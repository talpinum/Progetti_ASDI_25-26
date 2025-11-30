----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 16:13:43
-- Design Name: 
-- Module Name: Divisore - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Divisore is
  Port (
  x : in std_logic_vector(7 downto 0);
  s : out std_logic_vector(3 downto 0);
  d : out std_logic_vector(3 downto 0)
  );
end Divisore;

architecture Behavioral of Divisore is

begin
    
    s <= x(3 downto 0);
    d <= x(7 downto 4);

end Behavioral;
