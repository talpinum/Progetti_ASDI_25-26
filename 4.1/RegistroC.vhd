----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2025 09:25:02
-- Design Name: 
-- Module Name: RegistroC - Behavioral
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

entity RegistroC is
    Generic(
            N : INTEGER := 16
           );
    
    Port ( SI : in STD_LOGIC;
           SO : out STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR(1 DOWNTO 0)
           -- 00 shift a dx di 1
           -- 01 shift a dx di 2
           -- 10 shift a sx di 1
           -- 11 shift a sx di 2
            -- Eo  : in std_logic; ingresso seriale da destra (shift SX)
            -- Si potrebbe fare anche con sto qua ma nah
           );
end RegistroC;

architecture Structural of RegistroC is
    SIGNAL tmp: std_logic_vector(N-1 downto 0) := (others => '0');
    SIGNAL y_tmp : std_logic_vector (N-1 downto 0) := (others => '0');
    
    COMPONENT MUX4_1 is
        Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
               s : in STD_LOGIC_VECTOR (1 downto 0);
               y : out STD_LOGIC
               );
end COMPONENT;
    
    COMPONENT Flip_Flop is
        Port ( D : in STD_LOGIC;
               RST : in STD_LOGIC;
               CLK : in STD_LOGIC;
               Q : out STD_LOGIC);
end COMPONENT;
    
begin

    mux_0 : MUX4_1 PORT MAP(
        x(0) => SI,
        x(1) => SI,
        x(2) => y_tmp(1),
        x(3) => y_tmp(2),
        s => SEL,
        y => tmp(0)
        );
     
     mux_1 : MUX4_1 PORT MAP(
        x(0) => y_tmp(0),
        x(1) => SI,
        x(2) => y_tmp(2),
        x(3) => y_tmp(3),
        s => SEL,
        y => tmp(1)
        );
 
      mux_N1 : MUX4_1 PORT MAP(
        x(0) => y_tmp(N-2),
        x(1) => y_tmp(N-3),
        x(2) => SI,
        x(3) => SI,
        s => SEL,
        y => tmp(N-1)
        );       
        
      mux_N2 : MUX4_1 PORT MAP(
        x(0) => y_tmp(N-3),
        x(1) => y_tmp(N-4),
        x(2) => y_tmp(N-1),
        x(3) => SI,
        s => SEL,
        y => tmp(N-2)
        );
        
       create_mux: for i IN 2 to N-3 generate
            mux_i : MUX4_1 PORT MAP(
                x(0) => y_tmp(i-1),
                x(1) => y_tmp(i-2),
                x(2) => y_tmp(i+1),
                x(3) => y_tmp(i+2),
                s => SEL,
                y => tmp(i)
                );
       END GENERATE;  
       
       create_ff: for i IN 0 to N-1 generate
            ff_i : Flip_Flop PORT MAP(
                D => tmp(i),
                CLK => CLK,
                RST => RST,
                Q => y_tmp(i)
                );
       end generate;
       
       SO <= y_tmp(N-1);                   
end Structural;
