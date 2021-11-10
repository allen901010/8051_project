         ORG 0000h  ;
	 	 MOV A,  #00h
         MOV R0, #01h 
	 	 MOV R1, #80h
Loop:
		 MOV A, R0
	 	 ORL A, R1
	   	 CPL A
         MOV P1,A
		 MOV A, R0
		 RR A
		 MOV R0, A
		 MOV A, R1
  		 RL A	 
		 MOV R1, A
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