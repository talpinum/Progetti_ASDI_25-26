----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2025 19:29:06
-- Design Name: 
-- Module Name: rete_di_interconnessione - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

entity rete_di_interconnessione is
    port (
        x: in STD_LOGIC_VECTOR(31 downto 0);
        s: in  STD_LOGIC_VECTOR(7 downto 0);
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture structural of rete_di_interconnessione is

    component mux32to1
        port (
        D : in STD_LOGIC_VECTOR(31 downto 0);
        S : in STD_LOGIC_VECTOR(4 downto 0);
        Y : out STD_LOGIC
    );
    end component;

    component demux1to8
        port (
        D : in STD_LOGIC;
        S : in STD_LOGIC_VECTOR(2 downto 0);
        Y : out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;

    signal u: STD_LOGIC := '0';
    
    signal selezione_mux : STD_LOGIC_VECTOR(4 downto 0);
    signal selezione_demux : STD_LOGIC_VECTOR(2 downto 0);
    
    begin
    
    selezione_mux <= s(4 downto 0);
    selezione_demux <= s(7 downto 5);
    
        mux: mux32to1
            port map (
                D => x,
                S => selezione_mux,
                Y => u
            );
        
        demux: demux1to8
            port map (
                D => u,
                S => selezione_demux,
                Y => output
            );

end architecture;
