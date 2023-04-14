

(define (domain coffe-bar)

;remove requirements that are not needed
(:requirements :strips :adl :fluents :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    drink - object;
    cold - drink;
    warm - drink;
    robot- object;
    barista - robot;
    waiter - robot;
    bar table - location;
    
    tray - object;
)


(:predicates 
    (ready ?d-drink)   ;drink is ready to be served
    (free_barista ?b-barista) ;barista is free to prepare a drink
    (at_drink ?l-location ?d-drink) ;drink is at location
    (at_barista ?l-location ) ;barista is at location
    (at_tray ?l-location ) ;tray is at location
    (carrying_drink ?d-drink) ;waiter is carrying drink
    (carrying_tray ?w-waiter ?t-tray) ;waiter is carrying tray
    (at_drink_tray ?d-drink ?t-tray) ;drink is on tray
    (at_waiter ?l-location ) ;waiter is at location
    (free_waiter ?w-waiter) ;waiter is free 
    (connected ?l1-location ?l2-location)
    (served ?d-drink) ;locations are connected
    (preparing ?d-drink) ;drink is being prepared
    (moving ?w-waiter) ;waiter is moving
)

(:functions 
    (distance ?l1-location ?l2-location) ;distance between locations
    (distance_covered ?w - waiter) ;distance covered by waiter
    (duration_drink ?d - drink);duration of preparing drink
)

(:action prepare-drink
    :parameters ( ?d - drink ?b - barista ?l - bar)
    :precondition (and (free_barista ?b) (at_barista ?l) (not (ready ?d)) (not (preparing ?d)))
    :effect (and 
        (not(free_barista ?b))(preparing ?d)
    )
)

(:process preparing-drink
    :parameters (?d - drink)
    :precondition (and
        (preparing ?d)
        
    )
    
    :effect (and
        (decrease (duration_drink ?d) (* #t 1.0 ))
    )
)
(:event ready-drink 
    :parameters (?d - drink ?b - barista ?l - bar)
    :precondition (and
        (preparing ?d)
        (= (duration_drink ?d) 0.0)
    )
    :effect (and
        (ready ?d)
        (free_barista ?b)
        (at_drink ?l ?d)
        (not (preparing ?d))
    
    )
)


(:action pick-drink
    :parameters (?w - waiter ?d - drink  ?l - bar)
    :precondition (and (at_drink ?l ?d) (free_waiter ?w)(at_waiter ?l)(ready ?d)(not(moving ?w)))
    :effect (and (carrying_drink ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w))(moving ?w) )
)

(:process MOVE-WAITER
    :parameters (?w - waiter ?l1 - location ?l2 - location)
    :precondition (and (moving ?w) (connected ?l1 ?l2))
    :effect (and
        ;increase distance covered by waiter
        (increase (distance_covered ?w) (* #t 2.0)) 
    )
)
(:event arrive-waiter
    :parameters ( ?w - waiter ?l1 - location ?l2 - location)
    :precondition (and (moving ?w) (= (distance_covered ?w)(distance ?l1 ?l2)))
    :effect (and
        ;(not (carrying_drink ?d))
        (not (moving ?w))
        (assign (distance_covered ?w) 0.0)
        (at_waiter ?l2)
        
    )
)

(:action serve-drink
    :parameters ( ?w - waiter ?d - drink ?l - table )
    :precondition (and   (at_waiter ?l)(carrying_drink ?d)
    (not (free_waiter ?w)) (not(moving ?w)))
    :effect (and (not (carrying_drink ?d))  (free_waiter ?w) (at_drink ?l ?d) (moving ?w))
)
)