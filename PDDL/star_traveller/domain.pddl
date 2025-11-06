(define
        (domain stars)
        (:requirements :adl)
        (:predicates
                (przejscie ?A ?B ?z) ;istnieje przejscie z A do B
                (lever ?d ?p)
                (traveler ?A)
                (odblokowana ?p)
                (wolne ?f)
                (button ?B)
                (guzik ?p)
                (blokada ?x ?p)
                (star ?s ?m)
                (gwiazdozbior ?A)
                (pusta ?sx)
                (sasiad ?m1 ?m2)
                
        )

        (:action pull-lever 
            :parameters (?d ?p)
            :precondition (and 
                (traveler ?p)
                (lever ?d ?p)
                (not(blokada ?d ?p))
                (not(odblokowana ?d))


            )
            :effect (and 
                (odblokowana ?d)
            )
        )
        (:action move
            :parameters (?B ?A ?d)
            :precondition (and 
                (traveler ?A)
                (przejscie ?A ?B ?d)
                (or 
                    (odblokowana ?d)
                    (wolne ?d)
                )
            )
            :effect (and 
                (not(traveler ?A))
                (traveler ?B)
                (not(odblokowana ?d))
            )
        )
        (:action press-button
            :parameters (?A ?p ?B)
            :precondition (and 
                (traveler ?A)
                (button ?A)
                (blokada ?p ?B)
            )
            :effect (and 
                (not(blokada ?p ?B))
            )
        )

        (:action move-star
            :parameters (?S ?p ?sx ?m1 ?mx)
            :precondition (and 
                (traveler ?p)
                (gwiazdozbior ?p)
                (pusta ?sx)
                (star ?S ?m1)
                (star ?sx ?mx)
                (or
                    (sasiad ?m1 ?mx)
                    (sasiad ?mx ?m1)
                )
            
            )
            :effect (and 
            (not (star ?S ?m1))
            (not (star ?sx ?mx))
            (star ?S ?mx)
            (star ?sx ?m1)

            )
        )
)
