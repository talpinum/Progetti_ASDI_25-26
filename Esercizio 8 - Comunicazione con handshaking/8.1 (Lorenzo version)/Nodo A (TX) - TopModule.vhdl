library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nodo_A_TopModule is
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        EXTERNAL_START: in STD_LOGIC;
        B_ACK: in STD_LOGIC;
        DATA_READY_TO_B: out STD_LOGIC;
        DATA_TO_B: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture structural of Nodo_A_TopModule is

    signal CounterEnable: STD_LOGIC := '0';
    signal AllDataSent: STD_LOGIC := '0';

begin

    Nodo_A_Controllo_inst: entity work.Nodo_A_Controllo
     port map(
        CLK => CLK,
        RST => RST,
        START => EXTERNAL_START,
        B_ACK => B_ACK,
        ALL_DATA_SENT => AllDataSent,
        DATA_READY => DATA_READY_TO_B,
        COUNTER_ENABLE => CounterEnable
    );

    Nodo_A_Operativo_inst: entity work.Nodo_A_Operativo
     port map(
        CLK => CLK,
        RST => RST,
        COUNTER_ENABLE => CounterEnable,
        ALL_DATA_SENT => AllDataSent,
        DATA_TO_SEND => DATA_TO_B
    );
    

end architecture;