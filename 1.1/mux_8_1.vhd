library ieee;
use ieee.std_logic_1164.all;

entity mux_8_1 is
    port (
        input: in STD_LOGIC_VECTOR(7 downto 0);
        selection: in STD_LOGIC_VECTOR(2 downto 0);
        y1: out STD_LOGIC
    );
end entity;

architecture dataflow of mux_8_1 is

begin
    y1 <=  input(0) when  selection = "000" else
                 input(1) when  selection = "001" else
                 input(2) when  selection = "010" else
                 input(3) when  selection = "011" else
                 input(4) when  selection = "100" else
                 input(5) when  selection = "101" else
                 input(6) when  selection = "110" else
                 input(7) when  selection = "111" else
                 '-';

end architecture;