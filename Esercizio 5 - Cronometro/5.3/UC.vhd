----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.01.2026 16:23:14
-- Design Name: 
-- Module Name: UC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port(
        clk : in std_logic;
        rst : in std_logic;
        wr_mem : in std_logic;
        start_stop : in std_logic;
        load_sec : in std_logic;
        load_min : in std_logic;
        load_hours : in std_logic;
        set_smh : in std_logic_vector(0 to 5);
        anodes_out : out std_logic_vector (7 downto 0);
        cathodes_out : out std_logic_vector (7 downto 0)
        );
    end UC;

architecture Behavioral of UC is

    component cronometro is
    Port (
    clk : in std_logic;
    rst : in std_logic;
    start_stop : in std_logic;
    load_s : in std_logic;
    load_min : in std_logic;
    load_h : in std_logic;
    set_s : in std_logic_vector(0 to 5) := "000000";
    set_min : in std_logic_vector(0 to 5) := "000000";
    set_h : in std_logic_vector(0 to 4):= "00000";
    y_secondi : out std_logic_vector(0 to 5);
    y_minuti : out std_logic_vector(0 to 5);
    y_ore : out std_logic_vector(0 to 4)
    );
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
          sec : in std_logic_vector(5 downto 0);
          min : in std_logic_vector(5 downto 0);
          h : in std_logic_vector(4 downto 0);
          outP : out std_logic_vector(23 downto 0)
        );
    end component;

    component gestore_mem is
    Port (
        clk_gestore : in std_logic;
        start_gestore : in std_logic;
        en_gestore : in std_logic;
        reset_gestore: in std_logic;
        input_gestore : in std_logic_vector(16 downto 0);
        output_gestore : out std_logic_vector(23 downto 0)
    );
    end component;
    
    signal temp_second : std_logic_vector(0 to 5);
    signal temp_min : std_logic_vector(0 to 5);
    signal temp_hours : std_logic_vector(0 to 4);
    signal temp_value : std_logic_vector(23 downto 0);
    signal temp_out_gestore : std_logic_vector(23 downto 0);
    signal temp_in_gestore : std_logic_vector(16 downto 0);
    signal var_second : std_logic_vector(0 to 5) := "000000";
    signal var_min : std_logic_vector(0 to 5) := "000000";
    signal var_hours : std_logic_vector(0 to 4) := "00000";
    signal var_value : std_logic_vector(23 downto 0);
    signal in_dss : std_logic_vector(23 downto 0);
    signal cleared_reset : std_logic;
    signal cleared_load_sec : std_logic;
    signal cleared_load_min : std_logic;
    signal cleared_load_hours : std_logic;
    signal cleared_wr_mem : std_logic;
    signal start_stop_sync : std_logic;
    

begin

    cro: cronometro
    PORT MAP (
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
    PORT MAP(
    clock => clk,
    reset => cleared_reset,
    value => in_dss,
    enable => "11111111",
    dots => "00010100",
    anodes => anodes_out,
    cathodes => cathodes_out
    );
    
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
    
    gestore_memoria : gestore_mem
    PORT MAP(
    clk_gestore => clk,
    start_gestore => start_stop,
    en_gestore => cleared_wr_mem,
    reset_gestore => rst,
    input_gestore => temp_in_gestore,
    output_gestore => temp_out_gestore
    );
    
    deb_reset : ButtonDebouncer
    PORT MAP ( RST => '0',
    CLK => clk,
    BTN => rst,
    CLEARED_BTN => cleared_reset);

    deb_load_sec : ButtonDebouncer
    PORT MAP ( RST => '0',
    CLK => clk,
    BTN => load_sec,
    CLEARED_BTN => cleared_load_sec);
 
    deb_load_min : ButtonDebouncer
    PORT MAP ( RST => '0',
    CLK => CLK,
    BTN => load_min,
    CLEARED_BTN => cleared_load_min);
  
    deb_load_hours : ButtonDebouncer
    PORT MAP ( RST => '0',
    CLK => CLK,
    BTN => load_hours,
    CLEARED_BTN => cleared_load_hours);

    deb_wr_mem : ButtonDebouncer
    PORT MAP ( RST => '0',
    CLK => CLK,
    BTN => wr_mem,
    CLEARED_BTN => cleared_wr_mem);
    
    process (CLK, start_stop, cleared_load_sec,
cleared_load_min, cleared_load_hours, cleared_wr_mem)
    begin
        if rising_edge(CLK) then
            start_stop_sync <= start_stop;
            if start_stop_sync = '0' then
                if cleared_load_sec = '1' then
                    var_second <= set_smh;
                    in_dss <= var_value;
                elsif cleared_load_min = '1' then
                    var_min <= set_smh;
                    in_dss <= var_value;
                elsif cleared_load_hours = '1' then
                    var_hours <= set_smh(1 TO 5);
                    in_dss <= var_value;
                elsif cleared_wr_mem = '1' then
                    in_dss <= temp_out_gestore;
                end if;
            else
                if cleared_wr_mem = '1' then
                    temp_in_gestore <= temp_hours & temp_min & temp_second;
                end if;
                in_dss <= temp_value;
            end if;
        end if;
    end process;
    
--process(clk)
--begin
--if rising_edge(clk) then
 --       start_stop_sync <= start_stop;
 --   end if;
--end process;
end Behavioral;
