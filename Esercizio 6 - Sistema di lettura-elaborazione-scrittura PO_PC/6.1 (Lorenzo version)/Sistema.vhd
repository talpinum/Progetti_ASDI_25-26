library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.LOG2_ECCESSO;

entity Sistema is
    generic (N: POSITIVE := 16);
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        START: in STD_LOGIC;
        -- come uscita metto l'uscita della mem, cioè i dati all'interno di una sua riga
        MEMData: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture structural of Sistema is

    signal ROMOutput: STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); 
    signal AddressFromCounter: STD_LOGIC_VECTOR(LOG2_ECCESSO(N)-1 downto 0) := (others => '0');
    signal WriteEnableFromComparatore: STD_LOGIC := '0';
    signal MEMOutput: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal CountFinish: STD_LOGIC := '0';
    signal CountEnableFromUC: STD_LOGIC := '0';
    
begin

    MEMData <= MEMOutput;

    UnitaControllo_inst: entity work.UnitaControllo
     port map(
        CLK => CLK,
        RST => RST,
        START => START,
        COUNT_FINISH => CountFinish,
        COUNT_ENABLE => CountEnableFromUC
    );

    Contatore_inst: entity work.Contatore
     generic map(N => 16)
     port map(
        CLK => CLK,
        RST => RST,
        COUNT_ENABLE => CountEnableFromUC,
        COUNT_FINISH => CountFinish,
        Address => AddressFromCounter
    );

    ROM_16_8: entity work.ROM_N
     generic map(N => 16)
     port map(
        CLK => CLK,
        Address => AddressFromCounter,
        Content => ROMOutput
    );

    Comparatore_inst: entity work.Comparatore
     port map(
        ROMOutput => ROMOutput,
        MEM_WRITE_ENABLE => WriteEnableFromComparatore
    );

    MEM_N_inst: entity work.MEM_N
     generic map(N => 16)
     port map(
        CLK => CLK,
        RST => RST,
        WRITE_ENABLE => WriteEnableFromComparatore,
        DataToWrite => ROMOutput,
        Address => AddressFromCounter,
        Content => MEMOutput
    );

end architecture;