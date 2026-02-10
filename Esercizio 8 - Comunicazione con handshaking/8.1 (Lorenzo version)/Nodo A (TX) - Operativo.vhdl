library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nodo_A_Operativo is
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        COUNTER_ENABLE: in STD_LOGIC;
        
        ALL_DATA_SENT: out STD_LOGIC := '0';
        DATA_TO_SEND: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture behavioral of Nodo_A_Operativo is

    signal ROMAddress: STD_LOGIC_VECTOR(3 downto 0);
    signal ROMData: STD_LOGIC_VECTOR(7 downto 0);
    
begin

    ROM_A_inst: entity work.ROM -- uguale a ROM_A, che è un file inutile, basta riusare quello del 2.1
     port map(
        ADDRESS => ROMAddress,
        CONTENT => ROMData
    );
    
    Contatore_inst: entity work.Contatore -- uguale a contatore nel 6.1
     generic map(N => 16)
     port map(
        CLK => CLK,
        RST => RST,
        COUNT_ENABLE => COUNTER_ENABLE,
        COUNT_FINISH => ALL_DATA_SENT,
        Address => ROMAddress
    );

    -- dato inviato fuori dal process (asincrono)
    DATA_TO_SEND <= ROMData;

end architecture;