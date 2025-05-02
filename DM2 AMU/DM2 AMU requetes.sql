USE dm2;

-- Question 3a:

SELECT NoArr, NomArr
FROM Arret
WHERE NoArr IN (SELECT NoArr
			    FROM Plan
                WHERE NomLigne LIKE "Ligne 3: Péronnas - Alagnier");
# Ceci renvoie bien tous les arrêts de la ligne 3

-- Fin question 3a
                
-- Question 3b:

SELECT Ticket.DureeValid, Validation.DateValid, Arret.NomArr
FROM Validation INNER JOIN Ticket ON Ticket.NoTicket=Validation.NoTicket
				INNER JOIN Borne ON Borne.NoBorne=Validation.NoBorne
                INNER JOIN Arret ON Arret.NoArr=Borne.NoArr
WHERE Ticket.NoTicket = 2;
# D'après les données que j'ai renseigné le résultat de cette requête est correcte, le ticket a été validé deux fois dans la même journée à deux arrêts différents

-- Fin question 3b

-- Question 3c:

SELECT NomArr
FROM Arret INNER JOIN Plan ON Arret.NoArr=Plan.NoArr
WHERE NomLigne LIKE "Ligne 1: Emeraude - Verlaine" AND Arret.NoArr IN (SELECT NoArr
																	   FROM Plan
																	   WHERE NomLigne LIKE "Ligne 3: Péronnas - Alagnier");
# Carré Amiot est l'arrêt commun aux lignes 1 et 3.

-- Fin question 3c

-- Question 3d

SELECT Borne.NoBorne, Arret.NomArr
FROM Validation INNER JOIN Borne ON Borne.NoBorne=Validation.NoBorne
				INNER JOIN Arret ON Arret.NoArr=Borne.NoArr
GROUP BY Validation.NoBorne, Validation.NoTicket
HAVING COUNT(Validation.NoBorne) >= 2;
# Résultat : 1 Alimentec

-- Fin question 3d

-- Question 4a
      
SELECT Arret.NomArr
FROM Arret NATURAL JOIN Plan
WHERE Plan.NomLigne LIKE "Ligne 3: Péronnas - Alagnier" AND Plan.Rang IN (SELECT MIN(Rang)
																		 FROM Plan
																		 WHERE NomLigne LIKE "Ligne 3: Péronnas - Alagnier"
                                                                         UNION
                                                                         SELECT MAX(Rang)
                                                                         FROM Plan
                                                                         WHERE NomLigne LIKE "Ligne 3: Péronnas - Alagnier");
-- Fin question 4a

-- Question 4b

SELECT NoTicket, MIN(DateValid) as "Première Validation", MAX(DateValid) as "Dernière Validation", SEC_TO_TIME(TIMESTAMPDIFF(SECOND, MIN(DateValid), MAX(DateValid))) as "Différence"
FROM Validation
WHERE NoTicket = 2;

-- Fin question 4b

-- Question 4c

SELECT COUNT(*) as "Nombre de ticket périmé"
FROM Ticket T1
WHERE T1.DureeValid < (SELECT TIMESTAMPDIFF(SECOND, MIN(V1.DateValid), MAX(V1.DateValid))
					   FROM Validation V1
                       WHERE V1.NoTicket = T1.NoTicket);
                       
-- Fin question 4c

-- Question 4d

SELECT NomArr, COUNT(*) as "Nombre de tickets passés"
FROM Arret NATURAL JOIN Borne
	       NATURAL JOIN Validation
           NATURAL JOIN Ticket
WHERE Validation.DateValid BETWEEN "2025-03-01 00:00:00" AND "2025-03-31 23:59:59"
GROUP BY Borne.NoBorne;
# Pour cette question j'ai pris le mois de Mars 2025 étant donné les données que j'ai renseigné
# L'arrêt Carré Amiot a deux bornes différentes bien qu'ayant le même nom, il y a donc deux lignes différentes

-- Fin question 4d

-- Question 4e

SELECT NomArr, COUNT(*) as "Nombre de tickets passés"
FROM Arret NATURAL JOIN Borne
	       NATURAL JOIN Validation
           NATURAL JOIN Ticket
WHERE Validation.DateValid BETWEEN "2025-03-01 00:00:00" AND "2025-03-31 23:59:59"
GROUP BY Borne.NoBorne
ORDER BY "Nombre de tickets passés" DESC
LIMIT 3;

-- Fin question 4e