library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopModuleWrapper is
    port (
        CLK: in  STD_LOGIC;
        RST: in  STD_LOGIC;
        A_in: in  STD_LOGIC_VECTOR(3 downto 0);

        M_out: out STD_LOGIC_VECTOR(3 downto 0)
    );
end TopModuleWrapper;

architecture rtl of TopModuleWrapper is

    signal A_reg: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dataOut_internal: STD_LOGIC_VECTOR(3 downto 0);

begin
    
    S_inst: entity work.S
     port map(
        A => A_reg,
        dataOutput => dataOut_internal
    );

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                A_reg <= (others => '0');
                M_out <= (others => '0');
            else
                A_reg <= A_in;
                M_out <= dataOut_internal;
            end if;
        end if;
    end process;
end architecture;