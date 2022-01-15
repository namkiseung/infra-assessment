::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ����:::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off

setlocal
set think=C:\think
set john=%think%\john
set script=%think%\script

rem ��ũ��Ʈ ���� �� �׸� ī��Ʈ �����ֱ� ���� ����df
set item_count=0

TITLE Windosws Security Check

::���� ���� Ȯ�� ����
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

:: windows 2008 �̻������ icacls
if %WinVer% geq 3 (
	doskey cacls=icacls $*
)
::���� ���� Ȯ�� ��




set SCRIPT_LAST_UPDATE=2017.09.01
echo ======================================================================================= >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��������������������      Windows %WinVer_name% Security Check      ��������������������� >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��������������������      Copyright �� 2017, SK think Co. Ltd.    ��������������������� >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ======================================================================================= >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo LAST_UPDATE %SCRIPT_LAST_UPDATE%                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �������������������������������������  Start Time  �������������������������������������  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
date /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
time /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt     
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::sysinfo �ѱ�(chcp 437���� �ѱ� ??�� ���� ���� ����)
echo [+] Gathering systeminfo...
systeminfo																					 > %think%\systeminfo_ko.txt 2>nul

::�������� ����
chcp 437

::���� �������� ����
secedit /EXPORT /CFG Local_Security_Policy.txt >nul
net accounts > %think%\net-accounts.txt 


::FTP ���Ȯ��
net start | find /i "ftp" > nul
if not errorlevel 1 (
	echo FTP Enable                                                                         > ftp-enable.txt
) else (
goto FTP-Disable
)

:: FTP Version �����ϱ�
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

:: FTP Site List ���ϱ� ( ftpsite-list.txt )
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list site | find /i "ftp"                           > %think%\ftpsite-list.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "MSFTPSVC" | findstr /i /v "FILTERS APPPOOLS INFO" > ftpsite-list.txt
)

:: FTP Site Name ���ϱ� ( ftpsite-name.txt )
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

:: FTP Site physicalpath ���ϱ� ( ftpsite-physicalpath.txt )
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

::IIS ���Ȯ��
net start | find /i "world wide web publishing service" > nul
if not errorlevel 1 (
	echo IIS Enable                                                                           > iis-enable.txt
) else (
 goto IIS-Disable
 )

:: IIS Version ���ϱ�
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" | find /i "version" > iis-version.txt
type iis-version.txt | find /i "major"                                                        > iis-version-major.txt
for /f "tokens=3" %%a in (iis-version-major.txt) do set iis_ver_major=%%a
del iis-version-major.txt 2> nul

:: WebSite List ���ϱ� ( website-list.txt )
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list site | find /i "http"                             > website-list.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum W3SVC | find /i "W3SVC" | findstr /i /v "FILTERS APPPOOLS INFO" > website-list.txt
)

:: WebSite Name ���ϱ� ( website-name.txt )
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

:: Web Site physicalpath ���ϱ� ( website-physicalpath.txt )
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


::sysinfo ����
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
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ��:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0101 START                                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################        Administrator ���� �̸� �ٲٱ�         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Administrator ���� �̸��� �����Ͽ� ����ϴ� ��� ��ȣ                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #################               GUEST ���� ����                ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Guest ���� ��Ȱ��ȭ�� ��� ��ȣ                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################              ���ʿ��� ���� ����               ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���ʿ��� ������ �������� ���� ���                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################            ���� ��� �Ӱ谪 ����             ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �α׿� ���� ���� �����ϴ� ���� ��� �Ӱ谪�� 5�� ���Ϸ� �����Ǿ� ������ ��ȣ          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################    �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å�� "������"���� �����Ǿ� ������ ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (ClearTextPassword = 0 �� ��� ��ȣ)                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################      ������ �׷쿡 �ּ����� ����� ����        ##################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Administrators �׷쿡 ���ʿ��� ������ ���� ���� ���� ��� ��ȣ                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ################     Everyone ��� ������ �͸� ����ڿ��� ����          ############### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ��Everyone ��� ������ �͸� ����ڿ��� ���롱 ��å�� �������ԡ� ���� �Ǿ� ���� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 		: (EveryoneIncludesAnonymous=4,0 �̸� ��ȣ)                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #################              ���� ��� �Ⱓ ����              ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� ��� �Ⱓ", "���� ��� �Ⱓ ������� ����" ���� 60�� �̻����� �����Ǿ� ������ ��ȣ                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #################             �н����� ���⼺ ����              ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "��ȣ�� ���⼺�� �����ؾ� ��" ��å�� "���" ���� �Ǿ� ���� ��� ��ȣ            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (PasswordComplexity = 1 �� ��� ��ȣ)                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #################            �н����� �ּ� ��ȣ ����            ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ּ� ��ȣ ���� ������ 8�� �̻��� ��� ��ȣ                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #################            �н����� �ִ� ��� �Ⱓ           ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ִ� ��ȣ ��� �Ⱓ ������ 90�� ������ ��� ��ȣ                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #################           �н����� �ּ� ��� �Ⱓ            ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ������ �н����� ���Ⱓ�� �ּ� 1�� �̻��� ��� ��ȣ                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #################         ������ ����� �̸� ǥ�� ����         ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "������ ����� �̸� ǥ�� ����" ��å�� "���"���� �����Ǿ� ���� ��� ��ȣ        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (DontDisplayLastUserName = 1)                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################               ���� �α׿� ���               ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� �α׿� ���" ��å�� "Administrators", "IUSR_" �� ������ ��� ��ȣ         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (Administrators = *S-1-5-32-544), (IUSR = *S-1-5-17)                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################           �͸� SID/�̸� ��ȯ ���            ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�͸� SID/�̸� ��ȯ ���" ��å�� "��� �� ��" ���� �Ǿ� ���� ��� ��ȣ          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (LSAAnonymousNameLookup = 0)                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################                �ֱ� ��ȣ ���                ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ������ �ֱ� ����� �н����� ��� ������ 12�� �̻��� ��� ��ȣ                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################  �ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����  ################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"���� �Ǿ� ���� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (LimitBlankPasswordUse = 4,1)                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem ��� ���� �������� ������ Default ���� ����(Default ����: LimitBlankPasswordUse 1 ��ȣ)
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################    �����͹̳� ���� ������ ����� �׷� ����    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� �͹̳� ������ ������ Administrators�׷�� Remote Desktop Users�׷쿡       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : ���ʿ��� ������ ��ϵǾ� ���� ���� ��� ��ȣ                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2008_R2
if %WinVer% geq 4 (
	net start | find /i "Remote Desktop Services" >nul
	IF NOT ERRORLEVEL 1 (
		echo �� Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��� ����                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		echo �� Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
) else (
	NET START | FIND "Terminal Service" > NUL
	IF NOT ERRORLEVEL 1 (
		echo �� Terminal Service Enable                                          			>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��� ����                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		echo �� Terminal Service Disable                                             		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################          ���� ���� �� ����� �׷� ����        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �Ϲݰ��� ������ ���ų� ���� ���丮 ���� ������ Everyone ���� ��� ��ȣ    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | find /v "$" | find /v "���"			                                      	 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | find /v "$" | find /v "���" | find /v "------"                                    	 > %think%\inf_share_folder.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type inf_share_folder.txt | find "\" > nul
IF %ERRORLEVEL% neq 0 echo ���������� �������� �ʽ��ϴ�.								>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo �� cacls ���                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	echo Everyone ������ �������� �ʽ��ϴ�.														>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################            �ϵ��ũ �⺻ ���� ����          ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �⺻���� �׸�(C$, D$)�� �������� �ʰ� AutoShareServer ������Ʈ�� ���� 0�� ��� ��ȣ           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� �ϵ��ũ �⺻ ���� Ȯ��                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]"  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]" > nul
if %ERRORLEVEL% EQU 1 (
echo �⺻ ���� ������ ���� ���� �ʽ��ϴ�.													>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� Registry ����								                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################              ���ʿ��� ���� ����             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ý��ۿ��� �ʿ����� �ʴ� ����� ���񽺰� �����Ǿ� ���� ��� ��ȣ                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) Alerter(�������� Ŭ���̾�Ʈ�� ���޼����� ����)                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) Clipbook(������ Clipbook�� �ٸ� Ŭ���̾�Ʈ�� ����)                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) Messenger(Net send ��ɾ �̿��Ͽ� Ŭ���̾�Ʈ�� �޽����� ����)          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (4) Simple TCP/IP Services(Echo, Discard, Character, Generator, Daytime, ��)  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr "Alerter ClipBook Messenger"                                             > %think%\service.txt
net start | find "Simple TCP/IP Services"                                                    >> %think%\service.txt

net start | findstr /I "Alerter ClipBook Messenger TCP/IP" service.txt > NUL
IF ERRORLEVEL 1 ECHO �� ���ʿ��� ���񽺰� �������� ����.                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF NOT ERRORLEVEL 1 (
echo �� �Ʒ��� ���� ���ʿ��� ���񽺰� �߰ߵǾ���.                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             IIS ���� ���� ����             ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : IIS ���񽺰� ���ʿ��ϰ� �������� �ʴ� ��� ��ȣ(����� ���ͺ�)                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                
if exist iis-enable.txt (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-04-enable
) else (
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=Disabled																		>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-04-end
)


:2-04-enable

echo [IIS Version Ȯ��]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type iis-version.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################           IIS ���丮 ������ ����           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �⺻ ���� �� ����Ʈ�� "���͸� �˻�" ������ False �̸� ��ȣ                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-05-enable
) else (
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-05-end
)

:2-05-enable

echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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

echo [�⺻ ����]                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
			echo * �⺻ ������ ����Ǿ� ����.                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################               IIS CGI ���� ����              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : C:\inetpub\scripts �� C:\inetpub\cgi-bin ���͸��� ������� �ʴ� ��� ��ȣ     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : ��� �� Everyone�� ������, ��������, ��������� �ο��Ǿ� ���� ���� ��� ��ȣ  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	echo C:\inetpub\scripts ���͸��� �������� ����.                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

IF EXIST C:\inetpub\cgi-bin (
	cacls C:\inetpub\cgi-bin                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls C:\inetpub\cgi-bin                                                                >> %think%\result.txt
) ELSE (
	echo C:\inetpub\cgi-bin ���͸��� �������� ����.                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################          IIS ���� ���丮 ���� ����         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : "���� ��� ���" �ɼ��� üũ�Ǿ� ���� ���� ��� ��ȣ                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (asp enableParentPaths="false" �� ��� ��ȣ)                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-07-enable
) else (
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-07-end
)

:2-07-enable
echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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

echo [�⺻ ����]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" > nul
	IF NOT ERRORLEVEL 1 (
		%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" > %think%\result.txt
	) ELSE (
		echo * ������ ���� * �⺻���� : enableParentPaths=false                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs get W3SVC/AspEnableParentPaths  | find /i /v "Microsoft"    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs get W3SVC/AspEnableParentPaths  | find /i /v "Microsoft"    > %think%\result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
			echo * ������ ���� * �⺻���� : enableParentPaths=false                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
			echo AspEnableParentPaths : * �⺻ ������ ����Ǿ� ����.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################            IIS ���ʿ��� ���� ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : IISSamples, IISHelp ������͸��� �������� ���� ��� ��ȣ                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 		 (IIS 7.0 �̻� ���� �ش� ���� ����)						                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-08-enable
) else (
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-08-end
)

:2-08-enable
echo [���� ���͸� ���� ��Ȳ]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	echo �� IIS 7.0 �̻� ���� �ش� ���� ����							                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

::20160114 ������(�ش���� �������� ������)
::if %iis_ver_major% geq 7 (
	::%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "virtualdirectory" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)

::20160114 ������(IISSample �� ������ �Ǵܰ����ϰ� ������)
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
		ECHO * ���˰��: IISSamples, IISHelp ������͸��� �������� ����.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
	)	ELSE (
		ECHO * ���˰��: IISSamples, IISHelp ������͸��� ������.                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################          IIS �� ���μ��� ���� ����           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : IIS ���� ���� ������ ������ �������� ��ϵǾ� ���� ������ ��ȣ                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.09-end
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [World Wide Web Publishing Service ���� ����]                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\ObjectName"                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\ObjectName"                 >> %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [IIS Admin Service ���� ����]                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################               IIS ��ũ ������              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �� ����Ʈ Ȩ���͸��� �ɺ��� ��ũ, aliases, *.lnk ������ �������� ������ ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-10-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-10-end
)

:2-10-enable
echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	echo [Ȩ���丮 ���� - WEB/FTP ���п�]                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol physicalpath" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���ʿ� ���� üũ                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo �� ��� ���� �������� ������ ��ȣ                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################       IIS ���� ���ε� �� �ٿ�ε� ����       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �� ������ ���� �ڿ������� ���� ���ε� �� �ٿ�ε� �뷮�� ������ ��� ��ȣ     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : 7.0�̻�(maxAllowedContentLength: ������ �뷮 ���� ���� /Default: 30MB)                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 7.0�̻�(MaxRequestEntityAllowed: ���� ���ε� �뷮 ���� ���� /Default: 200000 bytes)    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 7.0�̻�(bufferingLimit: ���� �ٿ�ε� �뷮 ���� ���� /Default: 4MB(4194304 bytes))     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 6.0����(AspMaxRequestEntityAllowed : ���ε� �뷮 ���� ���� /Default: 200KB(204800 byte)) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 6.0����(AspBufferingLimit : �ٿ�ε� �뷮 ���� ���� /Default: 4MB(4194304 byte)) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-11-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
	goto 2-11-end
)

:2-11-enable
echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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

echo [�⺻ ����]                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config | findstr /i "maxAllowedContentLength maxRequestEntityAllowed bufferingLimit" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum W3SVC | findstr /i "AspMaxRequestEntityAllowed AspBufferingLimit" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo * ���� ���� ��� �⺻ ������ ����Ǿ� ����.                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%a in (website-name.txt) do (
		echo [WebSite Name] %%a                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%a | findstr /i "maxAllowedContentLength maxRequestEntityAllowed bufferingLimit" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo * ���� ���� ��� �⺻ ������ ����Ǿ� ����.                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
			echo AspMaxRequestEntityAllowed : * �⺻ ������ ����Ǿ� ����.                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
		cscript %script%\adsutil.vbs enum %%i | find /i "AspBufferingLimit" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i | find /i "AspBufferingLimit"           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo AspBufferingLimit          : * �⺻ ������ ����Ǿ� ����.                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################           IIS DB ���� ����� ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : 7.0�̻�- ��û ���͸����� .asa, .asax Ȯ���ڰ� False�� �����Ǿ� ������ ��ȣ     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   ��û ���͸����� .asa, .asax Ȯ���ڰ� True�� �����Ǿ� ���� ���        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   .asa, .asax ������ ��ϵǾ� �־�� ��ȣ                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   (����, Global.asa ������ ������� �ʴ� ��� �ش� ���� ����.)           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                 > (1) fileExtension=".asa" allowed="false" �̸� ��ȣ                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                 > (2) fileExtension=".asa" allowed="true" �̸�, .asa ���� Ȯ��           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo   	    : 6.0����- .asa ������ ������ ��� ��ȣ                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   (���� ��) ".asa,C:\WINDOWS\system32\inetsrv\asp.dll,5,GET,HEAD,POST,TRACE" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                    GET,HEAD,POST,TRACE ����: �������� ����								 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-12-enable
) else (
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
	goto 2-12-end
)

:2-12-enable
echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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

echo [�⺻ ����]                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
				echo .asa ������ ��ϵǾ� ���� ����. [���]                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				echo.                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			) else (
				echo * �⺻ ������ ����Ǿ� ����.                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################            IIS ���� ���丮 ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �ش� ������Ʈ�� IIS Admin, IIS Adminpwd ���� ���͸��� �������� ���� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo        : IIS 6.0 �̻� ���� �ش� ���� ���� 												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-13-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-13-end
)

:2-13-enable
echo [���� ���͸� ���� ��Ȳ]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ����##########
:: iis ver >= 6
if %iis_ver_major% geq 6 (
echo �� IIS 6.0 �̻� ���� �ش� ���� ���� 												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
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
rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ��##########


rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ����##########
:: iis ver >= 7
::if %iis_ver_major% geq 7 (
	::%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "virtualdirectory" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)
:: iis ver <= 6
::if %iis_ver_major% leq 6 (
	::%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)
rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ��##########
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
echo ###################           IIS ������ ���� ACL ����           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : Ȩ ���͸� ���� �ִ� ���ϵ鿡 ���� Everyone ������ �������� ���� ��� ��ȣ   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (��������Ʈ ������ Read ���Ѹ�)                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-14-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-14-end
)

:2-14-enable
echo [��� ����Ʈ]                                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo *** ����Ʈ�� ���� Everyone ���� üũ                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo �� ��� ���� �������� ������ ��ȣ                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################         IIS �̻�� ��ũ��Ʈ ���� ����        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �Ʒ��� ���� ����� ������ �������� ���� ��� ��ȣ(Windows 20003 ���� ������ ��ġ�� �Ǿ� ��ȣ��)                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (.htr .idc .stm .shtm .shtml .printer .htw .ida .idq)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-15-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-15-end
)

:2-15-enable
if %WinVer% geq 2 (
	echo �� Windows 2003 ���� ������ ��ġ�� �Ǿ� �ش���� ����							>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-15-end
) else (
	echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		echo [�̻�� ��ũ��Ʈ ���� Ȯ��]                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config | find /i "scriptprocessor" | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ��� ���� �������� ������ ��ȣ                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

	:: iis ver <= 6
	if %iis_ver_major% leq 6 (
		echo [�⺻ ����]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum W3SVC | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum W3SVC | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %think%\result.txt
		echo �� ��� ���� �������� ������ ��ȣ                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

		echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo *** ����Ʈ�� ���� Ȯ��                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
					echo * ����� ������ ��ϵǾ� ���� ����. [��ȣ]                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
					echo.                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				) else (
					echo * �⺻ ������ ����Ǿ� ����.                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################         IIS Exec ��ɾ� �� ȣ�� ����         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �ش� ������ ������Ʈ�� ���� 0�� ��� ��ȣ                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (����1) IIS 5.0 �������� �ش� ������Ʈ�� ���� ���� ��� ��ȣ                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (����2) IIS 6.0 �̻� ��ȣ                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-16-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-16-end
)

:2-16-enable
:: iis ver >= 6
if %iis_ver_major% geq 6 (
	echo �� IIS 6.0 �̻� ��ȣ			                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-16-end
)

:: iis ver < 6
if %iis_ver_major% lss 6 (
	echo [Registry ����] 			                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###################              IIS WebDAV ��Ȱ��ȭ              ##################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ���� �� �� ������ �ش�Ǵ� ��� ��ȣ                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 1. IIS �� ������� ���� ���                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2. DisableWebDAV ���� 1�� �����Ǿ� �������                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 3. Windows NT, 2000�� ������ 4 �̻��� ��ġ�Ǿ� ���� ���                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 4. Windows 2003, Windows 2008�� WebDAV �� ���� �Ǿ� ���� ���                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : "0,C:\WINDOWS\system32\inetsrv\httpext.dll,0,WEBDAV,WebDAV" (WebDAV ����-��ȣ) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : "1,C:\WINDOWS\system32\inetsrv\httpext.dll,0,WEBDAV,WebDAV" (WebDAV ���-���) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2008 �̻��� ��� allowed="false"   (WebDAV ����-��ȣ) 						>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2008 �̻��� ��� allowed="True"    (WebDAV ���-���) 						 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-17-enable
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-17-end
)

:2-17-enable

:: winver = 2000
if %WinVer% equ 1 (
	ECHO �� Win 2000�� ��� ������ 4 �̻� ��ȣ                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	echo [WebDAV ���� Ȯ��]                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\adsutil.vbs enum W3SVC | find /i "webdav" | find /v "WebDAV;WEBDAV"            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\adsutil.vbs enum W3SVC | find /i "webdav" | find /v "WebDAV;WEBDAV"            > %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.17-2003
)


:: iis ver >=7
if %iis_ver_major% geq 6 (
	echo [WebDAV ���� Ȯ��]                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo [���� - Registry ����(DisableWebDAV)]                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\registry\DisableWebDAV" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\DisableWebDAV"  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��� ���� �������� ���� ��� �ٸ� �������� ����                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [���� - OS Version, Service Pack]                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################         NetBIOS ���ε� ���� ���� ����       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ��ִ� ��� ��ȣ                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NetBIOS ��� ���� ����: NetbiosOptions 0x2 ��ȣ)                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NetBIOS ��� ����: NetbiosOptions 0x1 ���)                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (�⺻ ��: NetbiosOptions 0x0 ���)                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (�������� ���) ���ͳ� ��������(TCP/IP)�� ������� �� ��� �� Wins ���� TCP/IP���� NetBIOS ��� ���� (139��Ʈ����) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" | findstr /iv "listing" > 2-18-netbios-list.txt
	for /f "tokens=1 delims=[" %%a in (2-18-netbios-list.txt) do echo %%a >> 2-18-netbios-list-1.txt
	for /f "tokens=1 delims=]" %%a in (2-18-netbios-list-1.txt) do echo %%a >> 2-18-netbios-list-2.txt
	FOR /F %%a IN (2-18-netbios-list-2.txt) do echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\%%a\NetbiosOptions >> 2-18-netbios-query.txt
	FOR /F %%a IN (2-18-netbios-query.txt) do %script%\reg query %%a >> 2-18-netbios-result.txt
	echo [NetBIOS over TCP/IP ���� ��Ȳ]                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #########################        FTP ���� ���� ����          ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : FTP ���񽺸� ������� �ʴ� ��� ��ȣ (�̿� ������ ��������ͺ�)                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-19-enable
) else (
	echo �� FTP Service Disable                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-19-end
)

:2-19-enable


echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo #####################        FTP ���丮 ���ٱ��� ����          ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : FTP Ȩ ���͸��� Everyone�� ���� ������ �������� ������ ��ȣ				              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-20-enable
) else (
	echo �� FTP Service Disable                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-20-end
)


:2-20-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� ������ �⺻ FTP�� Ÿ FTP ���� ����� (����Ȯ��^)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-20-end
)
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [��� ����Ʈ]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	echo [Ȩ���丮 ���� - WEB/FTP ���п�]                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol physicalpath" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� Ȩ���丮 ���ٱ��� Ȯ��                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ###########################         Anonymous FTP ����          ####################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : FTP�� ������� �ʰų� "�͸� ���� ���"�� üũ�Ǿ� ���� ���� ��� ��ȣ(Default : ��� �� ��)          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : metabase.xml ���� ���� ����        											 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpService	Location ="/LM/MSFTPSVC" �� FTP ����Ʈ �⺻ ����                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : FTP ����Ʈ�� ���� ���� �� �ش� �⺻ ������ ���� ����.							 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpServer	Location ="/LM/MSFTPSVC/ID"�� FTP ����Ʈ�� ��ϵ� ���� ����Ʈ ���� >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : ���� ����Ʈ�� AllowAnonymous ������ ������ FTP ����Ʈ �⺻ ������ ���� ����   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpServer	Location ="/LM/MSFTPSVC/~/Public FTP Site"�� ���� �� ������� ���� >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-enable
) else (
	echo �� FTP Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-end
)

:2-21-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� ������ �⺻ FTP�� Ÿ FTP ���� �����                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-21-end
)

echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (


	type ftpsite-list.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [FTP ���� ���� Ȯ��]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol anonymousAuthentication enabled" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol anonymousAuthentication enabled" > %think%\result.txt
	echo.                                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-218-enable	
) 
	type ftpsite-name.txt                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [�⺻ ����]                                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "AllowAnonymous"                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "AllowAnonymous"                   > %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo *** ����Ʈ�� ���� Ȯ��                                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
			echo AllowAnonymous : �⺻ ������ ����Ǿ� ����.                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo AllowAnonymous : �⺻ ������ ����Ǿ� ����.                                 > %think%\result.txt
			echo.                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 2-213-enable
	)


::7�̻�
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
::6�̸�
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
echo ###########################        FTP ���� ���� ����          ######################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : FTP ���񽺿� �������� ������ �Ǿ� �ִ� ��� ��ȣ				                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : metabase.xml ���� ���� ����        												 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpService	Location ="/LM/MSFTPSVC" �� FTP ����Ʈ �⺻ ����               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpVirtualDir	Location ="/LM/MSFTPSVC/ID/ROOT"�� FTP ���� ����Ʈ ����      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : ���� ����Ʈ�� IPSecurity ������ ������ FTP ����Ʈ �⺻ ������ ���� ����       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IPSecurity="" �������� ����, IPSecurity="0102~" �������� ���� ����.           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �������� ����Ʈ���� ���� ���� ���� ������ ���˽� ��� ����.                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2008�̻� ipSecurity allowUnlisted ������ False�� �Ǿ�� ��ȣ                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : ipSecurity allowUnlisted True��� �׼��� ��� / False ��� �׼��� �ź�         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-22-enable
) else (
	echo �� FTP Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-22-end
)

:2-22-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo �� ������ �⺻ FTP�� Ÿ FTP ���� ����� (����Ȯ��^)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2-22-end
)
echo [��� ����Ʈ]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	echo *** ����Ʈ�� FTP �������� ���� Ȯ��                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
			echo * �������� ���� ����                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			)
		)
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	echo [FTP �������� ����]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             DNS Zone Transfer ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: DNS ���� ������ �Ʒ� ���� �� �ϳ��� �ش�Ǵ� ��� ��ȣ(SecureSecondaries 2) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) DNS ���񽺸� ������� ���� ���                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) ���� ���� ����� ���� ���� ���                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) Ư�� �����θ� ���� ������ ����ϴ� ���                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : * ������Ʈ����(�������� ������:3, �ƹ������γ�:0, �̸������ǿ������� �����θ�:1, ���������θ�:2 ) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : [����]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : ��� ���� ���� ��� DNS ������ ��ϵ� ��/������ ��ȸ ������ ���� ������,      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : DNS ���񽺸� ������� ���� ��� ���񽺸� ������ ���� �ǰ�                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "DNS Server" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� DNS Service Enable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� DNS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################         RDS (Remote Data Services) ����       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ������ �� �Ѱ����� �ش�Ǵ� ��� ��ȣ                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) IIS �� ������� �ʴ� ���                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) Windows 2000 sp4, Windows 2003 sp2, Windows 2008 �̻� ��ȣ  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) ����Ʈ ������Ʈ�� MSADC ���� ���͸��� �������� ���� ���                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (4) �ش� ������Ʈ�� ���� �������� ���� ���                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

if exist iis-enable.txt (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 2.24-end
)

:: OS Version, Service Pack ���� üũ
echo [OS Version Ȯ��]                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
:: winver = 2000
if %WinVer% equ 1 (
	ECHO �� Win 2000�� ��� ������ 4 �̻� ��ȣ                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	ECHO �� Windows 2003 sp2 �̻�, Windows 2008 �̻� ��ȣ                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		ECHO * ���˰��: MSADC ������͸��� �������� ����.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		ECHO * ���˰��: ��ϵ� REG���� �������� ����.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		ECHO * ���˰��: MSADC ������͸��� �������� ����.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		ECHO * ���˰��: ��ϵ� REG���� �������� ����.                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################               �ֽ� ������ ����              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ֽ� �������� ��ġ�Ǿ� ���� ��� ��ȣ                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (Windows NT 6a, Windows 2000 SP4, Windows 2003 SP2, Windows 2008 SP2)         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (Windows 2008R2 SP1, Windows 2012, 2012r2�� SP�� ����) 						 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | find "Microsoft"                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | find "Pack"                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [OS Version Ȯ��]                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################         �͹̳� ���� ��ȣȭ ���� ����        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �͹̳� ���񽺸� ������� �ʴ� ��� ��ȣ                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : �͹̳� ���񽺸� ��� �� ��ȣȭ ������ "Ŭ���̾�Ʈ�� ȣȯ����(�߰�)" �̻����� ������ ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (MinEncryptionLevel	2 �̻��̸� ��ȣ)                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		echo �� Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��ȣȭ ���� ���� Ȯ��                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo --------------------------------------------------------------------------------- >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" | %script%\awk -F" " {print$3}	> %think%\result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                     
		)
	IF ERRORLEVEL 1 (
		echo �� Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=2												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)

goto 2-26-end

:2-268-enable
NET START | FIND "Terminal Service" > NUL
	IF NOT ERRORLEVEL 1 (
		echo �� Terminal Service Enable                                          			>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��ȣȭ ���� ���� Ȯ��                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo --------------------------------------------------------------------------------- >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" | %script%\awk -F" " {print$3}	> %think%\result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	IF ERRORLEVEL 1 (
		echo �� Terminal Service Disable                                             		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             IIS ������ ���� ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ��ϵ� �� ����Ʈ�� [����� ���� ����] �ǿ���                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : 400, 401, 403, 404, 500 ������ ���� ������ �������� �����Ǿ� �ִ� ��� ��ȣ   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::echo ��       : (��� ����) prefixLanguageFilePath="%SystemDrive%\inetpub\custerr" path="401.htm" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem �⺻ �����̱� ������ �� ������ �����.
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "World Wide Web Publishing Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� IIS Service Enable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 1-45-enable
)	ELSE (
	ECHO �� IIS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 46
)

:1-45-enable
echo [��� ����Ʈ]                                                                        	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo [�⺻ ����]                                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
			echo �⺻ ������ ����Ǿ� ����.                                                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             SNMP ���� ���� ����             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: SNMP ���񽺸� ���ʿ��ϰ� ������� ������ ��ȣ                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : SNMP ���񽺴� �����ǰ� ������ SNMP ������ ���� ��� ���ʿ��ϰ� ���۵ǰ� �ִ� ������ �Ǵܵ�. >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� SNMP Service Enable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� SNMP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities ����]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP Trap ����]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################    SNMP ���� Ŀ�´�Ƽ��Ʈ���� ���⼺ ����   ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: SNMP Community �̸��� public, private �� �ƴ� �����ϱ� ��ư� �����Ǿ� ������ ��� ��ȣ                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (����1) REG_DWORD Community String ����                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (����2) ����: 2=�˸�, 4=�б�����, 8=�б�� ����, 16=�б�� �����             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� SNMP Service Enable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� SNMP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 29-end
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities ����]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type result.txt | findstr /i "REG_DWORD" > nul
if %ERRORLEVEL% neq 0 (
	echo "string ���� �����Ǿ� ���� ����(N/A)"                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo "���� ���� �ǰ�"                                                						   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [SNMP Trap Commnunities ����]                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 29-end
	)


echo [SNMP Trap Commnunities ����]                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################            SNMP Access Control ����           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Ư�� ȣ��Ʈ�� SNMP ��Ŷ�� ���� �� �ֵ��� SNMP Access Control�� ������ ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (PermittedManagers ������ ������ ��ȣ)                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (PermittedManagers ������ ������ ��� ȣ��Ʈ���� SNMP ��Ŷ�� ���� �� �־� ���) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� SNMP Service Enable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)	ELSE (
	ECHO �� SNMP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 30-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities ����]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %think%\result.txt
type %think%\result.txt | findstr /i "REG_DWORD" > nul
if %ERRORLEVEL% neq 0 (
	echo "string ���� �����Ǿ� ���� ����(N/A)"                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo "���� ���� �ǰ�"                                                						   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 30-end
	)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP Access Control ����]                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################              DNS ���� ���� ����             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: DNS ���񽺸� ��� ���� �ʰų� ���� ������Ʈ ������ "����"���� ������ ��� ��ȣ  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AllowUpdate	0 �̸� ��ȣ)                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : [����]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : ��� ���� ���� ��� DNS ������ ��ϵ� ��/������ ��ȸ ������ ���� ������,      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : DNS ���񽺸� ������� ���� ��� ���񽺸� ������ ���� �ǰ�                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : ������2008�̻󿡼� ��� ���� ���� ��� ����Ʈ�� �������� ����                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "DNS Server" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� DNS Service Enable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto dns-enable
)	ELSE (
	ECHO �� DNS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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


:: 2003 �̻� �˻�
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
echo ##################             HTTP/FTP/SMTP ��� ����           ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: HTTP/FTP/SMTP ��ʿ� �ý��� ������ ǥ�õ��� �ʴ� ��� ��ȣ                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "World Wide Web Publishing Service" > NUL
IF NOT ERRORLEVEL 1 (
echo ---------------------------------HTTP Banner-------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\http_banner.vbs >nul
	type http_banner.txt								>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	del http_banner.txt 2>nul
)	ELSE (
	ECHO �� IIS Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	ECHO �� FTP Service Disable                                                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
	ECHO �� SMTP Service Disable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################                Telnet ���� ����               ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Telnet ���񽺰� ���� �ǰ� ���� �ʰų�, ��������� NTLM �� ��� ��ȣ             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : [����]                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (SecurityMechanism 2. NTLM)                                            	 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (SecurityMechanism 6. NTLM, Password)                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (SecurityMechanism 4. Password)                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "telnet" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� TELNET Service Enable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-enable
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) ELSE (
	ECHO �� TELNET Service Disable 																	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ################# ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ���� #################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ý��� DSN �κ��� Data Source�� ���� ����ϰ� �ִ� ��� ��ȣ                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : �ý��� DSN �κ��� Data Source�� ������� �ʴµ� ��ϵǾ� ���� ��� ���       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" | find "REG_SZ"           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" | find "REG_SZ"                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��� ���� ���� ��� ���ʿ��� ODBC/OLE-DB�� �������� ���� 							               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################          �����͹̳� ���� Ÿ�Ӿƿ� ����        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� �͹̳��� ������� �ʰų�, ��� �� Session Timeout�� �����Ǿ� �ִ� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (MaxIdleTime ���� Ȯ�� ���: 60000=1��, 300000=5��)                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		echo �� Terminal Service Enable                                          			>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� Session Timeout ����                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /s | findstr "MaxIdleTime" > %think%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		type %think%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %think%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.
		) else (
		echo �� Terminal Service Disable                                             		 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 35-end		
		)
goto 35-end



:35-2008R2
net start > netstart.txt
type netstart.txt | find /i "Remote Desktop Services" > nul
	IF %ERRORLEVEL% neq 1 (
		echo �� Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� Session Timeout ����                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /s | findstr "MaxIdleTime" > %think%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		type %think%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %think%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.        
		) else (
		echo �� Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 35-end		
		)
goto 35-end	


:35-2012
net start > netstart.txt
type netstart.txt | find /i "Remote Desktop Services" > nul
	IF %ERRORLEVEL% neq 1 (
		echo �� Remote Desktop Services Enable                                          	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� Session Timeout ����                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /s | findstr "MaxIdleTime" > %think%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
		echo �� Remote Desktop Services Disable                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 35-end		
		)
		
	type %think%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD"	
		if %ERRORLEVEL% neq 0 (
		echo IdleTime ������ �Ǿ� ���� �ʽ��ϴ�.					>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ############### ����� �۾��� �ǽɽ����� ����� ��ϵǾ� �ִ��� ���� ################## >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ����� �۾��� �ǽɽ����� ����� ��ϵǾ� ���� ���� ��� ��ȣ                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2003
if %WinVer% geq 2 (
	echo �� ����� �۾� Ȯ��                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	schtasks | findstr [0-9][0-9][0-9][0-9]      	                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� at ��ɾ�� ����� �۾� Ȯ��                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
at                                                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2003
if %WinVer% geq 2 (
	echo [����] schtasks ��ü                                                      				 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################                �ֽ� HOT FIX ����              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ֽ�Hotfix �Ǵ� PMS(Patch Management System) Agent�� ��ġ�Ǿ� ���� ��� ��ȣ    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             ��� ���α׷� ������Ʈ            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���̷��� ��� ���α׷��� �ֽ� ���� ������Ʈ�� ��ġ�Ǿ� �ִ� ��� ��ȣ           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� ���� (��� ������Ʈ ���� Ȯ��)                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################          ��å�� ���� �ý��� �α� ����         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �̺�Ʈ ���� ������ �Ʒ��� ���� �����Ǿ� �ִ� ��� ��ȣ                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) �α׿� �̺�Ʈ, ���� �α׿� �̺�Ʈ, ��å ���� : ����/���� ����             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) ���� ����, ���͸� ���� �׼���, ���� ��� : ���� ����                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################           �α��� ������ ���� �� ����          ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �αױ�Ͽ� ���� ������ ����, �м�, ����Ʈ �ۼ� �� ���� ���� ��ġ�� �̷������ ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� ���� (����� ���ͺ� ����)                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################   �������� �׼����� �� �ִ� ������Ʈ�� ���   ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Remote Registry Service �� �����Ǿ� ���� ��� ��ȣ                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "Remote Registry" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� Remote Registry Service Enable                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� Remote Registry Service Disable                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################              �̺�Ʈ �α� ���� ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ִ� �α� ũ�� 10240KB (10MB) �̻��̰�, Retention 7776000(90��) �̻��̸� ��ȣ   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : "90�� ���� �̺�Ʈ ���"���� �����Ǿ� ���� ��� ��ȣ(Windows2008 �̻��� ����)                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (MaxSize 10485760 �̻�, Retention 7776000 �̻�)                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : Retention 0       = �ʿ��� ��� �̺�Ʈ �����                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : Retention 7776000 = �������� ������ �̺�Ʈ ����� (7776000 90��)            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : Retention -1      = �̺�Ʈ ����� ����(�������� �α� �����)                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
		echo �� Windows2008 �̻��� ����� ��¥ ���� �Ұ�			   	     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################      ���ݿ��� �̺�Ʈ �α� ���� ���� ����      ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �α� ���͸��� ���ѿ� Everyone �� ���� ��� ��ȣ                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) �ý��� �α� ���͸�: %systemroot%\system32\config                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) IIS �α� ���͸�: %systemroot%\system32\LogFiles                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config                                                           > %think%\result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls %systemroot%\system32\logfiles                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls %systemroot%\system32\logfiles                                                         >> %think%\result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo �� IIS Service Disable                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0404-end
	echo.                                                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type %think%\result.txt | find /I "everyone" > nul
	if %errorlevel% neq 0 (
	echo Everyone ������ �������� �ʽ��ϴ�.                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################               ��� ���α׷� ��ġ              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���̷��� ��� ���α׷��� ��ġ�Ǿ� �ִ� ��� ��ȣ                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
set vaccine="kaspersky norton bitdefender turbo avast v3"

echo �� Process List                                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for %%a IN (%vaccine%) DO (
type tasklist.txt | findstr /i %%a 															>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%b >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%c >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%d >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%e >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%f >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo. 																						 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� Service list                                                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for %%a IN (%vaccine%) DO (
net start | findstr /i %%a >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%b >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%c >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%d >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%e >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%f >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����� ���� ��� ���μ��� ��� �� ���ͺ並 ���� Ȯ�� �ʿ�                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

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
echo ##################            SAM ���� ���� ���� ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ���������� ��ϵ� ��� ��ȣ  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################                ȭ�麸ȣ�� ����                ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ȭ�� ��ȣ�⸦ �����ϰ�, ��ȣ�� ����ϸ�, ��� �ð��� 10���� ��� ��ȣ            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ������Ʈ�� ���� ���� ��� AD �Ǵ� OS��ġ �� ������ ���� ���� �����             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveActive"                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaverIsSecure"                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveTimeOut"                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [AD(Active Directory)�� ��� ������]                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################        �α׿����� �ʰ� �ý��� ���� ���       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�α׿� ���� �ʰ� �ý��� ���� ���"�� "������"���� �����Ǿ� �ִ� ��� ��ȣ    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (ShutdownWithoutLogon	0 �̸� ��ȣ)                                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################     ���� �ý��ۿ��� �ý��� ���� ���� ����     ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� �ý��ۿ��� ������ �ý��� ����" ��å�� "Administrators"�� ������ ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (Administrators = *S-1-5-32-544)                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ################# ���� ���縦 �α��� �� ���� ��� ��� �ý��� ���� #################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� ���縦 �α��� �� ���� ��� ��� �ý��� ����" ��å�� "������"���� �����Ǿ� �ִ� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (CrashOnAuditFail = 4,0 �̸� ��ȣ)                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################     SAM ������ ������ �͸� ���� ��� �� ��    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "SAM ������ ������ �͸� ���� ��� ����" ��å�� "���"�̰�,                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : "SAM ������ �͸� ���� ��� ����" ��å�� "���"���� �����Ǿ� �ִ� ��� ��ȣ    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (restrictanonymous	1 �̰�, RestrictAnonymousSAM	1 �̸� ��ȣ)                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SAM ������ ������ �͸� ���� ��� ���� ����]                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA\restrictanonymous"             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SAM ������ �͸� ���� ��� ���� ����]                                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################              Autologon ��� ����              ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: AutoAdminLogon ���� ���ų�, AutoAdminLogon 0���� �����Ǿ� �ִ� ��� ��ȣ        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (DefaultPassword ��Ʈ���� �����Ѵٸ� ������ ���� �ǰ�)                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################       �̵��� �̵�� ���� �� ������ ���       ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�̵��Ĺ̵�� ���� �� ������ ���" ��å�� "Administrators"���� �Ǿ� �ְų�, ����� ���� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (����� ������ �ƹ� �׷쵵 ���ǵ��� ����: Default Administrators�� ��� ���� ��ȣ) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AllocateDASD=1,"0" �̸� Administrators ��ȣ)                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AllocateDASD=1,"1" �̸� Administrators �� Power Users)                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AllocateDASD=1,"2" �̸� Administrators �� Interactive Users)                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "AllocateDASD"                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����� ���� ��� Default�� Administrators �� ��� ������ 							>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             ��ũ���� ��ȣȭ ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "������ ��ȣ�� ���� ������ ��ȣȭ" ��å�� ���� �� ��� ��ȣ                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	FOR /F "tokens=1 delims=\" %%a IN ("%cd%") DO (
		echo %%a\ 																			 > %think%\inf_using_drv.txt
	)
	echo �� current using drive volume														 > %think%\inf_Encrypted_file_check.txt
	type inf_using_drv.txt 																	 >> %think%\inf_Encrypted_file_check.txt
	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
		echo �� Search within the %%a drive...  											 >> %think%\inf_Encrypted_file_check.txt
		cipher /s:%%a | find "E "        												 	 >> %think%\inf_Encrypted_file_check.txt 2> nul
		if errorlevel 1 echo Encrypted file is not exist 									 >> %think%\inf_Encrypted_file_check.txt
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
	)
	type inf_Encrypted_file_check.txt 														 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver = 2003
if %WinVer% equ 2 (
	echo �� Current using drive volume 														 > %think%\inf_Encrypted_file_check.txt
	type inf_using_drv.txt 																	 >> %think%\inf_Encrypted_file_check.txt

	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
		echo �� Search within the %%a drive...  											 >> %think%\inf_Encrypted_file_check.txt
		cipher /s:%%a | find "E " | findstr "^E"											 >> %think%\inf_Encrypted_file_check.txt 2> nul
		if errorlevel 1 echo Encrypted file is not exist 									 >> %think%\inf_Encrypted_file_check.txt
		echo.								 												 >> %think%\inf_Encrypted_file_check.txt
	)
	type inf_Encrypted_file_check.txt 														 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver <= 2008
if %WinVer% geq 3 (
	echo �� Windows 2008 �̻� �ش���� ���� 													 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################          Dos���� ��� ������Ʈ�� ����         ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Dos ���ݿ� ���� ��� ������Ʈ���� �����Ǿ� �ִ� ��� ��ȣ                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) SynAttackProtect = REG_DWORD 0 �� 1 �� ���� �� ��ȣ                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) EnableDeadGWDetect = REG_DWORD 1(True) �� 0 ���� ���� �� ��ȣ             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) KeepAliveTime = REG_DWORD 7,200,000(2�ð�) �� 300,000(5��)���� ���� �� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (4) NoNameReleaseOnDemand = REG_DWORD 0(False) �� 1 �� ���� �� ��ȣ           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2008
if %WinVer% geq 3 (
	echo �� Windows 2008 �̻� �ش���� ����                             			 				>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5.11-end
) else (
	echo [SynAttackProtect ����]                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\SynAttackProtect" /s >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [EnableDeadGWDetect ����]                                                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableDeadGWDetect" /s >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [KeepAliveTime ����]                                                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\KeepAliveTime" /s >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [NoNameReleaseOnDemand ����]                                                            >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################  ����ڰ� ������ ����̹��� ��ġ�� �� ���� �� ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "����ڰ� ������ ����̹��� ��ġ�� �� ���� ��" ��å�� "���"���� ������ ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AddPrinterDrivers=4,1 �̸� ��ȣ)                                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################   ���� ������ �ߴ��ϱ� ���� �ʿ��� ���޽ð�   ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ����" ��å�� "���"���� �����ϰ�,       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : "���� ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð�" ��å�� "15��"���� ������ ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (EnableForcedLogOff	1 �̰�, AutoDisconnect	15 �̸� ��ȣ)                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################                ��� �޽��� ����               ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ý����� �ҹ����� ��뿡 ���� ��� �޽���/������ �����Ǿ� �ִ� ��� ��ȣ        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Win NT]                                                            					 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\LegalNoticeCaption" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\LegalNoticeText" >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Win 2000�̻�]                                                            				>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################         ����ں� Ȩ ���͸� ���� ����        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ����� ������ Ȩ ���͸��� Eveyone ������ ���� ��� ��ȣ                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. > %think%\home-directory.txt
dir "C:\Users\*" | find "<DIR>" | findstr /V "All Defalt ."                                  >> %think%\home-directory.txt
FOR /F "tokens=5" %%i IN (home-directory.txt) DO cacls "C:\Users\%%i" | find /I "Everyone" > nul
IF %ERRORLEVEL% equ 1 (
echo �� Everyone ������ �Ҵ�� Ȩ���͸��� �߰ߵ��� �ʾ���.                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################              LAN Manager ���� ����            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"���� �����Ǿ� �ִ� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����  : (LM NTML ���� ����: LmCompatibilityLevel=4,0)                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (LM NTML NTLMv2���� ���� ���(����� ���): LmCompatibilityLevel=4,1)         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLM ���� ����: LmCompatibilityLevel=4,2)                                    >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLMv2 ���丸 ����: LmCompatibilityLevel=4,3)                                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLMv2 ���丸 ����WLM�ź�: LmCompatibilityLevel=4,4)                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLMv2 ���丸 ����WLM�ź� NTLM �ź�: LmCompatibilityLevel=4,5)               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : ���� ���� ��� �ƹ��͵� ������ �� �� ������                                   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ش� ������ �����ϸ� Ŭ���̾�Ʈ�� ���� �Ǵ� ���� ���α׷����� ȣȯ���� ������ ��ĥ �� ����. >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ���� ���� ���� ����                                                                     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################   ���� ä�� ������ ������ ��ȣȭ �Ǵ� ����    ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �Ʒ� 3���� ��å�� "���" ���� �Ǿ� ���� ��� ��ȣ                               >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: (1) ������ ������: ���� ä�� �����͸� ������ ��ȣȭ �Ǵ� ����(�׻�)           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (2) ������ ������: ���� ä�� �����͸� ������ ��ȣȭ(������ ���)              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (3) ������ ������: ���� ä�� �����͸� ������ ����(������ ���)                >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (4,1)���, (4,0)��� �� ��                							  		 	>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             ���� �� ���丮 ��ȣ             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���Ͻý����� ���� ����� ���� ���ִ� NTFS�� ��� ��ȣ                           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo [����]                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo C: ����̺� ���� Ȯ��(NTFS�� ��� ������ ���� �ο� ������ ��µ�)                       >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################        ��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ        ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "��ǻ�� ���� ��ȣ ���� ��� ����" ��å "������"���� ���� �Ǿ� �ְ�,           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å�� "90��"�� �����Ǿ� �ִ� ��� ��ȣ     >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (DisablePasswordChange=4,0 �̰�, MaximumPasswordAge=4,90 �̸� ��ȣ)           >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################             �������α׷� ��� �м�            ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� ���α׷����� ���ʿ��� ���񽺰� ��ϵǾ� ���� �ʰ�, �ֱ������� �����ϴ� ��� ��ȣ >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (����� ���ͺ� �� ���� ���α׷� ���˰��� ���� Ȯ��)                         >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� ���α׷� Ȯ��(HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run)  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo �� ���� ���α׷� Ȯ��(HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run) >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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
echo ##################            Windows ���� ��� ���             ###################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Windows ���� ���� �����Ǿ� �ִ� ��� ��ȣ (LoginMode 1 �̸� ��ȣ)             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) LoginMode 1 �̸� Windows ���� ���                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) LoginMode 2 �̸� SQL Server �� Windows ���� ���                          >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.01-end
)

:: winver >= 2003
if %WinVer% geq 2 (
	net start | find "SQL Server" > NUL
	IF NOT ERRORLEVEL 1 (
		ECHO �� SQL Server Enable                                                                  >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 6.01-start
		echo.                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)	ELSE (
		ECHO �� SQL Server Disable                                                                 >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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

::�ý��� ���� ��� ����
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
	echo C:\WINDOWS\system32\inetsrv\MetaBase.xml �������� ����.                             >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############                      ���� ����                     #################### >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
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

::�ý��� ���� ��� ��



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ����2::::::::::::::::::::::::::::::::::::::::::
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


rem Netbios ����
del %think%\2-18-netbios-list-1.txt 2> nul
del %think%\2-18-netbios-list-2.txt 2> nul
del %think%\2-18-netbios-list.txt 2> nul
del %think%\2-18-netbios-query.txt 2> nul
del %think%\2-18-netbios-result.txt 2> nul


rem DB ���� ����
del %think%\unnecessary-user.txt 2>nul
del %think%\password-null.txt 2>nul


rem IIS ���� del
del %think%\iis-enable.txt 2>nul
del %think%\iis-version.txt 2>nul
del %think%\website-list.txt 2>nul
del %think%\website-name.txt 2>nul
del %think%\website-physicalpath.txt 2>nul
del %think%\sample-app.txt 2>nul


rem FTP ���� del
del %think%\ftp-enable.txt 2>nul
del %think%\ftpsite-list.txt 2>nul
del %think%\ftpsite-name.txt 2>nul
del %think%\ftpsite-physicalpath.txt 2>nul
del %think%\ftp-ipsecurity.txt 2>nul


rem ���� ����̺� ��� ���� del
del %think%\inf_using_drv_temp3.txt 2>nul
del %think%\inf_using_drv_temp2.txt 2>nul
del %think%\inf_using_drv_temp1.txt 2>nul
del %think%\inf_using_drv.txt 2>nul



echo.                                                                                        >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �������������������������������������   END Time  �������������������������������������   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
date /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
time /t                                                                                      >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.
echo ��������������������������������������   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ����                                                              ����   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ����       Windows %WinVer_name% Security Check is Finished       ����   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ����                                                              ����   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��������������������������������������   >> %think%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.
echo [+] Windows Security Check is Finished
pause

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ��2::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

