library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity frequencyDivider is
    port (
        SYS_CLK: in STD_LOGIC;
        DIV_CLOCK: out STD_LOGIC
        
    );
end entity;

architecture behavioral of frequencyDivider is

    -- con un clock di 100MHz, ogni milione di fronti di clock passa un secondo
    signal clockCounter: INTEGER range 0 to 99_999_999 := 0;

begin
    process (SYS_CLK)
    begin
        if rising_edge(SYS_CLK) then
            if clockCounter = 99_999_999 then
                DIV_CLOCK <= '1';
                clockCounter <= 0;
            else
                DIV_CLOCK <= '0';
                clockCounter <= clockCounter + 1;
            end if;
        end if;
    end process;   
end architecture;