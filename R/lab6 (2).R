#lab6: Testowanie hipotez (dwie populacje)

pop=read.csv("C:/Users/Student/Downloads/DwiePopulacje.csv", sep=";")
class(pop)
pop

#zad 1a

#(1) sformułowanie hipotezy
#H0: mu1-mu2=0  H1:mu1-mu2!=0 (mu0=0)
#H0: mu1=mu2  H1:mu1!=mu2

#(2) obliczenie statystyki testowej (w6, s. 5)
regbar1=na.omit(pop$cel1)
regbar2=na.omit(pop$cel2)
x_bar1=mean(regbar1)
x_bar2=mean(regbar2)
var1=var(regbar1)
var2=var(regbar2)
n1=length(regbar1)
n2=length(regbar2)
Sp2=((n1-1)*var1+(n2-1)*var2)/(n1+n2-2)

t=(x_bar1-x_bar2)/sqrt(Sp2*(1/n1+1/n2)) #t=-1.539823

#(3) wyznaczenie obszaru krytycznego
alfa=0.02
qt(1-alfa/2, n1+n2-2) #=2.47266
#R=(-inf; -2.47266) suma (2.47266; inf)

#(4) podjecie decyzji
#t=-1.539823 nie należy do R => brak podstaw do odrzucenia H0

#(5) Interpretacja 
#Na poziomie istotności alfa=0.02 dane nie potwierdzają hipotezy, że
#przeciętna zawartość celulozy dla regionu I różni się istotnie od przeciętnej zawartości celulozy dla regionu II.

#zad 1a - procedura testowa w R

#(1) sformułowanie hipotezy
#H0: mu1-mu2=0  H1:mu1-mu2!=0 (mu0=0)
#H0: mu1=mu2  H1:mu1!=mu2

#(2) obliczenie statystyki testowej (w6, s. 5)
t.test(regbar1, regbar2, var.equal = TRUE, mu = 0, alternative = "two.sided")

#(3)
#p-value = 0.1352

#(4) podjecie decyzji
# alfa=0.02 < p-value = 0.1352 => brak podstaw do odrzucenia H0

#(5) Interpretacja 
#Na poziomie istotności alfa=0.02 dane nie potwierdzają hipotezy, że
#przeciętna zawartość celulozy dla regionu I różni się istotnie od przeciętnej zawartości celulozy dla regionu II.

#zad1b

#(1) sformułowanie hipotezy
#H0: sig^2_1-sig^2=0  H1: sig^2_1-sig^2!=0

#(2) obliczenie statystyki testowej (w6, s. 17)
f=var1/var2 #=0.4786012

#(3) wyznaczenie obszaru krytycznego
qf(alfa/2, n1-1, n2-1) #=0.162458
qf(1-alfa/2, n1-1, n2-1) #=3.69874
# R=(0; 0.162458) suma (3.69874; inf)

#(4) podjecie decyzji
#f=0.4786012 nie należy do R => brak podstaw do odrzucenia H0

#(5) Interpretacja 
#Na poziomie istotności alfa=0.02 dane nie potwierdzają hipotezy o różności wariancji, zatem możemy założyć, że wariancje są jednorodne.

#zad1b - procedura testowa w R

library(PairedData)

#(1) sformułowanie hipotezy
#H0: sig^2_1-sig^2=0  H1: sig^2_1-sig^2!=0

#(2) obliczenie statystyki testowej (w6, s. 17)
var.test(regbar1, regbar2, alternative = "two.sided")

#(3) wyznaczenie obszaru krytycznego
#p-value = 0.3225

#(4) podjecie decyzji
# alfa=0.02 < p-value = 0.3225 => brak podstaw do odrzucenia H0

#(5) Interpretacja 
#Na poziomie istotności alfa=0.02 dane nie potwierdzają hipotezy o różności wariancji, zatem możemy założyć, że wariancje są jednorodne.

#zad 1c
# obliczenie statystyki testowej (w6, s. 4)
t.test(regbar1, regbar2, var.equal = TRUE, conf.level = 1-alfa)
#na poziomie ufnosci 98% przedzial (-13.52; 3.15) pokrywa nieznana prawdziwą różnicę średnich zawartości celulozy w dwóch regionach

#Interpretacja
# Ponieważ przedział (-13.52; 3.15) pokrywa wartość 0, zatem nie mamy podstaw do odrzucenia H0

#zad 3

publiczny=pop$publiczny
prywatny=pop$prywatny

#(1) sformułowanie hipotezy
#H0:  sig^2_1!=sig^2_2 H1: sig^2_1=sig^2_2 

#(2) obliczenie statystyki testowej (w6, s. 17)
var.test(publiczny, prywatny, alternative = "two.sided")

#(3) p-value=0.08687
#(4) podjecie decyzji
#alfa=0.1 > p-value=0.08687 => odrzucamy H0

#(5) Interpretacja
#na poziomie istotności 0.1 dane potwierdzają hipotezę o różności wariancji
#Zakładamy, że wariancje są różne

#(1) sformułowanie hipotezy
# H0: mu1-mu2>=0  H1: mu1-mu2<=0

#(2)
# obliczenie statystyki testowej (w6, s. 4)
alfa=0.1
t.test(publiczny, prywatny, var.equal = FALSE, conf.level = 1-alfa, alternative = "less")

#(3) p-value = 0.023
#(4) podjecie decyzji
#alfa=0.1 > p-value = 0.023 => odrzucamy H0

#(5) Interpretacja
#na poziomie istotnosci 0.1 dane potwierdzają hipotezę, 
#że publiczne  źródła finansowania udzielają, przeciętnie rzecz biorąc, mniejszych kredytów

#zad 4

zawodnik1=pop$zawodnik1
zawodnik2=pop$zawodnik2

#(1) sformułowanie hipotezy
#H0:  sig^2_1-sig^2_2>=0 H1: sig^2_1-sig^2_2<0 

#(2) obliczenie statystyki testowej (w6, s. 17)
var.test(zawodnik1, zawodnik2, alternative = "less")

#(3) p-value = 0.2108
#(4) podjecie decyzji
#alfa=0.05 < p-value = 0.2108 => brak podstaw do odrzucenia H0

#(5) Interpretacja
#na poziomie istotności 0.05 dane nie potweirdzają hipotezy o większej regularności wyników pierwszego zawodnika. 

#zad 6
#zad dom 6 a, b, c-> własne funkcje w R - zastosowanie wzorów (w6 s. 21)

phat1=T1/n1
phat2=T2/n2

#(a)
T1=0.78*1200 #0.78-procent zadowolonych, 1200 - wielkosc populacji
T2=0.8*2000 #0.8-procent zadowolonych, 2000 - wielkosc populacji
n1=1200
n2=2000
prop.test(c(T1, T2), c(n1, n2), conf.level = 0.9) #=(-0.045229569; 0.005229569)

#Interpretacja
#na poziomie ufnosci 90% przedział (-4.53%; 0.53%) pokrywa nieznana prawdziwą różnicę proporcji Polaków i Amerykanów zadowolonych z pracy

#(b)
#(1) sformułowanie hipotezy
#H0: p1-p2>=0  H1: p1-p2<0

#(2) obliczenie statystyki testowej (w6, s. 22)
prop.test(c(T1, T2), c(n1, n2), alternative = "less")

#(3) p-value = 0.09583
#(4) podjęcie decyzji
#alfa=0.1 > p-value = 0.09583 => odrzucamy H0

#na poziomie istotności 0.1 dane potwierdzają hipotezę, że  proporcja zadowolonych Polaków jest mniejsza niż zadowolonych Amerykanów 

#zad 9

przed=c(15, 4, 9, 9, 10, 10, 12, 17, 14)
po=c(14, 4, 10, 8, 10, 9, 10, 15, 14)

roznica=przed-po #chcemy sprawdzić czy różnica mniejsza 0, czy nie

#(1) sformułowanie hipotezy
#H0: mu=0 H1: mu!=0

#(2) obliczenie statystyki testowej
t.test(roznica, conf.level = 0.05)

#(3) p-value = 0.08052
#(4) podjęcie decyzji
#alfa=0.05 < p-value = 0.08052 => brak podstaw do odrzucenia H0

#(5) Interpretacja
#Na poziomie istotności 0.05 dane nie potwierdzają hipotezy, że dany rodzaj leku zmienia wartości określonego parametru biochemicznego
