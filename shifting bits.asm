:start		SET 0 RC		; MAIN LOOP - start by clearing register to receive user input
		SET :loopbits RE	;	set return register after user input
		JMP :getinp		;	get input from user into RC
:loopbits	SET :shiftval RE	;	set return location to shiftval label
		JMP :printbits		;	print the bits in register RC
:shiftval	SET 255 RD		;	we are comparing to 11111111 (256)
		COM RC RD RD		;	compare RE to RD and save back to RD
		CJMP :lotsofones RD	;	jump to "lots of ones" when RE = 11111111
		SET 1 RB		;	now lets ensure that the LSB is NOT ZERO
		AND RB RC RD		;	now RD=1 when the LSB in RC=1 and RD=0 when the LSB=0
		COM RD RB RD		;	compare RD to 1 and write back to RD
		SLT RD RD		;	shift so that < becomes = and = becomes >
		CJMP :lsbzero RD	;	jump to "least significant bit zero" when <
		SRT RC RC		;	right shift RE onto itself
		JMP :loopbits		;	otherwise repeat our loop starting with printing RC
:lotsofones	SET 79 RF		; 	write "O"
		SET 78 RF		;	write "N"
		SET 69 RF		;	write "E"
		SET 83 RF		;	write "S"
		SET 10 RF		;	write ENTER
		SET 0 RF		;	clear output
		JMP :start		;	restart the process
:lsbzero	SET 76 RF		;	write "L"
		SET 83 RF		;	write "S"
		SET 66 RF		;	write "B"
		SET 61 RF		;	write "="
		SET 48 RF		;	write "0"
		SET 10 RF		;	write ENTER
		SET 0 RF		;	clear output
		JMP :start		;	restart the program
:printbits	SET 128 RA		; PRINT BITS IN REGISTER RC
:pbloop		AND RA RC RB		; is this bit set?
		COM RA RB RB		; compare the bits
		CJMP :printone RB	; if they are the same print a 1
:printzero	SET 48 RF		; print a zero
		SET 0 RF		; clear output
		JMP :bitdone		; this bit is done
:printone	SET 49 RF		; print a one
		SET 0 RF		; clear output
		JMP :bitdone		; this bit is done
:bitdone	SRT RA RA		; shift RA to the right
		SET 0 RB		; when RA is zero we are done
		COM RA RB RB		; compare RA to ZERO
		CJMP :bitsdone RB	; jump to finalizing process when done
		JMP :pbloop		; jump to looping through bits
:bitsdone	SET 10 RF		; print an ENTER
		SET 0 RF		; clear output
		SET 2 RB		; equality for AJMP
		AJMP RE RB		; return to calling process
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
		SET 2 RA		;	set jump flag for AJMP
		AJMP RE RA 		; 	jump back to calling process