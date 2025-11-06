(define
        (domain bagend)
        (:requirements :adl)
        (:predicates
                (przejscie ?A ?B ?z) ;istnieje przejscie z A do B o kolorze z
                (kulka ?k ?A) ;kulka k jest w pokoju A
                (kolor ?k ?z) ;kulka k jest koloru z
                (posiada ?k) ; merry posiada konkretna kulke k
                (merry ?A) ; merry jest w pokoju A
                (pokoj ?A) ; zmienna A jest pokojem
                (klocek ?a1 ?p)
                (sasiad ?x ?y)
                (puste ?p)
        )

        (:action wez
            :parameters (?z ?A ?k) ;jestesmy w pokoju ?A i bierzemy kolor ?z
            :precondition
            (and
                (merry ?A)
                (pokoj ?A)
                (kulka ?k ?A)
                (kolor ?k ?z)
                (not(posiada ?k))
                        
            )
            :effect (and
                (merry ?A)
                (not(kulka ?k ?A))
                (posiada ?k)
            )
        )

        (:action idz
            :parameters (?A ?B ?k ?z)
            :precondition (and
                (merry ?B)
                (not(merry ?A))
                (posiada ?k)
                (kolor ?k ?z)
                (pokoj ?A)
                (pokoj ?B)
                (przejscie ?B ?A ?z)
             )
            :effect (and
                (merry ?A)
                (not (merry ?B))
                (not (posiada ?k))
             )
        )

        (:action przesun
            :parameters (?a1 ?b1 ?p1 ?p )
            :precondition (and
                (klocek ?a1 ?p1)
                (klocek ?b1 ?p)                       ;a1 - b1
                (sasiad ?p1 ?p)                   ; pole p1  pole p
                (puste ?b1)

            )
            :effect (and
                (not(klocek ?a1 ?p1))
                (not(klocek ?b1 ?p))
                (klocek ?b1 ?p1)
                (klocek ?a1 ?p)
          
            )
        )
        
                      
)
