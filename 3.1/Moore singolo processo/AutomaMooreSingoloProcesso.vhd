library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AutomaMooreSingoloProcesso is
    port (
        A: in STD_LOGIC;
        i: in STD_LOGIC;
        RST: in STD_LOGIC;
        Y: out STD_LOGIC
    );
end entity;

architecture behavioral of AutomaMooreSingoloProcesso is

    type stato is (S0, S1, S2, S3);
    signal statoCorrente: stato := S0;
    
begin

    processo_sequenziale: PROCESS (A, RST)
    begin
        if RST = '1' then
            statoCorrente <= S0;
            Y <= '0';
        elsif rising_edge(A) then
            case statoCorrente is
                when S0 =>
                    Y <= '0';
                    if i = '0' then
                        statoCorrente <= S0;
                    else
                        statoCorrente <= S1;
                    end if;
                when S1 =>
                    Y <= '0';
                    if i = '0' then
                        statoCorrente <= S0;
                    else
                        statoCorrente <= S2;
                    end if;
                when S2 =>
                    Y <= '0';
                    if i = '0' then
                        statoCorrente <= S0;
                    else
                        statoCorrente <= S3;
                    end if;
                when S3 =>
                    Y <= '1';
                    statoCorrente <= S0;
            end case;
        end if;
    end PROCESS;

end architecture;