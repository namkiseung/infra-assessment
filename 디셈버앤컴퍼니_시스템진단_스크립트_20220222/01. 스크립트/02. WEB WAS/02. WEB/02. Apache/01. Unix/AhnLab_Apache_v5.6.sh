#!/bin/sh

LANG=C
export LANG

# admin
if [ `id | grep "uid=0" | wc -l ` -eq 0 ]; then
echo " "
echo " "
echo "This script must be run from the root user."
echo " "
echo " "
exit 0
fi

HOSTNAME=`echo $HOSTNAME`
DATE=`date +%y-%m-%d`
IP=`ifconfig | grep -iw inet | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1`

#####################################
## global variable
#####################################

OS_VERSION="uname -a"
OS_TYPE=APACHE_LINUX

#####################################
## file name 
#####################################
RES_LAST_FILE=${OS_TYPE}_${IP}_${HOSTNAME}_${DATE}.asvd

#####################################
## Httpd Running Check Set Environment Variables
#####################################

HTTP_CONF=`ps -ef | grep httpd | grep -v grep | awk -F ' ' '{print $8}' | head -n 1`
APACHE_CONF=`ps -ef | grep apache2 | grep -v grep | awk -F ' ' '{print $8}' | head -n 1`

if [ `ps -ef | grep httpd | grep -v grep | wc -l` -ge 1 ]; then
	HTTPD_ROOT=`$HTTP_CONF -V | grep "HTTPD_ROOT" | sed 's/^.*=\(\)/\1/' | tr -d [\"][\]`
	SERVER_CONFIG_DIR=`$HTTP_CONF -V | grep "SERVER_CONFIG_FILE" | sed 's/^.*=\(\)/\1/' | tr -d [\"][\]`
	HTTPD_CONF=`echo $HTTPD_ROOT"/"$SERVER_CONFIG_DIR`	
else
	HTTPD_ROOT=`$APACHE_CONF -V | grep "HTTPD_ROOT" | sed 's/^.*=\(\)/\1/' | tr -d [\"][\]`
	SERVER_CONFIG_DIR=`$APACHE_CONF -V | grep "SERVER_CONFIG_FILE" | sed 's/^.*=\(\)/\1/' | tr -d [\"][\]`
	HTTPD_CONF=`echo $HTTPD_ROOT"/"$SERVER_CONFIG_DIR`
fi


if [ ! -f $HTTPD_CONF ]; then
	echo ""
	echo "********************* ERROR *********************"
	echo " Can not find the location of a httpd.conf file"
	echo " Please enter the full path to the httpd.conf file"
	echo "********************* ERROR *********************"
	echo ""
	echo "Write full path to the httpd.conf file under here"
	read HTTPD_CONF
	echo ""
	
	if [ ! -f $HTTPD_CONF ]; then
		echo ""
		echo "******************* ERROR *******************"
		echo "*** Was entered incorrectly. Please re-run"
		echo "******************* ERROR *******************"
		echo ""
		exit 0
	fi
fi



ServerRoot=`cat $HTTPD_CONF | grep ServerRoot | grep -v '#' | awk -F'"' '{print $2}'`
DocumentRoot=`cat $HTTPD_CONF | grep DocumentRoot | grep -v '#' | awk -F'"' '{print $2}'`
ErrorLog=`cat $HTTPD_CONF | grep ErrorLog | grep -v '#' | awk -F' ' '{print $2}' | awk -F'"' '{print $2}'`
CustomLog=`cat $HTTPD_CONF | grep CustomLog | grep -v '#' | awk -F' ' '{print $2}' | awk -F'"' '{print $2}'`


INCLUDE_FLAG=0
if [ `cat $HTTPD_CONF | grep -i "include" | grep -v '#' | wc -l` -ge 1 ]; then
	INCLUDE_FLAG=1
	EXTRA_CONF_PATH=`cat $HTTPD_CONF | grep -i "include " |grep -v '#' |cut -f2 -d " "`
	EXTRA_CONF_FILES=`find $HTTPD_ROOT/$EXTRA_CONF_PATH`
	ErrorLog_EX=`cat $EXTRA_CONF_FILES | grep ErrorLog | grep -v '#' | awk -F' ' '{print $2}' | awk -F'"' '{print $2}'`
	CustomLog_EX=`cat $EXTRA_CONF_FILES | grep CustomLog | grep -v '#' | awk -F' ' '{print $2}' | awk -F'"' '{print $2}'`
fi


echo SYSTEM LINUX APACHE HeaderInfo  >> ./$RES_LAST_FILE 2>&1 

echo -e " ** ASVD_INFO: 4 LINUX APACHE" >> ./$RES_LAST_FILE 2>&1
echo -e " ** Start_time:\t\t" `date` >> ./$RES_LAST_FILE 2>&1
echo -e " ** HOSTNAME:\t\t " $HOSTNAME >> ./$RES_LAST_FILE 2>&1
echo -e " ** IP ADDRESS:\t\t " $IP >> ./$RES_LAST_FILE 2>&1
echo -e " ** OS TYPE:\t\t " $OS_TYPE >> ./$RES_LAST_FILE 2>&1
echo -e " ** OS VERSION:\t\t " `$OS_VERSION` >> ./$RES_LAST_FILE 2>&1
echo }ahnlab} >> ./$RES_LAST_FILE 2>&1

echo ""	>> ./$RES_LAST_FILE 2>&1
echo "" >> ./$RES_LAST_FILE 2>&1
echo "## LINUX_APACHE001 ##"
echo "##### WA-001 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-001 웹 프로세스 권한 제한 ###############"														>> ./$RES_LAST_FILE 2>&1
echo "---------------< 프로세스 >---------------"															>> ./$RES_LAST_FILE 2>&1
ps -ef | grep -v grep | grep httpd 								 										>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< httpd.conf >---------------"															>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | egrep "User |Group ")													>> ./$RES_LAST_FILE 2>&1

echo "1.1  프로세스가 Root 로 구동되는지 확인"																>> ./$RES_LAST_FILE 2>&1
echo "1.2  확인 불가능할 경우 httpd.conf 에서 어떤 사용자를 통해 구동하는지 확인"							>> ./$RES_LAST_FILE 2>&1

echo "양호 : 전용 Web Server 계정으로 서비스가 구동되는 경우"												>> ./$RES_LAST_FILE 2>&1
echo "취약 : 전용 Web Server 계정으로 서비스가 구동되지 않은 경우"											>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1

echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE002 ##"
echo "##### WA-002 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-002 디렉터리 쓰기 권한 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerRoot >---------------"															>> ./$RES_LAST_FILE 2>&1
echo $ServerRoot 								 														>> ./$RES_LAST_FILE 2>&1
ls -lLd $ServerRoot																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< DocumentRoot >---------------"														>> ./$RES_LAST_FILE 2>&1
echo $DocumentRoot							 															>> ./$RES_LAST_FILE 2>&1
ls -lLd $DocumentRoot																					>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< VirtualHost Root >---------------"													>> ./$RES_LAST_FILE 2>&1
if [ $INCLUDE_FLAG -ge 1 ]; then
	for file in $EXTRA_CONF_FILES
	do 
		if [ `cat $file | grep -v '#' | grep "DocumentRoot" | wc -l` -ge 1 ]; then
			EXTRA_CONF_FILES_DocumentRoot=`cat $file | grep -v '#' | grep "DocumentRoot" | cut -f2 -d" "`
			for dir in $EXTRA_CONF_FILES_DocumentRoot
			do
				tmp_dir=`dirname $dir`
				ls -lLd $tmp_dir                                    										>> ./$RES_LAST_FILE 2>&1
			done
		else
			echo "no DocumentRoot in $file"                                    								>> ./$RES_LAST_FILE 2>&1
		fi
	done
fi


echo "1.1  각 Apache 관련 디렉토리의 권한 설정 확인"														>> ./$RES_LAST_FILE 2>&1

echo "양호 : 디렉터리 소유자가 전용 Web Server 계정이고, 권한이 750(-rwxr-x---) 또는 755(drwxr-xr-x)일 경우"	>> ./$RES_LAST_FILE 2>&1
echo "취약 : 디렉터리 소유자가 전용 Web Server 계정이 아니거나, 권한이 750(-rwxr-x---) 또는 755(drwxr-xr-x)가 아닐 경우"	>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE003 ##"
echo "##### WA-003 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-003 소스/설정파일 권한 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Configuration Files >---------------"													>> ./$RES_LAST_FILE 2>&1
ls -lL $HTTPD_CONF 																							>> ./$RES_LAST_FILE 2>&1
ls -lL $EXTRA_CONF_FILES 																					>> ./$RES_LAST_FILE 2>&1

echo "---------------< Source Files >---------------"													>> ./$RES_LAST_FILE 2>&1
ls -lLR $DocumentRoot																						>> ./$RES_LAST_FILE 2>&1

if [ $INCLUDE_FLAG -ge 1 ]; then
	for file in $EXTRA_CONF_FILES
	do 
		if [ `cat $file | grep -v '#' | grep "DocumentRoot" | wc -l` -ge 1 ]; then
			EXTRA_CONF_FILES_DocumentRoot=`cat $file | grep -v '#' | grep "DocumentRoot" | cut -f2 -d" "`
			for dir in $EXTRA_CONF_FILES_DocumentRoot
			do
				tmp_dir=`dirname $dir`
				ls -lLR $tmp_dir                                    										>> ./$RES_LAST_FILE 2>&1
			done
		else
			echo "no DocumentRoot in $file"                                    								>> ./$RES_LAST_FILE 2>&1
		fi
	done
fi

echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  Apache 설정파일 권한 확인"																		>> ./$RES_LAST_FILE 2>&1

echo "양호 : 소스 파일 소유자가 전용 Web Server 계정이고, 권한이 754(-rwxr-xr--) 이하일 경우 "				>> ./$RES_LAST_FILE 2>&1
echo "양호 : 설정 파일 소유자가 전용 Web Server 계정이고, 권한이 700(-rwx------) 이하일 경우"				>> ./$RES_LAST_FILE 2>&1
echo "취약 : 소스 파일 소유자가 전용 Web Server 계정이 아니거나, 권한이 754(-rwxr-xr--) 보다 높을 경우"		>> ./$RES_LAST_FILE 2>&1
echo "취약 : 설정 파일 소유자가 전용 Web Server 계정이 아니거나, 권한이 700(-rwx------) 보다 높을 경우"		>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE004 ##"
echo "##### WA-004 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-004 로그 디렉터리/파일 권한 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ErrorLog >---------------"															>> ./$RES_LAST_FILE 2>&1
echo $ErrorLog                                              											>> ./$RES_LAST_FILE 2>&1

for dir in $ErrorLog
do
	ls -lLR $HTTPD_ROOT/$dir																			>> ./$RES_LAST_FILE 2>&1
	ls -lLd $HTTPD_ROOT/$dir																			>> ./$RES_LAST_FILE 2>&1
done


ls -lLR $ErrorLog																						>> ./$RES_LAST_FILE 2>&1
ls -lLd $ErrorLog																						>> ./$RES_LAST_FILE 2>&1

echo "---------------< CustomLog >---------------"															>> ./$RES_LAST_FILE 2>&1
echo $CustomLog                                         												>> ./$RES_LAST_FILE 2>&1

for dir in $CustomLog
do
	ls -lLR $HTTPD_ROOT/$dir																					>> ./$RES_LAST_FILE 2>&1
	ls -lLd $HTTPD_ROOT/$dir																					>> ./$RES_LAST_FILE 2>&1
done

ls -lLR $CustomLog																						>> ./$RES_LAST_FILE 2>&1
ls -lLd $CustomLog																						>> ./$RES_LAST_FILE 2>&1

echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< httpd-vhosts.conf >---------------"													>> ./$RES_LAST_FILE 2>&1
echo $ErrorLog_EX                                     													>> ./$RES_LAST_FILE 2>&1

for dir in $EXTRA_CONF_FILES
do
	if [ `cat $dir | grep -v '#' | egrep "ErrorLog|CustomLog" | wc -l` -ge 1 ]; then
		ls -lLd $HTTPD_ROOT/$dir                                     												>> ./$RES_LAST_FILE 2>&1
		ls -lLR $HTTPD_ROOT/$dir                                     												>> ./$RES_LAST_FILE 2>&1
		ls -lLd $dir                                     												>> ./$RES_LAST_FILE 2>&1
		ls -lLd $dir                                     												>> ./$RES_LAST_FILE 2>&1
	else
		echo "no errorlog config in $dir"                                   							>> ./$RES_LAST_FILE 2>&1
	fi
done						 													 					
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  로그 디렉터리 및 파일 권한설정"																	>> ./$RES_LAST_FILE 2>&1

echo "양호 : 디렉터리 소유자가 전용 Web Server 계정이고, 권한이 750(-rwxr-x---) 이하일 경우 "				>> ./$RES_LAST_FILE 2>&1
echo "양호 : 파일 소유자가 전용 Web Server 계정이고, 권한이 640(-rw-r-----) 이하일 경우"					>> ./$RES_LAST_FILE 2>&1
echo "취약 : 디렉터리 소유자가 전용 Web Server 계정이 아니거나, 권한이 750(-rwxr-x---) 보다 높을 경우"		>> ./$RES_LAST_FILE 2>&1
echo "취약 : 파일 소유자가 전용 Web Server 계정이 아니거나, 권한이 640(-rw-r-----) 보다 높을 경우"			>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE005 ##"
echo "##### WA-005 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-005 디렉터리 리스팅 제거 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Options >---------------"															>> ./$RES_LAST_FILE 2>&1
cat $HTTPD_CONF | grep -v '#' | grep -v IndexOptions | grep Options									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Directory >---------------"															>> ./$RES_LAST_FILE 2>&1	
cat $HTTPD_CONF | grep -v '#' | grep 'Directory '														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< VirtualHost Option / Directory >---------------"										>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do
if [ `cat $dir | grep -v '#' | grep "VirtualHost" | wc -l` -ge 1 ]; then
VHOST_START=`cat $dir | grep -v '#' | grep -n "<VirtualHost" | cut -d: -f1`
VHOST_END=`cat $dir | grep -v '#' | grep -n "</VirtualHost" | cut -d: -f1`
VHOST_CNT=`cat $dir | grep -v '#' | grep  -c -n "<VirtualHost"`
temp_cnt=1
for i in $VHOST_START
do
VHOST_START_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done
temp_cnt=1
for i in $VHOST_END
do
VHOST_END_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done

for ((i=1;i<=$VHOST_CNT;i++));
do
VHOST_NAME=`sed -n ${VHOST_START_ARRAY[$i]},1p $dir`
VHOST_EACH_INFO=`sed -n ${VHOST_START_ARRAY[$i]},${VHOST_END_ARRAY[$i]}p $dir | grep -v "IndexOption" | egrep "Options|Directory|ServerName"`
echo $VHOST_NAME																			>> ./$RES_LAST_FILE 2>&1
echo $VHOST_EACH_INFO																		>> ./$RES_LAST_FILE 2>&1
echo " "
echo " "
done
fi
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  디렉토리 리스팅 설정확인 ( <Directory> </Directory> 사이에 Indexes 제거 또는 -Indexes 또는 IncludeNoExec 삽입)"		>> ./$RES_LAST_FILE 2>&1																		>> ./$RES_LAST_FILE 2>&1

echo "양호 : -Indexex 또는 IncludeNoExec 설정되어 있는 경우"												>> ./$RES_LAST_FILE 2>&1
echo "취약 :  Indexes 설정되어 있는 경우"																	>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE006 ##"
echo "##### WA-006 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-006 FollowSymLinks 제거 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Options >---------------"															>> ./$RES_LAST_FILE 2>&1
cat $HTTPD_CONF | grep -v '#' | grep -v IndexOptions | grep Options											>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Directory >---------------"															>> ./$RES_LAST_FILE 2>&1	
cat $HTTPD_CONF | grep -v '#' | grep 'Directory '														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< VirtualHost Option / Directory >---------------"										>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do
if [ `cat $dir | grep -v '#' | grep "VirtualHost" | wc -l` -ge 1 ]; then
VHOST_START=`cat $dir | grep -v '#' | grep -n "<VirtualHost" | cut -d: -f1`
VHOST_END=`cat $dir | grep -v '#' | grep -n "</VirtualHost" | cut -d: -f1`
VHOST_CNT=`cat $dir | grep -v '#' | grep  -c -n "<VirtualHost"`
temp_cnt=1
for i in $VHOST_START
do
VHOST_START_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done
temp_cnt=1
for i in $VHOST_END
do
VHOST_END_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done

for ((i=1;i<=$VHOST_CNT;i++));
do
VHOST_NAME=`sed -n ${VHOST_START_ARRAY[$i]},1p $dir`
VHOST_EACH_INFO=`sed -n ${VHOST_START_ARRAY[$i]},${VHOST_END_ARRAY[$i]}p $dir | grep -v "IndexOption" | egrep "Options|Directory|ServerName"`
echo $VHOST_NAME																			>> ./$RES_LAST_FILE 2>&1
echo $VHOST_EACH_INFO																		>> ./$RES_LAST_FILE 2>&1
echo " "
echo " "
done
fi
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  Options에 FollowSymLinks 존재확인"															>> ./$RES_LAST_FILE 2>&1

echo "양호 : FollowSymLinks 설정 값이 없거나, -FollowSymLinks 설정되어 있는 경우"							>> ./$RES_LAST_FILE 2>&1
echo "취약 : FollowSymLinks 설정되어 있는 경우"															>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1



echo "## LINUX_APACHE007 ##"
echo "##### WA-007 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-007 불필요한 파일 제거 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< httpd.conf >---------------"															>> ./$RES_LAST_FILE 2>&1
cat $HTTPD_CONF | grep -v '#' | grep manual																	>> ./$RES_LAST_FILE 2>&1
echo "---------------< manual/cgi-bin >---------------"														>> ./$RES_LAST_FILE 2>&1
DocumentRoot_S=`cat $HTTPD_CONF | grep -v '#' | grep DocumentRoot | cut -f2 -d" " | sed 's/.//' | sed 's/.$//'`
echo $DocumentRoot_S																					>> ./$RES_LAST_FILE 2>&1
for dir in $DocumentRoot_S
do
echo $dir 																							>> ./$RES_LAST_FILE 2>&1
find $dir/../ -exec ls -d {} \; | egrep "manual|cgi-bin"                          				>> ./$RES_LAST_FILE 2>&1
done
echo }ahnlab} >> ./$RES_LAST_FILE 2>&1 
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  불필요한 파일 또는 기본 CGI 스크립트 파일이 존재 확인"											>> ./$RES_LAST_FILE 2>&1

echo "양호 : 불필요한 파일 또는 기본 CGI 스크립트 파일이 존재하지 않는 경우"									>> ./$RES_LAST_FILE 2>&1
echo "취약 : 불필요한 파일 또는 기본 CGI 스크립트 파일이 존재하는 경우"										>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE008 ##"
echo "##### WA-008 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-008 응답 메시지 헤더 정보 숨기기 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerTokens (설정파일) >---------------"												>> ./$RES_LAST_FILE 2>&1	
(cat $HTTPD_CONF | grep -v '#' | grep ServerTokens)														>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerTokens (extra/httpd-default.conf etc...)>---------------"								>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do 
if [ `cat $dir | grep -v '#' | grep "ServerTokens" | wc -l` -ge 1 ]; then
(cat $dir | grep -v '#' | grep "ServerTokens")													>> ./$RES_LAST_FILE 2>&1
fi
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerSignature (설정파일) >---------------"											>> ./$RES_LAST_FILE 2>&1	
(cat $HTTPD_CONF | grep -v '#' | grep ServerSignature)													>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerSignature (extra/httpd-default.conf etc...) >---------------"							>> ./$RES_LAST_FILE 2>&1	
for dir in $EXTRA_CONF_FILES
do 
if [ `cat $dir | grep -v '#' | grep "ServerSignature" | wc -l` -ge 1 ]; then
(cat $dir | grep -v '#' | grep "ServerSignature")												>> ./$RES_LAST_FILE 2>&1
fi
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  서버 시그니처 확인"																			>> ./$RES_LAST_FILE 2>&1

echo "양호 : ServerTokens가 Prod 또는 ProductOnly로 설정 되어있고, ServerSignature가 off로 설정 되어 있는 경우"		>> ./$RES_LAST_FILE 2>&1
echo "취약 : ServerTokens가 Prod 또는 ProductOnly로 설정이 안되어있고, ServerSignature가 off로 설정 안되어 있는 경우">> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE009 ##"
echo "##### WA-009 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-009 MultiViews 옵션 비활성화 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Options >---------------"															>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | grep -v IndexOptions | grep Options)									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Directory >---------------"															>> ./$RES_LAST_FILE 2>&1	
(cat $HTTPD_CONF | grep -v '#' | grep 'Directory ')														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< VirtualHost Directory>---------------"												>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do
if [ `cat $dir | grep -v '#' | grep "VirtualHost" | wc -l` -ge 1 ]; then
VHOST_START=`cat $dir | grep -v '#' | grep -n "<VirtualHost" | cut -d: -f1`
VHOST_END=`cat $dir | grep -v '#' | grep -n "</VirtualHost" | cut -d: -f1`
VHOST_CNT=`cat $dir | grep -v '#' | grep  -c -n "<VirtualHost"`
temp_cnt=1
for i in $VHOST_START
do
VHOST_START_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done
temp_cnt=1
for i in $VHOST_END
do
VHOST_END_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done

for ((i=1;i<=$VHOST_CNT;i++));
do
VHOST_NAME=`sed -n ${VHOST_START_ARRAY[$i]},1p $dir`
VHOST_EACH_INFO=`sed -n ${VHOST_START_ARRAY[$i]},${VHOST_END_ARRAY[$i]}p $dir | grep -v "IndexOption" | egrep "Options|Directory|ServerName"`
echo $VHOST_NAME																			>> ./$RES_LAST_FILE 2>&1
echo $VHOST_EACH_INFO																		>> ./$RES_LAST_FILE 2>&1
echo " "
echo " "
done
fi
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  서버 설정확인"																					>> ./$RES_LAST_FILE 2>&1

echo "양호 : MultiViews 설정 값이 없거나, -MultiViews 설정이 되어있는 경우 "								>> ./$RES_LAST_FILE 2>&1
echo "취약 : MultiViews 설정이어 있는 경우"																>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1






echo "## LINUX_APACHE010 ##"
echo "##### WA-010 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-010 HTTP Method 제한 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Limit 설정 >---------------"															>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | grep -v ServerLimit | grep Limit	)									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< TraceEnable >---------------"														>> ./$RES_LAST_FILE 2>&1	
(cat $HTTPD_CONF | grep -v '#' | grep 'TraceEnable ')													>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  불필요한 Method 제한되어있는지 확인"															>> ./$RES_LAST_FILE 2>&1

echo "양호 : TraceEnable Off 설정 되어 있고, Dav Off 설정되어 있는 경우 (Default 값 : Dav on) "				>> ./$RES_LAST_FILE 2>&1
echo "양호 : 'Limit', 'LimitExcept'에 PUT, DELETE 등 불필요한 메소드가 존재하지 않을 경우"					>> ./$RES_LAST_FILE 2>&1
echo "취약 : TraceEnable On 설정 되어 있고, Dav On 설정되어 있는 경우 (Default 값 : Dav on)"				>> ./$RES_LAST_FILE 2>&1
echo "취약 : 'Limit', 'LimitExcept'에 PUT, DELETE 등 불필요한 메소드가 존재할 경우"							>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE011 ##"
echo "##### WA-011 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-011 로그 설정 관리 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ErrorLog (설정파일)>---------------"													>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | grep ErrorLog)															>> ./$RES_LAST_FILE 2>&1
echo "---------------< ErrorLog (extra) >---------------"													>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do
if [ `cat $dir | grep -v '#' | grep "VirtualHost" | wc -l` -ge 1 ]; then
VHOST_START=`cat $dir | grep -v '#' | grep -n "<VirtualHost" | cut -d: -f1`
VHOST_END=`cat $dir | grep -v '#' | grep -n "</VirtualHost" | cut -d: -f1`
VHOST_CNT=`cat $dir | grep -v '#' | grep  -c -n "<VirtualHost"`
temp_cnt=1
for i in $VHOST_START
do
VHOST_START_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done
temp_cnt=1
for i in $VHOST_END
do
VHOST_END_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done

for ((i=1;i<=$VHOST_CNT;i++));
do
VHOST_NAME=`sed -n ${VHOST_START_ARRAY[$i]},1p $dir`
VHOST_EACH_INFO=`sed -n ${VHOST_START_ARRAY[$i]},${VHOST_END_ARRAY[$i]}p $dir | grep "ErrorLog"`
echo $VHOST_NAME																			>> ./$RES_LAST_FILE 2>&1
echo $VHOST_EACH_INFO																		>> ./$RES_LAST_FILE 2>&1
echo " "
echo " "
done
fi
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< CustomLog (설정파일) >---------------"												>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | grep CustomLog)														>> ./$RES_LAST_FILE 2>&1
echo "---------------< CustomLog (extra) >---------------"													>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do
if [ `cat $dir | grep -v '#' | grep "VirtualHost" | wc -l` -ge 1 ]; then
VHOST_START=`cat $dir | grep -v '#' | grep -n "<VirtualHost" | cut -d: -f1`
VHOST_END=`cat $dir | grep -v '#' | grep -n "</VirtualHost" | cut -d: -f1`
VHOST_CNT=`cat $dir | grep -v '#' | grep  -c -n "<VirtualHost"`
temp_cnt=1
for i in $VHOST_START
do
VHOST_START_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done
temp_cnt=1
for i in $VHOST_END
do
VHOST_END_ARRAY[$temp_cnt]=$i
temp_cnt=`expr $temp_cnt+1`
done

for ((i=1;i<=$VHOST_CNT;i++));
do
VHOST_NAME=`sed -n ${VHOST_START_ARRAY[$i]},1p $dir`
VHOST_EACH_INFO=`sed -n ${VHOST_START_ARRAY[$i]},${VHOST_END_ARRAY[$i]}p $dir | grep "CustomLog"`
echo $VHOST_NAME																			>> ./$RES_LAST_FILE 2>&1
echo $VHOST_EACH_INFO																		>> ./$RES_LAST_FILE 2>&1
echo " "
echo " "
done
fi
done
echo "----------< Combined가 없을 경우 LogFormat 부분 확인 >----------"           							>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | grep LogFormat)       														>> ./$RES_LAST_FILE 2>&1



echo "1.1  적절한 로그레벨을 사용하여 로깅하는지 확인"														>> ./$RES_LAST_FILE 2>&1

echo "양호 : 로그포맷 설정 값이 combined 이거나, 아래 LogFormat 지시어가 설정 되어 있을 경우"				>> ./$RES_LAST_FILE 2>&1
echo "      LogFormat %h %l %u %t \%r\ %>s %b \%{Referer}i\ \{User-agent}i\ "							>> ./$RES_LAST_FILE 2>&1
echo "취약 : 로그포맷 설정 값이 combined 이 아니거나, 아래 LogFormat 지시어가 설정 되어 있지 않은 경우"		>> ./$RES_LAST_FILE 2>&1
echo "      LogFormat %h %l %u %t \%r\ %>s %b \%{Referer}i\ \{User-agent}i\ "							>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE012 ##"
echo "##### WA-012 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-012 파일 업로드 및 다운로드 제한 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
if [ `grep -n -i options $HTTPD_CONF | grep -v '#' | grep -i limitrequestbody | wc -l` -ge 1 ]; then
echo "@ OK"																						>> ./$RES_LAST_FILE 2>&1
grep -n -i limitrequestbody $HTTPD_CONF | grep -v '#'											>> ./$RES_LAST_FILE 2>&1
else
echo "No limit capacity to upload and download"													>> ./$RES_LAST_FILE 2>&1
fi
echo " " 																									>> ./$RES_LAST_FILE 2>&1	
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  파일 업로드 및 다운로드 용량제한 확인"															>> ./$RES_LAST_FILE 2>&1

echo "양호 : limitrequestbody 를 통해 파일 업로드 및 다운로드 용량을 제한하는 경우"							>> ./$RES_LAST_FILE 2>&1
echo "취약 : 파일 업로드 및 다운로드 용량이 제한없는 경우"													>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE013 ##"
echo "##### WA-013 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-013 웹 서비스 영역의 분리 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
grep -i "documentroot" $HTTPD_CONF | grep -v '#' |awk '{print$2}'  > u-58.txt
if [ $INCLUDE_FLAG -ge 1 ]; then
for dir in $EXTRA_CONF_FILES
do
grep -i "documentroot" $dir | grep -v '#'| awk '{print $2}'  > u-59.txt
done
fi


if [ `cat u-58.txt | grep '$HTTPD_ROOT' | wc -l` -eq 1 ]; then
echo "DocumentRoot exists in the installation directory of Apache."								>> ./$RES_LAST_FILE 2>&1
else
echo "@ Httpd.conf DocumentRoot OK"                												>> ./$RES_LAST_FILE 2>&1 
fi
if [ `cat u-59.txt | grep '$HTTPD_ROOT' | wc -l` -eq 1 ]; then
echo "VirtualHost DocumentRoot exists in the installation directory of Apache" 					>> ./$RES_LAST_FILE 2>&1
else
echo "@ VirtualHost DocumentRoot OK"															>> ./$RES_LAST_FILE 2>&1			
fi
echo "HTTPD_ROOT=`ls -ald $HTTPD_ROOT`"																>> ./$RES_LAST_FILE 2>&1
echo " " 																							>> ./$RES_LAST_FILE 2>&1
echo "DOCUMENTROOT=`cat u-58.txt`"																	>> ./$RES_LAST_FILE 2>&1
echo "VirtualHOST DocumentRoot=`cat u-59.txt`"  													>> ./$RES_LAST_FILE 2>&1

echo "1.1  웹 서비스를 위한 파일들이 서버 데몬과 다른 공간에 존재하는지 확인"									>> ./$RES_LAST_FILE 2>&1

echo "양호 : 웹 서비스 파일과 Apache 데몬이 다른 영역이 분리 되어 있을 경우"									>> ./$RES_LAST_FILE 2>&1
echo "취약 : 웹 서비스 파일과 Apache 데몬이 다른 영역이 분리 안되어 있을 경우"								>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
rm -rf u-58.txt
rm -rf u-59.txt






echo "## LINUX_APACHE014 ##"
echo "##### WA-014 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-014 상위 디렉터리 접근 금지 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "##### allowoveride #####"																			>> ./$RES_LAST_FILE 2>&1

echo "---------------< 설정파일 >---------------"														>> ./$RES_LAST_FILE 2>&1
cat $HTTPD_CONF | grep -v '#' | grep -i allowoverride													>> ./$RES_LAST_FILE 2>&1

echo "양호 : allowoveride가 None 또는 authconfig로 설정되어있는 경우"										>> ./$RES_LAST_FILE 2>&1
echo "취약 : allowoveride가 양호 이외에 다른 값으로 설정된 경우"											>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE015 ##"
echo "##### WA-015 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-015 에러 메시지 관리 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ErrorDocument >---------------"														>> ./$RES_LAST_FILE 2>&1	
(cat $HTTPD_CONF | grep ErrorDocument | grep -v '#'	)													>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do
if [ `cat $dir | grep -v '#' | egrep "ErrorDocument" | wc -l` -ge 1 ]; then
(cat $dir | grep -v '#' | grep ErrorDocument)                                     				>> ./$RES_LAST_FILE 2>&1
fi
done

echo "1.1  기본 에러페이지가 아닌 사용자 지정의 에러페이지를 사용하는지 확인"									>> ./$RES_LAST_FILE 2>&1

echo "양호 : [1],[2] 설정 모두 했을 경우"																	>> ./$RES_LAST_FILE 2>&1
echo "		+ [1] 결과값에서 ErrorDocument 설정이 되어 있을 경우"											>> ./$RES_LAST_FILE 2>&1
echo "		+ [2] [1]의 에러페이지 경로에 있는 파일이 있을 경우"											>> ./$RES_LAST_FILE 2>&1
echo "취약 : [1],[2] 설정 중 하나라도 미흡할 경우"															>> ./$RES_LAST_FILE 2>&1
echo "		+ [1] 결과값에서 ErrorDocument 설정이 안되어 있을 경우"										>> ./$RES_LAST_FILE 2>&1
echo "		+ [2] [1]의 url 경로에 있는 파일이 없을 경우"													>> ./$RES_LAST_FILE 2>&1

echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1



echo "## LINUX_APACHE016 ##"
echo "##### WA-016 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-016 최신 패치 적용 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
$HTTP_CONF -v								 															>> ./$RES_LAST_FILE 2>&1
$APACHE_CONF -v 																						>> ./$RES_LAST_FILE 2>&1
apachectl -v								 															>> ./$RES_LAST_FILE 2>&1

echo "1.1  최신보안패치 적용확인"																			>> ./$RES_LAST_FILE 2>&1

echo "양호 : 주기적으로 패치를 적용하는 경우"																>> ./$RES_LAST_FILE 2>&1
echo "취약 : 주기적으로 패치를 미적용하는 경우"																>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "================== ETC ========================"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "##### 설정파일(cat httpd.conf) ###############"														>> ./$RES_LAST_FILE 2>&1														>> ./$RES_LAST_FILE 2>&1
cat $HTTPD_CONF 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "##### 외부 설정파일 (find *.conf) ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do
echo $dir 																							>> ./$RES_LAST_FILE 2>&1
cat $dir  																							>> ./$RES_LAST_FILE 2>&1
echo " "																							>> ./$RES_LAST_FILE 2>&1
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "================== End of Script ========================"											>> ./$RES_LAST_FILE 2>&1
echo " "
date																										>> ./$RES_LAST_FILE 2>&1

chmod 400 ./$RES_LAST_FILE

echo " "
echo " ** End_Time:" `date`
echo " "
echo " "

exit 0