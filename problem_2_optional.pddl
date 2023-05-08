 
(define(problem istance)
 
    (:domain coffe-bar)
    (:objects
        barista - barista
        drink1_cold - cold
        drink2_cold - cold
        drink3_warm - warm
        drink4_warm - warm
        
        biscuit1 - biscuit
        biscuit2 - biscuit
        
        bar_counter - bar
        table1 - table
        table2 - table
        table3 - table
        table4 - table
        
        waiter1 - waiter
        waiter2 - waiter

            
        tray - tray
    )
    
    (:init
        
        
        (free_barista barista)
        (free_waiter waiter1)
        (free_waiter waiter2)
        
        (at_barista bar_counter)
        (at_waiter waiter1 bar_counter)
        (at_waiter waiter2 table1)
        (at_tray bar_counter)
        
        (at_biscuit bar_counter biscuit1)
        (at_biscuit bar_counter biscuit2)

        (empty table2)
        (empty table3)
        (empty table4)

        (order_of waiter1 table3)
        
        (together biscuit1 drink1_cold)
        (together biscuit2 drink2_cold)
        
        (cleaned table2)
        (cleaned table4)

        (dirty table1)

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
        
        (=(distance_covered waiter1) 0.0)
        (=(distance_covered waiter2) 0.0)
        (=(real_distance waiter1)0.0)
        (=(real_distance waiter2)0.0)
        
        (= (duration_drink drink1_cold) 3.0)
        (= (duration_drink drink2_cold) 3.0)
        (= (duration_drink drink3_warm) 5.0)
        (= (duration_drink drink4_warm) 5.0)
        
        (=(table_dimension table1) 1.0)
        (=(table_dimension table2) 1.0)
        (=(table_dimension table3) 2.0)
        (=(table_dimension table4) 1.0)
        
        (=(tray_capacity tray) 0.0)
        (=(tray_capacity_biscuit tray) 0.0)

        (=(counter_client table3) 4.0)

        (=(finishing_drink drink1_cold ) 4.0)
        (=(finishing_drink drink2_cold ) 4.0)
        (=(finishing_drink drink3_warm ) 4.0)
        (=(finishing_drink drink4_warm ) 4.0)
    )

    (:goal
        (and
            (at_drink table3 drink1_cold)
            (at_drink table3 drink2_cold)
            (at_drink table3 drink3_warm)
            (at_drink table3 drink4_warm)
            
            (at_biscuit table3 biscuit1)
            (at_biscuit table3 biscuit2)
            
            (cleaned table1)
            (cleaned table3)
        )
    )
    
    (:metric minimize(total-time))
)