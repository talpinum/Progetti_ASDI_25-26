library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity M is
    port (
        input_m: in STD_LOGIC_VECTOR(7 downto 0);
        output_m: out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;


architecture rtl of M is

    begin
        count_1_instances: process (input_m)
            variable count: integer range 0 to 8;

        begin
            count := 0;

            -- contiamo ogni bit dell'ingresso pari a 1
            for i in 0 to 7 loop
                if input_m(i) = '1' then
                    count:= count + 1;
                end if;
            end loop;

            -- converte il risultato in un std_logic_vector di 4 bit, dove count diventa il numero di 1 presenti codificato in binario
            output_m <= STD_LOGIC_VECTOR(to_unsigned(count, 4));

            end process;
    
end architecture;