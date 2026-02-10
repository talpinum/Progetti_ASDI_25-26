library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nodo_B_Operativo is
    port (
        CLK: in STD_LOGIC; 
        RST: in STD_LOGIC;
        DATA_IN: in STD_LOGIC_VECTOR(7 downto 0);

        SUM_RESULT: out STD_LOGIC_VECTOR(4 downto 0)
    );
end entity;

architecture behavioral of Nodo_B_Operativo is

    signal String_MostSignificant: STD_LOGIC_VECTOR(3 downto 0);
    signal String_LeastSignificant: STD_LOGIC_VECTOR(3 downto 0);
    signal Sum_out: STD_LOGIC_VECTOR(4 downto 0);

begin

    -- la stringa viene divisa in due parti
    String_MostSignificant  <= DATA_IN(7 downto 4);
    String_LeastSignificant <= DATA_IN(3 downto 0);

    RCA_inst: entity work.RCA4bit
     port map(
        A => String_LeastSignificant,
        B => String_MostSignificant,
        Sum => Sum_out
    );

    SUM_RESULT <= Sum_out;

-- salvare sul fronte di clock il risultato da qualche parte?
--     process(CLK, RST)
--     begin
--         if RST = '1' then
--             SUM_RESULT <= (others => '0');
--         elsif rising_edge(CLK) then
--             inserire da qualche parte boh? <= SUM_RESULT;
--         end if;
--     end process;

end architecture;