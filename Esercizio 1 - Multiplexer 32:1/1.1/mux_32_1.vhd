library ieee;
use ieee.std_logic_1164.all;

entity mux_32_1 is
    port (
        x: in STD_LOGIC_VECTOR(31 downto 0);
        s: in STD_LOGIC_VECTOR(4 downto 0);
        y: out STD_LOGIC
    );
end entity;

architecture structural of mux_32_1 is

    component mux_2_1
        port (
            a0: in STD_LOGIC;
            a1: in STD_LOGIC;
            c: in STD_LOGIC;
            y0: out STD_LOGIC
        );
    end component;

    component mux_8_1 is
        port (
            input: in STD_LOGIC_VECTOR(7 downto 0);
            selection: in STD_LOGIC_VECTOR(2 downto 0);
            y1: out STD_LOGIC
        );
    end component;
    
    signal u0: STD_LOGIC := '0';
    signal u1: STD_LOGIC := '0';
    signal u2: STD_LOGIC := '0';
    signal u3: STD_LOGIC := '0';

    signal u4: STD_LOGIC := '0';
    signal u5: STD_LOGIC := '0';
    
    begin

        mux0: mux_8_1
            port map (
                input(0) => x(0),
                input(1) => x(1),
                input(2) => x(2),
                input(3) => x(3),
                input(4) => x(4),
                input(5) => x(5),
                input(6) => x(6),
                input(7) => x(7),

                selection(0) => s(0), 
                selection(1) => s(1), 
                selection(2) => s(2), 

                y1 => u0
            );

        mux1: mux_8_1
            port map (
                input(0) => x(8),
                input(1) => x(9),
                input(2) => x(10),
                input(3) => x(11),
                input(4) => x(12),
                input(5) => x(13),
                input(6) => x(14),
                input(7) => x(15),

                selection(0) => s(0), 
                selection(1) => s(1), 
                selection(2) => s(2), 

                y1 => u1
            );

        mux2: mux_8_1
            port map (
                input(0) => x(16),
                input(1) => x(17),
                input(2) => x(18),
                input(3) => x(19),
                input(4) => x(20),
                input(5) => x(21),
                input(6) => x(22),
                input(7) => x(23),

                selection(0) => s(0), 
                selection(1) => s(1), 
                selection(2) => s(2), 

                y1 => u2
            );

        mux3: mux_8_1
            port map (
                input(0) => x(24),
                input(1) => x(25),
                input(2) => x(26),
                input(3) => x(27),
                input(4) => x(28),
                input(5) => x(29),
                input(6) => x(30),
                input(7) => x(31),

                selection(0) => s(0), 
                selection(1) => s(1), 
                selection(2) => s(2), 

                y1 => u3
            );

        mux4: mux_2_1
            port map (
                a0  => u0,
                a1 => u1,
                c => s(3),
                y0  => u4
            );
        
        mux5: mux_2_1
            port map (
                a0  => u2,
                a1 => u3,
                c => s(3),
                y0  => u5
            );
        
        mux6: mux_2_1
            port map (
                a0  => u4,
                a1 => u5,
                c => s(4),
                y0  => y 
            );

end architecture;