         ORG 0000h  ;

         MOV A, #01h 
		
Loop:
		 MOV P1, A
		 CPL  A
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