entity A_Completo is
    Port (
        clkA : in std_logic;
        rstA : in std_logic;
        startA : in std_logic;

        -- protocollo con B
        ackA : in std_logic;
        reqA : out std_logic;
        ok_user_ackA : in std_logic;
        doneA : in std_logic;

        -- uscita dati
        dataA : out std_logic_vector(7 downto 0)
    );
end A_Completo;
  
architecture Structural of A_Completo is

    component U_C_A_Completa
        Port (
            clk : in std_logic;
            rst : in std_logic;
            start : in std_logic;
            last : in std_logic;
            A_cont : out std_logic;
            load_A : out std_logic;

            ack : in std_logic;
            req : out std_logic;
            ok_user_ack : in std_logic;
            done : in std_logic
        );
    end component;

    component U_O_A_Completa
        Port (
            clk_o : in std_logic;
            rst_o : in std_logic;
            load_reg : in std_logic;
            A_cont : in std_logic;
            last_o : out std_logic;
            Y : out std_logic_vector(7 downto 0)
        );
    end component;

    signal A_cont_sig : std_logic;
    signal load_sig   : std_logic;
    signal last_sig   : std_logic;
    signal data_sig   : std_logic_vector(7 downto 0);

begin

    -- UNITÀ DI CONTROLLO
    UC_A : U_C_A_Completa
        port map(
            clk => clkA,
            rst => rstA,
            start => startA,
            last => last_sig,
            A_cont => A_cont_sig,
            load_A => load_sig,

            ack => ackA,
            req => reqA,
            ok_user_ack => ok_user_ackA,
            done => doneA
        );

    -- UNITÀ OPERATIVA
    UO_A : U_O_A_Completa
        port map(
            clk_o => clkA,
            rst_o => rstA,
            load_reg => load_sig,
            A_cont => A_cont_sig,
            last_o => last_sig,
            Y => data_sig
        );

    -- USCITA DATI
    dataA <= data_sig;

end Structural;
