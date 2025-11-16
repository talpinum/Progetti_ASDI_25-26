library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.all;

entity Cronometro is
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;

        SET: in STD_LOGIC;
        SET_S: in STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
        SET_M: in STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
        SET_H: in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

        Count_S: out STD_LOGIC_VECTOR(5 downto 0);
        Count_M: out STD_LOGIC_VECTOR(5 downto 0);
        Count_H: out STD_LOGIC_VECTOR(4 downto 0)
    );
end entity;

architecture structural of Cronometro is

    signal boardClock: STD_LOGIC;
    signal divClock: STD_LOGIC;
    signal secondsCounterCarryOut: STD_LOGIC;
    signal minutesCounterCarryOut: STD_LOGIC;
    signal hoursCounterCarryOut: STD_LOGIC;

begin

    boardClock <= CLK;
    
    frequencyDivider_inst: entity work.frequencyDivider
     port map(
        SYS_CLK => boardClock,
        DIV_CLOCK => divClock
    );

    secondsCounter: entity work.counterModN
     generic map(N => 60)
     port map(
        CLK => divClock,
        RST => RST,
        SET => SET,
        InitValue => SET_S,
        CountEnable => '1', -- il contatore di secondi deve essere sempre abilitato
        CarryOut => secondsCounterCarryOut,
        Count => Count_S
    );

    minutesCounter: entity work.counterModN
     generic map(N => 60)
     port map(
        CLK => divClock,
        RST => RST,
        SET => SET,
        InitValue => SET_M,
        CountEnable => secondsCounterCarryOut,
        CarryOut => minutesCounterCarryOut,
        Count => Count_M
    );

    hoursCounter: entity work.counterModN
     generic map(N => 24)
     port map(
        CLK => divClock,
        RST => RST,
        SET => SET,
        InitValue => SET_H,
        CountEnable => minutesCounterCarryOut,
        CarryOut => hoursCounterCarryOut,
        Count => Count_H
    );
    

end architecture;