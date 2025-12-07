----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2025 16:08:55
-- Design Name: 
-- Module Name: shift_reg - Behavioral
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

-- questo shift register all'inizio contiene una stringa di 8 zeri e
-- al termine della moltiplicazione conterrà il risultato
entity shift_reg is
 Port (
 clk : in std_logic;
 rst : in std_logic;
 load : in std_logic;
 shift : in std_logic;
 pararell_in : in std_logic_vector(16 downto 0);
 serial_in : in std_logic;
 pararell_out : out std_logic_vector(16 downto 0)
 );
end shift_reg;

architecture Behavioral of shift_reg is

    signal temp : std_logic_vector(16 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                temp <= (Others => '0');
            else
                if load = '1' then
                    temp <= pararell_in;
                elsif shift = '1' then
                    temp(15 downto 0) <= temp(16 downto 1);
                    temp(16) <= serial_in;
                end if;
            end if;
        end if;
    end process;
    
    pararell_out <= temp;     
                    
end Behavioral;
