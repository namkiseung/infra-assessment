
#!/bin/sh

LANG=C
export LANG
CREATE_FILE_RESULT=`hostname`"_"`date +%m%d`"_weblogic.txt"

#
# Weblogic unix script to check 취약
#
# Copyright (c) 2018 by think Co, Inc.
# All rights reserved
#

# 

echo ""
echo "###########################################################################"
echo "#        Copyright (c) 2018 think Co. Ltd. All Rights Reserved.         #"
echo "###########################################################################"
echo ""

if [ `uname | grep SunOS | wc -l` -ge 1 ]; then # 솔라리스일 경우
	AWK=/usr/xpg4/bin/awk
else
	AWK=awk
fi

echo ""
echo "################# Weblogic 진단 스크립트를 실행하겠습니다 ###################"
echo ""
echo ""

alias ls=ls
alias grep=/bin/grep
echo "******************************Weblogic 구동**********************************" 
ps -ef |grep -i start|grep -i weblogic
echo "*****************************************************************************" 
echo ""
echo "  Weblogic 설치 디렉터리(도메인까지)를 입력하십시오. "
while true
do 
   echo -n "    (ex. /export/home/weblogic/bea/user_projects/domains/mydomain) " 
   read weblogic
   if [ $weblogic ]
      then
         if [ -d $weblogic ]
            then 
               break
            else
               echo "   입력하신 디렉터리가 존재하지 않습니다. 다시 입력하여 주십시오."
               echo " "
         fi
    else
         echo "   잘못 입력하셨습니다. 다시 입력하여 주십시오."
         echo " "
   fi
done
echo " "

echo "  관리 디렉터리(도메인까지)를 입력하십시오. "
while true
do 
   echo -n "    (ex. /export/home/weblogic/wlserver_10.X.) " 
   read sbase
   if [ $sbase ]
      then
         if [ -d $sbase ]
            then 
               break
            else
               echo "   입력하신 디렉터리가 존재하지 않습니다. 다시 입력하여 주십시오."
               echo " "
         fi
    else
         echo "   잘못 입력하셨습니다. 다시 입력하여 주십시오."
         echo " "
   fi
done
echo " "

####Weblogic

config=$weblogic/config
bin2=$weblogic/bin
security2=$weblogic/security


echo "****************************** Start **********************************" 
echo '0101 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.1 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.1 데몬 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '구동 계정이 root가 아니면 양호처리 함, 다만 로그인이 불가능한 daemon, nobody와 같은 계정으로 사용하도록 권고함' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
ps -ef |grep start |grep -i weblogic >> $CREATE_FILE_RESULT 2>&1
echo '| 포트 |' >> $CREATE_FILE_RESULT 2>&1
cat $config/config.xml |grep listen >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '| 구동 |' >> $CREATE_FILE_RESULT 2>&1
if [ `ps -ef |grep start |grep -i weblogic|grep root|wc -l` -eq 0 ]
	then 
	echo 'ROOT계정으로 실행되는 Weblogic이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	echo Result='S'  >> $CREATE_FILE_RESULT 2>&1
else
	ps -ef |grep start |grep -i weblogic|grep root >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	echo Result='F'  >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0101 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0102 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.2 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.2 관리서버 디렉터리 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '관리 서버 750이하의 퍼미션이 부여되어있지 않으면 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
echo '| 관리 서버 |'  $sbase >> $CREATE_FILE_RESULT 2>&1
ls -al $sbase |grep 'd.........'|head -1 >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
if [ `ls -al $sbase |grep 'd.........'|head -1|grep -v '.....-....'|wc -l` -eq 0 ]
	then
	echo Result='S'  >> $CREATE_FILE_RESULT 2>&1
else
	echo Result='F'  >> $CREATE_FILE_RESULT 2>&1
fi	
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0102 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0103 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.3 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.3 설정파일 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '설정파일 600이하의 퍼미션이 부여되어있지 않으면 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
echo '| 설정파일 퍼미션 |' >> $CREATE_FILE_RESULT 2>&1
if [ \( `ls -al $config |grep 'd.........'|head -1 |grep -v 'd...------'|wc -l` -eq 0 \) -a \( `ls -al $bin2 |grep 'd.........'|head -1 |grep -v 'd...------'|wc -l` -eq 0 \) -a \( `ls -al $security2 |grep 'd.........'|head -1 |grep -v 'd...------'|wc -l` -eq 0 \) ]
	then
	echo '설정파일 퍼미션이 양호임' >> $CREATE_FILE_RESULT 2>&1 
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	echo Result='S'  >> $CREATE_FILE_RESULT 2>&1
else
	if [ \( `ls -al $config |grep -v 'd.........'|grep '..........'|grep -v '....------'|wc -l` -eq 0 \) -a \( `ls -al $bin2 |grep -v 'd.........'|grep '..........'|grep -v '....------'|wc -l` -eq 0 \) -a \( `ls -al $security2 |grep -v 'd.........'|grep '..........'|grep -v '....------'|wc -l` -eq 0 \) ]
		then
		echo '설정파일 퍼미션이 양호임' >> $CREATE_FILE_RESULT 2>&1 
		echo ' ' >> $CREATE_FILE_RESULT 2>&1
		echo Result='S'  >> $CREATE_FILE_RESULT 2>&1
	else
		echo '(1) config 디렉터리 취약 파일' >> $CREATE_FILE_RESULT 2>&1
		ls -al $config |grep '..........' >> $CREATE_FILE_RESULT 2>&1 
		echo ' ' >> $CREATE_FILE_RESULT 2>&1
		echo '(2) bin 디렉터리 취약 파일' >> $CREATE_FILE_RESULT 2>&1
		ls -al $bin2 |grep '..........' >> $CREATE_FILE_RESULT 2>&1 
		echo ' ' >> $CREATE_FILE_RESULT 2>&1
		echo '(3) security 디렉터리 취약 파일' >> $CREATE_FILE_RESULT 2>&1
		ls -al $security2 |grep '..........' >> $CREATE_FILE_RESULT 2>&1 
		echo ' ' >> $CREATE_FILE_RESULT 2>&1
		echo Result='F'  >> $CREATE_FILE_RESULT 2>&1
	fi
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0103 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0104 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.4 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.4 디렉토리 검색 기능 제거'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'plan.xml에서 indexDirectoryEnabled 설정이 false면 양호 (설정이 없을 경우도 양호)' >> $CREATE_FILE_RESULT 2>&1
echo 'plan.xml이 없는 경우 weblogic.xml에서 indexDirectoryEnabled 설정이 false면 양호 (설정이 없을 경우도 양호)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
Plan_path=`cat $config/config.xml | grep "plan-path" | $AWK -F 'plan-path>' '{print$2}' | $AWK -F '</' '{print$1}'`
weblogic_path_find=`find $weblogic -name weblogic.xml 2> /dev/null`

count=0

if [ `cat $config/config.xml | grep "<plan-path>" | wc -l` -ge 1 ]; then
	#plan-path가 모든 container에 존재할 경우
	if [ `cat $config/config.xml | grep "<plan-path>" | wc -l` = `cat $config/config.xml | grep "<app-deployment>" | wc -l` ]; then
		for Plan in $Plan_path; do
		echo "☞ "$Plan' 내용 확인' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $Plan | grep -i "index" | grep -i "directory" 2> /dev/null | wc -l` -ge 1 ]; then
			cat $Plan | grep -i "index" | grep -i "directory"  >> $CREATE_FILE_RESULT 2>&1
		else
			echo '해당 설정 값이 없음 ' >> $CREATE_FILE_RESULT 2>&1
		fi
		done
	
	else
		for Plan in $Plan_path; do
		echo "☞ "$Plan' 내용 확인' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $Plan | grep -i "index" | grep -i "directory" 2> /dev/null | wc -l` -ge 1 ]; then
			cat $Plan | grep -i "index" | grep -i "directory"   >> $CREATE_FILE_RESULT 2>&1
		else
			echo '해당 설정 값이 없음 ' >> $CREATE_FILE_RESULT 2>&1
		fi
		done

		for weblogic_path in $weblogic_path_find; do
		echo "☞ "$weblogic_path' 내용 확인' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $weblogic_path | grep -i "index" | grep -i "directory" | wc -l` -ge 1 ]; then
			cat $weblogic_path | grep -i "index" | grep -i "directory"   >> $CREATE_FILE_RESULT 2>&1
		else
			echo '해당 설정 값이 없음 ' >> $CREATE_FILE_RESULT 2>&1
		fi
		done
	fi

else
	for weblogic_path in $weblogic_path_find; do
		echo "☞ "$weblogic_path' 내용 확인' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $weblogic_path | grep -i "index" | grep -i "directory" | wc -l` -ge 1 ]; then
			cat $weblogic_path | grep -i "index" | grep -i "directory"   >> $CREATE_FILE_RESULT 2>&1
		else
			echo '해당 설정 값이 없음 ' >> $CREATE_FILE_RESULT 2>&1
		fi
	done
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result="M/T"  >> $CREATE_FILE_RESULT 2>&1
echo '0104 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0105 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.5 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.5 로그 디렉터리/파일 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'Log의 경로 확인 후 해당 디렉터리에 750이하, 파일에 640이하의 퍼미션이 부여되어있지 않으면 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
echo '| Log 경로 설정 |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml|grep -i 'log'|grep -i 'filename'|wc -l` -eq 0 ] 
	then
	echo 'config.xml파일안에 Log설정이 되어 있지 않음.' >> $CREATE_FILE_RESULT 2>&1
else
	echo 'config.xml파일안에 Log설정 퍼미션은 수동으로 확인하시기 바랍니다.' >> $CREATE_FILE_RESULT 2>&1
	echo '' >> $CREATE_FILE_RESULT 2>&1

	echo '| config.xml Log설정 |' >> $CREATE_FILE_RESULT 2>&1
	cat $config/config.xml|grep -i 'log'|grep -i 'filename' >> $CREATE_FILE_RESULT 2>&1
fi
echo '' >> $CREATE_FILE_RESULT 2>&1


echo '| Log 디렉토리 |' >> $CREATE_FILE_RESULT 2>&1
if [ `find $weblogic -name logs|wc -l` -eq 0 ]
	then
	echo '로그 디렉토리가 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
else
	find $weblogic -name logs -exec ls -al {} \; >> $CREATE_FILE_RESULT 2>&1
	echo '' >> $CREATE_FILE_RESULT 2>&1

	echo '| Log 디렉토리 퍼미션 |' >> $CREATE_FILE_RESULT 2>&1
	if [ `find $weblogic -name logs -exec ls -al {} \;|grep 'dr........'|grep -v '.....-.---'|wc -l` -eq 0 ]
		then
		echo '취약한 Log 디렉토리가 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	else
		find $weblogic -name logs -exec ls -al {} \;|grep 'dr........'|grep -v '.....-----' >> $CREATE_FILE_RESULT 2>&1
	fi
fi
echo '' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0105 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '0106 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.6 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.6 로그 포맷 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '내부 규정에 따라 필요한 지시자를 포함하여 로그 포맷을 설정하고 있지 않은 경우 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
echo '관리자 페이지를 통해 로그 포맷 extended 설정 및 지시자 설정 여부 확인 필요 (수동점검)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0106 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '0107 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.7 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.7 로그 저장 주기'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '로그를 지침에 맞게 저장 및 관리하지 않은 경우 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
echo '담당자와 인터뷰를 통해 로그 보관 및 관리 현황 파악 필요 (수동점검)' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0107 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0108 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.8 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.8 헤더 정보 노출 방지'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'Send Server Header 설정 값이 없거나 false로 되어 있고 x-powered-by-header-level 설정 값이 NONE으로 된 경우 양호로 처리함.' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
echo '(1) <send-server-header-enabled> 값 확인' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep "send" | wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음 (Default로 양호임)' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml | grep "send" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '(2) <x-powered-by-header-level> 값 확인' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep "power" | wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음 (Default 값은 SHORT로 취약임)' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml | grep "power" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0108 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0109 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.9 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.9 HTTP Method 제한 '  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'HTTP Method가 제한되어 있지 않은 경우 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
web_path_find=`find $weblogic -name web.xml 2> /dev/null`
if [ `echo $web_path_find | wc -l` -ge 1 ]; then
	for web_path in $web_path_find; do
		echo "☞ "$web_path' 내용 확인' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $web_path | grep -i "http-method" | wc -l` -ge 1 ]; then
			cat $web_path | grep -i "http-method" >> $CREATE_FILE_RESULT 2>&1
			echo '' >> $CREATE_FILE_RESULT 2>&1
		else
			echo 'Comment not found' >> $CREATE_FILE_RESULT 2>&1
		fi
	done
else
	echo 'web.xml 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0109 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0110 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.10 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.10 Session Timeout 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'web.xml은 30이하 양호(분 단위), weblogic.xml은 1800이하 양호(초 단위)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&11
echo '(1) web.xml 확인' >> $CREATE_FILE_RESULT 2>&1
web_path_find=`find $weblogic -name web.xml 2> /dev/null`
if [ `echo $web_path_find | wc -l` -ge 1 ]; then
	for web_path in $web_path_find; do
		echo "☞ "$web_path' 내용 확인' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $web_path | grep -i "session-timeout" | wc -l` -ge 1 ]; then
			cat $web_path | grep -i "session-timeout" >> $CREATE_FILE_RESULT 2>&1
			echo '' >> $CREATE_FILE_RESULT 2>&1
		else
			echo 'Comment not found' >> $CREATE_FILE_RESULT 2>&1
		fi
	done
else
	echo 'web.xml 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '(2) weblogic.xml 확인' >> $CREATE_FILE_RESULT 2>&1
weblogic_path_find=`find $weblogic -name weblogic.xml 2> /dev/null`
if [ `echo $weblogic_path_find | wc -l` -ge 1 ]; then
	for weblogic_path in $weblogic_path_find; do
		echo "☞ "$web_path' 내용 확인' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $weblogic_path | grep -i "timeout-secs" | wc -l` -ge 1 ]; then
			cat $web_path | grep -i "timeout-secs" >> $CREATE_FILE_RESULT 2>&1
			echo '' >> $CREATE_FILE_RESULT 2>&1
		else
			echo 'Comment not found' >> $CREATE_FILE_RESULT 2>&1
		fi
	done
else
	echo 'weblogic.xml 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
fi
echo '[참고] weblogic.xml 결과값 없을 경우 <session-param>에서 timeout 설정 존재 유무 확인 필요(수동점검)' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0110 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0111 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.11 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.11 HTTP 프로토콜 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '<max-http-message-size>가 2000000000이하이면 양호(디폴트 값은 -1이며 10M이므로 양호)' >> $CREATE_FILE_RESULT 2>&1
echo '<complete-message-timeout>이 480이하이면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >>  $CREATE_FILE_RESULT 2>&11
echo '(1) 메시지 크기 확인' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml |grep max |grep message|wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음 (Default로 양호임)' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml |grep max |grep message >> $CREATE_FILE_RESULT 2>&1
fi

echo '(2) 메시지 타임아웃 확인' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep timeout | grep message |wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml |grep timeout |grep message >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0111 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0112 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.12 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.12 SNMP Community String 취약성 제거'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'Community String 값이 public, private인 경우 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep community | grep prefix |wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml | grep community | grep prefix >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0112 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0201 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 2.1 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.1 불필요한 디렉터리 삭제'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'example, ROOT, webdav 디렉토리는 불필요시 삭제하도록 권고' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
if [ `find $weblogic/../../../../ -name samples|wc -l` -eq 0 ]
	then
	echo 'Sample Domain이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	result2_1='S'
else
	find $weblogic/../../../../ -name samples >> $CREATE_FILE_RESULT 2>&1
	result2_1='F'
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result=$result2_1  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0201 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0202 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 2.2 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.2 서버 구동 모드 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '<production-mode-enabled>값이 true로 설정 시 양호함' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep production |wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml | grep production >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0202 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0301 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 3.1 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 3.1 보안 패치 적용'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '서비스 지원이 종료된 버전을 사용하거나 주기적인 보안 패치를 적용하고 있지 않을 경우 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
cat $config/config.xml|grep version|grep domain|awk -F'>' '{print $2}'|awk -F'<' '{print $1}' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[최신 버전] - 18.03 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'Weblogic 12c R2 - 12.2.1.3.0' >> $CREATE_FILE_RESULT 2>&1
echo 'Weblogic 12c R1 - 12.1.3.0.0' >> $CREATE_FILE_RESULT 2>&1
echo 'Weblogic 11g R1 - 10.3.6.0' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0301 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0401 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 4.1 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.1 관리자 콘솔 접근통제'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '포트번호 7001을 사용하지 않고 접근 제어를 하는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
echo '(1) 포트 확인' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep listen | grep port | wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음 (Default로 양호임)' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml | grep listen | grep port >> $CREATE_FILE_RESULT 2>&1
fi

echo '(2) 접근제어 확인' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep connection | grep filter |wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml | grep connection | grep filter >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0401 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0402 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 4.2 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.2 관리자 Default 계정명 변경'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '관리자 계정명이 weblogic인 경우 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
echo 'security.xml에서 administrator의 name 설정값 확인(하단부 "[참고]security.xml 파일" 확인)' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0402 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0403 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 4.3 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.3 관리자 패스워드 암호정책'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '유추하기 쉬운 패스워드가 아닌 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
echo '설정파일로 확인이 불가능 (인터뷰 필요)' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT  2>&1
echo '0403 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0404 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 4.4 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.4 boot properties 파일 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'boot.properties 파일 600이하 권한 시 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
boot_path_find=`find $weblogic -name boot.properties 2> /dev/null`
if [ `echo $boot_path_find | wc -l` -ge 1 ]; then
	for boot_path in $boot_path_find; do
		ls -al $boot_path >> $CREATE_FILE_RESULT 2>&1
	done
else
	echo 'boot.properties 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1 
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0404 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0405 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 4.5 =============================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.5 계정 Lockout 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'lockout-enabled 값이 true 일 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $config/config.xml | grep lockout | grep enabled | wc -l` -eq 0 ]
	then
	echo '해당 설정 값이 없음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $config/config.xml | grep lockout | grep enabled >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '0405 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== end =============================='
echo '=============================  end  ====================================' >> $CREATE_FILE_RESULT 2>&1
echo '[참고] config.xml 파일'  >> $CREATE_FILE_RESULT 2>&1
cat $config/config.xml >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[참고] security.xml 파일'  >> $CREATE_FILE_RESULT 2>&1
cat $weblogic/init-info/security.xml >> $CREATE_FILE_RESULT 2>&1



















