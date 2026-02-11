DROP DATABASE IF EXISTS football_manager;
CREATE DATABASE football_manager;

DROP TABLE IF EXISTS ESTADIS;
CREATE TABLE ESTADIS(
	id int auto_increment,
    nom varchar(45) not null,
    num_espectadors int not null,
    constraint pk_ESTADIS primary key (id)
);

DROP TABLE IF EXISTS CIUTATS;
CREATE TABLE CIUTATS(
	id int auto_increment,
    nom varchar(45) not null,
    constraint pk_CIUTATS primary key (id)
);

DROP TABLE IF EXISTS PERSONES;
CREATE TABLE PERSONES(
	id int auto_increment,
    nom varchar(45) not null,
    cognoms varchar(45) not null,
    data_naixment date not null,
    nivell_motivacio int not null, 
    sou float not null,
    tipus_persona varchar(45) not null,
    constraint pk_PERSONES primary key (id)
);

DROP TABLE IF EXISTS POSICIONS;
CREATE TABLE POSICIONS(
	id int auto_increment,
    posicio varchar(45) not null,
    constraint pk_POSICIONS primary key (id)
);

DROP TABLE IF EXISTS EQUIPS;
CREATE TABLE EQUIPS(
	id int auto_increment,
    nom varchar(45) not null,
    any_fundacio int not null,
    nom_president varchar(45),
    ciutats_id int not null,
    estadis_id int not null,
    filials_equips int,
	constraint pk_EQUIPS primary key (id),
    constraint fk_EQUIPS_CIUTATS foreign key (ciutats_id) references CIUTATS(id),
    constraint fk_EQUIPS_ESTADIS foreign key (estadis_id) references ESTADIS(id)
);

DROP TABLE IF EXISTS ENTRENADORS;
CREATE TABLE ENTRENADORS(
	persones_id int not null,
    num_tornejos int not null,
    es_seleccionador tinyint not null,
    constraint pk_ENTRENADORS primary key (persones_id),
    constraint fk_ENTRENADORS_PERSONES foreign key (persones_id) references PERSONES(id)
);

DROP TABLE IF EXISTS JUGADORS;
CREATE TABLE JUGADORS(
	persones_id int not null,
    dorsal int not null,
    qualitat int not null,
    posicions_id int not null,
    constraint pk_JUGADORS primary key (persones_id),
    constraint fk_JUGADORS_PERSONES foreign key (persones_id) references PERSONES(id),
    constraint fk_JUGADORS_POSICIONS foreign key (posicions_id) references POSICIONS(id) 
);

DROP TABLE IF EXISTS LLIGUES;
CREATE TABLE LLIGUES(
	id int auto_increment,
    nom varchar(45) not null,
    temporada year not null,
    constraint pk_LLIGUES primary key (id)
);

DROP TABLE IF EXISTS PARTICIPAR_LLIGUES;
CREATE TABLE PARTICIPAR_LLIGUES(
	equips_id int not null,
    lligues_id int not null,
    constraint pk_PARTICIPAR_LLIGUES primary key (equips_id, lligues_id),
    constraint fk_PARTICIPAR_LLIGUES_EQUIPS foreign key (equips_id) references EQUIPS(id),
    constraint fk_PARTICIPAR_LLIGUES_LLIGUES foreign key (lligues_id) references LLIGUES(id)
);

DROP TABLE IF EXISTS JORNADES;
CREATE TABLE JORNADES(
	id int auto_increment,
    jornada int not null,
    data date not null,
    lligues_id int not null,
    constraint pk_JORNADES primary key (id),
    constraint fk_JORNADES_LLIGUES foreign key (lligues_id) references LLIGUES(id)
);

DROP TABLE IF EXISTS PARTITS;
CREATE TABLE PARTITS(
	id int auto_increment,
    gols_local int not null,
    gols_visitant int not null,
    punts_local int not null,
    punts_visitant int not null,
    jornades_id int not null,
    equips_id_local int not null,
    equips_id_visitant int not null,
    constraint pk_PARTITS primary key (id),
    constraint fk_PARTITS_JORNADES foreign key (jornades_id) references JORNADES(id),
    constraint fk_PARTITS_EQUIPS_LOCAL foreign key (equips_id_local) references EQUIPS(id),
    constraint fk_PARTITS_EQUIPS_VISITANT foreign key (equips_id_visitant) references EQUIPS(id)
);

DROP TABLE IF EXISTS ENTRENAR_EQUIPS;
CREATE TABLE ENTRENAR_EQUIPS(
	data_fitxatge date,
    entrenadors_id int not null,
    equips_id int not null,
    data_baixa date,
    constraint pk_ENTRENAR_EQUIPS primary key (data_fitxatge, entrenadors_id),
    constraint fk_ENTRENAR_EQUIPS_ENTRENADORS foreign key (entrenadors_id) references ENTRENADORS(persones_id),
    constraint fk_ENTRENAR_EQUIPS_EQUIPS foreign key (equips_id) references EQUIPS(id)
);    

DROP TABLE IF EXISTS JUGADORS_EQUIPS;
CREATE TABLE JUGADORS_EQUIPS(
	data_fitxatge date,
    jugadors_id int not null,
    equips_id int not null,
    data_baixa date,
    constraint pk_JUGADORS_EQUIPS primary key (data_fitxatge, jugadors_id),
    constraint fk_JUGADORS_EQUIPS_JUGADORS foreign key (jugadors_id) references JUGADORS(persones_id),
    constraint fk_JUGADORS_EQUIPS_EQUIPS foreign key (equips_id) references EQUIPS(id)
);
    
DROP TABLE IF EXISTS PARTITS_GOLS;
CREATE TABLE PARTITS_GOLS(
	partits_id int not null,
    jugadors_id int not null,
    minut int,
    es_penal tinyint not null,
    constraint pk_PARTITS_GOLS primary key (partits_id, minut, jugadors_id),
    constraint fk_PARTITS_GOLS_PARTITS foreign key (partits_id) references PARTITS(id),
    constraint fk_PARTITS_GOLS_JUGADORS foreign key (jugadors_id) references JUGADORS(persones_id)
);

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
	ON 	football_manager.EQUIPS
    TO 'adminEquips'@'localhost';
REVOKE INSERT, DELETE ON football_manager.EQUIPS FROM 'adminEquips'@'localhost';
GRANT SELECT, UPDATE
	ON football_manager.ESTADIS
    TO 'adminEquips'@'localhost';
REVOKE INSERT, DELETE ON football_manager.ESTADIS FROM 'adminEquips'@'localhost';
GRANT SELECT, UPDATE
	ON football_manager.PERSONES
    TO 'adminEquips'@'localhost';
REVOKE INSERT, DELETE ON football_manager.PERSONES FROM 'adminEquips'@'localhost';

-- Periodista
GRANT SELECT
	ON football_manager.*
    TO 'periodista'
    WITH GRANT OPTION;
REVOKE INSERT, DELETE, UPDATE ON football_manager.* FROM 'periodista';

-- Periodista AS(alts carrecs)



-- 1r Consulta
SELECT EQUIPS.nom, EQUIPS.any_fundacio, EQUIPS.nom_president, CIUTATS.nom, ESTADIS.nom, ESTADIS.num_espectadors
FROM EQUIPS
JOIN CIUTATS ON CIUTATS.id = EQUIPS.ciutats_id
JOIN ESTADIS ON ESTADIS.id = EQUIPS.estadis_id
WHERE ESTADIS.num_espectadors BETWEEN 3000 AND 5000
ORDER BY ESTADIS.num_espectadors asc; 

-- 2n Consulta
SELECT 