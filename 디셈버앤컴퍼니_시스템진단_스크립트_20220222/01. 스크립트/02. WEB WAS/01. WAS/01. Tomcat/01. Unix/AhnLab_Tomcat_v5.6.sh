
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
OS_TYPE=TOMCAT_LINUX

#####################################
## file name 
#####################################
RES_LAST_FILE=${OS_TYPE}_${IP}_${HOSTNAME}_${DATE}.asvd

#####################################
## Httpd Running Check Set Environment Variables
#####################################

TOMCAT_DIR_INFO=`ps -ef | grep catalina | grep -v grep`
for dir in $TOMCAT_DIR_INFO
do
	if [ `echo $dir | awk -F'=' '{print $1}'` = -Dcatalina.home ]; then
		TOMCAT_DIR=`echo $dir | awk -F'=' '{print $2}'`
	fi
done


TOMCAT_DIR_CONFIG=`find $TOMCAT_DIR/ -name server.xml`
TOMCAT_WEB_CONFIG=`find $TOMCAT_DIR/conf/ -name web.xml`


if [ ! -d $TOMCAT_DIR ]; then
	echo ""
	echo "********************* ERROR *********************"
	echo " Can not find the location of a Tomcat ServerRoot Directory"
	echo " Please enter the full path to the Tomcat ServerRoot Directory"
	echo "********************* ERROR *********************"
	echo ""
	echo "Write full path to the Tomcat ServerRoot Directory under here"
	read TOMCAT_DIR
	echo ""
	if [ ! -d $TOMCAT_DIR ]; then
		echo ""
		echo "******************* ERROR *******************"
		echo "*** Was entered incorrectly. Please re-run"
		echo "******************* ERROR *******************"
		echo ""
		exit 0
	fi
fi

HOSTNAME=`hostname`
DATE=`date +%Y-%m-%d`
FILENAME=Tomcat_${HOSTNAME}_${DATE}

appbase=`cat $TOMCAT_DIR_CONFIG | grep appBase | awk -F'Base' '{print $2}' | awk -F'"' '{print $2}'`
echo "appbase : "$appbase



#log_num=`cat $TOMCAT_DIR/conf/server.xml | grep -v '!--' | grep -n ' ' | grep AccessLog | awk -F':' '{print $1}'`
#log_num=$((log_num+1))
echo SYSTEM LINUX TOMCAT HeaderInfo {ahnlab{ >> ./$RES_LAST_FILE 2>&1 

echo -e " ** ASVD_INFO: 4 LINUX APACHE" >> ./$RES_LAST_FILE 2>&1
echo -e " ** Start_time:\t\t" `date` >> ./$RES_LAST_FILE 2>&1
echo -e " ** HOSTNAME:\t\t " $HOSTNAME >> ./$RES_LAST_FILE 2>&1
echo -e " ** IP ADDRESS:\t\t " $IP >> ./$RES_LAST_FILE 2>&1
echo -e " ** OS TYPE:\t\t " $OS_TYPE >> ./$RES_LAST_FILE 2>&1
echo -e " ** OS VERSION:\t\t " `$OS_VERSION` >> ./$RES_LAST_FILE 2>&1
echo }ahnlab} >> ./$RES_LAST_FILE 2>&1

echo ""	>> ./$RES_LAST_FILE 2>&1
echo "" >> ./$RES_LAST_FILE 2>&1

echo "****************************************************************"				>> ./$RES_LAST_FILE 2>&1
echo "****** AhnLab System Checklist for Tomcat Server *********"				>> ./$RES_LAST_FILE 2>&1
echo "******** Copyright 2014 Ahnlab. All right Reserved *********"				>> ./$RES_LAST_FILE 2>&1
echo "****************************************************************"				>> ./$RES_LAST_FILE 2>&1

echo "* Start Time "							                      	>> ./$RES_LAST_FILE 2>&1
date 							                               	>> ./$RES_LAST_FILE 2>&1
echo " "						                             		>> ./$RES_LAST_FILE 2>&1


echo "## LINUX_TOMCAT001 ##"
echo "##### WC-001 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-001 프로세스 권한 제한 ###############"														>> ./$RES_LAST_FILE 2>&1
echo "---------------< 프로세스 >---------------"															>> ./$RES_LAST_FILE 2>&1
echo " " 																								>> ./$RES_LAST_FILE 2>&1
ps -ef | grep java | grep catalina | grep -v "grep"	 													>> ./$RES_LAST_FILE 2>&1
echo " " 																								>> ./$RES_LAST_FILE 2>&1
cat /etc/passwd									 														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  프로세스가 root 로 구동되는지 확인"																>> ./$RES_LAST_FILE 2>&1

echo "양호 : 전용 WAS 계정으로 서비스가 구동되는 경우"														>> ./$RES_LAST_FILE 2>&1
echo "취약 : 전용 WAS 계정으로 서비스가 구동되지 않은 경우"													>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_TOMCAT002 ##"
echo "##### WC-002 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-002 디렉터리 권한 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< 관리서버 홈 디렉터리 ($TOMCAT_DIR/webapps) >---------------"							>> ./$RES_LAST_FILE 2>&1
ls -alLF $TOMCAT_DIR/webapps/ | grep -i manager											 				>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo '---------------< 웹 서버 홈 디렉터리 ($TOMCAT_DIR/$appbase) >---------------'							>> ./$RES_LAST_FILE 2>&1
echo 'appBase :' $appbase																				>> ./$RES_LAST_FILE 2>&1
echo $dir 																								>> ./$RES_LAST_FILE 2>&1
ls -alLR $TOMCAT_DIR/$dir						 														>> ./$RES_LAST_FILE 2>&1
ls -alLR $dir 																							>> ./$RES_LAST_FILE 2>&1

echo "1.1  각 Tomcat 관련 디렉토리의 권한 설정 확인"														>> ./$RES_LAST_FILE 2>&1

echo "양호 : 디렉터리 소유자가 전용 WAS 계정이고, 권한이 755(drwxr-xr-x) 이하일 경우"						>> ./$RES_LAST_FILE 2>&1
echo "취약 : 디렉터리 소유자가 전용 WAS 계정이 아니거나, 권한이 755(drwxr-xr-x) 보다 높을 경우"				>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1



echo "## LINUX_TOMCAT003 ##"
echo "##### WC-003 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-003 소스/설정파일 권한 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< 1.1 설정파일 ($TOMCAT_DIR/conf) >---------------"										>> ./$RES_LAST_FILE 2>&1
ls -alLRF $TOMCAT_DIR/conf/*.xml *.properties *.policy								 					>> ./$RES_LAST_FILE 2>&1

echo "---------------< 1.2 소스파일 ($TOMCAT_DIR/$appbase) >---------------"									>> ./$RES_LAST_FILE 2>&1
echo "appbase : "$appbase																				>> ./$RES_LAST_FILE 2>&1
ls -alLR $TOMCAT_DIR/$appbase								 											>> ./$RES_LAST_FILE 2>&1

echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "1.1  설정파일 권한 확인"																			>> ./$RES_LAST_FILE 2>&1
echo "1.2  소스파일 권한 확인"																			>> ./$RES_LAST_FILE 2>&1

echo "양호 : 소스 파일 소유자가 전용 WAS 계정이고, 권한이 754(-rwxr-xr--) 이하일 경우 "						>> ./$RES_LAST_FILE 2>&1
echo "       설정 파일 소유자가 전용 WAS 계정이고, 권한이 700(-rwx------) 이하일 경우"						>> ./$RES_LAST_FILE 2>&1
echo "취약 : 소스 파일 소유자가 전용 WAS 계정이 아니거나, 권한이 754(-rwxr-xr--) 보다 높을 경우"				>> ./$RES_LAST_FILE 2>&1
echo "       설정 파일 소유자가 전용 WAS 계정이 아니거나, 권한이 700(-rwx------) 보다 높을 경우"				>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_TOMCAT004 ##"
echo "##### WC-004 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-004 패스워드 파일 권한 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
ls -al $TOMCAT_DIR/conf/tomcat-users.xml	 															>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  패스워드 파일 권한 설정"																		>> ./$RES_LAST_FILE 2>&1

echo "양호 : 디렉터리 소유자가 전용 WAS 계정이고, 권한이 750(-rwxr-x---) 이하일 경우 "						>> ./$RES_LAST_FILE 2>&1
echo "      파일 소유자가 전용 WAS 계정이고, 권한이 640(-rw-r-----) 이하일 경우"							>> ./$RES_LAST_FILE 2>&1
echo "취약 : 디렉터리 소유자가 전용 WAS 계정이 아니거나, 권한이 750(-rwxr-x---) 보다 높을 경우"				>> ./$RES_LAST_FILE 2>&1
echo "       파일 소유자가 전용 WAS 계정이 아니거나, 권한이 640(-rw-r-----) 보다 높을 경우"					>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1






echo "## LINUX_TOMCAT005 ##"
echo "##### WC-005 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-005 로그 디렉터리/파일 권한 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< 로그 디렉터리 >---------------"														>> ./$RES_LAST_FILE 2>&1
ls -alF $TOMCAT_DIR/ | grep logs							 											>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< 로그 파일 >---------------"															>> ./$RES_LAST_FILE 2>&1
ls -alF $TOMCAT_DIR/logs/								 												>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< log etc. >---------------"															>> ./$RES_LAST_FILE 2>&1
cat $TOMCAT_DIR_CONFIG | grep -v '!--' | grep -n ' ' | grep AccessLog | awk -F':' '{print $2}' 			>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1



echo "1.1  로그 디렉터리 및 파일 권한설정"																	>> ./$RES_LAST_FILE 2>&1

echo "양호 : 디렉터리 소유자가 전용 WAS 계정이고, 권한이 750(-rwxr-x---) 이하일 경우 "						>> ./$RES_LAST_FILE 2>&1
echo "      파일 소유자가 전용 WAS 계정이고, 권한이 640(-rw-r-----) 이하일 경우"							>> ./$RES_LAST_FILE 2>&1
echo "취약 : 디렉터리 소유자가 전용 WAS 계정이 아니거나, 권한이 750(-rwxr-x---) 보다 높을 경우"				>> ./$RES_LAST_FILE 2>&1
echo "       파일 소유자가 전용 WAS 계정이 아니거나, 권한이 640(-rw-r-----) 보다 높을 경우"					>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_TOMCAT006 ##"
echo "##### WC-006 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-006 관리 콘솔 보안 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
cat $TOMCAT_DIR/conf/server.xml | grep -i "connector port"												>> ./$RES_LAST_FILE 2>&1  																					>> ./$RES_LAST_FILE 2>&1


echo "양호 : 관리자 콘솔을 사용하지 않거나 사용하고 Default Port(8080)을 사용하지 않는 경우"					>> ./$RES_LAST_FILE 2>&1
echo "취약 : 관리자 콘솔을 사용하고, Default port(8080)을 사용하는 경우"									>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_TOMCAT007 ##"
echo "##### WC-007 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-007 디렉터리 리스팅 제거 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
for dir in $TOMCAT_WEB_CONFIG
do
listing_num=`cat $dir | grep -v '!--' | grep -n ' ' | grep listing | awk -F':' '{print $1}'`
listing_num=$((listing_num+1))
echo $dir 																							>> ./$RES_LAST_FILE 2>&1
(cat $dir|grep -v '!--'|grep -n ' '|grep listing|awk -F':' '{print $2}') 							>> ./$RES_LAST_FILE 2>&1
(cat $dir|grep -v '!--'|grep -n ' '|grep $listing_num|head -1|awk -F':' '{print $2}') 				>> ./$RES_LAST_FILE 2>&1

(cat $TOMCAT_DIR/$dir |grep -v '!--'|grep -n ' '|grep listing|awk -F':' '{print $2}')				>> ./$RES_LAST_FILE 2>&1
(cat $TOMCAT_DIR/$dir |grep -v '!--'|grep -n ' '|grep $listing_num|head -1|awk -F':' '{print $2}') 	>> ./$RES_LAST_FILE 2>&1
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  디렉토리 리스팅 설정 사용하는지 확인"															>> ./$RES_LAST_FILE 2>&1

echo "양호 : <param-name>listings</param-name>값이 <param-value>false</param-value>일 경우"				>> ./$RES_LAST_FILE 2>&1
echo "취약 : <param-name>listings</param-name>값이 <param-value>true</param-value>일 경우"				>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1






echo "## LINUX_TOMCAT008 ##"
echo "##### WC-008 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-008 관리자 계정 이름 변경 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
cat $TOMCAT_DIR/conf/tomcat-users.xml	 										         				>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  기본으로 생성되는 관리자 제거"																	>> ./$RES_LAST_FILE 2>&1

echo "양호 : 기본 관리자 계정정보(tomcat/tomcat) 또는 유추 가능한 계정정보를 사용하지 않거나, 불필요한 Role이 제거되었을 경우 Tomcat 7.x 이상은 Default 계정이 주석처리되어 있음"													>> ./$RES_LAST_FILE 2>&1
echo "취약 : 기본 관리자 계정정보(tomcat/tomcat) 또는 유추 가능한 계정정보를 사용하거나, 불필요한 Role이 적용되었을 경우"	>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_TOMCAT009 ##"
echo "##### WC-009 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-009 패스워드 복잡성 설정 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
cat $TOMCAT_DIR/conf/tomcat-users.xml	 										         				>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  관리자 패스워드 복잡도 확인"																	>> ./$RES_LAST_FILE 2>&1

echo "양호 : 당사 패스워드 정책에 맞게 설정되어 있을 경우"													>> ./$RES_LAST_FILE 2>&1
echo "취약 : 당사 패스워드 정책에 맞게 설정되지 않았을 경우"												>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_TOMCAT010 ##"
echo "##### WC-010 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-010 Examples 디렉터리 삭제 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
ls -alF $TOMCAT_DIR/webapps/								 											>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  서비스에 불필요한 파일 또는 기본으로 생성되는 파일 존재여부 확인"									>> ./$RES_LAST_FILE 2>&1

echo "양호 : sample 및 manual 디렉토리가 없는 경우"														>> ./$RES_LAST_FILE 2>&1
echo "취약 : sample 혹은 manaul 디렉토리가 있을 경우"														>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_TOMCAT011 ##"
echo "##### WC-011 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-011 에러 메시지 관리 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
for dir in $TOMCAT_WEB_CONFIG
do
	cat $dir | grep -i error																			>> ./$RES_LAST_FILE 2>&1
	cat $TOMCAT_DIR/$dir | grep -i error																>> ./$RES_LAST_FILE 2>&1
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  기본 에러페이지가 아닌 사용자 지정의 에러페이지를 사용하는지 확인"									>> ./$RES_LAST_FILE 2>&1

echo "양호 : 에러 메세지 설정 및 에러페이지가 존재할 경우 "													>> ./$RES_LAST_FILE 2>&1
echo "취약 : 에러 메세지 설정 및 에러페이지가 존재하지 않을 경우 "											>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1



echo "## LINUX_TOMCAT012 ##"
echo "##### WC-012 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-012 프로세스 관리 기능 삭제 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
find $TOMCAT_DIR -name *.jar | grep catalina-manager.jar							 					>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  불필요한 프로세스 관리 기능 삭제"																>> ./$RES_LAST_FILE 2>&1

echo "양호 : catalina-manager.jar 파일이 존재하지 않을 경우"												>> ./$RES_LAST_FILE 2>&1
echo "취약 : catalina-manager.jar 파일이 존재할 경우"														>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_TOMCAT013 ##"
echo "##### WC-013 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WC-013 최신 패치 적용 ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
sh $TOMCAT_DIR/bin/version.sh								 											>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "1.1  최신보안패치 적용확인"																			>> ./$RES_LAST_FILE 2>&1

echo "양호 : 주기적으로 패치를 적용하는 경우"																>> ./$RES_LAST_FILE 2>&1
echo "취약 : 주기적으로 패치를 미적용하는 경우"																>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "================== ETC (홈디렉터리/web.xml/server.xml) ========================"						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "##### Tomcat 홈디렉터리 ###############"																>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
ls -al $TOMCAT_DIR 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "##### $TOMCAT_DIR/conf/web.xml ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
cat $TOMCAT_WEB_CONFIG																					>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1


echo "##### $TOMCAT_DIR/conf/server.xml ###############"													>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
cat $TOMCAT_DIR_CONFIG																					>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "##### /etc(ls -al /etc) ###############"																>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
ls -al /etc																								>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "##### /var/log(ls -al /var/log) ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
ls -al /var/log																							>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "##### /var/lib(ls -al /var/lib/tomcat) ###############"												>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
ls -al /var/lib/tom*																					>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "##### /var/lib(ls -al /var/lib/tomcat) ###############"												>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
ls -alR /var/lib/tom*																					>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo " "
echo "Finish System Check."
date
echo " "


exit 0