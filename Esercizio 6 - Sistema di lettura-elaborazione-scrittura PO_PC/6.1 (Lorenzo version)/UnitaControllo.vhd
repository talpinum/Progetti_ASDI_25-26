library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.LOG2_ECCESSO;

entity UnitaControllo is
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        START: in STD_LOGIC;
        COUNT_FINISH: in STD_LOGIC;

        COUNT_ENABLE: out STD_LOGIC
    );
end entity;

architecture behavioral of UnitaControllo is

    type stato is (IDLE, READING);
    signal statoCorrente: stato := IDLE;
        
begin

    process (CLK, RST)
    begin
        if RST = '1' then
            statoCorrente <= IDLE;
            COUNT_ENABLE <= '0';

        elsif rising_edge(CLK) then
            case statoCorrente is
                
                when IDLE =>
                    if START = '1' then
                        statoCorrente <= READING;
                        COUNT_ENABLE <= '1';
                    else COUNT_ENABLE <= '0';
                    end if;

                when READING =>
                    if COUNT_FINISH = '1' then
                        statoCorrente <= IDLE;
                        COUNT_ENABLE <= '0';
                    else COUNT_ENABLE <= '1';
                    end if;
            end case;
        end if;
    end process;
end architecture;