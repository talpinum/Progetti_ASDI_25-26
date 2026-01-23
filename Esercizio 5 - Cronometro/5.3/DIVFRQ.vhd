----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2025 18:41:51
-- Design Name: 
-- Module Name: DIVFRQ - Behavioral
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

entity DIVFRQ is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC;
           rst : in STD_LOGIC);
end DIVFRQ;

architecture Behavioral of DIVFRQ is
       CONSTANT FREQ : integer := 100000000;
    -- Per la simulazione usa un valore basso, es. 10 o 50
    -- CONSTANT FREQ : integer := 10;
    SIGNAL TMP: integer:=0;
begin
    
    process(clk_in)
    begin
        IF(clk_in'event and clk_in  = '0') then
        
            IF (RST = '1') then
                
                clk_out <= '0';
                TMP <= 0;
                                    
            else
                
                --Dobbiamo contare fino a 1 milione ed abilitare AB_cont
                TMP <= TMP + 1;
                IF(TMP = FREQ -1) THEN
                    clk_out <= '1';
                    TMP <= 0;
                    ELSE
                    clk_out <= '0';
                    
                END IF;
               
                
            end if;
            
        end if;
    
    
    
    end process;
                  
end Behavioral;
