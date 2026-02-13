entity Comparatore is
Port (
   A : in STD_LOGIC_VECTOR (7 downto 0); -- Dato ricevuto dal registro
   X : in STD_LOGIC_VECTOR (7 downto 0); -- Valore di soglia (Configurabile )
   MATCH : out STD_LOGIC -- '1' se A > X
);
end Comparatore;

architecture Behavioral of Comparator_NodeB is

begin

  -- Confronto unsigned per trattare i bit come numeri puri
  MATCH <= '1' when unsigned (A) > unsigned (X) else '0';

end Behavioral;
