----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2025 16:08:55
-- Design Name: 
-- Module Name: cont_mod8 - Behavioral
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

entity cont_mod8 is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  A : in std_logic;
  count : out std_logic_vector(2 downto 0)
  );
end cont_mod8;

architecture Behavioral of cont_mod8 is

    signal c : unsigned(2 downto 0) := (Others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                c <= (Others => '0');
            elsif A = '1' then
                    c <= c + 1;
            end if;    
        end if;    
    end process;
    
    count <= std_logic_vector(c);           
                
end Behavioral;
