use p2104789 ;
SET SQL_SAFE_UPDATES=0 ;
SET AUTOCOMMIT=1;

SELECT *
FROM p2100832.Product;

SET AUTOCOMMIT=0 ; 
GRANT select on Customer to p2100832;

INSERT INTO Customer VALUES
(default,'Meunier', 'Mathéo', '12 rue
Albert Einstein, Villeurbanne',
'2000-09-12', '0613058841', 'm', null
);
INSERT INTO Customer VALUES
(default,'Charpentier', 'Lila', '25
rue de la république, Bourg en
Bresse', '1998-05-10',
'070305999', 'f', null );

commit;

INSERT INTO Customer VALUES
(default,'Chiba', 'Didier', '25 bv du
11 nov. 1918, Toulouse', '2001-11-02', '073356123', 'm',null );
rollback;

Alter table Customer add email varchar(30); /*Pas affecté par le mode transactionnel*/

INSERT INTO Customer VALUES
(default,'Chiba', 'Didier', '25 bv du
11 nov. 1918, Toulouse', '2001-11-02', '073356123', 'm',null,null );

Alter table Customer drop email;
Rollback ; /*Inutile car Alter autocommit tout ce qu'il y a avant*/

Revoke Select on Customer from p2100832;


-- 3

Use p2100832;
select firstname
from Customer
where idCustomer = 1;

START TRANSACTION;
UPDATE Customer SET firstname = 'Bebert' where idCustomer = 1;
COMMIT; /*Ajouter commit pour valider les changements*/