/*
	Questa parte è inerente al DDL : Data Definition Language 
*/


/*
	SCHEMA LOGICO:

IMPIEGATO(matricola, nome, cognome, cf, curriculum, stipendio, sesso, foto, tipo, dirigente)
LABORATORIO(id_lab, topic, indirizzo, numero_telefono, numero_afferenti, responsabile)
PROGETTO(CUP, nome_progetto, budget, data_inizio, data_fine, dirigente, referente)
STORICO(ruolo_prec, nuovo_ruolo, data_scatto, matricola)
AFFERENZA(matricola, id_lab, ore_giornaliere, tipo_contratto)
GESTIONE(cup, id_lab)

*/



CREATE DOMAIN DOMINIO_IMPIEGATO AS VARCHAR CHECK(VALUE IN('junior','middle','senior'));
CREATE DOMAIN DOMINIO_CONTRATTO AS VARCHAR CHECK(VALUE IN('determinato','indeterminato'));


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
	dirigente BOOLEAN NOT NULL DEFAULT 0,

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
	numero_afferenti INTEGER DEFAULT 0,
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
	data_fine DATE DEFAULT NULL,  				--poichè data_fine non è immediatamente decisa al momento della creazione--
	dirigente VARCHAR NOT NULL,
	referente VARCHAR NOT NULL,


	CONSTRAINT stipendio_corretto CHECK(budget > 0),
	CONSTRAINT cup_pk PRIMARY KEY(cup),
	CONSTRAINT responsabile_progetto_fk FOREIGN KEY(dirigente) REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE,

	CONSTRAINT referente_progetto_fk FOREIGN key(referente)    REFERENCES IMPIEGATO(matricola)
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS STORICO
(
	ruolo_prec DOMINIO_IMPIEGATO,
	nuovo_ruolo DOMINIO_IMPIEGATO NOT NULL,
	data_scatto DATE NOT NULL,
	matricola VARCHAR,

	CONSTRAINT storico_pk PRIMARY KEY(nuovo_ruolo, matricola),
	CONSTRAINT matricola_fk FOREIGN KEY(matricola) REFERENCES IMPIEGATO(matricola)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AFFERENZA
(
	ore_giornaliere INTEGER NOT NULL,
	tipo_contratto DOMINIO_CONTRATTO NOT NULL,
	matricola VARCHAR NOT NULL,
	id_lab VARCHAR NOT NULL,

	CONSTRAINT matricola_afferenza_pk PRIMARY KEY(matricola),
	CONSTRAINT impiegato_afferenza_fk FOREIGN KEY(matricola) REFERENCES IMPIEGATO(matricola)
		ON DELETE CASCADE 	ON UPDATE CASCADE,
	CONSTRAINT afferenza_laboratorio_fk FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_lab)
		ON DELETE CASCADE	ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS GESTIONE
(
	cup_prog VARCHAR NOT NULL,
	id_lab   VARCHAR NOT NULL,

	CONSTRAINT cup_id_pk PRIMARY KEY(cup_prog, id_lab),
	CONSTRAINT gestione_progetto_pk FOREIGN KEY(cup_prog) REFERENCES PROGETTO(cup)
		ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT gestione_laboratorio_pk FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_lab)
		ON UPDATE CASCADE	ON DELETE CASCADE
);

/*	

	Creazione di almeno VIEW :
	1. Storico di un impiegato : Nome, Cognome, DATASCATTOJUNIOR, DATASCATTOMIDDLE, DATASCATTASENIOR, DIRIGENTE.
	2. Progetto : NomeProg, LABORATORIO1_ID, LABORATORIO2_ID, LABORATORIO3_ID, NUMERO TOTALI AFFERENTI.
	3. Stipendi medi per laboratorio : Laboratorio, avg(stipendio)

	TRIGGER:
	1. controllo in caso di delete di un referente o responsabile
	2. potremmo fare qualche vincolo di integrita semantica
		(esempio un junior non puo avere lo stipendio piu alto di un senior)
	3. controllare che un impiegato non lavora per più di otto ore al giorno
	4. controllare che per un progetto non vi siano al più di 3 laboratori
	5. controlla che nel momento in cui inserisco all'interno di un progetto, siano definiti referenti e responsabili.
	6. controllo che referente e dirigente di un prog , responsabile di un lab
	7. quando il contratto è determinato,  
	8. quando si inserisci una data_fine ad un progetto, allora rimuovere tutti gli impiegati dai laboratori che lavorano
	   per quel progetto settando dirigente e referente a null[...]
	9. se un laboratorio non lavora su alcun progetto, allora gli impiegati non vi possono partecipare.

	FUNZIONI/PROCEDURE :
	1.
	2.
	3.


	SQL DINAMICO :
	1. 
	2.
	3.
	4.

*/







