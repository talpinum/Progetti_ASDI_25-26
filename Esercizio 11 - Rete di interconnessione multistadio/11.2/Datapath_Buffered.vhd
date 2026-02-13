library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Datapath_Buffered is
    generic ( 
        WIDTH : integer := 7; -- 4 payload + 3 dest
        DEPTH : integer := 4 
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        
        -- INTERFACCIA INGRESSO (Dai Nodi Esterni)
        node_in : in  std_logic_vector((8*WIDTH)-1 downto 0); -- Vettore piatto
        wr_en_in : in  std_logic_vector(7 downto 0);           -- Valid in ingresso
        full_out : out std_logic_vector(7 downto 0);           -- Backpressure verso i nodi
        
        -- INTERFACCIA USCITA (Verso Destinazione)
        node_out : out std_logic_vector((8*WIDTH)-1 downto 0);
        valid_out : out std_logic_vector(7 downto 0);
        full_in_dest : in  std_logic_vector(7 downto 0)        -- Se le destinazioni finali sono piene
    );
end Datapath_Buffered;

architecture Structural of Datapath_Buffered is

    -- Componente Switch Bufferizzato
    component BUFFERED_SWITCH is
        Generic ( WIDTH : integer; DEPTH : integer );
        Port (
            clk, rst : in  std_logic;
            route_bit_idx : in  integer range 0 to 2;
            
            -- IN 0
            din0  : in  std_logic_vector(WIDTH-1 downto 0);
            wr_en0 : in  std_logic;
            full0  : out std_logic;
          
            -- IN 1
            din1 : in  std_logic_vector(WIDTH-1 downto 0);
            wr_en1 : in  std_logic;
            full1 : out std_logic;
            
            -- OUT 0
            dout0  : out std_logic_vector(WIDTH-1 downto 0);
            valid_out0 : out std_logic;
            next_full0 : in  std_logic;
            -- OUT 1
            dout1 : out std_logic_vector(WIDTH-1 downto 0);
            valid_out1 : out std_logic;
            next_full1 : in  std_logic
        );
    end component;

    -- Tipi Array per i collegamenti
    type bus_array is array (0 to 7) of std_logic_vector(WIDTH-1 downto 0);
    
    -- Segnali Input/Output "spacchettati"
    signal in_data_arr : bus_array;
    signal out_data_arr : bus_array;

    -- Segnali tra Stadio 1 e Stadio 2
    signal s1_data : bus_array; -- Dati usciti da S1
    signal s1_valid : std_logic_vector(7 downto 0); -- Valid usciti da S1
    signal s1_full  : std_logic_vector(7 downto 0); -- Full generati da S2 (backpressure)

    -- Segnali tra Stadio 2 e Stadio 3
    signal s2_data : bus_array;
    signal s2_valid : std_logic_vector(7 downto 0);
    signal s2_full : std_logic_vector(7 downto 0);

    -- Segnali Uscita Stadio 3 (prima dell'output finale)
    signal s3_data : bus_array;
    signal s3_valid : std_logic_vector(7 downto 0);

begin

    -- Array di 8 locazioni (tanti quanti i nodi) da 7 bit (tanti quanti i bit dei pacchetti (3 DST + 4 DATA) per nodo)
    gen_in_array: for i in 0 to 7 generate
        in_data_arr(i) <= node_in((i*WIDTH)+(WIDTH-1) downto i*WIDTH);
    end generate;

    -- ================= STADIO 1 =================
    -- Ingressi diretti (0,4), (1,5)... 
    -- Routing Bit: 2 (MSB)
    gen_stage1: for i in 0 to 3 generate
        sw_s1: BUFFERED_SWITCH 
        generic map (WIDTH, DEPTH)
        port map (
            clk => clk,
            rst => rst,
            route_bit_idx => 2, -- Guarda MSB destinazione

            -- INGRESSI (Dall'esterno)
            din0 => in_data_arr(i),
            wr_en0 => wr_en_in(i),
            full0 => full_out(i),      -- Backpressure verso esterno
            
            din1 => in_data_arr(i+4),
            wr_en1 => wr_en_in(i+4),
            full1 => full_out(i+4),    -- Backpressure verso esterno

            -- USCITE (Verso Stadio 2)
            dout0 => s1_data(i*2),
            valid_out0 => s1_valid(i*2),
            next_full0 => s1_full(i*2),     -- Backpressure da Stadio 2
            
            dout1  => s1_data(i*2+1),
            valid_out1 => s1_valid(i*2+1),
            next_full1 => s1_full(i*2+1)    -- Backpressure da Stadio 2
        );
    end generate;

    -- ================= STADIO 2 =================
    -- Perfect Shuffle connection tra S1 e S2
    -- Pattern Shuffle: 0->0, 4->1, 1->2, 5->3, 2->4, 6->5, 3->6, 7->7
    -- Routing Bit: 1 (Centrale)
    
    -- Nota: Qui dobbiamo mappare manualmente le connessioni shuffle
    -- Input SW0: Linea 0 e Linea 4 dello stadio precedente
    -- Input SW1: Linea 1 e Linea 5
    -- Input SW2: Linea 2 e Linea 6
    -- Input SW3: Linea 3 e Linea 7
    
    gen_stage2: for i in 0 to 3 generate
        sw_s2: BUFFERED_SWITCH 
        generic map (WIDTH, DEPTH)
        port map (
            clk => clk,
            rst => rst,
            route_bit_idx => 1,

            -- INGRESSI (Shuffle da S1)
            din0 => s1_data(i),       -- Prende 0, 1, 2, 3
            wr_en0 => s1_valid(i),
            full0 => s1_full(i),       -- Manda full indietro a 0, 1, 2, 3
            
            din1 => s1_data(i+4),     -- Prende 4, 5, 6, 7
            wr_en1 => s1_valid(i+4),
            full1 => s1_full(i+4),     -- Manda full indietro a 4, 5, 6, 7

            -- USCITE (Verso Stadio 3)
            dout0 => s2_data(i*2),
            valid_out0 => s2_valid(i*2),
            next_full0 => s2_full(i*2),
            
            dout1 => s2_data(i*2+1),
            valid_out1 => s2_valid(i*2+1),
            next_full1 => s2_full(i*2+1)
        );
    end generate;

    -- ================= STADIO 3 =================
    -- Perfect Shuffle connection tra S2 e S3
    -- Routing Bit: 0 (LSB)
    
    gen_stage3: for i in 0 to 3 generate
        sw_s3: BUFFERED_SWITCH 
        generic map (WIDTH, DEPTH)
        port map (
            clk => clk, 
            rst => rst,
            route_bit_idx => 0,

            -- INGRESSI (Shuffle da S2)
            din0 => s2_data(i),
            wr_en0 => s2_valid(i),
            full0 => s2_full(i),
            
            din1 => s2_data(i+4),
            wr_en1 => s2_valid(i+4),
            full1 => s2_full(i+4),

            -- USCITE (Verso Mondo Esterno)
            dout0  => s3_data(i*2),
            valid_out0 => s3_valid(i*2),
            next_full0 => full_in_dest(i*2),   -- Backpressure finale
            
            dout1 => s3_data(i*2+1),
            valid_out1 => s3_valid(i*2+1),
            next_full1 => full_in_dest(i*2+1)  -- Backpressure finale
        );
    end generate;

    -- Impacchettamento Output (Array to Flattened vector)
    gen_out_vector: for i in 0 to 7 generate
        node_out((i*WIDTH)+(WIDTH-1) downto i*WIDTH) <= s3_data(i);
        valid_out(i) <= s3_valid(i);
    end generate;

end Structural;
