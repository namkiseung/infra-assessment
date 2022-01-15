::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ����:::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off

setlocal
set logthink=C:\logthink
set john=%logthink%\john
set script=%logthink%\script

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
	echo Windows 2000 %WinBit%bit                                                            > %logthink%\real_ver.txt
)

:: windows 2003
if "%MV:~8,3%"=="5.2" (
	set WinVer=2
	set WinVer_name=2003
	echo Windows 2003 %WinBit%bit                                                            > %logthink%\real_ver.txt
)

:: windows 2008
if "%MV:~8,3%"=="6.0" (
	set WinVer=3
	set WinVer_name=2008
	echo Windows 2008 %WinBit%bit                                                            > %logthink%\real_ver.txt
)

:: windows 2008 r2
if "%MV:~8,3%"=="6.1" (
	set WinVer=4
	set WinVer_name=2008_R2
	echo Windows 2008 R2 %WinBit%bit                                                         > %logthink%\real_ver.txt
)

:: windows 2012
if "%MV:~8,3%"=="6.2" (
	set WinVer=5
	set WinVer_name=2012
	echo Windows 2012 %WinBit%bit                                                            > %logthink%\real_ver.txt
)

:: windows 2012 r2
if "%MV:~8,3%"=="6.3" (
	set WinVer=6
	set WinVer_name=2012_R2
	echo Windows 2012 R2 %WinBit%bit                                                         > %logthink%\real_ver.txt
)

:: windows 2016
if "%MV:~8,4%"=="10.0" (
	set WinVer=7
	set WinVer_name=2016
	echo Windows 2016 %WinBit%bit                                                         > %logthink%\real_ver.txt
)

type real_ver.txt > %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: windows 2008 �̻������ icacls
if %WinVer% geq 3 (
	doskey cacls=icacls $*
)
::���� ���� Ȯ�� ��



set SVERSION=19.1
set SCRIPT_LAST_UPDATE=2019.02
echo ======================================================================================= >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��������������������      Windows %WinVer_name% Security Check      ��������������������� >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��������������������      Copyright �� 2019, SK logthink Co. Ltd.    ��������������������� >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ======================================================================================= >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo SCRIPT_VERSION %SVERSION%                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo LAST_UPDATE %SCRIPT_LAST_UPDATE%                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �������������������������������������  Start Time  �������������������������������������  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
date /t                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
time /t                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt     
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

::sysinfo �ѱ�(chcp 437���� �ѱ� ??�� ���� ���� ����)
echo [+] Gathering systeminfo...
systeminfo																					 > %logthink%\systeminfo_ko.txt 2>nul

::�������� ����
chcp 437

::���� �������� ����
secedit /EXPORT /CFG Local_Security_Policy.txt >nul
net accounts > %logthink%\net-accounts.txt 


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
	%systemroot%\System32\inetsrv\appcmd list site | find /i "ftp"                           > %logthink%\ftpsite-list.txt
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
			echo %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k                                   >> %logthink%\ftpsite-name.txt
		)
	)
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (ftpsite-list.txt) do (
		cscript %script%\adsutil.vbs enum %%i | findstr /i "ServerComment ServerState"     >> %logthink%\ftpsite-name.txt
		echo -----------------------------------------------------------------------	   >> %logthink%\ftpsite-name.txt
	)
)

:: FTP Site physicalpath ���ϱ� ( ftpsite-physicalpath.txt )
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "physicalpath" > %logthink%\ftpsite-physicalpath-temp.txt
	for /f "tokens=3 delims= " %%a in (ftpsite-physicalpath-temp.txt) do (
		for /f "tokens=2 delims==" %%b in ("%%a") do echo %%~b >> ftpsite-physicalpath.txt
	)
	del ftpsite-physicalpath-temp.txt 2> nul
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (ftpsite-list.txt) do (
		cscript %script%\adsutil.vbs enum %%i/root | find /i "path" | find /i /v "AspEnableParentPaths" >> %logthink%\ftpsite-physicalpath-temp.txt
	)
	for /f "tokens=4-8 delims= " %%i in (ftpsite-physicalpath-temp.txt) do (
		echo %%i %%j %%k %%l %%m                                                              >> %logthink%\ftpsite-physicalpath.txt
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
systeminfo																					 > %logthink%\systeminfo.txt 2>nul

::Process List
:: winver = 2000
if %WinVer% equ 1 (
	%script%\pslist                                                                          > tasklist.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	tasklist																				 > %logthink%\tasklist.txt 2>nul
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ��:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##########################        1. ����� ����       ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0101 START                                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################          1.01 ���ʿ��� ���� ����              ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���ʿ��� ������ �������� ���� ��� ��ȣ                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ���ʿ��� ������ ���� ���ͺ� �ʿ�                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ****************************  User Accounts List  *****************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user | find /V "successfully" | findstr .                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *****************************  Account Information  ***************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        > %logthink%\account.txt 2>nul
FOR /F "tokens=1,2,3 skip=4" %%i IN ('net user') DO (
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%i >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%j >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%k >> account.txt 2>nul
)
findstr "User active Comment Last --" account.txt                                            > %logthink%\account_temp1.txt
findstr /v "change profile Memberships User's" account_temp1.txt                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0101 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0102 START                                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################    1.02 Administrator ���� �̸� �ٲٱ�    ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ������ ������ Administrator ���� �̸��� �����Ͽ� ����ϴ� ��� ��ȣ             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net localgroup Administrators | findstr /V "Comment Members completed" | findstr .           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

net localgroup Administrators | findstr /V "Comment Members completed" | findstr .           > %logthink%\1.02-result.txt
type 1.02-result.txt | findstr /V "Alias name" | findstr /i administrator | findstr .        > %logthink%\result.txt

net localgroup Administrators | findstr /V "Comment Members completed" | findstr . | findstr /V "Alias name" | findstr /i administrator | findstr . > nul
if %errorlevel% equ 0 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=Administrator																		>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O																				>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
del %logthink%\1.02-result.txt 2>nul
del %logthink%\result.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0102 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0103 START                                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################          1.03 GUEST ���� ����          ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Guest ���� ��Ȱ��ȭ�� ��� ��ȣ                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user guest | find "User name"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user guest | find "Account active"                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

net user guest | find "Account active" | %script%\awk -F" " {print$3}        >> %logthink%\result.txt

net user guest | find "Account active" | find "Yes" > nul
if %errorlevel% equ 0 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=Yes												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=No												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

del %logthink%\result.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0103 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0104 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################     1.04 ���� �α��� ����� ���� ����     ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "������ ����� �̸� ǥ�� ����" ��å�� "���"���� �����Ǿ� ���� ��� ��ȣ        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (DontDisplayLastUserName = 1)                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName" | %script%\awk -F" " {print$3} >> %logthink%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0104 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0105 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ########################     1.05 �α׿� ĳ�� ���� ����     ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "ĳ�� �� �α׿��� Ƚ��(��������Ʈ�ѷ��� ��� �Ұ����� ��쿡 ���)" �׸�      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.        "0��(�α׿� ĳ�� �� ��)"���� �����Ǿ� ������ ��ȣ                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

FOR /F "delims=" %%i IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v cachedlogonscount') DO SET logthink_result=%%i
if defined logthink_result (
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v cachedlogonscount >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo Registry key value not found: HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\cachedlogonscount >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
SET logthink_result=

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0105 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0106 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ########################      1.06 Autologon ��� ����      ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: AutoAdminLogon ���� ���ų�, AutoAdminLogon 0���� �����Ǿ� �ִ� ��� ��ȣ        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (DefaultPassword ��Ʈ���� �����Ѵٸ� ������ ���� �ǰ�)                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [AutoAdminLogon (1:Enable, 0:Disable, Default:Disable)]                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [Username]                                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [DefaultPassword]                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0106 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0107 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ########################    1.07 ���� ��� �Ӱ谪 ����    ############################# >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� ��� �Ӱ谪�� 5������ ������ �����Ǿ� �ִ� ��� ��ȣ  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� net accounts �� ���� ���� ��� �Ӱ谪 ���� Ȯ��                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type net-accounts.txt | find "Lockout threshold"                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


type net-accounts.txt | find "Lockout threshold" | %script%\awk -F" " {print$3}        		> %logthink%\result.txt

type %logthink%\result.txt | find /i "never" > nul
if %errorlevel% neq 1 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=Never												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
for /f %%r in (result.txt) do echo Result=%%r												 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ������Ʈ�� ���� ���� ���� ���� ���� ��� �Ӱ谪 ���� Ȯ��  [���ͺ� �ʿ�]            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "delims=" %%i IN ('reg query HKLM\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters\AccountLockout') DO SET logthink_result=%%i
if defined logthink_result (
	%script%\reg query HKLM\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters\AccountLockout >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo Registry key value not found: HKLM\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters\AccountLockout >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
SET logthink_result=

del %logthink%\result.txt 2>nul
echo 0107 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###########################        2. ���� ����       ################################# >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0201 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ########################        2.01 ���� �α׿� ���        ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� �α׿� ���" ��å�� "Administrators", "IUSR_" �� ������ ��� ��ȣ         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (Administrators = *S-1-5-32-544), (IUSR = *S-1-5-17)                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight"                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight" | %script%\awk -F= {print$2}                      >> %logthink%\result.txt

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
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

if ERRORLEVEL 1 (
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul
del %logthink%\result2.txt 2>nul
del %logthink%\result3.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0201 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0202 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################      2.02 �͸� SID/�̸� ��ȯ ���      ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�͸� SID/�̸� ��ȯ ���" ��å�� "��� �� ��" ���� �Ǿ� ���� ��� ��ȣ          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (LSAAnonymousNameLookup = 0)                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	type Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup"                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup" | %script%\awk -F" " {print$3}                      > %logthink%\result.txt

	for /f "delims= tokens=1" %%r in (result.txt) do echo Result=%%r	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul

)

echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0202 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0203 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############    2.03 �����͹̳� ���� ������ ����� �׷� ����    #################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: (������ ������ ������) ���������� ������ ������ �����Ͽ� Ÿ ������� ���������� >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : �����ϰ�, �������� ����� �׷쿡 ���ʿ��� ������ ��ϵǾ� ���� ���� ��� ��ȣ   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2008_R2
if %WinVer% geq 4 (
	net start | find /i "Remote Desktop Services" >nul
	IF NOT ERRORLEVEL 1 (
		echo �� Remote Desktop Services Enable                                          	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��� ����                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Administrators" | findstr /V "Comment Members completed" | findstr .         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Remote Desktop Users" | findstr /V "Comment Members completed" | findstr .   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	IF ERRORLEVEL 1 (
		echo �� Remote Desktop Services Disable                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
) else (
	NET START | FIND "Terminal Service" > NUL
	IF NOT ERRORLEVEL 1 (
		echo �� Terminal Service Enable                                          			>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��� ����                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Administrators" | findstr /V "Comment Members completed" | findstr .         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		net localgroup "Remote Desktop Users" | findstr /V "Comment Members completed" | findstr .   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	IF ERRORLEVEL 1 (
		echo �� Terminal Service Disable                                             		 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0203 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #########################        3. ��й�ȣ ����       ############################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0301 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##############    3.01 SNMP ���� GET Community ��Ʈ�� ���� ����    ################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: SNMP GET Community �̸��� public, private �� �ƴ� �����ϱ� ��ư� �����Ǿ�      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ���� ��� ��ȣ                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� SNMP ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� SNMP Service Enable                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� SNMP Service Disable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 301-end
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities ����]                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %logthink%\result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type result.txt | findstr /i "REG_DWORD" > nul
if %ERRORLEVEL% neq 0 (
	echo "string ���� �����Ǿ� ���� ����(N/A)"                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo "���� ���� �ǰ�"                                                						   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [SNMP Trap Commnunities ����]                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 301-end
	)


echo [SNMP Trap Commnunities ����]                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


type result.txt | findstr /i "public private" > nul
	if %ERRORLEVEL% equ 0 (
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if %ERRORLEVEL% neq 0 (
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
	
	

:301-end
del %logthink%\result.txt 2>nul
echo 0301 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0302 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##############    3.02 SNMP ���� SET Community ��Ʈ�� ���� ����    ################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: SNMP SET Community �̸��� public, private �� �ƴ� �����ϱ� ��ư� �����Ǿ�      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ���� ��� ��ȣ                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� SNMP ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� SNMP Service Enable                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� SNMP Service Disable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 302-end
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities ����]                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %logthink%\result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type result.txt | findstr /i "REG_DWORD" > nul
if %ERRORLEVEL% neq 0 (
	echo "string ���� �����Ǿ� ���� ����(N/A)"                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo "���� ���� �ǰ�"                                                						   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [SNMP Trap Commnunities ����]                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 302-end
	)


echo [SNMP Trap Commnunities ����]                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration" /s | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


type result.txt | findstr /i "public private" > nul
	if %ERRORLEVEL% equ 0 (
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if %ERRORLEVEL% neq 0 (
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
	
	

:302-end
del %logthink%\result.txt 2>nul
echo 0302 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0303 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################     3.03 ��й�ȣ ������å ����     ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ��й�ȣ ������å�� ������ ���� ������ ��� ��ȣ  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo MinimumPasswordAge 1  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo MaximumPasswordAge 90 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo MinimumPasswordLength 8 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo PasswordComplexity 1  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo PasswordHistorySize 12 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "MinimumPasswordAge"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "MaximumPasswordAge ="                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "MinimumPasswordLength"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "PasswordComplexity"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "PasswordHistorySize"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0303 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0304 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################     3.04 �������� �ʴ� ���� �� ��й�ȣ ����     ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� �н����� �������� 90�� ������ ���                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ��й�ȣ �̺��� ������ ���� ���ͺ� �ʿ�                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� �н����� �ִ� ���Ⱓ ���� Ȯ��                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "MaximumPasswordAge"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� �� �н����� ���� ���� Ȯ��                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "tokens=1 skip=4" %%i IN ('net user') DO net user %%i >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
FOR /F "tokens=2 skip=4" %%i IN ('net user') DO net user %%i >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
FOR /F "tokens=3 skip=4" %%i IN ('net user') DO net user %%i >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0304 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0305 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################      3.05 ���߰����� ��й�ȣ ��� ����      ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ��й�ȣ ���߰����� ������ ���� ��� ��ȣ                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : "��ȣ�� ���⼺�� �����ؾ� ��" ��å�� "���" ���� Ȯ��                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (PasswordComplexity = 1 �� ��� ���⼺ �����Ǿ� ����)                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ���߰����� ��й�ȣ ��� ���ο� ���� ���ͺ� �ʿ�                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� �н����� ���⼺ ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "PasswordComplexity"                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� : �ش� ���� ���� ����                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ****************************  User Accounts List  *****************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user | find /V "successfully" | findstr .                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *****************************  Account Information  ***************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        > %logthink%\account.txt 2>nul
FOR /F "tokens=1,2,3 skip=4" %%i IN ('net user') DO (
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%i >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%j >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%k >> account.txt 2>nul
)
findstr "User active Comment Last --" account.txt                                            > %logthink%\account_temp1.txt
findstr /v "change profile Memberships User's" account_temp1.txt                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0305 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0306 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############    3.06 �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����    #################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����; ��å ������,                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ClearTextPassword=0�� ��� ��ȣ                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "ClearTextPassword"                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "ClearTextPassword"  |  %script%\awk -F" " {print$3}    >> %logthink%\result.txt

for /f "delims= tokens=1" %%r in (result.txt) do set result=%%r
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=%result%												 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0306 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##########################        4. ���� ����       ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0401 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################      4.01 IIS ������ ���� ����      ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �������� ������������ ������ �����Ǿ� �ִ� ��� ��ȣ                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : 400, 401, 403, 404, 500 ������ ���� ������ �������� �����Ǿ� �ִ� ���          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::echo ��       : (��� ����) prefixLanguageFilePath="%SystemDrive%\inetpub\custerr" path="401.htm" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem �⺻ �����̱� ������ �� ������ �����.
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "World Wide Web Publishing Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� IIS Service Enable                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 4-01-enable
)	ELSE (
	ECHO �� IIS Service Disable                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 401
)

:4-01-enable
echo [��� ����Ʈ]                                                                        	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [�⺻ ����]                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\APPCMD list config | findstr "<error"                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:: iis ver <= 6
if %iis_ver_major% leq 6 (
cscript %script%\adsutil.vbs enum W3SVC | findstr "400, 401, 403, 404, 500,"                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%i in (website-name.txt) do (
			echo [WebSite Name] %%i                                          						>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo ---------------------------------------------------------------                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%i | findstr "<error" 				>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)

:: iis ver <= 6
if %iis_ver_major% leq 6 (
	FOR /F "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------------------------               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | findstr "400, 401, 403, 404, 500," > nul
		IF NOT ERRORLEVEL 1 (
			cscript %script%\adsutil.vbs enum %%i/root | findstr "400, 401, 403, 404, 500,"          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) ELSE (
			echo �⺻ ������ ����Ǿ� ����.                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)
echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:401
echo 0401 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0402 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #############    4.02 ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ����    ############# >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ý��� DSN �κ��� Data Source�� ���� ����ϰ� �ִ� ��� ��ȣ                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : Data Dource ��� ���ο� ���� ���ͺ� �ʿ�                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" | find "REG_SZ"                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" | find "REG_SZ"                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��� ���� ���� ��� ���ʿ��� ODBC/OLE-DB�� �������� ���� 						     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0402 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0403 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################      4.03 HTTP/FTP/SMTP ��� ����      ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: HTTP, FTP, SMTP ���ӽ� ��� ������ ������ �ʴ� ��� ��ȣ                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "World Wide Web Publishing Service" > NUL
IF NOT ERRORLEVEL 1 (
echo ---------------------------------HTTP Banner-------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\http_banner.vbs >nul
	type http_banner.txt								>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	del http_banner.txt 2>nul
)	ELSE (
	ECHO �� IIS Service Disable                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "ftp" > NUL
IF NOT ERRORLEVEL 1 (
echo -----------------------------------FTP Banner------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\ftp_banner.vbs >nul
	type ftp_banner.txt								>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	del ftp_banner.txt 2>nul
)	ELSE (
	ECHO �� FTP Service Disable                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "smtp" > NUL
IF NOT ERRORLEVEL 1 (
echo ---------------------------------SMTP Banner-------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\smtp_banner.vbs >nul
	type smtp_banner.txt								>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	del smtp_banner.txt 2>nul
)	ELSE (
	ECHO �� SMTP Service Disable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0403 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###########################        5. ���� ����        ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0501 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################       5.01 SNMP ���� ���� ����       ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Ư�� ȣ��Ʈ�κ��͸� SNMP ��Ŷ�� �޾Ƶ��̱�� �����Ǿ� �ִ� ��� ��ȣ            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (PermittedManagers ������ ������ ��ȣ)                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (PermittedManagers ������ ������ ��� ȣ��Ʈ���� SNMP ��Ŷ�� ���� �� �־� ���) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� SNMP ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "SNMP Service" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� SNMP Service Enable                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)	ELSE (
	ECHO �� SNMP Service Disable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 501-end
	)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP ValidCommunities ����]                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr . >> %logthink%\result.txt
type %logthink%\result.txt | findstr /i "REG_DWORD" > nul
if %ERRORLEVEL% neq 0 (
	echo "string ���� �����Ǿ� ���� ����(N/A)"                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo "���� ���� �ǰ�"                                                						   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 501-end
	)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SNMP Access Control ����]                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" | findstr . > %logthink%\result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %logthink%\result.txt | findstr /i "REG_SZ" > nul
	if %ERRORLEVEL% EQU 0 (
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if %ERRORLEVEL% NEQ 0 (
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:501-end

del %logthink%\result.txt 2>nul
echo 0501 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0502 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################        5.02 FTP ���� ���� ����        ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : Ư�� IP �ּҿ����� FTP ������ �����ϵ��� ���� ���� ������ ������ ��� ��ȣ     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : metabase.xml ���� ���� ����        											 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpService	Location ="/LM/MSFTPSVC" �� FTP ����Ʈ �⺻ ����                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpVirtualDir	Location ="/LM/MSFTPSVC/ID/ROOT"�� FTP ���� ����Ʈ ����      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : ���� ����Ʈ�� IPSecurity ������ ������ FTP ����Ʈ �⺻ ������ ���� ����        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IPSecurity="" �������� ����, IPSecurity="0102~" �������� ���� ����.            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �������� ����Ʈ���� ���� ���� ���� ������ ���˽� ��� ����.                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2008�̻� ipSecurity allowUnlisted ������ False�� �Ǿ�� ��ȣ                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : ipSecurity allowUnlisted True��� �׼��� ��� / False ��� �׼��� �ź�         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� FTP ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5-02-enable
) else (
	echo �� FTP Service Disable                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5-02-end
)

:5-02-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo �� ������ �⺻ FTP�� Ÿ FTP ���� ����� (����Ȯ��^)                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5-02-end
)
echo [��� ����Ʈ]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	type ftpsite-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	type ftpsite-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo *** ����Ʈ�� FTP �������� ���� Ȯ��                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	
	for /f "delims=" %%a in (ftpsite-name.txt) do (
		%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipAddress" > nul
		echo [FTP-Site Name] %%a                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		if not errorlevel 1 (
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipAddress" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipAddress" >> %logthink%\result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipSecurity AllowUnlisted" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%a /section:ipsecurity | find /i "ipSecurity AllowUnlisted" >> %logthink%\result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo * �������� ���� ����                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			)
		)
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	echo [FTP �������� ����]                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\ftp_ipsecurity.vbs >nul
	type ftp-ipsecurity.txt                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)



if %iis_ftp_ver_major% geq 7 (
	goto 5-022-enable
) 
if %iis_ftp_ver_major% leq 6 (
	goto 5-021-enable
)

:5-022-enable
type %logthink%\result.txt | find "ipSecurity allowUnlisted" | find "true" > nul
	if %ERRORLEVEL% NEQ 0 (
		echo Result=false												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if %ERRORLEVEL% EQU 0 (
		echo Result=true												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
del %logthink%\result.txt 2>nul	
goto 5-02-end

:5-021-enable
type ftp-ipsecurity.txt | find "SiteName" | find "Access Allow" > nul
		if %ERRORLEVEL% NEQ 0 (
			echo Result=false												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
		if %ERRORLEVEL% EQU 0 (
			echo Result=true												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)	
)
del %logthink%\ftp-ipsecurity.txt 2>nul

:5-02-end
echo 0502 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0503 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################    5.03 ������ �׷쿡 �ּ����� ����� ����    ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Administrator �׷쿡 ���ʿ��� ������ ������ ���� ��� ��ȣ                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ������ �׷� �� �ּ��� ����� ���� ���� ���� ���ͺ� �ʿ�                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net localgroup Administrators | findstr /V "Comment Members completed" | findstr .           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        > %logthink%\admin-account.txt 2>nul
echo *********************  Administrators Account Information  ********************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "tokens=1,2,3,4 skip=6" %%j IN ('net localgroup administrators') DO (
net user %%j %%k %%l %%m >> %logthink%\admin-account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %logthink%\admin-account.txt 2>nul
)
findstr c/:"User name | Account active | Last logon | -----" admin-account.txt               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0503 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0504 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############   5.04 Everyone ��� ������ �͸� ����ڿ��� ����    ################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ��Everyone ��� ������ �͸� ����ڿ��� ���롱 ��å�� �������ԡ� ���� �Ǿ� ���� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 		: (EveryoneIncludesAnonymous=4,0 �̸� ��ȣ)                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	type Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymous"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymous"						 >> %logthink%\result.txt

for /f "tokens=2 delims==" %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0504 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0505 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ################    5.05 �Ϲ� ������� ������ ����̹� ��ġ ����    ################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "����ڰ� ������ ����̹��� ��ġ�� �� ���� ��" ��å�� "���"���� ������ ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AddPrinterDrivers=4,1 �̸� ��ȣ)                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "AddPrinterDrivers"                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "AddPrinterDrivers" | %script%\awk -F= {print$2}       >> %logthink%\result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0505 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0506 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################     5.06 FTP ���丮 ���ٱ��� ����     ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : FTP Ȩ ���͸��� Everyone�� ���� ������ �������� ������ ��ȣ				              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� FTP ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5-06-enable
) else (
	echo �� FTP Service Disable                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5-06-end
)


:5-06-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� ������ �⺻ FTP�� Ÿ FTP ���� ����� (����Ȯ��^)                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 5-06-end
)
echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [��� ����Ʈ]                                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	type ftpsite-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	type ftpsite-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	echo [Ȩ���丮 ���� - WEB/FTP ���п�]                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol physicalpath" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� Ȩ���丮 ���ٱ��� Ȯ��                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f "delims=" %%a in (ftpsite-physicalpath.txt) do (
	echo [FtpSite HomeDir] %%a                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cacls %%a                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cacls %%a                                                                          >> %logthink%\result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %logthink%\result.txt | findstr /i "everyone" > nul
if %ERRORLEVEL% NEQ 0 (
 echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
if %ERRORLEVEL% EQU 0 (
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
del %logthink%\result.txt 2>nul



:5-06-end
echo 0506 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0507 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################    5.07 SAM ���� ���� ���� ����     ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ���������� ��ϵ� ��� ��ȣ  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

cacls %systemroot%\system32\config\SAM >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config\SAM > %logthink%\result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %logthink%\result.txt | find /V "NT AUTHORITY\SYSTEM" | find /V "BUILTIN\Administrators" | find "\" > nul
	if %errorlevel% neq 0 (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) 
	if %errorlevel% equ 0 (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
echo.                                                                              	     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\result.txt 2>nul
echo 0507 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0508 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################     5.08 ����ں� Ȩ ���丮 ���� ����     ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ����� Ȩ ���͸��� Eveyone ������ ���� ��� ��ȣ                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. > %logthink%\home-directory.txt
dir "C:\Users\*" | find "<DIR>" | findstr /V "All Defalt ."                                  >> %logthink%\home-directory.txt
FOR /F "tokens=5" %%i IN (home-directory.txt) DO cacls "C:\Users\%%i" | find /I "Everyone" > nul
IF %ERRORLEVEL% equ 1 (
echo �� Everyone ������ �Ҵ�� Ȩ���͸��� �߰ߵ��� �ʾ���.                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) ELSE (
	FOR /F "tokens=5" %%i IN (home-directory.txt) DO cacls "C:\Users\%%i" | find /I "Everyone" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0508 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0509 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############    5.09 �ý��� �α� ���� ���丮 ���� ���� ����   #################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ý��� �α� ���� ���丮�� Users ���� ���� ��� ��ȣ                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config\sam >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0509 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0510 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################   5.10 �̺�Ʈ �α׿� ���� ���� ���� ���� �̺�    #################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �̺�Ʈ �α״� ������ �ο� ������ ����ڰ� �� �� ���� ���                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : �̺�Ʈ �α� ���� ���� ���� ������Ʈ�� 3�� ���� ��� 1�� ��� ��ȣ               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\Application" �� Ȯ��  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\Application" | find "RestrictGuestAccess" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\Security" �� Ȯ��     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\Security" | find "RestrictGuestAccess" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\System" �� Ȯ��       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\System" | find "RestrictGuestAccess" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0510 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0511 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################    5.11 �����Ͽ� ���� ���� ���� ����     ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� �� ���� �α� ������ Everyone �׷�� Users �׷��� �������� ������ ��ȣ      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\logfiles >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls %systemroot%\system32\config >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0511 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0512 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################     5.12 �α׿����� �ʰ� �ý��� ���� ���     ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����1: "�α׿� ���� �ʰ� �ý��� ���� ���"�� "������"���� �����Ǿ� �ִ� ��� ��ȣ   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (ShutdownWithoutLogon	0 �̸� ��ȣ)                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "delims=" %%i IN ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system /v ShutdownWithoutLogon') DO SET logthink_result=%%i
if defined logthink_result (
	reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system /v ShutdownWithoutLogon >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo Registry key value not found: HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system\ShutdownWithoutLogon >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0512 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0513 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################    5.13 �������� ���� ���� ���� ����    ##################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ʿ��� �׷츸 ���� ����� �Ǿ������� ��ȣ                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ��Ʈ��ũ�� ���� �ý��� �׷� ������ ���� �����                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeNetworkLogonRight"                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ��Ʈ��ũ�� ���� �ý��� �׷� ������ �źε� �����                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeDenyNetworkLogonRight"                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� [����] Windows ����� sid Ȯ��                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
wmic useraccount get name,sid > 513a.txt
type 513a.txt                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� [����] Windows �׷���� sid Ȯ��                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
wmic group get name,sid > 513b.txt
type 513b.txt                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del 513a.txt
del 513b.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0513 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0514 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############   5.14 �Ϲ� ������� ��� �� ���� ���� ���� �̺�    ################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� �� ���丮 ���"�׸�� "���� �� ���丮 ����"�׸� ���� �׷캰 �������� >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ���� ������ Everyone �׷��̳� Guest �׷�, User �׷쿡 ���� ���� ������ �� ��ȣ  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ��� ���� Ȯ��                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeBackupPrivilege"                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ���� Ȯ��                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeRestorePrivilege"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� Windows ����� sid Ȯ��                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
wmic useraccount get name,sid > 514a.txt
type 514a.txt                                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� Windows �׷���� sid Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
wmic group get name,sid > 514b.txt
type 514b.txt                                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del 514a.txt
del 514b.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0514 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0515 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ############  5.15 �Ϲ� ������� �ý��� �ڿ� ������ ���� ���� ���� �̺�  ############## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� �Ǵ� �ٸ� ��ü�� ������ ��������" �׸� ���ѿ� Administrators �׷츸 ������ ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� �ý��� �ڿ� �������� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "SeTakeOwnershipPrivilege"                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� Windows ����� sid Ȯ��                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
wmic useraccount get name,sid > 515a.txt
type 515a.txt                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� Windows �׷���� sid Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
wmic group get name,sid >515b.txt
type 515b.txt                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del 515a.txt
del 515b.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0515 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###########################        6. ���� ����        ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0601 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################     6.01 ���ʿ��� SMTP ���� ���� ����     ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: SMTP�� ���������� �ʰų� ������ ������� ��� ��ȣ                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : SMTP ���� ��� �� ���뵵�� ���� ���ͺ� �ʿ�                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���μ��� �� Ȯ���� ���� SMTP ���� Ȯ��                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
NET START | find /i "SMTP" > NUL
IF NOT ERRORLEVEL 1 echo �� SMTP Service Enable                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF ERRORLEVEL 1 echo �� SMTP Service Disable                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ��Ʈ��(default : 25) Ȯ���� ���� SMTP ���� Ȯ��                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
netstat -an | findstr :25 > NUL
IF NOT ERRORLEVEL 1 echo �� SMTP Service Enable                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF ERRORLEVEL 1 echo �� SMTP Service Disable                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ��ȸ(SMTPSVC) Ȯ���� ���� SMTP ���� Ȯ��                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
sc query SMTPSVC                                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0601 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0602 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################       6.02 Anonymous FTP ��Ȱ��ȭ       ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : FTP�� ������� �ʰų� "�͸� ���� ���"�� üũ�Ǿ� ���� ���� ��� ��ȣ(Default : ��� �� ��) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : metabase.xml ���� ���� ����        											 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpService	Location ="/LM/MSFTPSVC" �� FTP ����Ʈ �⺻ ����                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : FTP ����Ʈ�� ���� ���� �� �ش� �⺻ ������ ���� ����.							 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpServer	Location ="/LM/MSFTPSVC/ID"�� FTP ����Ʈ�� ��ϵ� ���� ����Ʈ ���� >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : ���� ����Ʈ�� AllowAnonymous ������ ������ FTP ����Ʈ �⺻ ������ ���� ����    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : IIsFtpServer	Location ="/LM/MSFTPSVC/~/Public FTP Site"�� ���� �� ������� ���� >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-02-enable
) else (
	echo �� FTP Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-02-end
)

:6-02-enable
:: iis ver = 0
if %iis_ftp_ver_major%==0 (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� ������ �⺻ FTP�� Ÿ FTP ���� �����                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-02-end
)

echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [��� ����Ʈ]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (


	type ftpsite-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [FTP ���� ���� Ȯ��]                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol anonymousAuthentication enabled" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol anonymousAuthentication enabled" > %logthink%\result.txt
	echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-022-enable	
) 
	type ftpsite-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo [�⺻ ����]                                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "AllowAnonymous"                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs enum MSFTPSVC | find /i "AllowAnonymous"                   > %logthink%\result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo *** ����Ʈ�� ���� Ȯ��                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	for /f "tokens=1 delims=[]" %%i in (ftpsite-list.txt) do (
		echo [FtpSite AppRoot] %%i                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i | find /i "AllowAnonymous" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i | find /i "AllowAnonymous"                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i | find /i "AllowAnonymous"                 > %logthink%\result.txt
			echo.                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			goto 6-021-enable
		) 
			echo AllowAnonymous : �⺻ ������ ����Ǿ� ����.                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo AllowAnonymous : �⺻ ������ ����Ǿ� ����.                                 > %logthink%\result.txt
			echo.                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 6-021-enable
	)


::7�̻�
:6-022-enable
type %logthink%\result.txt | find /i "anonymousAuthentication" | find /i "true" > nul
::echo %errorlevel%
if %errorlevel% neq 0 (
	echo Result=false												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-02-end
) else (
	echo Result=true												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-02-end
)



:6-021-enable
::6�̸�
type %logthink%\result.txt | find /i "AllowAnonymous" | find /i "True" > nul
if %errorlevel% neq 0 (
 echo Result=false												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-02-end
)
echo Result=true												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt



:6-02-end
del %logthink%\result.txt 2>nul
echo 0602 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0603 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################      6.03 �ϵ��ũ �⺻ ���� ����      ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �⺻���� �׸�(C$, D$)�� �������� �ʰ� AutoShareServ4er ������Ʈ�� ���� 0�� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : NT�� ��� �⺻���� �׸��� �������� �ʰ� AutoShareWks ������Ʈ�� ���� 0�� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� �ϵ��ũ �⺻ ���� Ȯ��                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]"  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]" > nul
if %ERRORLEVEL% EQU 1 (
echo �⺻ ���� ������ ���� ���� �ʽ��ϴ�.													>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� Registry ����								                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer" | %script%\awk -F" " {print$3} > defaultshare.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

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
	echo Result=F                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo Result=%result02021%                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0603 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0604 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
chcp 949
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################     6.04 ���� ���� �� ����� �׷� ����     ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �Ϲݰ��� ������ ���ų� ���� ���丮 ���� ������ Everyone ���� �� ����������    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : �̷�� ���� ��� ��ȣ                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : �Ϲݰ��� ���� ���� �� ���ͺ� Ȯ�� �ʿ�                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | find /v "$" | find /v "���"			                                      	 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net share | find /v "$" | find /v "���" | find /v "------"                                    	 > %logthink%\inf_share_folder.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type inf_share_folder.txt | find "\" > nul
IF %ERRORLEVEL% neq 0 echo ���������� �������� �ʽ��ϴ�.								>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo �� cacls ���                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	FOR /F "tokens=2 skip=3" %%j IN (inf_share_folder.txt) DO cacls %%j                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
	
	FOR /F "tokens=2 skip=3" %%j IN (inf_share_folder.txt) DO cacls %%j  					>> %logthink%\result.txt
	type %logthink%\result.txt | findstr /i "everyone" > nul
	if NOT ERRORLEVEL 1 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if ERRORLEVEL 1 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: winver >= 2003
if %WinVer% geq 2 (	
	fsutil fsinfo drives 																	 > %logthink%\inf_using_drv_temp1.txt
	type inf_using_drv_temp1.txt | find /i "\" 												 > %logthink%\inf_using_drv_temp2.txt

	echo.																					 > %logthink%\inf_using_drv_temp3.txt
	FOR /F "tokens=1-26" %%a IN (inf_using_drv_temp2.txt) DO (
		echo %%a >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%b >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%c >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%d >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%e >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%f >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%g >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%h >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%i >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%j >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%k >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%l >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%m >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%n >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%o >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%p >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%q >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%r >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%s >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%t >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%u >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%v >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%w >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%x >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%y >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%z >> %logthink%\inf_using_drv_temp3.txt 2> nul
	)
	type inf_using_drv_temp3.txt | find /i "\" | find /v "A:\" 								 > %logthink%\inf_using_drv.txt
	
	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		type inf_share_folder.txt | find "%%a"												 >> %logthink%\inf_share_folder_temp.txt
	
	)
	
	%script%\sed "s/   */?/g" %logthink%\inf_share_folder_temp.txt 							 > %logthink%\inf_share_folder_temp_sed.txt
	type inf_share_folder_temp_sed.txt | findstr "^?"										 > %logthink%\inf_share_folder_temp_sed2.txt
	
	for /F "tokens=2 delims= " %%a in (inf_share_folder_temp.txt) do cacls ^"%%a^"		 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	for /F "tokens=2 delims=?" %%a in (inf_share_folder_temp_sed.txt) do cacls ^"%%a^"		 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	for /F "tokens=1 delims=?" %%a in (inf_share_folder_temp_sed2.txt) do cacls ^"%%a^"		 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	
	for /F "tokens=2 delims= " %%a in (inf_share_folder_temp.txt) do cacls ^"%%a^"		 >> %logthink%\result.txt
	for /F "tokens=2 delims=?" %%a in (inf_share_folder_temp_sed.txt) do cacls ^"%%a^"        >> %logthink%\result.txt 
	for /F "tokens=1 delims=?" %%a in (inf_share_folder_temp_sed2.txt) do cacls ^"%%a^"		  >> %logthink%\result.txt
	
	type %logthink%\result.txt | findstr /i "everyone" 2>nul
	if NOT ERRORLEVEL 1 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	if ERRORLEVEL 1 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Everyone ������ �������� �ʽ��ϴ�.														>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
)

del %logthink%\result.txt 2>nul
chcp 437
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0604 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0605 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################     6.05 ������ ��й�ȣ �� ���� ����      ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����1: "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"���� �Ǿ� ���� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (LimitBlankPasswordUse = 4,1)                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem ��� ���� �������� ������ Default ���� ����(Default ����: LimitBlankPasswordUse 1 ��ȣ)
echo �� ����2: ��й�ȣ �̼��� ���� ������ �� ��ȣ                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �̻�� ����, ����� ������ ���� ���ͺ� �ʿ�                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ������ �� ��ȣ ��� ����                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	type Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse"                >> %logthink%\result.txt
	for /f "delims== tokens=2" %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul

	
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ����� ���� ���� Ȯ��                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ****************************  User Accounts List  *****************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user | find /V "successfully" | findstr .                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� �� �н����� ���� ���� Ȯ��                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *****************************  Account Information  ***************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        > %logthink%\account.txt 2>nul
FOR /F "tokens=1,2,3 skip=4" %%i IN ('net user') DO (
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%i >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%j >> account.txt 2>nul
echo -------------------------------------------------------------------------------         >> %logthink%\account.txt 2>nul
net user %%k >> account.txt 2>nul
)
findstr "Password required --" account.txt                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0605 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0606 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##############    6.06 ���� �͹̳� ������ ��ȣȭ ���� ���� ����    ################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �͹̳� ���񽺸� ������� �ʴ� ��� ��ȣ                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : �͹̳� ���񽺸� ��� �� ��ȣȭ ������ "Ŭ���̾�Ʈ�� ȣȯ����(�߰�)" �̻����� ������ ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (MinEncryptionLevel	2 �̻��̸� ��ȣ)                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2008_R2
if %WinVer% geq 4 (
	goto 6-061-enable
) else (
	goto 6-062-enable
)

:6-061-enable
net start | find /i "Remote Desktop Services" >nul
	IF NOT ERRORLEVEL 1 (
		echo �� Remote Desktop Services Enable                                          	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��ȣȭ ���� ���� Ȯ��                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo --------------------------------------------------------------------------------- >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" | %script%\awk -F" " {print$3}	> %logthink%\result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                     
		)
	IF ERRORLEVEL 1 (
		echo �� Remote Desktop Services Disable                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=2												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)

goto 6-06-end

:6-062-enable
NET START | FIND "Terminal Service" > NUL
	IF NOT ERRORLEVEL 1 (
		echo �� Terminal Service Enable                                          			>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� ���� ��ȣȭ ���� ���� Ȯ��                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo --------------------------------------------------------------------------------- >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\MinEncryptionLevel" | %script%\awk -F" " {print$3}	> %logthink%\result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	IF ERRORLEVEL 1 (
		echo �� Terminal Service Disable                                             		 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=2												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)

:6-06-end

	


del %logthink%\result.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0606 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0607 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################     6.07 Telnet ���� ��� ���� �̺�     ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Telnet ���񽺰� ���� �ǰ� ���� �ʰų�, ��������� NTLM�� ����� ��� ��ȣ       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : [����]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (SecurityMechanism 2. NTLM)                                                 	 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (SecurityMechanism 6. NTLM, Password)                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (SecurityMechanism 4. Password)                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "telnet" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� TELNET Service Enable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-enable
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) ELSE (
	ECHO �� TELNET Service Disable 																	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
)

:telnet-enable
	%script%\reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr . | find /v "Listing of" | find /v "system was unable" > nul
	IF %ERRORLEVEL% neq 0 (
		reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %logthink%\result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\Software\Microsoft\TelnetServer\1.0" /s | findstr /i "SecurityMechanism" >> %logthink%\result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
:: winver < 2008R2
if %WinVer% leq 3 (
goto 0607-2008
)

:: winver > 2008
if %WinVer% geq 4 (
 goto 0607-2008R2
)


:0607-2008
type %logthink%\result.txt | findstr /i "REG_DWORD" | find "2" > nul
	if %ERRORLEVEL% neq 1 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	) else (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:0607-2008R2
type %logthink%\result.txt | findstr /i "REG_DWORD" | findstr /i "0x2" > nul
	if %ERRORLEVEL% neq 1 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	) else (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto telnet-end
	)
echo.  	
	
	
:telnet-end
del %logthink%\result.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0607 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0608 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################    6.08 ���� �͹̳� ���� Ÿ�Ӿƿ� �̼���     ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� �͹̳��� ������� �ʰų�, ��� �� Session Timeout�� �����Ǿ� �ִ� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (MaxIdleTime ���� Ȯ�� ���: 60000=1��, 300000=5��)                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: winver <= 2008
if %WinVer% leq 3 (
	goto 608-2008
)

:: winver = 2008_R2
if %WinVer% equ 4 (
	goto 608-2008r2
)

:: winver >= 2012
if %WinVer% geq 5 (
	goto 608-2012
)



:608-2008
NET START > netstart.txt
type netstart.txt | FIND "Terminal Service" > NUL
	IF %ERRORLEVEL% neq 1 (
		echo �� Terminal Service Enable                                          			>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� Session Timeout ����                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /s | findstr "MaxIdleTime" > %logthink%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		type %logthink%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %logthink%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.
		) else (
		echo �� Terminal Service Disable                                             		 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 608-end		
		)
goto 608-end



:608-2008R2
net start > netstart.txt
type netstart.txt | find /i "Remote Desktop Services" > nul
	IF %ERRORLEVEL% neq 1 (
		echo �� Remote Desktop Services Enable                                          	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� Session Timeout ����                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /s | findstr "MaxIdleTime" > %logthink%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		type %logthink%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %logthink%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.        
		) else (
		echo �� Remote Desktop Services Disable                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 608-end		
		)
goto 608-end	


:608-2012
net start > netstart.txt
type netstart.txt | find /i "Remote Desktop Services" > nul
	IF %ERRORLEVEL% neq 1 (
		echo �� Remote Desktop Services Enable                                          	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ���� �͹̳� Session Timeout ����                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /s | findstr "MaxIdleTime" > %logthink%\idletime.txt
		type idletime.txt | findstr /v "fInheritMaxIdleTime"                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
		echo �� Remote Desktop Services Disable                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=1												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 608-end		
		)
		
	type %logthink%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD"	
		if %ERRORLEVEL% neq 0 (
		echo IdleTime ������ �Ǿ� ���� �ʽ��ϴ�.					>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=0												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
		type %logthink%\idletime.txt | findstr /v "fInheritMaxIdleTime" | find "REG_DWORD" | %script%\awk -F" " {print$3}        > %logthink%\result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.											>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
		
goto 608-end	

		
		
:608-end
echo.     																								>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\result.txt 2>nul                                                                                   
del %logthink%\netstart.txt 2>nul
echo 0608 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0609 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################    6.09 SMB ���� �ߴ� ���� ���� �̺�   ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: '�α׿� �ð��� ����Ǹ� Ŭ�󸮾�Ʈ ���� ����' ��å�� "���"����,                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt         
echo.      : '���� ������ �ߴ��ϱ� ���� �ʿ��� ���޽ð�' ��å�� "15��"���� ������ ��� ��ȣ  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (EnableForcedLogOff	1 �̰�, AutoDisconnect	15 �̸� ��ȣ)                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� '�α׿� �ð��� ����Ǹ� Ŭ�󸮾�Ʈ ���� ����' ��å                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters\EnableForcedLogOff" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� '���� ������ �ߴ��ϱ� ���� �ʿ��� ���޽ð�' ��å                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters\AutoDisconnect" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0609 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0610 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ################    6.10 SAM ������ ������ �͸� ���� ��� �� ��    #################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "SAM ������ ������ �͸� ���� ��� ����" ��å�� "���"�̰�,                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : "SAM ������ �͸� ���� ��� ����" ��å�� "���"���� �����Ǿ� �ִ� ��� ��ȣ      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (2003 �̻� : restrictanonymous	1 �̰�, RestrictAnonymousSAM	1 �̸� ��ȣ)     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (2000 : restrictanonymous	2 �̰�, RestrictAnonymousSAM	2 �̸� ��ȣ)         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SAM ������ ������ �͸� ���� ��� ���� ����]                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA\restrictanonymous"             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [SAM ������ �͸� ���� ��� ���� ����]                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\System\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM"	         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA\restrictanonymous" | %script%\awk -F" " {print$3}       > %logthink%\result.txt
for /f %%r in (result.txt) do set restrict=%%r


%script%\reg query "HKLM\System\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM"	| %script%\awk -F" " {print$3}         > %logthink%\result.txt
for /f %%s in (result.txt) do echo Result=%restrict%:%%s												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\result.txt 2>nul
echo 0610 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0611 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################    6.11 NetBIOS ���ε� ���� ���� ����    ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ��ִ� ��� (Registry ���� 2�϶�) ��ȣ    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Windows 2000 ������ ȯ�濡�� AD�� ����� ��� ����                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (NetBIOS ��� ���� ����: NetbiosOptions 0x2 ��ȣ)                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (NetBIOS ��� ����: NetbiosOptions 0x1 ���)                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (�⺻ ��: NetbiosOptions 0x0 ���)                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (�������� ���) ���ͳ� ��������(TCP/IP)�� ������� �� ��� �� Wins ���� TCP/IP���� NetBIOS ��� ���� (139��Ʈ����) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" | findstr /iv "listing" > 2-18-netbios-list.txt
	for /f "tokens=1 delims=[" %%a in (2-18-netbios-list.txt) do echo %%a >> 2-18-netbios-list-1.txt
	for /f "tokens=1 delims=]" %%a in (2-18-netbios-list-1.txt) do echo %%a >> 2-18-netbios-list-2.txt
	FOR /F %%a IN (2-18-netbios-list-2.txt) do echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\%%a\NetbiosOptions >> 2-18-netbios-query.txt
	FOR /F %%a IN (2-18-netbios-query.txt) do %script%\reg query %%a >> 2-18-netbios-result.txt
	echo [NetBIOS over TCP/IP ���� ��Ȳ]                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	TYPE 2-18-netbios-result.txt	                            							>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s | findstr . >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2>nul
)
echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0611 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0612 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################       6.12 ���ʿ��� ���� ����       ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ý��ۿ��� �ʿ����� �ʴ� ����� ���񽺰� �����Ǿ� ���� ��� ��ȣ                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) Alerter(�������� Ŭ���̾�Ʈ�� ���޼����� ����)                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) Clipbook(������ Clipbook�� �ٸ� Ŭ���̾�Ʈ�� ����)                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) Messenger(Net send ��ɾ �̿��Ͽ� Ŭ���̾�Ʈ�� �޽����� ����)          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (4) Simple TCP/IP Services(Echo, Discard, Character, Generator, Daytime, ��)  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr "Alerter ClipBook Messenger"                                             > %logthink%\service.txt
net start | find "Simple TCP/IP Services"                                                    >> %logthink%\service.txt

net start | findstr /I "Alerter ClipBook Messenger TCP/IP" service.txt > NUL
IF ERRORLEVEL 1 ECHO �� ���ʿ��� ���񽺰� �������� ����.                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF NOT ERRORLEVEL 1 (
echo �� �Ʒ��� ���� ���ʿ��� ���񽺰� �߰ߵǾ���.                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type service.txt                                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /I "Alerter ClipBook Messenger TCP/IP" service.txt > NUL
IF ERRORLEVEL 1 ECHO Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF NOT ERRORLEVEL 1 echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0612 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0613 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################      6.13 FTP ���� ���� ����      ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: FTP ���񽺸� ������� �ʰų�, ������ ��� ���� ��� ��ȣ                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : FTP ���� ��� �� ���뵵�� ���� ���ͺ� �ʿ�                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� FTP ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist ftp-enable.txt (
	echo �� FTP Service Enable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	net start | findstr /i "ftp"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-13-enable
) else (
	echo �� FTP Service Disable                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-13-end
)

:6-13-enable


echo [��� ����Ʈ]                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ftp_ver_major% geq 7 (
	type ftpsite-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ftp_ver_major% leq 6 (
	type ftpsite-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:6-13-end
echo 0613 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0614 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################       6.14 IIS WebDAV ��Ȱ��ȭ       ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ���� �� �� ������ �ش�Ǵ� ��� ��ȣ                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 1. IIS �� ������� ���� ���                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2. DisableWebDAV ���� 1�� �����Ǿ� �������                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 3. Windows NT, 2000�� ������ 4 �̻��� ��ġ�Ǿ� ���� ���                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 4. Windows 2003, Windows 2008�� WebDAV �� ���� �Ǿ� ���� ���                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : "0,C:\WINDOWS\system32\inetsrv\httpext.dll,0,WEBDAV,WebDAV" (WebDAV ����-��ȣ) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : "1,C:\WINDOWS\system32\inetsrv\httpext.dll,0,WEBDAV,WebDAV" (WebDAV ���-���) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2008 �̻��� ��� allowed="false"   (WebDAV ����-��ȣ) 						 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 2008 �̻��� ��� allowed="True"    (WebDAV ���-���) 						 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-14-enable
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-14-end
)

:6-14-enable

:: winver = 2000
if %WinVer% equ 1 (
	ECHO �� Win 2000�� ��� ������ 4 �̻� ��ȣ                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "kernel version"                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack"                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}	> %logthink%\result.txt
	goto 6.14-2000
	echo.
)

:: iis ver =< 6
if %iis_ver_major% leq 6 (
	echo [WebDAV ���� Ȯ��]                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\adsutil.vbs enum W3SVC | find /i "webdav" | find /v "WebDAV;WEBDAV"            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\adsutil.vbs enum W3SVC | find /i "webdav" | find /v "WebDAV;WEBDAV"            > %logthink%\result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.14-2003
)


:: iis ver >=7
if %iis_ver_major% geq 6 (
	echo [WebDAV ���� Ȯ��]                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:isapiCgiRestriction | find /i "webdav" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:isapiCgiRestriction | find /i "webdav" > %logthink%\result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.14-2008
)

:6.14-2003
type result.txt | find "1," >nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6-14-end
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6-14-end



:6.14-2008	
type result.txt | find /i "true" >nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6-14-end
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6-14-end


:6-14-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [���� - Registry ����(DisableWebDAV)]                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\registry\DisableWebDAV" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\DisableWebDAV" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��� ���� �������� ���� ��� �ٸ� �������� ����                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [���� - OS Version, Service Pack]                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	type systeminfo.txt | find /i "kernel version"                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack"                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:: winver >= 2003
if %WinVer% geq 2 (
	type systeminfo.txt | find /i "os name"                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios"                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\result.txt 2>nul
echo 0614 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0615 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################   6.15 ���ʿ��� Tmax WebtoB ���� ���� ����   ##################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Webtob �������� ���������� �ʰų� ������ ������� ��� ��ȣ                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : Webtob ������ ���� �� ���뵵�� ���� ���ͺ� �ʿ�                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���μ��� �� Ȯ���� ���� (WEBTOB)���� ���� Ȯ��                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt  
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt  
net start | find /i "webtob" > NUL
IF NOT ERRORLEVEL 1 (
echo �� WEBTOB Service Enable     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo �� WEBTOB Service Disable    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ��ȸ(WEBTOB) Ȯ���� ���� ���� ���� Ȯ��                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
sc query Webtob       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0615 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0616 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #########################      6.16 IIS CGI ���� ����      ############################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �ش� ���͸� Everyone�� ��� ����, ���� ����, ���� ������ �ο����� ���� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �ش� ���͸��� ������� �ʴ� ��� ��ȣ                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �ش� ���͸� : C:\inetpub\scripts,  C:\inetpub\cgi-bin                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.16-end
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

IF EXIST C:\inetpub\scripts (
	cacls C:\inetpub\scripts                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls C:\inetpub\scripts                                                                 > %logthink%\result.txt
	echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) ELSE (
	echo C:\inetpub\scripts ���͸��� �������� ����.                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

IF EXIST C:\inetpub\cgi-bin (
	cacls C:\inetpub\cgi-bin                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cacls C:\inetpub\cgi-bin                                                                >> %logthink%\result.txt
) ELSE (
	echo C:\inetpub\cgi-bin ���͸��� �������� ����.                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %logthink%\result.txt | find /i /v "(ID)R" | find /i "everyone" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:6.16-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0616 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0617 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ########################     6.17 IIS ���� ���� ����     ############################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : IIS ���񽺰� ���ʿ��ϰ� �������� �ʴ� ��� ��ȣ(����� ���ͺ�)                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt              
if exist iis-enable.txt (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-17-enable
) else (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=Disabled																		>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-17-end
)


:6-17-enable

echo [IIS Version Ȯ��]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type iis-version.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [��� ����Ʈ]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:6-17-end

echo 0617 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0618 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################      6.18 IIS ���͸� ������ ����      ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ���͸� �������� �Ұ����� ��� ��ȣ                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �⺻ ���� �� ����Ʈ�� "���͸� �˻�" ������ False �̸� ��ȣ                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-18-enable
) else (
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-18-end
)

:6-18-enable

echo [��� ����Ʈ]                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [�⺻ ����]                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config | find /i "directoryBrowse"             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config | find /i "directoryBrowse"             > %logthink%\result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs get W3SVC/EnableDirBrowsing  | find /i /v "Microsoft"      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs get W3SVC/EnableDirBrowsing  | find /i /v "Microsoft"      > %logthink%\result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%i in (website-name.txt) do (
		echo [WebSite Name] %%i                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%i | find /i "directoryBrowse"       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%i | find /i "directoryBrowse"      >> %logthink%\result.txt
		echo.                                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | find /i "EnableDirBrowsing" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i/root | find /i "EnableDirBrowsing"         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i/root | find /i "EnableDirBrowsing"         >> %logthink%\result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo * �⺻ ������ ����Ǿ� ����.                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)

type result.txt | find /i "true" > nul
if %errorlevel% equ 0 (
echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=true												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=false												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:6-18-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\result.txt 2>nul
echo 0618 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0619 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################       6.19 IIS ���� ���͸� ���� ����       ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ���� ���͸� ���� ������ ��Ȱ��ȭ �Ǿ� �־�, ������ �Ұ����� ��� ��ȣ        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : "���� ��� ���" �ɼ��� üũ�Ǿ� ���� ���� ��� ��ȣ                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (asp enableParentPaths="false")                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-19-enable
) else (
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-19-end
)

:6-19-enable
echo [��� ����Ʈ]                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [�⺻ ����]                                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" > nul
	IF NOT ERRORLEVEL 1 (
		%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config /section:asp | find /i "enableParentPaths" > %logthink%\result.txt
	) ELSE (
		echo * ������ ���� * �⺻���� : enableParentPaths=false                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs get W3SVC/AspEnableParentPaths  | find /i /v "Microsoft"    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	cscript %script%\adsutil.vbs get W3SVC/AspEnableParentPaths  | find /i /v "Microsoft"    > %logthink%\result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%i in (website-name.txt) do (
		%systemroot%\System32\inetsrv\appcmd list config %%i /section:asp | find /i "enableParentPaths" > nul
		echo [WebSite Name] %%i                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		if not errorlevel 1 (
			%systemroot%\System32\inetsrv\appcmd list config %%i /section:asp | find /i "enableParentPaths" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			%systemroot%\System32\inetsrv\appcmd list config %%i /section:asp | find /i "enableParentPaths" >> %logthink%\result.txt
			echo.                                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo * ������ ���� * �⺻���� : enableParentPaths=false                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | find /i "AspEnableParentPaths" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i/root | find /i "AspEnableParentPaths"     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i/root | find /i "AspEnableParentPaths"     >> %logthink%\result.txt
			echo.                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo AspEnableParentPaths : * �⺻ ������ ����Ǿ� ����.                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)



type result.txt | find /i "true" > nul
if %errorlevel% equ 0 (
echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=true											   	>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=false												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:6-19-end
del %logthink%\result.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0619 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0620 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################      6.20 IIS ���ʿ��� ���� ����       ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : IISSamples, IISHelp ������͸��� �������� ���� ��� ��ȣ                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 		 (IIS 7.0 �̻� ���� �ش� ���� ����)						                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-20-enable
) else (
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-20-end
)

:6-20-enable
echo [���� ���͸� ���� ��Ȳ]                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	echo �� IIS 7.0 �̻� ���� �ش� ���� ����							                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

::20160114 ������(�ش���� �������� ������)
::if %iis_ver_major% geq 7 (
	::%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "virtualdirectory" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)

::20160114 ������(IISSample �� ������ �Ǵܰ����ϰ� ������)
:: iis ver <= 6
::if %iis_ver_major% leq 6 (
	::%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)

if %iis_ver_major% leq 6 (
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | findstr "IISSamples IISHelp" >> %logthink%\sample-app.txt
	type sample-app.txt                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	findstr "IISSamples IISHelp" sample-app.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * ���˰��: IISSamples, IISHelp ������͸��� �������� ����.                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
	)	ELSE (
		ECHO * ���˰��: IISSamples, IISHelp ������͸��� ������.                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt				
	)
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:6-20-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0620 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0621 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################      6.21 IIS �� ���μ��� ���� ����       ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : IIS ���񽺰� ���� ��� �ʿ��� �ּ��� �������� �����Ǿ� ������ ��ȣ         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.21-end
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [World Wide Web Publishing Service ���� ����]                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\ObjectName"                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\ObjectName"                 >> %logthink%\result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [IIS Admin Service ���� ����]                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN\ObjectName"              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN\ObjectName"              >> %logthink%\result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %logthink%\result.txt | find "LocalSystem" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:6.21-end
del %logthink%\result.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0621 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0622 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################        6.22 IIS ��ũ ������        ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �� ������ ���͸��� �ٷΰ��� ������ �������� ������ ��ȣ                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �� ����Ʈ Ȩ���͸��� �ɺ��� ��ũ, aliases, *.lnk ������ �������� ������ ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-22-enable
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-22-end
)

:6-22-enable
echo [��� ����Ʈ]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:: iis ver >= 7
if %iis_ver_major% geq 7 (
	echo [Ȩ���丮 ���� - WEB/FTP ���п�]                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | findstr /i "name protocol physicalpath" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���ʿ� ���� üũ                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f "delims=" %%a in (website-physicalpath.txt) do (
	echo [Website HomeDir] %%a                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cd /d %%a			2>nul
	attrib /s | find /i ".lnk"                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	attrib /s | find /i ".lnk"                                                                >> %logthink%\%result.txt
	cd /d %logthink%
	echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��� ���� �������� ������ ��ȣ                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %logthink%\result.txt | find ".lnk" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


:6-22-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\result.txt 2>nul
echo 0622 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0623 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################     6.23 IIS ���� ���ε� �� �ٿ�ε� ����     ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ���� ���ε� �� �ٿ�ε� ���� ���� ���� �� ��ȣ                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �� ������ ���� �ڿ������� ���� ���ε� �� �ٿ�ε� �뷮�� ������ ��� ��ȣ    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-23-enable
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
	goto 6-23-end
)

:6-23-enable
echo [��� ����Ʈ]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [�⺻ ����]                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config | findstr /i "maxAllowedContentLength maxRequestEntityAllowed bufferingLimit" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum W3SVC | findstr /i "AspMaxRequestEntityAllowed AspBufferingLimit" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo * ���� ���� ��� �⺻ ������ ����Ǿ� ����.                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%a in (website-name.txt) do (
		echo [WebSite Name] %%a                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%a | findstr /i "maxAllowedContentLength maxRequestEntityAllowed bufferingLimit" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo * ���� ���� ��� �⺻ ������ ����Ǿ� ����.                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i | find /i "AspMaxRequestEntityAllowed" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i | find /i "AspMaxRequestEntityAllowed"  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo AspMaxRequestEntityAllowed : * �⺻ ������ ����Ǿ� ����.                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
		cscript %script%\adsutil.vbs enum %%i | find /i "AspBufferingLimit" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i | find /i "AspBufferingLimit"           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			echo AspBufferingLimit          : * �⺻ ������ ����Ǿ� ����.                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		)
	)
)

echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:6-23-end
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0623 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0624 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################       6.24  IIS DB ���� ����� ����          ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : .asp�� asp.dll ���� ���� �����(GET, HEAD, POST, TRACE) ��ȣ                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : 7.0�̻�- ��û ���͸����� .asa, .asax Ȯ���ڰ� False�� �����Ǿ� ������ ��ȣ     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   ��û ���͸����� .asa, .asax Ȯ���ڰ� True�� �����Ǿ� ���� ���        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   .asa, .asax ������ ��ϵǾ� �־�� ��ȣ                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   (����, Global.asa ������ ������� �ʴ� ��� �ش� ���� ����.)          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                 > (1) fileExtension=".asa" allowed="false" �̸� ��ȣ                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                 > (2) fileExtension=".asa" allowed="true" �̸�, .asa ���� Ȯ��          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo   	    : 6.0����- .asa ������ ������ ��� ��ȣ                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                   (���� ��) ".asa,C:\WINDOWS\system32\inetsrv\asp.dll,5,GET,HEAD,POST,TRACE" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo                    GET,HEAD,POST,TRACE ����: �������� ����								 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-24-enable
) else (
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
	goto 6-24-end
)

:6-24-enable
echo [��� ����Ʈ]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo [�⺻ ����]                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	%systemroot%\System32\inetsrv\appcmd list config | find /i ".asa" | find /i /v "httpforbiddenhandler" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	cscript %script%\adsutil.vbs enum W3SVC | find /i ".asa"                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Ȯ��                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	for /f "delims=" %%a in (website-name.txt) do (
		echo [WebSite Name] %%a                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config %%a | find /i ".asa" | find /i /v "httpforbiddenhandler" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
		echo [WebSite AppRoot] %%i                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum %%i/root | find /i ".asa" > nul
		if not errorlevel 1 (
			cscript %script%\adsutil.vbs enum %%i/root | find /i ".asa"                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo.                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		) else (
			cscript %script%\adsutil.vbs enum %%i/root | find /i "ScriptMaps" > nul
			if not errorlevel 1 (
				echo .asa ������ ��ϵǾ� ���� ����. [���]                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				echo.                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			) else (
				echo * �⺻ ������ ����Ǿ� ����.                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				echo.                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			)
		)
	)
)
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
:6-24-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0624 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0625 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################     6.25 IIS ���� ���丮 ����     ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �ش� ������Ʈ�� IIS Admin, IIS Adminpwd ���� ���͸��� �������� ���� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo        : IIS 6.0 �̻� ���� �ش� ���� ���� 												 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-25-enable
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-25-end
)

:6-25-enable
echo [���� ���͸� ���� ��Ȳ]                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ����##########
:: iis ver >= 6
if %iis_ver_major% geq 6 (
echo �� IIS 6.0 �̻� ���� �ش� ���� ���� 												 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6-25-end
)

:: iis ver < 5
if %iis_ver_major% lss 5 (
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %logthink%\result.txt
)
type %logthink%\result.txt | find /i "IIS" | findstr /I "Admin Adminpwd" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ��##########


rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ����##########
:: iis ver >= 7
::if %iis_ver_major% geq 7 (
	::%systemroot%\System32\inetsrv\appcmd list config -section:system.applicationHost/sites | find /i "virtualdirectory" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)
:: iis ver <= 6
::if %iis_ver_major% leq 6 (
	::%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
::)
rem ##########20160114 6.0 �̻� �ش� ���� �������� �ҽ� ���� ��##########
del %logthink%\result.txt 2>nul
:6-25-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0625 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0626 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################     6.26 IIS ������ ���� ACL ����     ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �����͸� ���� ���ϵ鿡 Everyone ������ ���� ��� ��ȣ                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (��������Ʈ ������ Read ���Ѹ� ���� ��� ��ȣ)                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-26-enable
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-26-end
)

:6-26-enable
echo [��� ����Ʈ]                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: iis ver >= 7
if %iis_ver_major% geq 7 (
	type website-list.txt                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: iis ver <= 6
if %iis_ver_major% leq 6 (
	type website-name.txt                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *** ����Ʈ�� ���� Everyone ���� üũ                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo (exe, dll, cmd, pl, asp, inc, shtm, shtml, txt, gif, jpg, html)                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for /f "delims=" %%a in (website-physicalpath.txt) do (
	echo [Website HomeDir] %%a                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	echo -----------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	call cd /d %%a 2> nul																				
	cd 2> nul
	cacls *.exe /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.dll /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.cmd /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.pl /t | find /i "everyone"                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.asp /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.inc /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.shtm /t | find /i "everyone"                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.shtml /t | find /i "everyone"                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.txt /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.gif /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.jpg /t | find /i "everyone"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.html /t | find /i "everyone"                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 2> nul
	cacls *.exe /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.dll /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.cmd /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.pl /t | find /i "everyone"                                                       >> %logthink%\result.txt 2> nul
	cacls *.asp /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.inc /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.shtm /t | find /i "everyone"                                                     >> %logthink%\result.txt 2> nul
	cacls *.shtml /t | find /i "everyone"                                                    >> %logthink%\result.txt 2> nul
	cacls *.txt /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.gif /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.jpg /t | find /i "everyone"                                                      >> %logthink%\result.txt 2> nul
	cacls *.html /t | find /i "everyone"                                                     >> %logthink%\result.txt 2> nul
	cd /d %logthink% 2> nul
	echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) 2> nul
echo �� ��� ���� �������� ������ ��ȣ                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type %logthink%\result.txt | find /i "everyone" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:6-26-end
del %logthink%\result.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0626 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0627 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################      6.27 IIS �̻�� ��ũ��Ʈ ���� ����      ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : ����� ����(.htr .idc .stm .shtm .shtml .printer .htw .ida .idq)�� ��������    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : �ʴ� ��� ��ȣ                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : Windows 2003 ���� ������ ��ġ�� �Ǿ� ��ȣ��                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-27-enable
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-27-end
)

:6-27-enable
if %WinVer% geq 2 (
	echo �� Windows 2003 ���� ������ ��ġ�� �Ǿ� �ش���� ����							>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-27-end
) else (
	echo [��� ����Ʈ]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	:: iis ver >= 7
	if %iis_ver_major% geq 7 (
		type website-list.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	:: iis ver <= 6
	if %iis_ver_major% leq 6 (
		type website-name.txt                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

	:: iis ver >= 7
	if %iis_ver_major% geq 7 (
		echo [�̻�� ��ũ��Ʈ ���� Ȯ��]                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%systemroot%\System32\inetsrv\appcmd list config | find /i "scriptprocessor" | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo �� ��� ���� �������� ������ ��ȣ                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

	:: iis ver <= 6
	if %iis_ver_major% leq 6 (
		echo [�⺻ ����]                                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo -----------------------------------------------------                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum W3SVC | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		cscript %script%\adsutil.vbs enum W3SVC | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %logthink%\result.txt
		echo �� ��� ���� �������� ������ ��ȣ                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

		echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo *** ����Ʈ�� ���� Ȯ��                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f "tokens=1 delims=[]" %%i in (website-list.txt) do (
			echo [WebSite AppRoot] %%i                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			echo -----------------------------------------------------------------------        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			cscript %script%\adsutil.vbs enum %%i/root | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" > nul
			if not errorlevel 1 (
				cscript %script%\adsutil.vbs enum %%i/root | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				cscript %script%\adsutil.vbs enum %%i/root | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %logthink%\result.txt
				echo.                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
			) else (
				cscript %script%\adsutil.vbs enum %%i/root | find /i "ScriptMaps" > nul
				if not errorlevel 1 (
					echo * ����� ������ ��ϵǾ� ���� ����. [��ȣ]                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
					echo.                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				) else (
					echo * �⺻ ������ ����Ǿ� ����.                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
					echo.                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
				)
			)
		)
	)
)

type %logthink%\result.txt | findstr /i ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


del %logthink%\result.txt 2>nul
:6-27-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0627 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0628 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################      6.28 IIS Exec ��ɾ� �� ȣ�� ����       ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� : �ش� ������ ������Ʈ�� ���� 0�� ��� ��ȣ                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\SSIEnableCmdDirective  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (����1) IIS 5.0 �������� �ش� ������Ʈ�� ���� ���� ��� ��ȣ                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��      : (����2) IIS 7.0 �̻� ��ȣ                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-28-enable
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-28-end
)

:6-28-enable
:: iis ver >= 6
if %iis_ver_major% geq 6 (
	echo �� IIS 6.0 �̻� ��ȣ			                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6-28-end
)

:: iis ver < 6
if %iis_ver_major% lss 6 (
	echo [Registry ����] 			                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo -----------------------------------------------------                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\SSIEnableCmdDirective" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\SSIEnableCmdDirective" >> %logthink%\result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


type %logthink%\result.txt | find /V "0" | findstr /i "SSIEnableCmdDirective" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
del %logthink%\result.txt 2>nul

:6-28-end
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0628 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0629 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############    6.29 ������ Apache Tomcat �⺻ ���� ��� ����    ################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Apache Tomcat ���񽺰� ���������� �ʰų� tomcat/tomcat �Ǵ� ������ ����/�н�����>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : tomcat/admin �̿��� �ٸ� �н������ �����Ǿ� �ִ� ��� ��ȣ                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo. �� ���μ��� �� Ȯ���� ���� (Apache Tomcat)���� ���� Ȯ��                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "Apache Tomcat" > NUL
IF NOT ERRORLEVEL 1 (
echo �� Apache Tomcat Service Enable     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo �� Apache Tomcat Service Disable    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo. �� ��Ʈ��ȣ Ȯ���� ���� (Apache Tomcat)���� ���� Ȯ��                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
netstat -ao | find /i "8080" > NUL
IF NOT ERRORLEVEL 1 (
echo �� Apache Tomcat Service Enable     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� Apache Tomcat ���� ���� Ȯ��                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type %%CATALINA_HOME%%\conf\tomcat-users.xml                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo �� Apache Tomcat Service Disable    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0629 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0630 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################     6.30 DNS Recursive Query ���� ����    ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: DNS ���񽺰� ���������� �ʰų� Resursive Query�� �����ϴ� ������Ʈ�� ���� 1�� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ��ȸ(DNS) Ȯ���� ���� ���� ���� Ȯ��                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
sc query dns                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���μ��� �� Ȯ���� ���� (DNS)���� ���� Ȯ��                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /i "DNS Server" > NUL 
IF NOT ERRORLEVEL 1 (
echo �� DNS Service Enable     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo �� DNS Service Disable    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� DNS Recursive Query ����                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -------------------------------------------------------                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HLKM\SYSTEM\CurrentControlSet\Services\DNS\Parameters /v NoRecursion" | findstr .  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0630 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0631 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################    6.31 DNS Zone Transfer ����     ############################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: DNS ���� ������ �Ʒ� ���� �� �ϳ��� �ش�Ǵ� ��� ��ȣ(SecureSecondaries 2) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) DNS ���񽺸� ������� ���� ���                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) ���� ���� ����� ���� ���� ���                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) Ư�� �����θ� ���� ������ ����ϴ� ���                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : * ������Ʈ����(�������� ������:3, �ƹ������γ�:0, �̸������ǿ������� �����θ�:1, ���������θ�:2 ) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : [����]                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : ��� ���� ���� ��� DNS ������ ��ϵ� ��/������ ��ȸ ������ ���� ������,      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : DNS ���񽺸� ������� ���� ��� ���񽺸� ������ ���� �ǰ�                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� DNS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "DNS Server" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� DNS Service Enable                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� DNS Service Disable                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
	goto 0631-end
	echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)


:: winver < 2008R2
if %WinVer% leq 3 (
goto 0631-2008
)

:: winver > 2008
if %WinVer% geq 4 (
 goto 0631-2008R2
)


:0631-2008
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF %ERRORLEVEL% NEQ 0 (
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\result.txt
	) else (
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\result.txt
	)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type %logthink%\result.txt | %script%\awk -F" " {print$3} | find "0" > nul
	if %ERRORLEVEL% NEQ 0 (
		echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0631-end
	)
	if %ERRORLEVEL% EQU 0 (
		echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0631-end
	)
)

:0631-2008R2
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF %ERRORLEVEL% NEQ 0 (
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\result.txt
	) else (
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" >> %logthink%\result.txt
	)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type %logthink%\result.txt | find "0x0" > nul
	if %ERRORLEVEL% NEQ 0 (
		echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0631-end
	)
	if %ERRORLEVEL% EQU 0 (
		echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
		echo.                                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 0631-end
	)
)

:0631-end
del %logthink%\result.txt 2>nul	
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0631 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0632 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################    6.32 RDS (Remote Data Services) ����     ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ������ �� �Ѱ����� �ش�Ǵ� ��� ��ȣ                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) IIS �� ������� �ʴ� ���                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) Windows 2000 sp4, Windows 2003 sp2, Windows 2008 �̻� ��ȣ                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) ����Ʈ ������Ʈ�� MSADC ���� ���͸��� �������� ���� ���                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (4) �ش� ������Ʈ�� ���� �������� ���� ���                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� IIS ���� ���� ���� Ȯ��                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if exist iis-enable.txt (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Enable                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo �� IIS Service Disable                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.32-end
)

:: OS Version, Service Pack ���� üũ
echo [OS Version Ȯ��]                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
:: winver = 2000
if %WinVer% equ 1 (
	ECHO �� Win 2000�� ��� ������ 4 �̻� ��ȣ                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "kernel version"                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack"                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}	> %logthink%\result.txt
	goto 6.32-2000
	echo.
)

:: winver >= 2003
if %WinVer% geq 2 (
	ECHO �� Windows 2003 sp2 �̻�, Windows 2008 �̻� ��ȣ                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os name"                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "os version" | find /i /v "bios"                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if %WinVer% EQU 2 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}     > %logthink%\result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.32-2003
	)

if %WinVer% geq 3 (
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.32-end
	)

:6.32-2000
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6.32-2003-0
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 4 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6.32-end
)

:6.32-2003-0	
%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | find /i "msadc" >> %logthink%\msadcdir.txt
	type msadcdir.txt                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	find /i "msadc" msadcdir.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * ���˰��: MSADC ������͸��� �������� ����.                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 6.32-end
)

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" /s | findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" >> %logthink%\RDSREG.txt
type %logthink%\RDSREG.txt                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" RESREG.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * ���˰��: ��ϵ� REG���� �������� ����.                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 6.32-end
)

		echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 6.32-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:6.32-2003

type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6.32-2003-1
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 2 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6.32-end
)

:6.32-2003-1

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | find /i "msadc" >> %logthink%\msadcdir.txt
	type msadcdir.txt                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	find /i "msadc" msadcdir.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * ���˰��: MSADC ������͸��� �������� ����.                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 6.32-end
)

%script%\reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" /s | findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" >> %logthink%\RDSREG.txt
type %logthink%\RDSREG.txt                                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	findstr /i "RDSServer.DataFactory AdvancedDataFactory VbBusObj.VbbusObjCls" RESREG.txt > NUL
	IF ERRORLEVEL 1 (
		ECHO * ���˰��: ��ϵ� REG���� �������� ����.                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 6.32-end
)

		echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt		
		goto 6.32-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	

	
:6.32-end	
del %logthink%\result.txt 2>nul
del %logthink%\msadcdir.txt 2>nul
del %logthink%\RDSREG.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0632 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0633 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##############    6.33 �������� �׼����� �� �ִ� ������Ʈ�� ���    ################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Remote Registry Service �� �����Ǿ� ���� ��� ��ȣ                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : AD�� ����� ��� �ش� ������Ʈ�� Ȯ��, ���ʿ��� ����(Everyone ����) ������ �� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ������Ʈ�� �� HKLM\System\CurrentControlSet\Control\SecurePipeServers           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� Remote Registry service ���� ���� Ȯ��                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
sc query RemoteRegistry                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "Remote Registry" > NUL
IF NOT ERRORLEVEL 1 (
	ECHO �� Remote Registry Service Enable                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)	ELSE (
	ECHO �� Remote Registry Service Disable                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find "Remote Registry"                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ������Ʈ�� �� Ȯ��(AD ��� ��)                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "delims=" %%i IN ('reg query HKLM\System\CurrentControlSet\Control\SecurePipeServers') DO SET logthink_result=%%i
if defined logthink_result (
	reg query HKLM\System\CurrentControlSet\Control\SecurePipeServers >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
	echo Registry key value not found: HKLM\System\CurrentControlSet\Control\SecurePipeServers %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
SET logthink_result=

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0633 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0634 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################      6.34 LAN Manager ���� ����      ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"���� �����Ǿ� �ִ� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����  : (LM NTML ���� ����: LmCompatibilityLevel=4,0)                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (LM NTML NTLMv2���� ���� ���(����� ���): LmCompatibilityLevel=4,1)         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLM ���� ����: LmCompatibilityLevel=4,2)                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLMv2 ���丸 ����: LmCompatibilityLevel=4,3)                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLMv2 ���丸 ����WLM�ź�: LmCompatibilityLevel=4,4)                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (NTLMv2 ���丸 ����WLM�ź� NTLM �ź�: LmCompatibilityLevel=4,5)               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : ���� ���� ��� �ƹ��͵� ������ �� �� ������                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ش� ������ �����ϸ� Ŭ���̾�Ʈ�� ���� �Ǵ� ���� ���α׷����� ȣȯ���� ������ ��ĥ �� ����. >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� "LAN Manager ���� ����" ��å ���� Ȯ��                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "LmCompatibilityLevel"           					 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "LmCompatibilityLevel" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "LmCompatibilityLevel" | %script%\awk -F= {print$2}       >> %logthink%\result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ���� ���� ���� ����                                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

del %logthink%\result.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0634 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0635 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############    6.35 ���� ä�� ������ ������ ��ȣȭ �Ǵ� ����    ################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �Ʒ� 3���� ��å�� "���" ���� �Ǿ� ���� ��� ��ȣ                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: (1) ������ ������: ���� ä�� �����͸� ������ ��ȣȭ �Ǵ� ����(�׻�)             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (2) ������ ������: ���� ä�� �����͸� ������ ��ȣȭ(������ ���)                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (3) ������ ������: ���� ä�� �����͸� ������ ����(������ ���)                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (4,1)���, (4,0)��� �� ��                							  		   	 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ä�� ������ ������ ��ȣȭ �Ǵ� ���� ������ Ȯ��                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" | findstr "4.0 unable" > nul
if %errorlevel% equ 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=4,0												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=4,1												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo 0635 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0636 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #########################       6.36 ȭ�麸ȣ�� ����       ############################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ȭ�� ��ȣ�⸦ �����ϰ�, ��ȣ�� ����ϸ�, ��� �ð��� 10���� ��� ��ȣ           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ������Ʈ�� ���� ���� ��� AD �Ǵ� OS��ġ �� ������ ���� ���� �����             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ȭ�麸ȣ�� ������ Ȯ��                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveActive"                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaverIsSecure"                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveTimeOut"                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [AD(Active Directory)�� ��� ������]                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaverIsSecure" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaveTimeOut" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveActive"                             > %logthink%\result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaverIsSecure"                         >> %logthink%\result.txt
type %logthink%\result.txt | find /V "1" | find /I "REG_SZ" > nul
if %errorlevel% equ 0 (
	goto 6.36-start
	echo.                                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Control Panel\Desktop\ScreenSaveTimeOut"                           > %logthink%\result.txt
type result.txt | %script%\awk -F" " {print$3}      						                >> %logthink%\result1.txt
for /f %%r in (result1.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 6.36-end
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:6.36-start
echo.                                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaverIsSecure" > %logthink%\result.txt

type %logthink%\result.txt | find /V "0" | find /V "unable to find" | find /I "REG_SZ" > nul
	if %errorlevel% neq 0 (
	echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 6.36-end
	)
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	%script%\reg query "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop\ScreenSaveTimeOut" > %logthink%\result.txt
	type result.txt | %script%\awk -F" " {print$3}      						                >> %logthink%\result1.txt
	for /f %%r in (result1.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

:6.36-end

del %logthink%\result.txt 2>nul
del %logthink%\result1.txt 2>nul
echo.                                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0636 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0637 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################      6.37 NTFS ���� �ý��� �̻��      ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���Ͻý����� ���� ����� ���� ���ִ� NTFS ���� �ý��۸� ������� ��� ��ȣ      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	fsutil fsinfo drives 																	 > %logthink%\inf_using_drv_temp1.txt
	type inf_using_drv_temp1.txt | find /i "\" 												 > %logthink%\inf_using_drv_temp2.txt
	echo.																					 > %logthink%\inf_using_drv_temp3.txt
	FOR /F "tokens=1-26" %%a IN (inf_using_drv_temp2.txt) DO (
		echo %%a >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%b >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%c >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%d >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%e >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%f >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%g >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%h >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%i >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%j >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%k >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%l >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%m >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%n >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%o >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%p >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%q >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%r >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%s >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%t >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%u >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%v >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%w >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%x >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%y >> %logthink%\inf_using_drv_temp3.txt 2> nul
		echo %%z >> %logthink%\inf_using_drv_temp3.txt 2> nul
	)
	type inf_using_drv_temp3.txt | find /i "\" | find /v "A:\" 								 > %logthink%\inf_using_drv.txt
	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo %%a                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		fsutil fsinfo drivetype %%a												 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		fsutil fsinfo volumeinfo %%a												 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		fsutil fsinfo drivetype %%a												 > %logthink%\result.txt
	type %logthink%\result.txt | find /I "Fixed Drive" > nul
	type %logthink%\result.txt | find /I "Fixed Drive" > nul
	if not errorlevel 1 (
	fsutil fsinfo volumeinfo %%a												 >> %logthink%\result1.txt
	)
)
	type %logthink%\result1.txt | find /I "File System Name" | find /i "fat" > nul
	if %errorlevel% equ 0 (
	echo.                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=FAT												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
	echo.                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=NTFS												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
	
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [����]                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo C: ����̺� ���� Ȯ��(NTFS�� ��� ������ ���� �ο� ������ ��µ�)                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
cacls c:\ 																					 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


del %logthink%\result.txt 2>nul
del %logthink%\result1.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0637 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0638 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ########################      6.38 ��� ���α׷� ��ġ      ############################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���̷��� ��� ���α׷��� ��ġ�Ǿ� �ִ� ��� ��ȣ                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ������� ��� List �� ��� �� ��ġ ���� ���ͺ� �ʿ�                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
set vaccine="kaspersky norton bitdefender turbo avast v3"

echo �� Process List                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for %%a IN (%vaccine%) DO (
type tasklist.txt | findstr /i %%a 															>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%b >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%c >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%d >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%e >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type tasklist.txt | findstr /i %%f >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo. 																						 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� Service list                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
for %%a IN (%vaccine%) DO (
net start | findstr /i %%a >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%b >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%c >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%d >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%e >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i %%f >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����� ���� ��� ���μ��� ��� �� ���ͺ並 ���� Ȯ�� �ʿ�                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0638 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0639 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################    6.39 �̵��� �̵�� ���� �� ������ ���    ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "�̵��Ĺ̵�� ���� �� ������ ���" ��å�� "Administrators"���� �Ǿ� �ְų�, ����� ���� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (����� ������ �ƹ� �׷쵵 ���ǵ��� ����: Default Administrators�� ��� ���� ��ȣ) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AllocateDASD=1,"0" �̸� Administrators ��ȣ)                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AllocateDASD=1,"1" �̸� Administrators �� Power Users)                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (AllocateDASD=1,"2" �̸� Administrators �� Interactive Users)                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� �̵��� �̵�� ���� �� ������ ��� ���� �� Ȯ��                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "AllocateDASD"                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����� ���� ��� Default�� Administrators �� ��� ������ 							>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

type Local_Security_Policy.txt | Find /I "AllocateDASD" > nul
if %errorlevel% neq 0 (
echo Result=0												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type Local_Security_Policy.txt | Find /I "AllocateDASD" | %script%\awk -F, {print$2} | find "0" > nul
if %errorlevel% equ 0 (
echo Result=0												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type Local_Security_Policy.txt | Find /I "AllocateDASD" | %script%\awk -F, {print$2} | find "1" > nul
if %errorlevel% equ 0 (
echo Result=1												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
type Local_Security_Policy.txt | Find /I "AllocateDASD" | %script%\awk -F, {print$2} | find "2" > nul
if %errorlevel% equ 0 (
echo Result=2												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0639 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0640 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ########################      6.40 ��ȭ�� ��� �̻��      ############################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ��ȭ�� ��� Ȱ��ȭ�Ǿ� ������ ��ȣ                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ������ �ü�� ��ü ��ȭ�� �Ǵ� 3rd party ��ȭ�� ��� ���� Ȯ�� �ʿ�           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� Ȩ �Ǵ� ȸ�� ��Ʈ��ũ ��ȭ�� Ȱ��ȭ ���� Ȯ��                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"  | findstr "EnableFirewall"    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ��Ʈ��ũ ��ȭ�� Ȱ��ȭ ���� Ȯ��                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall" | findstr "EnableFirewall"  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0640 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0641 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################    6.41 ���ʿ��� TELNET ���� ���� ����   ####################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Telnet ���񽺰� ���������� ���� ��� ��ȣ                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : TELNET ���� ��� �� ���뵵�� ���� ���ͺ� �ʿ�                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� TELNET service ���� ���� Ȯ��                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | findstr /i "telnet" > NUL
IF NOT ERRORLEVEL 1 (
echo �� TELNET Service Enable     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) else (
echo �� TELNET Service Disable    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0641 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0642 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################    6.42 �ý��� ��� ���ǻ��� �����    ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ý����� �ҹ����� ��뿡 ���� ��� �޽���/������ �����Ǿ� �ִ� ��� ��ȣ        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : LegalNoticeCaption�� ����, LegalNoticeText�� ������ �Էµ� ���                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� �ý��� ��� �޽���/���� ��� ���� Ȯ��                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0642 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###########################        7. ��ġ ����        ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0701 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##################    7.01 �ֽ� ������ ����    ###################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ֽ� �������� ��ġ�Ǿ� ���� ��� ��ȣ                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (Windows NT 6a, Windows 2000 SP4, Windows 2003 SP2, Windows 2008 SP2)         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (Windows 2008R2 SP1, Windows 2012, 2012r2�� SP�� ����) 						 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | find "Microsoft"                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | find "Pack"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo [OS Version Ȯ��]                                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo -----------------------------------------------------                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
:: winver = 2000
if %WinVer% equ 1 (
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	type systeminfo.txt | find /i "service pack" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %logthink%\result.txt
	echo.
	goto 0701-2000
)

:: winver = 2003
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
if %WinVer% EQU 2 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %logthink%\result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0701-2003
	)

:: winver = 2008
if %WinVer% EQU 3 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %logthink%\result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0701-2008
	)

:: winver = 2008R2
if %WinVer% EQU 4 (
	type systeminfo.txt | find /i "os version" | find /i /v "bios" | %script%\awk -F" " {print$6}		        > %logthink%\result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0701-2008R2
	)
	
:: winver = 2012&2012R2
if %WinVer% GEQ 5 (
	echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 0701-end
	)

:0701-2000
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 4 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end

:0701-2003
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 2 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end

:0701-2008
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 2 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end

:0701-2008R2
type systeminfo.txt | find /i /v "bios" | find /V "N/A" | find /i "os version" >nul
if %errorlevel% neq 0 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)

for /f %%r in (result.txt) do set SP=%%r       
if %SP% geq 1 (
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=O												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end
)
echo Result=F												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
goto 0701-end

:0701-end	
del %logthink%\result.txt 2>nul
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0701 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0702 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################      7.02 ��� ���α׷� ������Ʈ      ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���̷��� ��� ���α׷��� �ֽ� ���� ������Ʈ�� ��ġ�Ǿ� �ִ� ��� ��ȣ           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : �ڵ� ������Ʈ ��� ��� �� ��ȣ                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� ���� (��� ������Ʈ ���� Ȯ��)                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0702 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0703 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################       7.03 �ֽ� HOT FIX ����       ############################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ֽ� Hotfix�� ��ġ�Ǿ� ���� ��� ��ȣ                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type systeminfo.txt | findstr /i "hotfix kb"                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0703 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##############################        8. ����        ################################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0801 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ######################    8.01 ���ʿ��� ����� �۾� ����     ########################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ����� �۾��� ���ʿ��� ��ɾ ������ ���� ��� ��ȣ                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : ����� �۾� List�� ���� ���� �ʿ� �۾� ���� ���ͺ� Ȯ�� �ʿ�                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2003
if %WinVer% geq 2 (
	echo �� ����� �۾� Ȯ��                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo                                                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	schtasks | findstr [0-9][0-9][0-9][0-9]      	                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� at ��ɾ�� ����� �۾� Ȯ��                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
at                                                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver >= 2003
if %WinVer% geq 2 (
	echo [����] schtasks ��ü                                                      				 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	schtasks                 									                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0801 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0802 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###################    8.02 ���ʿ��� �������α׷� ���� ����    ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: ���� ���α׷� ����� ���������� �˻��ϰ� ���ʿ��� ���񽺰� ���� ��� ��ȣ       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (����� ���ͺ� �� ���� ���α׷� ���˰��� ���� Ȯ��)                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� ���α׷� Ȯ��(HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run)  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	%script%\reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF NOT ERRORLEVEL 0 (
		reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���� ���α׷� Ȯ��(HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run) >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ---------------------------------------------------------------------------------       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run"        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver >= 2003
if %WinVer% geq 2 (
	%script%\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" | findstr . | find /v "Listing of" | find /v "system was unable" >nul
	IF NOT ERRORLEVEL 0 (
		reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0802 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0803 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################      8.03 ������ȣ ���� ���� �̽ǽ�      ######################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �Ʒ� �� �׸� ���� �ǰ� ���״�� �������� ���                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditObjectAccess=2                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditAccountManage=3                                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditLogonEvents=3                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditPrivilegeUse=2                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditDSAccess=2                                                               >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditAccountLogon=3                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditSystemEvents=2                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditPolicyChange=3                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : AuditProcessTracking=2                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ������ȣ ���� ���� ������ Ȯ��                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditObjectAccess" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditAccountManage" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditLogonEvents" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditPrivilegeUse" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditDSAccess" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditAccountLogon" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditSystemEvents" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditPolicyChange" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Findstr /I "AuditProcessTracking" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt                                                                                    >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0803 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0804 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################     8.04 �α��� ������ ���� �� ����     ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �αױ�Ͽ� ���� ������ ����, �м�, ����Ʈ �ۼ� �� ���� ���� ��ġ�� �̷������ ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo �� ���� ���� (����� ���ͺ� ����)                                                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0804 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0805 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ############    8.05 ���� ���縦 �α��� �� ���� ��� ��� �ý��� ����    ############## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "���� ���縦 �α��� �� ���� ��� ��� �ý��� ����" ��å�� "������"���� �����Ǿ� �ִ� ��� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : (CrashOnAuditFail = 4,0 �̸� ��ȣ)                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt 
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo. �� ���� ���縦 �α��� �� ���� ��� ��� �ý��� ���� ��å ������ Ȯ��                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "CrashOnAuditFail"                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
type Local_Security_Policy.txt | Find /I "CrashOnAuditFail" | %script%\awk -F= {print$2}       >> %logthink%\result.txt
for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

del %logthink%\result.txt 2>nul
echo 0805 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###########################        9. ���� ����        ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0901 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################     9.01 ��ũ���� ��ȣȭ ����     ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: "������ ��ȣ�� ���� ������ ��ȣȭ" ��å�� ���� �� ��� ��ȣ                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: �ش� ������ ���������� ��ȣ �� ���(IDC ��, PC�ð���ġ ��)�� ��ġ�� ���� ���   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��     : �Ǵ� �ϵ��ũ ��ü �� ���� �ϵ��ũ�� �𰡿�¡ �Ǵ� õ�� �� ��� ���� ���� ���� �� >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ���ͺ� Ȯ�� �ʿ�                                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	FOR /F "tokens=1 delims=\" %%a IN ("%cd%") DO (
		echo %%a\ 																			 > %logthink%\inf_using_drv.txt
	)
	echo �� current using drive volume														 > %logthink%\inf_Encrypted_file_check.txt
	type inf_using_drv.txt 																	 >> %logthink%\inf_Encrypted_file_check.txt
	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.								 												 >> %logthink%\inf_Encrypted_file_check.txt
		echo �� Search within the %%a drive...  											 >> %logthink%\inf_Encrypted_file_check.txt
		cipher /s:%%a | find "E "        												 	 >> %logthink%\inf_Encrypted_file_check.txt 2> nul
		if errorlevel 1 echo Encrypted file is not exist 									 >> %logthink%\inf_Encrypted_file_check.txt
		echo.								 												 >> %logthink%\inf_Encrypted_file_check.txt
	)
	type inf_Encrypted_file_check.txt 														 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver = 2003
if %WinVer% equ 2 (
	echo �� Current using drive volume 														 > %logthink%\inf_Encrypted_file_check.txt
	type inf_using_drv.txt 																	 >> %logthink%\inf_Encrypted_file_check.txt

	FOR /F "tokens=1" %%a IN (inf_using_drv.txt) DO (
		echo.								 												 >> %logthink%\inf_Encrypted_file_check.txt
		echo �� Search within the %%a drive...  											 >> %logthink%\inf_Encrypted_file_check.txt
		cipher /s:%%a | find "E " | findstr "^E"											 >> %logthink%\inf_Encrypted_file_check.txt 2> nul
		if errorlevel 1 echo Encrypted file is not exist 									 >> %logthink%\inf_Encrypted_file_check.txt
		echo.								 												 >> %logthink%\inf_Encrypted_file_check.txt
	)
	type inf_Encrypted_file_check.txt 														 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
:: winver <= 2008
if %WinVer% geq 3 (
	echo �� Windows 2008 �̻� �ش���� ���� 													 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Result=M/T												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0901 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0902 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #####################    9.02 Dos���� ��� ������Ʈ�� ����    ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Dos ���ݿ� ���� ��� ������Ʈ���� �����Ǿ� �ִ� ��� ��ȣ                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) SynAttackProtect = REG_DWORD 0 �� 1 �� ���� �� ��ȣ                       >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) EnableDeadGWDetect = REG_DWORD 1(True) �� 0 ���� ���� �� ��ȣ             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (3) KeepAliveTime = REG_DWORD 7,200,000(2�ð�) �� 300,000(5��)���� ���� �� ��ȣ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (4) NoNameReleaseOnDemand = REG_DWORD 0(False) �� 1 �� ���� �� ��ȣ           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo Dos���� ��� ������Ʈ�� ������ Ȯ��                                                     >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� SynAttackProtect ����                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\SynAttackProtect" /s >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� EnableDeadGWDetect ����                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableDeadGWDetect" /s >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� KeepAliveTime ����                                                                   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\KeepAliveTime" /s >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� NoNameReleaseOnDemand ����                                                           >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo --------------------------------------------------------                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
%script%\reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\NoNameReleaseOnDemand" /s >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 0902 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ############################        10. DB ����        ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 1001 START >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
SET /A item_count+=1
echo [+] %item_count%
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #######################    10.01 Windows ���� ��� ���     ########################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ����: Windows ���� ���� �����Ǿ� �ִ� ��� ��ȣ (LoginMode 1 �̸� ��ȣ)             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (1) LoginMode 1 �̸� Windows ���� ���                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��       : (2) LoginMode 2 �̸� SQL Server �� Windows ���� ���                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �� ��Ȳ                                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	echo Win 2000 �ش���� ����                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	goto 10.01-end
)

:: winver >= 2003
if %WinVer% geq 2 (
	net start | find "SQL Server" > NUL
	IF NOT ERRORLEVEL 1 (
		ECHO �� SQL Server Enable                                                                  >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 10.01-start
		echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)	ELSE (
		ECHO �� SQL Server Disable                                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo Result=N/A												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		goto 10.01-end
	)
)


:10.01-start

%script%\reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" > nul
	IF %ERRORLEVEL% neq 0 (
		reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" | %script%\awk -F" " {print$3}       > %logthink%\result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	) else (
		%script%\reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		%script%\reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s | find "LoginMode" | %script%\awk -F" " {print$3} > %logthink%\result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		for /f %%r in (result.txt) do echo Result=%%r												>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
		echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
	)

:10.01-end
del %logthink%\result.txt 2>nul

echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo 1001 END >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo @@FINISH>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


::�ý��� ���� ��� ����
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############################  Interface Information  ############################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
ipconfig /all                                                                                >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############################  System Information  ################################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


:: winver = 2000
if %WinVer% equ 1 (
	%script%\psinfo                                                                          > systeminfo.txt
	echo Hotfix:                                                                             >> systeminfo.txt
	%script%\reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\HotFix"            >> systeminfo.txt
	type systeminfo.txt                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)

:: winver >= 2003
if %WinVer% geq 2 (
	type %logthink%\systeminfo_ko.txt                                                         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############################  tasklist Information  ################################ >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
:: winver = 2000
if %WinVer% equ 1 (
	%script%\pslist                                                                          > tasklist.txt
	type %logthink%\tasklist.txt	                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
)

:: winver >= 2003
if %WinVer% geq 2 (
	tasklist																				 > %logthink%\tasklist.txt 2>nul
	type %logthink%\tasklist.txt	                                                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt	
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo #################################  Port Information  ################################## >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
netstat -an | find /v "TIME_WAIT"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ############################  Service Daemon Information  ############################# >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net start | find /v "started" | find /v "completed"                                          >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ##########################  Environment Variable Information  ######################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
set											                                                 >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt

echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################  metabase.xml  ################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
IF EXIST C:\WINDOWS\system32\inetsrv\MetaBase.xml (
	type C:\WINDOWS\system32\inetsrv\MetaBase.xml                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
) ELSE (
	echo C:\WINDOWS\system32\inetsrv\MetaBase.xml �������� ����.                             >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
)
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\account.txt 2>nul
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ###############                      ���� ����                     #################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ####################################################################################### >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ****************************  User Accounts List  *****************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net user | find /V "successfully"                                                            >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ************************  Group List - net localgroup  ************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
net localgroup | find /V "successfully"                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo *****************************  Account Information  ***************************         >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
FOR /F "tokens=1,2,3 skip=4" %%i IN ('net user') DO (
net user %%i >> account.txt 2>nul
net user %%j >> account.txt 2>nul
net user %%k >> account.txt 2>nul
)
type account.txt >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt



::�ý��� ���� ��� ��



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ����2::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



echo.>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.>> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo END_RESULT                                                                              >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
del %logthink%\account.txt 2>nul
del %logthink%\account_temp1.txt 2>nul
del %logthink%\account_temp2.txt 2>nul
del %logthink%\account_temp3.txt 2>nul
del %logthink%\admin-account.txt 2>nul
del %logthink%\service.txt 2>nul
del %logthink%\idletime.txt 2>nul
del %logthink%\home-directory.txt 2>nul
del %logthink%\home-directory-acl.txt 2>nul
del %logthink%\Local_Security_Policy.txt 2>nul
del %logthink%\net-accounts.txt 2>nul
del %logthink%\reg-website-list.txt 2>nul
del %logthink%\systeminfo.txt 2>nul
del %logthink%\systeminfo_ko.txt 2>nul
del %logthink%\tasklist.txt 2>nul
del %logthink%\real_ver.txt 2>nul
del %logthink%\inf_share_folder.txt 2>nul
del %logthink%\inf_share_folder_temp.txt 2>nul
del %logthink%\inf_share_folder_temp_sed.txt 2>nul
del %logthink%\inf_share_folder_temp_sed2.txt 2>nul
del %logthink%\inf_Encrypted_file_check.txt 2>nul
del %logthink%\AutoLogon_REG_Export.txt 2>nul


rem Netbios ����
del %logthink%\2-18-netbios-list-1.txt 2> nul
del %logthink%\2-18-netbios-list-2.txt 2> nul
del %logthink%\2-18-netbios-list.txt 2> nul
del %logthink%\2-18-netbios-query.txt 2> nul
del %logthink%\2-18-netbios-result.txt 2> nul


rem DB ���� ����
del %logthink%\unnecessary-user.txt 2>nul
del %logthink%\password-null.txt 2>nul


rem IIS ���� del
del %logthink%\iis-enable.txt 2>nul
del %logthink%\iis-version.txt 2>nul
del %logthink%\website-list.txt 2>nul
del %logthink%\website-name.txt 2>nul
del %logthink%\website-physicalpath.txt 2>nul
del %logthink%\sample-app.txt 2>nul


rem FTP ���� del
del %logthink%\ftp-enable.txt 2>nul
del %logthink%\ftpsite-list.txt 2>nul
del %logthink%\ftpsite-name.txt 2>nul
del %logthink%\ftpsite-physicalpath.txt 2>nul
del %logthink%\ftp-ipsecurity.txt 2>nul


rem ���� ����̺� ��� ���� del
del %logthink%\inf_using_drv_temp3.txt 2>nul
del %logthink%\inf_using_drv_temp2.txt 2>nul
del %logthink%\inf_using_drv_temp1.txt 2>nul
del %logthink%\inf_using_drv.txt 2>nul



echo.                                                                                        >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo �������������������������������������   END Time  �������������������������������������   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
date /t                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
time /t                                                                                      >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt


echo.
echo ��������������������������������������   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ����                                                              ����   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ����       Windows %WinVer_name% Security Check is Finished       ����   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ����                                                              ����   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo ��������������������������������������   >> %logthink%\%COMPUTERNAME%.WINDOWS.%WinVer_name%.result.txt
echo.
echo [+] Windows Security Check is Finished
pause

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::: ���� �κ� ��2::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

