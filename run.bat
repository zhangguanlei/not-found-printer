@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
rem 定义循环间隔时间和监测的服务：
rem 【clearCache】 是否清除打印机缓存(1是 0否)
rem 【secs】	间隔几秒执行一次启动
rem 【srvname】     需要启动服务名称
rem 【dirPath】	打印机缓存文件夹地址

set clearCache=1
set secs=5
set srvname="Print Spooler"
set dirPath=C:\Windows\System32\spool\PRINTERS\*.*
echo.

echo ==========================================

echo ==      查询打印机服务当前运行状态      ==

echo ==========================================

echo.

echo 此脚本监测的服务是：%srvname%

echo.

if %srvname%. == . goto end

if %clearCache% == 1 echo ===清除打印机缓存===
:loop
set dirFlag=0
if %clearCache% == 1 (
	net stop %srvname%
	ping -n 2 127.0.0.1 >nul
	for /F "tokens=1* delims= " %%s in ( 'dir /b %dirPath%') do (
		echo %%s
		set dirFlag=1
	)
	if !dirFlag! == 0 (
		echo.
		echo 已清除打印缓存
		echo.
	)else (
		echo.
		echo ---正在清除打印缓存---
		del %dirPath% /Q
		goto :loop
	)
)
echo ===打印机状态查询结果===
echo.
:chkit

set svrst=0

for /F "tokens=1* delims= " %%a in ('net start') do if /I "%%a %%b" == %srvname% set svrst=1

if %svrst% == 0 (
	echo 【%srvname%】服务未启动，启动中...
	net start %srvname%
) else (
	echo 结果：【该服务正常运行中】
	echo.
	echo 1、【该服务正常运行中】可以重新尝试打印服务
	echo.
	echo 2、如果还不能打印，打开【控制面板】找到【设备与打印机】查看打印机与电脑连接是否正常(下方有打印机设备信息输出)
	echo.
	echo ===当前电脑打印机设备信息===
	echo.
	echo 数字编码对应含义
	echo 0 (unknown)打印机报告的处理状态未知。
	echo 1 (待机)打印机处于空闲状态，并已准备好接受新的打印作业。
	echo 2 (处理)打印机当前正在处理打印作业，并将在完成时处理任何挂起的作业。
	echo 3 (停止)打印机遇到问题 (例如，在活动纸盒中缺纸) ，并且在解决问题之前无法继续当前的打印作业。
	echo 有关详细信息，请参阅 https://docs.microsoft.com/zh-cn/graph/api/resources/printerstatus?view=graph-rest-beta
	echo.
	for /f "tokens=1,* delims==" %%a in ('wmic printer list brief') do (
	     echo .%%a
	)
	echo.
	cmd
	goto end
)

set svrst=

rem 下面的命令用于延时，否则可能会导致cpu单个核心满载。

ping -n %secs% 127.0.0.1 > nul

goto chkit

:end