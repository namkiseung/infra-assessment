@echo off
TITLE MSSQL Security Check
setlocal

echo.
echo.



echo ※ 해당 값을 입력하지 않거나 틀릴 경우 스크립트가 정상 작동하지 않습니다. ※
set /p ID=ID를 입력해주세요 : 
set /p PW=PW를 입력해주세요 : 
set /p DBnameI=인스턴스명을 입력해주세요 : 
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
echo ■■■■■■■■■■■■■■■■■■■                MSSQL Security Check            ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■                    SK think                  ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  Start Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  >> %COMPUTERNAME%-result.txt
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
echo ##########################       1. 계정 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo D-01 START
echo D-01 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########           기본 계정의 패스워드, 정책 등을 변경하여 사용           ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 기본 계정의 패스워드를 변경하여 사용하는 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-01 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo D-02 START
echo D-02 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   scott 등 Demonstration 및 불필요 계정을 제거하거나 잠금 설정 후 사용  ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 계정 정보를 확인하여 불필요한 계정이 없는 경우 양호							 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-02 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-03 START
echo D-03 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########       패스워드의 사용기간 및 복잡도 기관 정책에 맞도록 설정       ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 패스워드를 주기적으로 변경하고, 패스워드 정책이 적용되어 있는 경우 양호		 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(name as varchar(30)) as Name, is_expiration_checked, is_disabled from sys.sql_logins where type='S'">> expiation.txt
type expiation.txt | findstr /v "##MS"													 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [패스워드 만료기간 설정 확인]>> %COMPUTERNAME%-result.txt
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
echo ##########     데이터베이스 관리자 권한을 꼭 필요한 계정 및 그룹에 허용      ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 계정별 관리자권한이 차등 부여 되어 있는 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
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
echo ####################          패스워드 재사용에 대한 제약          #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: is_policy_checked 활성화, Length of password history maintained 파라미터 설정이 적용된 경우 양호>> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
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
echo ####################          DB 사용자 계정 개별적 부여           #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 사용자별 계정을 사용하고 있는 경우 양호										 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-06 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-07 START
echo D-07 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################         원격에서 DB 서버로의 접속 제한        #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 허용된 IP 및 포트에 대한 접근 통제가 되어 있는 경우 양호						 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo (수동점검)                                                                              >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-07 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-08 START
echo D-08 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########    DBA이외의 인가되지 않은 사용자 시스템 테이블 접근 제한 설정    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: DBA만 접근 가능한 테이블에 일반 사용자 접근이 불가능 할 경우 양호				 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 아래 결과값이 존재하지 않으면 양호                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(su.name as varchar(30)) AS Principal, cast(ao.name as varchar(20)) AS Object, cast(p.permission_name as varchar(20)) AS Permission from sys.database_permissions p, sys.database_principals dp, sys.all_objects ao, sys.sysusers su where ao.object_id=p.major_id and p.grantee_principal_id=dp.principal_id and p.grantee_principal_id=su.uid and dp.name='public' and dp.name='guest' and ao.type='S';">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-08 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-09 START
echo D-09 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########          오라클 데이터베이스의 경우 리스너 패스워드 설정          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Listener의 패스워드가 설정되어 있는 경우 양호									 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-09 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-10 START
echo D-10 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########         불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 불필요한 ODBC/OLE-DB가 설치되지 않은 경우 양호									 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-10 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-11 START
echo D-11 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########             일정 횟수의 로그인 실패 시 잠금 정책 설정             ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 로그인 시도 횟수를 제한하는 값을 설정한 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
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
echo ###   데이터베이스의 주요 파일 보호 등을 위해 DB 계정의 umask를 022이상으로 설정    ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 계정의 umask가 022 이상으로 설정되어있는 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-12 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-13 START
echo D-13 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###   데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 설정   ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 주요 설정 파일 및 디렉터리의 퍼미션 설정이 되어있는 경우 양호					 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-13 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-14 START
echo D-14 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo 관리자 이외의 사용자가 오라클 리스너의 접속을 통해 리스너 로그 및 trace 파일에 대한 변경 권한 제한 >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 주요 설정 파일 및 로그 파일에 대한 퍼미션을 관리자로 설정한 경우 양호			 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-14 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-15 START
echo D-15 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   응용프로그램 또는 DBA 계정의 Role이 Public으로 설정되지 않도록 조정   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: DBA 계정의 Role이 Public으로 설정되어있지 않은 경우 양호						 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 아래 결과값이 존재하지 않으면 양호                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT s.name + '.' + o.name AS ObjectName, COALESCE(p.name, p2.name) AS OwnerName FROM sys.all_objects o LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id WHERE s.name IN ('public', 'guest')">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-15 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-16 START
echo D-16 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######    OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES를 FALSE로 설정   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES설정이 FALSE로 되어있는 경우 >> %COMPUTERNAME%-result.txt
echo ■ 현황																																									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-16 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-17 START
echo D-17 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###################     패스워드 확인함수가 설정되어 적용되는가     ################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 패스워드 검증 함수로 검증이 진행되는 경우 양호																	 >> %COMPUTERNAME%-result.txt
echo ■ 현황																																									 >> %COMPUTERNAME%-result.txt
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
echo #################     인가되지 않은 Object Owner가 존재하지 않는가    ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Object Owner 의 권한이 SYS, SYSTEM, 관리자 계정 등으로 제한된 경우 양호		 		 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 아래 결과값이 존재하지 않으면 양호                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT s.name + '.' + o.name AS ObjectName, COALESCE(p.name, p2.name) AS OwnerName FROM sys.all_objects o LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id WHERE s.name IN ('public', 'guest')">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-18 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-19 START
echo D-19 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##################     grant option이 role에 의해 부여되도록 설정   ################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: WITH_GRANT_OPTION이 ROLE에 의하여 설정되어있는 경우 양호>> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ☞ With Grant Option 권한 부여 계정 확인(결과 값이 없으면 양호) >> %COMPUTERNAME%-result.txt
echo.>> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT name FROM sys.databases" | findstr /v "^(" | findstr .>> grant.txt
FOR /F "tokens=1 skip=2" %%i IN (grant.txt) DO (
echo *************************************************************************************** > withgrant.txt
echo [DB명] %%i>> withgrant.txt
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
echo ##########            데이터베이스의 자원 제한 기능을 TRUE로 설정            ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: RESOURCE_LIMIT 설정이 TRUE로 되어있는 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-20 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-21 START
echo D-21 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #########   데이터베이스에 대해 최신 보안패치와 밴더 권고 사항을 모두 적용   ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 버전별 최신 패치를 적용한 경우 양호											 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-21 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-22 START
echo D-22 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo 데이터베이스의 접근, 변경, 삭제 등의 감사기록이 기관의 감사기록 정책에 적합하도록 설정  >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: DBMS의 감사 로그 저장 정책이 수립되어 있으며, 정책이 적용되어있는 경우 		 >> %COMPUTERNAME%-result.txt
echo         0x3을 제외한 나머지 전부 취약, 0x3 : 실패한 로그인과 성공한 로그인 모두    	 >> %COMPUTERNAME%-result.txt
echo         0x0 : 미설정, 0x1 : 성공한 로그인만, 0x2 : 실패한 로그인만    					 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [Registry 설정 값]                                                                      >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "AuditLevel"                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [감사 로그 저장 정책]                                                                   >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "DECLARE @AuditLevel int EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', @AuditLevel OUTPUT SELECT CASE WHEN @AuditLevel = 0 THEN 'None' WHEN @AuditLevel = 1 THEN 'Successful logins only' WHEN @AuditLevel = 2 THEN 'Failed logins only' WHEN @AuditLevel = 3 THEN 'Both failed and successful logins' END AS [AuditLevel]" >> %COMPUTERNAME%-result.txt

echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-22 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-23 START
echo D-23 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     보안에 취약하지 않은 버전의 데이터베이스를 사용하고 있는가    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 보안 패치가 지원되는 버전을 사용하는 경우 양호									 >> %COMPUTERNAME%-result.txt
echo         2005버전의 경우 EOS되어 더이상 패치를 지원하고 있지 않음						 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"															     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-23 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo D-24 START
echo D-24 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     Audit Table은 데이터베이스 관리자 계정에 속해 있도록 설정     ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Audit Table 접근 권한이 관리자 계정으로 설정한 경우 							 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo D-24 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.
echo.
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############                   SYSTEM 정보 출력                 #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
systeminfo                                                                                   >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############                   SECPOL 정보 출력                 #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
@secedit /EXPORT /CFG secedit.txt
type secedit.txt >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F secedit.txt
del /F null
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   END Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   >> %COMPUTERNAME%-result.txt
echo MSSQL Security Check is Finished
pause
echo.
echo.
