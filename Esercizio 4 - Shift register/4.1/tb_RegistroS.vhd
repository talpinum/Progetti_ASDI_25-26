library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_RegistroS is
end TB_RegistroS;

architecture Behavioral of TB_RegistroS is

    constant N : integer := 8;  -- usa 8 per vedere meglio in simulazione

    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal SI  : std_logic := '0';
    signal SO  : std_logic;
    signal SEL : std_logic_vector(1 downto 0) := "00";

    -- UUT
    component RegistroS
        generic ( N : integer := 16 );
        port (
            SI  : in  std_logic;
            SO  : out std_logic;
            CLK : in  std_logic;
            RST : in  std_logic;
            SEL : in  std_logic_vector(1 downto 0)
        );
    end component;

begin

    -- Istanziazione Unità Sotto Test
    UUT : RegistroS
        generic map(N => N)
        port map(
            SI  => SI,
            SO  => SO,
            CLK => CLK,
            RST => RST,
            SEL => SEL
        );

    -----------------------------------------------------------
    -- Clock 10 ns
    -----------------------------------------------------------
    CLK <= not CLK after 5 ns;

    -----------------------------------------------------------
    -- Stimoli
    -----------------------------------------------------------
    stim_proc : process
    begin

        ----------------------------------------------------
        -- RESET
        ----------------------------------------------------
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 20 ns;

        ----------------------------------------------------
        -- Shift right di 1 (SEL = 00)
        ----------------------------------------------------
        SEL <= "00";

        SI <= '1';
        wait for 20 ns;
        SI <= '0';
        wait for 20 ns;
        SI <= '1';
        wait for 20 ns;

        ----------------------------------------------------
        -- Shift right di 2 (SEL = 01)
        ----------------------------------------------------
        SEL <= "01";

        SI <= '1';
        wait for 20 ns;
        SI <= '0';
        wait for 20 ns;

        ----------------------------------------------------
        -- Shift left di 1 (SEL = 10)
        ----------------------------------------------------
        SEL <= "10";

        SI <= '1';
        wait for 20 ns;
        SI <= '0';
        wait for 20 ns;

        ----------------------------------------------------
        -- Shift left di 2 (SEL = 11)
        ----------------------------------------------------
        SEL <= "11";

        SI <= '1';
        wait for 20 ns;
        SI <= '0';
        wait for 20 ns;

        ----------------------------------------------------
        -- Fine simulazione
        ----------------------------------------------------
        wait;
    end process;

end Behavioral;
