(define(problem istance)

(:domain coffe-bar)
(:objects
    r - barista
    drink1 - warm   ; 5 seconds to be prepared
    drink2 - cold   ; 3 seconds to be prepared
    drink3 - cold   ; 3 seconds to be prepared
    l1 - bar
    l2 - table
    ;l3 - table

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
    (free_barista r)
    (at_barista l1)
    (at_waiter l1)
    (not(served drink1))
    (not(served drink2))
    (not(served drink3))

    (connected l1 l2)
    ; (connected l1 l3)
    ; (connected l3 l1)
    ; (connected l2 l1)
    (free_waiter w)
    (=(distance l1 l2) 10.0)
    ;(=(distance l1 l3) 10.0)
    ; (=(distance l2 l1) 10.0)
    ; (=(distance l3 l1) 10.0)
    (=(distance_covered w) 0.0)
    (= (duration_drink drink1) 5.0)
    (= (duration_drink drink2) 3.0)
    (= (duration_drink drink3) 3.0)
)



(:goal(and
    (ready drink1)
    (ready drink2)
    (ready drink3)
    (at_drink l2 drink1)
    (at_drink l2 drink2)
    (at_drink l2 drink3)
    ; (served drink1)
    ; (served drink2)
    )
)

(:metric minimize(total-time))

)