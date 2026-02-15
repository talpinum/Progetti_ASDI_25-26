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
 bt_sel : in std_logic;
 SW : in std_logic_vector(15 downto 0);
 LED : out std_logic_vector(7 downto 0)
 );
end display;

architecture Structural of display is

    signal x32 : std_logic_vector(31 downto 0);
    signal internal_s : std_logic_vector(7 downto 0);
    signal y : std_logic_vector(7 downto 0);
    signal btn_load1_clean , btn_load2_clean , btn_sel_clean : std_logic;
    
    
    component UC
    Port (
      clk : in std_logic;
      rst : in std_logic;
      firstbutton : in std_logic;
      secondbutton : in std_logic;
      load_sel : in std_logic;
      switch : in std_logic_vector(15 downto 0);
      sel_out : out std_logic_vector(7 downto 0);
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
  
  component ButtonDebouncer
    Generic(
        CLK_period : integer := 10;
        btn_noise_time : integer := 10000000
    );
    Port( RST : in STD_LOGIC;
          CLK : in STD_LOGIC;
          BTN : in STD_LOGIC;
          CLEARED_BTN : out STD_LOGIC);
   end component;

begin

    deb_1: ButtonDebouncer port map (
        RST => RST , CLK => CLK , BTN => bt1 , CLEARED_BTN => btn_load1_clean
    );
    deb_2: ButtonDebouncer port map (
        RST => RST , CLK => CLK , BTN => bt2 , CLEARED_BTN => btn_load2_clean
    );
    deb_3: ButtonDebouncer port map (
        RST => RST , CLK => CLK , BTN => bt_sel , CLEARED_BTN => btn_sel_clean
    );
    
    CU : UC
    port map (
      clk          => clk,
      rst          => rst,
      firstbutton  => btn_load1_clean,
      secondbutton => btn_load2_clean,
      load_sel => btn_sel_clean,
      switch       => SW,
      sel_out => internal_s,
      x_out        => x32
    );

  -- selezione presa direttamente dagli switch
  internal_s <= SW(7 downto 0);

  -- rete di interconnessione
  NET : rete_di_interconnessione
    port map (
      x      => x32,
      s      => internal_s,
      output => y
    );

  -- LED
  LED <= not y;


end Structural;
