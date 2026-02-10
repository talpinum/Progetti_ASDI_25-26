library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nodo_B_Controllo is
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        -- START: in STD_LOGIC;
        A_DATA_READY: in STD_LOGIC;

        ACK: out STD_LOGIC
    );
end entity;

architecture behavioral of Nodo_B_Controllo is

    type stato is (IDLE, WORKING);
    signal statoCorrente: stato := IDLE;

begin
    process (CLK, RST)
    begin
        if RST = '1' then
            ACK <= '0';
            statoCorrente <= IDLE;
        
        elsif rising_edge(CLK) then
            
            ACK <= '0';

            case statoCorrente is
                when IDLE =>
                    if A_DATA_READY = '1' then
                        ACK <= '1';
                        statoCorrente <= WORKING;
                    else
                        statoCorrente <= IDLE;
                    end if;
            
                when WORKING =>
                    statoCorrente <= IDLE;
            end case;
        
        end if;
    end process;
end architecture;