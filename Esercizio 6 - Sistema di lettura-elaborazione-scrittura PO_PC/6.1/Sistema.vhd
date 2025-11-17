----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2025 18:55:44
-- Design Name: 
-- Module Name: Sistema - Behavioral
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

entity Sistema is
    Port (
    clk_sis : in std_logic;
    INIZIO : in std_logic;
    RST_sis : in std_logic;
    Y : out std_logic_vector(7 downto 0)
    );
end Sistema;

architecture Structural of Sistema is

      component Contatore is
      generic (
        N: integer := 16;
        addr_width : integer := 4
        );
        
      Port (
        clk: in std_logic;
        rst : in std_logic;
        A : in std_logic; -- proveniente dalla nostra U.C.
        value : out std_logic_vector (addr_width-1 downto 0);
        last : out std_logic -- varrà 1 quando il mio segnale di count varrà N-1
      );
    
    end component;

    component Comparatore is
      Port (
        a : in std_logic_vector(7 downto 0);
        x : in std_logic_vector(7 downto 0);
        y : out std_logic
        -- clk
        -- rst
      );
    end component;

    component MEM is
      generic (
      N : integer := 16;
      ADDR_WIDTH : integer := 4
      );
      
      Port (
        clk: in std_logic;
        rst : in std_logic; -- lo uso per azzerare la memoria
        write : in std_logic; -- write sincrono
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        d_in : in std_logic_vector(7 downto 0);
        d_out : out std_logic_vector(7 downto 0)  
          );
    end component;

    component ROM is
        generic(
            N : integer := 16; -- Le N locazioni
            ADDR_WIDTH : integer := 4
        );
        
        port (
            clk : in std_logic;
            rst : in std_logic;
            address: in STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            content: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    component Control_unit is
        Port (
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        match : in std_logic; -- dal comparatore in modo tale che c'è il match e faccio partire write
        last : in std_logic; -- dal contatore e capisco che devo fare done
        wrt : out std_logic; -- write sincrono su MEM
        read : out std_logic; -- read sincrono su ROM
        A_cont : out std_logic; -- abilitiamo il contatore
        done : out std_logic
        );
    end component;
    
    signal write_sig : std_logic;
    signal read_sig : std_logic;
    signal A_sig : std_logic;
    signal last_sig : std_logic;
    signal done_sig : std_logic;
    
    signal addr : std_logic_vector(3 downto 0);
    signal rom_out : std_logic_vector(7 downto 0);
    signal mem_out : std_logic_vector(7 downto 0);
    signal comparatore_out : std_logic;
    
begin

    UC : Control_unit 
    PORT MAP(
    clk => clk_sis,
    rst => rst_sis,
    start => INIZIO,
    match => comparatore_out,
    last => last_sig,
    wrt => write_sig,
    read => read_sig,
    A_cont => A_sig,
    done => done_sig
    );
    
    CNT: Contatore
    PORT MAP(
    clk => clk_sis,
    rst => rst_sis,
    A => A_sig,
    value => addr,
    last => last_sig
    );
    
    ROM_A: ROM
    PORT MAP(
    clk => clk_sis,
    rst => rst_sis,
    address => addr,
    content => rom_out
    );
    
    COMP: Comparatore
    PORT MAP(
    a => rom_out,
    x => "10101010",
    y => comparatore_out
    );
    
    MEM_E: MEM
    PORT MAP(
    clk => clk_sis,
    rst => rst_sis,
    write => write_sig,
    addr => addr,
    d_in => rom_out,
    d_out => mem_out
    );
    
    Y<= mem_out;

end Structural;
