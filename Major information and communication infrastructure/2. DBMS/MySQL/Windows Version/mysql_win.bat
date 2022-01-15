@echo. > %COMPUTERNAME%-MYSQL-result.txt
::@mode con: cols=80 lines=30
@setlocal
@echo off

echo (ex: C:\Program Files\MySQL\MySQL Server 5.6)
set /p installdir=[INPUT MY-SQL Installed Directory] : 
		::set SQLCMD=%installdir%/bin/mysql

set /p admid=[INPUT MY-SQL ID]  : 
set /p admpwd=[INPUT MY-SQL PWD] : 

::sql�������� ���� ���� path ����
set currentdir="%cd%"
mkdir if_mytmp
set TmpFilePath=%currentdir%\if_mytmp

::sql ������ �̿�(���� üũ ��)�� �� ����path ���� (for���ȿ� "���� ���������� ���� ������)
set currentdir_re=%cd%
set "tmpp=%currentdir_re%\if_mytmp"

::@echo %currentdir_re% >> %COMPUTERNAME%-MYSQL-result.txt
::@echo tmpp�� %tmpp% >> %COMPUTERNAME%-MYSQL-result.txt

set SQLCMD="%installdir%/bin/mysql" -u%admid% -p%admpwd%

::����üũ
%SQLCMD% -e "select version();" -t > %TmpFilePath%\if_mv.txt
type %TmpFilePath%\if_mv.txt | find /V "+" | find /I /V "version" > %TmpFilePath%\if_mvre.txt 


::@type %TmpFilePath%\if_mvre.txt >> %COMPUTERNAME%-MYSQL-result.txt


::������ / mysql goto �������� ����
type %TmpFilePath%\if_mvre.txt | find /I "maria"
IF NOT ERRORLEVEL 1 (
		goto mariadb01
)	ELSE (
		goto mysql01
)


::������ ��������
:mariadb01
for /f "usebackq delims=|" %%i in ("%tmpp%\if_mvre.txt") do set mvrere=%%i
if "%mvrere:~1,4%"=="5.5." (
	set myVer=1
	set myVer_name=MariaDB 5.5
) else if "%mvrere:~1,4%"=="10.1" (
	set myVer=1
	set myVer_name=MariaDB 10.1
) else if "%mvrere:~1,4%"=="10.2" (
	set myVer=1
	set myVer_name=MariaDB 10.2
) else (
	set myVer=1
	set myVer_name=MariaDB etc
)

::������ ���� �� mysql�� �ٽ� ���� �ʰ� ����
type %TmpFilePath%\if_mvre.txt | find /I "maria"
IF NOT ERRORLEVEL 1 goto jump1

::MySQL ��������
:mysql01
for /f "usebackq delims=|" %%i in ("%tmpp%\if_mvre.txt") do set mvrere=%%i
if "%mvrere:~1,3%"=="5.5" (
	set myVer=2
	set myVer_name=MySQL 5.5
) else if "%mvrere:~1,3%"=="5.6" (
	set myVer=3
	set myVer_name=MySQL 5.6
) else if "%mvrere:~1,3%"=="5.7" (
	set myVer=4
	set myVer_name=MySQL 5.7
) else if "%mvrere:~1,3%"=="8.0" (
	set myVer=8
	set myVer_name=MySQL 8.0
) else (
	set myVer=1
	set myVer_name=MySQL etc
)

:jump1

::echo %myVer% >> %COMPUTERNAME%-MYSQL-result.txt
::echo %myVer_name% >> %COMPUTERNAME%-MYSQL-result.txt

::@echo currentdir�� %currentdir% �Դϴ�. >> %COMPUTERNAME%-MYSQL-result.txt
::@echo TmpFilePath�� %TmpFilePath% �Դϴ�. >> %COMPUTERNAME%-MYSQL-result.txt
::@echo TmpFilePath_re�� %TmpFilePath_re% �Դϴ�. >> %COMPUTERNAME%-MYSQL-result.txt

@echo.
set DBVersion=0.6.3
@echo MYSQL Security check                                                                    >> %COMPUTERNAME%-MYSQL-result.txt
@color 9f
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo ��������������������               MY-SQL Security Check            ��������������������� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##############################  Start Time ##################################
@echo �������������������������������������  Start Time  �������������������������������������  >> %COMPUTERNAME%-MYSQL-result.txt
@date /t                                                                                      >> %COMPUTERNAME%-MYSQL-result.txt
@time /t                                                                                      >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ###############################  Interface Information  ############################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
ipconfig /all                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       1. ���� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt







@echo D-01 START
@echo D-01 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-01 �⺻ ������ �н�����, ��å ���� �����Ͽ� ��� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �⺻ ������ �н����带 �����Ͽ� ����ϴ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

:: mysql 5.7 �̻�
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string from mysql.user where user='root';" -t > %TmpFilePath%\1_1.txt
) else (
	%SQLCMD% -e "select host, user, password from mysql.user where user='root';" -t > %TmpFilePath%\1_1.txt
)

find "+" %TmpFilePath%\1_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ���� ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-01 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo �ش� ȣ��Ʈ�� ���Ͽ� Null User/Password�� ���ǰ� �ִٸ� Null User�� �н����� ���� �� �����Ͽ��� �մϴ�. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt







@echo D-02 START
@echo D-02 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-02 scott �� Demonstration �� ���ʿ� ������ �����ϰų� ��� ���� �� ��� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���� ������ Ȯ���Ͽ� ���ʿ��� ������ ���� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user where user!='root';" -t > %TmpFilePath%\1_2.txt
find "+" %TmpFilePath%\1_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo root���� �̿��� ������ �������� ����(���� ��� ����) >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-02 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ������� �ʰų� ���ʿ��� ������ ������� �����Ͽ��� �մϴ�. >> %COMPUTERNAME%-MYSQL-result.txt
@echo Anonymous ����(user �÷��� ��ĭ)�� �����ϰ�, �н����尡 �����Ǿ� ���� ������ DB�� ���� ������ ������. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-03 START
@echo D-03 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-03 �н������� ���Ⱓ �� ���⵵ ��� ��å�� �µ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �н����带 �ֱ������� �����ϰ�, �н����� ��å�� ����Ǿ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo ���� ������ %myVer_name%�Դϴ�. ������ ���� ���ͺ� �ʿ� >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin�� 5.6 �̻� ����Ʈ�� ������(password_length, policy �� Ȯ�� ����)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked�÷��� 5.7�̻� ���� >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� Plugin ��� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\1_3_1.txt
type %TmpFilePath%\1_3_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� validate_password Plugin Ȱ��ȭ ���� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\1_3_0.txt
find "+" %TmpFilePath%\1_3_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\1_3_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin ��Ȱ��ȭ >> %COMPUTERNAME%-MYSQL-result.txt
)

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� �н����� ���� ���� �Ķ����(plugin ����) >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%vali%%';" -t > %TmpFilePath%\1_3_2.txt
type %TmpFilePath%\1_3_2.txt | find /V "query_cache" >> %COMPUTERNAME%-MYSQL-result.txt

::MySQL 5.7�̻�
echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� �н����� ����, ��������, ������� �� �÷� >> %COMPUTERNAME%-MYSQL-result.txt
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > %TmpFilePath%\1_3_3.txt
	type %TmpFilePath%\1_3_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo �� 5.7�̸� �ش� �÷� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-03 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "v5.6 �̸��� ���ͺ�" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "v5.6 �̻󿡼� validate_password Plugin ���� ����(�Ʒ��� �����ϸ� ��ȣ))" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_length 8 (�̻�)" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_mixed_case_count 1" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_number_count 1" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_policy MEDIUM" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "LOW (8�� �̻�), MEDIUM (�⺻ 8�� �̻�,����,�ҹ���,�빮��,Ư�����ڸ� ����), STRONG(�⺻ 8�� �̻�,����,�ҹ���,�빮��,Ư������,�����ܾ� ����)" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_special_char_count 1" >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-04 START
@echo D-04 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-04 �����ͺ��̽� ������ ������ �� �ʿ��� ���� �� �׷쿡 ��� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ������ �����ڱ����� ���� �ο� �Ǿ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user,select_priv,insert_priv,Delete_priv from mysql.user where (select_priv='Y' or insert_priv='Y' or delete_priv='Y') and user<>'root';" -t > %TmpFilePath%\1_4.txt
find "+" %TmpFilePath%\1_4.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_4.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo select_priv, insert_priv, delete_priv ������ �ο��� ������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-04 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 'root�� ������ �Ϲݰ����� select_priv, insert_priv, delete_priv���� ���� �ο��Ǿ��ִ��� Ȯ�� ��, �ο��� ������ ���Ͽ� Ÿ�缺 ���� �� ���ʿ�� ������ ȸ���Ͽ��� ��' >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-05 START
@echo D-05 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-05 �н����� ���뿡 ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX �Ķ���� ������ ����� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-05 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-06 START
@echo D-06 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-06 DB ����� ���� ������ �ο� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ����ں� ������ ����ϰ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\1_6.txt
find "+" %TmpFilePath%\1_6.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_6.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo "������ �������� ����(���� ��� ����)" >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-06 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo '������� ��� ����' >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-07 START
@echo D-07 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-07 ���ݿ��� DB �������� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���� IP �� ��Ʈ�� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.user���̺� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\1_7_1.txt
find "+" %TmpFilePath%\1_7_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_7_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.db���̺� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.db;" -t > %TmpFilePath%\1_7_2.txt
find "+" %TmpFilePath%\1_7_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_7_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-07 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo host �׸� ���� %% ������ �Ǿ� �ִ� ��� ��� IP�� ���� ������ ���������� �����Ͽ��� ��. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-08 START
@echo D-08 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-08 DBA�̿��� �ΰ����� ���� ����� �ý��� ���̺� ���� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: DBA�� ���� ������ ���̺� �Ϲ� ����� ������ �Ұ��� �� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql User ����] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user,select_priv from mysql.user where select_priv='Y' and user<>'root';" -t > %TmpFilePath%\1_8_1.txt
find "+" %TmpFilePath%\1_8_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_8_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql User�� select������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql DB ����] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user, db, select_priv from mysql.db where (db='mysql' and select_priv='Y') and user<>'root';" -t > %TmpFilePath%\1_8_2.txt
find "+" %TmpFilePath%\1_8_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_8_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql DB�� select ������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql Table ����] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select DB,USER,TABLE_NAME, TABLE_PRIV from mysql.tables_priv where (db='mysql' and table_name='user') and table_priv='select';" -t > %TmpFilePath%\1_8_3.txt
find "+" %TmpFilePath%\1_8_3.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_8_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql Table�� select ������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-08 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo "root�� ������ �Ϲݰ����� select������ �ο��Ǿ��ִ��� Ȯ�� ��, �ο��� ������ ���Ͽ� Ÿ�缺 ���� �� ���ʿ�� ������ ȸ���Ͽ��� ��."  >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-09 START
@echo D-09 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-09 ����Ŭ �����ͺ��̽��� ��� ������ �н����� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: Listener�� �н����尡 �����Ǿ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-09 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-10 START
@echo D-10 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-10 ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���ʿ��� ODBC/OLE-DB�� ��ġ���� ���� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 2>nul
if errorlevel 1 (
	echo ���ʿ��� ODBC/OLE-DB�� ��ġ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" >> %COMPUTERNAME%-MYSQL-result.txt
)
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-10 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-11 START
@echo D-11 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-11 ���� Ƚ���� �α��� ���� �� ��� ��å ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �α��� �õ� Ƚ���� �����ϴ� ���� ������ ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo "MySQL���� �ش� ��� �������� ����(N/A)" >> %COMPUTERNAME%-MYSQL-result.txt
echo "��, �ַ��, Ʈ���� ���� �̿��� ��� ��� ���� ����" >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-11 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-12 START
@echo D-12 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-12 �����ͺ��̽��� �ֿ� ���� ��ȣ ���� ���� DB ������ umask�� 022�̻����� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ������ umask�� 022 �̻����� �����Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo Win MySQL �ش���� ���� (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-12 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-13 START
@echo D-13 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-13 �����ͺ��̽��� �ֿ� ��������, �н����� ���� �� �ֿ� ���ϵ��� ���� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �ֿ� ���� ���� �� ���͸��� �۹̼� ������ �Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysqld.exe���� cacls                                                           >> %COMPUTERNAME%-MYSQL-result.txt
cacls "%installdir%/bin/mysqld.exe"                                                           >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.exe���� cacls                                                           >> %COMPUTERNAME%-MYSQL-result.txt
cacls "%installdir%/bin/mysql.exe"                                                            >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo my.ini���� cacls                                                           >> %COMPUTERNAME%-MYSQL-result.txt
cacls "%installdir%/my.ini"                                                           	      >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-13 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-14 START
@echo D-14 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-14 ������ �̿��� ����ڰ� ����Ŭ �������� ������ ���� ������ �α� �� trace ���Ͽ� ���� ���� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �ֿ� ���� ���� �� �α� ���Ͽ� ���� �۹̼��� �����ڷ� ������ ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-14 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-15 START
@echo D-15 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-15 �������α׷� �Ǵ� DBA ������ Role�� Public���� �������� �ʵ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: DBA ������ Role�� Public���� �����Ǿ����� ���� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-15 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-16 START
@echo D-16 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-16 OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES�� FALSE�� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES������ FALSE�� �Ǿ��ִ� ���>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-16 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-17 START
@echo D-17 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-17 �н����� Ȯ���Լ��� �����Ǿ� ����Ǵ°� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �н����� ���� �Լ��� ������ ����Ǵ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo ���� ������ %myVer_name%�Դϴ�. ������ ���� ���ͺ� �ʿ� >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin�� 5.6 �̻� ����Ʈ�� ������(password_length, policy �� Ȯ�� ����)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked�÷��� 5.7�̻� ���� >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� Plugin ��� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\1_3_1.txt
type %TmpFilePath%\1_3_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� validate_password Plugin Ȱ��ȭ ���� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\1_3_0.txt
find "+" %TmpFilePath%\1_3_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\1_3_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin ��Ȱ��ȭ >> %COMPUTERNAME%-MYSQL-result.txt
)

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� �н����� ���� ���� �Ķ����(plugin ����) >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%vali%%';" -t > %TmpFilePath%\1_3_2.txt
type %TmpFilePath%\1_3_2.txt | find /V "query_cache" >> %COMPUTERNAME%-MYSQL-result.txt

::MySQL 5.7�̻�
echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� �н����� ����, ��������, ������� �� �÷� >> %COMPUTERNAME%-MYSQL-result.txt
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > %TmpFilePath%\1_3_3.txt
	type %TmpFilePath%\1_3_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo �� 5.7�̸� �ش� �÷� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-17 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-18 START
@echo D-18 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-18 �ΰ����� ���� Object Owner�� �������� �ʴ°� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: Object Owner �� ������ SYS, SYSTEM, ������ ���� ������ ���ѵ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-18 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-19 START
@echo D-19 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-19 grant option�� role�� ���� �ο��ǵ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: WITH_GRANT_OPTION�� ROLE�� ���Ͽ� �����Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "SELECT user,grant_priv FROM mysql.user;" -t > %TmpFilePath%\1_19.txt
find "+" %TmpFilePath%\1_19.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_19.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-19 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-20 START
@echo D-20 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-20 �����ͺ��̽��� �ڿ� ���� ����� TRUE�� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: RESOURCE_LIMIT ������ TRUE�� �Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-20 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-21 START
@echo D-21 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-21 �����ͺ��̽��� ���� �ֽ� ������ġ�� ��� �ǰ� ������ ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ������ �ֽ� ��ġ�� ������ ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select version();" -t > %TmpFilePath%\1_21.txt
type %TmpFilePath%\1_21.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-21 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "2017�� 1�� ����" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 8.0 development" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 5.7 GA" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 5.6 GA" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 5.5 GA" >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-22 START
@echo D-22 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-22 �����ͺ��̽��� ����, ����, ���� ���� �������� ����� ������ ��å�� �����ϵ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: DBMS�� ���� �α� ���� ��å�� �����Ǿ� ������, ��å�� ����Ǿ��ִ� ��� >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo �� case1. mysql ���� logging ��� Ȯ�� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables where Variable_name in ('version', 'log', 'general_log', 'general_log_file', 'log_error', 'log_output', 'slow_query_log', 'slow_query_log_file');" -t > %TmpFilePath%\1_22_1.txt
type %TmpFilePath%\1_22_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo �� case2. my.ini ���� Ȯ��							                                     >> %COMPUTERNAME%-MYSQL-result.txt
IF EXIST "%installdir%"\my.ini (
	type "%installdir%"\my.ini | findstr /V "^#" | findstr .               					 >> %COMPUTERNAME%-MYSQL-result.txt
) ELSE (
	echo "%installdir%"��ο� my.ini �������� ����.                            				 >> %COMPUTERNAME%-MYSQL-result.txt
)

echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo �� case3. audit_log plugin ��� Ȯ�� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show plugins;" -t > %TmpFilePath%\1_22_2.txt
type %TmpFilePath%\1_22_2.txt | findstr /I "name audit_log" >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo �� case3. Ȯ�� �Ұ� �� �ַ�� ��� ���� ���ͺ� >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-22 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-23 START
@echo D-23 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-23 ���ȿ� ������� ���� ������ �����ͺ��̽��� ����ϰ� �ִ°� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���� ��ġ�� �����Ǵ� ������ ����ϴ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select version();" -t > %TmpFilePath%\1_21.txt
type %TmpFilePath%\1_21.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-23 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-24 START
@echo D-24 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-24 Audit Table�� �����ͺ��̽� ������ ������ ���� �ֵ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: Audit Table ���� ������ ������ �������� ������ ��� >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
::%SQLCMD% -e "select table_schema, table_name from information_schema.tables where table_name='%%aud%%'" -t >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-24 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt





@echo.
@echo.
@echo END_RESULT                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ###############                   SYSTEM ���� ���                 #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
systeminfo                                                                                   >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo #############                      my.ini ���                    #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
IF EXIST "%installdir%"\my.ini (
	type "%installdir%"\my.ini > %TmpFilePath%\if_my_ini.txt
	type %TmpFilePath%\if_my_ini.txt >> %COMPUTERNAME%-MYSQL-result.txt
) ELSE (
	echo "%installdir%"��ο� my.ini �������� ����.                            				 >> %COMPUTERNAME%-MYSQL-result.txt
)
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo #############  �αװ��� ���� ��� (show global variables like '%%log%%';) #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%log%%';" -t > %TmpFilePath%\if_logv.txt
type %TmpFilePath%\if_logv.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ###############                �÷����� ���(show plugins;)        #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
type %TmpFilePath%\1_22_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt





@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ###############       datadir(show global variables like 'datadir';)      #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like 'datadir';" -t > %TmpFilePath%\if_datadir.txt
echo datadir ��� >> %COMPUTERNAME%-MYSQL-result.txt
type %TmpFilePath%\if_datadir.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo datadir ��� �� dir  >> %COMPUTERNAME%-MYSQL-result.txt
type %TmpFilePath%\if_datadir.txt | find /I "datadir" > %TmpFilePath%\if_datadir_re.txt
for /F "usebackq tokens=2 delims=|" %%a in ("%tmpp%\if_datadir_re.txt") do dir %%a >> %COMPUTERNAME%-MYSQL-result.txt 2>nul
::for /F "usebackq tokens=2 delims=|" %%a in ("%tmpp%\if_datadir_re.txt") do set dirtmp=^"%%a^"
::set dirtmp=%dirtmp: =%
::dir %dirtmp% >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo �������������������������������������   END Time  �������������������������������������   >> %COMPUTERNAME%-MYSQL-result.txt
@date /t                                                                                      >> %COMPUTERNAME%-MYSQL-result.txt
@time /t                                                                                      >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##############################   END Time ###################################
@echo.
@echo.

pause
EXIT