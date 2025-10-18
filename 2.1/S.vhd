library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity S is
    port (
        A: in STD_LOGIC_VECTOR(3 downto 0);
        dataOutput: out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;

architecture structural of S is

    component ROM is
        port (
            address: in STD_LOGIC_VECTOR(3 downto 0);
            content: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component M is
        port (
            input_m: in STD_LOGIC_VECTOR(7 downto 0);
            output_m: out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal u: STD_LOGIC_VECTOR(7 downto 0) := ((others => '0') );
    
    begin

        ROM_inst: ROM
            port map(
                address => A,
                content => u
            );

        M_inst: M
            port map(
                input_m => u,
                output_m => dataOutput
            );

end architecture;