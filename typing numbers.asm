:start		SET 0 RE		; READS ONLY DIGITS, USES RA, RB, Static RE
		SET 0 RA		; CHECK FOR EMPTY INPUT
		COM RG RA RA		;	compare RG to RA and write to RA
		CJMP :start RA		;	jump when no input
		SET 10 RA		; CHECK FOR  ENTER VALUE
		COM RG RA RA		;	compare RG to RA and write to RA
		CJMP :endinput RA	;	jump to end input location when enter hit
		SET 48 RA		; CHECK FOR ASCII BELOW "0"
		SET 1 RB		;	set RB to "1" meaning less than
		COM RG RA RA		;	compare input to RA and write back to RA
		COM RA RB RA		;	was our comparison equal to "less than"?
		CJMP :badinput RA	;	jump to clear input section only if not valid
		SET 57 RA		; CHECK FOR ASCII ABOVE "9"
		SET 4 RB		;	set RB to "4" meaning greater than
		COM RG RA RA		;	compare input to RA and write back to RA
		COM RA RB RA		;	was our comparison equal to "greater than"?
		CJMP :badinput RA	;	jump to clear input section only if not valid
		SET 128 RA		; HANDLE VALID INPUT
		ADD RG RA RF		;	add keyboard and clear input bit to output
		SET 0 RF		;	clear output value
		JMP :start		;	jump to start
:badinput	SET 128 RF		; JUMP LOCATION FOR BAD INPUT
		SET 0 RF		;	clear output
		SET 0 RH		;	jump to start
:endinput	SET 138 RF		; JUMP LOCATION TO END INPUT
		SET 68 RF		;	write "D"
		SET 79 RF		;	write "O"
		SET 78 RF		;	write "N"
		SET 69 RF		;	write "E"
		SET 138 RF		;	clear input bit plus ENTER
		SET 0 RF		;	clear output
		SET 1 RB		;	set return location
		JMP :wait      		;	jump to wait for a "1"
:wait		SET 0 RA		; JUMP LOCATION TO END INPUT
		COM RG RA RA		;	compare RG to RA and write to RA
		CJMP :wait RA		;	jump when no input
		JMP :endwait 		;	end waiting when a keyboard input is received
:endwait	SET 138 RF		;	clear input bit plus ENTER
		SET 68 RF		;	write "D"
		SET 79 RF		;	write "O"
		SET 78 RF		;	write "N"
		SET 69 RF		;	write "E"
		SET 138 RF		;	clear input bit plus ENTER
		SET 0 RF		;	clear output 
		JMP :start 		;	restart the whole process