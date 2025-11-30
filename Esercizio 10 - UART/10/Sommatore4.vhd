----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 16:13:43
-- Design Name: 
-- Module Name: Sommatore4 - Behavioral
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

entity Sommatore4 is
  Port (
  Sx : in std_logic_vector(3 downto 0);
  Dx : in std_logic_vector(3 downto 0);
  Y : out std_logic_vector(4 downto 0)
  );
end Sommatore4;

architecture Structural of Sommatore4 is

    component Full_adder is
        Port (
            a : in std_logic;
            b : in std_logic;
            c_in : in std_logic;
            s : out std_logic;
            c_out : out std_logic
        );
    end component;  
    
    signal c : std_logic_vector(4 downto 0);

begin

    gen_FA : for i in 0 to 3 generate
        FA_i : Full_Adder
            Port map(
                a => Sx(i),
                b => Dx(i),
                c_in => c(i),
                s => Y(i),
                c_out => c(i+1)
            );
    end generate;        

    Y(4) <= c(4); -- carry finale = bit 4 del risultato

end Structural;
