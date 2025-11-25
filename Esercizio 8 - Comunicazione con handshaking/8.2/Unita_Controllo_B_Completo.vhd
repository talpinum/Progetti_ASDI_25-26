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

entity Unita_Controllo_B_Completo is
    Port (
    clk : in std_logic;
    rst : in std_logic;
    okUser : in std_logic;
    load : out std_logic; -- dice all'UO di campionare il byte
    req : in std_logic;
    ack : out std_logic    
    );
end Unita_Controllo_B_Completo;

architecture Behavioral of Unita_Controllo_B_Completo is

    type STATIB is (IDLE, CARICO_DATI, WAIT_OKUSER, SEND_ACK, ACK0);
    
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
                load <= '1'; -- “Sto acquisendo il dato che A ha appena reso valido”.
                stato_prossimo <= WAIT_OKUSER;
                
           when WAIT_OKUSER => -- "Aspetto che A mi dica che il dato è stabile e posso leggerlo".
                if okUser = '1' then
                    stato_prossimo <= SEND_ACK;
                end if;
                
            when SEND_ACK => -- acquisizione vera e propria
                ack <= '1'; -- ack = 1 → "Ho ricevuto e processato il dato"
                if req = '0' then
                    stato_prossimo <= ACK0;
                else
                    stato_prossimo <= SEND_ACK;
                end if;
             
            when ACK0 =>
                ack <= '0'; -- quando ho finito → "Sono pronto al prossimo dato"
                if req = '0' then
                    stato_prossimo <= IDLE;   
                end if; 
        end case;
    end process;     

end Behavioral;
