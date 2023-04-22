/*
    DUMPS __da aggiornare con i nuovi attributi inseriti[...]
*/

--INSERIMENTO NELLA TABELLA IMPIEGATO
INSERT INTO IMPIEGATO(matricola, nome, cognome, cf, curriculum, stipendio, sesso, tipo_impiegato, dirigente,data_licenziamento)
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
('MAT-021', 'francesco', 'salvatore', 'CNTCHR80L12G121T', 'Master in Psicologia', 2600.00, 'M', 'junior', false);
('MAT-022', 'Simone', 'Esposito', 'CNTCwR80L12G121T', 'Master in Psicologia', 2600.00, 'M', 'senior', false);
('MAT-023', 'Gianmarco', 'Deiana', 'CNTCQR80L12G121T', 'Master in Matematica', 2600.00, 'M', 'senior', false);

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



