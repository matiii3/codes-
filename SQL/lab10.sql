zad.1

create view ASYSTENCI
as 
 select 
 p.nazwisko, .placa_pod+nvl(p.placa_dod,0) as placa, 

 round(months_between(to_date('01-01-2024','DD-MM-YYYY'),p.zatrudniony)/12,1) as staz

 from pracownicy p 


zad.2
create view place

(ID_ZESP, SREDNIA, MINIMALNA, MAXIMUM, FUNDUSZ, L_PENSJI, L_DODATKOW)

AS

SELECT id_zesp,

avg (placa_pod +nvl(placa_dod, 0)),

min(placa_pod +nvl(placa_dod, 0)),

max(placa_pod +nvl(placa_dod, 0)),

sum(placa_pod +nvl(placa_dod, 0)),

count(placa_pod ),

count(placa_dod)

from pracownicy

group by id_zesp;



select * from place

order by id_zesp



zad.3

select nazwisko, placa_pod from pracownicy p

where p.placa_pod < (select srednia

from place where id_zesp = p.id_zesp)

order by nazwisko



zad.4

create view place_minimalne

(id_prac, nazwisko, etat, placa_pod)

as select id_prac, nazwisko, etat, placa_pod

from pracownicy where placa_pod < 700

with check option constraint ze_wysoka_placa;

select id_prac, nazwisko, etat, placa_pod from place_minimalne



zad.5

update place_minimalne

set placa_pod = 800 where nazwisko = 'HAPKE';



zad.6

CREATE VIEW PRAC_SZEF

AS

SELECT

    p.id_prac,

    p.id_szefa,

    p.nazwisko AS pracownik,

    p.etat,

    s.nazwisko AS szef

FROM

    pracownicy p LEFT JOIN pracownicy s ON p.id_szefa = s.id_prac;



zad.7

CREATE VIEW ZAROBKI

AS

SELECT

    p.id_prac,

    p.nazwisko,

    p.etat,

    p.placa_pod

FROM

    pracownicy p

    JOIN pracownicy s ON p.id_szefa = s.id_prac

WHERE

    p.placa_pod <= s.placa_pod

WITH CHECK OPTION CONSTRAINT za_wysoka_placa;



zad.8

SELECT column_name, updatable, insertable, deletable

 FROM user_updatable_columns

 WHERE table_name = 'PRAC_SZEF';
