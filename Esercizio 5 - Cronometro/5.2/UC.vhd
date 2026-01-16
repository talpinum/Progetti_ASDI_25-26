
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  start_stop : in std_logic;
  load_sec : in std_logic;
  load_h : in std_logic;
  load_min : in std_logic;
  set_smh : in std_logic_vector(0 to 5);
  anodes_out : out std_logic_vector(7 downto 0);
  cathodes_out : out std_logic_vector(7 downto 0)
  );
end UC;



architecture Behavioral of UC is
    
  component Cronometro is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start_stop : in STD_LOGIC;
           load_h : in STD_LOGIC;
           load_min : in STD_LOGIC;
           load_s : in STD_LOGIC;
           y_secondi : out STD_LOGIC_VECTOR (0 to 5);
           y_minuti : out STD_LOGIC_VECTOR (0 to 5);
           y_ore : out STD_LOGIC_VECTOR (0 to 4);
           set_h : in STD_LOGIC_VECTOR (0 to 4);
           set_min : in STD_LOGIC_VECTOR (0 to 5);
           set_s : in STD_LOGIC_VECTOR (0 to 5));
end component;   
    
  component ButtonDebouncer is
    generic (                       
        CLK_period: integer := 10;  -- periodo del clock (della board) in nanosecondi
        btn_noise_time: integer := 10000000 -- durata stimata dell'oscillazione del bottone in nanosecondi
                                            -- il valore di default è 10 millisecondi
    );
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           CLEARED_BTN : out STD_LOGIC);
end component;

  component display_seven_segments is
	Generic( 
				clock_frequency_in : integer := 100000000; 
				clock_frequency_out : integer := 500
				);
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           value : in  STD_LOGIC_VECTOR (23 downto 0);
           enable : in  STD_LOGIC_VECTOR (7 downto 0);
           dots : in  STD_LOGIC_VECTOR (7 downto 0);
           anodes : out  STD_LOGIC_VECTOR (7 downto 0);
           cathodes : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

  component converti_tempo is
      Port (
      sec : in std_logic_vector(0 to 5);
      min : in std_logic_vector(0 to 5);
      h : in std_logic_vector(0 to 4);
      outP : out std_logic_vector(23 downto 0)
      );
end component;
    
    signal temp_second : std_logic_vector(0 to 5);
    signal temp_min : std_logic_vector(0 to 5);
    signal temp_hours : std_logic_vector(0 to 4);
    signal temp_value : std_logic_vector(23 downto 0);
    signal var_second : std_logic_vector(0 to 5) := "000000";
    signal var_min : std_logic_vector(0 to 5) := "000000";
    signal var_hours : std_logic_vector(0 to 4) := "00000";
    signal var_value : std_logic_vector(23 downto 0);
    
    signal in_dss : std_logic_vector(23 downto 0);
    signal cleared_reset : std_logic;
    signal cleared_load_sec : std_logic;
    signal cleared_load_min : std_logic;
    signal cleared_load_hours : std_logic;
        

begin

    cro: cronometro
    port map (
    clk => clk,
    rst => cleared_reset,
    start_stop => start_stop,
    load_s => cleared_load_sec,
    load_min => cleared_load_min,
    load_h => cleared_load_hours,
    set_s => set_smh(0 to 5),
    set_min => set_smh(0 to 5),
    set_h => set_smh(1 to 5),
    y_secondi => temp_second,
    y_minuti => temp_min,
    y_ore => temp_hours
    );
    
    dss : display_seven_segments
    port map(
    clock => clk,
    reset => cleared_reset,
    value => in_dss,
    ENABLE => "11111111",
    dots => "00010100",
    anodes => anodes_out,
    cathodes => cathodes_out);
    
    encoder_cron : converti_tempo
    Port map(
    sec => temp_second,
    min => temp_min,
    h => temp_hours,
    outP => temp_value
    );
    
    encoder_switch : converti_tempo
    Port map(
    sec => var_second,
    min => var_min,
    h => var_hours,
    outP => var_value
    );
    
    deb_reset : ButtonDebouncer
    Port map (
    RST => '0',
    CLK => clk,
    BTN => rst,
    CLEARED_BTN => cleared_reset);
    
    deb_load_sec : ButtonDebouncer
    Port map (
    RST => '0',
    CLK => clk,
    BTN => load_sec,
    CLEARED_BTN => cleared_load_sec);
    
    deb_load_min : ButtonDebouncer
    Port map (
    RST => '0',
    CLK => CLK,
    BTN => load_min,
    CLEARED_BTN => cleared_load_min);
    
    deb_load_hours : ButtonDebouncer
    Port map(
    RST => '0',
    CLK => CLK,
    BTN => load_h,
    CLEARED_BTN => cleared_load_hours);
    
    selezione : process (CLK, start_stop, cleared_load_sec, cleared_load_min, cleared_load_hours)
    begin
        if rising_edge(CLK) then
            if cleared_reset = '1' then
            var_second <= (others => '0');
            var_min    <= (others => '0');
            var_hours  <= (others => '0');
                elsif start_stop = '0' then
                    if cleared_load_sec = '1' then
                        if unsigned(set_smh) <= 59 then
                            var_second <= set_smh;
                            --in_dss <= var_value;
                        else
                            var_second <= "111011"; -- 59
                        end if;
                        --in_dss <= var_value;
    
                    elsif cleared_load_min = '1' then
                        if unsigned(set_smh) <= 59 then
                            var_min <= set_smh;
                        --in_dss <= var_value;
                        else
                            var_min <= "111011"; -- 59
                        end if;
    
                    elsif cleared_load_hours = '1' then
                        if unsigned(set_smh(1 to 5)) <= 23 then
                            var_hours <= set_smh(1 to 5);
                            --in_dss <= var_value;
                        else
                            var_hours <= "10111"; -- 23
                        end if;
                        --in_dss <= var_value;
                    --else
                        --in_dss <= temp_value;
                    end if;
                --else
                    --in_dss <= temp_value;
                    
            end if;
        end if;
    end process;  
    
    process(clk)
    begin
        if rising_edge(clk) then
            in_dss <= var_value;
        end if;
    end process;        

end Behavioral;
