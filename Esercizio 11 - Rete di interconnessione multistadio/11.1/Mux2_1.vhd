
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux2_1 is
  Port (
    a0 : in std_logic_vector(3 downto 0);
    a1 : in std_logic_vector(3 downto 0);
    s : in std_logic;
    y : out std_logic_vector(3 downto 0)
  );
end mux2_1;

architecture dataflow of mux2_1 is

begin

    y <= a0 when s = '0' else
    a1 when s = '1' else 
    "--";

end dataflow;
