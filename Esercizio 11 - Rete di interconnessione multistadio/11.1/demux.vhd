----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2026 16:10:14
-- Design Name: 
-- Module Name: demux1_2 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demux1_2 is
  Port (
    d : in std_logic_vector(3 downto 0);
    s : in std_logic;
    y1 : out std_logic_vector(3 downto 0);
    y2 : out std_logic_vector(3 downto 0)
  );
end demux1_2;

architecture Dataflow of demux1_2 is

begin

    y1 <= d when s = '0' else (others => '0');
    y2 <= d when s = '1' else (others => '0');

end Dataflow;
