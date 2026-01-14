----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2026 18:42:11
-- Design Name: 
-- Module Name: display - Behavioral
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

entity display is
 Port (
 clk : in std_logic;
 rst : in std_logic;
 bt1 : in std_logic;
 bt2 : in std_logic;
 SW : in std_logic_vector(15 downto 0);
 LED : out std_logic_vector(7 downto 0)
 );
end display;

architecture Structural of display is

    signal x32 : std_logic_vector(31 downto 0);
    signal s : std_logic_vector(7 downto 0);
    signal y : std_logic_vector(7 downto 0);
    
    component UC
    Port (
      clk : in std_logic;
      rst : in std_logic;
      firstbutton : in std_logic;
      secondbutton : in std_logic;
      switch : in std_logic_vector(15 downto 0);
      x_out : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component rete_di_interconnessione
    port (
      x      : in  std_logic_vector(31 downto 0);
      s      : in  std_logic_vector(7 downto 0);
      output : out std_logic_vector(7 downto 0)
    );
  end component;

begin

    CU : UC
    port map (
      clk          => clk,
      rst          => rst,
      firstbutton  => bt1,
      secondbutton => bt2,
      switch       => SW,
      x_out        => x32
    );

  -- selezione presa direttamente dagli switch
  s <= SW(7 downto 0);

  -- rete di interconnessione
  NET : rete_di_interconnessione
    port map (
      x      => x32,
      s      => s,
      output => y
    );

  -- LED
  LED <= not y;


end Structural;
