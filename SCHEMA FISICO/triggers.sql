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
    --TRIGGER 0.0 :

    NEL MOMENTO IN CUI INSERISCO UN NUOVO IMPIEGATO, AGGIORNO IL SUO STATUS
    ALL'INTERNO DELLO STORICO CON LA DATA DI SCATTO CON IL TIPO INSERITO,
    NEL CASO IN CUI IL TIPO E' >JUNIOR, ALLORA INSERISCE ANCHE GLI ALTRI SCATTI,
    CALCOLANDOLI GRAZIE ALLA DATA DI ASSUNZIONE.
*/


CREATE OR REPLACE FUNCTION update_storico_impiegato() RETURNS trigger AS
$update_storico$
BEGIN
    --inserisco all'interno dello storico la nuova tupla creata
        INSERT INTO STORICO (ruolo_prec, nuovo_ruolo, data_scatto, matricola)
        VALUES (NULL, NEW.tipo_impiegato, CURRENT_DATE, NEW.matricola);

        --allora aggiorno i vari scatti di carriera fatti.
        if(NEW.tipo_impiegato <> 'junior') then
            CALL update_scatti(new.tipo_impiegato,new.matricola);
        end if;

    RETURN NEW;
END;
$update_storico$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER update_storico
    AFTER INSERT ON IMPIEGATO
    FOR EACH ROW
    EXECUTE FUNCTION update_storico_impiegato();


CREATE OR REPLACE PROCEDURE update_scatti(tipo_impiegato IN DOMINIO_IMPIEGATO, matricola IN VARCHAR(100)) AS
$$
    DECLARE

        data_assunzione date;
        data_prevista_middle date;

    BEGIN
        data_assunzione := (SELECT data_assunzione FROM Impiegati_attuali AS I WHERE I.matricola = $2);
        SELECT data_assunzione + INTERVAL '3 years' INTO data_prevista_middle;

        --caso in cui viene aggiunto un dipendente già senior, dunque bisogna aggiornare vari scatti di carriera.
        IF tipo_impiegato = 'senior' THEN
            --allora aggiungo i due scatti di carriera rimanenti...
            INSERT INTO STORICO (ruolo_prec, nuovo_ruolo, data_scatto, matricola)
            VALUES (NULL, 'junior', data_assunzione, $2);
            INSERT INTO STORICO (ruolo_prec, nuovo_ruolo, data_scatto, matricola)
            VALUES ('junior', 'middle', data_prevista_middle, $2);
        ELSIF tipo_impiegato = 'middle' THEN
            INSERT INTO STORICO (ruolo_prec, nuovo_ruolo, data_scatto, matricola)
            VALUES (NULL, 'junior', data_assunzione, $2);
        END IF;
    END;
$$ LANGUAGE plpgsql;

--________________________________________________________________________________________________________________________________--

--FUNZIONE DI AGGIORNAMENTO DEL DATABASE[...] 0.1
/*
    la funzione aggiorna il database seguendo due linee principali...
    1) verifica se rispetto all'ultima data scatto di un impiegato_attuale vi debbano essere
       ulteriori scatti, nel caso in cui vi fossero vengono aggiunti allo storico e aggiorna il 
       tipo_impiegato (attributo dentro impiegato), in caso contrario 
       non fa niente,
       Algoritmicamente non fa altro che scorrere la lista di impiegati attuali e verifica inanzitutto il tipo,
       se esso è junior va a controllare la data in cui lo è diventato, e verifica con la data odierna :
       Se essa rispetto alla data_scatto sono passati tre anni ma meno di 7 avviene lo scatto a middle,
       se sono passati più di sette anni avvengono due scatti :
       datajunior+3 = scattomiddle
       dataMiddle+4 = dataSenior;

       Nel caso in cui l'impiegato in questione è invece un middle si verifica che la data scatto
       sia ancora nel range rispetto alla data odierna, in caso contrario (sono passati 4 anni), allora diventa
       senior. 

       Nel caso in cui esso è Senior non fa nulla
*/

CREATE OR REPLACE PROCEDURE update_database() AS
$$
    DECLARE
        --cursore di impiegati 
        cursore_impiegati cursor for=(select*
                            from impiegati
                            where data_licenziamento is null);
    BEGIN
        

    END;
$$ LANGUAGE plpgsql;


/*

*/