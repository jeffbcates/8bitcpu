:start	###			; SIMPLE TYPING PROGRAM
	SET 0 RA		;	store empty keyboard value to compare
	COM RG RA RA		;	is keyboard input empty, back to RA
	CJMP :start RA		;	jump back when no input
	SET 128	RA		;	set clear bit
	ADD RG RA RF		;	add keyboard and clear input bit to output
	SET 0 RF		;	clear output value
	JMP :start		; 	jump to start