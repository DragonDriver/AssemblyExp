;-------------------------------------------------------------------------
DATA	SEGMENT  USE16
   N       EQU   4
   BUF     DB   'zhangsan',0,0   				;ѧ������������10���ֽڵĲ�����0���
	  	     DB    100, 85, 80,?  				; ƽ���ɼ���δ����
     	     DB   'lisi',6 DUP(0)
	   	     DB    80, 100, 70,?
	   	     DB   N-3 DUP( 'TempValue',0,80,90,95,?)  ;����3���Ѿ����嶨����ѧ��															��Ϣ�ĳɼ������⣬����ѧ������Ϣ��ʱ�ٶ�Ϊһ���ġ�
     	     DB   'yongheng',0,0     				;���һ���������Լ����ֵ�ƴ��
	   	     DB    85, 85, 100, ?
   PR	     DB   'Please  input name:(# = quit) $'		;�������룬����'#'�˳�
   in_name  DB   10
	   	     DB   ?
   	     DB   10 DUP(0) 
   PR2	     DB   'Error�� Please input again: $'
   PR3	     DB   'NO EXIST! $'
   PR4	     DB   'Grades error! $'
   PR5	     DB   '100 $'						;��ƽ���ɼ�Ϊ100����ͨ���ַ������
   POIN    DW   ?
   DJ	     DB   'F$','F$','F$','F$','F$','F$','D$','C$','B$','A$','A$';�ȼ������ݳɼ�����10���
;�����̽�������ȼ�
DATA ENDS 
;-------------------------------------------------------------------------
STACK	SEGMENT STACK
	DB	200 DUP(0)
STACK	ENDS
;-------------------------------------------------------------------------
CODE	SEGMENT  USE16
	ASSUME CS:CODE,DS:DATA,SS:STACK
START:  
;--------------------------------------------------------------------------;���ӹ���1���жϳɼ��Ƿ�Ϸ�
		MOV  AX,DATA	
		MOV  DS,AX
				MOV  BP,-14
				MOV  CX,N+1
   WX2:	DEC  CX
		JZ    TSSR
		LEA   DI, BUF
		ADD  BP,14
				ADD  DI,BP
		ADD  DI,10
		MOV  AX,3
NX2: CMP  BYTE PTR[DI], 0
		JB    ERR2
				CMP  BYTE PTR[DI], 100
		JA    ERR2
		INC   DI
		DEC  AX
		JNZ   NX2
		JMP   WX2
;--------------------------------------------------------------------------;����һ����������
TSSR:LEA  DX, PR					 		 ;���ɼ�����������ʾ��������
	     MOV  AH, 9
		INT   21H			
  SR:  LEA  DX, in_name					 	 ;������������
		MOV  AH,10
		INT   21H			
		MOV  DL, 0AH		                    ;����
		MOV  AH, 2
		INT   21H
		MOV  SI, OFFSET in_name+2		 		  ;��SIָ�򻺳���������ʼ��ַ
		CMP  BYTE PTR [SI], '#'			  		  ;���ӹ��ܣ������롮#�������˳�����
		JZ    EXIT	
		MOV  CL,[SI-1]							
 LOPA:	CMP  BYTE PTR [SI],'A'			  		  ;���ӹ��ܣ��ж�����Ϸ���
		JB    ERR
		CMP  BYTE PTR [SI],'z'
		JA    ERR			
		INC   SI
		DEC  CX
		JNZ   LOPA
;---------------------------------------------------------------------------;���ܶ����ж����޸�����
		MOV  BX,OFFSET  in_name+1
		MOV  CL,[BX]
		MOV  SI,CX
		INC   BX
		MOV  BYTE PTR [BX+SI],00H      		  ;�޸����봮�����һ���ַ�Ϊ��\0��
		MOV  CX,N+1			
		MOV  DX,-14
	 WX:MOV  DI,OFFSET BUF
	 	MOV  SI,OFFSET in_name+2
	     DEC  CX
	JZ    NEH					 		;���������������δ�ҵ�������ʾ������
		ADD  DX,14
		ADD  DI,DX
		PUSH  DI                         		;��������ַѹ���ջ
		PUSH  SI
		CALL  STRCMP                  		;�����ӳ����ж������Ƿ���ͬ
		CMP   AX,0                       		;��AXΪ0����ʾδ�ҵ�������������
		JZ     WX
	 	MOV   DI,OFFSET BUF
	 	ADD   DI,DX
	 	ADD   DI,10
	 	MOV   POIN,DI			      	;���ҵ�ѧ���ĳɼ���ʼ��ַ�浽POIN������
;------------------------------------------------------------------------;������������ÿ��ѧ��ƽ���ɼ�
	 	CALL JISUAN                      		;�����ӳ��򣬼�������ͬѧƽ���ɼ�
;-------------------------------------------------------------------------;�����ģ���ʾѧ���ȼ����ɼ�
PRINT: MOV	  BX,POIN
		XOR   AX,AX
		MOV   AL,BYTE PTR [BX+3]
		PUSH   AX                        		;AX�д洢�����жϵĳɼ���ѹ���ջ
 		CALL   PANDUAN				  		;�����ӳ����жϳɼ��ȼ�����ʾ
PRINT2:  MOV  DL,' '				       		;���ӹ���2����ʾѧ���ɼ�
		MOV  AH,2
		INT   21H
		CMP  AL,100
		JZ    GOOD
		MOV  AH, 0
		MOV  DL,10
		IDIV	  DL
		ADD	  AL,'0'
		ADD	  AH,'0'
		MOV  BL, AL
		MOV  BH, AH
		MOV  DL,BL
 		MOV  AH,2
 		INT	  21H
 		MOV  DL,BH
 		MOV  AH,2
 		INT	   21H
 		MOV   DL,0AH
 		MOV   AH,2
 		INT	   21H
 		JMP   TSSR 
GOOD: LEA    DX,PR5
 		MOV   AH,9
 		INT    21H
 		MOV   DL,0AH
 		MOV   AH,2
 		INT   21H
 		JMP   TSSR					 	;����ͬѧ��Ӧ����������ϣ�������ʾ��������
;------------------------------------------------------------------------;��������
EXIT:  MOV   AH,4CH
		INT	   21H
ERR:	LEA    DX,PR2					 	;��ʾ�������ִ���
		MOV   AH,9
		INT	   21H
		JMP    SR
ERR2:	LEA    DX,PR4					 	;��ʾ�ɼ����󣬲���������
	 	MOV   AH,9
		INT    21H		
	 	JMP    EXIT	
 NEH:	LEA    DX,PR3					 	;��ʾ������
		MOV   AH,9
INT    21H
	  	MOV   DL,0AH
    		MOV   AH,2
INT    21H
JMP    TSSR
         ;-----------------------------------------------------------------------------;�ӳ���һ���ַ����Ƚ�
		STRCMP   PROC 
 				PUSH   DX
 				PUSH   SI
 				PUSH   DI
 				PUSH   BP                        		;�����ֳ�
 				MOV   BP, SP
 				MOV   SI, 10[BP]
 				MOV   DI, 12[BP]
 		   BJ:	MOV   DH, BYTE PTR [SI]
 				MOV   DL, BYTE PTR [DI]
 				CMP   DH, DL
 				JNE    A0
 				CMP   DH, 0
 				JE     A1
 				INC   SI
 				INC   DI
 				JMP   BJ
 		   A0:   MOV   AX,0
 				POP   BP
 				POP   DI
 				POP   SI
 				POP   DX                       		 	;�ָ��ֳ�
 				RET
 		   A1:   MOV   AX,1
 				POP   BP
 				POP   DI
 				POP   SI
 				POP   DX
 				RET 
          STRCMP   ENDP
        ;-------------------------------------------------------------------------------;�ӳ����������ƽ���ɼ�
		JISUAN   PROC
				PUSH   AX
				PUSH   DX
				PUSH   CX
				PUSH   BX
				PUSH   DI							 ;�����ֳ�
	 			MOV   CX, N+1
				MOV   BX, -14
          JISUAN1:MOV   DI, OFFSET BUF
	              DEC   CX
				JZ      S								 ;�����гɼ���������ϣ���������ʾ��
			     ADD   BX, 14
			     ADD   DI, BX
			     ADD   DI, 10
			     XOR   AX, 0
			     XOR   DX, 0
			     MOV   DL, BYTE PTR [DI]
			     MOV   AX, DX
			     ADD   AX, AX
			     MOV   DL, BYTE PTR [DI+1]
			     ADD    AX, DX
			     MOV   DL, BYTE PTR [DI+2]
			     SAR    DL,1
			     ADD   AX, DX
			     SAL    AX, 1
			     MOV   DL,7
			  	IDIV    DL
			  	MOV    BYTE PTR [DI+3], AL
			   	JMP     JISUAN1
			  S: POP   DI
			     POP   BX
			     POP   CX
			     POP   DX
			     POP   AX                       		;�ָ��ֳ�
			     RET
			   JISUAN ENDP
          ;-------------------------------------------------------------------------- -;�ӳ��������ȼ����
		 PANDUAN   PROC
 				PUSH   DX
 				PUSH   SI
 				PUSH   CX
 				PUSH	 AX
 				PUSH   BP						 	;�����ֳ�
 				MOV   BP, SP
 				MOV   AX, 12[BP]
 				LEA    SI, DJ
 				MOV   DL, 10
 				IDIV    DL					 		;��ʱAL�д����
 				XOR   CX, CX
 				MOV   CL, AL
 				SAL    CX, 1
 				ADD   SI, CX
 				MOV   DX, SI					 		;9�ŵ��ã�ֱ�������Ӧ�ȼ�
 				MOV   AH,9
 				INT    21H
 				POP   BP
 				POP		AX
 				POP   CX
 				POP   SI
 				POP   DX                        		;�ָ��ֳ�
 				RET
             PANDUAN ENDP
CODE	ENDS
		END START
