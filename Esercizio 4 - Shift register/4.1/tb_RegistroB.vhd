library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_RegistroB is
end TB_RegistroB;

architecture tb of TB_RegistroB is

    -- Parametrizzazione del registro
    constant N : integer := 8;

    -- Segnali del testbench
    signal CLK : std_logic := '0';
    signal S   : std_logic := '0';
    signal RST : std_logic := '0';
    signal SI  : std_logic := '0';
    signal SO  : std_logic;
    signal Y   : integer range 1 to 2 := 1;

    -- Component under test
    component RegistroB
        generic ( N : integer := 16 );
        port (
            CLK : in STD_LOGIC;
            S   : in STD_LOGIC;
            RST : in STD_LOGIC; 
            SI  : in STD_LOGIC;
            SO  : out STD_LOGIC;
            Y   : in INTEGER RANGE 1 to 2
        );
    end component;

begin

    --------------------------------------------------------------------------
    -- ISTANZA DEL DUT (Device Under Test)
    --------------------------------------------------------------------------
    DUT : RegistroB
        generic map ( N => N )
        port map (
            CLK => CLK,
            S   => S,
            RST => RST,
            SI  => SI,
            SO  => SO,
            Y   => Y
        );

    --------------------------------------------------------------------------
    -- CLOCK PROCESS (periodo 10 ns)
    --------------------------------------------------------------------------
    CLK <= not CLK after 5 ns;

    --------------------------------------------------------------------------
    -- PROCESSO DI TEST
    --------------------------------------------------------------------------
    stim : process
    begin
        ----------------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------------
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;

        ----------------------------------------------------------------------
        -- COSTRUZIONE DEL REGISTRO (shift-right di 1)
        ----------------------------------------------------------------------
        S <= '0';  -- shift-right
        Y <= 1;

        SI <= '1'; wait for 10 ns;
        SI <= '0'; wait for 10 ns;
        SI <= '1'; wait for 10 ns;
        SI <= '1'; wait for 10 ns;
        SI <= '0'; wait for 10 ns;

        ----------------------------------------------------------------------
        -- SHIFT RIGHT DI 2
        ----------------------------------------------------------------------
        Y <= 2;
        SI <= '1';
        wait for 20 ns;

        ----------------------------------------------------------------------
        -- SHIFT LEFT DI 1
        ----------------------------------------------------------------------
        S <= '1';
        Y <= 1;
        SI <= '0';
        wait for 20 ns;

        ----------------------------------------------------------------------
        -- SHIFT LEFT DI 2
        ----------------------------------------------------------------------
        S <= '1';
        Y <= 2;
        SI <= '1';
        wait for 20 ns;

        ----------------------------------------------------------------------
        -- FINE SIMULAZIONE
        ----------------------------------------------------------------------
        wait;
    end process;

end tb;
