library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registro_pipo is
    generic (
        N : integer := 8  -- ampiezza del registro
    );
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        load  : in  std_logic;
        d_in  : in  std_logic_vector(N-1 downto 0);
        q_out : out std_logic_vector(N-1 downto 0)
    );
end registro_pipo;

architecture rtl of registro_pipo is
    signal reg : std_logic_vector(N-1 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                reg <= (others => '0');
            elsif load = '1' then
                reg <= d_in;
            end if;
        end if;
    end process;

    q_out <= reg;

end rtl;
