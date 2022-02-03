/*
1)
Primærnøklene sin hensikt er å gi alle radene i en tabell hver sin unike ID. Derfor må primærnøkler være unike,
 og alle radene under primærnøkkelkolonnen må være utfylt med data. Altså ikke null.
*/

/*
2)
*/
DROP TABLE IF EXISTS oppbygging;
DROP TABLE IF EXISTS onske;
DROP TABLE IF EXISTS del;
DROP TABLE IF EXISTS gave;
DROP TABLE IF EXISTS person;

CREATE TABLE del
(
    dnr SMALLINT,
    navn VARCHAR(20),
    lager_ant INTEGER,
    PRIMARY KEY (dnr)
);


CREATE TABLE gave
(
    gnr SMALLINT,
    navn VARCHAR(50) UNIQUE,
    prod_tid INTEGER NOT NULL,
    PRIMARY KEY (gnr)
);



CREATE TABLE person
(
    pnr SMALLINT AUTO_INCREMENT,
    fornavn VARCHAR(30),
    etternavn VARCHAR(30),
    fdato DATE,
    PRIMARY KEY (pnr)

);


CREATE TABLE onske
(
    onr SMALLINT AUTO_INCREMENT,
    pnr SMALLINT,
    gnr SMALLINT,
    prioritet SMALLINT,
    ferdig SMALLINT,
    PRIMARY KEY (onr),
    FOREIGN KEY (pnr) REFERENCES person (pnr),
    FOREIGN KEY (gnr) REFERENCES gave (gnr)
);





CREATE TABLE oppbygging
(
    gnr SMALLINT,
    dnr SMALLINT,
    ant SMALLINT,
    PRIMARY KEY (gnr, dnr),
    FOREIGN KEY (gnr) REFERENCES gave (gnr),
    FOREIGN KEY (dnr) REFERENCES del (dnr)

);





/*
3)
Det første man må passe på når man skal importere CSV filene inn i phpMyAdmin er at alle tabellene er definert. Tabellene må
også defineres i riktig rekkefølge, altså man kan ikke definere en tabell som inneholder en fremmednøkkel fra en annen tabell
før den tabellen er definert.

Deretter trykker man på tabellen man skal importere data til, så trykker man på importer.

Her må man velge riktig csv fil på maskinen din for opplastning, og velge riktig tegnsett.
Deretter velger man å skippe første linje, for der inneholder informasjon om kolonnenavn, og de har vi allerede definert
når vi definerte tabellene.

Så passer man på at der man velger hvilket tegn kolonnene er separert med er riktig, i vårt tilfelle må vi endre det til ";".
Deretter ser man til at "Kolonner omsluttet av:" er tom, så trykker man på "gå".

Nå skal dataen være importert, og da er det bare å repetere det med alle tabellene.
*/






/*
4)
*/

SELECT *
FROM person
WHERE fdato >= '2000-01-01'
AND fdato <= '2009-31-12'
AND etternavn LIKE 'H%'
ORDER BY etternavn
;







/*
5)
*/

SELECT *
FROM gave
WHERE UPPER(navn) LIKE '%MODELLFLY%'
;






/*
6)
*/

SELECT gave.navn, onske.prioritet, gave.prod_tid, person.pnr
FROM gave, onske, person
WHERE gave.gnr = onske.gnr
AND person.pnr = onske.pnr
AND person.pnr = 23
ORDER BY prioritet
;








/*
7)
*/

SELECT del.navn, SUM(oppbygging.ant)
FROM del, oppbygging
WHERE del.dnr = oppbygging.dnr
GROUP BY del.navn
;








/*
8)
*/


SELECT 
    CONCAT(person.pnr, ',', ' ', person.fornavn, ' ', person.etternavn) AS Personer,
    COUNT(onske.pnr) AS Sumonsker
FROM person, onske
WHERE person.pnr = onske.pnr
GROUP BY onske.pnr
HAVING COUNT(onske.pnr)>7
ORDER BY person.fdato DESC
;









/*
9)
*/

INSERT INTO person (fornavn, etternavn, fdato)
VALUES ('Sturla', 'Solheim', '1996-04-23')
;


INSERT INTO onske (pnr, gnr, prioritet)
VALUES
 (
    '101',
    '1',
    '3'
),

 (
    '101',
    '2',
    '2'
),


 (
    '101',
    '3',
    '1'
)
;










/*
10)
*/



SELECT CONCAT(gave.navn, ',', ' ', SUM(gave.prod_tid)) AS 'Tid per gave'
FROM gave, onske
WHERE gave.gnr = onske.gnr
GROUP BY onske.gnr
;


SELECT SUM(gave.prod_tid) AS Totaltid
FROM gave, onske
WHERE gave.gnr = onske.gnr
GROUP BY onske.gnr;