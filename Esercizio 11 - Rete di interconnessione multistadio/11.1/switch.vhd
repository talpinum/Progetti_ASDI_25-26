----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2026 16:30:06
-- Design Name: 
-- Module Name: switch - structural
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

entity switch is
  Port (
    src : in std_logic; -- Seleziona input (Routing basato su Sorgente)
    dest : in std_logic; -- Seleziona output (Routing basato su Destinazione)
    x1 : in std_logic_vector(3 downto 0);
    x2 : in std_logic_vector(3 downto 0);
    Y1 : out std_logic_vector(3 downto 0);
    Y2 : out std_logic_vector(3 downto 0)
  );
end switch;

architecture structural of switch is
    
    component mux2_1 is
    port(
        a0 : in std_logic_vector(3 downto 0);
        a1 : in std_logic_vector(3 downto 0);
        s : in std_logic;
        y : out std_logic_vector(3 downto 0)    
    );
    end component;

    component demux1_2 is
    port(
        d : in std_logic_vector(3 downto 0);
        s : in std_logic;
        y1 : out std_logic_vector(3 downto 0);
        y2 : out std_logic_vector(3 downto 0) 
    );
    end component;
    
    --segnale che collega output del MUX con INPUT del DEMUX
    signal temp : std_logic_vector(3 downto 0);
begin

    mux2to1 : mux2_1
    port map(
        a0 => x1,
        a1 => x2,
        s => src,
        y => temp
    );
    
    demux1to2 : demux1_2
    port map(
        d => temp,
        s => dest,
        y1 => Y1,
        y2 => Y2
    );

end structural;
