
; This is the domain defined for the first assignment of the AIRO2 course;
(define (domain coffe-bar)

;remove requirements that are not needed
(:requirements :strips :adl :fluents :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time)

; In PDDL types allows us to create basic to which we can apply predicates. 
; We use them to restrict what objects can form the parameters of an action.
(:types
    drink tray robot - object;
    cold warm - drink;
    barista waiter - robot;
    bar table - location;
)

; In PDDL predicates apply to a specific type of object, or to all objects. 
; They are either true or false at any point in a plan and when not declared are assumed to be false.
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
    
)

; In PDDL functions are used to encode numeric state variables.
(:functions 
    (duration_drink ?d - drink) ; Function to define the durantion of the preparation of drink.

    (distance ?l1-location ?l2-location)    ; Function to define the durantion of the preparation of drink.
    (cleaning_duration ?l - table); Function to define the durantion of the cleaning table.
    (table_dimension ?l - table); Function to define the dimension of table.
    (tray_capacity ?t - tray); Function to define the capacity of the tray.
    
    (real_distance ?w - waiter); Function to define the real distance traveled by the waiter.
    (distance_covered ?w - waiter); Function to define the distance covered by the waiter.
)

; This action is activated when the barista start to prepare a new drink, it activates the process of preparation of the new drink.
; It requires the barista robot to be located at the bar counter, and not busy; as effect it tells that the robot is start preparing the 
; drink.
(:action prepare-drink
    :parameters (?d - drink ?b - barista ?l - bar)
    :precondition (and (free_barista ?b) (at_barista ?l) (not (ready ?d)) (not (preparing ?d)))
    :effect (and (not (free_barista ?b)) (preparing ?d))
)

; This process used to preparing the drink. It requires only the input of a new order and as effects it decrease only 
; the preparation time (by 1 unit at time).
(:process preparing-drink
    :parameters (?d - drink)
    :precondition (and
        (preparing ?d)
    )
    :effect (and
        (decrease (duration_drink ?d) (* #t 1.0 ))
    )
)

; This event is activated every time that the barista has finish the preparation of the drink. It requires that the decreasing preparation
; time is equal to zero. As effect it tells that the drink is at the bar counter and ready, also that the barista is free and ready 
; for a new order.
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


; This action is activated when the waiter pick the drink at the bar to be served at the client.
; It requires the waiter robot to be located at the bar counter and free, the drink ready and at the bar counter;
; As effect the waiter is occupied and start carry the drink to a new location.
(:action pick-drink
    :parameters (?w - waiter ?d - drink  ?l - bar)
    :precondition (and (at_drink ?l ?d) (free_waiter ?w) (at_waiter ?l) (ready ?d) (not (moving ?w)))
    :effect (and (carrying_drink ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
)

; This action is activated when the waiter served the drink at the client sit in a table. It requires the waiter robot to be located
; at the client table with the drink in one gripper; As effect the waiter serve the drink to the client.
(:action serve-drink
    :parameters (?w - waiter ?d - drink ?l - table)
    :precondition (and (at_waiter ?l) (carrying_drink ?d) (not (free_waiter ?w)) (not (moving ?w)))
    :effect (and (not (carrying_drink ?d)) (free_waiter ?w) (at_drink ?l ?d) (drink_served ?d))
)

; This action is activated when the waiter start moving and it activates the process of movement to a new location.
; It requires the waiter robot to be free and not just moving and the future location is connected with the attual one.
; As effect the robot start moving and the distance value is assigned in a variable called "real_distance".
(:action start-move
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)))
    :effect (and (moving ?w) (not (at_waiter ?from)) (at_waiter ?to) (assign (real_distance ?w) (distance ?from ?to)))
)

; This is the process of movement of the waiter. It requires only the input of a new movement and
; as effects it increase only the distance covered (by 2 units at time).
(:process MOVE-WAITER
    :parameters (?w - waiter)
    :precondition (and
        (moving ?w)    
    )
    :effect (and
        (increase (distance_covered ?w) (* #t 2.0))     ;increase distance covered by waiter
    )
)

; This event is activated every time that the waiter arrive at the desired location. It requires that the distance covererd is equal
; to "real_distance". As effect the waiter stop moving and the distance covered is reinitialized to 0.
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

; This action is activated when the waiter start cleaning a new table and it activates the cleaning process.
; It requires that the waiter robot must be free and it not moving or just cleaning an other table. As effect the robot start clining.
(:action start-clean
    :parameters (?w - waiter ?l - table)
    :precondition (and (at_waiter ?l) (free_waiter ?w) (not (cleaned ?l)) (not (cleaning ?l)) (not (moving ?w)))
    :effect (and (cleaning ?l))
)

; This is the process of cleaning of a table. It requires only the input of a new cleaning command and the condition of motionless of robot.
; as effects it decrease only the dimesion of the table (by 2 units at time).
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

; This event is activated every time that the waiter finished cleanign a table . It requires that the dimension of the table is equal
; to 0. As effect the waiter stop cleaning and assign "cleaning  duration" to 0. The predicate "cleaned" is TRUE.
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

; This action is activated when the waiter start loading the tray with the drink ready at the bar.
; It requires that the waiter robot must be free and it not moving, the tray is at the bar counter and with 2 or less drink on it.
; As effect the robot start loading the drink on the tray.
(:action load-tray
    :parameters (?w - waiter ?t - tray ?d - drink ?l - bar)
    :precondition (and (at_drink ?l ?d) (at_waiter ?l) (at_tray ?l) (free_waiter ?w)
                       (not (moving ?w)) (< (tray_capacity ?t) 3.0) (ready ?d))
    :effect (and (drink_on_tray ?d ?t) (not (at_drink ?l ?d)) (increase (tray_capacity ?t) 1.0))
)

; This action is activated when the waiter pick the tray at the bar counter.
; It requires the waiter robot to be located at the bar counter and free, and the capacity (nunber of drink on the tray) is greater than 1.
; As effect the waiter is occupied and start carry the tray to a new location.
(:action pick-tray
    :parameters (?w - waiter ?t - tray ?l - bar)
    :precondition (and  (at_tray ?l) (free_waiter ?w) (at_waiter ?l) (> (tray_capacity ?t) 1.0))
    :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
)

; This action is activated when the waiter served the drinks with the tray at the clients sit in tables. 
; It requires the waiter robot to be located at the client table with the tray in one gripper;
; As effect the waiter serve the drink to the client and the tray capacity decreasing (by 1 unit at time).
(:action serve-drink-tray
    :parameters (?w - waiter ?d - drink ?l - table ?t - tray)
    :precondition (and (at_waiter ?l) (at_tray ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving ?w)) (not (moving_with_tray ?w ?t)) (drink_on_tray ?d ?t) (> (tray_capacity ?t) 0.0))
    :effect (and (not (drink_on_tray ?d ?t)) (at_drink ?l ?d) (decrease (tray_capacity ?t) 1.0))
)

; This action is activated when the waiter put the tray on the bar counter after having served the drink.
; It requires the waiter robot being at the bar counter with the tray in one gripper. The capacity of the tray must be 0.
; As effect the robot stop carring the tray and put it on the bar counter, the waiter is now free for new actions.
(:action unload-tray
    :parameters (?w - waiter ?t - tray ?l - bar)
    :precondition (and (at_tray ?l) (at_waiter ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving_with_tray ?w ?t)) (= (tray_capacity ?t) 0.0))
    :effect (and  (not (carrying_tray ?w ?t)) (free_waiter ?w) (at_tray ?l) (tray_at_bar ?t))
)

; This action is activated when the waiter start moving with the tray and it activates the process of movement to a new location.
; It requires the waiter robot to be free and not just moving, the condition of carring the tray si THRE and the future location is connected with the attual one.
; As effect the robot start moving and the distance value is assigned in a variable called "real_distance".
(:action start-move-tray
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)) (not (moving_with_tray ?w ?t))
                       (carrying_tray ?w ?t) (at_tray ?from)) 
    :effect (and (moving_with_tray ?w ?t) (not (at_waiter ?from)) (at_waiter ?to) (at_tray ?to) (not (at_tray ?from))
                 (assign (real_distance ?w) (distance ?from ?to)))
)

; This is the process of movement of the waiter with the tray. It requires only the input of a new movement (with tray) and the condition
;  of carring tray TRUE. As effects it increase only the distance covered (by 1 at time).
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

; This event is activated every time the waiter arrive at a table with the tray . It requires that the distance covererd is equal
; to "real_distance" and the condition of carring tray is TRUE.  As effect the waiter stop moving and the distance covered 
; is reinitialized to 0.
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