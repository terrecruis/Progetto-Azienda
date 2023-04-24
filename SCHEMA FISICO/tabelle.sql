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
	data_assunzione date not null;
	data_licenziamento date DEFAULT null,

	CONSTRAINT data_corretta CHECK(data_assunzione < data_licenziamento);
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
	CONSTRAINT data_fine_corrente CHECK(data_fine>data_inizio),
	CONSTRAINT budget_corretto CHECK(budget > 0),
	CONSTRAINT cup_pk PRIMARY KEY(cup),

	--nel caso in cui aggiorno la matricola in impiegato allora l'aggiorno anche in progetto,
	--nel caso di delete, entra un trigger in funzione
	constraint pk_respnsabilità FOREIGN KEY(responsabile) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,
	constraint pk_referente FOREIGN KEY(referente) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS STORICO
(
	--dominio scatto tiene conto anche degli scatti dirigenziali.
	ruolo_prec DOMINIO_SCATTO,
	nuovo_ruolo DOMINIO_SCATTO NOT NULL, 
	data_scatto DATE NOT NULL,
	matricola VARCHAR,

	CONSTRAINT storico_pk PRIMARY KEY(nuovo_ruolo, matricola),
	CONSTRAINT matricola_fk FOREIGN KEY(matricola) REFERENCES IMPIEGATO(matricola),
	--i primi tre casi sono quando inserisco un impiegato già senior o middle, o junior.
	CONSTRAINT check_ruolo CHECK(((ruolo_prec is NULL) AND (nuovo_ruolo = 'junior')) 
								 ((ruolo_prec is NULL) AND (nuovo_ruolo = 'middle'))  
								 ((ruolo_prec is NULL) AND (nuovo_ruolo = 'senior'))
								 or --oppure controllo il corretto flusso di scatti possibili.
								  ((ruolo_prec = 'junior') AND (nuovo_ruolo = 'middle')) or
								  ((ruolo_prec = 'middle') AND (nuovo_ruolo = 'senior'))  or
								  	(ruolo_prec = 'NonDirigente') AND (nuovo_ruolo = 'dirigente') or
									(ruolo_prec = 'dirigente') AND (nuovo_ruolo = 'NonDirigente'));
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


