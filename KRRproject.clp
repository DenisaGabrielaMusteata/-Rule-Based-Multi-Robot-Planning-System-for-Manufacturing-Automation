;==========================
; Use structural facts
; Data base using deftemplate
; STRUCTURAL ATTRIBUTES:
; slot - it can store only one variable
; multislot - it can hold multiple variables
;==========================
; VARIABLES:
; id - unique identifier for the robot
; speed - the speed of the robot
; positionI - the initial position of the robot
; device-storage - stores the parts near the robot, which that robot can access
; robot-id - identifies which robot can acces that storage
; positionF - target coodinates where the package should be placed
; package-id - the id of the package that will be moved to that location
;===========================

(deftemplate robot
  (slot id)
  (slot x)
  (slot y)
  (slot speed)
  (slot state)
  (multislot device-storage)
)

(deftemplate goal
  (slot id)
  (slot x)
  (slot y)
  (slot package-id)
)

(deftemplate assigned
  (slot robot-id)
  (slot goal-id)
  (slot time-cost)
)

(deftemplate missing-part
  (slot package-id)
)

(deftemplate collision
  (slot robot1)
  (slot robot2)
  (slot y))

(deftemplate part-transfer
  (slot from)
  (slot to)
  (slot part)
)

(deftemplate neighbor
  (slot robot-id)
  (slot robot-neighbor)
)

(deftemplate transferred
  (slot to)
  (slot part)
)


(deftemplate redistribute
  (slot from)
  (slot to)
  (slot part)
)

;========BS initial data========
(deffacts test-database
  ; Goals
  (goal (id g1) (x 1) (y 1) (package-id A))
  (goal (id g2) (x 2) (y 1) (package-id B))  
  (goal (id g3) (x 4) (y 2) (package-id C))   
  (goal (id g4) (x 1) (y 3) (package-id D))  

  ; Robots
  (robot (id R1) (x 0) (y 0) (speed 1) (state free) (device-storage A B))
  (robot (id R2) (x 3) (y 1) (speed 1) (state free) (device-storage D))
  (robot (id R3) (x 5) (y 5) (speed 1) (state free) (device-storage))
  (robot (id R4) (x 2) (y 2) (speed 1) (state free) (device-storage C E F))

  ; Neighbors (already in code, but can repeat here if needed)
  (neighbor (robot-id R1) (robot-neighbor R2))
  (neighbor (robot-id R1) (robot-neighbor R4))
  (neighbor (robot-id R2) (robot-neighbor R1))
  (neighbor (robot-id R2) (robot-neighbor R3))
  (neighbor (robot-id R3) (robot-neighbor R2))
  (neighbor (robot-id R3) (robot-neighbor R4))
  (neighbor (robot-id R4) (robot-neighbor R1))
  (neighbor (robot-id R4) (robot-neighbor R3))
)

;====================================================
;======== Optimal Plan Rule ========
(defrule assign-optimal-goal
  (declare (salience 50))
  ?g <- (goal (id ?gid) (x ?gx) (y ?gy) (package-id ?pkg))
  ?r <- (robot (id ?rid) (x ?rx) (y ?ry) (speed ?sp) (state free) (device-storage $? ?pkg $?))
  (not (assigned (goal-id ?gid)))
  =>
  (bind ?dist (+ (abs (- ?gx ?rx)) (abs (- ?gy ?ry))))
  (bind ?time (/ ?dist ?sp))
  (printout t "ASSIGN: " ?rid " assigned to goal " ?gid " with time cost: " ?time crlf)
  (assert (assigned (robot-id ?rid) (goal-id ?gid) (time-cost ?time)))
  (modify ?r (state busy))
)

;======== Warning Message Rule ========
(defrule check-missing-part
  (declare (salience 100))
  ?g <- (goal (package-id ?pkg))
  (not (robot (device-storage $? ?pkg $?)))
  (not (missing-part (package-id ?pkg)))
  =>
  (assert (missing-part (package-id ?pkg)))
  (printout t "WARNING: Missing part " ?pkg " in all robot storages." crlf)
)

;======== Collision Avoidance Rule ========
(defrule detect-collision
  (declare (salience 10))
  (assigned (robot-id ?r1) (goal-id ?g1))
  (assigned (robot-id ?r2) (goal-id ?g2))
  (goal (id ?g1) (y ?y1) (x ?x1))
  (goal (id ?g2) (y ?y2) (x ?x2))
  (test (and (= ?y1 ?y2) (neq ?r1 ?r2) (<= (abs (- ?x1 ?x2)) 1)))
  =>
  (assert (collision (robot1 ?r1) (robot2 ?r2) (y ?y1)))
  (printout t "WARNING: Potential collision between " ?r1 " and " ?r2 " at line Y=" ?y1 crlf)
)


;======== Transfer Piece Rule ========
(defrule initiate-part-transfer
  (declare (salience 90))
  (goal (package-id ?pkg))
  ?r1 <- (robot (id ?rid1) (device-storage $?ds1&:(not (member$ ?pkg ?ds1))))
  (neighbor (robot-id ?rid1) (robot-neighbor ?rid2))
  ?r2 <- (robot (id ?rid2) (device-storage $?before ?pkg $?after))
  (not (transferred (to ?rid1) (part ?pkg))) ; prevent repeated transfers
  =>
  (modify ?r2 (device-storage ?before $?after))
  (modify ?r1 (device-storage ?ds1 ?pkg))
  (assert (transferred (to ?rid1) (part ?pkg)))
  (assert (part-transfer (from ?rid2) (to ?rid1) (part ?pkg)))
  (printout t "TRANSFER: Part " ?pkg " moved from " ?rid2 " to " ?rid1 crlf)
)


;========= Parts redistribution ========
(defrule redistribute-after-goals
  (declare (salience 0))
  (not (goal))
  ?r1 <- (robot (id ?rid1) (device-storage $?ds1))
  ?r2 <- (robot (id ?rid2) (device-storage $?ds2))
  (test (> (length$ ?ds1) (+ (length$ ?ds2) 1)))
  =>
  (bind ?part (nth$ 1 ?ds1))
  (assert (redistribute (from ?rid1) (to ?rid2) (part ?part)))
  (printout t "BALANCE: Transfer part " ?part " from " ?rid1 " to " ?rid2 crlf)
)
