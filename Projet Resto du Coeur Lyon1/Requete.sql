use p2100832;
set default_storage_engine=InnoDB;
set SQL_SAFE_UPDATES=0;

-- Lister tout les Bénévoles
Select * From Bénévole;

-- Recherche Multicritère Bénévole
Select * From Bénévole where nom = 'Sevier';

Select* from Bénévole where actif;

select * From Bénévole where Id_Bénévole in
(Select Id_Bénévole from Occupe where Id_Mission 
in ( select Id_Mission from Mission where Intitulé like 'Responsable'));

Select * from Bénévole 
where Id_Bénévole in (select Id_Bénévole from Participe where Formées_ and Id_Modules in 
(select Id_Modules from Session_de_formation where Id_Modules in
(select Id_Modules from Catalogue_de_formations where Intitulé like 'Initiation aux resto du coeur' )));

-- Affichage détaillé Bénévole pour un Nom et prénom donné 
Select * from Bénévole
natural join Participe
where Nom like 'Blanc' and Prénom like 'Frontino';

-- Recherche Multicritères 
Select * from Session_de_formation
where id_UO in (select Id_UO from UO where Intitulé like 'Entrepot de Bourg-en-Bresse');

Select * from Session_de_formation 
where Id_Modules in ( select Id_Modules from Catalogue_de_formations where Intitulé like 'Initiation aux resto du coeur');

Select * from Session_de_formation
where id_UO in (select Id_UO from UO where Ville like 'Bourg-en-Bresse');

select * from Session_de_formation
where Statut_ like 'Ouverte';

-- affichage détaillé des formations pour un Statut donné
Select * from Session_de_formation
inner join Participe on Session_de_formation.Id_Session_de_formation = Participe.Id_Session_de_formation
where Statut_ like 'Ouverte';

-- Statistiques Bénévoles 

Select count(Id_Bénévole) as 'Nombre bénévole a l entrpot de bourg-en-bresse' from Bénévole
where Id_Bénévole in
(select Id_Bénévole from Occupe where Id_Mission in
(select Id_Mission from Mission where Id_UO in
(select Id_UO from UO where Intitulé like 'Entrepot de Bourg-en-Bresse')));

Select count(Id_Bénévole) as 'Nombre bénévole Responsable ' from Bénévole
where Id_Bénévole in
(select Id_Bénévole from Occupe where Id_Mission in
(select Id_Mission from Mission where Intitulé like 'Responsable'));


-- Statistiques Formations Réalisé
select count(Id_Session_de_formation) as 'nb formations réalisé par modules (Initiation aux restos du coeur)' from Session_de_formation
where Statut_ like 'Réalisé' and Id_Modules in (select Id_Modules from Catalogue_de_formations where Intitulé like 'Initiation aux resto du coeur');

select count(Id_Session_de_formation) as 'nb formations par UO (Entrepot de bourg en bresse)' from Session_de_formation
where Statut_ like 'Réalisé' and Id_UO in (select id_UO from UO where Intitulé like 'Entrepot de Bourg-en-Bresse');

select count(Id_Session_de_formation) as 'nb formations par periode (Janvier)' from Session_de_formation
where date_debut like '%-01-%' and Statut_ like 'Réalisé';
 
select count(Id_Bénévole) as 'nb participant a une session (Initiatin aux resto du coeur)' from Participe where Present and Id_Session_de_formation in
(select Id_Session_de_formation from Session_de_formation where Statut_ like 'Réalisé' and Id_Modules in
(select Id_Modules from Catalogue_de_formations where Intitulé like 'Initiation aux resto du coeur'));


-- Statistiques Formations Prévues

select count(Id_Session_de_formation) as 'nb formations réalisé par modules (Initiation aux restos du coeur)' from Session_de_formation
where Statut_ not like 'Réalisé' and Id_Modules in (select Id_Modules from Catalogue_de_formations where Intitulé like 'Initiation aux resto du coeur');

select count(Id_Session_de_formation) as 'nb formations par UO (Entrepot de bourg en bresse)' from Session_de_formation
where Statut_ not like 'Réalisé' and Id_UO in (select id_UO from UO where Intitulé like 'Entrepot de Bourg-en-Bresse');

select count(Id_Session_de_formation) as 'nb formations par periode (Janvier)' from Session_de_formation
where date_debut like '%-01-%' and Statut_ not like 'Réalisé';
 
select count(Id_Bénévole) as 'nb participant a une session (Initiatin aux resto du coeur)' from Participe where Present and Id_Session_de_formation in
(select Id_Session_de_formation from Session_de_formation where Statut_ not like 'Réalisé' and Id_Modules in
(select Id_Modules from Catalogue_de_formations where Intitulé like 'Initiation aux resto du coeur'));



