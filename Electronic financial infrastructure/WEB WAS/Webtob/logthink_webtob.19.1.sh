#!/bin/sh

LANG=C
export LANG

CREATE_FILE_RESULT=`hostname`"_"`date +%m%d%s`"_webtob_think.txt"
#OUTCONF=`hostname`"_"`date +%m%d%s`"_config_think.txt"

Version=19.1
Last_modify=2019.02

echo ""
echo "###########################################################################"
echo "# Copyright (c) 2019 SK think Co. Ltd. All Rights Reserved. Ver$Version #"
echo "#                     Last modify date $Last_modify						#"
echo "###########################################################################"
echo ""
echo ""
echo "################# WebtoB 진단 스크립트를 실행하겠습니다 ###################"
echo ""
echo ""

alias ls=ls
alias grep=/bin/grep

echo '[WebtoB 구동 경로]'
env |grep WEBTOBDI
echo ''
echo "  ${WEBTOBDIR}/config/를 입력하십시오. "
while true
do 
   echo "    (ex. /usr/local/webtob/config/) : " 
   read webtob
   if [ $webtob ]
      then
         if [ -d $webtob ]
            then 
               break
            else
               echo "   입력하신 디렉토리가 존재하지 않습니다. 다시 입력하여 주십시오."
               echo " "
         fi
    else
         echo "   잘못 입력하셨습니다. 다시 입력하여 주십시오."
         echo " "
   fi
done
echo " "


echo '[WebtoB 구동 환경파일]'
ls -al $webtob
echo ''
echo "  [환경파일.m]를 입력하십시오. "
while true
do 
   echo "    (ex. testweb.m) : " 
   read webtobm
   if [ $webtobm ]
      then
         if [ -f $webtob/$webtobm ]
            then 
               break
            else
               echo "   입력하신 파일이 존재하지 않습니다. 다시 입력하여 주십시오."
               echo " "
         fi
    else
         echo "   잘못 입력하셨습니다. 다시 입력하여 주십시오."
         echo " "
   fi
done
echo " "

echo $webtob
echo $webtobm

echo "****************************** Start **********************************" 
echo "########################################################################################################" >> $CREATE_FILE_RESULT 2>&1
echo "#                       Copyright (c) 2018 think Co. Ltd. All Rights Reserved.   Ver$Version         #" >> $CREATE_FILE_RESULT 2>&1
echo "#                                            Last modify date $Last_modify		       				 #" >> $CREATE_FILE_RESULT 2>&1
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
echo '============================== 1.1 ===================================='
echo "0101 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.1 데몬 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'deploy된 계정이 root인지 확인 (root 구동 시 취약)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1



if [ `ps -ef | grep webtob | grep -v grep |wc -l` -eq 0 ]
	then
	echo 'WebtoB가 구동되고 있지 않습니다.' >> $CREATE_FILE_RESULT 2>&1
	result1='N/A'
else
	ps -ef |grep webtob |grep -v grep >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1

	if [ `ps -ef | grep webtob | grep -v grep | grep -v root | wc -l` -eq 0 ]
		then
                    	result1='Vulnerability'
	else
		result1='Good'
		fuser=`ps -ef |grep webtob | grep -v grep |awk '{print  $1}' | head -1`
		
		echo '[Webtob /etc/passwd]' >> $CREATE_FILE_RESULT 2>&1
                       	fuserbin=`cat /etc/passwd | grep $fuser | awk -F':' '{print  $7}' |awk -F'/' '{print $3}'|head -1`

		cat /etc/passwd |grep $fuser >> $CREATE_FILE_RESULT 2>&1
	fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#echo '[결과]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result1 = 'Vulnerability' ]
#	then
#	echo '[root] 계정으로 설정되어 있어 Web Applincation 취약점이나 Buffer Overflow 취약점 등을 이용하는 공격자에게 [root] 권한을 획득이 가능함.' >> $CREATE_FILE_RESULT 2>&1
#	echo '(root권한이 아닌 로그인이 불가능한 일반계정으로 WebtoB 구동을 권고함)' >> $CREATE_FILE_RESULT 2>&1
#fi
#echo '' >> $CREATE_FILE_RESULT 2>&1

#echo '[bin]' >> $CREATE_FILE_RESULT 2>&1

#if [ \( $fuserbin = 'nologin' \) -o \( $fuserbin = 'false' \) ]
#     	then 
#	echo $fuserbin '   =   Good'>> $CREATE_FILE_RESULT 2>&1
#else
#	echo $fuserbin '   =   Vulnerability' >> $CREATE_FILE_RESULT 2>&1
#fi

#echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo '[구동 계정]' >> $CREATE_FILE_RESULT 2>&1

#echo $fuser '   =   ' $result1>> $CREATE_FILE_RESULT 2>&1
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
echo 'Server Root 에 750이하의 퍼미션이 부여되어있는지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm |grep WEBTOBDIR >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm |grep DOCROOT >> $CREATE_FILE_RESULT 2>&1


swebtob=`cat $webtob/$webtobm |grep WEBTOBDIR|awk -F'"' '{print $2}'`
dwebtob=`cat $webtob/$webtobm |grep DOCROOT|awk -F'"' '{print $2}'`


echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[ DocumentRoot ]' $dwebtob >> $CREATE_FILE_RESULT 2>&1
ls -al $dwebtob|grep '.r........'|head -1 >> $CREATE_FILE_RESULT 2>&1
dresult2=`ls -al  $dwebtob|grep '..........'|head -1|awk '{print $1}'`

echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[ ServerRoot ]' $swebtob >> $CREATE_FILE_RESULT 2>&1
ls -al $swebtob|grep '.r........'|head -1 >> $CREATE_FILE_RESULT 2>&1
sresult2=`ls -al  $swebtob|grep '..........'|head -1|awk '{print $1}'`
echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#echo '[결과]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
echo '권고사항 : DocumentRoot' $dwebtob '의 접근권한도 755로 변경할 것을 권고함.'>> $CREATE_FILE_RESULT 2>&1
#echo '(퍼미션 750이하로 설정을 권고함)' >> $CREATE_FILE_RESULT 2>&1


#if [ `ls -al $dwebtob|awk '{print $1}'|grep '..........'|head -1|grep '.r......-.'|wc -l` -eq 0 ]
#	then
#
#	echo 'DocumentRoot 퍼미션   :   ' $dresult2 '   =   Vulnerability' >> $CREATE_FILE_RESULT 2>&1
#else
#	echo 'DocumentRoot 퍼미션   :   ' $dresult2 '   =   Good' >> $CREATE_FILE_RESULT 2>&1
#fi
#if [ `ls -al $swebtob|awk '{print $1}'|grep '..........'|head -1|grep '.r......-.'|wc -l` -eq 0 ]
#	then
#	echo 'ServerRoot 퍼미션   :   ' $sresult2 '   =   Vulnerability' >> $CREATE_FILE_RESULT 2>&1
#else
#	echo 'ServerRoot 퍼미션   :   ' $sresult2 '   =   Good' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0102 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.3 ===================================='
echo "0103 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.3 설정파일 권한 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '설정파일은 600이하 퍼미션이 부여되어있는지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
ls -al $webtob/$webtobm >> $CREATE_FILE_RESULT 2>&1
ls -al $webtob/wsconfig >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#echo '| ' $webtobm ' |' >> $CREATE_FILE_RESULT 2>&1


#if [ `ls -al $webtob/$webtobm |grep -v '.r.....---'|wc -l` -eq 0 ]
#	then
#	echo '640이하로 설정되어 있음' >> $CREATE_FILE_RESULT 2>&1
#	result3='Good'
#else
#	echo '부적절한 퍼미션으로 설정되어 있음' >> $CREATE_FILE_RESULT 2>&1
#	result3='Vulnerability'
#fi

#echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#echo '[결과]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result3 = 'Vulnerability' ]
#	then
#	echo '설정파일 퍼미션이 부적절하게 설정되어 있어 파일 640이하, 디렉토리750이하로 퍼미션 설정을 권고함.' >> $CREATE_FILE_RESULT 2>&1
#fi
#echo '' >> $CREATE_FILE_RESULT 2>&1

#echo '[ '$webtobm ' 파일 퍼미션 ]   =   ' $result3 >> $CREATE_FILE_RESULT 2>&1
#echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0103 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.4 ===================================='
echo "0104 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.4 디렉토리 검색 기능 제거'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'DIRINDEX절이 존재하면 Options 값이 -index로 설정해야함 (-index로 설정되어 있으면 양호, DIRINDEX절이 없으면 양호)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
echo '| DIRINDEX절 |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $webtob/$webtobm |grep DirIndex|wc -l` -eq 0 ]
	then
	echo 'DIRINDEX절이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	result5='Good'
else
	cat $webtob/$webtobm |grep DirIndex >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	 
	echo '| Options |' >> $CREATE_FILE_RESULT 2>&1
	if [ `cat $webtob/$webtobm |grep Options |wc -l` -eq 0 ]
		then
		echo 'Options 설정이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
		result5='Vulnerability'
	else
		cat $webtob/$webtobm |grep Options >> $CREATE_FILE_RESULT 2>&1
		ind=`cat $webtob/$webtobm |grep Options |awk -F'"' '{print $2}'`

		if [ \( $ind = '-Index' \) -o \( $ind = '-index' \) -o \( $ind = '-INDEX' \) ]
			then
			echo '-index 제한설정이 되어 있음'  >> $CREATE_FILE_RESULT 2>&1
		else
			cat $webtob/$webtobm | grep -n index >> $CREATE_FILE_RESULT 2>&1
		fi
	fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#echo '[결과]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result5 = 'Vulnerability' ]
#	then
#	echo 'Options설정이 존재하지 않거나 Index 옵션으로 되어있어 디렉토리 존재하는 경우 모든 파일 리스트가 노출됨'>> $CREATE_FILE_RESULT 2>&1
#	echo '(-Index으로 변경 설정을 권고함.)'>> $CREATE_FILE_RESULT 2>&1
#fi
#	echo '(-Index으로 변경 설정을 권고함.)'>> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

#echo ' 디렉토리 검색 기능 제거   =   ' $result5 >> $CREATE_FILE_RESULT 2>&1
#echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0104 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '============================== 1.5 ===================================='
echo "0105 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.5 로그 디렉토리/파일 권한 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'Log의 경로 확인하여 해당 Log디렉터리의 퍼미션이 750이하, 로그파일 퍼미션이 640이하인지 확인' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[수동]' >> $CREATE_FILE_RESULT 2>&1
echo '로그퍼미션을 수동을 한번 확인하시기 바랍니다.(디렉토리 퍼미션)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm |grep ERRORLOG |grep -v '\*' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm |grep LOGGING |grep -v '\*' >> $CREATE_FILE_RESULT 2>&1

echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[기본경로 log디렉터리권한]' >> $CREATE_FILE_RESULT 2>&1
ls -al $webtob/../ | grep log >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

if [ `cat $webtob/$webtobm |grep SysLogDir|wc -l` -ne 0 ]
	then
	cat $webtob/$webtobm |grep SysLogDir >> $CREATE_FILE_RESULT 2>&1
	sys=`cat $webtob/$webtobm |grep SysLogDir|grep -v '\*'|awk -F'"' '{print $2}'`
fi
if [ `cat $webtob/$webtobm |grep UsrLogDir|wc -l` -ne 0 ]
	then
	cat $webtob/$webtobm |grep UsrLogDir >> $CREATE_FILE_RESULT 2>&1
	usr=`cat $webtob/$webtobm |grep UsrLogDir|grep -v '\*'|awk -F'"' '{print $2}'`
fi

elog=`cat $webtob/$webtobm |grep ERRORLOG |grep -v '\*'|awk -F'"' '{print $2}'`
log=`cat $webtob/$webtobm |grep LOGGING |grep -v '\*'|awk -F'"' '{print $2}'`

log1=`cat $webtob/$webtobm |grep Format|grep $log|awk -F'"' '{print $4}'|awk -F'%' '{print $1}'`
elog1=`cat $webtob/$webtobm |grep Format|grep $elog|awk -F'"' '{print $4}'|awk -F'%' '{print $1}'`

cat $webtob/$webtobm |grep Format|grep $log >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm |grep Format|grep $elog >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

result6='Vulnerability'
	
if [ `cat $webtob/$webtobm |grep UsrLogDir|wc -l` -ne 0 ]
	then
	echo '[로그 파일 퍼미션]' >> $CREATE_FILE_RESULT 2>&1
	ls -al $sys/../ |grep '..........'|grep 'd.........'|head -1 >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	if [ `ls -al $sys/../ |grep '..........'|grep 'd.........'|head -1|grep -v '.r.....---'|wc -l` -eq 0 ]
		then
		result6='Good'
	else
		result6='Vulnerability'
	fi
fi
if [ `cat $webtob/$webtobm |grep SysLogDir|wc -l` -ne 0 ]
	then
	echo '[로그 파일 퍼미션]' >> $CREATE_FILE_RESULT 2>&1
	ls -al $usr/../ |grep '..........'|grep 'd.........'|head -1 >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	if [ `ls -al $usr/../ |grep '..........'|grep 'd.........'|head -1|grep -v '.r.....---'|wc -l` -eq 0 ]
		then
		result6='Good'
	else
		result6='Vulnerability'
	fi
fi

if [ $elog1 = $log1 ]
	then
	echo '| ' $log ' |' >> $CREATE_FILE_RESULT 2>&1
	ls -al $log1*|grep '..........' |grep -v '.r.....---' >> $CREATE_FILE_RESULT 2>&1
	if [ `ls -al $log1*|grep 'd.........'|head -1|grep -v '.......---'|wc -l` -eq 0 ]
		then
		result6_1='Good'
	else
		if [ `ls -al $log1*|grep '..........'|grep -v 'd.........'|grep -v '.......---'|wc -l` -eq 0 ]
			then
			result6_1='Good'
		else
			result6_1='Vulnerability'
		fi
	fi
else
	echo '| ' $log ' |' >> $CREATE_FILE_RESULT 2>&1
	ls -al $log1*|grep '..........' >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1

	echo '| ' $elog ' |' >> $CREATE_FILE_RESULT 2>&1
	ls -al $elog1* |grep '..........' >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	if [ \( `ls -al $log1* |grep '..........' |grep -v '.......---'|wc -l` -eq 0 \) -a \( `ls -al $elog1* |grep '..........'|grep -v '.......---'|wc -l` -eq 0 \) ]
		then
		result6_1='Good'
	else
		result6_1='Vulnerability'
	fi

fi

if [ \( `cat $webtob/$webtobm |grep SysLogDir|wc -l` -ne 0 \) -o \( `cat $webtob/$webtobm |grep UsrLogDir|wc -l` -ne 0 \) ]
	then
	if [ $usr = $sys ]
		then
		echo '| ' $sys ' |' >> $CREATE_FILE_RESULT 2>&1
		ls -al $sys|grep '..........' |grep -v '.r.....---' >> $CREATE_FILE_RESULT 2>&1
		echo ' ' >> $CREATE_FILE_RESULT 2>&1
		if [ `ls -al $sys|grep 'd.........'|head -1|grep -v '.......---'|wc -l` -eq 0 ]
			then
			result6_2='Good'
		else
			if [ `ls -al $sys|grep '.r........'|grep -v 'd.........'|grep -v '.......---'|wc -l` -eq 0 ]
				then
				result6_2='Good'
			else
				result6_2='Vulnerability'
			fi
		fi
	else
		echo '| ' $sys ' |' >> $CREATE_FILE_RESULT 2>&1
		ls -al $sys|grep '..........' |grep -v '.r.....---' >> $CREATE_FILE_RESULT 2>&1
		echo ' ' >> $CREATE_FILE_RESULT 2>&1

		echo '| ' $usr ' |' >> $CREATE_FILE_RESULT 2>&1
		ls -al $usr|grep '..........' |grep -v '.r.....---' >> $CREATE_FILE_RESULT 2>&1
		if [ \( `ls -al $sys|grep '..........' |grep -v '.......---'|wc -l` -eq 0 \) -a \( `ls -al $usr|grep '..........'|grep -v '.......---'|wc -l` -eq 0 \) ]
			then
			result6_2='Good'
		else
			result6_2='Vulnerability'
		fi

	fi
else
	result6_2='Good'
fi

if [ $result6 = 'Good' ]
	then
	result6='Good'
else

	if [ \( $result6_1 = 'Vulnerability' \) -o \( $result6_2 = 'Vulnerability' \) ]
		then
		result6='Vulnerability'
	else
		result6='Good'
	fi
fi



echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#echo '[결과]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result6 = 'Vulnerability' ]
#	then
#	echo '로그파일 퍼미션이 부적절하게 설정되어 있어 파일 640이하, 디렉토리 750이하로 퍼미션 설정을 권고함.'>> $CREATE_FILE_RESULT 2>&1
#	echo '' >> $CREATE_FILE_RESULT 2>&1
#fi
#echo 'Log 퍼미션   =   ' $result6 >> $CREATE_FILE_RESULT 2>&1
#echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0105 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 1.6 ===================================='
echo "0106 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.6 로그 포맷 설정'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'LogFormat을 Combined 수준으로 설정한 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '상세 포맷은 보안가이드라인 참조' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1

cat $webtob/$webtobm |grep Format |grep -v '\*' >> $CREATE_FILE_RESULT 2>&1


echo '' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0106 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0107 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.7 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.7 로그 저장 주기'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '로그를 지침에 맞게 저장 및 관리하지 않은 경우 취약' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
echo "담당자와 인터뷰를 통해 로그 보관 및 관리 현황 파악 필요 (수동점검)" >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0107 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0108 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.8 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.8 헤더 정보 노출 방지'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'ServerTokens 값이 off 인 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm | cut -f 1 -d '#' | egrep -i 'WEBTOBDIR|ServerTokens' > 018temp.txt
if [ `cat 018temp.txt | egrep -i 'ServerTokens' | wc -l` -gt 0 ]; then
	cat 018temp.txt >> $CREATE_FILE_RESULT 2>&1
else
	echo "ServerTokens 설정이 없음." >> $CREATE_FILE_RESULT 2>&1
fi
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0108 END' >> $CREATE_FILE_RESULT 2>&1
rm -rf 018temp.txt
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0109 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.9 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.9 HTTP Method 제한'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo 'GET,POST,HEAD, OPTIONS만 허용된 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm | cut -f 1 -d '#' | egrep -i 'WEBTOBDIR|Method' > 019temp.txt
# Method 제한 설정이 존재할 경우
if [ `cat 019temp.txt | egrep -i 'Method' | wc -l` -gt 0 ]; then
	# HEAD Method를 제한한 경우
	cat 019temp.txt >> $CREATE_FILE_RESULT 2>&1
# Method 제한 설정이 없을 경우
else
	echo "Method 제한 설정이 없음.(Default 양호)" >> $CREATE_FILE_RESULT 2>&1
fi
#echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0109 END' >> $CREATE_FILE_RESULT 2>&1
rm -rf 019temp.txt
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0110 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.10 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.10 패스워드 파일 권한 관리'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '패스워드 파일 퍼미션이 600이하면 양호 (AUTHENT 설정이 없으면 양호)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $webtob/$webtobm | grep -i authent | wc -l` -eq 0 ]
	then
	echo 'AUTHENT 설정이 존재하지 않음. (양호)' >> $CREATE_FILE_RESULT 2>&1
else
	userfile=`cat $webtob/$webtobm |grep -i userfile|awk -F'"' '{print $2}'`
	groupfile=`cat $webtob/$webtobm |grep -i groupfile|awk -F'"' '{print $2}'`
	echo '' >> $CREATE_FILE_RESULT 2>&1
	echo '(1) userfile 퍼미션 |' >> $CREATE_FILE_RESULT 2>&1
	if [ -f $userfile ]
		then
		ls -al $userfile >> $CREATE_FILE_RESULT 2>&1
	else
		echo '패스워드 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	fi

	echo '(2) groupfile 퍼미션 |' >> $CREATE_FILE_RESULT 2>&1
	if [ -f $groupfile ]
		then
		ls -al $groupfile >> $CREATE_FILE_RESULT 2>&1
	else
		echo '패스워드 파일이 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	fi
fi
#echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0110 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
 

echo '0201 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 2.1 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.1 불필요한 디렉터리 삭제'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '불필요한 디렉터리를 삭제하도록 권고' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
if [ `find $webtob -name sample|wc -l` -eq 0 ]
	then
	echo 'Sample 디렉토리가 존재하지 않음' >> $CREATE_FILE_RESULT 2>&1
	Result='S'
else
	find $webtob -name sample >> $CREATE_FILE_RESULT 2>&1
	Result='F'
fi
#echo Result='$Result'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0201 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '0301 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 3.1 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 3.1 보안 패치 적용'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[기준]' >> $CREATE_FILE_RESULT 2>&1
echo '주기적으로 보안패치를 적용한 경우 양호' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[현황]' >> $CREATE_FILE_RESULT 2>&1
$webtob/../bin/wscfl -version >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[최신 버전]' >> $CREATE_FILE_RESULT 2>&1
echo 'WebtoB 5.0 SP0 Fix #1 - 16. 08. 31'>> $CREATE_FILE_RESULT 2>&1
echo 'WebtoB 4.1 SP9 Fix #1 - 16. 06. 22'>> $CREATE_FILE_RESULT 2>&1
echo 'WebtoB 3.X 서비스 종료' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo Result='M/T'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0301 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '****************************** End ***********************************' 
echo "########################http.m config###############################" >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm >> $CREATE_FILE_RESULT 2>&1
echo "####################################################################" >> $CREATE_FILE_RESULT 2>&1
#end script