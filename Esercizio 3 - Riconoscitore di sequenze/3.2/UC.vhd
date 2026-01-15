
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
  Port (
    clk : in std_logic;
    rst : in std_logic;
    B1 : in std_logic;
    S1 : in std_logic; 
    LED_Y : out std_logic
  );
end control_unit;

architecture Structural of control_unit is

    component ButtonDebouncer is
    generic (                       
    CLK_period: integer := 10;  -- periodo del clock (della board) in nanosecondi
    btn_noise_time: integer := 10000000 -- durata stimata dell'oscillazione del bottone in nanosecondi
                                            -- il valore di default è 10 millisecondi
    );
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           CLEARED_BTN : out STD_LOGIC);
    end component;
    
    component MealySP is
    port(
        i : in std_logic; -- dallo switch S1
        CLK : in std_logic;
        rst: in std_logic;
        E : in std_logic; -- impulso dal debouncer
        Y : out std_logic -- verso i LED
    );
    end component;
        
    signal E_clean : std_logic;

begin

    bottone : ButtonDebouncer
    Port map(
        clk => clk,
        rst => rst,
        BTN => B1,
        CLEARED_BTN => E_clean
    );
    
    Mealy : MealySP
      Port map(
          i => S1,
           clk => clk,
           rst => rst,
           E => E_clean,
           Y => LED_Y
        );
    

end Structural;
