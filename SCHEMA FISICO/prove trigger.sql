 /*
    _____________________________________________________________________________________________

    IN QUESTA SEZIONE SONO ELENCATI I TEST ESEGUITI SU I TRIGGER E LE PROCEDURE
    _____________________________________________________________________________________________
    *per impiegato speciale si intende un responsabile,referente o resp_scientifico
    -----------------------------------------------------------------------------------------------------------------------------------
    IMPIEGATO:
        OKK        licenzio un impiegato speciale nell azienda e poi chiamo avviso_su_impiegati_licenziati()-->warning

        OKK        update la data_licenziamento di un impiegato speciale -->mi parte il warning(trigger)

        OKK        modifico la data_assunzione o il tipo_impiegato-->errore

        OKK        elimino un responsabile,il referente o il r_scientifico se è associato ad un lab/progetto-->errore

        OKK        elimino un impiegato non speciale-->okk

        OKK        modifico lo stipendio di un middle e lo rendo piu alto di un senior-->errore

        OKK        modifico lo stipendio di un dirigente junior rendendolo il piu alto di tutti-->okk

    -----------------------------------------------------------------------------------------------------------------------------------
    LABORATORIO:
        OKK        inserisco in un lab un r_scientifico non senior-->errore

        OKK        update laboratotio inserisco un r_scientifico non senior-->errore

        OKK        aggiungo 1 impiegato in afferenza-->si aggiorna il numero_afferenti in laboratorio

        OKK        sottraggo 1 impiegato in afferenza-->si aggiorna il numero_afferenti in laboratorio
    -----------------------------------------------------------------------------------------------------------------------------------
    AFFERENZA:
        OKK        inserisco un impiegato licenziato in afferenza-->errore

        OKK        inserisco un impiegato con 9 ore di lavoro-->errore

    -----------------------------------------------------------------------------------------------------------------------------------
    PROGETTO:
        OKKKKK     prendo un referente e lo rendo non dirigente->messaggio di errore

        OKK        inserisco un prog con responsabile non dirigente -->errore

        OKK        inserisco un prog con  referente non senior -->errore

        OKK        aggiorno un prog con responsabile non dirigente -->errore
                
        OKK        aggiorno un prog con responsabile referente non senior -->errore

        OKK        inserisco un impiegato licenziato in progetto-->errore 
                    
        OKK        licenzia un referente in un progetto che è scaduto-->okk

        OKK        licenzia un responsabile in un progetto che è scaduto-->okk
    -----------------------------------------------------------------------------------------------------------------------------------
    GESTIONE:
        OKK        assegno ad un progetto piu di 3 laboratori-->errore

        OKK        assegno un laboratorio a piu di 3 progetti-->okk
    -----------------------------------------------------------------------------------------------------------------------------------
    STORICO: 
                modifico la data_assunzione di un impiegato, poi chiamo la procedura update_database()--> si aggiornano gli storici

        OKK        inserisco un impiegato con una data non coerente con il tipo_impiegato-->errore

        OKK        inserisco l impiegato -->aggiornamento di storico

        OKK        rendo un impiegato dirigente-->viene aggiornato lo storico

        OKK        rendo un impiegato non dirigente-->viene aggiornato lo storico
    -----------------------------------------------------------------------------------------------------------------------------------

*/