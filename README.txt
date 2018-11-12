Program Name: 
	-GP Arithmetic Exprs


Team/Author(s) 
Name(s): 
	- TEAM MVS
	
		- Jonathan Moubayed 
	
		- Andrew Vu


Contact info: 
	
- Jonathan's:	jonmoubayed@csu.fullerton.edu
	
- Andrew's: 	avu916@csu.fullerton.edu



Class Number:
	-CS 481-03: Artificial Intelligence

Intro:
	-This is a GP (Genetic Programming) problem. As you know, GP is a variant of the GA (Genetic Algorithm) 
family, except that 
1) it works on programs (each usually represented as a Tree) rather than on DNA gene strings (usually represented as bit strings), and 
2) to evaluate an individual's fitness we will "run" 
the program tree to get a value, the fitness value. We will be using GP to find a good approximation 
to a goal: an unknown quadratic arithmetic expression in several variables. (If you don't remember what 
such a thing is, not to worry: the GP program will tell you.)

	
To simplify things, each individual of our population is an arithmetic expression (an "expr"). 
An expr 
can be composed of its "alphabet" of operators, variable names, and constant integers. See Luger, 
	
section 12.2.2 for more information.



External Requirements:
	- none



Build Installation and Setup:
	

-  Built using GNU CLISP 2.49, ran through MAC terminal,
 Can be built using the clisp load function: (load "arithmeticExprs.lisp")
	

-  If the above doesn't work, build all of the program's function by copy and pasting our entire program into CLISP 



Usage:
	-then run the "main" function with x y z goal parameters:


ex. (main -4 -5 -3 158)




Bugs:
	-Does not contain any bugs

