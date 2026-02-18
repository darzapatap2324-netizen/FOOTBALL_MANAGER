
USE fm;

-- 1r Consulta
SELECT equips.nom, equips.any_fundacio, equips.nom_president, ciutats.nom, estadis.nom, estadis.num_espectadors
FROM equips
JOIN ciutats ON ciutats.id = equips.ciutats_id
JOIN estadis ON estadis.id = equips.estadis_id
WHERE estadis.num_espectadors BETWEEN 3000 AND 5000
ORDER BY estadis.num_espectadors asc; 

-- 2n Consulta
SELECT ciutats.nom, equips.nom, persones.nom, persones.cognoms
FROM equips
JOIN ciutats ON ciutats.id = equips.ciutats_id
JOIN entrenadors ON entrenadors.entrenadors_id = 
WHERE ciutats.nom IN ('Barcelona', 'Madrid', 'Sevilla')
AND NOT  LIKE persones.nom 'F%' AND persones.cognoms '%e%';