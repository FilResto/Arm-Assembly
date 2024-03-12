;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF

				AREA	DataCalories, DATA, READWRITE, align=3
				
Calories_food_ordered DCD 0, 0, 0, 0, 0, 0, 0
Calories_sport_ordered DCD 0, 0, 0
Temporary_food SPACE 56
Temporary_sport SPACE 24
					
                AREA    |.text|, CODE, READONLY, align=3


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]                                            
                LDR     R0, =Reset_Handler
				
				MOV R1, #0 ;index per loop esterno
				LDR R4, =Calories_food   ; pointer a Calories_food table
				LDRB R6, Num_days        ; tot num of days
				;LDRB R7, Num_days_sport
				MOV R3, #0; index per loop interno
				LDR R5, =Temporary_food
				
CopyLoop	
				CMP R1, R6  ; Compare with the number of entries
				BGE EndCopy

				; Copy day ID
				ADD R2, R4, R1, LSL #3
				LDR R8, [R2]  ; Load day ID
				STR R8, [R5, R1, LSL #3]  ; Store day ID in Temporary_vector

				; Copy calorie value
				LDR R9, [R2, #4]  ; Load calorie value
				ADD R2, R5, R1, LSL #3
				STR R9, [R2, #4]  ; Store calorie value in Temporary_vector

				ADD R1, R1, #1
				B CopyLoop

EndCopy
				MOV R1,#0

BubbleSort_Food
				CMP R1, R6
				BGE EndSort_Food
				
				MOV R3,R1 ; per far partire R3 da R1 minimo

InnerLoop_Food	
				ADD R3, R3, #1
				CMP R3,R6
				BGE NextOuter_Food
				
				;carico le calorie pt1
				ADD R12, R5, R1, LSL #3    ; Base address + R1 * 8
				LDR R8, [R12] ;qua tengo l address 
				ADD R12, R12, #4           ; Address of calorie value at R1
				LDR R9, [R12]              ; Load calorie value at R1
				;carico le calorie pt2 (elemento dopo)
				ADD R12, R5, R3, LSL #3    ; Base address + R3 * 8
				LDR R10, [R12] ;qua tengo l address 
				ADD R12, R12, #4           ; Address of calorie value at R3
				LDR R11, [R12]              ; Load calorie value at R3
				
				CMP R9,R11
				BGE InnerLoop_Food ;se R9 piu grande di r11 è ok e salto
				PUSH {R8, R9}  ; Save R1's day ID and calorie value
				

				; Swap day ID from R3 to R1
				LDR R8, [R5, R3, LSL #3]     ; Load R3's day ID
				STR R8, [R5, R1, LSL #3]     ; Store it in R1's position

				; Swap calorie value from R3 to R1
				ADD R12, R5, R3, LSL #3
				ADD R12, R12, #4
				LDR R8, [R12]                ; Load R3's calorie value
				ADD R12, R5, R1, LSL #3
				ADD R12, R12, #4
				STR R8, [R12]                ; Store it in R1's position

				; Swap day ID from R1 (saved in stack) to R3
				POP {R8, R9}                 ; Retrieve R1's original day ID and calorie value
				STR R8, [R5, R3, LSL #3]     ; Store R1's day ID in R3's position

				; Swap calorie value from R1 to R3
				ADD R12, R5, R3, LSL #3
				ADD R12, R12, #4
				STR R9, [R12]                ; Store R1's calorie value in R3's position

				
				B InnerLoop_Food
NextOuter_Food
				ADD R1, R1, #1
				B BubbleSort_Food
				
				
EndSort_Food

;IL TEMPORARY_VECTOR è ORDINATO, HO FATTO IL TEST!!!!!!

;salvo i val delle cal da temporary_vector a Calories_food_ordered
				MOV R1, #0
				LDR R7, =Calories_food_ordered ; Pointer to Calories_food_ordered
Final_rescue ;mettiamo i valori delle address in Calories_food_ordered
				CMP R1, R6                     ; Compare with the number of entries
				BGE EndFinal_rescue

				; Load calorie value from Temporary_vector
				ADD R12, R5, R1, LSL #3        ; Calculate address of entry in Temporary_vector
				
				LDR R9, [R12]                  ; Load calorie value

				; Store calorie value in Calories_food_ordered
				STR R9, [R7, R1, LSL #2]       ; Store calorie value at correct offset

				ADD R1, R1, #1
				B Final_rescue
				


EndFinal_rescue
;				MOV R1,#0
;Print		
;				CMP R1, R6                     ; Compare with the number of entries
;				BGE EndPrint
;
;				; Load and print calorie value from Calories_food_ordered
;				ADD R12, R7, R1, LSL #2        ; ora mi devo muovere di 4 byte alla vlta ,quindi LSL 2 e non 3 che è 8
;				LDR R9, [R12]                  ; Load calorie value
;				ADD R1, R1, #1
;				B Print
;EndPrint


				

;ORDINIAMO ANCHE SPORT CALORIES
				MOV R1,#0
				LDR R4, =Calories_sport  ; pointer a Calories_food table
				LDRB R6, Num_days_sport        
				;LDRB R7, Num_days_sport
				MOV R3, #0; index per loop interno
				LDR R5, =Temporary_sport

CopyLoop2
				CMP R1, R6  ; Compare with the number of entries
				BGE EndCopy2

				; Copy day ID
				ADD R2, R4, R1, LSL #3
				LDR R8, [R2]  ; Load day ID
				STR R8, [R5, R1, LSL #3]  ; Store day ID in Temporary_vector

				; Copy calorie value
				LDR R9, [R2, #4]  ; Load calorie value
				ADD R2, R5, R1, LSL #3
				STR R9, [R2, #4]  ; Store calorie value in Temporary_vector

				ADD R1, R1, #1
				B CopyLoop2

EndCopy2
				MOV R1,#0

BubbleSort_Food2
				CMP R1, R6
				BGE EndSort_Food2
				
				MOV R3,R1 ; per far partire R3 da R1 minimo

InnerLoop_Food2	
				ADD R3, R3, #1
				CMP R3,R6
				BGE NextOuter_Food2
				
				;carico le calorie pt1
				ADD R12, R5, R1, LSL #3    ; Base address + R1 * 8
				LDR R8, [R12] ;qua tengo l address 
				ADD R12, R12, #4           ; Address of calorie value at R1
				LDR R9, [R12]              ; Load calorie value at R1
				;carico le calorie pt2 (elemento dopo)
				ADD R12, R5, R3, LSL #3    ; Base address + R3 * 8
				LDR R10, [R12] ;qua tengo l address 
				ADD R12, R12, #4           ; Address of calorie value at R3
				LDR R11, [R12]              ; Load calorie value at R3
				
				CMP R9,R11
				BGE InnerLoop_Food2 ;se R9 piu grande di r11 è ok e salto
				PUSH {R8, R9}  ; Save R1's day ID and calorie value
				

				; Swap day ID from R3 to R1
				LDR R8, [R5, R3, LSL #3]     ; Load R3's day ID
				STR R8, [R5, R1, LSL #3]     ; Store it in R1's position

				; Swap calorie value from R3 to R1
				ADD R12, R5, R3, LSL #3
				ADD R12, R12, #4
				LDR R8, [R12]                ; Load R3's calorie value
				ADD R12, R5, R1, LSL #3
				ADD R12, R12, #4
				STR R8, [R12]                ; Store it in R1's position

				; Swap day ID from R1 (saved in stack) to R3
				POP {R8, R9}                 ; Retrieve R1's original day ID and calorie value
				STR R8, [R5, R3, LSL #3]     ; Store R1's day ID in R3's position

				; Swap calorie value from R1 to R3
				ADD R12, R5, R3, LSL #3
				ADD R12, R12, #4
				STR R9, [R12]                ; Store R1's calorie value in R3's position

				
				B InnerLoop_Food2
NextOuter_Food2
				ADD R1, R1, #1
				B BubbleSort_Food2
				
				
EndSort_Food2

;IL TEMPORARY_VECTOR è ORDINATO, HO FATTO IL TEST!!!!!!

;salvo i val delle cal da temporary_vector a Calories_food_ordered
				MOV R1, #0
				LDR R7, =Calories_sport_ordered ; Pointer to Calories_food_ordered
Final_rescue2;mettiamo i valori delle address in Calories_food_ordered
				CMP R1, R6                     ; Compare with the number of entries
				BGE EndFinal_rescue2

				; Load calorie value from Temporary_vector
				ADD R12, R5, R1, LSL #3        ; Calculate address of entry in Temporary_vector
				
				LDR R9, [R12]                  ; Load calorie value

				; Store calorie value in Calories_food_ordered
				STR R9, [R7, R1, LSL #2]       ; Store calorie value at correct offset

				ADD R1, R1, #1
				B Final_rescue2
				


EndFinal_rescue2
;				MOV R1,#0
;Print2	
;				CMP R1, R6                     ; Compare with the number of entries
;				BGE EndPrint2
;
;				; Load and print calorie value from Calories_food_ordered
;				ADD R12, R7, R1, LSL #2        ; ora mi devo muovere di 4 byte alla vlta ,quindi LSL 2 e non 3 che è 8
;				LDR R9, [R12]                  ; Load calorie value
;				ADD R1, R1, #1
;				B Print2
;EndPrint2
;FUNZIONA ANCHE Calories_sport_ordered che è in ordine!!!

;PT3 salvare in R11 the least caloric day
				MOV R11, #7000 ;metto un valore alto per far si che la prima comparazione vada a buon fine
				MOV R1, #0 ;index for days loop
				LDR R4, =Calories_food   ; pointer a Calories_food table
				LDR R5, =Calories_sport  ; pointer a Calories_sport table
				LDRB R6, Num_days        ; tot num of days
				LDRB R7, Num_days_sport
				MOV R3, #0; Initialize R3 to 0 for indexing
				

DayLoop 
				LDR R2, [R4,R3]
				ADD R3,R3,#4
				;carico in r1 calorie value
				LDR R9,[R4,R3]
				ADD R3,R3,#4
				;Il loop deve essere su Num_days

				;inizializzo sport cal to 0 per il giorno
				MOV R10,#0
				MOV R8,#0 ;indice per calories_sport loop


				
SportLoop	
				CMP R8, R7; se non sono uguali vuol dire che devo ancora finire di iterare Num_days_sport
                BGE NextDay ;se r8 ha un valore >= di r7 allora si attiva il salto a nosportcalories
                LDR R12, [R5, R8, LSL #3]  ; Load day ID from Calories_sport
                CMP R2, R12
                BNE NextSportDay
				;calcolo per il valore delle cal bruciate per l address R12
				ADD R12,R5,R8, LSL #3 ;Calculate the base address of the current entry
				ADD R12,R12,#4  ;Add 4 to the base address to get to the calorie value
                LDR R10, [R12]  ; Load sport calories
                SUB R9, R9, R10  ; Subtract sport calories from food calories
				CMP R9,R11
				BLT Lower
				B NextSportDay
Lower	
				
				PUSH {R1} ;pusho il counter di dove siamo arrivato nel sr l ultimo indirizzo che so che sarà quello del più piccolo
				MOV R11, R9; non so se serve tenere, tanto poi vado a sovrascrivere

NextSportDay	
				ADD R8, R8, #1
                B SportLoop

NextDay
				ADD R1, R1, #1
                CMP R1, R6
                BLT DayLoop
                
EndProgram
;now we get the address of r11, because in R11 I put the value of the calorie
				POP {R1} ;mi prende l ultimo indirizzo della push, che è quello con meno cal di tutti
				ADD R12, R4, R1, LSL #3
				LDR R11,[R12]




				
                BX      R0
                ENDP
				LTORG
Days            DCB 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
Calories_food   DCD 0x06, 1300, 0x03, 1700, 0x02, 1200, 0x04, 1900
                DCD 0x05, 1110, 0x01, 1670, 0x07, 1000
Calories_sport  DCD 0x02, 500, 0x05, 800, 0x06, 400
Num_days        DCB 7
Num_days_sport  DCB 3

 
; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit                

                END
