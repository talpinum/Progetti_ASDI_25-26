library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM is
   -- generic(
        --N : integer := 16; -- Le N locazioni
      --  ADDR_WIDTH : integer := 4
    --);
    
    port (
        clk : in std_logic;
       
        address: in STD_LOGIC_VECTOR(3 downto 0);
        content: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture behavioral of ROM is

    type MEMORY_16_8 is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
    
    -- inizializziamo la rom con valori qualunque
    constant ROM : MEMORY_16_8  := (
        X"00", X"01", X"02", X"03",
        X"04", X"05", X"06", X"07",
        X"08", X"09", X"0A", X"0B",
        X"0C", X"0D", X"0E", X"0F"
    );

    content <= ROM(to_integer(unsigned(address)));

end behavioral;
