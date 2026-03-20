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
UPDATE football_manager.partits AS partitsback
JOIN football_manager.jornades AS jornadesback ON jornadesback.

COMMIT;