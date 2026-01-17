----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2026 16:11:55
-- Design Name: 
-- Module Name: converti_tempo - Behavioral
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

entity contatore is
  generic (
    LEN_ADD : positive := 2  -- 2^4 = 16 locazioni
  );
  port (
    clk : in  std_logic;
    reset : in  std_logic;
    en_count : in  std_logic;
   -- END_COUNT : out std_logic;
    y : out std_logic_vector(LEN_ADD-1 downto 0)
  );
end contatore;

architecture Behavioral of contatore is

    signal Y_temp : std_logic_vector(LEN_ADD-1 downto 0) := (others => '0');

begin


  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        Y_temp <= (others => '0');

      elsif en_count = '1' then
            Y_temp <= STD_LOGIC_VECTOR(unsigned(Y_temp) + 1);
        end if;
      end if;
  end process;

  y <= Y_temp;
 -- END_COUNT <= '1' when (to_integer(unsigned(Y_temp)) = 2**N) else '0';
  
end Behavioral;
