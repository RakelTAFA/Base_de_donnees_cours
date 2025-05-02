use p2100832;
set default_storage_engine=InnoDB;
set SQL_SAFE_UPDATES=0;

insert into Type (libellé)
VALUES ('Association Départementale'),
('ACI Jardin du Coeur'),
('Entrepôt'),
('Centre'),(
'Annexe'),
('Centre itinérant');

insert into Catalogue_de_formations(Intitulé,Recommandé)
VALUES('Initiation aux resto du coeur',true),
('Comptabilité',false),
('Gestion des entrepots',false),
('Communication et relation humaine',true);

insert UO (Intitulé,Adresse,Code_postale,Ville,Tel,Mail,id_Type)
Values ('Entrepot de Bourg-en-Bresse','8 Rue des lilas','01100','Bourg-en-Bresse','0102030102','Mail',3),
('Centre de Pont De Veaux', '10 route des pissenlits', 01234, 'Pont De Veaux', '0636363636', 'Mail',4);

INSERT INTO Mission (Intitulé,ID_UO)
VALUES ('Responsable',1),
('Administrateur',2),
('Membre equipe stock',1),
('Distribution',2),
('Formateur',1);

INSERT INTO Bénévole (Nom,Prénom,Date_de_naissance,Adresse,Code_Postale,Ville,Tel_fixe,Tel_Mobile,Mail_Perso,Mail_Restos)
VALUES ('Sevier','Ila','1968-11-02',' 84, rue des six frères Ruellan','01500','Ambérieu-en-Bugey','0489375206','0489375206','IlaSevier@armyspy.com','IlaSevier@restoducoeur.com'),
('Marquis', 'Leroy', '2000-08-26', '3, Rue de Verdun', '01100', 'Oyonnax', '0424114616', '0614568570',  'LeroyMarquis@yahoo.com', 'LeroyMarquis@restoducoeur.com'),
('Blanc','Frontino','1943-08-06',' 12, rue des Nations Unies','01000','Bourg-en-Bresse','0447935620','0645231089','FrontinoBlanc@gmail.com','FrontinoBlanc@restoducoeur.com');

Update Bénévole SET Actif = False where Id_Bénévole = 3;

insert into Session_de_formation (Nom_session, Nb_Max_, date_debut, date_fin, heure_debut, heure_fin, Commentaire, Id_UO, id_Modules)
values ('Initiation aux resto du coeur ',12,'2022-02-12','2022-02-12','14:00:00','16:00:00', 'Initiation obligatoire pour le bénévolat',1,1),
('Initiation aux resto du coeur ',15,'2022-03-12','2022-03-12','10:00:00','12:00:00', 'Initiation obligatoire pour le bénévolat',1,1),
('Comptabilité ',10,'2022-01-19','2022-01-21','10:30:00','12:30:00','Formations de comptabilité',2,2);

update Session_de_formation, UO 
set Session_de_formation.Nom_Session = 
Concat(Session_de_formation.Nom_Session,left(Session_de_formation.date_debut,4),' ',monthname(Session_de_formation.date_debut),' ',UO.Ville) where UO.Id_UO = Session_de_formation.Id_UO;

UPDATE Session_de_formation set Statut_ = 'En Projet' where Id_Session_de_formation = 3;


Insert into Occupe ()
values (1,3,false,false,false),
(2,1,true,false,false),
(3,5,false,true,false);

insert into Participe()
Values(1,1,false,true,true,true,1),
(2,2,false,true,false,false,2),
(3,1,true,true,true,true,1);

/*Update Session_de_formation set 
Statut_ = Statut_ on delete restrict where Statut_ like 'Réalisé';*/

-- Passage en 'Réalisé'

Update Session_de_formation set Statut_ = 'Réalisé' where Id_Session_de_formation = 1;



