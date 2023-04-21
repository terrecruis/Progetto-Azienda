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
		ruolo_prec = NULL e nuovo_ruolo = new.tipo (si presuppone nell'azienda già dipendenti senior)

	0.1 Creare una funzione di aggiornamento database che quando chiamata, mi aggiunge, se si verificano le condizioni,
		i nuovi scatti di carriera fatti dagli impiegati, verifica che sulla tabella delle gestioni,
		nel caso in cui i progetti sono stati finiti, allora elimino dalla tabella gestione (stessa funz 1.3)
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
*/

--TRIGGER 0.0

/*
    NEL MOMENTO IN CUI INSERISCO UN NUOVO IMPIEGATO, AGGIORNO IL SUO STATUS
     ALL'INTERNO DELLO STORICO CON LA DATA DI SCATTO con il tipo inserito 
*/

CREATE OR REPLACE FUNCTION update_storico_impiegato() RETURNS trigger AS
$update_storico$
BEGIN
    --inserisco all'interno dello storico la nuova tupla creata
        INSERT INTO STORICO (ruolo_prec, nuovo_ruolo, data_scatto, matricola)
        VALUES (NULL, NEW.tipo_impiegato, CURRENT_DATE, NEW.matricola);

    RETURN NEW;
END;
$update_storico$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_storico
    AFTER INSERT ON IMPIEGATO
    FOR EACH ROW
    EXECUTE FUNCTION update_storico_impiegato();



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

       Nel caso in cui esso è Senior non fa nulla.

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