----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2025 18:41:51
-- Design Name: 
-- Module Name: Cronometro - Behavioral
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

entity Cronometro is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start_stop : in STD_LOGIC;
           load_h : in STD_LOGIC;
           load_min : in STD_LOGIC;
           load_s : in STD_LOGIC;
           y_secondi : out STD_LOGIC_VECTOR (0 TO 5);
           y_minuti : out STD_LOGIC_VECTOR (0 TO 5);
           y_ore : out STD_LOGIC_VECTOR (0 TO 4);
           set_h : in STD_LOGIC_VECTOR (0 TO 4);
           set_min : in STD_LOGIC_VECTOR (0 TO 5);
           set_s : in STD_LOGIC_VECTOR (0 TO 5));
end Cronometro;

architecture structural of Cronometro is
    component MOD24 is
        Port ( clk : in STD_LOGIC;
               count : out STD_LOGIC_VECTOR (0 TO 4);
               set : in STD_LOGIC_VECTOR (0 TO 4);
               load : in STD_LOGIC;
               A : in STD_LOGIC;
               rst : in STD_LOGIC);
    end component;
    
    component MOD60 is
        Port ( clk : in STD_LOGIC;
               count : out STD_LOGIC_VECTOR (0 TO 5);
               set : in STD_LOGIC_VECTOR (0 TO 5);
               load : in STD_LOGIC;
               rst : in STD_LOGIC;
               A : in STD_LOGIC;
               A_next : out STD_LOGIC);
    end component;
    
    component DIVFRQ is
        Port ( clk_in : in STD_LOGIC;
               clk_out : out STD_LOGIC;
               rst : in STD_LOGIC);
    end component;
    
    signal A0, A1, A2 : std_logic := '0';
    signal new_clk : STD_LOGIC;
    signal A_min : STD_LOGIC := '0';
    signal A_h : STD_LOGIC := '0';
    
begin
    
    divisore : DIVFRQ
        port map(
            clk_in => clk,
            rst => rst,
            clk_out => new_clk
            );
    A0 <= start_stop and new_clk;
    
    contatore_secondi : MOD60
        port map(
            clk => clk,
            rst => rst,
            A => A0,
            load => load_s,
            set => set_s,
            count => y_secondi,
            A_next => A_min
        );
    
    A1 <= start_stop and new_clk and a_min;
 
     contatore_minuti : MOD60
        port map(
            clk => clk,
            rst => rst,
            A => A1,
            load => load_min,
            set => set_min,
            count => y_minuti,
            A_next => A_h
        );
    
    A2 <= start_stop and new_clk and A_min and A_h;

     contatore_ore : MOD24
        port map(
            clk => clk,
            rst => rst,
            A => A2,
            load => load_h,
            set => set_h,
            count => y_ore
        );

end structural;
