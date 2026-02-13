library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Omega_Network is
    generic ( 
        payload_width : integer := 4 
    );
    Port ( 
        -- Segnali di Sistema
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        
        -- Interfaccia di Controllo (Richieste dai nodi)
        -- Bit a '1' = il nodo vuole trasmettere
        req_vector : in  std_logic_vector(7 downto 0);
        
        -- Interfaccia Destinazioni (Dove vogliono andare i nodi)
        -- 24 bit totali: [Dest7(3)]...[Dest1(3)][Dest0(3)]
        dest_flat_in : in  std_logic_vector(23 downto 0);
        
        -- Interfaccia Dati (Payload dai nodi)
        -- 32 bit totali: [Dato7(4)]...[Dato0(4)]
        node_in : in  std_logic_vector(31 downto 0);
        
        -- Uscite del Sistema
        node_out : out std_logic_vector(31 downto 0);
        
        -- Segnale di debug/validità (Alto quando un dato sta passando)
        valid_out : out STD_LOGIC
    );
end Omega_Network;

architecture Structural of Omega_Network is
    
    -- Il Controller (l'Arbitro che hai scritto prima)
    component UC is
        Port ( 
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            req_vector : in  std_logic_vector(7 downto 0);
            dest_flat_in  : in  std_logic_vector(23 downto 0);
            ctrl_src_addr : out std_logic_vector(2 downto 0);
            ctrl_dst_addr : out std_logic_vector(2 downto 0);
            valid_out : out STD_LOGIC
        );
    end component;

    -- Il Datapath 
    component UO is
        generic ( 
            payload_width : integer := 4 
        );
        port (
            node_in  : in  std_logic_vector(31 downto 0); 
            SRC_ADDR : in  std_logic_vector(2 downto 0);
            DST_ADDR : in  std_logic_vector(2 downto 0);
            node_out : out std_logic_vector(31 downto 0)
        );
    end component;

    -- SEGNALI INTERNI (I "fili" di collegamento)
    
    -- Questi segnali portano la decisione del Controller al Datapath
    signal w_src_addr : std_logic_vector(2 downto 0);
    signal w_dst_addr : std_logic_vector(2 downto 0);

begin
    
    -- Il Cervello
    Controller: UC
    port map (
        clk => clk,
        rst => rst,
        req_vector => req_vector,
        dest_flat_in => dest_flat_in,
        
        -- Output del Controller collegati ai segnali interni
        ctrl_src_addr => w_src_addr,
        ctrl_dst_addr => w_dst_addr,
        valid_out => valid_out
    );

    -- La Rete
    Datapath: UO
    generic map (
        payload_width => payload_width
    )
    port map (
        node_in => node_in,
        
        -- Input di controllo presi dai segnali interni (decisione dell'arbitro)
        SRC_ADDR => w_src_addr, 
        DST_ADDR => w_dst_addr,
        
        node_out => node_out
    );

end Structural;
