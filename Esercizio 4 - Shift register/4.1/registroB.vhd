----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2025 11:45:13
-- Design Name: 
-- Module Name: registro - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;
USE work.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity registro is
    generic(
        N : INTEGER := 16
        );
    
    Port ( CLK : in STD_LOGIC;
           S : in STD_LOGIC; -- Direzione: 1 = sinistra, 0 = destra
           RST : in STD_LOGIC; 
           SI : in STD_LOGIC; -- Bit in ingresso
           SO : out STD_LOGIC; -- Bit in uscita
           Y : in INTEGER RANGE 1 to 2 -- Numero di posizioni di shift
           );
           
end registro;

architecture Behavioral of registro is
    signal tmp : std_logic_vector(N-1 downto 0) := (others => '0');

begin
    process(CLK)
        begin
            if rising_edge(CLK) then
                if (RST = '1') then
                    tmp <= (others => '0');
                else
                    CASE S IS
                        WHEN '0' =>
                            if (Y = 1) then
                                 tmp(0) <= SI;
                                 for i IN 1 to (N-1) loop
                                    tmp(i) <= tmp(i-1);
                                 END LOOP;
                            elsif (Y = 2) then
                                 tmp(0) <= SI;
                                 tmp(1) <= SI;
                                 for i IN 2 to (N-1) loop
                                    tmp(i) <= tmp(i-2);
                                 END LOOP;
                           end if;
                        
                        WHEN '1' =>
                            if (Y=1) then
                                tmp(N-1) <= SI;
                                for i IN 0 to (N-2) loop
                                    tmp(i) <= tmp(i+1);
                                END LOOP;
                           elsif (Y=2) then
                                tmp(N-1) <= SI;
                                tmp(N-2) <= SI;
                                for i IN 0 to (N-3) loop
                                    tmp(i) <= tmp(i+2);
                                END LOOP;
                           end if;
                       WHEN OTHERS =>
                            SO <= '0'; -- non serve ma messo tanto per
                       end case;
                   end if;
                end if;
    END process;

    SO <= tmp(N-1);
                    
end Behavioral;
