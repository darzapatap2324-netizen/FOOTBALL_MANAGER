
-- Copia de Seguretat
create database if not exists football_manager_backup;
create table football_manager_backup.ciutats_backup as select * from football_manager.ciutats;
create table football_manager_backup.entrenadors_backup as select * from football_manager.entrenadors;
create table football_manager_backup.entrenar_equips_backup as select * from football_manager.entrenar_equips;
create table football_manager_backup.equips_backup as select * from football_manager.equips; 
create table football_manager_backup.estadis_backup as select * from football_manager.estadis;
create table football_manager_backup.jornades_backup as select * from football_manager.jornades;
create table football_manager_backup.jugadors_backup as select * from football_manager.jugadors;
create table football_manager_backup.jugadors_equips_backup as select * from football_manager.jugadors_equips;
create table football_manager_backup.lligues_backup as select * from football_manager.lligues;
create table football_manager_backup.participar_lligues_backup as select * from football_manager.participar_lligues;
create table football_manager_backup.partits_backup as select * from football_manager.partits;
create table football_manager_backup.partits_gols_backup as select * from football_manager.partits_gols;
create table football_manager_backup.persones_backup as select * from football_manager.persones;
create table football_manager_backup.posicions_backup as select * from football_manager.posicions;

-- Modificacions de DADES = Transaccions

-- 1r Consulta Modificat
/*Donat el nom d'una lliga i la temporada. Fer que tots els partits de la jornada 5 acabin en 0-0.*/
START TRANSACTION;
UPDATE partits
JOIN jornades ON jornades.id = partits.jornades_id
JOIN lligues ON lligues.id = jornades.lligues_id
SET partits.gols_local = 0, partits.gols_visitant = 0, partits.punts_local = 1, partits.punts_visitant = 1
WHERE jornades.jornada = 5 
AND lligues.nom = 'La Liga EA Sports' 
AND lligues.temporada = 2024;
COMMIT;
/*ROLLBACK;*/
/*COMMIT;*/

-- 2n Consulta Modificat
/*La nostra base de dades està creixent molt i hem d'alliberar
 una mica d'espai. Esborra totes les ciutats en les quals no hi hagi cap equip.*/
START TRANSACTION;
DELETE FROM ciutats
WHERE ciutats.id NOT IN (SELECT DISTINCT ciutats_id FROM equips WHERE ciutats_id IS NOT NULL);
COMMIT;
/*ROLLBACK;*/
/*COMMIT;*/


-- 3ra Consulta Modificat
/*Baixa un 10% la motivació d'aquells jugadors que cobren menys de 5 milions i tenen 35 anys o més.*/
START TRANSACTION;
UPDATE persones
JOIN jugadors ON jugadors.persones_id = persones.id
SET persones.nivell_motivacio = persones.nivell_motivacio * 0.9
WHERE persones.sou < 5000000 
AND (YEAR(CURDATE()) - YEAR(persones.data_naixement)) >= 35;
COMMIT;
/*ROLLBACK;*/
/*COMMIT;*/


-- 4t Consulta Modificat
/*S'ha celebrat un entrenament especial de porters dels primers equips. Puja en 3 punts la
 qualitat de tots els porters de la base de dades que no pertanyin a un equip filial.*/
START TRANSACTION;
UPDATE jugadors
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
SET jugadors.qualitat = jugadors.qualitat + 3
WHERE jugadors.posicions_id = 1 AND equips.filial_equips_id IS NULL;
COMMIT;
/*ROLLLBACK;*/
/*COMMIT;*/

-- 5ta Consulta Modificat
/*Afegeix un camp a la taula "Jugadors" per indicar si el jugador està disponible per
 a ser fitxat. De moment posarem com a disponibles tots aquells jugadors que hagin
 estat contractats durant el primer trimestre del 2024. La resta de jugadors de la base
 de dades hauran d'aparèixer com a no disponibles per a ser fitxats.*/
START TRANSACTION;
ALTER TABLE football_manager.jugadors ADD COLUMN jugador_disponible boolean;

-- 1r pas -> GENERIC - TOTS ELS JUGADORS NO DISPONIBLES
UPDATE football_manager.jugadors AS jugadorsback
SET jugadorsback.jugador_disponible = 0;

-- 2n pas -> JUGADORS DE 1r TRIMESTRE DISPONIBLE
UPDATE football_manager.jugadors AS jugadorsback
JOIN football_manager.jugadors_equips AS jugadors_equipsback ON jugadors_equipsback.jugadors_id = jugadorsback.persones_id
SET jugadorsback.jugador_disponible = 1
WHERE YEAR(jugadors_equipsback.data_fitxatge) = 2024 AND MONTH(jugadors_equipsback.data_fitxatge) BETWEEN 1 AND 3;
COMMIT;
/*ROLLBACK;*/
/*COMMIT;*/

-- 6ta Consulta Modificat
/*Estem a punt de crear una nova lliga. Hi participaran 6 equips al llarg de 6 jornades. Realitza els INSERT necessaris.*/
START TRANSACTION;
-- LLLIGUES INSERT = 1
INSERT INTO football_manager.lligues (nom, temporada)
VALUES ('Liga Premier EA Sports', 2026);

SET @id_lliga = LAST_INSERT_ID();

-- CIUTATS INSERTS = 6
INSERT INTO football_manager.ciutats (nom)
VALUES ('Barcelona'), ('Madrid'), ('Valencia'),
		('Sevilla'), ('Bilbao'), ('Malaga');

	-- GUARDAR IDs
    SET @ciutat1 = LAST_INSERT_ID() - 5;
    SET @ciutat2 = LAST_INSERT_ID() - 4;
    SET @ciutat3 = LAST_INSERT_ID() - 3;
    SET @ciutat4 = LAST_INSERT_ID() - 2;
    SET @ciutat5 = LAST_INSERT_ID() - 1;
    SET @ciutat6 = LAST_INSERT_ID();


-- ESTADIS INSERTS = 6
INSERT INTO football_manager.estadis
VALUES ('Estadi Olimpic', 50000),
		('Camp Central', 40000),
        ('Estadi del Mar', 35000),
        ('Fortaleza Arena', 45000),
        ('Camp Nord', 30000),
        ('Estadi Sud', 42000);

	-- GUARDAR IDs 
    SET @estadi1 = LAST_INSERT_ID() - 5;
    SET @estadi2 = LAST_INSERT_ID() - 4;
    SET @estadi3 = LAST_INSERT_ID() - 3;
    SET @estadi4 = LAST_INSERT_ID() - 2;
    SET @estadi5 = LAST_INSERT_ID() - 1;
    SET @estadi6 = LAST_INSERT_ID();

-- EQUIPS INSERTS = 6
INSERT INTO football_manager.equips (nom, any_fundacio, nom_president, ciutats_id, estadis_id) 
VALUES ('Olympia Cosmos', 2000, 'Juan Pérez', @ciutat1, @estadi1),
		('Valle Sagrado FC', 2005, 'Carlos Ruiz', @ciutat2, @estadi2),
		('Titanes de Plata FC', 2010, 'Luis Gómez', @ciutat3, @estadi3),
		('Real Titánico Club', 1998, 'Miguel Torres', @ciutat4, @estadi4),
		('Atlas Aurinegro', 2003, 'Pedro López', @ciutat5, @estadi5),
		('Simba Sporta Unido', 2015, 'Andrés Silva', @ciutat6, @estadi6);

	-- GUARDAR IDs
    SET @equip1 = LAST_INSERT_ID() - 5;
    SET @equip2 = LAST_INSERT_ID() - 4;
    SET @equip3 = LAST_INSERT_ID() - 3;
    SET @equip4 = LAST_INSERT_ID() - 2;
    SET @equip5 = LAST_INSERT_ID() - 1;
    SET @equip6 = LAST_INSERT_ID();


-- PARTICIPAR LLIGUES INSERTS = 6
INSERT INTO football_manager.participar_lligues (lligues_id, equips_id) 
VALUES (@id_lliga, @equip1), (@id_lliga, @equip2),
        (@id_lliga, @equip3), (@id_lliga, @equip4),
        (@id_lliga, @equip5), (@id_lliga, @equip6);


INSERT INTO jornades (jornada, data, lligues_id)
VALUES (0001, '2025-11-20', @id_lliga),
		(0002, '2026-01-15', @id_lliga),
        (0003, '2026-02-07', @id_lliga),
        (0004, '2026-02-25', @id_lliga),
        (0005, '2026-03-01', @id_lliga),
        (0006, '2026-03-22', @id_lliga);
COMMIT;
/*ROLLBACK;*/
/*COMMIT;*/

-- 7ma Consulta Modificat
/*Crea els INSERT necessaris per poder afegir una nova
 jornada de lliga amb un partit en què hi hagi algun gol.*/
 START TRANSACTION;
-- Afegit una PARTIT a la JORNADES
INSERT INTO football_manager.partits
(gols_local, gols_visitant, punts_local, punts_visitant,
 jornades_id, equips_id_local, equips_id_visitant)
VALUES (2, 1, 3, 0, 1, @equip1, @equip2);

SET @partits1 = LAST_INSERT_ID();

-- GOLS DELS JUGADORS
INSERT INTO football_manager.partits_gols 
(partits_id, jugadors_id, minut, es_penal)
VALUES (@partits1, 1, 12, 0),
		(@partits1, 2, 67, 0),
        (@partits1, 1, 80, 1);
COMMIT;
/*ROLLBACK;*/
/*COMMIT;*/

-- 8ve Consulta Modificat
/*Crea els INSERT necessaris per poder donar un nou
 equip d'altra a la nostra base de dades, incloent el
 seu estadi, l'entrenador i 2 jugadors.*/
START TRANSACTION;
INSERT INTO football_manager.ciutats (nom)
VALUES ('Granada');
SET @ciutat_nova = LAST_INSERT_ID();

INSERT INTO football_manager.estadis (nom, num_espectadors)
VALUES ('Nortrabeu Estadi', 25000);
SET @estadi_nou = LAST_INSERT_ID();

INSERT INTO football_manager.equips (nom, any_fundacio, nom_president, ciutats_id, estadis_id)
VALUES ('Estrella FC', 2012, 'Laura Fernández', @ciutat_nova, @estadi_nou);
SET @equip_nou = LAST_INSERT_ID();

INSERT INTO football_manager.participar_lligues (lligues_id, equips_id)
VALUES (@id_lliga, @equip_nou);

INSERT INTO football_manager.persones (nom, cognoms, data_naixement, nivell_motivacio, sou, tipus_persona)
VALUES ('Pedro', 'Martínez', '1975-05-12', 90, 200000, 'entrenador');
SET @entrenador_nou = LAST_INSERT_ID();

INSERT INTO football_manager.entrenadors (persones_id, num_tornejos, es_selecionador)
VALUES (@entrenador_nou, 3, 0);

INSERT INTO football_manager.entrenar_equips (data_fitxatge, entrenadors_id, equips_id)
VALUES ('2026-03-21', @entrenador_nou, @equip_nou);

INSERT INTO football_manager.persones (nom, cognoms, data_naixement, nivell_motivacio, sou, tipus_persona)
VALUES 
('Luis', 'García', '1995-03-10', 85, 100000, 'jugador'),
('Carlos', 'Molina', '1998-07-15', 88, 120000, 'jugador');
SET @jugador1 = LAST_INSERT_ID() - 1;
SET @jugador2 = LAST_INSERT_ID();

INSERT INTO football_manager.jugadors (persones_id, dorsal, qualitat, posicions_id)
VALUES
(@jugador1, 9, 86, 4),
(@jugador2, 7, 88, 3);

INSERT INTO football_manager.jugadors_equips (data_fitxatge, jugadors_id, equips_id)
VALUES
('2026-03-21', @jugador1, @equip_nou),
('2026-03-21', @jugador2, @equip_nou);
COMMIT;
