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

    type stato is (S0, S1, S2, S3, S4);
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
                if (i = '0') then
                    statoProssimo <= S3;
                    Y <= '0';
                else
                    statoProssimo <= S1;
                    Y <= '0';
                end if;

            when S1 =>
                if (i = '0') then
                    statoProssimo <= S4;
                    Y <= '0';
                else
                    statoProssimo <= S2;
                    Y <= '0';
                end if;
                    
            when S2 =>
                if (i = '0') then
                    statoProssimo <= S0; 
                    Y <= '0';
                else
                    statoProssimo <= S0; -- Sequenza 111
                    Y <= '1';
                end if;   
                    
            when S3 =>
                    statoProssimo <= S4;
                    Y <= '0';    

            when S4 =>
                    statoProssimo <= S0;
                    Y <= '0';
                        
                end case;   
            end if;
        end if;
    end process;
    
end behavioral;
