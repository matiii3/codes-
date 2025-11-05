ZAD.1

SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY
ORDER BY PLACA_POD DESC
FETCH FIRST 3 ROWS ONLY;

SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY
WHERE ROWNUM <= 3
ORDER BY PLACA_POD DESC;

ZAD.2

SELECT T.NAZWISKO, T.PLACA_POD
FROM( SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY  
ORDER BY PLACA_POD DESC) T
WHERE ROWNUM <=10
MINUS
SELECT T.NAZWISKO, T.PLACA_POD
FROM( SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY  
ORDER BY PLACA_POD DESC) T
WHERE ROWNUM <=5


SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY  
ORDER BY PLACA_POD DESC
OFFSET 5 ROWS
FETCH NEXT 5 ROWS WITH TIES;


ZAD.3

WITH SREDNIA_PLAC AS
(SELECT ID_ZESP, AVG(PLACA_POD) AS SR
FROM PRACOWNICY
GROUP BY ID_ZESP)
SELECT NAZWISKO, PLACA_POD, PLACA_POD-SR
FROM PRACOWNICY JOIN SREDNIA_PLAC
ON PRACOWNICY.ID_ZESP = SREDNIA_PLAC.ID_ZESP
WHERE PLACA_POD>SR

ZAD.4
WITH lata AS
(SELECT extract( year from zatrudniony) as rok, COUNT(*) as liczba
FROM PRACOWNICY
group by extract( year from zatrudniony))
select * from lata
order by liczba desc

ZAD 5
WITH lata AS
(SELECT extract( year from zatrudniony) as rok, COUNT(*) as liczba
FROM PRACOWNICY

group by extract( year from zatrudniony)
order by liczba desc
fetch first 1 rows only)
select * from lata;

ZAD 6
with asystenci as (
    select nazwisko, etat, id_zesp
    from pracownicy
    where etat in ('ASYSTENT')
),
piotrowo as (
    select * from ZESPOLY
    where adres in ('PIOTROWO 3A')
)
select nazwisko, etat, adres
from asystenci inner join piotrowo 
on asystenci.id_zesp = piotrowo.id_zesp;

ZAD 7
with maks_suma as(
    SELECT id_zesp, sum(placa_pod) as maks_suma_plac
    FROM PRACOWNICY
    
    group by id_zesp
    order by sum(placa_pod) desc
    FETCH FIRST 1 ROW ONLY
)
select nazwa, maks_suma_plac
from zespoly inner join maks_suma on
zespoly.id_zesp = maks_suma.id_zesp;

ZAD 8
WITH
podwladni (id_prac, id_szefa, nazwisko, poziom) AS
(SELECT id_prac, id_szefa, nazwisko, 1
from PRACOWNICY
where nazwisko = 'BRZEZINSKI'
UNION ALL
SELECT p.id_prac, p.id_szefa, p.nazwisko, poziom+1
FROM podwladni s JOIN pracownicy p ON s.id_prac = p.id_szefa)
-- wskazanie sposobu przeszukiwania hierarchii i sortowania rekordów-dzieci
SEARCH DEPTH FIRST BY nazwisko SET porzadek_potomkow
SELECT nazwisko, poziom
FROM podwladni
ORDER BY porzadek_potomkow;

ZAD 9
WITH
podwladni (id_prac, id_szefa, nazwisko, poziom) AS
(SELECT id_prac, id_szefa, nazwisko, 1
from PRACOWNICY
where nazwisko = 'BRZEZINSKI'
UNION ALL
SELECT p.id_prac, p.id_szefa, p.nazwisko, poziom+1
FROM podwladni s JOIN pracownicy p ON s.id_prac = p.id_szefa)
-- wskazanie sposobu przeszukiwania hierarchii i sortowania rekordów-dzieci
SEARCH DEPTH FIRST BY nazwisko SET porzadek_potomkow
SELECT LPAD (nazwisko, length(nazwisko)+(poziom-1)) as nazwisko, poziom as pozycja_w_hierarchi
FROM podwladni
ORDER BY porzadek_potomkow;










WITH
podwladni (id_prac, id_szefa, nazwisko, poziom) AS
-- definicja korzenia hierarchii
(SELECT id_prac, id_szefa, nazwisko, 1
FROM pracownicy
WHERE nazwisko = 'BRZESINSKI'
UNION ALL
-- rekurencyjna definicja niższych poziomów
SELECT p.id_prac, p.id_szefa, p.nazwisko, poziom+1
FROM podwladni s JOIN pracownicy p ON s.id_prac = p.id_szefa)
-- wskazanie sposobu przeszukiwania hierarchii i sortowania rekordów-dzieci
SEARCH DEPTH FIRST BY nazwisko SET porzadek_potomkow
SELECT id_prac, id_szefa, nazwisko, poziom
FROM podwladni
ORDER BY porzadek_potomkow;
