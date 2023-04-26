/*
	Questa parte è inerente al DDL : Data Definition Language 
	L’azienda possiede un certo numero di impiegati, raggruppabili in 4 categorie:
	1- Dipendente junior: colui che lavora da meno di 3 anni all’interno dell’azienda;
	2- Dipendente middle: colui che lavora da meno di 7 ma da più di tre anni per l’azienda;
	3- Dipendente senior: colui che lavora da almeno 7 anni per l’azienda.
	4- Dirigenti: la classe dirigente non ha obblighi temporali di servizio. Chiunque può diventare dirigente,
	se mostra di averne le capacità.
	I passaggi di ruolo avvengono per anzianità di servizio. 
	È necessario tracciare tutti gli scatti di carriera per ogni dipendente.
	Nell’azienda vengono gestiti laboratori e progetti. 
	Un laboratorio ha una particolare topic di cui si occupa, 
	un certo numero di afferenti ed un responsabile scientifico che è un dipendente senior. 
	Un progetto è identificato da un CUP (codice unico progetto) e da un nome (unico nel sistema). 
	Ogni progetto ha un referente scientifico, il quale deve essere un dipendente senior dell’ente, 
	ed un responsabile che è uno dei dirigenti. Al massimo 3 laboratori possono lavorare ad un progetto.

*/


/*
	SCHEMA LOGICO:

	IMPIEGATO(matricola, nome, cognome, cf, curriculum, stipendio, sesso, foto, tipo, dirigente, data_licenziamento, data_assunzione)
	LABORATORIO(id_lab, topic, indirizzo, numero_telefono, numero_afferenti, responsabile)
	PROGETTO(CUP, nome_progetto, budget, data_inizio, data_fine,responsabile,referente)
	STORICO(ruolo_prec, nuovo_ruolo, data_scatto, matricola)
	AFFERENZA(matricola, id_lab, ore_giornaliere)
	GESTIONE(cup, id_lab)
	
*/

/*______________________________________________________________________________________________________________________________*/

-- DOMINI DI ALCUNI ATTRIBUTI :

--fare dominio sesso e genere
CREATE DOMAIN DOMINIO_SESSO AS CHAR CHECK(VALUE IN('M','F','N'));
--FARE DOMINIO MATRICOLA
CREATE DOMAIN DOMINIO_MATRICOLA AS VARCHAR(8) CHECK(VALUE LIKE('MAT-%'));
--DOMINIO DELL'IMPIEGATO
CREATE DOMAIN DOMINIO_IMPIEGATO AS VARCHAR CHECK(VALUE IN('junior','middle','senior'));
--DOMINIO DELLO SCATTO DELL'IMPIEGATO
CREATE DOMAIN DOMINIO_SCATTO AS VARCHAR CHECK(VALUE IN('junior','middle','senior','dirigente','NonDirigente'));

/*______________________________________________________________________________________________________________________________*/

CREATE TABLE IF NOT EXISTS IMPIEGATO
(
	matricola DOMINIO_MATRICOLA,
	nome VARCHAR NOT NULL,
	cognome VARCHAR NOT NULL,
	cf CHAR(16) NOT NULL UNIQUE, 
	curriculum VARCHAR,
	stipendio DECIMAL(12,2) NOT NULL,
	sesso DOMINIO_SESSO NOT NULL,
	foto BYTEA,
	tipo_impiegato DOMINIO_IMPIEGATO NOT NULL DEFAULT 'junior',
	dirigente BOOLEAN NOT NULL DEFAULT FALSE,
	data_assunzione date not null,
	data_licenziamento date DEFAULT null,

	CONSTRAINT data_corretta CHECK(data_assunzione < data_licenziamento),
	CONSTRAINT impiegato_pk PRIMARY KEY(matricola),
	CONSTRAINT stipendio_corretto CHECK(stipendio > 0)
);

CREATE TABLE IF NOT EXISTS LABORATORIO
(
	id_lab VARCHAR,
	topic VARCHAR NOT NULL,
	indirizzo VARCHAR NOT NULL,
	numero_telefono VARCHAR(12), 
	numero_afferenti INTEGER DEFAULT 1,
	r_scientifico DOMINIO_MATRICOLA NOT NULL UNIQUE,

	CONSTRAINT responsabile_scientifico_fk FOREIGN KEY(r_scientifico) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,
	CONSTRAINT id_lab_pk PRIMARY KEY(id_lab)
);

CREATE TABLE IF NOT EXISTS PROGETTO
(
	cup VARCHAR,
	nome_progetto VARCHAR UNIQUE NOT NULL,
	budget DECIMAL(12,2) NOT NULL,
	data_inizio DATE NOT NULL,
	data_fine DATE DEFAULT NULL,  
	responsabile DOMINIO_MATRICOLA NOT NULL, 
	referente DOMINIO_MATRICOLA NOT NULL,  
	CONSTRAINT data_fine_corrente CHECK(data_fine>data_inizio),
	CONSTRAINT budget_corretto CHECK(budget > 0),
	CONSTRAINT cup_pk PRIMARY KEY(cup),

	CONSTRAINT data_corretta CHECK(data_fine > data_inizio),
	constraint pk_respnsabilità FOREIGN KEY(responsabile) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,
	constraint pk_referente FOREIGN KEY(referente) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS STORICO
(
	ruolo_prec DOMINIO_SCATTO,
	nuovo_ruolo DOMINIO_SCATTO NOT NULL, 
	data_scatto DATE NOT NULL,
	matricola DOMINIO_MATRICOLA,

	--in questo modo, un impiegato non può fare lo stesso scatto dirigenziale  nello stesso giorno,
	--aggiungendo alla primary key anche la data_scatto.
	CONSTRAINT storico_pk PRIMARY KEY(nuovo_ruolo, matricola,data_scatto),
	CONSTRAINT matricola_fk FOREIGN KEY(matricola) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT check_ruolo CHECK(((ruolo_prec is NULL) AND (nuovo_ruolo = 'junior')) OR 
								  ((ruolo_prec = 'junior') AND (nuovo_ruolo = 'middle')) OR
								  ((ruolo_prec = 'middle') AND (nuovo_ruolo = 'senior'))  OR
								  	(ruolo_prec = 'NonDirigente') AND (nuovo_ruolo = 'dirigente') OR
									(ruolo_prec = 'dirigente') AND (nuovo_ruolo = 'NonDirigente'))
);

CREATE TABLE IF NOT EXISTS AFFERENZA
(
	ore_giornaliere INTEGER NOT NULL,
	matricola DOMINIO_MATRICOLA NOT NULL,
	id_lab VARCHAR NOT NULL,

	CONSTRAINT matricola_afferenza_pk PRIMARY KEY(matricola,id_lab),
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


