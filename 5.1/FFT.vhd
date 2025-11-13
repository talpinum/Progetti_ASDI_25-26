----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2025 18:41:51
-- Design Name: 
-- Module Name: FFT - Behavioral
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

entity FFT is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC;
           RST : in STD_LOGIC;
           load : in STD_LOGIC;
           set : in STD_LOGIC;
           rst_count : in STD_LOGIC;
           A : in STD_LOGIC); -- è il mio ingresso T
end FFT;

architecture Behavioral of FFT is

    signal counter : std_logic := '0'; -- mi serve per memorizzare lo stato 
begin
    fft: process(clk)
    begin
        if falling_edge(clk) then
            if (rst = '1') then
                counter <= '0';
            else
                if (load ='1') then
                    counter <= set;
                else
                    if(rst_count = '1') then
                        counter <= '0';
                    else
                        if (A ='1') then
                            counter <= not counter;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    count <= counter;

end Behavioral;
