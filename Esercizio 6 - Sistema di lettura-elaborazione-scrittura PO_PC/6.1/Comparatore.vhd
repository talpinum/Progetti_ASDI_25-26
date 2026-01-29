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

-- LE COSE COMMENTATE SONO SE LO SI VUOLE FARE SINCRONO MA PER ME E' UNA PUTTANATA
LEGGETE SOPRA CHE LO SO CHE VI ESCE UN BELL'ERRORE SU VIVADO
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
 -- signal eq_reg : std_logic := '0';
begin
    y <= '1' when a = x else '0';

--process(clk, rst)
--    begin
--        if rst = '1' then
--            eq_reg <= '0';
--        elsif rising_edge(clk) then
--           if a = x then
--                eq_reg <= '1';
--            else
--                eq_reg <= '0';
--            end if;
--       end if;
--    end process;

--    y <= eq_reg;

end Behavioral;






  l--ibrary IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity Comparatore is
  --generic (
    --X_REF : std_logic_vector(7 downto 0) := "10101010"
  --);
  --port (
    --a : in  std_logic_vector(7 downto 0);
    --y : out std_logic
  --);
--end Comparatore;

--architecture Behavioral of Comparatore is
--begin
  --  y <= '1' when a = X_REF else '0';
--end Behavioral;





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
-- Description: Comparatore 8-bit con stringa X precaricata come COSTANTE interna.
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

entity Comparatore is
  Port (
    a : in  std_logic_vector(7 downto 0);
    y : out std_logic
  );
end Comparatore;

architecture Behavioral of Comparatore is
    -- Stringa X precaricata (modifica qui il valore desiderato)
    constant X_REF : std_logic_vector(7 downto 0) := "10101010";
begin
    -- Comparatore combinatorio
    y <= '1' when a = X_REF else '0';
end Behavioral;

