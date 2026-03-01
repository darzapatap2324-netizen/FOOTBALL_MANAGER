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

-- PRIMERA VISTA
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

-- SEGUNDA VISTA
CREATE OR REPLACE VIEW JugadorsJovesLaLliga AS
SELECT persones.nom AS 'Nom_Jugador', persones.cognoms AS 'Cognom_Jugador', 
persones.data_naixement AS 'Naixament', equips.nom AS 'Equip'
FROM jugadors
JOIN persones ON persones.id = jugadors.persones_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
JOIN participar_lligues ON participar_lligues.equips_id = equips.id
JOIN lligues ON lligues.id = participar_lligues.lligues_id
WHERE persones.data_naixement > '1999-12-31' AND lligues.nom = 'La Liga EA Sports'
ORDER BY persones.data_naixement ASC;
select * from JugadorsJovesLaLliga;

-- TERCERA VISTA
CREATE OR REPLACE VIEW PosicioJugadorsEquips AS
SELECT persones.nom AS 'Nom_Jugador', persones.cognoms AS 'Cognom_Jugador',
equips.nom AS 'Equip', jugadors.qualitat AS 'Qualitat', posicions.posicio AS 'Posició'
FROM jugadors
JOIN persones ON persones.id = jugadors.persones_id
JOIN posicions ON posicions.id = jugadors.posicions_id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id
JOIN equips ON equips.id = jugadors_equips.equips_id
WHERE jugadors_equips.data_baixa IS NULL
ORDER BY persones.nom;
SELECT * FROM JugadoresEquiposPosicion;

-- CUARTA VISTA
CREATE OR REPLACE VIEW InformacioEquips AS
SELECT equips.nom AS 'Nom_Equip', ciutats.nom AS 'Ciutat_Equip', lligues.nom AS 'Nom_Lliga'
FROM equips
JOIN ciutats ON ciutats.id = equips.ciutats_id
JOIN participar_lligues ON participar_lligues.equips_id = equips.id
JOIN lligues ON lligues.id = participar_lligues.lligues_id
ORDER BY equips.nom;
SELECT * FROM EquiposCiutatLliga;

-- ACCESO VISTAS
-- Periodista(alts carrecs)
GRANT SELECT 
	ON topgoleadores
    TO 'periodistaAS'@'localhost';

GRANT SELECT 
	ON jugadorsjoveslalliga
    TO 'periodistaMundo'@'localhost';
    
GRANT SELECT 
	ON posiciojugadorsequips
    TO 'periodistaSport'@'localhost';
    
GRANT SELECT 
	ON informacioequips
    TO 'periodistaAS'@'localhost';
