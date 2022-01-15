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

secedit /EXPORT /CFG secedit.txt
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
set DBVersion=19.1
set DBLast_update=2019.02

echo MSSQL Security Check         	                                                         > %COMPUTERNAME%-result.txt
echo Copyright (c) 2019 SK think Co. Ltd. All right Reserved                               >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo ��������������������                MSSQL Security Check            ��������������������� >> %COMPUTERNAME%-result.txt
echo ��������������������                    SK think                  ��������������������� >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo SCRIPT_VERSION %DBVersion%                                                              >> %COMPUTERNAME%-result.txt
echo LAST_UPDATE %DBLast_update%                                                             >> %COMPUTERNAME%-result.txt
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
echo ##########################       1. ����� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 0101 START
echo 0101 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########       ���ΰ����� ���� ������ ���� ����� ���� ����       ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� ������ Ȯ���Ͽ� ���ʿ��� ������ ���� ��� ��ȣ							 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0101 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0102 START
echo 0102 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################          �α��� ���� Ƚ���� ���� ��ݽð� �� ���� ��� ��å ����           #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �α��� �õ� Ƚ���� �����ϴ� ���� ������ ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0102 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null




echo 0103 START
echo 0103 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########         SYSDBA �α��� ���� ����          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������ ����(SYSDBA)�� ���� DB�������� ��й�ȣ �Է¾��� ������ �Ұ����� ��� ��ȣ  >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0103 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       2. ���� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0201 START
echo 0201 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##################     �н����� ���뿡 ���� ������ ���� ����   ################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: is_policy_checked Ȱ��ȭ, Length of password history maintained �Ķ���� ������ ����� ��� ��ȣ>> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0201 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null




echo 0202 START
echo 0202 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########            DB ����� ������ ���������� �ο�            ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ����ں� ������ ����ϰ� �ִ� ��� ��ȣ										 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0202 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       3. ��й�ȣ ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0301 START
echo 0301 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########           ���߰����� ��й�ȣ ��������(DB����)           ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ��й�ȣ ���� ���� ������ ���� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ���ͺ� ���� : ����� ���ͺ並 ���� ��й�ȣ�� ��å�� �°� �����ϴ��� ���� Ȯ�� �ʿ�								 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0301 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo 0302 START
echo 0302 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   �⺻ ���� �� �н����� ����(����Ʈ ID �� �н����� ���� �� ���)  ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �⺻ ������ �н����带 �����Ͽ� ����ϴ� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0302 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo 0303 START
echo 0303 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################         ��й�ȣ ���⵵ ����        #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ��ü������ ��й�ȣ ���⵵ ������ �Ǿ� �ְų�, ���� �ַ���� ���Ͽ� ���⵵ ������ �����Ǵ� ��� ��ȣ		 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(name as varchar(30)) as Name, is_policy_checked from sys.sql_logins where type='S'"> 3.03.txt
type 3.03.txt | findstr /v "##MS ("                                                          >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [�н����� ���⵵ ���� Ȯ��]                                                             >> %COMPUTERNAME%-result.txt
echo -------------------------------------------------------------------------------         >> %COMPUTERNAME%-result.txt
type secedit.txt | find "PasswordComplexity"                                                 >> %COMPUTERNAME%-result.txt
echo.                                                                                         >> %COMPUTERNAME%-result.txt
del /F 3.03.txt 2>null
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0303 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0304 START
echo 0304 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########    ��й�ȣ�� �ֱ����� ����    ########## >> %COMPUTERNAME%-result.txt
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
echo 0304 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F expiation.txt 2>null



echo 0305 START
echo 0305 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###   listener ��й�ȣ ���� �� ����Ʈ ��Ʈ ����    ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: listener�� ��й�ȣ ������ ���������� �Ǿ� �ְ�, ��Ʈ��ȣ�� ����Ʈ ��Ʈ��ȣ�� �ƴ� ��� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0305 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       4. ���� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0401 START
echo 0401 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     DBA�̿��� �ΰ����� ���� ����ڰ� �ý��� ���̺� ������ �� ������ ����     ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: DBA�� ���� ������ ���̺� �Ϲ� ����� ������ �Ұ��� �� ��� ��ȣ				 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �Ʒ� ������� �������� ������ ��ȣ                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(su.name as varchar(30)) AS Principal, cast(ao.name as varchar(20)) AS Object, cast(p.permission_name as varchar(20)) AS Permission from sys.database_permissions p, sys.database_principals dp, sys.all_objects ao, sys.sysusers su where ao.object_id=p.major_id and p.grantee_principal_id=dp.principal_id and p.grantee_principal_id=su.uid and dp.name='public' and dp.name='guest' and ao.type='S';">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0401 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo 0402 START
echo 0402 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #########   ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ����   ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���ʿ��� ODBC/OLE-DB�� ��ġ���� ���� ��� ��ȣ									 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0402 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0403 START
echo 0403 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �����ͺ��̽��� �ֿ� ��������, �н����� ���� �� �ֿ� ���ϵ��� ���� ���� ������ ����  >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �ֿ� ���� ���� �� ���͸��� �۹̼� ������ �Ǿ��ִ� ��� ��ȣ					 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0403 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0404 START
echo 0404 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     �����ͺ��̽��� �ֿ� ���� ��ȣ ���� ���� DB ������ umask ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������ umask�� 022 �̻����� �����Ǿ��ִ� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0404 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  



echo 0405 START
echo 0405 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     ����Ŭ ������ �α� �� trace ���Ͽ� ���� ���ϱ��� ������ ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �ֿ� ���� ���� �� �α� ���Ͽ� ���� �۹̼��� �����ڷ� ������ ��� ��ȣ			 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0405 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       5. �ɼ� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0501 START
echo 0501 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     �н����� Ȯ���Լ� ���� ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �н����� ���� �Լ��� ������ ����Ǵ� ��� ��ȣ																	 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																																									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0501 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null
del /F Local_Security_plicy.txt 2>null



echo 0502 START
echo 0502 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     Role�� ���� grant option ���� ����     ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: WITH_GRANT_OPTION�� ROLE�� ���Ͽ� �����Ǿ��ִ� ��� ��ȣ>> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0502 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0503 START
echo 0503 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     �ΰ����� ���� Object Owner�� ���� ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Object Owner �� ������ SYS, SYSTEM, ������ ���� ������ ���ѵ� ��� ��ȣ		 		 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0503 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  

echo 0504 START
echo 0504 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     �����ͺ��̽��� �ڿ� ���� ��� ���� ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: RESOURCE_LIMIT ������ TRUE�� �Ǿ��ִ� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0504 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       6. ���� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0601 START
echo 0601 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     DBA ���� ���� ����      ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: SYS, SYSTEM �� DBA������ �� �ʿ��� ������ DBA������ ���� �� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(SP2.[name] as varchar(30)) AS 'ServerRole', cast(SP1.[name] as varchar(30)) AS 'ID' FROM sys.server_principals SP1 JOIN sys.server_role_members SRM ON SP1.principal_id = SRM.member_principal_id JOIN sys.server_principals SP2 ON SRM.role_principal_id = SP2.principal_id where SP2.[name]='sysadmin' ORDER BY SP1.[name], SP2.[name]">> sysadmin.txt
type sysadmin.txt | findstr /v "##MS \SQLServer \SYSTEM SQLEXPRESS (" >>%COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0601 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F sysadmin.txt 2>null




echo 0602 START
echo 0602 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###   ���ݿ��� DB �������� ���� ����   ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� IP �� ��Ʈ�� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ						 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo (��������)                                                                              >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0602 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0603 START
echo 0603 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######    OS_ROLES,  REMOTE_OS_ROLES ����    #######   								>> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES������ FALSE�� �Ǿ��ִ� ��� >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																																									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0603 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0604 START
echo 0604 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   �������α׷� �Ǵ� DBA ������ Role�� Public ���� ����   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: DBA ������ Role�� Public���� �����Ǿ����� ���� ��� ��ȣ						 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �Ʒ� ������� �������� ������ ��ȣ                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT s.name + '.' + o.name AS ObjectName, COALESCE(p.name, p2.name) AS OwnerName FROM sys.all_objects o LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id WHERE s.name IN ('public', 'guest')">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0604 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       7. ���� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 0701 START
echo 0701 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########          ���� Idle timeout ����          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� Idle timeout ����(5��) Ȥ�� ���� �ַ���� ���Ͽ� �ش� ��� ����ϴ� ��� ��ȣ									 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT @@LOCK_TIMEOUT;"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0701 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       8. ��ġ ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0801 START
echo 0801 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######    �����ͺ��̽� �ֽ� ������ġ�� ��� �ǰ���� ����   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������ �ֽ� ��ġ�� ������ ��� ��ȣ											 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0801 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0802 START
echo 0802 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     ���ȿ� ������� ���� ������ �����ͺ��̽� ��� ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� ��ġ�� �����Ǵ� ������ ����ϴ� ��� ��ȣ									 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0802 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  


echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       9. ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 0901 START
echo 0901 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########             ���� ��� ���� ����             ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����1: DBMS�� ���� �α� ���� ��å�� �����Ǿ� ������, ��å�� ����Ǿ��ִ� ��� 		 >> %COMPUTERNAME%-result.txt
echo         0x3�� ������ ������ ���� ���, 0x3 : ������ �α��ΰ� ������ �α��� ���    	 >> %COMPUTERNAME%-result.txt
echo         0x0 : �̼���, 0x1 : ������ �α��θ�, 0x2 : ������ �α��θ�    					 >> %COMPUTERNAME%-result.txt
echo �� ����2: ��ü �⺻ ���� ����� ���� �� �̰ų�(audit_trail=none �ܿ� ����) �ַ���� ���� DBMS���� ����� ���� �� �� ��� ��ȣ								 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.
echo [Registry ���� ��]                                                                      >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "AuditLevel"                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [���� �α� ���� ��å]                                                                   >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "DECLARE @AuditLevel int EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', @AuditLevel OUTPUT SELECT CASE WHEN @AuditLevel = 0 THEN 'None' WHEN @AuditLevel = 1 THEN 'Successful logins only' WHEN @AuditLevel = 2 THEN 'Failed logins only' WHEN @AuditLevel = 3 THEN 'Both failed and successful logins' END AS [AuditLevel]" >> %COMPUTERNAME%-result.txt
                                                                                        >> %COMPUTERNAME%-result.txt
echo ���ͺ� ���� : ������ ���� ���� �Ǵ� ���� �ַ���� ���� DBMS���� ����� �����ϴ��� ���� Ȯ�� �ʿ� >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0901 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       10. ������ ������ ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 1001 START
echo 1001 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################          DB���� �߿����� ��ȣȭ ���� ����          #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ��й�ȣ Į��(Column)�� ��ȣȭ �Ǿ� ����� ��� ��ȣ>> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ���ͺ� ���� : ����� ���ͺ� �� �ǻ������� ���� ��й�ȣ �Ǵ� �ֹε�Ϲ�ȣ �� �߿������� ���� ��ȣȭ�� ����Ǿ� �ִ��� ���� Ȯ�� >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1001 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       11. �α� ����      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 1101 START
echo 1101 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     �����ͺ��̽� ������ ������ Audit Table�� ���� �ִ� ����    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Audit Table ���� ������ ������ �������� ������ ��� 							 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �ش���� ���� (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1101 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  




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
