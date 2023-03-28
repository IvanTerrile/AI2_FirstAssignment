

(define (domain coffeeshop)


    (:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time)

    ; We use types to restrict what objects can form the parameters of an action.
    ; Types and subtypes allow us to declare both general and specific actions and predicates.
    (:types
    )

    ; Predicates apply to a specific type of object, or to all objects.
    ; predicates are used to encode Boolean state variables (are either true or false at any point in a plan, and when not declared are assumed to be false)
    (:predicates 
        (drink ?d)
        (drink_at_table ?d) ;drink is at the customer table
        (drink_at_bar ?d)   ;drink is at the bar ready to service
    
        (tray_avaible ?t); tray is at the bar

        (gripper ?g)
        (carry ?d ?g)   ;robot is carring something
        (free ?g)   ; gripper is free

    )

    ; Functions are used to encode numeric state variables.
    (:functions 
        (drink_time_cold) ; Threshold for the maximum preparation time drink prepare_cold_drink
        (drink_time_warm) ; Threshold for the maximum preparation time drink prepare_cold_warm
    )


    (:action prepare_cold_drink ; sbaglaita la gestione del tempo ( probabile ultilizzo di un cilo)
        :parameters (?d)
        :precondition (and (= (drink_time_cold) 3))
        :effect (and (drink_at_bar ?d))
    )

    (:action prepare_warm_drink ; sbaglaita la gestione del tempo ( probabile ultilizzo di un cilo)
        :parameters (?d)
        :precondition (and (= (drink_time_warm) 5))
        :effect (and (drink_at_bar ?d))
    )

    (:action pick_drink       
      :parameters (?d ?g)       
      :precondition  (and (drink_at_bar ?d) (free ?g))      
      :effect (and (carry ?d ?g) (not (free ?g)) (not (drink_at_bar ?d)))
    )

    (:action pick_drink_tray    ;aggiungere la gestione dei 3 drink sul vassoio alla volta
      :parameters (?d ?g)       
      :precondition  (and (drink_at_bar ?d) (free ?g) (tray_avaible ?t))      
      :effect (and (carry ?d ?g) (not (free ?g)) (not (drink_at_bar ?d)) (not (tray_avaible ?t)))
    )
)