library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.LOG2_ECCESSO;

entity MEM_N is
    generic (N: POSITIVE := 16);
    port (
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        WRITE_ENABLE: in STD_LOGIC;

        DataToWrite: in STD_LOGIC_VECTOR(7 downto 0);
        Address: in STD_LOGIC_VECTOR(LOG2_ECCESSO(N)-1 downto 0);
        
        Content: out STD_LOGIC_VECTOR(7 downto 0) -- boh la traccia non lo menziona proprio un valore di out
    );
end entity;

architecture rtl of MEM_N is

    type MEM_N_8 is array (0 to N-1) of STD_LOGIC_VECTOR(7 downto 0);

    -- funzione per inizializzare la mem a 0 in ogni cella di memoria
    function init_mem return MEM_N_8 is
        variable tmpMem: MEM_N_8;
    begin
        for address in 0 to N-1 loop
            tmpMem(address) := (others => '0');
        end loop;
        return tmpMem;
    end function;

    signal MEM: MEM_N_8 := init_mem;

begin
    process (CLK, RST)
    begin
        if RST = '1' then
            MEM <= init_mem;
        elsif rising_edge(CLK) then
            if WRITE_ENABLE = '1' then
                MEM(to_integer(UNSIGNED(Address))) <= DataToWrite;
            end if;
            Content <= MEM(to_integer(UNSIGNED(Address)));
        end if;
    end process;

end architecture;