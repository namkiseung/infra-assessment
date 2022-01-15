::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: 공통 부분 시작:::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off

setlocal
set think=C:\think
set john=%think%\john
set script=%think%\script

rem 스크립트 실행 시 항목 카운트 보여주기 위한 변수df
set item_count=0

TITLE Windosws Security Check

::실제 버전 확인 시작
ver > ver.txt
for /f "delims=[ tokens=2" %%i in (ver.txt) do set MV=%%i
del ver.txt 2> nul

if exist %windir%\SysWOW64 (
	set WinBit=64
) else (
	set WinBit=32
)

:: windows 2000
if "%MV:~8,3%"=="5.0" (
	set WinVer=1
	set WinVer_name=2000
	echo Windows 2000 %WinBit%bit                                                            > %think%\real_ver.txt
)

:: windows 2003
if "%MV:~8,3%"=="5.2" (
	set WinVer=2
	set WinVer_name=2003
	echo Windows 2003 %WinBit%bit                                                            > %think%\real_ver.txt
)

:: windows 2008
if "%MV:~8,3%"=="6.0" (
	set WinVer=3
	set WinVer_name=2008
	echo Windows 2008 %WinBit%bit                                                            > %think%\real_ver.txt
)

:: windows 2008 r2
if "%MV:~8,3%"=="6.1" (
	set WinVer=4
	set WinVer_name=2008_R2
	echo Windows 2008 R2 %WinBit%bit                                                         > %think%\real_ver.txt
)

:: windows 2012
if "%MV:~8,3%"=="6.2" (
	set WinVer=5
	set WinVer_name=2012
	echo Windows 2012 %WinBit%bit                                                            > %think%\real_ver.txt
)

:: windows 2012 r2
if "%MV:~8,3%"=="6.3" (
	set WinVer=6
	set WinVer_name=2012_R2
	echo Windows 2012 R2 %WinBit%bit                                                         > %think%\real_ver.txt
)

:: windows 2016
if "%MV:~8,4%"=="10.0" (
	set WinVer=7
	set WinVer_name=2016
	echo Windows 2016 %WinBit%bit                                                         > %think%\real_ver.txt
)

type real_ver.txt > %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: windows 2008 이상버전은 icacls
if %WinVer% geq 3 (
	doskey cacls=icacls $*
)
::실제 버전 확인 끝




set SCRIPT_LAST_UPDATE=2017.09.01
echo ======================================================================================= >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■■■■■■■■■■■■■■■■■      Windows %WinVer_name% Security Check      ■■■■■■■■■■■■■■■■■■■■ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■■■■■■■■■■■■■■■■■      Copyright ⓒ 2017, SK think Co. Ltd.    ■■■■■■■■■■■■■■■■■■■■ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ======================================================================================= >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo LAST_UPDATE %SCRIPT_LAST_UPDATE%                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  Start Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
date /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
time /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt     
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::sysinfo 한글(chcp 437이후 한글 ??로 깨짐 현상 방지)
echo [+] Gathering systeminfo...
systeminfo																					 > %think%\systeminfo_ko.txt 2>nul

::영문으로 변경
chcp 437

::공통 설정파일 추출
secedit /EXPORT /CFG Local_Security_Policy.txt >nul
net accounts > %think%\net-accounts.txt 


::FTP 사용확인
net start | find /i "ftp" > nul
if not errorlevel 1 (
	echo FTP Enable                                                                         > ftp-enable.txt
) else (
goto FTP-Disable
)

:: FTP Version 구별하기
net start | find /i "FTP Publishing Service" > nul
if not errorlevel 1 (
	set iis_ftp_ver_major=6
) else (
	net start | find /i "Microsoft FTP Service" > nul
	if not errorlevel 1 (
		set iis_ftp_ver_major=7
	) else (
		set iis_ftp_ver_major=0
	)
)

:: FTP Site List 구하기 ( ftpsite-list.txt )
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list site | find /i "ftp"                           > %think%\ftpsite-list.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "MSFTPSVC" | findstr /i /v "FILTERS APPPOOLS INFO" > ftpsite-list.txt
)

:: FTP Site Name 구하기 ( ftpsite-name.txt )
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	for /f "tokens=1 delims=(" %%a in (ftpsite-list.txt) do (
		for /f "tokens=2-11 delims= " %%b in ("%%a") do (
			echo %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k                                   >> %think%\ftpsite-name.txt
		)
	)
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (ftpsite-list.txt) do (
		cscript %script%\adsutil.vbs enum %%i | findstr /i "ServerComment ServerState"     >> %think%\ftpsite-name.txt
		echo -----------------------------------------------------------------------	   >> %think%\ftpsite-name.txt
	)
)

:: FTP Site physicalpath 구하기 ( ftpsite-physicalpath.txt )
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "physicalpath" > %think%\ftpsite-physicalpath-temp.txt
	for /f "tokens=3 delims= " %%a in (ftpsite-physicalpath-temp.txt) do (
		for /f "tokens=2 delims==" %%b in ("%%a") do echo %%~b >> ftpsite-physicalpath.txt
	)
	del ftpsite-physicalpath-temp.txt 2> nul
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (ftpsite-list.txt) do (
		cscript %script%\adsutil.vbs enum %%i/root | find /i "path" | find /i /v "AspEnableParentPaths" >> %think%\ftpsite-physicalpath-temp.txt
	)
	for /f "tokens=4-8 delims= " %%i in (ftpsite-physicalpath-temp.txt) do (
		echo %%i %%j %%k %%l %%m                                                              >> %think%\ftpsite-physicalpath.txt
	)
	del ftpsite-physicalpath-temp.txt 2> nul
)
:FTP-Disable

::IIS 사용확인
net start | find /i "world wide web publishing service" > nul
if not errorlevel 1 (
	echo IIS Enable                                                                           > iis-enable.txt
) else (
 goto IIS-Disable
 )

:: IIS Version 구하기
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" | find /i "version" > iis-version.txt
type iis-version.txt | find /i "major"                                                        > iis-version-major.txt
for /f "tokens=3" %%a in (iis-version-major.txt) do set iis_ver_major=%%a
del iis-version-major.txt 2> nul

:: WebSite List 구하기 ( website-list.txt )
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list site | find /i "http"                             > website-list.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum W3SVC | find /i "W3SVC" | findstr /i /v "FILTERS APPPOOLS INFO" > website-list.txt
)

:: WebSite Name 구하기 ( website-name.txt )
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "tokens=1 delims=(" %%a in (website-list.txt) do (
		for /f "tokens=2-11 delims= " %%b in ("%%a") do (
			echo %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k                                         >> website-name.txt
		)
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		cscript %script%\adsutil.vbs enum %%i | findstr /i "ServerComment ServerAutoStart"       >> website-name.txt
		cscript %script%\adsutil.vbs enum %%i/ROOT | find "AppRoot"                              >> website-name.txt
		echo -----------------------------------------------------------------------			 >> website-name.txt
	)
)

:: Web Site physicalpath 구하기 ( website-physicalpath.txt )
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "physicalpath" > website-physicalpath-temp.txt
	for /f "tokens=3 delims= " %%a in (website-physicalpath-temp.txt) do (
		for /f "tokens=2 delims==" %%b in ("%%a") do echo %%~b >> website-physicalpath.txt
	)
	del website-physicalpath-temp.txt 2> nul
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		cscript %script%\adsutil.vbs enum %%i/root | find /i "path" | find /i /v "AspEnableParentPaths" >> website-physicalpath-temp.txt
	)
	for /f "tokens=4-8 delims= " %%i in (website-physicalpath-temp.txt) do (
		echo %%i %%j %%k %%l %%m                                                              >> website-physicalpath.txt
	)
	del website-physicalpath-temp.txt 2> nul
)
:IIS-Disable


::sysinfo 영문
systeminfo																					 > %think%\systeminfo.txt 2>nul

::Process List
:: winver = 2000
if %WinVer% equ 1 (
	%script%\pslist                                                                          > tasklist.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	tasklist																				 > %think%\tasklist.txt 2>nul
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: 공통 부분 끝:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0101 START                                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################        Administrator 계정 이름 바꾸기         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: Administrator 계정 이름을 변경하여 사용하는 경우 양호                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net localgroup Administrators | findstr /V "Comment Members completed" | findstr .           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

net localgroup Administrators | findstr /V "Comment Members completed" | findstr .           > %think%\1.01-result.txt
type 1.01-result.txt | findstr /V "Alias name" | findstr /i administrator | findstr .        > %think%\result.txt

net localgroup Administrators | findstr /V "Comment Members completed" | findstr . | findstr /V "Alias name" | findstr /i administrator | findstr . > nul
if %errorlevel% equ 0 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=Administrator																		>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O																				>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
del %think%\1.01-result.txt 2>nul
del %think%\result.txt 2>nul

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0101 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0102 START                                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################               GUEST 계정 상태                ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: Guest 계정 비활성화일 경우 양호                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user guest | find "User name"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user guest | find "Account active"                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

net user guest | find "Account active" | %script%\awk -F" " {print$3}        >> %think%\result.txt

net user guest | find "Account active" | find "Yes" > nul
if %errorlevel% equ 0 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=Yes												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=No												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

del %think%\result.txt 2>nul

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0102 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0103 START                                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################              불필요한 계정 제거               ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 불필요한 계정이 존재하지 않을 경우                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ****************************  User Accounts List  *****************************         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user | find /V "successfully" | findstr .                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *****************************  Account Information  ***************************         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        > %think%\account.txt 2>nul
FOR /F "tokens=1,2,3 skip=4" %%i IN ('net user') DO (
echo -------------------------------------------------------------------------------         >> %think%\account.txt 2>nul
net user %%i >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %think%\account.txt 2>nul
net user %%j >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %think%\account.txt 2>nul
net user %%k >> account.txt 2>nul
)
findstr "User active Comment Last --" account.txt                                            > %think%\account_temp1.txt
findstr /v "change profile Memberships User's" account_temp1.txt                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0103 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0104 START                                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################            계정 잠금 임계값 설정             ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 로그온 실패 수를 제한하는 계정 잠금 임계값이 5번 이하로 설정되어 있으면 양호          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type net-accounts.txt | find "Lockout threshold"                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


type net-accounts.txt | find "Lockout threshold" | %script%\awk -F" " {print$3}        		> %think%\result.txt

type %think%\result.txt | find /i "never" > nul
if %errorlevel% neq 1 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=Never												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
)


echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul

echo 0104 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0105 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################    해독 가능한 암호화를 사용하여 암호 저장    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "해독 가능한 암호화를 사용하여 암호 저장" 정책이 "사용안함"으로 설정되어 있으면 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (ClearTextPassword = 0 일 경우 양호)                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "ClearTextPassword"                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "ClearTextPassword"  |  %script%\awk -F" " {print$3}    >> %think%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo 0105 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0106 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################      관리자 그룹에 최소한의 사용자 포함        ##################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: Administrators 그룹에 불필요한 계정이 존재 하지 않을 경우 양호                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net localgroup Administrators | findstr /V "Comment Members completed" | findstr .           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        > %think%\admin-account.txt 2>nul
echo *********************  Administrators Account Information  ********************         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "tokens=1,2,3,4 skip=6" %%j IN ('net localgroup administrators') DO (
net user %%j %%k %%l %%m >> %think%\admin-account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %think%\admin-account.txt 2>nul
)
findstr c/:"User name | Account active | Last logon | -----" admin-account.txt               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0106 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0107 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ################     Everyone 사용 권한을 익명 사용자에게 적용          ############### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : “Everyone 사용 권한을 익명 사용자에게 적용” 정책이 “사용안함” 으로 되어 있을 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 		: (EveryoneIncludesAnonymous=4,0 이면 양호)                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 해당사항 없음                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	type Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymous"                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymous"						 >> %think%\result.txt

for /f "tokens=2 delims==" %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0107 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0108 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################              계정 잠금 기간 설정              ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "계정 잠금 기간", "계정 잠금 기간 원래대로 설정" 값이 60분 이상으로 설정되어 있으면 양호                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type net-accounts.txt | find "Lockout duration"                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type net-accounts.txt | find "Lockout observation"                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type net-accounts.txt | find "Lockout duration" | %script%\awk -F" " {print$4} > %think%\lockout.txt
type net-accounts.txt | find "Lockout observation" |%script%\awk -F" " {print$5} > %think%\lockout2.txt

for /f %%r in (lockout.txt) do set lockout1=%%r
for /f %%p in (lockout2.txt) do set lockout=%lockout1%:%%p					
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo Result=%lockout%												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\lockout.txt 2>nul
del %think%\lockout2.txt 2>nul

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0108 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0109 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################             패스워드 복잡성 설정              ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "암호는 복잡성을 만족해야 함" 정책이 "사용" 으로 되어 있을 경우 양호            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (PasswordComplexity = 1 일 경우 양호)                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "PasswordComplexity"                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


type Local_Security_Policy.txt | Find /I "PasswordComplexity" | %script%\awk -F" " {print$3}  >> %think%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul



echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0109 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0110 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################            패스워드 최소 암호 길이            ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 최소 암호 길이 설정이 8자 이상인 경우 양호                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type net-accounts.txt | find "length"                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type net-accounts.txt | find "length" | %script%\awk -F" " {print$4}                      >> %think%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul

echo 0110 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0111 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################            패스워드 최대 사용 기간           ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 최대 암호 사용 기간 설정이 90일 이하인 경우 양호                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type net-accounts.txt | find "Maximum password"                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type account.txt | findstr "User active expires Last --"                        			 > %think%\account_temp2.txt
type account_temp2.txt | findstr /v "change profile Memberships User's" | findstr "User active Password Last --" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type net-accounts.txt | find "Maximum password" | %script%\awk -F" " {print$5}                      >> %think%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul


echo 0111 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0112 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################           패스워드 최소 사용 기간            ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 계정의 패스워드 사용기간이 최소 1일 이상일 경우 양호                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type net-accounts.txt | find "Minimum password age"                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type net-accounts.txt | find "Minimum password age" | %script%\awk -F" " {print$5} > %think%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul


echo 0112 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0113 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################         마지막 사용자 이름 표시 안함         ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "마지막 사용자 이름 표시 안함" 정책이 "사용"으로 설정되어 있을 경우 양호        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (DontDisplayLastUserName = 1)                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName" | %script%\awk -F" " {print$3}                      >> %think%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul


echo 0113 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0114 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################               로컬 로그온 허용               ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "로컬 로그온 허용" 정책에 "Administrators", "IUSR_" 만 존재할 경우 양호         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (Administrators = *S-1-5-32-544), (IUSR = *S-1-5-17)                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight"                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight" | %script%\awk -F= {print$2}                      >> %think%\result.txt

for /F "delims=, tokens=1-26" %%a in (result.txt) do (
	echo %%a  >> result2.txt 2> nul
	echo %%b  >> result2.txt 2> nul
	echo %%c  >> result2.txt 2> nul
	echo %%d  >> result2.txt 2> nul
	echo %%e  >> result2.txt 2> nul
	echo %%f  >> result2.txt 2> nul
	echo %%g  >> result2.txt 2> nul
	echo %%h  >> result2.txt 2> nul
	echo %%i  >> result2.txt 2> nul
	echo %%j  >> result2.txt 2> nul
	echo %%k  >> result2.txt 2> nul
	echo %%l  >> result2.txt 2> nul
	echo %%m  >> result2.txt 2> nul
	echo %%n  >> result2.txt 2> nul
	echo %%o  >> result2.txt 2> nul
	echo %%p  >> result2.txt 2> nul
	echo %%q  >> result2.txt 2> nul
	echo %%r  >> result2.txt 2> nul
	echo %%s  >> result2.txt 2> nul
	echo %%t  >> result2.txt 2> nul
	echo %%u  >> result2.txt 2> nul
	echo %%v  >> result2.txt 2> nul
	echo %%w  >> result2.txt 2> nul
	echo %%x  >> result2.txt 2> nul
	echo %%y  >> result2.txt 2> nul
	echo %%z  >> result2.txt 2> nul
)

type result2.txt | findstr /V /i "*S-1-5-32-544 *S-1-5-17 ECHO" >> result3.txt

type result3.txt | findstr "*S-1" > nul
if NOT ERRORLEVEL 1 (
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

if ERRORLEVEL 1 (
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul
del %think%\result2.txt 2>nul
del %think%\result3.txt 2>nul

echo 0114 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0115 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################           익명 SID/이름 변환 허용            ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "익명 SID/이름 변환 허용" 정책이 "사용 안 함" 으로 되어 있을 경우 양호          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (LSAAnonymousNameLookup = 0)                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 해당사항 없음                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	type Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup"                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup" | %script%\awk -F" " {print$3}                      > %think%\result.txt

	for /f "delims= tokens=1" %%r in (result.txt) do echo Result=%%r	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul

)

echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0115 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0116 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################                최근 암호 기억                ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 계정의 최근 사용한 패스워드 기억 설정이 12개 이상인 경우 양호                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type net-accounts.txt | find "history"                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type net-accounts.txt | find "history" | %script%\awk -F" " {print$6}                      >> %think%\result.txt

type %think%\result.txt | find /i "None" > nul

for /f "tokens=1" %%r in (result.txt) do echo Result=%%r >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul

echo 0116 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0117 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################  콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한  ################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한" 정책이 "사용"으로 되어 있을 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (LimitBlankPasswordUse = 4,1)                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem 결과 값이 존재하지 않으면 Default 설정 적용(Default 설정: LimitBlankPasswordUse 1 양호)
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 해당사항 없음                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	type Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse"                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse"                >> %think%\result.txt
	for /f "delims== tokens=2" %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul

	
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0117 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0118 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################    원격터미널 접속 가능한 사용자 그룹 제한    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 원격 터미널 접속이 가능한 Administrators그룹과 Remote Desktop Users그룹에       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 불필요한 계정이 등록되어 있지 않은 경우 양호                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 해당사항 없음                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2008_R2
if %WinVer% geq 4 (
	net start | find /i "Remote Desktop Services" >nul
	IF NOT ERRORLEVEL 1 (
		echo ☞ Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ☞ 원격 터미널 접속 허용 계정                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Administrators" | findstr /V "Comment Members completed" | findstr .         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Remote Desktop Users" | findstr /V "Comment Members completed" | findstr .   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	IF ERRORLEVEL 1 (
		echo ☞ Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
) else (
	NET START | FIND "Terminal Service" > NUL
	IF NOT ERRORLEVEL 1 (
		echo ☞ Terminal Service Enable                                          			>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ☞ 원격 터미널 접속 허용 계정                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Administrators" | findstr /V "Comment Members completed" | findstr .         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Remote Desktop Users" | findstr /V "Comment Members completed" | findstr .   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	IF ERRORLEVEL 1 (
		echo ☞ Terminal Service Disable                                             		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0118 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0201 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
chcp 949
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################          공유 권한 및 사용자 그룹 설정        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 일반공유 폴더가 없거나 공유 디렉토리 접근 권한이 Everyone 없을 경우 양호    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | find /v "$" | find /v "명령"			                                      	 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | find /v "$" | find /v "명령" | find /v "------"                                    	 > %think%\inf_share_folder.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type inf_share_folder.txt | find "\" > nul
IF %ERRORLEVEL% neq 0 echo 공유폴더가 존재하지 않습니다.								>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ☞ cacls 결과                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	FOR /F "tokens=2 skip=3" %%j IN (inf_share_folder.txt) DO cacls %%j                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
	
	FOR /F "tokens=2 skip=3" %%j IN (inf_share_folder.txt) DO cacls %%j  					>> %think%\result.txt
	type %think%\result.txt | findstr /i "everyone" > nul
	if NOT ERRORLEVEL 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if ERRORLEVEL 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: winver >= 2003
if %WinVer% geq 2 (	
	fsutil fsinfo drives 																	 > %think%\inf_using_drv_temp1.txt
	type inf_using_drv_temp1.txt | find /i "\" 												 > %think%\inf_using_drv_temp2.txt

	echo.																					 > %think%\inf_using_drv_temp3.txt
	FOR /F "tokens=1-26" %%a IN (inf_using_drv_temp2.txt) DO (
		echo %%a >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%b >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%c >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%d >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%e >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%f >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%g >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%h >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%i >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%j >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%k >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%l >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%m >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%n >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%o >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%p >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%q >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%r >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%s >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%t >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%u >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%v >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%w >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%x >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%y >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%z >> %think%\inf_using_drv_temp3.txt 2> nul
	)
	type inf_using_drv_temp3.txt | find /i "\" | find /v "A:\" 								 > %think%\inf_using_drv.txt
	
	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		type inf_share_folder.txt | find "%%a"												 >> %think%\inf_share_folder_temp.txt
	
	)
	
	%script%\sed "s/   */?/g" %think%\inf_share_folder_temp.txt 							 > %think%\inf_share_folder_temp_sed.txt
	type inf_share_folder_temp_sed.txt | findstr "^?"										 > %think%\inf_share_folder_temp_sed2.txt
	
	for /F "tokens=2 delims= " %%a in (inf_share_folder_temp.txt) do cacls ^"%%a^"		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	for /F "tokens=2 delims=?" %%a in (inf_share_folder_temp_sed.txt) do cacls ^"%%a^"		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	for /F "tokens=1 delims=?" %%a in (inf_share_folder_temp_sed2.txt) do cacls ^"%%a^"		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	
	for /F "tokens=2 delims= " %%a in (inf_share_folder_temp.txt) do cacls ^"%%a^"		 >> %think%\result.txt
	for /F "tokens=2 delims=?" %%a in (inf_share_folder_temp_sed.txt) do cacls ^"%%a^"        >> %think%\result.txt 
	for /F "tokens=1 delims=?" %%a in (inf_share_folder_temp_sed2.txt) do cacls ^"%%a^"		  >> %think%\result.txt
	
	type %think%\result.txt | findstr /i "everyone" 2>nul
	if NOT ERRORLEVEL 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if ERRORLEVEL 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Everyone 권한이 존재하지 않습니다.														>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
)

del %think%\result.txt 2>nul
chcp 437
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0201 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0202 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
set result0202=Default
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################            하드디스크 기본 공유 제거          ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 기본공유 항목(C$, D$)이 존재하지 않고 AutoShareServer 레지스트리 값이 0일 경우 양호           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ 하드디스크 기본 공유 확인                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]"  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]" > nul
if %ERRORLEVEL% EQU 1 (
echo 기본 공유 폴더가 존재 하지 않습니다.													>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ Registry 설정								                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer" | %script%\awk -F" " {print$3} > defaultshare.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]" > nul
IF %ERRORLEVEL% EQU 0 (	
	set result02021=F
) else (
	set result02021=O
)

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer" | find "0" > nul
	if %ERRORLEVEL% EQU 0 (
		set result02022=O
		)
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer" | find "0" > nul
	if %ERRORLEVEL% EQU 1 (
		set result02022=F
		)
if not %result02021% == %result02022% (
	echo Result=F                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo Result=%result02021%                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0202 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0203 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################              불필요한 서비스 제거             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 시스템에서 필요하지 않는 취약한 서비스가 중지되어 있을 경우 양호                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (1) Alerter(서버에서 클라이언트로 경고메세지를 보냄)                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (2) Clipbook(서버내 Clipbook를 다른 클라이언트와 공유)                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (3) Messenger(Net send 명령어를 이용하여 클라이언트에 메시지를 보냄)          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (4) Simple TCP/IP Services(Echo, Discard, Character, Generator, Daytime, 등)  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr "Alerter ClipBook Messenger"                                             > %think%\service.txt
net start | find "Simple TCP/IP Services"                                                    >> %think%\service.txt

net start | findstr /I "Alerter ClipBook Messenger TCP/IP" service.txt > NUL
IF ERRORLEVEL 1 ECHO ☞ 불필요한 서비스가 존재하지 않음.                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF NOT ERRORLEVEL 1 (
echo ☞ 아래와 같은 불필요한 서비스가 발견되었음.                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type service.txt                                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /I "Alerter ClipBook Messenger TCP/IP" service.txt > NUL
IF ERRORLEVEL 1 ECHO Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF NOT ERRORLEVEL 1 echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0203 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0204 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             IIS 서비스 구동 점검             ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : IIS 서비스가 불필요하게 동작하지 않는 경우 양호(담당자 인터뷰)                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                
if exist iis-enable.txt (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-04-enable
) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=Disabled																		>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-04-end
)


:2-04-enable

echo [IIS Version 확인]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type iis-version.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:2-04-end

echo 0204 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0205 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################           IIS 디렉토리 리스팅 제거           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 기본 설정 및 사이트별 "디렉터리 검색" 설정이 False 이면 양호                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-05-enable
) else (
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-05-end
)

:2-05-enable

echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [기본 설정]                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config | find /i "directoryBrowse"             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config | find /i "directoryBrowse"             > %think%\result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs get W3SVC/EnableDirBrowsing  | find /i /v "Microsoft"      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs get W3SVC/EnableDirBrowsing  | find /i /v "Microsoft"      > %think%\result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 설정 확인                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%i in (website-name.txt) do (
		echo [WebSite Name] %%i                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%i | find /i "directoryBrowse"       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%i | find /i "directoryBrowse"      >> %think%\result.txt
		echo.                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | find /i "EnableDirBrowsing" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i/root | find /i "EnableDirBrowsing"         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i/root | find /i "EnableDirBrowsing"         >> %think%\result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo * 기본 설정이 적용되어 있음.                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)

type result.txt | find /i "true" > nul
if %errorlevel% equ 0 (
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=true												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=false												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:2-05-end
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul
echo 0205 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0206 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################               IIS CGI 실행 제한              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : C:\inetpub\scripts 와 C:\inetpub\cgi-bin 디렉터리를 사용하지 않는 경우 양호     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 사용 시 Everyone에 모든권한, 수정권한, 쓰기권한이 부여되어 있지 않은 경우 양호  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.06-end
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

IF EXIST C:\inetpub\scripts (
	cacls C:\inetpub\scripts                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls C:\inetpub\scripts                                                                 > %think%\result.txt
	echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) ELSE (
	echo C:\inetpub\scripts 디렉터리가 존재하지 않음.                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

IF EXIST C:\inetpub\cgi-bin (
	cacls C:\inetpub\cgi-bin                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls C:\inetpub\cgi-bin                                                                >> %think%\result.txt
) ELSE (
	echo C:\inetpub\cgi-bin 디렉터리가 존재하지 않음.                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\result.txt | find /i /v "(ID)R" | find /i "everyone" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:2.06-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0206 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0207 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################          IIS 상위 디렉토리 접근 금지         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : "상위 경로 사용" 옵션이 체크되어 있지 않을 경우 양호                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : (asp enableParentPaths="false" 인 경우 양호)                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-07-enable
) else (
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-07-end
)

:2-07-enable
echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [기본 설정]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" > nul
	IF NOT ERRORLEVEL 1 (
		%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" > %think%\result.txt
	) ELSE (
		echo * 설정값 없음 * 기본설정 : enableParentPaths=false                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs get W3SVC/AspEnableParentPaths  | find /i /v "Microsoft"    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs get W3SVC/AspEnableParentPaths  | find /i /v "Microsoft"    > %think%\result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 설정 확인                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%i in (website-name.txt) do (
		%systemroot%\System32\inetsrv\appcmd list config %%i /section:asp | find /i "enableParentPaths" > nul
		echo [WebSite Name] %%i                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		if not errorlevel 1 (
			%systemroot%\System32\inetsrv\appcmd list config %%i /section:asp | find /i "enableParentPaths" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%i /section:asp | find /i "enableParentPaths" >> %think%\result.txt
			echo.                                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo * 설정값 없음 * 기본설정 : enableParentPaths=false                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | find /i "AspEnableParentPaths" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i/root | find /i "AspEnableParentPaths"     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i/root | find /i "AspEnableParentPaths"     >> %think%\result.txt
			echo.                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo AspEnableParentPaths : * 기본 설정이 적용되어 있음.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)



type result.txt | find /i "true" > nul
if %errorlevel% equ 0 (
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=true												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=false												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:2-07-end
del %think%\result.txt 2>nul
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0207 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0208 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################            IIS 불필요한 파일 제거            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : IISSamples, IISHelp 가상디렉터리가 존재하지 않을 경우 양호                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 		 (IIS 7.0 이상 버전 해당 사항 없음)						                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-08-enable
) else (
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-08-end
)

:2-08-enable
echo [가상 디렉터리 설정 현황]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	echo ☞ IIS 7.0 이상 버전 해당 사항 없음							                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

::20160114 수정함(해당사항 없음으로 변경함)
::if %iis_ver_major% geq 7 (
	::%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "virtualdirectory" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)

::20160114 수정함(IISSample 등 없는지 판단가능하게 변경함)
:: iis ver <= 6
::if %iis_ver_major% leq 6 (
	::%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)

if %iis_ver_major% leq 6 (
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | findstr "IISSamples IISHelp" >> %think%\sample-app.txt
	type sample-app.txt                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	findstr "IISSamples IISHelp" sample-app.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * 점검결과: IISSamples, IISHelp 가상디렉터리가 존재하지 않음.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
	)	ELSE (
		ECHO * 점검결과: IISSamples, IISHelp 가상디렉터리가 존재함.                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt				
	)
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:2-08-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0208 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0209 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################          IIS 웹 프로세스 권한 제한           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : IIS 서비스 동작 계정이 관리자 계정으로 등록되어 있지 않으면 양호                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.09-end
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [World Wide Web Publishing Service 동작 계정]                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\ObjectName"                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\ObjectName"                 >> %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [IIS Admin Service 동작 계정]                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN\ObjectName"              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN\ObjectName"              >> %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\result.txt | find "LocalSystem" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:2.09-end
del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0209 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0210 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################               IIS 링크 사용금지              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 웹 사이트 홈디렉터리에 심볼릭 링크, aliases, *.lnk 파일이 존재하지 않으면 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-10-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-10-end
)

:2-10-enable
echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: iis ver >= 7
if %iis_ver_major% geq 7 (
	echo [홈디렉토리 정보 - WEB/FTP 구분용]                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol physicalpath" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 불필요 파일 체크                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f "delims=" %%a in (website-physicalpath.txt) do (
	echo [Website HomeDir] %%a                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cd /d %%a			2>nul
	attrib /s | find /i ".lnk"                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	attrib /s | find /i ".lnk"                                                                >> %think%\%result.txt
	cd /d %think%
	echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ※ 결과 값이 존재하지 않으면 양호                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\result.txt | find ".lnk" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


:2-10-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul
echo 0210 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0211 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################       IIS 파일 업로드 및 다운로드 제한       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 웹 서비스의 서버 자원관리를 위해 업로드 및 다운로드 용량을 제한한 경우 양호     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 참고 : 7.0이상(maxAllowedContentLength: 콘텐츠 용량 제한 설정 /Default: 30MB)                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 7.0이상(MaxRequestEntityAllowed: 파일 업로드 용량 제한 설정 /Default: 200000 bytes)    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 7.0이상(bufferingLimit: 파일 다운로드 용량 제한 설정 /Default: 4MB(4194304 bytes))     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 6.0이하(AspMaxRequestEntityAllowed : 업로드 용량 제한 설정 /Default: 200KB(204800 byte)) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 6.0이하(AspBufferingLimit : 다운로드 용량 제한 설정 /Default: 4MB(4194304 byte)) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-11-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
	goto 2-11-end
)

:2-11-enable
echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [기본 설정]                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config | findstr /i "maxAllowedContentLength maxRequestEntityAllowed bufferingLimit" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum W3SVC | findstr /i "AspMaxRequestEntityAllowed AspBufferingLimit" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo * 값이 없을 경우 기본 설정이 적용되어 있음.                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 설정 확인                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%a in (website-name.txt) do (
		echo [WebSite Name] %%a                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%a | findstr /i "maxAllowedContentLength maxRequestEntityAllowed bufferingLimit" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo * 값이 없을 경우 기본 설정이 적용되어 있음.                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i | find /i "AspMaxRequestEntityAllowed" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i | find /i "AspMaxRequestEntityAllowed"  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo AspMaxRequestEntityAllowed : * 기본 설정이 적용되어 있음.                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
		cscript %script%\adsutil.vbs enum %%i | find /i "AspBufferingLimit" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i | find /i "AspBufferingLimit"           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo AspBufferingLimit          : * 기본 설정이 적용되어 있음.                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)

echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:2-11-end
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0211 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0212 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################           IIS DB 연결 취약점 점검            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 7.0이상- 요청 필터링에서 .asa, .asax 확장자가 False로 설정되어 있으면 양호     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   요청 필터링에서 .asa, .asax 확장자가 True로 설정되어 있을 경우        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   .asa, .asax 매핑이 등록되어 있어야 양호                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   (만약, Global.asa 파일을 사용하지 않는 경우 해당 사항 없음.)           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                 > (1) fileExtension=".asa" allowed="false" 이면 양호                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                 > (2) fileExtension=".asa" allowed="true" 이면, .asa 맵핑 확인           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo   	    : 6.0이하- .asa 매핑이 존재할 경우 양호                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   (설정 예) ".asa,C:\WINDOWS\system32\inetsrv\asp.dll,5,GET,HEAD,POST,TRACE" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                    GET,HEAD,POST,TRACE 동사: 다음으로 제한								 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-12-enable
) else (
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
	goto 2-12-end
)

:2-12-enable
echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [기본 설정]                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config | find /i ".asa" | find /i /v "httpforbiddenhandler" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum W3SVC | find /i ".asa"                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 설정 확인                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%a in (website-name.txt) do (
		echo [WebSite Name] %%a                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%a | find /i ".asa" | find /i /v "httpforbiddenhandler" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | find /i ".asa" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i/root | find /i ".asa"                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			cscript %script%\adsutil.vbs enum %%i/root | find /i "ScriptMaps" > nul
			if not errorlevel 1 (
				echo .asa 맵핑이 등록되어 있지 않음. [취약]                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				echo.                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			) else (
				echo * 기본 설정이 적용되어 있음.                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				echo.                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			)
		)
	)
)
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
:2-12-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0212 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0213 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################            IIS 가상 디렉토리 삭제            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 해당 웹사이트에 IIS Admin, IIS Adminpwd 가상 디렉터리가 존재하지 않을 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo        : IIS 6.0 이상 버전 해당 사항 없음 												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-13-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-13-end
)

:2-13-enable
echo [가상 디렉터리 설정 현황]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem ##########20160114 6.0 이상 해당 사항 없음으로 소스 수정 시작##########
:: iis ver >= 6
if %iis_ver_major% geq 6 (
echo ☞ IIS 6.0 이상 버전 해당 사항 없음 												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2-13-end
)

:: iis ver < 5
if %iis_ver_major% lss 5 (
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %think%\result.txt
)
type %think%\result.txt | find /i "IIS" | findstr /I "Admin Adminpwd" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem ##########20160114 6.0 이상 해당 사항 없음으로 소스 수정 끝##########


rem ##########20160114 6.0 이상 해당 사항 없음으로 소스 삭제 시작##########
:: iis ver >= 7
::if %iis_ver_major% geq 7 (
	::%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "virtualdirectory" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)
:: iis ver <= 6
::if %iis_ver_major% leq 6 (
	::%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)
rem ##########20160114 6.0 이상 해당 사항 없음으로 소스 삭제 끝##########
del %think%\result.txt 2>nul
:2-13-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0213 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0214 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################           IIS 데이터 파일 ACL 적용           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 홈 디렉터리 내에 있는 파일들에 대해 Everyone 권한이 존재하지 않을 경우 양호   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : (정적컨텐트 파일은 Read 권한만)                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-14-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-14-end
)

:2-14-enable
echo [등록 사이트]                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 파일 Everyone 권한 체크                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo (exe, dll, cmd, pl, asp, inc, shtm, shtml, txt, gif, jpg, html)                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f "delims=" %%a in (website-physicalpath.txt) do (
	echo [Website HomeDir] %%a                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	echo -----------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cd /d %%a 2> nul																				
	cd 2> nul
	cacls *.exe /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.dll /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.cmd /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.pl /t | find /i "everyone"                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.asp /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.inc /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.shtm /t | find /i "everyone"                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.shtml /t | find /i "everyone"                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.txt /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.gif /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.jpg /t | find /i "everyone"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.html /t | find /i "everyone"                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.exe /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.dll /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.cmd /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.pl /t | find /i "everyone"                                                       >> %think%\result.txt 2> nul
	cacls *.asp /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.inc /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.shtm /t | find /i "everyone"                                                     >> %think%\result.txt 2> nul
	cacls *.shtml /t | find /i "everyone"                                                    >> %think%\result.txt 2> nul
	cacls *.txt /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.gif /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.jpg /t | find /i "everyone"                                                      >> %think%\result.txt 2> nul
	cacls *.html /t | find /i "everyone"                                                     >> %think%\result.txt 2> nul
	cd /d %think% 2> nul
	echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) 2> nul
echo ※ 결과 값이 존재하지 않으면 양호                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\result.txt | find /i "everyone" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:2-14-end
del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0214 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0215 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################         IIS 미사용 스크립트 매핑 제거        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 아래와 같은 취약한 매핑이 존재하지 않을 경우 양호(Windows 20003 이후 버전은 패치가 되어 양호함)                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : (.htr .idc .stm .shtm .shtml .printer .htw .ida .idq)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-15-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-15-end
)

:2-15-enable
if %WinVer% geq 2 (
	echo ☞ Windows 2003 이후 버전은 패치가 되어 해당사항 없음							>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-15-end
) else (
	echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	:: iis ver >= 7
	if %iis_ver_major% geq 7 (
		type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	:: iis ver <= 6
	if %iis_ver_major% leq 6 (
		type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	:: iis ver >= 7
	if %iis_ver_major% geq 7 (
		echo [미사용 스크립트 매핑 확인]                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config | find /i "scriptprocessor" | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ※ 결과 값이 존재하지 않으면 양호                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

	:: iis ver <= 6
	if %iis_ver_major% leq 6 (
		echo [기본 설정]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum W3SVC | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum W3SVC | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\result.txt
		echo ※ 결과 값이 존재하지 않으면 양호                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

		echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo *** 사이트별 설정 확인                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
			echo [WebSite AppRoot] %%i                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo -----------------------------------------------------------------------        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i/root | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" > nul
			if not errorlevel 1 (
				cscript %script%\adsutil.vbs enum %%i/root | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				cscript %script%\adsutil.vbs enum %%i/root | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\result.txt
				echo.                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			) else (
				cscript %script%\adsutil.vbs enum %%i/root | find /i "ScriptMaps" > nul
				if not errorlevel 1 (
					echo * 취약한 맵핑이 등록되어 있지 않음. [양호]                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
					echo.                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				) else (
					echo * 기본 설정이 적용되어 있음.                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
					echo.                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				)
			)
		)
	)
)

type %think%\result.txt | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


del %think%\result.txt 2>nul
:2-15-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0215 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0216 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################         IIS Exec 명령어 쉘 호출 진단         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 해당 서비스의 레지스트리 값이 0일 경우 양호                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : (참고1) IIS 5.0 버전에서 해당 레지스트리 값이 없을 경우 양호                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : (참고2) IIS 6.0 이상 양호                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-16-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-16-end
)

:2-16-enable
:: iis ver >= 6
if %iis_ver_major% geq 6 (
	echo ☞ IIS 6.0 이상 양호			                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-16-end
)

:: iis ver < 6
if %iis_ver_major% lss 6 (
	echo [Registry 설정] 			                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\SSIEnableCmdDirective" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\SSIEnableCmdDirective" >> %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


type %think%\result.txt | find /V "0" | findstr /i "SSIEnableCmdDirective" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
del %think%\result.txt 2>nul

:2-16-end
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0216 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0217 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################              IIS WebDAV 비활성화              ##################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : 다음 중 한 가지라도 해당되는 경우 양호                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 1. IIS 를 사용하지 않을 경우                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 2. DisableWebDAV 값이 1로 설정되어 있을경우                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 3. Windows NT, 2000은 서비스팩 4 이상이 설치되어 있을 경우                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 4. Windows 2003, Windows 2008은 WebDAV 가 금지 되어 있을 경우                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 참고 : "0,C:\WINDOWS\system32\inetsrv\httpext.dll,0,WEBDAV,WebDAV" (WebDAV 금지-양호) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : "1,C:\WINDOWS\system32\inetsrv\httpext.dll,0,WEBDAV,WebDAV" (WebDAV 허용-취약) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 2008 이상인 경우 allowed="false"   (WebDAV 금지-양호) 						>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 2008 이상인 경우 allowed="True"    (WebDAV 허용-취약) 						 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-17-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-17-end
)

:2-17-enable

:: winver = 2000
if %WinVer% equ 1 (
	ECHO ☞ Win 2000일 경우 서비스팩 4 이상 양호                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "kernel version"                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack"                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}	> %think%\result.txt
	goto 2.17-2000
	echo.
)

:: iis ver =< 6
if %iis_ver_major% leq 6 (
	echo [WebDAV 동작 확인]                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\adsutil.vbs enum W3SVC | find /i "webdav" | find /v "WebDAV;WEBDAV"            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\adsutil.vbs enum W3SVC | find /i "webdav" | find /v "WebDAV;WEBDAV"            > %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.17-2003
)


:: iis ver >=7
if %iis_ver_major% geq 6 (
	echo [WebDAV 동작 확인]                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:isapiCgiRestriction | find /i "webdav" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:isapiCgiRestriction | find /i "webdav" > %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.17-2008
)

:2.17-2003
type result.txt | find "1," >nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2-17-end
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2-17-end



:2.17-2008	
type result.txt | find /i "true" >nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2-17-end
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2-17-end


:2-17-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [참고 - Registry 설정(DisableWebDAV)]                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\registry\DisableWebDAV" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\DisableWebDAV"  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ※ 결과 값이 존재하지 않을 경우 다른 참고정보 검토                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [참고 - OS Version, Service Pack]                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	type systeminfo.txt | find /i "kernel version"                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack"                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:: winver >= 2003
if %WinVer% geq 2 (
	type systeminfo.txt | find /i "os name"                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios"                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul
echo 0217 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0218 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################         NetBIOS 바인딩 서비스 구동 점검       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: TCP/IP와 NetBIOS 간의 바인딩이 제거 되어있는 경우 양호                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (NetBIOS 사용 안함 설정: NetbiosOptions 0x2 양호)                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (NetBIOS 사용 설정: NetbiosOptions 0x1 취약)                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (기본 값: NetbiosOptions 0x0 취약)                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (수동점검 방법) 인터넷 프로토콜(TCP/IP)의 등록정보 ▶ 고급 ▶ Wins 탭의 TCP/IP에서 NetBIOS 사용 안함 (139포트차단) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" | findstr /iv "listing" > 2-18-netbios-list.txt
	for /f "tokens=1 delims=[" %%a in (2-18-netbios-list.txt) do echo %%a >> 2-18-netbios-list-1.txt
	for /f "tokens=1 delims=]" %%a in (2-18-netbios-list-1.txt) do echo %%a >> 2-18-netbios-list-2.txt
	FOR /F %%a IN (2-18-netbios-list-2.txt) do echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\%%a\NetbiosOptions >> 2-18-netbios-query.txt
	FOR /F %%a IN (2-18-netbios-query.txt) do %script%\reg query %%a >> 2-18-netbios-result.txt
	echo [NetBIOS over TCP/IP 설정 현황]                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	TYPE 2-18-netbios-result.txt	                            							>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
)
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0218 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0219 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #########################        FTP 서비스 구동 점검          ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : FTP 서비스를 사용하지 않는 경우 양호 (이용 목적은 담당자인터뷰)                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo ☞ FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-19-enable
) else (
	echo ☞ FTP Service Disable                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-19-end
)

:2-19-enable


echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	type ftpsite-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	type ftpsite-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:2-19-end
echo 0219 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0220 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################        FTP 디렉토리 접근권한 설정          ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : FTP 홈 디렉터리에 Everyone의 접근 권한이 존재하지 않으면 양호				              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo ☞ FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-20-enable
) else (
	echo ☞ FTP Service Disable                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-20-end
)


:2-20-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ 윈도우 기본 FTP외 타 FTP 서비스 사용중 (수동확인^)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-20-end
)
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [등록 사이트]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	type ftpsite-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	type ftpsite-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	echo [홈디렉토리 정보 - WEB/FTP 구분용]                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol physicalpath" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 홈디렉토리 접근권한 확인                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f "delims=" %%a in (ftpsite-physicalpath.txt) do (
	echo [FtpSite HomeDir] %%a                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cacls %%a                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cacls %%a                                                                          >> %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\result.txt | findstr /i "everyone" > nul
if %ERRORLEVEL% NEQ 0 (
 echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
if %ERRORLEVEL% EQU 0 (
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
del %think%\result.txt 2>nul



:2-20-end
echo 0220 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0221 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###########################         Anonymous FTP 금지          ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : FTP를 사용하지 않거나 "익명 연결 허용"이 체크되어 있지 않은 경우 양호(Default : 사용 안 함)          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 참고 : metabase.xml 파일 기준 설명        											 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : IIsFtpService	Location ="/LM/MSFTPSVC" 는 FTP 사이트 기본 설정                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : FTP 사이트를 새로 생성 시 해당 기본 설정을 적용 받음.							 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : IIsFtpServer	Location ="/LM/MSFTPSVC/ID"는 FTP 사이트에 등록된 개별 사이트 설정 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 개별 사이트에 AllowAnonymous 설정이 없으면 FTP 사이트 기본 설정을 적용 받음   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : IIsFtpServer	Location ="/LM/MSFTPSVC/~/Public FTP Site"는 진단 시 고려하지 안함 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo ☞ FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-enable
) else (
	echo ☞ FTP Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-end
)

:2-21-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ 윈도우 기본 FTP외 타 FTP 서비스 사용중                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-end
)

echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (


	type ftpsite-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [FTP 서버 설정 확인]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol anonymousAuthentication enabled" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol anonymousAuthentication enabled" > %think%\result.txt
	echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-218-enable	
) 
	type ftpsite-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [기본 설정]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "AllowAnonymous"                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "AllowAnonymous"                   > %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo *** 사이트별 설정 확인                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	for /f "tokens=1 delims=[]" %%i in (ftpsite-list.txt) do (
		echo [FtpSite AppRoot] %%i                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i | find /i "AllowAnonymous" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i | find /i "AllowAnonymous"                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i | find /i "AllowAnonymous"                 > %think%\result.txt
			echo.                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			goto 2-213-enable
		) 
			echo AllowAnonymous : 기본 설정이 적용되어 있음.                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo AllowAnonymous : 기본 설정이 적용되어 있음.                                 > %think%\result.txt
			echo.                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 2-213-enable
	)


::7이상
:2-218-enable
type %think%\result.txt | find /i "anonymousAuthentication" | find /i "true" > nul
::echo %errorlevel%
if %errorlevel% neq 0 (
	echo Result=false												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-end
) else (
	echo Result=true												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-end
)



:2-213-enable
::6미만
type %think%\result.txt | find /i "AllowAnonymous" | find /i "True" > nul
if %errorlevel% neq 0 (
 echo Result=false												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-end
)
echo Result=true												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt



:2-21-end
del %think%\result.txt 2>nul
echo 0221 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0222 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###########################        FTP 접근 제어 설정          ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준 : FTP 서비스에 접근제한 설정이 되어 있는 경우 양호				                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 참고 : metabase.xml 파일 기준 설명        												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : IIsFtpService	Location ="/LM/MSFTPSVC" 는 FTP 사이트 기본 설정               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : IIsFtpVirtualDir	Location ="/LM/MSFTPSVC/ID/ROOT"는 FTP 개별 사이트 설정      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 개별 사이트에 IPSecurity 설정이 없으면 FTP 사이트 기본 설정을 적용 받음       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : IPSecurity="" 접근제어 없음, IPSecurity="0102~" 접근제어 설정 있음.           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 마지막에 사이트명이 붙지 않은 설정 내용은 점검시 고려 안함.                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : 2008이상 ipSecurity allowUnlisted 설정이 False로 되어야 양호                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■      : ipSecurity allowUnlisted True경우 액세스 허용 / False 경우 액세스 거부         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo ☞ FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-22-enable
) else (
	echo ☞ FTP Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-22-end
)

:2-22-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo ☞ 윈도우 기본 FTP외 타 FTP 서비스 사용중 (수동확인^)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-22-end
)
echo [등록 사이트]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	type ftpsite-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	type ftpsite-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo *** 사이트별 FTP 접근제어 설정 확인                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	
	for /f "delims=" %%a in (ftpsite-name.txt) do (
		%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipAddress" > nul
		echo [FTP-Site Name] %%a                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		if not errorlevel 1 (
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipAddress" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipAddress" >> %think%\result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipSecurity AllowUnlisted" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipSecurity AllowUnlisted" >> %think%\result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo * 접근제한 설정 없음                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			)
		)
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	echo [FTP 접근제어 설정]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\ftp_ipsecurity.vbs >nul
	type ftp-ipsecurity.txt                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)



if %iis_ftp_ver_major% geq 7 (
	goto 2-227-enable
) 
if %iis_ftp_ver_major% leq 6 (
	goto 2-226-enable
)

:2-227-enable
type %think%\result.txt | find "ipSecurity allowUnlisted" | find "true" > nul
	if %ERRORLEVEL% NEQ 0 (
		echo Result=false												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if %ERRORLEVEL% EQU 0 (
		echo Result=true												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
del %think%\result.txt 2>nul	
goto 2-22-end

:2-226-enable
type ftp-ipsecurity.txt | find "SiteName" | find "Access Allow" > nul
		if %ERRORLEVEL% NEQ 0 (
			echo Result=false												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
		if %ERRORLEVEL% EQU 0 (
			echo Result=true												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)	
)
del %think%\ftp-ipsecurity.txt 2>nul

:2-22-end
echo 0222 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0223 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             DNS Zone Transfer 설정            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: DNS 서비스 설정이 아래 기준 중 하나라도 해당되는 경우 양호(SecureSecondaries 2) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (1) DNS 서비스를 사용하지 않을 경우                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (2) 영역 전송 허용을 하지 않을 경우                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (3) 특정 서버로만 영역 전송을 허용하는 경우                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : * 레지스트리값(영역전송 허용안함:3, 아무서버로나:0, 이름서버탭에나열된 서버로만:1, 다음서버로만:2 ) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : [참고]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 결과 값이 없을 경우 DNS 서버에 등록된 정/역방향 조회 영역이 없는 것으로,      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : DNS 서비스를 사용하지 않을 경우 서비스를 중지할 것을 권고                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "DNS Server" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ DNS Service Enable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO ☞ DNS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
	goto 0223-end
	echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


:: winver < 2008R2
if %WinVer% leq 3 (
goto 0223-2008
)

:: winver > 2008
if %WinVer% geq 4 (
 goto 0223-2008R2
)


:0223-2008
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF %ERRORLEVEL% NEQ 0 (
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\result.txt
	) else (
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\result.txt
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type %think%\result.txt | %script%\awk -F" " {print$3} | find "0" > nul
	if %ERRORLEVEL% NEQ 0 (
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0223-end
	)
	if %ERRORLEVEL% EQU 0 (
		echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0223-end
	)
)

:0223-2008R2
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF %ERRORLEVEL% NEQ 0 (
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\result.txt
	) else (
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %think%\result.txt
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type %think%\result.txt | find "0x0" > nul
	if %ERRORLEVEL% NEQ 0 (
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0223-end
	)
	if %ERRORLEVEL% EQU 0 (
		echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0223-end
	)
)

:0223-end
del %think%\result.txt 2>nul	
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0223 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0224 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################         RDS (Remote Data Services) 제거       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 다음의 중 한가지라도 해당되는 경우 양호                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (1) IIS 를 사용하지 않는 경우                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (2) Windows 2000 sp4, Windows 2003 sp2, Windows 2008 이상 양호  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (3) 디폴트 웹사이트에 MSADC 가상 디렉터리가 존재하지 않을 경우                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (4) 해당 레지스트리 값이 존재하지 않을 경우                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.24-end
)

:: OS Version, Service Pack 버전 체크
echo [OS Version 확인]                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
:: winver = 2000
if %WinVer% equ 1 (
	ECHO ☞ Win 2000일 경우 서비스팩 4 이상 양호                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "kernel version"                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack"                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}	> %think%\result.txt
	goto 2.24-2000
	echo.
)

:: winver >= 2003
if %WinVer% geq 2 (
	ECHO ☞ Windows 2003 sp2 이상, Windows 2008 이상 양호                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os name"                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios"                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if %WinVer% EQU 2 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}     > %think%\result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.24-2003
	)

if %WinVer% geq 3 (
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.24-end
	)

:2.24-2000
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2.24-2003-0
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 4 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2.24-end
)

:2.24-2003-0	
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | find /i "msadc" >> %think%\msadcdir.txt
	type msadcdir.txt                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	find /i "msadc" msadcdir.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * 점검결과: MSADC 가상디렉터리가 존재하지 않음.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 2.24-end
)

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" /s | findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" >> %think%\RDSREG.txt
type %think%\RDSREG.txt                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" RESREG.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * 점검결과: 등록된 REG값이 존재하지 않음.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 2.24-end
)

		echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 2.24-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:2.24-2003

type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2.24-2003-1
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 2 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 2.24-end
)

:2.24-2003-1

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | find /i "msadc" >> %think%\msadcdir.txt
	type msadcdir.txt                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	find /i "msadc" msadcdir.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * 점검결과: MSADC 가상디렉터리가 존재하지 않음.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 2.24-end
)

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" /s | findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" >> %think%\RDSREG.txt
type %think%\RDSREG.txt                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" RESREG.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * 점검결과: 등록된 REG값이 존재하지 않음.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 2.24-end
)

		echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 2.24-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	

	
:2.24-end	
del %think%\result.txt 2>nul
del %think%\msadcdir.txt 2>nul
del %think%\RDSREG.txt 2>nul

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0224 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0225 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################               최신 서비스팩 적용              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 최신 서비스팩이 설치되어 있을 경우 양호                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (Windows NT 6a, Windows 2000 SP4, Windows 2003 SP2, Windows 2008 SP2)         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (Windows 2008R2 SP1, Windows 2012, 2012r2는 SP이 없음) 						 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | find "Microsoft"                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | find "Pack"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [OS Version 확인]                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
:: winver = 2000
if %WinVer% equ 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %think%\result.txt
	echo.
	goto 0225-2000
)

:: winver = 2003
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if %WinVer% EQU 2 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %think%\result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0225-2003
	)

:: winver = 2008
if %WinVer% EQU 3 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %think%\result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0225-2008
	)

:: winver = 2008R2
if %WinVer% EQU 4 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %think%\result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0225-2008R2
	)
	
:: winver = 2012&2012R2
if %WinVer% GEQ 5 (
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0225-end
	)

:0225-2000
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 4 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end

:0225-2003
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 2 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end

:0225-2008
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 2 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end

:0225-2008R2
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 1 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end
)
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0225-end

:0225-end	
del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0225 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0226 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################         터미널 서비스 암호화 수준 설정        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 터미널 서비스를 사용하지 않는 경우 양호                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 터미널 서비스를 사용 시 암호화 수준을 "클라이언트와 호환가능(중간)" 이상으로 설정한 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (MinEncryptionLevel	2 이상이면 양호)                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2008_R2
if %WinVer% geq 4 (
	goto 2-262-enable
) else (
	goto 2-268-enable
)

:2-262-enable
net start | find /i "Remote Desktop Services" >nul
	IF NOT ERRORLEVEL 1 (
		echo ☞ Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ☞ 원격 터미널 서비스 암호화 수준 설정 확인                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo --------------------------------------------------------------------------------- >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" | %script%\awk -F" " {print$3}	> %think%\result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                     
		)
	IF ERRORLEVEL 1 (
		echo ☞ Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=2												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)

goto 2-26-end

:2-268-enable
NET START | FIND "Terminal Service" > NUL
	IF NOT ERRORLEVEL 1 (
		echo ☞ Terminal Service Enable                                          			>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ☞ 원격 터미널 서비스 암호화 수준 설정 확인                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo --------------------------------------------------------------------------------- >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" | %script%\awk -F" " {print$3}	> %think%\result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	IF ERRORLEVEL 1 (
		echo ☞ Terminal Service Disable                                             		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=2												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)

:2-26-end

	


del %think%\result.txt 2>nul

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0226 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0227 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             IIS 웹서비스 정보 숨김            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 등록된 웹 사이트의 [사용자 지정 오류] 탭에서                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 400, 401, 403, 404, 500 에러에 대해 별도의 페이지가 지정되어 있는 경우 양호   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::echo ■       : (취약 예문) prefixLanguageFilePath="%SystemDrive%\inetpub\custerr" path="401.htm" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem 기본 설정이기 때문에 위 설정은 취약함.
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "World Wide Web Publishing Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ IIS Service Enable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 1-45-enable
)	ELSE (
	ECHO ☞ IIS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 46
)

:1-45-enable
echo [등록 사이트]                                                                        	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [기본 설정]                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\APPCMD list config | findstr "<error"                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:: iis ver <= 6
if %iis_ver_major% leq 6 (
cscript %script%\adsutil.vbs enum W3SVC | findstr "400, 401, 403, 404, 500,"                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** 사이트별 설정 확인                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%i in (website-name.txt) do (
			echo [WebSite Name] %%i                                          						>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo ---------------------------------------------------------------                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%i | findstr "<error" 				>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)

:: iis ver <= 6
if %iis_ver_major% leq 6 (
	FOR /F "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------------------------               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | findstr "400, 401, 403, 404, 500," > nul
		IF NOT ERRORLEVEL 1 (
			cscript %script%\adsutil.vbs enum %%i/root | findstr "400, 401, 403, 404, 500,"          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) ELSE (
			echo 기본 설정이 적용되어 있음.                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)
echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:46
echo 0227 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0228 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             SNMP 서비스 구동 점검             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: SNMP 서비스를 불필요하게 사용하지 않으면 양호                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : SNMP 서비스는 구동되고 있으나 SNMP 설정이 없는 경우 불필요하게 동작되고 있는 것으로 판단됨. >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ SNMP Service Enable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO ☞ SNMP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities 설정]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP Trap 설정]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0228 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0229 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################    SNMP 서비스 커뮤니티스트링의 복잡성 설정   ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: SNMP Community 이름이 public, private 이 아닌 유추하기 어렵게 설정되어 있으면 경우 양호                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (참고1) REG_DWORD Community String 숫자                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (참고2) 숫자: 2=알림, 4=읽기전용, 8=읽기와 쓰기, 16=읽기와 만들기             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ SNMP Service Enable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO ☞ SNMP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 29-end
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities 설정]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type result.txt | findstr /i "REG_DWORD" > nul
if %ERRORLEVEL% neq 0 (
	echo "string 값이 설정되어 있지 않음(N/A)"                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo "서비스 중지 권고"                                                						   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [SNMP Trap Commnunities 설정]                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 29-end
	)


echo [SNMP Trap Commnunities 설정]                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


type result.txt | findstr /i "public private" > nul
	if %ERRORLEVEL% equ 0 (
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if %ERRORLEVEL% neq 0 (
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
	
	

:29-end
del %think%\result.txt 2>nul
echo 0229 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0230 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################            SNMP Access Control 설정           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 특정 호스트만 SNMP 패킷을 받을 수 있도록 SNMP Access Control이 설정된 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (PermittedManagers 설정이 있으면 양호)                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (PermittedManagers 설정이 없으면 모든 호스트에서 SNMP 패킷을 받을 수 있어 취약) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ SNMP Service Enable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)	ELSE (
	ECHO ☞ SNMP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 30-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities 설정]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\result.txt
type %think%\result.txt | findstr /i "REG_DWORD" > nul
if %ERRORLEVEL% neq 0 (
	echo "string 값이 설정되어 있지 않음(N/A)"                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo "서비스 중지 권고"                                                						   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 30-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP Access Control 설정]                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" | findstr . > %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\result.txt | findstr /i "REG_SZ" > nul
	if %ERRORLEVEL% EQU 0 (
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if %ERRORLEVEL% NEQ 0 (
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:30-end

del %think%\result.txt 2>nul
echo 0230 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0231 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################              DNS 서비스 구동 점검             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: DNS 서비스를 사용 하지 않거나 동적 업데이트 설정이 "없음"으로 설정된 경우 양호  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (AllowUpdate	0 이면 양호)                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : [참고]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 결과 값이 없을 경우 DNS 서버에 등록된 정/역방향 조회 영역이 없는 것으로,      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : DNS 서비스를 사용하지 않을 경우 서비스를 중지할 것을 권고                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 윈도우2008이상에서 결과 값이 없을 경우 디폴트로 없음으로 설정                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "DNS Server" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ DNS Service Enable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-enable
)	ELSE (
	ECHO ☞ DNS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-end
)
:dns-enable
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr "AllowUpdate" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr "AllowUpdate" >> %think%\result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-result1
	)


:: 2003 이상 검색
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr . | find /v "Listing of" | find /v "system was unable" > nul
	IF %ERRORLEVEL% neq 0 (
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr "AllowUpdate" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr "AllowUpdate" >> %think%\result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr "AllowUpdate" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr "AllowUpdate" >> %think%\result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

:dns-result
	type %think%\result.txt | findstr /i "AllowUpdate" > nul
	if %ERRORLEVEL% neq 0 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-end
	)

:: winver < 2008R2
if %WinVer% leq 3 (
goto 0231-2008
)

:: winver > 2008
if %WinVer% geq 4 (
 goto 0231-2008R2
)


:0231-2008
type %think%\result.txt | findstr /i "AllowUpdate" | find "1" > nul
	if %ERRORLEVEL% neq 0 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-end
	) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:0231-2008R2
type %think%\result.txt | findstr /i "AllowUpdate" | findstr /i "0x1" > nul
	if %ERRORLEVEL% neq 0 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-end
	) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:dns-end
del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0231 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0232 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             HTTP/FTP/SMTP 배너 차단           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: HTTP/FTP/SMTP 배너에 시스템 정보가 표시되지 않는 경우 양호                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "World Wide Web Publishing Service" > NUL
IF NOT ERRORLEVEL 1 (
echo ---------------------------------HTTP Banner-------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\http_banner.vbs >nul
	type http_banner.txt								>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	del http_banner.txt 2>nul
)	ELSE (
	ECHO ☞ IIS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "ftp" > NUL
IF NOT ERRORLEVEL 1 (
echo -----------------------------------FTP Banner------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\ftp_banner.vbs >nul
	type ftp_banner.txt								>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	del ftp_banner.txt 2>nul
)	ELSE (
	ECHO ☞ FTP Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "smtp" > NUL
IF NOT ERRORLEVEL 1 (
echo ---------------------------------SMTP Banner-------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\smtp_banner.vbs >nul
	type smtp_banner.txt								>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	del smtp_banner.txt 2>nul
)	ELSE (
	ECHO ☞ SMTP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0232 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0233 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################                Telnet 보안 설정               ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: Telnet 서비스가 구동 되고 있지 않거나, 인증방법이 NTLM 일 경우 양호             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : [참고]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (SecurityMechanism 2. NTLM)                                            	 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (SecurityMechanism 6. NTLM, Password)                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (SecurityMechanism 4. Password)                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "telnet" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ TELNET Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-enable
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) ELSE (
	ECHO ☞ TELNET Service Disable 																	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
)

:telnet-enable
	%script%\reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr . | find /v "Listing of" | find /v "system was unable" > nul
	IF %ERRORLEVEL% neq 0 (
		reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %think%\result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %think%\result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
:: winver < 2008R2
if %WinVer% leq 3 (
goto 0233-2008
)

:: winver > 2008
if %WinVer% geq 4 (
 goto 0233-2008R2
)


:0233-2008
type %think%\result.txt | findstr /i "REG_DWORD" | find "2" > nul
	if %ERRORLEVEL% neq 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:0233-2008R2
type %think%\result.txt | findstr /i "REG_DWORD" | findstr /i "0x2" > nul
	if %ERRORLEVEL% neq 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	)
echo.  	
	
	
:telnet-end
del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0233 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0234 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ################# 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거 #################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 시스템 DSN 부분의 Data Source를 현재 사용하고 있는 경우 양호                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 시스템 DSN 부분의 Data Source가 사용하지 않는데 등록되어 있을 경우 취약       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" | find "REG_SZ"           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" | find "REG_SZ"                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ※ 결과 값이 없을 경우 불필요한 ODBC/OLE-DB가 존재하지 않음 							               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0234 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0235 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################          원격터미널 접속 타임아웃 설정        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 원격 터미널을 사용하지 않거나, 사용 시 Session Timeout이 설정되어 있는 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (MaxIdleTime 설정 확인 방법: 60000=1분, 300000=5분)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: winver <= 2008
if %WinVer% leq 3 (
	goto 35-2008
)

:: winver = 2008_R2
if %WinVer% equ 4 (
	goto 35-2008r2
)

:: winver >= 2012
if %WinVer% geq 5 (
	goto 35-2012
)



:35-2008
NET START > netstart.txt
type netstart.txt | FIND "Terminal Service" > NUL
	IF %ERRORLEVEL% neq 1 (
		echo ☞ Terminal Service Enable                                          			>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ☞ 원격 터미널 Session Timeout 설정                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /s | findstr "MaxIdleTime" > %think%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		type %think%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %think%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.
		) else (
		echo ☞ Terminal Service Disable                                             		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 35-end		
		)
goto 35-end



:35-2008R2
net start > netstart.txt
type netstart.txt | find /i "Remote Desktop Services" > nul
	IF %ERRORLEVEL% neq 1 (
		echo ☞ Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ☞ 원격 터미널 Session Timeout 설정                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /s | findstr "MaxIdleTime" > %think%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		type %think%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %think%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.        
		) else (
		echo ☞ Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 35-end		
		)
goto 35-end	


:35-2012
net start > netstart.txt
type netstart.txt | find /i "Remote Desktop Services" > nul
	IF %ERRORLEVEL% neq 1 (
		echo ☞ Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ☞ 원격 터미널 Session Timeout 설정                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /s | findstr "MaxIdleTime" > %think%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
		echo ☞ Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 35-end		
		)
		
	type %think%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD"	
		if %ERRORLEVEL% neq 0 (
		echo IdleTime 설정이 되어 있지 않습니다.					>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=0												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
		type %think%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %think%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.											>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
		
goto 35-end	

		
		
:35-end
echo.     																								>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul                                                                                   
del %think%\netstart.txt 2>nul                                                                                   
echo 0235 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0236 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ############### 예약된 작업에 의심스러운 명령이 등록되어 있는지 점검 ################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 예약된 작업에 의심스러운 명령이 등록되어 있지 않은 경우 양호                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2003
if %WinVer% geq 2 (
	echo ☞ 예약된 작업 확인                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	schtasks | findstr [0-9][0-9][0-9][0-9]      	                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ at 명령어로 등록한 작업 확인                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
at                                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2003
if %WinVer% geq 2 (
	echo [참고] schtasks 전체                                                      				 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	schtasks                 									                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0236 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0301 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################                최신 HOT FIX 적용              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 최신Hotfix 또는 PMS(Patch Management System) Agent가 설치되어 있을 경우 양호    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | findstr /i "hotfix kb"                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0301 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0302 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             백신 프로그램 업데이트            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 바이러스 백신 프로그램의 최신 엔진 업데이트가 설치되어 있는 경우 양호           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ 수동 점검 (백신 업데이트 일자 확인)                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0302 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0303 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################          정책에 따른 시스템 로깅 설정         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 이벤트 감사 설정이 아래와 같이 설정되어 있는 경우 양호                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (1) 로그온 이벤트, 계정 로그온 이벤트, 정책 변경 : 성공/실패 감사             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (2) 계정 관리, 디렉터리 서비스 액세스, 권한 사용 : 실패 감사                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\auditpol  | findstr "Logon Policy Directory Management Privilege"                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\auditpol  | findstr "Logon Policy Directory Management Privilege"                   > %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\auditpol  | findstr "Logon Policy"  							                 > %think%\result1.txt
%script%\auditpol  | findstr "Directory Management Privilege"          			         > %think%\result2.txt



type %think%\result.txt | find "No" > nul
if %errorlevel% equ 0 (
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 3-03end
)


type %think%\result1.txt | find /V "Success and Failure" > nul
if %errorlevel% equ 0 (
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 3-03end
)

type %think%\result2.txt | find /V "Success and Failure" | find /V "Failure" > nul
if %errorlevel% equ 0 (
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


:3-03end
del %think%\result.txt 2>nul
del %think%\result1.txt 2>nul
del %think%\result2.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0303 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0401 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################           로그의 정기적 검토 및 보고          ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 로그기록에 대해 정기적 검토, 분석, 리포트 작성 및 보고 등의 조치가 이루어지는 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ 수동 점검 (담당자 인터뷰 수행)                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0401 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0402 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################   원격으로 액세스할 수 있는 레지스트리 경로   ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: Remote Registry Service 가 중지되어 있을 경우 양호                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "Remote Registry" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO ☞ Remote Registry Service Enable                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO ☞ Remote Registry Service Disable                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "Remote Registry"                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0402 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0403 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################              이벤트 로그 관리 설정            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 최대 로그 크기 10240KB (10MB) 이상이고, Retention 7776000(90일) 이상이면 양호   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : "90일 이후 이벤트 덮어씀"으로 설정되어 있을 경우 양호(Windows2008 이상은 제외)                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (MaxSize 10485760 이상, Retention 7776000 이상)                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : Retention 0       = 필요한 경우 이벤트 덮어쓰기                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : Retention 7776000 = 다음보다 오래된 이벤트 덮어쓰기 (7776000 90일)            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : Retention -1      = 이벤트 덮어쓰지 않음(수동으로 로그 지우기)                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Application Log Size]                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application\MaxSize"     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Security Log Size]                                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security\MaxSize"        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [System Log Size]                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System\MaxSize"          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

::Win <= 2003
if %WinVer% leq 2 (
	echo [Application log Retention]                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application\Retention"   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [Security log Retention]                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security\Retention"      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [System log Retention]                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System\Retention"        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) ELSE (
		echo ☞ Windows2008 이상은 덮어쓰기 날짜 지정 불가			   	     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0403 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0404 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################      원격에서 이벤트 로그 파일 접근 차단      ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 로그 디렉터리의 권한에 Everyone 이 없는 경우 양호                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (1) 시스템 로그 디렉터리: %systemroot%\system32\config                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (2) IIS 로그 디렉터리: %systemroot%\system32\LogFiles                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config                                                           > %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo ☞ IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls %systemroot%\system32\logfiles                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls %systemroot%\system32\logfiles                                                         >> %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo ☞ IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0404-end
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type %think%\result.txt | find /I "everyone" > nul
	if %errorlevel% neq 0 (
	echo Everyone 권한이 존재하지 않습니다.                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
	echo 
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:0404-end

del %think%\result.txt 2>nul
echo 0404 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0501 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################               백신 프로그램 설치              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 바이러스 백신 프로그램이 설치되어 있는 경우 양호                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
set vaccine="kaspersky norton bitdefender turbo avast v3"

echo ☞ Process List                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for %%a IN (%vaccine%) DO (
type tasklist.txt | findstr /i %%a 															>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%b >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%c >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%d >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%e >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%f >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo. 																						 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ Service list                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for %%a IN (%vaccine%) DO (
net start | findstr /i %%a >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%b >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%c >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%d >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%e >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%f >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ※ 결과가 없는 경우 프로세스 목록 및 인터뷰를 통해 확인 필요                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0501 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0502 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################            SAM 파일 접근 통제 설정            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: SAM 파일 접근권한에 Administrator, System 그룹만 모든권한으로 등록된 경우 양호  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config\SAM							                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config\SAM							                             > %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\result.txt | find /V "NT AUTHORITY\SYSTEM" | find /V "BUILTIN\Administrators" | find "\" > nul
	if %errorlevel% neq 0 (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) 
	if %errorlevel% equ 0 (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
echo.                                                                              	     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul
echo 0502 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0503 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################                화면보호기 설정                ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 화면 보호기를 설정하고, 암호를 사용하며, 대기 시간이 10분일 경우 양호            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 참고: 레지스트리 값이 없을 경우 AD 또는 OS설치 후 설정을 하지 않은 경우임             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveActive"                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaverIsSecure"                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveTimeOut"                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [AD(Active Directory)일 경우 레지값]                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaverIsSecure" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaveTimeOut" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveActive"                             > %think%\result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaverIsSecure"                         >> %think%\result.txt
type %think%\result.txt | find /V "1" | find /I "REG_SZ" > nul
if %errorlevel% equ 0 (
	goto 5.03-start
	echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveTimeOut"                           > %think%\result.txt
type result.txt | %script%\awk -F" " {print$3}      						                >> %think%\result1.txt
for /f %%r in (result1.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 5.03-end
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:5.03-start
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaverIsSecure" > %think%\result.txt

type %think%\result.txt | find /V "0" | find /V "unable to find" | find /I "REG_SZ" > nul
	if %errorlevel% neq 0 (
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5.03-end
	)
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaveTimeOut" > %think%\result.txt
	type result.txt | %script%\awk -F" " {print$3}      						                >> %think%\result1.txt
	for /f %%r in (result1.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:5.03-end

del %think%\result.txt 2>nul
del %think%\result1.txt 2>nul
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0503 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0504 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################        로그온하지 않고 시스템 종료 허용       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "로그온 하지 않고 시스템 종료 허용"이 "사용안함"으로 설정되어 있는 경우 양호    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (ShutdownWithoutLogon	0 이면 양호)                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon" > nul
if %errorlevel% equ 0 (
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon" | %script%\awk -F" " {print$3}     >> %think%\result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
del %think%\result.txt 2>nul
echo 0504 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0505 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################     원격 시스템에서 시스템 강제 종료 차단     ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "원격 시스템에서 강제로 시스템 종료" 정책에 "Administrators"만 존재할 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (Administrators = *S-1-5-32-544)                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeRemoteShutdownPrivilege"                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeRemoteShutdownPrivilege" | %script%\awk -F= {print$2} >> %think%\result.txt
for /F "delims=, tokens=1-26" %%a in (result.txt) do (
	echo %%a  >> result2.txt 2> nul
	echo %%b  >> result2.txt 2> nul
	echo %%c  >> result2.txt 2> nul
	echo %%d  >> result2.txt 2> nul
	echo %%e  >> result2.txt 2> nul
	echo %%f  >> result2.txt 2> nul
	echo %%g  >> result2.txt 2> nul
	echo %%h  >> result2.txt 2> nul
	echo %%i  >> result2.txt 2> nul
	echo %%j  >> result2.txt 2> nul
	echo %%k  >> result2.txt 2> nul
	echo %%l  >> result2.txt 2> nul
	echo %%m  >> result2.txt 2> nul
	echo %%n  >> result2.txt 2> nul
	echo %%o  >> result2.txt 2> nul
	echo %%p  >> result2.txt 2> nul
	echo %%q  >> result2.txt 2> nul
	echo %%r  >> result2.txt 2> nul
	echo %%s  >> result2.txt 2> nul
	echo %%t  >> result2.txt 2> nul
	echo %%u  >> result2.txt 2> nul
	echo %%v  >> result2.txt 2> nul
	echo %%w  >> result2.txt 2> nul
	echo %%x  >> result2.txt 2> nul
	echo %%y  >> result2.txt 2> nul
	echo %%z  >> result2.txt 2> nul
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type %think%\result2.txt | find /V "Administrators" | find /V "S-1-5-32-544" | find /V "ECHO is off" > nul
if %errorlevel% equ 0 (
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt			
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul
del %think%\result2.txt 2>nul
echo 0505 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0506 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ################# 보안 감사를 로그할 수 없는 경우 즉시 시스템 종료 #################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "보안 감사를 로그할 수 없는 경우 즉시 시스템 종료" 정책이 "사용안함"으로 설정되어 있는 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (CrashOnAuditFail = 4,0 이면 양호)                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "CrashOnAuditFail"                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "CrashOnAuditFail" | %script%\awk -F= {print$2}       >> %think%\result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul
echo 0506 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0507 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################     SAM 계정과 공유의 익명 열거 허용 안 함    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "SAM 계정과 공유의 익명 열거 허용 안함" 정책이 "사용"이고,                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : "SAM 계정의 익명 열거 허용 안함" 정책이 "사용"으로 설정되어 있는 경우 양호    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (restrictanonymous	1 이고, RestrictAnonymousSAM	1 이면 양호)                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SAM 계정과 공유의 익명 열거 허용 안함 설정]                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA\restrictanonymous"             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SAM 계정의 익명 열거 허용 안함 설정]                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\System\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM"	         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA\restrictanonymous" | %script%\awk -F" " {print$3}       > %think%\result.txt
for /f %%r in (result.txt) do set restrict=%%r


%script%\reg query "HKLM\System\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM"	| %script%\awk -F" " {print$3}         > %think%\result.txt
for /f %%s in (result.txt) do echo Result=%restrict%:%%s												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\result.txt 2>nul
echo 0507 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0508 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################              Autologon 기능 제어              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: AutoAdminLogon 값이 없거나, AutoAdminLogon 0으로 설정되어 있는 경우 양호        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (DefaultPassword 엔트리가 존재한다면 삭제할 것을 권고)                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [AutoAdminLogon (1:Enable, 0:Disable, Default:Disable)]                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg export "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" AutoLogon_REG_Export.txt /Y > nul
		type %think%\AutoLogon_REG_Export.txt | findstr /i "AutoAdminLogon" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. 																						>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Username]                                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg export "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" AutoLogon_REG_Export.txt /Y > nul
		type %think%\AutoLogon_REG_Export.txt | findstr /i "DefaultUserName" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. 																						>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [DefaultPassword]                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg export "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" AutoLogon_REG_Export.txt /Y > nul
		type %think%\AutoLogon_REG_Export.txt | findstr /i "DefaultPassword" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %think%\AutoLogon_REG_Export.txt | findstr /i "AutoAdminLogon" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type %think%\AutoLogon_REG_Export.txt | findstr /i "AutoAdminLogon" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0508-enable
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=0												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0508-end
)


:0508-enable

:: winver < 2008R2
if %WinVer% leq 3 (
goto 0508-2008
)

:: winver > 2008
if %WinVer% geq 4 (
 goto 0508-2008R2
)


:0508-2008
type %think%\result.txt | find "1" > nul
	if %ERRORLEVEL% neq 1 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0508-end
	) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=0												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0508-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:0508-2008R2
type %think%\result.txt | find "0" > nul
if %errorlevel% equ 0 (
	echo Result=0                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo Result=1                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0508-end


:0508-end
::del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0508 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0509 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################       이동식 미디어 포맷 및 꺼내기 허용       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "이동식미디어 포맷 및 꺼내기 허용" 정책이 "Administrators"으로 되어 있거나, 결과가 없는 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (결과가 없으면 아무 그룹도 정의되지 않음: Default Administrators만 사용 가능 양호) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (AllocateDASD=1,"0" 이면 Administrators 양호)                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (AllocateDASD=1,"1" 이면 Administrators 및 Power Users)                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (AllocateDASD=1,"2" 이면 Administrators 및 Interactive Users)                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "AllocateDASD"                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ※ 결과가 없을 경우 Default로 Administrators 만 사용 가능함 							>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "AllocateDASD" > nul
if %errorlevel% neq 0 (
echo Result=0												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type Local_Security_Policy.txt | Find /I "AllocateDASD" | %script%\awk -F, {print$2} | find "0" > nul
if %errorlevel% equ 0 (
echo Result=0												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type Local_Security_Policy.txt | Find /I "AllocateDASD" | %script%\awk -F, {print$2} | find "1" > nul
if %errorlevel% equ 0 (
echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type Local_Security_Policy.txt | Find /I "AllocateDASD" | %script%\awk -F, {print$2} | find "2" > nul
if %errorlevel% equ 0 (
echo Result=2												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0509 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0510 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             디스크볼륨 암호화 설정            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "데이터 보호를 위해 내용을 암호화" 정책이 선택 된 경우 양호                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	FOR /F "tokens=1 delims=\" %%a IN ("%cd%") DO (
		echo %%a\ 																			 > %think%\inf_using_drv.txt
	)
	echo ☞ current using drive volume														 > %think%\inf_Encrypted_file_check.txt
	type inf_using_drv.txt 																	 >> %think%\inf_Encrypted_file_check.txt
	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
		echo ☞ Search within the %%a drive...  											 >> %think%\inf_Encrypted_file_check.txt
		cipher /s:%%a | find "E "        												 	 >> %think%\inf_Encrypted_file_check.txt 2> nul
		if errorlevel 1 echo Encrypted file is not exist 									 >> %think%\inf_Encrypted_file_check.txt
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
	)
	type inf_Encrypted_file_check.txt 														 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver = 2003
if %WinVer% equ 2 (
	echo ☞ Current using drive volume 														 > %think%\inf_Encrypted_file_check.txt
	type inf_using_drv.txt 																	 >> %think%\inf_Encrypted_file_check.txt

	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
		echo ☞ Search within the %%a drive...  											 >> %think%\inf_Encrypted_file_check.txt
		cipher /s:%%a | find "E " | findstr "^E"											 >> %think%\inf_Encrypted_file_check.txt 2> nul
		if errorlevel 1 echo Encrypted file is not exist 									 >> %think%\inf_Encrypted_file_check.txt
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
	)
	type inf_Encrypted_file_check.txt 														 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver <= 2008
if %WinVer% geq 3 (
	echo ☞ Windows 2008 이상 해당사항 없음 													 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0510 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0511 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################          Dos공격 방어 레지스트리 설정         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: Dos 공격에 대한 방어 레지스트리가 설정되어 있는 경우 양호                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (1) SynAttackProtect = REG_DWORD 0 ▶ 1 로 변경 시 양호                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (2) EnableDeadGWDetect = REG_DWORD 1(True) ▶ 0 으로 변경 시 양호             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (3) KeepAliveTime = REG_DWORD 7,200,000(2시간) ▶ 300,000(5분)으로 변경 시 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (4) NoNameReleaseOnDemand = REG_DWORD 0(False) ▶ 1 로 변경 시 양호           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2008
if %WinVer% geq 3 (
	echo ☞ Windows 2008 이상 해당사항 없음                             			 				>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5.11-end
) else (
	echo [SynAttackProtect 설정]                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\SynAttackProtect" /s >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [EnableDeadGWDetect 설정]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableDeadGWDetect" /s >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [KeepAliveTime 설정]                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\KeepAliveTime" /s >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [NoNameReleaseOnDemand 설정]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\NoNameReleaseOnDemand" /s >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\SynAttackProtect" /s > %think%\result.txt

type %think%\result.txt | findstr "0 unable" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 5.11-end
)
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableDeadGWDetect" /s > %think%\result.txt
type %think%\result.txt | findstr "1 unable" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 5.11-end
)
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\NoNameReleaseOnDemand" /s > %think%\result.txt
type %think%\result.txt | findstr "0 unable" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 5.11-end
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\KeepAliveTime" /s > %think%\result.txt
type %think%\result.txt | find "KeepAliveTime" > nul
if %errorlevel% equ 0 (
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\KeepAliveTime" /s | %script%\awk -F" " {print$3}       > %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:5.11-end
del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0511 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0512 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################  사용자가 프린터 드라이버를 설치할 수 없게 함 ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "사용자가 프린터 드라이버를 설치할 수 없게 함" 정책이 "사용"으로 설정된 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (AddPrinterDrivers=4,1 이면 양호)                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "AddPrinterDrivers"                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "AddPrinterDrivers" | %script%\awk -F= {print$2}       >> %think%\result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %think%\result.txt 2>nul


echo 0512 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0513 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################   세션 연결을 중단하기 전에 필요한 유휴시간   ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "로그온 시간이 만료되면 클라이언트 연결 끊기" 정책을 "사용"으로 설정하고,       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : "세션 연결을 중단하기 전에 필요한 유휴 시간" 정책이 "15분"으로 설정된 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (EnableForcedLogOff	1 이고, AutoDisconnect	15 이면 양호)                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters\EnableForcedLogOff" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters\AutoDisconnect" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


%script%\reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters\EnableForcedLogOff" > %think%\result.txt
type %think%\result.txt | find "EnableForcedLogOff" | find "1" > nul
if %errorlevel% neq 0 (
set Result01=0
) else (
set Result01=1
)

%script%\reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters\AutoDisconnect" | %script%\awk -F" " {print$3}       > %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f %%r in (result.txt) do set Result02=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

if %Result01% equ 1 (
	if %Result02% geq 15 (
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)else (
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=F                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	)
) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0513 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0514 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################                경고 메시지 설정               ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 시스템의 불법적인 사용에 대한 경고 메시지/제목이 설정되어 있는 경우 양호        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Win NT]                                                            					 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\LegalNoticeCaption" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\LegalNoticeText" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Win 2000이상]                                                            				>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0514 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0515 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################         사용자별 홈 디렉터리 권한 설정        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 사용자 계정별 홈 디렉터리에 Eveyone 권한이 없을 경우 양호                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. > %think%\home-directory.txt
dir "C:\Users\*" | find "<DIR>" | findstr /V "All Defalt ."                                  >> %think%\home-directory.txt
FOR /F "tokens=5" %%i IN (home-directory.txt) DO cacls "C:\Users\%%i" | find /I "Everyone" > nul
IF %ERRORLEVEL% equ 1 (
echo ☞ Everyone 권한이 할당된 홈디렉터리가 발견되지 않았음.                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) ELSE (
	FOR /F "tokens=5" %%i IN (home-directory.txt) DO cacls "C:\Users\%%i" | find /I "Everyone" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0515 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0516 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################              LAN Manager 인증 수준            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "LAN Manager 인증 수준" 정책에 "NTLMv2 응답만 보냄"으로 설정되어 있는 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 참고  : (LM NTML 응답 보냄: LmCompatibilityLevel=4,0)                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (LM NTML NTLMv2세션 보안 사용(협상된 경우): LmCompatibilityLevel=4,1)         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (NTLM 응답 보냄: LmCompatibilityLevel=4,2)                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (NTLMv2 응답만 보냄: LmCompatibilityLevel=4,3)                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (NTLMv2 응답만 보냄WLM거부: LmCompatibilityLevel=4,4)                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (NTLMv2 응답만 보냄WLM거부 NTLM 거부: LmCompatibilityLevel=4,5)               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : 값이 없을 경우 아무것도 설정이 안 된 상태임                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 주의: 해당 설정을 수정하면 클라이언트나 서비스 또는 응용 프로그램과의 호환성에 영향을 미칠 수 있음. >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "LmCompatibilityLevel"           					 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "LmCompatibilityLevel" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "LmCompatibilityLevel" | %script%\awk -F= {print$2}       >> %think%\result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 값이 존재 하지 않음                                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0516 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0517 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################   보안 채널 데이터 디지털 암호화 또는 서명    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 아래 3가지 정책이 "사용" 으로 되어 있을 경우 양호                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 참고: (1) 도메인 구성원: 보안 채널 데이터를 디지털 암호화 또는 서명(항상)           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■     : (2) 도메인 구성원: 보안 채널 데이터를 디지털 암호화(가능한 경우)              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■     : (3) 도메인 구성원: 보안 채널 데이터를 디지털 서명(가능한 경우)                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■     : (4,1)사용, (4,0)사용 안 함                							  		 	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" | findstr "4.0 unable" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=4,0												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=4,1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo 0517 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0518 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             파일 및 디렉토리 보호             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 파일시스템이 보안 기능을 제공 해주는 NTFS일 경우 양호                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	fsutil fsinfo drives 																	 > %think%\inf_using_drv_temp1.txt
	type inf_using_drv_temp1.txt | find /i "\" 												 > %think%\inf_using_drv_temp2.txt
	echo.																					 > %think%\inf_using_drv_temp3.txt
	FOR /F "tokens=1-26" %%a IN (inf_using_drv_temp2.txt) DO (
		echo %%a >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%b >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%c >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%d >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%e >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%f >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%g >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%h >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%i >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%j >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%k >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%l >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%m >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%n >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%o >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%p >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%q >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%r >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%s >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%t >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%u >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%v >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%w >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%x >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%y >> %think%\inf_using_drv_temp3.txt 2> nul
		echo %%z >> %think%\inf_using_drv_temp3.txt 2> nul
	)
	type inf_using_drv_temp3.txt | find /i "\" | find /v "A:\" 								 > %think%\inf_using_drv.txt
	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo %%a                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		fsutil fsinfo drivetype %%a												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		fsutil fsinfo volumeinfo %%a												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		fsutil fsinfo drivetype %%a												 > %think%\result.txt
	type %think%\result.txt | find /I "Fixed Drive" > nul
	type %think%\result.txt | find /I "Fixed Drive" > nul
	if not errorlevel 1 (
	fsutil fsinfo volumeinfo %%a												 >> %think%\result1.txt
	)
)
	type %think%\result1.txt | find /I "File System Name" | find /i "fat" > nul
	if %errorlevel% equ 0 (
	echo.                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=FAT												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
	echo.                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=NTFS												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [참고]                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo C: 드라이브 권한 확인(NTFS일 경우 계정별 권한 부여 설정이 출력됨)                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls c:\ 																					 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


del %think%\result.txt 2>nul
del %think%\result1.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0518 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0519 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################        컴퓨터 계정 암호 최대 사용 기간        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: "컴퓨터 계정 암호 변경 사용 안함" 정책 "사용안함"으로 설정 되어 있고,           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : "컴퓨터 계정 암호 최대 사용 기간" 정책이 "90일"로 설정되어 있는 경우 양호     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (DisablePasswordChange=4,0 이고, MaximumPasswordAge=4,90 이면 양호)           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 해당사항 없음                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5.19-end
)
:: winver >= 2003
if %WinVer% geq 2 (
	type Local_Security_Policy.txt | Findstr /I "\MaximumPasswordAge disablepasswordchange"      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

type Local_Security_Policy.txt | Find /I "disablepasswordchange" | find "4,0" > nul
if %errorlevel% neq 0 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5.19-end
) 
	
type Local_Security_Policy.txt | Find /I "disablepasswordchange" | find "4,0" > nul
if %errorlevel% equ 0 (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type Local_Security_Policy.txt | Find /I "\MaximumPasswordAge" | %script%\awk -F, {print$2}       > %think%\result.txt
	for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:5.19-end
del %think%\result.txt 2>nul
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0519 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0520 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################             시작프로그램 목록 분석            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: 시작 프로그램에서 불필요한 서비스가 등록되어 있지 않고, 주기적으로 점검하는 경우 양호 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (담당자 인터뷰 및 시작 프로그램 점검관련 보고서 확인)                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ 시작 프로그램 확인(HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run)  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	%script%\reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF NOT ERRORLEVEL 0 (
		reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ☞ 시작 프로그램 확인(HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run"        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	%script%\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF NOT ERRORLEVEL 0 (
		reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0520 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0601 START >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################            Windows 인증 모드 사용             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 기준: Windows 인증 모드로 설정되어 있는 경우 양호 (LoginMode 1 이면 양호)             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (1) LoginMode 1 이면 Windows 인증 모드                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■       : (2) LoginMode 2 이면 SQL Server 및 Windows 인증 모드                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■ 현황                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 해당사항 없음                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.01-end
)

:: winver >= 2003
if %WinVer% geq 2 (
	net start | find "SQL Server" > NUL
	IF NOT ERRORLEVEL 1 (
		ECHO ☞ SQL Server Enable                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 6.01-start
		echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)	ELSE (
		ECHO ☞ SQL Server Disable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 6.01-end
	)
)


:6.01-start

%script%\reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" > nul
	IF %ERRORLEVEL% neq 0 (
		reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" | %script%\awk -F" " {print$3}       > %think%\result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" | %script%\awk -F" " {print$3} > %think%\result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

:6.01-end
del %think%\result.txt 2>nul

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0601 END >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo @@FINISH>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

::시스템 정보 출력 시작
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############################  Interface Information  ############################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
ipconfig /all                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############################  System Information  ################################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:: winver = 2000
if %WinVer% equ 1 (
	%script%\psinfo                                                                          > systeminfo.txt
	echo Hotfix:                                                                             >> systeminfo.txt
	%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\HotFix"            >> systeminfo.txt
	type systeminfo.txt                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:: winver >= 2003
if %WinVer% geq 2 (
	type %think%\systeminfo_ko.txt                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############################  tasklist Information  ################################ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\pslist                                                                          > tasklist.txt
	type %think%\tasklist.txt	                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
)

:: winver >= 2003
if %WinVer% geq 2 (
	tasklist																				 > %think%\tasklist.txt 2>nul
	type %think%\tasklist.txt	                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################################  Port Information  ################################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
netstat -an | find /v "TIME_WAIT"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ############################  Service Daemon Information  ############################# >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /v "started" | find /v "completed"                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##########################  Environment Variable Information  ######################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
set											                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################  metabase.xml  ################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF EXIST C:\WINDOWS\system32\inetsrv\MetaBase.xml (
	type C:\WINDOWS\system32\inetsrv\MetaBase.xml                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) ELSE (
	echo C:\WINDOWS\system32\inetsrv\MetaBase.xml 존재하지 않음.                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############                      계정 정보                     #################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ****************************  User Accounts List  *****************************         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user | find /V "successfully"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ************************  Group List - net localgroup  ************************         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net localgroup | find /V "successfully"                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *****************************  Account Information  ***************************         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "tokens=1,2,3 skip=4" %%i IN ('net user') DO (
net user %%i >> account.txt 2>nul
net user %%j >> account.txt 2>nul
net user %%k >> account.txt 2>nul
)
type account.txt>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

::시스템 정보 출력 끝



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: 공통 부분 시작2::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



echo.>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo END_RESULT                                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %think%\account.txt 2>nul
del %think%\account_temp1.txt 2>nul
del %think%\account_temp2.txt 2>nul
del %think%\admin-account.txt 2>nul
del %think%\service.txt 2>nul
del %think%\idletime.txt 2>nul
del %think%\home-directory.txt 2>nul
del %think%\home-directory-acl.txt 2>nul
del %think%\Local_Security_Policy.txt 2>nul
del %think%\net-accounts.txt 2>nul
del %think%\reg-website-list.txt 2>nul
del %think%\systeminfo.txt 2>nul
del %think%\systeminfo_ko.txt 2>nul
del %think%\tasklist.txt 2>nul
del %think%\real_ver.txt 2>nul
del %think%\inf_share_folder.txt 2>nul
del %think%\inf_share_folder_temp.txt 2>nul
del %think%\inf_share_folder_temp_sed.txt 2>nul
del %think%\inf_share_folder_temp_sed2.txt 2>nul
del %think%\inf_Encrypted_file_check.txt 2>nul
del %think%\AutoLogon_REG_Export.txt 2>nul


rem Netbios 관련
del %think%\2-18-netbios-list-1.txt 2> nul
del %think%\2-18-netbios-list-2.txt 2> nul
del %think%\2-18-netbios-list.txt 2> nul
del %think%\2-18-netbios-query.txt 2> nul
del %think%\2-18-netbios-result.txt 2> nul


rem DB 관리 관련
del %think%\unnecessary-user.txt 2>nul
del %think%\password-null.txt 2>nul


rem IIS 관련 del
del %think%\iis-enable.txt 2>nul
del %think%\iis-version.txt 2>nul
del %think%\website-list.txt 2>nul
del %think%\website-name.txt 2>nul
del %think%\website-physicalpath.txt 2>nul
del %think%\sample-app.txt 2>nul


rem FTP 관련 del
del %think%\ftp-enable.txt 2>nul
del %think%\ftpsite-list.txt 2>nul
del %think%\ftpsite-name.txt 2>nul
del %think%\ftpsite-physicalpath.txt 2>nul
del %think%\ftp-ipsecurity.txt 2>nul


rem 파일 드라이브 경로 관련 del
del %think%\inf_using_drv_temp3.txt 2>nul
del %think%\inf_using_drv_temp2.txt 2>nul
del %think%\inf_using_drv_temp1.txt 2>nul
del %think%\inf_using_drv.txt 2>nul



echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   END Time  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
date /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
time /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■                                                              ■■■   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■       Windows %WinVer_name% Security Check is Finished       ■■■   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■                                                              ■■■   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.
echo [+] Windows Security Check is Finished
pause

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: 공통 부분 끝2::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

