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

echo. [START TIME] 																												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
	date /t 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
	time /t 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
	
set /p PGUSER=DBA ID�� �Է��� �ּ���(ex root). : 
set /p PGPASS=Password�� �Է��� �ּ���. : 
set /p POST_HOME=PostgreSQL Ȩ ���͸��� �Է��� �ּ���(ex C:\Program Files\PostgreSQL\11\data). :
if exist "%POST_HOME%" (
	echo PostgreSQL Ȩ ���͸��� %POST_HOME% �Դϴ�.
) else (
	echo PostgreSQL Ȩ ���͸��� �������� �ʽ��ϴ�.
	goto 1
)

set PG_USER=%PGUSER%		
set PGPASSWORD=%PGPASS%

echo.  																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ##############################START#################################################
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-001] ����ϰ� ������ ��й�ȣ ����																			>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-001] CHECK OK
echo.##### DBM001 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���� ���� Ȯ��																											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT usename, passwd FROM PG_SHADOW;" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �ý��� �� ��� ������ ��й�ȣ�� ��й�ȣ ���⵵�� �����ϰ� ������� �ʰ� �����Ǿ� �ִٰ� �Ǵܵ� ���																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ��й�ȣ ���⵵�� �������� �ʰų� ����ϴٰ� �ǴܵǴ� ���� ��й�ȣ�� ������ ��� 															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ����																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default ID : postgres																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default password : ����																								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] ������ ���ʿ��� ���� ����																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] CHECK OK
echo.##### DBM003 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "select rolname, rolcanlogin, rolvaliduntil from pg_authid;" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : ������� �ʴ� ������ ���� ���ͺ� �ʿ� 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ ���ʿ��� ������ �������� �ʴ� ���												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��� ������ �����ϴ� ���											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : rolname(�����̸�), rolcanlogin(�α��ΰ��� ����, Default: t), rolvaliduntil(�α��� ��ȿ�Ⱓ, Default:NULL)																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ������� �ʴ� ������ ���� rolcanloing �÷��� t�� ��� ���																									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. rolvaliduntil �÷��� NULL�� ��� ��� (DBM-003-04 �׸�� ����)	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] ������ ���ʿ��ϰ� ������ ������ �ο��� ���� ����																								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] CHECK OK
echo.##### DBM004 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "select * from pg_user"									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : ������� �ʴ� ������ ���� ���ͺ� �ʿ� >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ ���ʿ��ϰ� ������ ������ �ο��� ������ �������� ���� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��ϰ� ������ ������ �ο��� ������ ������ ���													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ����																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ʿ��ϰ� ������ ����(usecreatedb, usesuper, userepl)�� t�� ��� ���																												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] �����ͺ��̽� �� �߿����� ��ȣȭ ������																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] CHECK OK
echo.##### DBM005 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "password_encrytion" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : �����ͺ��̽� ���� �ֹε�Ϲ�ȣ, ��й�ȣ ��� ���� �߿������� ������ �����ϴ��� Ȯ�� 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �����ͺ��̽� ���� �ֹε�Ϲ�ȣ, ��й�ȣ��� ���� �߿������� ��ȣȭ �Ǿ� ������ ���																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �����ͺ��̽� ���� �ֹε�Ϲ�ȣ, ��й�ȣ��� ���� �߿������� ������ ������ ���																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] �α��� ���� Ƚ���� ���� ���� ���� ���� ����																							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] CHECK OK
echo.##### DBM006 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : �÷�����(fail2ban), ���, �����Ƽ �ַ�� ���� ���� �α��� ���� Ƚ���� ���� ���� ���� ���� ���� ����	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �÷�����(fail2ban), ���, �����Ƽ �ַ�� ���� ���� �α��� ���� Ƚ���� ���� ���� ���� ���� ������ �����ϴ� ���																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �÷�����(fail2ban), ���, �����Ƽ �ַ�� ���� ���� �α��� ���� Ƚ���� ���� ���� ���� ���� ������ �������� �ʴ� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																	    >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																	    >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] ��й�ȣ�� ���⵵ ��å ���� ����																							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] CHECK OK
echo.##### DBM007 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT usename, usesysid, passwd, valuntil FROM PG_SHADOW" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-01. �н������ ����, ���� �ҹ���, ���� �빮��, Ư������ �� ����� �����Ͽ� ����ϵ��� ��å�� ���õǾ� �ֽ��ϱ� >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-02. �н������ �ּ��� �� ���� �̻� ����ϵ��� ��å �� ��ħ�� ���õǾ� �ֽ��ϱ� >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-03. �н������ ��ȣȭ(�Ǵ� �ؽ���) �Ǿ� ����/���� �ǰ� �ֽ��ϱ� >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-04. �н������ ���Ͽ� �ѹ��� �ٲٵ��� ��å �� ��ħ���� ����/������ �̷������ �ֽ��ϱ� >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-05. �н������ �ؽ� �Ǵ� ��ȣȭ(AES, SEED ��) �� ��� �˰����� ���ǰ� �ֽ��ϱ� >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ���� ���� �� ���� ��й�ȣ ����� ��й�ȣ ���⵵ �ؼ��ϵ��� �����ϰ� �ִ� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� ���� �� ���� ��й�ȣ ����� ��й�ȣ ���⵵ �ؼ��ϵ��� �����ϰ� ���� ���� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. �� ��й�ȣ ���⵵: ����/����/Ư������ 2�� ���� �� 10�ڸ� �̻�, 3�� ���� �� 8�ڸ� �̻�																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. �� �÷�����, ���, �����Ƽ �ַ�� ���� ���� ��й�ȣ ���⵵ �ؼ��� �����ϰ� �ִ��� ���� Ȯ��																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : ���� �� �н�����(PASSWD) ���� �� ����Ⱓ(VALUNTIL): PG_SHADOW																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : PostgreSQL�� �н����� ���� ��, �ؽ� �˰����� ����ϸ� MD5 �˰��� ������. (��ȣȭ ����� �������� ����)																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] �ֱ����� ��й�ȣ ���� ����																						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] CHECK OK
echo.##### DBM008 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT usename, usesysid, passwd, valuntil FROM PG_SHADOW" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ���� ��й�ȣ�� �ֱ���(�б⺰ 1ȸ �̻�)���� �����ϰ� �ִ� ���																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� ��й�ȣ�� �ֱ���(�б⺰ 1ȸ �̻�)���� �����ϰ� ���� ���� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. �� ���� � �뵵(�ַ��, ���ø����̼� ���ӿ� ��)�� ������� ������ ���ؼ� ��й�ȣ�� �����ϸ� ���� ��� ���� ���ɼ��� �ִٰ� ���������� �Ǵܵ� ��� �ش� �������� �򰡿��� ����																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] ������ �ʴ� ���� ���� ����																							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] CHECK OK
echo.##### DBM009 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 1) 9.6 �̸��� ������ ����� ���																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "statement_timeout" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : statement_timeout: ������ �ð��̻��� ������ ���ؼ��� ��� �ߴ� ���� �����ϴ�. 0�� Disable�̰� ������ milliseconds�� �Ͻø� �˴ϴ�.																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 2) 9.6 �̻��� ������ ����� ���																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "idle_in_transaction_timeout" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : idle_in_transaction_timeout: �⺻���� 0�̸�, 0�� ��� �� ���� ������� �ʴ� ��																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : timeout�� ���� 15�� Ȥ�� ��å�� �°� �����Ǿ� �ִ� ���											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : timeout�� ���� ��å�� �°� �����Ǿ� ���� ���� ���										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] ���� �α� ���� �� ��� ����																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] CHECK OK
echo.##### DBM011 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_connections" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_disconnections" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_duration" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_timestamp" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : log_connections, log_disconnections, log_duration, log_timestamp�� ���� ON���� �����ǰ� �ֱ������� ���� �α׿� ���� ����� �ǽ��ϰ� �ִ� ���										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� �α׸� ���� ������ �ʰų� �ֱ������� ���� �α׿� ���� ����� �ǽ��ϰ� ���� ���� ���										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. �� �����Ƽ �ַ��, ��Ÿ �÷����ε��� �̿��� ����α׸� ����/��� ������ Ȯ��																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-013] ���� ���ӿ� ���� ���� ���� ����																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-013] CHECK OK
echo.##### DBM013 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [postgresql.conf] >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "listen_address" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [pg_hba_conf] >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\pg_hba.conf" | findstr /V "^#" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �����ͺ��̽����� ���� ������� �̷������ �ִ� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �����ͺ��̽����� ���� ������� �̷������ �ʴ� ���(Host Į���� '%%'�� ����� ������ ������ ��� ���)								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���� : postgresql.conf���� listen_address ������ pg_hba.conf���� host ������									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 1) Ư�� IP�� 1�� �̻� �����Ǹ�, pg_hba.conf���� host ������ localhost(e.g.  127.0.0.1/32) ���� �� ��ȣ																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 2) Ư�� IP�� 1�� �̻� �����Ǹ�, pg_hba.conf���� host ������ ��Ʈ��ũ �뿪(e.g.  192.168.10.0/32) ���� �� ��ȣ																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 3) Ư�� IP�� 1�� �̻� �����Ǹ�, pg_hba.conf���� host ������ 0.0.0.0/0 ���� �� ��ȣ																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 4) ^* �� �����ǰ�, pg_hba.conf���� host ������ localhost(e.g 127.0.0.1) ���� �� ��ȣ																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 5) ^* �� �����ǰ�, pg_hba.conf���� host ������ ��Ʈ��ũ �뿪(e.g.  192.168.10.0/32) ���� �� ��ȣ																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 6) ^* �� �����ǰ�, pg_hba.conf���� host ������ 0.0.0.0/0 �����Ǿ� ������ ��� (��� IP�� ���Ͽ� TCP Connection�� ����)																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-015] Public Role�� ���ʿ��� ���� ����																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-015] CHECK OK
echo.##### DBM015 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\l" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\dn+" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : Public Role�� ���ʿ��� ���� ���� ����																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : Public Role�� ���ʿ��� ������ �������� �ʴ� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : Public Role�� ���ʿ��� ������ �����ϴ� ���								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] DBMS �ֽ� ������ġ�� ���� �ǰ���� ������																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] CHECK OK
echo.##### DBM016 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql --version >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �ֽź�����ġ �� ���� �ǰ������ ����� ���							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �ֽź�����ġ �� ���� �ǰ������ ������� ���� ���							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "LATEST RELEASES: 2022. 01. " >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "Version 		/ LATEST		/ Supported		/ First release	/ EOL" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "14		/ 14.1		/ YES			/ 2021-09-30	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "13		/ 13.5		/ YES			/ 2020-09-24	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "12		/ 12.9		/ YES			/ 2019-10.03	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "11		/ 11.14		/ YES			/ 2018-10-18	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "10		/ 10.19		/ YES			/ 2017-10-05	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.6		/ 9.6.24		/ YES			/ 2016-09-29	/ 2021-11-11" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.5		/ 9.5.25		/ YES			/ 2016-01-07	/ 2021-02-11" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.4		/ 9.4.26		/ YES			/ 2014-12-18	/ 2020-02-13" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.3		/ 9.3.25		/ YES			/ 2013-09-09	/ 2018-11-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.2		/ 9.2.19		/ YES			/ 2012-09-10	/ 2017-11-09" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.1		/ 9.1.24		/ NO			/ 2011-09-12	/ 2016-10-27" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.0		/ 9.0.23		/ NO			/ 2010-09-20 	/ 2015-10-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.4		/ 8.4.22		/ NO			/ 2009-07-01 	/ 2014-07-24" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.3		/ 8.3.23		/ NO			/ 2008-02-04 	/ 2013-02-07" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.2		/ 8.2.23		/ NO			/ 2006-12-05 	/ 2011-12-05" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.1		/ 8.1.23		/ NO			/ 2005-11-08 	/ 2010-11-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.0		/ 8.0.26		/ NO			/ 2005-01-19 	/ 2010-10-01" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.4		/ 7.4.30		/ NO			/ 2003-11-17	/ 2010-10-01" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.3		/ 7.3.21		/ NO			/ 2002-11-27	/ 2007-11-27" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.2		/ 7.2.8		/ NO			/ 2002-02-04 	/ 2007-02-04" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.1		/ 7.1.3		/ NO			/ 2001-04-13 	/ 2006-04-13" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.0		/ 7.0.3		/ NO			/ 2000-05-08	/ 2005-05-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "6.5		/ 6.5.3		/ NO			/ 1999-06-09 	/ 2004-06-09" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "6.4		/ 6.4.2		/ NO			/ 1998-10-30 	/ 2003-10-30" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "6.3		/ 6.3.2		/ NO			/ 1998-03-01 	/ 2003-03-01" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-017] ������ ���ʿ��� �ý��� ���̺� ���� ���� ����											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-017] CHECK OK
echo.##### DBM017 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\l" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\dp" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : ������ ���ʿ��� �ý��� ���̺� ���� ���� ���� ����																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ �ʿ��� �ý��� ���̺� ���� ���Ѹ� �����ϴ� ���														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��� �ý��� ���̺� ���� ������ �����ϴ� ���										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] ��й�ȣ ���� ���� ���� ����											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] CHECK OK
echo.##### DBM019 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : �÷�����, ���, �����Ƽ �ַ�� ���� ���� ���� ��й�ȣ ���� ���� ���� ����																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ��й�ȣ ����� ���� ��й�ȣ�� ������ �� ���� ���														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ��й�ȣ ����� ���� ��й�ȣ�� ������ �� �ִ� ���										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] ����ں� ���� �и� ����																				>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] CHECK OK
echo.##### DBM020 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT r.datname, ARRAY(SELECT m.rolname FROM pg_authid m JOIN pg_database b ON (m.oid = b.datdba) WHERE m.oid = r.datdba and b.DATISTEMPLATE = FALSE) as owner FROM pg_database r where r.DATISTEMPLATE = FALSE" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "select * from pg_user" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : ����ں� ������ �ο��ؼ� ����ϰ� �ְų� ���ø����̼Ǻ� ������ �ο��ؼ� ��� ���� 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �������� ����ں��� �����ϰ� �и��Ǿ� ���ǰ� �ְ� �ִ� ���																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.     (������ �����ؼ� ��� �ϴ� ���, ������Ʈ�ַ�ǵ��� ���� �����ں� ����α� �ĺ� ���ɽ� ��ȣ�� �Ǵ�)																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �������� ����ں��� �����ϰ� �и����� �ʰ� ���ǰ� �ִ� ���																						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] ���� ���� �� �߿������� ���Ե� ������ ���� ���� ���� ����																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] CHECK OK
echo.##### DBM022 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
icacls "%POST_HOME%\postgresql.conf" 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
icacls "%POST_HOME%\pg_hba.conf" 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
icacls "%POST_HOME%\pg_ident.conf" 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [��������] �ý��� �ֿ� ����(postgresql.conf, pg_hba.conf, pg_ident.conf)�� ���� ������ Adminisrators, SYSTEM, Owner ���� �׷쿡 ���� ���� Ȯ��																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �ֿ� ���� ���� �� �߿����� ���Ͽ� ���Ͽ� ���ٱ����� �����ϰ� ������ ���							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �ֿ� ���� ���� �� �߿����� ���Ͽ� ���Ͽ� ���ٱ����� �����ϰ� �����Ǿ� ���� ���� ���							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] ���ʿ��ϰ� WITH GRANT OPTION �ɼ��� ������ ���� ����																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] CHECK OK
echo.##### DBM024 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT grantor,grantee,table_name,privilege_type,is_grantable FROM information_schema.role_table_grants WHERE is_grantable='YES';" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : ���ʿ��ϰ� WITH GRANT OPTION �ɼ��� �����Ǿ� �ִ� ���� ���� ����																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ��� ���ʿ��ϰ� WITH GRANT OPTION(IS_GRANTABLE) �ɼ��� ����� ������ �������� �ʴ� ���						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ��� ���ʿ��ϰ� WITH GRANT OPTION(IS_GRANTABLE) �ɼ��� ����� ������ �����ϴ� ���							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] ���� ������ �����(EoS) �����ͺ��̽� ���																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] CHECK OK
echo.##### DBM025 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql --version >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ���� ��ġ�� �����Ǵ� �����ͺ��̽� ������ ����ϴ� ���							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ���� ��ġ�� �������� �ʴ� �����ͺ��̽� ������ ����ϴ� ���							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "LATEST RELEASES: 2022. 01. " >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "Version 		/ LATEST		/ Supported		/ First release	/ EOL" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "14		/ 14.1		/ YES			/ 2021-09-30	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "13		/ 13.5		/ YES			/ 2020-09-24	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "12		/ 12.9		/ YES			/ 2019-10.03	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "11		/ 11.14		/ YES			/ 2018-10-18	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "10		/ 10.19		/ YES			/ 2017-10-05	/ -" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.6		/ 9.6.24		/ YES			/ 2016-09-29	/ 2021-11-11" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.5		/ 9.5.25		/ YES			/ 2016-01-07	/ 2021-02-11" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.4		/ 9.4.26		/ YES			/ 2014-12-18	/ 2020-02-13" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.3		/ 9.3.25		/ YES			/ 2013-09-09	/ 2018-11-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.2		/ 9.2.19		/ YES			/ 2012-09-10	/ 2017-11-09" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.1		/ 9.1.24		/ NO			/ 2011-09-12	/ 2016-10-27" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "9.0		/ 9.0.23		/ NO			/ 2010-09-20 	/ 2015-10-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.4		/ 8.4.22		/ NO			/ 2009-07-01 	/ 2014-07-24" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.3		/ 8.3.23		/ NO			/ 2008-02-04 	/ 2013-02-07" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.2		/ 8.2.23		/ NO			/ 2006-12-05 	/ 2011-12-05" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.1		/ 8.1.23		/ NO			/ 2005-11-08 	/ 2010-11-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "8.0		/ 8.0.26		/ NO			/ 2005-01-19 	/ 2010-10-01" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.4		/ 7.4.30		/ NO			/ 2003-11-17	/ 2010-10-01" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.3		/ 7.3.21		/ NO			/ 2002-11-27	/ 2007-11-27" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.2		/ 7.2.8		/ NO			/ 2002-02-04 	/ 2007-02-04" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.1		/ 7.1.3		/ NO			/ 2001-04-13 	/ 2006-04-13" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "7.0		/ 7.0.3		/ NO			/ 2000-05-08	/ 2005-05-08" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "6.5		/ 6.5.3		/ NO			/ 1999-06-09 	/ 2004-06-09" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "6.4		/ 6.4.2		/ NO			/ 1998-10-30 	/ 2003-10-30" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo "6.3		/ 6.3.2		/ NO			/ 1998-03-01 	/ 2003-03-01" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-026] �����ͺ��̽� ���� ������ umask ���� ����													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-026] CHECK OK
echo.##### DBM026 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. �ص����ͺ��̽��� ��ġ�� OS�� Unix�迭�� ��쿡�� �ش�																									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �����ͺ��̽�  umask �������� 022 �ʰ��� �����Ǿ� �ִ� ���																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �����ͺ��̽� umask �������� 022 ���Ϸ� �����Ǿ� �ִ� ���															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] ������ ���ʿ��� �����ͺ��̽� Object ����												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] CHECK OK
echo.##### DBM028 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT distinct relname, relowner FROM pg_class;" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ���ͺ��ʿ� : ������ ���ʿ��� �����ͺ��̽� Object ���� ����																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : ������ ���ʿ��� �����ͺ��̽� Object�� �������� �ʴ� ���																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : ������ ���ʿ��� �����ͺ��̽� Object�� �����ϴ� ����															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ����																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. �ص����ͺ��̽� Object : ���̺�, ��, ���ν���, �Լ� ��																												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-032] �����ͺ��̽� ���� �� ��ű����� ��й�ȣ �� ����												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-032] CHECK OK
echo.##### DBM032 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [pg_hba.conf]																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
type "%POST_HOME%\pg_hba.conf" | findstr /V "^#" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [postgresql.conf]																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "ssl" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.
echo. ����üũ : ȯ�漳������ Ȯ�� pg_hba.conf, postgresql.conf																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 1) pg_hba.conf���� hostssl �� ���� �� �ش� �ּҿ��� ������ ssl���Ḹ ����ϸ� ��ȣ																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 2) pg_hba.conf���� (auth)method �ʵ尪 md5, password �ܷ̿� �����Ǿ� ������ ��ȣ																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 3) postgresql.conf���� ssl=on ���� ���� �� ssl ����̹Ƿ� ��ȣ(false�ϰ�� ���)																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��ȣ : �����ͺ��̽� ���� �� ��ű��� ��й�ȣ ��ȣȭ																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ��� : �����ͺ��̽� ���� �� ��ű��� ��й�ȣ �� ����															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1

echo. --- END TIME ---------------------------------------------------------------------- 										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
	date /t 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
	time /t 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1

exit /b 0