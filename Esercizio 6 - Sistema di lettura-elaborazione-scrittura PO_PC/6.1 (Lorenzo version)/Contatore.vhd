library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.LOG2_ECCESSO;

entity Contatore is
    generic (N: POSITIVE := 16);
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        COUNT_ENABLE: in STD_LOGIC;

        COUNT_FINISH: out STD_LOGIC := '0';
        Address: out STD_LOGIC_VECTOR(LOG2_ECCESSO(N)-1 downto 0)
    );
end entity;

architecture rtl of Contatore is

    signal count: UNSIGNED(LOG2_ECCESSO(N)-1 downto 0) := (others => '0');
    
begin

    Address <= STD_LOGIC_VECTOR(count);

    process (CLK, RST)
    begin
        if RST = '1' then 
            count <= (others => '0');
            COUNT_FINISH <= '0';

        elsif rising_edge(CLK) and COUNT_ENABLE = '1' then
            if TO_INTEGER(count) = N-1 then
                COUNT_FINISH <= '1';
            else
                count <= count + 1;
                COUNT_FINISH <= '0';
            end if;

        end if;
    end process;
end architecture;