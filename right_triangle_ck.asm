######################################################################################
# Programmer: Scott Schoeller (sschoellerSTEM)
#
# Description: 
# This is a MIPS32 asm program that checks for a right triangle
# given three sides and a hypotenuse (uses a^2 + b^2 = c^2)
######################################################################################

        .data
        # NOTE: will need to use floating point numbers in calculations
        
val_a:     .double 1.0  # placeholder value here for a
val_b:     .double 1.0  # placeholder value here for b
val_c:     .double 1.0  # placeholder value here for the hypotenuse
 
prompt_ab: .asciiz "\nEnter a value for the side: "
prompt_c:  .asciiz "\nEnter a value for the hypotenuse: "
yes:       .asciiz "\nYes, this is a right triangle.\n"
no:        .asciiz "\nNo, this is *not* a right triangle.\n"
hyp_err:   .asciiz "ERROR: the value of the hypotenuse is smaller than the sides!\n"

        .text
main:   # Main program code here
	
	li 	$v0, 4
	la 	$a0, prompt_ab
	syscall
	
	li      $v0, 7
	syscall
	
	s.d	$f0, val_a
	
	# prompt for second side
	li 	$v0, 4
	la 	$a0, prompt_ab
	syscall
	
	li      $v0, 7
	syscall
	
	s.d	$f0, val_b
	
	# prompt for hypotenuse
	li 	$v0, 4
	la 	$a0, prompt_c
	syscall
	
	li      $v0, 7
	syscall
	
	s.d	$f0, val_c
		
	
	# catch the cases where c < a and/or c < b
	l.d     $f2, val_a
	l.d     $f4, val_b
	l.d     $f6, val_c
	
	c.lt.d 	$f6, $f2
	bc1t catch_hyp_err
	
	c.lt.d  $f6, $f4
	bc1f    calc # calculate, readout and gracefully end	

catch_hyp_err:
	li      $v0, 4
	la      $t0, hyp_err
	move    $a0, $t0
	syscall
                
        b end

calc:
	# square each number
	mul.d 	$f8, $f2, $f2
	mul.d   $f10, $f4, $f4
	
	add.d   $f14, $f8, $f10
	
	# debugging code (below) commented out
	#mov.d   $f12, $f14
	#li	$v0, 3
	#syscall
	
	sqrt.d 	$f12, $f14
	
	# compare the contents of $f12 w/ the hypotenuse
	c.eq.d 	$f12, $f6 
	bc1f   is_not_right
	
	
is_right:
	li    	$v0, 4
	la      $a0, yes
	syscall
	
	b end

is_not_right:

	li    	$v0, 4
	la      $a0, no
	syscall

end:	
        li      $v0, 10   # return control to OS
        syscall   
