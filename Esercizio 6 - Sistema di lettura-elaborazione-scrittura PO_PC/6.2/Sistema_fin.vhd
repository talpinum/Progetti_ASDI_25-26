----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.01.2026 23:29:30
-- Design Name: 
-- Module Name: Sistema_fin - Behavioral
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

entity Sistema_fin is
 Port (
    clk: in std_logic;
    rst_db: in std_logic;
    start: in std_logic;
    read_ext: in std_logic;
    rst_ext: in std_logic;
    uscite: out std_logic_vector(7 downto 0)
    );
end Sistema_fin;

architecture structural of Sistema_fin is

    component ButtonDebouncer
generic (
CLK_period: integer := 10; -- periodo del clock (della board) in nanosecondi
btn_noise_time: integer := 10000000 -- durata stimata dell'oscillazione del bottone in nanosecondi
-- il valore di default ï¿½ 10 millisecondi
);
Port ( RST : in STD_LOGIC;
CLK : in STD_LOGIC;
BTN : in STD_LOGIC;
CLEARED_BTN : out STD_LOGIC);
end component;

component Sistema
    Port (
    clk_sis : in std_logic;
    start_sis : in std_logic;
    RST_sis : in std_logic;
    read_ext: in std_logic;
    Y : out std_logic_vector(7 downto 0)
    );
end component;


signal read_ext_cleaned: std_logic;
signal rst_ext_cleaned: std_logic;

begin
bd_read: ButtonDebouncer PORT MAP(
RST => rst_db,
CLK => clk,
BTN => read_ext,
CLEARED_BTN => read_ext_cleaned);

bd_rst: ButtonDebouncer PORT MAP(
RST => rst_db,
CLK => clk,
BTN => rst_ext,
CLEARED_BTN => rst_ext_cleaned);

sis: sistema PORT MAP(
clk_sis => clk,
RST_sis => rst_ext_cleaned,
start_sis => start,
read_ext => read_ext_cleaned,
Y => uscite);


end structural;
