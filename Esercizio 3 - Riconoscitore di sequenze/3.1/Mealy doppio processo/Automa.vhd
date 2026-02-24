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

    type stato is (S0, S1, S2, S3, S4);
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
                if (i = '0') then
                    statoProssimo <= S4;
            Y <= '0';
                else
                    statoProssimo <= S1;
                    Y <= '0';
                end if;

            when S1 =>
                if (i = '0') then
                    statoProssimo <= S5;
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
                    statoProssimo <= S0;
                    Y <= '1';
                end if;   
                    
            when S4 =>
                    statoProssimo <= S5;
                    Y <= '0';    

            when S5 =>
                    statoProssimo <= S0;
                    Y <= '0';

        end case;
    end PROCESS;

end architecture;
