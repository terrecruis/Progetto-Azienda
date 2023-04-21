/*
	Questa parte è inerente al DDL : Data Definition Language 
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


--questo vincolo mi assicura il tipo di impiegato attuale.
CREATE DOMAIN DOMINIO_IMPIEGATO AS VARCHAR CHECK(VALUE IN('junior','middle','senior',));
CREATE DOMAIN DOMINIO_CONTRATTO AS VARCHAR CHECK(VALUE IN('determinato','indeterminato'));
--questo dominio mi assicura il tipo di impiegato al momento dello scatto di carriera
CREATE DOMAIN DOMINIO_SCATTO AS VARCHAR CHECK(VALUE IN('junior','middle','senior','dirigente','NonDirigente'));

CREATE TABLE IF NOT EXISTS IMPIEGATO
(
	matricola VARCHAR,
	nome VARCHAR NOT NULL,
	cognome VARCHAR NOT NULL,
	cf CHAR(16) NOT NULL UNIQUE, --codice fiscale
	curriculum VARCHAR,
	stipendio DECIMAL(12,2) NOT NULL,
	sesso CHAR NOT NULL,
	foto BYTEA,
	tipo_impiegato DOMINIO_IMPIEGATO NOT NULL DEFAULT 'junior',
	dirigente BOOLEAN NOT NULL DEFAULT FALSE,
	data_licenziamento date DEFAULT null,
	data_assunzione date not null;


	CONSTRAINT data_corretta CHECK(data_assunzione<data_licenziamento);
	CONSTRAINT impiegato_pk PRIMARY KEY(matricola),
	CONSTRAINT stipendio_corretto CHECK(stipendio > 0),
	CONSTRAINT sesso_corretto CHECK(sesso = 'M' OR sesso = 'F')
);

CREATE TABLE IF NOT EXISTS LABORATORIO
(
	id_lab VARCHAR,
	topic VARCHAR NOT NULL,
	indirizzo VARCHAR NOT NULL,
	numero_telefono VARCHAR,
	numero_afferenti INTEGER DEFAULT 1,
	responsabile VARCHAR NOT NULL,

	CONSTRAINT responsabile_scientifico_fk FOREIGN KEY(responsabile) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,
	CONSTRAINT id_lab_pk PRIMARY KEY(id_lab)
);

CREATE TABLE IF NOT EXISTS PROGETTO
(
	cup VARCHAR,
	nome_progetto VARCHAR UNIQUE NOT NULL,
	budget DECIMAL(12,2) NOT NULL,
	data_inizio DATE NOT NULL,
	data_fine DATE DEFAULT NULL,  --poichè data_fine non è immediatamente decisa al momento della creazione--
	responsabile varchar NOT NULL, --perchè il responsabile si conosce a priori
	referente varchar not null,   --perchè il referente si conosce a priori
	CONSTRAINT data_fine_corrente CHECK(data_fine<data_inizio),
	CONSTRAINT budget_corretto CHECK(budget > 0),
	CONSTRAINT cup_pk PRIMARY KEY(cup),

	--nel caso in cui aggiorno la matricola in impiegato allora l'aggiorno anche in progetto.
	constraint pk_respnsabilità FOREIGN KEY(responsabile) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,
	constraint pk_referente FOREIGN KEY(referente) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS STORICO
(
	ruolo_prec DOMINIO_IMPIEGATO,
	nuovo_ruolo DOMINIO_SCATTO NOT NULL, 
	data_scatto DATE NOT NULL,
	matricola VARCHAR,

	CONSTRAINT storico_pk PRIMARY KEY(nuovo_ruolo, matricola),
	CONSTRAINT matricola_fk FOREIGN KEY(matricola) REFERENCES IMPIEGATO(matricola),
	CONSTRAINT check_ruolo CHECK(((ruolo_prec is NULL) AND (nuovo_ruolo = 'junior')) or 
								  ((ruolo_prec = 'junior') AND (nuovo_ruolo = 'middle')) or
								  ((ruolo_prec = 'middle') AND (nuovo_ruolo = 'senior'))  or
								  	(ruolo_prec = 'NonDirigente') AND (nuovo_ruolo = 'dirigente')
									(ruolo_prec = 'dirigente') AND (nuovo_ruolo = 'NonDirigente'));

 --tutti i possibili scatti di ruolo affinchè sia valido.
);

CREATE TABLE IF NOT EXISTS AFFERENZA
(
	ore_giornaliere INTEGER NOT NULL,
	tipo_contratto DOMINIO_CONTRATTO NOT NULL,
	matricola VARCHAR NOT NULL,
	id_lab VARCHAR NOT NULL,

	CONSTRAINT matricola_afferenza_pk PRIMARY KEY(matricola),
	CONSTRAINT impiegato_afferenza_fk FOREIGN KEY(matricola) REFERENCES IMPIEGATO(matricola)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT afferenza_laboratorio_fk FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_lab)
		ON UPDATE CASCADE ON DELETE CASCADE

	/*
		cosi assicuro che se viene cancaellato un impiegato allora viene eliminato anche in questa tabella.
		e analogamente se viene eliminato il laboratorio assocuro di eliminare da afferenza tutti gli impiegati
		che afferiscono a quel laboratorio.
	*/
);

CREATE TABLE IF NOT EXISTS GESTIONE
(
	cup VARCHAR NOT NULL,
	id_lab   VARCHAR NOT NULL,

	CONSTRAINT cup_id_pk PRIMARY KEY(cup, id_lab),
	CONSTRAINT gestione_progetto_pk FOREIGN KEY(cup) REFERENCES PROGETTO(cup)
		ON UPDATE CASCADE ON DELETE CASCADE ,
	CONSTRAINT gestione_laboratorio_pk FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_lab)
		ON UPDATE CASCADE ON DELETE CASCADE

  /*
	garantisco che nel caso in cui siano eliminato i progetti o i laboratori, eliminare tutte le tuple di gestione
	con quei codici.
  */
);


/*	
	_________________________________________________________________________________________________________________

	TRIGGER SU IMPIEGATO:
	
	(parte sullo storico e aggiornamento del database)
1	0.0 Ogni volta che aggiungo un impiegato va aggioranta la tabella Storico, inserendo all'interno l'impiegato con 
		ruolo_prec = NULL e nuovo_ruolo=junior (si presuppone nell'azienda già dipendenti senior)

2	0.1 Creare una funzione di aggiornamento database che quando chiamata, mi aggiunge, se si verificano le condizioni,
		i nuovi scatti di carriera fatti dagli impiegati, verifica che sulla tabella delle gestioni,
		nel caso in cui i progetti sono stati finiti, allora elimino dalla tabella gestione (stessa funz 1.3)
		aggiorna_database(); (quando la data è inserita nel momento di creazione della tupla)

3	0.2 potremmo fare qualche vincolo di integrita semantica
		(esempio un junior non puo avere lo stipendio piu alto di un senior)

4	0.3 (delete)Nel momento in cui elimino un dirigente che è associato ad un progetto allora devo chiedere all'utente di sostituire
		il responsabile di quel progetto altrimenti lanciando un messaggio di errore.
		stessa cosa per referente per un progetto e un responsabile scientifico per quel progetto.
		Questo giustificato dal fatto che un progetto non può esserci senza responsabile e referente,
		e un laboratorio non può esserci senza un referente scientifico.

	_________________________________________________________________________________________________________________


	TRIGGER SUL PROGETTO:

5	1.0 (delete pro) se elimino prog allora elimino l'associazione tra i laboratori e quel progetto.

6	1.1 (insert prog) quando aggiungo un referente e un responsabile devo fare in modo tale 
		che sia il primo senior e il secondo dirigente,
		altrimenti mando un messaggio di errore e non faccio l'inserimento.

7	1.15(update referente, matricola) se si aggiorna un responsabile o un referente allora si verifichi che il nuovo
		valore sia assegnabile. 

8	1.2(vincolo di gestione) Un progetto ha al più tre laboratori associati. (sulla tabella gestione).

9	1.3(update data fine) nel caso in cui sul progetto viene inserito la data di fine (RISPETTO A OGGI), 
		allora bisogna eliminare nella tabella (gestione)
		tutti i laboratori associati.

	_________________________________________________________________________________________________________________


	TRIGGER SU LABORATORIO:


10	2.05 quando aggiorno un responsabile scientifico, controllo se il nuovo valore è un senior, altrimenti rollback
	
11	2.1 quando aggiungo un responsabile scientifico esso dev'essere un senior, altrimenti elimina la tupla 
		lanciando un messaggio di eccezione.

12	2.2 controllare che un impiegato non lavora per più di otto ore al giorno (tabella afferenza), altrimenti
		lanciare un messaggio di errore.
	
13	2.3 ogni volta che aggiungo o elimino un'afferenza impiegato-laboratorio allora aggiorno il numero di afferenti di quel
		laboratorio.

	_________________________________________________________________________________________________________________

	TRIGGER SULLO STORICO:
14	3.0 Quando modifico l'attributo booleano da (false -> true), allora lo scatto dev'essere registrato nella tabella
		storico, in questo modo riesco a recuperare anche lo scatto dirigenziale fatto.

15	3.1 Nel caso in cui l'attributo booleano passa (true->false) devo prima controllare che il dirigente non abbia
		in gestione un progetto,
	_________________________________________________________________________________________________________________
*/


--tieni traccia dello scatto di carriera dirigente e la sua data_inizio e data_fine
