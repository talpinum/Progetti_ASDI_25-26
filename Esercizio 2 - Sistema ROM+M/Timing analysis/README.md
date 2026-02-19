Siccome abbiamo a che fare con macchine puramente combinatorie, siamo liberi da timing constraints sul clock (non essendoci elementi di memoria che necessitano di sincronizzazione).
In questo contesto, allora, la timing analysis non ha lo scopo di scovare eventuali errori dovuti a erronee sincronizzazioni sul clock (e quindi il rispetto dei tempi di setup e di hold): la sua utilità sta nel poter misurare il ritardo di propagazione tra l'attivazione degli switch e l'accensione dei relativi led.

Per ottenere una stima dei ritardi di un design puramente combinatorio, tuttavia, occorre inserire dei registri clockati a monte e a valle del design, che rappresentano rispettivamente gli input e gli output della macchina implementata.
Oltre a dover, quindi, aggiungere un file wrapper (TimingAnalysisWrapper.vhd) con i suddetti registri clockati, andrà modificato il file .xdc definendo comunque un constraint sul periodo del clock

L'analisi ci mostra un Worst Negative Slack ottenuto di 8,248ns. Avendo impostato un periodo di clock di 10ns, otteniamo un ritardo di propagazione (Data Path Delay) di 1,726ns.
Possiamo constatare come il 66% circa del ritardo sia dovuto al routing, il che ce lo si poteva aspettare, sapendo che i tempi legati al routing solitamente valgono tra il 45% e il 65% del tempo totale; il nostro risultato è leggermente superiore alla media, il che è normale in design molto piccoli come questo, dove l'overhead delle interconnessioni prevale sulla semplicità della logica.

Possiamo stimare la Frequenza massima di funzionamento attraverso la formula: vedere immagine

