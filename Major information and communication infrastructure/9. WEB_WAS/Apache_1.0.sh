#!/bin/sh

LANG=C
export LANG

CREATE_FILE_RESULT=`hostname`"_"`date +%Y%m%d`"_apache.log"


echo ""
echo "###########################################################################"
echo "#        Copyright (c) 2018 think Co. Ltd. All Rights Reserved.         #"
echo "###########################################################################"
echo ""
echo ""
echo "################# Apache 진단 스크립트를 실행하겠습니다 ###################"
echo ""
echo ""

alias ls=ls
alias grep=/bin/grep

echo '[Apache 서비스 확인]'
echo ''
ps -ef | grep -v grep | grep httpd | grep -v grep
echo ''

echo '[env 정보]'
env | grep APACHE
echo ''             

echo '[Apache httpd.conf 경로]'

if [ `ps -ef | grep -v grep | grep httpd | grep -v grep | wc -l` -ge 1 ]
   then
      apa=`ps -ef | grep -v grep | grep httpd | grep -v grep | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '\/httpd' | grep "^/" | sed 's/.bin\/httpd//' | sort -u`
      for apd in $apa
      do
         if [ -f $apd/conf/httpd.conf ]
            then
	           echo $apd/conf/httpd.conf
	        else
	           if [ -f $apd/httpd.conf ]
	              then
			         echo $apd/conf/httpd.conf
	           fi
	     fi
      done
   else
	  echo 'Apache가 동작하지 않습니다.'
      exit
fi

echo ''

echo "※ 위 경로를 참고하여 사용중인 httpd.conf 파일 경로를 입력하십시오. "

while true
do 
  echo "    (ex. /usr/local/apache/conf/httpd.conf) : " 
  read apachep
  if [ `echo $apachep | grep "httpd\.conf" | wc -l` -eq 1 ]
    then
      if [ -f $apachep ]
         then 
            if [ `echo $apachep | grep '/conf/httpd\.conf' | wc -l` -eq 1 ]
               then
			      apache=`echo $apachep | sed 's/\/conf\/httpd\.conf//'`
			      conf=$apache/conf
		      else
			      apache=`echo $apachep | sed 's/\/httpd\.conf//'`
			      conf=$apache
	        fi
			break
		 else
			echo "   입력하신 경로가 존재하지 않습니다. 다시 입력하여 주십시오."
			echo " "
	   fi
	else
		echo "   잘못 입력하셨습니다. 다시 입력하여 주십시오."
		echo " "
  fi
done

echo " "

#echo $apache
#echo $conf
echo "****************************** Start **********************************" 
echo "****************************** Start **********************************"
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
echo '============================== 1.1 ===================================='
echo "0101 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.1 데몬 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '구동 계정이 root가 아닌 웹서버 전용 계정으로 구동중' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
ps -ef |grep httpd |grep -v grep >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[httpd.conf 파일]' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep 'User ' |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep 'Group ' |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
if [ `ps -ef |grep httpd |grep -v grep| wc -l` -eq 0 ]
	then 
		result1='취약'
fi
if [ `ps -ef | grep httpd | grep -v grep | grep -v root | wc -l` -eq 0 ]
		then
                        	result1='취약'
	elif [ `ps -ef |grep httpd | grep -v grep | grep root | wc -l` -ge 3 ]
		then
			result1='취약'
	else
		result1='양호'
		
		fuser=`ps -ef |grep httpd | grep -v grep | grep -v root |awk '{print  $1}' | head -1`
		luser=`ps -ef |grep httpd | grep -v grep | grep -v root |awk '{print  $1}' | tail -1`
		echo '[Apache /etc/passwd]' >> $CREATE_FILE_RESULT 2>&1
                        
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
echo '※ Apache의 프로세스가 root 계정 외의 WEB 서버 전용 계정으로 구동할 것을 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#if [ $result1 = '취약' ]
#	then
#		echo '■ 취약 - 데몬 관리' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 양호 - 데몬 관리' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0101 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.2 ===================================='
echo "0102 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.2 관리서버 디렉토리 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'Server Root가 웹서버 전용계정 소유이며 750이하의 퍼미션이 부여되어있는지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep ServerRoot |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
seroot=`cat $conf/httpd.conf |grep ServerRoot |grep -v '#'|awk -F'"' '{print $2}'`

echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[ ServerRoot ]' $seroot >> $CREATE_FILE_RESULT 2>&1
ls -alL $seroot|grep '.r........'|head -1 >> $CREATE_FILE_RESULT 2>&1
sresult2=`ls -alL  $seroot|grep '..........'|head -1|awk '{print $1}'`

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '※ 관리서버 디렉토리에 일반 사용자가 접근할 수 없도록 750 이하 권한 설정 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ `ls -alL $seroot|grep '..........'|head -1|grep -v '.....-.---'|wc -l` -gt 0 ]
#	then
#	echo '■ 취약 - 관리서버 디렉토리 권한 설정' >> $CREATE_FILE_RESULT 2>&1
#else
#	echo '■	양호 - 관리서버 디렉토리 권한 설정' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0102 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.3 ================================'
echo "0103 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.3 설정파일 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '설정파일이 웹서버 전용계정 소유이며 600 또는 700이하의 퍼미션이 부여되어있는지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[Include 설정파일]' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
result3='양호'
echo '' >> $CREATE_FILE_RESULT 2>&1
for conlist in $confinc
	do
		if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
			then
				conpath=$apache/$conlist
			else
				conpath=$conlist
		fi
		if [ -f $conpath ]
			then
				ls -alL $conpath >> $CREATE_FILE_RESULT 2>&1
				if [ `ls -alL $conpath | grep '\.conf*'| grep -v '....------'|wc -l` -gt 0 ]
					then
						result3='취약'
				fi
			else
				ls -alL $conpath >> $CREATE_FILE_RESULT 2>&1
		fi
done

echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[설정파일]' >> $CREATE_FILE_RESULT 2>&1

ls -alLR $conf >> $CREATE_FILE_RESULT 2>&1

if [ `ls -alLR $conf | grep '\.conf*'| grep -v '....------'|wc -l` -gt 0 ] 
	then
		result3='취약'
fi




echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '웹 서버의 설정 파일 권한을 600 또는 700 이하로 설정 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ \( $result3 = '양호' \) ]
#	then
#		echo '■ 양호 - 설정파일 권한 설정' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 취약 - 설정파일 권한 설정' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0103 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.4 ===================================='
echo "0104 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.4 디렉토리 검색 기능 제거'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '<Directory>노드에 부여된 Indexes옵션을 삭제하도록 권고함' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-autoindex.conf 파일 include 여부]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result4='양호'
for conlist in $confinc
	do
		if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
			then
				conpath=$apache/$conlist
			else
				conpath=$conlist
		fi		
		if [ `ls -alL $conpath | grep -i 'httpd-autoindex.conf'|wc -l` -eq 1 ]
			then
				index=`ls -alL $conpath | grep -i 'httpd-autoindex.conf' | awk '{print $NF}'`
				incline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|grep $conlist|awk -F":" '{print $1}'`
				incOX="O"
				echo 'Include '$conlist >> $CREATE_FILE_RESULT 2>&1
				ls -alL $index >> $CREATE_FILE_RESULT 2>&1
		fi
done
if [ \( $incOX = 'X' \) ]
	then
		echo "httpd-autoindex.conf 파일이 include 되어 있지 않음" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
	

#Start
#Include
if [ \( $incOX = 'O' \) ]
	then
		echo '[httpd-autoindex.conf - index 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $index ]
			then
				cat $index |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| Indexes|</Directory' >> $CREATE_FILE_RESULT 2>&1
				if [ `cat $index |grep -v '#'|grep -i ' Options' |grep -i ' Indexes'| wc -l` -eq 0 ]
					then
						echo 'Indexes 옵션 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						result4='취약'
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi
		fi
fi
	
#httpd.conf
echo '[httpd.conf - index 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		cat $conf/httpd.conf |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| Indexes|</Directory' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $conf/httpd.conf |grep -v '#'|grep -i ' Options'|egrep -i ' Indexes' | wc -l` -eq 0 ]
			then
				echo 'Indexes 옵션 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				result4='취약'
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi
fi
#End


echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '웹 서버의 설정 파일에서 디록토리 검색 기능 제거를 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $incOX = 'X' \) ]
#	then
#		echo "httpd-autoindex.conf 파일이 include 되어 있지 않음" >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0104 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1






echo '============================== 1.5 ===================================='
echo "0105 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.5 로그 디렉토리/파일 권한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'Log의 경로 확인하여 해당 Log디렉토리의 퍼미션이 웹서버 전용계정 소유이며 750이하이거나 로그파일 퍼미션이 640이하인지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-vhosts.conf 파일 include 여부]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result5='양호'
for conlist in $confinc
	do
		if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
			then
				conpath=$apache/$conlist
			else
				conpath=$conlist
		fi
		if [ `ls -alL $conpath | grep -i 'httpd-vhosts.conf'|wc -l` -eq 1 ]
			then
				vhosts=`ls -alL $conpath | grep -i 'httpd-vhosts.conf' | awk '{print $NF}'`
				incline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|grep $conlist|awk -F":" '{print $1}'`
				incOX="O"
				echo 'Include '$conlist >> $CREATE_FILE_RESULT 2>&1
				ls -alL $vhosts >> $CREATE_FILE_RESULT 2>&1
		fi
done
if [ \( $incOX = 'X' \) ]
	then
		echo "httpd-vhosts.conf 파일이 include 되어 있지 않습니다." >> $CREATE_FILE_RESULT 2>&1
fi
echo "" >> $CREATE_FILE_RESULT 2>&1

#우선순위 판별
if [ \( $incOX = 'O' \) ]
	then
		if [ `cat $conf/httpd.conf |grep -v '#'|egrep -i 'ErrorLog|CustomLog'| wc -l` -gt 0 ]
			then
				cfgline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|egrep -i 'ErrorLog|CustomLog'|tail -1 |awk -F":" '{print $1}'`
				if [ $incline -gt $cfgline ]
					then
						priority='O'
				fi
			else
				priority='O'
		fi
fi

#Start
if [ \( $priority = 'O' \) ]
then
#Include	
	echo '[httpd-vhosts.conf 설정 확인]'  >> $CREATE_FILE_RESULT 2>&1
		if [ -f $vhosts ]
			then
				if [ `cat $vhosts |grep -v '#'|egrep -i 'ErrorLog|CustomLog'|wc -l` -eq 0 ]
					then
						echo 'ErrorLog, CustomLog 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						cat $vhosts |grep -v '#'|egrep -i 'ErrorLog|CustomLog'| grep -v "#"  >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi
		echo '| Log 퍼미션 확인 |'  >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $vhosts |egrep -i 'ErrorLog|CustomLog'| grep -v "#" | wc -l` -gt 0 ]
			then
				if [ `cat $vhosts |egrep -i 'ErrorLog|CustomLog'| grep -v "#" | awk -F" " '{print $2}' | grep -i '^"'| wc -l` -gt 0 ]
					then
						errlog=`cat $vhosts |grep -i 'ErrorLog'| grep -v "#" |awk -F'"' '{print $2}'`
						ctmlog=`cat $vhosts |grep -i 'CustomLog'| grep -v "#" |awk -F'"' '{print $2}'`
					else
						errlog=`cat $vhosts |grep -i 'ErrorLog'| grep -v "#" |awk -F" " '{print $2}'`
						ctmlog=`cat $vhosts |grep -i 'CustomLog'| grep -v "#" |awk -F" " '{print $2}'`
				fi
				for log in $errlog
					do
						echo $log | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep -i 'logs/[a-zA-Z0-9]' | sed 's/logs\//logs\/:/' | awk -F':' '{print $1}' >> logdir.log
				done
				for log in $ctmlog
					do					
						echo $log | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep -i 'logs/[a-zA-Z0-9]' | sed 's/logs\//logs\/:/' | awk -F':' '{print $1}' >> logdir.log
				done
				
				logdir=`cat logdir.log | sort -u`
				
			for dir in $logdir
				do
					if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
						then
							logpath=$apache/$dir
						else
							logpath=$dir
					fi
					if [ `echo $logpath | grep "^/" | wc -l` -eq 0 ]
						then
							if [ -d $logpath ]
								then
									echo $logpath >> $CREATE_FILE_RESULT 2>&1
									ls -alL $logpath >> $CREATE_FILE_RESULT 2>&1
									if [ `ls -alL $logpath |grep '^-.........' |grep -v '...-.-----'|wc -l` -gt 0 ]
										then
											result5='취약'
											
									fi
									if [ `ls -alL $logpath |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='취약'
									fi
							fi
						else
							if [ -d $logpath/ ]
								then
									echo $logpath/ >> $CREATE_FILE_RESULT 2>&1
									ls -alL $logpath/ >> $CREATE_FILE_RESULT 2>&1
									if [ `ls -alL $logpath/ |grep '^-.........' |grep -v '...-.-----'|wc -l` -gt 0 ]
										then
											result5='취약'
									fi
									if [ `ls -alL $logpath/ |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='취약'
									fi
							fi
					fi
			done
		fi
	fi

else
#httpd.conf
echo "[ "$conf"/httpd.conf 로그 설정 ]" >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		if [ `cat $conf/httpd.conf |egrep -i 'ErrorLog|CustomLog'| grep -v "#"| wc -l` -eq 0 ]
			then
				echo 'ErrorLog, CustomLog 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				cat $conf/httpd.conf |egrep -i 'ErrorLog|CustomLog'| grep -v "#" >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi
fi

echo "" >> $CREATE_FILE_RESULT 2>&1

		if [ `cat $conf/httpd.conf |egrep -i 'ErrorLog|CustomLog'| grep -v "#" | wc -l` -gt 1 ]
			then
				if [ `cat $conf/httpd.conf |egrep -i 'ErrorLog|CustomLog'| grep -v "#" | awk -F" " '{print $2}' | grep -i '^"'| wc -l` -gt 0 ]
					then
						errlog=`cat $conf/httpd.conf |grep -i 'ErrorLog'| grep -v "#" |awk -F'"' '{print $2}'`
						ctmlog=`cat $conf/httpd.conf |grep -i 'CustomLog'| grep -v "#" |awk -F'"' '{print $2}'`
					else
						errlog=`cat $conf/httpd.conf |grep -i 'ErrorLog'| grep -v "#" |awk -F" " '{print $2}'`
						ctmlog=`cat $conf/httpd.conf |grep -i 'CustomLog'| grep -v "#" |awk -F" " '{print $2}'`
				fi
				for log in $errlog
					do
						echo $log | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep -i 'logs/[a-zA-Z0-9]' | sed 's/logs\//logs\/:/' | awk -F':' '{print $1}' >> logdir.log
				done
				for log in $ctmlog
					do					
						echo $log | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep -i 'logs/[a-zA-Z0-9]' | sed 's/logs\//logs\/:/' | awk -F':' '{print $1}' >> logdir.log
				done
				
				logdir=`cat logdir.log | sort -u`
				
			for dir in $logdir
				do
					if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
						then
							logpath=$apache/$dir
						else
							logpath=$dir
					fi
					if [ `echo $logpath | grep "^/" | wc -l` -eq 0 ]
						then
							if [ -d $logpath ]
								then
									echo $logpath >> $CREATE_FILE_RESULT 2>&1
									ls -alL $logpath >> $CREATE_FILE_RESULT 2>&1
									if [ `ls -alL $logpath |grep '^-.........' |grep -v '...-.-----'|wc -l` -gt 0 ]
										then
											result5='취약'
											
									fi
									if [ `ls -alL $logpath |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='취약'
											
									fi
							fi
						else
							if [ -d $logpath/ ]
								then
									echo $logpath/ >> $CREATE_FILE_RESULT 2>&1
									ls -alL $logpath/ >> $CREATE_FILE_RESULT 2>&1
									if [ `ls -alL $logpath/ |grep '^-.........' |grep -v '...-.-----'|wc -l` -gt 0 ]
										then
											result5='취약'
											
									fi
									if [ `ls -alL $logpath/ |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='취약'
											
									fi
							fi
					fi
			done
		fi
#End
fi
		
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '※ 로그 디렉터리는 750이하 권한으로 파일은 640이하 권한으로 설정 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result5 = '양호' \) ]
#then
#	echo '■ 양호 - 로그 디렉토리/파일 권한 설정' >> $CREATE_FILE_RESULT 2>&1 
#else
#	echo '■ 취약 - 로그 디렉토리/파일 권한 설정' >> $CREATE_FILE_RESULT 2>&1 
#fi
rm -rf logdir.log
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0105 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1





echo '============================== 1.6 ===================================='
echo "0106 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.6 로그 포맷 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'LogFormat이 Combined형태보다 상세하게 설정되어있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-vhosts.conf 파일 include 여부]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result6='양호'
for conlist in $confinc
	do
		if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
			then
				conpath=$apache/$conlist
			else
				conpath=$conlist
		fi
		if [ `ls -alL $conpath | grep -i 'httpd-vhosts.conf'|wc -l` -eq 1 ]
			then
				vhosts=`ls -alL $conpath | grep -i 'httpd-vhosts.conf' | awk '{print $NF}'`
				incline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|grep $conlist|awk -F":" '{print $1}'`
				incOX="O"
				echo 'Include '$conlist >> $CREATE_FILE_RESULT 2>&1
				ls -alL $vhosts >> $CREATE_FILE_RESULT 2>&1
		fi
done
if [ \( $incOX = 'X' \) ]
	then
		echo "httpd-vhosts.conf 파일이 include 되어 있지 않습니다." >> $CREATE_FILE_RESULT 2>&1
fi
echo "" >> $CREATE_FILE_RESULT 2>&1

#우선순위 판별
if [ \( $incOX = 'O' \) ]
	then
		if [ `cat $conf/httpd.conf |grep -v '#'|egrep -i 'CustomLog'| wc -l` -gt 0 ]
			then
				cfgline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|egrep -i 'CustomLog'|tail -1 |awk -F":" '{print $1}'`
				if [ $incline -gt $cfgline ]
					then
						priority='O'
				fi
			else
				priority='O'
		fi
fi

#Start
if [ \( $priority = 'O' \) ]
then
#Include	
	echo '[httpd-vhosts.conf 설정 확인]'  >> $CREATE_FILE_RESULT 2>&1
		if [ -f $vhosts ]
			then
				if [ `cat $vhosts |grep -v '#'|egrep -i 'CustomLog' | wc -l` -eq 0 ]
					then
						echo 'CustomLog 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						cat $vhosts |grep -v '#'|egrep -i 'CustomLog'  >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi		
				if [ `cat $vhosts |egrep -i 'CustomLog'| grep -v "\#" | grep -v "combined" | wc -l` -gt 0 ]
					then
						result6='취약'
				fi
			else
				echo "httpd-vhosts.conf 파일이 존재하지 않음" >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi
	echo "" >> $CREATE_FILE_RESULT 2>&1
else
#httpd.conf
echo "[ "$conf"/httpd.conf 로그 설정 ]" >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		if [ `cat $conf/httpd.conf |grep -v '#'|egrep -i 'CustomLog' | wc -l` -eq 0 ]
			then
				echo 'CustomLog 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				cat $conf/httpd.conf |grep -v '#'|egrep -i 'CustomLog'  >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi		
fi

if [ `cat $conf/httpd.conf |egrep -i 'CustomLog'| grep -v "\#" | grep -v "combined" | wc -l` -gt 0 ]
	then
		result6='취약'
fi
#End
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '※ 적절한 로그 지시자가 포함되게 로그 포맷을 combined로 설정 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result6 = '양호' \) ]
#then
#	echo '■ 양호 - 로그 포맷 설정' >> $CREATE_FILE_RESULT 2>&1 
#else
#	echo '■ 취약 - 로그 포맷 설정' >> $CREATE_FILE_RESULT 2>&1 
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0106 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1







echo '============================== 1.7 ===================================='
echo "0107 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.7 로그 저장 주기 '  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '정통망법 및 개인정보보호법, 사규에 정해진 로그 저장주기 설정 적용' >> $CREATE_FILE_RESULT 2>&1
echo '로그 저장 기간, 정기적인 확인/감독, 별도 저장장치에 백업 등 상세 내용은 보안가이드라인 문서 참고' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '☞ 인터뷰 필요' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 미점검 - 로그 저장 주기' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0107 END" 															>> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.8 ===================================='
echo "0108 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.8 헤더 정보 노출 방지'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'ServerTokens값이 Prod로 설정되어 있는지 확인' >> $CREATE_FILE_RESULT 2>&1
echo 'ServerSignature이 Off로 설정되어 있는지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-default.conf 파일 include 여부]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result8='양호'
for conlist in $confinc
	do
		if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
			then
				conpath=$apache/$conlist
			else
				conpath=$conlist
		fi
		if [ `ls -alL $conpath | grep -i 'httpd-default.conf'|wc -l` -eq 1 ]
			then
				header=`ls -alL $conpath | grep -i 'httpd-default.conf' | awk '{print $NF}'`
				incline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|grep $conlist|awk -F":" '{print $1}'`
				incOX="O"
				echo 'Include '$conlist >> $CREATE_FILE_RESULT 2>&1
				ls -alL $header >> $CREATE_FILE_RESULT 2>&1
		fi
done
if [ \( $incOX = 'X' \) ]
	then
		echo "httpd-default.conf 파일이 include 되어 있지 않음" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#우선순위 판별
if [ \( $incOX = 'O' \) ]
	then
		if [ `cat $conf/httpd.conf |grep -v '#'|egrep -i 'CustomLog'| wc -l` -gt 0 ]
			then
				cfgline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|egrep -i 'ServerTokens|ServerSignature'|tail -1 |awk -F":" '{print $1}'`
				if [ $incline -gt $cfgline ]
					then
						priority='O'
				fi
			else
				priority='O'
		fi
fi

#Start
if [ \( $priority = 'O' \) ]
then
#Include	
		echo '[httpd-default.conf 파일 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $header ]
			then
				if [ `cat $header |egrep -i 'ServerTokens|ServerSignature'|grep -v '#'|wc -l` -eq 0 ]
					then
						echo 'ServerTokens, ServerSignature 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						cat $header |egrep -i 'ServerTokens|ServerSignature'|grep -v '#' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi
			else
				echo 'httpd-default.conf 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi

		if [ \( $incOX = 'O' \) ]
			then
				if [ -f $header ]
					then
						if [ `cat $header |grep -v '#' | grep -i 'ServerTokens'| grep -i "prod" | wc -l` -eq 0 ]
							then
								result8='취약'
						fi
						if [ `cat $header |grep -v '#' | grep -i 'ServerSignature'| grep -i "off" | wc -l` -eq 0 ]
							then
								result8='취약'
						fi
				fi
		fi

else
#httpd.conf
echo '[httpd.conf 파일 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		if [ `cat $conf/httpd.conf |egrep -i 'ServerTokens|ServerSignature'|grep -v '#'|wc -l` -eq 0 ]
			then
				echo 'ServerTokens, ServerSignature 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				cat $conf/httpd.conf |egrep -i 'ServerTokens|ServerSignature'|grep -v '#' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi
fi

if [ -f $conf/httpd.conf ]
	then
		if [ `cat $conf/httpd.conf |grep -v '#' | grep -i 'ServerTokens'| grep -i "prod" | wc -l` -eq 0 ]
			then
				result8='취약'
		fi
		if [ `cat $conf/httpd.conf |grep -v '#' | grep -i 'ServerSignature'| grep -i "off" | wc -l` -eq 0 ]
			then
				result8='취약'
		fi
fi
#End
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '웹 서버의 설정 파일에서 ServerTokens값은 Prod로 ServerSignature는 Off로 설정을 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ \( $result8 = '양호' \) ]
#	then
#		echo '■ 양호 - 헤더 정보 노출 방지' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 취약 - 헤더 정보 노출 방지' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0108 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '============================== 1.9 ===================================='
echo "0109 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.9 HTTP Method 제한'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '불필요한 Method 제한 설정이 되어 있는지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '(Default 값으로 GET, POST, HEAD, OPTIONS, TRACE Method를 허용하고 있음)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '| Trace Method 제한 |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $conf/httpd.conf | grep -i TraceEnable | grep -i off | grep -v "\#" |wc -l` -eq 0 ]
then
	echo 'TraceEnable On/Off 설정이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $conf/httpd.conf | grep -i TraceEnable >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '| Dav 모듈 사용 제한 : 모듈 Load 확인 |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -eq 0 ]
then
	echo 'Dav 모듈을 Load하고 있지 않음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $conf/httpd.conf | grep -i LoadModule | grep -i Dav  >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	echo '| Dav 모듈 사용 제한 : Dav on 설정 확인 |' >> $CREATE_FILE_RESULT 2>&1
	if [ `cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep -i "On|Off" | wc -l` -gt 0 ]
		then
			cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep "on|off" >> $CREATE_FILE_RESULT 2>&1
		else
			echo 'Dav On/Off 설정이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	fi
fi

result11='양호'

if [ `cat $conf/httpd.conf | grep -i TraceEnable | grep -i off | grep -v '#' |wc -l` -eq 0 ]
then
	result11='취약'
fi

if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -gt 0 ]
	then
		if [ `cat $conf/httpd.conf | grep -i dav | grep -i on | grep -v '#' |wc -l` -gt 0 ]
			then
				result11='취약'
		fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '※ HTTP Method 중 GET, POST, HEAD, OPTIONS 만 허용하도록' >> $CREATE_FILE_RESULT 2>&1
echo '   TraceEnable Off 설정과 Dav 모듈을 Load할 경우 Dav Off 설정을 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ $result11 = '취약' ]
#	then
#		echo '■ 취약 - HTTP Method 제한' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 양호 - HTTP Method 제한' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0109 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1





echo '============================== 1.10 ===================================='
echo "0110 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.10 FollowSymLinks 옵션 비활성화'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '<Directory>노드에 FollowSymLinks옵션이 제한 또는 제거되어있는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-autoindex.conf 파일 include 여부]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result9='양호'
for conlist in $confinc
	do
		if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
			then
				conpath=$apache/$conlist
			else
				conpath=$conlist
		fi
		if [ `ls -alL $conpath | grep -i 'httpd-autoLinks.conf'|wc -l` -eq 1 ]
			then
				Links=`ls -alL $conpath | grep -i 'httpd-autoLinks.conf' | awk '{print $NF}'`
				incline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|grep $conlist|awk -F":" '{print $1}'`
				incOX="O"
				echo 'Include '$conlist >> $CREATE_FILE_RESULT 2>&1
				ls -alL $Links >> $CREATE_FILE_RESULT 2>&1
		fi
done
if [ \( $incOX = 'X' \) ]
	then
		echo "httpd-autoLinks.conf 파일이 include 되어 있지 않음" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#Start
#Include
if [ \( $incOX = 'O' \) ]
	then
		echo '[httpd-autoLinks.conf - MultiLinks 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $Links ]
			then
				cat $Links |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| FollowSymLinks|</Directory' >> $CREATE_FILE_RESULT 2>&1
				if [ `cat $Links |grep -v '#'|grep -i ' Options'|grep -i ' FollowSymLinks'|wc -l` -eq 0 ]
					then
						echo 'MultiLinks 옵션 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
						result9='취약'
				fi
			else
				echo 'httpd-autoLinks.conf 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
		fi
fi

#httpd.conf
echo '[httpd.conf 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		cat $conf/httpd.conf |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| FollowSymLinks|</Directory' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $conf/httpd.conf |grep -v '#'|grep -i ' Options'|grep -i ' FollowSymLinks'|wc -l` -eq 0 ]
			then
				echo 'MultiLinks 옵션 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
				result9='취약'
		fi
fi

#End

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '웹 서버의 설정 파일에서 FollowSymLinks 옵션을 제거를 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result9 = '양호' \) ]
#	then
#		echo '■ 양호 - FollowSymLinks 옵션 비활성화' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 취약 - FollowSymLinks 옵션 비활성화' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0110 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.11 ===================================='
echo "0111 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.11 MultiViews 옵션 비활성화'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '<Directory>노드에 MultiViews옵션이 제한 또는 제거되어있는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-autoindex.conf 파일 include 여부]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result10='양호'
for conlist in $confinc
	do
		if [ `echo $conlist | grep "^/" | wc -l` -eq 0 ]
			then
				conpath=$apache/$conlist
			else
				conpath=$conlist
		fi
		if [ `ls -alL $conpath | grep -i 'httpd-autoViews.conf'|wc -l` -eq 1 ]
			then
				Views=`ls -alL $conpath | grep -i 'httpd-autoViews.conf' | awk '{print $NF}'`
				incline=`cat $conf/httpd.conf |grep -n " "|grep -v '#'|grep $conlist|awk -F":" '{print $1}'`
				incOX="O"
				echo 'Include '$conlist >> $CREATE_FILE_RESULT 2>&1
				ls -alL $Views >> $CREATE_FILE_RESULT 2>&1
		fi
done
if [ \( $incOX = 'X' \) ]
	then
		echo "httpd-autoViews.conf 파일이 include 되어 있지 않음" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#Start
#Include
if [ \( $incOX = 'O' \) ]
	then
		echo '[httpd-autoViews.conf - MultiViews 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $Views ]
			then
				cat $Views |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| MultiViews|</Directory' >> $CREATE_FILE_RESULT 2>&1
				if [ `cat $Views |grep -v '#'|grep -i ' Options'|grep -i ' MultiViews'|wc -l` -eq 0 ]
					then
					echo 'MultiViews 옵션 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
					echo ' ' >> $CREATE_FILE_RESULT 2>&1
				else
					echo ' ' >> $CREATE_FILE_RESULT 2>&1
					result10='취약'
				fi
			else
				echo 'httpd-autoViews.conf 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
		fi
fi

#httpd.conf
echo '[httpd.conf 설정 확인]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		cat $conf/httpd.conf |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| MultiViews|</Directory' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $conf/httpd.conf |grep -v '#'|grep -i ' Options'|grep -i ' MultiViews'|wc -l` -eq 0 ]
			then
			echo 'MultiViews 옵션 설정이 없음' >> $CREATE_FILE_RESULT 2>&1
			echo ' ' >> $CREATE_FILE_RESULT 2>&1
		else
			echo ' ' >> $CREATE_FILE_RESULT 2>&1
			result10='취약'
		fi
fi

#End


echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '웹 서버의 설정 파일에서 MultiViews 옵션 제거를 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result10 = '양호' \) ]
#	then
#		echo '■ 양호 - MultiViews 옵션 비활성화' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 취약 - MultiViews 옵션 비활성화' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0111 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1







echo '============================== 2.1 ===================================='
echo "0201 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.1 불필요한 Manual 파일 및 디렉터리 삭제'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '불필요한 Manual 디렉터리 및 기본 CGI스크립트가 존재하지 않으면 양호 ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

echo '| CGI 스크립트 확인 | ' >> $CREATE_FILE_RESULT 2>&1
if [ \( `ls -alL $apache/cgi-bin/ | grep printenv|wc -l` -eq 0 \) -a \( `ls -alL $apache/cgi-bin/ | grep test-cgi|wc -l` -eq 0 \) ]
then 
	echo 'CGI 스크립트가 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
else
	ls -alL $apache/cgi-bin/ >> $CREATE_FILE_RESULT 2>&1
fi

echo '' >> $CREATE_FILE_RESULT 2>&1
echo '| Manual 디렉터리 확인 |' >> $CREATE_FILE_RESULT 2>&1
if [ `ls -alL $apache/ | grep manual | wc -l` -eq 0 ]
then
	echo 'Manual 디렉터리가 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
else
	ls -alL $apache/ | grep manual >> $CREATE_FILE_RESULT 2>&1	
fi

result21='양호'

if [ \( `ls -alL $apache/cgi-bin/ | grep printenv|wc -l` -eq 0 \) -a \( `ls -alL $apache/cgi-bin/ | grep test-cgi|wc -l` -gt 0 \) ]
	then
		result21='취약'
fi

if [ `ls -alL $apache/ | grep -i manual | wc -l` -gt 0 ]
then
	result21='취약'
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo 'Manual 디렉토리 및 기본 CGI 스크립트 삭제를 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ $result21 = '취약' ]
#	then
#		echo '■ 취약 - 불필요한 Manual 디렉토리 삭제' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 양호 - 불필요한 Manual 디렉토리 삭제' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0201 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1





echo '============================== 2.2 ===================================='
echo "0202 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.2 WebDAV 제한 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo 'Dva Module Load 시 WebDAV 제한 설정이 되어 있으면 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1
echo '| Dav 모듈 사용 제한 : 모듈 Load 확인 |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -eq 0 ]
then
	echo 'Dav 모듈을 Load하고 있지 않음' >> $CREATE_FILE_RESULT 2>&1
else
	cat $conf/httpd.conf | grep -i LoadModule | grep -i Dav  >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	echo '| Dav 모듈 사용 제한 : Dav on 설정 확인 |' >> $CREATE_FILE_RESULT 2>&1
	if [ `cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep -i "On|Off" | wc -l` -gt 0 ]
		then
			cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep "on|off" >> $CREATE_FILE_RESULT 2>&1
		else
			echo 'Dav On/Off 설정이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	fi
fi

result22='양호'


if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -gt 0 ]
	then
		if [ `cat $conf/httpd.conf | grep -i dav | grep -i on | grep -v '#' |wc -l` -gt 0 ]
			then
				result22='취약'
		fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '   TraceEnable Off 설정과 Dav 모듈을 Load할 경우 Dav Off 설정을 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ $result22 = '취약' ]
#	then
#		echo '■ 취약 - HTTP Method 제한' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 양호 - HTTP Method 제한' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0202 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1





echo '============================== 3.1 ===================================='
echo "0301 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 3.1 보안 패치 적용'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '■ 기준' >> $CREATE_FILE_RESULT 2>&1
echo '서비스 침해 방지를 위하여 주기적인 보안패치를 적용하는 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '■ 현황' >> $CREATE_FILE_RESULT 2>&1

if [ -f $apache/bin/apachectl ]
	then
		apachectl=$apache/bin/apachectl
	else
		if [ -f $apache/sbin/apachectl ]
			then
				apachectl=$apache/sbin/apachectl
			else
				if [ `ps -ef | grep -v grep | grep apachectl | grep -v grep | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '\/apachectl' | grep "^/" | sort -u | wc -l` -eq 1 ]
					then
						apachectl=`ps -ef | grep -v grep | grep apachectl | grep -v grep | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '\/apachectl' | grep "^/" | sort -u`
					else
						apachectl=`ps -ef | grep -v grep | grep apachectl | grep " 1 " | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '\/apachectl' | grep "^/"`
				fi
		fi
fi

ver=`$apachectl -v |head -1|awk -F' ' '{print $3}'`
ver1=`echo $ver |awk -F'/' '{print $2}'|awk -F'.' '{print $1}'`
ver2=`echo $ver |awk -F'/' '{print $2}'|awk -F'.' '{print $2}'`
ver3=`echo $ver |awk -F'/' '{print $2}'|awk -F'.' '{print $3}'`

if [ `echo $apachectl -v | wc -l` -ge 1 ]
then
echo $ver  >> $CREATE_FILE_RESULT 2>&1

if [ $ver1 -eq 1 -a $ver2 -eq 3 ]
	then
		if [ $ver3 -ge 37 ]
		then
			result31='양호'
		else
			result31='취약'
		fi
fi
if [ $ver1 -eq 2 -a $ver2 -eq 0 ]
	then
		if [ $ver3 -ge 65 ]
			then
			result31='양호'
		else
			result31='취약'
		fi		
fi
if [ $ver1 -eq 2 -a $ver2 -eq 2 ]
	then
		if [ $ver3 -ge 20 ]
			then
			result31='양호'
		else
			result31='취약'
		fi
fi
if [ $ver1 -eq 2 -a $ver2 -eq 4 ]
	then
		if [ $ver3 -ge 3 ]
			then
			result31='양호'
		else
			result31='취약'
		fi
fi

else
echo '버전 정보를 찾을 수 없음(수동 확인 필요)' >> $CREATE_FILE_RESULT 2>&1
result31='취약'
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '아래 사이트 및 최신 버전을 참고하여 서비스 영향도 평가 후 패치를 권고' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ $result31 = '취약' ]
#	then
#		echo '■ 취약 - 보안 패치 적용' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '■ 양호 - 보안 패치 적용' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '※ Apache Securty Update:' >> $CREATE_FILE_RESULT 2>&1
echo 'http://httpd.apache.org/security_report.html' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[최신 버전]' >> $CREATE_FILE_RESULT 2>&1
echo 'Apache 2.4.29' >> $CREATE_FILE_RESULT 2>&1
echo 'Apache 2.2.34' >> $CREATE_FILE_RESULT 2>&1
echo 'Apache 2.0.65' >> $CREATE_FILE_RESULT 2>&1
echo 'Apache 1.3.37' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0301 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '****************************** End ***********************************' 
echo ' =================== ※ 참고 httpd.conf ==================='  >> $CREATE_FILE_RESULT 2>&1
cat $apache/conf/httpd.conf  >> $CREATE_FILE_RESULT 2>&1

#end script