

CREATE TABLE IF NOT EXISTS IMPIEGATO
(
	matricola VARCHAR PRIMARY KEY,
	nome CHAR NOT NULL,
	cognome CHAR NOT NULL,
	codice_fiscale VARCHAR NOT NULL UNIQUE,
	curriculum VARCHAR,
	stipendio DECIMAL NOT NULL,
	sesso CHAR NOT NULL,
	path_foto VARCHAR,/** in alternativa uso il tipo blob ma è menu pulito come metodo */
	tipo_impiegato CHAR NOT NULL,
	isDirigente BOOLEAN NOT NULL,
);

CREATE TABLE IF NOT EXISTS LABORATORIO
(
	id_laboratorio VARCHAR PRIMARY KEY,
	topic CHAR NOT NULL,
	indirizzo VARCHAR NOT NULL,
	numero_telefono INTEGER NOT NULL,
	CONSTRAINT fk_responsabile_scientifico FOREIGN KEY(mat_responsabile) REFERENCES IMPIEGATO(matricola) 
);

CREATE TABLE IF NOT EXISTS PROGETTO
{
	cup VARCHAR PRIMARY KEY,
	nome_progetto VARCHAR UNIQUE NOT NULL,
	budget DECIMAL NOT NULL,
	CONSTRAINT fk_responsabile_progetto FOREIGN KEY(mat_responsabile_progetto) REFERENCES IMPIEGATO(matricola) 

};

CREATE TABLE IF NOT EXISTS STORICO
(
	ruolo_prec VARCHAR NOT NULL,
	nuovo_ruolo VARCHAR NOT NULL,
	data_scatto DATE NOT NULL,
);

CREATE TABLE IF NOT EXISTS AFFERENZA
(
	ore_giornaliere INTEGER NOT NULL,
	tipo_contrattp VARCHAR NOT NULL,
	CONSTRAINT fk_afferenza_impiegato FOREIGN KEY(mat_impiegato) REFERENCES IMPIEGATO(matricola) 
	CONSTRAINT fk_afferenza_laboratorio FOREIGN KEY(id_lab) REFERENCES LABORATORIO(id_laboratorio)
);

CREATE TABLE IF NOT EXISTS GESTIONE
(
	CONSTRAINT fk_gestione_progetto FOREIGN KEY(cup_prog) REFERENCES PROGETTO(cup) 
	CONSTRAINT fk_gestione_laboratorio FOREIGN KEY(id_labb) REFERENCES LABORATORIO(id_laboratorio)
);