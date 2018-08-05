:: 关闭回显，设置变量延迟
@echo off & setlocal enabledelayedexpansion



::根据不同命名规则修改以下四个参数
set "form=%%a_%%b_%%c_%%d=%%e_%%f=%%g_%%h"
set "cut=delims==_ tokens=1-8"
set "time_=%%c"
set "bv_=%%e"


::flag为文件夹内是否含有多个级别录像的判断标识
set flag=0


:: 记录开始运行时间
set/a time1=(1%time:~0,2%-100)*3600+(1%time:~3,2%-100)*60+(1%time:~6,2%-100)
if %time:~0,2% equ 0 set/a time1+=86400


:: 删除文件夹pb
if exist pb rd /s/q pb


:: 创建路径.txt储存录像文件名信息（如已存在则清空文件内容，下同）
cd. > 路径.txt
echo 正在获取录像文件名. . .
for /f "tokens=*" %%a in ('dir /b/s *.avf *.mvf *.mvr *.rmv *.rawvf') do echo %%a >> 路径.txt


:: 查找文件名中"3BV="所在位置
set num=0
for /f "delims=" %%a in (路径.txt) do (
    set str=%%a
    :loop
    set char=!str:~%num%,4!
    set /a num=num+1
    if !char! equ 3BV^= set /a num=num+4 && goto :level
    if !num! equ 200 cls && echo 录像命名不规范，请再次命名后重试 && pause
    goto loop
)


:level
:: 根据命名查找级别信息
:: 创建排序.txt，将路径.txt内每行文件名从3BV开始进行首字母逆向排序
:: 创建等待.txt，当文件夹内有多个级别录像时临时存放剩余等级录像文件名
cd. > 排序.txt
cd. > 等待.txt
for /f "delims==_" %%a in (路径.txt) do (
    set str=%%a
    goto sort
)


:sort
:: 查找一个级别的所有录像并按文件名排序写入排序.txt中
:: 剩余其他级别录像暂时存放在路径.txt中
for /f "%cut%" %%a in (路径.txt) do (
if !str! equ %%a (
echo %form% >> 等待.txt
)else (
set flag=1
echo %form% >> 排序.txt
)
)

if !flag! equ 1 copy 排序.txt 路径.txt > nul


sort /r /+!num! 等待.txt > 排序.txt
del /q 等待.txt


:: 创建pb.txt储存pb信息，以3BV=**为判断依据
:: bv: 录像3BV
:: score: 录像Time
:: name: 前一行录像名，无第零行则赋初值为0
cd. > pb.txt
set bv=0
set score=0
set name=0
for /f "%cut%" %%a in (排序.txt) do (
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
            rem 输出排序异常bv
	    rem echo %bv_%
	)
    )
)
del /q 排序.txt


:: name为%%a前一行录像名，for循环结束后才为最后一行录像名
if !bv! neq 0 (
    echo !name! >> pb.txt
    echo !name!
)


:: 创建pb文件夹并将所有pb复制到此文件夹
if not exist pb md pb
echo 正在复制录像到文件夹. . .
for /f "tokens=*" %%a in (pb.txt) do (
    copy "%%a" pb > nul
)
del /q pb.txt

if !flag! equ 1 (
set flag=0
echo.
echo 切换级别查找pb. . .
goto level
)


del /q 路径.txt


:: 计算运行用时
set/a time2=(1%time:~0,2%-100)*3600+(1%time:~3,2%-100)*60+(1%time:~6,2%-100)
if %time:~0,2% equ 0 set/a time2+=86400
set/a time3=%time2%-%time1%
echo.
echo pb查找结束，耗时: %time3%秒
echo.

pause