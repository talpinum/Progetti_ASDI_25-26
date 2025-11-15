library ieee;
use ieee.std_logic_1164.all;

entity rete_di_interconnessione is
    port (
        x: in STD_LOGIC_VECTOR(31 downto 0);
        s: in  STD_LOGIC_VECTOR(7 downto 0);
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture structural of rete_di_interconnessione is

    component mux_32_1
        port (
        x: in STD_LOGIC_VECTOR(31 downto 0);
        s: in STD_LOGIC_VECTOR(4 downto 0);
        y: out STD_LOGIC
    );
    end component;

    component demux_1_8
        port (
        input: in STD_LOGIC;
        selection_demux: in STD_LOGIC_VECTOR(2 downto 0);
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;

    signal u: STD_LOGIC := '0';
    
    begin
        mux: mux_32_1
            port map (
                x  => x,
                s  => s(4 downto 0),
                y  =>  u
            );
        
        demux: demux_1_8
            port map (
                input => u,
                selection_demux => s(7 downto 5),
                output => output
            );

end architecture;