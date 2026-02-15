----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2025 09:00:46
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
 clk_A : in std_logic;
 rst_A : in std_logic;
 start_A : in std_logic;
 ack_A : in std_logic;
 req_A : out std_logic;
 dato_A : out std_logic_vector(7 downto 0)
 );
end A;

architecture Structural of A is
 component Unita_controllo_A is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        last : in std_logic;
        A_cont : out std_logic;
        load_A : out std_loigc;
         
        -- comandi protocollo --
        ack : in std_logic;
        req : out std_logic;
        
        -- la fine -- 
        done : out std_logic
    );
 end component;

 component Unita_operativa_A is
    Port (
        clk_o : in std_logic;
        rst_o : in std_logic;
        read : in std_logic;
        A_cont : in std_logic;
        last_o : out std_logic;
        Y : out std_logic_vector(7 downto 0)
    );
 end component;
 
    signal last_sig  : std_logic;
    signal read_sig  : std_logic;
    signal A_cont_sig: std_logic;
    signal done_sig  : std_logic;
    signal data_sig  : std_logic_vector(7 downto 0);
    
begin

    UC_A : Unita_controllo_A
    port map(
        clk => clk_A,
        rst => rst_A,
        start => start_A,
        last => last_sig,
        A_cont => A_cont_sig,
        read => read_sig,
         
        -- comandi protocollo --
        ack => ack_A,
        req => req_A,
        
        -- la fine -- 
        done => done_sig
    );
    
    UO_A : Unita_operativa_A
    port map(
        clk_o => clk_A,
        rst_o => rst_A,
        read => read_sig,
        A_cont => A_cont_sig,
        last_o => last_sig,
        Y => data_sig
    );
    
    dato_A <= data_sig;
    
end Structural;
