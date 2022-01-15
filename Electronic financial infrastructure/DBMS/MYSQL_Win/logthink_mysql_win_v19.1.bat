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
set DBVersion=19.1
set Last_modify=2019.02

@echo MYSQL Security check                                                                    >> %COMPUTERNAME%-MYSQL-result.txt
@echo Copyright (c) 2019 SK think Co. Ltd. All right Reserved                                >> %COMPUTERNAME%-MYSQL-result.txt
@color 9f
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo �����������������               MY-SQL Security Check(2019)            ������������������ >> %COMPUTERNAME%-MYSQL-result.txt
@echo �����������������                      SK think                      ������������������ >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo SCRIPT_VERSION %DBVersion%                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo LAST_UPDATE %Last_modify%                                                               >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ##########################       1. ����� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo 0101 START
@echo 0101 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ���ΰ����� ���� ������ ���� ����� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���� ������ Ȯ���Ͽ� ���ʿ��� ������ ���� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user where user!='root';" -t > %TmpFilePath%\1_1.txt
find "+" %TmpFilePath%\1_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo root���� �̿��� ������ �������� ����(���� ��� ����) >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo 0101 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ������� �ʰų� ���ʿ��� ������ ������� �����Ͽ��� �մϴ�. >> %COMPUTERNAME%-MYSQL-result.txt
@echo Anonymous ����(user �÷��� ��ĭ)�� �����ϰ�, �н����尡 �����Ǿ� ���� ������ DB�� ���� ������ ������. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0102 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0102 START
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �α��� ���� Ƚ���� ���� ��ݽð� �� ���� ��� ��å ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �α��� �õ� Ƚ���� �����ϴ� ���� ������ ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo "MySQL���� �ش� ��� �������� ����(N/A)" >> %COMPUTERNAME%-MYSQL-result.txt
echo "��, �ַ��, Ʈ���� ���� �̿��� ��� ��� ���� ����" >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0102 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0103 START
@echo 0103 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  SYSDBA �α��� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: root �н����尡 null�� �����Ǿ��ִ� ��� ���>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo "MySQL root �н����� null ���� Ȯ��" >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user, password from mysql.user;" -t > %TmpFilePath%\1_3_1.txt
type %TmpFilePath%\1_3_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user, password from mysql.user where user='root';" -t > %TmpFilePath%\1_3_2.txt
type %TmpFilePath%\1_3_2.txt >> %COMPUTERNAME%-MYSQL-result.txt


@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0103 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo. 


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       2. ���� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0201 START
@echo 0201 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �н����� ���뿡 ���� ������ ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX �Ķ���� ������ ����� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0201 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0202 START
@echo 0202 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  DB ����� ������ ���������� �ο� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ����ں� ������ ����ϰ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\2_2.txt
find "+" %TmpFilePath%\2_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\2_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo "������ �������� ����(���� ��� ����)" >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0202 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
echo '������� ��� ����' >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       3. ��й�ȣ ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0301 START
@echo 0301 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ���߰����� ��й�ȣ ��������(DB����) >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ��й�ȣ ���� ���� ������ �������� ���� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "���ͺ�-����� ���ͺ並 ���� ���� ������ �н����带 ����ϴ��� ���� ����" >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0301 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0302 START
@echo 0302 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �⺻ ���� �� �н����� ����(����Ʈ ID �� �н����� ���� �� ���) >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �⺻ ������ �н����带 �����Ͽ� ����ϴ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

:: mysql 5.7 �̻�
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string from mysql.user where user='root';" -t > %TmpFilePath%\3_2.txt
) else (
	%SQLCMD% -e "select host, user, password from mysql.user where user='root';" -t > %TmpFilePath%\3_2.txt
)

find "+" %TmpFilePath%\3_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\3_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ���� ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0302 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo �ش� ȣ��Ʈ�� ���Ͽ� Null User/Password�� ���ǰ� �ִٸ� Null User�� �н����� ���� �� �����Ͽ��� �մϴ�. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0303 START
@echo 0303 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ��й�ȣ ���⵵ ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����:  ��й�ȣ ���⵵ ������ �Ǿ� �ְų�, ���� �ַ���� ���Ͽ� ���⵵ ������ �����Ǵ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo ���� ������ %myVer_name%�Դϴ�. ������ ���� ���ͺ� �ʿ� >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin�� 5.6 �̻� ����Ʈ�� ������(password_length, policy �� Ȯ�� ����)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked�÷��� 5.7�̻� ���� >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� Plugin ��� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\3_3_1.txt
type %TmpFilePath%\3_3_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� validate_password Plugin Ȱ��ȭ ���� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\3_3_0.txt
find "+" %TmpFilePath%\3_3_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\3_3_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin ��Ȱ��ȭ >> %COMPUTERNAME%-MYSQL-result.txt
)

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� �н����� ���� ���� �Ķ����(plugin ����) >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%vali%%';" -t > %TmpFilePath%\3_3_2.txt
type %TmpFilePath%\3_3_2.txt | find /V "query_cache" >> %COMPUTERNAME%-MYSQL-result.txt
 
 
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0303 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0304 START
@echo 0304 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ��й�ȣ�� �ֱ����� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �н����带 �ֱ������� �����ϰ�, �н����� ��å�� ����Ǿ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
 
echo ���� ������ %myVer_name%�Դϴ�. ������ ���� ���ͺ� �ʿ� >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin�� 5.6 �̻� ����Ʈ�� ������(password_length, policy �� Ȯ�� ����)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked�÷��� 5.7�̻� ���� >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� Plugin ��� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\3_4_1.txt
type %TmpFilePath%\3_4_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� validate_password Plugin Ȱ��ȭ ���� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\3_4_0.txt
find "+" %TmpFilePath%\3_4_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\3_4_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin ��Ȱ��ȭ >> %COMPUTERNAME%-MYSQL-result.txt
)

::MySQL 5.7�̻�
echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo �� �н����� ����, ��������, ������� �� �÷� >> %COMPUTERNAME%-MYSQL-result.txt
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > %TmpFilePath%\3_4_3.txt
	type %TmpFilePath%\3_4_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo �� 5.7�̸� �ش� �÷� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0304 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
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



@echo 0305 START
@echo 0305 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  listener ��й�ȣ ���� �� ����Ʈ ��Ʈ ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: listener�� ��й�ȣ ������ ���������� �Ǿ� �ְ�, ����Ʈ ��Ʈ��ȣ�� �ƴ� ���>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0305 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       4. ���� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0401 START
@echo 0401 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  DBA�̿��� �ΰ����� ���� ����ڰ� �ý��� ���̺� ������ �� ������ ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: DBA�� ���� ������ ���̺� �Ϲ� ����� ������ �Ұ��� �� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql User ����] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user,select_priv from mysql.user where select_priv='Y' and user<>'root';" -t > %TmpFilePath%\4_1_1.txt
find "+" %TmpFilePath%\4_1_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\4_1_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql User�� select������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql DB ����] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user, db, select_priv from mysql.db where (db='mysql' and select_priv='Y') and user<>'root';" -t > %TmpFilePath%\4_1_2.txt
find "+" %TmpFilePath%\4_1_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\4_1_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql DB�� select ������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql Table ����] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select DB,USER,TABLE_NAME, TABLE_PRIV from mysql.tables_priv where (db='mysql' and table_name='user') and table_priv='select';" -t > %TmpFilePath%\4_1_3.txt
find "+" %TmpFilePath%\4_1_3.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\4_1_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql Table�� select ������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0401 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "root�� ������ �Ϲݰ����� select������ �ο��Ǿ��ִ��� Ȯ�� ��, �ο��� ������ ���Ͽ� Ÿ�缺 ���� �� ���ʿ�� ������ ȸ���Ͽ��� ��."  >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0402 START
@echo 0402 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���ʿ��� ODBC/OLE-DB�� ��ġ���� ���� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL �ش���� ���� (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt                                                                                       >> %COMPUTERNAME%-MYSQL-result.txt

@echo 0402 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0403 START
@echo 0403 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �����ͺ��̽��� �ֿ� ��������, �н����� ���� �� �ֿ� ���ϵ��� ���� ���� ������ ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �ֿ� ���� ���� �� ���͸��� �۹̼� ������ �Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL �ش���� ���� (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt                                                                                       >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0403 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0404 START
@echo 0404 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �����ͺ��̽��� �ֿ� ���� ��ȣ ���� ���� DB ������ umask ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ������ umask�� 022 �̻����� �����Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo Win MySQL �ش���� ���� (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0404 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0405 START
@echo 0405 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ����Ŭ ������ �α� �� trace ���Ͽ� ���� ���ϱ��� ������ ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �ֿ� ���� ���� �� �α� ���Ͽ� ���� �۹̼��� �����ڷ� ������ ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0405 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       5. �ɼ� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0501 START
@echo 0501 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �н����� Ȯ���Լ� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: �н����� ���� �Լ��� ������ ����Ǵ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0501 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0502 START
@echo 0502 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  Role�� ���� grant option ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: WITH_GRANT_OPTION�� ROLE�� ���Ͽ� �����Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0502 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0503 START
@echo 0503 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �ΰ����� ���� Object Owner�� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: Object Owner �� ������ SYS, SYSTEM, ������ ���� ������ ���ѵ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0503 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0504 START
@echo 0504 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �����ͺ��̽��� �ڿ� ���� ��� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: RESOURCE_LIMIT ������ TRUE�� �Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0504 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       6. ���� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0601 START
@echo 0601 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  DBA ���� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ������ �����ڱ����� ���� �ο� �Ǿ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user,select_priv,insert_priv,Delete_priv from mysql.user where (select_priv='Y' or insert_priv='Y' or delete_priv='Y') and user<>'root';" -t > %TmpFilePath%\6_1.txt
find "+" %TmpFilePath%\6_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\6_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo select_priv, insert_priv, delete_priv ������ �ο��� ������ �������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0601 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 'root�� ������ �Ϲݰ����� select_priv, insert_priv, delete_priv���� ���� �ο��Ǿ��ִ��� Ȯ�� ��, �ο��� ������ ���Ͽ� Ÿ�缺 ���� �� ���ʿ�� ������ ȸ���Ͽ��� ��' >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0602 START
@echo 0602 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ���ݿ��� DB �������� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���� IP �� ��Ʈ�� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.user���̺� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\6_2_1.txt
find "+" %TmpFilePath%\6_2_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\6_2_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.db���̺� >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.db;" -t > %TmpFilePath%\6_2_2.txt
find "+" %TmpFilePath%\6_2_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\6_2_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ������� ���� >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0602 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo host �׸� ���� %% ������ �Ǿ� �ִ� ��� ��� IP�� ���� ������ ���������� �����Ͽ��� ��. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0603 START
@echo 0603 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  OS_ROLES,  REMOTE_OS_ROLES ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES������ FALSE�� �Ǿ��ִ� ���>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0603 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0604 START
@echo 0604 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �������α׷� �Ǵ� DBA ������ Role�� Public ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: DBA ������ Role�� Public���� �����Ǿ����� ���� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0604 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       7. ���� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0701 START
@echo 0701 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ���� Idle timeout ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���� Idle timeout ����(5��) Ȥ�� ���� �ַ���� ���Ͽ� �ش� ��� ����� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo "timeout ���� �������" >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show variables like '%%timeout%%';" -t > %TmpFilePath%\7_1.txt
type %TmpFilePath%\7_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0701 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       8. ��ġ ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0801 START
@echo 0801 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �����ͺ��̽� �ֽ� ������ġ�� ��� �ǰ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ������ �ֽ� ��ġ�� ������ ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select version();" -t > %TmpFilePath%\8_1.txt
type %TmpFilePath%\8_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "2017�� 1�� ����" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 8.0 development" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 5.7 GA" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 5.6 GA" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "MySQL 5.5 GA" >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0801 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
                                                                                    >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0802 START
@echo 0802 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ���ȿ� ������� ���� ������ �����ͺ��̽� ��� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ���� ��ġ�� �����Ǵ� ������ ����ϴ� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select version();" -t > %TmpFilePath%\8_2.txt
type %TmpFilePath%\8_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0802 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       9. ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0901 START
@echo 0901 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  ���� ��� ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ��ü �⺻ ���� ����� ���� �� �̰ų� �ַ���� ���� DBMS���� ����� ���� �� �� ��� ��ȣ >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "show variables like '%%general_log%%';" -t > %TmpFilePath%\9_1.txt
type %TmpFilePath%\9_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0901 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       10. ������ ������ ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 1001 START
@echo 1001 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  DB���� �߿����� ��ȣȭ ���� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: ��й�ȣ Į��(Column)�� ��ȣȭ �Ǿ� ����� ��� ��ȣ>> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.   

@echo ���ͺ�-����� ���ͺ� �� �ǻ������� ���� �߿�����(��������, ��й�ȣ ��)�� ��ȣȭ ���� �� �˰��� >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 1001 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       11. �α� ����      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 1101 START
@echo 1101 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  �����ͺ��̽� ������ ������ Audit Table�� ���� �ִ� ���� >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ����: Audit Table ���� ������ ������ �������� ������ ��� >> %COMPUTERNAME%-MYSQL-result.txt
@echo �� ��Ȳ>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
::%SQLCMD% -e "select table_schema, table_name from information_schema.tables where table_name='%%aud%%'" -t >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 1101 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
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
%SQLCMD% -e "show plugins;" -t > %TmpFilePath%\plugins.txt
type %TmpFilePath%\plugins.txt >> %COMPUTERNAME%-MYSQL-result.txt
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
rd /q/s %TmpFilePath%
pause
EXIT