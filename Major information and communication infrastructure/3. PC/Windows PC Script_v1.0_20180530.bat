setlocal
chcp 437
FOR /F "tokens=1" %%a IN ('date /t') DO set day=%%a

TITLE Windows PC sysinfo check
echo Windows PC sysinfo check                                                               > %COMPUTERNAME%-result.txt
color 9f
echo Copyright (c) 2018 SK think Co. Ltd. All right Reserved                                  >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo ��������������������             Windows PC Security Check          ��������������������� >> %COMPUTERNAME%-result.txt
echo ��������������������                    SK think                  ��������������������� >> %COMPUTERNAME%-result.txt
echo ��������������������                 Copyright 2018-05              ��������������������� >> %COMPUTERNAME%-result.txt
echo ======================================================================================= >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �������������������������������������  Start Time  �������������������������������������  >> %COMPUTERNAME%-result.txt
echo ������ : %DATE%																		 >> %COMPUTERNAME%-result.txt
echo ���˽ð� : %TIME%																		 >> %COMPUTERNAME%-result.txt
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
echo ##########################         1. ���� ����        ################################ >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.01 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############            P-1 �н����� �ִ� ��� �Ⱓ            ##################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Maximum password age (days): ���� 90 �̻��� ��� ��ȣ                           >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
net accounts | find "Maximum password"														 >> %COMPUTERNAME%-result.txt
echo ����� ���� : %username%																 >> %COMPUTERNAME%-result.txt
net user %username% | find "Password required"												 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.01 END																				 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.02 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############               P-2 �н����� ��å����               ##################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Minimum password length: ���� 9 �̻� �����Ǿ� �ִ� ��� ��ȣ                   >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
net accounts | find "length"                                                           >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.02 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.03 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############         P-3 ���� �ֿܼ��� �ڵ� �α׿� ����        ##################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����:  (1) : AutoAdminLogon (DWORD ���� 0�� ��� ��ȣ)             				     >> %COMPUTERNAME%-result.txt
echo ��        (2) : AutoAdminLogon (DWORD ���� 1�� ��� ���)               			     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
type local_security.txt | findstr -i "SecurityLevel" 										 >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\setup\recoveryconsole"           >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\setup\recoveryconsole" | find "securitylevel"           >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.03 END >> %COMPUTERNAME%-result.txt
echo ��� ����: AutoAdminLogon >> %COMPUTERNAME%-result.txt
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.04 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############                  P-4 ���� ���� ����                #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �Ʒ� ���ؿ� ������ ��� ��ȣ				                     >> %COMPUTERNAME%-result.txt
echo ��       : (1) �⺻������ ��Ȱ��ȭ �Ǿ� ������ AutoShareWks ������Ʈ�� ���� 0            >> %COMPUTERNAME%-result.txt
echo ��       : (2) �Ϲݰ����� ���ų� ������ ����� ��� Everyone ���� ����                   >> %COMPUTERNAME%-result.txt
echo ��       : (3) 1, 2 ������ �Ѵ� �����ؾ� ��ȣ			                     >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- �⺻��������_�⺻���� ��Ȳ                                                            >> %COMPUTERNAME%-result.txt
net share | FIND /V "IPC$" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- �⺻��������_�⺻���� ��Ȱ��ȭ ���� ������Ʈ��(�� ���� ��� ���)                     >> %COMPUTERNAME%-result.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" | findstr -i "autoshare" >>%COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- �Ϲݰ�������_�Ϲݰ��� ��Ȳ                                                            >> %COMPUTERNAME%-result.txt
net share | find /v "$" | find /v "command"                                                  >> %COMPUTERNAME%-result.txt
net share | find /v "$" | find /v "command" |find /v "-"                                     >  share-folder.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- �Ϲݰ�������_�Ϲݰ��� ���� ��Ȳ                                                       >> %COMPUTERNAME%-result.txt
FOR /F "tokens=2 skip=3" %%j IN (share-folder.txt) DO cacls %%j                              >> %COMPUTERNAME%-result.txt 2>nul
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
del share-folder.txt
echo 1.04 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ��� ����:�������� ��Ȳ >> %COMPUTERNAME%-result.txt
net share >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareWks" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.05 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############              P-05 ���ʿ��� ���� ����             #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �ý��ۿ��� �ʿ����� �ʴ� ����� ���񽺰� �����Ǿ� ���� ��� ��ȣ                >> %COMPUTERNAME%-result.txt
echo ��       : (1) Alerter(�������� Ŭ���̾�Ʈ�� ���޼����� ����)                          >> %COMPUTERNAME%-result.txt
echo ��       : (2) Clipbook(������ Clipbook�� �ٸ� Ŭ���̾�Ʈ�� ����)                        >> %COMPUTERNAME%-result.txt
echo ��       : (3) Messenger(Net send ��ɾ �̿��Ͽ� Ŭ���̾�Ʈ�� �޽����� ����)          >> %COMPUTERNAME%-result.txt
echo ��       : (4) Simple TCP/IP Services(Echo, Discard, Character, Generator, Daytime, ��)  >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
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
ECHO �� ���ʿ��� ���񽺰� �������� ����.                                     >> %COMPUTERNAME%-result.txt
) else ( 
echo �� �Ʒ��� ���� ���ʿ��� ���񽺰� �߰ߵǾ���.                                            >> %COMPUTERNAME%-result.txt
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
echo ###############        P-06  Windows Messenger(MSN, .NET �޽Ŵ� ��) #################### >> %COMPUTERNAME%-result.txt
echo ###############              �� ���� ��� �޽����� ������        #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: PC���� Windows Messenger�� ��� �� ��� ���                                    >> %COMPUTERNAME%-result.txt
echo ��       : (1) PreventRun    REG_DWORD    0x1 ��� ��ȣ                                  >> %COMPUTERNAME%-result.txt
echo ��       : Windows Messenger �� ��ġ �Ǿ� ���� ������� ��ȣ                             >> %COMPUTERNAME%-result.txt
echo ��       : (2) PreventRun    REG_DWORD    0x0 ��� ���                                  >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                         >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Messenger\Client" /s | findstr "PreventRun" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.06 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �� ���� : Messenger\Client ��ġ���� Ȯ��                                                 >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.07 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############             P-07 ���� �ý����� NTFS�� ����         #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���Ͻý����� ���� ����� ���� ���ִ� NTFS�� ��� ��ȣ                          >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - C: ����̺� ���� �ý��� Ȯ��(NTFS�� ��� ��ȣ)                                        >> %COMPUTERNAME%-result.txt
fsutil fsinfo volumeinfo c:\                                                                 > fsutil.txt
type fsutil.txt | findstr -i "volume name"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - (����)C: ����̺� ���� Ȯ��(NTFS�� ��� ������ ���� �ο� ������ ��µ�)               >> %COMPUTERNAME%-result.txt
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
echo ###############             P-08 �ٸ� OS�� ��Ƽ���� ����           #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ���� OS�� ��ġ�Ͽ� ����ϰ� ���� ��� ��ȣ			                     >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
bcdedit                                                                                      >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.08 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.09 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##############  P-09 ������ ����� �ӽ� ���ͳ� ���� ������ ���� ���� ################ >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������ ����� �ӽ����ͳ� ���� ������ ���� ������ �ڵ����� ���� ���� ���� ��� >> %COMPUTERNAME%-result.txt
echo ��       : (1) Persistent    REG_DWORD    1 ��� ���                                    >> %COMPUTERNAME%-result.txt
echo ��       : (2) Persistent    REG_DWORD    0 ��� ��ȣ                                    >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - 1. �׷� ���� ��å				                                     >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Cache"  | findstr /I "Persistent"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - 2. ���� ������ ����             		         	        	     >> %COMPUTERNAME%-result.txt
reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\CACHE"  | findstr /I "Persistent"  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - �Ǵ� ����                 					        	     >> %COMPUTERNAME%-result.txt
echo   ��. 1,2�� ���� �Ѵ� ���� ��� ���				        	     >> %COMPUTERNAME%-result.txt
echo   ��. 1,2�� ���� �Ѵ� 0�� ��� ��ȣ				        	     >> %COMPUTERNAME%-result.txt
echo   ��. 1�� ���� ���� 2�� ���� 0�� ��� ��ȣ        			        	     >> %COMPUTERNAME%-result.txt
echo 1.09 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Cache ��" >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\CACHE" ��" >> %COMPUTERNAME%-result.txt
reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\CACHE" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt

echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.10 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############           P-10 HOT FIX �� �ֽ� ������ġ ����       #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: HOT FIX �� �ֽ� ������ġ ���� �� ��ȣ                                           >> %COMPUTERNAME%-result.txt
echo ��       : (1) ������Ʈ �̷� �� �ڵ� ������Ʈ ���� ��Ȳ���� �Ǵ� �Ұ� ��                 >> %COMPUTERNAME%-result.txt
echo ��       :     ����ڿ� ���ͺ並 ���� PMS ���� ����, ��ġ �ֱ� ������ �Ǵ�               >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - '##����2. Windows ������Ʈ �̷�##' �����Ͽ� �ֱ� ������Ʈ �̷� Ȯ��                   >> %COMPUTERNAME%-result.txt
type c:\windows\softwaredistribution\reportingevents.log >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.- Windows �ڵ�������Ʈ ���� ��Ȳ                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /s | findstr "AUOptions" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.10 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.11 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############               P-11 �ֽ� ������ ����              #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �ֽ� �������� ��ġ�Ǿ� ���� ��� ��ȣ                                         >> %COMPUTERNAME%-result.txt
echo ��       : (Windows 7 SP 1)  					                                         >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
systeminfo > systeminfo.txt
type systeminfo.txt | find -i "Host Name"                                                    >> %COMPUTERNAME%-result.txt
type systeminfo.txt | find -i "Os Name"                                                      >> %COMPUTERNAME%-result.txt
type systeminfo.txt | find -i "Os Version"                                                   >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.11 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo �� ����: �ý��� ����                                                                     >> %COMPUTERNAME%-result.txt
type systeminfo.txt                                                                          >> %COMPUTERNAME%-result.txt
del systeminfo.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.12 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############        P-12 MS-Office �ѱ�, ��� ��ũ�ι� ��     #################### >> %COMPUTERNAME%-result.txt
echo ###############        �� �������α׷��� ���� �ֽ� ���� ��ġ ��    #################### >> %COMPUTERNAME%-result.txt
echo ###############                    �ǰ���� ����                   #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ������� �������α׷��� ���� �ֽ� ���� ��ġ �� �ǰ���� ���뿩�� Ȯ��           >> %COMPUTERNAME%-result.txt
echo ��       (1) : (��� : MS-Office, �ѱ�, ��� ��ũ�ι�)				                 >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
wmic product list brief						                                  			     >> program.txt
echo - Microsoft Office ���� ����(���̷��� '##����1. MS-Office ������Ʈ �̷�##' ����) >> %COMPUTERNAME%-result.txt
type program.txt | findstr -i "Office"                                                          >> %COMPUTERNAME%-result.txt
IF ERRORLEVEL 1 echo MS-OFFICE�� ��ġ�Ǿ� ���� �ʽ��ϴ�.                                     >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - Acrobat Reader ���� ����			                                                     >> %COMPUTERNAME%-result.txt
type program.txt | findstr -i "Adobe"                                                           >> %COMPUTERNAME%-result.txt
IF ERRORLEVEL 1 echo Acrobat�� ��ġ�Ǿ� ���� �ʽ��ϴ�.                                       >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo - �ѱ� ���� ����				                                                         >> %COMPUTERNAME%-result.txt
type program.txt | findstr -i "hancom hansoft"                                                          >> %COMPUTERNAME%-result.txt
type program.txt | find /I "haansoft"                                                        >> %COMPUTERNAME%-result.txt
IF ERRORLEVEL 1 echo �ѱ��� ��ġ�Ǿ� ���� �ʽ��ϴ�.                                          >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.12 END >> %COMPUTERNAME%-result.txt
type program.txt>> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.13 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ##############  P-13 ���̷��� ��� ���α׷� ��ġ �� �ֱ��� ������Ʈ  ################## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ����� ��ġ�Ǿ� ������ �ǽð� ������Ʈ ������ ����Ǿ� �ִ� ���            >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.�� ��� ��ġ���� Ȯ��                                                                    >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" > nul
IF ERRORLEVEL 1 echo AhnLab V3 Internet Security �� ��ġ�Ǿ� ���� �ʽ��ϴ�.              >> %COMPUTERNAME%-result.txt
IF NOT ERRORLEVEL 1 echo AhnLab V3 Internet Security �� ��ġ�Ǿ� �ֽ��ϴ�.                   >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.�� V3 �ǽð� ������Ʈ ����                                                           >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0" /s | findstr "V3IS90" | find "REG_DWORD" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo V3 �ڵ� ������Ʈ �ֱ�                                                              >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0\Option\UPDATE" /s | findstr "autoupdateperiod" >> %COMPUTERNAME%-result.txt
echo.                                                                                       >> %COMPUTERNAME%-result.txt
echo 1.13 END >> %COMPUTERNAME%-result.txt

echo �� V3 ���� Ȯ�� >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0" >> %COMPUTERNAME%-result.txt
echo �� V3 Update ���� >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0\Option\UPDATE" >> %COMPUTERNAME%-result.txt
echo.                                                                                       >> %COMPUTERNAME%-result.txt
echo.                                                                                       >> %COMPUTERNAME%-result.txt
echo 1.14 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo #########  P-14 ���̷��� ��� ���α׷����� �����ϴ� �ǽð� ���� ��� Ȱ��ȭ  ########## >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ����� ��ġ �Ǿ� ������, �ǽð� ��������� Ȱ��ȭ �� ��� ��ȣ                  >> %COMPUTERNAME%-result.txt
echo    Sysmonuse  REG_DWORD    "1"    ��� ��ȣ                                             >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.�� ��� ��ġ���� Ȯ��                                                                   >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" > nul
IF ERRORLEVEL 1 echo AhnLab V3 Internet Security �� ��ġ�Ǿ� ���� �ʽ��ϴ�.          >> %COMPUTERNAME%-result.txt
IF NOT ERRORLEVEL 1 echo AhnLab V3 Internet Security �� ��ġ�Ǿ� �ֽ��ϴ�.           >> %COMPUTERNAME%-result.txt
net start | findstr -i "V3 ahnlab" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.�� V3 �ǽð� �˻� Ȱ��ȭ ����                                                           >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\AhnLab\V3IS80\sysmon" /s | findstr "sysmonuse" > V3_check1.txt
type V3_check1.txt                                                                           >> %COMPUTERNAME%-result.txt     
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.------------------------------------------------------------                      >> %COMPUTERNAME%-result.txt
echo.����. �ǽð� �˻� ���� �� �ڵ����� �ٽ� ���� �ð� ����                            >> %COMPUTERNAME%-result.txt                              
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\AhnLab\V3IS80\sysmon" /s | findstr "restart" > V3_check2.txt
type V3_check2.txt                                                                     >> %COMPUTERNAME%-result.txt     
echo.                                                                                  >> %COMPUTERNAME%-result.txt   
echo.��V3 ����� ��ġ�� �Ǿ� ���� ���� ��� "N/A"                                      >> %COMPUTERNAME%-result.txt
echo.                                                                                  >> %COMPUTERNAME%-result.txt   
del V3_check1.txt
del V3_check2.txt

echo 1.14 END >> %COMPUTERNAME%-result.txt
echo �� V3 Schedule ���� >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\ASPack\9.0\Option\SCHDLSCN" >> %COMPUTERNAME%-result.txt
echo.                                                                     >> %COMPUTERNAME%-result.txt
echo.                                                                     >> %COMPUTERNAME%-result.txt
echo 1.15 START                                                           >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############     P-15 OS���� �����ϴ� ħ������ ��� Ȱ��ȭ      #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Windows ��ȭ�� ��� "���" ���̸� ��ȣ                      >> %COMPUTERNAME%-result.txt
echo ��       (1) : (EnableFirewall	0 �� ��� ���)					     >> %COMPUTERNAME%-result.txt
echo ��       (2) : (EnableFirewall	1 �� ��� ��ȣ)					     >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo [��ȭ�� ���� ����]                                                                      >> %COMPUTERNAME%-result.txt
echo ---------------------------------------------------------------------------------       >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"  | findstr "EnableFirewall" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [���� ��� ���� ����]                                                                   >> %COMPUTERNAME%-result.txt
echo ---------------------------------------------------------------------------------       >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"  | findstr "DoNotAllowExceptions" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo [���� ��Ʈ ��� ����]                                                                   >> %COMPUTERNAME%-result.txt
echo ---------------------------------------------------------------------------------       >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\GloballyOpenPorts\List" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo *. EnableFirewall ���� ���� ��� ��ȣ�� �Ǵ�                                            >> %COMPUTERNAME%-result.txt
echo   (������ ��ġ �� �⺻���� ��ȭ���� Ȱ��ȭ �Ǿ� �ִ� ��� ������Ʈ�� ���� ����)         >> %COMPUTERNAME%-result.txt
echo 1.15 END >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.16 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############       P-16 ȭ�麸ȣ�� ��� �ð��� 5~10������       #################### >> %COMPUTERNAME%-result.txt
echo ###############       ���� �� ����۽� ��ȣ�� ��ȣ�ϵ��� ����      #################### >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: ȭ�� ��ȣ�⸦ �����ϰ�, ��ȣ�� ����ϸ�, ��� �ð��� ����� ��å�� �°� ���� �� ��� ��ȣ >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
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
echo #############    P-17 CD,DVD,USB �޸� ��� ���� �̵���� �ڵ�����   ################# >> %COMPUTERNAME%-result.txt
echo #############       ���� �� �̵��� �̵� ���� ���ȴ�å ����        ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: CD,DVD,USB �޸� ��� ���� �̵���� �ڵ����� ���� ������ ������ ��� ��ȣ      >> %COMPUTERNAME%-result.txt
echo ��       (1) : (NoDriveTypeAutoRun DWORD ���� "255(��� ����̺�)" �� ���� �Ǿ� ���� ��� ��ȣ) >> %COMPUTERNAME%-result.txt
echo ��       (2) : (NoDriveTypeAutoRun DWORD ���� "181(CD-ROM, �̵��� �̵��)�̰ų�          >> %COMPUTERNAME%-result.txt
echo ��       (3) : (NoDriveTypeAutoRun DWORD ���� ���� ��� ���				             >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
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
echo ###############       P-18 PC ���� �̻�� (3����) ActiveX ����        ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: 3���� �̻��� ������� ����  ActiveX �� ������ ��� ���                         >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo ����� ���ͺ�           																 >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.18 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.19 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############   P-19 �ý��� ���ý� Windows Messenger �ڵ����� ����  ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: Windows MSN �ڵ����� ���� �� ��ȣ                                               >> %COMPUTERNAME%-result.txt
echo ��       (DWORD ���� 1�̰ų�, Windows Messenger �� ��ġ�Ǿ� ���� ���� ��� ��ȣ)         >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Messenger\Client"  /s | findstr "PreventAutoRun" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Messenger\Client" /I "PreventAutoRun" > nul
IF ERRORLEVEL 1 echo Windows Messenger �� ��ġ�Ǿ� ���� �ʽ��ϴ�.                            >> %COMPUTERNAME%-result.txt
IF NOT ERRORLEVEL 1 echo Windows Messenger �� ��ġ�Ǿ� �ֽ��ϴ�.                             >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.19 END >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.20 START                                                                              >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo ###############             P-20 ���� ���� ���� ��å ����             ################# >> %COMPUTERNAME%-result.txt
echo ####################################################################################### >> %COMPUTERNAME%-result.txt
echo �� ����: �������� ���� ������ ������ ��� ��ȣ                                             >> %COMPUTERNAME%-result.txt
echo ��       (1) : (DWORD ���� 0�� ��� ��ȣ - ������)                                      >> %COMPUTERNAME%-result.txt
echo ��       (2) : (������� ���� ��� ��ȣ - �������� ����)                                   >> %COMPUTERNAME%-result.txt
echo �� ��Ȳ                                                                                  >> %COMPUTERNAME%-result.txt
echo.                                                                                         >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"  /s | findstr "fAllowUnsolicited" >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo.                                                                                        >> %COMPUTERNAME%-result.txt
echo 1.20 END >> %COMPUTERNAME%-result.txt
echo.                                                                                      >> %COMPUTERNAME%-result.txt
echo ����: fAllowUnsolicited                                                              >> %COMPUTERNAME%-result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" >> %COMPUTERNAME%-result.txt
echo.                                                                                      >> %COMPUTERNAME%-result.txt
echo.                                                                                      >> %COMPUTERNAME%-result.txt
echo �������������������������������������   END Time  ������������������������������������� >> %COMPUTERNAME%-result.txt
echo.
echo ##����1. PC ���� ��Ȳ##		                                                         >> %COMPUTERNAME%-result.txt
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
echo �������������������������������������������������������������
echo ����                                                      ����
echo ����       Windows PC Security Check is Finished          ����
echo ����                                                      ����
echo �������������������������������������������������������������
echo.
echo END_RESULT                                                 >> %COMPUTERNAME%-result.txt
pause
EXIT
