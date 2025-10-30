library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Automa is
    port (
        A: in STD_LOGIC;
        i: in STD_LOGIC;
        RST: in STD_LOGIC;
        Y: out STD_LOGIC
    );
end entity;

architecture behavioral of Automa is

    type stato is (S0, S1, S2);
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
        if (i = '0') then
            statoProssimo <= S0;
            Y <= '0';
        else
            case statoCorrente is
                when S0 =>
                    statoProssimo <= S1;
                    Y <= '0';
                when S1 =>
                    statoProssimo <= S2;
                    Y <= '0';
                when S2 =>
                    statoProssimo <= S0;
                    Y <= '1';
            end case;
        end if;


        /*case statoCorrente is
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
                statoProssimo <= S0;
                if i = '0' then
                    Y <= '0';
                else
                    Y <= '1';
                end if;
        end case;*/
        
    end PROCESS;

end architecture;