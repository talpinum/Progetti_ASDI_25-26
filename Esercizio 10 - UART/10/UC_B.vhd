----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2025 10:05:08
-- Design Name: 
-- Module Name: UC_B - Behavioral
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

entity UC_B is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  RDA : in std_logic;
  RD : out std_logic;
  wrt_mem : out std_logic;
  incr_B : out std_logic
  );
end UC_B;

 

architecture Behavioral of UC_B is

    type STATI is (IDLE, READ, OPERAZIONI, WRITE, INCR);
    signal stato : STATI;
    signal stato_prossimo : STATI;

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


    process(stato, RDA)
    begin
    
        RD <= '0';
        wrt_mem <= '0';
        incr_B <= '0';
        stato_prossimo <= stato;
        
        case stato is
        
            when IDLE =>
                if RDA = '1' then
                    stato_prossimo <= READ;
                else
                    stato_prossimo <= IDLE;
                end if;
            
            when READ =>
                RD <= '1';
                stato_prossimo <= OPERAZIONI;
                
            when OPERAZIONI =>
                stato_prossimo <= WRITE;
                
            when WRITE =>
                wrt_mem <= '1';
                stato_prossimo <= INCR;
                
            when INCR =>
                incr_B <= '1';
                stato_prossimo <= IDLE;
        
        end case;
    end process;    
       
end Behavioral;
