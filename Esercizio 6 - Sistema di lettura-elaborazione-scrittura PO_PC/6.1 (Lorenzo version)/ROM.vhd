library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.LOG2_ECCESSO;

entity ROM_N is
    generic (N: POSITIVE := 16);
    port (
        CLK: in STD_LOGIC;
        Address: in STD_LOGIC_VECTOR(LOG2_ECCESSO(N)-1 downto 0) := (others => '0') ;
        Content: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture rtl of ROM_N is

    type ROM_N_8 is array (0 to N-1) of STD_LOGIC_VECTOR(7 downto 0);

    function init_rom return ROM_N_8 is
        variable tmpRom: ROM_N_8;
    begin
        for address in 0 to N-1 loop
            -- convertiamo l'integer address in un vettore di 8 bit: la ROM conterrà semplicemente i numeri 0, 1, 2, … su 8 bit.
            tmpRom(address) := std_logic_vector(to_unsigned(address, 8));
        end loop;
        return tmpRom;
    end function;
    
    -- inizializziamo la rom con i valori di tmpRom
    constant ROM: ROM_N_8  := init_rom;
    
    begin
        process (CLK)
        begin
            if rising_edge(CLK) then
                Content <= ROM(to_integer(UNSIGNED(Address)));
            end if;
        end process;

end architecture;
