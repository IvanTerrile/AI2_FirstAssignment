(define(problem istance)

(:domain coffe-bar)
(:objects
r - barista
drink1_cold - cold
drink2_cold - cold
;drink3_cold - cold
bancone - bar
table1 - table
table2 - table
table3 - table
table4 - table

w - waiter
    
t - tray
)

(:init
(not(ready drink1_cold))
(not(ready drink2_cold))
; (not(ready drink3_cold))
(not(preparing drink1_cold))
(not(preparing drink2_cold))
; (not(preparing drink3_cold))
(not(moving w))
(not(moving_with_tray w t))

(not(cleaning table3))
(not(cleaning table4))
; (not(cleaning w table3))
(free_barista r)
(free_waiter w)
(at_barista bancone)
(at_waiter bancone)
(at_tray bancone)
(not(cleaned table3))
(not(cleaned table4))
(cleaned table1)
(cleaned table2)
; (not(cleaned table3))

(connected bancone table1)
(connected bancone table2)
(connected table2 bancone)
(connected table1 bancone)
(connected table1 table3)
(connected table3 table1)
(connected table2 table3)
(connected table3 table2)
(connected table2 table4)
(connected table4 table2)
(connected table1 table4)
(connected table4 table1)
(connected table3 table4)
(connected table4 table3)
(connected table1 table2)
(connected table2 table1)

(=(distance bancone table1) 10.0)
(=(distance bancone table2) 10.0)
(=(distance table1 bancone) 10.0)
(=(distance table2 bancone) 10.0)
(=(distance table1 table3) 10.0)
(=(distance table3 table1) 10.0)
(=(distance table2 table3) 10.0)
(=(distance table3 table2) 10.0)
(=(distance table2 table4) 10.0)
(=(distance table4 table2) 10.0)
(=(distance table1 table4) 10.0)
(=(distance table4 table1) 10.0)
(=(distance table3 table4) 10.0)
(=(distance table4 table3) 10.0)
(=(distance table1 table2) 10.0)
(=(distance table2 table1) 10.0)

(=(distance_covered w) 0.0)
(= (duration_drink drink1_cold) 3.0)
(= (duration_drink drink2_cold) 3.0)
;(= (duration_drink drink3_cold) 3.0)

(=(table_dimension table1)4.0)
(=(table_dimension table2)6.0)
(=(table_dimension table3)4.0)
(=(table_dimension table4)6.0)

(=(tray_capacity t) 0.0)
)
 




(:goal(and
;(ready drink1_cold)
; (ready drink2_cold)
; (ready drink3_cold)
(at_drink table2 drink1_cold)
(at_drink table2 drink2_cold)
;(at_drink table3 drink3_cold)
; (drink_on_tray drink1_cold t)
; (drink_on_tray drink2_cold t)
;(carrying_tray w t)
;(cleaning w) 
(cleaned table4)
(cleaned table3)
;(moving_with_tray w t)
 
    

))
(:metric minimize(total-time)
)
)