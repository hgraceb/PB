@echo off & setlocal enabledelayedexpansion
rem �رջ��ԣ����ñ����ӳ�


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


rem ���ݲ�ͬ������������޸������ĸ�����

rem ����ĸ��ʽ������������
set "form=%%a_%%b_%%c_%%d=%%e_%%f=%%g_%%h"
rem ���������еķָ������Լ���ĸ����
set "cut=delims==_ tokens=1-8"
rem ���������ĸ
set "level=%%a"
rem ����time����ĸ
set "score=%%c"
rem ����bv����ĸ
set "bbbv=%%e"


set count=0
set total=0


rem ɾ���ļ���pb
if exist pb rd /s/q pb


rem �ж��ļ������Ƿ����avf¼��
dir /b/s *.avf | findstr . >nul || goto wrong


rem ����%filename%����¼���ļ�����Ϣ�����Ѵ���������ļ����ݣ���ͬ��
if exist Beg·��.txt del /q Beg·��.txt
if exist Int·��.txt del /q Int·��.txt
if exist Exp·��.txt del /q Exp·��.txt
if exist Cus·��.txt del /q Cus·��.txt
echo ���ڻ�ȡ¼���ļ���. . .
for /f "tokens=*" %%z in ('dir /b *.avf') do (
    rem echo %%z
    for /f "%cut%" %%a in ("%%z") do (
        if not exist %level%·��.txt cd. > %level%·��.txt
        echo %%z >> %level%·��.txt
    )
)

:level
if exist Beg·��.txt set "filename=Beg·��.txt" && goto findbbbv
if exist Int·��.txt set "filename=Int·��.txt" && goto findbbbv
if exist Exp·��.txt set "filename=Exp·��.txt" && goto findbbbv
if exist Cus·��.txt set "filename=Cus·��.txt" && goto findbbbv
goto end

:findbbbv
set /p=________________________________________________________________________________<nul
echo.
if %filename:~0,3% equ Beg echo ���ڲ��ҳ���PB. . .
if %filename:~0,3% equ Int echo ���ڲ����м�PB. . .
if %filename:~0,3% equ Exp echo ���ڲ��Ҹ߼�PB. . .
if %filename:~0,3% equ Cus echo ���ڲ����Զ����PB. . .
echo.

rem �����ļ�����"3BV="����λ��
set num=0
for /f "delims=" %%a in (%filename%) do (
    set str=%%a
    :loop
    set char=!str:~%num%,4!
    set /a num=num+1
    if !char! equ 3BV^= set /a num=num+4 && goto :sort
    if !num! equ 200 cls && echo ��ͳһ������ʽΪ: && echo "<mode>_<style>_<time>_3BV=<3bv>_3BVs=<3bv/s>_<name>" && goto wrong
    goto loop
)


:sort
rem ��¼���������������������.txt��
sort /r /+!num! %filename% > ����.txt
del /q %filename%


rem ����pb.txt����pb��Ϣ����3BV=**Ϊ�ж�����
rem bv: ¼��3BV
rem result: ¼��Time
rem name: ǰһ��¼�������޵��������Ը���ֵΪ0
rem count:pb��
cd. > pb.txt
set bv=0
set result=0
set name=0
set count_temp=0
for /f "%cut%" %%a in (����.txt) do (
    set /a total+=1
    if !bv! neq %bbbv% (
        if !bv! neq 0 (
        echo !name!>> pb.txt
        echo !name!
        set /a count+=1
        set /a count_temp+=1
    )
    set bv=%bbbv%
    set result=%score%
    set name=%form%
    )else (
        if !result! geq %score% (
            set result=%score%
            set name=%form%
            rem ��ӡ�����쳣bv
            rem echo.
            rem echo %bbbv%
        )
    )
)

del /q ����.txt
rem start ����.txt


rem nameΪ%%aǰһ��¼������forѭ�������󲹳����һ��¼����
if !bv! neq 0 (
    echo !name! >> pb.txt
    echo !name!
    set /a count+=1
    set /a count_temp+=1
)


rem ��bv��С��������
rem sort /+!num! pb.txt


rem ����pb�ļ��в�������pb���Ƶ����ļ���
if not exist pb md pb
for /f "tokens=*" %%a in (pb.txt) do (
    copy "%%a" pb > nul
)

echo.
if %filename:~0,3% equ Beg echo ���ҵ� !count_temp! ������PB
if %filename:~0,3% equ Int echo ���ҵ� !count_temp! ���м�PB
if %filename:~0,3% equ Exp echo ���ҵ� !count_temp! ���߼�PB
if %filename:~0,3% equ Cus echo ���ҵ� !count_temp! ���Զ����PB
goto level


:end


del /q pb.txt


rem �ж�pb�ļ������Ƿ����ļ�����û����ɾ��pb�ļ���
if exist pb dir/a/b "pb\" | findstr . >nul || rd pb


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
set/a speed=!total!*10000/%time3%

rem ����ʱС��1sʱ��λ��0����
set/a second=%time3:~,-2%+0
set/a unit=%speed:~,-2%+0

set /p=________________________________________________________________________________<nul
echo.
echo ������ !total! ��¼��, �ҵ� !count! ��PB, �ٶ� !unit!.%speed:~-2,2% ��/s, �ܺ�ʱ: !second!.%time3:~-2,2% s
echo.

set /p=�밴������˳�. . .
exit

:wrong
if exist pb.txt del /q pb.txt
if exist ����.txt del /q ����.txt
if exist %filename% del /q %filename%
if exist pb rd /s/q pb
echo.
pause
exit