library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity mux_2_1 is
    port (
        a0: in STD_LOGIC;
        a1: in STD_LOGIC;
        c: in STD_LOGIC;
        y0: out STD_LOGIC
    );
end entity;

architecture dataflow of mux_2_1 is
    begin
        y0 <= a0 when c  = '0' else
                    a1 when c = '1' else
                    '-';
end architecture;