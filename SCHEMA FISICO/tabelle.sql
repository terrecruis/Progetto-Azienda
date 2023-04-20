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
REFERENZIALITA(referente,cup)
RESPONSABILITA'(responsabile,cup)
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
	dirigente BOOLEAN NOT NULL DEFAULT FALSE,

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
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT id_lab_pk PRIMARY KEY(id_lab)
);

CREATE TABLE IF NOT EXISTS PROGETTO
(
	cup VARCHAR,
	nome_progetto VARCHAR UNIQUE NOT NULL,
	budget DECIMAL(12,2) NOT NULL,
	data_inizio DATE NOT NULL,
	data_fine DATE DEFAULT NULL,  --poichè data_fine non è immediatamente decisa al momento della creazione--
	dirigente VARCHAR NOT NULL,
	referente VARCHAR NOT NULL,

	CONSTRAINT data_fine_corrente CHECK(data_fine<data_inizio),
	CONSTRAINT stipendio_corretto CHECK(budget > 0),
	CONSTRAINT cup_pk PRIMARY KEY(cup),
	CONSTRAINT responsabile_progetto_fk FOREIGN KEY(dirigente) REFERENCES IMPIEGATO(matricola)
	 ON UPDATE CASCADE,
	CONSTRAINT referente_progetto_fk FOREIGN key(referente) REFERENCES IMPIEGATO(matricola)
	 ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS STORICO
(
	ruolo_prec DOMINIO_IMPIEGATO,
	nuovo_ruolo DOMINIO_IMPIEGATO NOT NULL,
	data_scatto DATE NOT NULL,
	matricola VARCHAR,

	CONSTRAINT storico_pk PRIMARY KEY(nuovo_ruolo, matricola),
	CONSTRAINT matricola_fk FOREIGN KEY(matricola) REFERENCES IMPIEGATO(matricola),
	CONSTRAINT check_ruolo CHECK(((ruolo_prec = NULL) AND (nuovo_ruolo = 'junior')) or 
								  ((ruolo_prec = 'junior') AND (nuovo_ruolo = 'middle')) or
								  ((ruolo_prec = 'middle') AND (nuovo_ruolo = 'senior')))
	
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
);

CREATE TABLE IF NOT EXISTS GESTIONE
(
	cup VARCHAR NOT NULL,
	id_lab   VARCHAR NOT NULL,

	CONSTRAINT cup_id_pk PRIMARY KEY(cup, id_lab),
	CONSTRAINT gestione_progetto_pk FOREIGN KEY(cup) REFERENCES PROGETTO(cup),
	CONSTRAINT gestione_laboratorio_pk FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_lab)
);

CREATE TABLE IF NOT EXISTS RESPONSABILITA
(
	cup varchar NOT NULL
	responsabile varchar not NULL

	constraint pk_respnsabilità primary key(cup,responsabile),
	constraint fk_cup FOREIGN key(cup) REFERENCES PROGETTO(cup),
	constraint fk_responsabile FOREIGN key(responsabile) REFERENCES IMPIEGATO(matricola)

);

CREATE TABLE IF NOT EXISTS REFERENZIALITA
(
	cup varchar NOT NULL
	referente varchar not NULL

	constraint pk_respnsabilità primary key(cup,referente),
	constraint fk_cup FOREIGN key(cup) REFERENCES PROGETTO(cup),
	constraint fk_referente FOREIGN key(referente) REFERENCES IMPIEGATO(matricola)

);

/*	
	IDEA SUI TRIGGER DA FARE E LAVORO DA SVOLGERE[...]

	Creazione di almeno VIEW :
	1. Storico di un impiegato : Nome, Cognome, DATASCATTOJUNIOR, DATASCATTOMIDDLE, DATASCATTASENIOR, DIRIGENTE.
	2. Progetto : NomeProg, LABORATORIO1_ID, LABORATORIO2_ID, LABORATORIO3_ID, NUMERO TOTALI AFFERENTI.
	3. Stipendi medi per laboratorio : Laboratorio, avg(stipendio)

	_________________________________________________________________________________________________________________

	TRIGGER SU IMPIEGATO:
	
	(parte sullo storico e aggiornamento del database)
	0.0 Ogni volta che aggiungo un impiegato va aggioranta la tabella Storico, inserendo all'interno l'impiegato con 
		ruolo_prec = NULL e nuovo_ruolo=junior

	0.1 Creare una funzione di aggiornamento database che quando chiamata, mi aggiunge, se si verificano le condizioni,
		i nuovi scatti di carriera fatti dagli impiegati, verifica che sulla tabella delle gestioni,
		nel caso in cui i progetti sono stati finiti, allora elimino dalla tabella gestione (stessa funz 1.3)
		aggiorna_database();

	0.2 potremmo fare qualche vincolo di integrita semantica
		(esempio un junior non puo avere lo stipendio piu alto di un senior)

	_________________________________________________________________________________________________________________


	TRIGGER SUL PROGETTO:

	1.0 se elimino un progetto elimino anche da responsabilità e referenzialità le tuple.

	1.1 quando aggiungo un referente e un responsabile devo fare in modo tale che sia il primo senior il secondo dirigente,
		altrimenti mando un messaggio di errore e non faccio l'inserimento.

	1.15 se si aggiorna un responsabile o un referente allora si aggiorna nelle corrispettive tabelle di associazione la matricola
		associata a quel progetto, eliminando quella precedente.

	1.2 Un progetto ha al più tre laboratori associati. (sulla tabella gestione).

	1.3 nel caso in cui sul progetto viene inserito la data di fine, allora bisogna eliminare nella tabella (gestione)
		tutti i laboratori associati.

	1.4 nel momento in cui inserisco un nuovo progetto, allora devo aggiungere alla tabella responsabilità la coppia
		(dirigente,cup) e devo aggiungere nella tabella refenzialità la nuova (referente,cup).

	_________________________________________________________________________________________________________________


	TRIGGER SU LABORATORIO:

	2.0 controllo in caso in cui elimino un responsabile scientifico, allora bisogna riassegnare quel lab ad un altro
		responsabile scientifico.

	2.05 quando aggiorno un responsabile scientifico, controllo se il nuovo valore è un senior, altrimenti rollback
	
	2.1 quando aggiungo un responsabile scientifico esso dev'essere un senior, altrimenti elimina la tupla 
		lanciando un messaggio di eccezione.

	2.2 controllare che un impiegato non lavora per più di otto ore al giorno (tabella afferenza), altrimenti
		lanciare un messaggio di errore.
	

	_________________________________________________________________________________________________________________
*/





























































































/*
	DUMP DATABASE [...]
*/


--INSERIMENTO NELLA TABELLA IMPIEGATO
INSERT INTO IMPIEGATO(matricola, nome, cognome, cf, curriculum, stipendio, sesso, tipo_impiegato, dirigente)
VALUES
('MAT-001', 'Mario', 'Rossi', 'RSSMRA85H12G123A', 'Laurea in Informatica', 3000.00, 'M', 'junior', false),
('MAT-002', 'Luigi', 'Bianchi', 'BNCLGI83E11G123B', 'Dottorato in Fisica Teorica', 4500.00, 'M', 'senior', true),
('MAT-003', 'Giovanni', 'Verdi', 'VRDGNN80L12G123C', 'Laurea in Economia', 2500.00, 'M', 'middle', false),
('MAT-004', 'Roberta', 'Neri', 'NRIRBT81P12G123D', 'Specializzazione in Psicologia Clinica', 3500.00, 'F', 'senior', true),
('MAT-005', 'Silvia', 'Ferrari', 'FRRSLV79E11G123E', 'Master in Marketing', 2800.00, 'F', 'middle', false),
('MAT-006', 'Francesco', 'Russo', 'RSSFNC78H12G123F', 'Laurea in Ingegneria Meccanica', 3200.00, 'M', 'junior', false),
('MAT-007', 'Chiara', 'Romano', 'RMNCHI77E11G123G', 'Dottorato in Biologia Molecolare', 4200.00, 'F', 'senior', true),
('MAT-008', 'Alessio', 'Esposito', 'ESPLSS84T12G123H', 'Master in Scienze Politiche', 2900.00, 'M', 'middle', false),
('MAT-009', 'Paolo', 'Colombo', 'CLBPLA82P12G123I', 'Laurea in Architettura', 2700.00, 'M', 'junior', false),
('MAT-010', 'Federica', 'Conti', 'CNTFDR80L12G123J', 'Master in Lingue Straniere per il Turismo', 2600.00, 'F', 'middle', false),
('MAT-011', 'Marco', 'Rossi', 'RSSMRC85H12G123K', 'Laurea in Informatica', 3000.00, 'M', 'junior', false),
('MAT-012', 'Simone', 'Bianchi', 'BNCSMN83E11G123L', 'Dottorato in Fisica Teorica', 4500.00, 'M', 'senior', true),
('MAT-013', 'Laura', 'Verdi', 'VRDLRA80L12G123M', 'Laurea in Economia', 2500.00, 'F', 'middle', false),
('MAT-014', 'Maria', 'Neri', 'NRIMRA81P12G123N', 'Specializzazione in Psicologia Clinica', 3500.00, 'F', 'senior', true),
('MAT-015', 'Enrico', 'Ferrari', 'FRRNRC79E11G123O', 'Master in Marketing', 2800.00, 'M', 'middle', false),
('MAT-016', 'Giuseppe', 'Russo', 'RSSFPE78H12G123P', 'Laurea in Ingegneria Meccanica', 3200.00, 'M', 'junior', false),
('MAT-017', 'Valentina', 'Romano', 'RMNVLN77E11G123Q', 'Dottorato in Biologia Molecolare', 4200.00, 'F', 'senior', true),
('MAT-018', 'Fabio', 'Esposito', 'ESPFBO84T12G123R', 'Master in Scienze Politiche', 2900.00, 'M', 'middle', false),
('MAT-019', 'Claudio', 'Colombo', 'CLBCLD82P12G123S', 'Laurea in Architettura', 2700.00, 'M', 'junior', false),
('MAT-020', 'Chiara', 'Conti', 'CNTCHR80L12G123T', 'Master in Lingue Straniere per il Turismo', 2600.00, 'F', 'middle', false);

--INSERIMENTO NELLA TABELLA LABORATORIO
INSERT INTO LABORATORIO(id_lab, topic, indirizzo, numero_telefono, numero_afferenti, responsabile)
VALUES
('LAB-001', 'Intelligenza Artificiale', 'Via Roma 123, Milano', '02 12345678', 5, 'MAT-001'),
('LAB-002', 'Scienze Ambientali', 'Via Dante 45, Torino', '011 1234567', 7, 'MAT-002'),
('LAB-003', 'Ingegneria dei Materiali', 'Via Garibaldi 9, Bologna', '051 123456', 4, 'MAT-003'),
('LAB-004', 'Scienze della Comunicazione', 'Corso Vittorio Emanuele II 67, Roma', '06 1234567', 6, 'MAT-004'),
('LAB-005', 'Chimica Industriale', 'Via dei Mille 32, Napoli', '081 123456', 3, 'MAT-005'),
('LAB-006', 'Fisica Applicata', 'Piazza San Marco 15, Venezia', '041 12345', 8, 'MAT-006'),
('LAB-007', 'Scienze della Terra', 'Via Palestro 87, Firenze', '055 1234567', 5, 'MAT-007'),
('LAB-008', 'Medicina e Salute', 'Via Larga 14, Bari', '080 123456', 9, 'MAT-008'),
('LAB-009', 'Ingegneria Civile', 'Viale Europa 123, Genova', '010 1234567', 4, 'MAT-009'),
('LAB-010', 'Scienze della Formazione', 'Via XX Settembre 50, Palermo', '091 1234567', 6, 'MAT-010');

--INSERIMENTO NELLA TABELLA PROGETTO
INSERT INTO PROGETTO(cup, nome_progetto, budget, data_inizio, data_fine, dirigente, referente)
VALUES
('PRG-001', 'Sviluppo Applicazioni Web', 150000.00, '2022-01-01', '2022-12-31', 'MAT-001', 'MAT-002'),
('PRG-002', 'Ricerca sulle Energie Rinnovabili', 250000.00, '2022-03-01', '2023-02-28', 'MAT-003', 'MAT-004'),
('PRG-003', 'Sistemi di Intelligenza Artificiale per la Sanità', 350000.00, '2022-05-01', '2023-04-30', 'MAT-005', 'MAT-006'),
('PRG-004', 'Analisi del Territorio con Droni', 200000.00, '2022-07-01', '2023-06-30', 'MAT-007', 'MAT-008'),
('PRG-005', 'Ricerca sulla Chimica dei Materiali', 300000.00, '2022-09-01', '2023-08-31', 'MAT-009', 'MAT-010');








