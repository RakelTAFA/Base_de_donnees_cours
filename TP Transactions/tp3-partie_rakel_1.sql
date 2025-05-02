START Transaction; /* mode transactionnel*/
Insert into Product values (default,'Fast furious 1', 12, 200);
Select * from Product;
Rollback;
Select * from Product;
START Transaction; /* mode transactionnel*/
Insert into Product values (default, 'Fast furious 1', 12, 200);
Commit;
Select * from Product;

use p2104789 ;
SET SQL_SAFE_UPDATES=0 ;
SET AUTOCOMMIT=1;
GRANT SELECT ON Product TO p2104789;
INSERT INTO Product VALUES (0,'Fastfurious 2', 10,1500) ;

SET AUTOCOMMIT=0 ; 

SELECT *
FROM p2104789.Customer;


-- 3

grant select on Customer to p2104789;
select firstname from Customer;
Revoke Select on Customer from p2104789;

use p2104789 ;
GRANT Select on Customer to p2104789;
SET AUTOCOMMIT=0;
SELECT firstname from Customer FOR UPDATE;
Revoke Select on Customer from p2104789;

GRANT update, select on Customer to p2104789;
START TRANSACTION;
UPDATE Customer SET firstname = 'Didier' where idCustomer = 1;
COMMIT;

-- 4
SET AUTOCOMMIT=0;
DROP TABLE IF EXISTS Employe ;
CREATE TABLE Employe (
nom varchar(20),
prenom varchar(20),
salaire float) ;
Delete from Employe;
SAVEPOINT P1 ;
INSERT INTO Employe VALUES('Perrin','Eric',2300);
INSERT INTO Employe VALUES('Perrin','Alfred',2400);
INSERT INTO Employe VALUES('Perrin','Brice',2500);
INSERT INTO Employe VALUES('Perrin','Jérome',2000);
SAVEPOINT P2 ;
INSERT INTO Employe VALUES('Duchateau','Emilie',1300);
INSERT INTO Employe VALUES('Duchateau','Bernard',1800);
INSERT INTO Employe VALUES('Duchateau','Eloise',1550);
INSERT INTO Employe VALUES('Duchateau','Lina',2000);
SAVEPOINT P3 ;
INSERT INTO Employe VALUES('Descharmes','Yanick',1800);
INSERT INTO Employe VALUES('Descharmes','Laura',1900);
INSERT INTO Employe VALUES('Descharmes','Charles',3550);
INSERT INTO Employe VALUES('Descharmes','Robin',2200);
-- Une seule action peut-être décommentée à la fois
-- ROLLBACK TO SAVEPOINT P1;
-- ROLLBACK TO SAVEPOINT P2;
-- ROLLBACK TO SAVEPOINT P3;

