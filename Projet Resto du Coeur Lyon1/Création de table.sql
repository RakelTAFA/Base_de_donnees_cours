use p2100832;
set default_storage_engine=InnoDB;
set SQL_SAFE_UPDATES=0;

drop table if exists Participe; 
drop table if exists Occupe; 
drop table if exists Session_de_formation; 
drop table if exists Mission; 
drop table if exists UO; 
drop table if exists Catalogue_de_formations; 
drop table if exists Type; 
drop table if exists Bénévole; 



CREATE TABLE Bénévole(
   Id_Bénévole INT auto_increment,
   Nom VARCHAR(50) NOT NULL,
   Prénom VARCHAR(50) NOT NULL,
   Date_de_naissance DATE NOT NULL,
   Adresse VARCHAR(100),
   Code_Postale VARCHAR(5) NOT NULL,
   Ville VARCHAR(50) NOT NULL,
   Tel_fixe VARCHAR(10),
   Tel_Mobile VARCHAR(10),
   Mail_Perso VARCHAR(50),
   Mail_Restos VARCHAR(50),
   Actif bool default true NOT NULL ,
   PRIMARY KEY(Id_Bénévole)
);

CREATE TABLE Type(
   Id_Type int auto_increment,
   Libellé VARCHAR(60),
   PRIMARY KEY(Id_Type)
);

CREATE TABLE Catalogue_de_formations(
   Id_Modules int auto_increment,
   Intitulé VARCHAR(50),
   Recommandé bool,
   PRIMARY KEY(Id_Modules)
);

CREATE TABLE UO(
   Id_UO integer auto_increment,
   Intitulé VARCHAR(50),
   Adresse VARCHAR(100),
   Code_postale VARCHAR(5),
   Ville VARCHAR(50),
   Tel VARCHAR(10),
   Mail VARCHAR(60),
   Id_Type INT NOT NULL,
   PRIMARY KEY(Id_UO),
   FOREIGN KEY(Id_Type) REFERENCES Type(Id_Type)
);

CREATE TABLE Mission(
   Id_Mission int auto_increment,
   Intitulé VARCHAR(50),
   Id_UO integer NOT NULL,
   PRIMARY KEY(Id_Mission),
   FOREIGN KEY(Id_UO) REFERENCES UO(Id_UO)
);

CREATE TABLE Session_de_formation(
   Id_Session_de_formation int auto_increment,
   Nom_Session VARCHAR(100),
   Nb_max_ INT,
   date_debut DATE,
   date_fin DATE,
   heure_debut TIME,
   heure_fin TIME,
   Commentaire VARCHAR(200),
   Statut_ VARCHAR(10) default 'Ouverte' ,
   Id_UO integer NOT NULL,
   Id_Modules INT NOT NULL,
   PRIMARY KEY(Id_Session_de_formation,Id_Modules),
   FOREIGN KEY(Id_UO) REFERENCES UO(Id_UO),
   FOREIGN KEY(Id_Modules) REFERENCES Catalogue_de_formations(Id_Modules)
);

CREATE TABLE Occupe(
   Id_Bénévole INT,
   Id_Mission INT,
   Accès_données_des_bénévoles bool,
   Accès_données_des_formations bool,
   Accès_tables_communnes bool,
   PRIMARY KEY(Id_Bénévole, Id_Mission),
   FOREIGN KEY(Id_Bénévole) REFERENCES Bénévole(Id_Bénévole),
   FOREIGN KEY(Id_Mission) REFERENCES Mission(Id_Mission)
);

CREATE TABLE Participe(
   Id_Bénévole INT,
   Id_Session_de_formation INT,
   Formateurs_ bool,
   Inscrit bool,
   Formées_ bool,
   Present bool,
   Id_Modules int not null,
   PRIMARY KEY(Id_Bénévole,Id_Modules,Id_Session_de_formation),
   FOREIGN KEY(Id_Bénévole) REFERENCES Bénévole(Id_Bénévole),
   FOREIGN KEY(Id_Session_de_formation) REFERENCES Session_de_formation(Id_Session_de_formation)  ,
   FOREIGN KEY(Id_Modules) REFERENCES Session_de_formation(Id_Modules) 
);

