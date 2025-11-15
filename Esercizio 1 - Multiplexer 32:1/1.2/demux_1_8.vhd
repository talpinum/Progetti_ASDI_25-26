library ieee;
use ieee.std_logic_1164.all;

entity demux_1_8 is
    port (
        input: in STD_LOGIC;
        selection_demux: in STD_LOGIC_VECTOR(2 downto 0);
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture dataflow of demux_1_8 is

begin
    output <=  (0 => input, others => '0') when  selection_demux = "000" else
                          (1 => input, others => '0') when  selection_demux = "001" else
                          (2 => input, others => '0') when  selection_demux = "010" else
                          (3 => input, others => '0') when  selection_demux = "011" else
                          (4 => input, others => '0') when  selection_demux = "100" else
                          (5 => input, others => '0') when  selection_demux = "101" else
                          (6 => input, others => '0') when  selection_demux = "110" else
                          (7 => input, others => '0') when  selection_demux = "111" else
                          (others => 'U' );
                          
end architecture;