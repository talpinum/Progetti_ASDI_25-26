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
    signal counter : unsigned(27 downto 0) := (others => '0');
    signal no_division : BOOLEAN := true;
    
    
    -- La funzione to_unsigned(99999999, 28) converte il numero decimale 99999999 in un vettore unsigned a 28 bit.
    -- questa costante rappresenta la soglia a cui il contatore arriva prima di fare una certa azione
    -- quanti cicli di clock deve contare
    -- Allora la possiamo usare come confronto nel processo    
    CONSTANT divider : unsigned(27 DOWNTO 0) := to_unsigned(9, 28);
begin
    
    process(clk_in, rst, no_division)
    begin
        if (no_division = true) then
            clk_out <= clk_in;
        else
            if(rst = '1') then
                clk_out <= '0';
                counter <= (others => '0');
            elsif rising_edge(clk_in) then
                if counter = divider then
                    counter <= (others => '0');
                    clk_out <= '1';
                else
                    counter <= counter + 1;
                    clk_out <= '0';
                end if;
            end if;
        end if;
    end process;
                  
end Behavioral;
