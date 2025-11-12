----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2025 09:25:02
-- Design Name: 
-- Module Name: Flip_Flop - Behavioral
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

entity Flip_Flop is
    Port ( D : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Q : out STD_LOGIC);
end Flip_Flop;

architecture Behavioral of Flip_Flop is

begin
    ffrs : process (CLK)
        begin
            if rising_edge(CLK) then
                if (RST = '0') then
                    Q <= '0';
                else
                    Q <= D;
                end if;
            end if;
        end process;
            
end Behavioral;
