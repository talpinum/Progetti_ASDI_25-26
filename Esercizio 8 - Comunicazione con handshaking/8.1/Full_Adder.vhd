----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2025 15:51:17
-- Design Name: 
-- Module Name: Full_Adder - Behavioral
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

entity Full_Adder is
  Port (
  a : in std_logic;
  b : in std_logic;
  c_in : in std_logic;
  s : out std_logic;
  c_out : out std_logic
  );
end Full_Adder;

architecture Behavioral of Full_Adder is

begin

    s <= ((a XOR b) XOR c_in);
    c_out <= ((a AND b) OR (c_in AND (a XOR b)));


end Behavioral;
