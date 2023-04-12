(define(problem istance)

(:domain coffe-bar)
(:objects
r - barista
drink1 - cold
drink2 - warm
drink3 - cold
l1 - bar
l2 - table
w - waiter

)



(:init
(not(ready drink1))
(not(ready drink2))
(not(ready drink3))
(free_barista r)
(at_barista l1)
(not(served drink1))
(connected l1 l2)
(free_waiter w)
(=(distance l1 l2) 10)
(=(distance_covered w) 0)

)



(:goal(and
(ready drink1)
(ready drink2)
(ready drink3)
(served drink1)
))
)