----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 19:35:47
-- Design Name: 
-- Module Name: UCA - Behavioral
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

entity UCA is
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
end UCA;


architecture Behavioral of UCA is

    type state_type is (IDLE, CARICO_1, ATTIVO_CONT, CARICO_2, AVVIO_CONT_ANCORA, AVVIO_BOOTH, ASPETTO_BOOTH, RICHIESTA, WAITACK0);
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
    
    
    process(stato, start, ack, fine, Mul_done)
    begin
        A_cont <= '0'; load_first <= '0'; load_second <= '0'; 
        start_booth <= '0'; load_R2 <= '0'; req <= '0';
        stato_next <= stato;
        
        case stato is
            
            when IDLE =>
            if START = '1' then
                stato_next <= CARICO_1;
            else
                stato_next <= IDLE;
            end if;
            
            when CARICO_1 =>
                load_first <= '1';
                stato_next <= ATTIVO_CONT;
                
            when ATTIVO_CONT =>
                A_cont <= '1';
                stato_next <= CARICO_2;
            
            when CARICO_2 =>
                load_second <= '1';
                stato_next <= AVVIO_CONT_ANCORA;
                 
            when AVVIO_CONT_ANCORA =>
                A_cont <= '1';     
                stato_next <= AVVIO_BOOTH;
                
            when AVVIO_BOOTH =>
                start_booth <= '1'; -- Impulso di Start per il moltiplicatore
                stato_next <= ASPETTO_BOOTH;
                
            when ASPETTO_BOOTH =>
                start_booth <= '0';
                if Mul_Done = '1' then
                   stato_next <= RICHIESTA;
                else
                    stato_next <= ASPETTO_BOOTH;
                end if; 
                
            when RICHIESTA =>
                load_R2 <= '1'; -- salviamo il risultato
                req <= '1'; -- inviamo richiesta
                if ACK = '1' then
                    stato_next <= WAITACK0;
                else
                    stato_next <= RICHIESTA;
                end if;
                
            when WAITACK0 =>
                req <= '0';
                if ACK = '0' then
                    if fine = '1'then
                        stato_next <= IDLE;
                    else
                        stato_next <= CARICO_1;   
                    end if;
                end if;
                
        end case;        
    end process;            

end Behavioral;
