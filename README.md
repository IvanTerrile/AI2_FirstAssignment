# AI2_FirstAssignment
This repository contains the code for the first assignment of the Artificial Intelligence 2 course at the course of Robotic Engineering at the University of Genoa.

---------------------------------------
## Installation requirements
To run the code the following packages need to be installed:

```bash
sudo apt-get install openjdk-18
```

----------------------------------
## How to run the code
After cloning the repository, in genral, you can run the code by executing the following command:

```
java -jar enhsp-20.jar -o domain_name.pddl -f problem_name.pddl --delta_execuction 0.5 -planner planner_name
```
with the following command, we can see the arguments that can be passed to the program:

```
java -jar enhsp-20.jar 
```
------------------------------------------
## Specific commands used to execute the problems
The following commands are the ones used by us to execute the problems of the assignment, but they can be changed according to the needs of the user.
#### Problem 1 (basic)
```
java -jar enhsp-20.jar -o domain_basic.pddl -f problem_1_basic.pddl --delta_execuction 0.5 -planner opt-blind
```

#### Problem 2 (basic)
```
java -jar enhsp-20.jar -o domain_basic.pddl -f problem_2_basic.pddl --delta_execuction 0.5 -planner opt-hrmax
```

#### Problem 3 (basic)
```
java -jar enhsp-20.jar -o domain_basic.pddl -f problem_3_basic.pddl --delta_execuction 0.5 -planner opt-hrmax
```

#### Problem 4 (basic)
```
java -jar enhsp-20.jar -o domain_basic.pddl -f problem_4_basic.pddl --delta_execuction 0.5 -planner sat-aibr
```

------------------------------------

#### Problem 1 (optional extension)
```
java -jar enhsp-20.jar -o domain_optional.pddl -f problem_1_optional.pddl --delta_execuction 0.5 -planner opt-hrmax
```

#### Problem 2 (optional extension)
```
java -jar enhsp-20.jar -o domain_optional.pddl -f problem_2_optional.pddl --delta_execuction 0.5 -planner sat-hadd
```

#### Problem 3 (optional extension)
```
java -jar enhsp-20.jar -o domain_optional.pddl -f problem_3_optional.pddl --delta_execuction 0.5 -planner sat-aibr
```

#### Problem 4 (optional extension)
```
java -jar enhsp-20.jar -o domain_optional.pddl -f problem_4_optional.pddl --delta_execuction 0.5 -planner sat-hadd
```
------------------------------------
## Authors

* **Alessio Mura** - [alemuraa](https://github.com/alemuraa)
* **Pisano Davide** - [DavidePisano](https://github.com/DavidePisano)
* **Miriam Anna Ruggero** - [Miryru](https://github.com/Miryru)
* **Terrile Ivan** - [Ivanterry00](https://github.com/Ivanterry00)
