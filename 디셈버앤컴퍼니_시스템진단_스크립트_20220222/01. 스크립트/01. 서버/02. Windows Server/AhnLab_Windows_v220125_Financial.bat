@echo off

REM --------- Header ----------

SET PATH=%PATH%;.\bin;
FOR /F "tokens=4 delims= " %%a in ('route print ^| find "0.0.0.0" ^| find /v "??"') do set IP=%%a
SET RES_LAST_FILE=WIN_%IP%_%COMPUTERNAME%.log


echo. --- START TIME ---------------------------------------------------------------------- 												>> %RES_LAST_FILE% 2>&1

	date /t 																																>> %RES_LAST_FILE% 2>&1
	time /t																																	>> %RES_LAST_FILE% 2>&1
echo.  																																		>> %RES_LAST_FILE% 2>&1
SETLOCAL ENABLEDELAYEDEXPANSION

REM ------------------------------


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



REM 4. IIS
	echo "## IIS_VERSION (REG) ##" >> %RES_LAST_FILE% 2>&1
	reg query "HKLM\SOFTWARE\Microsoft\InetStp" /s | find /I "VersionString" > [ahnlab]_IIS_VERSION.ahn
	type [ahnlab]_IIS_VERSION.ahn >> %RES_LAST_FILE% 2>&1


REM ###########################################
REM ## 관리자 권한 실행 요청 부분
REM ###########################################
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리 권한을 요청 ...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
	del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
pushd "%CD%"
    CD /D "%~dp0"
REM chcp 437
chcp 949
echo.
echo.###########################################################																					>> %RES_LAST_FILE% 2>&1
echo.###########################################################																					>> %RES_LAST_FILE% 2>&1
echo.###### AhnLab System Checklist fo r Windows ver 2021.01 ####																					>> %RES_LAST_FILE% 2>&1
echo.###########################################################																					>> %RES_LAST_FILE% 2>&1
echo.###########################################################																					>> %RES_LAST_FILE% 2>&1
echo.																																				>> %RES_LAST_FILE% 2>&1
echo.																																				>> %RES_LAST_FILE% 2>&1

echo.##################### System Information ##################### 																				>> %RES_LAST_FILE% 2>&1
	systeminfo >> systeminfo1.ahn
	
	TYPE systeminfo1.ahn >> %RES_LAST_FILE% 2>&1
	echo. >> %RES_LAST_FILE% 2>&1

echo "## export Secedit ##"
echo "## export Secedit ##" >> %RES_LAST_FILE% 2>&1
Secedit /export /cfg [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn


echo.#[IPCONFIG]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
	ipconfig /all >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
	TYPE [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn >> %RES_LAST_FILE% 2>&1

echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-001 SNMP 서비스 Get community 스트링 설정 미흡]													>> %RES_LAST_FILE% 2>&1
echo.[SRV-001] OK
echo.##### SRV001 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.#SNMP 서비스 구동 여부>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I snmp || echo.[양호] SNMP 서비스 미구동) >> %RES_LAST_FILE% 2>&1
echo.#SNMP\Parameters\ValidCommunities 레지스트리값>> %RES_LAST_FILE% 2>&1
 (reg query HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.양호 : 1.1에서 SNMP 서비스 미사용 중이거나, 1.2에서 SNMP Community String 초기 값[Public, Private]이 아니거나, 유추하기 쉬운 문자열[기관명, 기기명 등]로 설정되어 있지 않고, 암호의 복잡도를 만족 할 경우    >> %RES_LAST_FILE% 2>&1
echo.취약 :                                                  >> %RES_LAST_FILE% 2>&1
echo.     1.1에서 SNMP 서비스 사용 중이거나, 1.2에서 SNMP Community String 초기 값[Public, Private]이거나, 유추하기 쉬운 문자열[기관명, 기기명 등]로 설정되어 있고, 암호의 복잡도를 만족하지 않을 경우              >> %RES_LAST_FILE% 2>&1
echo.     ※ [복잡도]숫자+문자+특수문자 중 2종류 이상으로 조합 시 10자 이상, 3종류 이상으로 조합 시 8자 이상                            >> %RES_LAST_FILE% 2>&1
echo.참고 : SRV-001,002 함께 진단, 1 - 없음, 2 - 알림, 4 - 읽기 전용, 8 - 읽기, 쓰기, 16 - 읽기, 만들기>>%RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-003 SNMP 접근 통제 미설정]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-003] OK
echo.##### SRV003 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#SNMP\Parameters\PermittedManager 레지스트리값	>> %RES_LAST_FILE% 2>&1
 (reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" ||echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 등록된 특정 호스트 항목의 유무 >> %RES_LAST_FILE% 2>&1
echo.취약 : 출력이 존재하지 않을 경우>> %RES_LAST_FILE% 2>&1
echo.양호 : 특정 호스트 존재하는 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-004 불필요한 SMTP 서비스 실행]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-004] OK
echo.##### SRV004 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I smtp|| echo.양호. SMTP 서비스 미구동) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.[ # 1.2 SMTP 포트 확인 # ]        >> %RES_LAST_FILE% 2>&1
	(netstat -na | find ":25" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 불필요한 "SMTP Service" 사용 유무>> %RES_LAST_FILE% 2>&1
echo.취약 : 인터뷰 점검(필요치 않은 서비스인데 구동 중일 경우 취약)>> %RES_LAST_FILE% 2>&1
echo.양호 : SMTP 서비스 비활성화>> %RES_LAST_FILE% 2>&1
echo.참고 : SMTP 서비스가 실행 중일 경우 인터뷰를 통해 필요한 서비스인지 점검 필요 >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-013 Anonymous 계정의 FTP 서비스 접속 제한 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-013] OK
echo.##### SRV013 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. #metabase.xml 패일 내용 확인  >> %RES_LAST_FILE% 2>&1
	(TYPE %systemroot%\system32\inetsrv\MetaBase.xml | findstr /C:"AllowAnonymous" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. #applicationHost.config 파일 내용 확인  >> %RES_LAST_FILE% 2>&1
	(TYPE %systemroot%\system32\inetsrv\config\applicationHost.config | findstr /C:"anonymousAuthentication enabled" || echo.파일 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1

echo.>> %RES_LAST_FILE% 2>&1
echo.인터넷 정보 서비스(IIS) 관리> FTP 사이트> 속성> [보안 계정] 탭>> %RES_LAST_FILE% 2>&1
echo.“익명 연결 허용” 확인. >> %RES_LAST_FILE% 2>&1
echo.IIS 7 이상 버전에서는 FTP 사이트를 별도로 생성하지 않고 기존 웹 사이트에 FTP 사이트를>> %RES_LAST_FILE% 2>&1
echo.바인딩 하여 사용함. (관리 도구> 인터넷 정보 서비스(IIS) 6.0 관리자에서 FTP 설정 가능)>> %RES_LAST_FILE% 2>&1
echo.취약 : FTP 서비스에 대한 AllowAnonymous 값이 1일 경우(기본 1)>> %RES_LAST_FILE% 2>&1
echo.양호 : 키 값이 0 또는 없을 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-018 불필요한 하드디스크 기본 공유 활성화]>> %RES_LAST_FILE% 2>&1
echo.[SRV-018] OK
echo.##### SRV018 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#기본 공유 여부>> %RES_LAST_FILE% 2>&1
	(net share)>> %RES_LAST_FILE% 2>&1
echo.#AutoShareServer 값 >> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /s | find /I "AutoShareServer" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 기본 공유 확인 및 AutoShareServer 값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 양호 2개 조건 하나 이상 불만족시 >> %RES_LAST_FILE% 2>&1
echo.양호 : Windows 2003 이상인 경우, 설정된 기본 공유 = 없음, AutoShareServer =0(값이 '0'으로 있어야 함)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-020 공유에 대한 접근 통제 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-020] OK
echo.##### SRV020 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	(net share /n | find /I "\") >> %RES_LAST_FILE% 2>&1
	(net share /n | find /I "\") > tmp1.ahn
echo.>> %RES_LAST_FILE% 2>&1
	FOR /F "tokens=2 delims= " %%j IN (tmp1.ahn) DO icacls %%j >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : Everyone 권한의 유무 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : Default 공유를 제외한 공유 폴더에 Everyone 권한이 있음>> %RES_LAST_FILE% 2>&1
echo.양호 : Default 공유를 제외한 공유 폴더에 Everyone 권한이 없음>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-021 FTP 서비스 접근 제어 설정 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-021] OK
echo.##### SRV021 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1

echo.점검 : 수동으로 특정 ip주소에서 ftp서버 접속가능한지 확인 >> %RES_LAST_FILE% 2>&1
echo.#FTP 서비스	>> %RES_LAST_FILE% 2>&1
 (net start | find /I "FTP" || echo. FTP 서비스 미구동) >> %RES_LAST_FILE% 2>&1
 

echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 특정 IP 주소에서만 FTP 서버에 접속하도록 접근제어 설정	>> %RES_LAST_FILE% 2>&1
echo.취약: 특정 IP 주소에서만 FTP 서버에 접속하도록 접근제어 설정을 적용하지 않은 경우	>> %RES_LAST_FILE% 2>&1
echo.※ 조치 시 마스터 속성과 모든 사이트에 적용함>> %RES_LAST_FILE% 2>&1
echo.양호: 특정 IP 주소에서만 FTP 서버에 접속하도록 접근제어 설정을 적용한 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-022 계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-022] OK
echo.##### SRV022 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# LimitBlankPasswordUse 값 확인	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" | findstr /I "LimitBlankPasswordUse" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
	secedit /export /cfg c:\test.inf
echo.# test.inf 파일 내 LimitBlankPasswordUse 값 확인	>> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | find /I "LimitBlankPasswordUse" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : LimitBlankPasswordUse 값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 0(사용안함)>>%RES_LAST_FILE% 2>&1
echo.양호 : 1(사용)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-023 원격 터미널 서비스의 암호화 수준 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-023] OK
echo.##### SRV023 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#MinEncryptionLevel 값 확인>> %RES_LAST_FILE% 2>&1
 (reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | findstr /I "MinEncryptionLevel" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : MinEncryptionLevel 값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 1(낮음)>> %RES_LAST_FILE% 2>&1
echo.양호 : 2(클라이언트 호환 가능), 3(높음), 4(FIPS 규격)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-024 취약한 Telnet 인증 방식 사용]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-024] OK
echo.##### SRV024 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#Telnet 서비스 구동여부 ([ SRV-158 불필요한 TELNET 서비스 구동 여부 ] 항목 진단 가능 : 미구동시 양호)>> %RES_LAST_FILE% 2>&1
	(net start | find /I "Telnet Service" || echo. Telnet Service 미 구동중) >> %RES_LAST_FILE% 2>&1
echo.# 인증 매커니즘 확인 #>> %RES_LAST_FILE% 2>&1
	tlntadmn config >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : Telnet 사용 여부 및 인증 방식 확인>> %RES_LAST_FILE% 2>&1
echo.취약 : Telnet 서비스가 실행 중이 아니거나 인증 방법 중 NTLM만 허용할 경우>> %RES_LAST_FILE% 2>&1
echo.양호 : Telnet 서비스가 실행되고 있으며 인증 방법 중 password 방식을 지원할 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-027 서비스 접근 IP 및 포트 제한 미비] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-027] OK
echo.##### SRV027 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#방화벽 상태 확인(작동모드, operational 필터링)>> %RES_LAST_FILE% 2>&1
   (netsh firewall show state | findstr /I "작동") >> %RES_LAST_FILE% 2>&1
   (netsh firewall show state | findstr /I "Operational") 	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : 방화벽의 상태를 확인하는 netsh firewall show state 명령에서 '작동 모드' 값을 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : '작동 모드=사용 안 함' (Operational mode = Disable)	>> %RES_LAST_FILE% 2>&1
echo.양호 : '작동 모드=사용' (Operational mode = Enable)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-028 원격 터미널 접속 타임아웃 미설정]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-028] OK
echo.##### SRV028 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#MaxIdleTime 값 확인>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Terminal Server\WinStations\RDP-Tcp" /v "MaxIdleTime" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#MaxIdleTime 값 확인 (Windows 2012 이상)>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "MaxIdleTime" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : MaxIdleTime 값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 0(설정안됨)>> %RES_LAST_FILE% 2>&1
echo.양호 : 0 이외의 값 (설정됨)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-029 SMB 세션 중단 관리 설정 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-029] OK
echo.##### SRV029 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#idle 필터링>> %RES_LAST_FILE% 2>&1
	(net config server /n | find /I "Idle")>> %RES_LAST_FILE% 2>&1
	(net config server /n | find /I "유휴")>> %RES_LAST_FILE% 2>&1
echo.#autodisconnect값, enableforcedlogoff값 확인>> %RES_LAST_FILE% 2>&1
	(reg query HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters | findstr "autodisconnect enableforcedlogoff" || echo.값 없음) >>%RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : autodisconnect, enableforcedlogoff 값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 양호 기준 1개 이상 미흡시 >> %RES_LAST_FILE% 2>&1
echo.양호 : autodisconnect = 0xf=15=15분 이하, enableforcedlogoff = 1일 경우 모두 충족 시 >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-031 계정 목록 및 네트워크 공유 이름 노출]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-031] OK
echo.##### SRV031 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#restrictanonymous값, restrictanonymoussam값 확인	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" | findstr /I "restrictanonymous restrictanonymoussam")>> %RES_LAST_FILE% 2>&1
	rem secedit /export /cfg c:\test.inf
echo.#test.inf 파일 내 restrictanonymous값, restrictanonymoussam 값 확인	>> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | findstr "RestrictAnonymous RestrictAnonymousSAM" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : restrictanonymous, restrictanonymoussam 값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 양호 조건 1개 이상 미충족시 >> %RES_LAST_FILE% 2>&1
echo.양호 : restrictanonymous = 1 (사용) 및 restrictanonymoussam = 1 (사용)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1




echo.[SRV-034 불필요한 서비스 활성화]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-034] OK
echo.##### SRV034 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#1. NetBIOS 구동 점검 확인	>> %RES_LAST_FILE% 2>&1
	 (nbtstat -n) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#2. Alerter , ClipBook , Messenger , Simple TCP/IP Services 서비스 목록 확인	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I "Alerter" || echo.Alerter 서비스 미구동) >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I "ClipBook"|| echo.ClipBook 서비스 미구동) >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I "Messenger" || echo.Messenger 서비스 미구동) >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"Simple TCP/IP Services" || echo.Simple TCP/IP Services 서비스 미구동)>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
 net start>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#3. IIS WebDAV 비활성화	>> %RES_LAST_FILE% 2>&1
echo.[# 1. IIS service : service process check #]   >> %RES_LAST_FILE% 2>&1
  (sc qc apphostsvc | sc qc IISADMIN | find "START_TYPE" ||echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.[# 2. DisableWebDAV value check #]   >> %RES_LAST_FILE% 2>&1
  (reg query "HKLM\SYSTEM\CurrentControlSet\services\W3SVC\Parameters" | find /I "DisableWebDAV"||echo.값 없음)>> %RES_LAST_FILE% 2>&1
echo.[# 3. WEBDAV value check #]    >> %RES_LAST_FILE% 2>&1
  (more %systemroot%\System32\inetsrv\MetaBase.xml  |  find /I "WEBDAV"||echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.[# 4. authoring enabled value check #]    >> %RES_LAST_FILE% 2>&1
 ( more %systemroot%\System32\inetsrv\config\applicationHost.config |  find /I "authoring enabled="||echo.값 없음) >> %RES_LAST_FILE% 2>&1  
echo.>> %RES_LAST_FILE% 2>&1 
echo.>> %RES_LAST_FILE% 2>&1
echo.#4. RDS(Remote Data Services)제거	>> %RES_LAST_FILE% 2>&1
echo.[# '/MSADC' 디렉터리 존재 확인#] 	>> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | findstr /I "MSADC" || echo. 미존재) >> %RES_LAST_FILE% 2>&1
echo.   >> %RES_LAST_FILE% 2>&1
echo.[# 'RDSServer.DataFactory' 레지스트리 키 존재 확인#]>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" | find /I "RDSServer.DataFactory" || echo. 미존재) >> %RES_LAST_FILE% 2>&1
echo.   >> %RES_LAST_FILE% 2>&1 
echo.[# 'AdvancedDataFactory' 레지스트리 키 존재 확인#] >> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" | find /I "AdvancedDataFactory" || echo. 미존재) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.[# 'VbBusObj.VbBusObjCls' 레지스트리 키 존재 확인#]>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" | find /I "VbBusObj.VbBusObjCls" || echo. 미존재) >> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1

echo.점검 : #1. NetBIOS 구동 점검 확인															>> %RES_LAST_FILE% 2>&1
echo.		사용중인 NetBIOS 목록 확인 출력값 없을 경우 양호함											>> %RES_LAST_FILE% 2>&1
echo.     #2. Alerter , ClipBook , Messenger , Simple TCP/IP Services 서비스 목록 확인			>> %RES_LAST_FILE% 2>&1
echo.     	출력값이 없을경우 양호함 																>> %RES_LAST_FILE% 2>&1
echo.     #3. IIS WebDAV 비활성화 확인			>> %RES_LAST_FILE% 2>&1
echo.  		양호 :         >> %RES_LAST_FILE% 2>&1 
echo.   		1. IIS 서비스가 미구동중일 경우 >> %RES_LAST_FILE% 2>&1
echo.   		2. IIS 서비스가 구동중이지만 DisableWebDAV 값이 1로 설정되어 있을 경우 (IIS 6 미만)  >> %RES_LAST_FILE% 2>&1
echo.   		3. IIS 서비스가 구동중이지만 C:\WINDOWS\system32 앞의 값이 0로 설정되어 있을  경우 (IIS 6 해당)  >> %RES_LAST_FILE% 2>&1
echo.   		4. IIS 서비스가 구동중이지만 authoring enabled 값이 false로 설정되어 있을  경우 (IIS 7 이상 해당)  >> %RES_LAST_FILE% 2>&1
echo. 	 	취약 :      >> %RES_LAST_FILE% 2>&1
echo.   		1. IIS 서비스가 구동중이며 >> %RES_LAST_FILE% 2>&1
echo.   		2. DisableWebDAV 값이 0로 설정되어 있을 경우 (IIS 6 미만)  >> %RES_LAST_FILE% 2>&1
echo.   		3. C:\WINDOWS\system32 앞의 값이 1로 설정되어 있을  경우 (IIS 6 해당)  >> %RES_LAST_FILE% 2>&1
echo.   		4. authoring enabled 값이 true로 설정되어 있을 경우 (IIS 7 이상 해당)  >> %RES_LAST_FILE% 2>&1
echo.     #4. RDS 제거 확인			>> %RES_LAST_FILE% 2>&1
echo.		다음 중 한 가지라도 해당되는 경우 양호   >> %RES_LAST_FILE% 2>&1
echo. 			1. IIS 를 사용하지 않는 경우>> %RES_LAST_FILE% 2>&1
echo. 			2. Windows 2000 일 경우 서비스팩 4가 설치되어 있는 경우(2003 양호)   	>> %RES_LAST_FILE% 2>&1
echo. 			3. 디폴트 웹사이트에 MSADC 가상 디렉터리가 존재하지 않을 경우  >> %RES_LAST_FILE% 2>&1
echo. 			4. 해당 레지스트리 값이 존재하지 않을 경우   	>> %RES_LAST_FILE% 2>&1
echo. 			5. 2008버전 이상 양호함   	>> %RES_LAST_FILE% 2>&1
echo.취약 : 1개 이상 사용 >> %RES_LAST_FILE% 2>&1
echo.양호 : 모두 없음>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-037 취약한 FTP 서비스 실행]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-037] OK
echo.##### SRV037 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#FTP 서비스	>> %RES_LAST_FILE% 2>&1
 (net start | find /I "FTP" || echo. FTP 서비스 미구동) >> %RES_LAST_FILE% 2>&1
echo.[# 1.1 MSFTPSVC : service process check #]   >> %RES_LAST_FILE% 2>&1
  sc query MSFTPSVC >> %RES_LAST_FILE% 2>&1
echo.[# 1.2 FTPSVC : service process check #]   >> %RES_LAST_FILE% 2>&1
  sc query FTPSVC >> %RES_LAST_FILE% 2>&1
 echo.[# 1.3 21 port check #]   >> %RES_LAST_FILE% 2>&1
  (netstat -na | find "21" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : FTP 서비스 관련 항목의 유무 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 불필요한 FTP 관련 서비스 있음>> %RES_LAST_FILE% 2>&1
echo.양호 : FTP 관련 서비스 없음>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-040 웹 서비스 디렉터리 리스팅 방지 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-040] OK
echo.##### SRV040 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	 %systemroot%\system32\inetsrv\appcmd.exe list config > TMP_IIS_CONF.log
	type TMP_IIS_CONF.log | find /i "directorybrowse"			>> %RES_LAST_FILE% 2>&1
	type TMP_IIS_CONF.log | find /i "directorybrowse enabled" | find /i "false" || echo. 값 없음>> %RES_LAST_FILE% 2>&1
echo.                                                                                                             																>> %RES_LAST_FILE% 2>&1
echo.점검 : “디렉터리 검색(directoryBrowse enabled)” 이 체크되어 있지 않은 경우(false) 양호	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-041 웹 서비스의 CGI 스크립트 관리 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-041] OK
echo.##### SRV041 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
	icacls C:\inetpub\scripts>> SRV-041-cgi-acl.ahn
	icacls C:\inetpub\cgi-bin>> SRV-041-cgi-acl.ahn
	TYPE SRV-041-cgi-acl.ahn>> %RES_LAST_FILE% 2>&1
echo.#script cgi-bin >> %RES_LAST_FILE% 2>&1
	TYPE SRV-041-cgi-acl.ahn | findstr /i "scripts cgi-bin"> NUL
	IF ERRORLEVEL 1 echo ⇒ 디렉터리가 존재하지 않습니다.>> %RES_LAST_FILE% 2>&1
 echo.>> %RES_LAST_FILE% 2>&1
 echo.# everyone 필터링>> %RES_LAST_FILE% 2>&1
	TYPE SRV-041-cgi-acl.ahn | findstr /I "everyone" | Find /V ")R"> nul
	IF ERRORLEVEL 1 ECHO [결과] 양호 - CGI 실행 제한>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 ECHO [결과] 취약 - CGI 실행 제한>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : Everyone의 권한 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 모든권한/수정권한/쓰기권한 중 한개 이상 존재>> %RES_LAST_FILE% 2>&1
echo.양호 : 해당 파일이 없거나 모든권한/수정권한/쓰기권한 모두 없음>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-042 웹 서비스 상위 디렉터리 접근 제한 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-042] OK
echo.##### SRV042 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
echo.#applicationhost.config 파일	>> %RES_LAST_FILE% 2>&1
echo.[applicationHost.config]------------------------------->>[RESULT_ahnlab]_CONFIG.config.ahn 2>&1
	TYPE %systemroot%\System32\inetsrv\config\applicationHost.config>> [RESULT_ahnlab]_CONFIG.config.ahn 2>&1
echo.#enableParentPaths	>> %RES_LAST_FILE% 2>&1
	TYPE [RESULT_ahnlab]_CONFIG.config.ahn | find /I "enableParentPaths">>%RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : enableParentPaths 값>> %RES_LAST_FILE% 2>&1
echo.취약 : True (허용)>> %RES_LAST_FILE% 2>&1
echo.양호 : False (허용 안함), 값 없음>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-043 웹 서비스 경로 내 불필요한 파일 존재]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-043] OK
echo.##### SRV043 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo. 참고 : IIS 7.0 이상 버전 해당 사항 없음>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots">> SRV-043-LOG-1.ahn
	TYPE SRV-043-LOG-1.ahn | findstr /I "samples help">> %RES_LAST_FILE% 2>&1
	TYPE SRV-043-LOG-1.ahn | findstr /I "samples help"> NUL
	IF ERRORLEVEL 1 ECHO ⇒ 불필요한 파일이 존재하지 않음.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : IIS 7.0 이상 버전을 사용하고 있으면 양호함 IISSamples, IISHelp 존재 여부 확인>> %RES_LAST_FILE% 2>&1
echo.취약 : 한 파일 이상 존재시 >> %RES_LAST_FILE% 2>&1
echo.양호 : 두 파일 모두 존재하지 않을 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-044 웹 서비스 파일 업로드 및 다운로드 용량 제한 미설정]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-044] OK
echo.##### SRV044 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.# IIS 5.0/6.0>> %RES_LAST_FILE% 2>&1
	TYPE MetaBase.xml | findstr /I "AspMaxRequestEntityAllowed AspBufferingLimit">> %RES_LAST_FILE% 2>&1
	echo.>> %RES_LAST_FILE% 2>&1
echo.# IIS 7.0>> %RES_LAST_FILE% 2>&1
echo.[administration.config]------------------------------->>[RESULT_ahnlab]_CONFIG.config.ahn 2>&1
	TYPE %systemroot%\System32\inetsrv\config\administration.config>> [RESULT_ahnlab]_CONFIG.config.ahn 2>&1
echo.[applicationHost.config]------------------------------->>[RESULT_ahnlab]_CONFIG.config.ahn 2>&1
	TYPE %systemroot%\System32\inetsrv\config\applicationHost.config>> [RESULT_ahnlab]_CONFIG.config.ahn 2>&1
echo.[redirection.config]------------------------------->>[RESULT_ahnlab]_CONFIG.config.ahn 2>&1
	TYPE %systemroot%\System32\inetsrv\config\redirection.config>> [RESULT_ahnlab]_CONFIG.config.ahn 2>&1
	TYPE [RESULT_ahnlab]_CONFIG.config.ahn | findstr /I "bufferingLimit maxRequestEntityAllowed">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : IIS 7.0 이상 버전은 Default로 제한이 설정되어 있으므로 양호함 >> %RES_LAST_FILE% 2>&1
echo.점검 : AspMaxRequestEntityAllowed, AspBufferingLimit, bufferingLimit maxRequestEntityAllowed 값 확인>> %RES_LAST_FILE% 2>&1
echo.취약 : 설정되어 있지 않을 경우 >> %RES_LAST_FILE% 2>&1
echo.양호 : 설정되어 있을 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-045 웹 서비스 프로세스 권한 제한 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-045] OK
echo.##### SRV045 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.[# 1.1. IIS 5.0, 6.0#]                                                      >> %RES_LAST_FILE% 2>&1
type %systemroot%\system32\inetsrv\MetaBase.xml | findstr ""AppPoolIdentityType"" || echo.값 없음>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.[# 1.2. IIS 7.0 이상#]                                                             >> %RES_LAST_FILE% 2>&1
TYPE %systemroot%\System32\inetsrv\config\applicationHost.config | findstr ""identityType""|| echo.값 없음>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 참고: IIS 5.0/6.0 해당사항 없음(N/A)>> %RES_LAST_FILE% 2>&1
echo. 참고 : windows2008 r2 (iis 7.5) 이상은 기본적으로 applicationpoolidentitiy 권한이 적용되어 양호>> %RES_LAST_FILE% 2>&1
echo.NetworkService(권고), LocalService일 경우 양호>> %RES_LAST_FILE% 2>&1
echo.사용자 지정 계정 설정 시 관리자 계정이 아닌 별도 계정일 경우 양호">> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-046 웹 서비스 경로 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-046] OK
echo.##### SRV046 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots")	>> SRV-046_TMP.ahn
	TYPE SRV-046_TMP.ahn | findstr /I "admin 관리자" >> %RES_LAST_FILE% 2>&1
	TYPE SRV-046_TMP.ahn | findstr /I "admin 관리자"> NUL
	IF ERRORLEVEL 1 ECHO ⇒ 가상 디렉터리가 존재하지 않음.	 >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	TYPE SRV-046_TMP.ahn | findstr /I "admin  관리자"> NUL
	IF ERRORLEVEL 1 echo [결과] 양호>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [결과] 취약>> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1
echo.점검 : IIS 6.0 이상 버전은 디폴트 가상디렉터리가 존재하지 않으므로 양호함 IISAdmin, IISAdminpwd 가상 디렉터리 존재 여부 >> %RES_LAST_FILE% 2>&1
echo.취약 : 가상 디렉터리 존재>> %RES_LAST_FILE% 2>&1
echo.양호 : 가상 디렉터리 없음>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1




echo.[SRV-047 웹 서비스 경로 내 불필요한 링크 파일 존재]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-047] OK
echo.##### SRV047 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.# IIS sample file check #	>> %RES_LAST_FILE% 2>&1
	(dir c:\inetpub | findstr /i "iissample" || echo."불필요 샘플파일 없음")    >> %RES_LAST_FILE% 2>&1
echo.# IIS sample helpfile check #	>> %RES_LAST_FILE% 2>&1
	(dir c:\windows\help | findstr /i "iishelp" || echo."불필요 help파일 없음")   >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 해당 사항 없음(N/A)	>> %RES_LAST_FILE% 2>&1
echo.취약 : 심볼릭 링크, aliases, 바로가기 등의 파일이 존재하는 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-048 불필요한 웹 서비스 실행]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-048] OK
echo.##### SRV048 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.# IIS ADMIN SERVICE check	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"IIS Admin Service" || echo."IIS Admin Service 미구동, 관련 항목 모두 양호(또는 N/A)")>> %RES_LAST_FILE% 2>&1
echo.[# World Wide Web Publishing Service check]	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"World Wide Web Publishing Service" || echo. World Wide Web Publishing Service 서비스 미구동) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#2 WebtoB 서비스 구동 확인>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I webtob||echo.WebtoB 서비스 미 구동) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : IIS Admin Service, World Wide Web Publishing Service WebtoB항목의 유무 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 불필요하게 구동시 취약>> %RES_LAST_FILE% 2>&1
echo.양호 : 항목 없음(사용안함), 필요에 의한 구동시 양호>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1





echo.[SRV-055 웹 서비스 설정 파일 노출]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-055] OK
echo.##### SRV055 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.                       >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.[1.1 처리기 매핑 리스트에서 확인]	>> %RES_LAST_FILE% 2>&1	
	cscript .\bin\adsutil.vbs get W3SVC/scriptmaps >> %RES_LAST_FILE% 2>&1

echo. 양호 : 처리기 매핑 리스트에 .asa 또는 .asax가 존재하지 않는 경우 또는 매핑 리스트에 존재하지만 요청 필터링의 allowed 값이 false로 설정된 경우 >> %RES_LAST_FILE% 2>&1
echo. 취약 : 처리기 매핑 리스트에 .asa 또는 .asax가 존재하고, 요청 필터링의 allowed 값이 true로 설정된 경우  >> %RES_LAST_FILE% 2>&1
echo.                       >> %RES_LAST_FILE% 2>&1
echo.#참고 : IIS 7.0 이상 버전에서는 Default로 asa/asax 파일 필터링이 설정되어 있으므로 양호      >> %RES_LAST_FILE% 2>&1
echo.                       >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1





echo.[SRV-057 웹 서비스 경로 내 파일의 접근 통제 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-057] OK
echo.##### SRV057 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
	FOR /F tokens^=2^delims^="" %%a IN ('%systemroot%\system32\inetsrv\appcmd list site ^| find "http"') DO (
		%systemroot%\system32\inetsrv\appcmd list vdir "%%a/" >> SRV-057_TMP.ahn
	)
	FOR /F "tokens=2 delims=(" %%a IN (SRV-057_TMP.ahn) DO (
set var1=%%a
set var2=!var1:~13,-1!
echo !var2! >> SRV-057_TMP2.ahn
	)
	FOR /F "tokens=*" %%a IN ('type SRV-057_TMP2.ahn ^| findstr /r /v "^.$"') DO .\bin\accesschk /accepteula -sq everyone "%%a">> SRV-057_TMP3.ahn
	for /f "delims=" %%a in (SRV-057_TMP3.ahn) do icacls %%a >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 불필요한 Everyone 권한의 유무>> %RES_LAST_FILE% 2>&1
echo.취약 : 불필요한 everyone 권한 있음>> %RES_LAST_FILE% 2>&1
echo.양호 : 불필요한 everyone 권한 없음>> %RES_LAST_FILE% 2>&1
echo.홈 디렉터리 하위 파일들에 대해 Everyone 권한이 존재하지 않을 경우(정적컨텐트 파일은 Read 권한만) 양호>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-058 웹 서비스의 불필요한 스크립트 매핑 존재]>> %RES_LAST_FILE% 2>&1
echo.[SRV-058] OK
echo.##### SRV058 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
	C:\Windows\System32\inetsrv\appcmd list site >> sitelist.ahn

	for /f tokens^=2^ delims^=^" %%i IN (.\sitelist.ahn)do echo %%i>> sitelist2.ahn

	echo -----------처리기 매핑(Handler Mappings)----------------                                		>> list.ahn
	echo. 사이트 처리기 매핑								>> list.ahn
	echo. [결과]										>> list.ahn
	C:\Windows\System32\inetsrv\appcmd list config /section:handlers 					 			>> list.ahn
	echo. 													>> list.ahn

	FOR /f "delims=" %%i IN (.\sitelist2.ahn) DO (
	echo. %%i 사이트 처리기 매핑 >> list.ahn
	echo. [결과] >>list.ahn
	C:\Windows\System32\inetsrv\appcmd list config"%%i" /section:handlers 							>> list.ahn
	ehco. >> list.ahn)

	echo -----------요청 필터링(request Filtering)----------------                                		>> list.ahn
	echo. 사이트 요청 필터링										>> list.ahn
	echo. [결과]												>> list.ahn
	C:\Windows\System32\inetsrv\appcmd list config /section:requestFiltering 						>> list.ahn
	echo.													>> list.ahn

	FOR /f "delims=" %%i IN (.\sitelist2.ahn) DO (
	echo. %%i 사이트 요청 필터링 >> list.ahn
	echo. [결과]>>list.ahn
	C:\Windows\System32\inetsrv\appcmd list config "%%i" /section:requestFiltering 					>> list.ahn
	echo. >>list.ahn)

	TYPE list.ahn >> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1
echo.점검 : 취약한 매핑 여부 >> %RES_LAST_FILE% 2>&1
echo.취약 : 처리기 매핑 리스트에 취약한 매핑이 존재하고, 요청 필터링의 allowed 값이 true로 설정된 경우 >> %RES_LAST_FILE% 2>&1
echo.양호 : 처리기 매핑 리스트에 취약한 매핑이 존재하지 않는 경우 또는 매핑 리스트에 존재하지만 요청 필터링의 allowed 값이 false로 설정된 경우 >> %RES_LAST_FILE% 2>&1
echo.참고 : .idc, .printer, asp, stm, stml, shtml, ida, idq, htw 등의 취약한 매핑이 존재하지 않을 경우 양호 >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-059 웹 서비스 서버 명령 실행 기능 제한 설정 미흡]>> %RES_LAST_FILE% 2>&1
echo.[SRV-059] OK
echo.##### SRV059 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최상단의 iis구동여부 확인(구동 중일경우 버전 표시)	>> %RES_LAST_FILE% 2>&1
echo. 스크립트 최하단의 iis구동여부 확인(구동 중일경우 admin, worldwide 표시(오류가능성으로 최하단에 표시)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" | findstr /I "SSIEnableCmdDirective")  >> SRV-059_TMP.ahn
	TYPE SRV-059_TMP.ahn  >> %RES_LAST_FILE% 2>&1
	TYPE SRV-059_TMP.ahn | findstr /I "SSIEnableCmdDirective" > NUL
	IF ERRORLEVEL 1 echo ⇒ SSIEnableCmdDirective 값이 없음	 >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
	TYPE SRV-059_TMP.ahn | findstr /I "SSIEnableCmdDirective" > NUL
	IF ERRORLEVEL 1 echo [결과] 양호 - Exec 명령어 쉘 호출 진단	   >> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [결과] 취약 - Exec 명령어 쉘 호출 진단    	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. 참고 : windows2003(iis6.0)이상 버전 해당 사항 없음>> %RES_LAST_FILE% 2>&1
echo.점검 : SSIEnableCmdDirective 값 확인   	>> %RES_LAST_FILE% 2>&1
echo.취약 : 해당 레지스트리 값이 1 인 경우   >> %RES_LAST_FILE% 2>&1
echo.양호 : 해당 레지스트리 값이 0 인 경우, IIS 5.0 버전에서 해당 레지스트리 값이 존재하지 않을 경우, IIS 6.0 이상 양호  	>> %RES_LAST_FILE% 2>&1
echo.참고 :  SRV-059_TMP.ahn 확인	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-060 웹 서비스 기본 계정(아이디 또는 비밀번호) 미변경] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-060] OK
echo.##### SRV060 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
	dir /s /b | find /i "tomcat-users.xml" > test.ahn
	type test.ahn >> %RES_LAST_FILE% 2>&1
	set /p var=< test.ahn
	type %var% | find /i "username="|| echo.값 없음 >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : 기본 계정을 사용하는지 확인 	>> %RES_LAST_FILE% 2>&1
echo.취약 : 결과 값에 기본 계정인 'tomcat', 'both','role1' 이 하나라도 존재	>> %RES_LAST_FILE% 2>&1
echo.양호 : 결과 값에 기본 계정인 'tomcat', 'both','role1' 이 전부 존재하지 않는 경우, 결과 값이 없는 경우(Apache Tomcat 미사용)	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.참고 : 기본 계정에 비밀번호를 변경해서 사용하는 경우에도 취약으로 처리함>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-063 DNS Recursive Query 설정 미흡] >> %RES_LAST_FILE% 2>&1
echo.[SRV-063] OK
echo.##### SRV063 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
	net start | find /I "DNS Server"
	IF ERRORLEVEL 1 ECHO ⇒ DNS 서버가 존재하지 않음(=양호)	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 dnscmd . /Info | findstr /I norecursion>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.점검 : DNS 설정 파일의 NoRecursion 사용 유무  	>> %RES_LAST_FILE% 2>&1
echo.취약 : NoRecursion 값이 0(재귀 사용)  	>> %RES_LAST_FILE% 2>&1
echo.양호 : NoRecursion 값이 1(재귀 미사용) 또는 DNS 서버를 사용하지 않는 경우 >> %RES_LAST_FILE% 2>&1
echo.참고 : DNS Recursive Query가 사용 중인 경우 인터뷰를 통해 필요 여부를 판단 후 평가>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-066 DNS Zone Transfer 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-066] OK
echo.##### SRV066 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
	net start | find /I "DNS Server"
	IF ERRORLEVEL 1 ECHO ⇒ DNS 서버가 존재하지 않음(=양호)	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1	reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find /I "SecureSecondaries">> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : SecureSecondaries 값 확인  	>> %RES_LAST_FILE% 2>&1
echo.취약 : SecureSecondaries 값이 0    	>> %RES_LAST_FILE% 2>&1
echo.양호 : SecureSecondaries 값이 1,3, DNS 서버를 사용하지 않는 경우    	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-069 비밀번호 관리정책 설정 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-069] OK
echo.##### SRV069 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. 1. 패스워드 설정 보기 (최소 암호 사용 기간 등)   >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "MinimumPasswordAge" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "MaximumPasswordAge" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "MinimumPasswordLength" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "PasswordComplexity" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "PasswordHistorySize" >> %RES_LAST_FILE% 2>&1
echo.         >> %RES_LAST_FILE% 2>&1
echo.양호 = 패스워드 관련 필드 대부분이 설정되어 있는 경우   >> %RES_LAST_FILE% 2>&1
echo.  ex) 최소 암호 사용 기간이 0보다 큰 값으로 설정되어 있는 경우    >> %RES_LAST_FILE% 2>&1
echo. 취약 = 패스워드 관련 필드 대부분이 미설정되어 있는 경우   >> %RES_LAST_FILE% 2>&1
echo.  ex) 최소 암호 사용 기간이 0으로 설정되어 있는 경우   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.참고 : - 비밀번호 관리 정책 기준 - 영문 숫자 특수문자 2개 조합 시 10자리 이상, 3개 조합 시 8자리 이상, 패스워드 변경 기간 90일 이하 만족 시 양호  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-070 취약한 패스워드 저장 방식 사용]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-070] OK
echo.##### SRV070 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# 패스워드 암호화 저장 확인(ClearTextPassword) #>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "ClearTextPassword" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검: ClearTextPassword 값	>> %RES_LAST_FILE% 2>&1
echo.취약 : 0이외의 값	>> %RES_LAST_FILE% 2>&1
echo.양호 : 0 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-072 기본 관리자 계정명(Administrator) 존재]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-072] OK
echo.##### SRV072 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# administrator의 계정 활성 여부 확인(net user - filter : account active, 활성) #>> %RES_LAST_FILE% 2>&1
	net user administrator | find "Account active"	>> %RES_LAST_FILE% 2>&1
	net user administrator | find "활성"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# administrator의 계정 활성 여부 확인(securitypolicy : EnableAdminAccount, NewAdministratorName) #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "EnableAdminAccount">> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "NewAdministratorName">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 점검: Administrator 계정 확인	>> %RES_LAST_FILE% 2>&1
echo. 취약: Administrator 계정이 존재하며 활성화(0이 아닌 값) 되어 있을 경우>> %RES_LAST_FILE% 2>&1
echo. 양호: Administrator 계정이 존재하지 않거나, 비활성화된 경우	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-073 관리자 그룹에 불필요한 사용자 존재]>> %RES_LAST_FILE% 2>&1
echo.[SRV-073] OK
echo.##### SRV073 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# local Administrators Group (net localgroup Administrators) #>> %RES_LAST_FILE% 2>&1
	net localgroup administrators	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. 점검: 인터뷰를 통해 Administrators 그룹의 계정 중 불필요한 계정 확인	>> %RES_LAST_FILE% 2>&1
echo. 취약: 관리자 계정 외에 다른 불필요한 계정이 존재할 경우>> %RES_LAST_FILE% 2>&1
echo. 양호: 관리자 계정만 존재할 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-074 불필요하거나 관리되지 않는 계정 존재]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-074] OK
echo.##### SRV074 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# 패스워드 최대사용기간 확인 #>> %RES_LAST_FILE% 2>&1
	net accounts | find /I "Maximum password age"	>> %RES_LAST_FILE% 2>&1
	net accounts | find /I "최대 암호 사용 기간"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# Administrator 계정의 암호 만료 설정 확인 #	>> %RES_LAST_FILE% 2>&1
	net user administrator | find "Password expires">> %RES_LAST_FILE% 2>&1
	net user administrator | find "암호 만료 날짜">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 암호 사용 기간 제한 없는(Password expires) 계정 현황 #>> %RES_LAST_FILE% 2>&1
	for /f "usebackq skip=4 tokens=*" %%a in (`net user ^| find /v "The command completed successfully"`) do (
    for %%B in (%%a) do (
   net user %%B | findstr "^Password.expires.*Never" >nul && echo %%B 	>> %RES_LAST_FILE% 2>&1
    )
)
echo.  	>> %RES_LAST_FILE% 2>&1
echo. 점검: 회사의 패스워드 정책 확인>> %RES_LAST_FILE% 2>&1
echo. 취약: 패스워드 최대사용기간이 설정되지 않거나 0이거나 unlimited인 경우>> %RES_LAST_FILE% 2>&1
echo. 양호: 패스워드 최대사용기간이 설정된 경우>> %RES_LAST_FILE% 2>&1
echo.  	>> %RES_LAST_FILE% 2>&1
echo. 참고: 기준이 없을 경우 90일로 설정(분기별 1회)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-075 유추 가능한 계정 비밀번호 존재]>> %RES_LAST_FILE% 2>&1
echo.[SRV-075] OK
echo.##### SRV075 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# PasswordComplexity	>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "PasswordComplexity" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. 점검: 패스워드 복잡성 확인 	>> %RES_LAST_FILE% 2>&1
echo. 양호: complex 일 경우 = 양호 또는 PasswordComplexity 1일 경우 양호 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-078 불필요한 Guest 계정 활성화]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-078] OK
echo.##### SRV078 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# 현재 컴퓨터의 Guest 계정 활성 여부(net user) #>> %RES_LAST_FILE% 2>&1
	net user guest | findstr /I "Account active"	>> %RES_LAST_FILE% 2>&1
	net user guest | findstr /I "활성 계정"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 현재 컴퓨터의 Guest 계정 활성 여부(securitypolicy) #>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "EnableGuestAccount" || echo. 값 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. 점검: Guest 계정의 활성화 유무>> %RES_LAST_FILE% 2>&1
echo. 취약: Guest 계정이 활성화 되어 있을 경우, EnableGuestAccount 값이 1일 경우	>> %RES_LAST_FILE% 2>&1
echo. 양호: Guest 계정이 활성화 되어있지 않을 경우, EnableGuestAccount 값이 0일 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-079 익명 사용자에게 부적절한 권한(Everyone) 적용]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-079] OK
echo.##### SRV079 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# everyoneincludesanonymous	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /r /i "everyoneincludesanonymous" | findstr /v "1"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : everyoneincludesanonymous 값 확인>> %RES_LAST_FILE% 2>&1
echo.취약 : everyoneincludesanonymous 값이 1일 경우>> %RES_LAST_FILE% 2>&1
echo.양호 : everyoneincludesanonymous 값이 0일 경우>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.참고 : Everyone 그룹에 익명 보안 식별자가 포함되는지 여부, 기본 설정 값은 0	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-080 일반 사용자의 프린터 드라이버 설치 제한 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-080] OK
echo.##### SRV080 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# 프린터 드라이브 정책 확인 #	>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "AddPrinterDrivers" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.점검 : AddPrinterDrivers 값 확인>> %RES_LAST_FILE% 2>&1
echo.취약 : AddPrinterDrivers 값이 1로 설정이 안된 경우>> %RES_LAST_FILE% 2>&1
echo.양호 : AddPrinterDrivers 값이 1(활성화됨)인 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-082 시스템 주요 디렉터리 권한 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-082] OK
echo.##### SRV082 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. 1. \system32\Config 폴더(Windows 2003일경우)                         >> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\Config                   >> %RES_LAST_FILE% 2>&1
echo.#2. \system32\winevt\Logs 폴더 >> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\winevt\Logs>> %RES_LAST_FILE% 2>&1
echo. 2.1 \system32\Config\SysEvent.Evt 파일(Windows 2003일경우)           >> %RES_LAST_FILE% 2>&1
	icacls %SystemRoot%\system32\Config\SysEvent.Evt    >> %RES_LAST_FILE% 2>&1														 
echo.  >> %RES_LAST_FILE% 2>&1
echo. 3. \system32\winevt\Logs\System.evtx 파일>> %RES_LAST_FILE% 2>&1
	icacls %SystemRoot%\system32\winevt\Logs\System.evtx  >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.점검 : Everyone 권한 유무 및 Users 권한 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 양호 조건 중 1개라도 미 충족 시 취약  >> %RES_LAST_FILE% 2>&1
echo.양호 : Everyone 권한 없음, Users에 W, C, F 중 1가지도 존재하지 않을 경우 양호 >> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.참고 : W(쓰기), C(바꾸기), F(모든 권한)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-084 시스템 주요 파일 권한 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-084] OK
echo.##### SRV084 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# SAM 파일 권한 설정여부 #	 	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\config\SAM	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : SAM 파일 접근권한 설정  	>> %RES_LAST_FILE% 2>&1
echo.취약 : Administrator / System 그룹 외 다른 그룹에 권한이 설정된 경우  >> %RES_LAST_FILE% 2>&1
echo.양호 : Administrator / System 그룹만 모든 권한으로 설정된 경우  	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.참고 : W(쓰기), C(바꾸기), F(모든 권한)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-090 불필요한 원격 레지스트리 서비스 활성화]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-090] OK
echo.##### SRV090 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 원격 레지스트리 사용여부 #	>> %RES_LAST_FILE% 2>&1
	(net start | find /I "Remote Registry" || echo. Remote Registry 미 사용중) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 원격 레지스트리 사용 유무  	>> %RES_LAST_FILE% 2>&1
echo.취약 : Remote registry 사용할 경우 >> %RES_LAST_FILE% 2>&1
echo.양호 : Remote registry 사용하지 않을 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-092 사용자 홈 디렉터리 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-092] OK
echo.##### SRV092 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 사용자 홈 디렉터리 확인 #	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
	dir /b %HOMEDRIVE%\Users > tmp5.tmp
	FOR /F "tokens=1 delims=" %%j IN (tmp5.tmp) DO icacls "%HOMEDRIVE%\Users\%%j" 											>> %RES_LAST_FILE% 2>&1
	del tmp5.tmp
echo.    	>> %RES_LAST_FILE% 2>&1
echo.점검 : 홈 디렉터리 권한 확인    	   	   	   	   	   	  	>> %RES_LAST_FILE% 2>&1
echo.양호 : 홈 디렉터리에 Everyone 권한이 없을 경우(All Users, Default User 디렉터리는 제외)    	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.참고 : W(쓰기), C(바꾸기), F(모든 권한)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-097 FTP 서비스 디렉터리 접근권한 설정 미흡]>> %RES_LAST_FILE% 2>&1
echo.[SRV-097] OK
echo.##### SRV097 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
FOR /F tokens^=2^delims^="" %%a IN ('%systemroot%\system32\inetsrv\appcmd list site ^| find "ftp"') DO (
%systemroot%\system32\inetsrv\appcmd list vdir "%%a/">>ftpdirectory.ahn
)
echo.>> %RES_LAST_FILE% 2>&1  >> %RES_LAST_FILE% 2>&1
echo.# FTP 서비스 디렉토리 확인 # 	>> %RES_LAST_FILE% 2>&1
FOR /F "tokens=2 delims=(" %%a IN (ftpdirectory.ahn) do echo %%a	>>ftpdirectory1.ahn 2>&1
FOR /F "tokens=1 delims=)" %%b IN (ftpdirectory1.ahn) do (
	set result1=%%b
	set result2=!result1:~13!
	echo.!result2! >> ftpdirectory2.ahn
)
	FOR /F "tokens=1 delims=" %%j IN (ftpdirectory2.ahn) do echo %%j	>> %RES_LAST_FILE% 2>&1
	echo.  >> %RES_LAST_FILE% 2>&1
	FOR /F "tokens=1 delims=" %%j IN (ftpdirectory2.ahn) do icacls %%j	>> %RES_LAST_FILE% 2>&1
	del ftp*.ahn
echo.>> %RES_LAST_FILE% 2>&1
echo.점검: FTP 디렉터리에 Everyone 권한이 있을 경우 취약	>> %RES_LAST_FILE% 2>&1
echo.참고 : W(쓰기), C(바꾸기), F(모든 권한)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-101 불필요한 예약된 작업 존재]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-101] OK
echo.##### SRV101 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 예약된 작업 확인(schtasks)# 	>> %RES_LAST_FILE% 2>&1
	schtasks /query>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.점검 : 예약된 작업 목록 확인  >> %RES_LAST_FILE% 2>&1
echo.취약 : 불필요하거나 의심스러운 명령 또는 파일이 있을 경우>> %RES_LAST_FILE% 2>&1
echo.양호 : 불필요하거나 의심스러운 명령 또는 파일이 없을 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-103 LAN Manager 인증 수준 미흡]>> %RES_LAST_FILE% 2>&1
echo.[SRV-103] OK
echo.##### SRV103 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# LAN Manager 인증 수준 확인(HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa, LMCompatibilityLevel 값)#>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | find /I "LMCompatibilityLevel" || echo.값 없음)>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.점검 : LMCompatibilityLevel 값 확인	 	 	 	 >> %RES_LAST_FILE% 2>&1
echo.취약 : "LM" 및 "NTLM"인증을 허용하는 경우(3 이하	>> %RES_LAST_FILE% 2>&1
echo.양호 : LMCompatibilityLevel이 '3'로 설정(Send NTLM response only)된 경우) 혹은 출력 값이 없을 경우(미설정된 경우)		>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-104 보안 채널 데이터 디지털 암호화 또는 서명 기능 비활성화]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-104] OK
echo.##### SRV104 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# Digitally encrypt or sign secure channel data(always) 확인 #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | find /I "RequireSignOrSeal")>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# Digitally encrypt secure channel data(when possible) 확인 #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | find /I "SealSecureChannel")>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# Digitally sign secure channel data(when possible) 확인 #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | find /I "SignSecureChannel")>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.점검 : 3개 정책과 관련된 레지스트리 값 확인	>> %RES_LAST_FILE% 2>&1
echo.취약 : 3개 정책이 모두 '1'(사용)로 설정되지 않은 경우	>> %RES_LAST_FILE% 2>&1
echo.양호 : 3개 정책이 모두 '1'(사용)로 설정된 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-105 불필요한 시작프로그램 존재]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-105] OK
echo.##### SRV105 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# HKLM\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run 확인 #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run") 	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo.# HKCU\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run 확인 #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run") 	  	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo.# WMIC startup 확인 #	>> %RES_LAST_FILE% 2>&1
	(wmic startup list /format:list)	>> wmic2.ahn

	TYPE wmic2.ahn	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo.점검 : 시작프로그램 목록 확인    	>> %RES_LAST_FILE% 2>&1
echo.취약 : 시작프로그램 중 불필요하거나 의심스러운 서비스가 존재하는 경우    	>> %RES_LAST_FILE% 2>&1
echo.양호 : 시작프로그램 중 불필요하거나 의심스러운 서비스가 존재하지 않을 경우  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-108 로그에 대한 접근통제 및 관리 미흡]>> %RES_LAST_FILE% 2>&1
echo.[SRV-108] OK
echo.##### SRV108 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.[ 1. 이벤트 로그에 대한 접근 권한 설정 여부 ]                                              	>> %RES_LAST_FILE% 2>&1
echo.# \system32\winevt\Logs 폴더 >> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\winevt\Logs>> %RES_LAST_FILE% 2>&1
echo.# \system32\winevt\Logs\Application.evtx 파일  	>> %RES_LAST_FILE% 2>&1
	icacls %SystemRoot%\system32\winevt\Logs\Application.evtx  >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.점검 : Everyone 권한 유무 및 Users 권한 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 양호 조건 중 1개라도 미 충족 시  >> %RES_LAST_FILE% 2>&1
echo.양호 : Everyone 권한 없음, Users에 W, C, F 중 1가지도 존재하지 않을 경우 양호 >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.참고 : W(쓰기), C(바꾸기), F(모든 권한)	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.[ 2. 감사 기록에 대한 접근 통제 설정 여부 ]                                              	>> %RES_LAST_FILE% 2>&1
echo. 1. SeSecurityPrivilege 설정 값                                          >> %RES_LAST_FILE% 2>&1
 type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "SeSecurityPrivilege"              >> %RES_LAST_FILE% 2>&1
echo. 2. \system32\winevt\Logs 폴더                                                               >> %RES_LAST_FILE% 2>&1
 icacls %systemroot%\system32\winevt\Logs                                                        >> %RES_LAST_FILE% 2>&1
echo. 2.1 \system32\Config 폴더(Windows 2003일경우)                                                               >> %RES_LAST_FILE% 2>&1
 icacls %systemroot%\system32\Config                                                        >> %RES_LAST_FILE% 2>&1
echo. 3. \system32\winevt\Logs\Security.evtx 파일                                                >> %RES_LAST_FILE% 2>&1
 icacls %SystemRoot%\system32\winevt\Logs\Security.evtx                                    >> %RES_LAST_FILE% 2>&1
echo. 3.1 \system32\Config\SecEvent.Evt 파일(Windows 2003일경우)                                                >> %RES_LAST_FILE% 2>&1
 icacls %SystemRoot%\system32\Config\SecEvent.Evt                                    >> %RES_LAST_FILE% 2>&1
echo.  
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.점검 : 감사 및 보안로그 관리에 Everyone그룹 및 Users그룹 존재여부 확인               >> %RES_LAST_FILE% 2>&1
echo.취약 : 양호 조건 중 1개라도 해당되지 않는 경우 취약                                      >> %RES_LAST_FILE% 2>&1
echo.양호 : 1) 1번 항목에서 SeSecurityPrivilege 설정 값이 S-1-5-32-544(관리자)인 경우      >> %RES_LAST_FILE% 2>&1
echo.     2) 2,3번 항목에서 Everyone 권한 없음, Users에 W, C, F 중 1가지도 존재하지 않을 경우  >> %RES_LAST_FILE% 2>&1
echo.참고 : W(쓰기), C(바꾸기), F(모든 권한)                                                           >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-109 시스템 주요 이벤트 로그 설정 미흡]>> %RES_LAST_FILE% 2>&1
echo.[SRV-109] OK
echo.##### SRV109 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. [ 1. 보안 로그 감사 기능 설정 확인 ]	>> %RES_LAST_FILE% 2>&1
echo.# 01. 개체 액세스 감사 #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditObjectAccess">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 02. 계정 관리 감사 #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditAccountManage">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 03. 계정 로그온 이벤트 감사 #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditAccountLogon">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 04. 권한 사용 감사 #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditPrivilegeUse">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 05. 디렉터리 서비스 액세스 감사 #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditDSAccess"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 06. 로그온 이벤트 감사 #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditLogonEvents"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 07. 시스템 이벤트 감사 #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditSystemEvents">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 08. 정책 변경 감사 #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditPolicyChange">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 09. 프로세스 추적 감사 #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditProcessTracking">> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.점검 : 감사 기능 설정 확인	 >> %RES_LAST_FILE% 2>&1
echo.취약 : 감사 정책 권고 기준에 따라 감사 설정이 되어 있는 경우	>> %RES_LAST_FILE% 2>&1
echo.양호 : 감사 정책 권고 기준에 따라 감사 설정이 되어 있지 않는 경우	 >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.  * 감사 정책 권고 기준(아래 기준은 운영체제 제조사에서 일반적으로 권장하는 설정값임) 	>> %RES_LAST_FILE% 2>&1
echo.	- 01. 객체 액세스 감사: (0) 감사 안 함>> %RES_LAST_FILE% 2>&1
echo.	- 02. 계정 관리 감사: (1) 성공>> %RES_LAST_FILE% 2>&1
echo.	- 03. 계정 로그온 이벤트 감사: (1) 성공>> %RES_LAST_FILE% 2>&1
echo.	- 04. 권한 사용 감사: (0) 감사 안 함>> %RES_LAST_FILE% 2>&1
echo.	- 05. 디렉터리 서비스 액세스 감사	: (1) 성공>> %RES_LAST_FILE% 2>&1
echo.	- 06. 로그온 이벤트 감사	: (3) 성공, 실패>> %RES_LAST_FILE% 2>&1
echo.	- 07. 시스템 이벤트 감사	: (3) 성공, 실패>> %RES_LAST_FILE% 2>&1
echo.	- 08. 정책 변경 감사: (1) 성공>> %RES_LAST_FILE% 2>&1
echo.	- 09. 프로세스 추적 감사	: (0) 감사 안 함>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-115 로그의 정기적 검토 및 보고 미수행]>> %RES_LAST_FILE% 2>&1
echo.[SRV-115] OK
echo.##### SRV115 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.# 수동점검	#  	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.점검 :  로그기록(이벤트 로그)에 대해 정기적 검토,분석,리포트 작성 및 보고 등의 조치가 되어 있을 경우 양호	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-116 “보안 감사를 수행할 수 없는 경우, 즉시 시스템 종료” 기능 설정 미흡] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-116] OK
echo.##### SRV116 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#CrashOnAuditFail>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "CrashOnAuditFail" 	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.점검 : CrashOnAuditFail값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 4,1(사용함) 	>> %RES_LAST_FILE% 2>&1
echo.양호 : 4,0(사용 안함) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-118 주기적인 보안패치 및 벤더 권고사항 미적용]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-118] OK
echo.##### SRV118 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ 1. 최신 서비스팩 적용 여부 ]                                              	>> %RES_LAST_FILE% 2>&1
echo.#version, buildnumber, ostype, servicepackmajorversion	>> %RES_LAST_FILE% 2>&1
	(wmic os get version, buildnumber, servicepackmajorversion, caption /format:list)>> wmic3.ahn
	TYPE wmic3.ahn>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : 아래와 같은 기준으로 최신 서비스팩을 확인>> %RES_LAST_FILE% 2>&1
echo. -Win 2000 : SP4 (Kernel build : 2195) >> %RES_LAST_FILE% 2>&1
echo. -Win 2003 : SP2 (Kernel build : 3790) >> %RES_LAST_FILE% 2>&1
echo. -Win 2008 : SP2 (Kernel build : 6002) >> %RES_LAST_FILE% 2>&1
echo. -Win 2008 R2 : SP1 (Kernel build : 7601) >> %RES_LAST_FILE% 2>&1
echo. -Win 2012 : 서비스팩 없음(양호)(Kernel build : 9600) >> %RES_LAST_FILE% 2>&1
echo. -Win 2016 : 서비스팩 없음(양호)(Kernel build : 14393) >> %RES_LAST_FILE% 2>&1
echo.양호 : 위의 서비스팩이 적용되어 있을 경우, 2012 버전 이상 양호 	>> %RES_LAST_FILE% 2>&1
echo.취약 : 위의 서비스팩이 적용되어 있지 않을 경우 >> %RES_LAST_FILE% 2>&1    
echo.
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.[ 2. 최신 HOTFIX 적용 여부 ]                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
REM echo. #2017, 2018년도 패치 로그>> %RES_LAST_FILE% 2>&1
REM 	type hotfix.ahn | find /I "/2017">> %RES_LAST_FILE% 2>&1
REM 	type hotfix.ahn | find /I "/2018">> %RES_LAST_FILE% 2>&1
echo.# OS 버전, 설치된 날짜 #>> %RES_LAST_FILE% 2>&1
TYPE wmic3.ahn>> %RES_LAST_FILE% 2>&1
wmic OS get InstallDate>wmic120.ahn
TYPE wmic120.ahn>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# HOT FIX 설치 내용 #>> %RES_LAST_FILE% 2>&1
wmic QFE Get HotFixID,InstalledOn>wmic120.ahn
TYPE wmic120.ahn>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.점검 :# 마이크로소프트 홈페이지에서 최신 보안패치 확인 #>> %RES_LAST_FILE% 2>&1
echo. http://technet.microsoft.com/ko-kr/security	 >> %RES_LAST_FILE% 2>&1    
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-119 백신 프로그램 업데이트 미흡]>> %RES_LAST_FILE% 2>&1
echo.[SRV-119] OK
echo.##### SRV119 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo.# 수동점검	#	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. 비고 : 인터뷰 또는 수동 확인을 통한 점검	 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-123 최종 로그인 사용자 계정 노출]>> %RES_LAST_FILE% 2>&1
echo.[SRV-123] OK
echo.##### SRV123 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1    
echo.#dontdisplaylastusername>> %RES_LAST_FILE% 2>&1    
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /s | find /I "dontdisplaylastusername" >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.점검 : dontdisplaylastusername값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 0(사용 안함) 	>> %RES_LAST_FILE% 2>&1
echo.양호 : 1(사용함) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1

 
echo.[SRV-125 화면보호기 미설정]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-125] OK
echo.##### SRV125 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
	reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find /I "ScreenSaveActive">> %RES_LAST_FILE% 2>&1
	reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find /I "ScreenSaverIsSecure">> %RES_LAST_FILE% 2>&1
	reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find /I "ScreenSaveTimeOut">> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : ScreenSaveActive, ScreenSaverIsSecure, ScreenSaveTimeOut값 이 아래와 같은지 확인  >> %RES_LAST_FILE% 2>&1
echo. -ScreenSaveActive = 1 >> %RES_LAST_FILE% 2>&1  
echo. -ScreenSaverIsSecure = 1 >> %RES_LAST_FILE% 2>&1  
echo. -ScreenSaveTimeOut = 600(10분) 이하 	>> %RES_LAST_FILE% 2>&1  
echo.취약 : 위의 설정 중 하나의 항목이라도 맞지 않게 설정된 경우 	>> %RES_LAST_FILE% 2>&1
echo.양호 : 위와 같이 설정되어 있을 경우 양호 >> %RES_LAST_FILE% 2>&1  
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-126 자동 로그온 방지 설정 미흡]>> %RES_LAST_FILE% 2>&1
echo.[SRV-126] OK
echo.##### SRV126 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
	reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "autoadminlogon">> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : AutoAdminLogon값 확인  >> %RES_LAST_FILE% 2>&1
echo.취약 : 값이 있는 경우 >> %RES_LAST_FILE% 2>&1
echo.양호 : 값이 없거나 0일 경우 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-127 계정 잠금 임계값 설정 미비]>> %RES_LAST_FILE% 2>&1
echo.[SRV-127] OK
echo.##### SRV127 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[# 1. 계정 잠금 임계값 확인 ] >> %RES_LAST_FILE% 2>&1
echo.#Lockout threshold >> %RES_LAST_FILE% 2>&1
	net accounts | find /I "Lockout threshold"  	>> %RES_LAST_FILE% 2>&1
	net accounts | find /I "임계값"  	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : 점검 회사의 패스워드 정책을 확인하여 기준에 준하는지 확인>> %RES_LAST_FILE% 2>&1
echo.       기준이 없을 경우 잠금 임계값(Lockout threshold)을 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 기준에 준하지 않거나 기준이 없을 경우 Lockout threshold가 5 초과 값 >> %RES_LAST_FILE% 2>&1
echo.양호 : 기준에 준하거나 기준이 없을 경우 Lockout threshold가 5 이하>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-128 NTFS 파일 시스템 미사용]>> %RES_LAST_FILE% 2>&1
echo.[SRV-128] OK
echo.##### SRV128 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[# 1. 파일시스템 확인 ]>> %RES_LAST_FILE% 2>&1
	wmic volume get DriveLetter, FileSystem >> wmic4.ahn
	TYPE wmic4.ahn >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : 각 볼륨의 파일 시스템 확인 >> %RES_LAST_FILE% 2>&1
echo.양호 - NTFS 파일 시스템만 사용하는 경우 >> %RES_LAST_FILE% 2>&1
echo.취약 - FAT 파일 시스템을 사용하는 경우 (USB 제외) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-129 백신 프로그램 미설치]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-129] OK
echo.##### SRV129 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.#프로세스 확인: ahnlab v3 malware>> %RES_LAST_FILE% 2>&1
	net start |findstr /I "ahnlab v3 malware"|| echo.V3 백신 프로그램 미설치>> %RES_LAST_FILE% 2>&1
echo. # 수동으로 기타 백신 프로그램 찾아보기 #>> %RES_LAST_FILE% 2>&1
	net start>> %RES_LAST_FILE% 2>&1
	tasklist  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : 목록 중에 백신 프로그램이 있는지 확인  >> %RES_LAST_FILE% 2>&1
echo.취약 : 없음>> %RES_LAST_FILE% 2>&1
echo.양호 : 있음 >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-135 TCP 보안 설정 미비]>> %RES_LAST_FILE% 2>&1
echo.[SRV-135] OK
echo.##### SRV135 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # SynAttackProtect 확인 #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "SynAttackProtect" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. 점검 : '1'이상으로 설정 되어 있으면 양호>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # EnableDeadGWDetect 확인 #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "EnableDeadGWDetect" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. 점검 : '0'으로 설정 되어 있으면 양호>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # KeepAliveTime 확인 #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "KeepAliveTime" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. 점검 : 300,000(5분: 권고값)으로 설정 되어 있으면 양호>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # NoNameReleaseOnDemand 확인 #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" | find /I "NoNameReleaseOnDemand" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. 점검 : '1'로 설정 되어 있으면 양호>> %RES_LAST_FILE% 2>&1
echo. # IPEnableRouter 확인 #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "IPEnableRouter" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. 점검 : 0으로 설정 되어 있으면 양호>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. 참고 : 결과값이 없을 경우 미설정된것으로 취약>> %RES_LAST_FILE% 2>&1
echo. 참고 : Windows 2008 이상인 경우, IPEnableRouter 값만 확인>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-136 시스템 종료 권한 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-136] OK
echo.##### SRV136 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#shutdownwithoutlogon	>> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /s | find /I "shutdownwithoutlogon"  ||echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : shutdownwithoutlogon값 확인  	>> %RES_LAST_FILE% 2>&1
echo.취약 : 1(사용함) 	>> %RES_LAST_FILE% 2>&1
echo.양호 : 0(사용안함) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-137 네트워크 서비스의 접근 제한 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-137] OK
echo.##### SRV137 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[# 1.1. 네트워크에서 이 컴퓨터 엑세스 #]                               >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeRemoteInteractiveLogonRight"   >> %RES_LAST_FILE% 2>&1
echo.[# 1.2. 네트워크에서 이 컴퓨터 엑세스 거부 #]                              >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeDenyNetworkLogonRight"    >> %RES_LAST_FILE% 2>&1
echo.[# 참고. 네트워크 원격 접속 허용 관련 레지스트리 확인 #]                              >> %RES_LAST_FILE% 2>&1
echo.#fDenyTSConnections	>> %RES_LAST_FILE% 2>&1
	(reg QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /s |find /I "fDenyTSConnections" ||echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.양호 : 필요한 그룹만 접근 허용 되어 있을 경우             >> %RES_LAST_FILE% 2>&1
echo.취약 : 불필요한 그룹이 접근 허용 되어 있을 경우             >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.참고 : 네트워크 원격 접속 허용 관련 레지스트리(fDenyTSConnections) 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 0(허용)	>> %RES_LAST_FILE% 2>&1
echo.양호 : 1(허용 안함)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-138 백업 및 복구 권한 설정 미흡] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-138] OK
echo.##### SRV138 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.[# 1.1. 파일 및 디렉토리 백업 #]                                 >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeBackupPrivilege"      >> %RES_LAST_FILE% 2>&1
echo.[# 1.2. 파일 및 디렉토리 복구 #]                                 >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeRestorePrivilege"     >> %RES_LAST_FILE% 2>&1
echo.양호 : "파일 및 디렉토리 백업" 항목과 "파일 및 디렉토리 복구" 항목에 대해 그룹별 접근제어 권한 설정에 Everyone 그룹이나 Guests 그룹, Users 그룹에 대해 권한 미존재 시  >> %RES_LAST_FILE% 2>&1
echo.취약 : "파일 및 디렉토리 백업" 항목과 "파일 및 디렉토리 복구" 항목에 대해 그룹별 접근제어 권한 설정에 Everyone 그룹이나 Guests 그룹, Users 그룹에 대해 권한 존재 시  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-139 시스템 자원 소유권 변경 권한 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-139] OK
echo.##### SRV139 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.[# 1.1. 네트워크에서 이 컴퓨터 엑세스 #]                               >> %RES_LAST_FILE% 2>&1
echo.[# SeTakeOwnershipPrivilege #]                              >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeTakeOwnershipPrivilege" || echo.값 없음  >> %RES_LAST_FILE% 2>&1
echo.양호 : "파일 또는 다른 개체의 소유권 가져오기" 항목 권한에 Administrators 그룹만 존재할 경우   >> %RES_LAST_FILE% 2>&1
echo.취약 : "파일 또는 다른 개체의 소유권 가져오기" 항목 권한에 Everyone, Users 그룹 등이 존재할 경우  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-140 이동식 미디어 포맷 및 꺼내기 허용 정책 설정 미흡]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-140] OK
echo.##### SRV140 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# AllocateDASD>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "AllocateDASD" >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : AllocateDASD값 확인 	>> %RES_LAST_FILE% 2>&1
echo.취약 : 1(Administrators 및 Power Users) 또는 2(Administrators 및 Interactice Users) >> %RES_LAST_FILE% 2>&1
echo.양호 : 값이 없거나(미설정), 0(Administrators) 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-147 불필요한 SNMP 서비스 실행]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-147] OK
echo.##### SRV147 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 SNMP 구동 확인 # ]        >> %RES_LAST_FILE% 2>&1
echo.#SNMP 서비스 구동 여부>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I snmp || echo.[양호] SNMP 서비스 미구동) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.양호: 1.1에서 SNMP 미사용 혹은 사용하나 필요에 의해 사용할 경우(확인필요)  >> %RES_LAST_FILE% 2>&1
echo.취약: 1.1에서 SNMP 사용 >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-148 웹 서비스 정보 노출]>> %RES_LAST_FILE% 2>&1
echo.[SRV-148] OK
echo.##### SRV148 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 6.0 URLSCAN.INI check #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\urlscan\urlscan.ini | findstr /i "RemoveServerHeader" || echo."6.0 버전일 경우, URLSCAN.INI 파일 없으므로 취약"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 7.0 Rewrite rule check(applicationhost.config) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i /c:"Remove Server header" || echo."7.0 버전일 경우, Rewrite룰 없으므로 취약"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 7.0 Rewrite rule check(web.config(우선순위는 web.config가 application보다 높음)) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\web.config | findstr /i /c:"Remove Server header" || echo."7.0 버전일 경우, Rewrite룰 없으므로 취약"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 10.0 Rewrite rule check(applicationhost.config) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i "removeServerHeader" || echo."10.0 버전일 경우, removeServerHeader 없으므로 취약"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 10.0 Rewrite rule check(web.config(우선순위는 web.config가 application보다 높음)) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\web.config | findstr /i "removeServerHeader" || echo."10.0 버전일 경우, removeServerHeader 없으므로 취약"   >> %RES_LAST_FILE% 2>&1

echo. >> %RES_LAST_FILE% 2>&1
echo.기준: 6.0버전은 RemoveServerHeader =1 이면 양호, 값이 없을 경우 취약     >> %RES_LAST_FILE% 2>&1
echo.기준: 7.0버전은 Rewrite룰 있을 경우 양호, 값이 없을 경우 취약     >> %RES_LAST_FILE% 2>&1
echo.기준: 10.0버전은 removeServerHeader=true 이면 양호, 값이 없을 경우 취약     >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# IIS errorpage check #	>> %RES_LAST_FILE% 2>&1
echo.[ 2. IIS 웹서비스 정보 숨김 여부 ]
echo.@ IIS 5.0>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	.\bin\mdutil ENUM_ALL W3SVC	> W3SVC_all.ahn
	IF ERRORLEVEL 1 goto 3_24_IIS_6_0
	TYPE W3SVC_all.ahn | findstr /I "CustomError" > SRV-148_ERRMSG.ahn
	TYPE SRV-148_ERRMSG.ahn	>> %RES_LAST_FILE% 2>&1
	echo.	>> %RES_LAST_FILE% 2>&1
	TYPE SRV-148_ERRMSG.ahn | findstr /I "CustomError" > NUL
	IF ERRORLEVEL 1 echo [결과] 에러에 대한 별도의 처리 페이지 존재하지 않음    	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [결과] 에러에 대한 별도의 처리 페이지 존재함	>> %RES_LAST_FILE% 2>&1
	goto 3_24_IIS_6_0

:3_24_IIS_6_0
echo.>> %RES_LAST_FILE% 2>&1
echo.@ IIS 6.0>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	IF ERRORLEVEL 1 goto 3_24_IIS_7_0
	TYPE MetaBase.xml | findstr /I "HttpErrors=" > SRV-148_ERRMSG.ahn
	TYPE SRV-148_ERRMSG.ahn	>> %RES_LAST_FILE% 2>&1
	echo.	>> %RES_LAST_FILE% 2>&1
	TYPE SRV-148_ERRMSG.ahn | findstr /I "HttpErrors=" > NUL
	IF ERRORLEVEL 1 echo [결과] 에러에 대한 별도의 처리 페이지 존재하지 않음    	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [결과] 에러에 대한 별도의 처리 페이지 존재함	>> %RES_LAST_FILE% 2>&1
	goto 3_24_IIS_7_0

:3_24_IIS_7_0
echo.>> %RES_LAST_FILE% 2>&1
echo.@ IIS 7.0>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 수동점검	# >> %RES_LAST_FILE% 2>&1

:3_24_IIS
echo.>> %RES_LAST_FILE% 2>&1
echo.기준: 6.0버전은 RemoveServerHeader =1 이면 양호, 값이 없을 경우 취약     >> %RES_LAST_FILE% 2>&1
echo.기준: 7.0버전은 Rewrite룰 있을 경우 양호, 값이 없을 경우 취약     >> %RES_LAST_FILE% 2>&1
echo.기준: 10.0버전은 removeServerHeader=true 이면 양호, 값이 없을 경우 취약     >> %RES_LAST_FILE% 2>&1
echo.점검 : error statusCode(상태 코드) 별로 별도의 처리 페이지가 존재 하는지 확인  >> %RES_LAST_FILE% 2>&1 
echo.취약 : [결과] 부분이 '에러에 대한 별도의 처리 페이지 존재하지 않음'이면 취약>> %RES_LAST_FILE% 2>&1
echo.양호 : [결과] 부분이 '에러에 대한 별도의 처리 페이지 존재함'이면 양호	>> %RES_LAST_FILE% 2>&1  
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-149 디스크 볼륨 암호화 미적용]>> %RES_LAST_FILE% 2>&1
echo.[SRV-149] OK
echo.##### SRV149 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.(1.1 인터뷰 확인)        >> %RES_LAST_FILE% 2>&1
echo.# 아래 예외에 해당하는 내용의 인터뷰 확인 필요#        >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.양호 : "데이터 보호를 위해 내용을 암호화" 정책이 선택된 경우 >> %RES_LAST_FILE% 2>&1
echo.예외 : 해당 서버가 물리적으로 보호 된 장소 (IDC 내, PC시건장치 등)에 위치해 있을 경우 >> %RES_LAST_FILE% 2>&1
echo.     또는 하드디스크 교체 시 기존 하드디스크의 디가우징 또는 천공 등 폐기 관련 규정 수행시 >> %RES_LAST_FILE% 2>&1
echo.취약 : "데이터 보호를 위해 내용을 암호화" 정책이 선택되어 있지 않은 경우  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#참고. EFS 관련 레지스트리 확인	>> %RES_LAST_FILE% 2>&1
	(Reg query HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\SystemCertificates\EFS |findstr /I "blob") >> %RES_LAST_FILE% 2>&1
echo.점검 : EFSblob 값(해당 레지스트리는 참고용으로만 사용하며 값이 존재하여도 디스크볼륨 암호화 설정이 안되어 있을 수 있으므로 인터뷰 필요함) >> %RES_LAST_FILE% 2>&1
echo.취약 : 빈값>> %RES_LAST_FILE% 2>&1
echo.양호 : 값 존재>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-150 로컬 로그온 허용]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-150] OK
echo.##### SRV150 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#SeInteractiveLogonRight>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "SeInteractiveLogonRight" 	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : SeInteractiveLogonRight값 확인 	>> %RES_LAST_FILE% 2>&1
echo.취약 : "Administrators(*S-1-5-32-544)", "IUSR_(*S-1-5-17)", "관리자 계정" 외의 다른 계정 및 그룹이 존재 >> %RES_LAST_FILE% 2>&1
echo.양호 : "Administrators(*S-1-5-32-544)", "IUSR_(*S-1-5-17)", "관리자 계정" 만 존재 >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-151 익명 SID/이름 변환 허용]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-151] OK
echo.##### SRV151 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# LSAAnonymousNameLookup>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "LSAAnonymousNameLookup" || echo. 값 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : (WIN 2008) LSAAnonymousNameLookup값 확인 >> %RES_LAST_FILE% 2>&1
echo.취약 : 1(사용함)  >> %RES_LAST_FILE% 2>&1
echo.양호 : 0(사용 안함) 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-152 원격터미널 접속 가능한 사용자 그룹 제한 미비]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-152] OK
echo.##### SRV152 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# 원격터미널 접속 가능 여부 확인 (SeRemoteInteractiveLogonRight)# 	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /r /i "SeRemoteInteractiveLogonRight"	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# 원격터미널 접속 가능 여부 확인 (fDenyTSConnections)# >> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" | find /I "fDenyTSConnections" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# 원격터미널 접속 가능 사용자 그룹 확인# 	>> %RES_LAST_FILE% 2>&1
	(net localgroup "Remote Desktop Users")	 >> %RES_LAST_FILE% 2>&1	
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : fDenyTSConnections 값 및 Remote Desktop Users 그룹의 계정 확인  >> %RES_LAST_FILE% 2>&1
echo.취약 : fDenyTSConnections값이 0(원격 접속 사용)이고 Remote Desktop Users 그룹에 불필요한 계정이 있는 경우 >> %RES_LAST_FILE% 2>&1
echo.양호 : fDenyTSConnections값이 1(원격 접속 사용 안함) or (fDenyTSConnections값이 0(원격 접속 사용)이고 Remote Desktop Users 그룹에 필요한 계정만 있는 경우) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-158 불필요한 TELNET 서비스 실행] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-158] OK
echo.##### SRV158 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#Telnet 서비스 구동 여부 >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I telnet || echo 양호. Telnet 서비스 미 구동) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#Telnet 서비스 포트 확인 >> %RES_LAST_FILE% 2>&1
	(netstat -na | find "23" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : 불필요한 "Telnet Service" 사용 유무 	>> %RES_LAST_FILE% 2>&1
echo.취약 : Telnet 서비스 구동시  	>> %RES_LAST_FILE% 2>&1
echo.양호 : Telnet 서비스 미구동 시	>> %RES_LAST_FILE% 2>&1
echo.참고 : TELNET 서비스가 실행 중일 경우 인터뷰를 통해 필요한 서비스인지 점검 필요>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-163 시스템 사용 주의사항 미출력]>> %RES_LAST_FILE% 2>&1
echo.[SRV-163] OK
echo.##### SRV163 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# 레지스트리_LegalNoticeCaption 값(메세지 창의 제목) >> %RES_LAST_FILE% 2>&1
	(reg QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "LegalNoticeCaption" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.# 레지스트리_LegalNoticeText 값(메세지 창의 내용) 	>> %RES_LAST_FILE% 2>&1
	(reg QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "LegalNoticeText" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.# 로컬보안정책_LegalNoticeCaption 값(메세지 창의 제목) >> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | findstr "LegalNoticeCaption" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo.# 로컬보안정책_LegalNoticeText 값(메세지 창의 내용) 	>> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | findstr "LegalNoticeText" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.점검 : LegalNoticeCaption, LegalNoticeText 두 레지스트리값 확인>> %RES_LAST_FILE% 2>&1
echo.취약 : 두 레지스트리 모두 빈 값 (REG_SZ 뒤) 	>> %RES_LAST_FILE% 2>&1
echo.양호 : 특정값 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-170 SMTP 서비스 정보 노출]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-170] OK
echo.##### SRV170 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 SMTP 구동 확인 # ]        >> %RES_LAST_FILE% 2>&1
echo.# SMTP SERVICE	>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I "SMTP" || echo. "SMTP 미구동, 관련 항목 모두 양호(또는 N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.2 SMTP 포트 확인 # ]        >> %RES_LAST_FILE% 2>&1
	(netstat -na | find ":25" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.양호: 1.1에서 IIS 미사용 혹은 25포트 미사용 혹은 포트 사용하나 SMTP 접속 시 배너 정보가 보이지 않는 경우(인터뷰 혹은 수동진단)     >> %RES_LAST_FILE% 2>&1
echo.취약: 1.1에서 IIS 사용 혹은 25포트 사용하며 SMTP 접속 시 배너 정보가 보여지는 경우     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-171 FTP 서비스 정보 노출]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-171] OK
echo.##### SRV171 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 FTP 구동 확인 # ]        >> %RES_LAST_FILE% 2>&1
echo.# FTP SERVICE	>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I "FTP" || echo. "FTP 미구동, 관련 항목 모두 양호(또는 N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.2 FTP/ 포트 확인 # ]        >> %RES_LAST_FILE% 2>&1
	(netstat -na | find ":21" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. #applicationHost.config 파일 내용 확인  >> %RES_LAST_FILE% 2>&1
	(TYPE %systemroot%\system32\inetsrv\config\applicationHost.config | findstr /i "suppressDefaultBanner" || echo.값 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.양호: 1.1에서 IIS 미사용 혹은 21포트 미사용 혹은 포트 사용하나 suppressDefaultBanner="TRUE" 설정이 존재하면 양호, FTP 접속 시 배너 정보가 보이지 않는 경우(인터뷰 혹은 수동진단)     >> %RES_LAST_FILE% 2>&1
echo.취약: 1.1에서 IIS 사용 혹은 21포트 사용하며 FTP 접속 시 배너 정보가 보여지는 경우     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1




echo.[SRV-172 불필요한 시스템 자원 공유 존재]>> %RES_LAST_FILE% 2>&1
echo.[SRV-172] OK
echo.##### SRV172 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#공유 폴더 확인 여부>> %RES_LAST_FILE% 2>&1
	(net share)>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.취약 : 불필요한 공유가 존재할 경우 >> %RES_LAST_FILE% 2>&1
echo.양호 : 공유폴더가 없거나, 업무상 필요한 공유만 존재할 경우>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-173 DNS 서비스의 취약한 동적 업데이트 설정]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-173] OK
echo.##### SRV173 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 DNS 구동 확인 # ]        >> %RES_LAST_FILE% 2>&1
echo.# IIS ADMIN SERVICE	>> %RES_LAST_FILE% 2>&1
	(sc query dns || echo. "DNS 미구동, 관련 항목 모두 양호(또는 N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# DnsSettings.txt	AllowUpdate 설정값 확인>> %RES_LAST_FILE% 2>&1
	dnscmd /ExportSettings
	(TYPE %systemroot%\system32\dns\DnsSettings.txt | findstr /I "AllowUpdate" || echo.파일 없음) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.양호: AllowUpdate가 1이 아닌경우    >> %RES_LAST_FILE% 2>&1
echo.취약: AllowUpdate가 1인 경우     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-174 불필요한 DNS 서비스 실행]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-174] OK
echo.##### SRV174 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 DNS 구동 확인 # ]        >> %RES_LAST_FILE% 2>&1
echo.# IIS ADMIN SERVICE	>> %RES_LAST_FILE% 2>&1
	sc query dns || echo. "DNS 미구동, 관련 항목 모두 양호(또는 N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.양호: DNS 서비스가 실행 중이지 않거나, 필요에 의해 사용 중인 경우     >> %RES_LAST_FILE% 2>&1
echo.취약: DNS 서비스가 불필요하게 실행 중인 경우AllowUpdate가 1인 경우     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.# IIS ADMIN SERVICE check	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"IIS Admin Service" || echo."IIS Admin Service 미구동, 관련 항목 모두 양호(또는 N/A)")>> %RES_LAST_FILE% 2>&1
echo.[# World Wide Web Publishing Service check]	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"World Wide Web Publishing Service" || echo. World Wide Web Publishing Service 서비스 미구동) >> %RES_LAST_FILE% 2>&1



echo.#[NET ACCOUNTS]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net accounts >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[NET LOCALGROUP]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net localgroup >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[NET LOCALGROUP - ADM]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net localgroup administrators >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[NET LOCALGROUP - guest]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net localgroup guests >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[NET LOCALGROUP - users]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net localgroup users >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[NET LOCALGROUP - remote]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net localgroup "remote desktop users" >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[NET LOCALGROUP - event]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net localgroup "event log readers" >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[NET LOCALGROUP - backup]################################################################>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
net localgroup "backup operators" >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1


echo.#[FIREWALL]################################################################ >> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
netsh firewall show state>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_basicinfo.ahn 2>&1

echo.#[REG-SNMP]################################################################ >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
	reg query HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SNMP\Parameters >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1

echo.#[REG-lanmanserver]################################################################ >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1

echo.#[REG-W3SVC]################################################################ >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
	reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\W3SVC\Parameters" >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1

echo.#[REG-TCP/IP]################################################################ >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
	reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" >> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1
echo.>> [RESULT_ahnlab]_%COMPUTERNAME%_REG.ahn 2>&1


echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. End of script
echo.>> %RES_LAST_FILE% 2>&1



echo. --- END TIME ---------------------------------------------------------------------->> %RES_LAST_FILE% 2>&1
	date /t>> %RES_LAST_FILE% 2>&1
	time /t 
	
echo.  	>> %RES_LAST_FILE% 2>&1
	del c:\test.inf
	REM del setup.*
	REM del MAKECABFILE.ahn
	REM rmdir disk1
	REM rmdir bin

	del [RESULT_ahnlab]*
	del *.ahn
	REM del *.xml
	REM del *.dmp
	del TMP_IIS_CONF.log
	del TMP_FILES1

	REM del *.bat



