@echo off

for /d %%i in (Exp*) do (
echo %%i
cd %%i
if exist CS1603_U201614577_����ȫ*.zip (del CS1603_U201614577_����ȫ*.zip)
mkdir CS1603_U201614577_����ȫ
copy /y task*.* CS1603_U201614577_����ȫ\
rem this is for exp3/task1
copy /y *ongj*.* CS1603_U201614577_����ȫ\
copy /y *U201614577*.doc* CS1603_U201614577_����ȫ\
7z a CS1603_U201614577_����ȫ.zip CS1603_U201614577_����ȫ\
rmdir /s/q CS1603_U201614577_����ȫ
cd ..
)