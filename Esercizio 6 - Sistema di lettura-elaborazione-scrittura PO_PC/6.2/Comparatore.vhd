----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2025 17:40:41
-- Design Name: 
-- Module Name: Comparatore - Behavioral
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

entity Comparatore is
  generic (
    X : std_logic_vector(7 downto 0) := "00000011"
  );
  Port (
    a : in std_logic_vector(7 downto 0);
    --x : in std_logic_vector(7 downto 0);
    o : out std_logic
  );
end Comparatore;

architecture Behavioral of Comparatore is

   -- constant X : std_logic_vector(7 downto 0) := "00000011";
    
begin

    o <= '1' when a = X else '0';

end Behavioral;
