----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 19:35:47
-- Design Name: 
-- Module Name: UCB - Behavioral
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

entity UCB is
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
end UCB;

architecture Behavioral of UCB is

    type state_type is (IDLE, CARICO_B, COMPARAZIONE, SCRIVO_MEM, ATTIVO_CONT, RISPONDO);
    signal stato, stato_next : state_type;
        
begin
    
    process(clk, rst)
    begin
        if rst = '1' then
            stato <= IDLE;
        elsif rising_edge(clk) then
            stato <= stato_next;
        end if;
    end process;
    
    process (stato , req , match)
    begin
        ack <= '0';
        load_B <= '0';
        wrt <= '0';
        A_cont <= '0';
        stato_next <= stato;
        
        case stato is
        
            when IDLE =>
                if REQ = '1' then
                    stato_next <= CARICO_B;
                else
                    stato_next <= IDLE;
                end if;
            
            when CARICO_B =>
                load_B <= '1';
                stato_next <= COMPARAZIONE;
                
            when COMPARAZIONE =>
                if MATCH = '1' then
                    stato_next <= SCRIVO_MEM;
                else
                    stato_next <= RISPONDO;
                end if;
                
            when SCRIVO_MEM =>
                 wrt <= '1';       
                 stato_next <= ATTIVO_CONT;
                 
            when ATTIVO_CONT =>
                 A_cont <= '1';
                 stato_next <= RISPONDO;
                 
            when RISPONDO =>
                 ack <= '1';
                 if req = '0' then
                    stato_next <= IDLE;
                 else
                    stato_next <= RISPONDO;
                 end if;
           
        end case;
    end process;            
                         
end Behavioral;
