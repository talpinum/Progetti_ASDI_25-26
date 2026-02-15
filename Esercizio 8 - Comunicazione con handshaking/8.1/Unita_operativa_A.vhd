----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2025 11:51:24
-- Design Name: 
-- Module Name: Unita_operativa_A - Behavioral
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

entity Unita_operativa_A is
    Port (
    clk_o : in std_logic;
    rst_o : in std_logic;
    load_reg : in std_logic;
    A_cont : in std_logic;
    last_o : out std_logic;
    Y : out std_logic_vector(7 downto 0)
    );
end Unita_operativa_A;


architecture structural of Unita_operativa_A is
    component ROM is
       -- generic(
            --N : integer := 16; -- Le N locazioni
          --  ADDR_WIDTH : integer := 4
        --);
        port (           
            address: in STD_LOGIC_VECTOR(3 downto 0);
            content: out STD_LOGIC_VECTOR(7 downto 0)
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

    component registro_pipo is
        generic (
            N : integer := 8
        );
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            load  : in  std_logic;
            d_in  : in  std_logic_vector(N-1 downto 0);
            q_out : out std_logic_vector(N-1 downto 0)
        );
    end component;
   
   signal addr : std_logic_vector(3 downto 0);
   signal rom_out : std_logic_vector(7 downto 0);
   signal reg_out   : std_logic_vector(7 downto 0);
   signal last_sig : std_logic;
   
begin
    ROM_A : ROM
    port map(
        address => addr,
        content => rom_out
    );
    
    Contatore_A : Contatore
    port map(
        clk => clk_o,
        rst => rst_o,
        A => A_cont,
        value => addr,
        last => last_sig
    );

    REG_A : registro_pipo
        generic map(
            N => 8
        )
        port map(
            clk   => clk_o,
            rst   => rst_o,
            load  => load_reg,        -- carica quando load_reg = 1
            d_in  => rom_out,
            q_out => reg_out
        );
    
    -- uscite U.O.A
    last_o <= last_sig;
    Y <= reg_out;
    
end structural;
