library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AutomaMoore is
    port (
        A: in STD_LOGIC;
        i: in STD_LOGIC;
        RST: in STD_LOGIC;
        Y: out STD_LOGIC
    );
end entity;

architecture behavioral of AutomaMoore is

    type stato is (S0, S1, S2, S3);
    signal statoCorrente: stato := S0;
    signal statoProssimo: stato := S0; 
    
begin

    memoria_di_stato: PROCESS (A, RST) 
    begin
        if RST = '1' then
            statoCorrente <= S0;
        elsif rising_edge(A) then
            statoCorrente <= statoProssimo;
        end if;
    end PROCESS;


    logica_combinatoria: PROCESS (i, statoCorrente)
    begin
        case statoCorrente is
            when S0 =>
                Y <= '0';
                if i = '0' then
                    statoProssimo <= S0;
                else
                    statoProssimo <= S1;
                end if;
            when S1 =>
                Y <= '0';
                if i = '0' then
                    statoProssimo <= S0;
                else
                    statoProssimo <= S2;
                end if;
            when S2 =>
                Y <= '0';
                if i = '0' then
                    statoProssimo <= S0;
                else
                    statoProssimo <= S3;
                end if;
            when S3 =>
                Y <= '1';
                statoProssimo <= S0;
        end case;
        
    end PROCESS;

end architecture;