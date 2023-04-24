/*
    Parte relativa ai trigger [...]
*/


/*
	SCHEMA LOGICO:

	IMPIEGATO(matricola, nome, cognome, cf, curriculum, stipendio, sesso, foto, tipo, dirigente, data_licenziamento)
	LABORATORIO(id_lab, topic, indirizzo, numero_telefono, numero_afferenti, responsabile)
	PROGETTO(CUP, nome_progetto, budget, data_inizio, data_fine,responsabile,referente)
	STORICO(ruolo_prec, nuovo_ruolo, data_scatto, matricola)
	AFFERENZA(matricola, id_lab, ore_giornaliere, tipo_contratto)
	GESTIONE(cup, id_lab)
*/


/*______________________________________________________________________________________________________________________________
    TRIGGER SU IMPIEGATO:

	(parte sullo storico e aggiornamento del database)
	0.0 Ogni volta che aggiungo un impiegato va aggioranta la tabella Storico, inserendo all'interno l'impiegato con 
		ruolo_prec = NULL e nuovo_ruolo = new.tipo, nel caso in cui il tipo inserito sia >junior allora, inserisco
        all'interno dello storico il resto degli scatti di carriera rimanenti.

	0.1 Creare una funzione di aggiornamento database che quando chiamata, mi aggiunge, se si verificano le condizioni,
		i nuovi scatti di carriera fatti dagli impiegati e il loro attributo 'tipo_impiegato',
        verifica che sulla tabella delle gestioni, nel caso in cui i progetti sono stati finiti,
        allora elimino dalla tabella gestione (stessa funz 1.3)
		aggiorna_database(); (quando la data è inserita nel momento di creazione della tupla)

	0.2 potremmo fare qualche vincolo di integrita semantica
		(esempio un junior non puo avere lo stipendio piu alto di un senior)

	0.3 (delete)Nel momento in cui elimino un dirigente che è associato ad un progetto allora devo chiedere all'utente di sostituire
		il responsabile di quel progetto altrimenti lanciando un messaggio di errore.
		stessa cosa per referente per un progetto e un responsabile scientifico per quel progetto.
		Questo giustificato dal fatto che un progetto non può esserci senza responsabile e referente,
		e un laboratorio non può esserci senza un referente scientifico.

    0.4(update false->true)nel caso in cui viene aggiornato l'attributo booleano dirigente in Impiegato, allora
        bisogna inserire la data scatto all'interno dello storico.
        (update true->false)nel caso in cui il dirigente gestisce qualche laboratorio mandare messaggio di errore, altrimenti,
        fare inserimento all'interno dello storico della data_scatto 'nonDirigente'->'dirigente'.

    _________________________________________________________________________________________________________________________________
    	TRIGGER SUL PROGETTO:

	1.0 (delete pro) se elimino prog allora elimino l'associazione tra i laboratori e quel progetto.

	1.1 (insert prog) quando aggiungo un referente e un responsabile devo fare in modo tale 
		che sia il primo senior e il secondo dirigente,
		altrimenti mando un messaggio di errore e non faccio l'inserimento.

	1.15(update referente, matricola) se si aggiorna un responsabile o un referente allora si verifichi che il nuovo
		valore sia assegnabile. 

	1.2(vincolo di gestione) Un progetto ha al più tre laboratori associati. (sulla tabella gestione).

	1.3(update data fine) nel caso in cui sul progetto viene inserito la data di fine (RISPETTO A OGGI), 
		allora bisogna eliminare nella tabella (gestione)
		tutti i laboratori associati.

	_________________________________________________________________________________________________________________

	TRIGGER SU LABORATORIO:


	2.05 quando aggiorno un responsabile scientifico, controllo se il nuovo valore è un senior, altrimenti rollback
	
	2.1 quando aggiungo un responsabile scientifico esso dev'essere un senior, altrimenti elimina la tupla 
		lanciando un messaggio di eccezione.

	2.2 controllare che un impiegato non lavora per più di otto ore al giorno (tabella afferenza), altrimenti
		lanciare un messaggio di errore.
	
	2.3 ogni volta che aggiungo o elimino un'afferenza impiegato-laboratorio allora aggiorno il numero di afferenti di quel
		laboratorio.

	_________________________________________________________________________________________________________________

	TRIGGER SULLO STORICO:
	3.0 Quando modifico l'attributo booleano da (false -> true), allora lo scatto dev'essere registrato nella tabella
		storico, in questo modo riesco a recuperare anche lo scatto dirigenziale fatto.

	3.1 Nel caso in cui l'attributo booleano passa (true->false) devo prima controllare che il dirigente non abbia
		in gestione un progetto,
	_________________________________________________________________________________________________________________
*/




--________________________________________________________________________________________________________________________________--

/*
    --TRIGGER 0.0 : INSERIMENTO DI UN IMPIEGATO, CONTROLLO VALIDITA' DI DATA E NEL CASO POSITIVO AGGIUNGO NELLO STORICO.

    NEL MOMENTO IN CUI INSERISCO UN NUOVO IMPIEGATO, AGGIORNO IL SUO STATUS
    ALL'INTERNO DELLO STORICO CON LA DATA DI SCATTO CON IL TIPO INSERITO,
    NEL CASO IN CUI IL TIPO E' >JUNIOR, ALLORA INSERISCE ANCHE GLI ALTRI SCATTI,
    CALCOLANDOLI GRAZIE ALLA DATA DI ASSUNZIONE.
*/

--si implementi un trigger che all inserimento di un impiegato si occupi di inserire i suoi scatti di carriera nella tab storico
CREATE OR REPLACE TRIGGER insert_storico
AFTER INSERT ON impiegato
FOR EACH ROW
EXECUTE FUNCTION function_insert_storico();

CREATE OR REPLACE FUNCTION function_insert_storico() RETURNS TRIGGER AS
$$
    BEGIN
        -- Check if the hiring date is consistent with the role to allow insertion
        IF (NEW.tipo_impiegato = 'junior') THEN
            IF((NEW.data_assunzione + INTERVAL '3 years') >= CURRENT_DATE ) THEN  
                INSERT INTO storico VALUES (NULL, 'junior', NEW.data_assunzione, NEW.matricola);
            ELSE
                -- Error message
                RAISE EXCEPTION 'Invalid hiring date for a junior employee';
            END IF;

        ELSIF (NEW.tipo_impiegato = 'middle') THEN
            IF ((NEW.data_assunzione + INTERVAL '3 years') <= CURRENT_DATE AND
                NEW.data_assunzione + INTERVAL '7 years' >= CURRENT_DATE ) THEN 
                    INSERT INTO storico VALUES (NULL, 'junior', NEW.data_assunzione, NEW.matricola);
                    INSERT INTO storico VALUES ('junior', 'middle', NEW.data_assunzione + INTERVAL '3 years', NEW.matricola);
            ELSE
                -- Error message
                RAISE EXCEPTION 'Invalid hiring date for a middle employee';
            END IF;

        ELSIF (NEW.tipo_impiegato = 'senior') THEN
            IF((NEW.data_assunzione + INTERVAL '7 years') <= CURRENT_DATE ) THEN
                INSERT INTO storico VALUES (NULL, 'junior', NEW.data_assunzione, NEW.matricola);
                INSERT INTO storico VALUES ('junior', 'middle', NEW.data_assunzione + INTERVAL '3 years', NEW.matricola);
                INSERT INTO storico VALUES ('middle', 'senior', NEW.data_assunzione + INTERVAL '7 years', NEW.matricola);
            ELSE 
                -- Error message
                RAISE EXCEPTION 'Invalid hiring date for a senior employee';
            END IF;

        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

--________________________________________________________________________________________________________________________________--
