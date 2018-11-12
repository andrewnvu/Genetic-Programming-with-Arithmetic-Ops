;; Authors: Jonathan Moubayed and Andrew Vu
;; Contacts: jonmoubayed@csu.fullerton.edu, avu916@csu.fullerton.edu
;; Brief Description: A program that demonstrates Genetic Programming with crossover, mutation, and fitness functions.

;;initializes lists and variables
(defun initialize ()
    (setq operators '(+ - *))
    (setq operands '( 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 X Y Z X Y Z))
    (setq mySet (append operators operands))
    (setq numArgs '(1 2 3 4))
    (setq myExprList '())
)


(defun subExpr()
    (setq head (list (nth(random (length operators))operators)))
    (setq numberOfArgs (nth(random (length numArgs))numArgs))
    (loop with n = 0
        while(< n numberOfArgs) do
        (setq leaves  (list (nth(random (length operands))operands)))
        (setq head (append head leaves))
        (incf n)
    )
)

(defun SubstNth ( a n l )
    (if l
        (if (zerop n)
            (cons a (cdr l))
            (cons (car l) (SubstNth a (1- n) (cdr l)))
        )
    )
)

(defun fullExpr()
   (subExpr)
   (setq myExpr head)
   (subExpr)
   (setq myExpr(SubstNth head 1 myExpr))
   (subExpr)
   (setq myExpr(SubstNth head 3 myExpr))
)

(defun run_expr (rvars rexpr goal)
    (let* ((x (car rvars))
          (y (nth 1 rvars))
          (z (nth 2 rvars))
          (fitnessList nil)
          (childrenList nil)
          (differenceList nil))
            (declare (special x))
            (declare (special y))
            (declare (special z))
            (loop for child in rexpr do
                (let ((fitness (eval child)))
                    (push (cons fitness (list child)) childrenList)
                    (push fitness fitnessList)
                )
            )
            (let ((sacrifice-list (copy-list childrenList)))
                (sort sacrifice-list 
                    #'(lambda (scored-critter-1 scored-critter-2)
                        (< (car scored-critter-1) (car scored-critter-2)))
                )
                (loop for x in sacrifice-list do
                        (push  (abs (- goal (car x))) differenceList)
                    )
                    (setq differenceList (reverse differenceList))
                    (setq bestIndex (position (reduce #'min differenceList) differenceList))
                    (setq bestParent (nth bestIndex sacrifice-list))
                    (setq sacrifice-list (remove bestParent sacrifice-list))
                    (setq bestIndex2 (position (reduce #'min differenceList) differenceList))
                    (setq bestParent2 (nth bestIndex2 sacrifice-list))
                    (setq differenceList (remove bestParent2 differenceList))      
            )
            (princ "The average fitness: ")
            (write (/ (apply #'+ fitnessList) 50))
            (terpri)
            (princ "The max fitness: ")
            (write (reduce #'max fitnessList))
            (terpri)
            (princ "The min fitness: ")
            (write (reduce #'min fitnessList))
            (terpri)
            (princ "The closest fitness: ")
            (write (car bestParent))
            (terpri)
            (princ "The best critter: ")
            (write (cdr bestParent))
            (terpri)
            (return-from run_expr bestParent)
    )
)


(defun createRandomGeneration (x)
    (initialize)
    (let ((myExprList nil))
        (loop with n = 0
            while(< n x) do
            (fullExpr)
            (push myExpr myExprList)
            (incf n)     
        )
        (return-from createRandomGeneration myExprList)
    )
)

(defun mutation (rtree)
    (cond
        ((atom rtree)
            (if rtree
                (if (< (random 100) 5)
                    (cond
                        ((numberp rtree) (random 9))
                        ((find rtree '(x y z)) (nth (random (length '(x y z))) '(x y z)))
                        (t (nth (random (length '(+ - *))) '(+ - *)))
                    )
                    rtree
                )))
        (t (let ((LX (mutation (car rtree)))
                 (RX (mutation (cdr rtree))))
              (cons LX RX)))
    )
)



(defun main (x y z goal)
    (progn
        (setq gen (createRandomGeneration 50))
        ;;(print gen)
        (loop with n = 0
            while (< n 50) do
                ;;(print gen)
                (princ "Generation: ")
                (write (+ n 1))
                (terpri)
                (incf n)
                (setq best_parent (run_expr (list x y z) gen goal))
                (setq nGen nil)
                (setq xGen (crossoverGeneration (cdr best_parent) gen))
                (loop for expr in gen do
                    (push (mutation expr) nGen)
                )
                (setq gen nGen)
        )
    )
)

(defun crossoverGeneration (best_parent generation)
    (progn
         (setq nextGen nil)
         (loop with n = 0
                while (< n 50) do

            ;;gets a random index position of 
                (setq value1 (random (length generation)))
            ;;gets the expression from that index
                (setq expr1 (nth value1 generation))
            ;;removes the expression from the current generation list
                (setq generation(remove expr1 generation))
            
            ;;same as the above lines used for 2nd expression
                ;;(setq value2 (random (length generation)))
                ;;(setq expr2 (nth value2 generation))
                ;;(setq generation(remove expr2 generation))
        
            ;;picks point index for expr1 and best_parent
                (setq point1 (random (length expr1)))
                (setq point2 (random (length best_parent)))

            ;;gets values of the choesen index of expr1/expr2
                (setq valueOfExpression1 (nth point1 expr1))
                (setq valueOfExpression2 (nth point2 best_parent))

            ;;susbstitues the values at crosspoint
                (setq expr1(SubstNth valueofExpression2 point1 expr1))
               ;;(setq expr2(SubstNth valueofExpression1 point2 expr2))

            ;;add expressions to new pool
                (push expr1 nextGen)
                ;;(push expr2 nextGen)

            
            ;;increment loop
                (setf n (+ n 1))
            )
            ;;(print nextGen)
            (return-from crossoverGeneration nextGen)
    )
)