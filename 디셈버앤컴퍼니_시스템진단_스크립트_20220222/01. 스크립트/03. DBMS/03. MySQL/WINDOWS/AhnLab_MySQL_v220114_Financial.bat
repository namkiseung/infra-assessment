@echo off

REM SETLOCAL ENABLEDELAYEDEXPANSION

FOR /f "tokens=1 delims=." %%a IN ('wmic os get version ^| findstr /i /v version ^| findstr /i /v "^$"') DO (
	if %%a EQU 5 (
		SET OS_VER=WIN2003
	)
	if %%a EQU 6 (
		SET OS_VER=WIN20082012
	)
	if %%a EQU 10 (
		SET OS_VER=WIN2016
	)
)

REM ###########################################
REM ## ������ ���� ���� ��û �κ�
REM ###########################################
if %OS_VER% EQU WIN20082012 (
	if _%1_==_payload_  goto :payload
) else (
	goto :payload
)
:getadmin
    echo.
    echo. %~nx0:
    echo.
    echo. ���� ��ũ��Ʈ ������ ���� ������ ������ ��û �մϴ�.
    set vbs=%temp%\getadmin.vbs
    echo. Set UAC = CreateObject^("Shell.Application"^)                >> %vbs%
    echo. UAC.ShellExecute "%~s0", "payload %~sdp0 %*", "", "runas", 1 >> %vbs%
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
goto :eof

:payload
    echo. ---------------------------------------------------
    cd /d %2
    shift
    shift

echo. [START TIME] 																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	date /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	time /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	
set /p MYSQL_USERNAME=MySQL USERNAME�� �Է��� �ּ���(ex root). : 
set /p MYSQL_PASSWORD=MySQL PASSWORD�� �Է��� �ּ���. : 
set /p MYSQL_HOME=MySQL Ȩ ���͸��� �Է��� �ּ���(ex C:\Program Files\MySQL\MySQL Server 5.6). :
if exist "%MYSQL_HOME%" (
	echo MySQL Ȩ ���͸��� %MYSQL_HOME% �Դϴ�.
) else (
	echo MySQL Ȩ ���͸��� �������� �ʽ��ϴ�.
	goto 1
)

REM ##### MAJOR ���� ���ڸ�, MINOR #####
FOR /f "tokens=1,2 delims=. " %%a IN ('mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select version();" ^| findstr /r "[0-9\.]"') DO (
	set MYSQL_MAJOR_VERSION=%%a
	set MYSQL_MINOR_VERSION=%%b
)
echo. %MYSQL_MAJOR_VERSION%																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. %MYSQL_MINOR_VERSION%																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1

echo. *************************************************************		
echo. ******** AhnLab System Checklist for MySQL ver 5.9.5 ********			
echo. *************************************************************		


echo. *************************************************************																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ******** AhnLab System Checklist for MySQL ver 5.9.5 ********																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. *************************************************************																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ##############################START#################################################
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-001] ����ϰ� ������ ��й�ȣ ����																			>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-001] CHECK OK
echo.##### DBM001 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ���� Ȯ��																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		if %MYSQL_MAJOR_VERSION% LEQ 5 ( if %MYSQL_MINOR_VERSION% LEQ 6 (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,password from mysql.user;" -t				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		) else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		))else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		)
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �ý��� �� ��� ������ ��й�ȣ�� ��й�ȣ ���⵵�� �����ϰ� ������� �ʰ� �����Ǿ� �ִٰ� �Ǵܵ� ���																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ��й�ȣ ���⵵�� �������� �ʰų� ����ϴٰ� �ǴܵǴ� ���� ��й�ȣ�� ������ ��� 															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default ID : root																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default password : ����																								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] ������ ���ʿ��� ���� ����																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] CHECK OK
echo.##### DBM003 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 1. ���� ���� Ȯ��																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		if %MYSQL_MAJOR_VERSION% LEQ 5 ( if %MYSQL_MINOR_VERSION% LEQ 6 (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,password from mysql.user;" -t				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		) else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		))else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		)
echo. 2. ������ ��� ����																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [���ͺ�] 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ ���ʿ��� ������ �������� �ʴ� ���												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��� ������ �����ϴ� ���											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] ������ ���ʿ��ϰ� ������ ������ �ο��� ���� ����																								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] CHECK OK
echo.##### DBM004 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ���� Ȯ��																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select * from mysql.user;" -t									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ ���ʿ��ϰ� ������ ������ �ο��� ������ �������� ���� ���															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��ϰ� ������ ������ �ο��� ������ ������ ���													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� ������ ���� : Global �������� �ο��� ����																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] �����ͺ��̽� �� �߿����� ��ȣȭ ������																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] CHECK OK
echo.##### DBM005 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [���ͺ�] 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �����ͺ��̽� ���� �ֹε�Ϲ�ȣ, ��й�ȣ��� ���� �߿������� ��ȣȭ �Ǿ� ������ ���																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �����ͺ��̽� ���� �ֹε�Ϲ�ȣ, ��й�ȣ��� ���� �߿������� ������ ������ ���																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : MySQL���� �����ϴ� ��ȣȭ �Լ�																						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �ܹ��� ��ȣȭ : MD5, PASSWORD, SHA1, SHA																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����� ��ȣȭ : AES_ENCRYPT, AES_DECRYPT, DES_ENCRYPT, DES_DECRYPT, DECODE, ENCODE, COMPRESS, UNCOMPRESS					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] �α��� ���� Ƚ���� ���� ���� ���� ���� ����																							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] CHECK OK
echo.##### DBM006 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��й�ȣ ��å Ȯ��																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT user, host, User_attributes FROM mysql.user;" -t					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. User_attributes �ʵ��� failed_login_attempts, password_lock_time_days �� Ȯ��																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : 5ȸ ���� �α��� ���н� �����ð� ���� ���� ����(���� ��� �Ǵ� ���� ����)�� �̷������ ���																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : 5ȸ ���� �α��� ���н� �����ð� ���� ���� ����(���� ��� �Ǵ� ���� ����)�� �̷������ �ʴ� ���															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. v8.0.19 �̻�: failed_login_attempts ���� 5�ʰ��� �Ǿ��ְų� password_lock_time_days ���� ����ġ�� �۰� �����Ǿ� �ִ� ��� ���									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. v8.0.19 �̸�: �÷�����, ���, �����Ƽ �ַ�� ���� ���� �α��� ���� Ƚ���� ���� ���� ���� ������ �̷�� ���� �ִ��� Ȯ��											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * failed_login_attempts : ������ ���� ���� �α��� ���� Ƚ��																		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * password_lock_time_days : ����Ƚ�� �α����� �����Ͽ� ������ ������� ����� Ǯ���� ���� �������ϴ� �ð�																	    >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� ���� � �뵵(�ַ��, ���ø����̼� ���ӿ� ��)�� ������� ������ ���ؼ� "�α��� ���� Ƚ���� ���� ���� ����"������ ������ ��� ���� ��� ���� ���ɼ��� �ִٰ� ���������� �Ǵܵ� ���, �ش� �������� �򰡿��� ����	   >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																	    >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] ��й�ȣ�� ���⵵ ��å ���� ����																							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] CHECK OK
echo.##### DBM007 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��й�ȣ ��å Ȯ��																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'validate_password%%';" -t		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ���� ���� �� ���� ��й�ȣ ����� ��й�ȣ ���⵵ �ؼ��ϵ��� �����ϰ� �ִ� ���															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� ���� �� ���� ��й�ȣ ����� ��й�ȣ ���⵵ �ؼ��ϵ��� �����ϰ� ���� ���� ���															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� ��й�ȣ ���⵵: ����/����/Ư������ 2�� ���� �� 10�ڸ� �̻�, 3�� ���� �� 8�ڸ� �̻�																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� �÷�����, ���, �����Ƽ �ַ�� ���� ���� ��й�ȣ ���⵵ �ؼ��� �����ϰ� �ִ��� ���� Ȯ��																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_check_user_name : �н����忡 userid�� ��� ���� Ȯ��													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_dictionary_file : �н����忡 dictionary file �˻�														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_length : �н����� ����																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_mixed_case_count : �н����忡 ��� ������ ��ҹ��� �ּ� ���� ����										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_number_count : �н����忡 ��� ������ �ּ� ���� ���� ����												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_policy : �н�������å�� ���� ����																		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_special_char_count : �н����忡 ��� ������ Ư�������� �ּ� ���� ����									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] �ֱ����� ��й�ȣ ���� ����																						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] CHECK OK
echo.##### DBM008 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��й�ȣ ���� ���� Ȯ��																									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'default_password_lifetime';" -t 				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT USER, HOST, password_last_changed from mysql.user;" -t 				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ���� ��й�ȣ�� �ֱ���(�б⺰ 1ȸ �̻�)���� �����ϰ� �ִ� ���																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� ��й�ȣ�� �ֱ���(�б⺰ 1ȸ �̻�)���� �����ϰ� ���� ���� ���															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� ���� � �뵵(�ַ��, ���ø����̼� ���ӿ� ��)�� ������� ������ ���ؼ� ��й�ȣ�� �����ϸ� ���� ��� ���� ���ɼ��� �ִٰ� ���������� �Ǵܵ� ��� �ش� �������� �򰡿��� ����																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] ������ �ʴ� ���� ���� ����																							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] CHECK OK
echo.##### DBM009 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "show variables like '%%timeout';" -t								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : interactive_timeout, wait_timeout�� ���� 15�� Ȥ�� ��å�� �°� �����Ǿ� �ִ� ���											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : interactive_timeout, wait_timeout�� ���� ��å�� �°� �����Ǿ� ���� ���� ���										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. connect_timeout : MySQL���� ���ӽÿ� ���ӽ��и� �޽����� ��������� ����ϴ� �ð�											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. delayed_insert_timeout : insert�� delay�� ��� ����ϴ� �ð�																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. innodb_lock_wait_timeout : innodb�� transaction ó���� lock�� �ɷ��� �� �ѹ� �ɶ����� ����ϴ� �ð�						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 							 innodb�� �ڵ����� ������� �˻��ؼ� �ѹ��Ų��													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. innodb_rollback_on_timeout : innodb�� ������ ������ �ѹ��ų�� �����ϴ� �Ķ����											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 							   timeout�� �������� transaction�� �ߴ��ϰ� ��ü transaction�� �ѹ��ϴ� �������� �߻��Ѵ�.		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. interactive_timeout : Ȱ������ Ŀ�ؼ��� ������ ������ ������ ����ϴ� �ð�												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. net_read_timeout : ������ Ŭ���̾�Ʈ�κ��� �����͸� �о���̴� ���� �ߴ��ϱ���� ����ϴ� �ð�							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. net_write_timeout : ������ Ŭ���̾�Ʈ�ο� �����͸� ���� ���� �ߴ��ϱ���� ����ϴ� �ð�									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. slave_net_timeout : ������/�����̺�� ������ Ŭ���̾�Ʈ�κ��� �����͸� �о���̴� ���� �ߴ��ϱ���� ����ϴ� �ð�			>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. table_lock_wait_timeout : ���̺� ���� �ߴ��ϱ���� ����ϴ� �ð�															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. wait_timeout : Ȱ������ �ʴ� Ŀ�ؼ��� ���������� ������ ����ϴ� �ð�														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] ���� �α� ���� �� ��� ����																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] CHECK OK
echo.##### DBM011 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "show VARIABLES like '%%log%%';" -t								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ���� �α׸� ���� ���̰� �ֱ������� ���� �α׿� ���� ����� �ǽ��ϰ� �ִ� ���										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� �α׸� ���� ������ �ʰų� �ֱ������� ���� �α׿� ���� ����� �ǽ��ϰ� ���� ���� ���										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� �����Ƽ �ַ��, ��Ÿ �÷����ε��� �̿��� ����α׸� ����/��� ������ Ȯ��																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-013] ���� ���ӿ� ���� ���� ���� ����																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-013] CHECK OK
echo.##### DBM013 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host from mysql.user;" -t							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �����ͺ��̽����� ���� ������� �̷������ �ִ� ���															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �����ͺ��̽����� ���� ������� �̷������ �ʴ� ���(Host Į���� '%%'�� ����� ������ ������ ��� ���)								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : host �ʵ忡 '%%'�� ����Ǿ� ���� ��� '%%'�� �����ϰ� ������ IP�ּҸ� �����Ͽ� ���									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� �÷�����, ��Ʈ��ũ ���, �����Ƽ �ַ�� ���� ���� ���� ���� ��� �̷������ �ִ��� Ȯ��																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] DBMS �ֽ� ������ġ�� ���� �ǰ���� ������																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] CHECK OK
echo.##### DBM016 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select version();" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �ֽź�����ġ �� ���� �ǰ������ ����� ���							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �ֽź�����ġ �� ���� �ǰ������ ������� ���� ���							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ����Ʈ																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ��ġ �� ������ ����Ʈ : http://downloads.mysql.com/archives.php														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ��Ȳ ����Ʈ : http://bugs.mysql.com/bugstats.php				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-017] ������ ���ʿ��� �ý��� ���̺� ���� ���� ����											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-017] CHECK OK
echo.##### DBM017 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ���� Ȯ��																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select * from mysql.user;" -t									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. DB ���� Ȯ��																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1	
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select * from mysql.db;" -t										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ �ʿ��� �ý��� ���̺� ���� ���Ѹ� �����ϴ� ���														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��� �ý��� ���̺� ���� ������ �����ϴ� ���										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * ���ͺ並 ���� ������ ���ʿ��ϰ� �ο��� �ý��� ���̺� ���� ������ �����ϴ��� Ȯ��																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. - ������ ���ʿ��� �ý��� ���̺�(sys, mysql, information_schema��) ���� ������ ������ ��� ���																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] ��й�ȣ ���� ���� ���� ����											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] CHECK OK
echo.##### DBM019 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * (v8.0�̻�) �����ͺ��̽� ��ü���(password_history, password_resue_interval) �� Ȯ��																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'password_history';" -t									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'password_reuse_interval';" -t										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  - password_history���� 0�̰ų� password_resue_interval���� 0�� ���  ���																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * ���� ������ �����Ǿ����� �ʰų� v8.0 �̸��� ���,�÷�����, �����Ƽ �ַ��, ���� ��å ���� ���� ���� ��й�ȣ ������ �����ϰ� �ִ��� Ȯ��																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  - ��й�ȣ ������ �����ϰ� ���� ���� ��� ���																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ��й�ȣ ����� ���� ��й�ȣ�� ������ �� ���� ���														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ��й�ȣ ����� ���� ��й�ȣ�� ������ �� �ִ� ���										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] ����ں� ���� �и� ����																				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] CHECK OK
echo.##### DBM020 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [���ͺ�] 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �������� ����ں��� �����ϰ� �и��Ǿ� ���ǰ� �ְ� �ִ� ���																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.     (������ �����ؼ� ��� �ϴ� ���, ������Ʈ�ַ�ǵ��� ���� �����ں� ����α� �ĺ� ���ɽ� ��ȣ�� �Ǵ�)																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �������� ����ں��� �����ϰ� �и����� �ʰ� ���ǰ� �ִ� ���																						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] ���� ���� �� �߿������� ���Ե� ������ ���� ���� ���� ����																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] CHECK OK
echo.##### DBM022 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
icacls "C:\ProgramData\MySQL\MySQL Server %MYSQL_MAJOR_VERSION%.%MYSQL_MINOR_VERSION%\my.ini" 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [��������] �ʱ�ȭ ����(my.cnf, my.ini)�� ���� ������ Adminisrators, SYSTEM, Owner ���� �׷쿡 ���� ���� Ȯ��																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �ֿ� ���� ���� �� �߿����� ���Ͽ� ���Ͽ� ���ٱ����� �����ϰ� ������ ���							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �ֿ� ���� ���� �� �߿����� ���Ͽ� ���Ͽ� ���ٱ����� �����ϰ� �����Ǿ� ���� ���� ���							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] ���ʿ��ϰ� WITH GRANT OPTION �ɼ��� ������ ���� ����																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] CHECK OK
echo.##### DBM024 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT grantee,privilege_type,is_grantable FROM information_schema.user_privileges;" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ��� ���ʿ��ϰ� WITH GRANT OPTION(IS_GRANTABLE) �ɼ��� ����� ������ �������� �ʴ� ���						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ��� ���ʿ��ϰ� WITH GRANT OPTION(IS_GRANTABLE) �ɼ��� ����� ������ �����ϴ� ���							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �� WITH GRANT OPTION : GRANT���� ���� �Ǵ� ������ Ÿ ����ڿ��� �ο��Ҽ� �ִ� �ɼ����� MySQL������ IS_GRANTABLE Į���� ���� ���� ����														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] ���� ������ �����(EoS) �����ͺ��̽� ���																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] CHECK OK
echo.##### DBM025 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select version();" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ���� ��ġ�� �����Ǵ� �����ͺ��̽� ������ ����ϴ� ���							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� ��ġ�� �������� �ʴ� �����ͺ��̽� ������ ����ϴ� ���							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ����Ʈ																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ��ġ �� ������ ����Ʈ : http://downloads.mysql.com/archives.php														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ��Ȳ ����Ʈ : http://bugs.mysql.com/bugstats.php																		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-026] �����ͺ��̽� ���� ������ umask ���� ����													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-026] CHECK OK
echo.##### DBM026 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �ص����ͺ��̽��� ��ġ�� OS�� Unix�迭�� ��쿡�� �ش�																									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �����ͺ��̽�  umask �������� 022 �ʰ��� �����Ǿ� �ִ� ���																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �����ͺ��̽� umask �������� 022 ���Ϸ� �����Ǿ� �ִ� ���															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] ������ ���ʿ��� �����ͺ��̽� Object ����												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] CHECK OK
echo.##### DBM028 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT OBJECT_TYPE,OBJECT_SCHEMA,OBJECT_NAME FROM (SELECT 'TABLE' AS OBJECT_TYPE ,TABLE_NAME AS OBJECT_NAME,TABLE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.TABLES UNION SELECT 'VIEW' AS OBJECT_TYPE,TABLE_NAME AS OBJECT_NAME,TABLE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.VIEWS UNION SELECT 'INDEX[Type:Name:Table]' AS OBJECT_TYPE,CONCAT (CONSTRAINT_TYPE,' : ',CONSTRAINT_NAME,' : ',TABLE_NAME) AS OBJECT_NAME,TABLE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.TABLE_CONSTRAINTS UNION SELECT ROUTINE_TYPE AS OBJECT_TYPE,ROUTINE_NAME AS OBJECT_NAME,ROUTINE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.ROUTINES UNION SELECT 'TRIGGER[Schema:Object]' AS OBJECT_TYPE,CONCAT (TRIGGER_NAME,' : ',EVENT_OBJECT_SCHEMA,' : ',EVENT_OBJECT_TABLE) AS OBJECT_NAME, TRIGGER_SCHEMA AS OBJECT_SCHEMA FROM information_schema.triggers) R" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ ���ʿ��� �����ͺ��̽� Object�� �������� �ʴ� ���																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��� �����ͺ��̽� Object�� �����ϴ� ����															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ����																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. �ص����ͺ��̽� Object : ���̺�, ��, ���ν���, �Լ� ��																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1

echo. --- END TIME ---------------------------------------------------------------------- 										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	date /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	time /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1

exit /b 0