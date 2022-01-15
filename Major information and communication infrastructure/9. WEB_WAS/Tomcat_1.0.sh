
#!/bin/sh
HOSTNAME=`hostname`

LANG=C
export LANG

CREATE_FILE_RESULT=`hostname`"_"`date +%Y%m%d`"_tomcat".log


echo ""
echo "###########################################################################"
echo "#        Copyright (c) 2018 think Co. Ltd. All Rights Reserved.         #"
echo "###########################################################################"
echo ""
echo ""
echo "################# Tomcat 진단 스크립트를 실행하겠습니다 ###################"
echo ""
echo ""

alias ls=ls
alias grep=/bin/grep

echo '[Tomcat 서비스 확인]'
echo ''
ps -ef |grep -i tomcat |grep -v grep
echo ''
echo '[env 정보]'
env | grep TOMCAT   
echo ''                                                                   
echo '[현재 Tomcat 설치 경로]'
#ps -ef |grep -i  tomcat|awk -F'home' '{print $2}'|awk '{print $1}'|grep =|tail -1
ps -ef |grep -i tomcat |awk -F'home' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'
echo ''
#echo '[구동 중인 conf파일 경로]' 
#ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / 


#echo '[구동 중인 conf파일 경로]' >> $CREATE_FILE_RESULT 2>&1
#ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / >> $CREATE_FILE_RESULT 2>&1
#echo '' >> $CREATE_FILE_RESULT 2>&1
#echo '' >> $CREATE_FILE_RESULT 2>&1
#/svc/was/tomcat6.0.20/Svr1
#/svc/was/tomcat6.0.20/Svr2
echo ''
echo '' >> $CREATE_FILE_RESULT 2>&1
echo ''
echo "※ 위 내용을 확인하시고 Tomcat 설치 디렉터리를 입력하십시오. "
while true
do 
   echo -n "    (ex. /usr/local/tomcat/) : " 
   read tomcat
   if [ $tomcat ]
      then
         if [ -d $tomcat ]
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

#echo '[현재 Tomcat 설치 경로]' >> $CREATE_FILE_RESULT 2>&1
#ps -ef |grep -i tomcat|awk -F'home' '{print $2}'|awk '{print $1}'|grep =|tail -1 >> $CREATE_FILE_RESULT 2>&1
#ps -ef |grep -i tomcat|awk -F'home' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
echo ''



#Dcatalina.Base
bcount=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |wc -l`


#Dcatalina.Base 경로
if [ $bcount -gt 5 ]
	then
	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
	bcount=6
else
	if [ $bcount -eq 5 ]
		then
		ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / >> $CREATE_FILE_RESULT 2>&1
		base1=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 1:|awk -F':' '{print $2}'`
		base2=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 2:|awk -F':' '{print $2}'`
		base3=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 3:|awk -F':' '{print $2}'`
		base4=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 4:|awk -F':' '{print $2}'`
		base5=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 5:|awk -F':' '{print $2}'`
	fi
	if [ $bcount -eq 4 ]
		then
		ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / >> $CREATE_FILE_RESULT 2>&1
		base1=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 1:|awk -F':' '{print $2}'`
		base2=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 2:|awk -F':' '{print $2}'`
		base3=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 3:|awk -F':' '{print $2}'`
		base4=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 4:|awk -F':' '{print $2}'`
	fi
	if [ $bcount -eq 3 ]
		then
		ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / >> $CREATE_FILE_RESULT 2>&1
		base1=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 1:|awk -F':' '{print $2}'`
		base2=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 2:|awk -F':' '{print $2}'`
		base3=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 3:|awk -F':' '{print $2}'`
	fi
	if [ $bcount -eq 2 ]
		then
		ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / >> $CREATE_FILE_RESULT 2>&1
		base1=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 1:|awk -F':' '{print $2}'`
		base2=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 2:|awk -F':' '{print $2}'`
	fi
	if [ $bcount -eq 1 ]
		then
		ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / >> $CREATE_FILE_RESULT 2>&1
		base1=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |grep -n ''|grep 1:|awk -F':' '{print $2}'`
	#else
	#	echo 'Dcatalina.Base가 없음' >> $CREATE_FILE_RESULT 2>&1
	fi

fi



echo " "
conf=$tomcat
conf1=$base1
conf2=$base2
conf3=$base3
conf4=$base4
conf5=$base5
confall=`echo $conf1 $conf2 $conf3 $conf4 $conf5`


echo '' >> $CREATE_FILE_RESULT 2>&1 
echo '' >> $CREATE_FILE_RESULT 2>&1 
echo "########################################################################################################" >> $CREATE_FILE_RESULT 2>&1
echo "#                         Copyright (c) 2018 think Co. Ltd. All Rights Reserved.                     #" >> $CREATE_FILE_RESULT 2>&1
echo "########################################################################################################" >> $CREATE_FILE_RESULT 2>&1
echo "  ※  Launching Time: `date`                                                                      " >> $CREATE_FILE_RESULT 2>&1
echo "  ※  Result File: $CREATE_FILE_RESULT                                                            " >> $CREATE_FILE_RESULT 2>&1
echo "  ※  Hostname: `hostname`                                                                        " >> $CREATE_FILE_RESULT 2>&1
ipadd=`ifconfig -a | grep "inet " | awk -F":" '{i=1; while(i<=NF) {print $i; i++}}' | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | egrep "^[1-9]" | egrep -v "^127|^255|255$"`
echo "  ※  ip address: `echo $ipadd`                                                                        " >> $CREATE_FILE_RESULT 2>&1
echo "********************************************************************************************************" >> $CREATE_FILE_RESULT 2>&1
uname -a                            >>  $CREATE_FILE_RESULT 2>&1
echo "********************************************************************************************************" >>  $CREATE_FILE_RESULT 2>&1
echo " " >> $CREATE_FILE_RESULT 2>&1
echo "###################################### Script Launching Time ################################################"
date
echo " "
echo " " >> $CREATE_FILE_RESULT 2>&1
echo " " >> $CREATE_FILE_RESULT 2>&1
echo "****************************** Start **********************************" 
echo '============================== 1.1 =============================='
echo "0101 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.1 데몬 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat의 데몬이 root 계정 외의 WAS 전용 계정으로 구동중이면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
ps -ef |grep -i tomcat |grep -v "Tomcat_script" | grep -v "grep" >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

if [ `ps -ef | grep -i tomcat | grep -v "Tomcat_script" | grep -v "grep" | grep -v "root" | wc -l` -eq 0 ]
	then
        	result2_1='■ 취약'
else
	result2_1='■ 양호'
	fuser=`ps -ef |grep -i tomcat | grep -v "Tomcat_script" | grep -v "grep" | awk '{print  $1}' | head -1`
	luser=`ps -ef |grep -i tomcat | grep -v "Tomcat_script" | grep -v "grep" | awk '{print  $1}' | tail -1`
	echo '[Tomcat /etc/passwd]' >> $CREATE_FILE_RESULT 2>&1
                       
	fuserbin=`cat /etc/passwd | grep $fuser | awk -F':' '{print  $7}' |awk -F'/' '{print $3}'|head -1`
	luserbin=`cat /etc/passwd | grep $luser | awk -F':' '{print  $7}' |awk -F'/' '{print $3}'|head -1`
	if [ $fuser = $luser ]
		then		
		cat /etc/passwd |grep $fuser >> $CREATE_FILE_RESULT 2>&1
		
	else
		cat /etc/passwd |grep $fuser	>> $CREATE_FILE_RESULT 2>&1		
		cat /etc/passwd |grep $luser >> $CREATE_FILE_RESULT 2>&1
	fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '※ Tomcat의 데몬을 root 계정 외의 WAS 전용 계정으로 변경하여 구동 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $result2_1  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0101 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 1.2 =============================='
echo "0102 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.2 관리서버 디렉토리 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '관리 서버 홈디렉토리 퍼미션이 WAS전용 계정 소유이며 750으로 설정되어 있는경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1


echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[ 관리서버 ]' >> $CREATE_FILE_RESULT 2>&1
echo '경로(버전 6.x, 7.x) : '$tomcat'/webapps' >> $CREATE_FILE_RESULT 2>&1
ls -alL $tomcat/webapps |grep manager >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '경로(버전 4.x, 5.x) : '$tomcat'/server/webapps' >> $CREATE_FILE_RESULT 2>&1
ls -alL $tomcat/server/webapps |grep manager >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

if [ `ls -alL $tomcat/webapps |grep manager|grep -v '.r...-.---'|wc -l ` -eq 0 ]
	then
	sresult2_2='■ 양호'
else
	sresult2_2='■ 취약'
fi

echo '※ 관리 서버 홈디렉토리 퍼미션이 750이하로 설정 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $sresult2_2 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0102 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.3 =============================='
echo "0103 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.3 설정파일 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 설정파일 퍼미션이 WAS전용 계정 소유이며 600 또는 700으로 설정되어 있는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

cresult2_32='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
	#for folder in $confall
	#	do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/ >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/conf/|egrep ".xml|.properties|.policy"|grep -v 'd.........' >> $CREATE_FILE_RESULT 2>&1
					if [ `ls -alL $tomcat/conf/|egrep ".xml|.properties|.policy"|grep -v 'd.........'|grep -v '....------'|wc -l` -gt 0 ]
						then
							cresult2_32='■ 취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
	#done
#fi

echo '※ Tomcat conf 디렉터리 내부의 설정파일 퍼미션을 600 또는 700이하로 설정 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult2_32 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0103 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 1.4 =============================='
echo "0104 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.4 디렉토리 검색 기능 제거'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'web.xml내부의 listing설정이 false로 설정되어있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1


cresult1_8='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/web.xml >> $CREATE_FILE_RESULT 2>&1
					mcount=`cat $tomcat/conf/web.xml|grep -v '!--'|grep -n ' '|grep listing|awk -F':' '{print $1}'`
					mcount=`expr $mcount + 1`
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep listing|awk -F':' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep $mcount|head -1|awk -F':' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep $mcount|head -1|awk -F':' '{print $2}'|awk -F'>' '{print $2}'|awk -F'<' '{print $1}'` = 'true' ]
						then
							cresult1_8='■ 취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '※ 디렉토리 구조 및 주요 설정파일의 내용을 노출 시킬 수 있는 listing 설정 값 false로 변경 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_8 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0104 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.5 =============================='
echo "0105 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.5 로그 디렉토리/파일 권한 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '로그 디렉토리 퍼미션 WAS전용 계정 소유이며 750, 로그 파일 퍼미션 640으로 설정되어 있는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1


result2_55='양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					log=`cat $tomcat/conf/server.xml|grep -v '!--'|grep -n ' '|grep 'valves.AccessLog'|awk -F'"' '{print $4}'`
					if [ `ls -alL $tomcat|grep $log|grep -v '.....-.---'|wc -l` -gt 0 ]
					then
							result2_55='취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi



result2_5='양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					log=`cat $tomcat/conf/server.xml|grep -v '!--'|grep -n ' '|grep 'valves.AccessLog'|awk -F'"' '{print $4}'`
                    echo '| Log 디렉토리 |' $tomcat/$log >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/$log >> $CREATE_FILE_RESULT 2>&1
					if [ `ls -alL $tomcat/$log|grep -v 'd.........' |grep -v 'total'|grep -v '...-.-----'|wc -l` -gt 0 ]
					then
							result2_5='취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

#if [ \( $result2_55 = "취약" \) -o \( $result2_5 = "취약" \) ]
#	then
#		result2_555='■ 취약'
#	else
#		result2_555='■ 양호'
#fi



echo '※ 로그파일 퍼미션을 640이하, 디렉토리 750이하로 설정을 권고함.'>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $result2_555 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0105 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.6 =============================='
echo "0106 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.6 로그 포맷 설정 '  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '로그 포맷 설정이  combined로 되어 있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1


cresult1_5='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/server.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/server.xml | grep -v '\-\-'| grep -v '#' | grep 'pattern=' | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '^pattern' >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/server.xml | grep -v '\-\-'| grep -v '#' | grep 'pattern=' | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '^pattern' | grep -i 'combined'| wc -l` -eq 0 ]
						then
							cresult1_5='■ 취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '※ 로그 포맷을 combined로 설정 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_5 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0106 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.7 =============================='
echo "0107 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.7 로그 저장 주기 '  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '법에 정해진 최소 로그 저장 기간대로 백업 및 보관하고 있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '■ 인터뷰 점검 : 담당자 인터뷰를 통해서 로그저장주기 및 검토, 백업현황 파악 필요' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0107 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.8 =============================='
echo "0108 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.8 HTTP Method 제한'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'HTTP Method가 GET, POST, HEAD, OPTIONS만 허용되어 있는경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

cresult1_7='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/web.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ''|grep -i forbidden  >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ''|grep -i method >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ''|grep -i method | egrep -i "put|delete|trace"|wc -l` -lt 3 ]
						then
							cresult1_7='■ 취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '※ web.xml 파일에서 PUT, DELETE, TRACE Method 설정을 제한' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_7 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0108 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '============================== 1.9 =============================='
echo "0109 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.9 Session Timeout 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'Session Timeout 30분 이내로 변경 (Default = 30) ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

cresult1_9='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/web.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep session-timeout|awk -F':' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep session-timeout|awk -F">" '{print $2}'|awk -F"<" '{print $1}'` -gt 30 ]
						then
							cresult1_9='■ 취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '※ Session Timeout 30분 이내로 변경 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_9 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0109 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 2.1 =============================='
echo "0201 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.1 불필요한 Examples 파일 및 디렉터리 삭제'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '운영상 불필요한 examples 디렉토리가 제거 되어 있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

result3_1='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/webapps/ >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/webapps/|grep 'd.........' >> $CREATE_FILE_RESULT 2>&1
					if [ `ls $tomcat/webapps|grep -w examples|wc -l` -ge 1 ]
						then
							result3_1='■ 취약'
					else
						echo $tomcat/webapps/examples/ '디렉토리 없음' >> $CREATE_FILE_RESULT 2>&1
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '※ example 디렉토리는 불필요시 삭제 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $result3_1 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0201 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 2.2 =============================='
echo "0202 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.2 프로세스 관리기능 삭제'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '불필요한 프로세스 관리 디렉토리가 삭제 되어 있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

result3_2='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat >> $CREATE_FILE_RESULT 2>&1
					find $tomcat -name catalina-manager.jar  >> $CREATE_FILE_RESULT 2>&1
					if [ `find $tomcat -name catalina-manager.jar|wc -l` -ge 1 ]
						then
							result3_2='■ 취약'
					else
						echo $tomcat/'catalina-manager.jar 파일 없음' >> $CREATE_FILE_RESULT 2>&1
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '※ Tomcat 설치시 관리자 프로세스 관리 기능이 웹상에서 가능하므로 catalina-manager.jar 파일 삭제' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo  $result3_2 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0202 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 3.1 =============================='
echo "0301 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 3.1 보안 패치 적용'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '서비스 침해 방지를 위해 주기적으로 최신 패치 적용 작업이 진행되고 있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[ 구동중인 Tomcat Version ]'  >> $CREATE_FILE_RESULT 2>&1
sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}' >> $CREATE_FILE_RESULT 2>&1

ver=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'`
ver1=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'|awk -F'.' '{print $1}'`
ver2=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'|awk -F'.' '{print $2}'`
ver3=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'|awk -F'.' '{print $3}'`


#if [ $ver1 -eq 8 -a $ver2 -eq 0 ]
#	then
#	if [ $ver3 -ge 50 ]
#		then 
#			result4_11='■ 양호'
#	fi
#fi			
#if [ $ver1 -eq 7 -a $ver2 -eq 0 ]
#	then
#	if [ $ver3 -ge 51 ]
#		then 
#			result4_11='■ 양호'
#		else
#			result4_11='■ 취약'
#	fi
#fi			
#if [ $ver1 -eq 6 -a $ver2 -eq 0 ]
#	then
#	if [ $ver3 -ge 37 ]
#		then
#			result4_11='■ 양호'
#		else
#			result4_11='■ 취약'
#	fi
#fi
#if [ $ver1 -eq 5 -a $ver2 -eq 5 ]
#	then
#	if [ $ver3 -ge 35 ]
#		then
#			result4_11='■ 양호'
#		else
#			result4_11='■ 취약'
#	fi
#fi

echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[최신 버전]' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 9.0.x	9.0.05' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 8.5.x	8.5.28' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 8.0.x	8.0.50' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 7.0.x	7.0.85' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 6.0.x	6.0.37' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 5.5.x	5.5.35' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 5.5버전 미만은 기술지원 완료로 인해 패치 지원 안함' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '※ 영향도 평가 이후 최신 패치 수행 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#echo $result4_11  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0301 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.1 =============================='
echo "0401 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.1 관리자 콘솔 접근통제'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '불필요한 경우, Tomcat 관리자 콘솔 사용 중지되어 있고, 필요한 경우 Default Port 변경해서 사용하는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '1) Tomcat 관리자 콘솔 확인'  >> $CREATE_FILE_RESULT 2>&1

cresult4_1_1='양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/webapps |grep -w manager >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/webapps |grep -w admin >> $CREATE_FILE_RESULT 2>&1
					#find $tomcat -name admin.xml >> $CREATE_FILE_RESULT 2>&1
					#find $tomcat -name manager.xml >> $CREATE_FILE_RESULT 2>&1
					if [ \( `ls -alL $tomcat/webapps |grep -w manager |wc -l` -ge 1 \) -o \( `ls -alL $tomcat/webapps |grep -w admin |wc -l` -ge 1 \) ]
						then
							cresult4_1_1='취약'
					else
						echo 'admin.xml, manager.xml 파일 없음' >> $CREATE_FILE_RESULT 2>&1
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

if [ $cresult4_1_1 = "취약" ]
then
echo '2) Default 포트(8080) 확인'  >> $CREATE_FILE_RESULT 2>&1

cresult4_1_2='양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/server.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/server.xml |grep 'Connector port'|grep -v '#'|awk -F" " '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					#if [ `cat $tomcat/conf/server.xml |grep 'Connector port'|awk '{print $2}'|awk -F'"' '{print $2}'` = '8080' ]
					if [ `cat $tomcat/conf/server.xml |grep 'Connector port'|grep -v '#'|awk '{print $2}'|grep 8080|wc -l` -ge 1 ]
						then
							cresult4_1_2='취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi
fi

if [ $cresult4_1_1 = "취약" ]
	then
		if [ $cresult4_1_2 = "취약" ]
			then
				result44_1='■ 취약'
		else
			result44_1='■ 양호'
		fi
else
	result44_1='■ 양호'
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[수동 방법]' >> $CREATE_FILE_RESULT 2>&1	
echo '(예 1) telnet 127.0.0.1 8080 으로 접속 후 GET http://127.0.0.1/admin/ HTTP/1.0를 요청 시 200 OK(Tomcat관련 웹페이지)가 나올 경우 취약' >> $CREATE_FILE_RESULT 2>&1	
echo '(예 2) telnet 127.0.0.1 8080 으로 접속 후 GET http://127.0.0.1/manager/ HTTP/1.0를 요청 시 200 OK(Tomcat관련 웹페이지)가 나올 경우 취약' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	
echo '※ 불필요한 경우, Tomcat 관리자 콘솔 사용 금지하고, 필요한 경우 Default Port 변경 권고' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	

#echo $result44_1  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0401 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.2 =============================='
echo "0402 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.2 관리자 default 계정명 변경'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '관리자 콘솔 default 값으로 제공된 계정명을 변경하여 사용하거나' >> $CREATE_FILE_RESULT 2>&1
echo 'default 계정명 삭제 또는 주석처리 되어 있는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					awk '/<tomcat-users>/,/<\/tomcat-users>/' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '※ 관리자 콘솔 default 계정명을 유추 힘든 계정으로 변경 권고' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	

echo '■ N/A'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0402 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.3 =============================='
echo "0403 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.3 관리자 패스워드 암호정책'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '패스워드 보안 정책에 맞게 사용중이면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '4가지 문자 중 3종류 이상을 조합하여 최소 8자리이상 또는' >> $CREATE_FILE_RESULT 2>&1
echo '4가지 문자 중 2종류 이상을 조합하여 최소 10자리 이상으로 사용 중이면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					awk '/<tomcat-users>/,/<\/tomcat-users>/' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '패스워드 보안 정책에 맞게 영문/숫자/특수문자 등 3종류 이상 조합으로' >> $CREATE_FILE_RESULT 2>&1	
echo '8자리 이상의 길이로 구성 또는 2종류 이상 10자리 조합으로 구성' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	

echo '■ N/A'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0403 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.4 =============================='
echo "0404 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.4 tomcat-users.xml 파일 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '패스워드 파일(tomcat-users.xml)이 WAS전용 계정 소유이며, 퍼미션이 600이면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

result4_4='■ 양호'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base가 너무 많음 수동진단하시기 바랍니다.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat 구동 디렉토리 ]' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/conf|grep tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					if [ `ls -alL $tomcat/conf|grep tomcat-users.xml|grep -v '...-------'|wc -l` -ge 1 ]
						then
							result4_4='■ 취약'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi


echo '※ 패스워드 파일(tomcat-users.xml) 퍼미션 600으로 변경 권고' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

#echo $result4_4  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0404 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' =================== ※ 참고 server.xml ==================='  >> $CREATE_FILE_RESULT 2>&1
cat $tomcat/conf/server.xml  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '****************************** End ***********************************' 
#end script