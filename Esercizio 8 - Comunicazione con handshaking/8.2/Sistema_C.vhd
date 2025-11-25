----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2025 18:22:53
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

entity Sistema_C is
    Port (
    clk : in std_logic;
    rst : in std_logic;
    result : out std_logic_vector(4 downto 0);
    okUser  : in std_logic;
    start : in std_logic
    );
end Sistema_C;

architecture Structural of Sistema_C is

    signal req_sig : std_logic;
    signal ack_sig : std_logic;
    signal dato_sig : std_logic_vector(7 downto 0);
    signal ok_user_B_sig  : std_logic; -- da B verso A
 
 component A_Completo is   
     Port (
         clk_A : in std_logic;
         rst_A : in std_logic;
         start_A : in std_logic;
         ack_A : in std_logic;
         ok_user_ack_A : in std_logic;
         req_A : out std_logic;
         dato_A : out std_logic_vector(7 downto 0)
     );
 end component;
 
 component B_Completo is
    Port (
        clkB : in std_logic;
        rstB : in std_logic;
        req : in std_logic; -- da nodo A
        data_in : in std_logic_vector(7 downto 0); -- da nodo A
        ack : out std_logic;
        okUser : in std_logic;
        ok_user_B : out std_logic;
        resultB : out std_logic_vector(4 downto 0)
    );
 end component;
    
begin
    
    A_inst : A_Completo
        port map(
            clk_A => clk,
            rst_A => rst,
            start_A => start,
            ack_A => ack_sig,       -- input da B
            req_A => req_sig,       -- output verso B
            ok_user_ack_A => ok_user_B_sig, -- feedback da B
            dato_A => dato_sig      -- output dati verso B
        );
        
    -- Nodo B
    B_inst : B_Completo
        port map(
            clkB => clk,
            rstB => rst,
            req => req_sig,         -- input da A
            ack => ack_sig,         -- output verso A
            data_in => dato_sig,    -- input dati da A
            okUser => okUser, -- utente
            ok_user_B => ok_user_B_sig, -- verso A
            resultB => result       -- output risultato
        );

end Structural;

