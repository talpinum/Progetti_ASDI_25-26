----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2025 18:28:00
-- Design Name: 
-- Module Name: A - Behavioral
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

entity A is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  start : in std_logic;
  txd : out std_logic;
  done : out std_logic
  );
end A;

architecture Structural of A is

component UO_A is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  -- comandi dalla UC
  ROM_A : in std_logic;
  UART_WR : in std_logic;
  INCR_A : in std_logic;
  
  -- l'UART
  TBE : out std_logic;
  txd : out std_logic
  );
end component;

component UC_A is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  start : in std_logic;
  last : in std_logic;
  
  TBE : in std_logic; -- TBE della UART
  
  ROM_A : out std_logic; -- Abilitiamo la lettura ROM
  INCR_A: out std_logic; -- incremento indirizzo ROM
  UART_WR : out std_logic;
  DONE : out std_logic -- fine operazione
  );
end component;


    signal rom_a : std_logic;
    signal uart_wrt: std_logic;
    signal incr_a : std_logic;
    signal tbe_A : std_logic;

begin

    UC : UC_A
        port map(
            clk => clk,
            rst => rst,
            start => start,
            last => '0',     -- il last non è esposto
            TBE => tbe_A,
            ROM_A => rom_a,
            INCR_A => incr_a,
            UART_WR => uart_wrt,
            DONE => done
        );
        
    UO : UO_A
        port map(
            clk => clk,
            rst => rst,
            ROM_A => rom_a,
            UART_WR=> uart_wrt,
            INCR_A => incr_a,
            TBE => tbe_A,
            txd => txd
        );

end Structural;
