; This is the domain defined for the first assignment of the AIRO2 course;
(define (domain coffe-bar)

    (:requirements :strips :adl :fluents :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time)

    ; In PDDL types allows us to create basic to which we can apply predicates. 
    ; We use them to restrict what objects can form the parameters of an action.
    (:types
        drink tray robot - object
        cold warm - drink
        barista waiter - robot
        bar table - location
    )

    ; In PDDL predicates apply to a specific type of object, or to all objects. 
    ; They are either true or false at any point in a plan and when not declared are assumed to be false.
    (:predicates 
        (ready ?d-drink)    ;Predicate to indicate if the drink is ready.
        (preparing ?d-drink)    ;Predicate to indicate if the drink is being prepared.
        (drink_served ?d)   ;Predicate to indicate if the drink was served. 
        (carrying_drink ?d-drink) ;Predicate to indicate if the drink is being brought.
        (at_drink ?l-location ?d-drink) ;Predicate to indicate the location of the drink.

        (free_barista ?b-barista) ;Predicate to indicate if the barista if free.
        (at_barista ?l-location ) ;Predicate to indicate the location of the barista.
        
        (drink_on_tray ?d - drink ?t - tray)    ;Predicate to indicate if the drink is on the tray.
        (tray_at_bar ?t - tray) ;Predicate to indicate if the tray is at the bar.
        (at_tray ?l-location ) ;Predicate to indicate the location of the tray.
        (carrying_tray ?w-waiter ?t-tray) ;Predicate to indicate if the waiter is carring the tray.
        (moving_with_tray ?w - waiter ?t - tray)    ;Predicate to indicate if the waiter is moving with the tray.

        (at_waiter ?l-location ) ;Predicate to indicate the location of the waiter.
        (free_waiter ?w-waiter) ;Predicate to indicate if the waiter is free.
        (moving ?w-waiter) ;Predicate to indicate if waiter is moving.
        
        (connected ?l1-location ?l2-location) ;Predicate to indicate if the locations are connected.

        (cleaning ?l-table )  ;Predicate to indicate if table is being cleaned.
        (cleaned ?l-table)    ;Predicate to indicate if table has been cleaned.
        
        (cleaning_waiter ?w - waiter)   ;Predicate to indicate if waiter is cleaning.
)

    ; In PDDL functions are used to encode numeric state variables.
    (:functions 
        (duration_drink ?d - drink)     ;Function to define the durantion of the preparation of drink.

        (table_dimension ?l - table)    ;Function to define the dimension of table.
        
        (tray_capacity ?t - tray)   ;Function to define the capacity of the tray.

        (distance ?l1-location ?l2-location)    ;Function to define the distance between two locations.
        (real_distance ?w - waiter)     ;Function to define the real distance traveled by the waiter.
        (distance_covered ?w - waiter)  ;Function to define the distance covered by the waiter.
    )

    ;This action specifies the process of the barista robot preparing a drink at the bar counter
    (:action prepare-drink
        :parameters (?d - drink ?b - barista ?l - bar)
        :precondition (and (free_barista ?b) (at_barista ?l) (not (ready ?d)) (not (preparing ?d)))
        :effect (and (not (free_barista ?b)) (preparing ?d))
    )

    ;This process represents a drink that is being prepared 
    ;and is activated by the action: (:action prepare-drink)
    (:process preparing-drink
        :parameters (?d - drink)
        :precondition (and
            (preparing ?d)
        )
        :effect (and
            (decrease (duration_drink ?d) (* #t 1.0 ))
        )
    )

    ;This event signifies the completion of preparation of a particular drink by the barista robot 
    ;and is activated by a process: (:process preparing-drink).
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

    ;This action specifies the process of a waiter picking up a ready drink at the bar counter 
    ;to deliver to a specified table.
    (:action pick-drink
        :parameters (?w - waiter ?d - drink  ?l - bar)
        :precondition (and (at_drink ?l ?d) (free_waiter ?w) (at_waiter ?l) (ready ?d) (not (moving ?w)))
        :effect (and (carrying_drink ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
    )

    ;This action specifies the process of a waiter serving a drink to a customer at a table
    (:action serve-drink
        :parameters (?w - waiter ?d - drink ?l - table)
        :precondition (and (at_waiter ?l) (carrying_drink ?d) (not (free_waiter ?w)) (not (moving ?w)))
        :effect (and (not (carrying_drink ?d)) (free_waiter ?w) (at_drink ?l ?d) (drink_served ?d))
    )

    ;This action specifies the process of a waiter starting to move from one location to another
    (:action start-move
        :parameters (?w - waiter ?from - location ?to - location)
        :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w))(not(cleaning_waiter ?w)))
        :effect (and (moving ?w) (not (at_waiter ?from)) (at_waiter ?to) (assign (real_distance ?w) (distance ?from ?to)))
    )

    ;This process models the action of a waiter robot moving from one location 
    ;to another in the environment and is activated by the action: (:action start-move).
    (:process move-waiter
        :parameters (?w - waiter)
        :precondition (and
            (moving ?w)    
        )
        :effect (and
            (increase (distance_covered ?w) (* #t 2.0))
        )
    )

    ;This event represents the arrival of the waiter robot to a destination location, 
    ;such as a table or the bar counter, location and is activated by a process: (:process move-waiter).
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

    ;This action specifies the process of a waiter starting to clean a table.
    (:action start-clean
        :parameters (?w - waiter ?l - table)
        :precondition (and (at_waiter ?l) (free_waiter ?w) (not (cleaned ?l)) (not (cleaning ?l))(not(cleaning_waiter ?w)) (not (moving ?w)))
        :effect (and (cleaning ?l)(cleaning_waiter ?w))
    )

    ;This process is used to clean the tables that are dirty 
    ;and is activated by the action: (:action start-clean).
    (:process cleaning-table
        :parameters (?l - table ?w - waiter)
        :precondition (and
            (cleaning ?l)
            (cleaning_waiter ?w)
            (not (moving ?w))
        )
        :effect (and
            (decrease (table_dimension ?l) (* #t 2.0))
        )
    )

    ;This event represents the completion of the cleaning process of a table 
    ;and is activated by a process: (:process cleaning-table). 
    (:event clean-table-done
        :parameters (?l - table ?w - waiter)
        :precondition (and
            (cleaning ?l)
            (cleaning_waiter ?w)
            (= (table_dimension ?l) 0.0)
            (not (moving ?w))
        )
        :effect (and
            (not (cleaning ?l))
            (not (cleaning_waiter ?w))
            (cleaned ?l)
        )
    )

    ;This action specifies the process of a waiter starting to load a tray at the bar counter.
    (:action load-tray
        :parameters (?w - waiter ?t - tray ?d - drink ?l - bar)
        :precondition (and (at_drink ?l ?d) (at_waiter ?l) (at_tray ?l) (free_waiter ?w)
                        (not (moving ?w)) (< (tray_capacity ?t) 3.0) (ready ?d))
        :effect (and (drink_on_tray ?d ?t) (not (at_drink ?l ?d)) (increase (tray_capacity ?t) 1.0))
    )

    ;This action specifies the process of a waiter starting to pick up a tray at the bar counter
    ;and is activated by the action: (:action load-tray).
    (:action pick-tray
        :parameters (?w - waiter ?t - tray ?l - bar)
        :precondition (and (at_tray ?l) (free_waiter ?w) (at_waiter ?l) (> (tray_capacity ?t) 1.0))
        :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
    )

    ;This action specifies the process of a waiter starting to serve a drink to a customer at a table
    ;and is activated by the action: (:action pick-tray).
    (:action serve-drink-tray
        :parameters (?w - waiter ?d - drink ?l - table ?t - tray)
        :precondition (and (at_waiter ?l) (at_tray ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                        (not (moving ?w)) (not (moving_with_tray ?w ?t)) (drink_on_tray ?d ?t) (> (tray_capacity ?t) 0.0))
        :effect (and (not (drink_on_tray ?d ?t)) (at_drink ?l ?d) (decrease (tray_capacity ?t) 1.0))
    )

    ;This action represents the action of the waiter robot unloading a tray that he is carrying
    (:action unload-tray
        :parameters (?w - waiter ?t - tray ?l - bar)
        :precondition (and (at_tray ?l) (at_waiter ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                        (not (moving_with_tray ?w ?t)) (= (tray_capacity ?t) 0.0))
        :effect (and  (not (carrying_tray ?w ?t)) (free_waiter ?w) (at_tray ?l) (tray_at_bar ?t))
    )

    ;This action describes a waiter starting to move with a tray from one location to another.
    (:action start-move-tray
        :parameters (?w - waiter ?t - tray ?from - location ?to - location)
        :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)) (not (moving_with_tray ?w ?t))
                        (carrying_tray ?w ?t) (at_tray ?from)(not(cleaning_waiter ?w))) 
        :effect (and (moving_with_tray ?w ?t) (not (at_waiter ?from)) (at_waiter ?to) (at_tray ?to) (not (at_tray ?from))
                    (assign (real_distance ?w) (distance ?from ?to)))
    )

    ;This process represents the action of the waiter robot moving from one location to another 
    ;while carrying a tray and is activated by an action: (:action start-move-tray).
    (:process move-waiter-tray
        :parameters (?w - waiter ?t - tray)
        :precondition (and 
            (moving_with_tray ?w ?t) (not (moving ?w)) (carrying_tray ?w ?t)
        )    
        :effect (and
            (increase (distance_covered ?w) (* #t 1.0))
        )
    )

    ;This event models the arrival of a waiter carrying a tray to its destination location 
    ;and is activated by a process: (:process move-waiter-tray).
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