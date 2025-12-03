----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2025 10:05:08
-- Design Name: 
-- Module Name: UO_B - Behavioral
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

entity UO_B is
  Port (
  clk_b : in std_logic;
  rst_b : in std_logic;
  
  write_mem : in std_logic;
  incr_b : in std_logic;
  rd_uart : in std_logic;
  
  RXD_b : in std_logic;
  last : out std_logic;
  uscita_mem : out std_logic;
  RDA_b : inout std_logic
  );
end UO_B;

architecture Structural of UO_B is


component Rs232RefComp is
    Port ( 
		TXD 	: out std_logic  	:= '1';
    	RXD 	: in  std_logic;					
    	CLK 	: in  std_logic;					--Master Clock
		DBIN 	: in  std_logic_vector (7 downto 0);--Data Bus in
		DBOUT : out std_logic_vector (7 downto 0);	--Data Bus out
		RDA	: inout std_logic;						--Read Data Available(1 quando il dato Ã¨ disponibile nel registro rdReg)
		TBE	: inout std_logic 	:= '1';				--Transfer Bus Empty(1 quando il dato da inviare Ã¨ stato caricato nello shift register)
		RD		: in  std_logic;					--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
		WR		: in  std_logic;					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
		PE		: out std_logic;					--Parity Error Flag
		FE		: out std_logic;					--Frame Error Flag
		OE		: out std_logic;					--Overwrite Error Flag
		RST		: in  std_logic	:= '0'
		);			--Master Reset
end component;

component MEM is
  Port (
  clk : in std_logic;
  wrt : in std_logic;
  addr : in std_logic_vector(3 downto 0);
  d_in : in std_logic_vector(4 downto 0);
  d_out : out std_logic_vector(3 downto 0)
  );
end component;

component Divisore is
  Port (
  x : in std_logic_vector(7 downto 0);
  s : out std_logic_vector(3 downto 0);
  d : out std_logic_vector(3 downto 0)
  );
end component;

component Sommatore4 is
  Port (
  Sx : in std_logic_vector(3 downto 0);
  Dx : in std_logic_vector(3 downto 0);
  Y : out std_logic_vector(4 downto 0)
  );
end component;


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

  
  signal primi4 : std_logic_vector(3 downto 0); -- la prima metà della stringa da sommare 
  signal ultimi4 : std_logic_vector(3 downto 0); -- la seconda metà della stringa da sommare
  signal rx_byte : std_logic_vector(7 downto 0); -- gli 8 bit provenienti da A
  signal somma : std_logic_vector(4 downto 0); -- risultato somma
  signal addr : std_logic_vector(3 downto 0);
  
begin

    UART_B : Rs232RefComp
    Port map(
        TXD => open,
    	RXD	=> RXD_b,
    	CLK	=> clk_b,	--Master Clock
		DBIN => (others => '0'),--Data Bus in
		DBOUT => rx_byte,	--Data Bus out
		RDA	=> RDA_b,				--Read Data Available(1 quando il dato Ã¨ disponibile nel registro rdReg)
		TBE	=> open,			--Transfer Bus Empty(1 quando il dato da inviare Ã¨ stato caricato nello shift register)
		RD => rd_uart,			--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
		WR => '0',				--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
		PE => open, 					--Parity Error Flag
		FE => open,			--Frame Error Flag
		OE => open,		--Overwrite Error Flag
		RST => rst_b
    );
    
    DIV8_4 : Divisore
    port map(
        x => rx_byte,
        s => primi4,
        d => ultimi4
    );
    
    SOMMA4 : Sommatore4
    Port map(
        Sx => primi4,
        Dx => ultimi4,
        Y => somma
    );
    
    CNT : Contatore
    Port map(
        clk => clk_b,
        rst => rst_b,
        A => incr_b,
        value => addr,
        last => open
    );
    
    RAM_B : MEM
    Port map(
        clk => clk_b,
        wrt => write_mem,
        addr => addr,
        d_in => somma,
        d_out => uscita_mem
  );
end Structural;
