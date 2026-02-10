library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nodo_B_TopModule is
    port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        --START: in STD_LOGIC;
        A_DATA_READY: in STD_LOGIC;
        DATA_FROM_A: in STD_LOGIC_VECTOR(7 downto 0);
        
        ACK_TO_A: out STD_LOGIC;
        RESULT: out STD_LOGIC_VECTOR(4 downto 0)
    );
end entity;

architecture structural of Nodo_B_TopModule is

begin

    Nodo_B_Controllo_inst: entity work.Nodo_B_Controllo
     port map(
        CLK => CLK,
        RST => RST,
        A_DATA_READY => A_DATA_READY,
        ACK => ACK_TO_A
    );

    Nodo_B_Operativo_inst: entity work.Nodo_B_Operativo
     port map(
        CLK => CLK,
        RST => RST,
        DATA_IN => DATA_FROM_A,
        SUM_RESULT => RESULT
    );
    

end architecture;