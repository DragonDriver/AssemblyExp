.386
.MODEL 	 FLAT, STDCALL
OPTION 	 CASEMAP: NONE

include 	windows.inc
include 	user32.inc
include 	kernel32.inc
include 	gdi32.inc
include 	shell32.inc

includelib 	user32.lib
includelib 	kernel32.lib
includelib 	gdi32.lib
includelib 	shell32.lib

WinMain		proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc		proto :DWORD,:DWORD,:DWORD,:DWORD 
List			proto :DWORD 
Average		proto :DWORD 

student 	 struct  
	myname		db  10 dup(0)  
	chinese		db  0  
	math			db  0  
	english		db  0  
	average 		db  0  
	grade			db  0 
student    	ends
;------------------------------------------
.data 
szClassName		db		'MainWndClass',0 
szDisplayName		db 		'My first Window',0      			;�������� 
MenuName			db 		'MyMenu',0 
DlgName			db 		'MyDialog',0 
AboutMsg			db 		'����IS1601������',0          	;��ʾ������ 
hInstance			dd 		0 
CommandLine		dd		0 
hWnd				dd		0
buf      	student   <'zhaojiu',89,75,88,0,0>         				;ѧ���ṹ����   
			student   <'zhangsan',60,85,46,0,0>   
			student   <'lisi',95,90,95,0,0>   
			student   <'wangwu',80,65,85,0,0>   
			student   <'yongheng',99,98,97,0,0> 
msg_list			db		 'List',0  
msg_name			db       'Name',0 
msg_chinese		db       'Chinese',0 
msg_math			db       'Math',0 
msg_english			db       'English',0 
msg_average		db       'Average',0 
msg_grade			db       'Grade',0 
msg_line			db		 '___________________________________________________________________________',0
chinese			db       '89','60','95','80', '99'         ;���������ѧ���ɼ� 
math 				db       '75','85','90','65', '98' 
english 			db       '88','46','95','85', '97' 
average 			db       '00','00','00','00', '00'
flag				db		0
N				EQU				5
.code
;-----------------------------������--------------------------------------
start:
		invoke	GetModuleHandle ,NULL
		mov		hInstance, EAX
		invoke	GetCommandLine
		mov		CommandLine ,EAX
		invoke	WinMain,hInstance ,NULL ,CommandLine ,SW_SHOWDEFAULT
		invoke	ExitProcess, EAX
;---------------------------����������-----------------------------------
WinMain		proc  hInst	:DWORD,   hPrevInst	:DWORD,
				 CmdLine		:DWORD,  CmdShow	:DWORD
		local   	wc		:WNDCLASSEX
		local   	msg		:MSG
		local		Wwd		:DWORD
		local		Wht		:DWORD
		local		Wtx		:DWORD
		local		Wty		:DWORD
		mov		wc.cbSize, sizeof WNDCLASSEX  
		mov		wc.style, CS_HREDRAW or CS_VREDRAW
 	mov		wc.lpfnWndProc, offset WndProc  
		mov		wc.cbClsExtra, NULL  
		mov		wc.cbWndExtra, NULL  
		push		hInst  
		pop		wc.hInstance  
		mov    	wc.hbrBackground, COLOR_WINDOW+1  
		mov		wc.lpszMenuName, offset MenuName  
		mov		wc.lpszClassName, offset szClassName    
		mov		wc.hIcon, 0
		mov    	wc.hIconSm, 0  
		invoke	LoadCursor, NULL,IDC_ARROW  
		mov		wc.hCursor, eax  
		invoke	RegisterClassEx, addr wc			;ע�ᴰ����
		mov		Wwd, 600 
		mov		Wht, 400 
		mov		Wtx, 100 
		mov		Wty, 100
		invoke	CreateWindowEx, WS_EX_ACCEPTFILES + WS_EX_APPWINDOW,
addr	szClassName, addr	szDisplayName,WS_OVERLAPPEDWINDOW+ WS_VISIBLE,Wtx, Wty, Wwd, Wht,
				NULL, NULL, hInst, NULL			;��������
		mov		hWnd,EAX
		invoke  	LoadMenu, hInst,600
		invoke  	SetMenu,hWnd, EAX
	StartLoop:
		invoke	GetMessage,addr msg,NULL,0,0		;��ȡ��Ϣ
		cmp		EAX,0
		je		ExitLoop
		invoke	TranslateMessage,addr	msg			;ת����Ϣ
		invoke	DispatchMessage,addr msg			;�ַ���Ϣ
		jmp		StartLoop
	ExitLoop:
		mov		EAX , msg.wParam				;�����˳���
		Ret
WinMain	ENDP
;---------------------������Ϣ�������----------------------------
WndProc		proc	hWin	:DWORD,	uMsg	:DWORD, wParam:DWORD, lParam:DWORD
				.if uMsg == WM_COMMAND
				   .if wParam == 1800
					invoke	Average,N			 ;����ƽ��ֵ�ӳ���
			        .elseif	wParam == 1801
						invoke	List,hWin		 ;����չʾ�ӳ���
				   .elseif wParam == 1900			 ;help-about��Ϣչʾ
							invoke	MessageBox, hWin, addr AboutMsg, addr szDisplayName,MB_OK
				   .elseif wParam == 1010
					invoke	SendMessage,hWin,WM_CLOSE,0,0
				   .endif
				.elseif	uMsg == WM_DESTROY
					invoke	PostQuitMessage,NULL
				.else
					invoke	DefWindowProc,hWin,uMsg,wParam,lParam
					ret
						.endif
							mov EAX,0
					ret
WndProc		endp
;-----------------------�û��������------------------------------------
;�ӳ�������Average
;���ܣ������Ȩƽ��ֵ
;ԭ�ͣ�Average	PROTO	��DWORD
;			buf���ṹ����		;ѧ����Ϣ
Average	proc	number:DWORD
				pusha
				mov		flag,1
				mov		ecx, 0
_next:	cmp		ecx, 	number
				jge		_exit
				xor 		eax, eax
 			xor 		edx, edx
 			imul		ebx, ecx, 15
 			mov   	al,  buf[ebx].chinese 
 			mov   	dl,  buf[ebx].math  
				sal   	eax,2 
				sal   	edx,1 
				add		eax,edx  
				mov   	edx,0 
				mov   	dl,  buf[ebx].english 
				add		ax, dx 
				mov   	dl,7 
				div   	dl
				;�жϵȼ�
   			.if al > 90 
						mov	buf[ebx].grade, 'A'     
				.elseif al > 80 
						mov	buf[ebx].grade, 'B'     
				.elseif al > 70 
						mov	buf[ebx].grade, 'C' 
		    		.elseif al > 60 
						mov	buf[ebx].grade, 'D'     
				.else 
						mov	buf[ebx].grade, 'F'  
    			.endif

				mov buf[ebx].average, al 
				call	F2T10			;��ƽ���ɼ�ת��Ϊ10�������ִ�
				inc	ecx 
				jmp	_next
 _exit: popa
 			ret
 	Average ENDP
;---------------------------------------------------------------------
;�ӳ�������List
;���ܣ�����ɼ���
;ԭ�ͣ�List		PROTO	��DWORD	
List		proc		hWin:DWORD
				XX     	equ  10              
				YY     	equ  10       
				XX_GAP 	equ  100       
				YY_GAP 	equ  30 
				local  	hdc :HDC 
				invoke	GetDC, hWin 
				mov		hdc, eax 
				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_list,4 
				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset msg_name,4 
				invoke 	TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset msg_chinese,7 
				invoke 	TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset msg_math,4 
				invoke 	TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset msg_english,7 	
				invoke 	TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset msg_average,7 	
				invoke 	TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset msg_grade,5
				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+2*YY_GAP,offsetmsg_line,68 

          ;�������ѧ���ĳɼ� 				
				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+3*YY_GAP,offset buf[0*15].myname,7 
				invoke 	TextOut,hdc,XX+1*XX_GAP,YY+3*YY_GAP,offset chinese,2 
				invoke 	TextOut,hdc,XX+2*XX_GAP,YY+3*YY_GAP,offset math,2 
				invoke 	TextOut,hdc,XX+3*XX_GAP,YY+3*YY_GAP,offset english,2 
				
				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+4*YY_GAP,offset buf[1*15].myname,8 
				invoke 	TextOut,hdc,XX+1*XX_GAP,YY+4*YY_GAP,offset chinese+2,2 
				invoke 	TextOut,hdc,XX+2*XX_GAP,YY+4*YY_GAP,offset math+2,   2 
				invoke 	TextOut,hdc,XX+3*XX_GAP,YY+4*YY_GAP,offset english+2,2 
				
				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+5*YY_GAP,offset buf[2*15].myname,4 
				invoke 	TextOut,hdc,XX+1*XX_GAP,YY+5*YY_GAP,offset chinese+4,2 
				invoke 	TextOut,hdc,XX+2*XX_GAP,YY+5*YY_GAP,offset math+4,   2 
				invoke 	TextOut,hdc,XX+3*XX_GAP,YY+5*YY_GAP,offset english+4,2 

				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+6*YY_GAP,offset buf[3*15].myname,6 
				invoke 	TextOut,hdc,XX+1*XX_GAP,YY+6*YY_GAP,offset chinese+6,2 
				invoke 	TextOut,hdc,XX+2*XX_GAP,YY+6*YY_GAP,offset math+6,2 
				invoke 	TextOut,hdc,XX+3*XX_GAP,YY+6*YY_GAP,offset english+6,2 
				
				invoke 	TextOut,hdc,XX+0*XX_GAP,YY+7*YY_GAP,offset buf[4*15].myname,8 
				invoke 	TextOut,hdc,XX+1*XX_GAP,YY+7*YY_GAP,offset chinese+8,2 
				invoke 	TextOut,hdc,XX+2*XX_GAP,YY+7*YY_GAP,offset math+8,2 
				invoke 	TextOut,hdc,XX+3*XX_GAP,YY+7*YY_GAP,offset english+8,2 

					;����flag�ж��Ƿ�ƽ��ֵ�ȼ��Ƿ��Ѽ���
				cmp			flag,0
				je			exit				
				invoke 	TextOut,hdc,XX+4*XX_GAP,YY+3*YY_GAP,offset average,2 
				invoke	TextOut,hdc,XX+5*XX_GAP,YY+3*YY_GAP,offset buf[0*15].grade,1              
				invoke 	TextOut,hdc,XX+4*XX_GAP,YY+4*YY_GAP,offset average+2,2 
				invoke 	TextOut,hdc,XX+5*XX_GAP,YY+4*YY_GAP,offset buf[1*15].grade,1             
				invoke 	TextOut,hdc,XX+4*XX_GAP,YY+5*YY_GAP,offset average+4,2 
				invoke 	TextOut,hdc,XX+5*XX_GAP,YY+5*YY_GAP,offset buf[2*15].grade,1  
				invoke 	TextOut,hdc,XX+4*XX_GAP,YY+6*YY_GAP,offset average+6,2 
				invoke 	TextOut,hdc,XX+5*XX_GAP,YY+6*YY_GAP,offset buf[3*15].grade,1   
				invoke 	TextOut,hdc,XX+4*XX_GAP,YY+7*YY_GAP,offset average+8,2 
				invoke 	TextOut,hdc,XX+5*XX_GAP,YY+7*YY_GAP,offset buf[4*15].grade,1  
				exit:	ret 
List     endp 
;-----------------------------------------------------------------------
;�ӳ�������F2T10
;���ܣ�����������ת��Ϊʮ�������ִ�
;������ax����������
;		 average�����ִ���ַ	
F2T10   proc
			pusha
			mov		ah, 0
			mov  	dx, 10
			idiv 	 	dl
			mov   	average[ecx*2+1], ah
			add   	average[ecx*2+1], '0'
			mov  	ah,0
			idiv 	 	dl
			mov   	average[ecx*2], ah
			add   	average[ecx*2], '0'
			popa
			ret
		F2T10 ENDP
end start
