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
REM ## 관리자 권한 실행 요청 부분
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
    echo. 진단 스크립트 실행을 위한 관리자 권한을 요청 합니다.
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
	
set /p PGUSER=DBA ID를 입력해 주세요(ex root). : 
set /p PGPASS=Password를 입력해 주세요. : 
set /p POST_HOME=PostgreSQL 홈 디렉터리를 입력해 주세요(ex C:\Program Files\PostgreSQL\11\data). :
if exist "%POST_HOME%" (
	echo PostgreSQL 홈 디렉터리는 %POST_HOME% 입니다.
) else (
	echo PostgreSQL 홈 디렉터리가 존재하지 않습니다.
	goto 1
)

set PG_USER=%PGUSER%		
set PGPASSWORD=%PGPASS%

echo.  																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ##############################START#################################################
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-001] 취약하게 설정된 비밀번호 존재																			>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-001] CHECK OK
echo.##### DBM001 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 계정 정보 확인																											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT usename, passwd FROM PG_SHADOW;" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 시스템 내 모든 계정의 비밀번호가 비밀번호 복잡도를 만족하고 취약하지 않게 설정되어 있다고 판단될 경우																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 비밀번호 복잡도를 만족하지 않거나 취약하다고 판단되는 계정 비밀번호가 존재할 경우 															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default ID : postgres																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default password : 없음																								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] 업무상 불필요한 계정 존재																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] CHECK OK
echo.##### DBM003 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "select rolname, rolcanlogin, rolvaliduntil from pg_authid;" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 사용하지 않는 계정에 대한 인터뷰 필요 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 불필요한 계정이 존재하지 않는 경우												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요한 계정이 존재하는 경우											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : rolname(계정이름), rolcanlogin(로그인가능 여부, Default: t), rolvaliduntil(로그인 유효기간, Default:NULL)																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 사용하지 않는 계정에 대해 rolcanloing 컬럼이 t일 경우 취약																									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. rolvaliduntil 컬럼이 NULL인 경우 취약 (DBM-003-04 항목과 동일)	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] 업무상 불필요하게 관리자 권한이 부여된 계정 존재																								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] CHECK OK
echo.##### DBM004 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1																										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "select * from pg_user"									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 사용하지 않는 계정에 대한 인터뷰 필요 >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 불필요하게 관리자 권한이 부여된 계정이 존재하지 않을 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요하게 관리자 권한이 부여된 계정이 존재할 경우													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 불필요하게 관리자 권한(usecreatedb, usesuper, userepl)이 t일 경우 취약																												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] 데이터베이스 내 중요정보 암호화 미적용																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] CHECK OK
echo.##### DBM005 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "password_encrytion" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 데이터베이스 내에 주민등록번호, 비밀번호 등과 같은 중요정보가 평문으로 존재하는지 확인 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 데이터베이스 내에 주민등록번호, 비밀번호등과 같은 중요정보가 암호화 되어 존재할 경우																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 데이터베이스 내에 주민등록번호, 비밀번호등과 같은 중요정보가 평문으로 존재할 경우																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] 로그인 실패 횟수에 따른 접속 제한 설정 미흡																							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] CHECK OK
echo.##### DBM006 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 플러그인(fail2ban), 장비, 써드파티 솔루션 등을 통해 로그인 실패 횟수에 따른 계정 접속 제한 설정 여부	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 플러그인(fail2ban), 장비, 써드파티 솔루션 등을 통해 로그인 실패 횟수에 따른 계정 접속 제한 설정이 존재하는 경우																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 플러그인(fail2ban), 장비, 써드파티 솔루션 등을 통해 로그인 실패 횟수에 따른 계정 접속 제한 설정이 존재하지 않는 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																	    >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																	    >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] 비밀번호의 복잡도 정책 설정 미흡																							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] CHECK OK
echo.##### DBM007 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT usename, usesysid, passwd, valuntil FROM PG_SHADOW" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-01. 패스워드는 숫자, 영문 소문자, 영문 대문자, 특수문자 중 몇가지를 조합하여 사용하도록 정책이 마련되어 있습니까 >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-02. 패스워드는 최소한 몇 글자 이상 사용하도록 정책 및 지침이 마련되어 있습니까 >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-03. 패스워드는 암호화(또는 해쉬값) 되어 저장/보관 되고 있습니까 >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-04. 패스워드는 몇일에 한번씩 바꾸도록 정책 및 지침으로 관리/감독이 이루어지고 있습니까 >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 07-05. 패스워드는 해쉬 또는 암호화(AES, SEED 등) 중 어떠한 알고리즘을 사용되고 있습니까 >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 계정 생성 및 계정 비밀번호 변경시 비밀번호 복잡도 준수하도록 강제하고 있는 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 계정 생성 및 계정 비밀번호 변경시 비밀번호 복잡도 준수하도록 강제하고 있지 않은 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 비밀번호 복잡도: 영문/숫자/특수문자 2개 조합 시 10자리 이상, 3개 조합 시 8자리 이상																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 플러그인, 장비, 써드파티 솔루션 등을 통해 비밀번호 복잡도 준수를 강제하고 있는지 여부 확인																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : 계정 별 패스워드(PASSWD) 정보 및 만료기간(VALUNTIL): PG_SHADOW																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : PostgreSQL은 패스워드 저장 시, 해쉬 알고리즘을 사용하며 MD5 알고리즘만 지원함. (암호화 모듈은 지원하지 않음)																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] 주기적인 비밀번호 변경 미흡																						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] CHECK OK
echo.##### DBM008 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT usename, usesysid, passwd, valuntil FROM PG_SHADOW" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 계정 비밀번호를 주기적(분기별 1회 이상)으로 변경하고 있는 경우																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 계정 비밀번호를 주기적(분기별 1회 이상)으로 변경하고 있지 않을 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 서비스 운영 용도(솔루션, 애플리케이션 접속용 등)로 사용중인 계정에 대해서 비밀번호를 변경하면 서비스 장애 유발 가능성이 있다고 내부적으로 판단될 경우 해당 계정들은 평가에서 제외																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] 사용되지 않는 세션 종료 미흡																							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] CHECK OK
echo.##### DBM009 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 1) 9.6 미만의 버전을 사용할 경우																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "statement_timeout" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : statement_timeout: 지정된 시간이상의 쿼리에 대해서는 모두 중단 시켜 버립니다. 0은 Disable이고 셋팅은 milliseconds로 하시면 됩니다.																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 2) 9.6 이상의 버전을 사용할 경우																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "idle_in_transaction_timeout" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : idle_in_transaction_timeout: 기본값이 0이며, 0일 경우 이 값을 사용하지 않는 것																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : timeout의 값이 15분 혹은 정책에 맞게 설정되어 있는 경우											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : timeout의 값이 정책에 맞게 설정되어 있지 않은 경우										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] 감사 로그 수집 및 백업 미흡																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] CHECK OK
echo.##### DBM011 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_connections" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_disconnections" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_duration" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
(type "%POST_HOME%\postgresql.conf" | findstr -i "log_timestamp" || @echo No Value) >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : log_connections, log_disconnections, log_duration, log_timestamp의 값이 ON으로 설정되고 주기적으로 감사 로그에 대한 백업을 실시하고 있는 경우										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 감사 로그를 수집 중이지 않거나 주기적으로 감사 로그에 대한 백업을 실시하고 있지 않은 경우										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 써드파티 솔루션, 기타 플러그인등을 이용해 감사로그를 수집/백업 중인지 확인																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-013] 원격 접속에 대한 접근 제어 미흡																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
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
echo. 양호 : 데이터베이스로의 원격 접근제어가 이루어지고 있는 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 데이터베이스로의 원격 접근제어가 이루어지지 않는 경우(Host 칼럼에 '%%'가 저장된 계정이 존재할 경우 취약)								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : postgresql.conf에서 listen_address 정보와 pg_hba.conf에서 host 정보가									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 1) 특정 IP가 1개 이상 설정되며, pg_hba.conf에서 host 정보가 localhost(e.g.  127.0.0.1/32) 설정 시 양호																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 2) 특정 IP가 1개 이상 설정되며, pg_hba.conf에서 host 정보가 네트워크 대역(e.g.  192.168.10.0/32) 설정 시 양호																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 3) 특정 IP가 1개 이상 설정되며, pg_hba.conf에서 host 정보가 0.0.0.0/0 설정 시 양호																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 4) ^* 로 설정되고, pg_hba.conf에서 host 정보가 localhost(e.g 127.0.0.1) 설정 시 양호																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 5) ^* 로 설정되고, pg_hba.conf에서 host 정보가 네트워크 대역(e.g.  192.168.10.0/32) 설정 시 양호																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 6) ^* 로 설정되고, pg_hba.conf에서 host 정보가 0.0.0.0/0 설정되어 있으면 취약 (모든 IP에 대하여 TCP Connection이 가능)																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-015] Public Role에 불필요한 권한 존재																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-015] CHECK OK
echo.##### DBM015 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\l" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\dn+" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : Public Role에 불필요한 권한 존재 여부																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : Public Role에 불필요한 권한이 존재하지 않는 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : Public Role에 불필요한 권한이 존재하는 경우								>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] DBMS 최신 보안패치와 벤더 권고사항 미적용																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] CHECK OK
echo.##### DBM016 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql --version >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 최신보안패치 및 벤더 권고사항이 적용된 경우							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 최신보안패치 및 벤더 권고사항이 적용되지 않은 경우							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
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
echo. [DBM-017] 업무상 불필요한 시스템 테이블 접근 권한 존재											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-017] CHECK OK
echo.##### DBM017 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\l" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "\dp" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 업무상 불필요한 시스템 테이블 접근 권한 존재 여부																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 필요한 시스템 테이블 접근 권한만 존재하는 경우														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요한 시스템 테이블 접근 권한이 존재하는 경우										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] 비밀번호 재사용 방지 설정 미흡											>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] CHECK OK
echo.##### DBM019 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 플러그인, 장비, 써드파티 솔루션 등을 통해 이전 비밀번호 재사용 제한 설정 여부																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 비밀번호 변경시 이전 비밀번호를 재사용할 수 없는 경우														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 비밀번호 변경시 이전 비밀번호를 재사용할 수 있는 경우										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] 사용자별 계정 분리 미흡																				>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] CHECK OK
echo.##### DBM020 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT r.datname, ARRAY(SELECT m.rolname FROM pg_authid m JOIN pg_database b ON (m.oid = b.datdba) WHERE m.oid = r.datdba and b.DATISTEMPLATE = FALSE) as owner FROM pg_database r where r.DATISTEMPLATE = FALSE" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "select * from pg_user" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 사용자별 계정을 부여해서 사용하고 있거나 어플리케이션별 계정을 부여해서 사용 여부 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 계정들이 사용자별로 적절하게 분리되어 사용되고 있고 있는 경우																					>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.     (계정을 공유해서 사용 하는 경우, 서드파트솔루션등을 통해 접속자별 감사로그 식별 가능시 양호로 판단)																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 계정들이 사용자별로 적절하게 분리되지 않고 사용되고 있는 경우																						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] 설정 파일 및 중요정보가 포함된 파일의 접근 권한 설정 미흡																	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] CHECK OK
echo.##### DBM022 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
icacls "%POST_HOME%\postgresql.conf" 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
icacls "%POST_HOME%\pg_hba.conf" 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
icacls "%POST_HOME%\pg_ident.conf" 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [수동진단] 시스템 주요 파일(postgresql.conf, pg_hba.conf, pg_ident.conf)의 접근 권한이 Adminisrators, SYSTEM, Owner 외의 그룹에 설정 여부 확인																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 주요 설정 파일 및 중요정보 파일에 대하여 접근권한이 적절하게 설정된 경우							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 주요 설정 파일 및 중요정보 파일에 대하여 접근권한이 적절하게 설정되어 있지 않은 경우							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] 불필요하게 WITH GRANT OPTION 옵션이 설정된 권한 존재																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] CHECK OK
echo.##### DBM024 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT grantor,grantee,table_name,privilege_type,is_grantable FROM information_schema.role_table_grants WHERE is_grantable='YES';" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 불필요하게 WITH GRANT OPTION 옵션이 설정되어 있는 권한 존재 여부																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 운영상 불필요하게 WITH GRANT OPTION(IS_GRANTABLE) 옵션이 적용된 권한이 존재하지 않는 경우						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 운영상 불필요하게 WITH GRANT OPTION(IS_GRANTABLE) 옵션이 적용된 권한이 존재하는 경우							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] 서비스 지원이 종료된(EoS) 데이터베이스 사용																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] CHECK OK
echo.##### DBM025 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql --version >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 보안 패치를 지원되는 데이터베이스 버전을 사용하는 경우							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 보안 패치가 지원되지 않는 데이터베이스 버전을 사용하는 경우							>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
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
echo. [DBM-026] 데이터베이스 구동 계정의 umask 설정 미흡													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-026] CHECK OK
echo.##### DBM026 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ※데이터베이스가 설치된 OS가 Unix계열일 경우에만 해당																									>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 데이터베이스  umask 설정값이 022 초과로 설정되어 있는 경우																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 데이터베이스 umask 설정값이 022 이하로 설정되어 있는 경우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] 업무상 불필요한 데이터베이스 Object 존재												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] CHECK OK
echo.##### DBM028 #####                                               >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
psql -U %PG_USER% -c "SELECT distinct relname, relowner FROM pg_class;" >> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 인터뷰필요 : 업무상 불필요한 데이터베이스 Object 존재 여부																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 불필요한 데이터베이스 Object가 존재하지 않는 경우																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요한 데이터베이스 Object가 존재하는 경우우															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																														>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. ※데이터베이스 Object : 테이블, 뷰, 프로시저, 함수 등																												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-032] 데이터베이스 접속 시 통신구간에 비밀번호 평문 노출												>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
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
echo. 수동체크 : 환경설정파일 확인 pg_hba.conf, postgresql.conf																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 1) pg_hba.conf에서 hostssl 이 설정 시 해당 주소에서 들어오는 ssl연결만 허용하면 양호																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 2) pg_hba.conf에서 (auth)method 필드값 md5, password 이외로 설정되어 있으면 양호																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 3) postgresql.conf에서 ssl=on 으로 설정 시 ssl 허용이므로 양호(false일경우 취약)																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 데이터베이스 접속 시 통신구간 비밀번호 암호화																>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 데이터베이스 접속 시 통신구간 비밀번호 평문 노출															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1

echo. --- END TIME ---------------------------------------------------------------------- 										>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
	date /t 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
	time /t 																													>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1
echo. 																															>> [RESULT]_PostgreSQL_%COMPUTERNAME%.txt 2>&1

exit /b 0