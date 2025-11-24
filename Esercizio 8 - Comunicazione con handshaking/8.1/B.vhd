----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2025 15:30:35
-- Design Name: 
-- Module Name: Unita_Operativa_B - Behavioral
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
        clkB : in std_logic;
        rstB : in std_logic;
        req : in std_logic; -- da nodo A
        data_in : in std_logic_vector(7 downto 0); -- da nodo A
        ack : out std_logic;
        resultB : out std_logic_vector(4 downto 0)
    );
end B;
    

    
architecture Structural of B is
        component Unita_Controllo_B
        Port (
            clk : in std_logic;
            rst : in std_logic;
            load : out std_logic;
            req : in std_logic;
            ack : out std_logic
        );
    end component;

    component Unita_Operativa_B
        Port (
            clk_o : in std_logic;
            rst_o : in std_logic;
            load : in std_logic;
            data_out : out std_logic_vector(4 downto 0);
            data_in : in std_logic_vector(7 downto 0)
        );
    end component;
    
    signal load_sig : std_logic;
    signal ack_sig : std_logic;
    signal risultato : std_logic_vector(4 downto 0);
begin

    UC_B : Unita_Controllo_B
        port map(
            clk => clkB,
            rst => rstB,
            load => load_sig,
            req => req,
            ack => ack_sig
        );

    UO_B : Unita_Operativa_B
        port map(
            clk_o => clkB,
            rst_o => rstB,
            load => load_sig,
            data_out => risultato,
            data_in => data_in
        );

    ack <= ack_sig;
    resultB <= risultato;


end Structural;
