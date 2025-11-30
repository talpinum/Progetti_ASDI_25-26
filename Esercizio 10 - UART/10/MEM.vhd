----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 16:13:43
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
  Port (
  clk : in std_logic;
  wrt : in std_logic;
  addr : in std_logic_vector(3 downto 0);
  d_in : in std_logic_vector(3 downto 0);
  d_out : out std_logic_vector(3 downto 0)
  );
end MEM;

architecture Behavioral of MEM is

    type RAM_t is array (0 to 15) of std_logic_vector(3 downto 0);
    signal ram : RAM_t := (others => (others =>'0'));
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if wrt = '1' then
                ram(TO_INTEGER(unsigned(addr))) <= d_in;
            end if;
        end if;
    end process;
    
    d_out <= ram(TO_INTEGER(unsigned(addr)));
        


end Behavioral;
