/*
	Questa parte è inerente al DDL : Data Definition Language 
	in cui creaimo lo Schema, le tabelle, domini, viste, e i vincoli (di tabelle):
	1. Vincoli su valori NULL e valori predefiniti
	2. Vincoli sulle tuple (CHECK)
	3. vincoli sui domini degli attributi
	4. Vincoli di chiave
	5. Vincoli di integrità referenziale
*/



CREATE DOMAIN DOMINIO_IMPIEGATO AS VARCHAR CHECK(VALUE IN('junior','middle','senior'));
CREATE DOMAIN DOMINIO_CONTRATTO AS VARCHAR CHECK(VALUE IN('determinato','indeterminato'));


CREATE TABLE IF NOT EXISTS IMPIEGATO
(
	matricola VARCHAR,
	nome VARCHAR NOT NULL,
	cognome VARCHAR NOT NULL,
	codice_fiscale CHAR(16) NOT NULL UNIQUE,
	curriculum VARCHAR, 
	stipendio DECIMAL(12,2) NOT NULL,
	sesso CHAR NOT NULL,
	foto BYTEA,
	tipo_impiegato DOMINIO_IMPIEGATO NOT NULL,
	dirigente BOOLEAN NOT NULL,

	CONSTRAINT impiegato_pk PRIMARY KEY(matricola),
	CONSTRAINT stipendio_corretto CHECK(stipendio > 0),
	CONSTRAINT sesso_corretto CHECK(sesso = 'M' OR sesso = 'F')
);

CREATE TABLE IF NOT EXISTS LABORATORIO
(
	id_laboratorio VARCHAR,
	topic VARCHAR NOT NULL,
	indirizzo VARCHAR NOT NULL,
	numero_telefono VARCHAR,
	numero_afferenti INTEGER DEFAULT 0,
	mat_responsabile VARCHAR NOT NULL,

	CONSTRAINT responsabile_scientifico_fk FOREIGN KEY(mat_responsabile) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,
	CONSTRAINT id_laboratorio_pk PRIMARY KEY(id_laboratorio)
);

CREATE TABLE IF NOT EXISTS PROGETTO
(
	cup VARCHAR,
	nome_progetto VARCHAR UNIQUE NOT NULL,
	budget DECIMAL(12,2) NOT NULL,
	data_inizio DATE NOT NULL,
	data_fine DATE,  				--poichè data_fine non è immediatamente decisa al momento della creazione--
	mat_dirigente VARCHAR NOT NULL,
	mat_referente VARCHAR NOT NULL,

	CONSTRAINT cup_pk PRIMARY KEY(cup),
	CONSTRAINT responsabile_progetto_fk FOREIGN KEY(mat_dirigente) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,

	CONSTRAINT referente_progetto_fk FOREIGN key(mat_referente)    REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS STORICO
(
	ruolo_prec DOMINIO_IMPIEGATO,
	nuovo_ruolo DOMINIO_IMPIEGATO NOT NULL,
	data_scatto DATE NOT NULL,
	mat_impiegato VARCHAR,

	CONSTRAINT storico_pk PRIMARY KEY(nuovo_ruolo, mat_impiegato),
	CONSTRAINT mat_impiegato_fk FOREIGN KEY(mat_impiegato) REFERENCES IMPIEGATO(matricola)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AFFERENZA
(
	ore_giornaliere INTEGER NOT NULL,
	tipo_contratto DOMINIO_CONTRATTO NOT NULL,
	mat_impiegato VARCHAR NOT NULL,
	id_lab VARCHAR NOT NULL,

	CONSTRAINT mat_impiegato_afferenza_pk PRIMARY KEY(mat_impiegato),
	CONSTRAINT impiegato_afferenza_fk FOREIGN KEY(mat_impiegato) REFERENCES IMPIEGATO(matricola)
		ON DELETE CASCADE 	ON UPDATE CASCADE,
	CONSTRAINT afferenza_laboratorio_fk FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_laboratorio)
		ON DELETE CASCADE	ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS GESTIONE
(
	cup_prog VARCHAR NOT NULL,
	id_lab   VARCHAR NOT NULL,

	CONSTRAINT cup_id_pk PRIMARY KEY(cup_prog, id_lab),
	CONSTRAINT gestione_progetto_pk FOREIGN KEY(cup_prog) REFERENCES PROGETTO(cup)
		ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT gestione_laboratorio_pk FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_laboratorio)
		ON UPDATE CASCADE	ON DELETE CASCADE
);

/*Creazione di almeno DUE VIEW :
	1. Storico di un impiegato : Nome, Cognome, DATASCATTOJUNIOR, DATASCATTOMIDDLE, DATASCATTASENIOR. 
	2. Progetto : NomeProg, LABORATORIO1_ID, LABORATORIO2_ID, LABORATORIO3_ID, NUMERO TOTALI AFFERENTI. 
*/