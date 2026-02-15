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

entity Unita_Controllo_B is
    Port (
    clk : in std_logic;
    rst : in std_logic;
    load : out std_logic;
    req : in std_logic;
    ack : out std_logic    
    );
end Unita_Controllo_B;

architecture Behavioral of Unita_Controllo_B is

    type STATIB is (IDLE, CARICO_DATI, SEND_ACK, CHIUDO, ATTESA_RISULTATO);
    
    signal stato_prossimo : STATIB;
    signal stato : STATIB;
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stato <= IDLE;
            else
                stato <= stato_prossimo;
            end if;
        end if;
    end process;
    
    
    process (stato, req)
    begin
        ack <= '0';
        load <= '0';
        stato_prossimo <= stato;
        
        case stato is
        
            when IDLE =>   
                if req = '1' then
                    stato_prossimo <= CARICO_DATI;
                else
                    stato_prossimo <= IDLE;
                end if;
            
            when CARICO_DATI =>
                load <= '1';
                stato_prossimo <= SEND_ACK;
            
            when SEND_ACK =>
                ack <= '1';
                if req = '0' then
                    stato_prossimo <= CHIUDO;
                else
                    stato_prossimo <= SEND_ACK;
                end if;
             
            when CHIUDO =>
                ack <= '0';
                
                stato_prossimo <= ATTESA_RISULTATO;  

            when ATTESA_RISULTATO =>
                stato_prossimo <= IDLE;
                
        end case;
    end process;     

end Behavioral;
