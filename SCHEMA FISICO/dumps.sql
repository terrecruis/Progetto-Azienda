/*
    DUMPS[...]
*/

--INSERIMENTO NELLA TABELLA IMPIEGATO
INSERT INTO IMPIEGATO (matricola, nome, cognome, cf, curriculum, stipendio, sesso, tipo_impiegato, dirigente, data_assunzione) 
VALUES 
('0001', 'Mario', 'Rossi', 'RSSMRA01A01F205F', 'Laurea in Informatica', 25000.00, 'M', 'senior', true, '20-01-01'),
('0002', 'Laura', 'Bianchi', 'BNCLRA02B02H501A', 'Laurea in Economia', 28000.00, 'F', 'senior', true, '2009-06-01'),
('0003', 'Giovanni', 'Verdi', 'VRDGNN03C03I601C', 'Diploma di Ragioniere', 20000.00, 'M', 'senior', true , '2000-03-15'),
('0004', 'Francesca', 'Neri', 'NRIFNC04D04L219S', 'Laurea in Ingegneria', 35000.00, 'F', 'senior', true, '2005-01-01'),
('0005', 'Andrea', 'Russo', 'RSSNDR05E05P123Q', 'Laurea in Scienze Politiche', 30000.00, 'M', 'senior', true, '2004-09-01'),
('0006', 'Alessandra', 'Rizzo', 'RZZLSA06F06M765T', 'Diploma di Tecnico Informatico', 22000.00, 'F', 'senior', true, '2015-02-01'),
('0007', 'Luca', 'Greco', 'GRCMCU07G07N456L', 'Laurea in Architettura', 32000.00, 'M', 'senior', true, '1999-05-01'),
('0008', 'Martina', 'Lombardi', 'LMBMRT08H08S789G', 'Laurea in Lingue', 26000.00, 'F', 'senior', false, '2003-11-01'),
('0009', 'Simone', 'Ferrari', 'FRRSMN09I09T012K', 'Diploma di Perito Elettronico', 23000.00, 'M', 'senior', false, '2000-03-01'),
('0010', 'Elisa', 'Giordano', 'GRDELZ10L10Z456T', 'Laurea in Giurisprudenza', 29000.00, 'F', 'senior', false, '1960-02-01'),
('0011', 'Fabio', 'Moretti', 'MRTFBI11M11A123Z', 'Diploma di Geometra', 21000.00, 'M', 'junior', false, '2021-01-01'),
('0012', 'Sara', 'Ricci', 'RCCSRA12N12B654H', 'Laurea in Psicologia', 27000.00, 'F', 'middle', false, '2019-04-01'),
('0013', 'Davide', 'Gatti', 'GTDDVD13O13C789Y', 'Diploma di Tecnico Meccanico', 24000.00, 'M', 'junior', false, '2020-06-01'),
('0014', 'Valentina', 'Conti', 'CNTVLN14P14F123M', 'Laurea in Biologia', 31000.00, 'F', 'middle', false, '2017-02-01'),
('0015', 'Gabriele', 'Longo', 'LNGGBL15Q15H456T', 'Laurea in Storia dell Arte', 28000.00, 'M', 'middle', false, '2018-06-01'),
('0016', 'Silvia', 'Marino', 'MRNSLV16R16L789K', 'Laurea in Scienze della Comunicazione', 30000.00, 'F', 'middle', false, '2017-09-01'),
('0017', 'Antonio', 'Palumbo', 'PLBNTN17S17P012A', 'Diploma di Perito Agrario', 22000.00, 'M', 'junior', false, '2021-02-01'),
('0018', 'Giulia', 'Fabbri', 'FBBGLI18T18Z456K', 'Laurea in Lettere', 29000.00, 'F', 'middle', false, '2018-02-01'),
('0019', 'Marco', 'Ricci', 'RCCMRC19U19B654Y', 'Diploma di Tecnico Chimico', 24000.00, 'M', 'junior', false, '2020-06-01'),
('0020', 'Paola', 'Fontana', 'FNTPLA20V20C789L', 'Laurea in Filosofia', 31000.00, 'F', 'middle', false, '2017-02-01');

--INSERIMENTO NELLA TABELLA LABORATORIO
INSERT INTO LABORATORIO (id_lab, topic, indirizzo, numero_telefono, r_scientifico)
VALUES 
('Lab001', 'Intelligenza Artificiale', 'Via Roma 1, Milano', '02 1234567', '0001'),
('Lab002', 'Scienze Cognitive', 'Via Garibaldi 2, Torino', '011 1234567', '0002'),
('Lab003', 'Biochimica', 'Via Dante 3, Roma', '06 1234567', '0003'),
('Lab004', 'Ingegneria Meccanica', 'Via dei Mille 4, Napoli', '081 1234567', '0004'),
('Lab005', 'Scienze Politiche', 'Piazza del Popolo 5, Firenze', '055 1234567', '0005'),
('Lab006', 'Fisica Teorica', 'Via dei Condotti 6, Roma', '06 1234567', '0006'),
('Lab007', 'Tecnologie dell Informazione', 'Via XX Settembre 7, Bologna', '051 1234567','0007'),
('Lab008', 'Neuroscienze', 'Via Veneto 8, Roma', '06 1234567','0008'),
('Lab009', 'Scienze della Terra', 'Via Palestro 9, Milano', '02 1234567','0009'),
('Lab010', 'Chimica Organica', 'Corso Vittorio Emanuele 10, Torino', '011 1234567','0010');


--INSERIMENTO NELLA TABELLA PROGETTO
INSERT INTO PROGETTO (cup, nome_progetto, budget, data_inizio, data_fine, responsabile, referente)
VALUES
('CUP001', 'Progetto Intelligenza Artificiale', 100000.00, '2023-01-01', '3000-12-31', '0001', '0002'),
('CUP002', 'Progetto Scienze Cognitive', 150000.00, '2023-02-01', '2034-12-31', '0002', '0003'),
('CUP003', 'Progetto Biochimica', 200000.00, '2023-03-01', '2029-12-31', '0003', '0004'),
('CUP004', 'Progetto Ingegneria Meccanica', 250000.00, '2023-04-01', '2028-12-31', '0004', '0005'),
('CUP005', 'Progetto Scienze Politiche', 300000.00, '2023-05-01', '2027-12-31', '0005', '0006'),
('CUP006', 'Progetto Fisica Teorica', 350000.00, '2023-06-01', '2025-12-31', '0006', '0007');


--INSERIMENTO IN AFFERENZA
INSERT INTO AFFERENZA (ore_giornaliere, tipo_contratto, matricola, id_lab)
VALUES
(4, 'indeterminato', '0001', 'Lab001'),
(2, 'indeterminato', '0002', 'Lab001'),
(4, 'indeterminato', '0003', 'Lab001'),
(4, 'indeterminato', '0004', 'Lab001'),
(4, 'indeterminato', '0005', 'Lab001'),
(4, 'indeterminato', '0006', 'Lab001'),
(4, 'indeterminato', '0007', 'Lab001'),
(4, 'indeterminato', '0008', 'Lab001'),
(4, 'indeterminato', '0009', 'Lab001'),
(4, 'indeterminato', '0010', 'Lab001'),
(8, 'indeterminato', '0011', 'Lab001'),
(4, 'indeterminato', '0012', 'Lab002'),
(6, 'indeterminato', '0013', 'Lab002'),
(7, 'indeterminato', '0014', 'Lab002'),
(8, 'indeterminato', '0015', 'Lab002'),
(4, 'indeterminato', '0016', 'Lab002'),
(8, 'indeterminato', '0017', 'Lab002'),
(8, 'indeterminato', '0018', 'Lab002'),
(8, 'indeterminato', '0019', 'Lab002'),
(8, 'indeterminato', '0020', 'Lab002'),
(4, 'indeterminato', '001', 'Lab002'),
(4, 'indeterminato', '006', 'Lab003'),
(4, 'determinato', '002', 'Lab003'),
(4, 'determinato', '004', 'Lab003'),
(4, 'determinato', '005', 'Lab003'),
(4, 'determinato', '012', 'Lab003'),
(4, 'determinato', '007', 'Lab003'),
(4, 'determinato', '008', 'Lab003'),
(4, 'determinato', '009', 'Lab003'),
(4, 'determinato', '010', 'Lab003');

--INSERIMENTO SU GESTIONE
INSERT INTO GESTIONE (cup, id_lab)
VALUES
('CUP001', 'Lab001'),
('CUP001', 'Lab002'),
('CUP001', 'Lab003'),
('CUP002', 'Lab001'),
('CUP002', 'Lab002'),
('CUP002', 'Lab003'),
('CUP003', 'Lab002'),
('CUP003', 'Lab003'),
('CUP003', 'Lab004'),
('CUP004', 'Lab003'),
('CUP004', 'Lab004'),
('CUP004', 'Lab005'),
('CUP005', 'Lab004'),
('CUP005', 'Lab005'),
('CUP005', 'Lab006'),
('CUP006', 'Lab005'),
('CUP006', 'Lab006'),
('CUP006', 'Lab007');
