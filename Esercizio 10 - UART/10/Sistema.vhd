----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2025 12:01:12
-- Design Name: 
-- Module Name: Sistema - Behavioral
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
entity Sistema is
  Port (
    clk   : in std_logic;
    rst   : in std_logic;
    start : in std_logic;
    done  : out std_logic;
    last  : out std_logic;
    uscita_sistema : out std_logic;
    RDA   : out std_logic
  );
end Sistema;

architecture Structural of Sistema is

component B is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  RXD_in : in std_logic;
  last : out std_logic;
  uscita : out std_logic;
  RDA : out std_logic
  );
end component;

component A is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  start : in std_logic;
  txd : out std_logic;
  done : out std_logic
  );
end component;

  signal txd_signal : std_logic;
  signal rxd_signal : std_logic;  -- per chiarezza, sarà collegato a txd_signal

begin

  Trasmettitore: A
    port map (
      clk => clk,
      rst => rst,
      start => start,
      txd => txd_signal,   -- uscita seriale nodo A
      done => done
    );

  Ricevitore: B
    port map (
      clk => clk,
      rst => rst,
      RXD_in => txd_signal,  -- collegamento seriale da A a B
      last => last,
      uscita => uscita_sistema,
      RDA => RDA
    );

end Structural;
