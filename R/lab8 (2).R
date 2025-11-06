chemikalia=read.csv("C:\\Users\\student\\Downloads\\Reg_chemikalia.csv", sep=";",dec=",")
surowiec_x=chemikalia$surowiec
produkt_y=chemikalia$produkt

plot(surowiec_x,produkt_y)

cov(surowiec_x, produkt_y)
# S_XY=138.4889
#kowariancja jest rozna od 0 zatem istnieje liniowa zaleznosc miedzy iloscia 
#zuzytego surowca a koncowa wielkoscia produkcji srodkow chemicznych

#poniewaz s_xy jest dodatnia zatem ze wzrostem ilosci zuzytego surowca wzrasta koncowa wielkosc produkcji srodkow chemicznych 

cor(surowiec_x, produkt_y)

#r_XY= 0.8953468

#wspolczynnik korelacji r=0.85>|0.8| zatem istnieje bardzi silny 
#zwiazek liniowy miedzy iloscia zuzytego surowca a koncowa wielkoscia produkcji srodkow chemicznych
# to sie odczytuje z tabelki z wykladu, mozna ja miec na kolosie 

prosta=lm(produkt_y ~surowiec_x)
prosta
# y =22.41 + 3.61*x - rownanie prostej regresji liniowej 
#miedzy wielkoscia prodykcji a iloscia zuzytego surowca

summary(prosta)

plot(surowiec_x,produkt_y);abline(prosta)

#jesli ilosc surowca wzroscnie o 1l to koncowa wielkosc produkcji srodkow chemicznych wzrosnie o 3,61kg
#(jest to interpretacja wspolczynnika regresji liniowej )

predict(prosta, data.frame(surowiec_x=c(20,15)))

#jesli zuzyjemy 20l surowca to koncowa wielkosc produkcji wynisie 94.79kg
#jesli zuzyjemy 15l to koncowa wielkosc produkcji wyniesie 76.69kg 

summary(prosta)
#wspolczynnik determinacji R-squared=0.8016*100%=80,16%
# (linijka ,,multiple R-squared: '')
#prosta regresji liniowe jjest dobrze dopasowana do  danych 
#powyzej 80 - dobrze dopasowane
#okolo 50 - umiarkowanie
# ponizej to slabo 

#koncowa wielkosc produkcji srodkow chemicznych jest wyjasniona w okolo 80% przez ilosc zuzytego surowca

#H0: b1=0 (regresja liniowa nieistotna)
#H1: b1!=0 (istotna)

anova(prosta)
#I sposob
alfa=0.05
n=length(surowiec_x)
qf(1-alfa,1,n-2)
#F=32.332 > F_t=5.317655 -> odrzucamy H0

#II sposob
#alfa = 0.05> p-value = 0.0004617 -> odrzucamy H0

#na poziomie istotnosci alfa = 0.05 dane potwierdzaja hipoteze ze regresja liniowa jest istotna

#zad2

urzadzenia=read.csv("C:\\Users\\student\\Downloads\\Reg_urzadzenie.csv", sep=";",dec=",")
efektywnosc_x=urzadzenia$efektywnosc
zywotnosc_y=urzadzenia$zywotnosc

plot(efektywnosc_x,zywotnosc_y)

cov(efektywnosc_x,zywotnosc_y)

cor(efektywnosc_x,zywotnosc_y)

prosta=lm(zywotnosc_y~efektywnosc_x)
prosta
# y = 18.88 -0.86*x

summary(prosta)
predict(prosta, data.frame(efektywnosc_x=c(11,19)))


#82.7%
anova(prosta)
