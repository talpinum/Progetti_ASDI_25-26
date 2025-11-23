----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2025 15:38:00
-- Design Name: 
-- Module Name: Contatore - Behavioral
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

entity Contatore is
  generic (
    N: integer := 16;
    addr_width : integer := 4
    );
    
  Port (
    clk: in std_logic;
    rst : in std_logic;
    A : in std_logic; -- proveniente dalla nostra U.C.
    value : out std_logic_vector (addr_width-1 downto 0);
    last : out std_logic -- varrà 1 quando il mio segnale di count varrà N-1
  );

end Contatore;



architecture Behavioral of Contatore is
    
        signal counter : unsigned(addr_width-1 downto 0) := (others => '0');
        
begin

    process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    counter <= (others => '0');
                elsif A ='1' then
                    if counter < to_unsigned(N-1, addr_width) then
                        counter <= counter + 1;
                    end if;
                end if;   
            end if;
    end process;
    
    value <= std_logic_vector(counter);
    last <= '1' when  to_unsigned(N-1, addr_width) else '0';
                


end Behavioral;
