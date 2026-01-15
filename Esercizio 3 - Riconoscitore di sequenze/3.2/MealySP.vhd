library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MealySP is
    port(
        i : in std_logic; -- dallo switch S1
        CLK : in std_logic;
        rst: in std_logic;
        E : in std_logic; -- impulso dal debouncer
        Y : out std_logic -- verso i LED
    );
end entity;

architecture behavioral of MealySP is

    type stato is (S0, S1, S2);
    signal stato_corrente: stato := S0;

begin
    stato_prossimo: process(CLK)
    begin
        if rising_edge(CLK) then
            if (rst='1') then
                stato_corrente <= S0;
                Y <= '0';
            elsif E = '1' then 
                case stato_corrente is
                
                    when S0 =>
                        if(i='0') then
                            stato_corrente <= S0;
                            
                        else
                            stato_corrente <= S1;
                            
                        end if;
                        Y <= '0';
                        
                    when S1 =>
                        if(i='0') then
                            stato_corrente <= S0;
                            
                        else
                            stato_corrente <= S2;
                            
                        end if;    
                            Y <= '0';
                            
                    when S2 =>
                        if(i='0') then
                            stato_corrente <= S0;
                            Y <= '0';
                        else
                            stato_corrente <= S0;
                            Y <= '1';
                        end if;
                        
                end case;   
            end if;
        end if;
    end process;
    
end behavioral;
