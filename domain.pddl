
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
    (servable ?d - drink)
    (drinking ?d - drink)   ;Predicate to indicate if the customer is drinking.
    (finished ?d - drink)   ;Predicate to indicate whether the customer is finished drinking.
    (unvaible ?d - drink)
    (unavailable ?d - drink)
    (start_cooling_down ?d - warm)
    (carrying_drink ?w - waiter ?d-drink) ;Predicate to indicate if the drink is being brought.
    (order_of ?w - waiter ?l - table)
    
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
    (empty ?from - location)
)
 
(:functions 
    (duration_drink ?d - drink) ;Function to define the durantion of the preparation of drink.
 
    (distance ?l1-location ?l2-location)    ;Function to define the durantion of the preparation of drink.
    (cleaning_duration ?l - table)  ;Function to define the durantion of the cleaning table.
    (table_dimension ?l - table)    ;Function to define the dimension of table.
    (tray_capacity ?t - tray)   ;Function to define the capacity of the tray.
    
    (tray_capacity_biscuit ?t-tray) ;Function to define the capacity of the tray.
 
    (real_distance ?w - waiter); Function to define the real distance traveled by the waiter.
    (distance_covered ?w - waiter); Function to define the distance covered by the waiter.
    (finishing_drink ?d - drink); Function to define the time to finish the drink.
    (counter_client ?l - table)      ; Function to indicate the time that the customer takes to drink.
    (counter ?d - drink)
    (duration_cool_down ?d - warm)
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

; (:action start-cool-down
;     :parameters (?d - warm ?l - bar ?w - waiter) 
;     :precondition (and  (ready ?d) (at_drink ?l ?d) (not (drink_served ?d))(not (carrying_drink ?w ?d)))
;     :effect
    
;     (and (start_cooling_down ?d) )
; )


; (:process cooling-down
;     :parameters (?d - warm)
;     :precondition (and
;         (start_cooling_down ?d)
;     )
;     :effect (and
;         (decrease (duration_cool_down ?d) (* #t 1.0))
;     )
; )
; (:event cooled-down
;     :parameters (?d - warm)
;     :precondition (and
;         (start_cooling_down ?d)
;         (= (duration_cool_down ?d) 0.0)
;     )
;     :effect (and
;         (not (start_cooling_down ?d))
;         (not(servable ?d))
;     )
; )

; This action is activated when the waiter pick the drink at the bar to be served at the client.
; It requires the waiter robot to be located at the bar counter and free, the drink ready and at the bar counter;
; As effect the waiter is occupied and start carry the drink to a new location. 
(:action pick-drink
    :parameters (?w - waiter ?d - drink  ?l - bar)
    :precondition (and (at_drink ?l ?d) (free_waiter ?w) (at_waiter ?w ?l) (ready ?d) (not (moving ?w)))
    :effect (and (carrying_drink ?w ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
)

; This action is activated when the waiter served the drink at the client sit in a table. It requires the waiter robot to be located
; at the client table with the drink in one gripper; As effect the waiter serve the drink to the client. 
(:action serve-drink
    :parameters (?w - waiter ?d - drink ?l - table)
    :precondition (and (at_waiter ?w ?l) (carrying_drink ?w ?d) (order_of ?w ?l) (not (free_waiter ?w)) (not (moving ?w)))
    :effect (and (not (carrying_drink ?w ?d)) (free_waiter ?w) (at_drink ?l ?d) (drink_served ?d))
)

; This action is activated when the waiter pick the biscuit at the bar to be served at the client.
; It requires the waiter robot to be located at the bar counter and free. The drink already served at the client;
; As effect the waiter is occupied and start carry the biscuit to a new location. 
(:action pick-biscuit
    :parameters (?w - waiter ?c - food ?d - cold ?l - bar)
    :precondition (and (together ?c ?d) (drink_served ?d) (at_biscuit ?l ?c) (free_waiter ?w) (at_waiter ?w ?l) (not (moving ?w)))
    :effect (and (carrying_biscuit ?w ?c) (not (at_biscuit ?l ?c)) (not (free_waiter ?w)))
)

; This action is activated when the waiter served the biscuit at the client sit in a table. It requires the waiter robot to be located
; at the client table with the biscuit in one gripper. The drink must be already served. As effect the waiter serve the drink to the client.  
(:action serve-biscuit
    :parameters (?w - waiter ?l - table ?d - cold ?c - food)
    :precondition (and (together ?c ?d) (at_waiter ?w ?l) (drink_served ?d) (order_of ?w ?l) (carrying_biscuit ?w ?c) (not (free_waiter ?w)) (not (moving ?w)))
    :effect (and (not (carrying_biscuit ?w ?c)) (free_waiter ?w) (at_biscuit ?l ?c) (biscuit_served ?c))
)

; This action is activated when the client start drink a cold drink. It requires that the drink is at the client table and the client not drinking it.
; The biscuit is already been served. As effect the client start drinking the drink and eat the biscuit.
(:action start-drinking-cold
    :parameters (?d -  cold ?l - table ?c - food)
    :precondition (and (at_drink ?l ?d) (at_biscuit ?l ?c) (drink_served ?d) (biscuit_served ?c) (not (drinking ?d)) (not (finished ?d))
                       (> (counter_client ?l) 0.0) (not (unavailable_biscuit ?c)))
    :effect (and (drinking ?d) (unavailable_biscuit ?c))
)

; This action is activated when the client start drink a warm drink. It requires that the drink is at the client table and the client not drinking it.
; As effect the client start drinking the drink.
(:action start-drinking-warm
    :parameters (?d -  warm ?l - table)
    :precondition (and (at_drink ?l ?d) (drink_served ?d) (not (drinking ?d)) (not (finished ?d)) (> (counter_client ?l) 0.0))
    :effect (and (drinking ?d))
)

; This is the precess of drinking. It requires only that the client is drinking.
; As effects it decrease only the function to indicate the time to finish the drink. (by 1 units at time). 
(:process drinking
    :parameters (?d - drink)
    :precondition (and
        (drinking ?d)
    )
    :effect (and
        (decrease (finishing_drink ?d ) (* #t 1.0 ))
    )
)

; This event is activated every time that the customer has finished drinking his drink. It requires that the customer is having the drink,
; and the variable finishing drink is equal to zero. As a result the customer has finished drinking the drink. 
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

(:action finished-drink
    :parameters (?d - drink ?l - table)
    :precondition (and (finished ?d) (at_drink ?l ?d) (not (drinking ?d)) (> (counter_client ?l) 0.0) (not (unavailable ?d)))
    :effect (and (decrease (counter_client ?l) 1.0) (unavailable ?d))
)

; This action is activated when there are no more customers sitting at the table. It requires that the counter client is equal to zero, and
; the table is not alreay clean. as effect we initialize the predicate dirty to TRUE.
(:action can-clean
    :parameters (?l - table) 
    :precondition (and (= (counter_client ?l) 0.0) (not (cleaned ?l)))
    :effect (and (dirty ?l))
)

; This action is activated when the waiter start moving and it activates the process of movement to a new location.
; It requires the waiter robot to be free and not just moving and the future location is connected with the attual one.
; As effect the robot start moving and the distance value is assigned in a variable called "real_distance". 
(:action start-move
    :parameters (?w - waiter  ?from - location ?to - location)
    :precondition (and (at_waiter ?w ?from) (connected ?from ?to) (not (moving ?w)) (not (cleaning_waiter ?w)) (not(empty ?from)) (empty ?to))
    :effect (and (moving ?w) (not (at_waiter ?w ?from)) (at_waiter ?w ?to) (assign (real_distance ?w) (distance ?from ?to)) (not (empty ?to)) (empty ?from))
)

; This is the process of movement of the waiter. It requires only the input of a new movement and
; as effects it increase only the distance covered (by 2 units at time). 
(:process move-waiter
    :parameters (?w - waiter)
    :precondition (and
        (moving ?w)    
    )
    :effect (and
        (increase (distance_covered ?w) (* #t 2.0)) 
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
    :precondition (and (at_waiter ?w ?l) (free_waiter ?w) (not (cleaned ?l)) (not (cleaning ?l)) (not (moving ?w)) (dirty ?l))
    :effect (and (cleaning ?l) (cleaning_waiter ?w))
)

; This is the process of cleaning of a table. It requires only the input of a new cleaning command and the condition of motionless of robot.
; as effects it decrease only the dimesion of the table (by 2 units at time). 
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

; This event is activated every time that the waiter finished cleanign a table . It requires that the dimension of the table is equal
; to 0. As effect the waiter stop cleaning and assign "cleaning  duration" to 0. The predicate "cleaned" is TRUE. 
(:event clean-table-done
    :parameters (?l - table ?w - waiter)
    :precondition (and
        (cleaning ?l)
        (cleaning_waiter ?w)
        (= (table_dimension ?l) 0.0)
        (not (moving ?w))
    )
    :effect (and
        (assign (cleaning_duration ?l) 0.0)
        (not (cleaning ?l))
        (not (cleaning_waiter ?w))
        (cleaned ?l)
    )
)

; This action is activated when the waiter start loading the tray with biscuits ready at the bar.
; It requires that the waiter robot must be free and it not moving, the tray is at the bar counter and with 3 or less biscuits on it.
; There must be no drinks on the tray.
; As effect the robot start loading the biscuit on the tray and increasing the tray capacity of biscuits (by 1 unit at time).
(:action load-tray-biscuit
    :parameters (?w - waiter ?t - tray ?d - cold ?c - food ?l - bar)
    :precondition (and (together ?c ?d) (at_biscuit ?l ?c) (at_waiter ?w ?l) (at_tray ?l) (free_waiter ?w)
                       (not (moving ?w)) (= (tray_capacity ?t) 0.0) (< (tray_capacity_biscuit ?t) 3.0) (not (drink_on_tray ?d ?t)) (drink_served ?d))
    :effect (and (biscuit_on_tray ?c ?t) (not (at_biscuit ?l ?c)) (increase (tray_capacity_biscuit ?t) 1.0))
)

; This action is activated when the waiter start loading the tray with drinks ready at the bar.
; It requires that the waiter robot must be free and it not moving, the tray is at the bar counter and with 3 or less drinks on it.
; There must be no biscuits on the tray.
; As effect the robot start loading the drink on the tray and increasing the tray capacity (by 1 unit at time).
(:action load-tray-drink
    :parameters (?w - waiter ?t - tray ?d - drink  ?c - food ?l - bar)
    :precondition (and (at_drink ?l ?d) (at_waiter ?w ?l) (at_tray ?l) (free_waiter ?w)
                       (not (moving ?w)) (= (tray_capacity_biscuit ?t) 0.0) (< (tray_capacity ?t) 3.0) (not (biscuit_on_tray ?c ?t)) (ready ?d))
    :effect (and (drink_on_tray ?d ?t) (not (at_drink ?l ?d)) (increase (tray_capacity ?t) 1.0))
)

; This action is activated when the waiter pick the tray at the bar counter for serving drinks.
; It requires the waiter robot to be located at the bar counter and free, and the capacity (nunber of drinks on the tray) is greater than 1.
; As effect the waiter is occupied and start carry the tray to a new location. 
(:action pick-tray-drink
    :parameters (?w - waiter ?t - tray  ?l - bar)
    :precondition (and (at_tray ?l) (free_waiter ?w) (at_waiter ?w ?l) (> (tray_capacity ?t) 1.0))
    :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
)

; This action is activated when the waiter pick the tray at the bar counter for serving biscuits.
; It requires the waiter robot to be located at the bar counter and free, and the capacity (nunber of biscuits on the tray) is greater than 1.
; As effect the waiter is occupied and start carry the tray to a new location. 
(:action pick-tray-biscuit
    :parameters (?w - waiter ?t - tray  ?l - bar)
    :precondition (and (at_tray ?l) (free_waiter ?w) (at_waiter ?w ?l) (> (tray_capacity_biscuit ?t) 1.0))
    :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
)

; This action is activated when the waiter served the drinks with the tray at the clients sit in tables. 
; It requires the waiter robot to be located at the client table with the tray in one gripper;
; As effect the waiter serve the drink to the client and the tray capacity decreasing (by 1 unit at time). 
(:action serve-drink-tray
    :parameters (?w - waiter ?d - drink  ?l - table ?t - tray)
    :precondition (and (at_waiter ?w ?l) (at_tray ?l) (carrying_tray ?w ?t) (order_of ?w ?l) (not (free_waiter ?w)) 
                       (not (moving ?w)) (not (moving_with_tray ?w ?t)) (drink_on_tray ?d ?t) (> (tray_capacity ?t) 0.0))
    :effect (and (not (drink_on_tray ?d ?t)) (at_drink ?l ?d) (drink_served ?d) (decrease (tray_capacity ?t) 1.0))
)

; This action is activated when the waiter served the biscuits with the tray at the clients sit in tables. 
; It requires the waiter robot to be located at the client table with the tray in one gripper. Before serving the drink there must be
; a cold drink already served; As effect the waiter serve the BISCUIT to the client and the tray capacity decreasing (by 1 unit at time).  
(:action serve-biscuit-tray
    :parameters (?w - waiter ?c - food ?d - cold ?l - table ?t - tray)
    :precondition (and (together ?c ?d) (drink_served ?d) (at_waiter ?w ?l) (at_tray ?l) (order_of ?w ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving ?w)) (not (moving_with_tray ?w ?t)) (biscuit_on_tray ?c ?t) (> (tray_capacity_biscuit ?t) 0.0))
    :effect (and (not (biscuit_on_tray ?c ?t)) (at_biscuit ?l ?c) (biscuit_served ?c) (decrease (tray_capacity_biscuit ?t) 1.0))
)

; This action is activated when the waiter put the tray on the bar counter after having served the drink.
; It requires the waiter robot being at the bar counter with the tray in one gripper. The capacity of the tray must be 0.
; As effect the robot stop carring the tray and put it on the bar counter, the waiter is now free for new actions. 
(:action unload-tray
    :parameters (?w - waiter ?t - tray ?l - bar)
    :precondition (and (at_tray ?l) (at_waiter ?w ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving_with_tray ?w ?t)) (= (tray_capacity_biscuit ?t) 0.0) (= (tray_capacity ?t) 0.0))
    :effect (and (not (carrying_tray ?w ?t)) (free_waiter ?w) (at_tray ?l))
)

; This action is activated when the waiter start moving with the tray and it activates the process of movement to a new location.
; It requires the waiter robot to be free and not just moving, the condition of carring the tray si THRE and the future location is 
; connected with the attual one. As effect the robot start moving and the distance value is assigned in a variable called "real_distance". 
(:action start-move-tray
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?w ?from) (connected ?from ?to) (not (moving ?w)) (not (moving_with_tray ?w ?t)) (not(empty ?from)) (empty ?to)
                       (carrying_tray ?w ?t) (at_tray ?from)) 
    :effect (and (moving_with_tray ?w ?t) (not (at_waiter ?w ?from)) (at_waiter ?w ?to) (at_tray ?to) (not (at_tray ?from))
                 (assign (real_distance ?w) (distance ?from ?to)) (not (empty ?to)) (empty ?from))
)

; This is the process of movement of the waiter with the tray. It requires only the input of a new movement (with tray) and the condition
; of carring tray TRUE. As effects it increase only the distance covered (by 1 at time). 
(:process move-waiter-tray
    :parameters (?w - waiter ?t - tray)
    :precondition (and 
        (moving_with_tray ?w ?t) (not (moving ?w)) (carrying_tray ?w ?t)
    )    
    :effect (and
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