.data
	yearInput:		.asciiz "Enter a year (0 to exit): "
	leapYearTrue:	.asciiz " is a leap year"
	leapYearFalse:	.asciiz " is NOT a leap year"
	negYear:		.asciiz "Invalid entry-must be >=0\n\n"
	nl:				.asciiz "\n\n"
	progComp:		.asciiz "\nProgram Complete\n"
.text

main:
li $s0, 4						# check 1
li $s1, 100						# check 2
li $s2, 400						# check 3

while:
	jal askYear					# Function Asks for Year
backFromNeg:
	beqz $a1, exit				# if $a1 = 0: goto exit
	bltz $a1, ifNegYear			# if $a1 < 0: goto ifNegYear
	
	jal yearChecker				# Function Checks Year

	jal leapYearAns				# Function Outputs if Leap Year
		j while					# jump --> while
exit:
	li $v0, 4					# output: Program Complete
	la $a0, progComp
	syscall
	
	li $v0, 10					# PROGRAM EXITS
	syscall
	
#-------------------------------------------------------------------------------------------#
#---------------------------------------askYear---------------------------------------------#
askYear:
	li $v0, 4					# output: yearInput
	la $a0, yearInput
	syscall

	li $v0, 5					# ask: year
	syscall
	move $a1, $v0				# $v0 --> a1 = year
	
	jr $ra 						# jump return
#---------------------------------------yearChecker-----------------------------------------#	
yearChecker:
	div $a1, $s0				# $a1 / $s0		year / 4
	mfhi $v1					# $v1 = hi - remainder

	beqz $v1, check2			# if remainder = true: goto check2
	bnez $v1, notLeapYear		# if remainder != 0: goto notLeapYear

	check2:
		div $a1, $s1			# $a1 / $s1		year / 100
		mfhi $v1				# $v1 = hi - remainder
		bnez $v1, isLeapYear	# if $v1 != 0: goto isLeapYear
		beqz $v1, check3		# if $v1 = 0: goto check3

	check3:
		div $a1, $s2			# $a1 / $s2		year / 400
		mfhi $v1				# $v1 = hi - remainde
		beqz $v1, isLeapYear	# if $v1 = 0: goto isLeapYear
		bnez $v1, notLeapYear	# if $v1 != 0: goto notLeapYear
		
	jr $ra						# jump return
#---------------------------------------leapYearAnswers-------------------------------------#		
leapYearAns:
	isLeapYear:
		move $a0, $a1			# $a1 --> $a0
		li $v0, 1				# output: Year
		syscall
	
		li $v0, 4				# output: is a leap year
		la $a0, leapYearTrue
		syscall
		
		li $v0, 4				# output: \n
		la $a0, nl
		syscall
		
		j while					# jump --> while
	notLeapYear:
		move $a0, $a1			# $a1 --> $a0
		li $v0, 1				# output: Year
		syscall
		
		li $v0, 4				# output: is NOT a leap year
		la $a0, leapYearFalse
		syscall
		
		li $v0, 4				# output: \n
		la $a0, nl
		syscall
		j while					# jump --> while
	jr $ra						# jump return
#------------------------------------------------------------------------------------------#
#---------------------------------break: ifNegYear (ifNegYear !function)-------------------#	
ifNegYear:
	li $v0, 4					# output: yearInput
	la $a0, negYear
	syscall	
	
	jal askYear					# Function Asks for Year
	
	j backFromNeg				# jump --> backFromNeg

	
