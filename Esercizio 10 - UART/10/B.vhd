----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2025 10:05:08
-- Design Name: 
-- Module Name: B - Behavioral
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

entity B is
  Port (
  clk : in std_logic;
  rst : in std_logic;
  RXD_in : in std_logic;
  last : out std_logic;
  uscita : out std_logic;
  RDA : out std_logic
  );
end B;

architecture Structural of B is

    component UC_B is
      Port (
        clk      : in std_logic;
        rst      : in std_logic;
        RDA      : in std_logic;      -- arriva dalla UO_B
        RD       : out std_logic;     -- verso UO_B
        wrt_mem  : out std_logic;     -- verso UO_B
        incr_B   : out std_logic      -- verso UO_B
      );
    end component;

    -- UO_B
    component UO_B is
      Port (
        clk_b    : in std_logic;
        rst_b    : in std_logic;

        write_mem : in std_logic;
        incr_b    : in std_logic;
        rd_uart   : in std_logic;

        RXD_b     : in std_logic;
        last      : out std_logic;
        uscita_mem : out std_logic;
        RDA_b     : inout std_logic    -- dalla UART → verso UC_B
      );
    end component;
    
    signal RDA_s : std_logic;
    signal wrt_mem_s : std_logic;
    signal incr_s : std_logic;
    signal RD_s : std_logic;
begin

      UC : UC_B
      Port map(
        clk => clk,
        rst => rst,
        RDA => RDA_s, -- la UC legge lo stato dalla UART (attraverso UO)
        RD => RD_s,
        wrt_mem => wrt_mem_s,
        incr_B => incr_s
      );
      
    UO : UO_B
      Port map(
        clk_b => clk,
        rst_b => rst,
        write_mem => wrt_mem_s,
        incr_b => incr_s,
        rd_uart => RD_s,
        RXD_b => RXD_in,
        last => last,
        uscita_mem => uscita,
        RDA_b => RDA_s
      );
      
     RDA <= RDA_s; 
    

end Structural;
