@echo off


REM ##### Tomcat 환경설정 ###############
REM ##### Tomcat 설치 경로 ###############

:1
set /p TOMCAT_DIR=Input Tomcat base directory(ex C:\tomcat). :
if exist "%TOMCAT_DIR%" (
echo Tomcat Base Directory is %TOMCAT_DIR% .
) else (
echo Base Directory is not exist.
goto 1
)

REM #####  웹 서버 홈 디렉터리 ###############

:2
set /p appbase=Input Tomcat appbase directory(ex C:\tomcat\webapps). :
if exist "%appbase%" (
echo appbase directory is %appbase% 
REM 추가부분-- 추가 web.xml 확인
) else (
echo Appbase Directory is not exist.
goto 2
)

REM #####  로그 디렉터리 ###############

:3
set /p LOG=Input Tomcat Log directory(ex "C:\tomcat\logs"). :
if exist "%LOG%" (
echo Log Directory is  %LOG% 
) else (
echo Log directory is not exist.
goto 3
)


REM #### HEADER 부분 ####

SETLOCAL ENABLEDELAYEDEXPANSION
SET PATH=%PATH%;.\bin;


FOR /F "tokens=4 delims= " %%a in ('route print ^| find "0.0.0.0" ^| find /v "??"') do set IP=%%a
SET RES_LAST_FILE=Tomcat_Windows_%IP%_%COMPUTERNAME%.log


echo SYSTEM WINDOWS HeaderInfo {ahnlab{ >> %RES_LAST_FILE% 2>&1 

echo ** ASVD_INFO: 1 WINDOWS >> %RES_LAST_FILE% 2>&1
echo ** START_TIME: %CDATE% %TIME% >> %RES_LAST_FILE% 2>&1
echo ** HOSTNAME: %COMPUTERNAME% >> %RES_LAST_FILE% 2>&1
echo ** IP ADDRESS: %IP% >> %RES_LAST_FILE% 2>&1
echo }ahnlab} >> %RES_LAST_FILE% 2>&1 

echo. >> %RES_LAST_FILE% 2>&1


echo. --- START TIME ---------------------------------------------------------------------- 															
date /t 																												 
time /t 																												 
echo.  																													 


echo.
echo. *************************************************************															>> %RES_LAST_FILE% 2>&1
echo. ****** AhnLab System Checklist for Tomcat ver 5.0.0 *******															>> %RES_LAST_FILE% 2>&1
echo. *************************************************************															>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1


.\bin\psinfo -s 																											> [RESULT]_%COMPUTERNAME%_installed_software.txt

chcp 437
echo. 																														>> %RES_LAST_FILE% 2>&1
echo. ##################### System Information ##################### 														>> %RES_LAST_FILE% 2>&1
echo. --- OS Version ---------------------------------------------------------------------- 									


echo. --- IPCONFIG /ALL ------------------------------------------------------------------- 								>> %RES_LAST_FILE% 2>&1
ipconfig /all 																											>> %RES_LAST_FILE% 2>&1
echo.  																														>> %RES_LAST_FILE% 2>&1
echo.  																														>> %RES_LAST_FILE% 2>&1




echo "## Tomcat_Windows001 ##"
echo "##### WC-001 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-001 프로세스 권한 제한 ##"																							>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
REM java로 찾아야 더 정확하게 나옴(tomcat은 java 프로세스로 구동)
tasklist /V | findstr /i "java"  																						>> %RES_LAST_FILE% 2>&1

echo "양호 : Window N/A"																									>> %RES_LAST_FILE% 2>&1
echo "취약 : Window N/A"																									>> %RES_LAST_FILE% 2>&1
echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows002 ##"
echo "##### WC-002 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-002 디렉터리 권한 설정 ##"																							>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1
echo "--------------- 웹서버 홈 디렉터리 ---------------"																		>> %RES_LAST_FILE% 2>&1

echo "%appbase%" 	 																									>> %RES_LAST_FILE% 2>&1 

echo.																													>> %RES_LAST_FILE% 2>&1
echo 웹 서버 홈 디렉터리 권한																								>>%RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1
icacls "%appbase%"							 																			>> %RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1

echo "--------------- 관리서버 홈 디렉터리 ---------------"																	>> %RES_LAST_FILE% 2>&1

echo "%TOMCAT_DIR%\webapps\manager" 	 																				>> %RES_LAST_FILE% 2>&1 
echo.																													>> %RES_LAST_FILE% 2>&1
echo 관리서버 홈 디렉터리 권한																							>> %RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1
icacls "%TOMCAT_DIR%\webapps\manager"  																					>> %RES_LAST_FILE% 2>&1

echo.																														>> %RES_LAST_FILE% 2>&1
echo "양호 : 1) 디렉토리 소유자 : Administrator 또는 전용 WAS 계정일 경우"													>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정된 경우"																	>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1
echo "취약 : 1) 디렉토리 소유자 : Administrator 또는 전용 WAS 계정이 아닐 경우"												>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정이 안된 경우"																>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo "## Tomcat_Windows003 ##"
echo "##### WC-003 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-003 소스/설정파일 권한 설정 ##"																						>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "--------------- 소스 파일 ---------------"																				>> %RES_LAST_FILE% 2>&1

echo 소스 파일 권한																										>> %RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1
icacls "%appbase%" /T 																									>> %RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1

echo "--------------- 웹서버 설정파일 ---------------"																		>> %RES_LAST_FILE% 2>&1			

echo 웹서버 설정파일 권한																									>> %RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1
icacls "%TOMCAT_DIR%\conf\*.xml"																						>> %RES_LAST_FILE% 2>&1
icacls "%TOMCAT_DIR%\conf\*.properties"																					>> %RES_LAST_FILE% 2>&1
icacls "%TOMCAT_DIR%\conf\*.policy"																						>> %RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1

echo "양호 : 1) 디렉토리 소유자 : Administrator 또는 전용 WAS 계정일 경우"													>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정된 경우"																	>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1
echo "취약 : 1) 디렉토리 소유자 : Administrator 또는 전용 WAS 계정이 아닐 경우"												>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정이 안된 경우"																>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows004 ##"
echo "##### WC-004 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-004 패스워드 파일 권한 설정 ##"																						>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo.																														>> %RES_LAST_FILE% 2>&1
icacls "%TOMCAT_DIR%\conf\tomcat-users.xml"	 																			>> %RES_LAST_FILE% 2>&1

echo "양호 : 1) 파일 소유자 : Administrator 또는 전용 WAS 계정일 경우"													>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정된 경우"																	>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1
echo "취약 : 1) 파일 소유자 : Administrator 또는 전용 WAS 계정이 아닐 경우"												>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정이 안된 경우"																>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1


echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows005 ##"
echo "##### WC-005 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-005 로그 디렉터리/파일 권한 설정 ##"																					>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1

echo "--------------- 로그 디렉터리/파일 권한 확인---------------"																>> %RES_LAST_FILE% 2>&1
dir /q "%TOMCAT_DIR%\logs" 																								>> %RES_LAST_FILE% 2>&1
dir /q "%TOMCAT_DIR%\logs\*" /T																							>> %RES_LAST_FILE% 2>&1
dir /q "%LOG%"																											>> %RES_LAST_FILE% 2>&1
dir /q "%LOG%\*" /T																										>> %RES_LAST_FILE% 2>&1

echo "--------------- 로그 디렉터리---------------"																			>> %RES_LAST_FILE% 2>&1
icacls "%TOMCAT_DIR%\logs"							 																	>> %RES_LAST_FILE% 2>&1
echo "--------------- 로그 파일 ---------------"																				>> %RES_LAST_FILE% 2>&1
icacls "%TOMCAT_DIR%\logs\*" /T								 															>> %RES_LAST_FILE% 2>&1
echo "--------------- log etc. ---------------"																				>> %RES_LAST_FILE% 2>&1
icacls "%LOG%"																											>> %RES_LAST_FILE% 2>&1
icacls "%LOG%\*" /T																										>> %RES_LAST_FILE% 2>&1

REM 추가부분 로그파일이 기본 경로에 없을때
echo "### 로그 파일이 기본 경로에 없을 때 ###"																					>> %RES_LAST_FILE% 2>&1
echo "------ logging 디렉토리 권한 확인------"																				>> %RES_LAST_FILE% 2>&1
dir /s "%TOMCAT_DIR%\logging.properties" /b >> logging.txt
REM TYPE logging.txt	>> %RES_LAST_FILE% 2>&1

for /f "delims=" %%i in (logging.txt) do (
REM echo 결과: %%i
type %%i | findstr /i catalina | findstr /i directory >> logging2.txt
) 																													>> %RES_LAST_FILE% 2>&1

for /f "tokens=1,2 delims==$ " %%a in (logging2.txt) do set path_logging2=%%b
REM echo %path_logging2%	>> %RES_LAST_FILE% 2>&1
echo "%path_logging2%"	>> logging3.txt

for /f "tokens=1,2 delims=}" %%c in (logging3.txt) do set log_replace=%%d
REM  echo %log_replace% >> %RES_LAST_FILE% 2>&1

set path_replace="%TOMCAT_DIR%\%log_replace%" 																		>> %RES_LAST_FILE% 2>&1
echo 경로 : "%path_replace%"																							>> %RES_LAST_FILE% 2>&1
icacls "%path_replace%" 																							>> %RES_LAST_FILE% 2>&1

rem logging 디렉토리 이외 catalina 파일들 찾는 경로

echo "------ 디렉토리 권한 확인------"																						>> %RES_LAST_FILE% 2>&1
dir /s "%TOMCAT_DIR%\catalina.sh" /b >> logging4.txt
TYPE logging4.txt																										>> %RES_LAST_FILE% 2>&1

for /f "delims=" %%i in (logging4.txt) do (
rem echo 결과: %%i
type "%%i" | findstr /i CATALINA_OUT=	 >> logging5.txt
) 																														>> %RES_LAST_FILE% 2>&1

echo 결과																												>> %RES_LAST_FILE% 2>&1
type logging5.txt 																										>> %RES_LAST_FILE% 2>&1

echo "양호 : 1) 파일 소유자 : Administrator 또는 전용 WAS 계정일 경우"														>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정된 경우"																	>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1
echo "취약 : 1) 파일 소유자 : Administrator 또는 전용 WAS 계정이 아닐 경우"													>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정이 안된 경우"																>> %RES_LAST_FILE% 2>&1
echo "		전용 WAS 계정 그릅(Administrator) - 모든 권한"																>> %RES_LAST_FILE% 2>&1
echo "		Users : 쓰기 권한 제거 / Everyone : 그룹 제거"																>> %RES_LAST_FILE% 2>&1


echo. 																														>> %RES_LAST_FILE% 2>&1
echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows006 ##"
echo "##### WC-006 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-006 관리 콘솔 보안 ##"																								>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1

TYPE "%TOMCAT_DIR%\conf\server.xml" | find /i "connector port"															>> %RES_LAST_FILE% 2>&1

echo "양호 : 1) 관리자 콘솔을 사용하지 않을 경우"																			>> %RES_LAST_FILE% 2>&1
echo "       2) 관리자 콘솔을 사용하고, Default Port(8080)를 사용하지 않는 경우"											>> %RES_LAST_FILE% 2>&1
echo "취약 : 1) 관리자 콘솔을 사용하고, Default Port(8080)를 사용하는 경우"													>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows007 ##"
echo "##### WC-007 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-007 디렉터리 리스팅 제거 ##"																						>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\web.xml" | find /V "<!--" | findstr /i param-name												>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\web.xml" | find /V "<!--" | findstr /i param-valu												>> %RES_LAST_FILE% 2>&1																													>> %RES_LAST_FILE% 2>&1

REM 추가부분-- server.xml 부분 확인
echo "--- server.xml 확인 ---"																								>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\server.xml" | find /V "<!--" | findstr /i param-name											>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\server.xml" | find /V "<!--" | findstr /i param-valu											>> %RES_LAST_FILE% 2>&1 

echo "양호 : <param-name>listings</param-name>값이 <param-value>false</param-value>일 경우"								>> %RES_LAST_FILE% 2>&1
echo "취약 : <param-name>listings</param-name>값이 <param-value>true</param-value>일 경우"								>> %RES_LAST_FILE% 2>&1


echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows008 ##"
echo "##### WC-008 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-008 관리 계정 이름 변경 ##"																							>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\tomcat-users.xml"	         																	>> %RES_LAST_FILE% 2>&1

echo "양호 : 기본 관리자 계정정보(tomcat/tomcat) 또는 유추 가능한 계정정보를 사용하지 않거나, 불필요한 Role이 제거되었을 경우 Tomcat 7.x 이상은 Default 계정이 주석처리되어 있음"								>> %RES_LAST_FILE% 2>&1
echo "취약 : 기본 관리자 계정정보(tomcat/tomcat) 또는 유추 가능한 계정정보를 사용하거나, 불필요한 Role이 적용되었을 경우"								>> %RES_LAST_FILE% 2>&1


echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1


echo "## Tomcat_Windows009 ##"
echo "##### WC-009 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-009 패스워드 복잡성 설정 ##"																						>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\tomcat-users.xml"	 																			>> %RES_LAST_FILE% 2>&1

echo "양호 : 당사 패스워드 정책에 맞게 설정되어 있을 경우"								>> %RES_LAST_FILE% 2>&1
echo "취약 : 당사 패스워드 정책에 맞게 설정되지 않았을 경우"								>> %RES_LAST_FILE% 2>&1


echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows010 ##"
echo "##### WC-010 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-010 examples 디렉터리 삭제 ##"																						>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
dir "%TOMCAT_DIR%\webapps\"								 																>> %RES_LAST_FILE% 2>&1

REM 추가부분-- examples라는 이름을 가진 모든 파일의 경로 검색
echo "--- examples 직접 검색 ---"																							>> %RES_LAST_FILE% 2>&1
dir /s /a:d "%TOMCAT_DIR%\examples*" 																					>> %RES_LAST_FILE% 2>&1

echo "양호 : sample 및 manual 디렉토리가 없는 경우"																		>> %RES_LAST_FILE% 2>&1
echo "취약 : sample 혹은 manaul 디렉토리가 있을 경우"																		>> %RES_LAST_FILE% 2>&1


echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows011 ##"
echo "##### WC-011 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-011 에러 메시지 관리 ##"																							>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "--- web.xml 확인 ---"																									>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\web.xml" | find /V "<!--" | findstr /i error													>> %RES_LAST_FILE% 2>&1
TYPE "%TOMCAT_DIR%\conf\web.xml" | find /V "<!--" | findstr /i location													>> %RES_LAST_FILE% 2>&1

REM 추가부분-- 다른 web.xml 부분 확인
echo. 																														>> %RES_LAST_FILE% 2>&1
TYPE webxmladdress.txt																									>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1
echo "--- 다른 web.xml 부분 확인 ---"																							>> %RES_LAST_FILE% 2>&1
for /f "delims=" %%i in (webxmladdress.txt) do (
echo 결과: %%i
type %%i | find /V "<!--" | findstr /i error
type %%i | find /V "<!--" | findstr /i location
) 																													>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1

REM 추가부분-- server.xml 부분 확인
echo "--- server.xml 확인 ---"																								>> %RES_LAST_FILE% 2>&1
TYPE %TOMCAT_DIR%\conf\server.xml | find /V "<!--" | findstr /i error													>> %RES_LAST_FILE% 2>&1
TYPE %TOMCAT_DIR%\conf\server.xml | find /V "<!--" | findstr /i location												>> %RES_LAST_FILE% 2>&1

echo "양호 : 에러 메세지 설정 및 에러페이지가 존재할 경우 "																	>> %RES_LAST_FILE% 2>&1
echo "취약 : 에러 메세지 설정 및 에러페이지가 존재하지 않을 경우 "															>> %RES_LAST_FILE% 2>&1



echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1



echo "## Tomcat_Windows012 ##"
echo "##### WC-012 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-012 프로세스 관리기능 삭제 ##"																						>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
dir %TOMCAT_DIR%\server\webapps\manager\WEB-INF\lib								 										>> %RES_LAST_FILE% 2>&1

REM 추가부분-- catalina라는 이름을 가진 모든 파일의 경로 검색
echo "--- catalina-manager.jar 직접 검색 ---"																				>> %RES_LAST_FILE% 2>&1
dir /s \catalina* 		 																								>> %RES_LAST_FILE% 2>&1
echo "양호 : catalina-manager.jar 파일이 존재하지 않을 경우"																>> %RES_LAST_FILE% 2>&1
echo "취약 : catalina-manager.jar 파일이 존재할 경우"																		>> %RES_LAST_FILE% 2>&1


echo. 																														>> %RES_LAST_FILE% 2>&1
echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1


echo "## Tomcat_Windows013 ##"
echo "##### WC-013 #####"																									>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																									>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1
echo "## WC-013 최신 패치 적용 ##"																								>> %RES_LAST_FILE% 2>&1
echo ***********************************************																		>> %RES_LAST_FILE% 2>&1

CALL %TOMCAT_DIR%\bin\version.bat >> TC_version.txt
type TC_version.txt																										>> %RES_LAST_FILE% 2>&1
echo.																													>> %RES_LAST_FILE% 2>&1

echo "양호 : 주기적으로 패치를 적용하는 경우"																				>> %RES_LAST_FILE% 2>&1
echo "취약 : 주기적으로 패치를 미적용하는 경우"																				>> %RES_LAST_FILE% 2>&1


echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1


echo "================== ETC(홈디렉토리, Web.xml, Server.xml) ========================"										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1
echo "##### 홈디렉토리 (dir %TOMCAT_DIR%) ###############"																	>> %RES_LAST_FILE% 2>&1
dir /q %TOMCAT_DIR% 																									>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1
echo "##### Web.xml (type %TOMCAT_DIR%\conf\web.xml) ###############"														>> %RES_LAST_FILE% 2>&1
TYPE %TOMCAT_DIR%\conf\web.xml																							>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1
echo "##### Web.xml 권한 확인 ###############"																				>> %RES_LAST_FILE% 2>&1
dir /q %TOMCAT_DIR%\conf\web.xml		 																				>> %RES_LAST_FILE% 2>&1
echo "##### Server.xml (type %TOMCAT_DIR%\conf\server.xml) ###############"													>> %RES_LAST_FILE% 2>&1
TYPE %TOMCAT_DIR%\conf\server.xml																						>> %RES_LAST_FILE% 2>&1
echo "##### Server.xml 권한 확인 ###############"																			>> %RES_LAST_FILE% 2>&1
dir /q %TOMCAT_DIR%\conf\server.xml																	  					>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1 
echo. 																														>> %RES_LAST_FILE% 2>&1




echo. --- END TIME ---------------------------------------------------------------------- 														
date /t 																			
time /t 																			
echo.                           								


@echo off
del [RESULT]_*.txt
del webxmladdress.txt
del logging*.txt
del TC_version.txt

echo.
echo.
echo.
echo.
EXIT