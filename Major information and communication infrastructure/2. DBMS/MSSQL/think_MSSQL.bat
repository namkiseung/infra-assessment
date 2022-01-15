@echo off
TITLE MSSQL Security Check
setlocal

echo.
echo.



echo �� �ش� ���� �Է����� �ʰų� Ʋ�� ��� ��ũ��Ʈ�� ���� �۵����� �ʽ��ϴ�. ��
set /p ID=ID�� �Է����ּ��� : 
set /p PW=PW�� �Է����ּ��� : 
set /p DBnameI=�ν��Ͻ����� �Է����ּ��� : 
set DBname=.\%DBnameI%


osql -E -S 127.0.0.1 -Q "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'" > nul
if not errorlevel 1 (
	set MSSQLCMD=osql -w 65530 -E -S 127.0.0.1 -Q
) 

osql -U %ID% -P %PW% -S 127.0.0.1 -Q "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'" > nul
if not errorlevel 1 (
	set MSSQLCMD=osql -w 65530 -U %ID% -P %PW% -S 127.0.0.1 -Q
) 

osql -E -S %DBname% -Q "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'" > nul
if not errorlevel 1 (
	set MSSQLCMD=osql -w 65530 -E -S %DBname% -Q
) 

osql -U %ID% -P %PW% -S %DBname% -Q "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'" > nul
if not errorlevel 1 (
set MSSQLCMD=osql -w 65530 -U %ID% -P %PW% -S %DBname% -Q
)


chcp 437
set DBVersion=0.6.3
echo MSSQL Security Check         	                                                         > %COMPUTERNAME%-result.txt
echo Copyright (c) 2017 think Co. Ltd. All right Reserved                                  >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo ��������������������                MSSQL Security Check            ��������������������� >> %COMPUTERNAME%-result.txt
echo ��������������������                    SK think                  ��������������������� >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �������������������������������������  Start Time  �������������������������������������  >> %COMPUTERNAME%-result.txt
date /t                                                                                      >> %COMPUTERNAME%-result.txt
time /t                                                                                      >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############################  Interface Information  ############################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
ipconfig /all                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       1. ���� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo D-01 START
echo D-01 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########           �⺻ ������ �н�����, ��å ���� �����Ͽ� ���           ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �⺻ ������ �н����带 �����Ͽ� ����ϴ� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-01 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo D-02 START
echo D-02 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   scott �� Demonstration �� ���ʿ� ������ �����ϰų� ��� ���� �� ���  ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� ������ Ȯ���Ͽ� ���ʿ��� ������ ���� ��� ��ȣ							 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-02 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-03 START
echo D-03 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########       �н������� ���Ⱓ �� ���⵵ ��� ��å�� �µ��� ����       ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �н����带 �ֱ������� �����ϰ�, �н����� ��å�� ����Ǿ� �ִ� ��� ��ȣ		 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(name as varchar(30)) as Name, is_expiration_checked, is_disabled from sys.sql_logins where type='S'">> expiation.txt
type expiation.txt | findstr /v "##MS"													 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [�н����� ����Ⱓ ���� Ȯ��]>> %COMPUTERNAME%-result.txt
echo ------------------------------------------------------------------------------->> %COMPUTERNAME%-result.txt
net accounts | find "Maximum password">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-03 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F expiation.txt 2>null


echo D-04 START
echo D-04 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     �����ͺ��̽� ������ ������ �� �ʿ��� ���� �� �׷쿡 ���      ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������ �����ڱ����� ���� �ο� �Ǿ� �ִ� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(SP2.[name] as varchar(30)) AS 'ServerRole', cast(SP1.[name] as varchar(30)) AS 'ID' FROM sys.server_principals SP1 JOIN sys.server_role_members SRM ON SP1.principal_id = SRM.member_principal_id JOIN sys.server_principals SP2 ON SRM.role_principal_id = SP2.principal_id where SP2.[name]='sysadmin' ORDER BY SP1.[name], SP2.[name]">> sysadmin.txt
type sysadmin.txt | findstr /v "##MS \SQLServer \SYSTEM SQLEXPRESS (" >>%COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-04 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F sysadmin.txt 2>null


echo D-05 START
echo D-05 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################          �н����� ���뿡 ���� ����          #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: is_policy_checked Ȱ��ȭ, Length of password history maintained �Ķ���� ������ ����� ��� ��ȣ>> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

%MSSQLCMD% "select cast(name as varchar(30)) as Name, is_policy_checked, is_disabled from sys.sql_logins where type='S'">> policy.txt
type policy.txt | findstr /v "##MS"														 >> %COMPUTERNAME%-result.txt
net accounts | find "Length of password history maintained"								 	 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-05 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null

echo D-06 START
echo D-06 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################          DB ����� ���� ������ �ο�           #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ����ں� ������ ����ϰ� �ִ� ��� ��ȣ										 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-06 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-07 START
echo D-07 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################         ���ݿ��� DB �������� ���� ����        #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� IP �� ��Ʈ�� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ						 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo (��������)                                                                              >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-07 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-08 START
echo D-08 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########    DBA�̿��� �ΰ����� ���� ����� �ý��� ���̺� ���� ���� ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: DBA�� ���� ������ ���̺� �Ϲ� ����� ������ �Ұ��� �� ��� ��ȣ				 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �Ʒ� ������� �������� ������ ��ȣ                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(su.name as varchar(30)) AS Principal, cast(ao.name as varchar(20)) AS Object, cast(p.permission_name as varchar(20)) AS Permission from sys.database_permissions p, sys.database_principals dp, sys.all_objects ao, sys.sysusers su where ao.object_id=p.major_id and p.grantee_principal_id=dp.principal_id and p.grantee_principal_id=su.uid and dp.name='public' and dp.name='guest' and ao.type='S';">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-08 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-09 START
echo D-09 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########          ����Ŭ �����ͺ��̽��� ��� ������ �н����� ����          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Listener�� �н����尡 �����Ǿ� �ִ� ��� ��ȣ									 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-09 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-10 START
echo D-10 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########         ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ����          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���ʿ��� ODBC/OLE-DB�� ��ġ���� ���� ��� ��ȣ									 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-10 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-11 START
echo D-11 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########             ���� Ƚ���� �α��� ���� �� ��� ��å ����             ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �α��� �õ� Ƚ���� �����ϴ� ���� ������ ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(name as varchar(30)) as Name, is_policy_checked, is_disabled from sys.sql_logins where type='S'">> policy.txt
type policy.txt | findstr /v "##MS"														 >> %COMPUTERNAME%-result.txt
net accounts | find "Lockout threshold"													  	 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-11 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null


echo D-12 START
echo D-12 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###   �����ͺ��̽��� �ֿ� ���� ��ȣ ���� ���� DB ������ umask�� 022�̻����� ����    ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������ umask�� 022 �̻����� �����Ǿ��ִ� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-12 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-13 START
echo D-13 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###   �����ͺ��̽��� �ֿ� ��������, �н����� ���� �� �ֿ� ���ϵ��� ���� ���� ����   ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �ֿ� ���� ���� �� ���͸��� �۹̼� ������ �Ǿ��ִ� ��� ��ȣ					 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-13 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-14 START
echo D-14 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ������ �̿��� ����ڰ� ����Ŭ �������� ������ ���� ������ �α� �� trace ���Ͽ� ���� ���� ���� ���� >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �ֿ� ���� ���� �� �α� ���Ͽ� ���� �۹̼��� �����ڷ� ������ ��� ��ȣ			 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-14 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-15 START
echo D-15 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   �������α׷� �Ǵ� DBA ������ Role�� Public���� �������� �ʵ��� ����   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: DBA ������ Role�� Public���� �����Ǿ����� ���� ��� ��ȣ						 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �Ʒ� ������� �������� ������ ��ȣ                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT s.name + '.' + o.name AS ObjectName, COALESCE(p.name, p2.name) AS OwnerName FROM sys.all_objects o LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id WHERE s.name IN ('public', 'guest')">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-15 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-16 START
echo D-16 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######    OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES�� FALSE�� ����   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES������ FALSE�� �Ǿ��ִ� ��� >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																																									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-16 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-17 START
echo D-17 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###################     �н����� Ȯ���Լ��� �����Ǿ� ����Ǵ°�     ################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �н����� ���� �Լ��� ������ ����Ǵ� ��� ��ȣ																	 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																																									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(name as varchar(30)) as Name, is_policy_checked, is_disabled from sys.sql_logins where type='S'">> policy.txt
type policy.txt | findstr /v "##MS"																													 >> %COMPUTERNAME%-result.txt
secedit /export /cfg Local_Security_plicy.txt >null
type Local_Security_plicy.txt | find /I "PasswordComplexity"														     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-17 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

del /F policy.txt 2>null
del /F Local_Security_plicy.txt 2>null

echo D-18 START
echo D-18 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #################     �ΰ����� ���� Object Owner�� �������� �ʴ°�    ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Object Owner �� ������ SYS, SYSTEM, ������ ���� ������ ���ѵ� ��� ��ȣ		 		 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �Ʒ� ������� �������� ������ ��ȣ                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT s.name + '.' + o.name AS ObjectName, COALESCE(p.name, p2.name) AS OwnerName FROM sys.all_objects o LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id WHERE s.name IN ('public', 'guest')">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-18 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-19 START
echo D-19 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##################     grant option�� role�� ���� �ο��ǵ��� ����   ################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: WITH_GRANT_OPTION�� ROLE�� ���Ͽ� �����Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �� With Grant Option ���� �ο� ���� Ȯ��(��� ���� ������ ��ȣ) >> %COMPUTERNAME%-result.txt
echo.>> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT name FROM sys.databases" | findstr /v "^(" | findstr .>> grant.txt
FOR /F "tokens=1 skip=2" %%i IN (grant.txt) DO (
echo *************************************************************************************** > withgrant.txt
echo [DB��] %%i>> withgrant.txt
%MSSQLCMD% "USE %%i; if exists(select object_name(id) as object, user_name(uid) as grantee, user_name(grantor) as 'Granted by' from sysprotects where protecttype = 204) begin select cast(object_name(id) as varchar(30)) as objectname, cast(user_name(uid) as varchar(18)) as userid, cast(user_name(grantor) as varchar(18)) as 'Granted by', case action when 193 then 'SELECT' when 195 then 'INSERT' when 196 then 'DELETE' when 197 then 'UPDATE' when 198 then 'CREATE TABLE' when 203 then 'CREATE DATABASE' when 207 then 'CREATE VIEW' when 222 then 'CREATE PROCEDURE' when 224 then 'EXECUTE' when 228 then 'BACKUP DATABASE' when 233 then 'CREATE DEFAULT' when 235 then 'BACKUP RULE' when 236 then 'CREATE LOG' when 26 then 'REFERENCES' when 178 then 'CREATE FUNCTION' end as Permmision from sysprotects where protecttype = 204; end" >> withgrant.txt
echo *************************************************************************************** >> withgrant.txt
echo.>> withgrant.txt
type withgrant.txt | findstr -i "object" > NUL
IF NOT ERRORLEVEL 1 type withgrant.txt >> %COMPUTERNAME%-result.txt
)
echo.>> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-19 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F grant.txt 2>null
del /F withgrant.txt 2>null

echo D-20 START
echo D-20 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########            �����ͺ��̽��� �ڿ� ���� ����� TRUE�� ����            ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: RESOURCE_LIMIT ������ TRUE�� �Ǿ��ִ� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-20 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-21 START
echo D-21 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #########   �����ͺ��̽��� ���� �ֽ� ������ġ�� ��� �ǰ� ������ ��� ����   ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������ �ֽ� ��ġ�� ������ ��� ��ȣ											 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-21 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-22 START
echo D-22 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �����ͺ��̽��� ����, ����, ���� ���� �������� ����� ������ ��å�� �����ϵ��� ����  >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: DBMS�� ���� �α� ���� ��å�� �����Ǿ� ������, ��å�� ����Ǿ��ִ� ��� 		 >> %COMPUTERNAME%-result.txt
echo         0x3�� ������ ������ ���� ���, 0x3 : ������ �α��ΰ� ������ �α��� ���    	 >> %COMPUTERNAME%-result.txt
echo         0x0 : �̼���, 0x1 : ������ �α��θ�, 0x2 : ������ �α��θ�    					 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [Registry ���� ��]                                                                      >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "AuditLevel"                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [���� �α� ���� ��å]                                                                   >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "DECLARE @AuditLevel int EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', @AuditLevel OUTPUT SELECT CASE WHEN @AuditLevel = 0 THEN 'None' WHEN @AuditLevel = 1 THEN 'Successful logins only' WHEN @AuditLevel = 2 THEN 'Failed logins only' WHEN @AuditLevel = 3 THEN 'Both failed and successful logins' END AS [AuditLevel]" >> %COMPUTERNAME%-result.txt

echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-22 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-23 START
echo D-23 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     ���ȿ� ������� ���� ������ �����ͺ��̽��� ����ϰ� �ִ°�    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� ��ġ�� �����Ǵ� ������ ����ϴ� ��� ��ȣ									 >> %COMPUTERNAME%-result.txt
echo         2005������ ��� EOS�Ǿ� ���̻� ��ġ�� �����ϰ� ���� ����						 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"															     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-23 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-24 START
echo D-24 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     Audit Table�� �����ͺ��̽� ������ ������ ���� �ֵ��� ����     ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Audit Table ���� ������ ������ �������� ������ ��� 							 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-24 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.
echo.
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############                   SYSTEM ���� ���                 #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
systeminfo                                                                                   >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############                   SECPOL ���� ���                 #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
@secedit /EXPORT /CFG secedit.txt
type secedit.txt >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F secedit.txt
del /F null
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �������������������������������������   END Time  �������������������������������������   >> %COMPUTERNAME%-result.txt
echo MSSQL Security Check is Finished
pause
echo.
echo.
