(define(problem istance)

(:domain coffe-bar)
(:objects
r - barista
drink1 - warm
drink2 - cold
drink3 - cold
l1 - bar
l2 - table
w - waiter

)



(:init
(not(ready drink1))
(not(ready drink2))
(not(ready drink3))
(not(preparing drink1))
(not(preparing drink2))
(not(preparing drink3))
(not(moving w))
(free_barista r)
(at_barista l1)
(at_waiter l1)
(not(served drink1))

(connected l1 l2)
(free_waiter w)
(=(distance l1 l2) 10.0)
(=(distance_covered w) 0.0)
(= (duration_drink drink1) 5.0)
(= (duration_drink drink2) 3.0)
(= (duration_drink drink3) 3.0)
 
)



(:goal(and
(ready drink1)
(ready drink2)
(ready drink3)
(at_drink l2 drink1)
; (served drink2)
; (served drink3)

))
(:metric minimize(total-time)
)
)