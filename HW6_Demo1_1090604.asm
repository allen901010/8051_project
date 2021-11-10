			ORG		0000h				   			;開始
			MOV		R0, #0h							;設R0為0
			MOV		A, 	#0FEh						;設A為0FEh因為先控制LED亮的地方
			MOV		P0, #0FFh						;先將七段顯示器設為不亮，進了迴圈再開始亮
			MOV		DPTR, #Seven_Table				;把Seven_Table設給DPTR
			MOV		0E8h, #11111110B				;設定七段顯示器亮最左邊那顆 
Loop:
			MOV		P1, A							;把A丟進P1設定LED亮最左邊那個
			RL		A								;讓LED往右邊移動
			JB		Acc.1, NO_7seg 					;如果LED第一顆不亮跳到NO_7seg讓LED間隔一下向右移動
			ACALL	Disp_7seg						;跳到七段顯示器

NO_7seg:
			ACALL	Delay							;跳到Delay
			SJMP	Loop							;回到Loop
Disp_7seg:
			PUSH	0E0h							;把A的值放到0E0h
			MOV		A, R0							;把R0給A
			ANL		A, #0Fh							;給A不要超過16的遮罩
			MOVC	A, @A+DPTR						;讀取七段顯示器的值再給A
			MOV		P0, A							;把A的值給P0來設定七段顯示器的顯示
			INC		R0								;R0+1
			POP		0E0h							;取回放在0E0h的值
			RET										;結束迴圈並回到上面
			

Delay:
			MOV		R4, #10							;設R4為0
Delay10:	MOV		R5, #24							;設R5為0
Delay1:		MOV		R6, #100						;設R6為100
Delay2:		MOV		R7, #100						;設R7為100
Delay0:		DJNZ	R7, Delay0						;R7減1減至0
			DJNZ	R6, Delay2						;R6減1減至0
			DJNZ	R5, Delay1						;R5減1減至0
			DJNZ	R4, Delay10						;R4減1減至0
			RET										;回到上面



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
				