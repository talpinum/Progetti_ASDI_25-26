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

    type stato is (S0, S1, S2);
    signal statoCorrente: stato := S0;
    
begin

    logica_combinatoria: PROCESS (A, RST)
    begin
        if RST = '1' then
            statoCorrente <= S0;
            Y <= '0';
        elsif rising_edge(A) then
            if (i = '0') then
            statoCorrente <= S0;
            Y <= '0';
            else
                case statoCorrente is
                    when S0 =>
                        statoCorrente <= S1;
                        Y <= '0';
                    when S1 =>
                        statoCorrente <= S2;
                        Y <= '0';
                    when S2 =>
                        statoCorrente <= S0;
                        Y <= '1';
                end case;
            end if; 
        end if;
end PROCESS;

end architecture;