use football_manager;

-- CREAR USUARIOS ADMINISTRADORES
-- SUPERADMINISTRADOR
CREATE USER 'superadministrador'@'localhost' IDENTIFIED BY 'superadministrador'
	PASSWORD HISTORY 2
    PASSWORD EXPIRE INTERVAL 30 DAY;

-- Administrador de equips
CREATE USER 'adminEquips'@'localhost' IDENTIFIED BY 'adminequips' PASSWORD EXPIRE;

-- Administrador de lligues
CREATE USER 'adminLligues'@'localhost' IDENTIFIED BY 'adminlligues';
	
-- CREAR ROL I USAURIOS DEL PERIODISMO
CREATE ROLE 'periodista';
CREATE USER 'periodistaSport'@'localhost' IDENTIFIED BY 'periodista';
CREATE USER 'periodistaAS'@'localhost' IDENTIFIED BY 'periodista';
CREATE USER 'periodistaMundo'@'localhost' IDENTIFIED BY 'periodista';

-- PERMISOS:
-- SUPERADMINISTRADOR 
-- Lectura, Insercion, Modificacion y borrado sobre toda la base de datos
GRANT SELECT, INSERT, UPDATE, DELETE 
	ON football_manager.*
    TO 'superadministrador'@'localhost';

-- PERMISOS
-- ADMINISTRADOR DE EQUIPS
-- Consulta y Modificar la tabla Equips
GRANT SELECT, UPDATE
	ON 	football_manager.equips
    TO 'adminEquips'@'localhost';

-- No Puede añadir ni eliminar datos en la tabla Equips
REVOKE INSERT, DELETE ON football_manager.equips FROM 'adminEquips'@'localhost';

-- Consulta y Modificar la tabla Estadis
GRANT SELECT, UPDATE
	ON football_manager.estadis
    TO 'adminEquips'@'localhost';

-- No Puede añadir ni eliminar datos en la tabla Estadis
REVOKE INSERT, DELETE ON football_manager.estadis FROM 'adminEquips'@'localhost';

-- No Puede añadir ni eliminar datos en la tabla Persones
GRANT SELECT, UPDATE
	ON football_manager.persones
    TO 'adminEquips'@'localhost';

-- No Puede añadir ni eliminar datos en la tabla Persones
REVOKE INSERT, DELETE ON football_manager.persones FROM 'adminEquips'@'localhost';

-- PERMISOS
-- ADMINISTRADOR DE LLIGUES
GRANT INSERT, UPDATE, SELECT
	ON football_manager.lligues
    TO 'adminLligues'@'localhost';
    
GRANT INSERT, UPDATE, SELECT
	ON football_manager.jornades
    TO 'adminLligues'@'localhost';
    
GRANT INSERT, UPDATE, SELECT
	ON football_manager.partits
    TO 'adminLligues'@'localhost';
    
GRANT INSERT, UPDATE, SELECT
	ON football_manager.partits_gols
    TO 'adminLligues'@'localhost';

-- PERMISOS:
-- PERIODISTA
-- Puede consultar toda la base de datos
GRANT SELECT
	ON football_manager.*
    TO 'periodista';

-- No puede añadir, borrar o modificar la base de datos
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
	AS SELECT persones.nom AS 'NOMBRE_ENTRENADORS', persones.cognoms AS 'COGNOMS_ENTRENADORS', COUNT(*);


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
    JOIN equips ON equips.filial_equips_id = participar_lligues.equips_id;topgoleadorestopgoleadores
    

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
