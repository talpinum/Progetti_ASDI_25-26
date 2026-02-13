----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 19:35:47
-- Design Name: 
-- Module Name: A - Behavioral
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

entity A is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  start : in std_logic;
  ack : in std_logic; 
  req :  out std_logic;
  data_out : out std_logic_vector(7 downto 0)
  );
  end A;

architecture Structural of A is

component UCA is
  Port (
    clk : in std_logic;
    rst : in std_logic;
    start : in std_logic;
    ack : in std_logic;
    fine : in std_logic; -- letto tutte le locazioni
    Mul_done : in std_logic; -- Booth ha finito
    
    A_cont : out std_logic;
    load_first : out std_logic;
    load_second : out std_logic;
    start_booth : out std_logic;
    load_R2 : out std_logic;
    req : out std_logic
  );
end component;

component Counter_4
    Port (
        clk , rst , A_Cont : in STD_LOGIC ;
        Count : out STD_LOGIC_VECTOR (3 downto 0);
        fine : out STD_LOGIC
        );
end component;

component ROM_A
    Port(
        addr : in std_logic_vector(3 downto 0);
        data : out std_logic_vector(3 downto 0)
    );
end component;

component Reg_A
     Port(
        clk , rst , load_First , load_Second : in STD_LOGIC ;   
        Data_In : in STD_LOGIC_VECTOR (3 downto 0);
        Data_Out : out STD_LOGIC_VECTOR (7 downto 0)
     );
end component;

component Booth
	 port( clock, reset, start: in std_logic;
		   X, Y: in std_logic_vector(3 downto 0);		   
		   --stop: out std_logic;	--a che serve?	   
		   P: out std_logic_vector(7 downto 0); -- prodotto
		   
		   -- AGGIUNTA NECESSARIA: Segnale di fine operazione(Collegato al fine del counter in Booth)
		   
		   done : out std_logic
    );
end component;    

component reg_AtoB -- Registro di interfaccia per il dato che deve andare da A a B
    Port(
    clk, rst, load_R2 : in std_logic;
    d : in std_logic_vector(7 downto 0);
    q : out std_logic_vector(7 downto 0)
    );
end component;

    signal s_CMAX_Count , s_Mul_Done : std_logic;
    signal s_En_Cont , s_Load_First , s_Load_Second , s_Start_Mul , s_En_R2 : std_logic;
    signal s_Addr , s_Rom_Data : std_logic_vector(3 downto 0);
    signal s_RegOp_Out , s_Mul_Res : std_logic_vector(7 downto 0);
    
begin

    inst_UC : UCA
    port map(
    CLK => CLK, RST => RST, START => START, ACK => ACK,
    fine => s_CMAX_Count,
    Mul_Done => s_Mul_Done, -- Collegato al DONE del moltiplicatore
    A_Cont => s_En_Cont,
    Load_First => s_Load_First,
    Load_Second => s_Load_Second,
    start_booth => s_Start_Mul,
    load_R2 => s_En_R2,
    REQ => REQ
    );
    
    inst_ROM : ROM_A
    port map(
        Addr => s_Addr,
        Data => s_Rom_Data
    );
    
    inst_RegOp : Reg_A
    port map(
        CLK => CLK, RST => RST,
        Load_First => s_Load_First, Load_Second => s_Load_Second,
        Data_In => s_Rom_Data,
        Data_Out => s_RegOp_Out
    );
    
    inst_Booth : Booth
    port map (
        clock => CLK, reset => RST,
        START => s_Start_Mul,
        Y => s_RegOp_Out (7 downto 4),
        X => s_RegOp_Out (3 downto 0),
		P => s_Mul_Res,
		done => s_Mul_Done
    );
    
    inst_RegOut : reg_AtoB
    port map(
        CLK => CLK, RST => RST,
        load_R2 => s_En_R2,
        D => s_Mul_Res,
        Q => Data_Out
    );
        
end Structural;
