set sql_safe_updates=0;
-- Exo 1
CREATE or REPLACE VIEW DEPARTEMENT 
AS SELECT departement numDepart, count(*) nbVilles, 
sum(superficie) superficie, max(altitudeMax) altitudeMax, 
min(altitudeMin) altitudeMin, sum(pop2010) pop2010
FROM films.villes 
GROUP BY departement;

SELECT * FROM DEPARTEMENT;
-- requête plus simple avec la vue
SELECT NumDepart 
from DEPARTEMENT 
WHERE superficie = (select max(superficie)
			  from DEPARTEMENT);

-- EXO 2

-- Emprunteurs qui n'ont vu autre aucun thriller 
-- sol 1
CREATE OR REPLACE VIEW EMP_NOTTHRIL
        as select * 
	  from films.emprunteurs j
    	  where isnull ((select distinct categorie
                            from films.emprunteurs g
                            NATURAL JOIN films.emprunts
                            NATURAL JOIN films.exemplaires
                            NATURAL JOIN films.films
                                where j.idemprunteur = g.idemprunteur 
                                and categorie = "thriller"));
 
 -- sol 2
CREATE OR REPLACE VIEW EMP_NOTTHRIL
as select  e1.* 
FROM films.emprunteurs e1
EXCEPT
SELECT distinct e1.* 
FROM films.emprunteurs e1
JOIN films.emprunts e2 ON  e1.idemprunteur=e2.idemprunteur
JOIN films.exemplaires e3 ON e3.idexemplaire=e2.idexemplaire
JOIN films.films f ON f.idfilm=e3.idfilm 
Where f.categorie='thriller' ;

  -- sol 3        

CREATE OR REPLACE VIEW EMP_NOTTHRIL
as select  e1.* 
FROM films.emprunteurs e1
Where e1.idemprunteur NOT IN (
SELECT e.idemprunteur
FROM films.emprunteurs e
JOIN films.emprunts e2 ON  e.idemprunteur=e2.idemprunteur
JOIN films.exemplaires e3 ON e3.idexemplaire=e2.idexemplaire
JOIN films.films f ON f.idfilm=e3.idfilm 
Where f.categorie='thriller');

-- contenu de la vue
SELECT * FROM EMP_NOTTHRIL;
--  req 1: Lister les noms des villes ou habitent au moins un emprunteur qui 
-- n’a jamais emprunté un thriller.
Select distinct v.nom from films.villes v
JOIN EMP_NOTTHRIL e ON v.idville=e.ville;
-- req2: Lister les noms des villes ou habitent au moins 10 emprunteurs qui n’ont jamais emrunté un thriller
Select distinct v.nom 
from films.villes v
JOIN EMP_NOTTHRIL e ON v.idville=e.ville
group by v.idville
having count(*)>=2;


-- EXO 3
-- Vue 
CREATE OR REPLACE VIEW EMPCAT 
AS SELECT e1.idEmprunteur, f.categorie, count(distinct f.idfilm) nb
FROM films.emprunteurs e1
JOIN films.emprunts e2 ON  e1.idemprunteur=e2.idemprunteur
JOIN films.exemplaires e3 ON e3.idexemplaire=e2.idexemplaire
JOIN films.films f ON f.idfilm=e3.idfilm 
where categorie is not null
group by e1.idEmprunteur, f.categorie;

select * from EMPCAT;
-- req 
select idEmprunteur, sum(nb) totalEmprunts
FROM EMPCAT
group by idEmprunteur;


-- EXO 4

DROP TABLE IF exists mesemprunteurs;
CREATE TABLE mesemprunteurs AS SELECT * FROM films.emprunteurs;

-- changer le type de idemprunteur de 3 à 4 caractères
Alter table mesemprunteurs modify idemprunteur varchar(4);

-- vue avec sous req
CREATE OR REPLACE VIEW EMP_Bourg1 AS 
select *
from mesemprunteurs 
where mesemprunteurs.ville = (select films.villes.idVille 
					from films.villes 
					where films.villes.nom = 'Bourg-en-Bresse');

-- vue avec join
CREATE OR REPLACE VIEW EMP_Bourg2 AS 
select e.*
from mesemprunteurs e JOIN films. villes v ON e.ville=v.idville
where v.nom = 'Bourg-en-Bresse';

-- 	Laquelle des deux vues permet de :
--  Ajouter un emprunteur qui habite à Bourg en Bresse
--  Ajouter un emprunteur qui habite à Ambronay

-- Avec l première vue, ça marche car vue simple 
INSERT INTO EMP_Bourg1 Values ('E200', 'Lagraa', 'Hamida', null,null,null,
(select films.villes.idVille 
from films.villes 
where films.villes.nom = 'Bourg-en-Bresse'), null);

INSERT INTO EMP_Bourg1 Values ('E201', 'Boutin', 'JP', null,null,null,
(select films.villes.idVille 
from films.villes 
where films.villes.nom = 'Ambronay'), null);

-- Peut-on supprimer ces deux emprunteurs via cette vue ?
delete from EMP_Bourg1 where idemprunteur='E200';
delete from EMP_Bourg1 where idemprunteur='E201';

-- avec la seconde vue on ne peut pas insérer ou supprimer car vue complexe
INSERT INTO EMP_Bourg2 Values ('E200', 'Lagraa', 'Hamida', null,null,null,
(select films.villes.idVille 
from films.villes 
where films.villes.nom = 'Bourg-en-Bresse'), null);

-- Revoir la définition de la vue pour corriger le problème de l’ajout.
-- Pour n'ajouter que les emprunteurs qui répondent à la condition de la vue, il faut ajouter check option

CREATE OR REPLACE VIEW EMP_Bourg1 AS select *
from mesemprunteurs where 
mesemprunteurs.ville = (select films.villes.idVille 
from films.villes 
where films.villes.nom = 'Bourg-en-Bresse') with check option;

-- le premier Insert passe mais le second insert est refusé
INSERT INTO EMP_Bourg1 Values ('E200', 'Lagraa', 'Hamida', null,null,null,
(select films.villes.idVille 
from films.villes 
where films.villes.nom = 'Bourg-en-Bresse'), null);

INSERT INTO mesemprunteurs Values ('E200', 'Lagraa', 'Hamida', null,null,null,
(select films.villes.idVille 
from films.villes 
where films.villes.nom = 'Bourg-en-Bresse'), null);
delete from mesemprunteurs where idemprunteur='E200';

INSERT INTO EMP_Bourg1 Values ('E201', 'Boutin', 'JP', null,null,null,
(select films.villes.idVille 
from films.villes 
where films.villes.nom = 'Ambronay'), null);
commit;


-- EXO 5

CREATE or REPLACE View VUE6 AS
SELECT ex.*
FROM films.films f join films.exemplaires ex on f.idFilm=ex.idFilm
WHERE ex.idExemplaire in (
	SELECT idExemplaire
    FROM films.bibliotheques
    WHERE idBibli in (SELECT idBibliRetour
					  FROM films.emprunts emp1
                      join films.emprunteurs emp2 on emp1.idEmprunteur=emp2.idEmprunteur
                      join films.villes v on emp2.ville=v.idVille
                      WHERE v.nom = 'Bourg-en-Bresse'));

-- Compter les films
SELECT count(idFilm), idBibli
FROM VUE6
group by idBibli;
