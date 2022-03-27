@echo off

FOR /F "tokens=4 delims= " %%a in ('route print ^| find "0.0.0.0" ^| find /v "??"') do set IP=%%a
SET RES_LAST_FILE=WINDOWS_%IP%_%COMPUTERNAME%.asvd

:1
set /p APACHE_DIR=Input Apache Base Path :
if exist "%APACHE_DIR%" (
echo Apache base directory is "%APACHE_DIR%".
) else (
echo Apache Directory it not exist.
goto 1
)

:2
set /p DOCUMENT_CONF=Input Apache document root Path :
if exist "%DOCUMENT_CONF%" (
echo Document Root path is "%DOCUMENT_CONF%" 입니다.
) else (
echo Document Root path is not exist.
goto 2
)

:3
set /p LOG_PATH=Input Apache Log Path :
if exist "%LOG_PATH%" (
echo Log path is "%LOG_PATH%" 입니다.
) else (
echo Log path is not exist.
goto 3
)

SETLOCAL ENABLEDELAYEDEXPANSION







echo. --- START TIME ----------------------------------------------------------------------                                              >> %RES_LAST_FILE% 2>&1
date /t                                                                                     >> %RES_LAST_FILE% 2>&1
time /t                                                                                     >> %RES_LAST_FILE% 2>&1
echo.                                                                                         >> %RES_LAST_FILE% 2>&1

set APACHE_CONF=%APACHE_DIR%\conf\httpd.conf


echo.
echo. *************************************************************                                             >> %RES_LAST_FILE% 2>&1
echo. ****** AhnLab System Checklist for Windows_Apache ver 4.8.3 *******                                             >> %RES_LAST_FILE% 2>&1
echo. *************************************************************                                             >> %RES_LAST_FILE% 2>&1
echo.                                                                                           >> %RES_LAST_FILE% 2>&1
echo *******APACHE SERVER ROOT********				>> %RES_LAST_FILE% 2>&1
echo %HTTPD_FULL_CONF%									>> %RES_LAST_FILE% 2>&1
echo *********************************				>> %RES_LAST_FILE% 2>&1

echo *******Administrator Info********				>> %RES_LAST_FILE% 2>&1
net localgroup administrators >> %RES_LAST_FILE% 2>&1
net user administrator | find "Account active" >> %RES_LAST_FILE% 2>&1
echo *********************************				>> %RES_LAST_FILE% 2>&1

echo SYSTEM WINDOWS HeaderInfo {ahnlab{ >> %RES_LAST_FILE% 2>&1 

echo ** ASVD_INFO: 1 WINDOWS >> %RES_LAST_FILE% 2>&1
echo ** START_TIME: %CDATE% %TIME% >> %RES_LAST_FILE% 2>&1
echo ** HOSTNAME: %COMPUTERNAME% >> %RES_LAST_FILE% 2>&1
echo ** IP ADDRESS: %IP% >> %RES_LAST_FILE% 2>&1
echo }ahnlab} >> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 001 ##"
echo "##### WA-001 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-001 웹 프로세스 권한 제한 ###############"         																	>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< Process >---------------"      																			>> %RES_LAST_FILE% 2>&1   
tasklist /V | findstr /i "httpd" > check_admin.txt
set /p CHECK_ADMIN=< check_admin.txt  
echo "%CHECK_ADMIN%" 																										>> %RES_LAST_FILE% 2>&1
del check_admin.txt
echo "---------------< httpd.conf >---------------"   																			>> %RES_LAST_FILE% 2>&1         
type "%APACHE_CONF%" | findstr /V "#" | findstr /I /C:"User " /C:"Group "      												>> %RES_LAST_FILE% 2>&1

echo "양호 : Window N/A"																										>> %RES_LAST_FILE% 2>&1
echo "취약 : Window N/A"																										>> %RES_LAST_FILE% 2>&1
echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1


echo "## APACHE-WINDOWS 002 ##"
echo "##### WA-002 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-002 디렉터리 쓰기 권한 설정 ###############"         																>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< ServerRoot >---------------"      																		>> %RES_LAST_FILE% 2>&1
echo "%APACHE_DIR%"																											>> %RES_LAST_FILE% 2>&1
icacls "%APACHE_DIR%"																										>> %RES_LAST_FILE% 2>&1
echo "---------------< DocumentRoot >---------------"   																		>> %RES_LAST_FILE% 2>&1
echo "%DOCUMENT_CONF%"																										>> %RES_LAST_FILE% 2>&1
icacls "%DOCUMENT_CONF%"  																									>> %RES_LAST_FILE% 2>&1

echo "양호 : 1) 디렉토리 소유자 : Administrator 또는 전용 Web Server 계정일 경우"												>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정된 경우"																		>> %RES_LAST_FILE% 2>&1
echo "       전용 Web Server 계정 그룹(Administrator) - 모든 권한"															>> %RES_LAST_FILE% 2>&1
echo "        Users : 쓰기 권한 제거"																							>> %RES_LAST_FILE% 2>&1
echo "        Everyone : 그룹 제거"																							>> %RES_LAST_FILE% 2>&1
echo "*취약 : 1) 디렉토리 소유자 : Administrator 또는 전용 Web Server 계정이 아닐 경우"											>> %RES_LAST_FILE% 2>&1
echo "        2) 그룹 권한 설정이 아래와 같이 설정이 안된 경우"																	>> %RES_LAST_FILE% 2>&1
echo "        전용 Web Server 계정 그룹(Administrator) - 모든 권한"															>> %RES_LAST_FILE% 2>&1
echo "        Users : 쓰기 권한 제거"																							>> %RES_LAST_FILE% 2>&1
echo "        Everyone : 그룹 제거 "																							>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 003 ##"
echo "##### WA-003 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-003 설정파일 권한 설정 ###############"         																		>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< httpd.conf >---------------"      																		>> %RES_LAST_FILE% 2>&1
echo "%APACHE_CONF%"																										>> %RES_LAST_FILE% 2>&1
icacls "%APACHE_CONF%"																										>> %RES_LAST_FILE% 2>&1                                            

echo "양호 : 1) 디렉토리 소유자 : Administrator 또는 전용 Web Server 계정일 경우"												>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정된 경우"																		>> %RES_LAST_FILE% 2>&1
echo "       전용 Web Server 계정 그룹(Administrator) - 모든 권한"															>> %RES_LAST_FILE% 2>&1
echo "        Users : 쓰기 권한 제거"																							>> %RES_LAST_FILE% 2>&1
echo "        Everyone : 그룹 제거"																							>> %RES_LAST_FILE% 2>&1
echo "*취약 : 1) 디렉토리 소유자 : Administrator 또는 전용 Web Server 계정이 아닐 경우"											>> %RES_LAST_FILE% 2>&1
echo "        2) 그룹 권한 설정이 아래와 같이 설정이 안된 경우"																	>> %RES_LAST_FILE% 2>&1
echo "        전용 Web Server 계정 그룹(Administrator) - 모든 권한"															>> %RES_LAST_FILE% 2>&1
echo "        Users : 쓰기 권한 제거"																							>> %RES_LAST_FILE% 2>&1
echo "        Everyone : 그룹 제거 "																							>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 004 ##"
echo "##### WA-004 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-004 로그 디렉토리 / 파일 권한 설정 ###############"         															>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< ErrorLog >---------------"      																			>> %RES_LAST_FILE% 2>&1
echo "%LOG_PATH%"																											>> %RES_LAST_FILE% 2>&1
icacls "%LOG_PATH%" /T 																										>> %RES_LAST_FILE% 2>&1

echo "양호 : 1) 디렉토리 소유자 : Administrator 또는 전용 Web Server 계정일 경우"												>> %RES_LAST_FILE% 2>&1
echo "       2) 그룹 권한 설정이 아래와 같이 설정된 경우"																		>> %RES_LAST_FILE% 2>&1
echo "       전용 Web Server 계정 그룹(Administrator) - 모든 권한"															>> %RES_LAST_FILE% 2>&1
echo "        Users : 쓰기 권한 제거"																							>> %RES_LAST_FILE% 2>&1
echo "        Everyone : 그룹 제거"																							>> %RES_LAST_FILE% 2>&1
echo "*취약 : 1) 디렉토리 소유자 : Administrator 또는 전용 Web Server 계정이 아닐 경우"											>> %RES_LAST_FILE% 2>&1
echo "        2) 그룹 권한 설정이 아래와 같이 설정이 안된 경우"																	>> %RES_LAST_FILE% 2>&1
echo "        전용 Web Server 계정 그룹(Administrator) - 모든 권한"															>> %RES_LAST_FILE% 2>&1
echo "        Users : 쓰기 권한 제거"																							>> %RES_LAST_FILE% 2>&1
echo "        Everyone : 그룹 제거 "																							>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 005 ##"
echo "##### WA-005 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-005 디렉터리 리스팅 제거 ###############"         																	>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< Options >---------------"     																			>> %RES_LAST_FILE% 2>&1   
echo "%APACHE_CONF%"																										>> %RES_LAST_FILE% 2>&1
type "%APACHE_CONF%" | findstr /v IndexOptions | findstr /v # | findstr Options  											>> %RES_LAST_FILE% 2>&1 
echo "---------------< Directory >---------------"   																			>> %RES_LAST_FILE% 2>&1         
type "%APACHE_CONF%" | findstr /v # | findstr /i Directory																	>> %RES_LAST_FILE% 2>&1

echo "양호 : -Indexes 또는 IncludeNoExec 설정이 되어있는 경우"																	>> %RES_LAST_FILE% 2>&1
echo "취약 : indexes 설정이 되어 있는 경우"																					>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																										>> %RES_LAST_FILE% 2>&1
echo. 																														>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 006 ##"
echo "##### WA-006 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-006 링크 사용 금지 ###############"         																			>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< Options >---------------"      																			>> %RES_LAST_FILE% 2>&1   
type "%APACHE_CONF%" | findstr /v IndexOptions | findstr /v # | findstr Options  											>> %RES_LAST_FILE% 2>&1 
echo "---------------< Directory >---------------"   																			>> %RES_LAST_FILE% 2>&1         
type "%APACHE_CONF%" | findstr /v # | findstr /i Directory																	>> %RES_LAST_FILE% 2>&1

echo "양호 : FollowSymLinks 설정 값이 없거나, -FollowSymLinks 설정되어 있는 경우"												>> %RES_LAST_FILE% 2>&1
echo "취약 : FollowSymLinks 설정되어 있는 경우"																				>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 007 ##"
echo "##### WA-007 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-007 불필요한 파일 제거 ###############"         																		>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< Manual / cgi-bin >---------------"      																	>> %RES_LAST_FILE% 2>&1
dir /s "%APACHE_DIR%\Manual" /b                            																	>> %RES_LAST_FILE% 2>&1
dir /s "%APACHE_DIR%\cgi-bin" /b                          																	>> %RES_LAST_FILE% 2>&1

echo "양호 : 불필요한 파일 또는 기본 CGI 스크립트 파일이 존재하지 않는 경우"														>> %RES_LAST_FILE% 2>&1
echo "취약 : 불필요한 파일 또는 기본 CGI 스크립트 파일이 존재하는 경우"															>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 008 ##"
echo "##### WA-008 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-008 응답 메시지 헤더정보 숨기기 ###############"         																>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< ServerTokens (httpd.conf) >---------------"      														>> %RES_LAST_FILE% 2>&1
type %APACHE_CONF% | findstr /v # | findstr ServerTokens             														>> %RES_LAST_FILE% 2>&1

echo "양호 : ServerTokens가 Prod 또는 ProductOnly로 설정 되어있고, ServerSignature가 off로 설정 되어 있는 경우"					>> %RES_LAST_FILE% 2>&1
echo "취약 : ServerTokens가 Prod 또는 ProductOnly로 설정이 안되어있고, ServerSignature가 off로 설정 안되어 있는 경우"			>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 009 ##"
echo "##### WA-009 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-009 Multiview 옵션 비 활성화 ###############"         																>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< Options >---------------"      																			>> %RES_LAST_FILE% 2>&1   
type "%APACHE_CONF%" | findstr /v IndexOptions | findstr /v # | findstr Options  											>> %RES_LAST_FILE% 2>&1 
echo "---------------< Directory >---------------"   																			>> %RES_LAST_FILE% 2>&1         
type "%APACHE_CONF%" | findstr /v # | findstr /i Directory																	>> %RES_LAST_FILE% 2>&1

echo "양호 : MultiViews 설정 값이 없거나, -MultiViews 설정이 되어있는 경우"														>> %RES_LAST_FILE% 2>&1
echo "취약 : MultiViews 설정이어 있는 경우"																					>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 010 ##"
echo "##### WA-010 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-010 HTTP Method 제한 ###############"         																		>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< Limit Options >---------------"      																	>> %RES_LAST_FILE% 2>&1   
type "%APACHE_CONF%" | findstr /v "ServerLimit" | findstr /v # | findstr Limit  											>> %RES_LAST_FILE% 2>&1 
echo "---------------< TraceEnable >---------------"   																			>> %RES_LAST_FILE% 2>&1         
type "%APACHE_CONF%" | findstr /v # | findstr "TraceEnable"																	>> %RES_LAST_FILE% 2>&1                         

echo "양호 : TraceEnable Off 설정 되어 있고, Dav Off 설정되어 있는 경우 (Default 값 : Dav on)"									>> %RES_LAST_FILE% 2>&1
echo "      'Limit', 'LimitExcept'에 PUT, DELETE 등 불필요한 메소드가 존재하지 않을 경우"										>> %RES_LAST_FILE% 2>&1
echo "취약 : TraceEnable On 설정 되어 있고, Dav On 설정되어 있는 경우 (Default 값 : Dav on)"									>> %RES_LAST_FILE% 2>&1
echo "      'Limit', 'LimitExcept'에 PUT, DELETE 등 불필요한 메소드가 존재할 경우"												>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 011 ##"
echo "##### WA-011 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-011 로그 설정 관리 ###############"         																			>> %RES_LAST_FILE% 2>&1               
                         
echo "---------------< ErrorLog >---------------"      																			>> %RES_LAST_FILE% 2>&1
type "%APACHE_CONF%" | findstr /v # | findstr /i ErrorLog 						 											>> %RES_LAST_FILE% 2>&1
echo "---------------< CustomLog >---------------"      																		>> %RES_LAST_FILE% 2>&1
type "%APACHE_CONF%" | findstr /v # | findstr /i CustomLog 						 											>> %RES_LAST_FILE% 2>&1

echo "---------------< Log Format settings >---------------"      																>> %RES_LAST_FILE% 2>&1
type %APACHE_CONF% | findstr /v # | findstr LogFormat     																		>> %RES_LAST_FILE% 2>&1

echo "양호 : 로그포맷 설정 값이 combined 이거나, 아래 LogFormat 지시어가 설정 되어 있을 경우"									>> %RES_LAST_FILE% 2>&1
echo "      LogFormat %h %l %u %t \%r\ %>s %b \%{Referer}i\ \{User-agent}i\ "												>> %RES_LAST_FILE% 2>&1
echo "취약 : 로그포맷 설정 값이 combined 이 아니거나, 아래 LogFormat 지시어가 설정 되어 있지 않은 경우"							>> %RES_LAST_FILE% 2>&1
echo "      LogFormat %h %l %u %t \%r\ %>s %b \%{Referer}i\ \{User-agent}i\ "												>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 012 ##"
echo "##### WA-012 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-012 파일 업로드 및 다운로드 제한 ###############"         															>> %RES_LAST_FILE% 2>&1   
echo "Limit Request Body check"            																						>> %RES_LAST_FILE% 2>&1 
type /i "options" "%APACHE_CONF%" | findstr /v # | findstr /i limitrequestbody													>> %RES_LAST_FILE% 2>&1                        

echo "양호 : LimitRequestBody를 통해 파일 업로드 및 다운로드 용량을 제한하는 경우"												>> %RES_LAST_FILE% 2>&1
echo "취약 : 파일 업로드 및 다운로드 용량이 제한없는 경우"																		>> %RES_LAST_FILE% 2>&1
echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 013 ##"
echo "##### WA-013 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-013 웹 서비스 영역의 분리 ###############"         																	>> %RES_LAST_FILE% 2>&1               
type "%APACHE_CONF%" | findstr /v # | findstr /i DocumentRoot 																>> %RES_LAST_FILE% 2>&1

echo "양호 : 웹 서비스 파일과 Apache 데몬이 다른 영역이 분리 되어 있을 경우"														>> %RES_LAST_FILE% 2>&1
echo "취약 : 웹 서비스 파일과 Apache 데몬이 다른 영역이 분리 안되어 있을 경우"													>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1


echo "## APACHE-WINDOWS 014 ##"
echo "##### WA-014 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-014 상위 디렉터리 접근 금지 ###############"         																>> %RES_LAST_FILE% 2>&1               
type "%APACHE_CONF%" | findstr /v # | findstr /C:"allowoverride"               												>> %RES_LAST_FILE% 2>&1

echo "양호 : allowoveride가 None 또는 authconfig로 설정되어있는 경우"															>> %RES_LAST_FILE% 2>&1
echo "취약 : allowoveride가 양호 이외에 다른 값으로 설정된 경우"																>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1


echo "## APACHE-WINDOWS 015 ##"
echo "##### WA-015 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-015 에러 메시지 관리 ###############"               																	>> %RES_LAST_FILE% 2>&1 

echo "######## < ErrorDocument > ########"                      																>> %RES_LAST_FILE% 2>&1
TYPE "%APACHE_CONF%"   | findstr /v # | findstr ErrorDocument       															>> %RES_LAST_FILE% 2>&1

echo "양호 : [1],[2] 설정 모두 했을 경우"																						>> %RES_LAST_FILE% 2>&1
echo "양호 : + [1] 결과값에서 ErrorDocument 설정이 되어 있을 경우"																>> %RES_LAST_FILE% 2>&1
echo "양호 : + [2] [1]의 에러페이지 경로에 있는 파일이 있을 경우"																>> %RES_LAST_FILE% 2>&1
echo "취약 : [1],[2] 설정 중 하나라도 미흡할 경우"																				>> %RES_LAST_FILE% 2>&1
echo "취약 : + [1] 결과값에서 ErrorDocument 설정이 안되어 있을 경우"															>> %RES_LAST_FILE% 2>&1
echo "취약 : + [2] [1]의 url 경로에 있는 파일이 없을 경우"																		>> %RES_LAST_FILE% 2>&1

echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "## APACHE-WINDOWS 016 ##"
echo "##### WA-016 #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### START #####"																										>> %RES_LAST_FILE% 2>&1
echo "##### WA-016 최신 패치 적용 ###############"                       															>> %RES_LAST_FILE% 2>&1
CALL "%APACHE_DIR%\bin\httpd" -v >> version.txt	
type version.txt																											>> %RES_LAST_FILE% 2>&1															

echo "양호 : 주기적으로 패치를 적용하는 경우"																					>> %RES_LAST_FILE% 2>&1
echo "취약 : 주기적으로 패치를 미적용하는 경우"																					>> %RES_LAST_FILE% 2>&1


echo "##### END #####" 																											>> %RES_LAST_FILE% 2>&1
echo. 																															>> %RES_LAST_FILE% 2>&1

echo "=====================ETC (Setting Files)=========================="			>> %RES_LAST_FILE% 2>&1
echo .			>> %RES_LAST_FILE% 2>&1
echo .			>> %RES_LAST_FILE% 2>&1
echo "##### httpd.conf ######"			>> %RES_LAST_FILE% 2>&1
type "%APACHE_CONF%"						>> %RES_LAST_FILE% 2>&1
echo .				>> %RES_LAST_FILE% 2>&1
echo .				>> %RES_LAST_FILE% 2>&1


REM 명령어 끝부분...........



echo. End of script >> %RES_LAST_FILE% 2>&1

chcp 949

echo. --- END TIME ---
del version.txt