library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Omega_Controller is
    Port ( 
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        
        -- INPUT 1: Chi vuole trasmettere? (1 bit per nodo)
        req_vector    : in  STD_LOGIC_VECTOR(7 downto 0);
        
        -- INPUT 2: Dove vogliono andare? (3 bit per nodo * 8 nodi = 24 bit)
        -- Ordine: [Dest7]...[Dest1][Dest0]
        dest_flat_in  : in  STD_LOGIC_VECTOR(23 downto 0);
        
        -- OUTPUT verso Datapath
        ctrl_src_addr : out STD_LOGIC_VECTOR(2 downto 0);
        ctrl_dst_addr : out STD_LOGIC_VECTOR(2 downto 0);
        valid_out     : out STD_LOGIC
    );
end Omega_Controller;

architecture Behavioral of Omega_Controller is
    
    -- Definizione array per spacchettare le destinazioni
    type dest_array_type is array (0 to 7) of std_logic_vector(2 downto 0);
    signal destinations_arr : dest_array_type;

    -- Registro per tenere il segno della priorità (token)
    signal priority_token : integer range 0 to 7;

begin

    -- 1. SPACCHETTAMENTO CONCORRENTE (Come hai fatto nel Datapath)
    -- Trasforma il vettore 24 bit in un array accessibile tramite indice
    gen_dest_array: for i in 0 to 7 generate
        destinations_arr(i) <= dest_flat_in((i*3)+2 downto i*3);
    end generate;

    -- 2. PROCESSO DI ARBITRAGGIO
    process(clk, reset)
        variable req_double : unsigned(15 downto 0);
        variable found      : boolean;
        variable temp_win   : integer range 0 to 7;
        variable calc_idx   : integer;
    begin
        if reset = '1' then
            priority_token <= 0;
            ctrl_src_addr  <= (others => '0');
            ctrl_dst_addr  <= (others => '0');
            valid_out      <= '0';
        elsif rising_edge(clk) then
            
            -- Creazione vettore doppio per ricerca circolare
            req_double := unsigned(std_logic_vector'(req_vector & req_vector));
            
            found := false;
            temp_win := 0; 
            valid_out <= '0'; -- Default se nessuno trasmette

            -- Scansione della finestra di 8 bit a partire dal token
            for i in 0 to 7 loop
                if not found then
                    -- Controlliamo il bit (token + i)
                    if req_double(priority_token + i) = '1' then
                        
                        -- Calcolo dell'indice reale del vincitore (modulo 8 semplificato)
                        calc_idx := priority_token + i;
                        if calc_idx >= 8 then
                            temp_win := calc_idx - 8;
                        else
                            temp_win := calc_idx;
                        end if;
                        
                        found := true;
                    end if;
                end if;
            end loop;

            -- Se abbiamo trovato un vincitore, aggiorniamo le uscite e il token
            if found then
                -- A. Comunica alla rete CHI trasmette (Sorgente)
                ctrl_src_addr <= std_logic_vector(to_unsigned(temp_win, 3));
                
                -- B. Comunica alla rete DOVE andare (pescando dall'array creato sopra)
                ctrl_dst_addr <= destinations_arr(temp_win);
                
                -- C. Segnala validità
                valid_out <= '1';

                -- D. Aggiorna Priorità: il token passa al successivo del vincitore
                if temp_win = 7 then
                    priority_token <= 0;
                else
                    priority_token <= temp_win + 1;
                end if;
            
            else
                -- Se nessuno ha richiesto, il token resta dov'è (o ruota, a scelta)
                valid_out <= '0';
            end if;
            
        end if;
    end process;

end Behavioral;
