ORG 0000h ;程式開始
MOV 0E8h,#0FFh ;P4暗
MOV P0,#0FFh ; P0暗
MOV P1,#0FFh ; P1暗
MOV R0, #0h
MOV R1, #0F7h ;1111 0111B 第一個開始
MOV R2, #77h ;0111 0111B
MOV DPTR,#Seven_Table


Loop:
ACALL Disp_07seg
ACALL Delay
SJMP Loop


Delay: 
MOV R4, #10
Delay10: MOV R5, #24
Delay1: MOV R6, #100
Delay2: MOV R7, #100
Delay0: DJNZ R7, Delay0
DJNZ R6, Delay2
DJNZ R5, Delay1
DJNZ R4, Delay10
RET 

Disp_07seg:
MOV A,R1
RL A
JB 0E4h,Here
MOV A,#0FEh
Here:
MOV 0E8h,A
MOV R1,A

MOV A, R0
ANL A,#00001111B
MOVC A,@A+DPTR
MOV P0,A
INC R0

MOV A,R2
RL A
MOV P1,A
MOV R2,A

RET

Seven_Table:
DB 11000000B
DB 11111001B
DB 10100100B
DB 10110000B
DB 10011001B
DB 10010010B
DB 10000010B
DB 11011000B
DB 10000000B
DB 10010000B
DB 10001000B
DB 10000011B
DB 10100111B
DB 10100001B
DB 10000110B
DB 10001110B
END