/*
    DUMPS __da aggiornare con i nuovi attributi inseriti[...]
*/

--INSERIMENTO NELLA TABELLA IMPIEGATO
INSERT INTO IMPIEGATO (matricola, nome, cognome, cf, curriculum, stipendio, sesso, tipo_impiegato, dirigente, data_assunzione, data_licenziamento)
VALUES
('MAT-001', 'Mario', 'Rossi', 'RSSMRA01A01H501A', 'Laurea in Informatica', 25000.00, 'M', 'junior', FALSE, '2022-01-01', null),
('MAT-002', 'Luca', 'Bianchi', 'BNCLCU02B02H501B', 'Laurea in Ingegneria', 28000.00, 'M', 'junior', FALSE, '2022-02-01', null),
('MAT-003', 'Giulia', 'Verdi', 'VRDGLI03C03H501C', 'Laurea in Economia', 30000.00, 'F', 'junior', FALSE, '2022-03-01', null),
('MAT-004', 'Francesca', 'Neri', 'NRFNCS04D04H501D', 'Laurea in Giurisprudenza', 32000.00, 'F', 'junior', FALSE, '2022-04-01', null),
('MAT-005', 'Antonio', 'Russo', 'RSSNTN05E05H501E', 'Laurea in Lingue', 29000.00, 'M', 'junior', FALSE, '2022-05-01', null),
('MAT-006', 'Roberto', 'Ferrari', 'FRRRBR06F06H501F', 'Laurea in Architettura', 27000.00, 'M', 'junior', FALSE, '2022-06-01', null),
('MAT-007', 'Simona', 'Romano', 'RMNSMN07G07H501G', 'Laurea in Psicologia', 31000.00, 'F', 'junior', FALSE, '2022-07-01', null),
('MAT-008', 'Giovanni', 'Lombardi', 'LMBGNN08H08H501H', 'Laurea in Scienze Politiche', 29000.00, 'M', 'junior', FALSE, '2022-08-01', null),
('MAT-009', 'Valentina', 'Greco', 'GRCVLN09I09H501I', 'Laurea in Lettere', 28000.00, 'F', 'junior', FALSE, '2022-09-01', null),
('MAT-010', 'Alessandro', 'Moretti', 'MRTLSN10L10H501L', 'Laurea in Chimica', 32000.00, 'M', 'junior', FALSE, '2022-10-01', null),
('MAT-011', 'Paolo', 'Conti', 'CNTPLA11M11H501M', 'Laurea in Biologia', 30000.00, 'M', 'junior', FALSE, '2022-11-01', null),
('MAT-012', 'Elena', 'Esposito', 'ESPETN12N12H501N', 'Laurea in Filosofia', 29000.00, 'F', 'junior', FALSE, '2022-12-01', null),
('MAT-013', 'Fabrizio', 'Ricci', 'RCCFBR13O13H501O', 'Laurea in Storia dell arte', 28000.00, 'M', 'junior', FALSE, '2023-01-01', null),
('MAT-014', 'Silvia', 'Marino', 'MRNSLV14P14H501P', 'Laurea in Agraria', 31000.00, 'F', 'junior', FALSE, '2023-02-01', null),
('MAT-015', 'Riccardo', 'Greco', 'GRCRCD15Q15H501Q', 'Laurea in Fisica', 32000.00, 'M', 'junior', FALSE, '2023-03-01', null),
('MAT-016', 'Barbara', 'Lombardo', 'LMBBRB16R16H501R', 'Laurea in Scienze dell educazione', 29000.00, 'F', 'junior', FALSE, '2023-04-01', null),
('MAT-017', 'Davide', 'Ferrara', 'FRRDVD17S17H501S', 'Laurea in Teologia', 28000.00, 'M', 'junior', FALSE, '2023-05-01', null),
('MAT-018', 'Laura', 'Rizzo', 'RZZLRA18T18H501T', 'Laurea in Scienze motorie', 31000.00, 'F', 'junior', FALSE, '2023-06-01', null),
('MAT-019', 'Marco', 'Bruno', 'BRNMRK19U19H501U', 'Laurea in Infermieristica', 30000.00, 'M', 'junior', FALSE, '2023-07-01', null),
('MAT-020', 'Sara', 'Costa', 'CSTSR20V20H501V', 'Laurea in Odontoiatria', 32000.00, 'F', 'junior', FALSE, '2023-08-01', null);

--INSERIMENTO NELLA TABELLA STORICO
INSERT INTO STORICO (ruolo_prec, nuovo_ruolo, data_scatto, matricola) VALUES
(NULL, 'junior', '2020-01-01', 'MAT-001'),
('junior', 'middle', '2021-01-01', 'MAT-001'),
('middle', 'senior', '2022-01-01', 'MAT-001'),

(NULL, 'junior', '2020-02-01', 'MAT-002'),
('junior', 'middle', '2021-02-01', 'MAT-002'),
('middle', 'senior', '2022-02-01', 'MAT-002'),

(NULL, 'junior', '2020-03-01', 'MAT-003'),
('junior', 'middle', '2021-03-01', 'MAT-003'),
('middle', 'senior', '2022-03-01', 'MAT-003'),

(NULL, 'junior', '2020-04-01', 'MAT-004'),
('junior', 'middle', '2021-04-01', 'MAT-004'),
('middle', 'senior', '2022-04-01', 'MAT-004'),

(NULL, 'junior', '2020-05-01', 'MAT-005'),
('junior', 'middle', '2021-05-01', 'MAT-005'),
('middle', 'senior', '2022-05-01', 'MAT-005'),

(NULL, 'junior', '2020-06-01', 'MAT-006'),
('junior', 'middle', '2021-06-01', 'MAT-006'),
('middle', 'senior', '2022-06-01', 'MAT-006'),

(NULL, 'junior', '2020-07-01', 'MAT-007'),
('junior', 'middle', '2021-07-01', 'MAT-007'),
('middle', 'senior', '2022-07-01', 'MAT-007'),

(NULL, 'junior', '2020-08-01', 'MAT-008'),
('junior', 'middle', '2021-08-01', 'MAT-008'),
('middle', 'senior', '2022-08-01', 'MAT-008'),

(NULL, 'junior', '2020-09-01', 'MAT-009'),
('junior', 'middle', '2021-09-01', 'MAT-009'),
('middle', 'senior', '2022-09-01', 'MAT-009'),

(NULL, 'junior', '2020-10-01', 'MAT-010'),
('junior', 'middle', '2021-10-01', 'MAT-010'),
('middle', 'senior', '2022-10-01', 'MAT-010');

(NULL, 'junior', '2020-11-01', 'MAT-011'),
('junior', 'middle', '2021-11-01', 'MAT-011'),
('middle', 'senior', '2022-11-01', 'MAT-011'),

(NULL, 'junior', '2020-12-01', 'MAT-012'),
('junior', 'middle', '2021-12-01', 'MAT-012'),
('middle', 'senior', '2022-12-01', 'MAT-012'),

(NULL, 'junior', '2021-01-01', 'MAT-013'),
('junior', 'middle', '2022-01-01', 'MAT-013'),
('middle', 'senior', '2023-01-01', 'MAT-013'),

(NULL, 'junior', '2021-02-01', 'MAT-014'),
('junior', 'middle', '2022-02-01', 'MAT-014'),
('middle', 'senior', '2023-02-01', 'MAT-014'),

(NULL, 'junior', '2021-03-01', 'MAT-015'),
('junior', 'middle', '2022-03-01', 'MAT-015'),
('middle', 'senior', '2023-03-01', 'MAT-015'),

(NULL, 'junior', '2021-04-01', 'MAT-016'),
('junior', 'middle', '2022-04-01', 'MAT-016'),
('middle', 'senior', '2023-04-01', 'MAT-016'),

(NULL, 'junior', '2021-05-01', 'MAT-017'),
('junior', 'middle', '2022-05-01', 'MAT-017'),
('middle', 'senior', '2023-05-01', 'MAT-017'),

(NULL, 'junior', '2021-06-01', 'MAT-018'),
('junior', 'middle', '2022-06-01', 'MAT-018'),
('middle', 'senior', '2023-06-01', 'MAT-018'),

(NULL, 'junior', '2021-07-01', 'MAT-019'),
('junior', 'middle', '2022-07-01', 'MAT-019'),
('middle', 'senior', '2023-07-01', 'MAT-019'),

(NULL, 'junior', '2021-08-01', 'MAT-020'),
('junior', 'middle', '2022-08-01', 'MAT-020'),
('middle', 'senior', '2023-08-01', 'MAT-020');






-- Inserimenti nella tabella LABORATORIO
INSERT INTO LABORATORIO (id_lab, topic, indirizzo, numero_telefono, numero_afferenti, responsabile) VALUES
('LAB01', 'Ingegneria', 'Via Roma 1', '0123456789', 5, 'MAT-001'),
('LAB02', 'Fisica', 'Via Milano 2', '9876543210', 7, 'MAT-004'),
('LAB03', 'Informatica', 'Via Napoli 3', '3333333333', 5, 'MAT-007'),
('LAB04', 'Biologia', 'Via Firenze 4', '4444444444', 6, 'MAT-010'),
('LAB05', 'Chimica', 'Via Venezia 5', '5555555555', 4, 'MAT-013'),
('LAB06', 'Matematica', 'Via Torino 6', '6666666666', 3, 'MAT-016'),
('LAB07', 'Ingegneria', 'Via Bologna 7', '7777777777', 2, 'MAT-019'),
('LAB08', 'Fisica', 'Via Genova 8', '8888888888', 4, 'MAT-002'),
('LAB09', 'Informatica', 'Via Palermo 9', '9999999999', 5, 'MAT-011'),
('LAB10', 'Biologia', 'Via Padova 10', '0000000000', 6, 'MAT-018');



--INSERIMENTO NELLA TABELLA AFFERENZA 
INSERT INTO AFFERENZA (ore_giornaliere, tipo_contratto, matricola, id_lab) VALUES
(8, 'determinato', 'MAT-001', 'LAB01'),
(6, 'determinato', 'MAT-002', 'LAB01'),
(7, 'indeterminato', 'MAT-003', 'LAB01'),
(6, 'determinato', 'MAT-004', 'LAB02'),
(8, 'indeterminato', 'MAT-005', 'LAB02'),
(5, 'determinato', 'MAT-006', 'LAB02'),
(7, 'indeterminato', 'MAT-007', 'LAB03'),
(6, 'determinato', 'MAT-008', 'LAB03'),
(8, 'indeterminato', 'MAT-009', 'LAB03'),
(5, 'determinato', 'MAT-010', 'LAB04'),
(7, 'indeterminato', 'MAT-011', 'LAB04'),
(6, 'determinato', 'MAT-012', 'LAB04'),
(8, 'indeterminato', 'MAT-013', 'LAB05'),
(5, 'determinato', 'MAT-014', 'LAB05'),
(6, 'determinato', 'MAT-015', 'LAB05'),
(7, 'indeterminato', 'MAT-016', 'LAB06'),
(8, 'indeterminato', 'MAT-017', 'LAB06'),
(5, 'determinato', 'MAT-018', 'LAB06'),
(6, 'determinato', 'MAT-019', 'LAB06'),
(7, 'indeterminato', 'MAT-020', 'LAB06');



