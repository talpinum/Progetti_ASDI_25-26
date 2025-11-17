library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Comparatore is
    port (
        ROMOutput: in STD_LOGIC_VECTOR(7 downto 0);
        MEM_WRITE_ENABLE: out STD_LOGIC
    );
end entity;

architecture rtl of Comparatore is
    constant X: UNSIGNED(7 downto 0) := "00000101"; -- stringa precaricata a caso

begin
    MEM_WRITE_ENABLE <= '1' when unsigned(ROMOutput) = X else '0';    

end architecture;