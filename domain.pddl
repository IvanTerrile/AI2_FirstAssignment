
(define (domain coffe-bar)

;remove requirements that are not needed
(:requirements :strips :adl :fluents :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    drink tray robot - object;
    cold warm - drink;
    barista waiter - robot;
    bar table - location;
)

(:predicates 
    (ready ?d-drink)    ;Predicate to indicate if the drink is ready.
    (preparing ?d-drink) ;Predicate to indicate if the drink is being prepared.
    (drink_served ?d)   ;Predicate to indicate if the drink was served.
    (carrying_drink ?d-drink) ;Predicate to indicate if the drink is being brought.
    (at_drink ?l-location ?d-drink) ;Predicate to indicate the location of the drink.

    (free_barista ?b-barista) ;Predicate to indicate if the barista if free.
    (at_barista ?l-location ) ;Predicate to indicate the location of the barista.
    
    (at_drink_tray ?d-drink ?t-tray) ;Predicate ot indicate the location of the drink on the tray.
    (drink_on_tray ?d - drink ?t - tray)    ;Predicate to indicate if the drink is on the tray.
    (tray_at_bar ?t - tray) ;Predicate to indicate if the tray is at the bar.
    (at_tray ?l-location ) ;Predicate to indicate the location of the tray.
    (carrying_tray ?w-waiter ?t-tray) ;Predicate to indicate if the waiter is carring the tray.
    (moving_with_tray ?w - waiter ?t - tray)    ;Predicate to indicate if the waiter is moving with the tray.

    (at_waiter ?l-location ) ;Predicate to indicate the location of the waiter.
    (free_waiter ?w-waiter) ;Predicate to indicate if the waiter is free.
    (moving ?w-waiter) ;Predicate to indicate if waiter is moving.
    
    (connected ?l1-location ?l2-location) ;Predicate to indicate if the locations are connected.

    (cleaning ?l - table )  ;Predicate to indicate if table is being cleaned.
    (cleaned ?l - table)    ;Predicate to indicate if the table has been cleaned.
    
    ; (at_biscuit ?l-location ?c-biscuit) ;biscuit is at location
    ; (carrying_biscuit ?c-biscuit)  ;waiter is carring
)

(:functions 
    (duration_drink ?d - drink) ; Function to define the durantion of the preparation of drink.

    (distance ?l1-location ?l2-location)    ; Function to define the durantion of the preparation of drink.
    (cleaning_duration ?l - table); Function to define the durantion of the cleaning table.
    (table_dimension ?l - table); Function to define the dimension of table.
    (tray_capacity ?t - tray); Function to define the capacity of the tray.
    
    (real_distance ?w - waiter); Function to define the real distance traveled by the waiter.
    (distance_covered ?w - waiter); Function to define the distance covered by the waiter.
)

(:action prepare-drink
    :parameters (?d - drink ?b - barista ?l - bar)
    :precondition (and (free_barista ?b) (at_barista ?l) (not (ready ?d)) (not (preparing ?d)))
    :effect (and (not (free_barista ?b)) (preparing ?d))
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
    :precondition (and (at_drink ?l ?d) (free_waiter ?w) (at_waiter ?l) (ready ?d) (not (moving ?w)))
    :effect (and (carrying_drink ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
)

(:action serve-drink
    :parameters (?w - waiter ?d - drink ?l - table)
    :precondition (and (at_waiter ?l) (carrying_drink ?d) (not (free_waiter ?w)) (not (moving ?w)))
    :effect (and (not (carrying_drink ?d)) (free_waiter ?w) (at_drink ?l ?d) (drink_served ?d))
)

; (:action pick-biscuit
;     :parameters (?w - waiter ?c - biscuit  ?l - bar)
;     :precondition (and (at_biscuit ?l ?c) (free_waiter ?w) (at_waiter ?l) (not (moving ?w)))
;     :effect (and (carrying_biscuit ?c) (not (at_biscuit ?l ?c)) (not (free_waiter ?w)))
; )

; (:action serve-biscuit
;     :parameters ( ?w - waiter ?d - drink ?l - table ?c - biscuit)
;     :precondition (and (at_waiter ?l) (carrying_drink ?d) (not (free_waiter ?w)) (not (moving ?w)) (drink_served ?d))
;     :effect (and (not (carrying_biscuit ?c)) (free_waiter ?w) (at_biscuit ?l ?c))
; )

(:action start-move
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)))
    :effect (and (moving ?w) (not (at_waiter ?from)) (at_waiter ?to) (assign (real_distance ?w) (distance ?from ?to)))
)

(:process MOVE-WAITER
    :parameters (?w - waiter)
    :precondition (and
        (moving ?w)    
    )
    :effect (and
        ;increase distance covered by waiter
        (increase (distance_covered ?w) (* #t 2.0)) 
    )
)

(:event arrive-waiter
    :parameters (?w - waiter)
    :precondition (and
        (moving ?w)
        (= (distance_covered ?w) (real_distance ?w))
    )
    :effect (and
        (not (moving ?w))
        (assign (distance_covered ?w) 0.0)
    )
)

(:action start-clean
    :parameters (?w - waiter ?l - table)
    :precondition (and (at_waiter ?l) (free_waiter ?w) (not (cleaned ?l)) (not (cleaning ?l)) (not (moving ?w)))
    :effect (and (cleaning ?l))
)

(:process CLEANING
    :parameters (?l - table ?w - waiter)
    :precondition (and
        (cleaning ?l)
        (not (moving ?w))
    )
    :effect (and
        (decrease (table_dimension ?l) (* #t 2.0))
    )
)

(:event clean-table-done
    :parameters (?l - table ?w - waiter)
    :precondition (and
        (cleaning ?l)
        (= (table_dimension ?l) 0.0)
        (not (moving ?w))
    )
    :effect (and
        (assign (cleaning_duration ?l) 0.0)
        (not (cleaning ?l))
        (cleaned ?l)
    )
)

(:action load-tray
    :parameters (?w - waiter ?t - tray ?d - drink ?l - bar)
    :precondition (and (at_drink ?l ?d) (at_waiter ?l) (at_tray ?l) (free_waiter ?w)
                       (not (moving ?w)) (< (tray_capacity ?t) 3.0) (ready ?d))
    :effect (and (drink_on_tray ?d ?t) (not (at_drink ?l ?d)) (increase (tray_capacity ?t) 1.0))
)

(:action pick-tray
    :parameters (?w - waiter ?t - tray ?l - bar)
    :precondition (and  (at_tray ?l) (free_waiter ?w) (at_waiter ?l) (> (tray_capacity ?t) 1.0))
    :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
)

(:action serve-drink-tray
    :parameters (?w - waiter ?d - drink ?l - table ?t - tray)
    :precondition (and (at_waiter ?l) (at_tray ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving ?w)) (not (moving_with_tray ?w ?t)) (drink_on_tray ?d ?t) (> (tray_capacity ?t) 0.0))
    :effect (and (not (drink_on_tray ?d ?t)) (at_drink ?l ?d) (decrease (tray_capacity ?t) 1.0))
)

(:action unload-tray
    :parameters (?w - waiter ?t - tray ?l - bar)
    :precondition (and (at_tray ?l) (at_waiter ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving_with_tray ?w ?t)) (= (tray_capacity ?t) 0.0))
    :effect (and  (not (carrying_tray ?w ?t)) (free_waiter ?w) (at_tray ?l) (tray_at_bar ?t))
)

(:action start-move-tray
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)) (not (moving_with_tray ?w ?t))
                       (carrying_tray ?w ?t) (at_tray ?from)) 
    :effect (and (moving_with_tray ?w ?t) (not (at_waiter ?from)) (at_waiter ?to) (at_tray ?to) (not (at_tray ?from))
                 (assign (real_distance ?w) (distance ?from ?to)))
)

(:process MOVE-WAITER-TRAY
    :parameters (?w - waiter ?t - tray)
    :precondition (and 
        (moving_with_tray ?w ?t) (not (moving ?w)) (carrying_tray ?w ?t)
    )    
    :effect (and
        ;increase distance covered by waiter
        (increase (distance_covered ?w) (* #t 1.0))
    )
)

(:event arrive-waiter-tray
    :parameters (?w - waiter ?t - tray)
    :precondition (and
        (not (moving ?w))
        (moving_with_tray ?w ?t)
        (= (distance_covered ?w) (real_distance ?w))
        (carrying_tray ?w ?t)
    )
    :effect (and
        (not (moving_with_tray ?w ?t))
        (assign (distance_covered ?w) 0.0)
    )
)
)