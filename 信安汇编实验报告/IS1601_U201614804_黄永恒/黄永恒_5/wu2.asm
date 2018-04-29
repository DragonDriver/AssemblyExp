.386
STACK  SEGMENT  USE16  STACK
       DB  200  DUP (0)
STACK  ENDS

CODE   SEGMENT USE16
       ASSUME CS: CODE, SS:STACK
  COUNT   DB   18
  HOUR    DB	   ? ,?, ':'
  MIN      DB   ? , ?, ':'
  SEC      DB   ? , ?
  BUF_LEN = $ - HOUR
  CURSOR   DW  ?
  OLD_INT   DW  ?, ?
  MESSAGE  DB  0dh,0ah,'press any key to return',0dh,0ah,0dh,0ah,'$'
  
;--------------------------------------------------------------------------------------
; ����� 8���жϴ������  
NEW08H  PROC  FAR
        PUSHF
        CALL  DWORD  PTR  OLD_INT
        DEC   COUNT
        JZ    DISP
        IRET
  DISP: MOV  COUNT,18
        STI
        PUSHA
        PUSH  DS
        PUSH  ES
        MOV   AX, CS
        MOV   DS, AX
        MOV   ES, AX

        CALL  GET_TIME

        MOV   BH, 0
        MOV   AH, 3
        INT   10H             ; ��ȡ���λ�� (DH,DL)=(�У���)


        MOV   CURSOR,  DX
        MOV   DH, 0
        MOV   DL, 0
 

        MOV   BP,  OFFSET  HOUR
        MOV   BH, 0
        MOV   BL, 07H
        MOV   CX, BUF_LEN
        MOV   AL, 1
        MOV   AH, 13H
        INT   10H
 
        MOV   DX, CURSOR
        ADD    DL, BUF_LEN   ;  �� DL�Ƶ�ʱ����ʾ�Ľ�β��
        CMP    DL, 80
        JBE     NEW08_L1
        INC     DH
        SUB    DL, 81

        MOV   BH, 0
        MOV   AH, 3
        INT   10H             ; ��ȡ���λ�� (DH,DL)=(�У���)
         
NEW08_L1:    
        MOV    BH, 0
        MOV   AH, 2
        INT    10H

        POP   ES
        POP   DS
        POPA
        IRET
NEW08H   ENDP
; -------------------------------GET_TIME ------------------------------------------------
; ȡʱ��
; �ο����ϣ�CMOS���ݵĶ�д
GET_TIME   PROC
        MOV 	   AL, 4
        OUT 	  70H, AL
        JMP 	   $+2
        IN	       AL, 71H
        MOV     AH, AL
        AND      AL,0FH
        SHR 	   AH, 4
        ADD 	   AX, 3030H
        XCHG   AH, AL
        MOV    WORD PTR HOUR, AX
        MOV     AL, 2
        OUT     70H, AL
        JMP      $+2
        IN        AL, 71H
        MOV     AH, AL
        AND     AL, 0FH
        SHR     AH, 4
        ADD     AX, 3030H
        XCHG    AH, AL
        MOV     WORD PTR MIN, AX
        MOV     AL, 0
        OUT     70H, AL
        JMP      $+2
        IN       AL, 71H
        MOV     AH, AL
        AND     AL, 0FH
        SHR     AH, 4
        ADD     AX, 3030H
        XCHG    AH, AL
        MOV     WORD PTR SEC, AX
        RET
GET_TIME ENDP
; -------------------------------------------------------------------------------------------------------
; ������ʼ

BEGIN:   
          ; ��ʾ�����ڴ�����е� MESSAGE���е����ݣ�

        PUSH    CS
        POP   	  DS
         ; ��ȡԭ 8 ���жϵ��жϴ���������ڵ�ַ
        MOV    AX, 3508H
        INT     21H
        MOV    OLD_INT,  BX
        MOV    OLD_INT+2, ES

           ; �����µ� 8���жϵ��жϴ���������ڵ�ַ
        MOV    DX, OFFSET NEW08H
        MOV    AX, 2508H
        INT   	  21H

        LEA     DX, MESSAGE
        MOV    AH, 9
        INT     21H       

  NEXT: MOV   AH, 0BH       ;   �ж����޻���������������а�����ֹ         
        INT   	 21H
        CMP    AL, 0   
        JZ    	 NEXT
       	
        MOV    DX, OFFSET BEGIN+15
        MOV    CL, 4
        SHR   	  DX, CL
        ADD    DX, 10H
        MOV    AL, 0
        MOV    AH, 31H
        INT     21H

CODE    ENDS
        	END  BEGIN
