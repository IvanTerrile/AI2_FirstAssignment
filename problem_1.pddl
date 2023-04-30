 
(define(problem istance)
 
    (:domain coffe-bar)
    (:objects
        r - barista
        drink1_cold - cold
        drink2_cold - cold
        
        biscuit1 - biscuit
        biscuit2 - biscuit
        
        bar_counter - bar
        table1 - table
        table2 - table
        table3 - table
        table4 - table
        
        w  - waiter
        w2 - waiter

            
        t - tray
    )
    
    (:init
        (not(ready drink1_cold))
        (not(ready drink2_cold))
        
        (not(preparing drink1_cold))
        (not(preparing drink2_cold))

        ; (servable drink1_cold)
        ; (servable drink2_cold)
        
        (not(moving w))
        (not(moving w2))
        (not(moving_with_tray w t))
        (not(moving_with_tray w2 t))
        
        (free_barista r)
        (free_waiter w)
        (free_waiter w2)
        
        (at_barista bar_counter)
        (at_waiter w bar_counter)
        (not(empty bar_counter))
        (not(empty table1))
        (empty table2)
        (empty table3)
        (empty table4)

        (order_of w table2)

        (at_waiter w2 table1)
        (at_tray bar_counter)
        
        (at_biscuit bar_counter biscuit1)
        (at_biscuit bar_counter biscuit2)
        
        (together biscuit1 drink1_cold)
        (together biscuit2 drink2_cold)
        
        (not(cleaning table3))
        (not(cleaning table4))
        (not(cleaned table3))
        (not(cleaned table4))

        (not (drinking drink1_cold))
        (not (drinking drink2_cold))

        (not(finished drink1_cold))
        (not(finished drink2_cold))

        (=(finishing_drink drink1_cold) 4.0)
        (=(finishing_drink drink2_cold) 4.0)

        
        (cleaned table1)


        (dirty table4)
        (dirty table3)
        
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
        (=(distance_covered w2)0.0)
        (=(real_distance w)0.0)
        (=(real_distance w2)0.0)
        
        (= (duration_drink drink1_cold) 3.0)
        (= (duration_drink drink2_cold) 3.0)
        
        (=(table_dimension table1) 1.0)
        (=(table_dimension table2) 1.0)
        (=(table_dimension table3) 2.0)
        (=(table_dimension table4) 1.0)
        
        (=(tray_capacity t) 0.0)
        (=(tray_capacity_biscuit t) 0.0)

        (=(counter_client table2) 2.0)
    )
    
    (:goal
        (and
            (at_drink table2 drink1_cold)
            (at_drink table2 drink2_cold)
            
            (at_biscuit table2 biscuit1)
            (at_biscuit table2 biscuit2)
            
            (cleaned table4)
            (cleaned table3)
            (cleaned table2)
        )
    )
    
    (:metric minimize(total-time))
)
 

 
