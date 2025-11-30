----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 16:13:43
-- Design Name: 
-- Module Name: ROM - Behavioral
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

entity ROM is
  Port (
    address : in std_logic_vector(3 downto 0);
    content : out std_logic_vector(7 downto 0)
  );
end ROM;

architecture Behavioral of ROM is

    type MEMORY16_8 is array(0 to 15) of std_logic_vector(7 downto 0);
    -- inizializziamo la ROM con valori qualunque
    constant ROM : MEMORY16_8 := (
        X"00", X"01", X"02", X"03",
        X"04", X"05", X"06", X"07",
        X"08", X"09", X"0A", X"0B",
        X"0C", X"0D", X"0E", X"0F"
    );
    
begin

    content <= ROM(TO_INTEGER(unsigned(address)));

end Behavioral;
