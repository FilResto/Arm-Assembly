.data
m: 	.word 1
k: 	.double 0
p: 	.double 0
zero: .double 0.0
v1: .double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
		
v2: .double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0	
	
v3: .double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	
v4: .double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
	.double 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0	

v5: .space 512
v6: .space 512
v7: .space 512
	
.text
	dadd R2,R0,R0 ; per accedere a v[i] 								5
	daddi R8,R0,64													   ;1    9
	dadd R9,R0,R0 ;temp reg											   ;1
	daddi R10,R10,0#sarebbe i										   ;1	
	l.d F20, zero(R0)												   ;1
	
LOOP:
	beq R10, R8, END_LOOP  																	;FDEMW	2     8
	ld R1, m(R0)																			; FDEMW	1
	andi R4,R10, 1 ;R2 c è i, fa il bitwise e guarda il bit a dx, e lo salva in R4			;  FDEMW	1
	beq R4,R0, IS_EVEN ;se R4 è 0 allora IS EVEN se no IS ODD								;	FDEMW	2
	l.d F2, v1(R2) #messa per branch delay slot, non serve metterla anche in j IS_ODD		;    FDEMW 1
	j IS_ODD ;non sicuro																	;	  FDEMW	1
	
	
IS_EVEN:
	#p= v1[i] * ((double)( m<< i)) /*logic shift */
	#l.d F2, v1(R2)																			;     FDEMW	1    17         
	dsllv R9,R1,R10 #bit shifting ledt su R1 o m di R2 o i e storing in R9 result			;	   FDEMW	1
	mtc1 R9,F3																				;	    FDEMW	1
	cvt.d.l F3,F3																			;		 FDEMW	1
	
	mul.d F4,F2,F3																			;		  FDAAAAAAAAMW	8
	s.d F4,p(R0)#store res in p																;		   FDsssssssEMW	1 forse swappare con sd r1,m(ro), 
																					
	cvt.l.d F4,F4 #convertion per m															;           FsssssssDEMW	1
	mfc1 R1,F4																				;			 		FDEMW	1
	sd R1, m(R0)																			;                    FDEMW	1

	j CONTINUE																				;					  FDEMW	1
	l.d F9,v2(R2)																			;					   FDEMW 1

IS_ODD:	
	;p= v1[i] / ((double)m* i))																;
	#l.d F2, v1(R2)																			;FDEMW	1    26
	
	mtc1 R1, F3 ; mi converte R1 o m in double 												; FDEMW	1
	cvt.d.l F3, F3 ; fa (double)F3															;  FDEMW	1	
	#convert also i into double in order to mul.d
	mtc1 R10, F4;																			;	 FDEMW	0
	cvt.d.l F4,F4																			;	  FDEMW	0
	mul.d F3, F3, F4;problema se i=0 allora m*i fa zero e la divisione viene F2/0			;	   FDAAAAAAAAMW	8 spostato su
	#converto m*i in nuovo registro per vedere se è 0	
	cvt.l.d F6,F3 ;tronca F3 e lo mette in F6												;	    FDEMW	0
    mfc1 R9,F6																				;	     FDEMW	0
	beq R9,R0, HANDLE_ZERO																	;		  FDEMW	0
	
	div.d F2, F2, F3																		;		  FDddddddddddddddddddddMW 15
	s.d F2,p(R0)																			;		   FDsssssssssssssssssssEMW 1

RESUME_POINT:
	#k =  ((float)((int)v4[i]/ 2^i), qua chiede in float e non in double, ma tiella in double che l ha detto il prof(assistente)
	l.d F5, v4(R2)																			;FDEMW	1     30
	cvt.l.d F5,F5;(int)v4[i]																; FDEMW	1
	mfc1 R7,F5 ;funziona la conversione a int												;  FDEMW	1
	daddi R1,R0,1 ; perche se abbiamo 2^0 fa 1	ma forse ha senso meteerela all inizio		;   FDEMW	1
	dsllv R3,R1,R10 ; R3 = 1 << R2; effectively 2^i, la v si usa quando usiamo un registro, ;    FDEMW	1
	ddiv R7,R7,R3																			;     FDddddddddddddddddddddMW 20
	#conversione in double del risultato della divisione
	mtc1 R7, F8																				;	   FDsssssssssssssssssssEMW	1
	cvt.d.l F8,F8																			;	    FsssssssssssssssssssDEMW	1
	s.d F8, k(R0)																			;	                		FDEMW	1
	j CONTINUE																				;							 FDEMW	1
	l.d F9,v2(R2) #branch delay slot 																					  FDEMW 1

HANDLE_ZERO:	
	s.d F20, p(R0)																			;FDEMW	1     2
	j RESUME_POINT																			; FDEMW	1
	
CONTINUE:
	# Load operations first
	#l.d F9,v2(R2)       																;FDEMW   1     40
	l.d F10,p(R0)              															; FDEMW 1
	l.d F12,v3(R2)             															;  FDEMW 1
	l.d F14,v1(R2)             															;   FDEMW 1
	# Compute for v5[i]
	mul.d F11,F10,F9           # p * v2[i]												;    FDXXXXXXXXMW 8
	add.d F11,F11,F12          # (p * v2[i]) + v3[i]									;	  FDsssssssAAAMW 3
	l.d F12,v4(r2)             # Load v4[i] here to allow time for previous result		;	   FsssssssDEMW 0
	add.d F13,F11,F12          # ((p * v2[i]) + v3[i]) + v4[i]							;	           FDXXXMW 3

	# Compute for v6[i]
	add.d F14, F14, F8         # k + v1[i]												;			    FDssXXXMW 3
	div.d F15, F13, F14        # v5[i] / (k + v1[i])									;				 FssDssddddddddddddddddddddMW 20
	# Compute for v7[i]
	add.d F16, F9, F12         # v2[i] + v3[i]											;					FssDssAAAMW 0
	mul.d F17, F15, F16        # v6[i] * (v2[i] + v3[i])								;					   FssDXXXXXXXXMW 0

	# Store results																		;						  
	s.d F13,v5(R2)             																				;     FDEMW 0
	s.d F15,v6(R2)             																					;  FDEMW 0
	s.d F17,v7(R2)             																					;	FDEMW 0

	# Pointer adjustments for next iteration
	daddi R2,R2,8              																					;	 FDEMW 0
	
	j LOOP                     																						; FDEMW 0
	daddi R10,R10,1            																					;	   FDEMW 0
END_LOOP:
	HALT																					;FDEMW 1
	