
;  �����ܣ� ��ʾ�ַ����У�ֱ��������ֹ


.386
STACK  SEGMENT  USE16  STACK
       DB  100  DUP (0)
STACK  ENDS

CODE   SEGMENT USE16
       ASSUME CS:CODE,DS:CODE,SS:STACK

   MESSAGE  DB  0dh,0ah,'press any key to return',0dh,0ah,0dh,0ah,'$'

; ��ʱ�����
DELAY   PROC
        PUSH  ECX
        MOV   ECX,0
L1:     INC   ECX
        CMP   ECX, 0600000H
        JB    L1
        POP   ECX
        RET
DELAY   ENDP


BEGIN:    ; Ҫ��ʾ MESSAGE���е����ݣ�
             ; ���ñ����ֶ����ڴ������,�ܷ���9�Ź��ܵ����أ�
      
        PUSH  CS
        POP   DS
        LEA   DX, MESSAGE
        MOV   AH, 9
        INT   21H  
        
        MOV   DL,30H
LOOP_DISP:    
        CALL  DELAY
        MOV   AH, 2        
        INT    21H
        INC    DL
        CMP   DL, 100
        JNZ    CHECK_KEY
        MOV   DL, 30H     ; ����� ASCIIΪ 99 ʱ�������¿�ʼ

CHECK_KEY :
           ; �ж����޻���������������а�����ֹ   
          MOV   AH, 0BH
          INT    21H
          CMP   AL, 0   
         JZ      LOOP_DISP

         MOV   AX,4C00H
         INT    21H       
CODE    ENDS
        END  BEGIN

 
