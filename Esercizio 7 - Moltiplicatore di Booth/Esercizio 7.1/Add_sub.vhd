----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2025 16:08:55
-- Design Name: 
-- Module Name: Add_sub - Behavioral
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

entity Add_sub is
  Port (
  x : in std_logic_vector(7 downto 0);
  y : in std_logic_vector(7 downto 0);
  c_in : in std_logic;
  c_out : out std_logic;
  z : out std_logic_vector(7 downto 0)
  );
end Add_sub;

architecture Structural of Add_sub is

component RCA is
  Port (
      x : in std_logic_vector(7 downto 0);
      y : in std_logic_vector(7 downto 0);
      c_in : in std_logic;
      c_out : out std_logic;
      z : out std_logic_vector(7 downto 0)
  );
end component;

    signal complementoy : std_logic_vector(7 downto 0);

begin

    complemento_y : for i in 0 to 7 generate
        complementoy(i) <= Y(i) XOR c_in;
    end generate;
    
    RA : RCA 
    port map(
        x => x,
        y => complementoy,
        c_in => c_in,
        c_out => c_out,
        z => z
    );
end Structural;
