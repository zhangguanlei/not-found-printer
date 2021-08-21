@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
rem ����ѭ�����ʱ��ͼ��ķ���
rem ��clearCache�� �Ƿ������ӡ������(1�� 0��)
rem ��secs��	�������ִ��һ������
rem ��srvname��     ��Ҫ������������
rem ��dirPath��	��ӡ�������ļ��е�ַ

set clearCache=1
set secs=5
set srvname="Print Spooler"
set dirPath=C:\Windows\System32\spool\PRINTERS\*.*
echo.

echo ==========================================

echo ==      ��ѯ��ӡ������ǰ����״̬      ==

echo ==========================================

echo.

echo �˽ű����ķ����ǣ�%srvname%

echo.

if %srvname%. == . goto end

if %clearCache% == 1 echo ===�����ӡ������===
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
		echo �������ӡ����
		echo.
	)else (
		echo.
		echo ---���������ӡ����---
		del %dirPath% /Q
		goto :loop
	)
)
echo ===��ӡ��״̬��ѯ���===
echo.
:chkit

set svrst=0

for /F "tokens=1* delims= " %%a in ('net start') do if /I "%%a %%b" == %srvname% set svrst=1

if %svrst% == 0 (
	echo ��%srvname%������δ������������...
	net start %srvname%
) else (
	echo ��������÷������������С�
	echo.
	echo 1�����÷������������С��������³��Դ�ӡ����
	echo.
	echo 2����������ܴ�ӡ���򿪡�������塿�ҵ����豸���ӡ�����鿴��ӡ������������Ƿ�����(�·��д�ӡ���豸��Ϣ���)
	echo.
	echo ===��ǰ���Դ�ӡ���豸��Ϣ===
	echo.
	echo ���ֱ����Ӧ����
	echo 0 (unknown)��ӡ������Ĵ���״̬δ֪��
	echo 1 (����)��ӡ�����ڿ���״̬������׼���ý����µĴ�ӡ��ҵ��
	echo 2 (����)��ӡ����ǰ���ڴ�����ӡ��ҵ�����������ʱ�����κι������ҵ��
	echo 3 (ֹͣ)��ӡ���������� (���磬�ڻֽ����ȱֽ) �������ڽ������֮ǰ�޷�������ǰ�Ĵ�ӡ��ҵ��
	echo �й���ϸ��Ϣ������� https://docs.microsoft.com/zh-cn/graph/api/resources/printerstatus?view=graph-rest-beta
	echo.
	for /f "tokens=1,* delims==" %%a in ('wmic printer list brief') do (
	     echo .%%a
	)
	echo.
	cmd
	goto end
)

set svrst=

rem ���������������ʱ��������ܻᵼ��cpu�����������ء�

ping -n %secs% 127.0.0.1 > nul

goto chkit

:end
