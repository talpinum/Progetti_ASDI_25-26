library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    port (
        A, B, C: in STD_LOGIC;
        S, Cout: out STD_LOGIC
    );
end entity;

architecture dataflow of FullAdder is
begin

    S <= A xor B xor C;
    Cout <= (A and B) or (C and (A xor B));
    
end architecture;