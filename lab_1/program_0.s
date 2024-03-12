.data
v1: .byte 1, 2, -3, 4, 5, 6, 7, -8, 9, 10, 11, 12, 13, 14, 15
v2: .byte 2,2,2,2,2,2,2,5,2,2,2,2,2,2,2
v3: .byte 1, -2, 3, -4, 5, 6, 7, 8, 7, 6, 5, -4, 3, -2, 1
f1a: .space 1
f2a: .space 1
f3a: .space 1
v4: .space 9

.text # fai un registro dove metti il flag, già fatto. Dove se non è palindroma esci subito dal loop, se no rimani dentro e continui 
dadd R2,R0,R0 #pointer (start of array)
dadd R3,R0,R0 #pointer (end of array)
daddi R3,R3,14 #9 vec elements, so 9-1 last elem, modify it to 14 cuz array is 15 elements
daddi R1, R0, 1 #flag true (1) cuz we assume it's palindrome

LOOP: 
    lb R4, v1(R2) #get v1[i]
	lb R5, v1(R3) #get v1[j]
	bne R4, R5, NOT_PAL #if not pal put flag to 0, 
	daddi R2,R2,1 #increment 1 R2 in order to move forward for the start pointer
	daddi R3,R3,-1 #decrement -1 in order to move backward for the end pointer
	slt R6, R2, R3  # If R2 < R3, set R6 to 1, otherwise set R6 to 0
	bne R6, R0, LOOP  # If R6 is not equal to 0, branch to LOOP
	j END_LOOP
 
NOT_PAL:
    daddi R1, R0, 0 #set flag to 0

END_LOOP:
	sd R1, f1a(R0)#if all match then 1, otherwise 0

dadd R2,R0,R0 #pointer (start of array)
dadd R3,R0,R0 #pointer (end of array)
daddi R3,R3,14 #9 vec elements, so 9-1 last elem, modify it to 14 cuz array is 15 elements
daddi R1, R0, 1 #flag true (1) cuz we assume it's palindrome
	  
LOOP2: 
    lb R4, v2(R2) #get v2[i]
	lb R5, v2(R3) #get v2[j]
	bne R4, R5, NOT_PAL2
	daddi R2,R2,1
	daddi R3,R3,-1
	slt R6, R2, R3  
	bne R6, R0, LOOP2 
	j END_LOOP2
 
NOT_PAL2:
    daddi R1, R0, 0 

END_LOOP2:
	sd R1, f2a(R0)

# For v3
dadd R2,R0,R0 #pointer (start of array)
dadd R3,R0,R0 #pointer (end of array)
daddi R3,R3,14 #9 vec elements, so 9-1 last elem, modify it to 14 cuz array is 15 elements
daddi R1, R0, 1 #flag true (1) cuz we assume it's palindrome
	  
LOOP3: 
    lb R4, v3(R2) #get v3[i]
	lb R5, v3(R3) #get v3[j]
	bne R4, R5, NOT_PAL3
	daddi R2,R2,1
	daddi R3,R3,-1
	slt R6, R2, R3  
	bne R6, R0, LOOP3 
	j END_LOOP3
 
NOT_PAL3:
    daddi R1, R0, 0 

END_LOOP3:
	sd R1, f3a(R0)

#Somma
dadd R2, R0, R0   #indice per pointer v1 2 3 
dadd R3, R0, R0   #indice v4

ld R10, f1a(R0)  
ld R11, f2a(R0)  
ld R12, f3a(R0)  

SUM_LOOP:
    #faccio controllo per vedere se tutti gli elementi sono stati fatti
    daddi R8, R0, 15
    beq R2, R8, END_PROGRAM  # se raggiungiamo 14, allora finiamo il programma
    
    daddi R7, R0, 0  # Initialize R7 with 0 which will hold sum of this iteration
    
    beq R10, R1, ADD_V1  # se v1 palindroma, go to ADD_V1, se no skippo
SKIP_V1:
    beq R11, R1, ADD_V2  # se v2 palindroma, go to ADD_V2, se no skippo
SKIP_V2:
    beq R12, R1, ADD_V3  #se v3 palindroma, go to ADD_V3, se no skippo
SKIP_V3:
    sb R7, v4(R3)  #metto res in R4
    daddi R2, R2, 1  #incremento puntatore
    daddi R3, R3, 1  #incremento puntatore di v4. forse inutile, potrei usare R3 e basta, dovrebbero avere stesso valore
    j SUM_LOOP
    
ADD_V1:
    lb R8, v1(R2)   #v1[i]
    dadd R7, R7, R8 #lo aggiungo alla somma
    j SKIP_V1       #salto indietro
    
ADD_V2:
    lb R8, v2(R2)   
    dadd R7, R7, R8 
    j SKIP_V2       
    
ADD_V3:
    lb R8, v3(R2)   
    dadd R7, R7, R8 
    j SKIP_V3       

END_PROGRAM:
	HALT

HALT