----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2026 19:06:51
-- Design Name: 
-- Module Name: UO - Behavioral
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

entity UO is
    generic ( 
        payload_width : integer := 4 
    );
    port (
        -- Input appiattito: 8 canali * 4 bit = 32 bit totali
        -- node_in(31..28) è nodo 7, node_in(3..0) è nodo 0
        node_in : in  std_logic_vector(31 downto 0); 
        
        -- Segnali di controllo dalla CU
        -- src_addr controlla quale input del switch prendere (routing sorgente)
        -- dst_addr controlla quale output del switch prendere (routing destinazione)
        src_addr : in  std_logic_vector(2 downto 0);
        dst_addr : in  std_logic_vector(2 downto 0);
        
        node_out : out std_logic_vector(31 downto 0)
    );
end UO;

architecture Structural of UO is
    component SWITCH is
    port(
    src : in std_logic; -- Seleziona input (Routing basato su Sorgente)
    dest : in std_logic; -- Seleziona output (Routing basato su Destinazione)
    x1 : in std_logic_vector(3 downto 0);
    x2 : in std_logic_vector(3 downto 0);
    Y1 : out std_logic_vector(3 downto 0);
    Y2 : out std_logic_vector(3 downto 0)
    );
    end component;

    -- Segnali interni per i collegamenti tra stadi
    type bus_array is array (0 to 7) of std_logic_vector(payload_width-1 downto 0);
    signal stage1_out, stage2_out : bus_array;
    signal input_arr, output_arr : bus_array;

begin
    -- Conversione vettore piatto in array per comodità
    -- stiamo prendendo i 32 bit in ingresso (4 * 8) e li stiamo dividendo in input da 4 bit ciascuno
    -- in modo da avere 8 "fili" da 4 bit ognuno (3-0) (7-4) (11-8) ... (32-29)
    gen_in_array: for i in 0 to 7 generate
        input_arr(i) <= node_in((i*4)+3 downto i*4);
    end generate;

    -- ================= STADIO 1 =================
    -- Input diretti: (0,1), (2,3), (4,5), (6,7)
    -- Controllo: Usa SRC bit 0 e DST bit 2 (MSB)
    stage1_gen: for i in 0 to 3 generate
        sw_s1: SWITCH
        port map (
            x1 => input_arr(i),       -- 0, 1, 2, 3 (il primo switch prende i 4 bit da 0-3 in IN0)
            x2 => input_arr(i+4),     -- 4, 5, 6, 7 (il primo switch prende i 4 bit da 4-7 in IN1)
            src => src_addr(2),        -- MSB della sorgente
            dest => dst_addr(2),        -- MSB della destinazione
            Y1 => stage1_out(i*2),    -- 0, 2, 4, 6
            Y2 => stage1_out(i*2+1)   -- 1, 3, 5, 7
        );
    end generate;

    -- ================= STADIO 2 =================
    -- Input: Perfect Shuffle delle uscite dello Stadio 1
    -- Shuffle 8: 0->0, 1->2, 2->4, 3->6, 4->1, 5->3, 6->5, 7->7
    -- Controllo: Usa SRC bit 1 e DST bit 1
    
    -- Switch 0 (Input da 0 e 4 dello stadio precedente shuffle) -> In realtà shuffle collega:
    -- Out0 S1 -> In0 Sw0 S2
    -- Out4 S1 -> In1 Sw0 S2
    -- Vediamo la mappa corretta del Perfect Shuffle:
    -- Ingressi SW0 S2: da S1(0) e S1(4) -- No, shuffle di 0..7: 0,4,1,5,2,6,3,7
    
    sw_s2_0: SWITCH
    port map ( x1 => stage1_out(0), 
               x2 => stage1_out(4), 
               src => src_addr(1), 
               dest => dst_addr(1), 
               y1 => stage2_out(0), 
               y2 => stage2_out(1)
               );
               
    sw_s2_1: SWITCH
    port map ( x1 => stage1_out(1), 
               x2 => stage1_out(5), 
               src => src_addr(1), 
               dest => dst_addr(1), 
               y1 => stage2_out(2), 
               y2 => stage2_out(3)
               );
               
    sw_s2_2: SWITCH
    port map ( 
              x1 => stage1_out(2), 
              x2 => stage1_out(6), 
              src => src_addr(1), 
              dest => dst_addr(1), 
              y1 => stage2_out(4), 
              y2 => stage2_out(5)
              );
              
    sw_s2_3: SWITCH
    port map ( x1 => stage1_out(3), 
               x2 => stage1_out(7), 
               src => src_addr(1), 
               dest => dst_addr(1), 
               y1 => stage2_out(6), 
               y2 => stage2_out(7)
               );

    -- ================= STADIO 3 =================
    -- Input: Perfect Shuffle delle uscite dello Stadio 2
    -- Controllo: Usa SRC bit 2 (MSB) e DST bit 0 (LSB)
    
    gen_stage3: for i in 0 to 3 generate
        sw_s3: SWITCH
        port map (
            x1 => stage2_out(i),
            x2 => stage2_out(i+4),
            src => src_addr(0),
            dest => dst_addr(0),       -- LSB indirizzo destinazione
            y1 => output_arr(i*2),
            y2 => output_arr(i*2+1)
        );
    end generate;

    -- Mappatura uscita
    gen_out_vector: for i in 0 to 7 generate
        node_out((i*4)+3 downto i*4) <= output_arr(i);
    end generate;

end Structural;
