#!/bin/sh

LANG=C
export LANG

HOSTNAME=`hostname`
#DATE=`date +%Y-%m-%d`
#IP=`ifconfig eth0 | sed -n '/inet addr:/s/ *inet addr:\([[:digit:].]*\) .*/\1/p'`
IP=`ip addr | grep -w inet | awk '{ print $2 }' | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -v "127.0.0.1"`
RES_LAST_FILE=Linux_${IP}_${HOSTNAME}.log

echo "***********************************************************"
echo "****** AhnLab System Checklist for Linux ver 22.1.21 ******"
echo "******   Copyright 2022 Ahnlab. All right Reserved   ******"
echo "*******************************0****************************"

echo "***********************************************************"											>> $RES_LAST_FILE 2>&1
echo "****** AhnLab System Checklist for Linux ver 22.1.21 ******"											>> $RES_LAST_FILE 2>&1
echo "******   Copyright 2022 Ahnlab. All right Reserved   ******"											>> $RES_LAST_FILE 2>&1
echo "***********************************************************"											>> $RES_LAST_FILE 2>&1
echo 																										>> $RES_LAST_FILE 2>&1
echo "System check start. Please wait..."
	date
echo " "

echo "* Start Time " 																						>> $RES_LAST_FILE 2>&1
	date 																									>> $RES_LAST_FILE 2>&1
echo " "																									>> $RES_LAST_FILE 2>&1

echo "#################################  커널 정보   #################################" >> $RES_LAST_FILE 2>&1
uname -a >> $RES_LAST_FILE 2>&1
echo " " >> $RES_LAST_FILE 2>&1

echo "#################################  커널 상세 정보   #################################" >> $RES_LAST_FILE 2>&1
uname -r >> $RES_LAST_FILE 2>&1

echo "#################################  IP 정보    ##################################" >> $RES_LAST_FILE 2>&1
ifconfig -a >> $RES_LAST_FILE 2>&1
echo " " >> $RES_LAST_FILE 2>&1

echo "#################################  네트워크 현황 ###############################" >> $RES_LAST_FILE 2>&1
netstat -an | egrep -i "LISTEN|ESTABLISHED" >> $RES_LAST_FILE 2>&1
echo " " >> $RES_LAST_FILE 2>&1

echo "################################## 라우팅 정보 #################################" >> $RES_LAST_FILE 2>&1
netstat -rn >> $RES_LAST_FILE 2>&1
echo " " >> $RES_LAST_FILE 2>&1

echo "################################## 프로세스 현황 ###############################" >> $RES_LAST_FILE 2>&1
ps -ef >> $RES_LAST_FILE 2>&1
echo " " >> $RES_LAST_FILE 2>&1

echo "################################## 사용자 환경 #################################" >> $RES_LAST_FILE 2>&1
env >> $RES_LAST_FILE 2>&1
echo " " >> $RES_LAST_FILE 2>&1

# Apahce 활성화 유무 체크
if [ `ps -ef | grep httpd | grep -v grep | wc -l` -ge 1 ]; then
APACHE_CHECK=ON
else >> $RES_LAST_FILE 2>&1
APACHE_CHECK=OFF >> $RES_LAST_FILE 2>&1
fi 

HTTPD_CONF="/etc/httpd/conf/httpd.conf"

### 40번 항목에서 사용하는 변수
path1=$(httpd -V | egrep "(HTTPD\_ROOT)" | cut -f 2 -d '"')     
path2=$(httpd -V | egrep "(SERVER\_CONFIG\_FILE)" | cut -f 2 -d '"') 

##############################START#################################################

echo "[SRV-001] SNMP Community 스트링 설정 미흡"													>> $RES_LAST_FILE 2>&1
echo "[SRV-001] OK"
echo "##### SRV001 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               >> $RES_LAST_FILE 2>&1
echo 1. SNMP 서비스 사용 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep snmpd | grep -v grep || echo "[양호] - SNMP 서비스 미사용")								>> $RES_LAST_FILE 2>&1
echo 2. SNMP 서비스 community 스트링 설정 값 확인															>> $RES_LAST_FILE 2>&1
	(cat /etc/snmp/snmpd.conf | egrep 'public|private' | grep -v '^#' || echo "[양호] - Not using public or private")	>> $RES_LAST_FILE 2>&1
echo "양호 : SNMP 서비스 미사용 혹은 SNMP Community String 초기 값(Public, Private)이 아니고, 아래의 복잡도를 만족할 경우"						>> $RES_LAST_FILE 2>&1
echo "취약 : SNMP 서비스를 사용하고 SNMP Community String 초기 값(Public, Private)이거나, 복잡도를 만족하지 않을 경우"						>> $RES_LAST_FILE 2>&1	
echo "참고 : "															>> $RES_LAST_FILE 2>&1
echo "		(복잡도) 기본값(public, private) 미사용, 영문자, 숫자가 포함 10자리 이상 또는 영문자, 숫자, 특수문자 포함 8자리 이상" 			>> $RES_LAST_FILE 2>&1
echo "		SNMP v3의 경우 별도 인증 기능을 사용하고, 해당 비밀번호가 복잡도를 만족할 경우 양호로 판단"			>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                                 >> $RES_LAST_FILE 2>&1
echo "" 																										>> $RES_LAST_FILE 2>&1


echo "[SRV-004] 불필요한 SMTP 서비스 실행"																>> $RES_LAST_FILE 2>&1
echo "[SRV-004] OK"
echo "##### SRV004 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               >> $RES_LAST_FILE 2>&1
echo "[# 1.1. SMTP service check #]"                                            >> $RES_LAST_FILE 2>&1
	(netstat -ntlp | grep ':25')                                              >> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'sendmail' | grep -v 'grep')                                           >> $RES_LAST_FILE 2>&1
echo      "양호 : 1.1에서 SMTP 서비스 미사용하는 경우"                                         >> $RES_LAST_FILE 2>&1
echo      "취약 :"                                                  >> $RES_LAST_FILE 2>&1
echo           "1. 1.1에서 불필요한 SMTP 서비스 사용하는 경우"                                              >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비"												>> $RES_LAST_FILE 2>&1
echo "[SRV-005] OK"
echo "##### SRV005 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               >> $RES_LAST_FILE 2>&1
echo "[# 1.1. SMTP service check #]"                                            >> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'sendmail' | grep -v 'grep')                                           >> $RES_LAST_FILE 2>&1
echo "[# 1.2. expn, vrfy commands check  #]"                                          >> $RES_LAST_FILE 2>&1
	(cat /etc/mail/sendmail.cf | grep -v '#' | grep -i 'PrivacyOptions')                                    >> $RES_LAST_FILE 2>&1
echo       "양호 : 1.1에서 SMTP 서비스 미사용 중이거나, 1.2 expn, vrfy 접근을 못하도록 설정 했을 경우[noexpn&novrfy 설정 OR goaway 설정]"                     >> $RES_LAST_FILE 2>&1
echo       "취약 :"                                                  >> $RES_LAST_FILE 2>&1
echo           "1. 1.1에서 불필요한 SMTP 서비스 사용 중이거나, 1.2 expn, vrfy 접근을 허용했을 경우"                                   >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-006] SMTP 서비스 로그 수준 설정 미흡"																	>> $RES_LAST_FILE 2>&1
echo "[SRV-006] OK"
echo "##### SRV006 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.1. SMTP service check #]"                                            >> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'sendmail' | grep -v 'grep')                                           >> $RES_LAST_FILE 2>&1
echo "[# 1.2. Sendmail Log Level check #]"                                           >> $RES_LAST_FILE 2>&1
	(cat /etc/mail/sendmail.cf | grep 'LogLevel')                                          >> $RES_LAST_FILE 2>&1

echo       "양호 : 1.1에서 SMTP 서비스 미사용 중이거나, 1.2 LogLevel 설정값이 9 이상일 경우"                                 >> $RES_LAST_FILE 2>&1
echo       "취약 :"                                                  >> $RES_LAST_FILE 2>&1
echo           "1. 1.1에서 불필요한 SMTP 서비스 사용 중이거나, 1.2 LogLevel 설정값이 8 이하일 경우"                                  >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-007] 취약한 버전의 SMTP 서비스 사용"															>> $RES_LAST_FILE 2>&1
echo "[SRV-007] OK"
echo "##### SRV007 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. SMTP 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'sendmail' | grep -v 'grep' || echo "[양호] - SMTP 서비스 미사용")						>> $RES_LAST_FILE 2>&1
echo 2. SMTP 포트 상태 확인																					>> $RES_LAST_FILE 2>&1
	netstat -an | grep ':25' | grep 'LISTEN'																>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
	ss -at | grep 'smtp'																					>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
	ss -ant | grep ':25'																						>> $RES_LAST_FILE 2>&1
echo 3. Sendmail 버전 확인																				>> $RES_LAST_FILE 2>&1
	grep DZ /etc/mail/sendmail.cf																			>> $RES_LAST_FILE 2>&1
echo       "양호 : 1.1에서 SMTP 서비스 미사용 중이거나, 1.2 Sendmail 버전을 정기적으로 점검하고, 패치[2022.01 기준 8.17.1]를 했을 경우"                       >> $RES_LAST_FILE 2>&1
echo       "취약 :"                                                  >> $RES_LAST_FILE 2>&1
echo           "1. 1.1에서 불필요한 SMTP 서비스 사용 중이거나, 1.2 Sendmail ver 8.17.1 미만 버전을 사용하는 경우"                               >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-008] SMTP 서비스의 DoS 방지 기능 미설정"														>> $RES_LAST_FILE 2>&1
echo "[SRV-008] OK"
echo "##### SRV008 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. SMTP 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'sendmail' | grep -v 'grep' || echo "[양호] - SMTP 서비스 미사용")						>> $RES_LAST_FILE 2>&1
echo 2. Sendmail.cf 설정 값 확인																			>> $RES_LAST_FILE 2>&1
 	(cat /etc/mail/sendmail.cf | grep -i 'ConnectionRateThrottle')											>> $RES_LAST_FILE 2>&1
 	(cat /etc/mail/sendmail.cf | grep -i 'MaxDaemonChildren')													>> $RES_LAST_FILE 2>&1
 	(cat /etc/mail/sendmail.cf | grep -i 'MinFreeBlocks')														>> $RES_LAST_FILE 2>&1
 	(cat /etc/mail/sendmail.cf | grep -i 'MaxHeadersLength')													>> $RES_LAST_FILE 2>&1
 	(cat /etc/mail/sendmail.cf | grep -i 'MaxMessageSize')													>> $RES_LAST_FILE 2>&1
echo "양호 : SMTP 서비스 미사용 혹은 서비스 거부 방지를 위한 내용이 모두 설정된 경우"						>> $RES_LAST_FILE 2>&1
echo "취약 : sendmail.cf 설정 값이 주석 처리되거나 값이 설정되지 않은 경우(아래 내용 참고)"					>> $RES_LAST_FILE 2>&1
echo "참고 : sendmail.cf 설정값이 설정되어 있을 시 대상 시스템 성능을 분석하여 적절히 설정되었는지 점검 필요">> $RES_LAST_FILE 2>&1
echo "		ConnectionRateThrottle - 초당 수용 가능한 클라이언트 수 지정, 한계 값에 도달하면 그 후의 연결은 지연됨" 			>> $RES_LAST_FILE 2>&1
echo "		MaxDaemonChildren - 최대 child 프로세스 수, 한계 값에 도달하면 그 후의 연결은 지연됨"			>> $RES_LAST_FILE 2>&1
echo "		MinFreeBlocks - 메일 수용을 위한 최소 여유 블록의 수(기본 값은 100 블록)"						>> $RES_LAST_FILE 2>&1
echo "		MaxHeadersLength - 발신 메시지 헤더의 최대 용량(바이트 단위)"									>> $RES_LAST_FILE 2>&1
echo "		MaxMessageSize - 발신 메시지 1개의 최대 용량(바이트 단위)"										>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-009] SMTP 서비스 스팸 메일 릴레이 제한 미설정"																		>> $RES_LAST_FILE 2>&1
echo "[SRV-009] OK"
echo "##### SRV009 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. SMTP 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'sendmail' | grep -v 'grep' || echo "[양호] - SMTP 서비스 미사용")						>> $RES_LAST_FILE 2>&1
echo 2. 릴레이 제한 설정 여부																				>> $RES_LAST_FILE 2>&1
	(cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied")										>> $RES_LAST_FILE 2>&1														
echo       "양호 : 1.1에서 SMTP 서비스 미사용 중이거나, 1.2 스팸 메일 릴레이 방지 설정을 했을 경우, sendmail 버전 8.9 이상인 경우[디폴트로 스팸 메일 릴레이 방지 설정이 되어 있음]"             >> $RES_LAST_FILE 2>&1
echo       "취약 :"                                                  >> $RES_LAST_FILE 2>&1
echo           "1. 1.1에서 불필요한 SMTP 서비스 사용 중이거나, 1.2 스팸 메일 릴레이 방지 설정을 하지 않았을 경우"                               >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-010] SMTP 서비스의 메일 queue 처리 권한 설정 미흡"															>> $RES_LAST_FILE 2>&1
echo "[SRV-010] OK"
echo "##### SRV010 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. SMTP 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'sendmail' | grep -v 'grep' || echo "[양호] - SMTP 서비스 미사용")						>> $RES_LAST_FILE 2>&1
echo 2. restrictqrun 항목의 유무																			>> $RES_LAST_FILE 2>&1
	(cat /etc/mail/sendmail.cf  | grep PrivacyOptions) 														>> $RES_LAST_FILE 2>&1														
echo "양호 : SMTP 서비스 미사용 혹은 restrictqrun 항목 있음" 												>> $RES_LAST_FILE 2>&1
echo "취약 : SMTP 서비스를 사용하고 restrictqrun 항목 없음"													>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-011] 시스템 관리자 계정의 FTP 사용 제한 미비" 													>> $RES_LAST_FILE 2>&1
echo "[SRV-011] OK"
echo "##### SRV011 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 0. FTP 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep -i 'ftp' | grep -v 'grep'	|| echo "[양호] - FTP 서비스 미사용")						>> $RES_LAST_FILE 2>&1
echo 1.1. PROFTP																							>> $RES_LAST_FILE 2>&1
echo "/etc/ftpusers"                                                                                        >> $RES_LAST_FILE 2>&1
	cat /etc/ftpusers        																				>> $RES_LAST_FILE 2>&1
echo 1.2. NCFTP                                                                                            	>> $RES_LAST_FILE 2>&1
echo "/etc/ftpd/ftpusers"                                                                                   >> $RES_LAST_FILE 2>&1
	cat /etc/ftpd/ftpusers   																				>> $RES_LAST_FILE 2>&1
echo 1.3. VSFTP                                                                                             >> $RES_LAST_FILE 2>&1
echo "/etc/vsftpd/user_list"                                                                                >> $RES_LAST_FILE 2>&1
	cat /etc/vsftpd/user_list 																				>> $RES_LAST_FILE 2>&1
echo "/etc/vsftpd/ftpusers"                                                                                 >> $RES_LAST_FILE 2>&1
	cat /etc/vsftpd/ftpusers  																				>> $RES_LAST_FILE 2>&1
echo "/etc/vsftpd.user_list"                                                                                >> $RES_LAST_FILE 2>&1
	cat /etc/vsftpd.user_list 																				>> $RES_LAST_FILE 2>&1
echo "/etc/vsftpd.ftpusers"                                                                                 >> $RES_LAST_FILE 2>&1
	cat /etc/vsftpd.ftpusers  																				>> $RES_LAST_FILE 2>&1
echo 아래의 항목들은 권고문 및 기반시설 가이드에 명시되어 있지 않은 경로들임                                >> $RES_LAST_FILE 2>&1
echo "/etc/vsftpd.userlist"                                                                                 >> $RES_LAST_FILE 2>&1
	cat /etc/vsftpd.userlist  																				>> $RES_LAST_FILE 2>&1
echo "/etc/vsftpd/vsftpd.userlist"                                                                          >> $RES_LAST_FILE 2>&1
	cat /etc/vsftpd/vsftpd.userlist 																		>> $RES_LAST_FILE 2>&1
echo "/etc/vsftpd/vsftpd.ftpusers"                                                                          >> $RES_LAST_FILE 2>&1
	cat /etc/vsftpd/vsftpd.ftpusers 																		>> $RES_LAST_FILE 2>&1
echo "양호 : FTP 서비스 미실행 혹은 실행 중인 FTP의 ftpusers 파일에 root가 있는 경우"						>> $RES_LAST_FILE 2>&1
echo "취약 : FTP 서비스 실행 중이며 실행 중인 FTP의 ftpusers 파일에 root가 없는 경우"						>> $RES_LAST_FILE 2>&1
echo "참고 : 실행 중인 FTP 서비스에 해당되는 ftpusers 파일을 확인"											>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-012] .netrc 파일 내 중요 정보 노출"															>> $RES_LAST_FILE 2>&1
echo "[SRV-012] OK"
echo "##### SRV012 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo .netrc 파일 권한 확인 \(출력값이 없으면 .netrc 파일이 없는 경우, 즉 양호\)								>> $RES_LAST_FILE 2>&1
 	find / -xdev -name .netrc -ls																			>> $RES_LAST_FILE 2>&1
echo "양호 : netrc 파일이 없는 경우 혹은 관리자에게만 권한이 있는 경우(ex.-rw-------)"						>> $RES_LAST_FILE 2>&1
echo "취약 : netrc 파일이 존재하며 관리자 외 그룹 및 사용자에게 권한이 주어지는 경우"						>> $RES_LAST_FILE 2>&1
echo "참고 : netrc 파일에는 FTP 계정이 평문으로 저장되기 때문에 사용하지 않을 것을 권고함"					>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-013] Anonymous 계정의 FTP 서비스 접속 제한 미비"																		>> $RES_LAST_FILE 2>&1
echo "[SRV-013] OK"
echo "##### SRV013 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. FTP 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep -i 'ftp' | grep -v 'grep' || echo "FTP 서비스 미사용")									>> $RES_LAST_FILE 2>&1
echo 2. FTP 포트 상태 확인																					>> $RES_LAST_FILE 2>&1
	(netstat -an | grep ':21' | grep 'LISTEN' || echo "FTP 서비스 미사용")									>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
	ss -a | grep 'ftp'																					>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
	ss -an | grep ':21'																						>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo 3.. 일반 FTP, ProFTP 사용 시 ftp, anonymous 계정 확인													>> $RES_LAST_FILE 2>&1
	(cat /etc/passwd | grep -i '^ftp' | grep -v 'grep')														>> $RES_LAST_FILE 2>&1
	(cat /etc/passwd | grep -i '^anonymous' | grep -v 'grep')													>> $RES_LAST_FILE 2>&1
echo 4. vsftp 사용 시 anonymous_enable 설정 값 확인															>> $RES_LAST_FILE 2>&1
	(cat /etc/vsftpd/vsftpd.conf | grep -i anonymous_enable)													>> $RES_LAST_FILE 2>&1
	(cat /etc/vsftpd.conf | grep -i anonymous_enable)														>> $RES_LAST_FILE 2>&1
echo "양호 : FTP 서비스 미실행 혹은 실행 중일 경우 3번 결과에서 출력값이 없고 4번 결과에서 anonymous_enable 값이 존재하지 않거나 NO로 설정된 경우"					>> $RES_LAST_FILE 2>&1
echo "취약 : FTP 서비스를 실행하고 있고, 3번 결과에서 출력값이 있는 경우 혹은 4번 결과에서 anonymous_enable 값이 YES인 경우"			>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-014] NFS 접근 통제 미비"																				>> $RES_LAST_FILE 2>&1
echo "[SRV-014] OK"
echo "##### SRV014 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. NFS 서비스 사용 여부 확인																			>> $RES_LAST_FILE 2>&1
	(ps -ef | grep -i 'nfsd' | grep -v 'grep' || echo "[양호] - NFS 서비스 미사용")							>> $RES_LAST_FILE 2>&1																							
echo 2. NFS 접근제어 파일 내용 확인																			>> $RES_LAST_FILE 2>&1
	cat /etc/exports 																						>> $RES_LAST_FILE 2>&1														
echo "양호 : 1번 결과에서 NFS 서비스 미사용인 경우 혹은 2번 경우에서 everyone 공유를 제한한 경우"			>> $RES_LAST_FILE 2>&1
echo "취약 : 1번 결과에서 NFS 서비스 사용중이고 everyone 공유를 제한하지 않은 경우"							>> $RES_LAST_FILE 2>&1
echo "참고	: 기본 설정 예시) /공유디렉토리 접근할 호스트(옵션)"											>> $RES_LAST_FILE 2>&1
echo "		: 취약한 설정 예시) /var/www/img *(ro,all_squash)"												>> $RES_LAST_FILE 2>&1
echo "		: 위 예시에서는 접근할 호스트를 *로 설정했기 때문에 취약"										>> $RES_LAST_FILE 2>&1
echo "		: 양호한 설정 예시) /data 172.27.0.0/16(rw,no_root_squash)"										>> $RES_LAST_FILE 2>&1
echo "		: 위 예시에서는 접근할 호스트를 특정하여 설정했기 때문에 양호"									>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-015] 불필요한 NFS 서비스 실행"																		>> $RES_LAST_FILE 2>&1
echo "[SRV-015] OK"
echo "##### SRV015 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	(ps -ef | grep -i 'nfsd' | grep -v 'grep' || echo "[양호] - NFS 서비스 미사용")							>> $RES_LAST_FILE 2>&1																							
echo "양호 : 결과값이 [양호] - NFS 서비스 미사용일 경우"													>> $RES_LAST_FILE 2>&1
echo "취약 : NFS 사용 중일 경우"																			>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-016] 불필요한 RPC서비스 활성화"																>> $RES_LAST_FILE 2>&1
echo "[SRV-016] OK"
echo "##### SRV016 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1.1 불필요한 RPC 서비스 비활성화 여부 확인																>> $RES_LAST_FILE 2>&1
	(cat /etc/inetd.conf | grep -v '^#' | egrep 'rpc.cmsd|rusersd|rstatd|rpc.statd|kcms_server|rpc.ttdbserverd|Walld|rpc.nids|rpc.ypupdated|cachefsd|sadmind|sprayd|rpc.pcnfsd|rexd|rpc.rquotad' || echo "[양호] - RPC service disabled")	>> $RES_LAST_FILE 2>&1	
echo 1.2 /etc/xinetd.d 디렉터리 내 서비스별 파일 비활성화 여부 확인											>> $RES_LAST_FILE 2>&1
	(ls -al /etc/xinetd.d | egrep 'rpc.cmsd|rusersd|rstatd|rpc.statd|kcms_server|rpc.ttdbserverd|Walld|rpc.nids|rpc.ypupdated|cachefsd|sadmind|sprayd|rpc.pcnfsd|rexd|rpc.rquotad' || echo "[양호] - RPC service disabled")	>> $RES_LAST_FILE 2>&1																							
echo 2. RPC 프로세스 확인																				>> $RES_LAST_FILE 2>&1
	(ps -ef | egrep 'rpc.cmsd|rusersd|rstatd|rpc.statd|kcms_server|rpc.ttdbserverd|Walld|rpc.nids|rpc.ypupdated|cachefsd|sadmind|sprayd|rpc.pcnfsd|rexd|rpc.rquotad' | grep -v 'grep' || echo "[양호] - RPC service disabled")	>> $RES_LAST_FILE 2>&1
echo "취약 : 총 3개의 항목 중, 하나라도 서비스가 활성화 중인 경우는 취약"									>> $RES_LAST_FILE 2>&1
# SRV-016 항목의 경우, (x)inetd가 아닌, systemd을 사용하는 환경에서는 재확인 필요
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-022] 계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡" >> $RES_LAST_FILE 2>&1
echo "[SRV-022] OK"
echo "##### SRV022 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "1. 비밀번호가 미설정된 계정" >> $RES_LAST_FILE 2>&1
	(cat /etc/shadow | grep :! || echo "[양호] 비밀번호 미설정된 계정 없음") >> $RES_LAST_FILE 2>&1
echo "2. shadow에서 미설정된 계정 passwd에서 확인\(ex. bin\/bash같은 경우 쉘 권한 부여됨\)" >> $RES_LAST_FILE 2>&1
	(cat /etc/passwd) >> $RES_LAST_FILE 2>&1	
echo "양호 : 1번 결과에 해당하는 계정이 없는 경우" >> $RES_LAST_FILE 2>&1
echo "      1번 결과에서 해당하는 계정이 있어도 2번 결과에 암호화 되어 있는 경우" >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-025] 취약한 hosts.equiv 또는 .rhosts 설정 존재"														>> $RES_LAST_FILE 2>&1
echo "[SRV-025] OK"
echo "##### SRV025 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[1.1. hosts.equiv : permission check]"																>> $RES_LAST_FILE 2>&1
	(ls -al /etc/hosts.equiv || echo "[양호] 해당 파일 없음")												>> $RES_LAST_FILE 2>&1
echo "[1.2. hosts.equiv : configuration check]"																>> $RES_LAST_FILE 2>&1
	(cat /etc/hosts.equiv | grep "+" || echo "[양호] 해당 파일 없음")										>> $RES_LAST_FILE 2>&1
echo "[2. .rhosts : check configuration]"																	>> $RES_LAST_FILE 2>&1
	HOMEDIRS=`cat /etc/passwd | grep -v '/bin/false' | awk -F: 'length($6) > 0 {print $6}' | sort -u`
	FILES=".rhosts"
	FLAG=1
	for dir in $HOMEDIRS
	do
	for file in $FILES
	do
	FILE=$dir/$file
	if [ -f $FILE ];
	then
	echo "[2.1. $FILE : permission check]"																	>> $RES_LAST_FILE 2>&1
	ls -al $FILE																							>> $RES_LAST_FILE 2>&1
	echo																									>> $RES_LAST_FILE 2>&1
	echo "[2.2. $FILE : configuration check]"																>> $RES_LAST_FILE 2>&1
	(cat $FILE | grep "+" || echo "[양호] 해당 파일 없음")													>> $RES_LAST_FILE 2>&1
	echo																									>> $RES_LAST_FILE 2>&1
	FLAG=`expr $FLAG + 1`
	fi
	done
	done
	if [ $FLAG == 1 ];
	then
	echo "[양호] 해당 파일 없음"																			>> $RES_LAST_FILE 2>&1
	fi
echo "양호 : 해당 파일들이 없거나 있을 경우 3개의 항목에 대하여 아래와 같이 설정"							>> $RES_LAST_FILE 2>&1
echo "1. hosts.equiv 및 .rhosts 파일의 소유자가 root 또는 해당 계정"										>> $RES_LAST_FILE 2>&1
echo "2. hosts.equiv 및 .rhosts 파일의 권한이 644(-rw-r--r--) 이하"											>> $RES_LAST_FILE 2>&1
echo "3. hosts.equiv 및 .rhosts 파일에 '+' 설정이 없음"														>> $RES_LAST_FILE 2>&1
echo "취약 : 1개의 항목이라도 위와 다르게 설정"																>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-026] root 계정 원격 접속 제한 미비"																	>> $RES_LAST_FILE 2>&1
echo "[SRV-026] OK"
echo "##### SRV026 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1.1. SSH service																						>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'ssh' | grep -v 'grep' || echo "[SSH 서비스 사용 안 함]")								>> $RES_LAST_FILE 2>&1
echo 1.2. SSH port																							>> $RES_LAST_FILE 2>&1
	netstat -an | grep ':22' | grep 'LISTEN'																>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
	ss -at | grep 'ssh'																					>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1	
	ss -ant | grep '22'																						>> $RES_LAST_FILE 2>&1
echo 1.3. SSH : PermitRootLogin config																		>> $RES_LAST_FILE 2>&1
	(cat /etc/ssh/sshd_config | grep -i 'PermitRootLogin' | grep -v '#' || echo "[취약] - PermitRootLogin 설정 값 없음") 			>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1																										
echo "[# 2.1. Telnet : service check #]"                    >> $RES_LAST_FILE 2>&1
	(netstat -an | grep ':23' | grep 'LISTEN')                    >> $RES_LAST_FILE 2>&1
	(cat /etc/inetd.d/telnet | grep 'telnet' | grep -v '^#')                >> $RES_LAST_FILE 2>&1
	(cat /etc/xinetd.d/telnet | egrep -i 'disable|telnet')                 >> $RES_LAST_FILE 2>&1
echo "[# 2.2. Telnet : /etc/securetty #]"                    >> $RES_LAST_FILE 2>&1
	(cat /etc/securetty | grep -i 'pts/'| grep -v '^#')                  >> $RES_LAST_FILE 2>&1
echo "[# 2.3. Telnet : pam_securetty.so #]"                    >> $RES_LAST_FILE 2>&1
	(cat /etc/pam.d/login | grep -i 'pam_securetty.so' | grep -v '^#')              >> $RES_LAST_FILE 2>&1
echo       "양호 :"                                             >> $RES_LAST_FILE 2>&1
echo           "1. 원격 터미널 서비스를 사용하지 않는 경우"                >> $RES_LAST_FILE 2>&1
echo           "2. SSH 사용 중인 경우, 1.3에서 PermitRootLogin=no로 설정되어 있을 경우"         >> $RES_LAST_FILE 2>&1
echo           "3. telnet 사용 중인 경우, 아래 2가지를 모두 만족하는 경우"            >> $RES_LAST_FILE 2>&1
echo            "(1) 2.2에서 /etc/securetty 파일에 pts/0 ~ pts/x 관련 설정이 없음(=출력 값 없음)"       >> $RES_LAST_FILE 2>&1
echo            "(2) 2.3에서 /etc/pam.d/login 파일에 pam_securetty.so 관련 설정이 존재함"         >> $RES_LAST_FILE 2>&1
echo       "취약 :"                                                                                            >> $RES_LAST_FILE 2>&1
echo           "1. SSH 사용하고 1.3에서 /etc/ssh/sshd_config 파일에 PermitRootLogin=yes 설정 혹은 출력 값이 없는 경우" >> $RES_LAST_FILE 2>&1
echo           "2. telnet 사용하고 2.2에서 /etc/securetty 파일이 존재하지 않거나 pts/0 ~ pts/x 관련 설정이 존재하는 경우" >> $RES_LAST_FILE 2>&1
echo           "3. telnet 사용하고 2.3에서 /etc/pam.d/login 파일이 존재하지 않거나 pam_securetty.so 관련 설정이 없는 경우">> $RES_LAST_FILE 2>&1
echo "진단 기준"																							>> $RES_LAST_FILE 2>&1
echo "양호 : [1.3], [2.3], [2.4] 의 결과값이 아래와 같을 경우"												>> $RES_LAST_FILE 2>&1
echo "1.3 = PermitRootLogin no 라고 출력된 경우" 															>> $RES_LAST_FILE 2>&1
echo "2.1 = [양호] 라고 출력된 경우"																		>> $RES_LAST_FILE 2>&1
echo "2.2 = auth required pam_securetty.so"																	>> $RES_LAST_FILE 2>&1
echo "또는 auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so"				>> $RES_LAST_FILE 2>&1
echo "또는 auth required /lib/security/pam_securetty.so"   													>> $RES_LAST_FILE 2>&1
echo "취약 : 1개 항목이라도 위와 다르게 설정된 경우"														>> $RES_LAST_FILE 2>&1
echo "참고 :" 																								>> $RES_LAST_FILE 2>&1
echo "- PermitRootLogin : root 계정 로그인 허용 여부 설정"													>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-027] 서비스 접근 IP 및 포트 제한 미비"																		>> $RES_LAST_FILE 2>&1
echo "[SRV-027] OK"
echo "##### SRV027 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1.1. ls -al /etc/hosts.allow																			>> $RES_LAST_FILE 2>&1
	ls -al /etc/hosts.allow 																				>> $RES_LAST_FILE 2>&1
echo 1.2. cat /etc/hosts.allow \(주석 처리된 내용은 출력 안 함\)											>> $RES_LAST_FILE 2>&1
	cat /etc/hosts.allow | grep -v '#'																		>> $RES_LAST_FILE 2>&1
echo 2.1. ls -al /etc/hosts.deny																			>> $RES_LAST_FILE 2>&1
	ls -al /etc/hosts.deny 																					>> $RES_LAST_FILE 2>&1
echo 2.2. /etc/hosts.deny \(주석 처리된 내용은 출력 안 함\)													>> $RES_LAST_FILE 2>&1
	cat /etc/hosts.deny  | grep -v '#'																		>> $RES_LAST_FILE 2>&1
echo 3.1. ls -al /etc/sysconfig/iptables																	>> $RES_LAST_FILE 2>&1
	ls -al /etc/sysconfig/iptables 																			>> $RES_LAST_FILE 2>&1
echo 3.2. /etc/sysconfig/iptables																			>> $RES_LAST_FILE 2>&1
	cat /etc/sysconfig/iptables 																			>> $RES_LAST_FILE 2>&1
echo 4.1. ls -al /etc/firewalld/zones/public.xml															>> $RES_LAST_FILE 2>&1
	ls -al /etc/firewalld/zones/public.xml 																	>> $RES_LAST_FILE 2>&1
echo 4.2. /etc/firewalld/zones/public.xml																	>> $RES_LAST_FILE 2>&1
	cat /etc/firewalld/zones/public.xml 																	>> $RES_LAST_FILE 2>&1
echo "양호 : 1,2번 항목에 대하여 아래와 같이 설정되어 있거나"  												>> $RES_LAST_FILE 2>&1
echo "3번 또는 4번에서 IP 및 포트에 대한 접근제어가 설정된 경우"  											>> $RES_LAST_FILE 2>&1
echo "- /etc/hosts.allow - sshd : IP주소 (접근을 허용할 호스트)"											>> $RES_LAST_FILE 2>&1
echo "- /etc/hosts.deny - ALL:ALL (ALL Deny 설정)"															>> $RES_LAST_FILE 2>&1
echo "취약 : 1,2번 항목에 대하여 하나라도 위와 다르게 설정되어 있으며"										>> $RES_LAST_FILE 2>&1
echo "3번(centos6) 또는 4번(centos7)에서 접근 제어 ip 설정이 안 된 경우"															>> $RES_LAST_FILE 2>&1
echo "참고"																									>> $RES_LAST_FILE 2>&1
echo "1,2번에서 정상적으로 설정이 되어 있지 않더라도,"														>> $RES_LAST_FILE 2>&1
echo "3번 또는 4번에서 접근 제어 설정이 되어 있다면 양호"													>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-028] 원격 터미널 접속 타임아웃 설정 미흡" 			                                                >> $RES_LAST_FILE 2>&1
echo "[SRV-028] OK"
echo "##### SRV028 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. /etc/profile 확인																					>> $RES_LAST_FILE 2>&1
	(cat /etc/profile | grep -i TMOUT || echo "[취약] - 세션 타임아웃 미설정")								>> $RES_LAST_FILE 2>&1
echo 2. /etc/csh.login 확인																					>> $RES_LAST_FILE 2>&1
	(cat /etc/csh.login | grep -i autologout || echo "[취약] - 세션 타임아웃 미설정")						>> $RES_LAST_FILE 2>&1	
echo "양호 : 세션 타임아웃이 설정되어 있고 그 값이 900 이하인 경우    "                          >> $RES_LAST_FILE 2>&1
echo "취약 : 세션 타임아웃이 설정되어 있지 않거나 설정되어 있는데 그 값이 900 이상인 경우"     	>> $RES_LAST_FILE 2>&1
echo "참고 : 하나라도 제대로 설정되어 있으면 양호, 둘 다 취약 조건에 해당될 경우, 취약"						>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-034] 불필요한 서비스 활성화"																			>> $RES_LAST_FILE 2>&1
echo "[SRV-034] OK"
echo "##### SRV034 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	(ps -ef | grep -i 'automount' | grep -v 'grep' || echo "[양호] - automountd 서비스 비활성화") 			>> $RES_LAST_FILE 2>&1	
echo "양호 : automountd 서비스가 비활성화된 경우 = [양호]메시지가 출력된 경우"								>> $RES_LAST_FILE 2>&1
echo "취약 : automountd 서비스가 활성화된 경우"																>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-035] 취약한 서비스 활성화"																		>> $RES_LAST_FILE 2>&1
echo "[SRV-035] OK"
echo "##### SRV035 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1.1. tftp,talk 서비스 데몬 확인																			>> $RES_LAST_FILE 2>&1
	(ps -ef | egrep 'tftp|talk' | grep -v 'grep' || echo "[양호] - tftp, talk, ntalk 서비스 데몬 없음") 	>> $RES_LAST_FILE 2>&1	
echo 1.2. tftp,talk 서비스 활성화 여부 확인																				>> $RES_LAST_FILE 2>&1
	(ls -al /etc/xinetd.d | grep -v '^#' | egrep 'tftp|talk|ntalk' || echo "[양호] - tftp, talk, ntalk 서비스 비활성화")  		>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo 2.1. Finger 서비스 활성화 여부 확인 /etc/inetd.conf																		>> $RES_LAST_FILE 2>&1
	(cat /etc/inetd.conf | grep 'finger' || echo "[양호] - Finger 서비스 비활성화")							>> $RES_LAST_FILE 2>&1
echo 2.2. Finger 서비스 활성화 여부 확인 /etc/xinetd.d 																	>> $RES_LAST_FILE 2>&1
	(cat /etc/xinetd.d/finger | egrep "service|disable" || echo "[양호] - Finger 서비스 비활성화")			>> $RES_LAST_FILE 2>&1
echo 2.3. Finger 서비스 데몬 확인																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep -i 'finger' | grep -v 'grep' || echo "[양호] - Finger 서비스 비활성화")					>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo 3.1. r 계열 서비스 활성화 여부 확인 /etc/inetd.conf																		>> $RES_LAST_FILE 2>&1
	(cat /etc/inetd.conf | grep -v '^#' | egrep 'rsh|rlogin|rexec' || echo "[양호] - no r commands")	>> $RES_LAST_FILE 2>&1
echo 3.2. r 계열 서비스 활성화 여부 확인 /etc/xinetd.conf																	>> $RES_LAST_FILE 2>&1
	(ls -alL /etc/xinetd.d | egrep 'rsh|rlogin|rexec' | egrep -v 'grep|klogin|kshell|kexec' || echo "[양호] - no r commands")	>> $RES_LAST_FILE 2>&1
echo 3.3. r 계열 서비스 데몬 확인																					>> $RES_LAST_FILE 2>&1
	(ps -ef | egrep 'rsh|rlogin|rexec' | grep -v 'grep' || echo "[양호] - rsh,rlogin,rexec no process") 					>> $RES_LAST_FILE 2>&1
echo 3.4. r 계열 서비스 데몬 확인																				>> $RES_LAST_FILE 2>&1
	(systemctl status rsh.socket | grep -i 'active (listening)' || echo "rsh 미사용 상태 입니다.") 		>> $RES_LAST_FILE 2>&1
	(systemctl status rlogin.socket | grep -i 'active (listening)' || echo "rlogin 미사용 상태 입니다.") 	>> $RES_LAST_FILE 2>&1
	(systemctl status rexec.socket | grep -i 'active (listening)' || echo "rexec 미사용 상태 입니다.") 	>> $RES_LAST_FILE 2>&1
#echo 이하 항목들은 기반시설 상세가이드에 포함되지 않는 점검 항목들 \(권고문에만 명시되어 있는 점검 사항\)	
echo 3.5. /etc/hosts.equiv																					>> $RES_LAST_FILE 2>&1
	(cat /etc/hosts.equiv || echo "[양호] - 해당 파일 없음")													>> $RES_LAST_FILE 2>&1
echo 3.6. /.rhosts																							>> $RES_LAST_FILE 2>&1
	HOMEDIRS=`cat /etc/passwd | grep -v '/bin/false' | awk -F: 'length($6) > 0 {print $6}' | sort -u`		
	FILES=".rhosts"		
	for file in $FILES		
		do
		FILE=$FILES
		if [ -f $FILE ]; then
			ls -alL $FILE																					>> $RES_LAST_FILE 2>&1
		fi
	done
	for dir in $HOMEDIRS
		do
		for file in $FILES
			do
			FILE=$dir/$file																					>> $RES_LAST_FILE 2>&1
			if [ -f $FILE ]; then																				
				echo "- $FILE"																				>> $RES_LAST_FILE 2>&1
				cat $FILE
			fi
		done
	done
echo																										>> $RES_LAST_FILE 2>&1
echo 4.1. DoS 공격에 취약한 서비스 활성화 여부 확인 /etc/inetd.conf																						>> $RES_LAST_FILE 2>&1
	(cat /etc/inetd.conf | grep -v '^#' | egrep 'echo|discard|daytime|chargen' || echo "[양호] - echo,discard,daytime,chargen 서비스 비활성화") >> $RES_LAST_FILE 2>&1
echo 4.2. DoS 공격에 취약한 서비스 활성화 여부 확인 /etc/xinetd.d																						>> $RES_LAST_FILE 2>&1
	(ls -al /etc/xinetd.d | egrep 'echo|discard|daytime|chargen' || echo "[양호] - echo,discard,daytime,chargen 서비스 비활성화")	>> $RES_LAST_FILE 2>&1
echo - echo service																							>> $RES_LAST_FILE 2>&1
	(cat /etc/xinetd.d/echo* | grep -i 'disable')									>> $RES_LAST_FILE 2>&1
echo - discard service																						>> $RES_LAST_FILE 2>&1
	(cat /etc/xinetd.d/discard* | grep -i 'disable')								>> $RES_LAST_FILE 2>&1
echo - daytime service																						>> $RES_LAST_FILE 2>&1
	(cat /etc/xinetd.d/daytime* | grep -i 'disable')								>> $RES_LAST_FILE 2>&1
echo - chargen service																						>> $RES_LAST_FILE 2>&1
	(cat /etc/xinetd.d/chargen* | grep -i 'disable')								>> $RES_LAST_FILE 2>&1
echo 4.3. DoS 공격에 취약한 서비스 데몬 확인																						>> $RES_LAST_FILE 2>&1
	(ps -ef | egrep 'echo|discard|daytime|chargen' | grep -v grep || echo "[양호] - echo,discard,daytime,chargen no process")		>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo 5.1. NIS 서비스 데몬 확인																						>> $RES_LAST_FILE 2>&1
	(ps -ef | egrep 'ypserv|ypbind|rpc.yppasswdd|ypxfrd|rpc.ypupdate' | grep -v 'grep' || echo "[양호] - NIS 서비스 비활성화")	>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo "양호 : 아래의 항목 중 해당 사항이 없는 경우"	>> $RES_LAST_FILE 2>&1
echo "	1. tftp, talk, ntalk 서비스가 불필요하게 활성화된 경우"														>> $RES_LAST_FILE 2>&1
echo "	2. finger 서비스 활성화"														>> $RES_LAST_FILE 2>&1
echo "	3. rexec, rlogin, rsh, 서비스 활성화"														>> $RES_LAST_FILE 2>&1
echo "	4. DoS 공격에 취약한 echo, discard, daytime, chargen 서비스 활성화"														>> $RES_LAST_FILE 2>&1
echo "	5. NIS, NIS+ 서비스 활성화"														>> $RES_LAST_FILE 2>&1
echo "취약 : 위의 항목 중 해당하는 조건이 있는 경우"														>> $RES_LAST_FILE 2>&1
echo "참고 : 만일 NIS 서비스를 사용해야 한다면, 보안에 대해 강화된 제품인 NIS+를 쓰도록 권고"			  	>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1




echo "[SRV-037] 취약한 FTP 서비스 실행"														>> $RES_LAST_FILE 2>&1
echo "[SRV-037] OK"
echo "##### SRV037 #####" >> $RES_LAST_FILE 2>&1
echo "##### START #####" >> $RES_LAST_FILE 2>&1
echo "[# 1. ftp : service process check #]"                   >> $RES_LAST_FILE 2>&1
 (ps -ef | grep 'ftp' | grep -v 'grep' || echo "ftp 미사용")     >> $RES_LAST_FILE 2>&1
echo ""                                                >> $RES_LAST_FILE 2>&1
echo       "양호 : "                                            >> $RES_LAST_FILE 2>&1
echo       "    1. FTP 서비스를 사용하지 않거나   "             >> $RES_LAST_FILE 2>&1
echo       "    1. 필요에 의해 사용시 암호화가 적용된 FTP(예. vsFTP) 서비스를 사용 할 경우   "             >> $RES_LAST_FILE 2>&1
echo       "취약 : "                                                                                           >> $RES_LAST_FILE 2>&1
echo       "    1. FTP 서비스를 사용 중인 경우 " >> $RES_LAST_FILE 2>&1
echo "##### END #####"  >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-040] 웹 서비스 디렉터리 리스팅 방지 설정 미흡"																>> $RES_LAST_FILE 2>&1
echo "[SRV-040] OK"
echo "##### SRV040 #####" >> $RES_LAST_FILE 2>&1
echo "##### START #####" >> $RES_LAST_FILE 2>&1
echo ""                                                >> $RES_LAST_FILE 2>&1
echo "[# 1.0. Apache : service process check_centos #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.0. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo "[# 2.1. httpd conf check (CentOS, Redhat) #]"                   >> $RES_LAST_FILE 2>&1
	(cat /etc/httpd/conf/httpd.conf | grep -i "options"| grep -i "indexes")     >> $RES_LAST_FILE 2>&1
	(cat /etc/httpd/httpd.conf | grep -i "options" | grep -i "indexes")     >> $RES_LAST_FILE 2>&1
echo "[# 2.2. httpd conf check (Ubuntu, Debian) #]"                   >> $RES_LAST_FILE 2>&1
	(cat /etc/apache2/apache2.conf | grep -i "options" | grep -i "indexes")     >> $RES_LAST_FILE 2>&1
	(cat /etc/apache2/httpd.conf | grep -i "options" | grep -i "indexes")     >> $RES_LAST_FILE 2>&1
echo "[# 3.0. httpd conf check (AIX) #]"                   >> $RES_LAST_FILE 2>&1
	(cat /opt/freeware/etc/httpd/conf/httpd.conf | grep -i "options"| grep -i "indexes")     >> $RES_LAST_FILE 2>&1
echo "[# 4.0. httpd conf check (HP-UX) #]"                   >> $RES_LAST_FILE 2>&1
	(cat /etc/httpd/conf/httpd.conf | grep -i "options"| grep -i "indexes")     >> $RES_LAST_FILE 2>&1
	(cat /opt/hpwsXX/apache/conf/httpd.conf | grep -i "options"| grep -i "indexes")     >> $RES_LAST_FILE 2>&1
	(cat /opt/hpws/apache/conf/httpd.conf | grep -i "options"| grep -i "indexes")     >> $RES_LAST_FILE 2>&1
echo "[# 5.0. httpd conf check (Solaris 9) #]"                   >> $RES_LAST_FILE 2>&1
	(cat /etc/apache/httpd.conf | grep -i "options"| grep -i "indexes")     >> $RES_LAST_FILE 2>&1
echo "[# 6.0. httpd conf check (Solaris 10) #]"                   >> $RES_LAST_FILE 2>&1
	(cat /etc/apache/httpd.conf | grep -i "options"| grep -i "indexes")     >> $RES_LAST_FILE 2>&1
echo "[# 7.0. New config path check #]"                   >> $RES_LAST_FILE 2>&1

echo $path1"/"$path2  "is a new config path"  >> $RES_LAST_FILE 2>&1
	(cat $path1"/"$path2   | grep -i "options" | grep -i "indexes"  )    >> $RES_LAST_FILE 2>&1
echo       "    해당되는 OS 확인 후"                                            >> $RES_LAST_FILE 2>&1
echo       "    2.1~6.0에서 값을 출력하지 못할 경우 7.0 출력 값 확인하세요"                                            >> $RES_LAST_FILE 2>&1
echo       "양호 : "                                            >> $RES_LAST_FILE 2>&1
echo       "    1. Apache 서비스를 사용하지 않는 경우   "             >> $RES_LAST_FILE 2>&1
echo       "    2.1~6.0 Apache 서비스 사용 시 Options에 indexes가 없을 경우"             >> $RES_LAST_FILE 2>&1
echo       "    2.1~6.0 Apache 서비스 사용 시 Options에 -indexes(제거)로 설정되어 있거나 앞에 주석(#)처리있는 경우"             >> $RES_LAST_FILE 2>&1
echo       "    7. Apache 서비스 사용 시 Options에 -indexes(제거)로 설정되어 있거나 앞에 주석(#)처리있는 경우"             >> $RES_LAST_FILE 2>&1
echo       "취약 : "                                                                                           >> $RES_LAST_FILE 2>&1
echo       "    1. Apache 서비스를 사용하며   "             >> $RES_LAST_FILE 2>&1
echo       "    2.1~6.0 Options에 앞에 주석(#)처리 되어있지 않고 indexes가 있을 경우"             >> $RES_LAST_FILE 2>&1
echo       "    7. Options에 앞에 주석(#)처리 되어있지 않고 indexes가 있을 경우"             >> $RES_LAST_FILE 2>&1
echo "##### END #####"  >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-042] 웹 서비스 상위 디렉터리 접근 제한 설정 미흡" 															>> $RES_LAST_FILE 2>&1
echo "[SRV-042] OK"
echo "##### SRV042 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_centos #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo "[# 1.2 AllowOverride check # ]"         >> $RES_LAST_FILE 2>&1
	(cat $path1"/"$path2   | grep -i "allowoverride"  )    >> $RES_LAST_FILE 2>&1
echo "양호 : 1.1에서 아파치 서비스가 미사용 중이거나 Apache 2.048보다 높은 버전인 경우, 1.2에서 상위 디렉터리 이동 제한 설정 값(AllowOverride)이 AuthConfig 혹은 None인 경우"  >> $RES_LAST_FILE 2>&1
echo "취약 : 1.2에서 상위 디렉터리 이동 설정 값(AllowOverride)이 AuthConfig 혹은 None이 아닐 경우"              >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-043] 웹 서비스 경로 내 불필요한 파일 존재" >> $RES_LAST_FILE 2>&1
echo "[SRV-043] OK"
echo "##### SRV043 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_centos #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo "[# 1.2 sample directory]"               >> $RES_LAST_FILE 2>&1
	(ls -al $path1 | egrep -i 'manual|docs|samples' || echo "불필요한 파일 존재하지 않음") >> $RES_LAST_FILE 2>&1
	(ls -al $path2 | egrep -i 'manual|docs|samples' || echo "불필요한 파일 존재하지 않음") >> $RES_LAST_FILE 2>&1
echo "양호 : 1.1에서 아파치 서비스가 미사용 중이거나, 1.2에서 불필요한 파일이 발견되지 않은 경우"  >> $RES_LAST_FILE 2>&1
echo "취약 : 1.2에서 불필요한 파일이 발견된 경우"               >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-044] 웹 서비스 파일 업로드 및 다운로드 용량 제한 미설정" 														>> $RES_LAST_FILE 2>&1
echo "[SRV-044] OK"
echo "##### SRV044 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_centos #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
	echo "[# 1.2 limitrequestbody check #]"       >> $RES_LAST_FILE 2>&1
	(cat $path1"/"$path2   | grep -i "limitrequestbody"  )    >> $RES_LAST_FILE 2>&1
echo "양호 : 1.1에서 아파치 서비스가 미사용 중이거나, 1.2에서 파일 사이즈 제한 값(limitrequestbody)이 있는 경우"  >> $RES_LAST_FILE 2>&1
echo "취약 : 1.2에서 파일 사이즈 제한 값(limitrequestbody)이 없거나, 설정이 되지 않은 경우"               >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-045] 웹 서비스 프로세스 권한 제한 미비" 																>> $RES_LAST_FILE 2>&1
echo "[SRV-045] OK"
echo "##### SRV045 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.0. Apache : service process check #]"                >> $RES_LAST_FILE 2>&1	
	if [ $APACHE_CHECK == "OFF" ]; then
		echo "[양호] Apache 서비스 미사용"																	>> $RES_LAST_FILE 2>&1
	else
		ps -ef | grep -i 'httpd' | grep -v 'grep' 											>> $RES_LAST_FILE 2>&1
	fi
echo "[# 1.1. Apache : service process check_centos #]"                >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo "양호 : 1.1에서 아파치 서비스가 미사용 중이거나, 1.2에서 아파치 서비스가 root 이 외의 권한으로 구동되는 경우"  >> $RES_LAST_FILE 2>&1
echo "취약 : 1.2에서 아파치 서비스가 root 권한으로 구동되는 경우"           >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-046] 웹 서비스 경로 관리 미흡" 																>> $RES_LAST_FILE 2>&1
echo "[SRV-046] OK"
echo "##### SRV046 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_centos #]"                >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo "[# 1.2 documentroot check #]"       >> $RES_LAST_FILE 2>&1
	(cat $path1"/"$path2   | grep -i "documentroot"  )    >> $RES_LAST_FILE 2>&1
echo "양호 : 1.1에서 아파치 서비스가 미사용 중이거나, 1.2에서 웹 루트 디렉터리(documentroot)가 /usr/local/apache/htdocs로 설정되지 않은 경우"  >> $RES_LAST_FILE 2>&1
echo "취약 : 1.2에서 웹 루트 디렉터리가(documentroot)가 /usr/local/apache/htdocs로 설정된 경우"     >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-047] 웹 서비스 경로 내 불필요한 링크 파일 존재" 																	>> $RES_LAST_FILE 2>&1
echo "[SRV-047] OK"
echo "##### SRV047 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_centos #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.1. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo "[# 1.2 documentroot check #]"       >> $RES_LAST_FILE 2>&1
	(cat $path1"/"$path2   | grep -i "followsymlinks"  )    >> $RES_LAST_FILE 2>&1
echo "양호 : 1.1에서 아파치 서비스가 미사용 중이거나, 1.2에서 follwsymlinks 값이 없는 경우"  >> $RES_LAST_FILE 2>&1
echo "취약 : 1.2에서 follwsymlinks 값이 있는 경우"     >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-048] 불필요한 웹 서비스 실행"														>> $RES_LAST_FILE 2>&1
echo "[SRV-048] OK"
echo "##### SRV048 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.0. WebtoB : service process check #]"                   >> $RES_LAST_FILE 2>&1
 (ps -ef | grep 'wsm' | grep -v 'grep' || echo "webtob 미사용")     >> $RES_LAST_FILE 2>&1
echo       "* 양호 : "                                            >> $RES_LAST_FILE 2>&1
echo       "    1. WebtoB 서비스를 사용하지 않는 경우   "             >> $RES_LAST_FILE 2>&1
echo       "* 취약 : "                                                                                           >> $RES_LAST_FILE 2>&1
echo       "    1. WebtoB 서비스를 사용 중인 경우 " >> $RES_LAST_FILE 2>&1
echo       "사용 중이면 필요한 서비스인지 담당자와 인터뷰 필요" >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-060] 웹 서비스 기본 계정(아이디 또는 비밀번호) 미변경"                                                   >> $RES_LAST_FILE 2>&1
echo "[SRV-060] OK"
echo "##### SRV060 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	if [ $APACHE_CHECK == "OFF" ]; then
		echo "[양호] Apache 서비스 미사용"                                                      			>> $RES_LAST_FILE 2>&1
	else
		echo "Apache Service 활성화되어 있음"                                                               >> $RES_LAST_FILE 2>&1
		echo                                                                                                >> $RES_LAST_FILE 2>&1
		TOMCAT_USER=`find / -name tomcat-users.xml`                                                         >> $RES_LAST_FILE 2>&1
		if [ "$TOMCAT_USER" != "" ]; then
			cat $TOMCAT_USER 																				>> $RES_LAST_FILE 2>&1
		else
			echo "FILE NOT EXIST" 																			>> $RES_LAST_FILE 2>&1
		fi                                                                                   
	fi
echo "양호 : Apache Service가 활성화되어 있지 않은 경우"													>> $RES_LAST_FILE 2>&1
echo "	혹은 <tomcat-users> 아래의 계정 등록 부분이 주석처리 되어있는 경우"									>> $RES_LAST_FILE 2>&1
echo "	혹은 주석처리가 되어있지 않고 '<user username=' 뒤에 기본 계정인 'tomcat', 'both','role1' 이 전부 존재하지 않는 경우"	>> $RES_LAST_FILE 2>&1
echo "취약 : <tomcat-users> 아래의 계정 등록 부분이 주석처리 되어있지 않고" 								>> $RES_LAST_FILE 2>&1
echo "	<user username=' 뒤에 기본 계정인 'tomcat', 'both', 'role1' 중 1개 이상이 존재할 경우" 				>> $RES_LAST_FILE 2>&1
echo "참고 : XML 주석처리는 <!-- , --> 이고 <tomcat-users> 아래의 계정 등록 부분은 다음과 같음 " 			>> $RES_LAST_FILE 2>&1
echo "예시"                                                                                                 >> $RES_LAST_FILE 2>&1
echo  "<user username=\"tomcat\" password=\"<must-be-changed>\" roles=\"tomcat\"/>"							>> $RES_LAST_FILE 2>&1
echo  "<user username=\"both\" password=\"<must-be-changed>\" roles=\"tomcat,role1\"/>"						>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-062] DNS 서비스 정보 노출"																	>> $RES_LAST_FILE 2>&1
echo "[SRV-062] OK"
echo "##### SRV062 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. DNS 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'named' | grep -v 'grep' || echo "[양호] - DNS 서비스 미사용")							>> $RES_LAST_FILE 2>&1
echo 2. BIND 버전 조회 시 노출 메시지 설정 여부 확인														>> $RES_LAST_FILE 2>&1
	(cat /etc/named.conf | grep 'version')																	>> $RES_LAST_FILE 2>&1
echo "양호 : 결과값에 [version '임의의 문자열']이 포함된 경우	혹은 DNS 서비스를 사용하지 않을 경우"		>> $RES_LAST_FILE 2>&1
echo "취약 : 결과값에 [version '임의의 문자열']이 출력되지 않는 경우		= version 메세지 미설정"		>> $RES_LAST_FILE 2>&1
echo "참고 : version '임의의 문자열'이 설정된 경우, BIND 버전 조회 시 버전 대신 "임의의 문자열"이 출력됨"	>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-063] DNS Recursive Query 설정 미흡"																>> $RES_LAST_FILE 2>&1
echo "[SRV-063] OK"
echo "##### SRV063 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. DNS 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'named' | grep -v 'grep' || echo "[양호] - DNS 서비스 미사용")							>> $RES_LAST_FILE 2>&1
echo 2. recursion 설정 값 확인																				>> $RES_LAST_FILE 2>&1
	(cat /etc/named.conf | grep 'recursion')																	>> $RES_LAST_FILE 2>&1
echo "양호 : recursion 설정 값이 no인 경우 혹은 DNS 서비스를 사용하지 않을 경우"							>> $RES_LAST_FILE 2>&1
echo "취약 : recursion 설정 값이 yes인 경우 = recursion이 허용됨"											>> $RES_LAST_FILE 2>&1
echo "참고 : DNS Recursive Query의 사용이 필요할 경우 최신 버전의 DNS를 사용하는 것을 권장"					>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-064] DNS 보안 버전 패치"																			>> $RES_LAST_FILE 2>&1
echo "[SRV-064] OK"
echo "##### SRV064 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. DNS 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'named' | grep -v 'grep' || echo "[양호] - DNS 서비스 미사용")							>> $RES_LAST_FILE 2>&1
echo 2. DNS 보안 버전 확인																					>> $RES_LAST_FILE 2>&1
	named -v																								>> $RES_LAST_FILE 2>&1
echo 3. dig @localhost +short porttest.dns-oarc.net TXT 명령어 실행 결과																					>> $RES_LAST_FILE 2>&1
	dig @localhost +short porttest.dns-oarc.net TXT																								>> $RES_LAST_FILE 2>&1
echo "양호 : "										>> $RES_LAST_FILE 2>&1
echo "  1. 알려진 취약점이 없는 DNS 버전을 사용하는 경우"										>> $RES_LAST_FILE 2>&1
echo "  2. dig @localhost +short porttest.dns-oarc.net TXT 명령 결과가 다음과 같은 경우"										>> $RES_LAST_FILE 2>&1
echo "     z.y.x.w.v.u.t.s.r.q.p.o.n.m.l.k.j.i.h.g.f.e.d.c.b.a.pt.dns-oarc.net."										>> $RES_LAST_FILE 2>&1
echo "     IP-of-GOOD is GOOD: 26 queries in 2.0 seconds from 26 ports with std dev 17685.51"										>> $RES_LAST_FILE 2>&1
echo "취약 :"  									>> $RES_LAST_FILE 2>&1
echo "  1. 패치관리에 대한 금융회사의 내부규정을 준수하지 않을 경우, 단 금융회사 내부규정에 명시되지 않은 경우 통상 1개월 이내 최신 버전으로 패치 적용할 것을 권고"										>> $RES_LAST_FILE 2>&1
echo "  2. dig @localhost +short porttest.dns-oarc.net TXT 명령 결과가 다음과 같은 경우"										>> $RES_LAST_FILE 2>&1
echo "     porttest.y.x.w.v.u.t.s.r.q.p.o.n.m.l.k.j.i.h.g.f.e.d.c.b.a.pt.dns-oarc.net."										>> $RES_LAST_FILE 2>&1
echo "     해당서버IP is POOR: 26 queries in 3.6 seconds from 1 ports with std dev 0"										>> $RES_LAST_FILE 2>&1
echo "참고 : Bind 최신버전 다운로드 사이트 : http://www.isc.org/downloads/"							>> $RES_LAST_FILE 2>&1
echo "참고 : 각 버전에 대한 취약점 정보 사이트"							>> $RES_LAST_FILE 2>&1
echo "  1. BIND 8 Vulnerability matrix : https://kb.isc.org/docs/aa-00959"										>> $RES_LAST_FILE 2>&1
echo "  2. BIND 9 Vulnerability matrix : https://kb.isc.org/docs/aa-00913"										>> $RES_LAST_FILE 2>&1																						
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-066] DNS Zone Transfer 설정 미흡"																		>> $RES_LAST_FILE 2>&1
echo "[SRV-066] OK"
echo "##### SRV066 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. DNS 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'named' | grep -v 'grep' || echo "[양호] - DNS 서비스 미사용")							>> $RES_LAST_FILE 2>&1
echo 2.1. allow-transfer in /etc/named.conf - BIND8	이상		 											>> $RES_LAST_FILE 2>&1
	(cat /etc/named.conf | grep -i 'allow-transfer' || echo "[취약] - no configuration")					>> $RES_LAST_FILE 2>&1
echo 2.2. xfrnets in /etc/named.boot - BIND4.9				 												>> $RES_LAST_FILE 2>&1
	(cat /etc/named.boot | grep -i 'xfrnets' || echo "[취약] - no configuration")							>> $RES_LAST_FILE 2>&1
echo "양호 : DNS 서비스 미사용 혹은 allow-transfer 또는 xfrnets 를 통하여 설정된 특정 IP가 있음"			>> $RES_LAST_FILE 2>&1
echo "취약 : DNS 서비스를 사용하며 allow-transfer 또는 xfrnets 를 통하여 설정된 특정 IP가 없음"				>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-069] 비밀번호 관리정책 설정 미비"				                                                >> $RES_LAST_FILE 2>&1
echo "[SRV-069] OK"
echo "##### SRV069 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "1. 패스워드 최소 길이 설정 보기(/etc/login.defs)"                                 >> $RES_LAST_FILE 2>&1
	(cat /etc/login.defs | grep -i "PASS_MIN_LEN") >> $RES_LAST_FILE 2>&1
echo "2.1 패스워드 복잡성 설정 보기_영문,숫자,특수문자 조합으로 설정(/etc/login.defs)"                                 >> $RES_LAST_FILE 2>&1
	(cat /etc/login.defs | egrep -i "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE") >> $RES_LAST_FILE 2>&1
echo "2.2 /etc/pam.d/system-auth 파일 확인"                              >> $RES_LAST_FILE 2>&1
 if [ -f /etc/pam.d/system-auth ]
  then
   echo "[/etc/pam.d/system-auth 파일 설정 현황]" >> $RES_LAST_FILE 2>&1
   cat /etc/pam.d/system-auth | grep "password" >> $RES_LAST_FILE 2>&1
  else
   echo "/etc/pam.d/system-auth 파일이 없습니다. " >> $RES_LAST_FILE 2>&1
 fi
echo "2.3 /etc/security/pwquality.conf(Centos7일 경우) 파일 확인"                              >> $RES_LAST_FILE 2>&1
	(cat /etc/security/pwquality.conf | egrep -i "minlen|lcredit|ucredit|dcredit|ocredit")	>> $RES_LAST_FILE 2>&1
echo "양호(2.1) : /etc/login.defs 파일 내에 다음 항목들이 설정되어 있을 경우, PASS_MIN_LEN 값이 8 이상인 경우"   >> $RES_LAST_FILE 2>&1
echo     "1. PASS\_MAX\_DAYS"                                       >> $RES_LAST_FILE 2>&1
echo     "2. PASS\_MIN\_DAYS"                                       >> $RES_LAST_FILE 2>&1
echo     "3. PASS\_MIN\_LEN"                                        >> $RES_LAST_FILE 2>&1
echo     "4. PASS\_WARN\_AGE"                                       >> $RES_LAST_FILE 2>&1
echo "양호(2.2) : 영문, 숫자, 특수문자 중 2가지 혼합된 경우 10자리, 3가지 혼합된 경우 8자리 이상의 패스워드가 설정된 경우 양호.(PAM 모듈 사용 시, 모듈별로 판단 기준이 상이하므로 추가 확인 필요)" >> $RES_LAST_FILE 2>&1
echo     "1. lcredit : 최소 문자 수" >> $RES_LAST_FILE 2>&1
echo     "2. ucredit : 최대 문자 수" >> $RES_LAST_FILE 2>&1
echo     "3. dcredit : 최소 숫자 수" >> $RES_LAST_FILE 2>&1
echo     "4. ocredit : 최소 특수문자 수" >> $RES_LAST_FILE 2>&1
echo     "5. -1 값이 들어가야 해당 항목이 반드시 패스워드 설정 정책에 포함" >> $RES_LAST_FILE 2>&1
echo "취약 : /etc/login.defs 파일 내에 위의 항목들이 설정되어 있지 않을 경우, PASS_MIN_LEN 값이 8 이상이 아닌 경우"   >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-070] 취약한 패스워드 저장 방식 사용"																		>> $RES_LAST_FILE 2>&1
echo "[SRV-070] OK"
echo "##### SRV070 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. shadow 파일 확인																					>> $RES_LAST_FILE 2>&1
	cat /etc/shadow																							>> $RES_LAST_FILE 2>&1
echo 2. passwd 파일 확인																					>> $RES_LAST_FILE 2>&1
	cat /etc/passwd 																						>> $RES_LAST_FILE 2>&1
echo "양호 : 아래 항목 중 하나에 해당하는 경우 양호	"														>> $RES_LAST_FILE 2>&1
echo "1. /etc/shadow 파일이 존재하는 경우"  																>> $RES_LAST_FILE 2>&1
echo "2. /etc/shadow 파일이 존재하지 않지만 /etc/passwd 내 패스워드를 암호화 저장" 							>> $RES_LAST_FILE 2>&1
echo "취약 : /etc/shadow 파일이 존재하지 않고 /etc/passwd 내 패스워드를 평문으로 저장"						>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-073] 관리자 그룹에 불필요한 사용자 존재"			                                              	>> $RES_LAST_FILE 2>&1
echo "[SRV-073] OK"
echo "##### SRV073 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	cat /etc/group | grep root                                                                              >> $RES_LAST_FILE 2>&1
echo "양호 : 'root:x:0:' 뒤에 root 외의 다른 사용자가 없는 경우"                                            >> $RES_LAST_FILE 2>&1
echo "취약 : 'root:x:0:' 뒤에 root 외의 다른 사용자가 존재하는 경우"                                        >> $RES_LAST_FILE 2>&1
echo "참고 : root 외의 다른 사용자가 존재할 경우 인터뷰를 통해 항목 평가"									>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-074] 불필요하거나 관리되지 않는 계정 존재"															>> $RES_LAST_FILE 2>&1
echo "[SRV-074] OK"
echo "##### SRV074 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "1. 계정별 비밀번호 변경일자 확인"         >> $RES_LAST_FILE 2>&1
 Username=`cat /etc/passwd | grep sh | grep bash | awk -F: 'length($1) > 0 {print $1}'`
 for user in $Username   
  do
   Lastpasswd=`passwd -S $user`
   echo $Lastpasswd >> lastpasswd1.txt
  done  
 cat lastpasswd1.txt >> $RES_LAST_FILE 2>&1
rm -rf lastpasswd1.txt
echo                          >> $RES_LAST_FILE 2>&1
echo "양호 : 최근 90일 이내에 로그인 한 기록이 있고, 최종 패스워드 변경일이 90일 이전인 경우"   >> $RES_LAST_FILE 2>&1
echo    "1. 최대 사용 기간이 90 이하"            >> $RES_LAST_FILE 2>&1
echo    "2. 최소 사용 기간은 1 이상"            >> $RES_LAST_FILE 2>&1
echo "취약 : 최대 사용 기간이 90 초과, 최소 사용 기간은 0 이거나 미설정"      >> $RES_LAST_FILE 2>&1
echo "참고 : 최대, 최소 사용 기간은 /etc/login.defs 에서 기본 설정"      >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-075] 유추 가능한 계정 비밀번호 존재"																>> $RES_LAST_FILE 2>&1
echo "[SRV-075] OK"
echo "##### SRV075 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "1. shadow 파일 확인 _ 비밀번호가 평문으로 단순하게 설정되어 있지 않고, 암호화되어 있는지 확인하기 위함"																			>> $RES_LAST_FILE 2>&1
	(cat /etc/shadow)																			>> $RES_LAST_FILE 2>&1
echo "2. [/etc/passwd]_Brute Forcing 공격에 취약한 비밀번호가 설정된 계정 확인 _ 비밀번호가 암호화되어 있다면, 유추가능한지 확인하기 위함"																			>> $RES_LAST_FILE 2>&1
	(cat /etc/passwd)																			>> $RES_LAST_FILE 2>&1
echo "양호 : 패스워드 필드에 값이 들어있는 경우"     >> $RES_LAST_FILE 2>&1
echo "취약 : 패스워드 필드가 비어있는 경우('x', '!', '*' 제외)" >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-081] Crontab 설정파일 권한 설정 미흡"                                                			>> $RES_LAST_FILE 2>&1
echo "[SRV-081] OK"
echo "##### SRV081 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "1. cron"                                                                              							>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/crontab                                                                						>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/cron.daily/*                                                             					>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/cron.hourly/*                                                             					>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/cron.monthly/*                                                             					>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/cron.weekly/*                                                             					>> $RES_LAST_FILE 2>&1
	ls -alLd /var/spool/cron/*                                                             					>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo "2. /etc/at.deny"																						>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/at.deny 																					>> $RES_LAST_FILE 2>&1
echo "2. /etc/at.allow"																						>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/at.allow 																					>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo "3. cron.allow"																						>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/cron.allow 																					>> $RES_LAST_FILE 2>&1
echo "3. cron.deny"																						>> $RES_LAST_FILE 2>&1
	ls -alLd /etc/cron.deny																					>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo "양호 : /var/spool/cron/crontab/* 에 others 읽기 쓰기 권한이 없음, at 접근제어 파일의 소유자가 root 이고 권한이 640 이하, cron.allow 와 cron.deny 파일의 소유자가 root이고 권한이 640 이하"                           		>> $RES_LAST_FILE 2>&1
echo "취약 : cron 서비스 관련 설정 파일들이 양호 기준보다 많은 권한이 부여된 경우"                              		>> $RES_LAST_FILE 2>&1
echo "예시) -rwxrw-rw- 이 경우, 타사용자에게 쓰기권한이 부여됨         "                           			>> $RES_LAST_FILE 2>&1
echo "예시) -rwxrw-r-- 이 경우, 타사용자에게 쓰기권한이 부여되지 않음  "                            		>> $RES_LAST_FILE 2>&1
echo "참고 : 쓰기(w) 권한이 존재하더라도 실행(x) 권한이 부여된 경우에만 쓰기가 가능함"							>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-082] 시스템 주요 디렉터리 권한 설정 미흡"																>> $RES_LAST_FILE 2>&1
echo "[SRV-082] OK"
echo "##### SRV082 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 전체 디렉토리																							>> $RES_LAST_FILE 2>&1
	ls -alL / | grep "^d"																					>> $RES_LAST_FILE 2>&1
echo "양호 : 타사용자(other)에게 쓰기 권한이 없는 경우"														>> $RES_LAST_FILE 2>&1
echo "취약 : 타사용자(other)에게 쓰기 권한이 있는 경우"														>> $RES_LAST_FILE 2>&1
echo "참고 : "																								>> $RES_LAST_FILE 2>&1
echo "		타사용자(other) 쓰기 권한이 있는 경우(ex. drwxr-xrwx 처럼 마지막 3개의 문자 값에 w 포함)"		>> $RES_LAST_FILE 2>&1
echo "		타사용자(other) 쓰기 권한이 없는 경우(ex. drwxr-xr-x 처럼 마지막 3개의 문자 값에 w 미포함)"		>> $RES_LAST_FILE 2>&1
echo "      쓰기(w) 권한이 존재하더라도 실행(x) 권한이 부여된 경우에만 쓰기가 가능함"							>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-083] 시스템 스타트업 스크립트 권한 설정 오류"				                                    >> $RES_LAST_FILE 2>&1
echo "[SRV-083] OK"
echo "##### SRV083 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	ls -l /etc/rc.d/rc.local                                                                                >> $RES_LAST_FILE 2>&1
echo "양호 : others에 쓰기 권한이 없을 경우						"							>> $RES_LAST_FILE 2>&1
echo "취약 : others에 쓰기 권한이 있을 경우                      "                     		>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-084] 시스템 주요 파일 권한 설정 미흡"														>> $RES_LAST_FILE 2>&1
echo "[SRV-084] OK"
echo "##### SRV084 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo /etc/passwd 파일의 소유자와 권한 값																	>> $RES_LAST_FILE 2>&1
	ls -alL /etc/passwd																						>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo /etc/shadow 파일의 소유자와 권한 값																	>> $RES_LAST_FILE 2>&1
	ls -alL /etc/shadow																						>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo /etc/hosts 파일의 소유자와 권한 값																		>> $RES_LAST_FILE 2>&1
	ls -alL /etc/hosts																						>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo /etc/inetd.conf 파일의 소유자와 권한 값																>> $RES_LAST_FILE 2>&1
	ls -alL /etc/inetd.conf																					>> $RES_LAST_FILE 2>&1
echo /etc/xinetd.conf 파일의 소유자와 권한 값															>> $RES_LAST_FILE 2>&1
	ls -alL /etc/xinetd.conf																					>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo /etc/rsyslog.conf 파일의 소유자와 권한 값																>> $RES_LAST_FILE 2>&1
	ls -alL /etc/rsyslog.conf																				>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo /etc/services 파일의 소유자와 권한 값																>> $RES_LAST_FILE 2>&1
	ls -alL /etc/services 																					>> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo /etc/hosts.lpd  파일의 소유자와 권한 값																>> $RES_LAST_FILE 2>&1
	ls -alL /etc/hosts.lpd     					                        	                                >> $RES_LAST_FILE 2>&1
echo                          >> $RES_LAST_FILE 2>&1
echo "양호 : 시스템 주요 파일 권한이 아래의 조건보다 낮게 부여된 경우"														>> $RES_LAST_FILE 2>&1
echo "취약 : 시스템 주요 파일 권한이 아래의 조건보다 높게 부여된 경우"														>> $RES_LAST_FILE 2>&1
echo "	1. /etc/passwd 권한: 644, 소유자 root"														>> $RES_LAST_FILE 2>&1
echo "	2. /etc/shadow 권한: 600, 소유자 root"														>> $RES_LAST_FILE 2>&1
echo "	3. /etc/hosts 권한: 644, 소유자 root"														>> $RES_LAST_FILE 2>&1
echo "	4. /etc/(x)inetd.conf 권한: 600, 소유자 root"														>> $RES_LAST_FILE 2>&1
echo "	5. /etc/syslogd.conf 권한: 644, 소유자 root"														>> $RES_LAST_FILE 2>&1
echo "	6. /etc/services 권한: 644, 소유자 root"														>> $RES_LAST_FILE 2>&1
echo "	7. /etc/hosts.lpd 권한: 640, 소유자 root"														>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-087] 컴파일러 존재 및 권한 설정 오류"															>> $RES_LAST_FILE 2>&1
echo "[SRV-087] OK"
echo "##### SRV087 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. gcc 컴파일러 존재 유무 확인																			>> $RES_LAST_FILE 2>&1
	which gcc																								>> $RES_LAST_FILE 2>&1
echo 2. gcc 컴파일러 실행 권한 확인\(해당 파일이 없다고 출력되는 경우는 양호\) 								>> $RES_LAST_FILE 2>&1
	ls -aLl /usr/bin/gcc																						>> $RES_LAST_FILE 2>&1
echo "해당 항목에서는 gcc 컴파일러만 점검하고 있으므로 										"				>> $RES_LAST_FILE 2>&1
echo "인터뷰 및 수동 점검을 통해 별도의 C 컴파일러 사용 유무 및 컴파일러의 권한 설정 확인	"				>> $RES_LAST_FILE 2>&1
echo "양호 : 컴파일러가 존재하지 않는 경우 혹은 관리자에게만 실행 권한이 있는 경우			"				>> $RES_LAST_FILE 2>&1
echo "취약 : 관리자 외에 그룹, 기타 사용자에게 실행 권한이 있는 경우						"				>> $RES_LAST_FILE 2>&1
echo "참고 : 권한(퍼미션) 확인 시"																			>> $RES_LAST_FILE 2>&1
echo "그룹, 기타 사용자 권한에 실행권한(x)이 있는 경우 취약							"						>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-091] 불필요하게 SUID, SGID, Sticky bit가 설정된 파일 존재"														>> $RES_LAST_FILE 2>&1
echo "[SRV-091] OK"
echo "##### SRV091 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	echo "[CHECK SUID & SGID]"																				>> $RES_LAST_FILE 2>&1
	FILES="/sbin/dump /sbin/restore /sbin/unix_chkpwd /usr/bin/at /usr/bin/lpq /usr/bin/lpq-lpd /usr/bin/lpr /usr/bin/lpr-lpd /usr/bin/lprm /usr/bin/lprm-lpd /usr/bin/newgrp /usr/sbin/lpc /usr/sbin/lpc-lpd /usr/sbin/traceroute"
	for check_file in $FILES
	do
		if [ -f $check_file ];
			then
				if [ `ls -alL $check_file | awk '{print $1}' | grep -i 's'` ];								>> $RES_LAST_FILE 2>&1
					then
						ls -alL $check_file																	>> $RES_LAST_FILE 2>&1
				fi
		fi
	done
	echo "[CHECK ETC - Additional points]"																	>> $RES_LAST_FILE 2>&1
		FILES="/usr/bin/chage /usr/bin/gpasswd /usr/bin/wall /usr/bin/chfn /usr/bin/write /usr/sbin/usernetctl /usr/sbin/userhelper /bin/mount /bin/umount /usr/sbin/lockdev /bin/ping /bin/ping6"
	for check_file in $FILES
	do
		if [ -f $check_file ];
			then
				if [ `ls -alL $check_file | awk '{print $1}' | grep -i 's'` ];								>> $RES_LAST_FILE 2>&1
					then
						ls -alL $check_file																	>> $RES_LAST_FILE 2>&1
				fi
		fi
	done
echo "양호 : SUID, SGID가 설정되어 있는 파일 및 Sticky bit가 설정되어 있는 디렉터리가 없음(=결과값이 없음)"	>> $RES_LAST_FILE 2>&1
echo "취약 : SUID, SGID가 설정되어 있는 파일 또는 Sticky bit가 설정되어 있는 디렉터리가 있음"				>> $RES_LAST_FILE 2>&1
echo "[CHECK ETC - Additional points] 항목의 경우에는" 														>> $RES_LAST_FILE 2>&1
echo "양호/취약 여부와는 별개로 취급하며 SUID 또는 SGID가 설정된 파일이 있을 경우 인터뷰를 통하여 수정할 것을 권고해야 함" 		>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-092] 사용자 홈 디렉터리 설정 미흡"																>> $RES_LAST_FILE 2>&1
echo "[SRV-092] OK"
echo "##### SRV092 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	HOMEDIRS=`cat /etc/passwd | grep -v 'nologin' | grep -v 'false' | awk -F: 'length($6) > 0 {print $6}' | sort -u` 			>> $RES_LAST_FILE 2>&1
	for dir in $HOMEDIRS																					
	do																										
		ls -aldL $dir																						>> $RES_LAST_FILE 2>&1
	done																			
echo "양호 : 홈 디렉터리의 소유자와 실 사용자가 일치하고, 계정간 중복 홈 디렉터리가 존재하지 않고, 불필요한 others 쓰기 권한이 없는 경우"															>> $RES_LAST_FILE 2>&1
echo "취약 : 홈 디렉터리의 소유자와 실 사용자가 일치하지 않거나, 계정간 중복 홈 디렉터리가 존재하거나, 불필요한 others 쓰기 권한이 있는 경우"											  					>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-093] 불필요한 world writable 파일 존재"																	>> $RES_LAST_FILE 2>&1
echo "[SRV-093] OK"
echo "##### SRV093 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	find / -xdev -type f -perm -2 -exec ls -al {} \; 														>> $RES_LAST_FILE 2>&1
echo "양호 : world writable 파일이 없거나, 필요에 의한 world writable 파일만 존재"							>> $RES_LAST_FILE 2>&1
echo "취약 : 불필요한 world writable 파일이 있음"											  				>> $RES_LAST_FILE 2>&1
echo "예시) -rwxrw-rw- 이 경우, world writable 파일"														>> $RES_LAST_FILE 2>&1
echo "예시) -rwxrw-r-- 이 경우, world writable 파일이 아님"													>> $RES_LAST_FILE 2>&1
echo "참고 : world writable 파일이 존재할 경우, 인터뷰를 통하여 해당 파일에 대한 필요성을 판단해야 함"		>> $RES_LAST_FILE 2>&1
echo "world writable 파일 : 모든 사용자가 접근 및 수정할 수 있는 권한으로 설정된 파일"						>> $RES_LAST_FILE 2>&1
echo "일반 사용자(other)에게 쓰기 권한(w)이 있는 경우 world writable 파일로 분류함"							>> $RES_LAST_FILE 2>&1
echo "참고 : 쓰기(w) 권한이 존재하더라도 실행(x) 권한이 부여된 경우에만 쓰기가 가능함"							>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-094] Crontab 참조파일 권한 설정 미흡"                                                			>> $RES_LAST_FILE 2>&1
echo "[SRV-094] OK"
echo "##### SRV094 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l >> $RES_LAST_FILE 2>&1; done > cron.txt                                                  
	(CRONTAB_DIR=`cat cron.txt | sed -e 's;^.* ;;'`)
	for dir in $CRONTAB_DIR
	do
		(ls -l $dir)                                                                     						>> $RES_LAST_FILE 2>&1   
	done
	rm -f cron.txt 
echo "양호 : crontab에서 사용하는 파일이 없는 경우(=출력 값이 없는 경우) "        							>> $RES_LAST_FILE 2>&1
echo "   혹은 사용하는 파일이 있으나 타사용자에게 쓰기권한이 부여되지 않은 파일인 경우  "               	>> $RES_LAST_FILE 2>&1
echo "취약 : crontab에서 사용하는 파일이 타사용자에게 쓰기권한이 부여된 파일인 경우     "               	>> $RES_LAST_FILE 2>&1
echo "참고 : 참조 파일 중 하나의 파일이라도 타사용자에게 쓰기권한이 부여되면 취약"							>> $RES_LAST_FILE 2>&1
echo "예시) -rwxrw-rw- 이 경우, 타사용자에게 쓰기권한이 부여됨                          "         			>> $RES_LAST_FILE 2>&1
echo "예시) -rwxrw-r-- 이 경우, 타사용자에게 쓰기권한이 부여되지 않음                   "         			>> $RES_LAST_FILE 2>&1
echo "참고 : 쓰기(w) 권한이 존재하더라도 실행(x) 권한이 부여된 경우에만 쓰기가 가능함"							>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-095] 존재하지 않는 소유자 및 그룹 권한을 가진 파일 또는 디렉터리 존재"																>> $RES_LAST_FILE 2>&1
echo "[SRV-095] OK"
echo "##### SRV095 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "" >> $RES_LAST_FILE 2>&1 
	find / -xdev \( -nouser -o -nogroup \) -exec ls -al {} \; 2>/dev/null >> SRV-095.txt 2>&1	
	cat SRV-095.txt																						>> $RES_LAST_FILE 2>&1
	if [ `cat SRV-095.txt | grep "/" | wc -l` -eq 0 ]; then
		 echo "[양호] - 소유자가 없는 파일 및 디렉토리 없음" 												>> $RES_LAST_FILE 2>&1
	fi
	rm -f SRV-095.txt
echo "양호 : 결과값이 없는 경우"	    																	>> $RES_LAST_FILE 2>&1
echo "취약 : [취약] - 소유자가 없는 파일 및 디렉토리 존재가 뜨는 경우"                                      >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-096] 사용자 환경파일의 소유자 또는 권한 설정 미흡"													>> $RES_LAST_FILE 2>&1
echo "[SRV-096] OK"
echo "##### SRV096 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	ls -al /etc/profile                                                                                     >> $RES_LAST_FILE 2>&1
	HOMEDIRS=`cat /etc/passwd | grep -v 'nologin' | grep -v 'false' | grep -v "#" | awk -F: 'length($6) > 0 {print $6}' | sort -u` 		>> $RES_LAST_FILE 2>&1
	FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile" 	>> $RES_LAST_FILE 2>&1
	for dir in $HOMEDIRS
		do
		for file in $FILES
			do
			FILE=$dir/$file         																		>> $RES_LAST_FILE 2>&1
			if [ -f $FILE ]; then
				ls -alL $FILE																				>> $RES_LAST_FILE 2>&1
			fi
		done
	done
echo "양호 : 1)소유자: root 및 해당 계정, 2)권한: root 및 others에 권한이 없을 경우"			   				>> $RES_LAST_FILE 2>&1
echo "취약 : 소유자가 잘못되었으며, others에 읽기 혹은 쓰기 권한이 있을 경우"                                  		>> $RES_LAST_FILE 2>&1
echo "참고 : 디렉터리일 경우 쓰기(w) 권한이 존재하더라도 실행(x) 권한이 부여된 경우에만 쓰기가 가능함"							>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-108] 로그에 대한 접근 통제 및 관리 미흡"			                                             	>> $RES_LAST_FILE 2>&1
echo "[SRV-108] OK"
echo "##### SRV108 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	ls -al /var/log                                                                                >> $RES_LAST_FILE 2>&1
	echo "양호 : 파일이 1)소유자: root, 2)권한: 644(-rw-r--r--) 이하로 설정되어 있는 경우"         				>> $RES_LAST_FILE 2>&1
echo "취약 : 소유자와 권한 중 한 가지라도 위와 다르게 설정된 경우"                                          >> $RES_LAST_FILE 2>&1
echo "참고 : /var/log/wtmp의 경우는 664 이하 (권한 변경 불가)"                                          >> $RES_LAST_FILE 2>&1
echo "     /var/log/btmp의 경우는 660 이하 (권한 변경 불가)"                                          >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-109] 시스템 주요 이벤트 로그 설정 미흡"																	>> $RES_LAST_FILE 2>&1
echo "[SRV-109] OK"
echo "##### SRV109 #####"          >> $RES_LAST_FILE 2>&1
echo "##### START #####"          >> $RES_LAST_FILE 2>&1
echo "[ # 1.1 /etc/syslog.conf 파일에서 시스템 로깅 설정 확인 # ]"        >> $RES_LAST_FILE 2>&1
	(cat /etc/syslog.conf | grep -v '#' | egrep -i 'authpriv|mail|cron|alert|emerg')     >> $RES_LAST_FILE 2>&1
echo "[ # 1.2 /etc/rsyslog.conf 파일에서 시스템 로깅 설정 확인 # ]"        >> $RES_LAST_FILE 2>&1
	(cat /etc/rsyslog.conf | grep -v '#' | egrep -i 'authpriv|mail|cron|alert|emerg')    >> $RES_LAST_FILE 2>&1
echo "[ # 1.3 /etc/syslog-ng.conf 파일에서 시스템 로깅 설정 확인 # ]"        >> $RES_LAST_FILE 2>&1
	(cat /etc/syslog-ng.conf | grep -v '#' | egrep -i 'authpriv|mail|cron|alert|emerg')    >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1
echo "2.rsyslogd 확인"																						>> $RES_LAST_FILE 2>&1
	if [ `ps -ef | grep -i 'rsyslogd' | grep -v 'grep' | wc -l` -ge 1 ]; then
		echo "로그 데몬(rsyslogd)이 활성화되어 있음"														>> $RES_LAST_FILE 2>&1
		echo 																								>> $RES_LAST_FILE 2>&1
		echo "# /etc/rsyslog.conf 확인 #"																	>> $RES_LAST_FILE 2>&1
		cat /etc/rsyslog.conf | grep "authpriv.*"       									>> $RES_LAST_FILE 2>&1
	else	
		if [ `ps -ef | grep -i 'syslogd' | grep -v 'grep' | wc -l` -ge 1 ]; then 							>> $RES_LAST_FILE 2>&1
			echo "로그 데몬(syslogd)이 활성화되어 있음"														>> $RES_LAST_FILE 2>&1
			echo 																							>> $RES_LAST_FILE 2>&1
			echo "# /etc/syslog.conf 확인 #"																>> $RES_LAST_FILE 2>&1
			cat /etc/syslog.conf | grep "authpriv.*"       								>> $RES_LAST_FILE 2>&1
		else
			echo "[취약] - 로그 데몬이 활성화되어 있지 않음"												>> $RES_LAST_FILE 2>&1
		fi
	fi
echo "" 																>> $RES_LAST_FILE 2>&1
echo "양호: 아래 2가지에 해당하는 경우"                            >> $RES_LAST_FILE 2>&1
echo "	1.1과 1.2, 1.3에서 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우"                            >> $RES_LAST_FILE 2>&1
echo "	2.에서 로그 데몬이 활성화되어 있고 'authpriv.info /var/log/sulog'가 설정되어 있는 경우"                            >> $RES_LAST_FILE 2>&1
echo "취약: 아래 2가지에 해당하는 경우"                            >> $RES_LAST_FILE 2>&1
echo "	1.1과 1.2, 1.3에서 로그 기록 정책 미수립, 또는, 정책에 따라 설정되어 있지 않은 경우"                            >> $RES_LAST_FILE 2>&1
echo "	2.에서 [취약] - 로그 데몬이 활성화되어 있지 않음이 출력되거나, conf 파일에 'authpriv.info /var/log/sulog' 설정이 없는 경우"                            >> $RES_LAST_FILE 2>&1
echo ""         >> $RES_LAST_FILE 2>&1
echo "[ ## 시스템 로깅 설정 참고 ## ]"         >> $RES_LAST_FILE 2>&1
echo "- *.info;mail.none;authpriv.none;cron.none /var/log/messages"  >> $RES_LAST_FILE 2>&1
echo "- authpriv.*  /var/log/secure"      >> $RES_LAST_FILE 2>&1
echo "- mail.*     /var/log/maillog"      >> $RES_LAST_FILE 2>&1
echo "- cron.*     /var/log/cron"      >> $RES_LAST_FILE 2>&1
echo "- *.alert     /dev/console"      >> $RES_LAST_FILE 2>&1
echo "- *.emerg   *"                      >> $RES_LAST_FILE 2>&1
echo "##### END #####"           >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-115] 로그의 정기적 검토 및 보고 미수행"			                                                		>> $RES_LAST_FILE 2>&1
echo "[SRV-115] OK"
echo "##### SRV115 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "# 수동 진단 #"                                                                                        >> $RES_LAST_FILE 2>&1
echo "양호 : 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우 "                  >> $RES_LAST_FILE 2>&1
echo "취약 : 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지지 않는 경우"              >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-118] 주기적인 보안패치 및 벤더 권고사항 미적용"		                                                >> $RES_LAST_FILE 2>&1
echo "[SRV-118] OK"
echo "##### SRV118 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1
echo "[ ## 배포판 버전 확인 1 ## ]"         >> $RES_LAST_FILE 2>&1
	(cat /etc/*-release | uniq)                                                         >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1
echo "[ ## 배포판 버전 확인 2 ## ]"         >> $RES_LAST_FILE 2>&1
	(cat /etc/issue* | uniq)                                                         >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1
echo "[ ## 배포판 버전 확인 3(redhat계열) ## ]"         >> $RES_LAST_FILE 2>&1
	(rpm -qa *-release | uniq)                                                         >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1
echo "양호 : 패치 적용 정책을 수립하여 주기적으로 패치관리를 하고 있는 경우"                       			>> $RES_LAST_FILE 2>&1
echo "취약 : 패치 적용 정책을 수립하지 않고 주기적으로 패치관리를 하지 않는 경우"                       	>> $RES_LAST_FILE 2>&1
echo "          단, 내부규정에 명시되지 않은 경우 통상 1개월 이내 최신 버전으로 패치 적용할 것을 권고"      >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-121] root 계정의 PATH 환경변수 설정 미흡"			                                        >> $RES_LAST_FILE 2>&1
echo "[SRV-121] OK"
echo "##### SRV121 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo $PATH																				>> $RES_LAST_FILE 2>&1
	if [ `echo $PATH | grep "\.:" | wc -l` -eq 0 ]; then echo "[양호] - PATH 환경변수에 '.'을 사용하지 않음">> $RES_LAST_FILE 2>&1                                                        
	else echo "[취약] - PATH 환경변수에 '.'을 사용함" 														>>$RES_LAST_FILE 2>&1
    fi
echo "* 양호 : PATH 환경변수에 '.', '::' 가 맨 앞이나 중간에 존재하지 않은 경우"   >> $RES_LAST_FILE 2>&1
echo "* 취약 : PATH 환경변수에 '.', '::' 가 맨 앞이나 중간에 존재하는 경우"         >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-122] UMASK 설정 미흡" 				                                                    >> $RES_LAST_FILE 2>&1
echo "[SRV-122] OK"
echo "##### SRV122 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[1. umask value]"                                                       >> $RES_LAST_FILE 2>&1
umask                                                                            >> $RES_LAST_FILE 2>&1
echo "[2. umask in .profile ]"                                                 >> $RES_LAST_FILE 2>&1
HOMEDIRS=`cat /etc/passwd | grep -E -v '/bin/false|nologin' | awk -F: 'length($6) > 0 {print $6}' | sort -u`
FILES=".profile"
for dir in $HOMEDIRS
do
for file in $FILES
do
FILE=$dir/$file
if [ -f $FILE ];
then
echo "#" $FILE                                                                 >> $RES_LAST_FILE 2>&1
(cat $FILE | grep -i 'umask')                                                  >> $RES_LAST_FILE 2>&1
echo                                                                             >> $RES_LAST_FILE 2>&1
fi
done
done
echo "[3. umask in /etc/profile ]"                                            >> $RES_LAST_FILE 2>&1
cat /etc/profile | grep -i 'umask'                                             >> $RES_LAST_FILE 2>&1
echo "양호 : UMASK 값이 022 이상인 경우"                             >> $RES_LAST_FILE 2>&1
echo "취약 : UMASK 값이 022 미만인 경우"                             >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-127] 계정 잠금 임계값 설정 미비" 				                                                        >> $RES_LAST_FILE 2>&1
echo "[SRV-127] OK"
echo "##### SRV127 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	LINUX_BIT=`getconf LONG_BIT`
	if [ LINUX_BIT == "64" ]; then
		# 64bit 일 경우
		echo "# 64bit pam_tally 설정 확인 #"                         												>> $RES_LAST_FILE 2>&1
		echo 1.1. [Fedora \& Gentoo \& Red Hat_system-auth]																>> $RES_LAST_FILE 2>&1
			(cat /etc/pam.d/system-auth | grep -i 'deny' || echo "[취약] - deny 가 설정되어 있지 않음") >> $RES_LAST_FILE 2>&1
		echo																								>> $RES_LAST_FILE 2>&1
		echo 1.2. [Fedora \& Gentoo \& Red Hat_password-auth]																>> $RES_LAST_FILE 2>&1
			(cat /etc/pam.d/password-auth | grep -i 'deny' || echo "[취약] - deny 가 설정되어 있지 않음") >> $RES_LAST_FILE 2>&1
		echo																								>> $RES_LAST_FILE 2>&1
		echo 2. [Ubuntu \& Suse \& Debian_common-auth]																	>> $RES_LAST_FILE 2>&1
			(cat /etc/pam.d/common-auth | grep -i 'deny' || echo "[취약] - deny 가 설정되어 있지 않음") >> $RES_LAST_FILE 2>&1
		echo																								>> $RES_LAST_FILE 2>&1
		echo 2.1 [Ubuntu \& Suse \& Debian_common-password]																	>> $RES_LAST_FILE 2>&1
			(cat /etc/pam.d/common-password | grep -i 'deny' || echo "[취약] - deny 가 설정되어 있지 않음") >> $RES_LAST_FILE 2>&1
		echo																								>> $RES_LAST_FILE 2>&1	
	else
		# 32bit 일 경우
		echo "# 32bit pam_tally 설정 확인 #"                         												>> $RES_LAST_FILE 2>&1
		echo 1. [Fedora \& Gentoo \& Red Hat]																>> $RES_LAST_FILE 2>&1
			(cat /etc/pam.d/system-auth | grep -i '/lib/security/pam_tally2.so' || echo "[취약] - pam_tally2.so가 설정되어 있지 않음") >> $RES_LAST_FILE 2>&1
		echo																								>> $RES_LAST_FILE 2>&1
		echo 2. [Ubuntu \& Suse \& Debian_common-auth]																	>> $RES_LAST_FILE 2>&1
			(cat /etc/pam.d/common-auth | grep -i '/lib/security/pam_tally.so' || echo "[취약] - pam_tally2.so가 설정되어 있지 않음") >> $RES_LAST_FILE 2>&1
		echo																								>> $RES_LAST_FILE 2>&1
		echo 2.1 [Ubuntu \& Suse \& Debian_common-password]																	>> $RES_LAST_FILE 2>&1
			(cat /etc/pam.d/common-password | grep -i '/lib/security/pam_tally.so' || echo "[취약] - pam_tally2.so가 설정되어 있지 않음") >> $RES_LAST_FILE 2>&1
	fi
echo "**[참고. 전체 내용 보기 ]"                                            >> $RES_LAST_FILE 2>&1
echo "[/etc/pam.d/system-auth]"                                            >> $RES_LAST_FILE 2>&1
	(cat /etc/pam.d/system-auth) >> $RES_LAST_FILE 2>&1
echo "[/etc/pam.d/password-auth]"                                            >> $RES_LAST_FILE 2>&1
	(cat /etc/pam.d/password-auth) >> $RES_LAST_FILE 2>&1
echo																								>> $RES_LAST_FILE 2>&1	
echo "[Ubuntu \& Suse \& Debian_common-auth]"                                            >> $RES_LAST_FILE 2>&1	
	(cat /etc/pam.d/common-auth) >> $RES_LAST_FILE 2>&1
echo																								>> $RES_LAST_FILE 2>&1	
echo "[Ubuntu \& Suse \& Debian_common-password]"                                            >> $RES_LAST_FILE 2>&1	
	(cat /etc/pam.d/common-password) >> $RES_LAST_FILE 2>&1
echo																								>> $RES_LAST_FILE 2>&1		
echo "양호 : /etc/pam.d/password-auth 파일과 /etc/pam.d/system-auth 파일에 계정 잠금 임계값 설정이 존재하는 경우"                         						 >> $RES_LAST_FILE 2>&1
echo "       auth     required       pam_faillock.so preauth silent audit deny=3 unlock_time=600"                 					>> $RES_LAST_FILE 2>&1
echo "       auth     [default=die]  pam_faillock.so authfail audit deny=3 unlock_time=600"                                    >> $RES_LAST_FILE 2>&1
echo "       account  required       pam_faillock.so"                             		>> $RES_LAST_FILE 2>&1
echo "취약 : /etc/pam.d/password-auth 파일과 /etc/pam.d/system-auth 파일에 계정 잠금 임계값 설정이 존재하지 않는 경우"                                    		>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-131] SU 명령 사용가능 그룹 제한 미비" 				                                            >> $RES_LAST_FILE 2>&1
echo "[SRV-131] OK"
echo "##### SRV131 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "1.1. /bin/su 권한 확인"  																				>> $RES_LAST_FILE 2>&1
	ls -alL /bin/su  																						>> $RES_LAST_FILE 2>&1
echo "1.2. wheel 그룹 존재 여부 확인"																		>> $RES_LAST_FILE 2>&1
	DIRS=`ls -al /bin/su | awk '{print $4}'`																>> $RES_LAST_FILE 2>&1
	for dir in $DIRS
		do
		cat /etc/group | grep $dir:																			>> $RES_LAST_FILE 2>&1
	done
echo "2.1. pam 모듈 사용 - wheel group 확인"																>> $RES_LAST_FILE 2>&1
	cat /etc/group | grep 'wheel'																			>> $RES_LAST_FILE 2>&1
echo "2.2. pam 모듈 사용 - /etc/pam.d/su 확인"																>> $RES_LAST_FILE 2>&1
	cat /etc/pam.d/su | grep pam_*																			>> $RES_LAST_FILE 2>&1
echo "# 추가 정보: /etc/pam.d/su 소유자 및 권한"															>> $RES_LAST_FILE 2>&1
	ls -al /etc/pam.d/su																					>> $RES_LAST_FILE 2>&1
echo "양호 : 아래의 조건을 모두 만족해야 양호"																>> $RES_LAST_FILE 2>&1
echo "      1) /bin/su의 권한이 4750(-rwsr-x---)"															>> $RES_LAST_FILE 2>&1
echo "      2) wheel 그룹 존재"																				>> $RES_LAST_FILE 2>&1
echo "      3) /etc/pam.d/su 의 설정이 아래와 같음"															>> $RES_LAST_FILE 2>&1
echo "	     - auth  sufficient  /lib/security/pam_rootok.so"												>> $RES_LAST_FILE 2>&1
echo "	     - auth  required  /lib/security/pam_wheel.so debug group=wheel 혹은"							>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo "       - auth  sufficient  /lib/security/$ISA/pam_rootok.so"											>> $RES_LAST_FILE 2>&1
echo "       - auth  required  /lib/security/$ISA/pam_wheel.so use_uid"										>> $RES_LAST_FILE 2>&1
echo " 취약 : 위의 조건 중 하나라도 만족하지 않을 경우"														>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-133] Cron 서비스 사용 계정 제한 미비" 			                                                        >> $RES_LAST_FILE 2>&1
echo "[SRV-133] OK"
echo "##### SRV133 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	CRON_ALLOW="/etc/cron.allow"                                                                                
	CRON_DENY="/etc/cron.deny"                                                                                  
echo "1)crontab 명령에 대한 접근 제어 확인"                                                                 >> $RES_LAST_FILE 2>&1
#cron.allow 파일이 존재하는 경우                                                                                     
if [ -f $CRON_ALLOW ]; then                                                                                    
  CRON_ID="`cat $CRON_ALLOW`" && CRON_LEN="${#CRON_ID}"                                                                                 
    if [[ "$CRON_ID" != "root" ]]; then                                                                                                  
      if [ ${CRON_LEN} -gt 4 ]; then                                                                                                    
        #cron.allow 파일이 있고  root 외의 다른 계정 존재
	echo [인터뷰] - crontab 명령을 root 외의 사용자가 사용할 수 있음                                        >> $RES_LAST_FILE 2>&1
echo                                                                                                        >> $RES_LAST_FILE 2>&1
	echo "# /etc/cron.allow 내의 계정 #" 																	>> $RES_LAST_FILE 2>&1
      	cat /etc/cron.allow																					>> $RES_LAST_FILE 2>&1
	echo "# /etc/cron.deny 내의 계정 #" 																	>> $RES_LAST_FILE 2>&1
      	cat /etc/cron.deny																					>> $RES_LAST_FILE 2>&1	
      else                                                                                                 
        #cron.allow 파일이 있는데 root 외의 다른 계정 없음
        echo [양호] - crontab 명령을 root 외의 사용자가 사용할 수 없음                                      >> $RES_LAST_FILE 2>&1
      fi
    else
      #cron.allow 파일이 있는데 root 계정이 없음(파일이 존재해도 root를 명시해주어야 root 만 crontab명령을 사용할 수 있음)
      echo crontab 명령을 root 외의 사용자가 사용할 수 있음                                                 >> $RES_LAST_FILE 2>&1
    fi 
#cron.allow 파일은 없고 cron.deny 파일만 있는 경우
elif [ -f $CRON_DENY -a ! -f $CRON_ALLOW ]; then                                                            
  echo "[취약] - cron.deny 파일만 있음"                                                                     >> $RES_LAST_FILE 2>&1
#cron.allow, cron.deny 파일 전부 없는 경우
else
  echo "[양호] - cron.allow, cron.deny 파일 전부 없음(슈퍼 유저만 가능)"                                    >> $RES_LAST_FILE 2>&1
fi
echo                                                                                                        >> $RES_LAST_FILE 2>&1
echo "2)cron.allow, cron.deny 파일 소유자 및 권한 확인"                                                     >> $RES_LAST_FILE 2>&1
	if [ -f $CRON_ALLOW ]; then ls -al $CRON_ALLOW                                                          >> $RES_LAST_FILE 2>&1 2<&1
	fi
	if [ -f $CRON_DENY ]; then ls -al $CRON_DENY                                                            >> $RES_LAST_FILE 2>&1 2<&1
	fi
echo "3)cron.allow, cron.deny 파일 내용 확인"                                                     >> $RES_LAST_FILE 2>&1	
	echo "# /etc/cron.allow 내의 계정 #" 																	>> $RES_LAST_FILE 2>&1
      	cat /etc/cron.allow																					>> $RES_LAST_FILE 2>&1
	echo "# /etc/cron.deny 내의 계정 #" 																	>> $RES_LAST_FILE 2>&1
      	cat /etc/cron.deny																					>> $RES_LAST_FILE 2>&1		
echo "참고 : "																								>> $RES_LAST_FILE 2>&1
echo "- '[인터뷰] - crontab 명령을 root 외의 사용자가 사용할 수 있음'인 경우 인터뷰로 해당 계정이 불필요한 계정인지 확인" 		>> $RES_LAST_FILE 2>&1
echo "- 1), 2) 중 하나라도 취약할 경우 취약	"																>> $RES_LAST_FILE 2>&1
echo "양호 :"																								>> $RES_LAST_FILE 2>&1
echo "1) crontab 명령에 대한 접근 제어 확인"																>> $RES_LAST_FILE 2>&1
echo "- '[양호] - cron.allow, cron.deny 파일 전부 없음(슈퍼 유저만 가능)' 이거나"							>> $RES_LAST_FILE 2>&1
echo "- '[양호] - crontab 명령을 root 외의 사용자가 사용할 수 없음'인 경우"									>> $RES_LAST_FILE 2>&1
echo "2) cron.allow, cron.deny 파일 소유자 및 권한 확인	"													>> $RES_LAST_FILE 2>&1
echo "- 파일의 소유자: root, 권한: 644(-rw-r--r--) 이하인 경우	"											>> $RES_LAST_FILE 2>&1
echo "취약 : "																								>> $RES_LAST_FILE 2>&1
echo "1) crontab 명령에 대한 접근 제어 확인	"																>> $RES_LAST_FILE 2>&1
echo "- '[취약] - cron.deny 파일만 있음'인 경우(cron.deny 파일만 있으면 파일 안의 계정만 블랙리스트로 막기 때문에 취약)"		>> $RES_LAST_FILE 2>&1
echo "2) cron.allow, cron.deny 파일 소유자 및 권한 확인	"													>> $RES_LAST_FILE 2>&1
echo "- 파일의 소유자: root, 권한: 644(-rw-r--r--) 이하가 아닌 경우	"										>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-142] 중복 UID가 부여된 계정 존재" 				                                                >> $RES_LAST_FILE 2>&1
echo "[SRV-142] OK"
echo "##### SRV142 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 1. 결과 :                                                                                                 >> $RES_LAST_FILE 2>&1
	awk -F: '$3==0 {print $1, $3}' /etc/passwd																>> $RES_LAST_FILE 2>&1
echo                                                                                                        >> $RES_LAST_FILE 2>&1
echo 2. 결과 :                                                                                                 >> $RES_LAST_FILE 2>&1
	cat /etc/passwd																						>> $RES_LAST_FILE 2>&1
	ret=`awk -F: '{print $3}' /etc/passwd |grep -v '^0' |  sort | uniq -d | wc -l` 
	if [ $ret -eq 0 ]; then
		echo "[양호] - 일반 계정과 동일한 UID가 없음" 														>> $RES_LAST_FILE 2>&1
	else
		echo "[취약] - 일반 계정과 동일한 UID가 있음" 							  							>> $RES_LAST_FILE 2>&1
		echo                                                                                                >> $RES_LAST_FILE 2>&1
		ret2=`awk -F: '{print $3}' /etc/passwd |grep -v '^0' |  sort | uniq -d`
		for RPM in $ret2; do
			awk -F: '$3=='$RPM' {print $0}' /etc/passwd   													>> $RES_LAST_FILE 2>&1
		done
	fi
echo                                                                                                        >> $RES_LAST_FILE 2>&1
echo "양호 : 아래 2가지를 모두 만족하는 경우       "                                                       	>> $RES_LAST_FILE 2>&1
echo "	1. UID가 0인 계정이 root만 존재"                                                       	>> $RES_LAST_FILE 2>&1
echo "	2. [양호] 메시지가 출력될 경우"                                                       	>> $RES_LAST_FILE 2>&1
echo "취약 : 위의 조건 중 하나라도 만족하지 않을 경우"                                            				>> $RES_LAST_FILE 2>&1
echo "참고 : 계정 뒤의 숫자가 UID               "                                                           >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-144] /dev 경로에 불필요한 파일 존재"				                                        >> $RES_LAST_FILE 2>&1
echo "[SRV-144] OK"
echo "##### SRV144 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
	find /dev -type f -exec ls -al {} \;																	>> $RES_LAST_FILE 2>&1
echo "양호 : 해당 device 파일이 없음(결과값 없음)"                                                        	>> $RES_LAST_FILE 2>&1
echo "취약 : 해당 device 파일이 존재  "                                             						>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-147] 불필요한 SNMP 서비스 실행"                                                                   	>> $RES_LAST_FILE 2>&1
echo "[SRV-147] OK"
echo "##### SRV147 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "# SNMP Service 사용 여부 #"                                                         					>> $RES_LAST_FILE 2>&1
   (ps -ef | grep -i 'snmp' | grep -v 'grep' || echo "[양호] SNMP 서비스 미사용")                         >> $RES_LAST_FILE 2>&1
echo "# 추가 정보: SNMP Service 포트 #"                                                      				>> $RES_LAST_FILE 2>&1
   netstat -an | grep ':161' | grep 'LISTEN'                                                				>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1   
   ss -au | grep 'snmp'																					>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1   
   ss -anu | grep ':161'																						>> $RES_LAST_FILE 2>&1
echo "양호 : SNMP 서비스 미사용"                                             								>> $RES_LAST_FILE 2>&1
echo "취약 : SNMP 서비스를 사용하는 경우는 인터뷰 점검(필요치 않은 서비스인데 구동 중일 경우 취약)"         >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-148] 웹 서비스 정보 노출"	                                                       			>> $RES_LAST_FILE 2>&1
echo "[SRV-148] OK"
echo "##### SRV148 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[# 1.0. Apache : service process check_centos #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i httpd | grep -v 'grep' || echo "apache 미사용")     >> $RES_LAST_FILE 2>&1
echo "[# 1.0. Apache : service process check_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(ps -ef |grep -i apache2 | grep -v 'grep' || echo "apache 미사용(apache2 프로세스 없음)")     >> $RES_LAST_FILE 2>&1
echo "[# 2.1. httpd conf check_servertokens #]"                   >> $RES_LAST_FILE 2>&1
	if [ $APACHE_CHECK == "OFF" ]; then
		echo [양호] Apache 서비스 미사용																	>> $RES_LAST_FILE 2>&1
	else
		grep -i "ServerTokens|ServerSignature" $HTTPD_CONF                                                  >> $RES_LAST_FILE 2>&1
	fi
echo "[# 3.1. httpd conf check (CentOS, Redhat) #]"                   >> $RES_LAST_FILE 2>&1
	(cat /etc/httpd/conf/httpd.conf | grep -i "ServerTokens|ServerSignature")     >> $RES_LAST_FILE 2>&1
	(cat /etc/httpd/httpd.conf | grep -i "ServerTokens|ServerSignature")     >> $RES_LAST_FILE 2>&1
echo "[# 3.2. httpd conf check_servertokens_ubuntu #]"                   >> $RES_LAST_FILE 2>&1
	(cat /etc/apache2/apache2.conf | grep -i "ServerTokens|ServerSignature")     >> $RES_LAST_FILE 2>&1
echo "양호 : Apache 서비스 미사용 혹은 ServerTokens 옆에 Prod(ProductOnly) 옵션이 있는 경우"                >> $RES_LAST_FILE 2>&1
echo "취약 : ServerTokens 옆에 Prod(ProductOnly) 옵션이 없는 경우 "                     					>> $RES_LAST_FILE 2>&1
echo "설정 예시 : ServerTokens ProductOnly 혹은 ServerTokens Prod"											>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-158] 불필요한 Telnet 서비스 실행"															>> $RES_LAST_FILE 2>&1
echo "[SRV-158] OK"
echo "##### SRV158 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "1.1 TELNET 확인(ps -ef | grep 'telnet')"																>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'telnet' | grep -v 'grep')																	>> $RES_LAST_FILE 2>&1
echo "1.2. Telnet 포트 확인"																				>> $RES_LAST_FILE 2>&1
	(netstat -an | grep ':23' | grep 'LISTEN')																>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1	
	(ss -an | grep ':23')																						>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo "2.1. inetd 확인(ps -ef | grep 'inetd')"                                                               >> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'inetd' | grep -v 'grep')																	>> $RES_LAST_FILE 2>&1
echo "2.2. /etc/inetd.d/telnet 내용 중 disable 값 확인"                                                     >> $RES_LAST_FILE 2>&1
	(cat /etc/inetd.d/telnet | grep disable) 																	>> $RES_LAST_FILE 2>&1
echo "3.1. xinetd 확인(ps -ef | grep 'xinetd')"                                                             >> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'xinetd' | grep -v 'grep') 																>> $RES_LAST_FILE 2>&1
echo "3.2. /etc/xinetd.d/telnet 내용 중 disable 값 확인"                                                    >> $RES_LAST_FILE 2>&1
	(cat /etc/xinetd.d/telnet | grep disable) 																>> $RES_LAST_FILE 2>&1
echo "양호 : 아래 항목을 모두 만족하는 경우"																>> $RES_LAST_FILE 2>&1
echo	 " - 1.1 에서 결과 값이 없음"																		>> $RES_LAST_FILE 2>&1
echo	 " - 2.1 에서 결과 값이 없는 경우 혹은 결과 값이 있는 경우엔 2.2에서 disable 값이 yes인 경우"		>> $RES_LAST_FILE 2>&1
echo	 " - 3.1 에서 결과 값이 없는 경우 혹은 결과 값이 있는 경우엔 3.2 에서 disable 값이 yes인 경우"		>> $RES_LAST_FILE 2>&1
echo "취약 : 양호 조건 중 하나라도 만족하지 않는 경우"														>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-161] ftpusers 파일의 소유자 및 권한 설정 미흡"                                                      	>> $RES_LAST_FILE 2>&1
echo "[SRV-161] OK"
echo "##### SRV161 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "# PROFTP - /etc/ftpusers #"																			>> $RES_LAST_FILE 2>&1
	ls -al /etc/ftpusers																					>> $RES_LAST_FILE 2>&1
echo "# NCFTP - /etc/ftpd/ftpusers #"																		>> $RES_LAST_FILE 2>&1
	ls -al /etc/ftpd/ftpusers																				>> $RES_LAST_FILE 2>&1
echo "# VSFTP - /etc/vsftpd.userlist #"																		>> $RES_LAST_FILE 2>&1
	ls -al /etc/vsftpd.userlist																				>> $RES_LAST_FILE 2>&1
echo "# VSFTP - /etc/vsftpd/user_list #"																	>> $RES_LAST_FILE 2>&1
	ls -al /etc/vsftpd/user_list																			>> $RES_LAST_FILE 2>&1
echo "# VSFTP - /etc/vsftpd/vsftpd.userlist #"																>> $RES_LAST_FILE 2>&1
	ls -al /etc/vsftpd/vsftpd.userlist																		>> $RES_LAST_FILE 2>&1
echo "# VSFTP - /etc/vsftpd/ftpusers #"																		>> $RES_LAST_FILE 2>&1
	ls -al /etc/vsftpd/ftpusers 																			>> $RES_LAST_FILE 2>&1
echo "# VSFTP - /etc/vsftpd/vsftpd.ftpusers #"																>> $RES_LAST_FILE 2>&1
	ls -al /etc/vsftpd/vsftpd.ftpusers 																		>> $RES_LAST_FILE 2>&1
echo "양호 : 존재하는 파일에 대하여 1)소유자: root, 2)권한: 640 이하로 설정된 경우"                         >> $RES_LAST_FILE 2>&1
echo "취약 : 소유자와 권한 중 한 가지라도 위와 다르게 설정된 경우"                                      	>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-163] 시스템 사용 주의사항 미출력" 			                                                    >> $RES_LAST_FILE 2>&1
echo "[SRV-163] OK"
echo "##### SRV163 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "# 로컬 접속시도 시 보여줄 문구 #"                                                                     >> $RES_LAST_FILE 2>&1
	(cat /etc/issue)                                                                                          >> $RES_LAST_FILE 2>&1
echo "# 원격지에서 접속시도 시 보여줄 문구 #"                                                               >> $RES_LAST_FILE 2>&1
	(cat /etc/issue.net)                                                                                      >> $RES_LAST_FILE 2>&1
echo "# 로컬, 원격접속 모두에 해당하며 로그인 성공 후 보여줄 문구 #"                                        >> $RES_LAST_FILE 2>&1
	(cat /etc/motd)                                                                                           >> $RES_LAST_FILE 2>&1
echo "# /etc/ssh/sshd_config 파일의 Banner 값에 /etc/issue.net 파일로 설정 확인 #"        >> $RES_LAST_FILE 2>&1
	(cat /etc/ssh/sshd_config | grep -i "Banner")    >> $RES_LAST_FILE 2>&1	
	
echo   "양호: 1.1에서 /etc/motd와 1.2에서 /etc/issue.net 파일의 시스템 사용 주의사항 출력 설정이 되어 있고"            >> $RES_LAST_FILE 2>&1
            "1.3에서 /etc/ssh/sshd_config 파일의 Banner 값에 /etc/issue.net 파일로 설정되어 있는 경우"            >> $RES_LAST_FILE 2>&1
echo   "취약: 1.1에서 /etc/motd와 1.2에서 /etc/issue.net 파일의 시스템 사용 주의사항 출력 설정이 되어 있지 않거나 시스템 정보가 노출될 경우"                >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-164] 구성원이 존재하지 않는 불필요한 GID 존재"                                                      		>> $RES_LAST_FILE 2>&1
echo "[SRV-164] OK"
echo "##### SRV164 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[ # 1.1 /etc/passwd 파일에서 계정 확인 # ]"          >> $RES_LAST_FILE 2>&1
	(cat /etc/passwd)          >> $RES_LAST_FILE 2>&1
echo "[ # 1.2 /etc/group 파일에서 gid 확인 # ]"          >> $RES_LAST_FILE 2>&1
	(cat /etc/group)          >> $RES_LAST_FILE 2>&1
echo "양호 : 1.1 에서 시스템에 존재하는 계정 확인한 후"                                    >> $RES_LAST_FILE 2>&1
echo "		1.2 에서 존재하지 않는 계정에 GID 설정을 금지한 경우"                   >> $RES_LAST_FILE 2>&1
echo "취약 : 1.2 에서 존재하지 않은 계정에 GID 설정이 되어있는 경우"                 >> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-165] 불필요하게 Shell이 부여된 계정 존재"                                                     					>> $RES_LAST_FILE 2>&1
echo "[SRV-165] OK"
echo "##### SRV165 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "[ # 1.1 /etc/passwd 파일에서 system 계정 확인 # ]"          >> $RES_LAST_FILE 2>&1
	(cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher" | grep -v "admin") >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1	
echo "[ # 1.2 /etc/passwd 파일에서 /bin/false나 /sbin/nologin이 없을 경우 사용중인 계정인지 확인필요# ]"          >> $RES_LAST_FILE 2>&1
echo "[ #(참고의 UID_MIN값 이상의 계정이 사용중인 계정인지 확인; UID_MIN 미만 값의 계정은 전부 /bin/false 설정 필요)# ]"          >> $RES_LAST_FILE 2>&1
	(cat /etc/passwd | grep -v "false" | grep -v "nologin") >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1	
echo "* 양호 : 모든 항목에 /bin/false 또는 /sbin/nologin 이 부여되어 있음"                                   	>> $RES_LAST_FILE 2>&1
echo "* 취약 : 1. 1개 이상의 항목에 /bin/false 또는 /sbin/nologin 이 부여되어 있지 않음"    						>> $RES_LAST_FILE 2>&1
echo "        2. /etc/passwd 파일에서 현재 불필요 계정이 사용 중일 경우(/bin/false 또는 /sbin/nologin 설정이 없을 경우)"    						>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1
echo "* 참고 : UID 값이 1 ~ 100, 499이하(데비안, 수세리눅스는 999까지), 60000이상은 시스템 계정이므로 /bin/false 또는 /sbin/nologin 설정 되어 있어야함"    						>> $RES_LAST_FILE 2>&1
echo "* /etc/login.defs 에서 시스템 계정 UID 및 GID 값 확인"    						>> $RES_LAST_FILE 2>&1
	(cat /etc/login.defs | egrep "UID_MIN|UID_MAX|GID_MIN|GID_MAX|SYS_UID_MIN|SYS_UID_MAX") >> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-166] 불필요한 숨김 파일 또는 디렉터리 존재"                                                     	>> $RES_LAST_FILE 2>&1
echo "[SRV-166] OK"
echo "##### SRV166 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo "# 홈 디렉토리 확인 #"                                                                                 >> $RES_LAST_FILE 2>&1
	HOMEDIRS=`cat /etc/passwd | grep -v 'nologin' | grep -v 'false' | awk -F: 'length($6) > 0 {print $6}' | sort -u` 			>> $RES_LAST_FILE 2>&1
	for dir in $HOMEDIRS
		do
		echo "----------< $dir >----------"																	>> $RES_LAST_FILE 2>&1
		ls -a $dir | grep "^\."																				>> $RES_LAST_FILE 2>&1
	done
echo "# 다른 파일 시스템 #"																					>> $RES_LAST_FILE 2>&1
	find / -xdev -iname ".*" -type f -perm -1 -exec ls -al {} \;											>> $RES_LAST_FILE 2>&1
echo "양호 : 불필요한 파일 및 디렉토리가 없음"                                   							>> $RES_LAST_FILE 2>&1
echo "취약 : 불필요한 파일 및 디렉토리가 있음"    															>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                    				>> $RES_LAST_FILE 2>&1
echo "" 																>> $RES_LAST_FILE 2>&1


echo "[SRV-174] 불필요한 DNS 서비스 실행"																>> $RES_LAST_FILE 2>&1
echo "[SRV-174] OK"
echo "##### SRV174 #####"                                               >> $RES_LAST_FILE 2>&1
echo "##### START #####"                                               	>> $RES_LAST_FILE 2>&1
echo 결과 :																									>> $RES_LAST_FILE 2>&1
echo 1. DNS 서비스 실행 여부																				>> $RES_LAST_FILE 2>&1
	(ps -ef | grep 'named' | grep -v 'grep' || echo "[양호] - DNS 서비스 미사용")							>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo "양호 : DNS 서비스가 실행 중이지 않거나, 필요에 의해 사용 중인 경우"							>> $RES_LAST_FILE 2>&1
echo "취약 : DNS 서비스가 불필요하게 실행 중인 경우"											>> $RES_LAST_FILE 2>&1
echo																										>> $RES_LAST_FILE 2>&1
echo "##### END #####"                                                 >> $RES_LAST_FILE 2>&1
echo "" 																										>> $RES_LAST_FILE 2>&1


echo "---------------------------"                                                      				>> $RES_LAST_FILE 2>&1
echo "# 추가 정보: httpd_conf 내용 #"                                                      				>> $RES_LAST_FILE 2>&1
echo "# 01. 하드코딩 httpd_conf 내용 #"                                                      				>> $RES_LAST_FILE 2>&1
	(cat $HTTPD_CONF)                                                									>> $RES_LAST_FILE 2>&1
echo "---------------------------"                                                      				>> $RES_LAST_FILE 2>&1
echo "# 02. ps에서 경로 가져온 httpd_conf 내용 #"                                                      				>> $RES_LAST_FILE 2>&1
	(cat $path1"/"$path2)    >> $RES_LAST_FILE 2>&1
echo "---------------------------"                                                      				>> $RES_LAST_FILE 2>&1
echo "# 03. centos /etc/httpd/conf/httpd_conf 내용 #"                                                      				>> $RES_LAST_FILE 2>&1
	(cat /etc/httpd/conf/httpd.conf)     >> $RES_LAST_FILE 2>&1
echo "# 03. centos /etc/httpd/httpd_conf 내용 #"                                                      				>> $RES_LAST_FILE 2>&1	
	(cat /etc/httpd/httpd.conf)     >> $RES_LAST_FILE 2>&1
echo "# 03. ubuntu httpd_conf 내용 #"                                                      				>> $RES_LAST_FILE 2>&1
	(cat /etc/apache2/apache2.conf)    >> $RES_LAST_FILE 2>&1
echo "---------------------------"                                                      				>> $RES_LAST_FILE 2>&1
exit 0
