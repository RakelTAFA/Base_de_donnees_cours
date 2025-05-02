#CREATE DATABASE dm2;
USE dm2;

DROP TABLE IF EXISTS Validation;
DROP TABLE IF EXISTS Plan;
DROP TABLE IF EXISTS Borne;
DROP TABLE IF EXISTS Arret;
DROP TABLE IF EXISTS Ticket;

-- Question 1:
CREATE TABLE Arret (
	NoArr INT AUTO_INCREMENT,
    NomArr VARCHAR(32),
    AdrArr VARCHAR(32),
    CONSTRAINT PK_Arret PRIMARY KEY (NoArr)
);

CREATE TABLE Plan (
	NomLigne VARCHAR(32),
    NoArr INT,
    Rang INT,
    CONSTRAINT PK_Plan PRIMARY KEY (NomLigne, NoArr),
    CONSTRAINT FK_Plan_Arret FOREIGN KEY (NoArr) REFERENCES Arret(NoArr),
    CONSTRAINT UNI_Plan UNIQUE (NomLigne, Rang)
);

CREATE TABLE Borne (
	NoBorne INT AUTO_INCREMENT,
    NoArr INT,
    CONSTRAINT PK_Borne PRIMARY KEY (NoBorne),
    CONSTRAINT FK_Borne FOREIGN KEY (NoArr) REFERENCES Arret(NoArr)
);

CREATE TABLE Ticket (
	NoTicket INT AUTO_INCREMENT,
    DureeValid INT,
	Prix DECIMAL(5, 2),
    CONSTRAINT PK_Ticket PRIMARY KEY (NoTicket)
);

CREATE TABLE Validation (
	NoTicket INT,
    NoBorne INT,
    DateValid DATETIME,
    CONSTRAINT PK_Validation PRIMARY KEY (NoTicket, DateValid),
    CONSTRAINT FK_Validation_Ticket FOREIGN KEY (NoTicket) REFERENCES Ticket(NoTicket),
    CONSTRAINT FK_Validation_Borne FOREIGN KEY (NoBorne) REFERENCES Borne(NoBorne)
);
-- fin question 1

-- Question 2:
INSERT INTO Arret (NoArr, NomArr, AdrArr)
VALUES (DEFAULT, "Girod de l'Ain", "Rue Jean Mermoz"),
		(DEFAULT, "Bouvard", "Rue Jean Mermoz"),
        (DEFAULT, "Alimentec", "Avenue de Bad Kreuznach"),
        (DEFAULT, "Carré Amiot", "Rue du 4 Septembre"),
        (DEFAULT, "Ainterexpo", "25 Avenue du Maréchal Juin"),
        (DEFAULT, "Péronnas", "25 Avenue du Maréchal Juin"),
        (DEFAULT, "Alagnier", "25 Avenue du Maréchal Juin");

INSERT INTO Plan
VALUES ("Ligne 3: Péronnas - Alagnier",
	   (SELECT NoArr FROM Arret WHERE NomArr LIKE "Bouvard"),
	   10),
       ("Ligne 3: Péronnas - Alagnier",
	   (SELECT NoArr FROM Arret WHERE NomArr LIKE "Girod de l'Ain"),
	   11),
       ("Ligne 1: Emeraude - Verlaine",
	   (SELECT NoArr FROM Arret WHERE NomArr LIKE "Alimentec"),
	   4),
	   ("Ligne 1: Emeraude - Verlaine",
       (SELECT NoArr FROM Arret WHERE NomArr LIKE "Carré Amiot"),
       15),
       ("Ligne 3: Péronnas - Alagnier", 
       (SELECT NoArr FROM Arret WHERE NomArr LIKE "Carré Amiot"),
       17),
       ("Ligne 2: Fleyriat - Ainterexpo",
       (SELECT NoArr FROM Arret WHERE NomArr LIKE "Ainterexpo"),
       29),
       ("Ligne 3: Péronnas - Alagnier",
	   (SELECT NoArr FROM Arret WHERE NomArr LIKE "Péronnas"),
	   1),
       ("Ligne 3: Péronnas - Alagnier",
	   (SELECT NoArr FROM Arret WHERE NomArr LIKE "Alagnier"),
	   29);

INSERT INTO Borne
VALUES (DEFAULT, (SELECT NoArr FROM Arret WHERE NomArr LIKE "Alimentec")),
       (DEFAULT, (SELECT NoArr FROM Arret WHERE NomArr LIKE "Girod de l'Ain")),
       (DEFAULT, (SELECT NoArr FROM Arret WHERE NomArr LIKE "Carré Amiot")),
       (DEFAULT, (SELECT NoArr FROM Arret WHERE NomArr LIKE "Carré Amiot"));
              
INSERT INTO Ticket(NoTicket, DureeValid, Prix)
VALUES (DEFAULT, 3600, 1.20),
	   (DEFAULT, 7200, 2.00),
	   (DEFAULT, 1800, 0.80),
	   (DEFAULT, 14400, 3.00),
	   (DEFAULT, 3600, 1.20),
	   (DEFAULT, 3600, 1.20);
       
INSERT INTO Validation(NoTicket, NoBorne, DateValid)
VALUES (1, 3, now()),
	   (2, 1, "2025-03-15 14:30:00"),
       (2, 1, "2025-03-15 15:20:00"),
	   (2, 2, "2025-03-15 14:49:00"),
	   (1, 2, "2025-03-15 14:49:00"),
	   (1, 3, "2025-03-15 16:51:00"),
	   (4, 4, "2025-03-15 08:20:00"),
	   (6, 1, "2025-03-15 11:00:00");
-- fin question 2
