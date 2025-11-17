library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package utils is
    function LOG2_ECCESSO(N: positive) return natural;
end package;

package body utils is
    function LOG2_ECCESSO(N: positive) return natural is
        variable bitsNeeded: natural := 0;
        variable maxValue: natural := N - 1;
    begin
        while maxValue > 0 loop
            -- a ogni divisione per due del valore da rappresentare, corrisponde un bit aggiuntivo necessario
            -- (la divisione arrotonda per difetto)
            maxValue := maxValue / 2;
            bitsNeeded := bitsNeeded + 1;
        end loop;
        return bitsNeeded;
    end function;
end package body;
