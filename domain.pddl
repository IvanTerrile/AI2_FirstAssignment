

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
    (connected ?l1-location ?l2-location) ;locations are connected
    (preparing ?d-drink) ;drink is being prepared
    (moving ?w-waiter) ;waiter is moving

    (cleaning ?l - table )
    (cleaned ?l - table)

    (drink_on_tray ?d - drink ?t - tray)
    (moving_with_tray ?w - waiter ?t - tray)
    (vaffanculo ?w - waiter)
    (vaff ?w - waiter)
    (tray_at_bar ?t - tray)
)
(:functions 
    (distance ?l1-location ?l2-location) ;distance between locations
    (distance_covered ?w - waiter) ;distance covered by waiter
    (duration_drink ?d - drink);duration of preparing drink
    (cleaning_duration ?l - table)
    (table_dimension ?l - table)
    (tray_capacity ?t - tray)
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
    :effect (and (carrying_drink ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
)

(:action start-move
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)))
    :effect (and (moving ?w) (not (at_waiter ?from)) (at_waiter ?to))
)
(:process MOVE-WAITER
    :parameters (?w - waiter )
    :precondition (and
        (moving ?w)    
    )
    :effect (and
        ;increase distance covered by waiter
        (increase (distance_covered ?w) (* #t 2.0)) 
    )
)
(:event arrive-waiter
    :parameters ( ?w - waiter ?l1 - location ?l2 - location)
    :precondition (and
        (moving ?w)
        (= (distance_covered ?w)(distance ?l1 ?l2))
    )
    :effect (and
        (not (moving ?w))
        (assign (distance_covered ?w) 0.0)
        
    )
)

(:action serve-drink
    :parameters ( ?w - waiter ?d - drink ?l - table )
    :precondition (and (at_waiter ?l) (carrying_drink ?d) (not (free_waiter ?w)) (not(moving ?w)))
    :effect (and (not (carrying_drink ?d))  (free_waiter ?w) (at_drink ?l ?d))
)

(:action start-clean
    :parameters (?w - waiter ?l - table)
    :precondition (and (at_waiter ?l) (free_waiter ?w) (not(cleaned ?l)) (not(cleaning ?l)) (not(moving ?w)))
    :effect (and  (cleaning ?l))
)
(:process CLEANING
    :parameters (?l - table)
    :precondition (and
        (cleaning ?l )
    )
    :effect (and
        (decrease (table_dimension ?l) (* #t 2.0))
    )
)
(:event clean-table-done
    :parameters (?l - table)
    :precondition (and
        (cleaning ?l)
        (= (table_dimension ?l) 0.0)
    )
    :effect (and
        (assign (cleaning_duration ?l) 0.0)
        (not (cleaning ?l))
        (cleaned ?l)
    )
)


(:action load-tray
    :parameters ( ?w - waiter ?t - tray ?d - drink ?l - bar)
    :precondition (and  (at_drink ?l ?d) (at_waiter ?l) (at_tray ?l) (free_waiter ?w)
                        (not(moving ?w))(<(tray_capacity ?t) 3.0) (ready ?d))
    :effect (and (drink_on_tray ?d ?t) (not(at_drink ?l ?d)) (increase (tray_capacity ?t) 1.0))
)
(:action pick-tray
    :parameters ( ?w - waiter ?t - tray ?l - bar)
    :precondition (and  (at_tray ?l) (free_waiter ?w) (at_waiter ?l) (>(tray_capacity ?t) 1.0))
    :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
)

(:action start-move-tray
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)) (not (moving_with_tray ?w ?t)) (carrying_tray ?w ?t) (at_tray ?from)) 
    :effect (and (moving_with_tray ?w ?t) (not (at_waiter ?from)) (at_waiter ?to) (at_tray ?to) (not (at_tray ?from)))
)
(:process MOVE-WAITER-TRAY
    :parameters (?w - waiter ?t - tray)
    :precondition (and (moving_with_tray ?w ?t) (not (moving ?w)) (carrying_tray ?w ?t))    
    :effect (and
        ;increase distance covered by waiter
        (increase (distance_covered ?w) (* #t 1.0)))
)
(:event arrive-waiter-tray
    :parameters ( ?w - waiter ?l1 - location ?l2 - location ?t - tray)
    :precondition (and
        (not (moving ?w))
        (moving_with_tray ?w ?t)
        (= (distance_covered ?w)(distance ?l1 ?l2))
        (carrying_tray ?w ?t)
    )
    :effect (and
        (not (moving_with_tray ?w ?t))
        (assign (distance_covered ?w) 0.0)
        (vaff ?w)
    )
)

(:action serve-drink-tray
    :parameters ( ?w - waiter ?d - drink ?l - table ?t - tray)
    :precondition (and (at_waiter ?l) (at_tray ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) (not(moving ?w)) (not(moving_with_tray ?w ?t)) (drink_on_tray ?d ?t)(>(tray_capacity ?t) 0.0))
    :effect (and (not (drink_on_tray ?d ?t)) (at_drink ?l ?d) (decrease (tray_capacity ?t) 1.0))
)

(:action unload-tray
    :parameters ( ?w - waiter ?t - tray ?l - bar)
    :precondition (and (at_tray ?l)(at_waiter ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) (not(moving_with_tray ?w ?t)) (=(tray_capacity ?t) 0.0))
    :effect (and  (not (carrying_tray ?w ?t)) (free_waiter ?w) (at_tray ?l) (tray_at_bar ?t))
)
)