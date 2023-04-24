(define(problem istance)
 
(:domain coffe-bar)
(:objects
r - barista
drink1_warm - warm
drink2_warm - warm
drink3_warm - warm
drink4_warm - warm
drink5_cold - cold
drink6_cold - cold
drink7_cold - cold
drink8_cold - cold
 
biscuit1 - biscuit
biscuit2 - biscuit
biscuit3 - biscuit
biscuit4 - biscuit
 
bar_counter - bar
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
(not(ready drink5_cold))
(not(ready drink6_cold))
(not(ready drink7_cold))
(not(ready drink8_cold))
 
(not(preparing drink1_warm))
(not(preparing drink2_warm))
(not(preparing drink3_warm))
(not(preparing drink4_warm))
(not(preparing drink5_cold))
(not(preparing drink6_cold))
(not(preparing drink7_cold))
(not(preparing drink8_cold))
 
(not(moving w))
(not(moving_with_tray w t))
 
(free_barista r)
(free_waiter w)
 
(at_barista bar_counter)
(at_waiter bar_counter)
(at_tray bar_counter)
 
(at_biscuit bar_counter biscuit1)
(at_biscuit bar_counter biscuit2)
(at_biscuit bar_counter biscuit3)
(at_biscuit bar_counter biscuit4)
 
(together biscuit1 drink5_cold)
(together biscuit2 drink6_cold)
(together biscuit3 drink7_cold)
(together biscuit4 drink8_cold)
 
(not (cleaning table2))
(not (cleaned table2))

(dirty table2)

(=(finishing_drink drink1_warm) 4.0)
(=(finishing_drink drink2_warm) 4.0)
(=(finishing_drink drink3_warm) 4.0)
(=(finishing_drink drink4_warm) 4.0)
(=(finishing_drink drink5_cold) 4.0)
(=(finishing_drink drink6_cold) 4.0)
(=(finishing_drink drink7_cold) 4.0)
(=(finishing_drink drink8_cold) 4.0)


 
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
(=(real_distance w)0.0)
 
(= (duration_drink drink1_warm) 5.0)
(= (duration_drink drink2_warm) 5.0)
(= (duration_drink drink3_warm) 5.0)
(= (duration_drink drink4_warm) 5.0)
(= (duration_drink drink5_cold) 3.0)
(= (duration_drink drink6_cold) 3.0)
(= (duration_drink drink7_cold) 3.0)
(= (duration_drink drink8_cold) 3.0)
 
(=(table_dimension table1) 1.0)
(=(table_dimension table2) 1.0)
(=(table_dimension table3) 2.0)
(=(table_dimension table4) 1.0)
 
(=(tray_capacity t) 0.0)
(=(tray_capacity_biscuit t) 0.0)
(=(counter_client table3) 4.0)
(=(counter_client table4) 2.0)
(=(counter_client table1) 2.0)
 
)
 
(:goal(and
(at_drink table3 drink1_warm)
(at_drink table3 drink2_warm)
(at_drink table3 drink3_warm)
(at_drink table3 drink4_warm)
 
(at_drink table4 drink5_cold)
(at_drink table4 drink6_cold)
(at_drink table1 drink7_cold)
(at_drink table1 drink8_cold)
 
(at_biscuit table4 biscuit1)
(at_biscuit table4 biscuit2)
(at_biscuit table1 biscuit3)
(at_biscuit table1 biscuit4)
 
;(cleaned table4)
(cleaned table2)
(cleaned table1)
(cleaned table3)
(cleaned table4)
))
 
(:metric minimize(total-time)
)
)
 
 

 
