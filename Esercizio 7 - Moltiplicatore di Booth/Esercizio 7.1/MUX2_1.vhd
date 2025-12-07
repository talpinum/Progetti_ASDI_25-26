----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2025 16:08:55
-- Design Name: 
-- Module Name: MUX2_1 - Behavioral
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

entity MUX2_1 is
  generic(
    width : INTEGER := 8
  );
  Port (
  x0 : in std_logic_vector(width-1 downto 0);
  x1 : in std_logic_vector(width-1 downto 0);
  s : in std_logic;
  y : out std_logic_vector(width-1 downto 0)
  );
end MUX2_1;

architecture rtl of MUX2_1 is


begin

    y <= x0 when s='0' else
         x1 when s='1' else
         (others => '0');
end rtl;
