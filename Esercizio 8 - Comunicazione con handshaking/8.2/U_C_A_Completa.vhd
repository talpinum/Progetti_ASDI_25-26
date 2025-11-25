----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2025 11:11:11
-- Design Name: 
-- Module Name: Unita_controllo_A - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Addit----------------------------------------------------------------------------------
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

entity U_C_A_Completa is
 Port (
 clk : in std_logic;
 rst : in std_logic;
 start : in std_logic;
 last : in std_logic;
 A_cont : out std_logic;
 read : out std_logic;
 
 -- comandi protocollo --
 ack : in std_logic;
 req : out std_logic;
 ok_user_ack : in std_logic;
 
 -- la fine -- 
 done : out std_logic
 );
end U_C_A_Completa;

architecture Behavioral of U_C_A_Completa is

    type STATI is (IDLE, READ_ROM, SEND_REQ, INCR, CHECK_LAST, FINE);
    
    signal stato_next: STATI;
    signal stato: STATI;
    
begin

    process(clk) 
    begin
        if rising_edge(clk) then
            if rst = '1' then 
                stato <= IDLE;
            else
                stato <= stato_next;
            end if;
        end if;
    end process;
    
    process(stato, start, ack, last)
    begin
        read <= '0';
        req <= '0';
        done <= '0';
        A_cont <= '0';
        stato_next <= stato;
        
        case stato is
            when IDLE =>
                if start = '1' then
                    stato_next <= READ_ROM;
                else
                    stato_next <= IDLE;
                end if;
             
             when READ_ROM =>
                read <= '1'; -- abilito la rom
                stato_next <= SEND_REQ;
        
            when SEND_REQ =>
                req <= '1';
                if ack = '1' then
                    stato_next <= INCR;
                end if;
            
            when INCR =>
                req <= '0';
                if ack = '0' and ok_user_ack = '1' then
                    A_cont <= '1';
                    stato_next <= CHECK_LAST;
                end if;
            
            when CHECK_LAST =>
                if last = '1' then
                    stato_next <= FINE;
                else
                    stato_next <= READ_ROM;
                end if;
                    
            when FINE =>
                done <= '1';
                stato_next <= IDLE;
            
        end case;
    end process; 
end Behavioral;

