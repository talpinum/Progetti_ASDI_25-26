----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 19:35:47
-- Design Name: 
-- Module Name: B - Behavioral
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

entity B is
  Port (
    clk : in std_logic;
    rst : in std_logic;
    
    data_in : in std_logic_vector(7 downto 0);
    req : in std_logic;
    X : in std_logic_vector(7 downto 0);
    
    ack : out std_logic
  );
end B;

architecture Behavioral of B is

component UCB is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  req : in std_logic;
  match : in std_logic; 
  
  ack : out std_logic;
  load_B : out std_logic;
  wrt : out std_logic;
  A_cont : out std_logic
  );
end component;
    
component Reg_B 
    port(
        clk : in std_logic;
        rst : in std_logic;
        load_B : in std_logic;
        data_in : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end component;

component Comparatore
    port(
        A : in std_logic_vector(7 downto 0);
        X : in std_logic_vector(7 downto 0);
        match : out std_logic
    );
end component;

component contatore
    port(
        clk : in std_logic;
        rst : in std_logic;
        A_cont : in std_logic;
        addr : out std_logic_vector(3 downto 0)
    );
end component;

component RAM
    port(
        clk : in std_logic;
        wrt : in std_logic;
        addr : in std_logic_vector(3 downto 0);
        data_in : in std_logic_vector(7 downto 0)
    );
end component;

    -- UC to Datapath
    signal s_Ab_Reg1, s_WE_Mem, s_En_Cont : std_logic;
    
    -- Datapath to UC
    signal s_MATCH : STD_LOGIC;
    
    -- Dal Datapath
    signal s_Reg_Out : STD_LOGIC_VECTOR (7 downto 0); -- Uscita del registro di ingresso
    signal s_Addr : STD_LOGIC_VECTOR (3 downto 0); -- Indirizzo generato dal contatore

begin

    ControlUnit : UCB
    port map(
      clk => clk,
      rst => rst,
      req => req,
      match => s_MATCH,      
      ack => ACK,
      load_B => s_Ab_Reg1,
      wrt => s_WE_Mem,
      A_cont => s_En_Cont
    );
    
    InputReg : Reg_B
    port map(
        clk => clk,
        rst => rst,
        load_B => s_Ab_Reg1,
        Data_In => Data_In,
        Data_Out => s_Reg_Out
    );
    
    Comparator : Comparatore
    port map(
        A => s_Reg_Out,
        X => X,
        MATCH => s_MATCH 
    );
    
    Counter16 : contatore
    port map(
        clk => clk,
        rst => rst,
        A_cont => s_En_Cont,
        addr => s_Addr
    );
    
    RAM_B : RAM
    port map(
        clk => clk,
        wrt => s_WE_Mem,
        addr => s_Addr,
        data_in => s_Reg_Out
    );
    
end Behavioral;
