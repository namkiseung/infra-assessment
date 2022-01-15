setlocal
chcp 437
FOR /F "tokens=1" %%a IN ('date /t') DO set day=%%a

TITLE Windows PC sysinfo check
echo Windows PC sysinfo check                                                               > %COMPUTERNAME%-result.txt
color 9f
echo Copyright (c) 2018 SK think Co. Ltd. All right Reserved                                  >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■             Windows PC Security Check          ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■                    SK think                  ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■                 Copyright 2018-05              ■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  Start Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  >> %COMPUTERNAME%-result.txt
echo 점검일 : %DATE%																		 >> %COMPUTERNAME%-result.txt
echo 점검시간 : %TIME%																		 >> %COMPUTERNAME%-result.txt
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
echo ##########################         1. 계정 관리        ################################ >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.01 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############            P-1 패스워드 최대 사용 기간            ##################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Maximum password age (days): 값이 90 이상인 경우 양호                           >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
net accounts | find "Maximum password"														 >> %COMPUTERNAME%-result.txt
echo 사용자 계정 : %username%																 >> %COMPUTERNAME%-result.txt
net user %username% | find "Password required"												 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.01 END																				 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.02 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############               P-2 패스워드 정책관리               ##################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Minimum password length: 값이 9 이상 설정되어 있는 경우 양호                   >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
net accounts | find "length"                                                           >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.02 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.03 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############         P-3 복구 콘솔에서 자동 로그온 금지        ##################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준:  (1) : AutoAdminLogon (DWORD 값이 0일 경우 양호)             				     >> %COMPUTERNAME%-result.txt
echo ■        (2) : AutoAdminLogon (DWORD 값이 1일 경우 취약)               			     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
type local_security.txt | findstr -i "SecurityLevel" 										 >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\setup\recoveryconsole"           >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\setup\recoveryconsole" | find "securitylevel"           >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.03 END >> %COMPUTERNAME%-result.txt
echo ■■ 참고: AutoAdminLogon >> %COMPUTERNAME%-result.txt
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.04 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############                  P-4 공유 폴더 제거                #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 아래 기준에 만족할 경우 양호				                     >> %COMPUTERNAME%-result.txt
echo ■       : (1) 기본공유가 비활성화 되어 있으며 AutoShareWks 레지스트리 값이 0            >> %COMPUTERNAME%-result.txt
echo ■       : (2) 일반공유가 없거나 업무상 사용할 경우 Everyone 권한 제거                   >> %COMPUTERNAME%-result.txt
echo ■       : (3) 1, 2 조건을 둘다 만족해야 양호			                     >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- 기본공유점검_기본공유 현황                                                            >> %COMPUTERNAME%-result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- 기본공유점검_기본공유 비활성화 설정 레지스트리(값 없을 경우 취약)                     >> %COMPUTERNAME%-result.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" | findstr -i "autoshare" >>%COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- 일반공유점검_일반공유 현황                                                            >> %COMPUTERNAME%-result.txt
net share | find /v "$" | find /v "command"                                                  >> %COMPUTERNAME%-result.txt
net share | find /v "$" | find /v "command" |find /v "-"                                     >  share-folder.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- 일반공유점검_일반공유 권한 현황                                                       >> %COMPUTERNAME%-result.txt
FOR /F "tokens=2 skip=3" %%j IN (share-folder.txt) DO cacls %%j                              >> %COMPUTERNAME%-result.txt 2>nul
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del share-folder.txt
echo 1.04 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ■■ 참고:공유폴더 현황 >> %COMPUTERNAME%-result.txt
net share >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareWks" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.05 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############              P-05 불필요한 서비스 제거             #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 시스템에서 필요하지 않는 취약한 서비스가 중지되어 있을 경우 양호                >> %COMPUTERNAME%-result.txt
echo ■       : (1) Alerter(서버에서 클라이언트로 경고메세지를 보냄)                          >> %COMPUTERNAME%-result.txt
echo ■       : (2) Clipbook(서버내 Clipbook를 다른 클라이언트와 공유)                        >> %COMPUTERNAME%-result.txt
echo ■       : (3) Messenger(Net send 명령어를 이용하여 클라이언트에 메시지를 보냄)          >> %COMPUTERNAME%-result.txt
echo ■       : (4) Simple TCP/IP Services(Echo, Discard, Character, Generator, Daytime, 등)  >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
net start | find /I "Alerter"  			 								     				>> %COMPUTERNAME%-result.txt
net start | find /I "Clipbook"  						   			     					>> %COMPUTERNAME%-result.txt
net start | find /I "Computer Browser"   								     				>> %COMPUTERNAME%-result.txt
net start | find /I "DHCP Client"   								     					>> %COMPUTERNAME%-result.txt
net start | find /I "FTP Publishing Service"   								     			>> %COMPUTERNAME%-result.txt
net start | find /I "Internet Connection Sharing Service"   								>> %COMPUTERNAME%-result.txt
net start | find /I "Indexing Service"   								     				>> %COMPUTERNAME%-result.txt
net start | find /I "infared Monitor Service"   								     		>> %COMPUTERNAME%-result.txt
net start | find /I "Messenger"   								     						>> %COMPUTERNAME%-result.txt
net start | find /I "NetLogon"   								     						>> %COMPUTERNAME%-result.txt
net start | find /I "Network DDE"   								     					>> %COMPUTERNAME%-result.txt
net start | find /I "NetMeeting Remote Desktop Sharing Service"  							>> %COMPUTERNAME%-result.txt
net start | find /I "Print spooler"  								     					>> %COMPUTERNAME%-result.txt
net start | find /I "Remote Registry Service"   								     		>> %COMPUTERNAME%-result.txt
net start | find /I "Routing and Remote Access Service"   									>> %COMPUTERNAME%-result.txt
net start | find /I "Simple TCP/IP Service"   								     			>> %COMPUTERNAME%-result.txt
net start | find /I "SMTP Service"   								     					>> %COMPUTERNAME%-result.txt
net start | find /I "Task Scheduler"   										 				>> %COMPUTERNAME%-result.txt
net start | find /I "TCP/IP NetBIOS Helper"   								     			>> %COMPUTERNAME%-result.txt
net start | find /I "Terminal Service"   								     				>> %COMPUTERNAME%-result.txt
net start | find /I "Telnet"   								     							>> %COMPUTERNAME%-result.txt
net start | find /I "Alerter"  			 								     				>> service.txt
net start | find /I "Clipbook"  						   			     					>> service.txt
net start | find /I "Computer Browser"   								     				>> service.txt
net start | find /I "DHCP Client"   								     					>> service.txt
net start | find /I "FTP Publishing Service"   								     			>> service.txt
net start | find /I "Indexing Service"   								     				>> service.txt
net start | find /I "infared Monitor Service"   								     		>> service.txt
net start | find /I "NetLogon"   								     						>> service.txt
net start | find /I "Network DDE"   								     					>> service.txt
net start | find /I "NetMeeting Remote Desktop Sharing Service"  							>> service.txt
net start | find /I "Print spooler"  								     					>> service.txt
net start | find /I "Remote Registry Service"   								     		>> service.txt
net start | find /I "Routing and Remote Access Service"   									>> service.txt
net start | find /I "Simple TCP/IP Service"   								     			>> service.txt
net start | find /I "SMTP Service"   								     					>> service.txt
net start | find /I "Task Scheduler"   										 				>> service.txt
net start | find /I "TCP/IP NetBIOS Helper"   								     			>> service.txt
net start | find /I "Terminal Service"   								     				>> service.txt
net start | find /I "Telnet"   								     							>> service.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
for /F %%a in ("service.txt") do set "FileSize=%%~zi"
if %FileSize% EQU 0 ( 
ECHO ☞ 불필요한 서비스가 존재하지 않음.                                     >> %COMPUTERNAME%-result.txt
) else ( 
echo ☞ 아래와 같은 불필요한 서비스가 발견되었음.                                            >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
type service.txt                                                                             >> %COMPUTERNAME%-result.txt
)
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.05 END >> %COMPUTERNAME%-result.txt
del service.txt 2>nul
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.06 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############        P-06  Windows Messenger(MSN, .NET 메신더 등) #################### >> %COMPUTERNAME%-result.txt
echo ###############              와 같은 상용 메신저의 사용금지        #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: PC에서 Windows Messenger를 사용 할 경우 취약                                    >> %COMPUTERNAME%-result.txt
echo ■       : (1) PreventRun    REG_DWORD    0x1 경우 양호                                  >> %COMPUTERNAME%-result.txt
echo ■       : Windows Messenger 가 설치 되어 있지 않은경우 양호                             >> %COMPUTERNAME%-result.txt
echo ■       : (2) PreventRun    REG_DWORD    0x0 경우 취약                                  >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                         >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Messenger\Client" /s | findstr "PreventRun" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.06 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ■ 참고 : Messenger\Client 설치여부 확인                                                 >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.07 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############             P-07 파일 시스템을 NTFS로 포맷         #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 파일시스템이 보안 기능을 제공 해주는 NTFS일 경우 양호                          >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - C: 드라이브 파일 시스템 확인(NTFS일 경우 양호)                                        >> %COMPUTERNAME%-result.txt
fsutil fsinfo volumeinfo c:\                                                                 > fsutil.txt
type fsutil.txt | findstr -i "volume name"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - (참고)C: 드라이브 권한 확인(NTFS일 경우 계정별 권한 부여 설정이 출력됨)               >> %COMPUTERNAME%-result.txt
cacls c:\                                                                                    >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.07 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
fsutil fsinfo volumeinfo c:\                                                                 > fsutil.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.08 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############             P-08 다른 OS로 멀티부팅 금지           #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 단일 OS만 설치하여 사용하고 있을 경우 양호			                     >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
bcdedit                                                                                      >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.08 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.09 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##############  P-09 브라우저 종료시 임시 인터넷 파일 폴더의 내용 삭제 ################ >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 브라우저 종료시 임시인터넷 파일 폴더의 내용 삭제를 자동으로 설정 하지 않은 경우 >> %COMPUTERNAME%-result.txt
echo ■       : (1) Persistent    REG_DWORD    1 경우 취약                                    >> %COMPUTERNAME%-result.txt
echo ■       : (2) Persistent    REG_DWORD    0 경우 양호                                    >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - 1. 그룹 보안 정책				                                     >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Cache"  | findstr /I "Persistent"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - 2. 개인 브라우져 설정             		         	        	     >> %COMPUTERNAME%-result.txt
reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\CACHE"  | findstr /I "Persistent"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - 판단 조건                 					        	     >> %COMPUTERNAME%-result.txt
echo   ㄱ. 1,2번 값이 둘다 없을 경우 취약				        	     >> %COMPUTERNAME%-result.txt
echo   ㄴ. 1,2번 값이 둘다 0일 경우 양호				        	     >> %COMPUTERNAME%-result.txt
echo   ㄷ. 1번 값이 없고 2번 값이 0일 경우 양호        			        	     >> %COMPUTERNAME%-result.txt
echo 1.09 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Cache 값" >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\CACHE" 값" >> %COMPUTERNAME%-result.txt
reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\CACHE" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.10 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############           P-10 HOT FIX 등 최신 보안패치 적용       #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: HOT FIX 등 최신 보안패치 적용 시 양호                                           >> %COMPUTERNAME%-result.txt
echo ■       : (1) 업데이트 이력 및 자동 업데이트 설정 현황으로 판단 불가 시                 >> %COMPUTERNAME%-result.txt
echo ■       :     담당자와 인터뷰를 통해 PMS 적용 여부, 패치 주기 등으로 판단               >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - '##참고2. Windows 업데이트 이력##' 참고하여 최근 업데이트 이력 확인                   >> %COMPUTERNAME%-result.txt
type c:\windows\softwaredistribution\reportingevents.log >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- Windows 자동업데이트 설정 현황                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /s | findstr "AUOptions" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.10 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.11 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############               P-11 최신 서비스팩 적용              #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 최신 서비스팩이 설치되어 있을 경우 양호                                         >> %COMPUTERNAME%-result.txt
echo ■       : (Windows 7 SP 1)  					                                         >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
systeminfo > systeminfo.txt
type systeminfo.txt | find -i "Host Name"                                                    >> %COMPUTERNAME%-result.txt
type systeminfo.txt | find -i "Os Name"                                                      >> %COMPUTERNAME%-result.txt
type systeminfo.txt | find -i "Os Version"                                                   >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.11 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ■ 참고: 시스템 정보                                                                     >> %COMPUTERNAME%-result.txt
type systeminfo.txt                                                                          >> %COMPUTERNAME%-result.txt
del systeminfo.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.12 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############        P-12 MS-Office 한글, 어도비 아크로뱃 등     #################### >> %COMPUTERNAME%-result.txt
echo ###############        의 응용프로그램에 대한 최신 보안 패치 및    #################### >> %COMPUTERNAME%-result.txt
echo ###############                    권고사항 적용                   #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 사용중인 응용프로그램에 대한 최신 보안 패치 및 권고사항 적용여부 확인           >> %COMPUTERNAME%-result.txt
echo ■       (1) : (대상 : MS-Office, 한글, 어도비 아크로뱃)				                 >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
wmic product list brief						                                  			     >> program.txt
echo - Microsoft Office 버젼 정보(상세이력은 '##참고1. MS-Office 업데이트 이력##' 참조) >> %COMPUTERNAME%-result.txt
type program.txt | findstr -i "Office"                                                          >> %COMPUTERNAME%-result.txt
IF ERRORLEVEL 1 echo MS-OFFICE가 설치되어 있지 않습니다.                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - Acrobat Reader 버젼 정보			                                                     >> %COMPUTERNAME%-result.txt
type program.txt | findstr -i "Adobe"                                                           >> %COMPUTERNAME%-result.txt
IF ERRORLEVEL 1 echo Acrobat이 설치되어 있지 않습니다.                                       >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - 한글 버젼 정보				                                                         >> %COMPUTERNAME%-result.txt
type program.txt | findstr -i "hancom hansoft"                                                          >> %COMPUTERNAME%-result.txt
type program.txt | find /I "haansoft"                                                        >> %COMPUTERNAME%-result.txt
IF ERRORLEVEL 1 echo 한글이 설치되어 있지 않습니다.                                          >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.12 END >> %COMPUTERNAME%-result.txt
type program.txt>> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.13 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##############  P-13 바이러스 백신 프로그램 설치 및 주기적 업데이트  ################## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 백신이 설치되어 있으며 실시간 업데이트 설정이 적용되어 있는 경우            >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.① 백신 설치여부 확인                                                                    >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" > nul
IF ERRORLEVEL 1 echo AhnLab V3 Internet Security 가 설치되어 있지 않습니다.              >> %COMPUTERNAME%-result.txt
IF NOT ERRORLEVEL 1 echo AhnLab V3 Internet Security 가 설치되어 있습니다.                   >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.② V3 실시간 업데이트 설정                                                           >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0" /s | findstr "V3IS90" | find "REG_DWORD" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo V3 자동 업데이트 주기                                                              >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0\Option\UPDATE" /s | findstr "autoupdateperiod" >> %COMPUTERNAME%-result.txt
echo.                                                                                       >> %COMPUTERNAME%-result.txt
echo 1.13 END >> %COMPUTERNAME%-result.txt

echo ■ V3 정보 확인 >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0" >> %COMPUTERNAME%-result.txt
echo ■ V3 Update 정보 >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0\Option\UPDATE" >> %COMPUTERNAME%-result.txt
echo.                                                                                       >> %COMPUTERNAME%-result.txt
echo.                                                                                       >> %COMPUTERNAME%-result.txt
echo 1.14 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #########  P-14 바이러스 백신 프로그램에서 제공하는 실시간 감시 기능 활성화  ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 백신이 설치 되어 있으며, 실시간 감지기능을 활성화 할 경우 양호                  >> %COMPUTERNAME%-result.txt
echo    Sysmonuse  REG_DWORD    "1"    경우 양호                                             >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.① 백신 설치여부 확인                                                                   >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" > nul
IF ERRORLEVEL 1 echo AhnLab V3 Internet Security 가 설치되어 있지 않습니다.          >> %COMPUTERNAME%-result.txt
IF NOT ERRORLEVEL 1 echo AhnLab V3 Internet Security 가 설치되어 있습니다.           >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.② V3 실시간 검사 활성화 여부                                                           >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\AhnLab\V3IS80\sysmon" /s | findstr "sysmonuse" > V3_check1.txt
type V3_check1.txt                                                                           >> %COMPUTERNAME%-result.txt     
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.------------------------------------------------------------                      >> %COMPUTERNAME%-result.txt
echo.참고. 실시간 검사 종료 후 자동으로 다시 시작 시간 설정                            >> %COMPUTERNAME%-result.txt                              
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\AhnLab\V3IS80\sysmon" /s | findstr "restart" > V3_check2.txt
type V3_check2.txt                                                                     >> %COMPUTERNAME%-result.txt     
echo.                                                                                  >> %COMPUTERNAME%-result.txt   
echo.＊V3 백신이 설치가 되어 있지 않을 경우 "N/A"                                      >> %COMPUTERNAME%-result.txt
echo.                                                                                  >> %COMPUTERNAME%-result.txt   
del V3_check1.txt
del V3_check2.txt

echo 1.14 END >> %COMPUTERNAME%-result.txt
echo ■ V3 Schedule 정보 >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0\Option\SCHDLSCN" >> %COMPUTERNAME%-result.txt
echo.                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                     >> %COMPUTERNAME%-result.txt
echo 1.15 START                                                           >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############     P-15 OS에서 제공하는 침입차단 기능 활성화      #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Windows 방화벽 기능 "사용" 중이면 양호                      >> %COMPUTERNAME%-result.txt
echo ■       (1) : (EnableFirewall	0 일 경우 취약)					     >> %COMPUTERNAME%-result.txt
echo ■       (2) : (EnableFirewall	1 일 경우 양호)					     >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo [방화벽 동작 설정]                                                                      >> %COMPUTERNAME%-result.txt
echo ---------------------------------------------------------------------------------       >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"  | findstr "EnableFirewall" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [예외 허용 안함 설정]                                                                   >> %COMPUTERNAME%-result.txt
echo ---------------------------------------------------------------------------------       >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"  | findstr "DoNotAllowExceptions" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [예외 포트 등록 설정]                                                                   >> %COMPUTERNAME%-result.txt
echo ---------------------------------------------------------------------------------       >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\GloballyOpenPorts\List" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo *. EnableFirewall 값이 없을 경우 양호로 판단                                            >> %COMPUTERNAME%-result.txt
echo   (윈도우 설치 시 기본으로 방화벽이 활성화 되어 있는 경우 레지스트리 값이 없음)         >> %COMPUTERNAME%-result.txt
echo 1.15 END >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.16 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############       P-16 화면보호기 대기 시간을 5~10분으로       #################### >> %COMPUTERNAME%-result.txt
echo ###############       설정 및 재시작시 암호로 보호하도록 설정      #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 화면 보호기를 설정하고, 암호를 사용하며, 대기 시간이 기관의 정책에 맞게 적용 될 경우 양호 >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | findstr -i "ScreenSaveActive"          >> %COMPUTERNAME%-result.txt
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | findstr -i "ScreenSaverIsSecure"       >> %COMPUTERNAME%-result.txt
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | findstr -i "ScreenSaveTimeOut"         >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.16 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.17 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #############    P-17 CD,DVD,USB 메모리 등과 같은 미디어의 자동실행   ################# >> %COMPUTERNAME%-result.txt
echo #############       방지 등 이동식 미디어에 대한 보안대책 수립        ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: CD,DVD,USB 메모리 등과 같은 미디어의 자동실행 제한 설정을 적용한 경우 양호      >> %COMPUTERNAME%-result.txt
echo ■       (1) : (NoDriveTypeAutoRun DWORD 값이 "255(모든 드라이브)" 로 적용 되어 있을 경우 양호) >> %COMPUTERNAME%-result.txt
echo ■       (2) : (NoDriveTypeAutoRun DWORD 값이 "181(CD-ROM, 이동식 미디어)이거나          >> %COMPUTERNAME%-result.txt
echo ■       (3) : (NoDriveTypeAutoRun DWORD 값이 없을 경우 취약				             >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /s | findstr /I "NoDriveTypeAutoRun" >> %COMPUTERNAME%-result.txt   
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.17 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.18 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############       P-18 PC 내부 미사용 (3개월) ActiveX 제거        ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 3개월 이상의 사용하지 않은  ActiveX 가 존재할 경우 취약                         >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 담당자 인터뷰           																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.18 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.19 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############   P-19 시스템 부팅시 Windows Messenger 자동시작 금지  ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: Windows MSN 자동시작 금지 시 양호                                               >> %COMPUTERNAME%-result.txt
echo ■       (DWORD 값이 1이거나, Windows Messenger 가 설치되어 있지 않은 경우 양호)         >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Messenger\Client"  /s | findstr "PreventAutoRun" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Messenger\Client" /I "PreventAutoRun" > nul
IF ERRORLEVEL 1 echo Windows Messenger 가 설치되어 있지 않습니다.                            >> %COMPUTERNAME%-result.txt
IF NOT ERRORLEVEL 1 echo Windows Messenger 가 설치되어 있습니다.                             >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.19 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.20 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############             P-20 원격 지원 금지 정책 설정             ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ■ 기준: 원격지원 제공 설정을 금지한 경우 양호                                             >> %COMPUTERNAME%-result.txt
echo ■       (1) : (DWORD 값이 0일 경우 양호 - 사용안함)                                      >> %COMPUTERNAME%-result.txt
echo ■       (2) : (결과값이 없는 경우 양호 - 구성하지 않음)                                   >> %COMPUTERNAME%-result.txt
echo ■ 현황                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                         >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"  /s | findstr "fAllowUnsolicited" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.20 END >> %COMPUTERNAME%-result.txt
echo.                                                                                      >> %COMPUTERNAME%-result.txt
echo 참고: fAllowUnsolicited                                                              >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" >> %COMPUTERNAME%-result.txt
echo.                                                                                      >> %COMPUTERNAME%-result.txt
echo.                                                                                      >> %COMPUTERNAME%-result.txt
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   END Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ >> %COMPUTERNAME%-result.txt
echo.
echo ##참고1. PC 정보 현황##		                                                         >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #################################  Port Information  ################################## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
netstat -an | find /v "TIME_WAIT"                                                            >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############################  tasklist Information  ################################ >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
tasklist							                                                         >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ############################  Service Daemon Information  ############################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
net start >> %COMPUTERNAME%-result.txt

echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################  Environment Variable Information  ######################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
set											                                                 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##########################  Local Security Policy Information  ######################## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
secedit /export /cfg local_security.txt
type local_security.txt >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

del activexlist.txt
del notlist.txt
del path_temp.txt
del temp3.txt
del time_temp.txt
del local_security.txt
del program.txt
del fsutil.txt

type activex.txt									 >> %COMPUTERNAME%-result.txt
echo.											     >> %COMPUTERNAME%-result.txt
echo.
echo.
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
echo ■■■                                                      ■■■
echo ■■■       Windows PC Security Check is Finished          ■■■
echo ■■■                                                      ■■■
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
echo.
echo END_RESULT                                                 >> %COMPUTERNAME%-result.txt
pause
EXIT
