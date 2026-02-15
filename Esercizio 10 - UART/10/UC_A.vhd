----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2025 16:16:39
-- Design Name: 
-- Module Name: UC_A - Behavioral
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

entity UC_A is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  start : in std_logic;
  last : in std_logic;
  
  TBE : in std_logic; -- TBE della UART
  
  --ROM_A : out std_logic; -- Abilitiamo la lettura ROM
  INCR_A: out std_logic; -- incremento indirizzo ROM
  UART_WR : out std_logic;
  DONE : out std_logic -- fine operazione
  );
end UC_A;

architecture Behavioral of UC_A is

    type STATI is (IDLE, LOAD, SEND, A_CONT);
    signal stato : STATI;
    signal stato_next : STATI;

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
    
    process(stato, start, TBE)
    begin
        case stato is
        
            when IDLE =>
                if start = '1' then
                    stato_next <= LOAD;
                else
                    stato_next <= IDLE;
                end if;
            
            when LOAD =>
            -- dopo aver letto dalla ROM scriviamo in UART
                UART_WR <= '1';
                stato_next <= SEND;
            
            when SEND =>
            -- aspetto che TBE torni a 1 (significa "shift register caricato")
                if TBE = '1' then
                    stato_next <= FINE;
                else
                    stato_next <= SEND;
                end if;
                
            when A_CONT =>
                INCR_A <= '1';
                DONE <= '1'
                IF last = '1' then
                stato_next <= IDLE;
                else
                  stato_next <= LOAD;
        
        end case;
    end process;    
    
    --ROM_A <= '1' when stato = LOAD else '0';
    UART_WR <= '0'
    INCR_A <= '0'
    DONE <= '0'

end Behavioral;
