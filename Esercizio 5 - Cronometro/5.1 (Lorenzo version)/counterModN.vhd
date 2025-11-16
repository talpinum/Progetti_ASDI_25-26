library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.utils.all;

entity counterModN is
    generic (
        N: POSITIVE := 60
    );
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        SET: in STD_LOGIC;
        InitValue: in STD_LOGIC_VECTOR(LOG2_ECCESSO(N)-1 downto 0);
        CountEnable: in STD_LOGIC;

        CarryOut: out STD_LOGIC := '0';
        Count: out STD_LOGIC_VECTOR(LOG2_ECCESSO(N)-1 downto 0)
    );
end entity;

architecture behavioral of counterModN is

    signal currentCount: UNSIGNED(LOG2_ECCESSO(N)-1 downto 0) := (others => '0');

begin

    Count <= STD_LOGIC_VECTOR(currentCount);
    CarryOut <= '1' when currentCount = N-1 and CountEnable = '1' else '0';

    process (CLK, RST)
    begin
        if RST = '1' then currentCount <= (others => '0');

        elsif rising_edge(CLK) then
            if SET = '1' then currentCount <= UNSIGNED(InitValue);

            elsif CountEnable = '1' then
                if currentCount = N-1 then currentCount <= (others => '0'); 
                else currentCount <= currentCount + 1;
                end if;

            end if;
        end if;
    end process;
end architecture;