:: �رջ��ԣ����ñ����ӳ�
@echo off & setlocal enabledelayedexpansion



::���ݲ�ͬ���������޸������ĸ�����
set "form=%%a_%%b_%%c_%%d=%%e_%%f=%%g_%%h"
set "cut=delims==_ tokens=1-8"
set "time_=%%c"
set "bv_=%%e"


::flagΪ�ļ������Ƿ��ж������¼����жϱ�ʶ
set flag=0


:: ��¼��ʼ����ʱ��
set/a time1=(1%time:~0,2%-100)*3600+(1%time:~3,2%-100)*60+(1%time:~6,2%-100)
if %time:~0,2% equ 0 set/a time1+=86400


:: ɾ���ļ���pb
if exist pb rd /s/q pb


:: ����·��.txt����¼���ļ�����Ϣ�����Ѵ���������ļ����ݣ���ͬ��
cd. > ·��.txt
echo ���ڻ�ȡ¼���ļ���. . .
for /f "tokens=*" %%a in ('dir /b/s *.avf *.mvf *.mvr *.rmv *.rawvf') do echo %%a >> ·��.txt


:: �����ļ�����"3BV="����λ��
set num=0
for /f "delims=" %%a in (·��.txt) do (
    set str=%%a
    :loop
    set char=!str:~%num%,4!
    set /a num=num+1
    if !char! equ 3BV^= set /a num=num+4 && goto :level
    if !num! equ 200 cls && echo ¼���������淶�����ٴ����������� && pause
    goto loop
)


:level
:: �����������Ҽ�����Ϣ
:: ��������.txt����·��.txt��ÿ���ļ�����3BV��ʼ��������ĸ��������
:: �����ȴ�.txt�����ļ������ж������¼��ʱ��ʱ���ʣ��ȼ�¼���ļ���
cd. > ����.txt
cd. > �ȴ�.txt
for /f "delims==_" %%a in (·��.txt) do (
    set str=%%a
    goto sort
)


:sort
:: ����һ�����������¼�񲢰��ļ�������д������.txt��
:: ʣ����������¼����ʱ�����·��.txt��
for /f "%cut%" %%a in (·��.txt) do (
if !str! equ %%a (
echo %form% >> �ȴ�.txt
)else (
set flag=1
echo %form% >> ����.txt
)
)

if !flag! equ 1 copy ����.txt ·��.txt > nul


sort /r /+!num! �ȴ�.txt > ����.txt
del /q �ȴ�.txt


:: ����pb.txt����pb��Ϣ����3BV=**Ϊ�ж�����
:: bv: ¼��3BV
:: score: ¼��Time
:: name: ǰһ��¼�������޵������򸳳�ֵΪ0
cd. > pb.txt
set bv=0
set score=0
set name=0
for /f "%cut%" %%a in (����.txt) do (
    if !bv! neq %bv_% (
	if !bv! neq 0 (
	echo !name!>> pb.txt
	echo !name!
    )
    set bv=%bv_%
    set score=%time_%
    set name=%form%
    )else (
	if !score! geq %time_% (
	    set score=%time_%
	    set name=%form%
            rem ��������쳣bv
	    rem echo %bv_%
	)
    )
)
del /q ����.txt


:: nameΪ%%aǰһ��¼������forѭ���������Ϊ���һ��¼����
if !bv! neq 0 (
    echo !name! >> pb.txt
    echo !name!
)


:: ����pb�ļ��в�������pb���Ƶ����ļ���
if not exist pb md pb
echo ���ڸ���¼���ļ���. . .
for /f "tokens=*" %%a in (pb.txt) do (
    copy "%%a" pb > nul
)
del /q pb.txt

if !flag! equ 1 (
set flag=0
echo.
echo �л��������pb. . .
goto level
)


del /q ·��.txt


:: ����������ʱ
set/a time2=(1%time:~0,2%-100)*3600+(1%time:~3,2%-100)*60+(1%time:~6,2%-100)
if %time:~0,2% equ 0 set/a time2+=86400
set/a time3=%time2%-%time1%
echo.
echo pb���ҽ�������ʱ: %time3%��
echo.

pause