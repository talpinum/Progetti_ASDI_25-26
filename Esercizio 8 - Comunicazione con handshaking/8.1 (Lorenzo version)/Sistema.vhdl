library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sistema is
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        START: in STD_LOGIC;
        FINAL_RESULT: out STD_LOGIC_VECTOR(4 downto 0)
    );
end entity;

architecture structural of Sistema is

    signal ack_from_b: STD_LOGIC;
    signal data_ready: STD_LOGIC;
    signal data_string: STD_LOGIC_VECTOR(7 downto 0);

begin

    Nodo_A: entity work.Nodo_A_TopModule
        port map(
            CLK => CLK,
            RST => RST,
            EXTERNAL_START => START,
            B_ACK => ack_from_b,
            DATA_READY_TO_B => data_ready,
            DATA_TO_B => data_string
        );

    Nodo_B: entity work.Nodo_B_TopModule
        port map(
            CLK => CLK, RST => RST,
            A_DATA_READY => data_ready,
            DATA_FROM_A => data_string,
            ACK_TO_A => ack_from_b,
            RESULT => FINAL_RESULT
        );
  
end architecture;