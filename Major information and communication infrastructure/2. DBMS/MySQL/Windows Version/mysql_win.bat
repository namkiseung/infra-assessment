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
set DBVersion=0.6.3
@echo MYSQL Security check                                                                    >> %COMPUTERNAME%-MYSQL-result.txt
@color 9f
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■■■■■■■■■■■■■■■■■■■               MY-SQL Security Check            ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo ##########################       1. 계정 관리      #################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt







@echo D-01 START
@echo D-01 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-01 기본 계정의 패스워드, 정책 등을 변경하여 사용 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 기본 계정의 패스워드를 변경하여 사용하는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

:: mysql 5.7 이상만
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string from mysql.user where user='root';" -t > %TmpFilePath%\1_1.txt
) else (
	%SQLCMD% -e "select host, user, password from mysql.user where user='root';" -t > %TmpFilePath%\1_1.txt
)

find "+" %TmpFilePath%\1_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo 쿼리 결과 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-01 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 해당 호스트에 대하여 Null User/Password가 사용되고 있다면 Null User를 패스워드 변경 및 삭제하여야 합니다. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt







@echo D-02 START
@echo D-02 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-02 scott 등 Demonstration 및 불필요 계정을 제거하거나 잠금 설정 후 사용 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 계정 정보를 확인하여 불필요한 계정이 없는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user where user!='root';" -t > %TmpFilePath%\1_2.txt
find "+" %TmpFilePath%\1_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo root계정 이외의 계정이 존재하지 않음(쿼리 결과 없음) >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-02 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 사용하지 않거나 불필요한 계정이 있을경우 삭제하여야 합니다. >> %COMPUTERNAME%-MYSQL-result.txt
@echo Anonymous 계정(user 컬럼이 빈칸)이 존재하고, 패스워드가 설정되어 있지 않으면 DB에 임의 접속이 가능함. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-03 START
@echo D-03 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-03 패스워드의 사용기간 및 복잡도 기관 정책에 맞도록 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 패스워드를 주기적으로 변경하고, 패스워드 정책이 적용되어 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo 현재 버전은 %myVer_name%입니다. 버전에 따라 인터뷰 필요 >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재 >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● Plugin 경로 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\1_3_1.txt
type %TmpFilePath%\1_3_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● validate_password Plugin 활성화 여부 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\1_3_0.txt
find "+" %TmpFilePath%\1_3_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\1_3_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin 비활성화 >> %COMPUTERNAME%-MYSQL-result.txt
)

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● 패스워드 검증 관련 파라미터(plugin 관련) >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%vali%%';" -t > %TmpFilePath%\1_3_2.txt
type %TmpFilePath%\1_3_2.txt | find /V "query_cache" >> %COMPUTERNAME%-MYSQL-result.txt

::MySQL 5.7이상만
echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● 패스워드 만료, 변경일자, 계정잠김 등 컬럼 >> %COMPUTERNAME%-MYSQL-result.txt
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > %TmpFilePath%\1_3_3.txt
	type %TmpFilePath%\1_3_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ☞ 5.7미만 해당 컬럼 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-03 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
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






@echo D-04 START
@echo D-04 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-04 데이터베이스 관리자 권한을 꼭 필요한 계정 및 그룹에 허용 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 계정별 관리자권한이 차등 부여 되어 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user,select_priv,insert_priv,Delete_priv from mysql.user where (select_priv='Y' or insert_priv='Y' or delete_priv='Y') and user<>'root';" -t > %TmpFilePath%\1_4.txt
find "+" %TmpFilePath%\1_4.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_4.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo select_priv, insert_priv, delete_priv 권한이 부여된 계정이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-04 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo 'root를 제외한 일반계정에 select_priv, insert_priv, delete_priv권한 등이 부여되어있는지 확인 후, 부여된 계정에 대하여 타당성 검토 후 불필요시 권한을 회수하여야 함' >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-05 START
@echo D-05 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-05 패스워드 재사용에 대한 제약 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX 파라미터 설정이 적용된 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-05 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-06 START
@echo D-06 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-06 DB 사용자 계정 개별적 부여 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 사용자별 계정을 사용하고 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\1_6.txt
find "+" %TmpFilePath%\1_6.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_6.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo "계정이 존재하지 않음(쿼리 결과 없음)" >> %COMPUTERNAME%-MYSQL-result.txt
)

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-06 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo '공용계정 사용 금지' >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-07 START
@echo D-07 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-07 원격에서 DB 서버로의 접속 제한 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 허용된 IP 및 포트에 대한 접근 통제가 되어 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.user테이블 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.user;" -t > %TmpFilePath%\1_7_1.txt
find "+" %TmpFilePath%\1_7_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_7_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo 쿼리결과 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.db테이블 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user from mysql.db;" -t > %TmpFilePath%\1_7_2.txt
find "+" %TmpFilePath%\1_7_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_7_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo 쿼리결과 없음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-07 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo host 항목에 대해 %% 설정이 되어 있는 경우 모든 IP에 대한 접근이 가능함으로 제거하여야 함. >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-08 START
@echo D-08 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-08 DBA이외의 인가되지 않은 사용자 시스템 테이블 접근 제한 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: DBA만 접근 가능한 테이블에 일반 사용자 접근이 불가능 할 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql User 권한] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user,select_priv from mysql.user where select_priv='Y' and user<>'root';" -t > %TmpFilePath%\1_8_1.txt
find "+" %TmpFilePath%\1_8_1.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_8_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql User에 select권한이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql DB 권한] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select host, user, db, select_priv from mysql.db where (db='mysql' and select_priv='Y') and user<>'root';" -t > %TmpFilePath%\1_8_2.txt
find "+" %TmpFilePath%\1_8_2.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_8_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql DB에 select 권한이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo. >> %COMPUTERNAME%-MYSQL-result.txt

echo [Mysql Table 권한] >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select DB,USER,TABLE_NAME, TABLE_PRIV from mysql.tables_priv where (db='mysql' and table_name='user') and table_priv='select';" -t > %TmpFilePath%\1_8_3.txt
find "+" %TmpFilePath%\1_8_3.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_8_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo Mysql Table에 select 권한이 존재하지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-08 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo "root를 제외한 일반계정에 select권한이 부여되어있는지 확인 후, 부여된 계정에 대하여 타당성 검토 후 불필요시 권한을 회수하여야 함."  >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-09 START
@echo D-09 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-09 오라클 데이터베이스의 경우 리스너 패스워드 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: Listener의 패스워드가 설정되어 있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-09 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-10 START
@echo D-10 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-10 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 불필요한 ODBC/OLE-DB가 설치되지 않은 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 2>nul
if errorlevel 1 (
	echo 불필요한 ODBC/OLE-DB가 설치되지 않음 >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  D-11 일정 횟수의 로그인 실패 시 잠금 정책 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 로그인 시도 횟수를 제한하는 값을 설정한 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo "MySQL에서 해당 기능 지원하지 않음(N/A)" >> %COMPUTERNAME%-MYSQL-result.txt
echo "단, 솔루션, 트리거 등을 이용할 경우 기능 구현 가능" >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-11 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-12 START
@echo D-12 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-12 데이터베이스의 주요 파일 보호 등을 위해 DB 계정의 umask를 022이상으로 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 계정의 umask가 022 이상으로 설정되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo Win MySQL 해당사항 없음 (N/A)                                                           >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-12 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-13 START
@echo D-13 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-13 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 주요 설정 파일 및 디렉터리의 퍼미션 설정이 되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysqld.exe파일 cacls                                                           >> %COMPUTERNAME%-MYSQL-result.txt
cacls "%installdir%/bin/mysqld.exe"                                                           >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo mysql.exe파일 cacls                                                           >> %COMPUTERNAME%-MYSQL-result.txt
cacls "%installdir%/bin/mysql.exe"                                                            >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo my.ini파일 cacls                                                           >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  D-14 관리자 이외의 사용자가 오라클 리스너의 접속을 통해 리스너 로그 및 trace 파일에 대한 변경 권한 제한 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 주요 설정 파일 및 로그 파일에 대한 퍼미션을 관리자로 설정한 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-14 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-15 START
@echo D-15 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-15 응용프로그램 또는 DBA 계정의 Role이 Public으로 설정되지 않도록 조정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: DBA 계정의 Role이 Public으로 설정되어있지 않은 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-15 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-16 START
@echo D-16 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-16 OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES를 FALSE로 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES설정이 FALSE로 되어있는 경우>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-16 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-17 START
@echo D-17 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-17 패스워드 확인함수가 설정되어 적용되는가 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 패스워드 검증 함수로 검증이 진행되는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo 현재 버전은 %myVer_name%입니다. 버전에 따라 인터뷰 필요 >> %COMPUTERNAME%-MYSQL-result.txt
echo validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)  >> %COMPUTERNAME%-MYSQL-result.txt
echo authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재 >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● Plugin 경로 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%plu%%';" -t > %TmpFilePath%\1_3_1.txt
type %TmpFilePath%\1_3_1.txt >> %COMPUTERNAME%-MYSQL-result.txt

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● validate_password Plugin 활성화 여부 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE 'validate%%';" -t > %TmpFilePath%\1_3_0.txt
find "+" %TmpFilePath%\1_3_0.txt >nul
if not errorlevel 1 (
	type type %TmpFilePath%\1_3_0.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo validate_password Plugin 비활성화 >> %COMPUTERNAME%-MYSQL-result.txt
)

echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● 패스워드 검증 관련 파라미터(plugin 관련) >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables like '%%vali%%';" -t > %TmpFilePath%\1_3_2.txt
type %TmpFilePath%\1_3_2.txt | find /V "query_cache" >> %COMPUTERNAME%-MYSQL-result.txt

::MySQL 5.7이상만
echo. >> %COMPUTERNAME%-MYSQL-result.txt
echo ● 패스워드 만료, 변경일자, 계정잠김 등 컬럼 >> %COMPUTERNAME%-MYSQL-result.txt
if %myVer% geq 4 (
	%SQLCMD% -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > %TmpFilePath%\1_3_3.txt
	type %TmpFilePath%\1_3_3.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo ☞ 5.7미만 해당 컬럼 없음 >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  D-18 인가되지 않은 Object Owner가 존재하지 않는가 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: Object Owner 의 권한이 SYS, SYSTEM, 관리자 계정 등으로 제한된 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-18 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-19 START
@echo D-19 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-19 grant option이 role에 의해 부여되도록 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: WITH_GRANT_OPTION이 ROLE에 의하여 설정되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

%SQLCMD% -e "SELECT user,grant_priv FROM mysql.user;" -t > %TmpFilePath%\1_19.txt
find "+" %TmpFilePath%\1_19.txt >nul
if not errorlevel 1 (
	type %TmpFilePath%\1_19.txt >> %COMPUTERNAME%-MYSQL-result.txt
) else (
	echo 쿼리결과 없음 >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  D-20 데이터베이스의 자원 제한 기능을 TRUE로 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: RESOURCE_LIMIT 설정이 TRUE로 되어있는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-20 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ======================================================================================= >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt






@echo D-21 START
@echo D-21 START                                                                              >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo  D-21 데이터베이스에 대해 최신 보안패치와 밴더 권고 사항을 모두 적용 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 버전별 최신 패치를 적용한 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "select version();" -t > %TmpFilePath%\1_21.txt
type %TmpFilePath%\1_21.txt >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo D-21 END                                                                                >> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
@echo "2017년 1월 기준" >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  D-22 데이터베이스의 접근, 변경, 삭제 등의 감사기록이 기관의 감사기록 정책에 적합하도록 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: DBMS의 감사 로그 저장 정책이 수립되어 있으며, 정책이 적용되어있는 경우 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo ● case1. mysql 지원 logging 기능 확인 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show global variables where Variable_name in ('version', 'log', 'general_log', 'general_log_file', 'log_error', 'log_output', 'slow_query_log', 'slow_query_log_file');" -t > %TmpFilePath%\1_22_1.txt
type %TmpFilePath%\1_22_1.txt >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo ● case2. my.ini 파일 확인							                                     >> %COMPUTERNAME%-MYSQL-result.txt
IF EXIST "%installdir%"\my.ini (
	type "%installdir%"\my.ini | findstr /V "^#" | findstr .               					 >> %COMPUTERNAME%-MYSQL-result.txt
) ELSE (
	echo "%installdir%"경로에 my.ini 존재하지 않음.                            				 >> %COMPUTERNAME%-MYSQL-result.txt
)

echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo ● case3. audit_log plugin 사용 확인 >> %COMPUTERNAME%-MYSQL-result.txt
%SQLCMD% -e "show plugins;" -t > %TmpFilePath%\1_22_2.txt
type %TmpFilePath%\1_22_2.txt | findstr /I "name audit_log" >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt

echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
echo ● case3. 확인 불가 시 솔루션 사용 여부 인터뷰 >> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  D-23 보안에 취약하지 않은 버전의 데이터베이스를 사용하고 있는가 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: 보안 패치가 지원되는 버전을 사용하는 경우 양호>> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
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
@echo  D-24 Audit Table은 데이터베이스 관리자 계정에 속해 있도록 설정 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ####################################################################################### >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 기준: Audit Table 접근 권한이 관리자 계정으로 설정한 경우 >> %COMPUTERNAME%-MYSQL-result.txt
@echo ■ 현황>> %COMPUTERNAME%-MYSQL-result.txt
@echo.                                                                                        >> %COMPUTERNAME%-MYSQL-result.txt
::%SQLCMD% -e "select table_schema, table_name from information_schema.tables where table_name='%%aud%%'" -t >> %COMPUTERNAME%-MYSQL-result.txt
@echo MySQL 해당사항 없음 (N/A)                                                                     >> %COMPUTERNAME%-MYSQL-result.txt
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
type %TmpFilePath%\1_22_2.txt >> %COMPUTERNAME%-MYSQL-result.txt
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

pause
EXIT