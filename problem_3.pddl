(define(problem istance)
 
    (:domain coffe-bar)
    (:objects
        r - barista
        drink1_warm - warm
        drink2_warm - warm
        drink3_warm - warm
        drink4_warm - warm
        
        bar_counter - bar
        table1 - table
        table2 - table
        table3 - table
        table4 - table
        
        w - waiter
        w2 - waiter
            
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
        (not(moving w2))
        (not(moving_with_tray w t))
        (not(moving_with_tray w2 t))
        
        (free_barista r)
        (free_waiter w)
        (free_waiter w2)
        
        (at_barista bar_counter)
        (at_waiter w bar_counter)

        (at_waiter w2 table1)
        (at_tray bar_counter)

        (not(empty bar_counter))
        (not(empty table1))
        (empty table2)
        (empty table3)
        (empty table4)

        (order_of w2 table1)
        (order_of w table4)
        
        (not(cleaning table3))
        (not (cleaned table3))
        (cleaned table2)

        (dirty table3)

        (=(finishing_drink drink1_warm) 4.0)
        (=(finishing_drink drink2_warm) 4.0)
        (=(finishing_drink drink3_warm) 4.0)
        (=(finishing_drink drink4_warm) 4.0)
        
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
        (=(distance_covered w2) 0.0)
        (=(real_distance w)0.0)
        (=(real_distance w2)0.0)
        
        (= (duration_drink drink1_warm) 5.0)
        (= (duration_drink drink2_warm) 5.0)
        (= (duration_drink drink3_warm) 5.0)
        (= (duration_drink drink4_warm) 5.0)
        
        (=(table_dimension table1) 1.0)
        (=(table_dimension table2) 1.0)
        (=(table_dimension table3) 2.0)
        (=(table_dimension table4) 1.0)
        
        (=(tray_capacity t) 0.0)
        (=(counter_client table4) 2.0)
        (=(counter_client table1) 2.0)
    )
    
    (:goal
        (and
            (at_drink table4 drink1_warm)
            (at_drink table4 drink2_warm)
            (at_drink table1 drink3_warm)
            (at_drink table1 drink4_warm)
            
            (cleaned table3)
            (cleaned table1)
            (cleaned table4)
        )
    )
    
    (:metric minimize(total-time))
)