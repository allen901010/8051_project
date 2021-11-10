			ORG		0000h				   			;開始
			MOV		R0, #40h						;設R0為40h因為要從40h開始讀值
			MOV		40h, #4							;設40h為4
			MOV		41h, #9							;設41h為9
			MOV		42h, #2							;設42h為2
			MOV		43h, #5							;設43h為5
			MOV		P0, #0FFh						;先將七段顯示器設為不亮，進了迴圈再開始亮
			MOV		DPTR, #Seven_Table				;把Seven_Table設給DPTR
			MOV		0E8h, #01110111B				;設定七段顯示器亮最左邊那顆 
Loop:
			ACALL	Disp_7seg						;跳到七段顯示器
			ACALL	Delay							;跳到Delay
			SJMP	Loop							;回到Loop

Disp_7seg:
			MOV		A, R0							;把R0的值給A
			ANL		A, #01000011B					;遮罩讓A從40~43
			MOV		R0, A							;再把A從R0取回來
			MOV		A, @R0							;把R0的值直接給A
			MOVC	A, @A+DPTR						;讓A讀取Seven_Table
			MOV		P0,A							;設定給七段顯示器顯示對應的數字
			INC		R0								;R0+1
			MOV		A, 0E8h							;把0E8h丟到A暫存
			RL		A								;右移
			MOV		0E8h, A							;取回暫存的值
			RET										;回到上面

Delay:												;調整閃爍的時間
			MOV		R4, #1							;設R4為1
Delay10:	MOV		R5, #12							;設R5為12
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