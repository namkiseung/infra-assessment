
#!/bin/sh
HOSTNAME=`hostname`

LANG=C
export LANG

clear
sleep 1

SVersion=19.1
SLast_update=2019.02

function perm {
	ls -l $1 | awk '{
    k = 0
    s = 0
    for( i = 0; i <= 8; i++ )
    {
        k += ( ( substr( $1, i+2, 1 ) ~ /[rwxst]/ ) * 2 ^( 8 - i ) )
    }
    j = 4
    for( i = 4; i <= 10; i += 3 )
    {
        s += ( ( substr( $1, i, 1 ) ~ /[stST]/ ) * j )
        j/=2
    }
    if ( k )
    {
        printf( "%0o%0o ", s, k )
    } else
        {
                printf ( "0000 " )
        }

    print
	}'
}

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#################################  Preprocessing...  #####################################"
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

find /usr -name su -ls | grep '/bin/'                                                          > su.txt
find /bin -name su -ls | grep '/bin/'                                                          > su1.txt
find /sbin -name su -ls | grep '/bin/'                                                         > su2.txt


#2016 04 15############################## print 8 or 9 구분하기(시작) ##################################
if [ `ps -ef | grep "httpd" | grep -v "ns-httpd" | grep -v "grep" | awk '{print $8}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
then
	apaflag=8
elif [ `ps -ef | grep "httpd" | grep -v "ns-httpd" | grep -v "grep" | awk '{print $9}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
then
	apaflag=9
else
	apaflag=0
fi
#2016 04 15############################## print 8 or 9 구분하기(끝) ##################################

############################### 홈디렉터리 경로 구하기(시작) ##################################
if [ `ps -ef | grep "httpd" | grep -v "ns-httpd" | grep -v "grep" | awk -v apaflag2=$apaflag '{print $apaflag2}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
then
	APROC1=`ps -ef | grep "httpd" | grep -v "ns-httpd" | grep -v "grep" | awk -v apaflag2=$apaflag '{print $apaflag2}' | grep "/" | grep -v "httpd.conf" | uniq`
	APROC=`echo $APROC1 | awk '{print $1}'`

	if [ `$APROC -V | grep -i "root" | wc -l` -gt 0 ]
	then
		AHOME=`$APROC -V | grep -i "root" | awk -F"\"" '{print $2}'`
		ACFILE=`$APROC -V | grep -i "server_config_file" | awk -F"\"" '{print $2}'`
	else
		echo "httpd -V 옵션 사용 불가하여 $APROC를 sed로 conf/httpd.conf 변환함" > Inf_apaTemp.txt
		AHOME=`echo $APROC | sed 's/\/bin\/httpd//g'`
		ACFILE="conf/httpd.conf"
		#ACONF=`echo $APROC | sed 's/\/bin\/httpd/\/conf\/httpd.conf/g'`
	fi

	if [ -f $AHOME/$ACFILE ]
	then
		ACONF=$AHOME/$ACFILE
	else
		ACONF=$ACFILE
	fi	
fi
################################ 홈디렉터리 경로 구하기(끝) ###################################

# FTP 서비스 동작확인
find /etc/ -name "proftpd.conf" | grep "/etc/"                                                     > proftpd.txt
find /etc/ -name "vsftpd.conf" | grep "/etc/"                                                      > vsftpd.txt
profile=`cat proftpd.txt`
vsfile=`cat vsftpd.txt`

clear

echo " " > $HOSTNAME.aix.result.txt 2>&1

echo "***************************************************************************************"
echo "***************************************************************************************"
echo "*                                                                                     *"
echo "*  AIX Security Checklist version $SVersion                                           *"
echo "*                                                                                     *"
echo "***************************************************************************************"
echo "***************************************************************************************"

echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo "■■■■■■■■■■■■■■■■■■■               AIX Security Check           	 ■■■■■■■■■■■■■■■■■■■■" >> $HOSTNAME.aix.result.txt 2>&1
echo "■■■■■■■■■■■■■■■■■■■      Copyright ⓒ 2019, SK think Co. Ltd.    ■■■■■■■■■■■■■■■■■■■■" >> $HOSTNAME.aix.result.txt 2>&1
echo "■■■■■■■■■■■■■■■■■■■     Ver $SVersion // Last update $SLast_update ■■■■■■■■■■■■■■■■■■■■" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "##################################  Start Time  #######################################"
date
echo "##################################  Start Time  #######################################" >> $HOSTNAME.aix.result.txt 2>&1
date                                                                                           >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "*************************************** START *****************************************"
echo "*************************************** START *****************************************" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "############################        1. 사용자 인증       #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0101 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           root 계정 원격 접속 제한            ####################"
echo "####################           root 계정 원격 접속 제한            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: [telnet] /etc/security/user 파일에서 root: rlogin=false이면 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 기준: [SSH] /etc/ssh/sshd_config 파일에 PermitRootLogin no로 설정되어 있을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① [telnet] /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② [telnet] 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep *.$port | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep *.$port | grep -i "^tcp"                                                >> $HOSTNAME.aix.result.txt 2>&1
		flag1="Enabled"
	else
		echo "☞ Telnet Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
		flag1="Disabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "③ [telnet] /etc/security/user 파일 설정"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1

if [ -f /etc/security/user ]
then
	echo "☞ Default 설정 확인" 								                                                 >> $HOSTNAME.aix.result.txt 2>&1
  if [ `awk '/default:/,/root:/' /etc/security/user | grep -v '^ *$'| grep -i "rlogin" | grep "=" | wc -l` -eq 0 ]
  then
  	echo "default 설정: rlogin 설정 없음"                                                         >> $HOSTNAME.aix.result.txt 2>&1
  else
  	awk '/default:/,/root:/' /etc/security/user | grep -v '^ *$'| grep -i "rlogin" | grep "=" | awk '{print "default 설정:" $0}' >> $HOSTNAME.aix.result.txt 2>&1
		default=`awk '/default:/,/root:/' /etc/security/user | grep -v '^ *$'| grep -i "rlogin" | grep "=" | awk -F= '{print $2}' | sed -e 's/^ *//g' -e 's/ *$//g'`
  fi
	
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
  echo "☞ root 설정 확인" 											                                                 >> $HOSTNAME.aix.result.txt 2>&1
  if [ `awk '/root:/,/daemon:/' /etc/security/user | grep -v '^ *$'| grep -i "rlogin" | grep "=" | wc -l` -eq 0 ]
  then
  	echo "root 설정: rlogin 설정 없음"                                                         >> $HOSTNAME.aix.result.txt 2>&1
  else
  	awk '/root:/,/daemon:/' /etc/security/user | grep -v '^ *$'| grep -i "rlogin" | grep "=" | awk '{print "root 설정:" $0}' >> $HOSTNAME.aix.result.txt 2>&1
  	root=`awk '/root:/,/daemon:/' /etc/security/user | grep -v '^ *$'| grep -i "rlogin" | grep "=" | awk -F= '{print $2}' | sed -e 's/^ *//g' -e 's/ *$//g'`
  fi
  else
  echo "/etc/security/user파일이 없습니다."                                                    >> $HOSTNAME.aix.result.txt 2>&1
fi

if [ $root = "false" ]
then
	flag2="O"
else
	if [ $default = "false" ]
	then
		flag2="O"
	else
		flag2="F"
	fi	
fi

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "④ [SSH] 서비스 구동 확인"                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo "--------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
  then
   echo "☞ SSH Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
   flag3="Disabled"
  else
   ps -ef | grep sshd | grep -v grep                                                           >> $HOSTNAME.aix.result.txt 2>&1
	flag3="Enabled"
   fi

echo " " >> $HOSTNAME.aix.result.txt 2>&1

echo "⑤ [SSH] /etc/ssh/sshd_config 파일 확인 " >> $HOSTNAME.aix.result.txt 2>&1
echo "--------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/ssh/sshd_config | egrep -i 'PermitRootLogin' | wc -l` -eq 0 ]
  then
   echo "☞ sshd_config 파일 설정이 안되어 있음 " >> $HOSTNAME.aix.result.txt 2>&1
	flag4="Fail"
  else
   cat /etc/ssh/sshd_config | egrep -i 'PermitRootLogin' >> $HOSTNAME.aix.result.txt 2>&1
	flag4="M/T"
   fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2":"$flag3":"$flag4                                              >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0101 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                       


echo "0102 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           계정 잠금 임계값 설정            ####################"
echo "####################           계정 잠금 임계값 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 계정 잠금 임계 값이 적절하게 설정되어 있는 경우 양호 (권고: 5회 이하)"                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (loginretries 값이 설정되어 있으면 양호)"                                      >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/security/user ]
then
	awk '/default:/,/root:/' /etc/security/user | grep -v '^ *$'| grep -i "loginretries" | grep "=" | awk '{print "Default 설정:" $0}' >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "☞ /etc/security/user 파일이 없습니다."                                                >> $HOSTNAME.aix.result.txt 2>&1
fi

egrep ":$|loginretries" /etc/security/user                                                     > account-loginretries.txt

if [ `cat account-loginretries.txt | grep loginretries | grep -v "*" | wc -l` -eq 0 ]
then
	flag="F"
else
	grep -v '*' account-loginretries.txt | grep loginretries | awk '!x[$0]++' | awk -F= '{print $2}' | sed -e 's/^ *//g' -e 's/ *$//g' > temp112.txt
	for ret in `cat temp112.txt`
	do
		if [ $ret -gt 5 ]
		then
			flag="F"
			break
		else
			flag="O"
		fi	
	done
fi


echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag		                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0102 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf account-loginretries.txt
rm -rf temp112.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "############################        2. 계정 관리        #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0201 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           계정이 존재하지 않는 GID 금지            ####################"
echo "####################           계정이 존재하지 않는 GID 금지            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 구성원이 존재하지 않는 빈 그룹이 발견되지 않을 경우 양호"                        >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 구성원이 존재하지 않는 그룹"                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1

	for gid in `awk -F: '$4==null {print $3}' /etc/group`
	do
		if [ `grep -c $gid /etc/passwd` -eq 0 ]
		then
			grep $gid /etc/group                                                                     >> nullgid.txt
		fi		
	done

if [ `cat nullgid.txt | wc -l` -eq 0 ]
then
		echo "구성원이 존재하지 않는 그룹이 발견되지 않았습니다."                                  >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=0 	                                                                           >> $HOSTNAME.aix.result.txt 2>&1
else
		cat nullgid.txt                                                                            >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=`cat nullgid.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`                    >> $HOSTNAME.aix.result.txt 2>&1
fi


echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0201 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf nullgid.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "0202 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           사용자 shell 점검            ####################"
echo "####################           사용자 shell 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 로그인이 필요하지 않은 시스템 계정에 /bin/false(nologin) 쉘이 부여되어 있으면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 로그인이 필요하지 않은 시스템 계정 확인"                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1

if [ -f /etc/passwd ]
  then
   cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher" | grep -v "admin" > temp202.txt 
   cat temp202.txt 																																						 >> $HOSTNAME.aix.result.txt 2>&1
   echo " "                                                                                    >> $HOSTNAME.aix.result.txt 2>&1
   echo Result=`egrep -v "false|nologin" temp202.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'` >> $HOSTNAME.aix.result.txt 2>&1
    
  else
    echo "/etc/passwd 파일이 없습니다."                                                        >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=0                                                                              >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0202 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf temp202.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "###########################        3. 비밀번호 관리        #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0301 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           SNMP 서비스 Get community 스트링 설정 오류            ####################"
echo "####################           SNMP 서비스 Get community 스트링 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SNMP Get Community 이름이 public 이 아닐 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1) SNMP V1을 사용할 경우: /etc/snmpd.conf (/usr/sbin/snmpd)"                  >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2) SNMP V3을 사용할 경우: /etc/snmpdv3.conf (/usr/sbin/snmpd -> snmpdv3ne)"   >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① SNMP 서비스 활성화 여부 확인(UDP 161)"                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `netstat -na | grep "*.161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "☞ SNMP Service Disable"                                                               >> $HOSTNAME.aix.result.txt 2>&1
else
	netstat -na | grep "*.161 " | grep -i "^udp"                                                 >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② SNMP Community String 설정 값"                                                        >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo "● SNMP 버전 확인: `find /usr -name snmpd -ls | grep -v "sample" | awk '{print $11 $12 $13 $14}'`" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/snmpd.conf ]
then
	echo "● /etc/snmpd.conf 파일 설정:"                                                          >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.aix.result.txt 2>&1
	cat /etc/snmpd.conf | egrep -i "public|private|community" | grep -v "^#"                   >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "● /etc/snmpd.conf 파일 설정: 해당 파일 없음."                                          >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/snmpdv3.conf ]
then
	echo "● /etc/snmpdv3.conf 파일 설정:"                                                        >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.aix.result.txt 2>&1
	cat /etc/snmpdv3.conf | egrep -i "public|private|community" | grep -v "^#"                 >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "● /etc/snmpdv3.conf 파일 설정: 해당 파일 없음."                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0301 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0302 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           SNMP 서비스 Set community 스트링 설정 오류            ####################"
echo "####################           SNMP 서비스 Set community 스트링 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SNMP Set Community 이름이 public, private 이 아닐 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1) SNMP V1을 사용할 경우: /etc/snmpd.conf (/usr/sbin/snmpd)"                  >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2) SNMP V3을 사용할 경우: /etc/snmpdv3.conf (/usr/sbin/snmpd -> snmpdv3ne)"   >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① SNMP 서비스 활성화 여부 확인(UDP 161)"                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `netstat -na | grep "*.161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "☞ SNMP Service Disable"                                                               >> $HOSTNAME.aix.result.txt 2>&1
else
	netstat -na | grep "*.161 " | grep -i "^udp"                                                 >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② SNMP Community String 설정 값"                                                        >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo "● SNMP 버전 확인: `find /usr -name snmpd -ls | grep -v "sample" | awk '{print $11 $12 $13 $14}'`" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/snmpd.conf ]
then
	echo "● /etc/snmpd.conf 파일 설정:"                                                          >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.aix.result.txt 2>&1
	cat /etc/snmpd.conf | egrep -i "public|private|community" | grep -v "^#"                   >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "● /etc/snmpd.conf 파일 설정: 해당 파일 없음."                                          >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/snmpdv3.conf ]
then
	echo "● /etc/snmpdv3.conf 파일 설정:"                                                        >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.aix.result.txt 2>&1
	cat /etc/snmpdv3.conf | egrep -i "public|private|community" | grep -v "^#"                 >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "● /etc/snmpdv3.conf 파일 설정: 해당 파일 없음."                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0302 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0303 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           비밀번호 관리정책 점검            ####################"
echo "####################           비밀번호 관리정책 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/security/user 의 default: 섹션 밑의 비밀번호 관련 정책들이 설정되어 있을 경우 양호"                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/security/user ]
then
  cat /etc/security/user | grep -v "^*"                                                           >> $HOSTNAME.aix.result.txt 2>&1
else
  echo "/etc/security/user 파일이 없습니다."                                                          >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0303 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "0304 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           비밀번호 저장파일 보호            ####################"
echo "####################           비밀번호 저장파일 보호            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: AIX 서버는 기본적으로 /etc/security/passwd 파일에 패스워드를 암호화하여 저장함으로 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/passwd ]
then
	if [ `awk -F: '$2=="!"' /etc/passwd | wc -l` -eq 0 ]
	then
		echo "☞ /etc/passwd 파일에 패스워드가 암호화 되어 있지 않습니다. (취약)"                  >> $HOSTNAME.aix.result.txt 2>&1
		flag="F"
	else
		echo "☞ /etc/passwd 파일에 패스워드가 암호화 되어 있습니다. (양호)"                       >> $HOSTNAME.aix.result.txt 2>&1
		flag="O"
	fi
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo "[참고]"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
	cat /etc/passwd | head -5                                                                    >> $HOSTNAME.aix.result.txt 2>&1
	echo "이하생략..."                                                                           >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "☞ /etc/passwd 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
fi

echo " "     	                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag		                                                                           >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0304 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "0305 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           관리되지 않는 계정 및 비밀번호 점검            ####################"
echo "####################           관리되지 않는 계정 및 비밀번호 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준1: 불필요한 계정이 존재하지 않는 경우 양호(90일 이상 로그인 하지 않는 계정 포함)"							                           >> $HOSTNAME.aix.result.txt 2>&1
echo "■     : /etc/passwd 파일 내용을 참고하여 불필요한 계정 식별 (인터뷰 필요)"               >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준2: 최종 패스워드 변경일이 90일 이전인 경우 양호"                                    >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/passwd 파일 내용"                          							                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
    cat /etc/passwd                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 계정명, 가장 최근 패스워드 변경일(1970.1.1을 기준으로 초단위)"                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
egrep ":|lastupdate" /etc/security/passwd													   >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"		                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0305 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "0306 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           유추가능한 비밀번호 사용 여부            ####################"
echo "####################           유추가능한 비밀번호 사용 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 패스워드 필드에 유추가 불가능한 값으로 설정된 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/security/passwd									                                 >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0306 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "###########################    4. 파일 및 디렉터리 관리    #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0401 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           /dev에 존재하지 않는 device 파일 점검            ####################"
echo "####################           /dev에 존재하지 않는 device 파일 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준 : dev 에 존재하지 않은 Device 파일을 점검하고, 존재하지 않은 Device을 제거 했을 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■        : (아래 나열된 결과는 major, minor Number를 갖지 않는 파일임)"                  >> $HOSTNAME.aix.result.txt 2>&1
echo "■        : (.devlink_db_lock/.devfsadm_daemon.lock/.devfsadm_synch_door/.devlink_db는 Default로 존재 예외)" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
find /dev -type f -exec ls -l {} \;                                                            > 4.01.txt

if [ -s 4.01.txt ]
then
	cat 4.01.txt                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "☞ dev 에 존재하지 않은 Device 파일이 발견되지 않았습니다."                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0401 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf 4.01.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0402 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           홈디렉토리로 지정한 디렉토리의 존재 관리            ####################"
echo "####################           홈디렉토리로 지정한 디렉토리의 존재 관리            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 홈 디렉터리가 존재하지 않는 계정이 발견되지 않으면 양호"                         >> $HOSTNAME.aix.result.txt 2>&1
# 홈 디렉토리가 존재하지 않는 경우, 일반 사용자가 로그인을 하면 사용자의 현재 디렉터리가 /로 로그인 되므로 관리,보안상 문제가 발생됨.
# 예) 해당 계정으로 ftp 로그인 시 / 디렉터리로 접속하여 중요 정보가 노출될 수 있음.
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 홈 디렉터리가 존재하지 않은 계정"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
flag=0
for dir in $HOMEDIRS
do
	if [ ! -d $dir ]
	then
		awk -F: '$6=="'${dir}'" { print "● 계정명(홈디렉터리):"$1 "(" $6 ")" }' /etc/passwd        >> $HOSTNAME.aix.result.txt 2>&1
		flag=`expr $flag + 1`
		echo " "                                                                                   > 4.02.txt
	fi
done

if [ ! -f 4.02.txt ]
then
	echo "홈 디렉터리가 존재하지 않은 계정이 발견되지 않았습니다. (양호)"                        >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=0                                                                                >> $HOSTNAME.aix.result.txt 2>&1
else
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0402 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf 4.02.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0403 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           숨겨진 파일 및 디렉토리 검색 및 제거            ####################"
echo "####################           숨겨진 파일 및 디렉토리 검색 및 제거            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 디렉토리 내에 숨겨진 파일을 확인 및 검색 하여, 불필요한 파일을 삭제를 완료한 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
find /tmp -name ".*" -ls                                                                       > temp403.txt
find /home -name ".*" -ls                                                                      >> temp403.txt
find /usr -name ".*" -ls                                                                       >> temp403.txt
find /var -name ".*" -ls                                                                       >> temp403.txt
head -10 temp403.txt                                                                           >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "위에 리스트에서 숨겨진 파일 확인"                                                        >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0403 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "###########################        5. 서비스 관리        #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0501 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           ftp 계정 shell 제한            ####################"
echo "####################           ftp 계정 shell 제한            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: ftp 서비스가 비활성화 되어 있을 경우 양호"                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : ftp 서비스 사용 시 ftp 계정에 /bin/false 쉘을 부여하면 양호"  >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                  >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(2)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"              >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(2)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(3)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                               >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(3)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep "*.21 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo "③ ftp 계정 쉘 확인"                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ `cat /etc/passwd | awk -F: '$1=="ftp"' | wc -l` -gt 0 ]
	then
		cat /etc/passwd | awk -F: '$1=="ftp"'                                                        >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat /etc/passwd | awk -F: '$1=="ftp" {print $7}' | egrep -v "nologin|false" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "ftp 계정이 존재하지 않음.(양호)"                                                       >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat /etc/passwd | awk -F: '$1=="ftp"' | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	fi
	
else
	echo "☞ FTP Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0501 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0502 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           SNMP 서비스 구동 점검            ####################"
echo "####################           SNMP 서비스 구동 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SNMP 서비스를 불필요한 용도로 사용하지 않을 경우 양호"                           >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
# SNMP서비스는 동작시 /etc/service 파일의 포트를 사용하지 않음.
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ `netstat -na | grep "*.161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "☞ SNMP Service Disable"                                                               >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Disabled"                                                                         >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "☞ SNMP 서비스 활성화 여부 확인(UDP 161)"                                              >> $HOSTNAME.aix.result.txt 2>&1
  echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
	netstat -na | grep "*.161 " | grep -i "^udp"                                                 >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Enabled"                                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0502 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0503 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 웹서비스 정보 숨김            ####################"
echo "####################           Apache 웹서비스 정보 숨김           ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: ServerTokens 지시자로 헤더에 전송되는 정보를 설정할 수 있음.(ServerTokens Prod 설정인 경우 양호)" >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : ServerTokens Prod 설정이 없는 경우 Default 설정(ServerTokens Full)이 적용됨."  >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	
	echo "☞ $ACONF 파일 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
	if [ `cat $ACONF | grep -i "ServerTokens" | grep -v '\#' | wc -l` -gt 0 ]
	then
		cat $ACONF | grep -i "ServerTokens" | grep -v '\#'                                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat $ACONF | grep -i "ServerTokens" | grep -v '\#' | awk -F" " '{print $2}'`
	else
		echo "ServerTokens 지시자가 설정되어 있지 않습니다.(취약)"                                 >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0503 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "############################        6. 권한 관리        #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0601 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Sendmail Log Level 미설정           ####################"
echo "####################           Sendmail Log Level 미설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: LogLevel 설정값이 9 이상일 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					                 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	Result="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.aix.result.txt 2>&1
	echo " "         >> $HOSTNAME.aix.result.txt 2>&1
	echo "② /etc/mail/sendmail.cf 파일 확인"                                                          >> $HOSTNAME.aix.result.txt 2>&1
	echo "-------------------------------------------" 												>> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
		if [ `cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel | wc -l` -eq 0 ]
		then 
			echo "LogLevel 설정이 안되어 있음"																>> $HOSTNAME.aix.result.txt 2>&1
			Result="M/T"																					>> $HOSTNAME.aix.result.txt 2>&1
		elif [ `cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel | awk -F= '{print $2}'` -ge 9 ]
		then 
			cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel									>> $HOSTNAME.aix.result.txt 2>&1
			Result="Success"																			>> $HOSTNAME.aix.result.txt 2>&1
		else 
			cat /etc/mail/sendmail.cf | grep -i LogLevel												>> $HOSTNAME.aix.result.txt 2>&1
			Result="Fail"																				>> $HOSTNAME.aix.result.txt 2>&1
		fi
	else
		echo "☞ /etc/mail/sendmail.cf 파일이 존재하지 않음"                                              >> $HOSTNAME.aix.result.txt 2>&1
	fi
	echo " "                                                                 					    >> $HOSTNAME.aix.result.txt 2>&1
	echo "③ /etc/sendmail.cf 파일 확인"                                                               >> $HOSTNAME.aix.result.txt 2>&1
	echo "-------------------------------------------"  											>> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	then
		if [ `cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel | wc -l` -eq 0 ]
		then 
			echo "☞ LogLevel 설정이 안되어 있음"                                             					>> $HOSTNAME.aix.result.txt 2>&1
			Result="M/T"																					>> $HOSTNAME.aix.result.txt 2>&1
		elif [ `cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel | awk -F= '{print $2}'` -ge 9 ]
		then
			cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel 											>> $HOSTNAME.aix.result.txt 2>&1
			Result="Success"																				>> $HOSTNAME.aix.result.txt 2>&1
		else 
			cat /etc/sendmail.cf | grep -i LogLevel															>> $HOSTNAME.aix.result.txt 2>&1
			Result="Fail"																					>> $HOSTNAME.aix.result.txt 2>&1
		fi
	else
		echo "☞ /etc/sendmail.cf 파일이 존재하지 않음"                                  			            >> $HOSTNAME.aix.result.txt 2>&1
	fi	
else
	echo "☞ Sendmail Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	Result="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고]"                                                                              	   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                     	 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        		 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*:$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*:$port " | grep -i "^tcp"                                              >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$Result                                                                 	               >> $HOSTNAME.aix.result.txt 2>&1
echo "0601 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0602 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           NFS 접근통제            ####################"
echo "####################           NFS 접근통제            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준1: NFS 서버 데몬이 동작하지 않으면 양호"                                           >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준2: NFS 서버 데몬이 동작하는 경우 /etc/exports 파일에 everyone 공유 설정이 없으면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① NFS Server Daemon(nfsd)확인"                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
 then
   ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep"                >> $HOSTNAME.aix.result.txt 2>&1
   flag="M/T"
 else
   echo "☞ NFS Service Disable"                                                               >> $HOSTNAME.aix.result.txt 2>&1
   flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② /etc/exports 파일 설정"                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/exports ]
then
	if [ `cat /etc/exports | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/exports | grep -v "^#" | grep -v "^ *$"                                           >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "설정 내용이 없습니다."                                                               >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
  echo "/etc/exports 파일이 없습니다."                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag					                                                       >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0602 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0603 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           $HOME/.rhosts, hosts.equiv 사용 금지            ####################"
echo "####################           $HOME/.rhosts, hosts.equiv 사용 금지            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: r-commands 서비스를 사용하지 않으면 양호"                                        >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : r-commands 서비스를 사용하는 경우 HOME/.rhosts, hosts.equiv 설정확인"          >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1) .rhosts 파일의 소유자가 해당 계정의 소유자이고, 퍼미션 600, 내용에 + 가 설정되어 있지 않으면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2) /etc/hosts.equiv 파일의 소유자가 root 이고, 퍼미션 600, 내용에 + 가 설정되어 있지 않으면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep *.$port | grep -i "^tcp"                                                  > 6.03.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep *.$port | grep -i "^tcp"                                                  >> 6.03.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep *.$port | grep -i "^tcp"                                                  >> 6.03.txt
fi

if [ -s 6.03.txt ]
then
	cat 6.03.txt | grep -v '^ *$'                                                                >> $HOSTNAME.aix.result.txt 2>&1
	flag="M/T"
else
	echo "☞ r-command Service Disable"                                                          >> $HOSTNAME.aix.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "③ /etc/hosts.equiv 파일 설정"                                                           >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/hosts.equiv ]
	then
		echo "(1) Permission: (`ls -al /etc/hosts.equiv`)"                                         >> $HOSTNAME.aix.result.txt 2>&1
		echo "(2) 설정 내용:"                                                                      >> $HOSTNAME.aix.result.txt 2>&1
		echo "----------------------------------------"                                            >> $HOSTNAME.aix.result.txt 2>&1
		if [ `cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
		then
			cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$'                                      >> $HOSTNAME.aix.result.txt 2>&1
		else
			echo "설정 내용이 없습니다."                                                             >> $HOSTNAME.aix.result.txt 2>&1
		fi
	else
		echo "/etc/hosts.equiv 파일이 없습니다."                                                   >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "④ 사용자 home directory .rhosts 설정 내용"                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u`
FILES="/.rhosts"

for dir in $HOMEDIRS
do
	for file in $FILES
	do
		if [ -f $dir$file ]
		then
			echo " "                                                                                 > rhosts.txt
			echo "# $dir$file 파일 설정:"                                                            >> $HOSTNAME.aix.result.txt 2>&1
			echo "(1) Permission: (`ls -al $dir$file`)"                                              >> $HOSTNAME.aix.result.txt 2>&1
			echo "(2) 설정 내용:"                                                                    >> $HOSTNAME.aix.result.txt 2>&1
			echo "----------------------------------------"                                          >> $HOSTNAME.aix.result.txt 2>&1
			if [ `cat $dir$file | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
			then
				cat $dir$file | grep -v "#" | grep -v '^ *$'                                           >> $HOSTNAME.aix.result.txt 2>&1
			else
				echo "설정 내용이 없습니다."                                                           >> $HOSTNAME.aix.result.txt 2>&1
			fi
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		fi
	done
done
if [ ! -f rhosts.txt ]
then
	echo ".rhosts 파일이 없습니다."                                                              >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                          >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0603 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf rhosts.txt
rm -rf 6.03.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0604 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           접속 IP 및 포트 제한            ####################"
echo "####################           접속 IP 및 포트 제한            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준 : /etc/hosts.deny 파일에 All Deny(ALL:ALL) 설정이 등록되어 있고," 				   >> $HOSTNAME.aix.result.txt 2>&1
echo "         /etc/hosts.allow 파일에 접근 허용 IP가 등록되어 있으면 양호" 				   >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황" 																				   >> $HOSTNAME.aix.result.txt 2>&1
echo " " 																					   >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/hosts.allow 파일 설정"                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "-----------------------------------------------------"                                   >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/hosts.allow ]
	then
		cat /etc/hosts.allow                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/hosts.allow 파일이 없습니다."                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/hosts.deny 파일 설정"                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo "-----------------------------------------------------"                                   >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/hosts.deny ]
	then
		cat /etc/hosts.deny                                                                    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/hosts.deny 파일이 없습니다."                                             >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0604 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0605 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 상위 디렉토리 접근 금지            ####################"
echo "####################           Apache 상위 디렉토리 접근 금지            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: httpd.conf 파일의 Directory 부분의 AllowOverride None 설정이 아니면 양호"        >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |AllowOverride|</Directory" | grep -v '\#'                 >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |AllowOverride|</Directory" | grep -v '\#' | grep AllowOverride | awk -F" " '{print $2}' | grep -v none | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                  >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0605 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0606 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 웹 프로세스 권한 제한            ####################"
echo "####################           Apache 웹 프로세스 권한 제한           ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 웹 프로세스 권한을 제한 했을 경우 양호(User root, Group root 가 아닌 경우)"      >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
		usercheck=`cat $ACONF | grep -i "user" | grep -v "\#" | egrep -v "^LoadModule|LogFormat|IfModule|UserDir" | grep -i "user"`
		groupcheck=`cat $ACONF | grep -i "group" | grep -v "\#" | egrep -v "^LoadModule|LogFormat|IfModule|UserDir" | grep -i "group"`
		echo $usercheck                                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo $groupcheck                                                                             >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`echo $usercheck | awk -F" " '{print $2}'`":"`echo $groupcheck | awk -F" " '{print $2}' | sed -e 's/^ *//g' -e 's/ *$//g'`
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo "☞ httpd 데몬 동작 계정 확인"                                                          >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
		ps -ef | grep "httpd"                                                                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                 	                 >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Null:Null"
	fi
	
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled:Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0606 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0607 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           관리자 그룹에 최소한의 사용자 포함            ####################"
echo "####################           관리자 그룹에 최소한의 사용자 포함            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 관리자 그룹에 불필요한 계정이 없을 경우 양호"   									          >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① 관리자 계정"                                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    awk -F: '$3==0 { print $1 " -> UID=" $3 }' /etc/passwd                                     >> $HOSTNAME.aix.result.txt 2>&1
  else
    echo "/etc/passwd 파일이 없습니다."                                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 관리자 계정이 포함된 그룹 확인"                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
for group in `awk -F: '$3==0 { print $1}' /etc/passwd`
do
	cat /etc/group | grep "$group"                                                               >> $HOSTNAME.aix.result.txt 2>&1
done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0607 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  



echo "0608 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Crontab 설정파일 권한 설정 오류            ####################"
echo "####################           Crontab 설정파일 권한 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: others에 읽기/쓰기 권한이 없을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	if [ -d /var/spool/cron/crontabs/ ]
	then
		echo "/var/spool/cron/crontabs 설정파일 권한 확인"                                                       >> $HOSTNAME.aix.result.txt 2>&1
		echo "-------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
		ls -alL /var/spool/cron/crontabs | egrep -v "total|^d"										>> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "/var/spool/cron 설정파일 권한 확인"                                                       >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
		ls -alL /var/spool/cron | egrep -v "total|^d"																			>> $HOSTNAME.aix.result.txt 2>&1
	fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"																					>> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0608 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0609 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           시스템 디렉토리 권한설정 미비            ####################"
echo "####################           시스템 디렉토리 권한설정 미비            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: others에 쓰기 권한이 없을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                        >> $HOSTNAME.aix.result.txt 2>&1
HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin /usr/lbin"
for dir in $HOMEDIRS
do
	ls -dal $dir   																				 >> $HOSTNAME.aix.result.txt 2>&1
done

HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin /usr/lbin"
for dir in $HOMEDIRS
do	
	if [ -d $dir ]
then
	if [ `ls -dal $dir | awk -F" " '{print $1}' | grep "l........." | wc -l` -eq 1 ]
	then
		echo Result="M/T"          	                   >> 6.09.txt 2>&1
	elif [ `ls -dal $dir | awk -F" " '{print $1}' | grep "........w." | wc -l` -eq 1 ]
	then
		echo Result="Fail"          	                   >> 6.09.txt 2>&1
	else
		echo Result="Success"          	                   >> 6.09.txt 2>&1
	fi
	else
		echo Result="Success"          	                   >> 6.09.txt 2>&1
	fi
	done
	
if [ `cat 6.09.txt | grep "Fail" | wc -l` -eq 1 ]
then
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Fail"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
elif [ `cat 6.09.txt | grep "M/T" | wc -l` -eq 1 ]
	then
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
else
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Success"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
fi	
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0609 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf 6.09.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0610 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           시스템 스타트업 스크립트 권한 설정 오류            ####################"
echo "####################           시스템 스타트업 스크립트 권한 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: others에 쓰기 권한이 없을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/rc.d/init.d /etc/rc.d/rc2.d /etc/rc.d/rc3.d 파일 권한 확인"                                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	DIR_STARTUP="/etc/rc.d/init.d /etc/rc.d/rc2.d /etc/rc.d/rc3.d"
	for ldir in $DIR_STARTUP; 
		do
		echo "☞ "$ldir"/* 파일 권한"																>> $HOSTNAME.aix.result.txt 2>&1
		if [ -d $ldir ]
		then 
			ls -aldL $ldir/* | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"			>> $HOSTNAME.aix.result.txt 2>&1
		else
			echo "존재하지 않음."                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
		fi
		done	
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0610 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0611 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           /etc/passwd 파일 소유자 및 권한 설정            ####################"
echo "####################           /etc/passwd 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/passwd 파일의 소유자가 root 이고, 권한이 644 이하 이면 양호"                     >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    ls -alL /etc/passwd                                                                        >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=`perm /etc/passwd | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`                             >> $HOSTNAME.aix.result.txt 2>&1
  else
    echo "☞ /etc/passwd 파일이 없습니다."                                                     >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result="Null:Null"                                                                    >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0611 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0612 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           /etc/shadow 파일 소유자 및 권한 설정            ####################"
echo "####################           /etc/shadow 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/security/passwd 파일의 소유자가 root 이고, 권한이 400 이면 양호"            >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/security/passwd ]
  then
    ls -alL /etc/security/passwd                                                               >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=`perm /etc/security/passwd | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`                    >> $HOSTNAME.aix.result.txt 2>&1
  else
    echo "☞ /etc/security/passwd 파일이 없습니다."                                            >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result="Null:Null"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/shadow ]
  then
    ls -alL /etc/shadow                                                                        >> $HOSTNAME.aix.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0612 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0613 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           /etc/hosts 파일 소유자 및 권한 설정            ####################"
echo "####################           /etc/hosts 파일 소유자 및 권한 설정           ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/hosts 파일의 소유자가 root 이고, 권한이 600 이면 양호"                      >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/hosts ]
  then
    ls -alL /etc/hosts                                                                         >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=`perm /etc/hosts | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   					                 >> $HOSTNAME.aix.result.txt 2>&1
   else
    echo "☞ /etc/hosts 파일이 없습니다."                                                      >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result="Null:Null"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0613 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0614 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           C 컴파일러 존재 및 권한 설정 오류            ####################"
echo "####################           C 컴파일러 존재 및 권한 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 컴파일러에 others 실행권한이 없을 시 양호"                       						  >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
DIR_temp="/usr/bin/cc /usr/bin/gcc /usr/ucb/cc /usr/ccs/bin/cc /opt/ansic/bin/cc /usr/vac/bin/cc /usr/local/bin/gcc"
	for dir in $DIR_temp; do
		if [ -f $dir ]
		then
			echo " "                                                                                >> $HOSTNAME.aix.result.txt 2>&1
			echo "☞ $dir 파일 권한"																>> $HOSTNAME.aix.result.txt 2>&1
			ls -alL $dir																		>> $HOSTNAME.aix.result.txt 2>&1
			echo " "                                                                                >> $HOSTNAME.aix.result.txt 2>&1
		else
			echo "☞ $dir 존재하지 않음."																>> $HOSTNAME.aix.result.txt 2>&1
			echo " "                                                                                >> $HOSTNAME.aix.result.txt 2>&1
		fi
	done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0614 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0615 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           /etc/(x)inetd.conf 파일 소유자 및 권한 설정            ####################"
echo "####################           /etc/(x)inetd.conf 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/inetd.conf 파일의 소유자가 root 이고, 권한이 600 이면 양호"                 >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/inetd.conf ]
then
    ls -alL /etc/inetd.conf                                                                    >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=`perm /etc/inetd.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   			                 >> $HOSTNAME.aix.result.txt 2>&1
elif [ -f /etc/xinetd.conf ]
then
    ls -alL /etc/xinetd.conf                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=`perm /etc/xinetd.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   			               >> $HOSTNAME.aix.result.txt 2>&1
else
    echo "☞ /etc/(x)inetd.conf 파일이 없습니다."                                              >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result="Null:Null"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0615 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0616 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           /etc/syslog.conf 파일 소유자 및 권한 설정            ####################"
echo "####################           /etc/syslog.conf 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/(r)syslog.conf 파일의 소유자가 root이고 권한이 644 이면 양호"               >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
    ls -alL /etc/syslog.conf                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=`perm /etc/syslog.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   			               >> $HOSTNAME.aix.result.txt 2>&1
elif [ -f /etc/rsyslog.conf ]
then
	ls -alL /etc/rsyslog.conf                                                           	       >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                          	         >> $HOSTNAME.aix.result.txt 2>&1
  echo Result=`perm /etc/rsyslog.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   			    	           >> $HOSTNAME.aix.result.txt 2>&1
else
    echo "☞ /etc/(r)syslog.conf 파일이 없습니다."                                             >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result="0"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0616 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0617 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           SUID, SGID, Sticky bit 설정 파일 점검            ####################"
echo "####################           SUID, SGID, Sticky bit 설정 파일 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 불필요한 SUID/SGID 설정이 존재하지 않을 경우 양호"                               >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
find /usr -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -al  {}  \;     > 6.17.txt 2> /dev/null

if [ -s 6.17.txt ]
then
	linecount=`cat 6.17.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	if [ $linecount -gt 10 ]
  then
  	echo "SUID,SGID,Sticky bit 설정 파일 (상위 10개)"                                          >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	  head -10 6.17.txt                                                                          >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
  	echo " 등 총 "$linecount"개 파일 존재 (전체 목록은 스크립트 결과 파일 확인)"               >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=$linecount                                                               	       >> $HOSTNAME.aix.result.txt 2>&1
			else
  	echo "SUID,SGID,Sticky bit 설정 파일"                                                      >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	  cat 6.17.txt                                                                               >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
  	echo " 총 "$linecount"개 파일 존재"                                                        >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=$linecount                                                               	       >> $HOSTNAME.aix.result.txt 2>&1
	fi
	
else
	echo "☞ SUID/SGID로 설정된 파일이 발견되지 않았습니다."                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo " " 		                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=0                                                   				            	       >> $HOSTNAME.aix.result.txt 2>&1
	fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0617 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0618 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           홈디렉토리 소유자 및 권한 설정            ####################"
echo "####################           홈디렉토리 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 홈 디렉터리의 소유자가 /etc/passwd 내에 등록된 홈 디렉터리 사용자와 일치하고,"   >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : 홈 디렉터리에 타사용자 쓰기권한이 없으면 양호"                                 >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 사용자 홈 디렉터리"                                                                   >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
for dir in $HOMEDIRS
do
	if [ -d $dir ]
	then
		ls -dal $dir | grep '\d.........'                                                          >> $HOSTNAME.aix.result.txt 2>&1
	fi
done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0618 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0619 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           world writable 파일 점검            ####################"
echo "####################           world writable 파일 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 불필요한 권한이 부여된 world writable 파일이 존재하지 않을 경우 양호"            >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 파일 존재 시 쓰기가능 설정 이유 확인하여 관리하는 경우 양호"         				   >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -d /etc ]
then
  find /etc -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}' | grep -v "^l"         > world-writable.txt
fi
if [ -d /var ]
then
  find /var -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}' | grep -v "^l"         >> world-writable.txt
fi
if [ -d /tmp ]
then
  find /tmp -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}' | grep -v "^l"         >> world-writable.txt
fi
if [ -d /home ]
then
  find /home -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}'| grep -v "^l"         >> world-writable.txt
fi
if [ -d /export ]
then
  find /export -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}'| grep -v "^l"       >> world-writable.txt
fi

if [ -s world-writable.txt ]
then
  linecount=`cat world-writable.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
  if [ $linecount -gt 10 ]
  then
  	echo "World Writable 파일 (상위 10개)"                                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	  head -10 world-writable.txt                                                                >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
  	echo " 등 총 "$linecount"개 파일 존재 (전체 목록은 스크립트 결과 파일  확인)"              >> $HOSTNAME.aix.result.txt 2>&1
		echo " " 		                                                                               >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=$linecount                                                               	     >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo "0619 END"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
   else
    echo "World Writable 파일"                                                                 >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	  cat world-writable.txt                                                                     >> $HOSTNAME.aix.result.txt 2>&1
    echo " 총 "$linecount"개 파일 존재"                                                        >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=$linecount                                                               	     >> $HOSTNAME.aix.result.txt 2>&1
		echo " " 		                                                                               >> $HOSTNAME.aix.result.txt 2>&1
		echo "0619 END"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
    echo "☞ World Writable 권한이 부여된 파일이 발견되지 않았습니다."                         >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=0 				                                                              	     >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo "0619 END"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0620 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Crontab 참조파일 권한 설정 오류            ####################"
echo "####################           Crontab 참조파일 권한 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: crontab 참조파일에 others 쓰기 권한이 없는 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	if [ -d /var/spool/cron/crontabs/ ]
	then
		if [ `cat /var/spool/cron/crontabs/* | egrep "\.sh|\.pl" | awk '{print $6}' | wc -l ` -gt 0 ]
		then 
			REFLIST=`cat /var/spool/cron/crontabs/* | egrep "\.sh|\.pl" | awk '{print $6}' `
			echo " "                                                                                       > crontab_temp.txt 2>&1
		fi
	else
		if [ `cat /var/spool/cron/* | egrep "\.sh|\.pl" | awk '{print $6}' | wc -l` -gt 0 ]
		then
			REFLIST=`cat /var/spool/cron/* | egrep "\.sh|\.pl" | awk '{print $6}' `
		echo " "                                                                                       > crontab_temp.txt 2>&1
		fi
	fi
	
	if [ -f crontab_temp.txt ]
	then
	rm -rf crontab_temp.txt
		for file in $REFLIST
		do
			if [ -f $file ]
			then
				echo "☞ "$file" 권한 확인"             					                            >> $HOSTNAME.aix.result.txt 2>&1
				ls -alL $file			                      		                             >> $HOSTNAME.aix.result.txt 2>&1
			fi
		done
	else	
		echo "crontab 참조파일이 존재하지 않음"       		 			                            >> $HOSTNAME.aix.result.txt 2>&1
	fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0620 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0621 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정            ####################"
echo "####################           사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고"        >> $HOSTNAME.aix.result.txt 2>&1
echo "■     : 홈디렉터리 환경변수 파일에 소유자 이외에 쓰기 권한이 제거되어 있으면 양호"       >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 홈디렉터리 환경변수 파일"                                                             >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

for file in $FILES
do
  FILE=/$file
  if [ -f $FILE ]
  then
    ls -alL $FILE                                                                              >> $HOSTNAME.aix.result.txt 2>&1
  fi
done

for dir in $HOMEDIRS
do
  for file in $FILES
  do
    FILE=$dir/$file
    if [ -f $FILE ]
    then
      ls -alL $FILE                                                                            >> $HOSTNAME.aix.result.txt 2>&1
    fi
  done
done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0621 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0622 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           /etc/services 파일 소유자 및 권한 설정            ####################"
echo "####################           /etc/services 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/services 파일의 소유자가 root이고 권한이 644 이면 양호"                     >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/services ]
  then
    ls -alL /etc/services                                                                      >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result=`perm /etc/services | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`  		 			               >> $HOSTNAME.aix.result.txt 2>&1
   else
    echo "☞ /etc/services 파일이 없습니다."                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
    echo Result="0"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0622 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0623 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           xterm 실행 파일 권한 설정            ####################"
echo "####################           xterm 실행 파일 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 파일권한이 750이하로 설정되어 있고, 소유자가 root로 설정된 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /usr/bin/xterm ]
then
	ls -alLd /usr/bin/xterm     																>> $HOSTNAME.aix.result.txt 2>&1
  
if [ `ls -alL /usr/bin/xterm | grep "...-------" | wc -l` -eq 1 ]
then
	echo Result="Success"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
else
	echo Result="Fail"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
fi
else
	echo "☞ /usr/bin/xterm 파일이 존재하지 않음"                                              >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Success"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0623 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0624 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           hosts.lpd 파일 소유자 및 권한 설정            ####################"
echo "####################           hosts.lpd 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/hosts.lpd 파일의 소유자가 root 이고, 권한이 600 이면 양호"                   >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/hosts.lpd ]
then
	ls -alL /etc/hosts.lpd                                                                        >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                         	        	 >> $HOSTNAME.aix.result.txt 2>&1
  echo Result=`perm /etc/hosts.lpd | awk -F" " '{print $3 ":" $1 }'` 			 		   >> $HOSTNAME.aix.result.txt 2>&1
 else
  echo "☞ /etc/hosts.lpd 파일이 없습니다. (양호)"                                              >> $HOSTNAME.aix.result.txt 2>&1
  echo " "                                                                         	        	 >> $HOSTNAME.aix.result.txt 2>&1
  echo Result="Null:Null"																													 			 		   >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0624 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0625 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           at 접근제한 파일 소유자 및 권한 설정            ####################"
echo "####################           at 접근제한 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: at.allow 또는 at.deny 파일 권한이 640 이하이고 소유자가 root일 경우 양호"        >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① at.allow 파일 권한 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /var/adm/cron/at.allow ]
then
	ls -alL /var/adm/cron/at.allow                                                               >> $HOSTNAME.aix.result.txt 2>&1
	flag1=`perm /var/adm/cron/at.allow | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/var/adm/cron/at.allow 파일이 없습니다."                                               >> $HOSTNAME.aix.result.txt 2>&1
  flag1="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② at.deny 파일 권한 확인"                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /var/adm/cron/at.deny ]
then
	ls -alL /var/adm/cron/at.deny                                                                >> $HOSTNAME.aix.result.txt 2>&1
  flag2=`perm /var/adm/cron/at.deny | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/var/adm/cron/at.deny 파일이 없습니다."                                                >> $HOSTNAME.aix.result.txt 2>&1
  flag2="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0625 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0626 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           과도한 시스템 로그파일 권한 설정            ####################"
echo "####################           과도한 시스템 로그파일 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 디렉터리 내 로그 파일들의 권한이 644 이하일 때 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
DIR_LOG="/var/adm /etc/security /etc/utmp"
for ldir in $DIR_LOG; do
	echo $ldir"/* 확인"                                                              		>> $HOSTNAME.aix.result.txt 2>&1
	echo "-------------------------------------------"  										>> $HOSTNAME.aix.result.txt 2>&1
	ls -aldL $ldir/*																			>> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0626 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0627 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#####################               SU 명령 사용가능 그룹 제한 미비               ###################"
echo "#####################               SU 명령 사용가능 그룹 제한 미비               ###################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: su 명령 파일의 권한이 4750 이고 특정 그룹만 사용 할 수 있도록 제한 되어있으면 양호" >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① su 사용권한"                                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -s su.txt ]
	then
		sugroup=`awk -F" " '{print $6}' su.txt`;
		cat su.txt                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
fi

if [ -s su1.txt ]
	then
		sugroup=`awk -F" " '{print $6}' su1.txt`;
		cat su1.txt                                                                                >> $HOSTNAME.aix.result.txt 2>&1
fi

if [ -s su2.txt ]
	then
		sugroup=`awk -F" " '{print $6}' su2.txt`;
		cat su2.txt                                                                                >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② su 명령그룹"                                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
egrep "^$sugroup" /etc/group                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0627 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf su.txt
rm -rf su1.txt
rm -rf su2.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                    



echo "0628 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Cron 파일 소유자 및 권한 설정            ####################"
echo "####################           Cron 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: cron.allow 또는 cron.deny 파일 권한이 640 이하이고 소유자가 root일 경우 양호"    >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① cron.allow 파일 권한 확인"                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /var/adm/cron/cron.allow ]
then
	ls -alL /var/adm/cron/cron.allow                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1=`perm /var/adm/cron/cron.allow | awk -F" " '{print $4 ":" substr($1, 2, 3)}'`
else
	echo "/var/adm/cron/cron.allow 파일이 없습니다."                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② cron.deny 파일 권한 확인"                                                             >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /var/adm/cron/cron.deny ]
then
	ls -alL /var/adm/cron/cron.deny                                                              >> $HOSTNAME.aix.result.txt 2>&1
	flag2=`perm /var/adm/cron/cron.deny | awk -F" " '{print $4 ":" substr($1, 2, 3)}'`
else
	echo "/var/adm/cron/cron.deny 파일이 없습니다."                                              >> $HOSTNAME.aix.result.txt 2>&1
	flag2="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0628 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0629 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           cron 파일 내 계정 미존재            ####################"
echo "####################           cron 파일 내 계정 미존재            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: cron.allow, cron.deny 파일 내부에 계정이 존재하는 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "     : cron.allow, cron.deny 파일 둘 다 없는 경우(root만 cron 사용 가능)양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	FILE_CRONUSER="/var/adm/cron/cron.allow /var/adm/cron/cron.deny"
	for hfile in $FILE_CRONUSER
	do
	if [ -f $hfile ]; then
		echo "☞ "$hfile" 파일 확인"																	>> $HOSTNAME.aix.result.txt 2>&1
		cat $hfile  |  sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"			>> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	else 
		echo "☞ "$hfile" 파일이 존재하지 않음"                                          						   >> $HOSTNAME.aix.result.txt 2>&1	
		echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi
	done

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "0629 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0630 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           ftpusers 파일 소유자 및 권한 설정            ####################"
echo "####################           ftpusers 파일 소유자 및 권한 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: ftpusers 파일의 소유자가 root이고, 권한이 640 이하이면 양호"                     >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : [FTP 종류별 적용되는 파일]"                                                    >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1)ftpd: /etc/ftpusers 또는 /etc/ftpd/ftpusers"                                >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2)proftpd: /etc/ftpusers 또는 /etc/ftpd/ftpusers"                             >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (3)vsftpd: /etc/vsftpd/ftpusers, /etc/vsftpd/user_list (또는 /etc/vsftpd.ftpusers, /etc/vsftpd.user_list)" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                  >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(2)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"              >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(2)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(3)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                               >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(3)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep "*.21 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo "③ ftpusers 파일 소유자 및 권한 확인"                                                    >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       > ftpusers.txt
	ServiceDIR="/etc/ftpusers /etc/ftpd/ftpusers /etc/vsftpd/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd/user_list /etc/vsftpd.user_list"
	for file in $ServiceDIR
	do
		if [ -f $file ]
		then
			ls -alL $file                                                                              >> ftpusers.txt
		fi
	done
	
	if [ `cat ftpusers.txt | wc -l` -gt 1 ]
	then
		cat ftpusers.txt | grep -v "^ *$"                                                            >> $HOSTNAME.aix.result.txt 2>&1
		for file2 in `awk -F" " '{print $9}' ftpusers.txt`
		do
			if [ `perm $file2 | awk -F" " '{ print substr($1, 2, 3) }'` -gt 640 -o `ls -l $file2 | awk -F" " '{print $3}'` != "root" ]
			then
				flag2="F"
				break
			else
				flag2="O"
			fi
		done
	else
		echo "ftpusers 파일을 찾을 수 없습니다. (FTP 서비스 동작 시 취약)"                           >> $HOSTNAME.aix.result.txt 2>&1
		flag2="F"	
	fi

else
	echo "☞ FTP Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0630 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "############################        7. 설정 관리        #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1



echo "0701 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           불필요한 SMTP 서비스 실행 여부            ####################"
echo "####################           불필요한 SMTP 서비스 실행 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SMTP가 동작 중이지 않거나, 업무상 사용 중인 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					                 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Enabled"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.aix.result.txt 2>&1
else
	echo "☞ Sendmail Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"   		       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "③ 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*:$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*:$port " | grep -i "^tcp"                                              >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Enabled"
	else
		echo "☞ Sendmail Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Disabled"
	fi
else
	echo "서비스 포트 확인 불가" 				                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "0701 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0702 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           SMTP 서비스 expn/vrfy 명령어 실행 가능 여부            ####################"
echo "####################           SMTP 서비스 expn/vrfy 명령어 실행 가능 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SMTP 서비스를 사용하지 않거나 noexpn, novrfy 옵션이 설정되어 있을 경우 양호"     >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					                 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo "② /etc/sendmail.cf 파일의 옵션 확인"                                                    >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	  then
	    grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions                                      >> $HOSTNAME.aix.result.txt 2>&1
	    if [ `grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions | grep noexpn | wc -l` -eq 0 ]
	    then
				flag2="F"    
	    else
	    	if [ `grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions | grep novrfy | wc -l` -eq 0 ]
	    	then
	    		flag2="F"
	    	else
	    		flag2="O"
	    	fi
	    fi
	else
	  echo "/etc/sendmail.cf 파일이 없습니다."                                                   >> $HOSTNAME.aix.result.txt 2>&1
	  flag2="Null"
	fi
else
	echo "☞ Sendmail Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고]"                                                                              	   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                     	 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        		 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*:$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*:$port " | grep -i "^tcp"                                              >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0702 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0703 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           취약한 버전의 Sendmail 사용 여부            ####################"
echo "####################           취약한 버전의 Sendmail 사용 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: sendmail 버전을 정기적으로 점검하고, 패치를 했을 경우(8.15.2 이상) 양호"                                            >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					                 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.aix.result.txt 2>&1
	echo " "         >> $HOSTNAME.aix.result.txt 2>&1
	echo "② sendmail 버전확인"                                                                    >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
    then
		grep -v '^ *#' /etc/sendmail.cf | grep DZ                                                 >> $HOSTNAME.aix.result.txt 2>&1
   else
		echo "/etc/sendmail.cf 파일이 없습니다."                                                  >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "☞ Sendmail Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고]"                                                                              	   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                     	 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        		 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*:$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*:$port " | grep -i "^tcp"                                              >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag1                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0703 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0704 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Sendmail 서비스 거부 방지 기능 미설정            ####################"
echo "####################           Sendmail 서비스 거부 방지 기능 미설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: sendmail.cf 내부에 관련 파라미터들이 적절하게 설정되어 있을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					                 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.aix.result.txt 2>&1
	echo " "         >> $HOSTNAME.aix.result.txt 2>&1

	echo "② /etc/mail/sendmail.cf 파일 확인"                                                  >> $HOSTNAME.aix.result.txt 2>&1
  echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
  if [ -f /etc/mail/sendmail.cf ]
  then
    if [ `cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#" | wc -l` -eq 5 ]
    then
      cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"        >> $HOSTNAME.aix.result.txt 2>&1
      flag2="M/T"
    else
      cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"        >> $HOSTNAME.aix.result.txt 2>&1
      echo "☞ 파라미터 설정이 적용되어 있지 않음"                                          >> $HOSTNAME.aix.result.txt 2>&1
      flag2="Fail"
    fi
  else
    echo "☞ /etc/mail/sendmail.cf 파일이 존재하지 않음"                                          >> $HOSTNAME.aix.result.txt 2>&1
  fi
  
  echo " "         >> $HOSTNAME.aix.result.txt 2>&1
  echo "③ /etc/sendmail.cf 파일 확인"                                                  >> $HOSTNAME.aix.result.txt 2>&1
  echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
  if [ -f /etc/sendmail.cf ]
  then
    if [ `cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#" | wc -l` -eq 5 ]
    then
      cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"        >> $HOSTNAME.aix.result.txt 2>&1
      flag3="M/T"
    else
      cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"        >> $HOSTNAME.aix.result.txt 2>&1
      echo "☞ 파라미터 설정이 안되어 있음"                                          >> $HOSTNAME.aix.result.txt 2>&1
      flag3="Fail"
    fi
  else
    echo "☞ /etc/sendmail.cf 파일이 존재하지 않음"                                          >> $HOSTNAME.aix.result.txt 2>&1
  fi
	
else
	echo "☞ Sendmail Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고]"                                                                              	   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                     	 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        		 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*:$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*:$port " | grep -i "^tcp"                                              >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag1":"$flag2":"$flag3                                                           >> $HOSTNAME.aix.result.txt 2>&1
echo "0704 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0705 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           스팸 메일 릴레이 제한            ####################"
echo "####################           스팸 메일 릴레이 제한            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있을 경우 양호"             >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (R$* $#error $@ 5.7.1 $: "550 Relaying denied" 해당 설정에 주석이 제거되어 있으면 양호)" >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (sendmail 버전 8.9 이상인 경우 디폴트로 스팸 메일 릴레이 방지 설정이 되어 있으므로 양호)" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					                 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.aix.result.txt 2>&1
	echo " "         >> $HOSTNAME.aix.result.txt 2>&1
	echo "② /etc/sendmail.cf 파일의 옵션 확인"                                                    >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	  then
	    cat /etc/sendmail.cf | grep "R$\*" | grep "Relaying denied"                                >> $HOSTNAME.aix.result.txt 2>&1
	    flag2=`cat /etc/sendmail.cf | grep "R$\*" | grep "Relaying denied" | grep -v ^# | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	  else
	    echo "/etc/sendmail.cf 파일이 없습니다."                                                   >> $HOSTNAME.aix.result.txt 2>&1
	    flag2="Null"
	fi
	echo " "         																			>>	 $HOSTNAME.aix.result.txt 2>&1
	echo "③ sendmail 버전확인"                                                                    >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	then
		grep -v '^ *#' /etc/sendmail.cf | grep DZ                                                 >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "/etc/sendmail.cf 파일이 없습니다."                                                  >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "☞ Sendmail Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고]"                                                                              	   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                     	 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        		 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*:$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*:$port " | grep -i "^tcp"                                              >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0705 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0706 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           일반사용자의 Sendmail 실행 방지            ####################"
echo "####################           일반사용자의 Sendmail 실행 방지            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SMTP 서비스를 사용하지 않거나 일반 사용자의 Sendmail 실행 방지가 설정된 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (restrictqrun 옵션이 설정되어 있을 경우 양호)"                                 >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					                 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.aix.result.txt 2>&1
	echo " "         >> $HOSTNAME.aix.result.txt 2>&1
	echo "② /etc/sendmail.cf 파일의 옵션 확인"                                                    >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	  then
	    grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions                                      >> $HOSTNAME.aix.result.txt 2>&1
	    flag2=`grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions | grep restrictqrun | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	  else
	    echo "/etc/sendmail.cf 파일이 없습니다."                                                   >> $HOSTNAME.aix.result.txt 2>&1
	    flag2="Null"
	fi
else
	echo "☞ Sendmail Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고]"                                                                              	   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                     	 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        		 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*:$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*:$port " | grep -i "^tcp"                                              >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0706 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0707 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           ftpusers 파일 내 시스템 계정 존재 여부            ####################"
echo "####################           ftpusers 파일 내 시스템 계정 존재 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: ftp 를 사용하지 않거나, ftp 사용시 ftpusers 파일에 root가 있을 경우 양호"        >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : [FTP 종류별 적용되는 파일]"                                                    >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1)ftpd: /etc/ftpusers 또는 /etc/ftpd/ftpusers"                                >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2)proftpd: /etc/ftpusers 또는 /etc/ftpd/ftpusers"                             >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (3)vsftpd: /etc/vsftpd/ftpusers, /etc/vsftpd/user_list (또는 /etc/vsftpd.ftpusers, /etc/vsftpd.user_list)" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                  >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(2)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"              >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(2)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(3)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                               >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(3)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep "*.21 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo "③ ftpusers 파일 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       > ftpusers.txt
	ServiceDIR="/etc/ftpusers /etc/ftpd/ftpusers /etc/vsftpd/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd/user_list /etc/vsftpd.user_list"
	for file in $ServiceDIR
	do
		if [ -f $file ]
		then
			if [ `cat $file | grep "root" | grep -v "^#" | wc -l` -gt 0 ]
			then
				echo "● $file 파일내용: `cat $file | grep "root" | grep -v "^#"` 계정이 등록되어 있음."  >> ftpusers.txt
				echo "check"                                                                             > check.txt
				flag2=`cat $file | grep "root" | grep -v "^#"`
			else
				echo "● $file 파일내용: root 계정이 등록되어 있지 않음."                                 >> ftpusers.txt
				echo "check"                                                                             > check.txt
				flag2="F"
			fi
		fi
	done
	
	if [ -f check.txt ]
	then
		cat ftpusers.txt | grep -v "^ *$"                                                            >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "ftpusers 파일을 찾을 수 없습니다. (FTP 서비스 동작 시 취약)"                           >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Null"
	fi


else
	echo "☞ FTP Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi


echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0707 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf check.txt
rm -rf ftpusers.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0708 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           .netrc 파일 내 호스트 정보 노출            ####################"
echo "####################           .netrc 파일 내 호스트 정보 노출            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준 : .netrc 파일 내부에 아이디, 패스워드 등 민감한 정보가 없으며 파일 권한이 600인 경우 양호"            >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`

for dir in $HOMEDIRS
do
  if [ -d $dir ]
  then
    hfiles=`ls -alL $dir | awk -F" " '{print $9}' | grep ".netrc"`
    if [ `ls -alL $dir | awk -F" " '{print $9}' | grep ".netrc" | wc -l` -gt 0 ]
    then
      for hfile in $hfiles
      do
        if [ -f $dir/$hfile ]
        then
          echo " "                                                                             >> $HOSTNAME.aix.result.txt 2>&1
          echo "☞ $dir 홈디렉터리의 .netrc 파일 권한 및 설정 값 확인"                                  >> $HOSTNAME.aix.result.txt 2>&1
		  ls -aldL $dir/$hfile                                                                 >> $HOSTNAME.aix.result.txt 2>&1
          echo "---------------------------------------"                                       >> $HOSTNAME.aix.result.txt 2>&1
          cat $dir/$hfile                                                                      >> $HOSTNAME.aix.result.txt 2>&1
		  echo " "                                                                             >> $HOSTNAME.aix.result.txt 2>&1
        else
          echo "☞ dir/$hfile 파일이 존재하지 않음"                                            >> $HOSTNAME.aix.result.txt 2>&1
        fi
      done                                                                                       
    else
      echo "☞ $dir 홈디렉터리에 .netrc 파일이 존재하지 않음"                                  >> $HOSTNAME.aix.result.txt 2>&1
    fi
  else
    echo "☞ $dir 홈디렉터리가 존재하지 않음"                                                  >> $HOSTNAME.aix.result.txt 2>&1
  fi
done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0708 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0709 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Anonymous FTP 비활성화            ####################"
echo "####################           Anonymous FTP 비활성화            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: Anonymous FTP (익명 ftp)를 비활성화 시켰을 경우 양호"                            >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1)ftpd를 사용할 경우: /etc/passwd 파일내 FTP 또는 anonymous 계정이 존재하지 않으면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2)proftpd를 사용할 경우: /etc/passwd 파일내 FTP 계정이 존재하지 않으면 양호"  >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (3)vsftpd를 사용할 경우: vsftpd.conf 파일에서 anonymous_enable=NO 설정이면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                  >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(2)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"              >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(2)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(3)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                               >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(3)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep "*.21 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo "③ Anonymous FTP 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ -s vsftpd.txt ]
	then
		cat $vsfile | grep -i "anonymous_enable" | awk '{print "● VsFTP 설정: " $0}'                 >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat $vsfile | grep -i "anonymous_enable" | grep -i "YES" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		if [ `cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l` -gt 0 ]
		then
			echo "● ProFTP, 기본FTP 설정:"                                                               >> $HOSTNAME.aix.result.txt 2>&1
			cat /etc/passwd | egrep "^ftp:|^anonymous:"                                                  >> $HOSTNAME.aix.result.txt 2>&1
			echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
			flag2=`cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'` 
			echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		else
			echo "● ProFTP, 기본FTP 설정: /etc/passwd 파일에 ftp 또는 anonymous 계정이 없습니다."        >> $HOSTNAME.aix.result.txt 2>&1
			echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
			flag2=`cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
		fi	
	fi
else
	echo "☞ FTP Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0709 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0710 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           NFS 서비스 비활성화            ####################"
echo "####################           NFS 서비스 비활성화            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 불필요한 NFS 서비스 관련 데몬이 제거되어 있는 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① NFS Server Daemon(nfsd)확인"                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
 then
   ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep"                >> $HOSTNAME.aix.result.txt 2>&1
   flag1="Enabled_Server"
 else
   echo "☞ NFS Service Disable"                                                               >> $HOSTNAME.aix.result.txt 2>&1
   flag1="Disabled_Server"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② NFS Client Daemon(statd,lockd)확인"                                                   >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd|kblockd" | wc -l` -gt 0 ] 
  then
    ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd"                    >> $HOSTNAME.aix.result.txt 2>&1
    flag2="Enabled_Client"
  else
    echo "☞ NFS Client(statd,lockd) Disable"                                                  >> $HOSTNAME.aix.result.txt 2>&1
    flag2="Disabled_Client"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0710 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0711 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           불필요한 RPC서비스 구동 여부            ####################"
echo "####################           불필요한 RPC서비스 구동 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 불필요한 rpc 관련 서비스가 존재하지 않으면 양호"                                 >> $HOSTNAME.aix.result.txt 2>&1
echo "(rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd)" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd"

echo "☞ 불필요한 RPC 서비스 동작 확인"                                                        >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
ps -ef | egrep $SERVICE_INETD | grep -v grep																									 >> $HOSTNAME.aix.result.txt 2>&1
	echo "결과 값이 존재하지 않으면 양호."                                         						   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=`ps -ef | egrep $SERVICE_INETD | grep -v grep | wc -l`                           >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0711 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0712 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           automountd 제거            ####################"
echo "####################           automountd 제거            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: automountd 서비스가 동작하지 않을 경우 양호"                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① Automountd Daemon 확인"                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi" | wc -l` -gt 0 ] 
 then
   ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi"              >> $HOSTNAME.aix.result.txt 2>&1
   flag="Enabled"
 else
   echo "☞ Automountd Daemon Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
   flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0712 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0713 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           tftp, talk 서비스 비활성화            ####################"
echo "####################           tftp, talk 서비스 비활성화            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: tftp, talk, ntalk 서비스가 구동 중이지 않을 경우에 양호"                         >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp"                    >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp"                    >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "  " $2}' | grep "udp"                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^udp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > 7.13.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^udp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > 7.13.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^udp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > 7.13.txt
	fi
fi

if [ -f 7.13.txt ]
then
	rm -rf 7.13.txt
	flag="Enabled"
else
	echo "☞ tftp, talk, ntalk Service Disable"                                                  >> $HOSTNAME.aix.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0713 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0714 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           계정의 비밀번호 미 설정 점검            ####################"
echo "####################           계정의 비밀번호 미 설정 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 계정들의 비밀번호가 모두 설정되어 있을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/security/passwd 내용"                                              	>> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------"                                >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/security/passwd | awk -F: '{print $1"\t\t"$2}' | cut -c-30                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② password 값만 추출"       						                                       	>> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------"								>> $HOSTNAME.aix.result.txt 2>&1
egrep "password" /etc/security/passwd                                   					>> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0714 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  


echo "0715 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Finger 서비스 비활성화            ####################"
echo "####################           Finger 서비스 비활성화            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: Finger 서비스가 비활성화 되어 있을 경우 양호"                                    >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "☞ Finger Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	else
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
	fi
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=`netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`                         >> $HOSTNAME.aix.result.txt 2>&1
else
	if [ `netstat -na | grep "*.79 " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "☞ Finger Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	else
		netstat -na | grep "*.79 " | grep -i "^tcp"                                                >> $HOSTNAME.aix.result.txt 2>&1
	fi
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=`netstat -na | grep "*.79 " | grep -i "^tcp" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`                		         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0715 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0716 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           불필요한 DMI 서비스 구동 여부            ####################"
echo "####################           불필요한 DMI 서비스 구동 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: dmi 서비스가 동작하지 않을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "AIX는 해당사항 없음"                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0716 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0717 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           r 계열 서비스 비활성화            ####################"
echo "####################           r 계열 서비스 비활성화            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: r-commands 서비스를 사용하지 않으면 양호"                                        >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인(서비스 중지시 결과 값 없음)"                             >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ -f rcommand.txt ]
then
	rm -rf rcommand.txt
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Enabled"										 																									   >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "☞ r-commands Service Disable"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Disabled"																																		   >> $HOSTNAME.aix.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0717 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0718 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           DoS 공격에 취약한 서비스 비활성화            ####################"
echo "####################           DoS 공격에 취약한 서비스 비활성화            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: DoS 공격에 취약한 echo , discard , daytime , chargen 서비스를 사용하지 않았을 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "tcp"                 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "udp"                 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp"                 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp"                 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp"                 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp"                 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp"                 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp"                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인(서비스 중지시 결과 값 없음)"                             >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^udp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^udp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^udp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^udp"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ -f unnecessary.txt ]
then
	rm -rf unnecessary.txt
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Enabled"										 																									   >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "불필요한 서비스가 동작하고 있지 않습니다.(echo, discard, daytime, chargen)"            >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="Disabled"										 																									   >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0718 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0719 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           FTP 서비스 구동 점검            ####################"
echo "####################           FTP 서비스 구동 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: ftp 서비스가 비활성화 되어 있을 경우 양호"                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                  >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(2)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"              >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(2)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "(3)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                               >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "(3)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep "*.21 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"
else
	echo "☞ FTP Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1                                                                           >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0719 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0720 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           불필요한 Tmax WebtoB 서비스 구동 여부            ####################"
echo "####################           불필요한 Tmax WebtoB 서비스 구동 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: WebToB 웹서버가 동작하지 않을 시 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① 프로세스 구동 여부 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	Tempps=`echo "wsm[^a-z\.].*webtob|wsm[^a-z\.].*webtob|wsm|webtob" | sed "s/|/ /g"`
	temp_webtob1=0
	for ps in $Tempps
	do
		resTemp=`ps -ef | egrep "[^a-z]$ps[^a-z\.]|[^a-z]$ps$" | grep -v "grep" | sort | uniq`
		if [ "$resTemp" ]; then
			echo "$resTemp"																>> $HOSTNAME.aix.result.txt 2>&1
			echo " "																>> $HOSTNAME.aix.result.txt 2>&1
			$temp_webtob1=1
		fi
	done

	if [ $temp_webtob1 -eq 0 ]
	then 
		echo "WebtoB가 구동중이지 않음"                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi
	
echo "② inetd 설정 확인"                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	temp_webtob2=0
	Tempinetd=`echo "wsm|webtob" | sed "s/|/ /g"`
	for inetd in $Tempinetd
	do
		inetd=`echo "$inetd" | sed "s/|/ /g"`
		if [ -f "/etc/xinetd.d/$inetd" ]; then
			resTemp=`cat "/etc/xinetd.d/$inetd" | egrep -v "^#" | egrep "disable" | egrep "no" | egrep -v "^$"`
			if [ "$resTemp" ]; then
				echo "$resTemp" | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"						>> $HOSTNAME.aix.result.txt 2>&1
				echo " "                                                                                       		>> $HOSTNAME.aix.result.txt 2>&1
				$temp_webtob2=1
			fi
		fi
		
		if [ -f /etc/inetd.conf ]; then
			resTemp=`cat /etc/inetd.conf | egrep -v "^#" | egrep -i "^$inetd[d]?[^a-z]|[^a-z]$inetd[d]?[^a-z]" | egrep -v "^$"`
			if [ "$resTemp" ]; then
				echo "$resTemp" | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"						>> $HOSTNAME.aix.result.txt 2>&1
				echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
				$temp_webtob2=1
			fi
		fi
	done
	
	if [ $temp_webtob2 -eq 0 ]
	then 
		echo "WebtoB 설정이 존재하지 않음"                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi
echo Result="M/T"                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0720 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0721 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 디렉토리 리스팅 제거            ####################"
echo "####################           Apache 디렉토리 리스팅 제거            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: httpd.conf 파일의 Directory 부분의 Options 지시자에 Indexes가 설정되어 있지 않으면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	echo "☞ httpd 데몬 동작 확인"                                                         		 >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
	ps -ef | grep "httpd" | grep -v "grep"                                					     >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo "☞ httpd 설정파일 경로"                                                          		 >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f Inf_apaTemp.txt ]
	then
		cat Inf_apaTemp.txt                                                           			 >> $HOSTNAME.aix.result.txt 2>&1
		rm -rf Inf_apaTemp.txt
	fi
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
	echo $ACONF																					 >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	
	if [ -f $ACONF ]
	then
		echo "☞ Indexes 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"    >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |Indexes|</Directory" | grep -v '\#'                   >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |Indexes|</Directory" | grep -v '\#' | grep Indexes | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                  >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0721 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0722 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 불필요한 파일 제거           ####################"
echo "####################           Apache 불필요한 파일 제거            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /htdocs/manual 또는 /apache/manual 디렉터리와,"                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : /cgi-bin/test-cgi, /cgi-bin/printenv 파일이 제거되어 있는 경우 양호"           >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag="M/T"
	if [ -d $AHOME/cgi-bin ]
	then
		echo "☞ $AHOME/cgi-bin 파일"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
		ls -ld $AHOME/cgi-bin/test-cgi                                                             >> $HOSTNAME.aix.result.txt 2>&1
		ls -ld $AHOME/cgi-bin/printenv                                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ $AHOME/cgi-bin 디렉터리가 제거되어 있습니다.(양호)"                               >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	fi

	if [ -d $AHOME/htdocs/manual ]
	then
		echo "☞ $AHOME/htdocs/manual 파일"                                                        >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
		ls -ld $AHOME/htdocs/manual                                                                >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ $AHOME/htdocs/manual 디렉터리가 제거되어 있습니다.(양호)"                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	fi

	if [ -d $AHOME/manual ]
	then
		echo "☞ $AHOME/manual 파일 설정"                                                          >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
		ls -ld $AHOME/manual                                                                       >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ $AHOME/manual 디렉터리가 제거되어 있습니다.(양호)"                                >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0722 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0723 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 파일 업로드 및 다운로드 제한            ####################"
echo "####################           Apache 파일 업로드 및 다운로드 제한            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 시스템에 따라 파일 업로드 및 다운로드에 대한 용량이 제한되어 있는 경우 양호(파일사이즈 5M권고)"     >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : <Directory 경로>의 LimitRequestBody 지시자에 제한용량이 설정되어 있는 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |LimitRequestBody|</Directory" | grep -v '\#'              >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |LimitRequestBody|</Directory" | grep -v '\#' | grep LimitRequestBody | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                  >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0723 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0724 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 웹 서비스 영역의 분리            ####################"
echo "####################           Apache 웹 서비스 영역의 분리            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: DocumentRoot를 기본 디렉터리(~/apache/htdocs)가 아닌 별도의 디렉토리로 지정한 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="M/T"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                  >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1				                                                                   >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0724 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0725 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Apache 링크 사용금지 여부            ####################"
echo "####################           Apache 링크 사용금지 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: Options 지시자에서 심블릭 링크를 가능하게 하는 옵션인 FollowSymLinks가 제거된 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |FollowSymLinks|</Directory" | grep -v '\#'                >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |FollowSymLinks|</Directory" | grep -v '\#' | grep FollowSymLinks | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                  >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0725 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0726 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           미흡한 Apache Tomcat 기본 계정 사용 여부            ####################"
echo "####################           미흡한 Apache Tomcat 기본 계정 사용 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 관리자 계정/패스워드 tomcat/admin 이외의 다른 패스워드로 설정되어 있을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "	   : Tomcat6.x와 7.x 이상은 Default 계정의 주석처리 확인 필요."                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

echo "① Tomcat 구동 확인(프로세스)"                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep -i "tomcat" | grep -v "grep" | wc -l` -gt 0 ]
then
	ps -ef | grep -i "tomcat" | grep -v "grep"                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

	echo "② tomcat-user.xml 파일 설정 확인($CATALINA_HOME\conf\tomcat-user.xml)"                       >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	if [ -d $CATALINA_HOME ]
	then
		if [ -f $CATALINA_HOME\conf\tomcat-user.xml ] 
		then
			ls -alL $CATALINA_HOME\conf\tomcat-user.xml                                              >> $HOSTNAME.aix.result.txt 2>&1
			echo " "                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
			cat $CATALINA_HOME\conf\tomcat-user.xml | egrep "username|password"                           >> $HOSTNAME.aix.result.txt 2>&1
		else
			echo "tomcat-user.xml 파일이 존재하지 않음"                                                               >> $HOSTNAME.aix.result.txt 2>&1
		fi
	else
		echo "기본 환경변수 내 구동 경로 미지정 (수동점검 필요)"                                                        >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "Tomcat 서비스가 구동되고 있지 않음"                                            >> $HOSTNAME.aix.result.txt 2>&1
fi


echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"     					                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0726 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0727 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           DNS Inverse Query 설정 오류            ####################"
echo "####################           DNS Inverse Query 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: option 내부에 fake-iquery 설정이 없는 경우 양호"                        				 >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	echo "① 설정 확인"																		  >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	echo "☞ /etc/named.boot 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/named.boot  ]
	then
		cat /etc/named.boot                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/named.boot 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi

	echo "☞ /etc/named.conf 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/named.conf  ]
	then
		cat /etc/named.conf                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/named.conf 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi

	echo "☞ /etc/bind/named.boot 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/bind/named.boot  ]
	then
		cat /etc/bind/named.boot                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.boot 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi

		echo "☞ /etc/bind/named.conf 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/bind/named.conf  ]
	then
		cat /etc/bind/named.conf                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.conf 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi
	
		echo "☞ /etc/bind/named.conf.options 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/bind/named.conf.options  ]
	then
		cat /etc/bind/named.conf.options                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.conf.options 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi
  Result="M/T"
else
	echo "☞ DNS Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	Result="N/A"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$Result                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "0727 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0728 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           BIND 서버 버전 노출 여부            ####################"
echo "####################           BIND 서버 버전 노출 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: option 내부에 version 정보가 없는 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "     : named 프로세스가 존재하며 option 내부에 version 정보가 있는 경우 취약"  >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	echo "① 설정 확인"																		  >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	grep version /etc/named.conf															  >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	grep version /etc/bind/named.conf														  >> $HOSTNAME.aix.result.txt 2>&1
	Result="M/T"
else
  echo "☞ DNS Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
  Result="N/A"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$Result                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "0728 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0729 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           DNS Recursive Query 설정 오류            ####################"
echo "####################           DNS Recursive Query 설정 오류            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: options { } 내부에 recursion yes 옵션이 없거나 no 로 설정된 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	echo "① 설정 확인"																		  >> $HOSTNAME.aix.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	echo "☞ /etc/named.boot 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/named.boot  ]
	then
		cat /etc/named.boot                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/named.boot 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi

	echo "☞ /etc/named.conf 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/named.conf  ]
	then
		cat /etc/named.conf                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/named.conf 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi

	echo "☞ /etc/bind/named.boot 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/bind/named.boot  ]
	then
		cat /etc/bind/named.boot                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.boot 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi

		echo "☞ /etc/bind/named.conf 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/bind/named.conf  ]
	then
		cat /etc/bind/named.conf                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.conf 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi
	
		echo "☞ /etc/bind/named.conf.options 확인" 								                                    >> $HOSTNAME.aix.result.txt 2>&1
	if [ -f /etc/bind/named.conf.options  ]
	then
		cat /etc/bind/named.conf.options                              					                        >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.conf.options 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
	fi
  Result="M/T"
else
	echo "☞ DNS Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	Result="N/A"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$Result                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "0729 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "



echo "0730 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           DNS 보안 버전 패치            ####################"
echo "####################           DNS 보안 버전 패치            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: DNS 서비스를 사용하지 않거나, 양호한 버전을 사용하고 있을 경우에 양호"           >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (양호한 버전: BIND 9.3.5-p1, BIND 9.4.2-p1, BIND 9.5.0-p1 이상)"            >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
DNSPR=`ps -ef | grep named | grep -v "grep" | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}'| grep "/" | uniq`
DNSPR=`echo $DNSPR | awk '{print $1}'`
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	flag="M/T"
	if [ -f $DNSPR ]
	then
    echo "BIND 버전 확인"                                                                      >> $HOSTNAME.aix.result.txt 2>&1
    echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
    $DNSPR -v | grep BIND                                                                      >> $HOSTNAME.aix.result.txt 2>&1
  else
    echo "$DNSPR 파일이 없습니다."                                                             >> $HOSTNAME.aix.result.txt 2>&1
  fi
else
  echo "☞ DNS Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
  flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0730 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0731 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           NIS, NIS+ 점검            ####################"
echo "####################           NIS, NIS+ 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: NIS 서비스가 비활성화 되어 있거나, 필요 시 NIS+를 사용하는 경우 양호"            >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated|rpc.nids"

if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ NIS, NIS+ Service Disable"                                                        >> $HOSTNAME.aix.result.txt 2>&1
	flag="Disabled"
else
	echo "☞ NIS+ 데몬은 rpc.nids임"														   >> $HOSTNAME.aix.result.txt 2>&1
	ps -ef | egrep $SERVICE | grep -v "grep"                                                   >> $HOSTNAME.aix.result.txt 2>&1
	
	if [ `ps -ef | grep "rpc.nids" | grep -v "grep" | wc -l` -eq 0 ]
	then
		flag="Enabled"
	else
		flag="nis+"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                          >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0731 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0732 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           DNS Zone Transfer 설정            ####################"
echo "####################           DNS Zone Transfer 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: DNS 서비스를 사용하지 않거나 Zone Transfer 가 제한되어 있을 경우 양호"           >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① DNS 프로세스 확인 " >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep named | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ DNS Service Disable"                                                                >> $HOSTNAME.aix.result.txt 2>&1
	flag="Disabled"
else
	ps -ef | grep named | grep -v "grep"                                                         >> $HOSTNAME.aix.result.txt 2>&1
	flag="M/T"
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ `ls -al /etc/rc.d/rc*.d/* | grep -i named | grep "/S" | wc -l` -gt 0 ]
then
	ls -al /etc/rc.d/rc*.d/* | grep -i named | grep "/S"                                         >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
fi
if [ -f /etc/rc.tcpip ]
then
	cat /etc/rc.tcpip | grep -i named                                                            >> $HOSTNAME.aix.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
fi
echo "② /etc/named.conf 파일의 allow-transfer 확인"                                           >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/named.conf ]
then
	cat /etc/named.conf | grep 'allow-transfer'                                                  >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "/etc/named.conf 파일이 없습니다."                                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "③ /etc/named.boot 파일의 xfrnets 확인"                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/named.boot ]
then
	cat /etc/named.boot | grep "\xfrnets"                                                        >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "/etc/named.boot 파일이 없습니다."                                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0732 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0733 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           파일 및 디렉토리 소유자 설정            ####################"
echo "####################           파일 및 디렉토리 소유자 설정           ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 소유자가 존재하지 않는 파일 및 디렉토리가 존재하지 않을 경우 양호"               >> $HOSTNAME.aix.result.txt 2>&1
echo "■ ※ 실제 소유자명이 숫자일 경우가 있으므로 담당자 확인 필수"		               >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 소유자가 존재하지 않는 파일 (소유자 => 파일위치: 경로)"                               >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -d /etc ]
then
  find /etc -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" > 7.33.txt
fi
if [ -d /var ]
then
find /var -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> 7.33.txt
fi
if [ -d /tmp ]
then
find /tmp -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> 7.33.txt
fi
if [ -d /home ]
then
find /home -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> 7.33.txt
fi
if [ -d /export ]
then
find /export -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> 7.33.txt
fi

if [ -s 7.33.txt ]
then
	linecount=`cat 7.33.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	if [ $linecount -gt 10 ]
  then
		echo "소유자가 존재하지 않는 파일 (상위 10개)"                                             >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
	  head -10 7.33.txt                                                                          >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
  	echo " 등 총 "$linecount"개 파일 존재 (전체 목록은 스크립트 결과 파일 확인)"               >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=$linecount                                                                       >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo "0733 END"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "소유자가 존재하지 않는 파일"                                                         >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
		cat 7.33.txt                                                                               >> $HOSTNAME.aix.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
  	echo " 총 "$linecount"개 파일 존재"                                                        >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo Result=$linecount                                                                       >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1
		echo "0733 END"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
  echo "------------------------------------------------------------------------------"        >> $HOSTNAME.aix.result.txt 2>&1
  echo "소유자가 존재하지 않는 파일이 발견되지 않았습니다."                                    >> $HOSTNAME.aix.result.txt 2>&1
  echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo Result=0					                                                                       >> $HOSTNAME.aix.result.txt 2>&1	
  echo " "                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
	echo "0733 END"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0734 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           root 홈, 패스 디렉토리 권한 및 패스 설정            ####################"
echo "####################           root 홈, 패스 디렉토리 권한 및 패스 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: Path 설정에 “.”,"::" 이 맨 앞이나 중간에 포함되어 있지 않을 경우 양호"                >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ PATH 설정 확인"                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo $PATH                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0734 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0735 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           UMASK 설정 점검            ####################"
echo "####################           UMASK 설정 점검            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준1: 현재의 umask 값이 022이상인 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준2: 설정파일에 적용된 umask값이 022이상인 경우 양호"                                                        >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1) UMASK 값은 /etc/profile, /etc/security/user 파일에서 설정함"                      >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2) 계정별 환경파일에서 umask 설정 확인(결과 파일 하단 확인)"                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① 현재 로그인한 계정의 UMASK 설정 값"                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
umask                                                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo " "     
                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "② /etc/profile 파일(권고 설정: umask 022)"                                            >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/profile ]
then
  if [ `cat /etc/profile | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
		cat /etc/profile | grep -i umask | grep -v ^#                                    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "umask 설정이 없습니다."                                                              >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
  echo "/etc/profile 파일이 없습니다."                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1

echo "③ /etc/security/user 파일(권고 설정: umask 022)"                                            >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/security/user ]
then
  if [ `cat /etc/security/user | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
		cat /etc/security/user | grep -i umask | grep -v ^#                                    >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "umask 설정이 없습니다."                                                              >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
  echo "/etc/security/user 파일이 없습니다."                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                   >> $HOSTNAME.aix.result.txt 2>&1

echo "④ 계정별 환경파일 umask 설정값 확인"                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
for dir in $HOMEDIRS
do
	if [ -d $dir ]
	then
		echo "☞ $dir 디렉토리 내 환경파일 확인"                        							            >> $HOSTNAME.aix.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
		
		if [ -f $dir/.profile ]
		then
			echo " - $dir/.profile 파일 존재, umask 설정값 확인"				       			                         >> $HOSTNAME.aix.result.txt 2>&1
			cat $dir/.profile | grep "umask"                                                      		  >> $HOSTNAME.aix.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
		fi
		
		if [ -f $dir/.*shrc ]
		then
			echo " - $dir/.*shrc 파일 존재, umask 설정값 확인"            			                                  >> $HOSTNAME.aix.result.txt 2>&1
			cat $dir/.*shrc | grep "umask"                                                        >> $HOSTNAME.aix.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
		fi
	fi
done

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="M/T"                 												          >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0735 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0736 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           스택 영역 실행 방지 미설정            ####################"
echo "####################           스택 영역 실행 방지 미설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: noexec\_user\_stack 의 설정값이 1이면 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "AIX는 해당사항 없음"                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0736 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0737 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           TCP ISS 설정 여부            ####################"
echo "####################           TCP ISS 설정 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: TCP\_STRONG\_ISS 가 2일 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "AIX는 해당사항 없음"                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0737 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0738 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           root 계정과 동일한 UID 금지            ####################"
echo "####################           root 계정과 동일한 UID 금지            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: root 계정만이 UID가 0이면 양호"                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    awk -F: '$3==0 { print $1 " -> UID=" $3 }' /etc/passwd > 7.37.txt
    cat 7.37.txt                                     >> $HOSTNAME.aix.result.txt 2>&1
  else
    echo "☞ /etc/passwd 파일이 존재하지 않습니다."                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "Result="`cat 7.37.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'` 												 >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0738 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf 7.37.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  



echo "0739 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           일반 계정과 동일한 UID 금지            ####################"
echo "####################           일반 계정과 동일한 UID 금지            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 동일한 UID로 설정된 계정이 존재하지 않을 경우 양호"                              >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 동일한 UID를 사용하는 계정 "                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       > total-equaluid.txt
for uid in `cat /etc/passwd | awk -F: '{print $3}'`
do
	cat /etc/passwd | awk -F: '$3=="'${uid}'" { print "UID=" $3 " -> " $1 }'                     > equaluid.txt
	if [ `cat equaluid.txt | wc -l` -gt 1 ]
	then
		cat equaluid.txt                                                                           >> total-equaluid.txt
	fi
done
if [ `sort -k 1 total-equaluid.txt | wc -l` -gt 1 ]
then
	sort -k 1 total-equaluid.txt | uniq -d                                                       >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "동일한 UID를 사용하는 계정이 발견되지 않았습니다."                                     >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "	                                                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo Result=`sort -k 1 total-equaluid.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`				   >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0739 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf equaluid.txt
rm -rf total-equaluid.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "  



echo "0740 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           불필요한 TELNET 서비스 구동 여부            ####################"
echo "####################           불필요한 TELNET 서비스 구동 여부            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: TELNET 서비스가 동작 중이지 않거나, 업무상 사용 중인 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① 서비스 포트 확인"                  															>> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo "①-1 TELNET 확인"                 															 >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1==" " {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "①-2 SSH 확인"                  															>> $HOSTNAME.aix.result.txt 2>&1
echo " " > ssh-result.txt
ServiceDIR="/etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /usr/local/sshd/etc/sshd_config /usr/local/ssh/etc/sshd_config"
for file in $ServiceDIR
do
	if [ -f $file ]
	then
		if [ `cat $file | grep ^Port | grep -v ^# | wc -l` -gt 0 ]
		then
			cat $file | grep ^Port | grep -v ^# | awk '{print "SSH 설정파일('${file}'): " $0 }'      >> ssh-result.txt
			port1=`cat $file | grep ^Port | grep -v ^# | awk '{print $2}'`
			echo " "                                                                                 > port1-search.txt
		else
			echo "SSH 설정파일($file): 포트 설정 X (Default 설정: 22포트 사용)"                      >> ssh-result.txt
		fi
	fi
done
if [ `cat ssh-result.txt | grep -v "^ *$" | wc -l` -gt 0 ]
then
	cat ssh-result.txt | grep -v "^ *$"                                                          >> $HOSTNAME.aix.result.txt 2>&1
else
	echo "SSH 설정파일: 설정 파일을 찾을 수 없습니다."                                           >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo "②-1 TELNET"                                                         >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep *.$port | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep *.$port | grep -i "^tcp"                                                >> $HOSTNAME.aix.result.txt 2>&1
		flag1="Enabled"
	else
		echo "☞ Telnet Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
		flag1="Disabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "②-2 SSH 확인"                                                         >> $HOSTNAME.aix.result.txt 2>&1
if [ -f port1-search.txt ]
then
	if [ `netstat -na | grep "*.$port1 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	then
		echo "☞ SSH Service Disable"                                                              >> $HOSTNAME.aix.result.txt 2>&1
	else
		netstat -na | grep "*.$port1 " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	if [ `netstat -na | grep "*.22 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	then
		echo "☞ SSH Service Disable"                                                              >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Disabled"
	else
		netstat -na | grep "*.22 " | grep -i "^tcp" | grep -i "LISTEN"                             >> $HOSTNAME.aix.result.txt 2>&1
		flag2="Enabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0740 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf port1-search.txt
rm -rf ssh-result.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0741 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           원격 접속 세션 타임아웃 미설정            ####################"
echo "####################           원격 접속 세션 타임아웃 미설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/profile 에서 TMOUT=600 또는 /etc/csh.login 에서 autologout=10 이하로 설정되어 있으면 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (1) sh, ksh, bash 쉘의 경우 /etc/profile 파일 설정을 적용받음"                 >> $HOSTNAME.aix.result.txt 2>&1
echo "■       : (2) csh, tcsh 쉘의 경우 /etc/csh.cshrc 또는 /etc/csh.login 파일 설정을 적용받음" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 현재 로그인 계정 TMOUT"                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
if [ `set | egrep -i "TMOUT|autologout" | wc -l` -gt 0 ]
	then
		set | egrep -i "TMOUT|autologout"                                                            >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "TMOUT 이 설정되어 있지 않습니다."                                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ TMOUT 설정 확인"                                                                      >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/profile 파일"                                                                    >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/profile ]
then
  if [ `cat /etc/profile | grep -i TMOUT | grep -v "^#" | wc -l` -gt 0 ]
  then
  	cat /etc/profile | grep -i TMOUT | grep -v "^#"                                            >> $HOSTNAME.aix.result.txt 2>&1
  else
  	echo "TMOUT 이 설정되어 있지 않습니다."                                                    >> $HOSTNAME.aix.result.txt 2>&1
  fi
else
  echo "/etc/profile 파일이 없습니다."                                                         >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② /etc/csh.login 파일"                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/csh.login ]
then
  if [ `cat /etc/csh.login | grep -i autologout | grep -v "^#" | wc -l` -gt 0 ]
  then
  	cat /etc/csh.login | grep -i autologout | grep -v "^#"                                     >> $HOSTNAME.aix.result.txt 2>&1
  else
  	echo "autologout 이 설정되어 있지 않습니다."                                               >> $HOSTNAME.aix.result.txt 2>&1
  fi
else
  echo "/etc/csh.login 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "③ /etc/csh.cshrc 파일"                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/csh.cshrc ]
then
  if [ `cat /etc/csh.cshrc | grep -i autologout | grep -v "^#" | wc -l` -gt 0 ]
  then
  	cat /etc/csh.cshrc | grep -i autologout | grep -v "^#"                                     >> $HOSTNAME.aix.result.txt 2>&1
  else
  	echo "autologout 이 설정되어 있지 않습니다."                                               >> $HOSTNAME.aix.result.txt 2>&1
  fi
else
  echo "/etc/csh.cshrc 파일이 없습니다."                                                       >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0741 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0742 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           시스템 사용 주의사항 미출력            ####################"
echo "####################           시스템 사용 주의사항 미출력            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/security/login.cfg과 /etc/motd 파일에 로그온 시스템 사용 주의사항 등의 안내(경고) 문구가 설정되어 있을 경우 양호"  >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① /etc/motd 파일 설정: "                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/motd ]
then
	if [ `cat /etc/motd | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/motd | grep -v "^ *$"                                                             >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "경고 메시지 설정 내용이 없습니다.(취약)"                                             >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "/etc/motd 파일이 없습니다."                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② /etc/security/login.cfg 파일 설정: "                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "● /etc/services 파일에서 포트 확인"                                                      >> $HOSTNAME.aix.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "● 서비스 포트 활성화 여부 확인"                                                          >> $HOSTNAME.aix.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.aix.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep "*.$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep "*.$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "☞ Telnet Service Disable"                                                           >> $HOSTNAME.aix.result.txt 2>&1
	fi
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "● /etc/security/login.cfg 파일 설정:"                                                    >> $HOSTNAME.aix.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/security/login.cfg ]
then
	if [ `cat /etc/security/login.cfg | grep "herald" | grep -v "^*" | grep -v "^#" | wc -l` -gt 0 ]
	then
		cat /etc/security/login.cfg | grep "herald" | grep -v "^*" | grep -v "^#"                  >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "herald 설정내용이 없습니다.(취약)"                                                   >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "/etc/security/login.cfg 파일이 없습니다."                                              >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0742 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "############################        8. 패치 관리        #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0801 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           최신 보안패치 및 벤더 권고사항 적용            ####################"
echo "####################           최신 보안패치 및 벤더 권고사항 적용            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있을 경우 양호"             >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ oslevel -s"                                                             						   >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ ex. 7100-03-05 -> AIX7.1 TL3 SP5"                                                     >> $HOSTNAME.aix.result.txt 2>&1
oslevel -s																																									   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ TL:Technology Level확인 (ML:Maintenance Level과 동일한 개념임)"							    	   >> $HOSTNAME.aix.result.txt 2>&1
instfix -i | grep ML | sort                                                        					   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ SP:Service Pack 확인"																												    	   >> $HOSTNAME.aix.result.txt 2>&1
instfix -i | grep SP | sort                                                        					   >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0801 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "############################          9. 감사          #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo "0901 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           Cron 서비스 실행 로깅 미설정            ####################"
echo "####################           Cron 서비스 실행 로깅 미설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /etc/default/cron 파일에 CRONLOG=YES 가 설정되어 있는 경우 양호"        >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "AIX는 해당사항 없음"                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0901 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 


echo "0902 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           로그인 실패 감사 기능 미설정            ####################"
echo "####################           로그인 실패 감사 기능 미설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: /var/adm/loginlog 파일이 존재하며, 소유자는 관리자, 권한은 600으로 설정되어 있을 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "AIX는 해당사항 없음"                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0902 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0903 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           로그의 정기적 검토 및 보고            ####################"
echo "####################           로그의 정기적 검토 및 보고            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: 로그기록에 대해 정기적 검토, 분석, 리포트 작성 및 보고가 이루어지고 있는 경우 양호" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "☞ 담당자 인터뷰 및 증적확인"                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
echo "① 일정 주기로 로그를 점검하고 있는가?"                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "② 로그 점검결과에 따른 결과보고서가 존재하는가?"                                        >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0903 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "0904 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           이벤트 로그에 대한 접근 권한 설정 미비            ####################"
echo "####################           이벤트 로그에 대한 접근 권한 설정 미비            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: SULOG가 설정되어 있고, syslog 파일의 권한이 640 인 경우 양호"                         >> $HOSTNAME.aix.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "AIX는 해당사항 없음"                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "0904 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "############################        10. 로그 관리        #################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1



echo "1001 START"                                                                              >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "####################           정책에 따른 시스템 로깅 설정            ####################"
echo "####################           정책에 따른 시스템 로깅 설정            ####################" >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 기준: syslog 에 중요 로그 정보에 대한 설정이 되어 있을 경우 양호"                      >> $HOSTNAME.aix.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "① SYSLOG 데몬 동작 확인"                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ `ps -ef | grep 'syslog' | grep -v 'grep' | wc -l` -eq 0 ]
then
	echo "☞ SYSLOG Service Disable"                                                             >> $HOSTNAME.aix.result.txt 2>&1
else
	ps -ef | grep 'syslog' | grep -v 'grep'                                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "② SYSLOG 설정 확인"                                                                     >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
	if [ `cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$"                                       >> $HOSTNAME.aix.result.txt 2>&1
	else
		echo "/etc/syslog.conf 파일에 설정 내용이 없습니다.(주석, 빈칸 제외)"                      >> $HOSTNAME.aix.result.txt 2>&1
	fi
else
	echo "/etc/syslog.conf 파일이 없습니다."                                                      >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "1001 END"                                                                                >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " " 



echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
rm -rf proftpd.txt
rm -rf vsftpd.txt
echo "***************************************** END *****************************************" >> $HOSTNAME.aix.result.txt 2>&1
date                                                                                           >> $HOSTNAME.aix.result.txt 2>&1
echo "***************************************** END *****************************************"

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "@@FINISH"                                                                        	       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
     
echo "#################################   Process Status   ##################################"
echo "#################################   Process Status   ##################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "END_RESULT"                                                                              >> $HOSTNAME.aix.result.txt 2>&1


echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "=========================== System Information Query Start ============================"
echo "=========================== System Information Query Start ============================" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "###############################  Kernel Information  ##################################"
echo "###############################  Kernel Information  ##################################" >> $HOSTNAME.aix.result.txt 2>&1
uname -a                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "################################## IP Information #####################################"
echo "################################## IP Information #####################################" >> $HOSTNAME.aix.result.txt 2>&1
ifconfig -a                                                                                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "################################   Network Status   ###################################"
echo "################################   Network Status   ###################################" >> $HOSTNAME.aix.result.txt 2>&1
netstat -an | egrep -i "LISTEN|ESTABLISHED"                                                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#############################   Routing Information   #################################"
echo "#############################   Routing Information   #################################" >> $HOSTNAME.aix.result.txt 2>&1
netstat -rn                                                                                    >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "################################   Process Status   ###################################"
echo "################################   Process Status   ###################################" >> $HOSTNAME.aix.result.txt 2>&1
ps -ef                                                                                         >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "###################################   User Env   ######################################"
echo "###################################   User Env   ######################################" >> $HOSTNAME.aix.result.txt 2>&1
env                                                                                            >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "=========================== System Information Query End =============================="
echo "=========================== System Information Query End ==============================" >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고] /etc/passwd, /etc/security/passwd, /etc/shadow 파일 내용"                         >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    echo "① /etc/passwd 파일"                                                                 >> $HOSTNAME.aix.result.txt 2>&1
    cat /etc/passwd                                                                            >> $HOSTNAME.aix.result.txt 2>&1
  else
    echo "/etc/passwd 파일이 없습니다."                                                        >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/security/passwd ]
  then
    echo "② /etc/security/passwd 파일"                                                        >> $HOSTNAME.aix.result.txt 2>&1
    cat /etc/security/passwd                                                                   >> $HOSTNAME.aix.result.txt 2>&1
  else
    echo "/etc/security/passwd 파일이 없습니다."                                               >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
if [ -f /etc/shadow ]
  then
    echo "③ /etc/shadow 파일"                                                                 >> $HOSTNAME.aix.result.txt 2>&1
    cat /etc/shadow                                                                            >> $HOSTNAME.aix.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1


echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고] /etc/security/user 파일 내용"                        														 >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
	cat /etc/security/user                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고] /etc/group 파일"                                                                  >> $HOSTNAME.aix.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/group                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1




		echo "[참고] 소유자가 존재하지 않는 파일 전체 목록"                                        >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
		cat 7.33.txt                                                                               >> $HOSTNAME.aix.result.txt 2>&1
		rm -rf 7.33.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1		
		
		echo "[참고] SUID,SGID,Sticky bit 설정 파일 전체 목록"                                     >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
    cat 6.17.txt                                                                               >> $HOSTNAME.aix.result.txt 2>&1
    rm -rf 6.17.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1    
    
    echo "[참고] World Writable 파일 전체 목록"                                                >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
    cat world-writable.txt                                                                     >> $HOSTNAME.aix.result.txt 2>&1
    rm -rf world-writable.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1    
    
    echo "[참고] 숨겨진 파일 전체 목록" 				                                               >> $HOSTNAME.aix.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.aix.result.txt 2>&1
    cat temp403.txt				                                                                     >> $HOSTNAME.aix.result.txt 2>&1
    rm -rf temp403.txt
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1




echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고] 사용자 별 profile 내용"                                                           >> $HOSTNAME.aix.result.txt 2>&1
echo ": 사용자 profile 또는 profile 내 TMOUT 설정이 없는 경우 결과 없음 (/etc/profile을 따름)" >> $HOSTNAME.aix.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

awk -F: '{print $1 ":" $6}' /etc/passwd > profilepath.txt

for result in `cat profilepath.txt`
do
	echo $result > tempfile.txt
	var=`awk -F":" '{print $2}' tempfile.txt`

	if [ $var="/" ]
	then
		if [ `ls -f / | grep "^\.profile$" | wc -l` -gt 0 ]
		then
			filename=`ls -f / | grep "^\.profile$"`

			if [ `grep -i TMOUT /$filename | grep -v "^#" | wc -l` -gt 0 ]
			then
				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.aix.result.txt 2>&1
				echo "-----------------------------------------------"                                 >> $HOSTNAME.aix.result.txt 2>&1
				grep -i TMOUT /$filename | grep -v "^#"	                                               >> $HOSTNAME.aix.result.txt 2>&1
				echo " "                                                                               >> $HOSTNAME.aix.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#			else
#				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.aix.result.txt 2>&1
#                         	echo "----------------------------------------"                      >> $HOSTNAME.aix.result.txt 2>&1
#                         	echo $filename"에 TMOUT 설정이 존재하지 않음"                        >> $HOSTNAME.aix.result.txt 2>&1
#				echo " "                                                                               >> $HOSTNAME.aix.result.txt 2>&1
			fi
#		else
#                        awk -F":" '{print $1}' tempfile.txt                                    >> $HOSTNAME.aix.result.txt 2>&1
#                        echo "----------------------------------------"                        >> $HOSTNAME.aix.result.txt 2>&1
#                        echo "사용자 profile 파일이 존재하지 않음"                             >> $HOSTNAME.aix.result.txt 2>&1
#			echo " "                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
		fi
	else
		pathname=`awk -F":" '{print $2}' tempfile.txt`
				if [ -f $pathname ]
				then
                if [ `ls -f $pathname | grep "^\.profile$" | wc -l` -gt 0 ]
                then
                        filename = `ls -f $pathname | grep "^\.profile$"`

                        if [ `grep -i TMOUT $pathname/$filename | grep -v "^#" | wc -l` -gt 0 ]
                        then
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.aix.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.aix.result.txt 2>&1
                                grep -i TMOUT $pathname/$filename | grep -v "^#"               >> $HOSTNAME.aix.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.aix.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.aix.result.txt 2>&1
#                                echo "----------------------------------------"                >> $HOSTNAME.aix.result.txt 2>&1
#                                echo $filename"에 TMOUT 설정이 존재하지 않음"                  >> $HOSTNAME.aix.result.txt 2>&1
#                                echo " "                                                       >> $HOSTNAME.aix.result.txt 2>&1
                        fi
#                else
#                        awk -F":" '{print $1}' tempfile.txt                                    >> $HOSTNAME.aix.result.txt 2>&1
#                        echo "----------------------------------------"                        >> $HOSTNAME.aix.result.txt 2>&1
#                        echo "사용자 profile 파일이 존재하지 않음"                             >> $HOSTNAME.aix.result.txt 2>&1
#                        echo " "                                                               >> $HOSTNAME.aix.result.txt 2>&1
								 fi
					fi			 
	fi
done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.aix.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.aix.result.txt 2>&1
rm -rf tempfile.txt


echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고] 사용자 별 profile 내용"                                                           >> $HOSTNAME.aix.result.txt 2>&1
echo ": 사용자 profile 또는 profile 내 UMASK 설정이 없는 경우 결과 없음 (/etc/profile을 따름)" >> $HOSTNAME.aix.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

for result in `cat profilepath.txt`
do
	echo $result > tempfile.txt
	var=`awk -F":" '{print $2}' tempfile.txt`

	if [ $var="/" ]
	then
		if [ `ls -f / | grep "^\.profile$" | wc -l` -gt 0 ]
		then
			filename=`ls -f / | grep "^\.profile$"`

			if [ `grep -i umask /$filename | grep -v "^#" | wc -l` -gt 0 ]
			then
				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.aix.result.txt 2>&1
				echo "-----------------------------------------------"                                 >> $HOSTNAME.aix.result.txt 2>&1
				grep -i umask /$filename | grep -v "^#"	                                     >> $HOSTNAME.aix.result.txt 2>&1
				echo " "                                                                               >> $HOSTNAME.aix.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#			else
#				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.aix.result.txt 2>&1
#                         	echo "----------------------------------------"                    >> $HOSTNAME.aix.result.txt 2>&1
#                         	echo $filename"에 UMASK 설정이 존재하지 않음"                      >> $HOSTNAME.aix.result.txt 2>&1
#				echo " "                                                                               >> $HOSTNAME.aix.result.txt 2>&1
			fi
#		else
#                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.aix.result.txt 2>&1
#                        echo "----------------------------------------"                       >> $HOSTNAME.aix.result.txt 2>&1
#                        echo "사용자 profile 파일이 존재하지 않음"                            >> $HOSTNAME.aix.result.txt 2>&1
#			echo " "                                                                                 >> $HOSTNAME.aix.result.txt 2>&1
		fi
	else
		pathname=`awk -F":" '{print $2}' tempfile.txt`
			if [ -f $pathname ]
			then
                if [ `ls -f $pathname | grep "^\.profile$" | wc -l` -gt 0 ]
                then
                        filename = `ls -f $pathname | grep "^\.profile$"`

                        if [ `grep -i umask $pathname/$filename | grep -v "^#" | wc -l` -gt 0 ]
                        then
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.aix.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.aix.result.txt 2>&1
                                grep -i umask $pathname/$filename | grep -v "^#"     >> $HOSTNAME.aix.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.aix.result.txt 2>&1
                        fi
				fi
			fi			 
	fi
done
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo "[참고] /etc/profile 내용"                                                      	       >> $HOSTNAME.aix.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
cat /etc/profile                                                                               >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.aix.result.txt 2>&1



rm -rf profilepath.txt
rm -rf tempfile.txt
rm -rf su.txt
rm -rf su1.txt
rm -rf su2.txt