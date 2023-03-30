;Header and description

(define (domain coffe-bar)

;remove requirements that are not needed
(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time)

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
    (carrying_drink ?w-waiter ?d-drink) ;waiter is carrying drink
    (carrying_tray ?w-waiter ?t-tray) ;waiter is carrying tray
    (at_drink_tray ?d-drink ?t-tray) ;drink is on tray
    (at_waiter ?l-location ) ;waiter is at location
    (free_waiter ?w-waiter) ;waiter is free 
    (connected ?l1-location ?l2-location) ;locations are connected

)
(:functions 
    (distance ?l1-location ?l2-location) ;distance between locations
    (distance_covered ?w - waiter);distance covered by waiter
)

(:durative-action prepare-cold-drink
    :parameters (?b - barista ?d - cold ?l - bar)
    :duration (=? duration 3)
    :condition (and(at start(free_barista ?b))(at start(not(ready ?d))))            
    :effect (and
            (at start (not (free_barista ?b)))
            (at end (ready ?d))
            (at end (free_barista ?b))
            (at end (at_drink ?l ?d))
            )
  )
(:durative-action prepare-warm-drink
    :parameters (?b - barista ?d - warm ?l - bar)
    :duration (=? duration 5)
    :condition (and(at start(free_barista ?b))(at start(not(ready ?d))))            
    :effect (and
            (at start (not (free_barista ?b)))
            (at end (ready ?d))
            (at end (free_barista ?b))
            (at end (at_drink ?l ?d)))
            )
  

(:action pick-drink
    :parameters (?w - waiter ?d - drink  ?l - bar)
    :precondition (and (at_drink ?l ?d) (free_waiter ?w)(at_waiter ?l))
    :effect (and (carrying_drink ?w ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
)
(:process move-waiter
    :parameters (?w - waiter ?from - location ?to - location)
    :precondition (and
        (at_waiter ?from ) (connected ?from ?to)
    )
    :effect (and
        ;increase distance covered by waiter
        (increase (distance_covered ?w) 2) 
    )
)
)