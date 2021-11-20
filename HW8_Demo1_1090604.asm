			P4			EQU		0E8h                ;set name P4 = 0E8h
			DispBuf0	EQU		40h                 ;set name DispBuf0 = 40hh
			DispBuf1	EQU		41h                 ;set name DispBuf1 = 41h
			DispBuf2	EQU		42h                 ;set name DispBuf2 = 42h
			DispBuf3	EQU		43h                 ;set name DispBuf3 = 43h
			Keybuf_P2	EQU		44h                 ;set name Keybuf_P2 = 44h
			Keybuf_P3	EQU		45h	                ;set name Keybuf_P3 = 45h
            Key_pre     EQU     46h                 ;set name Key_pre = 46h
            Key_now     EQU     47h                 ;set name Key_now = 47h
;---------------------------------------------
			ORG		0000h				   			;start with 0000h
			MOV		P4, #7Fh                        ;set P4 value 7Fh
			MOV		R0, #DispBuf0					;set R0 value from DispBuf0
			MOV		DispBuf0, #0FFh			        ;set 7seg0 off
			MOV		DispBuf1, #0FFh		            ;set 7seg1 off
			MOV		DispBuf2, #0FFh			        ;set 7seg2 off
			MOV		DispBuf3, #0FFh			        ;set 7seg3 off
			MOV		P2, #0FFh                       ;set P2 as input mode
			MOV		P3, #0FFh						;set P3 as input mode
			MOV		DPTR, #Seven_Table				;set DPTR get values from #Seven_Table
            MOV     Key_pre, #0FFh                  ;set Key_pre as input mode
            MOV     Key_now, #0FFh                  ;set Key_now as input mode
            MOV     R3, #100                        ;set R3 value 7Fh
Loop:
            ACALL	GetKey                          ;goto Label Getkey
			ACALL	Disp_7seg				        ;goto Label Disp_7seg
			ACALL	Delay_KeyDebounce				;goto Label Delay_KeyDebounce
			SJMP	Loop						    ;goto Label Loop
Delay:											    ;set 7seg flashing time delay
            MOV     R5, #15
Delay1:     MOV     R6, #10
Delay2:     MOV     R7, #100
Delay0:     DJNZ    R7, Delay0
            DJNZ    R6, Delay2
            DJNZ    R5, Delay1
            RET    

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
            SJMP    Exit_Getkey                     ;goto label Exit_Getkey
;-------------------------------------------------
Get_P2:                                             ;set P2 value
			MOV		R2, #0                          ;set R2 start count from 0
Check_P2:   
            JB      Acc.0, Check_next_P2            ;if Acc.0 = 1 goto Check_next_P2
            MOV     Key_now, R2                     ;set Key_now from R2
            SJMP    Exit_Getkey                     ;goto label Exit_Getkey
Check_next_P2:
            RR      A                               ;right rotate A
            INC     R2                              ;R2++
            CJNE    R2, #8, Check_P2                ;if R2 not equal to 8 then goto label Check_P2
            SJMP    Exit_Getkey 			        ;goto label Exit_Getkey
;-------------------------------------------------
Get_P3:                                             ;set P2 value
			MOV		R2, #8                          ;set R2 start count from 0
Check_P3:   
            JB      Acc.0, Check_next_P3            ;if Acc.0 = 1 goto Check_next_P3
            MOV     Key_now, R2                     ;set Key_now from R2
            SJMP    Exit_Getkey                     ;goto label Exit_Getkey
Check_next_P3:
            RR      A                               ;right rotate A
            INC     R2                              ;R2++
            CJNE    R2, #16, Check_P3               ;if R2 not equal to 16 then goto label Check_P2
Exit_Getkey:                                        ;set over
			POP		0E0h                            ;get value from stack into A
			RET                                     ;return
			
Delay_KeyDebounce:
            PUSH    0E0h                            ;Push A into stack
            ACALL   Delay                           ;run Delay Loop
            DEC     R3                              ;R3--
            CJNE    R3, #0, Exit_KeyDebounce        ;if R3 not equal to0 then goto Exit_Getkey
            MOV     R3, #100                        ;set R3 = 100
            MOV     A, Key_now                      ;set A from Key_now
            CJNE    A, #0FFh, Unclear_KeyCheck      ;if A not equal to FFh then goto Unclear_KeyCheck 
Clear_KeyCheck:
            MOV     Key_pre, #0FFh                  ;set Key_pre = FFh
            MOV     Key_now, #0FFh                  ;set Key_now = FFh
Exit_KeyDebounce:
            POP     0E0h                            ;POP A from stack
            RET                                     ;return
Unclear_KeyCheck:
            CJNE    A, Key_pre, recheck             ;if A not equal to Key_pre the goto recheck
            MOV     DispBuf0, DispBuf1              ;left move the 7seg
            MOV     DispBuf1, DispBuf2              ;left move the 7seg
            MOV     DispBuf2, DispBuf3              ;left move the 7seg
            MOV     DispBuf3, A                     ;left move the 7seg
            SJMP    Clear_KeyCheck                  ;goto label Clear_KeyCheck
			 
recheck:
            MOV     Key_pre, Key_now                ;set Key_pre from Key_now
            SJMP    Exit_Getkey                     ;goto label Exit_Getkey 
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