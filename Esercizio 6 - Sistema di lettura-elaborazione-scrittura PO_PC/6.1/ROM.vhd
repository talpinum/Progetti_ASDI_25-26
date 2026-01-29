library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM is
    generic(
        N : integer := 16; -- Le N locazioni
        ADDR_WIDTH : integer := 4 -- quanti bit servono per indirizzare N locazioni
    );
    
    port (
        clk : in std_logic;
        read : in std_logic;
        address: in STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        content: out STD_LOGIC_VECTOR(7 downto 0) -- valore letto, 8 bit
    );
end entity;

architecture behavioral of ROM is

    type MEMORY_16_8 is array (0 to N-1) of STD_LOGIC_VECTOR(7 downto 0);
    
    -- inizializziamo la rom con valori qualunque
    constant ROM : MEMORY_16_8  := ( -- Costante perché una ROM non cambia durante l'esecuzione
        X"00", X"01", X"02", X"03",
        X"04", X"05", X"06", X"07",
        X"08", X"09", X"0A", X"0B",
        X"0C", X"0D", X"0E", X"0F"
    );
    
    -- ROM sincrona quindi il valore letto non può uscire direttamente
    -- Segnale interno per memorizzare il dato da leggere
    signal dout_reg : std_logic_vector(7 downto 0) := (others => '0');
    
    begin
    -- processo di lettura sincrono
        process(clk)
            begin
                if rising_edge(clk) then
                    if read = '1' then
                    -- Posso mettere anche if ROM(to_integer(unsigned(address)) < N
                    -- Per controllare se l'indirizzo va fuori range
                    -- e gli faccio mettere 0 su dout_reg
                        dout_reg <= ROM(to_integer(unsigned(address)));
                        -- Ho letto quella locazione e trasformata in un intero
                    end if;
               end if;
        end process;
        -- Il dato in uscita cambia solo al Prossimo fronte di clock.
                    
        content <= dout_reg;

end behavioral;
