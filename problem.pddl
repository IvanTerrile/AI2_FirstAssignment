(define(problem istance)

(:domain coffe-bar)
(:objects
r - barista
drink1_warm - warm
drink2_cold - cold
drink3_cold - cold
bancone - bar
table1 - table
table2 - table
table3 - table

w - waiter

    
)



(:init
(not(ready drink1_warm))
(not(ready drink2_cold))
(not(ready drink3_cold))
(not(preparing drink1_warm))
(not(preparing drink2_cold))
(not(preparing drink3_cold))
(not(moving w))
(not(cleaning w table1))
(not(cleaning w table2))
(not(cleaning w table3))
(free_barista r)
(at_barista bancone)
(at_waiter bancone)
; (not(served drink1_warm))
; (not(served drink2_cold))
; (not(served drink3_cold))
(not(cleaned table1))
(not(cleaned table2))
(not(cleaned table3))

(connected bancone table1)
(connected bancone table2)
(connected table2 bancone)
(connected table1 bancone)
(connected table1 table3)
(connected table3 table1)
(free_waiter w)
(=(distance bancone table1) 10.0)
(=(distance bancone table2) 10.0)
(=(distance table1 bancone) 10.0)
(=(distance table2 bancone) 10.0)
(=(distance table1 table3) 10.0)
(=(distance table3 table1) 10.0)

(=(distance_covered w) 0.0)
(= (duration_drink drink1_warm) 5.0)
(= (duration_drink drink2_cold) 3.0)
(= (duration_drink drink3_cold) 3.0)
(=(cleaning_duration w) 0.0)
(=(table_dimension table1)4.0)
(=(table_dimension table2)6.0)
(=(table_dimension table3)4.0)
)
 




(:goal(and
(ready drink1_warm)
(ready drink2_cold)
(ready drink3_cold)
(at_drink table2 drink1_warm)
(at_drink table1 drink2_cold)
(at_drink table3 drink3_cold)
(cleaned table1)
(cleaned table2)
(cleaned table3)

))
(:metric minimize(total-time)
)
)