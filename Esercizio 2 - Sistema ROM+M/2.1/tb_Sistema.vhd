library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Sistema is
-- entity vuota perché è un testbench
end tb_Sistema;

architecture Behavioral of tb_Sistema is

    -- Segnali per collegare il DUT (Device Under Test)
    signal A_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Y_tb : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Istanza del Sistema
    DUT: entity work.Sistema
        port map(
            A => A_tb,
            Y => Y_tb
        );

    -- Processo di stimolo
    stim_proc: process
    begin
        -- ciclo sugli indirizzi da 0 a 15
        for i in 0 to 15 loop
            A_tb <= STD_LOGIC_VECTOR(to_unsigned(i, 4));
            wait for 10 ns;  -- attendi 10 ns tra un cambio e l'altro
        end loop;

        wait;  -- ferma la simulazione
    end process;

end Behavioral;
