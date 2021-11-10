			P4			EQU		0E8h
			DispBuf0	EQU		40h
			DispBuf1	EQU		41h
			DispBuf2	EQU		42h
			DispBuf3	EQU		43h
			Keybuf_P2	EQU		44h
			Keybuf_P3	EQU		45h	
;---------------------------------------------
			ORG		0000h				   			;開始
			MOV		P4, #07Fh
			MOV		R0, #DispBuf0					;設R0為40h因為要從40h開始讀值
			MOV		DispBuf0, #11111111B					;設40h為4
			MOV		DispBuf1, #11111111B					;設41h為9
			MOV		DispBuf2, #11111111B					;設42h為2
			MOV		DispBuf3, #11111111B					;設43h為5 
			MOV		P2, #0FFh
			MOV		P3, #0FFh						;先將七段顯示器設為不亮，進了迴圈再開始亮
			MOV		DPTR, #Seven_Table				;把Seven_Tabl				

Loop:
			ACALL	Disp_7seg						;跳到七段顯示器
			ACALL	GetKey
			ACALL	Delay							;跳到Delay
			SJMP	Loop							;回到Loop

Delay:												;調整閃爍的時間
			MOV		R4, #1							;設R4為1
Delay10:	MOV		R5, #1							;設R5為12
Delay1:		MOV		R6, #100						;設R6為100
Delay2:		MOV		R7, #100						;設R7為100
Delay0:		DJNZ	R7, Delay0						;R7減1減至0
			DJNZ	R6, Delay2						;R6減1減至0
			DJNZ	R5, Delay1						;R5減1減至0
			DJNZ	R4, Delay10						;R4減1減至0
			RET										;回到上面

Disp_7seg:
			PUSH	0E0h
			MOV		A, P4
			RL		A
			JB		Acc.4, Out_P4
			MOV		A, #0FEh

Out_P4:
			MOV		P4, A
			MOV		A, @R0
			MOVC	A, @A+DPTR
			MOV		P0, A

			INC		R0
			MOV		A,R0
			ANL		A, #01000011B
			MOV		R0, A
			POP		0E0h
			RET

GetKey:
			PUSH	0E0h
			MOV		Keybuf_P2, P2
			MOV		Keybuf_P3, P3
			MOV		A, Keybuf_P2
			CJNE	A, #0FFh, Get_P2
			MOV		A, Keybuf_P3
			CJNE	A, #0FFh, Get_P3 
Exit_Getkey:
			POP		0E0h
			RET
Get_P2:
			MOV		R2, #0
			MOV		A, Keybuf_P2
Check_P2:
			JB		Acc.0, Buf0_SCAN 
Disp_Buf0:
			MOV		DispBuf0, R2
			SJMP	Exit_Getkey
Buf0_SCAN:
			RR		A
			INC		R2
			CJNE	R2, #8, Check_P2

Get_P3:
			MOV		R2, #8
			MOV		A, Keybuf_P3
Check_P3:
			JB		Acc.0, Buf1_SCAN 
Disp_Buf1:
			MOV		DispBuf1, R2
			SJMP	Exit_Getkey
Buf1_SCAN:
			RR		A
			INC		R2
			CJNE	R2, #16, Check_P3
			
			 
;-----------------------------------------------------
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