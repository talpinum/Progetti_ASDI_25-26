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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity U_O_B_Completa is
    Port (
    clk_o : in std_logic;
    rst_o : in std_logic;
    load : in  std_logic;
    data_out : out std_logic_vector(4 downto 0);
    data_in : in std_logic_vector(7 downto 0)
    );
end U_O_B_Completa;
    
    
architecture Behavioral of U_O_B_Completa is

    component Sommatore4 is
      Port (
        Sx : in std_logic_vector(3 downto 0);
        Dx : in std_logic_vector(3 downto 0);
        Y : out std_logic_vector(4 downto 0)
      );
    end component;

    component Divisore is
          Port (
        X : in std_logic_vector(7 downto 0);
        S : out std_logic_vector(3 downto 0);
        D : out std_logic_vector(3 downto 0)
        );
    end component;

     component registro_pipo is
        generic (
            N : integer := 8
        );
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            load  : in  std_logic;
            d_in  : in  std_logic_vector(N-1 downto 0);
            q_out : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    signal data_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal sinistra, destra : std_logic_vector(3 downto 0);
    signal risultato : std_logic_vector(4 downto 0);
  

begin
    
    REG_B : registro_pipo
        generic map(
            N => 8
        )
        port map(
            clk   => clk_o,
            rst   => rst_o,
            load  => load,
            d_in  => data_in,
            q_out => data_reg
        );
    
    Sommatore : Sommatore4
        Port map(
            Sx => sinistra,
            Dx => destra,
            Y => risultato
        );
        
     Divisore8_4 : Divisore
        Port map(
            X => data_reg,
            S => sinistra,
            D => destra
        );
    
    data_out <= risultato;
    

end Behavioral;
