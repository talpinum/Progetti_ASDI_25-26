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

entity PO is
    Port (
    clk   : in std_logic;
    rst   : in std_logic;

    read  : in std_logic;   -- da UC
    wrt   : in std_logic;   -- da UC
    A_cont: in std_logic;   -- da UC

    last  : out std_logic;  -- verso UC
    match : out std_logic;  -- verso UC

    Y     : out std_logic_vector(7 downto 0)
    );
end PO;

architecture Structural of PO is

  component Contatore is
    generic (
      N : integer := 16;
      addr_width : integer := 4
    );
    Port (
      clk  : in std_logic;
      rst  : in std_logic;
      A    : in std_logic;
      value: out std_logic_vector(addr_width-1 downto 0);
      last : out std_logic
    );
  end component;

  component ROM is
    generic(
        N : integer := 16; -- Le N locazioni
        ADDR_WIDTH : integer := 4 -- quanti bit servono per indirizzare N locazioni
    );
    port (
        clk : in std_logic;
        read : in std_logic;
        address: in STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        content: out STD_LOGIC_VECTOR(7 downto 0) -- valore letto, 8 bit
        );
  end component;

  component Comparatore is
    generic (
    X : std_logic_vector(7 downto 0) := "00000011"
  );
    Port (
      a : in std_logic_vector(7 downto 0);
      o : out std_logic
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

  signal addr_s     : std_logic_vector(3 downto 0);
  signal rom_out_s  : std_logic_vector(7 downto 0);
  signal mem_out_s  : std_logic_vector(7 downto 0);

begin

  -- CONTATORE
  CNT : Contatore
    port map (
      clk   => clk,
      rst   => rst,
      A     => A_cont,
      value => addr_s,
      last  => last
    );

  -- ROM
  ROM_A : ROM
    port map (
      clk     => clk,
      read    => read,
      address => addr_s,
      content => rom_out_s
    );

  -- COMPARATORE
  COMP : Comparatore
    port map (
      a => rom_out_s,
      o => match
    );

  -- MEMORIA
  MEM_A : MEM
    port map (
      clk   => clk,
      write => wrt,
      addr  => addr_s,
      rst => rst,
      d_in  => rom_out_s,
      d_out => mem_out_s   
    );

  -- USCITA SU LED
 Y <= mem_out_s;
 --Y <= rom_out_s when wrt = '1' else (others => '0');
 --Y <= rom_out_s when read = '1' else
    -- mem_out_s when wrt  = '1' else
  --  (others => '0');

end Structural;
