----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2025 16:16:39
-- Design Name: 
-- Module Name: UO_A - Behavioral
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

entity UO_A is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  -- comandi dalla UC
  ROM_A : in std_logic;
  UART_WR : in std_logic;
  INCR_A : in std_logic;
  
  -- l'UART
  TBE : out std_logic;
  txd : out std_logic
  );
end UO_A;

architecture Structural of UO_A is

component ROM is
  Port (
    address : in std_logic_vector(3 downto 0);
    content : out std_logic_vector(7 downto 0)
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
		RST		: in  std_logic	:= '0');			--Master Reset
end component;

    signal addr:  std_logic_vector(3 downto 0);
    signal rom_data : std_logic_vector(7 downto 0);
    
    signal rda : std_logic;
    signal tbe_i : std_logic;
    signal PE_i : std_logic;
    signal FE_i : std_logic;
    signal OE_i : std_logic;

begin

    CNT : Contatore
    port map(
        clk => clk,
        rst => rst,
        A => INCR_A,
        value => addr,
        last => open -- sto cercando di capire se serve oppure no il contatore
    );    

    ROMA : ROM -- non me la fa chiamare ROM_A e non capisco il perché quindi DAJE
    port map(
        address => addr,
        content => rom_data
    );
    
    UART_A : Rs232RefComp
    Port map( 
		TXD => txd,
    	RXD => '1', -- A non riceve niente					
    	CLK => clk,
		DBIN => rom_data,
		DBOUT => open,
		RDA	=> rda,
		TBE	=> tbe_i,
		RD => '0',
		WR => UART_WR,
		PE => pe_i,
		FE => fe_i,
		OE => oe_i,
		RST => rst
	);
	
	TBE <= tbe_i;

end Structural;
