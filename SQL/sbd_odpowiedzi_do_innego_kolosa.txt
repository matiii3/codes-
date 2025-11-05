select nazwa, rok_produkcji, czas_trwania_w_minutach
from SBD_Programy p
where upper(ograniczenie_wiekowe) = ‘BEZ OGRANICZEŃ’
and czas_trwania_w_minutach < 60,
and nazwa like ‘%odc%
order by czas_trwania_w_minutach desc, nazwa, rok_produkcji
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
select rok_produkcji, count(*)
from SBD_programy
group by rok_produkcji having count(*)>1
order by rok_produkcji
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
select time(har.poczatek_emisji), pro.nazwa , kat.nazwa, pro.ograniczenie_wiekowe
from SBD_Harmonogram_emisj hari
join SBD_Programy pro using(id_programu)
join sbd_kategorie kat on kat.symbol = pro.symbol_kategori
where nazwa_kanału = ‘TVN’ and cast(poczatek_emsji as date) = date ‘2024-05-30’
order by har.poczatek_emisji

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
select har.nazwa_kanalu
SBD_Harmonogramy_emisji har join SBD_Programy pro
on har.id_programu = pro.id_programu
group by har.nazwa_kanalu
having avg(czas_trwania_w_minutach) > (select avg(czas_trwania_w_minutach)
from SBD_Harmonogramy_emisji har2 join SBD_Programy pro2
on har.id_programu = pro.id_programu
where har.nazwa_kanalu = 'TVP 1')
order by har.nazwa_kanalu

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
alter table SBD_Kategorie
add column LICZBA_PROGRAMOW integer constraint dodatnie check(LICZBA_PROGRAMOW >=0)

update SBD_Kategorie kat
set LICZBA_PROGRAMOW = (select coalesce(count(*),0)
from sbd_programy pro
where pro.symbol_kategori = kat.symbol)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

create or replace view SBD_analiza_kanalow_V
as
select case
when rok_zalozenia <2000 then 'zalozone przed 2000'
when rok_zalozenia > 2010 then 'zalozone po 2010'
else 'zalozone w latach pd 2000 do 2010'
end as kategoria
count(nazwa_kanalu) as liczba_kanalow,
avg(extract(year from current_date) - rok_zalozenia) as sredni_wiek
from SBD_Harmonogramy_emisji he
inner join SBD_kanały k on k.nazwa = he.nazwa_kanalu
group by kategoria;

select * from SBD_analiza_kanalow_V


alter table SBD_Programy
add column Liczba_emisji integer 
constraint dodatnie check(LICZBA_PROGRAMOW >=0)



update SBD_Programy prog
set LICZBA_PROGRAMOW = (select coalesce(count(*),0)
from sbd_programy pro
where pro.symbol_kategori = kat.symbol)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
create table SBD_Oceny_widzow (
email varchar(100) not null,,
data_oceny date not null,
ocena integer constraint Ocena_zakres check(ocena between 1 and 10),
opcjonalne_uwagi varchar(200),
id_programu integer
constraint fk_oceny foreign key(id_programu) references SBD_Programy(id_programu),
constraint priamry key(email, id_programu)
);

insert into SBD_Oceny_widzow(email,data_oceny,ocena,dodatkowe_uwagi,id_programu)
values
(‘a@vp.pl’, current_date, 5,null,12),
(‘a@vp.pl’, current_date, 5,null,13);  