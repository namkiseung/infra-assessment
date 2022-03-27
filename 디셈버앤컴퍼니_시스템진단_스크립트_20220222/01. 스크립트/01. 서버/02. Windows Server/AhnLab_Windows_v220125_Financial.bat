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
REM ## ������ ���� ���� ��û �κ�
REM ###########################################
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ���� ������ ��û ...
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


echo.[SRV-001 SNMP ���� Get community ��Ʈ�� ���� ����]													>> %RES_LAST_FILE% 2>&1
echo.[SRV-001] OK
echo.##### SRV001 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.#SNMP ���� ���� ����>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I snmp || echo.[��ȣ] SNMP ���� �̱���) >> %RES_LAST_FILE% 2>&1
echo.#SNMP\Parameters\ValidCommunities ������Ʈ����>> %RES_LAST_FILE% 2>&1
 (reg query HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 1.1���� SNMP ���� �̻�� ���̰ų�, 1.2���� SNMP Community String �ʱ� ��[Public, Private]�� �ƴϰų�, �����ϱ� ���� ���ڿ�[�����, ���� ��]�� �����Ǿ� ���� �ʰ�, ��ȣ�� ���⵵�� ���� �� ���    >> %RES_LAST_FILE% 2>&1
echo.��� :                                                  >> %RES_LAST_FILE% 2>&1
echo.     1.1���� SNMP ���� ��� ���̰ų�, 1.2���� SNMP Community String �ʱ� ��[Public, Private]�̰ų�, �����ϱ� ���� ���ڿ�[�����, ���� ��]�� �����Ǿ� �ְ�, ��ȣ�� ���⵵�� �������� ���� ���              >> %RES_LAST_FILE% 2>&1
echo.     �� [���⵵]����+����+Ư������ �� 2���� �̻����� ���� �� 10�� �̻�, 3���� �̻����� ���� �� 8�� �̻�                            >> %RES_LAST_FILE% 2>&1
echo.���� : SRV-001,002 �Բ� ����, 1 - ����, 2 - �˸�, 4 - �б� ����, 8 - �б�, ����, 16 - �б�, �����>>%RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-003 SNMP ���� ���� �̼���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-003] OK
echo.##### SRV003 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#SNMP\Parameters\PermittedManager ������Ʈ����	>> %RES_LAST_FILE% 2>&1
 (reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" ||echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : ��ϵ� Ư�� ȣ��Ʈ �׸��� ���� >> %RES_LAST_FILE% 2>&1
echo.��� : ����� �������� ���� ���>> %RES_LAST_FILE% 2>&1
echo.��ȣ : Ư�� ȣ��Ʈ �����ϴ� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-004 ���ʿ��� SMTP ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-004] OK
echo.##### SRV004 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I smtp|| echo.��ȣ. SMTP ���� �̱���) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.[ # 1.2 SMTP ��Ʈ Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
	(netstat -na | find ":25" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : ���ʿ��� "SMTP Service" ��� ����>> %RES_LAST_FILE% 2>&1
echo.��� : ���ͺ� ����(�ʿ�ġ ���� �����ε� ���� ���� ��� ���)>> %RES_LAST_FILE% 2>&1
echo.��ȣ : SMTP ���� ��Ȱ��ȭ>> %RES_LAST_FILE% 2>&1
echo.���� : SMTP ���񽺰� ���� ���� ��� ���ͺ並 ���� �ʿ��� �������� ���� �ʿ� >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-013 Anonymous ������ FTP ���� ���� ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-013] OK
echo.##### SRV013 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. #metabase.xml ���� ���� Ȯ��  >> %RES_LAST_FILE% 2>&1
	(TYPE %systemroot%\system32\inetsrv\MetaBase.xml | findstr /C:"AllowAnonymous" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. #applicationHost.config ���� ���� Ȯ��  >> %RES_LAST_FILE% 2>&1
	(TYPE %systemroot%\system32\inetsrv\config\applicationHost.config | findstr /C:"anonymousAuthentication enabled" || echo.���� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1

echo.>> %RES_LAST_FILE% 2>&1
echo.���ͳ� ���� ����(IIS) ����> FTP ����Ʈ> �Ӽ�> [���� ����] ��>> %RES_LAST_FILE% 2>&1
echo.���͸� ���� ��롱 Ȯ��. >> %RES_LAST_FILE% 2>&1
echo.IIS 7 �̻� ���������� FTP ����Ʈ�� ������ �������� �ʰ� ���� �� ����Ʈ�� FTP ����Ʈ��>> %RES_LAST_FILE% 2>&1
echo.���ε� �Ͽ� �����. (���� ����> ���ͳ� ���� ����(IIS) 6.0 �����ڿ��� FTP ���� ����)>> %RES_LAST_FILE% 2>&1
echo.��� : FTP ���񽺿� ���� AllowAnonymous ���� 1�� ���(�⺻ 1)>> %RES_LAST_FILE% 2>&1
echo.��ȣ : Ű ���� 0 �Ǵ� ���� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-018 ���ʿ��� �ϵ��ũ �⺻ ���� Ȱ��ȭ]>> %RES_LAST_FILE% 2>&1
echo.[SRV-018] OK
echo.##### SRV018 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#�⺻ ���� ����>> %RES_LAST_FILE% 2>&1
	(net share)>> %RES_LAST_FILE% 2>&1
echo.#AutoShareServer �� >> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /s | find /I "AutoShareServer" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : �⺻ ���� Ȯ�� �� AutoShareServer �� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ��ȣ 2�� ���� �ϳ� �̻� �Ҹ����� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : Windows 2003 �̻��� ���, ������ �⺻ ���� = ����, AutoShareServer =0(���� '0'���� �־�� ��)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-020 ������ ���� ���� ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-020] OK
echo.##### SRV020 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	(net share /n | find /I "\") >> %RES_LAST_FILE% 2>&1
	(net share /n | find /I "\") > tmp1.ahn
echo.>> %RES_LAST_FILE% 2>&1
	FOR /F "tokens=2 delims= " %%j IN (tmp1.ahn) DO icacls %%j >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : Everyone ������ ���� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : Default ������ ������ ���� ������ Everyone ������ ����>> %RES_LAST_FILE% 2>&1
echo.��ȣ : Default ������ ������ ���� ������ Everyone ������ ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-021 FTP ���� ���� ���� ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-021] OK
echo.##### SRV021 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1

echo.���� : �������� Ư�� ip�ּҿ��� ftp���� ���Ӱ������� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.#FTP ����	>> %RES_LAST_FILE% 2>&1
 (net start | find /I "FTP" || echo. FTP ���� �̱���) >> %RES_LAST_FILE% 2>&1
 

echo.>> %RES_LAST_FILE% 2>&1
echo.���� : Ư�� IP �ּҿ����� FTP ������ �����ϵ��� �������� ����	>> %RES_LAST_FILE% 2>&1
echo.���: Ư�� IP �ּҿ����� FTP ������ �����ϵ��� �������� ������ �������� ���� ���	>> %RES_LAST_FILE% 2>&1
echo.�� ��ġ �� ������ �Ӽ��� ��� ����Ʈ�� ������>> %RES_LAST_FILE% 2>&1
echo.��ȣ: Ư�� IP �ּҿ����� FTP ������ �����ϵ��� �������� ������ ������ ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-022 ������ ��й�ȣ �̼���, �� ��ȣ ��� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-022] OK
echo.##### SRV022 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# LimitBlankPasswordUse �� Ȯ��	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" | findstr /I "LimitBlankPasswordUse" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
	secedit /export /cfg c:\test.inf
echo.# test.inf ���� �� LimitBlankPasswordUse �� Ȯ��	>> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | find /I "LimitBlankPasswordUse" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : LimitBlankPasswordUse �� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : 0(������)>>%RES_LAST_FILE% 2>&1
echo.��ȣ : 1(���)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-023 ���� �͹̳� ������ ��ȣȭ ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-023] OK
echo.##### SRV023 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#MinEncryptionLevel �� Ȯ��>> %RES_LAST_FILE% 2>&1
 (reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | findstr /I "MinEncryptionLevel" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : MinEncryptionLevel �� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : 1(����)>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 2(Ŭ���̾�Ʈ ȣȯ ����), 3(����), 4(FIPS �԰�)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-024 ����� Telnet ���� ��� ���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-024] OK
echo.##### SRV024 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#Telnet ���� �������� ([ SRV-158 ���ʿ��� TELNET ���� ���� ���� ] �׸� ���� ���� : �̱����� ��ȣ)>> %RES_LAST_FILE% 2>&1
	(net start | find /I "Telnet Service" || echo. Telnet Service �� ������) >> %RES_LAST_FILE% 2>&1
echo.# ���� ��Ŀ���� Ȯ�� #>> %RES_LAST_FILE% 2>&1
	tlntadmn config >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : Telnet ��� ���� �� ���� ��� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.��� : Telnet ���񽺰� ���� ���� �ƴϰų� ���� ��� �� NTLM�� ����� ���>> %RES_LAST_FILE% 2>&1
echo.��ȣ : Telnet ���񽺰� ����ǰ� ������ ���� ��� �� password ����� ������ ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-027 ���� ���� IP �� ��Ʈ ���� �̺�] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-027] OK
echo.##### SRV027 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#��ȭ�� ���� Ȯ��(�۵����, operational ���͸�)>> %RES_LAST_FILE% 2>&1
   (netsh firewall show state | findstr /I "�۵�") >> %RES_LAST_FILE% 2>&1
   (netsh firewall show state | findstr /I "Operational") 	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : ��ȭ���� ���¸� Ȯ���ϴ� netsh firewall show state ��ɿ��� '�۵� ���' ���� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : '�۵� ���=��� �� ��' (Operational mode = Disable)	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : '�۵� ���=���' (Operational mode = Enable)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-028 ���� �͹̳� ���� Ÿ�Ӿƿ� �̼���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-028] OK
echo.##### SRV028 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#MaxIdleTime �� Ȯ��>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Terminal Server\WinStations\RDP-Tcp" /v "MaxIdleTime" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#MaxIdleTime �� Ȯ�� (Windows 2012 �̻�)>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "MaxIdleTime" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : MaxIdleTime �� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : 0(�����ȵ�)>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 0 �̿��� �� (������)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-029 SMB ���� �ߴ� ���� ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-029] OK
echo.##### SRV029 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#idle ���͸�>> %RES_LAST_FILE% 2>&1
	(net config server /n | find /I "Idle")>> %RES_LAST_FILE% 2>&1
	(net config server /n | find /I "����")>> %RES_LAST_FILE% 2>&1
echo.#autodisconnect��, enableforcedlogoff�� Ȯ��>> %RES_LAST_FILE% 2>&1
	(reg query HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters | findstr "autodisconnect enableforcedlogoff" || echo.�� ����) >>%RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : autodisconnect, enableforcedlogoff �� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ��ȣ ���� 1�� �̻� ����� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : autodisconnect = 0xf=15=15�� ����, enableforcedlogoff = 1�� ��� ��� ���� �� >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-031 ���� ��� �� ��Ʈ��ũ ���� �̸� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-031] OK
echo.##### SRV031 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#restrictanonymous��, restrictanonymoussam�� Ȯ��	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" | findstr /I "restrictanonymous restrictanonymoussam")>> %RES_LAST_FILE% 2>&1
	rem secedit /export /cfg c:\test.inf
echo.#test.inf ���� �� restrictanonymous��, restrictanonymoussam �� Ȯ��	>> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | findstr "RestrictAnonymous RestrictAnonymousSAM" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : restrictanonymous, restrictanonymoussam �� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ��ȣ ���� 1�� �̻� �������� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : restrictanonymous = 1 (���) �� restrictanonymoussam = 1 (���)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1




echo.[SRV-034 ���ʿ��� ���� Ȱ��ȭ]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-034] OK
echo.##### SRV034 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#1. NetBIOS ���� ���� Ȯ��	>> %RES_LAST_FILE% 2>&1
	 (nbtstat -n) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#2. Alerter , ClipBook , Messenger , Simple TCP/IP Services ���� ��� Ȯ��	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I "Alerter" || echo.Alerter ���� �̱���) >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I "ClipBook"|| echo.ClipBook ���� �̱���) >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I "Messenger" || echo.Messenger ���� �̱���) >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"Simple TCP/IP Services" || echo.Simple TCP/IP Services ���� �̱���)>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
 net start>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#3. IIS WebDAV ��Ȱ��ȭ	>> %RES_LAST_FILE% 2>&1
echo.[# 1. IIS service : service process check #]   >> %RES_LAST_FILE% 2>&1
  (sc qc apphostsvc | sc qc IISADMIN | find "START_TYPE" ||echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.[# 2. DisableWebDAV value check #]   >> %RES_LAST_FILE% 2>&1
  (reg query "HKLM\SYSTEM\CurrentControlSet\services\W3SVC\Parameters" | find /I "DisableWebDAV"||echo.�� ����)>> %RES_LAST_FILE% 2>&1
echo.[# 3. WEBDAV value check #]    >> %RES_LAST_FILE% 2>&1
  (more %systemroot%\System32\inetsrv\MetaBase.xml  |  find /I "WEBDAV"||echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.[# 4. authoring enabled value check #]    >> %RES_LAST_FILE% 2>&1
 ( more %systemroot%\System32\inetsrv\config\applicationHost.config |  find /I "authoring enabled="||echo.�� ����) >> %RES_LAST_FILE% 2>&1  
echo.>> %RES_LAST_FILE% 2>&1 
echo.>> %RES_LAST_FILE% 2>&1
echo.#4. RDS(Remote Data Services)����	>> %RES_LAST_FILE% 2>&1
echo.[# '/MSADC' ���͸� ���� Ȯ��#] 	>> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots" | findstr /I "MSADC" || echo. ������) >> %RES_LAST_FILE% 2>&1
echo.   >> %RES_LAST_FILE% 2>&1
echo.[# 'RDSServer.DataFactory' ������Ʈ�� Ű ���� Ȯ��#]>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" | find /I "RDSServer.DataFactory" || echo. ������) >> %RES_LAST_FILE% 2>&1
echo.   >> %RES_LAST_FILE% 2>&1 
echo.[# 'AdvancedDataFactory' ������Ʈ�� Ű ���� Ȯ��#] >> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" | find /I "AdvancedDataFactory" || echo. ������) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.[# 'VbBusObj.VbBusObjCls' ������Ʈ�� Ű ���� Ȯ��#]>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch" | find /I "VbBusObj.VbBusObjCls" || echo. ������) >> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1

echo.���� : #1. NetBIOS ���� ���� Ȯ��															>> %RES_LAST_FILE% 2>&1
echo.		������� NetBIOS ��� Ȯ�� ��°� ���� ��� ��ȣ��											>> %RES_LAST_FILE% 2>&1
echo.     #2. Alerter , ClipBook , Messenger , Simple TCP/IP Services ���� ��� Ȯ��			>> %RES_LAST_FILE% 2>&1
echo.     	��°��� ������� ��ȣ�� 																>> %RES_LAST_FILE% 2>&1
echo.     #3. IIS WebDAV ��Ȱ��ȭ Ȯ��			>> %RES_LAST_FILE% 2>&1
echo.  		��ȣ :         >> %RES_LAST_FILE% 2>&1 
echo.   		1. IIS ���񽺰� �̱������� ��� >> %RES_LAST_FILE% 2>&1
echo.   		2. IIS ���񽺰� ������������ DisableWebDAV ���� 1�� �����Ǿ� ���� ��� (IIS 6 �̸�)  >> %RES_LAST_FILE% 2>&1
echo.   		3. IIS ���񽺰� ������������ C:\WINDOWS\system32 ���� ���� 0�� �����Ǿ� ����  ��� (IIS 6 �ش�)  >> %RES_LAST_FILE% 2>&1
echo.   		4. IIS ���񽺰� ������������ authoring enabled ���� false�� �����Ǿ� ����  ��� (IIS 7 �̻� �ش�)  >> %RES_LAST_FILE% 2>&1
echo. 	 	��� :      >> %RES_LAST_FILE% 2>&1
echo.   		1. IIS ���񽺰� �������̸� >> %RES_LAST_FILE% 2>&1
echo.   		2. DisableWebDAV ���� 0�� �����Ǿ� ���� ��� (IIS 6 �̸�)  >> %RES_LAST_FILE% 2>&1
echo.   		3. C:\WINDOWS\system32 ���� ���� 1�� �����Ǿ� ����  ��� (IIS 6 �ش�)  >> %RES_LAST_FILE% 2>&1
echo.   		4. authoring enabled ���� true�� �����Ǿ� ���� ��� (IIS 7 �̻� �ش�)  >> %RES_LAST_FILE% 2>&1
echo.     #4. RDS ���� Ȯ��			>> %RES_LAST_FILE% 2>&1
echo.		���� �� �� ������ �ش�Ǵ� ��� ��ȣ   >> %RES_LAST_FILE% 2>&1
echo. 			1. IIS �� ������� �ʴ� ���>> %RES_LAST_FILE% 2>&1
echo. 			2. Windows 2000 �� ��� ������ 4�� ��ġ�Ǿ� �ִ� ���(2003 ��ȣ)   	>> %RES_LAST_FILE% 2>&1
echo. 			3. ����Ʈ ������Ʈ�� MSADC ���� ���͸��� �������� ���� ���  >> %RES_LAST_FILE% 2>&1
echo. 			4. �ش� ������Ʈ�� ���� �������� ���� ���   	>> %RES_LAST_FILE% 2>&1
echo. 			5. 2008���� �̻� ��ȣ��   	>> %RES_LAST_FILE% 2>&1
echo.��� : 1�� �̻� ��� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : ��� ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-037 ����� FTP ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-037] OK
echo.##### SRV037 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#FTP ����	>> %RES_LAST_FILE% 2>&1
 (net start | find /I "FTP" || echo. FTP ���� �̱���) >> %RES_LAST_FILE% 2>&1
echo.[# 1.1 MSFTPSVC : service process check #]   >> %RES_LAST_FILE% 2>&1
  sc query MSFTPSVC >> %RES_LAST_FILE% 2>&1
echo.[# 1.2 FTPSVC : service process check #]   >> %RES_LAST_FILE% 2>&1
  sc query FTPSVC >> %RES_LAST_FILE% 2>&1
 echo.[# 1.3 21 port check #]   >> %RES_LAST_FILE% 2>&1
  (netstat -na | find "21" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : FTP ���� ���� �׸��� ���� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ���ʿ��� FTP ���� ���� ����>> %RES_LAST_FILE% 2>&1
echo.��ȣ : FTP ���� ���� ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-040 �� ���� ���͸� ������ ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-040] OK
echo.##### SRV040 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	 %systemroot%\system32\inetsrv\appcmd.exe list config > TMP_IIS_CONF.log
	type TMP_IIS_CONF.log | find /i "directorybrowse"			>> %RES_LAST_FILE% 2>&1
	type TMP_IIS_CONF.log | find /i "directorybrowse enabled" | find /i "false" || echo. �� ����>> %RES_LAST_FILE% 2>&1
echo.                                                                                                             																>> %RES_LAST_FILE% 2>&1
echo.���� : �����͸� �˻�(directoryBrowse enabled)�� �� üũ�Ǿ� ���� ���� ���(false) ��ȣ	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-041 �� ������ CGI ��ũ��Ʈ ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-041] OK
echo.##### SRV041 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
	icacls C:\inetpub\scripts>> SRV-041-cgi-acl.ahn
	icacls C:\inetpub\cgi-bin>> SRV-041-cgi-acl.ahn
	TYPE SRV-041-cgi-acl.ahn>> %RES_LAST_FILE% 2>&1
echo.#script cgi-bin >> %RES_LAST_FILE% 2>&1
	TYPE SRV-041-cgi-acl.ahn | findstr /i "scripts cgi-bin"> NUL
	IF ERRORLEVEL 1 echo �� ���͸��� �������� �ʽ��ϴ�.>> %RES_LAST_FILE% 2>&1
 echo.>> %RES_LAST_FILE% 2>&1
 echo.# everyone ���͸�>> %RES_LAST_FILE% 2>&1
	TYPE SRV-041-cgi-acl.ahn | findstr /I "everyone" | Find /V ")R"> nul
	IF ERRORLEVEL 1 ECHO [���] ��ȣ - CGI ���� ����>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 ECHO [���] ��� - CGI ���� ����>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : Everyone�� ���� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ������/��������/������� �� �Ѱ� �̻� ����>> %RES_LAST_FILE% 2>&1
echo.��ȣ : �ش� ������ ���ų� ������/��������/������� ��� ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-042 �� ���� ���� ���͸� ���� ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-042] OK
echo.##### SRV042 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
echo.#applicationhost.config ����	>> %RES_LAST_FILE% 2>&1
echo.[applicationHost.config]------------------------------->>[RESULT_ahnlab]_CONFIG.config.ahn 2>&1
	TYPE %systemroot%\System32\inetsrv\config\applicationHost.config>> [RESULT_ahnlab]_CONFIG.config.ahn 2>&1
echo.#enableParentPaths	>> %RES_LAST_FILE% 2>&1
	TYPE [RESULT_ahnlab]_CONFIG.config.ahn | find /I "enableParentPaths">>%RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : enableParentPaths ��>> %RES_LAST_FILE% 2>&1
echo.��� : True (���)>> %RES_LAST_FILE% 2>&1
echo.��ȣ : False (��� ����), �� ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-043 �� ���� ��� �� ���ʿ��� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-043] OK
echo.##### SRV043 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo. ���� : IIS 7.0 �̻� ���� �ش� ���� ����>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots">> SRV-043-LOG-1.ahn
	TYPE SRV-043-LOG-1.ahn | findstr /I "samples help">> %RES_LAST_FILE% 2>&1
	TYPE SRV-043-LOG-1.ahn | findstr /I "samples help"> NUL
	IF ERRORLEVEL 1 ECHO �� ���ʿ��� ������ �������� ����.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : IIS 7.0 �̻� ������ ����ϰ� ������ ��ȣ�� IISSamples, IISHelp ���� ���� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.��� : �� ���� �̻� ����� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : �� ���� ��� �������� ���� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-044 �� ���� ���� ���ε� �� �ٿ�ε� �뷮 ���� �̼���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-044] OK
echo.##### SRV044 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
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
echo.���� : IIS 7.0 �̻� ������ Default�� ������ �����Ǿ� �����Ƿ� ��ȣ�� >> %RES_LAST_FILE% 2>&1
echo.���� : AspMaxRequestEntityAllowed, AspBufferingLimit, bufferingLimit maxRequestEntityAllowed �� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.��� : �����Ǿ� ���� ���� ��� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : �����Ǿ� ���� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-045 �� ���� ���μ��� ���� ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-045] OK
echo.##### SRV045 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.[# 1.1. IIS 5.0, 6.0#]                                                      >> %RES_LAST_FILE% 2>&1
type %systemroot%\system32\inetsrv\MetaBase.xml | findstr ""AppPoolIdentityType"" || echo.�� ����>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.[# 1.2. IIS 7.0 �̻�#]                                                             >> %RES_LAST_FILE% 2>&1
TYPE %systemroot%\System32\inetsrv\config\applicationHost.config | findstr ""identityType""|| echo.�� ����>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ����: IIS 5.0/6.0 �ش���� ����(N/A)>> %RES_LAST_FILE% 2>&1
echo. ���� : windows2008 r2 (iis 7.5) �̻��� �⺻������ applicationpoolidentitiy ������ ����Ǿ� ��ȣ>> %RES_LAST_FILE% 2>&1
echo.NetworkService(�ǰ�), LocalService�� ��� ��ȣ>> %RES_LAST_FILE% 2>&1
echo.����� ���� ���� ���� �� ������ ������ �ƴ� ���� ������ ��� ��ȣ">> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-046 �� ���� ��� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-046] OK
echo.##### SRV046 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\Virtual Roots")	>> SRV-046_TMP.ahn
	TYPE SRV-046_TMP.ahn | findstr /I "admin ������" >> %RES_LAST_FILE% 2>&1
	TYPE SRV-046_TMP.ahn | findstr /I "admin ������"> NUL
	IF ERRORLEVEL 1 ECHO �� ���� ���͸��� �������� ����.	 >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	TYPE SRV-046_TMP.ahn | findstr /I "admin  ������"> NUL
	IF ERRORLEVEL 1 echo [���] ��ȣ>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [���] ���>> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1
echo.���� : IIS 6.0 �̻� ������ ����Ʈ ������͸��� �������� �����Ƿ� ��ȣ�� IISAdmin, IISAdminpwd ���� ���͸� ���� ���� >> %RES_LAST_FILE% 2>&1
echo.��� : ���� ���͸� ����>> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���� ���͸� ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1




echo.[SRV-047 �� ���� ��� �� ���ʿ��� ��ũ ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-047] OK
echo.##### SRV047 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.# IIS sample file check #	>> %RES_LAST_FILE% 2>&1
	(dir c:\inetpub | findstr /i "iissample" || echo."���ʿ� �������� ����")    >> %RES_LAST_FILE% 2>&1
echo.# IIS sample helpfile check #	>> %RES_LAST_FILE% 2>&1
	(dir c:\windows\help | findstr /i "iishelp" || echo."���ʿ� help���� ����")   >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : �ش� ���� ����(N/A)	>> %RES_LAST_FILE% 2>&1
echo.��� : �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ������ �����ϴ� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-048 ���ʿ��� �� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-048] OK
echo.##### SRV048 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.# IIS ADMIN SERVICE check	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"IIS Admin Service" || echo."IIS Admin Service �̱���, ���� �׸� ��� ��ȣ(�Ǵ� N/A)")>> %RES_LAST_FILE% 2>&1
echo.[# World Wide Web Publishing Service check]	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"World Wide Web Publishing Service" || echo. World Wide Web Publishing Service ���� �̱���) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#2 WebtoB ���� ���� Ȯ��>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I webtob||echo.WebtoB ���� �� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : IIS Admin Service, World Wide Web Publishing Service WebtoB�׸��� ���� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ���ʿ��ϰ� ������ ���>> %RES_LAST_FILE% 2>&1
echo.��ȣ : �׸� ����(������), �ʿ信 ���� ������ ��ȣ>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1





echo.[SRV-055 �� ���� ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-055] OK
echo.##### SRV055 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.                       >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.[1.1 ó���� ���� ����Ʈ���� Ȯ��]	>> %RES_LAST_FILE% 2>&1	
	cscript .\bin\adsutil.vbs get W3SVC/scriptmaps >> %RES_LAST_FILE% 2>&1

echo. ��ȣ : ó���� ���� ����Ʈ�� .asa �Ǵ� .asax�� �������� �ʴ� ��� �Ǵ� ���� ����Ʈ�� ���������� ��û ���͸��� allowed ���� false�� ������ ��� >> %RES_LAST_FILE% 2>&1
echo. ��� : ó���� ���� ����Ʈ�� .asa �Ǵ� .asax�� �����ϰ�, ��û ���͸��� allowed ���� true�� ������ ���  >> %RES_LAST_FILE% 2>&1
echo.                       >> %RES_LAST_FILE% 2>&1
echo.#���� : IIS 7.0 �̻� ���������� Default�� asa/asax ���� ���͸��� �����Ǿ� �����Ƿ� ��ȣ      >> %RES_LAST_FILE% 2>&1
echo.                       >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1





echo.[SRV-057 �� ���� ��� �� ������ ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-057] OK
echo.##### SRV057 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
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
echo.���� : ���ʿ��� Everyone ������ ����>> %RES_LAST_FILE% 2>&1
echo.��� : ���ʿ��� everyone ���� ����>> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���ʿ��� everyone ���� ����>> %RES_LAST_FILE% 2>&1
echo.Ȩ ���͸� ���� ���ϵ鿡 ���� Everyone ������ �������� ���� ���(��������Ʈ ������ Read ���Ѹ�) ��ȣ>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-058 �� ������ ���ʿ��� ��ũ��Ʈ ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-058] OK
echo.##### SRV058 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
	C:\Windows\System32\inetsrv\appcmd list site >> sitelist.ahn

	for /f tokens^=2^ delims^=^" %%i IN (.\sitelist.ahn)do echo %%i>> sitelist2.ahn

	echo -----------ó���� ����(Handler Mappings)----------------                                		>> list.ahn
	echo. ����Ʈ ó���� ����								>> list.ahn
	echo. [���]										>> list.ahn
	C:\Windows\System32\inetsrv\appcmd list config /section:handlers 					 			>> list.ahn
	echo. 													>> list.ahn

	FOR /f "delims=" %%i IN (.\sitelist2.ahn) DO (
	echo. %%i ����Ʈ ó���� ���� >> list.ahn
	echo. [���] >>list.ahn
	C:\Windows\System32\inetsrv\appcmd list config"%%i" /section:handlers 							>> list.ahn
	ehco. >> list.ahn)

	echo -----------��û ���͸�(request Filtering)----------------                                		>> list.ahn
	echo. ����Ʈ ��û ���͸�										>> list.ahn
	echo. [���]												>> list.ahn
	C:\Windows\System32\inetsrv\appcmd list config /section:requestFiltering 						>> list.ahn
	echo.													>> list.ahn

	FOR /f "delims=" %%i IN (.\sitelist2.ahn) DO (
	echo. %%i ����Ʈ ��û ���͸� >> list.ahn
	echo. [���]>>list.ahn
	C:\Windows\System32\inetsrv\appcmd list config "%%i" /section:requestFiltering 					>> list.ahn
	echo. >>list.ahn)

	TYPE list.ahn >> %RES_LAST_FILE% 2>&1
echo.	>> %RES_LAST_FILE% 2>&1
echo.���� : ����� ���� ���� >> %RES_LAST_FILE% 2>&1
echo.��� : ó���� ���� ����Ʈ�� ����� ������ �����ϰ�, ��û ���͸��� allowed ���� true�� ������ ��� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : ó���� ���� ����Ʈ�� ����� ������ �������� �ʴ� ��� �Ǵ� ���� ����Ʈ�� ���������� ��û ���͸��� allowed ���� false�� ������ ��� >> %RES_LAST_FILE% 2>&1
echo.���� : .idc, .printer, asp, stm, stml, shtml, ida, idq, htw ���� ����� ������ �������� ���� ��� ��ȣ >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-059 �� ���� ���� ��� ���� ��� ���� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-059] OK
echo.##### SRV059 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ �ֻ���� iis�������� Ȯ��(���� ���ϰ�� ���� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo. ��ũ��Ʈ ���ϴ��� iis�������� Ȯ��(���� ���ϰ�� admin, worldwide ǥ��(�������ɼ����� ���ϴܿ� ǥ��)	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1	
echo.>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" | findstr /I "SSIEnableCmdDirective")  >> SRV-059_TMP.ahn
	TYPE SRV-059_TMP.ahn  >> %RES_LAST_FILE% 2>&1
	TYPE SRV-059_TMP.ahn | findstr /I "SSIEnableCmdDirective" > NUL
	IF ERRORLEVEL 1 echo �� SSIEnableCmdDirective ���� ����	 >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
	TYPE SRV-059_TMP.ahn | findstr /I "SSIEnableCmdDirective" > NUL
	IF ERRORLEVEL 1 echo [���] ��ȣ - Exec ��ɾ� �� ȣ�� ����	   >> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [���] ��� - Exec ��ɾ� �� ȣ�� ����    	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. ���� : windows2003(iis6.0)�̻� ���� �ش� ���� ����>> %RES_LAST_FILE% 2>&1
echo.���� : SSIEnableCmdDirective �� Ȯ��   	>> %RES_LAST_FILE% 2>&1
echo.��� : �ش� ������Ʈ�� ���� 1 �� ���   >> %RES_LAST_FILE% 2>&1
echo.��ȣ : �ش� ������Ʈ�� ���� 0 �� ���, IIS 5.0 �������� �ش� ������Ʈ�� ���� �������� ���� ���, IIS 6.0 �̻� ��ȣ  	>> %RES_LAST_FILE% 2>&1
echo.���� :  SRV-059_TMP.ahn Ȯ��	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-060 �� ���� �⺻ ����(���̵� �Ǵ� ��й�ȣ) �̺���] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-060] OK
echo.##### SRV060 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
	dir /s /b | find /i "tomcat-users.xml" > test.ahn
	type test.ahn >> %RES_LAST_FILE% 2>&1
	set /p var=< test.ahn
	type %var% | find /i "username="|| echo.�� ���� >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : �⺻ ������ ����ϴ��� Ȯ�� 	>> %RES_LAST_FILE% 2>&1
echo.��� : ��� ���� �⺻ ������ 'tomcat', 'both','role1' �� �ϳ��� ����	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : ��� ���� �⺻ ������ 'tomcat', 'both','role1' �� ���� �������� �ʴ� ���, ��� ���� ���� ���(Apache Tomcat �̻��)	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : �⺻ ������ ��й�ȣ�� �����ؼ� ����ϴ� ��쿡�� ������� ó����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-063 DNS Recursive Query ���� ����] >> %RES_LAST_FILE% 2>&1
echo.[SRV-063] OK
echo.##### SRV063 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
	net start | find /I "DNS Server"
	IF ERRORLEVEL 1 ECHO �� DNS ������ �������� ����(=��ȣ)	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 dnscmd . /Info | findstr /I norecursion>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.���� : DNS ���� ������ NoRecursion ��� ����  	>> %RES_LAST_FILE% 2>&1
echo.��� : NoRecursion ���� 0(��� ���)  	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : NoRecursion ���� 1(��� �̻��) �Ǵ� DNS ������ ������� �ʴ� ��� >> %RES_LAST_FILE% 2>&1
echo.���� : DNS Recursive Query�� ��� ���� ��� ���ͺ並 ���� �ʿ� ���θ� �Ǵ� �� ��>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-066 DNS Zone Transfer ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-066] OK
echo.##### SRV066 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
	net start | find /I "DNS Server"
	IF ERRORLEVEL 1 ECHO �� DNS ������ �������� ����(=��ȣ)	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1	reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find /I "SecureSecondaries">> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : SecureSecondaries �� Ȯ��  	>> %RES_LAST_FILE% 2>&1
echo.��� : SecureSecondaries ���� 0    	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : SecureSecondaries ���� 1,3, DNS ������ ������� �ʴ� ���    	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-069 ��й�ȣ ������å ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-069] OK
echo.##### SRV069 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. 1. �н����� ���� ���� (�ּ� ��ȣ ��� �Ⱓ ��)   >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "MinimumPasswordAge" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "MaximumPasswordAge" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "MinimumPasswordLength" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "PasswordComplexity" >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "PasswordHistorySize" >> %RES_LAST_FILE% 2>&1
echo.         >> %RES_LAST_FILE% 2>&1
echo.��ȣ = �н����� ���� �ʵ� ��κ��� �����Ǿ� �ִ� ���   >> %RES_LAST_FILE% 2>&1
echo.  ex) �ּ� ��ȣ ��� �Ⱓ�� 0���� ū ������ �����Ǿ� �ִ� ���    >> %RES_LAST_FILE% 2>&1
echo. ��� = �н����� ���� �ʵ� ��κ��� �̼����Ǿ� �ִ� ���   >> %RES_LAST_FILE% 2>&1
echo.  ex) �ּ� ��ȣ ��� �Ⱓ�� 0���� �����Ǿ� �ִ� ���   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : - ��й�ȣ ���� ��å ���� - ���� ���� Ư������ 2�� ���� �� 10�ڸ� �̻�, 3�� ���� �� 8�ڸ� �̻�, �н����� ���� �Ⱓ 90�� ���� ���� �� ��ȣ  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-070 ����� �н����� ���� ��� ���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-070] OK
echo.##### SRV070 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# �н����� ��ȣȭ ���� Ȯ��(ClearTextPassword) #>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "ClearTextPassword" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.����: ClearTextPassword ��	>> %RES_LAST_FILE% 2>&1
echo.��� : 0�̿��� ��	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 0 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-072 �⺻ ������ ������(Administrator) ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-072] OK
echo.##### SRV072 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# administrator�� ���� Ȱ�� ���� Ȯ��(net user - filter : account active, Ȱ��) #>> %RES_LAST_FILE% 2>&1
	net user administrator | find "Account active"	>> %RES_LAST_FILE% 2>&1
	net user administrator | find "Ȱ��"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# administrator�� ���� Ȱ�� ���� Ȯ��(securitypolicy : EnableAdminAccount, NewAdministratorName) #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "EnableAdminAccount">> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "NewAdministratorName">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ����: Administrator ���� Ȯ��	>> %RES_LAST_FILE% 2>&1
echo. ���: Administrator ������ �����ϸ� Ȱ��ȭ(0�� �ƴ� ��) �Ǿ� ���� ���>> %RES_LAST_FILE% 2>&1
echo. ��ȣ: Administrator ������ �������� �ʰų�, ��Ȱ��ȭ�� ���	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-073 ������ �׷쿡 ���ʿ��� ����� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-073] OK
echo.##### SRV073 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# local Administrators Group (net localgroup Administrators) #>> %RES_LAST_FILE% 2>&1
	net localgroup administrators	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. ����: ���ͺ並 ���� Administrators �׷��� ���� �� ���ʿ��� ���� Ȯ��	>> %RES_LAST_FILE% 2>&1
echo. ���: ������ ���� �ܿ� �ٸ� ���ʿ��� ������ ������ ���>> %RES_LAST_FILE% 2>&1
echo. ��ȣ: ������ ������ ������ ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-074 ���ʿ��ϰų� �������� �ʴ� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-074] OK
echo.##### SRV074 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# �н����� �ִ���Ⱓ Ȯ�� #>> %RES_LAST_FILE% 2>&1
	net accounts | find /I "Maximum password age"	>> %RES_LAST_FILE% 2>&1
	net accounts | find /I "�ִ� ��ȣ ��� �Ⱓ"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# Administrator ������ ��ȣ ���� ���� Ȯ�� #	>> %RES_LAST_FILE% 2>&1
	net user administrator | find "Password expires">> %RES_LAST_FILE% 2>&1
	net user administrator | find "��ȣ ���� ��¥">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# ��ȣ ��� �Ⱓ ���� ����(Password expires) ���� ��Ȳ #>> %RES_LAST_FILE% 2>&1
	for /f "usebackq skip=4 tokens=*" %%a in (`net user ^| find /v "The command completed successfully"`) do (
    for %%B in (%%a) do (
   net user %%B | findstr "^Password.expires.*Never" >nul && echo %%B 	>> %RES_LAST_FILE% 2>&1
    )
)
echo.  	>> %RES_LAST_FILE% 2>&1
echo. ����: ȸ���� �н����� ��å Ȯ��>> %RES_LAST_FILE% 2>&1
echo. ���: �н����� �ִ���Ⱓ�� �������� �ʰų� 0�̰ų� unlimited�� ���>> %RES_LAST_FILE% 2>&1
echo. ��ȣ: �н����� �ִ���Ⱓ�� ������ ���>> %RES_LAST_FILE% 2>&1
echo.  	>> %RES_LAST_FILE% 2>&1
echo. ����: ������ ���� ��� 90�Ϸ� ����(�б⺰ 1ȸ)>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-075 ���� ������ ���� ��й�ȣ ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-075] OK
echo.##### SRV075 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# PasswordComplexity	>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "PasswordComplexity" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. ����: �н����� ���⼺ Ȯ�� 	>> %RES_LAST_FILE% 2>&1
echo. ��ȣ: complex �� ��� = ��ȣ �Ǵ� PasswordComplexity 1�� ��� ��ȣ 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-078 ���ʿ��� Guest ���� Ȱ��ȭ]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-078] OK
echo.##### SRV078 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# ���� ��ǻ���� Guest ���� Ȱ�� ����(net user) #>> %RES_LAST_FILE% 2>&1
	net user guest | findstr /I "Account active"	>> %RES_LAST_FILE% 2>&1
	net user guest | findstr /I "Ȱ�� ����"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# ���� ��ǻ���� Guest ���� Ȱ�� ����(securitypolicy) #>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "EnableGuestAccount" || echo. �� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. ����: Guest ������ Ȱ��ȭ ����>> %RES_LAST_FILE% 2>&1
echo. ���: Guest ������ Ȱ��ȭ �Ǿ� ���� ���, EnableGuestAccount ���� 1�� ���	>> %RES_LAST_FILE% 2>&1
echo. ��ȣ: Guest ������ Ȱ��ȭ �Ǿ����� ���� ���, EnableGuestAccount ���� 0�� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-079 �͸� ����ڿ��� �������� ����(Everyone) ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-079] OK
echo.##### SRV079 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# everyoneincludesanonymous	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /r /i "everyoneincludesanonymous" | findstr /v "1"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : everyoneincludesanonymous �� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.��� : everyoneincludesanonymous ���� 1�� ���>> %RES_LAST_FILE% 2>&1
echo.��ȣ : everyoneincludesanonymous ���� 0�� ���>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : Everyone �׷쿡 �͸� ���� �ĺ��ڰ� ���ԵǴ��� ����, �⺻ ���� ���� 0	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-080 �Ϲ� ������� ������ ����̹� ��ġ ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-080] OK
echo.##### SRV080 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# ������ ����̺� ��å Ȯ�� #	>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "AddPrinterDrivers" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.���� : AddPrinterDrivers �� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.��� : AddPrinterDrivers ���� 1�� ������ �ȵ� ���>> %RES_LAST_FILE% 2>&1
echo.��ȣ : AddPrinterDrivers ���� 1(Ȱ��ȭ��)�� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-082 �ý��� �ֿ� ���͸� ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-082] OK
echo.##### SRV082 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. 1. \system32\Config ����(Windows 2003�ϰ��)                         >> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\Config                   >> %RES_LAST_FILE% 2>&1
echo.#2. \system32\winevt\Logs ���� >> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\winevt\Logs>> %RES_LAST_FILE% 2>&1
echo. 2.1 \system32\Config\SysEvent.Evt ����(Windows 2003�ϰ��)           >> %RES_LAST_FILE% 2>&1
	icacls %SystemRoot%\system32\Config\SysEvent.Evt    >> %RES_LAST_FILE% 2>&1														 
echo.  >> %RES_LAST_FILE% 2>&1
echo. 3. \system32\winevt\Logs\System.evtx ����>> %RES_LAST_FILE% 2>&1
	icacls %SystemRoot%\system32\winevt\Logs\System.evtx  >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.���� : Everyone ���� ���� �� Users ���� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ��ȣ ���� �� 1���� �� ���� �� ���  >> %RES_LAST_FILE% 2>&1
echo.��ȣ : Everyone ���� ����, Users�� W, C, F �� 1������ �������� ���� ��� ��ȣ >> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.���� : W(����), C(�ٲٱ�), F(��� ����)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-084 �ý��� �ֿ� ���� ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-084] OK
echo.##### SRV084 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# SAM ���� ���� �������� #	 	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\config\SAM	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : SAM ���� ���ٱ��� ����  	>> %RES_LAST_FILE% 2>&1
echo.��� : Administrator / System �׷� �� �ٸ� �׷쿡 ������ ������ ���  >> %RES_LAST_FILE% 2>&1
echo.��ȣ : Administrator / System �׷츸 ��� �������� ������ ���  	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : W(����), C(�ٲٱ�), F(��� ����)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-090 ���ʿ��� ���� ������Ʈ�� ���� Ȱ��ȭ]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-090] OK
echo.##### SRV090 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# ���� ������Ʈ�� ��뿩�� #	>> %RES_LAST_FILE% 2>&1
	(net start | find /I "Remote Registry" || echo. Remote Registry �� �����) >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : ���� ������Ʈ�� ��� ����  	>> %RES_LAST_FILE% 2>&1
echo.��� : Remote registry ����� ��� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : Remote registry ������� ���� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-092 ����� Ȩ ���͸� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-092] OK
echo.##### SRV092 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# ����� Ȩ ���͸� Ȯ�� #	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
	dir /b %HOMEDRIVE%\Users > tmp5.tmp
	FOR /F "tokens=1 delims=" %%j IN (tmp5.tmp) DO icacls "%HOMEDRIVE%\Users\%%j" 											>> %RES_LAST_FILE% 2>&1
	del tmp5.tmp
echo.    	>> %RES_LAST_FILE% 2>&1
echo.���� : Ȩ ���͸� ���� Ȯ��    	   	   	   	   	   	  	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : Ȩ ���͸��� Everyone ������ ���� ���(All Users, Default User ���͸��� ����)    	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.���� : W(����), C(�ٲٱ�), F(��� ����)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-097 FTP ���� ���͸� ���ٱ��� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-097] OK
echo.##### SRV097 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
FOR /F tokens^=2^delims^="" %%a IN ('%systemroot%\system32\inetsrv\appcmd list site ^| find "ftp"') DO (
%systemroot%\system32\inetsrv\appcmd list vdir "%%a/">>ftpdirectory.ahn
)
echo.>> %RES_LAST_FILE% 2>&1  >> %RES_LAST_FILE% 2>&1
echo.# FTP ���� ���丮 Ȯ�� # 	>> %RES_LAST_FILE% 2>&1
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
echo.����: FTP ���͸��� Everyone ������ ���� ��� ���	>> %RES_LAST_FILE% 2>&1
echo.���� : W(����), C(�ٲٱ�), F(��� ����)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-101 ���ʿ��� ����� �۾� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-101] OK
echo.##### SRV101 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# ����� �۾� Ȯ��(schtasks)# 	>> %RES_LAST_FILE% 2>&1
	schtasks /query>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : ����� �۾� ��� Ȯ��  >> %RES_LAST_FILE% 2>&1
echo.��� : ���ʿ��ϰų� �ǽɽ����� ��� �Ǵ� ������ ���� ���>> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���ʿ��ϰų� �ǽɽ����� ��� �Ǵ� ������ ���� ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-103 LAN Manager ���� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-103] OK
echo.##### SRV103 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# LAN Manager ���� ���� Ȯ��(HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa, LMCompatibilityLevel ��)#>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | find /I "LMCompatibilityLevel" || echo.�� ����)>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.���� : LMCompatibilityLevel �� Ȯ��	 	 	 	 >> %RES_LAST_FILE% 2>&1
echo.��� : "LM" �� "NTLM"������ ����ϴ� ���(3 ����	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : LMCompatibilityLevel�� '3'�� ����(Send NTLM response only)�� ���) Ȥ�� ��� ���� ���� ���(�̼����� ���)		>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-104 ���� ä�� ������ ������ ��ȣȭ �Ǵ� ���� ��� ��Ȱ��ȭ]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-104] OK
echo.##### SRV104 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# Digitally encrypt or sign secure channel data(always) Ȯ�� #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | find /I "RequireSignOrSeal")>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# Digitally encrypt secure channel data(when possible) Ȯ�� #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | find /I "SealSecureChannel")>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# Digitally sign secure channel data(when possible) Ȯ�� #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | find /I "SignSecureChannel")>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.���� : 3�� ��å�� ���õ� ������Ʈ�� �� Ȯ��	>> %RES_LAST_FILE% 2>&1
echo.��� : 3�� ��å�� ��� '1'(���)�� �������� ���� ���	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 3�� ��å�� ��� '1'(���)�� ������ ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-105 ���ʿ��� �������α׷� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-105] OK
echo.##### SRV105 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.# HKLM\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run Ȯ�� #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run") 	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo.# HKCU\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run Ȯ�� #	>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run") 	  	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo.# WMIC startup Ȯ�� #	>> %RES_LAST_FILE% 2>&1
	(wmic startup list /format:list)	>> wmic2.ahn

	TYPE wmic2.ahn	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo.���� : �������α׷� ��� Ȯ��    	>> %RES_LAST_FILE% 2>&1
echo.��� : �������α׷� �� ���ʿ��ϰų� �ǽɽ����� ���񽺰� �����ϴ� ���    	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : �������α׷� �� ���ʿ��ϰų� �ǽɽ����� ���񽺰� �������� ���� ���  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.   	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-108 �α׿� ���� �������� �� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-108] OK
echo.##### SRV108 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.[ 1. �̺�Ʈ �α׿� ���� ���� ���� ���� ���� ]                                              	>> %RES_LAST_FILE% 2>&1
echo.# \system32\winevt\Logs ���� >> %RES_LAST_FILE% 2>&1
	icacls %systemroot%\system32\winevt\Logs>> %RES_LAST_FILE% 2>&1
echo.# \system32\winevt\Logs\Application.evtx ����  	>> %RES_LAST_FILE% 2>&1
	icacls %SystemRoot%\system32\winevt\Logs\Application.evtx  >> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo.���� : Everyone ���� ���� �� Users ���� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ��ȣ ���� �� 1���� �� ���� ��  >> %RES_LAST_FILE% 2>&1
echo.��ȣ : Everyone ���� ����, Users�� W, C, F �� 1������ �������� ���� ��� ��ȣ >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.���� : W(����), C(�ٲٱ�), F(��� ����)	>> %RES_LAST_FILE% 2>&1
echo.  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.[ 2. ���� ��Ͽ� ���� ���� ���� ���� ���� ]                                              	>> %RES_LAST_FILE% 2>&1
echo. 1. SeSecurityPrivilege ���� ��                                          >> %RES_LAST_FILE% 2>&1
 type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | Find /I "SeSecurityPrivilege"              >> %RES_LAST_FILE% 2>&1
echo. 2. \system32\winevt\Logs ����                                                               >> %RES_LAST_FILE% 2>&1
 icacls %systemroot%\system32\winevt\Logs                                                        >> %RES_LAST_FILE% 2>&1
echo. 2.1 \system32\Config ����(Windows 2003�ϰ��)                                                               >> %RES_LAST_FILE% 2>&1
 icacls %systemroot%\system32\Config                                                        >> %RES_LAST_FILE% 2>&1
echo. 3. \system32\winevt\Logs\Security.evtx ����                                                >> %RES_LAST_FILE% 2>&1
 icacls %SystemRoot%\system32\winevt\Logs\Security.evtx                                    >> %RES_LAST_FILE% 2>&1
echo. 3.1 \system32\Config\SecEvent.Evt ����(Windows 2003�ϰ��)                                                >> %RES_LAST_FILE% 2>&1
 icacls %SystemRoot%\system32\Config\SecEvent.Evt                                    >> %RES_LAST_FILE% 2>&1
echo.  
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.���� : ���� �� ���ȷα� ������ Everyone�׷� �� Users�׷� ���翩�� Ȯ��               >> %RES_LAST_FILE% 2>&1
echo.��� : ��ȣ ���� �� 1���� �ش���� �ʴ� ��� ���                                      >> %RES_LAST_FILE% 2>&1
echo.��ȣ : 1) 1�� �׸񿡼� SeSecurityPrivilege ���� ���� S-1-5-32-544(������)�� ���      >> %RES_LAST_FILE% 2>&1
echo.     2) 2,3�� �׸񿡼� Everyone ���� ����, Users�� W, C, F �� 1������ �������� ���� ���  >> %RES_LAST_FILE% 2>&1
echo.���� : W(����), C(�ٲٱ�), F(��� ����)                                                           >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-109 �ý��� �ֿ� �̺�Ʈ �α� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-109] OK
echo.##### SRV109 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. [ 1. ���� �α� ���� ��� ���� Ȯ�� ]	>> %RES_LAST_FILE% 2>&1
echo.# 01. ��ü �׼��� ���� #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditObjectAccess">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 02. ���� ���� ���� #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditAccountManage">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 03. ���� �α׿� �̺�Ʈ ���� #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditAccountLogon">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 04. ���� ��� ���� #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditPrivilegeUse">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 05. ���͸� ���� �׼��� ���� #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditDSAccess"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 06. �α׿� �̺�Ʈ ���� #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditLogonEvents"	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 07. �ý��� �̺�Ʈ ���� #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditSystemEvents">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 08. ��å ���� ���� #>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditPolicyChange">> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# 09. ���μ��� ���� ���� #	>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /I "AuditProcessTracking">> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.���� : ���� ��� ���� Ȯ��	 >> %RES_LAST_FILE% 2>&1
echo.��� : ���� ��å �ǰ� ���ؿ� ���� ���� ������ �Ǿ� �ִ� ���	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���� ��å �ǰ� ���ؿ� ���� ���� ������ �Ǿ� ���� �ʴ� ���	 >> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.  * ���� ��å �ǰ� ����(�Ʒ� ������ �ü�� �����翡�� �Ϲ������� �����ϴ� ��������) 	>> %RES_LAST_FILE% 2>&1
echo.	- 01. ��ü �׼��� ����: (0) ���� �� ��>> %RES_LAST_FILE% 2>&1
echo.	- 02. ���� ���� ����: (1) ����>> %RES_LAST_FILE% 2>&1
echo.	- 03. ���� �α׿� �̺�Ʈ ����: (1) ����>> %RES_LAST_FILE% 2>&1
echo.	- 04. ���� ��� ����: (0) ���� �� ��>> %RES_LAST_FILE% 2>&1
echo.	- 05. ���͸� ���� �׼��� ����	: (1) ����>> %RES_LAST_FILE% 2>&1
echo.	- 06. �α׿� �̺�Ʈ ����	: (3) ����, ����>> %RES_LAST_FILE% 2>&1
echo.	- 07. �ý��� �̺�Ʈ ����	: (3) ����, ����>> %RES_LAST_FILE% 2>&1
echo.	- 08. ��å ���� ����: (1) ����>> %RES_LAST_FILE% 2>&1
echo.	- 09. ���μ��� ���� ����	: (0) ���� �� ��>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-115 �α��� ������ ���� �� ���� �̼���]>> %RES_LAST_FILE% 2>&1
echo.[SRV-115] OK
echo.##### SRV115 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.# ��������	#  	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo.���� :  �αױ��(�̺�Ʈ �α�)�� ���� ������ ����,�м�,����Ʈ �ۼ� �� ���� ���� ��ġ�� �Ǿ� ���� ��� ��ȣ	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.    	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-116 ������ ���縦 ������ �� ���� ���, ��� �ý��� ���ᡱ ��� ���� ����] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-116] OK
echo.##### SRV116 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#CrashOnAuditFail>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "CrashOnAuditFail" 	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.���� : CrashOnAuditFail�� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : 4,1(�����) 	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 4,0(��� ����) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-118 �ֱ����� ������ġ �� ���� �ǰ���� ������]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-118] OK
echo.##### SRV118 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ 1. �ֽ� ������ ���� ���� ]                                              	>> %RES_LAST_FILE% 2>&1
echo.#version, buildnumber, ostype, servicepackmajorversion	>> %RES_LAST_FILE% 2>&1
	(wmic os get version, buildnumber, servicepackmajorversion, caption /format:list)>> wmic3.ahn
	TYPE wmic3.ahn>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : �Ʒ��� ���� �������� �ֽ� �������� Ȯ��>> %RES_LAST_FILE% 2>&1
echo. -Win 2000 : SP4 (Kernel build : 2195) >> %RES_LAST_FILE% 2>&1
echo. -Win 2003 : SP2 (Kernel build : 3790) >> %RES_LAST_FILE% 2>&1
echo. -Win 2008 : SP2 (Kernel build : 6002) >> %RES_LAST_FILE% 2>&1
echo. -Win 2008 R2 : SP1 (Kernel build : 7601) >> %RES_LAST_FILE% 2>&1
echo. -Win 2012 : ������ ����(��ȣ)(Kernel build : 9600) >> %RES_LAST_FILE% 2>&1
echo. -Win 2016 : ������ ����(��ȣ)(Kernel build : 14393) >> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���� �������� ����Ǿ� ���� ���, 2012 ���� �̻� ��ȣ 	>> %RES_LAST_FILE% 2>&1
echo.��� : ���� �������� ����Ǿ� ���� ���� ��� >> %RES_LAST_FILE% 2>&1    
echo.
echo.                                                                                                       >> %RES_LAST_FILE% 2>&1
echo.[ 2. �ֽ� HOTFIX ���� ���� ]                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
REM echo. #2017, 2018�⵵ ��ġ �α�>> %RES_LAST_FILE% 2>&1
REM 	type hotfix.ahn | find /I "/2017">> %RES_LAST_FILE% 2>&1
REM 	type hotfix.ahn | find /I "/2018">> %RES_LAST_FILE% 2>&1
echo.# OS ����, ��ġ�� ��¥ #>> %RES_LAST_FILE% 2>&1
TYPE wmic3.ahn>> %RES_LAST_FILE% 2>&1
wmic OS get InstallDate>wmic120.ahn
TYPE wmic120.ahn>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# HOT FIX ��ġ ���� #>> %RES_LAST_FILE% 2>&1
wmic QFE Get HotFixID,InstalledOn>wmic120.ahn
TYPE wmic120.ahn>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1

echo.���� :# ����ũ�μ���Ʈ Ȩ���������� �ֽ� ������ġ Ȯ�� #>> %RES_LAST_FILE% 2>&1
echo. http://technet.microsoft.com/ko-kr/security	 >> %RES_LAST_FILE% 2>&1    
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-119 ��� ���α׷� ������Ʈ ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-119] OK
echo.##### SRV119 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo.# ��������	#	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. ��� : ���ͺ� �Ǵ� ���� Ȯ���� ���� ����	 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-123 ���� �α��� ����� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-123] OK
echo.##### SRV123 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1    
echo.#dontdisplaylastusername>> %RES_LAST_FILE% 2>&1    
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /s | find /I "dontdisplaylastusername" >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.���� : dontdisplaylastusername�� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : 0(��� ����) 	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 1(�����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1

 
echo.[SRV-125 ȭ�麸ȣ�� �̼���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-125] OK
echo.##### SRV125 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
	reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find /I "ScreenSaveActive">> %RES_LAST_FILE% 2>&1
	reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find /I "ScreenSaverIsSecure">> %RES_LAST_FILE% 2>&1
	reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find /I "ScreenSaveTimeOut">> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : ScreenSaveActive, ScreenSaverIsSecure, ScreenSaveTimeOut�� �� �Ʒ��� ������ Ȯ��  >> %RES_LAST_FILE% 2>&1
echo. -ScreenSaveActive = 1 >> %RES_LAST_FILE% 2>&1  
echo. -ScreenSaverIsSecure = 1 >> %RES_LAST_FILE% 2>&1  
echo. -ScreenSaveTimeOut = 600(10��) ���� 	>> %RES_LAST_FILE% 2>&1  
echo.��� : ���� ���� �� �ϳ��� �׸��̶� ���� �ʰ� ������ ��� 	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���� ���� �����Ǿ� ���� ��� ��ȣ >> %RES_LAST_FILE% 2>&1  
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-126 �ڵ� �α׿� ���� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-126] OK
echo.##### SRV126 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
	reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "autoadminlogon">> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : AutoAdminLogon�� Ȯ��  >> %RES_LAST_FILE% 2>&1
echo.��� : ���� �ִ� ��� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���� ���ų� 0�� ��� 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-127 ���� ��� �Ӱ谪 ���� �̺�]>> %RES_LAST_FILE% 2>&1
echo.[SRV-127] OK
echo.##### SRV127 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[# 1. ���� ��� �Ӱ谪 Ȯ�� ] >> %RES_LAST_FILE% 2>&1
echo.#Lockout threshold >> %RES_LAST_FILE% 2>&1
	net accounts | find /I "Lockout threshold"  	>> %RES_LAST_FILE% 2>&1
	net accounts | find /I "�Ӱ谪"  	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : ���� ȸ���� �н����� ��å�� Ȯ���Ͽ� ���ؿ� ���ϴ��� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.       ������ ���� ��� ��� �Ӱ谪(Lockout threshold)�� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : ���ؿ� ������ �ʰų� ������ ���� ��� Lockout threshold�� 5 �ʰ� �� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���ؿ� ���ϰų� ������ ���� ��� Lockout threshold�� 5 ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-128 NTFS ���� �ý��� �̻��]>> %RES_LAST_FILE% 2>&1
echo.[SRV-128] OK
echo.##### SRV128 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[# 1. ���Ͻý��� Ȯ�� ]>> %RES_LAST_FILE% 2>&1
	wmic volume get DriveLetter, FileSystem >> wmic4.ahn
	TYPE wmic4.ahn >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : �� ������ ���� �ý��� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��ȣ - NTFS ���� �ý��۸� ����ϴ� ��� >> %RES_LAST_FILE% 2>&1
echo.��� - FAT ���� �ý����� ����ϴ� ��� (USB ����) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-129 ��� ���α׷� �̼�ġ]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-129] OK
echo.##### SRV129 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.#���μ��� Ȯ��: ahnlab v3 malware>> %RES_LAST_FILE% 2>&1
	net start |findstr /I "ahnlab v3 malware"|| echo.V3 ��� ���α׷� �̼�ġ>> %RES_LAST_FILE% 2>&1
echo. # �������� ��Ÿ ��� ���α׷� ã�ƺ��� #>> %RES_LAST_FILE% 2>&1
	net start>> %RES_LAST_FILE% 2>&1
	tasklist  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : ��� �߿� ��� ���α׷��� �ִ��� Ȯ��  >> %RES_LAST_FILE% 2>&1
echo.��� : ����>> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���� >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-135 TCP ���� ���� �̺�]>> %RES_LAST_FILE% 2>&1
echo.[SRV-135] OK
echo.##### SRV135 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # SynAttackProtect Ȯ�� #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "SynAttackProtect" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. ���� : '1'�̻����� ���� �Ǿ� ������ ��ȣ>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # EnableDeadGWDetect Ȯ�� #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "EnableDeadGWDetect" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. ���� : '0'���� ���� �Ǿ� ������ ��ȣ>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # KeepAliveTime Ȯ�� #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "KeepAliveTime" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. ���� : 300,000(5��: �ǰ�)���� ���� �Ǿ� ������ ��ȣ>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. # NoNameReleaseOnDemand Ȯ�� #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" | find /I "NoNameReleaseOnDemand" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. ���� : '1'�� ���� �Ǿ� ������ ��ȣ>> %RES_LAST_FILE% 2>&1
echo. # IPEnableRouter Ȯ�� #>> %RES_LAST_FILE% 2>&1
	(reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "IPEnableRouter" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. ���� : 0���� ���� �Ǿ� ������ ��ȣ>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. ���� : ������� ���� ��� �̼����Ȱ����� ���>> %RES_LAST_FILE% 2>&1
echo. ���� : Windows 2008 �̻��� ���, IPEnableRouter ���� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-136 �ý��� ���� ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-136] OK
echo.##### SRV136 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#shutdownwithoutlogon	>> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /s | find /I "shutdownwithoutlogon"  ||echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : shutdownwithoutlogon�� Ȯ��  	>> %RES_LAST_FILE% 2>&1
echo.��� : 1(�����) 	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 0(������) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-137 ��Ʈ��ũ ������ ���� ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-137] OK
echo.##### SRV137 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[# 1.1. ��Ʈ��ũ���� �� ��ǻ�� ������ #]                               >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeRemoteInteractiveLogonRight"   >> %RES_LAST_FILE% 2>&1
echo.[# 1.2. ��Ʈ��ũ���� �� ��ǻ�� ������ �ź� #]                              >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeDenyNetworkLogonRight"    >> %RES_LAST_FILE% 2>&1
echo.[# ����. ��Ʈ��ũ ���� ���� ��� ���� ������Ʈ�� Ȯ�� #]                              >> %RES_LAST_FILE% 2>&1
echo.#fDenyTSConnections	>> %RES_LAST_FILE% 2>&1
	(reg QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /s |find /I "fDenyTSConnections" ||echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.��ȣ : �ʿ��� �׷츸 ���� ��� �Ǿ� ���� ���             >> %RES_LAST_FILE% 2>&1
echo.��� : ���ʿ��� �׷��� ���� ��� �Ǿ� ���� ���             >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : ��Ʈ��ũ ���� ���� ��� ���� ������Ʈ��(fDenyTSConnections) Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : 0(���)	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : 1(��� ����)	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-138 ��� �� ���� ���� ���� ����] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-138] OK
echo.##### SRV138 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.[# 1.1. ���� �� ���丮 ��� #]                                 >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeBackupPrivilege"      >> %RES_LAST_FILE% 2>&1
echo.[# 1.2. ���� �� ���丮 ���� #]                                 >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeRestorePrivilege"     >> %RES_LAST_FILE% 2>&1
echo.��ȣ : "���� �� ���丮 ���" �׸�� "���� �� ���丮 ����" �׸� ���� �׷캰 �������� ���� ������ Everyone �׷��̳� Guests �׷�, Users �׷쿡 ���� ���� ������ ��  >> %RES_LAST_FILE% 2>&1
echo.��� : "���� �� ���丮 ���" �׸�� "���� �� ���丮 ����" �׸� ���� �׷캰 �������� ���� ������ Everyone �׷��̳� Guests �׷�, Users �׷쿡 ���� ���� ���� ��  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-139 �ý��� �ڿ� ������ ���� ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-139] OK
echo.##### SRV139 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.[# 1.1. ��Ʈ��ũ���� �� ��ǻ�� ������ #]                               >> %RES_LAST_FILE% 2>&1
echo.[# SeTakeOwnershipPrivilege #]                              >> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr "SeTakeOwnershipPrivilege" || echo.�� ����  >> %RES_LAST_FILE% 2>&1
echo.��ȣ : "���� �Ǵ� �ٸ� ��ü�� ������ ��������" �׸� ���ѿ� Administrators �׷츸 ������ ���   >> %RES_LAST_FILE% 2>&1
echo.��� : "���� �Ǵ� �ٸ� ��ü�� ������ ��������" �׸� ���ѿ� Everyone, Users �׷� ���� ������ ���  >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-140 �̵��� �̵�� ���� �� ������ ��� ��å ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-140] OK
echo.##### SRV140 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# AllocateDASD>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "AllocateDASD" >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : AllocateDASD�� Ȯ�� 	>> %RES_LAST_FILE% 2>&1
echo.��� : 1(Administrators �� Power Users) �Ǵ� 2(Administrators �� Interactice Users) >> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���� ���ų�(�̼���), 0(Administrators) 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1

echo.[SRV-147 ���ʿ��� SNMP ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-147] OK
echo.##### SRV147 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 SNMP ���� Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
echo.#SNMP ���� ���� ����>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I snmp || echo.[��ȣ] SNMP ���� �̱���) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.��ȣ: 1.1���� SNMP �̻�� Ȥ�� ����ϳ� �ʿ信 ���� ����� ���(Ȯ���ʿ�)  >> %RES_LAST_FILE% 2>&1
echo.���: 1.1���� SNMP ��� >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-148 �� ���� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-148] OK
echo.##### SRV148 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 6.0 URLSCAN.INI check #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\urlscan\urlscan.ini | findstr /i "RemoveServerHeader" || echo."6.0 ������ ���, URLSCAN.INI ���� �����Ƿ� ���"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 7.0 Rewrite rule check(applicationhost.config) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i /c:"Remove Server header" || echo."7.0 ������ ���, Rewrite�� �����Ƿ� ���"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 7.0 Rewrite rule check(web.config(�켱������ web.config�� application���� ����)) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\web.config | findstr /i /c:"Remove Server header" || echo."7.0 ������ ���, Rewrite�� �����Ƿ� ���"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 10.0 Rewrite rule check(applicationhost.config) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i "removeServerHeader" || echo."10.0 ������ ���, removeServerHeader �����Ƿ� ���"   >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.# IIS 10.0 Rewrite rule check(web.config(�켱������ web.config�� application���� ����)) #	>> %RES_LAST_FILE% 2>&1
	TYPE c:\windows\system32\inetsrv\config\web.config | findstr /i "removeServerHeader" || echo."10.0 ������ ���, removeServerHeader �����Ƿ� ���"   >> %RES_LAST_FILE% 2>&1

echo. >> %RES_LAST_FILE% 2>&1
echo.����: 6.0������ RemoveServerHeader =1 �̸� ��ȣ, ���� ���� ��� ���     >> %RES_LAST_FILE% 2>&1
echo.����: 7.0������ Rewrite�� ���� ��� ��ȣ, ���� ���� ��� ���     >> %RES_LAST_FILE% 2>&1
echo.����: 10.0������ removeServerHeader=true �̸� ��ȣ, ���� ���� ��� ���     >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# IIS errorpage check #	>> %RES_LAST_FILE% 2>&1
echo.[ 2. IIS ������ ���� ���� ���� ]
echo.@ IIS 5.0>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	.\bin\mdutil ENUM_ALL W3SVC	> W3SVC_all.ahn
	IF ERRORLEVEL 1 goto 3_24_IIS_6_0
	TYPE W3SVC_all.ahn | findstr /I "CustomError" > SRV-148_ERRMSG.ahn
	TYPE SRV-148_ERRMSG.ahn	>> %RES_LAST_FILE% 2>&1
	echo.	>> %RES_LAST_FILE% 2>&1
	TYPE SRV-148_ERRMSG.ahn | findstr /I "CustomError" > NUL
	IF ERRORLEVEL 1 echo [���] ������ ���� ������ ó�� ������ �������� ����    	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [���] ������ ���� ������ ó�� ������ ������	>> %RES_LAST_FILE% 2>&1
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
	IF ERRORLEVEL 1 echo [���] ������ ���� ������ ó�� ������ �������� ����    	>> %RES_LAST_FILE% 2>&1
	IF NOT ERRORLEVEL 1 echo [���] ������ ���� ������ ó�� ������ ������	>> %RES_LAST_FILE% 2>&1
	goto 3_24_IIS_7_0

:3_24_IIS_7_0
echo.>> %RES_LAST_FILE% 2>&1
echo.@ IIS 7.0>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.# ��������	# >> %RES_LAST_FILE% 2>&1

:3_24_IIS
echo.>> %RES_LAST_FILE% 2>&1
echo.����: 6.0������ RemoveServerHeader =1 �̸� ��ȣ, ���� ���� ��� ���     >> %RES_LAST_FILE% 2>&1
echo.����: 7.0������ Rewrite�� ���� ��� ��ȣ, ���� ���� ��� ���     >> %RES_LAST_FILE% 2>&1
echo.����: 10.0������ removeServerHeader=true �̸� ��ȣ, ���� ���� ��� ���     >> %RES_LAST_FILE% 2>&1
echo.���� : error statusCode(���� �ڵ�) ���� ������ ó�� �������� ���� �ϴ��� Ȯ��  >> %RES_LAST_FILE% 2>&1 
echo.��� : [���] �κ��� '������ ���� ������ ó�� ������ �������� ����'�̸� ���>> %RES_LAST_FILE% 2>&1
echo.��ȣ : [���] �κ��� '������ ���� ������ ó�� ������ ������'�̸� ��ȣ	>> %RES_LAST_FILE% 2>&1  
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-149 ��ũ ���� ��ȣȭ ������]>> %RES_LAST_FILE% 2>&1
echo.[SRV-149] OK
echo.##### SRV149 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.(1.1 ���ͺ� Ȯ��)        >> %RES_LAST_FILE% 2>&1
echo.# �Ʒ� ���ܿ� �ش��ϴ� ������ ���ͺ� Ȯ�� �ʿ�#        >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.��ȣ : "������ ��ȣ�� ���� ������ ��ȣȭ" ��å�� ���õ� ��� >> %RES_LAST_FILE% 2>&1
echo.���� : �ش� ������ ���������� ��ȣ �� ��� (IDC ��, PC�ð���ġ ��)�� ��ġ�� ���� ��� >> %RES_LAST_FILE% 2>&1
echo.     �Ǵ� �ϵ��ũ ��ü �� ���� �ϵ��ũ�� �𰡿�¡ �Ǵ� õ�� �� ��� ���� ���� ����� >> %RES_LAST_FILE% 2>&1
echo.��� : "������ ��ȣ�� ���� ������ ��ȣȭ" ��å�� ���õǾ� ���� ���� ���  >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#����. EFS ���� ������Ʈ�� Ȯ��	>> %RES_LAST_FILE% 2>&1
	(Reg query HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\SystemCertificates\EFS |findstr /I "blob") >> %RES_LAST_FILE% 2>&1
echo.���� : EFSblob ��(�ش� ������Ʈ���� ��������θ� ����ϸ� ���� �����Ͽ��� ��ũ���� ��ȣȭ ������ �ȵǾ� ���� �� �����Ƿ� ���ͺ� �ʿ���) >> %RES_LAST_FILE% 2>&1
echo.��� : ��>> %RES_LAST_FILE% 2>&1
echo.��ȣ : �� ����>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-150 ���� �α׿� ���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-150] OK
echo.##### SRV150 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#SeInteractiveLogonRight>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "SeInteractiveLogonRight" 	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : SeInteractiveLogonRight�� Ȯ�� 	>> %RES_LAST_FILE% 2>&1
echo.��� : "Administrators(*S-1-5-32-544)", "IUSR_(*S-1-5-17)", "������ ����" ���� �ٸ� ���� �� �׷��� ���� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : "Administrators(*S-1-5-32-544)", "IUSR_(*S-1-5-17)", "������ ����" �� ���� >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-151 �͸� SID/�̸� ��ȯ ���]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-151] OK
echo.##### SRV151 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# LSAAnonymousNameLookup>> %RES_LAST_FILE% 2>&1
	(type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | find /I "LSAAnonymousNameLookup" || echo. �� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : (WIN 2008) LSAAnonymousNameLookup�� Ȯ�� >> %RES_LAST_FILE% 2>&1
echo.��� : 1(�����)  >> %RES_LAST_FILE% 2>&1
echo.��ȣ : 0(��� ����) 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-152 �����͹̳� ���� ������ ����� �׷� ���� �̺�]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-152] OK
echo.##### SRV152 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# �����͹̳� ���� ���� ���� Ȯ�� (SeRemoteInteractiveLogonRight)# 	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
	type [RESULT_ahnlab]_%COMPUTERNAME%_securitypolicy.ahn | findstr /r /i "SeRemoteInteractiveLogonRight"	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# �����͹̳� ���� ���� ���� Ȯ�� (fDenyTSConnections)# >> %RES_LAST_FILE% 2>&1
	(reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" | find /I "fDenyTSConnections" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# �����͹̳� ���� ���� ����� �׷� Ȯ��# 	>> %RES_LAST_FILE% 2>&1
	(net localgroup "Remote Desktop Users")	 >> %RES_LAST_FILE% 2>&1	
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : fDenyTSConnections �� �� Remote Desktop Users �׷��� ���� Ȯ��  >> %RES_LAST_FILE% 2>&1
echo.��� : fDenyTSConnections���� 0(���� ���� ���)�̰� Remote Desktop Users �׷쿡 ���ʿ��� ������ �ִ� ��� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : fDenyTSConnections���� 1(���� ���� ��� ����) or (fDenyTSConnections���� 0(���� ���� ���)�̰� Remote Desktop Users �׷쿡 �ʿ��� ������ �ִ� ���) >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-158 ���ʿ��� TELNET ���� ����] 	>> %RES_LAST_FILE% 2>&1
echo.[SRV-158] OK
echo.##### SRV158 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#Telnet ���� ���� ���� >> %RES_LAST_FILE% 2>&1
	(net start | findstr /I telnet || echo ��ȣ. Telnet ���� �� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.#Telnet ���� ��Ʈ Ȯ�� >> %RES_LAST_FILE% 2>&1
	(netstat -na | find "23" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : ���ʿ��� "Telnet Service" ��� ���� 	>> %RES_LAST_FILE% 2>&1
echo.��� : Telnet ���� ������  	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : Telnet ���� �̱��� ��	>> %RES_LAST_FILE% 2>&1
echo.���� : TELNET ���񽺰� ���� ���� ��� ���ͺ並 ���� �ʿ��� �������� ���� �ʿ�>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-163 �ý��� ��� ���ǻ��� �����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-163] OK
echo.##### SRV163 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# ������Ʈ��_LegalNoticeCaption ��(�޼��� â�� ����) >> %RES_LAST_FILE% 2>&1
	(reg QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "LegalNoticeCaption" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.# ������Ʈ��_LegalNoticeText ��(�޼��� â�� ����) 	>> %RES_LAST_FILE% 2>&1
	(reg QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "LegalNoticeText" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.# ���ú�����å_LegalNoticeCaption ��(�޼��� â�� ����) >> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | findstr "LegalNoticeCaption" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo.# ���ú�����å_LegalNoticeText ��(�޼��� â�� ����) 	>> %RES_LAST_FILE% 2>&1
	(type c:\test.inf | findstr "LegalNoticeText" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.���� : LegalNoticeCaption, LegalNoticeText �� ������Ʈ���� Ȯ��>> %RES_LAST_FILE% 2>&1
echo.��� : �� ������Ʈ�� ��� �� �� (REG_SZ ��) 	>> %RES_LAST_FILE% 2>&1
echo.��ȣ : Ư���� 	>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1 
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-170 SMTP ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-170] OK
echo.##### SRV170 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 SMTP ���� Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
echo.# SMTP SERVICE	>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I "SMTP" || echo. "SMTP �̱���, ���� �׸� ��� ��ȣ(�Ǵ� N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.2 SMTP ��Ʈ Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
	(netstat -na | find ":25" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.��ȣ: 1.1���� IIS �̻�� Ȥ�� 25��Ʈ �̻�� Ȥ�� ��Ʈ ����ϳ� SMTP ���� �� ��� ������ ������ �ʴ� ���(���ͺ� Ȥ�� ��������)     >> %RES_LAST_FILE% 2>&1
echo.���: 1.1���� IIS ��� Ȥ�� 25��Ʈ ����ϸ� SMTP ���� �� ��� ������ �������� ���     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-171 FTP ���� ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-171] OK
echo.##### SRV171 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 FTP ���� Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
echo.# FTP SERVICE	>> %RES_LAST_FILE% 2>&1
 (net start | findstr /I "FTP" || echo. "FTP �̱���, ���� �׸� ��� ��ȣ(�Ǵ� N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.2 FTP/ ��Ʈ Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
	(netstat -na | find ":21" | find /I "LISTENING")>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. #applicationHost.config ���� ���� Ȯ��  >> %RES_LAST_FILE% 2>&1
	(TYPE %systemroot%\system32\inetsrv\config\applicationHost.config | findstr /i "suppressDefaultBanner" || echo.�� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1	
echo.��ȣ: 1.1���� IIS �̻�� Ȥ�� 21��Ʈ �̻�� Ȥ�� ��Ʈ ����ϳ� suppressDefaultBanner="TRUE" ������ �����ϸ� ��ȣ, FTP ���� �� ��� ������ ������ �ʴ� ���(���ͺ� Ȥ�� ��������)     >> %RES_LAST_FILE% 2>&1
echo.���: 1.1���� IIS ��� Ȥ�� 21��Ʈ ����ϸ� FTP ���� �� ��� ������ �������� ���     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1




echo.[SRV-172 ���ʿ��� �ý��� �ڿ� ���� ����]>> %RES_LAST_FILE% 2>&1
echo.[SRV-172] OK
echo.##### SRV172 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.#���� ���� Ȯ�� ����>> %RES_LAST_FILE% 2>&1
	(net share)>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo.��� : ���ʿ��� ������ ������ ��� >> %RES_LAST_FILE% 2>&1
echo.��ȣ : ���������� ���ų�, ������ �ʿ��� ������ ������ ���>> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo.>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1



echo.[SRV-173 DNS ������ ����� ���� ������Ʈ ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-173] OK
echo.##### SRV173 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 DNS ���� Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
echo.# IIS ADMIN SERVICE	>> %RES_LAST_FILE% 2>&1
	(sc query dns || echo. "DNS �̱���, ���� �׸� ��� ��ȣ(�Ǵ� N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.# DnsSettings.txt	AllowUpdate ������ Ȯ��>> %RES_LAST_FILE% 2>&1
	dnscmd /ExportSettings
	(TYPE %systemroot%\system32\dns\DnsSettings.txt | findstr /I "AllowUpdate" || echo.���� ����) >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.��ȣ: AllowUpdate�� 1�� �ƴѰ��    >> %RES_LAST_FILE% 2>&1
echo.���: AllowUpdate�� 1�� ���     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.[SRV-174 ���ʿ��� DNS ���� ����]	>> %RES_LAST_FILE% 2>&1
echo.[SRV-174] OK
echo.##### SRV174 #####                                               >> %RES_LAST_FILE% 2>&1
echo.##### START #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.[ # 1.1 DNS ���� Ȯ�� # ]        >> %RES_LAST_FILE% 2>&1
echo.# IIS ADMIN SERVICE	>> %RES_LAST_FILE% 2>&1
	sc query dns || echo. "DNS �̱���, ���� �׸� ��� ��ȣ(�Ǵ� N/A)") >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo.��ȣ: DNS ���񽺰� ���� ������ �ʰų�, �ʿ信 ���� ��� ���� ���     >> %RES_LAST_FILE% 2>&1
echo.���: DNS ���񽺰� ���ʿ��ϰ� ���� ���� ���AllowUpdate�� 1�� ���     >> %RES_LAST_FILE% 2>&1
echo.##### END #####                                              	>> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1
echo. >> %RES_LAST_FILE% 2>&1


echo.# IIS ADMIN SERVICE check	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"IIS Admin Service" || echo."IIS Admin Service �̱���, ���� �׸� ��� ��ȣ(�Ǵ� N/A)")>> %RES_LAST_FILE% 2>&1
echo.[# World Wide Web Publishing Service check]	>> %RES_LAST_FILE% 2>&1
	(net start | findstr /I /C:"World Wide Web Publishing Service" || echo. World Wide Web Publishing Service ���� �̱���) >> %RES_LAST_FILE% 2>&1



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



