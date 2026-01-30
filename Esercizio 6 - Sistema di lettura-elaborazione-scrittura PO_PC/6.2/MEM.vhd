----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2025 16:33:01
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
  generic (
  N : integer := 16;
  ADDR_WIDTH : integer := 4
  );
  
  Port (
    clk: in std_logic;
    rst : in std_logic; -- lo uso per azzerare la memoria
    write : in std_logic; -- write sincrono
    addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    d_in : in std_logic_vector(7 downto 0);
    d_out : out std_logic_vector(7 downto 0)  
      );
end MEM;

architecture Behavioral of MEM is

      type ram_type is array (0 to N-1) of std_logic_vector(7 downto 0);
      signal ram : ram_type := (others => (others => '0'));  
  --    signal address_temp : std_logic_vector(ADDR_WIDTH-1 downto 0);
      signal dout_reg : std_logic_vector(7 downto 0); --:= (others => '0');
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
               ram <= (others => (others => '0'));
              dout_reg <= (others => '0');
            else
                if write = '1' then
                    ram(to_integer(unsigned(addr))) <= d_in;
                --    address_temp <= addr;
                end if;
             -- read sincrono: aggiorno dout_reg con il contenuto dell'indirizzo corrente
                dout_reg <= ram(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;
    
    d_out <= dout_reg;           

end Behavioral;
