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
        start : in std_logic;
        okUser : in std_logic;

        resultB : out std_logic_vector(4 downto 0);
        ok_user_B : out std_logic
    );
end Sistema_C;

architecture Structural of A_B_System is

    component A_Completo
        Port (
            clkA : in std_logic;
            rstA : in std_logic;
            startA : in std_logic;
            ackA : in std_logic;
            reqA : out std_logic;
            ok_user_ackA : in std_logic;
            doneA : in std_logic;
            dataA : out std_logic_vector(7 downto 0)
        );
    end component;

    component B_Completo
        Port (
            clkB : in std_logic;
            rstB : in std_logic;
            req : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            ack : out std_logic;
            okUser : in std_logic;
            ok_user_B : out std_logic;
            done : out std_logic;
            resultB : out std_logic_vector(4 downto 0)
        );
    end component;

    signal req_sig       : std_logic;
    signal ack_sig       : std_logic;
    signal data_sig      : std_logic_vector(7 downto 0);
    signal ok_user_sig   : std_logic;
    signal done_sig : std_logic;


begin

    -- BLOCCO A
    A_inst : A_Completo
        port map(
            clkA => clk,
            rstA => rst,
            startA => start,
            ackA => ack_sig,
            reqA => req_sig,
            ok_user_ackA => ok_user_sig,
            doneA => done_sig,        -- ATTENZIONE: segnale fittizio
            dataA => data_sig
        );

    -- BLOCCO B
    B_inst : B_Completo
        port map(
            clkB => clk,
            rstB => rst,
            req => req_sig,
            data_in => data_sig,
            ack => ack_sig,
            okUser => okUser,
            ok_user_B => ok_user_sig,
            done => done_sig,        -- esce verso A
            resultB => resultB
        );

    ok_user_B <= ok_user_sig;

end Structural;


