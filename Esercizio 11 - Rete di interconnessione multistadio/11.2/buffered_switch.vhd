library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buffered_switch is
    Generic (
        WIDTH : integer := 7; -- 3 bit Dest + 4 bit Payload
        DEPTH : integer := 4  -- Capacità buffer richiesta
    );
    Port (
        clk : in  std_logic;
        rst : in  std_logic;
        
        -- Configurazione Routing
        -- 2 per stadio 1 (MSB), 1 per stadio 2, 0 per stadio 3 (LSB)
        route_bit_idx : in  integer range 0 to 2; 

        -- INPUT PORT 0
        din0 : in  std_logic_vector(WIDTH-1 downto 0);
        wr_en0 : in  std_logic; -- Valid in ingresso
        full : out std_logic; -- Backpressure verso stadio precedente
        
        -- INPUT PORT 1
        din1 : in  std_logic_vector(WIDTH-1 downto 0);
        wr_en1 : in  std_logic;
        full1 : out std_logic;

        -- OUTPUT PORT 0 (Uscita Alta)
        dout0 : out std_logic_vector(WIDTH-1 downto 0);
        valid_out0 : out std_logic; -- Write enable per stadio successivo
        next_full0 : in  std_logic; -- Backpressure dallo stadio successivo
        
        -- OUTPUT PORT 1 (Uscita Bassa)
        dout1 : out std_logic_vector(WIDTH-1 downto 0);
        valid_out1 : out std_logic;
        next_full1 : in  std_logic
    );
end buffered_switch;

architecture Behavioral of buffered_switch is

    -- Componente FIFO
    component FIFO_Buffer is
        Generic ( DEPTH : integer; WIDTH : integer );
        Port (
            clk, rst : in  std_logic;
            wr_en, rd_en : in  std_logic;
            din : in  std_logic_vector(WIDTH-1 downto 0);
            dout : out std_logic_vector(WIDTH-1 downto 0);
            full, empty : out std_logic
        );
    end component;

    -- Segnali interni dalle FIFO
    signal f0_dout, f1_dout : std_logic_vector(WIDTH-1 downto 0);
    signal f0_empty, f1_empty : std_logic;
    signal f0_rd, f1_rd : std_logic; -- Segnali di pop calcolati dalla logica

    -- Logica di Routing (dove vogliono andare?)
    signal req0_to_out0, req0_to_out1 : boolean;
    signal req1_to_out0, req1_to_out1 : boolean;

    -- Arbitraggio (0 = priorità a FIFO0, 1 = priorità a FIFO1)
    signal priority_token : std_logic := '0';

begin

    -- ISTANZA DEI BUFFER DI INGRESSO
    queue_0: FIFO_Buffer generic map (DEPTH, WIDTH)
    port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en0, 
        rd_en => f0_rd,
        din => din0,
        dout => f0_dout,
        full => full0,
        empty => f0_empty
    );

    queue_1: FIFO_Buffer generic map (DEPTH, WIDTH)
    port map (
        clk => clk, 
        rst => rst,
        wr_en => wr_en1,
        rd_en => f1_rd,
        din => din1,
        dout => f1_dout,
        full => full1,
        empty => f1_empty
    );

    -- LOGICA DI DECODIFICA (ROUTING LOOK-AHEAD)
    -- Guardiamo i pacchetti senza estrarli (FIFO output è asincrono sulla testa)
    process(f0_dout, f1_dout, f0_empty, f1_empty, route_bit_idx)
        variable dest_bit_0 : std_logic;
        variable dest_bit_1 : std_logic;
    begin
        -- Default: nessuno vuole andare da nessuna parte
        req0_to_out0 <= false; req0_to_out1 <= false;
        req1_to_out0 <= false; req1_to_out1 <= false;

        -- Analisi FIFO 0
        if f0_empty = '0' then
            -- Estraiamo il bit di routing (Offset 4 perché payload è 4 bit)
            dest_bit_0 := f0_dout(4 + route_bit_idx);
            if dest_bit_0 = '0' then 
              req0_to_out0 <= true; -- Vuole andare su (0)
            else                     
              req0_to_out1 <= true; -- Vuole andare giù (1)
            end if;
        end if;

        -- Analisi FIFO 1
        if f1_empty = '0' then
            dest_bit_1 := f1_dout(4 + route_bit_idx);
            if dest_bit_1 = '0' then
              req1_to_out0 <= true;
            else                    
              req1_to_out1 <= true;
            end if;
        end if;
    end process;

    -- ARBITRO E CROSSBAR
    -- Decide chi passa e genera i segnali di Read (pop) e Valid Out
    process(clk, reset)
    begin
        if reset = '1' then
            priority_token <= '0';
        elsif rising_edge(clk) then
            -- Cambia priorità solo se c'è stato un conflitto risolto
            -- (Logica semplificata: toggle ogni clock o su conflitto)
            -- Qui facciamo toggle su conflitto per equità stretta
            if (req0_to_out0 and req1_to_out0) or (req0_to_out1 and req1_to_out1) then
                priority_token <= not priority_token;
            end if;
        end if;
    end process;

    -- Logica Combinatoria Crossbar (Chi va dove ORA?)
    process(req0_to_out0, req0_to_out1, req1_to_out0, req1_to_out1, 
            next_full0, next_full1, priority_token, f0_dout, f1_dout)
    begin
        -- Reset defaults
        f0_rd <= '0'; f1_rd <= '0';
        valid_out0 <= '0'; valid_out1 <= '0';
        dout0 <= (others => '0'); dout1 <= (others => '0');

        -- === GESTIONE USCITA 0 (OUT0) ===
        -- Caso A: Conflitto (Entrambi vogliono OUT0)
        if req0_to_out0 and req1_to_out0 then
            if next_full0 = '0' then -- Se c'è spazio dopo
                if priority_token = '0' then
                    -- Vince FIFO 0
                    dout0 <= f0_dout; valid_out0 <= '1'; f0_rd <= '1';
                else
                    -- Vince FIFO 1
                    dout0 <= f1_dout; valid_out0 <= '1'; f1_rd <= '1';
                end if;
            end if;
        
        -- Caso B: Solo FIFO 0 vuole OUT0
        elsif req0_to_out0 then
            if next_full0 = '0' then
                dout0 <= f0_dout; valid_out0 <= '1'; f0_rd <= '1';
            end if;

        -- Caso C: Solo FIFO 1 vuole OUT0
        elsif req1_to_out0 then
            if next_full0 = '0' then
                dout0 <= f1_dout; valid_out0 <= '1'; f1_rd <= '1';
            end if;
        end if;


        -- === GESTIONE USCITA 1 (OUT1) ===
        -- Nota: f0_rd e f1_rd potrebbero essere già stati asseriti sopra?
        -- NO, perché un pacchetto non può volere OUT0 e OUT1 contemporaneamente.
        -- Quindi possiamo usare assegnazioni condizionali sicure.
        
        -- Caso A: Conflitto (Entrambi vogliono OUT1)
        if req0_to_out1 and req1_to_out1 then
            if next_full1 = '0' then
                if priority_token = '0' then -- Qui la priorità è la stessa o invertita? Usiamo la stessa logica
                     dout1 <= f0_dout; valid_out1 <= '1'; f0_rd <= '1';
                else
                     dout1 <= f1_dout; valid_out1 <= '1'; f1_rd <= '1';
                end if;
            end if;
        
        -- Caso B: Solo FIFO 0 vuole OUT1
        elsif req0_to_out1 then
            if next_full1 = '0' then
                dout1 <= f0_dout; valid_out1 <= '1'; f0_rd <= '1';
            end if;

        -- Caso C: Solo FIFO 1 vuole OUT1
        elsif req1_to_out1 then
            if next_full1 = '0' then
                dout1 <= f1_dout; valid_out1 <= '1'; f1_rd <= '1';
            end if;
        end if;

    end process;

end Behavioral;
