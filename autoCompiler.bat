@echo off
rem ��ʵ���ļ��е�.exe��.asm��ʵ�鱨�渴��
FOR /r . %%i in (*.asm) do F:\masm60\MASM.exe %%i
FOR /r . %%a in (*.obj) do echo.|F:\masm60\LINK.exe %%a
FOR /r . %%c in (*.tr) do echo Y|del %%c