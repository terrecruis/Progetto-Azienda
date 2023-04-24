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

OK	0.0 Ogni volta che aggiungo un impiegato va aggioranta la tabella Storico, inserendo all'interno l'impiegato con 
		ruolo_prec = NULL e nuovo_ruolo = new.tipo, nel caso in cui il tipo inserito sia >junior allora, inserisco
        all'interno dello storico il resto degli scatti di carriera rimanenti.

OK	0.1 Creare una funzione di aggiornamento database che quando chiamata, mi aggiunge, se si verificano le condizioni,
		i nuovi scatti di carriera fatti dagli impiegati e il loro attributo 'tipo_impiegato'
		aggiorna_database(); (quando la data è inserita nel momento di creazione della tupla)

	0.2 potremmo fare qualche vincolo di integrita semantica
		(esempio un junior non puo avere lo stipendio piu alto di un senior)

OK	0.3 (delete)Nel momento in cui elimino un dirigente che è associato ad un progetto allora devo chiedere all'utente di sostituire
		il responsabile di quel progetto altrimenti lanciando un messaggio di errore.
		stessa cosa per referente per un progetto e un responsabile scientifico per quel progetto.
		Questo giustificato dal fatto che un progetto non può esserci senza responsabile e referente,
		e un laboratorio non può esserci senza un referente scientifico.

 OK   0.4(update false->true)nel caso in cui viene aggiornato l'attributo booleano dirigente in Impiegato, allora
        bisogna inserire la data scatto all'interno dello storico.
        (update true->false)nel caso in cui il dirigente gestisce qualche progetto mandare messaggio di errore, altrimenti,
        fare inserimento all'interno dello storico della data_scatto 'nonDirigente'->'dirigente'.

    _________________________________________________________________________________________________________________________________
    	TRIGGER SUL PROGETTO:

OK	1.0 (insert prog) quando aggiungo un referente e un responsabile devo fare in modo tale 
		che sia il primo senior e il secondo dirigente,
		altrimenti mando un messaggio di errore e non faccio l'inserimento.

OK	1.1(update referente, matricola) se si aggiorna un responsabile o un referente allora si verifichi che il nuovo
		valore sia assegnabile. 

ok	1.2(vincolo di gestione) Un progetto ATTIVI (data fine = null) ha al più 
		tre laboratori associati. (sulla tabella gestione).

	_________________________________________________________________________________________________________________

	TRIGGER SU LABORATORIO:
	2.0 verifica che un responsabile scientifico sia unico e senior per ogni laboratorio diverso.

	2.05 quando aggiorno un responsabile scientifico, controllo se il nuovo valore è un senior, altrimenti rollback
	
	2.1 quando aggiungo un responsabile scientifico esso dev'essere un senior, altrimenti elimina la tupla 
		lanciando un messaggio di eccezione.

	2.2 controllare che un impiegato non lavora per più di otto ore al giorno (tabella afferenza), altrimenti
		lanciare un messaggio di errore.
	
	2.3 ogni volta che aggiungo o elimino un'afferenza impiegato-laboratorio allora aggiorno il numero di afferenti di quel
		laboratorio.

	_________________________________________________________________________________________________________________
*/





--________________________________________________________________________________________________________________________________--

/*
    --TRIGGER 0.0 : INSERIMENTO DI UN IMPIEGATO, CONTROLLO VALIDITA' DI DATA E NEL CASO POSITIVO AGGIUNGO NELLO STORICO.

    NEL MOMENTO IN CUI INSERISCO UN NUOVO IMPIEGATO, AGGIORNO IL SUO STATUS
    ALL'INTERNO DELLO STORICO CON LA DATA DI SCATTO CON IL TIPO INSERITO,
    NEL CASO IN CUI IL TIPO E' >JUNIOR, ALLORA INSERISCE ANCHE GLI ALTRI SCATTI,
    CALCOLANDOLI GRAZIE ALLA DATA DI ASSUNZIONE.
*/

--si implementi un trigger che all inserimento di un impiegato si occupi di inserire i suoi scatti di carriera nella tab storico

CREATE OR REPLACE FUNCTION f_insert_storico() RETURNS TRIGGER AS
$$
    BEGIN
        -- Check if the hiring date is consistent with the role to allow insertion
        IF (NEW.tipo_impiegato = 'junior') THEN
            IF((NEW.data_assunzione + INTERVAL '3 years') >= CURRENT_DATE ) THEN  
                INSERT INTO storico VALUES (NULL, 'junior', NEW.data_assunzione, NEW.matricola);
            ELSE
                -- Error message
                RAISE EXCEPTION 'Invalid hiring date for a junior employee';
            END IF;

        ELSIF (NEW.tipo_impiegato = 'middle') THEN
            IF ((NEW.data_assunzione + INTERVAL '3 years') <= CURRENT_DATE AND
                NEW.data_assunzione + INTERVAL '7 years' >= CURRENT_DATE ) THEN 
                    INSERT INTO storico VALUES (NULL, 'junior', NEW.data_assunzione, NEW.matricola);
                    INSERT INTO storico VALUES ('junior', 'middle', NEW.data_assunzione + INTERVAL '3 years', NEW.matricola);
            ELSE
                -- Error message
                RAISE EXCEPTION 'Invalid hiring date for a middle employee';
            END IF;

        ELSIF (NEW.tipo_impiegato = 'senior') THEN
            IF((NEW.data_assunzione + INTERVAL '7 years') <= CURRENT_DATE ) THEN
                INSERT INTO storico VALUES (NULL, 'junior', NEW.data_assunzione, NEW.matricola);
                INSERT INTO storico VALUES ('junior', 'middle', NEW.data_assunzione + INTERVAL '3 years', NEW.matricola);
                INSERT INTO storico VALUES ('middle', 'senior', NEW.data_assunzione + INTERVAL '7 years', NEW.matricola);
            ELSE 
                -- Error message
                RAISE EXCEPTION 'Invalid hiring date for a senior employee';
            END IF;


		--caso in cui l'impiegato è inserito come dirigente[...]
		if(new.dirigente is true) THEN
			INSERT INTO STORICO VALUES('NonDirigente','dirigente', CURRENT_DATE, new.matricola);
		end if;


        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER insert_storico
AFTER INSERT ON impiegato
FOR EACH ROW
EXECUTE FUNCTION f_insert_storico();

--________________________________________________________________________________________________________________________________--

/*
	PROCEDURE 0.1 : AGGIORNAMENTO DEL DATABASE

	SI SCORRE TUTTI GLI IMPIEGATI PRENDENDO L'ULTIMO SCATTO DI CARRIERA FATTO E 
	CONTROLLA CON LA DATA ODIERNA. SE VI SONO ALTRI SCATTI ALLORA INSERISCE LE NUOVE TUPLE ALL'INTERNO
	DI STORICO E VA A MODIFICARE IL TIPO DI IMPIEGATO (ATTRIBUTO IMPIEGATO), ALTRIMENTI NON FA NIENTE.	

*/

CREATE OR REPLACE PROCEDURE update_database() AS
$$
	DECLARE
		--cursore con tutti gli impiegati con le ultime date scatto fatte
		cursore_impiegati cursor is (select*
									 from impiegato as i natural join storico as s
									 where s.nuovo_ruolo = i.tipo_impiegato);

		imp_corrente record;

	BEGIN

		--AGGIORNAMENTO IMPIEGATI[...]
		open cursore_impiegati;
		LOOP
		FETCH cursore_impiegati INTO imp_corrente;
		IF NOT FOUND THEN
            EXIT;
        end if;

			--CASO IN CUI E' JUNIOR
			IF(imp_corrente.tipo_impiegato = 'junior') THEN
					--se sono passati piu di tre anni allora discrimino gli scatti di carriera fatti.
				IF(imp_corrente.data_assunzione + INTERVAL '3 years' <= CURRENT_DATE) THEN

					IF(imp_corrente.data_assunzione + INTERVAL '7 years' >= CURRENT_DATE) THEN
						INSERT INTO STORICO VALUES('junior','middle',imp_corrente.data_assunzione + INTERVAL '3 YEARS', imp_corrente.matricola);

						UPDATE IMPIEGATO
						SET tipo_impiegato = 'middle'
						WHERE impiegato.matricola = imp_corrente.matricola;

					--altrimenti sono passati 7 anni quindi aggiorno a senior.
					ELSIF(imp_corrente.data_assunzione + INTERVAL '7 years' <= CURRENT_DATE) THEN
						INSERT INTO STORICO VALUES('junior','middle',imp_corrente.data_assunzione + INTERVAL '3 YEARS', imp_corrente.matricola);
						INSERT INTO STORICO VALUES('middle','senior',imp_corrente.data_assunzione + INTERVAL '7 YEARS', imp_corrente.matricola);

						UPDATE IMPIEGATO
						SET tipo_impiegato = 'senior'
						WHERE impiegato.matricola = imp_corrente.matricola;

					END IF;
				END IF;
			END IF;

			--CASO IN CUI E' MIDDLE
			IF(imp_corrente.tipo_impiegato = 'middle') THEN
				IF(imp_corrente.data_assunzione + INTERVAL '7 years' <= CURRENT_DATE) THEN
					INSERT INTO STORICO VALUES('middle','senior',imp_corrente.data_assunzione + INTERVAL '7 YEARS', imp_corrente.matricola);
					UPDATE IMPIEGATO
					SET tipo_impiegato = 'senior'
					WHERE impiegato.matricola = imp_corrente.matricola;
				end if;
			END IF;
		END LOOP;
		close cursore_impiegati;

	END;

$$ LANGUAGE plpgsql;

--________________________________________________________________________________________________________________________________--

/*
	TRIGGER 0.3 :
	Nel momento in cui elimino un dirigente che è associato ad un progetto allora devo chiedere all'utente di sostituire
	il responsabile di quel progetto altrimenti lanciando un messaggio di errore.
	stessa cosa per referente per un progetto
	Questo giustificato dal fatto che un progetto non può esserci senza responsabile e referente.
*/

create or replace function f_eliminazione_impiegati_speciali() RETURNS TRIGGER AS
$$
	BEGIN

		--if del responsabile di un progetto
		IF EXISTS(select*
				  from PROGETTO
				  where responsabile = old.matricola and data_fine is null or data_fine > CURRENT_DATE) THEN

		RAISE EXCEPTION 'Impossibile eliminare il responsabile di un progetto attivo, prima bisogna sostituirlo!';

		--if del referente di un progetto
		ELSIF EXISTS(select*
				  from PROGETTO
				  where referente = old.matricola and data_fine is null or data_fine > CURRENT_DATE) THEN

		RAISE EXCEPTION 'Impossibile eliminare il referente di un progetto attivo, prima bisogna sostituirlo!';

		--if del responsabile scientifico in un laboratorio
		ELSIF EXISTS(select*
				  from laboratorio
				  where r_scientifico = old.matricola) THEN

		RAISE EXCEPTION 'Impossibile eliminare un responsabile scientifico di un laboratorio , prima bisogna sostituirlo!';

		END IF;

		RETURN OLD;
	END;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER eliminazione_impiegati_speciali
BEFORE DELETE ON IMPIEGATO
FOR EACH ROW
EXECUTE function f_eliminazione_impiegati_speciali();


--________________________________________________________________________________________________________________________________--

/*
	TRIGGER 0.4
	(update false->true)nel caso in cui viene aggiornato l'attributo booleano dirigente in Impiegato, allora
	bisogna inserire la data scatto all'interno dello storico.
	(update true->false)nel caso in cui il dirigente gestisce qualche progetto mandare messaggio di errore, altrimenti,
	fare inserimento all'interno dello storico della data_scatto 'nonDirigente'->'dirigente'.
*/

create or replace function f_update_dirigente() returns trigger
    language plpgsql
as
$$
	DECLARE

	BEGIN
		IF((OLD.dirigente = false ) AND NEW.dirigente = true)THEN
			INSERT INTO STORICO VALUES('NonDirigente','dirigente', CURRENT_DATE, new.matricola);

		ELSIF (NEW.dirigente = false AND OLD.dirigente = true)THEN
			IF EXISTS(SELECT* FROM PROGETTO WHERE responsabile = new.matricola
											and (data_fine is null or data_fine > CURRENT_DATE) ) THEN

				RAISE EXCEPTION 'NON PUOI DECLASSARE UN DIRIGENTE SE GESTISCE UN PROGETTO, BISOGNA PRIMA CAMBIARLO!';


			ELSE
			INSERT INTO STORICO VALUES('dirigente','NonDirigente', CURRENT_DATE, new.matricola);
			END IF;

		END IF;

		RETURN NEW;

	END;

$$ language plpgsql;



CREATE OR REPLACE TRIGGER update_dirigente
AFTER UPDATE OF dirigente On impiegato
FOR EACH ROW
EXECUTE FUNCTION f_update_dirigente();

--________________________________________________________________________________________________________________________________--

/*
	VINCOLO DI INTEGRITA' SEMANTICA[...] :
	Un impiegato Junior o un middle non può avere lo stipendio più alto di un senior.
	--aggiorna per il middle rispetto al junior...--
*/
create or replace function f_check_stipendio() returns TRIGGER AS 
$$
	BEGIN
		IF EXISTS(SELECT*
				  FROM Impiegato as i
				  where i.tipo_impiegato = 'Senior' and i.stipendio < new.stipendio ) then

			RAISE EXCEPTION 'Un dipendente di grado inferiore non può avere uno stipendio più alto di un senior';
		END IF;

		RETURN NEW;
	END;
$$


create or replace trigger check_stipendio()
after insert or update on Impiegato
when tipo_impiegato = 'junior' or tipo_impiegato = 'middle'
for each ROW
execute function f_check_stipendio();

--________________________________________________________________________________________________________________________________--
--________________________________________________________________________________________________________________________________--

--												TRIGGER E FUNZIONI SU PROGETTO:

/*
	TRIGGER :
	1.0 (insert prog) quando aggiungo un referente e un responsabile devo fare in modo tale 
		che sia il primo senior e il secondo dirigente,
		altrimenti mando un messaggio di errore e non faccio l'inserimento.
*/

create or replace function f_check_referente_or_dirigente() returns trigger AS
$$
	BEGIN
		IF(new.dirigente not in (select matricola from impiegato where dirigente is true)) then 
			RAISE EXCEPTION 'Il responsabile deve essere un dirigente dell azienda!';
		
		IF(new.referente not in (select matricola from impiegato where tipo_impiegato = 'Senior'))
			RAISE EXCEPTION 'Il referente deve essere un impiegato Senior!';

	RETURN NEW;

	END;
$$


CREATE OR REPLACE TRIGGER check_referente_or_dirigente
AFTER INSERT ON PROGETTO
FOR EACH ROW
EXECUTE FUNCTION f_check_referente_or_dirigente();

--________________________________________________________________________________________________________________________________--
/*
		TRIGGER 1.1
		se si aggiorna un responsabile o un referente allora si verifichi che il nuovo valore sia assegnabile. 
*/

CREATE OR REPLACE TRIGGER check_update_dirigente_or_responsabile
AFTER UPDATE of referente or responsabile ON PROGETTO 
FOR EACH ROW
EXECUTE FUNCTION f_check_referente_or_dirigente();

--________________________________________________________________________________________________________________________________--

/*
		1.2(vincolo di gestione) Un progetto ATTIVI (data fine = null) ha al più 
		tre laboratori associati. (sulla tabella gestione).
*/

CREATE OR REPLACE FUNCTION f_max_labs_per_cup() RETURNS TRIGGER AS 
$$
DECLARE
    lab_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO lab_count FROM Gestione_Attuale WHERE cup = NEW.cup;
    IF lab_count >= 3 THEN
        RAISE EXCEPTION 'Non è possibile associare più di tre ID_LAB ad un  CUP';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER max_labs_per_cup
BEFORE INSERT ON GESTIONE
FOR EACH ROW
EXECUTE FUNCTION f_max_labs_per_cup();

--________________________________________________________________________________________________________________________________--
--________________________________________________________________________________________________________________________________--

--														TRIGGER SU LABORATORIO:

/*
	TRIGGER 2.0 and 2.05 : RESPONSABILE SCIENTIFICO 
	verifica che quando inserisco un laboratorio, il suo responsabile scientifico sia senior e responsabile solo di QUEL laboratorio.
*/
CREATE OR REPLACE FUNCTION f_check_responsabile_scientifico() RETURNS TRIGGER AS 
$$
BEGIN	
	IF NEW.r_scientifico NOT IN (SELECT matricola FROM impiegato WHERE tipo_impiegato = 'senior') THEN
		RAISE EXCEPTION 'Il referente scientifico deve essere un senior dell''azienda!';
	END IF;

	IF EXISTS (SELECT * FROM laboratorio WHERE r_scientifico = NEW.r_scientifico AND id_lab <> NEW.id_lab) THEN
		RAISE EXCEPTION 'Il referente scientifico è già associato ad un altro laboratorio!';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_responsabile_scientifico_insert
AFTER INSERT ON laboratorio
FOR EACH ROW
EXECUTE FUNCTION f_check_responsabile_scientifico();

CREATE TRIGGER check_responsabile_scientifico_update
AFTER UPDATE OF r_scientifico ON laboratorio
FOR EACH ROW
EXECUTE FUNCTION f_check_responsabile_scientifico();

--________________________________________________________________________________________________________________________________--
/*
	TRIGGER 2.2 
	controllare che un impiegato non lavora per più di otto ore al giorno (tabella afferenza), altrimenti
	lanciare un messaggio di errore.
*/
CREATE OR REPLACE FUNCTION f_max_ore_giornaliere() RETURNS TRIGGER AS 
$$
	DECLARE
	num_ore_tot INTEGER;
	BEGIN
		num_ore_tot := (select sum(ore_giornaliere) from afferenza as a where a.matricola = new.matricola)

		if num_ore_tot > 8
			RAISE EXCEPTION 'UN IMPIEGATO NON PUO LAVORARE PIU DI OTTO ORE AL GIORNO!';
		END IF;

	END;

$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER max_ore_giornaliere
AFTER INSERT ON AFFERENZA
FOR EACH ROW
EXECUTE FUNCTION f_max_ore_giornaliere();

CREATE OR REPLACE TRIGGER max_ore_giornaliere
AFTER UPDATE OF ore_giornaliere ON AFFERENZA
FOR EACH ROW
EXECUTE FUNCTION f_max_ore_giornaliere();
--________________________________________________________________________________________________________________________________--