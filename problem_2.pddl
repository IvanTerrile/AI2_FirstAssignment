(define(problem istance)

(:domain coffe-bar)
(:objects
r - barista
drink1_cold - cold
drink2_cold - cold
drink3_warm - warm
drink4_warm - warm


bar_counter - bar
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
(not(ready drink3_warm))
(not(ready drink4_warm))

(not(preparing drink1_cold))
(not(preparing drink2_cold))
(not(preparing drink3_warm))
(not(preparing drink4_warm))

(not(moving w))
(not(moving_with_tray w t))

(free_barista r)
(free_waiter w)

(at_barista bar_counter)
(at_waiter bar_counter)
(at_tray bar_counter)

(not(cleaning table1))
(not (cleaned table1))
(cleaned table2)
(cleaned table3)
(cleaned table4)

(connected bar_counter table1)
(connected bar_counter table2)
(connected table2 bar_counter)
(connected table1 bar_counter)
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

(=(distance bar_counter table1) 2.0)
(=(distance bar_counter table2) 2.0)
(=(distance table1 bar_counter) 2.0)
(=(distance table2 bar_counter) 2.0)
(=(distance table3 table1) 1.0)
(=(distance table2 table3) 1.0)
(=(distance table1 table3) 1.0)
(=(distance table3 table2) 1.0)
(=(distance table2 table4) 1.0)
(=(distance table4 table2) 1.0)
(=(distance table1 table4) 1.0)
(=(distance table4 table1) 1.0)
(=(distance table3 table4) 1.0)
(=(distance table4 table3) 1.0)
(=(distance table1 table2) 1.0)
(=(distance table2 table1) 1.0)

(=(distance_covered w) 0.0)

(= (duration_drink drink1_cold) 3.0)
(= (duration_drink drink2_cold) 3.0)
(= (duration_drink drink3_warm) 5.0)
(= (duration_drink drink4_warm) 5.0)

(=(table_dimension table1) 1.0)
(=(table_dimension table2) 1.0)
(=(table_dimension table3) 2.0)
(=(table_dimension table4) 1.0)

(=(tray_capacity t) 0.0)
)
 
(:goal(and
(at_drink table3 drink1_cold)
(at_drink table3 drink2_cold)
(at_drink table3 drink3_warm)
(at_drink table3 drink4_warm)
 
(cleaned table1)
))

(:metric minimize(total-time)
)
)