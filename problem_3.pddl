(define(problem istance)

(:domain coffe-bar)
(:objects
r - barista
drink1_warm - warm
drink2_warm - warm
drink3_warm - warm
drink4_warm - warm


bar - bar
table1 - table
table2 - table
table3 - table
table4 - table

w - waiter
    
t - tray
)

(:init
(not(ready drink1_warm))
(not(ready drink2_warm))
(not(ready drink3_warm))
(not(ready drink4_warm))

(not(preparing drink1_warm))
(not(preparing drink2_warm))
(not(preparing drink3_warm))
(not(preparing drink4_warm))

(not(moving w))
(not(moving_with_tray w t))

(free_barista r)
(free_waiter w)

(at_barista bar)
(at_waiter bar)
(at_tray bar)

(not(cleaning table3))
(not (cleaned table3))
(cleaned table2)
(cleaned table1)
(cleaned table4)

(connected bar table1)
(connected bar table2)
(connected table2 bar)
(connected table1 bar)
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

(=(distance bar table1) 2.0)
(=(distance bar table2) 2.0)
(=(distance table1 bar) 2.0)
(=(distance table2 bar) 2.0)
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

(= (duration_drink drink1_warm) 5.0)
(= (duration_drink drink2_warm) 5.0)
(= (duration_drink drink3_warm) 5.0)
(= (duration_drink drink4_warm) 5.0)

(=(table_dimension table1) 1.0)
(=(table_dimension table2) 1.0)
(=(table_dimension table3) 2.0)
(=(table_dimension table4) 1.0)

(=(tray_capacity t) 0.0)
)
 
(:goal(and
(at_drink table4 drink1_warm)
(at_drink table4 drink2_warm)
(at_drink table1 drink3_warm)
(at_drink table1 drink4_warm)
 
(cleaned table3)
))

(:metric minimize(total-time)
)
)