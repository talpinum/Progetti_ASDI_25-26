----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2025 17:40:41
-- Design Name: 
-- Module Name: Comparatore - Behavioral
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

-- I COMMENTI E' PER MOSTRARE ANCHE COME SI POTREBBE FARE IN MANIERA SINCRONA MA PENSO SIA UNA PUTTANATA FARLO
LEGGETE QUESTA COSA QUA SOPRA TANTO SO CHE SE NON VI COMMENTO CIO' ESCE UN BELL'ERRORE SUL VOSTRO VIVADO
entity Comparatore is
  Port (
    a : in std_logic_vector(7 downto 0);
    x : in std_logic_vector(7 downto 0);
    y : out std_logic
    -- clk
    -- rst
  );
end Comparatore;

architecture Behavioral of Comparatore is
    --  signal eq_reg : std_logic := '0'
begin
    y <= '1' when a = x else '0';
    
  
  --process(clk, rst)
   -- begin
    --    if rst = '1' then
     --       eq_reg <= '0';
   --     elsif rising_edge(clk) then
  --          if a = x then
  --              eq_reg <= '1';
  --          else
 --               eq_reg <= '0';
 --           end if;
 --       end if;
--    end process;

--    eq <= eq_reg;

end Behavioral;
