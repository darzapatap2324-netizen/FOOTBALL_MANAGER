
USE football_manager;
SELECT * FROM lligues;

-- 1r Consulta
SELECT equips.nom, equips.any_fundacio, equips.nom_president, ciutats.nom, estadis.nom, estadis.num_espectadors
FROM equips
JOIN ciutats ON ciutats.id = equips.ciutats_id
JOIN estadis ON estadis.id = equips.estadis_id
WHERE estadis.num_espectadors BETWEEN 3000 AND 5000
ORDER BY estadis.num_espectadors asc; 

-- 2n Consulta
SELECT ciutats.nom, equips.nom, persones.nom, persones.cognoms
FROM entrenadors
JOIN persones ON persones.id = entrenadors.persones_id
JOIN entrenar_equips ON entrenar_equips.entrenadors_id = entrenadors.persones_id
JOIN equips ON equips.id = entrenar_equips.equips_id
JOIN ciutats ON ciutats.id = equips.ciutats_id
WHERE ciutats.nom IN  ('Barcelona', 'Madrid', 'Sevilla') 
AND persones.nom NOT LIKE 'F%'  AND persones.cognoms LIKE '%e%'; 

-- 3r Consulta
SELECT /*equips.id,*/ equips.nom, SUM(punts) AS 'Puntuacio_Total'
FROM (
	SELECT partits.equips_id_local AS 'equips_id', partits.punts_local AS 'punts'
    FROM partits
    JOIN equips ON equips.id = partits.equips_id_local AND partits.equips_id_visitant
    JOIN participar_lligues ON participar_lligues.equips_id = equips.id
	JOIN lligues ON  lligues.id = participar_lligues.lligues_id
	WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
    
    UNION ALL
    
    SELECT partits.equips_id_visitant AS 'equips_id', partits.punts_visitant AS 'punts'
    FROM partits
    JOIN equips ON equips.id = partits.equips_id_local AND partits.equips_id_visitant
    JOIN participar_lligues ON participar_lligues.equips_id = equips.id
	JOIN lligues ON  lligues.id = participar_lligues.lligues_id
	WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
    ) AS equipos
JOIN equips ON equips.id = equipos.equips_id
GROUP BY equips.nom/*, equips.id*/
ORDER BY Puntuacio_Total DESC;


-- 4t Consulta
USE football_manager;
SELECT equips.nom, persones.tipus_persona, CONCAT(persones.nom, ' ' ,persones.cognoms) AS 'Nombre_Completo'
FROM persones
JOIN entrenadors ON entrenadors.persones_id = persones.id
JOIN jugadors ON jugadors.persones_id = persones.id
JOIN entrenar_equips ON entrenar_equips.entrenadors_id = persones.id AND entrenar_equips.equips_id = equips.id
JOIN jugadors_equips ON jugadors_equips.jugadors_id = jugadors.persones_id AND jugadors_equips.equips_id = equips.id
GROUP BY equips.nom;











