----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2025 18:00:10
-- Design Name: 
-- Module Name: Control_unit - Behavioral
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

entity Control_unit is
    Port (
    clk : in std_logic;
    rst : in std_logic;
    start : in std_logic;
    match : in std_logic; -- dal comparatore in modo tale che c'è il match e faccio partire write
    last : in std_logic; -- dal contatore e capisco che devo fare done
    wrt : out std_logic; -- write sincrono su MEM
    read : out std_logic; -- read sincrono su ROM
    A_cont : out std_logic -- abilitiamo il contatore
   -- done : out std_logic
    );
end Control_unit;

architecture Behavioral of Control_unit is

    type STATI is (IDLE, LEGGI, CHECK, WRITE, NEXT_ADDR);
    
    -- signal stato_iniziale : STATI := IDLE;
    signal stato_next : STATI;
    signal stato : STATI;
       
begin

   comb : process(stato, start, match, last)
   begin
    wrt <= '0';
    read <= '0';
    A_cont <= '0';
    --done <= '0';
    --stato_next <= stato;
    
    case stato is 
        when IDLE =>
            A_cont <= '0';
            if start = '1' then
                stato_next <= LEGGI;
            else
                stato_next <= IDLE;
            end if;
            
        when LEGGI => -- metto indirizzo e leggo ma con la ROM sincrona dovrò aspettare per leggere
            read <= '1';
            stato_next <= CHECK;
            A_cont <= '0';
            
        when CHECK =>
            read <= '0';
            if match = '1' then
               stato_next <= WRITE;
            else
                stato_next <= NEXT_ADDR;
            end if;
            
        when WRITE =>
            wrt <= '1';
            stato_next <= NEXT_ADDR;
        
        when NEXT_ADDR =>
            A_cont <= '1';
            wrt <= '0';
            if last = '1' then
                stato_next <= IDLE;
            else
                stato_next <= LEGGI;
            end if;
                   
        end case;
   end process;
   
   
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

end Behavioral;
