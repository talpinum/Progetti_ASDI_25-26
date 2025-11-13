----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2025 18:41:51
-- Design Name: 
-- Module Name: MOD24 - Behavioral
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
use work.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MOD24 is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (0 TO 4);
           set : in STD_LOGIC_VECTOR (0 TO 4);
           load : in STD_LOGIC;
           A : in STD_LOGIC;
           rst : in STD_LOGIC);
end MOD24;

architecture structural of MOD24 is
    component fft is 
        Port ( clk : in STD_LOGIC;
               count : out STD_LOGIC;
               RST : in STD_LOGIC;
               load : in STD_LOGIC;
               set : in STD_LOGIC;
               rst_count : in STD_LOGIC;
               A : in STD_LOGIC); -- E' il T del flip flop
        end component;
        
    signal counter : std_logic_vector(4 downto 0) := (others => '0');
    signal reset : std_logic := '0';
    signal rst_local : std_logic := '0';
    signal A0, A1, A2, A3, A4 : std_logic := '0';     
            
begin
    -- 23 in binario 10111
    reset <= counter(4) AND NOT counter(3) AND counter(2) AND counter(1) AND counter(0);
    rst_local <= reset AND A;
    A1 <= A AND counter(0);
    A2 <= A AND counter(0) AND counter(1);
    A3 <= A AND counter(0) AND counter(1) AND counter(2);
    A4 <= A AND counter(0) AND counter(1) AND counter(2) AND counter(3);
    ff0 : fft
        port map(
            clk => clk,
            count => counter(0),
            RST => rst,
            load => load,
            set => set(4),
            rst_count => rst_local,
            A => A
        );
    ff1 : fft
        port map(
            clk => clk,
            count => counter(1),
            RST => rst,
            load => load,
            set => set(3),
            rst_count => rst_local,
            A => A1
        );
    ff2 : fft
        port map(
            clk => clk,
            count => counter(2),
            RST => rst,
            load => load,
            set => set(2),
            rst_count => rst_local,
            A => A2
        );
    ff3 : fft
        port map(
            clk => clk,
            count => counter(3),
            RST => rst,
            load => load,
            set => set(1),
            rst_count => rst_local,
            A => A3
        );
    ff4 : fft
        port map(
            clk => clk,
            count => counter(4),
            RST => rst,
            load => load,
            set => set(0),
            rst_count => rst_local,
            A => A4
        );
        
     count <= counter;        
end structural;
