/*

    VIEW:
    Con le VIEW riusciamo a GESTIRE tutti quei processi ATTUALI dell'Azienda, mentre
    nelle tabelle fisiche salviamo tutto ciò che passa per il database.

*/


/*

	SCHEMA LOGICO DEL PROGETTO:

	IMPIEGATO(matricola, nome, cognome, cf, curriculum, stipendio, sesso, foto, tipo, dirigente, data_licenziamento, data_assunzione)
	LABORATORIO(id_lab, topic, indirizzo, numero_telefono, numero_afferenti, responsabile)
	PROGETTO(CUP, nome_progetto, budget, data_inizio, data_fine,responsabile,referente)
	STORICO(ruolo_prec, nuovo_ruolo, data_scatto, matricola)
	AFFERENZA(matricola, id_lab, ore_giornaliere)
	GESTIONE(cup, id_lab)

*/

--_____________________________________________________________________________________________--

/*
    la tabella impiegati tiene traccia sia degli impiegati attuali sia di quelli licenziati,
    motivo per il quale mi salvo in una view a parte tutti gli impiegati attuali dell'azienda.
*/

CREATE OR REPLACE VIEW Impiegati_attuali AS
select*
from Impiegato
where data_licenziamento IS NULL or data_licenziamento > CURRENT_DATE;

--_____________________________________________________________________________________________--

/*
    lo storico di un impiegato è formato dalla sua matricola,
    nome,cognome,datascattoJunior,datascattoMiddle, datascattoSenior e se è un dirigente.
    Questa view mi restituisce lo storico di un impiegato
*/

CREATE OR REPLACE VIEW STORICO_VIEW AS 
(
    SELECT i.nome, i.cognome, i.matricola,
        s1.data_scatto AS data_scatto_junior,
        s2.data_scatto AS data_scatto_middle,
        s3.data_scatto AS data_scatto_senior,
        i.dirigente
    FROM IMPIEGATO i
    --uguale matricola ma con storici diversi e scatti diversi.
    LEFT JOIN STORICO s1 ON i.matricola = s1.matricola AND s1.nuovo_ruolo = 'junior'
    LEFT JOIN STORICO s2 ON i.matricola = s2.matricola AND s2.nuovo_ruolo = 'middle'
    LEFT JOIN STORICO s3 ON i.matricola = s3.matricola AND s3.nuovo_ruolo = 'senior'
);

 --_____________________________________________________________________________________________--

/*
    view sui laboratori e stipendi medi
*/

CREATE OR REPLACE VIEW Stipendio_medio_laboratorio AS 
(
    select l.id_lab, avg(imp.stipendio) as stipendio_medio
    from (impiegato as imp natural join afferenza as a)
          natural join laboratorio as l
    group by l.id_lab
);

--_____________________________________________________________________________________________--

/*
    VIEW CHE MI MOSTRA I DIRIGENTI[...]
*/

CREATE OR REPLACE VIEW Dirigenti_Attuali AS 
(
    select *
    from Impiegati_attuali
    where dirigente is true 
);

--_____________________________________________________________________________________________--

/*
    VIEW CHE MOSTRA I PROGETTI ATTIVI[...]
*/

CREATE OR REPLACE VIEW Gestione_Attuale AS 
(
    select g.cup,g.id_lab
    from gestione as g natural join progetto as p
    where p.data_fine is null or p.data_fine > CURRENT_DATE
);

--_____________________________________________________________________________________________--
/*
    VIEW DEI RESPONSABILI SCIENTIFICI E I LORO LABORATORI ASSOCIATI
*/

CREATE OR REPLACE VIEW RESPONSABILI_SCIENTIFICI_ATTUALI AS
(
    SELECT l.id_lab, l.r_scientifico
    FROM laboratorio l
);

--_____________________________________________________________________________________________--
/*
    VIEW DEI REFERENTI E I LORO PROGETTI ATTUALI
*/

CREATE OR REPLACE VIEW REFERENTI_ATTUALI AS
(
    SELECT p.cup ,p.referente
    FROM progetto as p 
);

--_____________________________________________________________________________________________--
/*
    VIEW CHE MOSTRA I PROGETTI TERMINATI
*/
CREATE OR REPLACE VIEW PROGETTI_TERMINATI AS
(
    SELECT *
    FROM progetto
    WHERE data_fine < CURRENT_DATE
);

--_____________________________________________________________________________________________--
