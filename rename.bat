@echo off & setlocal enabledelayedexpansion

rem ��¼��ʼ����ʱ��
set begin=%time%
if %time:~0,2% lss 10 (
    set /a hh=10%time:~1,1%-100
)else (
    set /a hh=1%time:~0,1%-100
)
set /a mm=1%time:~3,2%-100
set /a ss=1%time:~6,2%-100
set /a hun=1%time:~9,2%-100
set /a time1=!hh!*360000+!mm!*6000+!ss!*100+!hun!
if %time:~0,2% equ 0 set /a time1+=8640000

rem cl rename.c

echo �����������ļ�. . .
set /p=________________________________________________________________________________<nul
echo.
set count=0
for /f "tokens=*" %%a in ('dir /b *.avf') do (
	set /a count+=1
	rename.exe "%%a"
)


rem ����������ʱ
rem echo.
rem echo ��ʼʱ�䣺%begin%
rem echo ����ʱ�䣺%time%
if %time:~0,2% lss 10 (
    set /a hh=10%time:~1,1%-100
)else (
    set /a hh=1%time:~0,1%-100
)
set /a mm=1%time:~3,2%-100
set /a ss=1%time:~6,2%-100
set /a hun=1%time:~9,2%-100
set /a time2=!hh!*360000+!mm!*6000+!ss!*100+!hun!
if %time:~0,2% equ 0 set /a time2+=8640000

set/a time3=%time2%-%time1%
set/a speed=!count!*10000/%time3%

rem ��λ��0����
set/a second=%time3:~,-2%+0
set/a unit=%speed:~,-2%+0

set /p=________________________________________________________________________________<nul
echo.
echo ���������ļ� !count! ��, �ٶ� !unit!.%speed:~-2,2% ��/s, �ܺ�ʱ: !second!.%time3:~-2,2% s
echo.

if exist pb.bat (
echo 10s���Զ���ʼ����PB. . .
ping /n 4 127.0.0.1> nul
echo 8s ���Զ���ʼ����PB. . .
ping /n 4 127.0.0.1> nul
echo 6s ���Զ���ʼ����PB. . .
ping /n 4 127.0.0.1> nul
echo 4s ���Զ���ʼ����PB. . .
ping /n 4 127.0.0.1> nul
echo 2s ���Զ���ʼ����PB. . .
ping /n 4 127.0.0.1> nul

rem set /p=�밴�������ʼ����PB. . .<nul
rem pause > nul

start pb.bat
)else (
set /p=�밴������˳�. . .<nul
pause >nul
)