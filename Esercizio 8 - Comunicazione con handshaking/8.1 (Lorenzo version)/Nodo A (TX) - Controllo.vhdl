library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nodo_A_Controllo is
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        START: in STD_LOGIC;
        B_ACK: in STD_LOGIC;
        ALL_DATA_SENT: in STD_LOGIC;

        DATA_READY: out STD_LOGIC;
        COUNTER_ENABLE: out STD_LOGIC
    );
end entity;

architecture behavioral of Nodo_A_Controllo is

    -- idle funziona sia come idle che come stato di fine
    type stato is (IDLE, SENDING_DATA, WAITING_ACK);
    signal statoCorrente: stato := IDLE;
    
begin

    process (CLK, RST)
    begin
        
        if RST = '1' then
            DATA_READY <= '0';
            statoCorrente <= IDLE;
            -- tutto il resto si resetta nel contatore 
            
        elsif rising_edge(CLK) then

            COUNTER_ENABLE <= '0';
            DATA_READY <= '0';

            case statoCorrente is
                when IDLE =>
                    if START = '1' then 
                        COUNTER_ENABLE <= '1';
                        statoCorrente <= SENDING_DATA;
                    end if;
                    
                when SENDING_DATA =>
                    DATA_READY <= '1';
                    statoCorrente <= WAITING_ACK;
            
                when WAITING_ACK =>
                    if B_ACK = '0' then 

                        if ALL_DATA_SENT = '1' then
                            statoCorrente <= IDLE;
                        else
                            DATA_READY <= '1';
                            statoCorrente <= WAITING_ACK;
                        end if;
                    else
                        COUNTER_ENABLE <= '1';
                        statoCorrente <= SENDING_DATA;
                    end if;
            end case;
        end if;
    end process;
end architecture;