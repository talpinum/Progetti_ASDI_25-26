----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2025 11:51:24
-- Design Name: 
-- Module Name: Unita_operativa_A - Behavioral
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

entity U_O_A_Completa is
    Port (
    clk_o : in std_logic;
    rst_o : in std_logic;
    read : in std_logic;
    A_cont : in std_logic;
    last_o : out std_logic;
    ok_user_ack : in std_logic; -- (da B) A può avanzare
    Y : out std_logic_vector(7 downto 0)
    );
end U_O_A_Completa;


architecture structural of U_O_A_Completa is
    component ROM is
       -- generic(
            --N : integer := 16; -- Le N locazioni
          --  ADDR_WIDTH : integer := 4
        --);
        port (
            clk : in std_logic;
            address: in STD_LOGIC_VECTOR(3 downto 0);
            content: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    component Contatore is
        generic (
        N: integer := 16;
        addr_width : integer := 4
        );
      Port (
        clk: in std_logic;
        rst : in std_logic;
        A : in std_logic; -- proveniente dalla nostra U.C.
        value : out std_logic_vector (addr_width-1 downto 0);
        last : out std_logic -- varrà 1 quando il mio segnale di count varrà N-1
      );
   end component;
   
   signal addr : std_logic_vector(3 downto 0);
   signal rom_out : std_logic_vector(7 downto 0);
   signal last_sig : std_logic;
   -- signal Y_reg : std_logic_vector(7 downto 0) := (others => '0');
   
   signal cont_enable : std_logic; -- segnale che decide se il contatore avanza
   
begin

    cont_enable <= A_cont AND ok_user_ack;
    
    ROM_A : ROM
    port map(
        clk => clk_o,
        address => addr,
        content => rom_out
    );
    
    Contatore_A : Contatore
    port map(
        clk => clk_o,
        rst => rst_o,
        A => cont_enable,
        value => addr,
        last => last_sig
    );
    
    
    last_o <= last_sig;
    Y <= rom_out;
    -- Y <= Y_reg;
    
    
    --process(clk_o, rst_o)
    --begin
    --    if rising_edge(clk_o) then
    --        if rst_o = '1' then
    --           Y_reg <= (others => '0');
    --        else
    --            -- aggiorna l'uscita ROM solo quando read = 1
    --            if read = '1' then
    --                Y_reg <= rom_out;
    --            end if;
    --        end if;
    --    end if;
    --end process;
    
    
end structural;
