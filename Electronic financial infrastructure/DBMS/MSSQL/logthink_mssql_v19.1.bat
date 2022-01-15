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
echo ■■■■■■■■■■■■■■■■■■■                MSSQL Security Check            ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■                    SK think                  ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo SCRIPT_VERSION %DBVersion%                                                              >> %COMPUTERNAME%-result.txt
echo LAST_UPDATE %DBLast_update%                                                             >> %COMPUTERNAME%-result.txt
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
echo ##########################       1. 사용자 인증      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 0101 START
echo 0101 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########       비인가자의 접근 차단을 위한 사용자 계정 관리       ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 계정 정보를 확인하여 불필요한 계정이 없는 경우 양호							 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0101 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0102 START
echo 0102 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################          로그인 실패 횟수에 따른 잠금시간 등 계정 잠금 정책 설정           #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 로그인 시도 횟수를 제한하는 값을 설정한 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0102 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null




echo 0103 START
echo 0103 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########         SYSDBA 로그인 제한 설정          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 관리자 권한(SYSDBA)을 가진 DB계정으로 비밀번호 입력없이 접속이 불가능한 경우 양호  >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0103 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       2. 계정 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0201 START
echo 0201 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##################     패스워드 재사용에 대한 제약이 설정 여부   ################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: is_policy_checked 활성화, Length of password history maintained 파라미터 설정이 적용된 경우 양호>> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0201 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null




echo 0202 START
echo 0202 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########            DB 사용자 계정을 개별적으로 부여            ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 사용자별 계정을 사용하고 있는 경우 양호										 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT cast(name as varchar(20)) as name, password_hash FROM master.sys.sql_logins">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0202 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       3. 비밀번호 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0301 START
echo 0301 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########           유추가능한 비밀번호 설정여부(DB계정)           ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 비밀번호 유추 가능 계정이 없을 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 인터뷰 점검 : 담당자 인터뷰를 통해 비밀번호를 정책에 맞게 설정하는지 여부 확인 필요								 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0301 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo 0302 START
echo 0302 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   기본 계정 및 패스워드 변경(디폴트 ID 및 패스워드 변경 및 잠금)  ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 기본 계정의 패스워드를 변경하여 사용하는 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(loginname as varchar(20)) as Name, pwdcompare('', password) Password_value from syslogins where loginname='sa'">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0302 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo 0303 START
echo 0303 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################         비밀번호 복잡도 설정        #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 자체적으로 비밀번호 복잡도 설정이 되어 있거나, 관련 솔루션을 통하여 복잡도 설정이 통제되는 경우 양호		 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(name as varchar(30)) as Name, is_policy_checked from sys.sql_logins where type='S'"> 3.03.txt
type 3.03.txt | findstr /v "##MS ("                                                          >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [패스워드 복잡도 설정 확인]                                                             >> %COMPUTERNAME%-result.txt
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
echo ##########    비밀번호의 주기적인 변경    ########## >> %COMPUTERNAME%-result.txt
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
echo 0304 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F expiation.txt 2>null



echo 0305 START
echo 0305 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###   listener 비밀번호 설정 및 디폴트 포트 변경    ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: listener의 비밀번호 설정이 정상적으로 되어 있고, 포트번호가 디폴트 포트번호가 아닌 경우 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0305 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       4. 접근 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0401 START
echo 0401 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     DBA이외의 인가되지 않은 사용자가 시스템 테이블에 접근할 수 없도록 설정     ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: DBA만 접근 가능한 테이블에 일반 사용자 접근이 불가능 할 경우 양호				 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 아래 결과값이 존재하지 않으면 양호                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select cast(su.name as varchar(30)) AS Principal, cast(ao.name as varchar(20)) AS Object, cast(p.permission_name as varchar(20)) AS Permission from sys.database_permissions p, sys.database_principals dp, sys.all_objects ao, sys.sysusers su where ao.object_id=p.major_id and p.grantee_principal_id=dp.principal_id and p.grantee_principal_id=su.uid and dp.name='public' and dp.name='guest' and ao.type='S';">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0401 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt




echo 0402 START
echo 0402 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #########   불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거   ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 불필요한 ODBC/OLE-DB가 설치되지 않은 경우 양호									 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0402 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0403 START
echo 0403 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 적절성 여부  >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 주요 설정 파일 및 디렉터리의 퍼미션 설정이 되어있는 경우 양호					 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0403 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0404 START
echo 0404 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     데이터베이스의 주요 파일 보호 등을 위한 DB 계정의 umask 설정    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 계정의 umask가 022 이상으로 설정되어있는 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0404 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  



echo 0405 START
echo 0405 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     오라클 리스너 로그 및 trace 파일에 대한 파일권한 적절성 여부    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 주요 설정 파일 및 로그 파일에 대한 퍼미션을 관리자로 설정한 경우 양호			 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0405 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       5. 옵션 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0501 START
echo 0501 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     패스워드 확인함수 적용 여부    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 패스워드 검증 함수로 검증이 진행되는 경우 양호																	 >> %COMPUTERNAME%-result.txt
echo ■ 현황																																									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0501 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del /F policy.txt 2>null
del /F Local_Security_plicy.txt 2>null



echo 0502 START
echo 0502 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     Role에 의한 grant option 설정 여부     ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: WITH_GRANT_OPTION이 ROLE에 의하여 설정되어있는 경우 양호>> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0502 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0503 START
echo 0503 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     인가되지 않은 Object Owner가 존재 여부    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Object Owner 의 권한이 SYS, SYSTEM, 관리자 계정 등으로 제한된 경우 양호		 		 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0503 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  

echo 0504 START
echo 0504 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     데이터베이스의 자원 제한 기능 설정 여부    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: RESOURCE_LIMIT 설정이 TRUE로 되어있는 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0504 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  




echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       6. 권한 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0601 START
echo 0601 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     DBA 계정 권한 관리      ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: SYS, SYSTEM 등 DBA권한이 꼭 필요한 계정에 DBA권한이 설정 된 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
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
echo ###   원격에서 DB 서버로의 접속 제한   ### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 허용된 IP 및 포트에 대한 접근 통제가 되어 있는 경우 양호						 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo (수동점검)                                                                              >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0602 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0603 START
echo 0603 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######    OS_ROLES,  REMOTE_OS_ROLES 설정    #######   								>> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES설정이 FALSE로 되어있는 경우 >> %COMPUTERNAME%-result.txt
echo ■ 현황																																									 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0603 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0604 START
echo 0604 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######   응용프로그램 또는 DBA 계정의 Role의 Public 설정 점검   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: DBA 계정의 Role이 Public으로 설정되어있지 않은 경우 양호						 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 아래 결과값이 존재하지 않으면 양호                                                      >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT s.name + '.' + o.name AS ObjectName, COALESCE(p.name, p2.name) AS OwnerName FROM sys.all_objects o LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id WHERE s.name IN ('public', 'guest')">> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0604 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       7. 설정 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 0701 START
echo 0701 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########          세션 Idle timeout 설정          ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 세션 Idle timeout 설정(5분) 혹은 관련 솔루션을 통하여 해당 기능 사용하는 경우 양호									 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "SELECT @@LOCK_TIMEOUT;"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0701 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       8. 패치 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0801 START
echo 0801 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #######    데이터베이스 최신 보안패치와 밴더 권고사항 적용   ####### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 버전별 최신 패치를 적용한 경우 양호											 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0801 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo 0802 START
echo 0802 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     보안에 취약하지 않은 버전의 데이터베이스 사용 여부    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 보안 패치가 지원되는 버전을 사용하는 경우 양호									 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "select @@version"																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0802 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  


echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       9. 감사      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 0901 START
echo 0901 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########             감사 기능 설정 점검             ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준1: DBMS의 감사 로그 저장 정책이 수립되어 있으며, 정책이 적용되어있는 경우 		 >> %COMPUTERNAME%-result.txt
echo         0x3을 제외한 나머지 전부 취약, 0x3 : 실패한 로그인과 성공한 로그인 모두    	 >> %COMPUTERNAME%-result.txt
echo         0x0 : 미설정, 0x1 : 성공한 로그인만, 0x2 : 실패한 로그인만    					 >> %COMPUTERNAME%-result.txt
echo ■ 기준2: 자체 기본 감사 기능이 실행 중 이거나(audit_trail=none 외에 설정) 솔루션을 통해 DBMS감사 기능을 수행 중 일 경우 양호								 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.
echo [Registry 설정 값]                                                                      >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "AuditLevel"                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [감사 로그 저장 정책]                                                                   >> %COMPUTERNAME%-result.txt
%MSSQLCMD% "DECLARE @AuditLevel int EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', @AuditLevel OUTPUT SELECT CASE WHEN @AuditLevel = 0 THEN 'None' WHEN @AuditLevel = 1 THEN 'Successful logins only' WHEN @AuditLevel = 2 THEN 'Failed logins only' WHEN @AuditLevel = 3 THEN 'Both failed and successful logins' END AS [AuditLevel]" >> %COMPUTERNAME%-result.txt
                                                                                        >> %COMPUTERNAME%-result.txt
echo 인터뷰 점검 : 감사기능 설정 여부 또는 별도 솔루션을 통해 DBMS감사 기능을 수행하는지 여부 확인 필요 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 0901 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       10. 관리적 물리적 보안      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 1001 START
echo 1001 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################          DB서버 중요정보 암호화 적용 여부          #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 비밀번호 칼럼(Column)에 암호화 되어 저장된 경우 양호>> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 인터뷰 점검 : 담당자 인터뷰 및 실사점검을 통해 비밀번호 또는 주민등록번호 등 중요정보에 대해 암호화가 적용되어 있는지 여부 확인 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1001 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt



echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################       11. 로그 관리      #################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt


echo 1101 START
echo 1101 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########     데이터베이스 관리자 계정에 Audit Table이 속해 있는 여부    ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Audit Table 접근 권한이 관리자 계정으로 설정한 경우 							 >> %COMPUTERNAME%-result.txt
echo ■ 현황																					 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1101 END                                                                                >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.  




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
