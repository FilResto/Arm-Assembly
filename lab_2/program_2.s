.data
i:     .double 1.2,2.3,3.4,4.5,5.6,6.7,7.8,8.9,9.0,0.1
	   .double 1.2,2.3,3.4,4.5,5.6,6.7,7.8,8.9,9.0,0.1
	   .double 1.2,2.3,3.4,4.5,5.6,6.7,7.8,8.9,9.0,0.1
	   
w:     .double 1.2,2.3,3.4,4.5,5.6,6.7,7.8,8.9,9.0,0.1
	   .double 1.2,2.3,3.4,4.5,5.6,6.7,7.8,8.9,9.0,0.1
	   .double 1.2,2.3,3.4,4.5,5.6,6.7,7.8,8.9,9.0,0.1
	   
b:     .double 0xab ; 0xab
y:     .space 8    ;
zero:  .double 0.0 ; serve nel caso del match dell esponente


.text
MAIN:
	daddi R1,R0,30 ;counter for K=30
	dadd R2,R0,R0 ; index 0
	
	l.d F8, b(R0)

LOOP:
	l.d F0, i(R2)
	l.d F1, w(R2)
	
	mul.d F2, F0, F1
	add.d F8, F8, F2 ; accumulator, ci ho messo il bias subito nel main
	
	daddi R2, R2, 8 ; move to the next element in the vector
	daddi R1, R1, -1
	bnez R1, LOOP ; if R1 is not zero continue the loop
	
	; Store the floating-point number from F8 into a location, che è y.
	s.d F8, y(R0)

	; Load the raw bits of the floating-point number from memory into integer registers.
	#lw R3, y(R0)       ; Load the lower 32 bits, so after the dot
	ld R4, y(R0)
	#lw R4, y+4(R0)     ; Load the upper 32 bits, so the integer part
	;estrazione della parte dell esp di F8
	dsll R4, R4,1 ; shift left per eliminare il bit segno nel caso ci fosse
	dsrl R4, R4,31 ; shift right di 53 siccome ho shiftato di 1 a sx prima
	dsrl R4, R4,22
	#dsrl R4, R4, 20 ; shift right di 20 perche sto caricando solo i 32 bit della
					; parte alta cioè 1 segno 11 exp e 20 fraction, shifto di 20 per togliere la fraction
	

	; comparing exp with 0x7FF
	daddi R6, R0, 2047	;0x7FF
    beq R4, R6, EXPONENT_MATCH  ; entro se exp è 0x7ff

    ; se no match allora y=f(x) = x
    s.d F8, y(R0) 
    j END

EXPONENT_MATCH:
    ; se exp matcha, y = f(x) = 0
    l.d F8, zero(R0)
    s.d F8, y(R0)  ; Store F0 into memory location y

END:
    HALT
	
HALT
