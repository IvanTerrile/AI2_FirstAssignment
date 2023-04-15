(define(problem istance)

(:domain coffe-bar)
(:objects
r - barista
drink1 - warm
drink2 - cold
drink3 - cold
l1 - bar
l2 - table
l3 - table
l4 - table

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
(not(cleaning w))
(free_barista r)
(at_barista l1)
(at_waiter l1)
(not(served drink1))
(not(served drink2))
(not(served drink3))
(not(cleaned l2))
(not(cleaned l3))

(connected l1 l2)
(connected l1 l3)
(connected l3 l1)
 (connected l2 l1)
(connected l2 l4)
(connected l4 l2)
(free_waiter w)
(=(distance l1 l2) 10.0)
(=(distance l1 l3) 10.0)
(=(distance l2 l1) 10.0)
(=(distance l3 l1) 10.0)
(=(distance l2 l4) 10.0)
(=(distance l4 l2) 10.0)

(=(distance_covered w) 0.0)
(= (duration_drink drink1) 5.0)
(= (duration_drink drink2) 3.0)
(= (duration_drink drink3) 3.0)
(=(cleaning_duration w) 0.0)
(=(table_dimension l2)4.0)
(=(table_dimension l3)6.0)
(=(table_dimension l4)4.0)
)
 




(:goal(and
(ready drink1)
(ready drink2)
(ready drink3)
(at_drink l3 drink1)
(at_drink l2 drink2)
(at_drink l4 drink3)
(cleaned l2)
(cleaned l3)

))
(:metric minimize(total-time)
)
)