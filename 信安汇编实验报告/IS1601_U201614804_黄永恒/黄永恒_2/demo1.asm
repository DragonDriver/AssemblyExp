;----------------------------
DATA	SEGMENT  USE16
   N       EQU   4
   BUF     DB   'zhangsan',0,0   													;ѧ������������10���ֽڵĲ�����0���
	  			 DB    100, 100, 100,?  													; ƽ���ɼ���δ����
     	   	 DB   'lisi',6 DUP(0)
	   			 DB    80, 100, 70,?
	   			 DB   N-3 DUP( 'TempValue',0,80,90,95,?)			  ;����3���Ѿ����嶨����ѧ��
	   																											;��Ϣ�ĳɼ������⣬����ѧ������Ϣ��ʱ�ٶ�Ϊһ���ġ�
     	     DB   'yongheng',0,0     												;���һ���������Լ����ֵ�ƴ��
	   			 DB    85, 85, 100, ?
   PR	     DB   'Please  input name:(# = quit) $'					;�������룬����'#'�˳�
   in_name DB   10
	   			 DB   ?
           DB   10 DUP(0) 
   PR2	   DB   'Error Please input again: $'
   PR3     DB   'NO EXIST! $'
   PR4     DB   'Grades error! $'
   PR5		 DB   '100 $'
   POIN    DW   ?
DATA ENDS 
;----------------------------------------------------
STACK	SEGMENT STACK
	DB	200 DUP(0)
STACK	ENDS
;----------------------------------------------------
CODE	SEGMENT  USE16
	ASSUME CS:CODE,DS:DATA,SS:STACK
START:  
;---------------------------------------------------------;���ӹ��ܣ��жϳɼ��Ƿ�Ϸ�
				MOV AX,DATA	
				MOV DS,AX
				MOV BP,-14
				MOV CX,N+1
    WX2:LEA DI, BUF
  			DEC CX
				JZ  TSSR
				ADD BP,14
				ADD DI,BP
				ADD DI,10
				MOV AX,3
	  NX2:CMP BYTE PTR[DI],0
				JB  ERR2
				CMP BYTE PTR[DI],100
				JA  ERR2
				INC DI
				DEC AX
				JNZ NX2
				JMP WX2
;---------------------------------------------------------;����һ����������
	 TSSR:LEA DX,PR																				  ;���ɼ�����������ʾ��������
				MOV AH,9
				INT 21H			
    SR: LEA DX,in_name																		;������������
				MOV AH,10
				INT 21H			
				MOV DL,0AH                                        ;����
				MOV AH,2
				INT 21H
				MOV SI,OFFSET in_name+2														;��SIָ�򻺳���������ʼ��ַ
				CMP BYTE PTR [SI],'#'															;���ӹ��ܣ������롮#�������˳�����
				JZ  EXIT	
				MOV CL,[SI-1]							
  LOPA:	CMP BYTE PTR [SI],'A'															;���ӹ��ܣ��ж�����Ϸ���
				JB  ERR
				CMP BYTE PTR [SI],'z'
				JA  ERR			
				INC SI
				DEC CX
				JNZ LOPA
;---------------------------------------------------------;���ܶ����ж����޸�����
				MOV CX,N+1			
				MOV BX,-14
	 WX:	MOV SI,OFFSET in_name+2														
	 			MOV DI,OFFSET BUF
	      DEC CX
				JZ  NEH																						;���������������δ�ҵ�������ʾ������
			  ADD BX,14
			  ADD DI,BX
			  MOV AX,10
	 NX:  MOV DH,BYTE PTR [SI]								
	 			MOV DL,BYTE PTR [DI]
	 			CMP DH,0DH
	 			JZ  PD																						;���ƶ�������������жϴ洢�����Ӧ��ֵ�Ƿ�Ϊ'0'
	 			CMP DH,DL
	 			JNE WX																						;��������ĸ����ȣ���������ѭ��
	 			INC SI
	 			INC DI
	 			DEC AX
	 			JNE NX																						;��δ�Ƚ���������ĸ���������ѭ��
	 	PD: CMP DL,0
	 			JNZ WX																						;����������Ӧ�ַ���Ϊ0����ת����ѭ��
	 			MOV DI,OFFSET BUF
	 			ADD DI,BX
	 			ADD DI,10
	 			MOV POIN,DI																				;���ҵ�ѧ���ĳɼ���ʼ��ַ�浽POIN������
;---------------------------------------------------------;������������ÿ��ѧ��ƽ���ɼ�
	 			MOV CX,N+1
				MOV BX,-14
 JISUAN:MOV DI,OFFSET BUF
	      DEC CX
				JZ  PRINT																					;�����гɼ���������ϣ���������ʾ��
			  ADD BX,14
			  ADD DI,BX
			  ADD DI,10
			  MOV AX,0
			  MOV DX,0
			  MOV DL,BYTE PTR [DI]
			  MOV AX,DX
			  ADD AX,AX
			  MOV DL,BYTE PTR [DI+1]
			  ADD AX,DX
			  MOV DL,BYTE PTR [DI+2]
			  SAR DL,1
			  ADD AX,DX
			  SAL AX,1
			  MOV DL,7
			  IDIV DL
			  MOV BYTE PTR [DI+3],AL
			  JMP JISUAN
;--------------------------------------------------------;�����ģ���ʾѧ���ȼ����ɼ�
 PRINT: MOV BX,POIN
				MOV AX,[BX+3]
				CMP AL,90
			  JGE LA
			  CMP AL,80
			  JGE LB
			  CMP AL,70
			  JGE LC			  
			  CMP AL,60
			  JGE LD
			  CMP AL,60
			  JL  LF
PRINT2: MOV DL,' '																			 ;���ӹ��ܣ���ʾѧ���ɼ�
				MOV AH,2
				INT 21H
				CMP AL,100
				JZ  GOOD
				MOV AH, 0
				MOV DL,10
			 IDIV DL
			  ADD AL,'0'
			  ADD AH,'0'
			  MOV BL, AL
			  MOV BH, AH
			  MOV DL,BL
 				MOV AH,2
 				INT 21H
 				MOV DL,BH
 				MOV AH,2
 				INT 21H
 				MOV DL,0AH
 				MOV AH,2
 				INT 21H
 				JMP TSSR 	
 	GOOD: LEA DX,PR5
 				MOV AH,9
 				INT 21H
 				MOV DL,0AH
 				MOV AH,2
 				INT 21H
 				JMP TSSR 																				 ;����ͬѧ��Ӧ����������ϣ�������ʾ��������
;--------------------------------------------------------;��������
	EXIT:	MOV AH,4CH
				INT 21H
   ERR: LEA DX,PR2																			 ;��ʾ�������ִ���
				MOV AH,9
				INT 21H
				JMP SR
	 ERR2:LEA DX,PR4																			 ;��ʾ�ɼ����󣬲���������
	 			MOV AH,9
	 			INT 21H		
	 			JMP EXIT	
	 NEH: LEA DX,PR3																			 ;��ʾ������
	      MOV AH,9
	      INT 21H
	      MOV DL,0AH
	      MOV AH,2
	      INT 21H
	      JMP TSSR
	   LA:MOV DL,'A'
	   		MOV AH,2
	   		INT 21H
	   		JMP PRINT2
	   LB:MOV DL,'B'
	   		MOV AH,2
	   		INT 21H
	   		JMP PRINT2
		 LC:MOV DL,'C'
	   		MOV AH,2
	   		INT 21H
	   		JMP PRINT2
		 LD:MOV DL,'D'
	   		MOV AH,2
	   		INT 21H
	   		JMP PRINT2
		 LF:MOV DL,'F'
	   		MOV AH,2
	   		INT 21H
	   		JMP PRINT2
CODE	ENDS
			END START