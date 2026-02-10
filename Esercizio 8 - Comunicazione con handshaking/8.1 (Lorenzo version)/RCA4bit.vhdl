library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RCA4bit is
    port (
        A: in STD_LOGIC_VECTOR(3 downto 0);
        B: in STD_LOGIC_VECTOR(3 downto 0);

        Sum: out STD_LOGIC_VECTOR(4 downto 0)
    );
end entity;

architecture structural of RCA4bit is

    signal carry: STD_LOGIC_VECTOR(4 downto 0);
    
begin
    carry(0) <= '0'; -- Primo carry in a zero
    
    GEN_RCA: for i in 0 to 3 generate
        FA_inst: entity work.FullAdder
            port map(
                A => A(i),
                B => B(i),
                C => carry(i),
                S => Sum(i),
                Cout => carry(i+1)
            );
    end generate;
    
    Sum(4) <= carry(4);
    
end architecture;