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

entity Unita_controllo_A is
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
 
  
 done : out std_logic
 );
end Unita_controllo_A;

architecture Behavioral of Unita_controllo_A is

    type STATI is (IDLE, READ_ROM, CARICO, SEND_REQ, WAITACK0, INCR);
    
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
        load_A <= '0';
        A_cont <= '0';
        done <= '0';
        stato_next <= stato;
        
        case stato is
            when IDLE =>
                if start = '1' then
                    stato_next <= READ_ROM;
                else
                    stato_next <= IDLE;
                end if;
             
             when READ_ROM =>
                
                 stato_next <= SEND_REQ;

            when CARICO => 
                 
                 load_A <= '1';
                 stato_next <= SEND_REQ;

            when SEND_REQ =>
                req <= '1';
                if ack = '1' then
                    stato_next <= WAITACK0;
                else  
                    stato_next <= SEND_REQ;
                end if;
                 
            when WAITACK0 =>
          
                if ack = '1' then
                    stato_next <= WAITACK0;
                else
                    stato_next <= INCR;
                end if;    
                 
            when INCR =>
                A_cont <= '1';
                if done = '1' then
                 stato_next <= IDLE;
                else
                 stato_next <= READ_ROM;
               end if;
            
        end case;
    end process; 
end Behavioral;

