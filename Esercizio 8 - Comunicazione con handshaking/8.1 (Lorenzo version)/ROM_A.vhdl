-- QUESTO FILE È INUTILE, BASTA RIUSARE IL FILE ROM.VHD DEL 2.1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_A is
    port (
        ADDRESS: in STD_LOGIC_VECTOR(3 downto 0);
        CONTENT: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture rtl of ROM_A is

    type MEMORY_16_8 is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
    
    -- inizializziamo la rom con valori qualunque
    constant ROM_16_8: MEMORY_16_8  := (
        X"00", X"01", X"02", X"03",
        X"04", X"05", X"06", X"07",
        X"08", X"09", X"0A", X"0B",
        X"0C", X"0D", X"0E", X"0F"
    );
    
    begin
        CONTENT <= ROM_16_8(to_integer(unsigned(ADDRESS)));

end architecture;
