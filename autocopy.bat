@echo off

for /d %%i in (Exp*) do (
echo %%i
cd %%i
if not exist *.zip (
mkdir ʵ�鱨���ļ���
copy /y *.asm ʵ�鱨���ļ���\
copy /y *.ASM ʵ�鱨���ļ���\
copy /y *.exe ʵ�鱨���ļ���\
copy /y *.EXE ʵ�鱨���ļ���\
copy /y CS1603_U201614577* ʵ�鱨���ļ���\
7z a ʵ�鱨��ѹ��.zip ʵ�鱨���ļ���\
rmdir /s/q ʵ�鱨���ļ���
) 
cd ..
)