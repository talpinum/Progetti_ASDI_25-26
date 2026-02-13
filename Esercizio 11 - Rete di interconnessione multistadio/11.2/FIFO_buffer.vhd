library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_Buffer is
    Generic (
        DEPTH : integer := 4;
        WIDTH : integer := 7 
    );
    Port (
        clk : in  std_logic;
        rst : in  std_logic;
        wr_en : in  std_logic;
        rd_en : in  std_logic;
        din : in  std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0);
        full : out std_logic;
        empty : out std_logic
    );
end FIFO_Buffer;

architecture Behavioral of FIFO_Buffer is
    type memory_type is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
    signal memory : memory_type;
    
    signal head : integer range 0 to DEPTH-1 := 0;
    signal tail : integer range 0 to DEPTH-1 := 0;
    signal count : integer range 0 to DEPTH := 0;
    
    -- Segnali interni per leggerezza di lettura
    signal empty_internal : std_logic;
    signal full_internal  : std_logic;

begin

    -- ============================================================
    -- 1. LOOK-AHEAD OUTPUT (La correzione fondamentale)
    -- Il dato è sempre disponibile in uscita, anche senza rd_en.
    -- ============================================================
    dout <= memory(head);

    -- Assegnazione flag interni
    empty_internal <= '1' when count = 0 else '0';
    full_internal <= '1' when count = DEPTH else '0';
    
    -- Output dei flag
    empty <= empty_internal;
    full <= full_internal;

    process(clk, rst)
    begin
        if reset = '1' then
            head <= 0;
            tail <= 0;
            count <= 0;
        elsif rising_edge(clk) then
            
            -- SCRITTURA: Se abilitata e c'è spazio
            if wr_en = '1' and full_internal = '0' then
                memory(tail) <= din;
                if tail = DEPTH-1 then 
                    tail <= 0; 
                else 
                    tail <= tail + 1; 
                end if;
            end if;
            
            -- LETTURA: Se abilitata e c'è qualcosa da leggere
            -- Nota: questo sposta solo il puntatore, il dato è già uscito sopra
            if rd_en = '1' and empty_internal = '0' then
                if head = DEPTH-1 then 
                    head <= 0; 
                else 
                    head <= head + 1; 
                end if;
            end if;
            
            -- GESTIONE DEL CONTEGGIO (COUNT)
            -- Caso 1: Scrivo ma non leggo -> incremento
            if wr_en = '1' and rd_en = '0' and full_internal = '0' then
                count <= count + 1;
            -- Caso 2: Leggo ma non scrivo -> decremento
            elsif wr_en = '0' and rd_en = '1' and empty_internal = '0' then
                count <= count - 1;
            end if;
            -- Caso 3: Scrivo e Leggo contemporaneamente -> count resta uguale
            -- (Non serve codice, il valore viene mantenuto)
            
        end if;
    end process;

end Behavioral;
