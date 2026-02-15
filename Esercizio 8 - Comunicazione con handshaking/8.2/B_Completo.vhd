library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

eentity B_Completo is
    Port (
        clkB : in std_logic;
        rstB : in std_logic;
        req : in std_logic;                      -- da nodo A
        data_in : in std_logic_vector(7 downto 0);
        ack : out std_logic;
        okUser : in std_logic;                   -- input utente
        ok_user_B : out std_logic;               -- verso esterno
        done : out std_logic;
        resultB : out std_logic_vector(4 downto 0)
    );
end B_Completo;
    
architecture Structural of B_Completo is

    component Unita_Controllo_B_Completo
        Port (
            clk : in std_logic;
            rst : in std_logic;
            okUser : in std_logic;
            load : out std_logic;
            req : in std_logic;
            done : out std_logic;
            user_ack : out std_logic;
            ack : out std_logic
        );
    end component;

    component U_O_B_Completa
        Port (
            clk_o : in std_logic;
            rst_o : in std_logic;
            load : in std_logic;
            data_out : out std_logic_vector(4 downto 0);
            data_in : in std_logic_vector(7 downto 0)
        );
    end component;

    signal load_sig    : std_logic;
    signal ack_sig     : std_logic;
    signal done_sig    : std_logic;
    signal user_ack_sig: std_logic;
    signal risultato   : std_logic_vector(4 downto 0);

begin

    -- UNITÀ DI CONTROLLO
    UC_B_C : Unita_Controllo_B_Completo
        port map(
            clk => clkB,
            rst => rstB,
            okUser => okUser,
            load => load_sig,
            req => req,
            done => done_sig,
            user_ack => user_ack_sig,
            ack => ack_sig
        );

    -- UNITÀ OPERATIVA
    UO_B_C : U_O_B_Completa
        port map(
            clk_o => clkB,
            rst_o => rstB,
            load => load_sig,
            data_out => risultato,
            data_in => data_in
        );

    -- USCITE ESTERNE
    ack <= ack_sig;
    resultB <= risultato;
    ok_user_B <= user_ack_sig;

end Structural;
