
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
USE football_manager;
SELECT equips.nom, SUM(partits.punts_local + partits.punts_visitant) AS 'Puntuacio_Total'
FROM equips
JOIN partits ON partits.equips_id_local = equips.id 
JOIN partits ON partits.equips_id_visitant = equips.id
JOIN participar_lligues ON participar_lligues.equips_id = equips.id
JOIN lligues ON  lligues.id = participar_lligues.lligues_id
GROUP BY equips.nom
WHERE lligues.nom = 'La Liga EA Sports' AND lligues.temporada = 2024
ORDER BY 'Puntuacio Total' DESC;






















