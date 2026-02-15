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
    load : out std_logic; 
    req : in std_logic;
    done : out std_logic;
    user_ack : out std_logic;
    ack : out std_logic    
    );
end Unita_Controllo_B_Completo;

architecture Behavioral of Unita_Controllo_B_Completo is

    type STATIB is (IDLE, DISPONIBILE, CARICO_DATI, RISPONDO, CHIUDO, ATTESA_RIS);
    
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
        done <= '0';
        user_ack <= '0';    
        stato_prossimo <= stato;
        
        case stato is
        
            when IDLE =>   
                if req = '1' & okUser='1' then
                    stato_prossimo <= CARICO_DATI;
                else
                    stato_prossimo <= IDLE;
                end if;
                    
            when DISPONIBILE =>
                ack <= '1';
                user_ack <= '1';
                stato_prossimo <= CARICO_DATI;
            
            when CARICO_DATI =>
                load <= '1'; -- “Sto acquisendo il dato che A ha appena reso valido”.
                stato_prossimo <= WAIT_OKUSER;
                
           when RISPONDO => -- "Aspetto che A mi dica che il dato è stabile e posso leggerlo".
                done <= '1';
                if req = '1' then
                    stato_prossimo <= RISPONDO;
                else
                    stato_prossimo <= CHIUDO;
                end if;
                
            when CHIUDO => -- acquisizione vera e propria
                done <= '0';
                stato_prossimo <= ATTESA_RIS;

            when ATTESA_RIS =>
                stato_prossimo <= ATTESA_RIS;

                
        end case;
    end process;     

end Behavioral;
