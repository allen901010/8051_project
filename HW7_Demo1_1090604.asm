			P4			EQU		0E8h                ;set name P4 = 0E8h
			DispBuf0	EQU		40h                 ;set name DispBuf0 = 40hh
			DispBuf1	EQU		41h                 ;set name DispBuf1 = 41h
			DispBuf2	EQU		42h                 ;set name DispBuf2 = 42h
			DispBuf3	EQU		43h                 ;set name DispBuf3 = 43h
			Keybuf_P2	EQU		44h                 ;set name Keybuf_P2 = 44h
			Keybuf_P3	EQU		45h	                ;set name Keybuf_P3 = 45h
;---------------------------------------------
			ORG		0000h				   			;start with 0000h
			MOV		P4, #07Fh                       ;set P4 value 7Fh
			MOV		R0, #DispBuf0					;set R0 value from DispBuf0
			MOV		DispBuf0, #11111111B			;set 7seg0 off
			MOV		DispBuf1, #11111111B			;set 7seg1 off
			MOV		DispBuf2, #11111111B			;set 7seg2 off
			MOV		DispBuf3, #11111111B			;set 7seg3 off
			MOV		P2, #0FFh                       ;set P2 as input mode
			MOV		P3, #0FFh						;set P3 as input mode
			MOV		DPTR, #Seven_Table				;set DPTR get values from #Seven_Table

Loop:
			ACALL	Disp_7seg				        ;goto Label Disp_7seg
			ACALL	GetKey                          ;goto Label Getkey
			ACALL	Delay					        ;goto Label Delay
			SJMP	Loop						    ;goto Label Loop

Delay:											    ;set 7seg flashing time delay
			MOV		R4, #1						    ;set R4 value 1
Delay10:	MOV		R5, #1							;set R5 value 1
Delay1:		MOV		R6, #100						;set R6 value 100
Delay2:		MOV		R7, #100						;set R7 value 100
Delay0:		DJNZ	R7, Delay0						;R7-- until 0 then jump to Delay0
			DJNZ	R6, Delay2					    ;R6-- until 0 then jump to Delay2
			DJNZ	R5, Delay1					    ;R5-- until 0 then jump to Delay1
			DJNZ	R4, Delay10					    ;R4-- until 0 then jump to Delay10
			RET									    ;return

Disp_7seg:                                          ;set 7seg flashed factor
			PUSH	0E0h                            ;PUSH A to stack to save the value avoid the code influence
			MOV		A, P4                           ;set A from P4
			RL		A                               ;right rotate A's value
			JB		Acc.4, Out_P4                   ;if Acc.4 = 1 jump to label Out_P4
			MOV		A, #0FEh                        ;set A FEh

Out_P4:                                             ;control P4 value
			MOV		P4, A                           ;set P4 from A
			MOV		A, @R0                          ;set A from R0 (bytes to addres)
			MOVC	A, @A+DPTR                      ;set A from A(bytes to addres)+DPTR value
			MOV		P0, A                           ;set P0 from A

			INC		R0                              ;R0++
			MOV		A, R0                           ;set A from R0
			ANL		A, #01000011B                   ;give A a mask to get value
			MOV		R0, A                           ;set R0 from A
			POP		0E0h                            ;get value from stack into A
			RET                                     ;return

GetKey:                                             ;get the button press in
			PUSH	0E0h                            ;PUSH A to stack to save the value avoid the code influence
			MOV		Keybuf_P2, P2                   ;set Keybuf_P2 from P2
			MOV		Keybuf_P3, P3                   ;set Keybuf_P3 from P3
			MOV		A, Keybuf_P2                    ;set A from Keybuf_P2
			CJNE	A, #0FFh, Get_P2                ;if A is not equal FFh jump to Get_P2(get the button press in)
			MOV		A, Keybuf_P3                    ;set A from Keybuf_P3
			CJNE	A, #0FFh, Get_P3                ;if A is not equal FFh jump to Get_P3(get the button press in)
Exit_Getkey:                                        ;set over
			POP		0E0h                            ;get value from stack into A
			RET                                     ;return
;-------------------------------------------------
Get_P2:                                             ;set P2 value
			MOV		R2, #0                          ;set R2 start count from 0
			MOV		A, Keybuf_P2                    ;set A from Keybuf_P2
Check_P2:                                           ;check P2 value
			JB		Acc.0, Buf0_SCAN                ;if bit Acc.0 is set jump to Buf0_SCAN
Disp_Buf0:                                          ;display Buf0
			MOV		DispBuf0, R2                    ;set DispBuf0 from R2
			SJMP	Exit_Getkey                     ;goto Exit_Getkey
Buf0_SCAN:                                          ;scan Buf0 value
			RR		A                               ;right rorate A's value
			INC		R2                              ;R2++
			CJNE	R2, #8, Check_P2                ;if R2 is not equal 8 jump to Check_P2(if equal 8 means didn't get button press in)
;-------------------------------------------------
Get_P3:                                             ;set P3 value
			MOV		R2, #8                          ;set R2 start count from 8
			MOV		A, Keybuf_P3                    ;set A from Keybuf_P3
Check_P3:                                           ;check P3 value
			JB		Acc.0, Buf1_SCAN                ;if bit Acc.0 is set jump to Buf1_SCAN
Disp_Buf1:                                          ;display Buf1
			MOV		DispBuf1, R2                    ;set DispBuf1 from R2
			SJMP	Exit_Getkey                     ;goto Exit_Getkey
Buf1_SCAN:                                          ;scan Buf1 value
			RR		A                               ;right rorate A's value
			INC		R2                              ;R2++
			CJNE	R2, #16, Check_P3               ;if R2 is not equal 16 jump to Check_P3(if equal 16 means didn't get button press in)
			
			 
;-------------------------------------------------
Seven_Table:
			DB		11000000B		;display 0
			DB		11001111B		;display 1 	
			DB		10100100B		;display 2
			DB		10110000B		;display 3
			DB		10011001B		;display 4
			DB		10010010B		;display 5
			DB		10000010B		;display 6
			DB		11111000B		;display 7
			DB		10000000B		;display 8
			DB		10010000B		;display 9
			DB		10001000B		;display A
			DB		10000011B		;display b
			DB		10100111B		;display c
			DB		10100001B		;display d
			DB		10000110B		;display E
			DB		10001110B		;display F
			END