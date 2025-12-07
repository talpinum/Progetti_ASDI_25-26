----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2025 16:08:55
-- Design Name: 
-- Module Name: registro8 - Behavioral
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

entity registro8 is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  load : in std_logic;
  A : in std_logic_vector(7 downto 0);
  B : out std_logic_vector(7 downto 0)
  );
end registro8;

architecture Behavioral of registro8 is

    signal temp_b : std_logic_vector(7 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                temp_b <= (others => '0');
            else
                if load = '1' then
                    temp_b <= A;
                end if;
            end if;
        end if;
    end process;
    
    B <= temp_b;      

end Behavioral;
