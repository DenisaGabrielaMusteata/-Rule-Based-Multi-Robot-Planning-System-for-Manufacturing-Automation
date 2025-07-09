;; Use structural facts
;; Data base using deftemplate
;; STRUCTURAL ATTRIBUTES:
;; slot - it can store only one variable
;; multislot - it can hold multiple variables

;; VARIABLES:
;; id - unique identifier for the robot
;; speed - the speed of the robot
;; positionI - the initial position of the robot
;; device-storage - stores the parts near the robot, which that robot can access
;; robot-id - identifies which robot can acces that storage
;; positionF - target coodinates where the package should be placed
;; package-id - the id of the package that will be moved to that location
 
;; ASSERT TEMPLATES FOR EACH BS:
;; Robot deff: (assert(robot(id x)(speed y)(position(a b))(device-storage A B C D E F..))
;; Storage deff: (assert(strorage(robot-id R1//R2/R3/R4)))
;; Goal deff: (assert(goal(position(c d))(package-id A/B/C/D/E/F)))

;; RULES TEMPLATES TO USE: 
;; Robot: (robot (id ?r) (speed ?s) (position ?pI) (device-storage $? ?ds $?)) 
;; Storage: (storage(robot-id ?id))
;; Goal: (goal(positionF ?pF)(package-id ?idP))

;; Definirea șabloanelor (deftemplate) pentru roboți, depozit și obiective
;; ==============================
;; Definirea șabloanelor (deftemplate)
;; ==============================

(deftemplate robot
   (slot id)
   (slot speed)
   (multislot positionI)
   (multislot device-storage))


(deftemplate storage
  (slot robot-id))

(deftemplate goal
  (slot positionF)
  (slot package-id))

;; ==============================
;; Definirea funcțiilor (deffunction)
;; ==============================

(deffunction calculate-distance (?pos1 ?pos2)
  (return (+ (abs (- (nth$ 1 ?pos1) (nth$ 1 ?pos2)))
             (abs (- (nth$ 2 ?pos1) (nth$ 2 ?pos2))))))

;; ==============================
;; Definirea regulilor (defrule)
;; ==============================
(defrule optimal-plan
   (declare (salience 10))
   ?r1 <- (robot (id ?id1) (speed ?s1) (positionI $?pI1) (device-storage $?parts&:(member$ ?part ?parts)))
?r2 <- (robot (id ?id2) (speed ?s2) (positionI $?pI2) (device-storage $?parts&:(member$ ?part ?parts)))

   ?g <- (goal (positionF ?pF) (package-id ?part))
   =>
   (bind ?dist1 (calculate-distance ?pI1 ?pF))  ;; Distanța robotului 1
   (bind ?dist2 (calculate-distance ?pI2 ?pF))  ;; Distanța robotului 2
   (bind ?time1 (/ ?dist1 ?s1))  ;; Timpul necesar pentru robotul 1
   (bind ?time2 (/ ?dist2 ?s2))  ;; Timpul necesar pentru robotul 2
   
   (bind ?selected-id ?id1)
   (bind ?selected-time ?time1)
   (if (> ?time1 ?time2) then
      (bind ?selected-id ?id2)
      (bind ?selected-time ?time2))
   
   (assert (task (robot ?selected-id) (move-to ?pF) (part ?part) (time ?selected-time)))

   (printout t "Robot " ?selected-id " selected to move part " ?part " to " ?pF " in time " ?selected-time crlf))

;; warning message

	

;; colission avoidance

	

;; parts transfer

	

;; improvement of the program to have the robots’ storages uniformly loaded

	