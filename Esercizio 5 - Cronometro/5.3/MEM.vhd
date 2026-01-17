----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.01.2026 00:05:56
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
  generic (
    LEN_ADD : positive := 4  -- 2^LEN_ADD locazioni
  );
  port (
    clk_mem : in  std_logic;
    wrt : in  std_logic; -- write enable
    read : in  std_logic; -- read enable (bottone)
    address : in  std_logic_vector(LEN_ADD-1 downto 0);
    inp_val : in  std_logic_vector(16 downto 0);
    out_val : out std_logic_vector(16 downto 0)
  );
end MEM;

architecture Behavioral of MEM is

  constant N : integer := 2**LEN_ADD;

  type ram_type is array (0 to N-1) of std_logic_vector(16 downto 0);
  signal ram : ram_type := (others => (others => '0'));
  signal address_temp : std_logic_vector(len_add-1 downto 0);

  signal out_reg : std_logic_vector(16 downto 0) := (others => '0');
  


begin

  process(clk_mem)
  begin
    if rising_edge(clk_mem) then
      if read = '1' then
        out_reg <= ram(to_integer(unsigned(address)));
      end if;
      if wrt = '1' then
        ram(to_integer(unsigned(address))) <= inp_val;
        address_temp <= address;
      end if;
      out_val <= ram(to_integer(unsigned(address_temp)));
    end if;
  end process;

  --out_val <= out_reg;

end Behavioral;
