
use football_manager;

-- CREAR USUARIOS ADMINISTRADORES
CREATE USER IF NOT EXISTS 'superadministrador'@'localhost' IDENTIFIED BY 'superadministrador'
	PASSWORD HISTORY 2
    PASSWORD EXPIRE INTERVAL 30 DAY;
CREATE USER IF NOT EXISTS 'adminEquips'@'localhost' IDENTIFIED BY 'adminequips' PASSWORD EXPIRE;
CREATE USER IF NOT EXISTS 'adminLligues'@'localhost' IDENTIFIED BY 'adminlligues';
	
-- CREAR ROL I USAURIOS DEL PERIODISMO
CREATE ROLE IF NOT EXISTS 'periodista';
CREATE USER IF NOT EXISTS 'periodistaSport'@'localhost' IDENTIFIED BY 'periodista';
CREATE USER IF NOT EXISTS 'periodistaAS'@'localhost' IDENTIFIED BY 'periodista';
CREATE USER IF NOT EXISTS 'periodistaMundo'@'localhost' IDENTIFIED BY 'periodista';

-- PERMISOS:
-- SUPERADMINISTRADOR 
GRANT SELECT, INSERT, UPDATE, DELETE 
	ON football_manager.*
    TO 'superadministrador'@'localhost';

-- Administrador de equips
GRANT SELECT, UPDATE 
	ON 	football_manager.equips
    TO 'adminEquips'@'localhost';
REVOKE INSERT, DELETE ON football_manager.equips FROM 'adminEquips'@'localhost';
GRANT SELECT, UPDATE
	ON football_manager.estadis
    TO 'adminEquips'@'localhost';
REVOKE INSERT, DELETE ON football_manager.estadis FROM 'adminEquips'@'localhost';
GRANT SELECT, UPDATE
	ON football_manager.persones
    TO 'adminEquips'@'localhost';
REVOKE INSERT, DELETE ON football_manager.persones FROM 'adminEquips'@'localhost';

-- Periodista
GRANT SELECT
	ON football_manager.*
    TO 'periodista'
    WITH GRANT OPTION;
REVOKE INSERT, DELETE, UPDATE ON football_manager.* FROM 'periodista';






-- VISTAS (para mostrar info filtrada u processada)
-- Drop view if exists EntrenadorsEquips;
CREATE OR REPLACE VIEW TopGoleadores
	AS SELECT persones.nom AS 'Nom_Jugador', persones.cognoms AS 'Cognom/s_Jugador', equips.nom AS 'Equip', sum(partits.gols_local + partits.gols_visitant) as GolsTotal
    FROM jugadors
    JOIN persones ON persones.id = jugadors.persones_id
    JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
    JOIN equips ON equips.id = jugadors_equips.equips_id
	JOIN partits_gols ON partits_gols.jugadors_id = jugadors.persones_id 
    JOIN partits ON partits.equips_id_local = equips.id 
    OR partits.equips_id_visitant = equips.id AND partits.id = partits_gols.partits_id
	GROUP BY jugadors.persones_id, persones.nom, persones.cognoms, equips.nom
	ORDER BY GolsTotal DESC;
SHOW CREATE VIEW TopGoleadores; -- Enseña la descripcion del view
SELECT * FROM TopGoleadores;




-- Esta view esta por hacer acabalo si puedes, te reto.
CREATE OR REPLACE VIEW EntrenadoresMasPartidosDirigidos
	AS SELECT persones.nom AS 'NOMBRE_ENTRENADORS', persones.cognoms AS 'COGNOMS_ENTRENADORS', COUNT()


-- Las views EquipsLlocsJugant, LliguesParticipen no estan filtradas como lo demanda el enunciado. Lo has de rehacer.
CREATE OR REPLACE VIEW EquipsLlocsJugant
	AS SELECT equips.nom AS 'Nom de equip', ciutats.nom AS 'Ciutat', estadis.nom AS 'Estadi'
	FROM equips
    JOIN estadis ON estadis.id = equips.estadis_id
    JOIN ciutats ON ciutats.id = equips.ciutats_id;
    
    
CREATE OR REPLACE VIEW LliguesParticipen
	AS SELECT equips.nom AS 'Equips', lligues.nom AS 'Lligues'
    FROM lligues
    JOIN participar_lligues ON participar_lligues.lligues_id = lligues.id
    JOIN equips ON equips.filial_equips_id = participar_lligues.equips_id;
    

-- Periodista AS(alts carrecs)
-- 
GRANT SELECT 
	ON -- NOM_VIEW
    TO 'periodistaAS'@'localhost'
    WITH GRANT OPTION;

GRANT SELECT 
	ON -- NOM_VIEW
    TO 'periodistaAS'@'localhost'
	WITH GRANT OPTION;
    
GRANT SELECT 
	ON -- NOM_VIEW
    TO 'periodistaAS'@'localhost'
    WITH GRANT OPTION;
    
GRANT SELECT 
	ON -- NOM_VIEW
    TO 'periodistaAS'@'localhost'
    WITH GRANT OPTION;