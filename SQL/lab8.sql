1



INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,  ID_ZESP)

VALUES 

(250, 'KOWALSKI', 'ASYSTENT', TO_DATE('13-JAN-2015', 'DD-MON-YYYY'), 1500, 10);

INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,  ID_ZESP)

VALUES 

(260, 'ADAMSKI', 'ASYSTENT', TO_DATE('10-SEP-2014', 'DD-MON-YYYY'), 1500, 10);

INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD, PLACA_DOD, ID_ZESP)

VALUES 

(270, 'NOWAK', 'ADIUNKT', TO_DATE('01-MAY-1990', 'DD-MON-YYYY'), 2050, 540, 20);

SELECT * FROM PRACOWNICY

WHERE ID_PRAC IN (250, 260, 270);

2



UPDATE PRACOWNICY

SET PLACA_POD = PLACA_POD * 1.1, 

    PLACA_DOD = NVL(PLACA_DOD, 100) * 1.2

WHERE ID_PRAC IN (250, 260, 270);

SELECT * FROM PRACOWNICY

WHERE ID_PRAC IN (250, 260, 270);

3



INSERT INTO zespoly VALUES (60, 'BAZY DANYCH', 'PIOTROWO 2');

SELECT * FROM ZESPOLY

where id_zesp = 60;

4



UPDATE PRACOWNICY

SET ID_ZESP = (SELECT ID_ZESP FROM ZESPOLY WHERE NAZWA = 'BAZY DANYCH')

WHERE ID_PRAC IN (250, 260, 270);

SELECT * FROM PRACOWNICY WHERE ID_ZESP = (SELECT ID_ZESP FROM ZESPOLY WHERE NAZWA = 'BAZY DANYCH');

5





UPDATE PRACOWNICY

SET ID_SZEFA = (SELECT ID_PRAC FROM PRACOWNICY p  WHERE p.NAZWISKO = 'MORZY')

WHERE ID_ZESP = (SELECT ID_ZESP FROM ZESPOLY WHERE NAZWA = 'BAZY DANYCH');

SELECT * FROM PRACOWNICY WHERE ID_SZEFA = (SELECT ID_PRAC FROM PRACOWNICY p  WHERE p.NAZWISKO = 'MORZY');



6



delete from ZESPOLY

WHERE nazwa = 'BAZY DANYCH';







7



delete from PRACOWNICY

where id_zesp = (SELECT id_zesp from zespoly where nazwa = 'BAZY DANYCH');

delete from ZESPOLY

where nazwa = ('BAZY DANYCH');

select *  from PRACOWNICY

where id_zesp = (SELECT id_zesp from zespoly where nazwa = 'BAZY DANYCH');

select *  from ZESPOLY

where nazwa = ('BAZY DANYCH');



8



select nazwisko, placa_pod, 

(select

(avg(placa_pod)*0.1) as podwyzka

from PRACOWNICY s

where p.id_zesp = s.id_zesp

group by id_zesp) as podwyzka

from pracownicy p 

order by nazwisko;



9



update pracownicy p

set placa_pod = (SELECT (avg(placa_pod)*0.1) 

from PRACOWNICY s

where p.id_zesp = s.id_zesp

group by id_zesp)+placa_pod;

select nazwisko, placa_pod

from pracownicy

order by nazwisko;



10



select * from pracownicy 

where placa_pod=(select min(placa_pod) from pracownicy);



11



update PRACOWNICY

set  placa_pod =  (select avg(placa_pod) from pracownicy z)

where placa_pod =(select min(placa_pod) from pracownicy p);

select * from PRACOWNICY

where id_prac = 200;



12





update PRACOWNICY

set  placa_dod = (select avg(placa_pod) 

from pracownicy m 

where id_szefa = (select id_prac from pracownicy s where s.nazwisko = 'MORZY')

group by m.id_szefa)

where id_zesp = 20;

select nazwisko, placa_dod

from pracownicy u

where id_zesp = 20

order by nazwisko;



13



UPDATE PRACOWNICY p

SET p.PLACA_POD = p.PLACA_POD * 1.25

WHERE p.ID_ZESP IN (SELECT z.ID_ZESP FROM ZESPOLY z WHERE z.NAZWA = 'SYSTEMY ROZPROSZONE');

select nazwisko, PLACA_POD

from PRACOWNICY p

where p.ID_ZESP IN (SELECT z.ID_ZESP FROM ZESPOLY z WHERE z.NAZWA = 'SYSTEMY ROZPROSZONE')

order by nazwisko;



14



select nazwisko from pracownicy p

where id_szefa = (select id_prac from pracownicy m where nazwisko = 'MORZY');



DELETE FROM pracownicy

WHERE id_prac IN (

    SELECT p.id_prac

    FROM pracownicy p

    WHERE p.id_szefa IN (SELECT id_prac FROM pracownicy WHERE nazwisko = 'MORZY')

);



select nazwisko from pracownicy p

where id_szefa = (select id_prac from pracownicy m where nazwisko = 'MORZY');





15



select * from PRACOWNICY

order by nazwisko
