/*
    _____________________________________________________________________________________________

    IN QUESTA SEZIONE SONO ELENCATI I TEST ESEGUITI SU I TRIGGER E LE PROCEDURE
    _____________________________________________________________________________________________
    *per impiegato speciale si intende un responsabile,referente o resp_scientifico
    -----------------------------------------------------------------------------------------------------------------------------------
    IMPIEGATO:
        OKK        licenzio un impiegato speciale nell azienda e poi chiamo avviso_su_impiegati_licenziati()-->warning

        OKK        update la data_licenziamento di un impiegato speciale -->mi parte il warning(trigger)

                modifico la data_assunzione o il tipo_impiegato-->errore

                elimino un responsabile,il referente o il r_scientifico se è associato ad un lab/progetto-->errore

                elimino un impiegato non speciale-->okk

                modifico lo stipendio di un middle e lo rendo piu alto di un senio-->errore

                modifico lo stipendio di un dirigente junior rendendolo il piu alto di tutti-->okk
    -----------------------------------------------------------------------------------------------------------------------------------
    LABORATORIO:
                inserisco in un lab un r_scientifico non senior-->errore

                update laboratotio inserisco un r_scientifico non senior-->errore

                aggiungo 1 impiegato in afferenza-->si aggiorna il numero_afferenti in laboratorio

                sottraggo 1 impiegato in afferenza-->si aggiorna il numero_afferenti in laboratorio
    -----------------------------------------------------------------------------------------------------------------------------------
    AFFERENZA:
                inserisco un impiegato licenziato in afferenza-->errore

                inserisco un impiegato con 9 ore di lavoro-->errore

                inserisco un impiegato con 7 ore di lavoro,poi lo inserisco di nuovo con 2-->errore
                (potrei fare un trigger che verifica se l impiegato lavora gia in quel lab e mandare un mess di eccezione)
    -----------------------------------------------------------------------------------------------------------------------------------
    PROGETTO:
                prendo un referente e lo rendo non dirigente->messaggio di errore

                inserisco un prog con responsabile non dirigente -->errore

                inserisco un prog con responsabile referente non senior -->errore

                aggiorno un prog con responsabile non dirigente -->errore
                
                aggiorno un prog con responsabile referente non senior -->errore

                inserisco un impiegato licenziato in progetto-->errore  NOT OK
    -----------------------------------------------------------------------------------------------------------------------------------
    GESTIONE:
                assegno ad un progetto piu di 3 laboratori-->errore

                assegno un laboratorio a piu di 3 progetti-->okk
    -----------------------------------------------------------------------------------------------------------------------------------
    STORICO: 
                modifico la data_assunzione di un impiegato, poi chiamo la procedura update_database()--> si aggiornano gli storici

                inserisco un impiegato con una data non coerente con il tipo_impiegato-->errore

        OKK        inserisco l impiegato -->aggiornamento di storico

                rendo un impiegato dirigente-->viene aggiornato lo storico

                rendo un impiegato non dirigente-->viene aggiornato lo storico
    -----------------------------------------------------------------------------------------------------------------------------------


                













*/