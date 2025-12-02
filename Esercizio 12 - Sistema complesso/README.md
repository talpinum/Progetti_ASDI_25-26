## Esercizio 12
Progettare, implementare in VHDL e testare mediante simulazione il seguente sistema.

Un sistema è composto da due nodi, A e B; A include una memoria ROM di 16 locazioni da 4 bit ciascuna e un moltiplicatore (realizzato secondo Robertson o Booth, a scelta dello studente). B include un comparatore di stringhe da 8 bit e una memoria MEM. Opportuni contatori sono utilizzati in A e B per scandire le locazioni delle rispettive memorie.

Il sistema A preleva due stringhe da due locazioni successive della memoria A e le moltiplica tra loro mediante il moltiplicatore; l’uscita del moltiplicatore, su 8 bit, viene inviata a B mediante handshaking semplice; B, ricevuta la stringa, la confronta con una stringa X di 8 bit pre-caricata in un registro interno (a scelta dello studente): se risulta strettamente maggiore di X, B memorizza la stringa ricevuta in MEM, altrimenti la scarta (non fa nulla).

· Si disegni l’architettura complessiva del sistema tramite un diagramma a blocchi, identificando parte operativa e parte di controllo di ciascun nodo. Nella parte operativa, si mettano in evidenza i principali componenti e le loro interconnessioni.

· Implementare ROM, MEM, comparatore e contatori in maniera behavioral.

· Implementare il moltiplicatore in maniera strutturale utilizzando il componente Robertson fornito a lezione o il componente Booth sviluppato per l’esercizio 7 opportunamente scalati per lavorare su operandi di 4 bit.

· Progettare le unità di controllo di A e B evidenziando gli stati, gli ingressi e le uscite negli automi risultanti.

· Implementare il sistema in VHDL e includere il codice del top module, dei moduli che inglobano i singoli nodi, delle unità di controllo di A e B e dalle parti operative di A e B; fornire una descrizione delle modifiche fatte al codice pre-esistente del moltiplicatore e il codice del comparatore.

· Simulare il sistema testandolo in almeno 2 scenari (comparazione con esito positivo e negativo) utilizzando 2 clock diversi per A e B, sfasati tra loro. Per uno dei due scenari illustrare la simulazione sia per clkA>clkB sia per clkB>clkA.
