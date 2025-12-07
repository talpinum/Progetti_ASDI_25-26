----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2025 16:08:55
-- Design Name: 
-- Module Name: RCA - Behavioral
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

entity RCA is
  Port (
      x : in std_logic_vector(7 downto 0);
      y : in std_logic_vector(7 downto 0);
      c_in : in std_logic;
      c_out : out std_logic;
      z : out std_logic_vector(7 downto 0)
  );
end RCA;

architecture Structural of RCA is

component FA is
    port(
      a : in std_logic;
      b : in std_logic;
      c_in : in std_logic;
      c_out : out std_logic;
      s : out std_logic
    );
end component;

    signal c : std_logic_vector(8 downto 0);

begin
    
    c(0) <= c_in;
    
    gen_FA : for i in 0 to 7 generate
        FA_i : FA
            port map(
                a     => x(i),
                b     => y(i),
                c_in  => c(i),
                s     => z(i),
                c_out => c(i+1)
            );
    end generate;
    
    c_out <= c(8);
end Structural;
