:start		### 			; MAIN LOOP: ADD 2 OPERANDS FROM USER KEYBOARD INPUT
		SET 0 RC		;	clear input value
		SET :getop1 RE		;	set jump location to return after op 1 input
		JMP :getinp 		;	jump to getting op 1 into RC
:getop1		MOV RC RD		;	save off first operand to RD
		SET 0 RC		;	clear input value
		SET :getop2 RE		;	set jump location to return after op 2 input
		JMP :getinp 		;	get the second operand into RC
:getop2		SET 0 RA		;	we want to check RC against a value of ZERO
		COM RC RA RA		;	compare the value and write to RA
		CJMP :done RA		;	when that value was ZERO we are done
		ADD RC RD RC		;	add the two operands back into RC
		MOV RC RD		;	save a copy of RC into RD because print will clear RC
		SET :doneprint RE	;	set return location
		JMP :print 		; 	jump to print output location
:doneprint	MOV RD RC		;	move our saved copy of number back to RC
		JMP :getop1		;	repeat the loop
:done		SET 68 RF		; 	write "D"
		SET 79 RF		;	write "0"
		SET 78 RF		;	write "N"
		SET 69 RF		; 	write "E"
		SET 10 RF		;	write ENTER to output
		SET 0 RF		;	clear output to avoid repeating "E"
		JMP :start		;	jump back to start to repeat the process
:getinp		###  			; CHECK FOR EMPTY INPUT
		SET 0 RA		;	empty keyboard value
		COM RG RA RA		;	compare RG to RA and write to RA
		CJMP :getinp RA		;	jump when no input
		###  			; CHECK FOR  ENTER VALUE
		SET 10 RA		;	ENTER input value
		COM RG RA RA		;	compare RG to RA and write to RA
		CJMP :endinp RA		; 	ump to end input location when enter hit
		###  			; CHECK FOR ASCII BELOW "0"
		SET 48 RA		; 	set RA to min ACII value of "0"
		COM RG RA RA		; 	compare input to RA and write back to RA
		SLT RA RA		;	shift RA to left to convert "less than" to "equality"
		CJMP :badinp RA		; 	jump to clear input section only if not valid
		###  			; CHECK FOR ASCII ABOVE "9"
		SET 57 RA		; 	set RA to max ASCII value of "9"
		COM RG RA RA		; 	compare input to RA and write back to RA
		SRT RA RA		;	shift RA to right, converting "greater than" to equality
		CJMP :badinp RA		; 	jump to clear input section only if not valid
		JMP :digit1 		; 	jump to valid input section
:badinp		  			; JUMP LOCATION FOR BAD INPUT
		SET 128 RF		; 	clear input bit
		SET 0 RF		; 	clear output
		JMP :getinp 		; 	jump to start
:digit1		  			; HANDLE FIRST DIGIT
		SET 0 RA		; 	we are checking RC long storage against RA of 0
		COM RC RA RA		; 	do the check and write results back to RA
		SRT RA RA		;	shift right to convert "greater than" to equality
		CJMP :digit2 RA		; 	jump to digit 2 when RC > 0
		SET 48 RA		; 	we need to strip off ASCII start char #
		SUB RG RA RC		; 	save result to RC as first true digit
		JMP :validinput 	; 	go to valid input to write out the char and loop
:digit2		  			; HANDLE SECOND DIGIT
		SET 9 RA		; 	we are checking RC long storage against RA of 0
		COM RC RA RA		; 	do the check and write results back to RA
		SRT RA RA		;	shift RA right to convert "greater than" to equality
		CJMP :digit3 RA		; 	jump to digit 3 when RC > 9
		###  			; 	we are on digit 2 so multiply RC by 10 first
		SLT RC RC		; 	Left Shift RC -> multiplying by 2
		MOV RC RB		; 	Copy RC to RB
		SLT RC RC		; 	Left shift RC again (now its x4)
		ADD RC RB RC		; 	Add RC and RB into RC now its 6x
		SLT RB RB		; 	Left shift RB (now its x4)
		ADD RC RB RC		; 	Adding the x4 and x6 together gets x10
		SET 48 RA		; 	value to subtract from RG to make RG a digit
		SUB RG RA RA		; 	subtract that value and save to RA
		ADD RA RC RC		; 	add that back to RC so the new digit is 1s place
		JMP :validinput 	; 	jump to valid input section
:digit3		  			; HANDLE THIRD DIGIT
		###  			; 	RC contains 2 digits, multiply by 10 and add 3rd
		SLT RC RC		; 	left shift rc now rc = rc*2
		MOV RC RB		; 	Copy RC to RB
		SLT RC RC		; 	Left shift RC again (now its x4)
		ADD RC RB RC		; 	Add RC and RB into RB now they are x6
		SLT RB RB		; 	Left shift RB (now its x4)
		ADD RC RB RC		; 	add the x6 and x4 together to get x10
		SET 48 RA		; 	we need to strip off ASCII start char #
		SUB RG RA RA		; 	now RA contains the next real digit
		ADD RC RA RC		; 	add it to RC in the 1s place
		JMP :endinp 		; 	jump to end input since we have 3 digits
:validinput		  		; HANDLE VALID INPUT
		SET 128 RA		; 	set clear bit
		ADD RG RA RF		; 	add keyboard and clear input bit to output
		SET 0 RF		; 	clear output value
		JMP :getinp 		; 	jump to check
:endinp		  			; JUMP LOCATION TO END INPUT
		MOV RG RF		; 	write keyboard to output
		SET 138 RF		; 	write clear bit and enter to output
		SET 0 RF		; 	clear output
		SET 2 RA		;	set RA to TRUE for AJMP
		AJMP RE RA 		; 	jump back to calling process
:print		MOV RC RB		; PRINT CONTENTS OF RC TO OUTPUT AND RETURN TO REGISTER RE
:print_loop	SET 10 RA		; 
		COM RB RA RA		; 	compare RB to RA
		SLT RA RA		; 	shift RA to the left, converting less than to equality
		CJMP :print_done RA	; 	when less than move to done, printing remainder
		SET 0 RC		; 	we are not less than so we need division
:check100	SET 100 RA		; 
		COM RB RA RA		; 	compare RB to RA
		SLT RA RA		; 	shift RA to the left, converting less than to equality
		CJMP :print_div RA	; 	move to division by 10
:print_div100	SET 100 RA		; 	reset our divisor
		COM RB RA RA		; 	compare RB to RA
		SLT RA RA		; 	shift RA to the left, converting less than to equality
		CJMP :print_next RA	; 
		SET 100 RA		; 	reset divisor to 10 again
		SUB RB RA RB		; 	subtract 100 from RB and write back to RB
		INC RC RC		; 	increment RD into itself
		JMP :print_div100 	; 	loop back to divide
:print_div	SET 10 RA		; 	reset our divisor
		COM RB RA RA		; 	compare RB to RA
		SLT RA RA		; 	shift RA to the left, converting less than to equality
		CJMP :print_next RA	; 	jump when RB is less than RA (10)
		SET 10 RA		; 	reset divisor to 10 again
		SUB RB RA RB		; 	subtract 10 from RB and write back to RB
		INC RC RC		; 	increment RD into itself
		JMP :print_div 		; 	loop back to divide
:print_next	SET 48 RA		; 	value to add to make ASCII start
		ADD RC RA RF		; 	move quotient to output as ASCII
		SET 0 RF		; 	clear output
		JMP :print_loop 	; 	and repeat the process
:print_done	SET 48 RA		;	value to convert number to ASCII
		ADD RB RA RF		;	add that value and our number and write to output		
		SET 10 RF		; 	write enter to output
		SET 0 RF		; 	clear output
		SET 0 RC		; 	clear all registers we used
		SET 0 RB		; 	clear all registers we used
		SET 2 RA		; 	set RA to condition jump true condition
		AJMP RE RA 		; 	jump back to calling process