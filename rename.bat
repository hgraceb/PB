@echo off & setlocal enabledelayedexpansion

rem 记录开始运行时间
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

echo 正在重命名文件. . .
set /p=________________________________________________________________________________<nul
echo.
set count=0
for /f "tokens=*" %%a in ('dir /b *.avf') do (
	set /a count+=1
	rename.exe "%%a"
)


rem 计算运行用时
rem echo.
rem echo 开始时间：%begin%
rem echo 结束时间：%time%
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

rem 个位用0补足
set/a second=%time3:~,-2%+0
set/a unit=%speed:~,-2%+0

set /p=________________________________________________________________________________<nul
echo.
echo 共重命名文件 !count! 个, 速度 !unit!.%speed:~-2,2% 个/s, 总耗时: !second!.%time3:~-2,2% s
echo.

if exist pb.bat (
echo 10s后自动开始查找PB. . .
ping /n 4 127.0.0.1> nul
echo 8s 后自动开始查找PB. . .
ping /n 4 127.0.0.1> nul
echo 6s 后自动开始查找PB. . .
ping /n 4 127.0.0.1> nul
echo 4s 后自动开始查找PB. . .
ping /n 4 127.0.0.1> nul
echo 2s 后自动开始查找PB. . .
ping /n 4 127.0.0.1> nul

rem set /p=请按任意键开始查找PB. . .<nul
rem pause > nul

start pb.bat
)else (
set /p=请按任意键退出. . .<nul
pause >nul
)