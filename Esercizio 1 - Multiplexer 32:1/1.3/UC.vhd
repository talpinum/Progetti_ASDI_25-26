----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2026 17:50:30
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  firstbutton : in std_logic;
  secondbutton : in std_logic;
  load_sel : in std_logic;
  switch : in std_logic_vector(15 downto 0);
  sel_out : out std_logic_vector(7 downto 0);
  x_out : out std_logic_vector(31 downto 0)
   );
end UC;

architecture Behavioral of UC is

    signal first_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal second_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal reg_sel : STD_LOGIC_VECTOR (7 downto 0) := ( others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                first_reg <= (others => '0');
                second_reg <= (others => '0');
                
            elsif firstbutton = '1' then
                first_reg <= switch;
                
            elsif secondbutton = '1' then
                second_reg <= switch;
                
            elsif load_sel = '1' then
                reg_sel <= switch(7 downto 0);
            end if;
        end if;
    end process;
    
    x_out <=  first_reg & second_reg;

end Behavioral;
