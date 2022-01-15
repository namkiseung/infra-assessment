@echo. > %COMPUTERNAME%-MYSQL-result.txt
::@mode con: cols=80 lines=30
@setlocal
@echo off

echo (ex: C:\Program Files\MySQL\MySQL Server 5.6)
set /p installdir=[INPUT MY-SQL Installed Directory] : 
		::set SQLCMD=%installdir%/bin/mysql

set /p admid=[INPUT MY-SQL ID]  : 
set /p admpwd=[INPUT MY-SQL PWD] : 

::sql쿼리문을 위한 파일 path 변수
set currentdir="%cd%"
mkdir if_mytmp
set TmpFilePath=%currentdir%\if_mytmp

::sql 쿼리문 이외(버전 체크 등)에 들어갈 파일path 변수 (for문안에 "들어가면 에러남으로 별도 생성함)
set currentdir_re=%cd%
set "tmpp=%currentdir_re%\if_mytmp"

::@echo %currentdir_re% >> %COMPUTERNAME%-MYSQL-result.txt
::@echo tmpp는 %tmpp% >> %COMPUTERNAME%-MYSQL-result.txt

set SQLCMD="%installdir%/bin/mysql" -u%admid% -p%admpwd%

::버전체크
%SQLCMD% -e "select version();" -t > %TmpFilePath%\if_mv.txt
type %TmpFilePath%\if_mv.txt | find /V "+" | find /I /V "version" > %TmpFilePath%\if_mvre.txt 


::@type %TmpFilePath%\if_mvre.txt >> %COMPUTERNAME%-MYSQL-result.txt


::마리아 / mysql goto 구문으로 구분
type %TmpFilePath%\if_mvre.txt | find /I "maria"
IF NOT ERRORLEVEL 1 (
		goto mariadb01
)	ELSE (
		goto mysql01
)


::마리아 영역진입
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

::마리아 진행 시 mysql로 다시 들어가지 않게 점프
type %TmpFilePath%\if_mvre.txt | find /I "maria"
IF NOT ERRORLEVEL 1 goto jump1

::MySQL 영역진입
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

::@echo currentdir은 %currentdir% 입니다. >> %COMPUTERNAME%-MYSQL-result.txt
::@echo TmpFilePath는 %TmpFilePath% 입니다. >> %COMPUTERNAME%-MYSQL-result.txt
::@echo TmpFilePath_re는 %TmpFilePath_re% 입니다. >> %COMPUTERNAME%-MYSQL-result.txt

@echo.
set DBVersion=19.1
set Last_modify=2019.02

@echo MYSQL Security check                                                                    >> %COMPUTERNAME%-MYSQL-result.txt
@echo Copyright (c) 2019 SK think Co. Ltd. All right Reserved                                >> %COMPUTERNAME%-MYSQL-result.txt
@color 9f
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■■■■■■■■■■■■■■■■               MY-SQL Security Check(2019)            ■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■■■■■■■■■■■■■■■■                      SK think                      ■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo SCRIPT_VERSION %DBVersion%                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo LAST_UPDATE %Last_modify%                                                               >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##############################  Start Time ##################################
@echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  Start Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ##########################       1. 사용자 인증      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo 0101 START
@echo 0101 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  비인가자의 접근 차단을 위한 사용자 계정 관리 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 계정 정보를 확인하여 불필요한 계정이 없는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user where user!='root';" -t > %TmpFilePath%\1_1.txt
find "+" %TmpFilePath%\1_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo root계정 이외의 계정이 존재하지 않음(쿼리 결과 없음) >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo 0101 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 사용하지 않거나 불필요한 계정이 있을경우 삭제하여야 합니다. >> %COMPUTERNAME%-MYSQL-result.txt
@echo Anonymous 계정(user 컬럼이 빈칸)이 존재하고, 패스워드가 설정되어 있지 않으면 DB에 임의 접속이 가능함. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0102 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0102 START
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  로그인 실패 횟수에 따른 잠금시간 등 계정 잠금 정책 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 로그인 시도 횟수를 제한하는 값을 설정한 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo "MySQL에서 해당 기능 지원하지 않음(N/A)" >> %COMPUTERNAME%-MYSQL-result.txt
echo "단, 솔루션, 트리거 등을 이용할 경우 기능 구현 가능" >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  SYSDBA 로그인 제한 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: root 패스워드가 null로 설정되어있는 경우 취약>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo "MySQL root 패스워드 null 설정 확인" >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ##########################       2. 계정 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0201 START
@echo 0201 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  패스워드 재사용에 대한 제약이 설정 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX 파라미터 설정이 적용된 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                              >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  DB 사용자 계정을 개별적으로 부여 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 사용자별 계정을 사용하고 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\2_2.txt
find "+" %TmpFilePath%\2_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\2_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo "계정이 존재하지 않음(쿼리 결과 없음)" >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0202 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
echo '공용계정 사용 금지' >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       3. 비밀번호 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0301 START
@echo 0301 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  유추가능한 비밀번호 설정여부(DB계정) >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 비밀번호 유추 가능 계정이 존재하지 않을 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "인터뷰-담당자 인터뷰를 통해 우추 가능한 패스워드를 사용하는지 여부 점검" >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0301 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0302 START
@echo 0302 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  기본 계정 및 패스워드 변경(디폴트 ID 및 패스워드 변경 및 잠금) >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 기본 계정의 패스워드를 변경하여 사용하는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

:: mysql 5.7 이상만
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string from mysql.user where user='root';" -t > %TmpFilePath%\3_2.txt
) else (
	%SQLCMD% -e "select host, user, password from mysql.user where user='root';" -t > %TmpFilePath%\3_2.txt
)

find "+" %TmpFilePath%\3_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\3_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo 쿼리 결과 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0302 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 해당 호스트에 대하여 Null User/Password가 사용되고 있다면 Null User를 패스워드 변경 및 삭제하여야 합니다. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0303 START
@echo 0303 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  비밀번호 복잡도 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준:  비밀번호 복잡도 설정이 되어 있거나, 관련 솔루션을 통하여 복잡도 설정이 통제되는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo 현재 버전은 %myVer_name%입니다. 버전에 따라 인터뷰 필요 >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재 >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● Plugin 경로 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\3_3_1.txt
type %TmpFilePath%\3_3_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● validate_password Plugin 활성화 여부 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\3_3_0.txt
find "+" %TmpFilePath%\3_3_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\3_3_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin 비활성화 >> %COMPUTERNAME%-MYSQL-result.txt
)

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● 패스워드 검증 관련 파라미터(plugin 관련) >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  비밀번호의 주기적인 변경 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 패스워드를 주기적으로 변경하고, 패스워드 정책이 적용되어 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
 
echo 현재 버전은 %myVer_name%입니다. 버전에 따라 인터뷰 필요 >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재 >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● Plugin 경로 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\3_4_1.txt
type %TmpFilePath%\3_4_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● validate_password Plugin 활성화 여부 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\3_4_0.txt
find "+" %TmpFilePath%\3_4_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\3_4_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin 비활성화 >> %COMPUTERNAME%-MYSQL-result.txt
)

::MySQL 5.7이상만
echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● 패스워드 만료, 변경일자, 계정잠김 등 컬럼 >> %COMPUTERNAME%-MYSQL-result.txt
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > %TmpFilePath%\3_4_3.txt
	type %TmpFilePath%\3_4_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ☞ 5.7미만 해당 컬럼 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0304 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "v5.6 미만은 인터뷰" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "v5.6 이상에서 validate_password Plugin 사용시 설정(아래를 만족하면 양호))" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_length 8 (이상)" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_mixed_case_count 1" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_number_count 1" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_policy MEDIUM" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "LOW (8자 이상), MEDIUM (기본 8자 이상,숫자,소문자,대문자,특수문자를 포함), STRONG(기본 8자 이상,숫자,소문자,대문자,특수문자,사전단어 포함)" >> %COMPUTERNAME%-MYSQL-result.txt
@echo "- Validate_password_special_char_count 1" >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0305 START
@echo 0305 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  listener 비밀번호 설정 및 디폴트 포트 변경 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: listener의 비밀번호 설정이 정상적으로 되어 있고, 디폴트 포트번호가 아닌 경우>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0305 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       4. 접근 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0401 START
@echo 0401 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  DBA이외의 인가되지 않은 사용자가 시스템 테이블에 접근할 수 없도록 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: DBA만 접근 가능한 테이블에 일반 사용자 접근이 불가능 할 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql User 권한] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user,select_priv from mysql.user where select_priv='Y' and user<>'root';" -t > %TmpFilePath%\4_1_1.txt
find "+" %TmpFilePath%\4_1_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\4_1_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql User에 select권한이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql DB 권한] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user, db, select_priv from mysql.db where (db='mysql' and select_priv='Y') and user<>'root';" -t > %TmpFilePath%\4_1_2.txt
find "+" %TmpFilePath%\4_1_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\4_1_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql DB에 select 권한이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql Table 권한] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select DB,USER,TABLE_NAME, TABLE_PRIV from mysql.tables_priv where (db='mysql' and table_name='user') and table_priv='select';" -t > %TmpFilePath%\4_1_3.txt
find "+" %TmpFilePath%\4_1_3.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\4_1_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql Table에 select 권한이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0401 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "root를 제외한 일반계정에 select권한이 부여되어있는지 확인 후, 부여된 계정에 대하여 타당성 검토 후 불필요시 권한을 회수하여야 함."  >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0402 START
@echo 0402 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 불필요한 ODBC/OLE-DB가 설치되지 않은 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL 해당사항 없음 (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt                                                                                       >> %COMPUTERNAME%-MYSQL-result.txt

@echo 0402 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0403 START
@echo 0403 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 적절성 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 주요 설정 파일 및 디렉터리의 퍼미션 설정이 되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL 해당사항 없음 (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt                                                                                       >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0403 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0404 START
@echo 0404 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  데이터베이스의 주요 파일 보호 등을 위한 DB 계정의 umask 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 계정의 umask가 022 이상으로 설정되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo Win MySQL 해당사항 없음 (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0404 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0405 START
@echo 0405 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  오라클 리스너 로그 및 trace 파일에 대한 파일권한 적절성 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 주요 설정 파일 및 로그 파일에 대한 퍼미션을 관리자로 설정한 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0405 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       5. 옵션 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0501 START
@echo 0501 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  패스워드 확인함수 적용 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 패스워드 검증 함수로 검증이 진행되는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0501 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0502 START
@echo 0502 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  Role에 의한 grant option 설정 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: WITH_GRANT_OPTION이 ROLE에 의하여 설정되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0502 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0503 START
@echo 0503 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  인가되지 않은 Object Owner가 존재 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: Object Owner 의 권한이 SYS, SYSTEM, 관리자 계정 등으로 제한된 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0503 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0504 START
@echo 0504 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  데이터베이스의 자원 제한 기능 설정 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: RESOURCE_LIMIT 설정이 TRUE로 되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0504 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       6. 권한 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0601 START
@echo 0601 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  DBA 계정 권한 관리 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 계정별 관리자권한이 차등 부여 되어 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user,select_priv,insert_priv,Delete_priv from mysql.user where (select_priv='Y' or insert_priv='Y' or delete_priv='Y') and user<>'root';" -t > %TmpFilePath%\6_1.txt
find "+" %TmpFilePath%\6_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\6_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo select_priv, insert_priv, delete_priv 권한이 부여된 계정이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0601 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 'root를 제외한 일반계정에 select_priv, insert_priv, delete_priv권한 등이 부여되어있는지 확인 후, 부여된 계정에 대하여 타당성 검토 후 불필요시 권한을 회수하여야 함' >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0602 START
@echo 0602 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  원격에서 DB 서버로의 접속 제한 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 허용된 IP 및 포트에 대한 접근 통제가 되어 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.user테이블 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\6_2_1.txt
find "+" %TmpFilePath%\6_2_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\6_2_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo 쿼리결과 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.db테이블 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.db;" -t > %TmpFilePath%\6_2_2.txt
find "+" %TmpFilePath%\6_2_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\6_2_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo 쿼리결과 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0602 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo host 항목에 대해 %% 설정이 되어 있는 경우 모든 IP에 대한 접근이 가능함으로 제거하여야 함. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0603 START
@echo 0603 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  OS_ROLES,  REMOTE_OS_ROLES 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES설정이 FALSE로 되어있는 경우>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0603 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt



@echo 0604 START
@echo 0604 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  응용프로그램 또는 DBA 계정의 Role의 Public 설정 점검 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: DBA 계정의 Role이 Public으로 설정되어있지 않은 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 0604 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       7. 설정 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0701 START
@echo 0701 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  세션 Idle timeout 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 세션 Idle timeout 설정(5분) 혹은 관련 솔루션을 통하여 해당 기능 사용할 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo "timeout 설정 쿼리결과" >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ##########################       8. 패치 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0801 START
@echo 0801 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  데이터베이스 최신 보안패치와 밴더 권고사항 적용 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 버전별 최신 패치를 적용한 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select version();" -t > %TmpFilePath%\8_1.txt
type %TmpFilePath%\8_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "2017년 1월 기준" >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  보안에 취약하지 않은 버전의 데이터베이스 사용 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 보안 패치가 지원되는 버전을 사용하는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ##########################       9. 감사      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 0901 START
@echo 0901 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  감사 기능 설정 점검 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 자체 기본 감사 기능이 실행 중 이거나 솔루션을 통해 DBMS감사 기능을 수행 중 일 경우 양호 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ##########################       10. 관리적 물리적 보안      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 1001 START
@echo 1001 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  DB서버 중요정보 암호화 적용 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 비밀번호 칼럼(Column)에 암호화 되어 저장될 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.   

@echo 인터뷰-담당자 인터뷰 및 실사점검을 통해 중요정보(개인정보, 비밀번호 등)의 암호화 여부 및 알고리즘 >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 1001 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##########################       11. 로그 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt


@echo 1101 START
@echo 1101 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  데이터베이스 관리자 계정에 Audit Table이 속해 있는 여부 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: Audit Table 접근 권한이 관리자 계정으로 설정한 경우 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
::%SQLCMD% -e "select table_schema, table_name from information_schema.tables where table_name='%%aud%%'" -t >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ###############                   SYSTEM 정보 출력                 #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
systeminfo                                                                                   >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo #############                      my.ini 출력                    #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
IF EXIST "%installdir%"\my.ini (
	type "%installdir%"\my.ini > %TmpFilePath%\if_my_ini.txt
	type %TmpFilePath%\if_my_ini.txt >> %COMPUTERNAME%-MYSQL-result.txt
) ELSE (
	echo "%installdir%"경로에 my.ini 존재하지 않음.                            				 >> %COMPUTERNAME%-MYSQL-result.txt
)
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo #############  로그관련 변수 출력 (show global variables like '%%log%%';) #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%log%%';" -t > %TmpFilePath%\if_logv.txt
type %TmpFilePath%\if_logv.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ###############                플러그인 출력(show plugins;)        #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show plugins;" -t > %TmpFilePath%\plugins.txt
type %TmpFilePath%\plugins.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt





@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ###############       datadir(show global variables like 'datadir';)      #################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like 'datadir';" -t > %TmpFilePath%\if_datadir.txt
echo datadir 경로 >> %COMPUTERNAME%-MYSQL-result.txt
type %TmpFilePath%\if_datadir.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo datadir 경로 내 dir  >> %COMPUTERNAME%-MYSQL-result.txt
type %TmpFilePath%\if_datadir.txt | find /I "datadir" > %TmpFilePath%\if_datadir_re.txt
for /F "usebackq tokens=2 delims=|" %%a in ("%tmpp%\if_datadir_re.txt") do dir %%a >> %COMPUTERNAME%-MYSQL-result.txt 2>nul
::for /F "usebackq tokens=2 delims=|" %%a in ("%tmpp%\if_datadir_re.txt") do set dirtmp=^"%%a^"
::set dirtmp=%dirtmp: =%
::dir %dirtmp% >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   END Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   >> %COMPUTERNAME%-MYSQL-result.txt
@date /t                                                                                      >> %COMPUTERNAME%-MYSQL-result.txt
@time /t                                                                                      >> %COMPUTERNAME%-MYSQL-result.txt
@echo ##############################   END Time ###################################
@echo.
@echo.
rd /q/s %TmpFilePath%
pause
EXIT