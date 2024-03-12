.data
v1:	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8

v2:	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	
v3:	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	
v4:	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	.double 1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8
	
v5: .space 512
v6: .space 512
v7: .space 512


.text
	dadd R2, R0, R0 	; FDEMW       5
	dadd R3, R0, R0 	;  FDEMW      1
	daddi R8, R0, 64 	;	FDEMW	  1	
	
FOR_LOOP:
	beq R2, R8, END_LOOP;	 FDEMW    2
	#v5[i] = ((v1[i]* v2[i]) + v3[i]) + v4[i];
	l.d F2, v1(R3)		;	  FDEMW   1	
	l.d F3, v2(R3)		;	   FDEMW  1
	l.d F5, v3(R3)		;		FDEMW 1
	l.d F6, v4(R3)		;		 FDEMW 1
	mul.d F4, F2, F3	;	      FDEEEEEEEEMW 8
	
	add.d F4, F4, F5	;		   FDsssssssEEEMW 3					  
	add.d F4, F4, F6	;			FsssssssDssEEEMW 3
	s.d F4, v5(R3)		;			    FssssssDssEMW 1    qua?, ma non so se va messa FDssssssssEMW appena dopo la F, ma sembra che il compilatore dica la seconda
	
	#v6[i] = v5[i]/(v4[i]+v1[i]);
	add.d F7, F6, F2	;				       FssDEEEMW 3
	div.d F8, F4, F7	;					      FDssEEEEEEEEEEEEEEEEEEEEMW 20 guardando il compilatore qua fa 2 cicli di E quando la add è in E, controllare
	s.d F8, v6(R3)		;					       FsssssssDssssssssssssssEMW 1
	
	#v7[i] = v6[i]*(v2[i]+v3[i]);
	add.d F9, F3, F5	;						           FssssssssssssssDEEEMW 3
	mul.d F10, F8, F9	;											      FDssEEEEEEEEMW 8
	s.d F10, v7(R3)		;												   FssDsssssssEMW 1
	
	daddi R3, R3, 8		; 												 	   FssssssDEMW 1 ? o meglio FDEMW finita la s dell istruzione prec?												
	daddi R2, R2, 1		;												       		  FDEMW 1
	j FOR_LOOP			;														       FDEMW 1
	
END_LOOP:
	HALT ; FDEMW 1

#add non dipende da div e mul, lo stesso per gli altri due in triangolo. 