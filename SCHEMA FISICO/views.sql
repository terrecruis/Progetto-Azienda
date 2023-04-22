/*

    creazione di views e il loro significato

*/


/*

	SCHEMA LOGICO DEL PROGETTO:

	IMPIEGATO(matricola, nome, cognome, cf, curriculum, stipendio, sesso, foto, tipo, dirigente, data_licenziamento, data_assunzione)
	LABORATORIO(id_lab, topic, indirizzo, numero_telefono, numero_afferenti, responsabile)
	PROGETTO(CUP, nome_progetto, budget, data_inizio, data_fine,responsabile,referente)
	STORICO(ruolo_prec, nuovo_ruolo, data_scatto, matricola)
	AFFERENZA(matricola, id_lab, ore_giornaliere, tipo_contratto)
	GESTIONE(cup, id_lab)
    
*/

--_____________________________________________________________________________________________--

/*
    la tabella impiegati tiene traccia sia degli impiegati attuali sia di quelli licenziati,
    motivo per il quale mi salvo in una view a parte tutti gli impiegati attuali dell'azienda.
*/
CREATE VIEW Impiegati_attuali AS
select*
from Impiegato
where data_licenziamento IS NULL

--_____________________________________________________________________________________________--

/*
    lo storico di un impiegato è formato dalla sua matricola,
    nome,cognome,datascattoJunior,datascattoMiddle, datascattoSenior e se è un dirigente.
    Questa view mi restituisce lo storico di un impiegato      
*/

CREATE or replace VIEW STORICO_VIEW AS (
SELECT i.nome, i.cognome, i.matricola,
       s1.data_scatto AS data_scatto_junior,
       s2.data_scatto AS data_scatto_middle,
       s3.data_scatto AS data_scatto_senior,
       s4.data_scatto AS data_scatto_dirigenza,
       s5.data_scatto AS data_fine_dirigenza,
       i.dirigente
FROM IMPIEGATO i
--uguale matricola ma con storici diversi e scatti diversi.
LEFT JOIN STORICO s1 ON i.matricola = s1.matricola AND s1.nuovo_ruolo = 'junior'
LEFT JOIN STORICO s2 ON i.matricola = s2.matricola AND s2.nuovo_ruolo = 'middle'
LEFT JOIN STORICO s3 ON i.matricola = s3.matricola AND s3.nuovo_ruolo = 'senior'
LEFT JOIN STORICO s4 ON i.matricola = s4.matricola AND s4.nuovo_ruolo = 'Dirigente'
LEFT JOIN STORICO s5 ON i.matricola = s5.matricola AND s5.nuovo_ruolo = 'NonDirigente'
);

 --_____________________________________________________________________________________________--

/*
    view sui laboratori e stipendi medi
*/

CREATE or replace VIEW Stipendio_medio_laboratorio AS (
    select l.id_lab, avg(imp.stipendio) as stipendio_medio
    from (impiegato as imp natural join afferenza as a)
          natural join laboratorio as l
    group by l.id_lab
);

--_____________________________________________________________________________________________--

/*
    VIEW CHE MI MOSTRA I DIRIGENTI[...]
*/
CREATE OR REPLACE VIEW Dirigenti_Attuali AS (
    select *
    from Impiegati_attuali
    where dirigente is true
);

--_____________________________________________________________________________________________--