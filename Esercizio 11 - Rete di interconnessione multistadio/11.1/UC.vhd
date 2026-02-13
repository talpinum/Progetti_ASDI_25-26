library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UC is
    Port ( 
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        
        -- INPUT 1: Richieste di trasmissione (1 bit per nodo)
        req_vector : in  STD_LOGIC_VECTOR(7 downto 0);
        
        -- INPUT 2: Destinazioni richiest (3 bit per nodo * 8 nodi = 24 bit)
        -- Ordine: [Dest7]...[Dest1][Dest0]
        dest_flat_in : in  STD_LOGIC_VECTOR(23 downto 0);
        
        -- OUTPUT verso Datapath
        ctrl_src_addr : out STD_LOGIC_VECTOR(2 downto 0);
        ctrl_dst_addr : out STD_LOGIC_VECTOR(2 downto 0);
        valid_out : out STD_LOGIC
    );
end UC;

architecture Behavioral of UC is
    
    -- Array per organizzare le destinazioni in modo indicizzabile
    type dest_array_type is array (0 to 7) of std_logic_vector(2 downto 0);
    signal dest_array  : dest_array_type;

    -- Registro che memorizza la posizione corrente del token di priorità
    signal priority_token : integer range 0 to 7;

begin

    --  SPACCHETTAMENTO CONCORRENTE (Come nel Datapath)
    -- Trasforma il vettore 24 bit in un array accessibile tramite indice
    gen_dest_array: for i in 0 to 7 generate
        dest_array(i) <= dest_flat_in((i*3)+2 downto i*3);
    end generate;

    --PROCESSO DI ARBITRAGGIO ROUND-ROBIN
    process(clk, rst)
        variable req_ext : unsigned(15 downto 0);
        variable found : boolean;
        variable selected_idx : integer range 0 to 7;
        variable calc_idx : integer;
    begin
        if rst = '1' then
            priority_token <= 0;
            ctrl_src_addr <= (others => '0');
            ctrl_dst_addr <= (others => '0');
            valid_out <= '0';
        elsif rising_edge(clk) then
            
            -- Duplica il vettore richieste per facilitare la scansione circolare
            req_ext := unsigned(std_logic_vector'(req_vector & req_vector));
            
            found := false;
            selected_idx := 0; 
            valid_out <= '0'; -- se nessuno trasmette

            -- Scansione della finestra di 8 bit a partire dal token (puntatore corrente)
            for i in 0 to 7 loop
                if not found then
                    -- Controlliamo il bit (token + i)
                    if req_ext(priority_token + i) = '1' then
                        
                        -- Calcolo dell'indice reale del vincitore (modulo 8 semplificato)
                        calc_idx := priority_token + i;
                        if calc_idx >= 8 then
                            selected_idx := calc_idx - 8;
                        else
                            selected_idx := calc_idx;
                        end if;
                        
                        found := true;
                    end if;
                end if;
            end loop;

            -- Se abbiamo trovato un vincitore, aggiorniamo le uscite e il token
            if found then
                -- Indica quale nodo trasmette (Sorgente)
                ctrl_src_addr <= std_logic_vector(to_unsigned(selected_idx, 3));
                
                -- Comunica alla rete DOVE andare (pescando dall'array creato sopra)
                ctrl_dst_addr <= dest_array(selected_idx);
                
                valid_out <= '1';

                -- Aggiorna Priorità: il token passa al successivo del vincitore
                if selected_idx = 7 then
                    priority_token <= 0;
                else
                    priority_token <= selected_idx + 1;
                end if;
            
            else
                -- Se nessuno ha richiesto, il token resta dov'è (o ruota, a scelta)
                valid_out <= '0';
            end if;
            
        end if;
    end process;

end Behavioral;
