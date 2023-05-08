; This is the domain defined for the first assignment of the AIRO2 course with the addition of the optional extensions.
(define (domain coffe-bar)

    (:requirements :strips :adl :fluents :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time )

    ; In PDDL types allows us to create basic to which we can apply predicates. 
    ; We use them to restrict what objects can form the parameters of an action. 
    (:types 
        drink tray robot - object
        cold warm - drink
        biscuit - food
        barista waiter - robot
        bar table - location
    )
    
    (:predicates 
        (ready ?d-drink)    ;Predicate to indicate if the drink is ready.
        (preparing ?d-drink)    ;Predicate to indicate if the drink is being prepared.
        (drink_served ?d)   ;Predicate to indicate if the drink was served.
        (drinking ?d - drink)   ;Predicate to indicate if the customer is drinking.
        (finished ?d - drink)   ;Predicate to indicate whether the customer is finished drinking.
        
        (unavailable ?d - drink)
        
        (carrying_drink ?w - waiter ?d-drink) ;Predicate to indicate if the drink is being brought.
        (order_of ?w - waiter ?l - table) ;Predicate to indicate if the waiter is taking the order.
        (at_drink ?l-location ?d-drink) ;Predicate to indicate the location of the drink.
    
        (free_barista ?b-barista)   ;Predicate to indicate if the barista if free.
        (at_barista ?l-location )   ;Predicate to indicate the location of the barista.
        
        (at_drink_tray ?d-drink ?t-tray)    ;Predicate ot indicate the location of the drink on the tray.
        (drink_on_tray ?d - drink ?t - tray)    ;Predicate to indicate if the drink is on the tray.
        (at_tray ?l-location )  ;Predicate to indicate the location of the tray.
        (carrying_tray ?w-waiter ?t-tray)   ;Predicate to indicate if the waiter is carring the tray.
        (moving_with_tray ?w - waiter ?t - tray)    ;Predicate to indicate if the waiter is moving with the tray.
    
        (at_waiter ?w - waiter ?l-location ) ;Predicate to indicate the location of the waiter.
        (free_waiter ?w-waiter) ;Predicate to indicate if the waiter is free.
        (moving ?w-waiter)  ;Predicate to indicate if waiter is moving.
        (cleaning_waiter ?w - waiter)   ;Predicate to indicate if the waiter is cleaning

        (connected ?l1-location ?l2-location) ;Predicate to indicate if the locations are connected.
    
        (cleaning ?l - table )  ;Predicate to indicate if table is being cleaned.
        (cleaned ?l - table)    ;Predicate to indicate if the table has been cleaned.
        (dirty ?l - table)  ;Predicate to indicate if the table is dirty.
    
        (at_biscuit ?l-location ?c - food) ;Predicate to indicate the location of the biscuit.
        (carrying_biscuit ?w - waiter ?c - food) ;Predicate to indicate if the biscuit is being brought.
        (biscuit_on_tray ?c - food ?t - tray)    ;Predicate to indicate if the biscuit is on the tray.
        (biscuit_served ?c - food)  ;Predicate to indicate if the biscuit was served.
        (together ?c - food ?d - cold) ;Predicate to indicate if the drink and the biscuit are together.
        (unavailable_biscuit ?c - food)     ;Predicate to indicate that biscuit is not vaiable.
        (empty ?from - location)    ;Predicate to indicate if the location is empty.
    )
    
    (:functions 
        (duration_drink ?d - drink) ;Function to define the durantion of the preparation of drink.
    
        (distance ?l1-location ?l2-location)    ;Function to define the durantion of the preparation of drink.
        (table_dimension ?l - table)    ;Function to define the dimension of table.
        (tray_capacity ?t - tray)   ;Function to define the capacity of the tray.
        
        (tray_capacity_biscuit ?t-tray) ;Function to define the capacity of the tray.
    
        (real_distance ?w - waiter); Function to define the real distance traveled by the waiter.
        (distance_covered ?w - waiter); Function to define the distance covered by the waiter.
        (finishing_drink ?d - drink); Function to define the time to finish the drink.
        (counter_client ?l - table)      ; Function to indicate the time that the customer takes to drink.
        
        
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
        :precondition (and (at_drink ?l ?d) (free_waiter ?w) (at_waiter ?w ?l) (ready ?d) (not (moving ?w)))
        :effect (and (carrying_drink ?w ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
    )

    ;This action specifies the process of a waiter serving a drink to a customer at a table
    (:action serve-drink
        :parameters (?w - waiter ?d - drink ?l - table)
        :precondition (and (at_waiter ?w ?l) (carrying_drink ?w ?d) (order_of ?w ?l) (not (free_waiter ?w)) (not (moving ?w)))
        :effect (and (not (carrying_drink ?w ?d)) (free_waiter ?w) (at_drink ?l ?d) (drink_served ?d))
    )

    ;This action specifies the process of a waiter picking up a biscuit at the bar counter 
    ;to deliver to a specified table.
    (:action pick-biscuit
        :parameters (?w - waiter ?c - food ?d - cold ?l - bar)
        :precondition (and (together ?c ?d) (drink_served ?d) (at_biscuit ?l ?c) (free_waiter ?w) (at_waiter ?w ?l) (not (moving ?w)))
        :effect (and (carrying_biscuit ?w ?c) (not (at_biscuit ?l ?c)) (not (free_waiter ?w)))
    )

    ;This action specifies the process of a waiter serving a biscuit to a customer at a table
    (:action serve-biscuit
        :parameters (?w - waiter ?l - table ?d - cold ?c - food)
        :precondition (and (together ?c ?d) (at_waiter ?w ?l) (drink_served ?d) (order_of ?w ?l) (carrying_biscuit ?w ?c) (not (free_waiter ?w)) (not (moving ?w)))
        :effect (and (not (carrying_biscuit ?w ?c)) (free_waiter ?w) (at_biscuit ?l ?c) (biscuit_served ?c))
    )

    ;This action specifies the process of a customer starting a cold drink.
    (:action start-drinking-cold
        :parameters (?d -  cold ?l - table ?c - food)
        :precondition (and (at_drink ?l ?d) (at_biscuit ?l ?c) (drink_served ?d) (biscuit_served ?c) (not (drinking ?d)) (not (finished ?d))
                        (> (counter_client ?l) 0.0) (not (unavailable_biscuit ?c)))
        :effect (and (drinking ?d) (unavailable_biscuit ?c))
    )

    ;This action specifies the process of a customer starting a warm drink.
    (:action start-drinking-warm
        :parameters (?d -  warm ?l - table)
        :precondition (and (at_drink ?l ?d) (drink_served ?d) (not (drinking ?d)) (not (finished ?d)) (> (counter_client ?l) 0.0))
        :effect (and (drinking ?d))
    )

    ;This process models the action of a client drinking a drink and is activated 
    ;by the action: (:action start-drinking-cold) or (:action start-drinking-warm), depending on the type of the drinks 
    (:process drinking
        :parameters (?d - drink)
        :precondition (and
            (drinking ?d)
        )
        :effect (and
            (decrease (finishing_drink ?d ) (* #t 1.0 ))
        )
    )

    ;This event specifies a finish-drink event, which is triggered when a person finishes drinking 
    ;a specific drink and is activated by a process: (:process drinking). 
    (:event finish-drink
        :parameters (?d - drink)
        :precondition (and
            (drinking ?d)
            (= (finishing_drink ?d) 0.0)
        )
        :effect (and
            (not (drinking ?d))
            (finished ?d)
        )
    )

    ;This action represents the process of finishing drinks
    (:action finished-drink
        :parameters (?d - drink ?l - table)
        :precondition (and (finished ?d) (at_drink ?l ?d) (not (drinking ?d)) (> (counter_client ?l) 0.0) (not (unavailable ?d)))
        :effect (and (decrease (counter_client ?l) 1.0) (unavailable ?d))
    )

    ;The action specifies that a table can be cleaned if it has no clients and has not been cleaned yet. 
    (:action can-clean
        :parameters (?l - table) 
        :precondition (and (= (counter_client ?l) 0.0) (not (cleaned ?l)))
        :effect (and (dirty ?l))
    )

    ;This action specifies the process of a waiter starting to move from one location to another
    (:action start-move
        :parameters (?w - waiter  ?from - location ?to - location)
        :precondition (and (at_waiter ?w ?from) (connected ?from ?to) (not (moving ?w)) (not (cleaning_waiter ?w)) (not(empty ?from)) (empty ?to))
        :effect (and (moving ?w) (not (at_waiter ?w ?from)) (at_waiter ?w ?to) (assign (real_distance ?w) (distance ?from ?to)) (not (empty ?to)) (empty ?from))
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
        :precondition (and (at_waiter ?w ?l) (free_waiter ?w) (not (cleaned ?l)) (not (cleaning ?l)) (not (moving ?w)) (dirty ?l))
        :effect (and (cleaning ?l) (cleaning_waiter ?w))
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

    ;This action represents the waiter robot loading a tray with a drink.
    (:action load-tray-biscuit
        :parameters (?w - waiter ?t - tray ?d - cold ?c - food ?l - bar)
        :precondition (and (together ?c ?d) (at_biscuit ?l ?c) (at_waiter ?w ?l) (at_tray ?l) (free_waiter ?w)
                        (not (moving ?w)) (= (tray_capacity ?t) 0.0) (< (tray_capacity_biscuit ?t) 3.0) (not (drink_on_tray ?d ?t)) (drink_served ?d))
        :effect (and (biscuit_on_tray ?c ?t) (not (at_biscuit ?l ?c)) (increase (tray_capacity_biscuit ?t) 1.0))
    )

    ;This action specifies a process for a waiter to load a tray with a biscuit.
    (:action load-tray-drink
        :parameters (?w - waiter ?t - tray ?d - drink  ?c - food ?l - bar)
        :precondition (and (at_drink ?l ?d) (at_waiter ?w ?l) (at_tray ?l) (free_waiter ?w)
                        (not (moving ?w)) (= (tray_capacity_biscuit ?t) 0.0) (< (tray_capacity ?t) 3.0) (not (biscuit_on_tray ?c ?t)) (ready ?d))
        :effect (and (drink_on_tray ?d ?t) (not (at_drink ?l ?d)) (increase (tray_capacity ?t) 1.0))
    )

    ;This action represents the action of the waiter robot picking up a tray of drinks from a bar. 
    (:action pick-tray-drink
        :parameters (?w - waiter ?t - tray  ?l - bar)
        :precondition (and (at_tray ?l) (free_waiter ?w) (at_waiter ?w ?l) (> (tray_capacity ?t) 1.0))
        :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
    )

    ;This action specifies that a waiter can pick up a tray that has at least 
    ;one biscuit on it, in order to serve it to a client. 
    (:action pick-tray-biscuit
        :parameters (?w - waiter ?t - tray  ?l - bar)
        :precondition (and (at_tray ?l) (free_waiter ?w) (at_waiter ?w ?l) (> (tray_capacity_biscuit ?t) 1.0))
        :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
    )

    ;This action describes the process of a waiter serving a drink from a tray to a customer’s table.
    (:action serve-drink-tray
        :parameters (?w - waiter ?d - drink  ?l - table ?t - tray)
        :precondition (and (at_waiter ?w ?l) (at_tray ?l) (carrying_tray ?w ?t) (order_of ?w ?l) (not (free_waiter ?w)) 
                        (not (moving ?w)) (not (moving_with_tray ?w ?t)) (drink_on_tray ?d ?t) (> (tray_capacity ?t) 0.0))
        :effect (and (not (drink_on_tray ?d ?t)) (at_drink ?l ?d) (drink_served ?d) (decrease (tray_capacity ?t) 1.0))
    )

    ;This action specifies the parameters and effects of serving a biscuit from a tray to a table.
    (:action serve-biscuit-tray
        :parameters (?w - waiter ?c - food ?d - cold ?l - table ?t - tray)
        :precondition (and (together ?c ?d) (drink_served ?d) (at_waiter ?w ?l) (at_tray ?l) (order_of ?w ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                        (not (moving ?w)) (not (moving_with_tray ?w ?t)) (biscuit_on_tray ?c ?t) (> (tray_capacity_biscuit ?t) 0.0))
        :effect (and (not (biscuit_on_tray ?c ?t)) (at_biscuit ?l ?c) (biscuit_served ?c) (decrease (tray_capacity_biscuit ?t) 1.0))
    )

    ;This action represents the action of the waiter robot unloading a tray that he is carrying
    (:action unload-tray
        :parameters (?w - waiter ?t - tray ?l - bar)
        :precondition (and (at_tray ?l) (at_waiter ?w ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                        (not (moving_with_tray ?w ?t)) (= (tray_capacity_biscuit ?t) 0.0) (= (tray_capacity ?t) 0.0))
        :effect (and (not (carrying_tray ?w ?t)) (free_waiter ?w) (at_tray ?l))
    )

    ;This action describes a waiter starting to move with a tray from one location to another.  
    (:action start-move-tray
        :parameters (?w - waiter ?t - tray ?from - location ?to - location)
        :precondition (and (at_waiter ?w ?from) (connected ?from ?to) (not (moving ?w)) (not (moving_with_tray ?w ?t)) (not(empty ?from)) (empty ?to)
                        (carrying_tray ?w ?t) (at_tray ?from)) 
        :effect (and (moving_with_tray ?w ?t) (not (at_waiter ?w ?from)) (at_waiter ?w ?to) (at_tray ?to) (not (at_tray ?from))
                    (assign (real_distance ?w) (distance ?from ?to)) (not (empty ?to)) (empty ?from))
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