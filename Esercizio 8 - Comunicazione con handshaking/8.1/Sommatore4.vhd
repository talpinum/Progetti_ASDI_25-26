----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2025 15:30:35
-- Design Name: 
-- Module Name: Unita_Operativa_B - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sommatore4 is
  Port (
    Sx : in std_logic_vector(3 downto 0);
    Dx : in std_logic_vector(3 downto 0);
    Y : out std_logic_vector(4 downto 0)
  );
end Sommatore4;

architecture Behavioral of Sommatore4 is

begin
    
    Y <= std_logic_vector(unsigned(Sx) + unsigned(Dx));
    
end Behavioral;
