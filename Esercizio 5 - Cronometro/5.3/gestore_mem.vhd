----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.01.2026 16:11:25
-- Design Name: 
-- Module Name: gestore_mem - Behavioral
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

entity gestore_mem is
  Port (
    clk_gestore : in std_logic;
    start_gestore : in std_logic;
    en_gestore : in std_logic;
    reset_gestore: in std_logic;
    input_gestore : in std_logic_vector(16 downto 0);
    output_gestore : out std_logic_vector(23 downto 0)
  );
end gestore_mem;

architecture Behavioral of gestore_mem is

component MEM is
    generic (
         LEN_ADD : positive := 2 -- 2^LEN_ADD locazioni
    );
    port (
        clk_mem : in  std_logic;
        wrt : in  std_logic; -- write enable
        read : in  std_logic; -- read enable (bottone)
        address : in  std_logic_vector(LEN_ADD-1 downto 0);
        inp_val : in  std_logic_vector(16 downto 0);
        out_val : out std_logic_vector(16 downto 0)
    );
end component;

component contatore is
    generic (
        LEN_ADD : positive := 2  -- 2^4 = 16 locazioni
    );
    port (
        clk : in  std_logic;
        reset : in  std_logic;
        en_count : in  std_logic;
        y : out std_logic_vector(LEN_ADD-1 downto 0)
    );
end component;

component converti_tempo is
    Port (
        sec : in std_logic_vector(0 to 5);
        min : in std_logic_vector(0 to 5);
        h : in std_logic_vector(0 to 4);
        outP : out std_logic_vector(23 downto 0)
    );
end component;

    signal temp_out_counter_write : std_logic_vector(1 downto 0);
    signal temp_out_mem : std_logic_vector(16 downto 0);
    signal temp_address : std_logic_vector(1 downto 0);
    signal temp_out_counter_read : std_logic_vector(1 downto 0);
    signal temp_write : std_logic;
    signal temp_read : std_logic;
    signal en_count_read: std_logic;
    signal en_count_write: std_logic;
    signal en_gestore_q : std_logic;
    signal start_gestore_q : std_logic;

    
    type STATO is (IDLE, COUNT_WRITE, COUNT_READ, WRITE, READ);
    signal stato_corrente : STATO := IDLE;
    signal stato_prossimo : STATO;

begin

    counter_mem_write : contatore
    port map(
    clk => clk_gestore,
    reset => reset_gestore,
    en_count => en_count_write,
    y => temp_out_counter_write
    );

    ounter_mem_read : contatore
    port map(
    clk => clk_gestore,
    reset => reset_gestore,
    en_count => en_count_read,
    y => temp_out_counter_read
    );
    
    MEMORIA : MEM
    Port map(
    clk_mem => clk_gestore,
    wrt => temp_write,
    read => temp_read,
    address => temp_address,
    inp_val => input_gestore,
    out_val => temp_out_mem
    );
    
    encoder_gestore : converti_tempo
    Port map(
    sec => temp_out_mem(5 downto 0),
    min => temp_out_mem(11 downto 6),
    h => temp_out_mem(16 downto 12),
    outP => output_gestore
    );


    process(start_gestore, en_gestore)
    begin
       -- stato_prossimo   <= stato_corrente;
       -- en_count_write   <= '0';
      --  en_count_read    <= '0';
     --   temp_write       <= '0';
     --   temp_read        <= '0';
       -- temp_address     <= (others => '0');
        
        case stato_corrente is
            when IDLE =>
            if start_gestore = '1' and en_gestore = '1' then
                en_count_write <= '1';
                stato_prossimo <= COUNT_WRITE;
            elsif start_gestore = '0' and en_gestore = '1' then
                en_count_read <= '1';
                stato_prossimo <= COUNT_READ;
            else
                stato_prossimo <= IDLE;
            end if;
        
            when COUNT_WRITE =>
                en_count_write <= '0';
                temp_write <= '1';
                temp_address <= temp_out_counter_write;
                stato_prossimo <= WRITE;

            when WRITE =>
                temp_write <= '0';
                stato_prossimo <= IDLE;
                
            when COUNT_READ =>
                en_count_read <= '0';
                temp_address <= temp_out_counter_read;
                temp_read <= '1';
                stato_prossimo <= READ;

            when READ =>
                temp_read <= '0';
                stato_prossimo <= IDLE;
        end case;
    end process;
    
    process(clk_gestore)
    begin
        if rising_edge(clk_gestore) then
            stato_corrente <= stato_prossimo;
        end if;
    end process;
    
end Behavioral;
