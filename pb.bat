@echo off & setlocal enabledelayedexpansion
rem 关闭回显，设置变量延迟


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


rem 根据不同命名规则进行修改以下四个参数

rem 以字母形式代替命名规则
set "form=%%a_%%b_%%c_%%d=%%e_%%f=%%g_%%h"
rem 命名规则中的分隔符号以及字母个数
set "cut=delims==_ tokens=1-8"
rem 代表级别的字母
set "level=%%a"
rem 代表time的字母
set "score=%%c"
rem 代表bv的字母
set "bbbv=%%e"


set count=0
set total=0


rem 删除文件夹pb
if exist pb rd /s/q pb


rem 判断文件夹内是否存在avf录像
dir /b/s *.avf | findstr . >nul || goto wrong


rem 创建%filename%储存录像文件名信息（如已存在则清空文件内容，下同）
if exist Beg路径.txt del /q Beg路径.txt
if exist Int路径.txt del /q Int路径.txt
if exist Exp路径.txt del /q Exp路径.txt
if exist Cus路径.txt del /q Cus路径.txt
echo 正在获取录像文件名. . .
for /f "tokens=*" %%z in ('dir /b *.avf') do (
    rem echo %%z
    for /f "%cut%" %%a in ("%%z") do (
        if not exist %level%路径.txt cd. > %level%路径.txt
        echo %%z >> %level%路径.txt
    )
)

:level
if exist Beg路径.txt set "filename=Beg路径.txt" && goto findbbbv
if exist Int路径.txt set "filename=Int路径.txt" && goto findbbbv
if exist Exp路径.txt set "filename=Exp路径.txt" && goto findbbbv
if exist Cus路径.txt set "filename=Cus路径.txt" && goto findbbbv
goto end

:findbbbv
set /p=________________________________________________________________________________<nul
echo.
if %filename:~0,3% equ Beg echo 正在查找初级PB. . .
if %filename:~0,3% equ Int echo 正在查找中级PB. . .
if %filename:~0,3% equ Exp echo 正在查找高级PB. . .
if %filename:~0,3% equ Cus echo 正在查找自定义局PB. . .
echo.

rem 查找文件名中"3BV="所在位置
set num=0
for /f "delims=" %%a in (%filename%) do (
    set str=%%a
    :loop
    set char=!str:~%num%,4!
    set /a num=num+1
    if !char! equ 3BV^= set /a num=num+4 && goto :sort
    if !num! equ 200 cls && echo 请统一命名格式为: && echo "<mode>_<style>_<time>_3BV=<3bv>_3BVs=<3bv/s>_<name>" && goto wrong
    goto loop
)


:sort
rem 对录像名进行排序并输出到排序.txt中
sort /r /+!num! %filename% > 排序.txt
del /q %filename%


rem 创建pb.txt储存pb信息，以3BV=**为判断依据
rem bv: 录像3BV
rem result: 录像Time
rem name: 前一行录像名，无第零行所以赋初值为0
rem count:pb数
cd. > pb.txt
set bv=0
set result=0
set name=0
set count_temp=0
for /f "%cut%" %%a in (排序.txt) do (
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
            rem 打印排序异常bv
            rem echo.
            rem echo %bbbv%
        )
    )
)

del /q 排序.txt
rem start 排序.txt


rem name为%%a前一行录像名，for循环结束后补充最后一行录像名
if !bv! neq 0 (
    echo !name! >> pb.txt
    echo !name!
    set /a count+=1
    set /a count_temp+=1
)


rem 按bv大小重新排序
rem sort /+!num! pb.txt


rem 创建pb文件夹并将所有pb复制到此文件夹
if not exist pb md pb
for /f "tokens=*" %%a in (pb.txt) do (
    copy "%%a" pb > nul
)

echo.
if %filename:~0,3% equ Beg echo 共找到 !count_temp! 个初级PB
if %filename:~0,3% equ Int echo 共找到 !count_temp! 个中级PB
if %filename:~0,3% equ Exp echo 共找到 !count_temp! 个高级PB
if %filename:~0,3% equ Cus echo 共找到 !count_temp! 个自定义局PB
goto level


:end


del /q pb.txt


rem 判断pb文件夹内是否有文件，若没有则删除pb文件夹
if exist pb dir/a/b "pb\" | findstr . >nul || rd pb


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
set/a speed=!total!*10000/%time3%

rem 当耗时小于1s时个位用0补足
set/a second=%time3:~,-2%+0
set/a unit=%speed:~,-2%+0

set /p=________________________________________________________________________________<nul
echo.
echo 共查找 !total! 盘录像, 找到 !count! 个PB, 速度 !unit!.%speed:~-2,2% 盘/s, 总耗时: !second!.%time3:~-2,2% s
echo.

set /p=请按任意键退出. . .
exit

:wrong
if exist pb.txt del /q pb.txt
if exist 排序.txt del /q 排序.txt
if exist %filename% del /q %filename%
if exist pb rd /s/q pb
echo.
pause
exit