         ORG 0000h  ;
		 MOV A,  #00h
		 CLR C
         MOV R0, #01h 
	 	 MOV R1, #03h
Loop:
		 JC Two_LED
One_LED:
		 MOV A, R0
		 CPL A
		 MOV P1, A
		 MOV A, R0
		 RL  A
		 MOV R0, A
		 SJMP All_Do
		 		 
Two_LeD:
		 MOV A, R1
		 CPL A
		 MOV P1, A
		 MOV A,R1
		 RL A
		 MOV R1, A
		 SJMP All_Do
	     
All_Do:	 
		 CPL C	 
         ACALL Delay  ;
         SJMP Loop

Delay:
         MOV R4, #10
Delay10: MOV R5, #24
Delay1:  MOV R6, #100
Delay2:  MOV R7, #100
Delay0:  DJNZ R7, Delay0
         DJNZ R6, Delay2
         DJNZ R5, Delay1
         DJNZ R4, Delay10
         RET  ;
;-----------------------------
         END  ;