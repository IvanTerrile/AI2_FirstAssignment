(define(problem istance)

(:domain coffe-bar)
(:objects
bar-barista
drink1-cold
drink2-warm
drink3-cold
)



(:init
(not(ready drink1-cold))
(not(ready drink2-warm))
(not(ready drink3-cold))
(free_barista bar-barista)
)

(:goal(and
(ready drink1-cold)
(ready drink2-warm)
(ready drink3-cold)
))
)