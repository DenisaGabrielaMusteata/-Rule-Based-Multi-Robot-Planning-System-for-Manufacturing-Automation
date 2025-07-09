# A-Rule-Based-Multi-Robot-Planning-System-for-Manufacturing-Automation

This project was developed as part of the **Bachelor’s Degree project** at the **Technical University “Gheorghe Asachi” of Iași**, Faculty of Automatic Control and Computer Engineering.  
It implements a **rule-based expert system** for coordinating multiple autonomous robots in a manufacturing scenario, focusing on task allocation, resource balancing, and collision avoidance.

## Project Overview

Using the **CLIPS** expert system environment, the project models a team of four robots tasked with placing specific parts (A–F) on an 8-position grid.  
The system automates:
- Optimal assignment of robots to manufacturing goals
- Dynamic part transfers between neighboring robots
- Collision detection and avoidance
- Inventory rebalancing after task completion

The design demonstrates symbolic AI and multi-agent coordination in a distributed industrial environment.

## Motivation

Manufacturing automation increasingly relies on multi-robot systems.  
This project explores how **declarative knowledge representation** and **rule-based reasoning** can coordinate such systems:
- Improve efficiency through intelligent task planning
- Dynamically adapt to missing resources or conflicts
- Maintain balanced inventories across robots

## Technologies Used

- **CLIPS** – rule engine and expert system programming
- Declarative knowledge representation (`deftemplate`)
- Forward chaining inference
- Modular rule design for task assignment, resource transfer, and conflict detection

##  System Features

- **Structured facts** to represent robots, parts, goals, neighbors, and states
- **Optimal robot-to-goal assignment** based on Manhattan distance and robot speed
- **Part transfers** to resolve shortages when a robot lacks required parts
- **Collision detection** to prevent simultaneous movement into adjacent cells
- **Post-goal redistribution** to balance inventory among robots

##  Testing & Validation

The system was tested through:
- **Unit tests** for each rule (assignment, transfer, collision)
- **Scenario-based testing** with multiple robots and dynamic goals
- **Edge case handling** (missing parts, repeated transfers, uneven inventories)
- Real-time fact monitoring (`(facts)`) and rule tracing (`(watch rules)`)

##  Possible Enhancements

- Support for **priority-based goals**
- **Energy constraints** and recharging logic
- **Dynamic goal injection** during runtime
- Visualization of robot movement and part transfers

##  Results Summary

The system successfully:
- Automates robot assignment based on efficiency
- Detects and prevents potential collisions
- Performs dynamic resource redistribution
- Maintains balanced inventories for future tasks

It serves as a modular prototype demonstrating how rule-based systems can manage real-world constraints in multi-agent coordination.

##  Author

**Denisa Gabriela Musteață**  
`denisa-gabriela.musteata@student.tuiasi.ro`  
Technical University “Gheorghe Asachi” of Iași  
Department of Automatics and Applied Informatics

--- 
> It demonstrates the potential of expert systems for intelligent task planning and coordination in manufacturing automation.
> 
> *For educational and non-commercial use only.*
