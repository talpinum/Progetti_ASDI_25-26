library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AutomaSingoloProcesso is
    port (
        A: in STD_LOGIC;
        i: in STD_LOGIC;
        RST: in STD_LOGIC;
        Y: out STD_LOGIC
    );
end entity;

architecture behavioral of AutomaSingoloProcesso is

    type stato is (S0, S1, S2, S3, S4);
    signal statoCorrente: stato := S0;
    
begin

    processo_sequenziale: PROCESS (A, RST)
    begin
    if rising_edge(clk) then
        if RST = '1' then
            statoCorrente <= S0;
            Y <= '0';
        else
         case statoCorrente is

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
end PROCESS;

end architecture;
