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

echo. [START TIME] 																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	date /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	time /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	
set /p MYSQL_USERNAME=MySQL USERNAME을 입력해 주세요(ex root). : 
set /p MYSQL_PASSWORD=MySQL PASSWORD를 입력해 주세요. : 
set /p MYSQL_HOME=MySQL 홈 디렉터리를 입력해 주세요(ex C:\Program Files\MySQL\MySQL Server 5.6). :
if exist "%MYSQL_HOME%" (
	echo MySQL 홈 디렉터리는 %MYSQL_HOME% 입니다.
) else (
	echo MySQL 홈 디렉터리가 존재하지 않습니다.
	goto 1
)

REM ##### MAJOR 버전 앞자리, MINOR #####
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
echo. [DBM-001] 취약하게 설정된 비밀번호 존재																			>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-001] CHECK OK
echo.##### DBM001 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 계정 정보 확인																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		if %MYSQL_MAJOR_VERSION% LEQ 5 ( if %MYSQL_MINOR_VERSION% LEQ 6 (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,password from mysql.user;" -t				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		) else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		))else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		)
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 시스템 내 모든 계정의 비밀번호가 비밀번호 복잡도를 만족하고 취약하지 않게 설정되어 있다고 판단될 경우																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 비밀번호 복잡도를 만족하지 않거나 취약하다고 판단되는 계정 비밀번호가 존재할 경우 															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default ID : root																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 	- default password : 없음																								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] 업무상 불필요한 계정 존재																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-003] CHECK OK
echo.##### DBM003 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 1. 계정 정보 확인																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		if %MYSQL_MAJOR_VERSION% LEQ 5 ( if %MYSQL_MINOR_VERSION% LEQ 6 (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,password from mysql.user;" -t				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		) else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		))else (
			mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host,authentication_string from mysql.user;" -t	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		)
echo. 2. 계정의 사용 여부																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [인터뷰] 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 불필요한 계정이 존재하지 않는 경우												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요한 계정이 존재하는 경우											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] 업무상 불필요하게 관리자 권한이 부여된 계정 존재																								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-004] CHECK OK
echo.##### DBM004 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 계정 권한 확인																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select * from mysql.user;" -t									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 불필요하게 관리자 권한이 부여된 계정이 존재하지 않을 경우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요하게 관리자 권한이 부여된 계정이 존재할 경우													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 관리자 권한 : Global 수준으로 부여된 권한																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] 데이터베이스 내 중요정보 암호화 미적용																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-005] CHECK OK
echo.##### DBM005 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [인터뷰] 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 데이터베이스 내에 주민등록번호, 비밀번호등과 같은 중요정보가 암호화 되어 존재할 경우																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 데이터베이스 내에 주민등록번호, 비밀번호등과 같은 중요정보가 평문으로 존재할 경우																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : MySQL에서 지원하는 암호화 함수																						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 단방향 암호화 : MD5, PASSWORD, SHA1, SHA																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양방향 암호화 : AES_ENCRYPT, AES_DECRYPT, DES_ENCRYPT, DES_DECRYPT, DECODE, ENCODE, COMPRESS, UNCOMPRESS					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] 로그인 실패 횟수에 따른 접속 제한 설정 미흡																							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-006] CHECK OK
echo.##### DBM006 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 비밀번호 정책 확인																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT user, host, User_attributes FROM mysql.user;" -t					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. User_attributes 필드의 failed_login_attempts, password_lock_time_days 값 확인																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 5회 연속 로그인 실패시 일정시간 동안 접속 제한(계정 잠금 또는 접속 차단)이 이루어지는 경우																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 5회 연속 로그인 실패시 일정시간 동안 접속 제한(계정 잠금 또는 접속 차단)이 이루어지지 않는 경우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. v8.0.19 이상: failed_login_attempts 값이 5초과로 되어있거나 password_lock_time_days 값이 지나치게 작게 설정되어 있는 경우 취약									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. v8.0.19 미만: 플러그인, 장비, 써드파티 솔루션 등을 통해 로그인 실패 횟수에 따른 계정 접속 제한이 이루어 지고 있는지 확인											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * failed_login_attempts : 계정이 잠기기 위해 로그인 실패 횟수																		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * password_lock_time_days : 일정횟수 로그인을 실패하여 계정이 잠겼을때 잠금이 풀리기 위해 지나야하는 시간																	    >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 서비스 운영 용도(솔루션, 애플리케이션 접속용 등)로 사용중인 계정에 대해서 "로그인 실패 횟수에 따른 접속 제한"설정을 적용할 경우 서비스 장애 유발 가능성이 있다고 내부적으로 판단될 경우, 해당 계정들은 평가에서 제외	   >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																	    >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] 비밀번호의 복잡도 정책 설정 미흡																							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-007] CHECK OK
echo.##### DBM007 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 비밀번호 정책 확인																										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'validate_password%%';" -t		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 계정 생성 및 계정 비밀번호 변경시 비밀번호 복잡도 준수하도록 강제하고 있는 경우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 계정 생성 및 계정 비밀번호 변경시 비밀번호 복잡도 준수하도록 강제하고 있지 않은 경우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 비밀번호 복잡도: 영문/숫자/특수문자 2개 조합 시 10자리 이상, 3개 조합 시 8자리 이상																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 플러그인, 장비, 써드파티 솔루션 등을 통해 비밀번호 복잡도 준수를 강제하고 있는지 여부 확인																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_check_user_name : 패스워드에 userid의 사용 여부 확인													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_dictionary_file : 패스워드에 dictionary file 검사														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_length : 패스워드 길이																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_mixed_case_count : 패스워드에 사용 가능한 대소문자 최소 갯수 설정										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_number_count : 패스워드에 사용 가능한 최소 숫자 갯수 설정												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_policy : 패스워드정책의 수준 설정																		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. validate_password_special_char_count : 패스워드에 사용 가능한 특수문자의 최소 갯수 설정									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] 주기적인 비밀번호 변경 미흡																						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-008] CHECK OK
echo.##### DBM008 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 비밀번호 만료 설정 확인																									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'default_password_lifetime';" -t 				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT USER, HOST, password_last_changed from mysql.user;" -t 				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 계정 비밀번호를 주기적(분기별 1회 이상)으로 변경하고 있는 경우																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 계정 비밀번호를 주기적(분기별 1회 이상)으로 변경하고 있지 않을 경우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 서비스 운영 용도(솔루션, 애플리케이션 접속용 등)로 사용중인 계정에 대해서 비밀번호를 변경하면 서비스 장애 유발 가능성이 있다고 내부적으로 판단될 경우 해당 계정들은 평가에서 제외																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] 사용되지 않는 세션 종료 미흡																							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-009] CHECK OK
echo.##### DBM009 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "show variables like '%%timeout';" -t								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : interactive_timeout, wait_timeout의 값이 15분 혹은 정책에 맞게 설정되어 있는 경우											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : interactive_timeout, wait_timeout의 값이 정책에 맞게 설정되어 있지 않은 경우										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. connect_timeout : MySQL서버 접속시에 접속실패를 메시지를 보내기까지 대기하는 시간											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. delayed_insert_timeout : insert시 delay될 경우 대기하는 시간																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. innodb_lock_wait_timeout : innodb에 transaction 처리중 lock이 걸렸을 시 롤백 될때까지 대기하는 시간						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 							 innodb는 자동으로 데드락을 검색해서 롤백시킨다													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. innodb_rollback_on_timeout : innodb의 마지막 구문을 롤백시킬지 결정하는 파라미터											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 							   timeout은 진행중인 transaction을 중단하고 전체 transaction을 롤백하는 과정에서 발생한다.		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. interactive_timeout : 활동중인 커넥션이 닫히기 전까지 서버가 대기하는 시간												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. net_read_timeout : 서버가 클라이언트로부터 데이터를 읽어들이는 것을 중단하기까지 대기하는 시간							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. net_write_timeout : 서버가 클라이언트로에 데이터를 쓰는 것을 중단하기까지 대기하는 시간									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. slave_net_timeout : 마스터/슬레이브로 서버가 클라이언트로부터 데이터를 읽어들이는 것을 중단하기까지 대기하는 시간			>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. table_lock_wait_timeout : 테이블 락을 중단하기까지 대기하는 시간															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. wait_timeout : 활동하지 않는 커넥션을 끊을때까지 서버가 대기하는 시간														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] 감사 로그 수집 및 백업 미흡																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-011] CHECK OK
echo.##### DBM011 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "show VARIABLES like '%%log%%';" -t								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 감사 로그를 수집 중이고 주기적으로 감사 로그에 대한 백업을 실시하고 있는 경우										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 감사 로그를 수집 중이지 않거나 주기적으로 감사 로그에 대한 백업을 실시하고 있지 않은 경우										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 써드파티 솔루션, 기타 플러그인등을 이용해 감사로그를 수집/백업 중인지 확인																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-013] 원격 접속에 대한 접근 제어 미흡																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-013] CHECK OK
echo.##### DBM013 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select user,host from mysql.user;" -t							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 데이터베이스로의 원격 접근제어가 이루어지고 있는 경우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 데이터베이스로의 원격 접근제어가 이루어지지 않는 경우(Host 칼럼에 '%%'가 저장된 계정이 존재할 경우 취약)								>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 : host 필드에 '%%'가 저장되어 있을 경우 '%%'를 삭제하고 지정된 IP주소를 지정하여 등록									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ 플러그인, 네트워크 장비, 써드파티 솔루션 등을 통해 원격 접근 제어가 이루어지고 있는지 확인																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] DBMS 최신 보안패치와 벤더 권고사항 미적용																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-016] CHECK OK
echo.##### DBM016 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select version();" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 최신보안패치 및 벤더 권고사항이 적용된 경우							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 최신보안패치 및 벤더 권고사항이 적용되지 않은 경우							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 사이트																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 버그 패치 된 릴리즈 사이트 : http://downloads.mysql.com/archives.php														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 버그 현황 사이트 : http://bugs.mysql.com/bugstats.php				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-017] 업무상 불필요한 시스템 테이블 접근 권한 존재											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-017] CHECK OK
echo.##### DBM017 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 계정 권한 확인																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select * from mysql.user;" -t									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. DB 권한 확인																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1	
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select * from mysql.db;" -t										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 필요한 시스템 테이블 접근 권한만 존재하는 경우														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요한 시스템 테이블 접근 권한이 존재하는 경우										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * 인터뷰를 통해 업무상 불필요하게 부여된 시스템 테이블 접근 권한이 존재하는지 확인																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. - 업무상 불필요한 시스템 테이블(sys, mysql, information_schema등) 접근 권한이 존재할 경우 취약																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] 비밀번호 재사용 방지 설정 미흡											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-019] CHECK OK
echo.##### DBM019 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * (v8.0이상) 데이터베이스 자체기능(password_history, password_resue_interval) 값 확인																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'password_history';" -t									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SHOW VARIABLES LIKE 'password_reuse_interval';" -t										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  - password_history값이 0이거나 password_resue_interval값이 0일 경우  취약																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. * 위의 값들이 설정되어있지 않거나 v8.0 미만인 경우,플러그인, 써드파티 솔루션, 내부 정책 등을 통해 이전 비밀번호 재사용을 제한하고 있는지 확인																											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  - 비밀번호 재사용을 제한하고 있지 않을 경우 취약																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 비밀번호 변경시 이전 비밀번호를 재사용할 수 없는 경우														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 비밀번호 변경시 이전 비밀번호를 재사용할 수 있는 경우										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] 사용자별 계정 분리 미흡																				>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-020] CHECK OK
echo.##### DBM020 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [인터뷰] 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 계정들이 사용자별로 적절하게 분리되어 사용되고 있고 있는 경우																					>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.     (계정을 공유해서 사용 하는 경우, 서드파트솔루션등을 통해 접속자별 감사로그 식별 가능시 양호로 판단)																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 계정들이 사용자별로 적절하게 분리되지 않고 사용되고 있는 경우																						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] 설정 파일 및 중요정보가 포함된 파일의 접근 권한 설정 미흡																	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-022] CHECK OK
echo.##### DBM022 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
icacls "C:\ProgramData\MySQL\MySQL Server %MYSQL_MAJOR_VERSION%.%MYSQL_MINOR_VERSION%\my.ini" 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [수동진단] 초기화 파일(my.cnf, my.ini)의 접근 권한이 Adminisrators, SYSTEM, Owner 외의 그룹에 설정 여부 확인																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 주요 설정 파일 및 중요정보 파일에 대하여 접근권한이 적절하게 설정된 경우							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 주요 설정 파일 및 중요정보 파일에 대하여 접근권한이 적절하게 설정되어 있지 않은 경우							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] 불필요하게 WITH GRANT OPTION 옵션이 설정된 권한 존재																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-024] CHECK OK
echo.##### DBM024 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT grantee,privilege_type,is_grantable FROM information_schema.user_privileges;" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 운영상 불필요하게 WITH GRANT OPTION(IS_GRANTABLE) 옵션이 적용된 권한이 존재하지 않는 경우						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 운영상 불필요하게 WITH GRANT OPTION(IS_GRANTABLE) 옵션이 적용된 권한이 존재하는 경우							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※ WITH GRANT OPTION : GRANT받은 권한 또는 역할을 타 사용자에게 부여할수 있는 옵션으로 MySQL에서는 IS_GRANTABLE 칼럼을 통해 설정 가능														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] 서비스 지원이 종료된(EoS) 데이터베이스 사용																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-025] CHECK OK
echo.##### DBM025 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "select version();" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 보안 패치를 지원되는 데이터베이스 버전을 사용하는 경우							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 보안 패치가 지원되지 않는 데이터베이스 버전을 사용하는 경우							>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고 사이트																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 버그 패치 된 릴리즈 사이트 : http://downloads.mysql.com/archives.php														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 버그 현황 사이트 : http://bugs.mysql.com/bugstats.php																		>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-026] 데이터베이스 구동 계정의 umask 설정 미흡													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-026] CHECK OK
echo.##### DBM026 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※데이터베이스가 설치된 OS가 Unix계열일 경우에만 해당																									>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 데이터베이스  umask 설정값이 022 초과로 설정되어 있는 경우																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 데이터베이스 umask 설정값이 022 이하로 설정되어 있는 경우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] 업무상 불필요한 데이터베이스 Object 존재												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. [DBM-028] CHECK OK
echo.##### DBM028 #####                                               >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### START #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.  >> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
		mysql -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% mysql -e "SELECT OBJECT_TYPE,OBJECT_SCHEMA,OBJECT_NAME FROM (SELECT 'TABLE' AS OBJECT_TYPE ,TABLE_NAME AS OBJECT_NAME,TABLE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.TABLES UNION SELECT 'VIEW' AS OBJECT_TYPE,TABLE_NAME AS OBJECT_NAME,TABLE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.VIEWS UNION SELECT 'INDEX[Type:Name:Table]' AS OBJECT_TYPE,CONCAT (CONSTRAINT_TYPE,' : ',CONSTRAINT_NAME,' : ',TABLE_NAME) AS OBJECT_NAME,TABLE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.TABLE_CONSTRAINTS UNION SELECT ROUTINE_TYPE AS OBJECT_TYPE,ROUTINE_NAME AS OBJECT_NAME,ROUTINE_SCHEMA AS OBJECT_SCHEMA FROM information_schema.ROUTINES UNION SELECT 'TRIGGER[Schema:Object]' AS OBJECT_TYPE,CONCAT (TRIGGER_NAME,' : ',EVENT_OBJECT_SCHEMA,' : ',EVENT_OBJECT_TABLE) AS OBJECT_NAME, TRIGGER_SCHEMA AS OBJECT_SCHEMA FROM information_schema.triggers) R" -t											>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 양호 : 업무상 불필요한 데이터베이스 Object가 존재하지 않는 경우																>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 취약 : 업무상 불필요한 데이터베이스 Object가 존재하는 경우우															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 참고																														>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. ※데이터베이스 Object : 테이블, 뷰, 프로시저, 함수 등																												>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo.##### END #####                                              	>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. =====================================================================================================						>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1

echo. --- END TIME ---------------------------------------------------------------------- 										>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	date /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
	time /t 																													>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1
echo. 																															>> [RESULT]_MySQL_%COMPUTERNAME%.txt 2>&1

exit /b 0