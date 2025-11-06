#zad1

cisnienie=read.csv("C:\\Users\\student\\Downloads\\Anova_cisnienie.csv",sep=";")
obiekty=rep(names(cisnienie),each=length(cisnienie$Niskie))
wyniki=c(na.omit(cisnienie$Niskie),
         na.omit(cisnienie$Srednie),
         na.omit(cisnienie$Silne),
         na.omit(cisnienie$BardzoSilne)
         )
cisnienieTest=data.frame(obiekty,wyniki)

#srednie probkowe 
srednie=sapply(split(cisnienieTest$wyniki,cisnienieTest$obiekty),mean)

srednie

#HO:sig1^2=sig2^2=sig^2=sig4^2 H1: ~H0
#H0: wariacje sa jednorodne H1: ~H0

bartlett.test(wyniki~obiekty, cisnienieTest)
alfa=0.05
#alfa=0.05<p-value=0.5009 -> brak podstaw do odrzucenia H0

#Na poziomie istotnosci 5% nie mmay podstaw do odrzucania H0 zatem zakladamy  jednorodnosc wariancji i mozemy przeprowadzic ANOVE

#H0: mu1=mu2=mu3=mu4 H1: ~H0
anova(lm(wyniki~obiekty))

#1sposob F=2.2665 < ql(1-alfa,3,36)=F_tabl=2.866266 -> 
qf(1-alfa,3,36)

#2sposob: alfa=0.05<p-value=0.09735 -> brak podstaw dp odrzucenia H0

#Na poziomie istotnosci 5% nie mamy podstaw do odrzucenia H0
#stwierdzamy zatem, że cisnienie nie ma istotnego wplywu na wielkosc produkcji

#zad2 -> zadanie domowe ?

#zad3
#a

mikrometry=read.csv("C:\\Users\\student\\Downloads\\Anova_mikrometr.csv",sep=";",dec=",")
obiekty=rep(names(mikrometry),c(length(na.omit(mikrometry$mikrometrI)),length(na.omit(mikrometry$mikrometrII)),length(na.omit(mikrometry$mikrometrIII))))
wyniki=c(na.omit(mikrometry$mikrometrI),na.omit(mikrometry$mikrometrII),na.omit(mikrometry$mikrometrIII))
mikrometryTest=data.frame(obiekty,wyniki)

srednie=sapply(split(mikrometryTest$wyniki,mikrometryTest$obiekty),mean)

anova(lm(wyniki~obiekty))

#alfa=0.05 < p-value=0.06859 brak podstaw do odrzucenia H0
#Na poziomie istotnosci 5% nie mamy podstaw do odrzucenia H0
#stwierdzamy zatem, że wybór mikrometru nie ma wpływu na uzyskane wyniki

sportowcy=read.csv("C:\\Users\\student\\Downloads\\Anova_sportowcy.csv",sep=";")
obiekty=rep(names(sportowcy),each=length(sportowcy$Niepalacy))
wyniki=c(sportowcy$Niepalacy,sportowcy$Lekkopalacy,sportowcy$Sredniopalacy,sportowcy$Duzopalacy)

sportowcyTest=data.frame(obiekty,wyniki)
srednie=sapply(split(sportowcyTest$wyniki,sportowcyTest$obiekty),mean)

bartlett.test(wyniki~obiekty,sportowcyTest)
alfa=0.01

anova(lm(wyniki~obiekty))

#Na poziomie istotnosci odrzucamy H0
#stwierdzamy zatem, ze palenie paierosow moze wplywac na rytm zatokowy serca

#b

#sprawdzimy ktore poziomy palenia sa podone(nie roznia sie miedzy soba istotnie)

TukeyHSD(aov(wyniki~obiekty))

#grupy jednorodne
# nie roznia sie miedzy soba istotnie: (L,D) (N,D) (Ś,D) (Ś,N)
#                                      (L,D)    |  (N-Ś-D)
#obiekty w grupach jednorodnych nie roznia sie miedzy soba istotnie 

plot(TukeyHSD(aov(wyniki~obiekty)))

#zad4

chomiki=read.csv("C:\\Users\\student\\Downloads\\Anova_chomiki.csv", sep=";")
obiekty=rep(names(chomiki),c(length(na.omit(chomiki$I)),length(na.omit(chomiki$II)),length(na.omit(chomiki$III)),length(na.omit(chomiki$IV))))
wyniki=c(na.omit(chomiki$I),na.omit(chomiki$II),na.omit(chomiki$III),na.omit(chomiki$IV))
chomikiTest=data.frame(obiekty,wyniki)


bartlett.test(wyniki~obiekty)
anova(lm(wyniki~obiekty))
#alfa=0.5 > p-value=0.02398 -> odrzucamy H0
#na poziomie istotnosci 5% odrzucamy H0
plot(TukeyHSD(aov(wyniki~obiekty)))
#stwierdzamy że masa gruszolu zalezy od poziomu inbreadu

#grupy jednorodne 

# (I- II - III)
# (II - III - IV)

