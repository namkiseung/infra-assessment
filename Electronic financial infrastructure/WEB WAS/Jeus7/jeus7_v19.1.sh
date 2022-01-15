#!/bin/sh
#!c:/logthink/bin/sh
LANG=C
export LANG
BUILD_VER=19.1
LAST_UPDATE=2019.02

echo "####################################################################"
echo "	Copyright (c) 2019 logthink Co. Ltd. All Rights Reserved."
echo "	JEUS 7 Vulnerability Scanner Version $BUILD_VER ($LAST_UPDATE) "
echo "####################################################################"

echo ""
echo ""
echo "###### Starting Jeus 7 Vulnerability Checker $BUILD_VER #########"
echo ""
echo ""
os=`uname`
if [ "$os" = "WindowsNT" ]; then 
	alias ls=c:/logthink/bin/ls
	alias grep=c:/logthink/bin/grep
	alias awk=c:/logthink/bin/gawk
	alias find=c:/logthink/bin/find
	alias tr=c:/logthink/bin/tr
	alias wget=c:/logthink/bin/wget
	alias cat=c:/logthink/bin/cat
	alias date=c:/logthink/bin/date
	alias reg=c:/logthink/bin/reg
	alias pv=c:/logthink/bin/pv
fi
# Support "echo -n " in SunOS Environment 
if [ "$os" = "SunOS" ]; then 
	alias echo=/usr/ucb/echo
fi
if [ \( "$os" = "AIX" \) -o \( "$os" = "SunOS" \) ]; then
	alias ifconfig=/usr/sbin/ifconfig 
fi
logthink="c:/logthink"


echo " "
echo 'Enter the full path with node name.' 
while true 
do
	if [ "$os" = "WindowsNT" ]; then
		echo -n '	(ex. c:/TmaxSoft/Jeus/domains/[node name]) : '
	else
		echo -n '	(ex. /opt/jeus/domains/[node name]) : ' 
	fi
	read jeus 
	if [ "$jeus" ] 
		then
		if [ -d "$jeus" ] 
			then 
				break
			else
				echo " Entered path does not exist. Please try again!! " 
				echo " "
		fi
		
	#<!-- 2018.03
	#	elif [ -z ""$jeus"" ]; then
	#jeus 4
	#	jeus=${jeus:-"c:/Jeus4/config/lnxsvr"}
	#	jeus=${jeus:-"/usr/local/jeus4/config/lnxsvr"}
	#jeus 5
	#	jeus=${jeus:-"c:/TmaxSoft/Jeus5.0/config/logthink-ef0c688"}
	#	break 
	#-->	

	else
		echo "	Wrong path. Please try agin!! "
		echo " "
	fi
done
 
echo " "
_HOSTNAME=`hostname`
OUTFILE=${_HOSTNAME}__`basename $jeus`__`date +%Y%m%d%s`__result.txt
SUMMARY=${_HOSTNAME}__`basename $jeus`__`date +%Y%m%d`__summary.txt 
TMPFILE=`basename $jeus`_jeus_result_tmp.txt
rm -f $OUTFILE 
rm -f $SUMMARY 
rm -f $TMPFILE
JEUS_HOME=`dirname \`dirname $jeus\``
logthink="c:/logthink"
#echo "JEUS_HOME=$JEUS_HOME"
echo "***************************** Stsrt **********************************"
if [ "$os" = "WindowsNT" ]; then
	if [ -f "$JEUS_HOME"/bin/jeusadmin.bat ]; then
		version=`cmd /c "$JEUS_HOME"/../bin/jeusadmin.bat -version | grep JEUS | awk '{print $2}'` 
	fi
	if [ -f "$JEUS_HOME"/bin/jeusadmin.cmd ]; then
		version=`cmd /c "$JEUS_HOME"/../bin/jeusadmin.cmd -version | grep JEUS | awk '{print $2}'`
	fi
		version=${version:-unknown}
	if [ `echo $version | grep ^4 | wc -l` -gt 0 ]; then
		JEUS_PROPERTIES="jeus.properties.bat"
		JEUS_ADMIN="jeusadmin.bat"
		JEUS_RUNENV="jeus.ini"
	else
		JEUS_PROPERTIES="jeus.properties.cmd"
		JEUS_ADMIN="jeusadmin.cmd"
		JEUS_RUNENV="jeus.bat"
	fi
else
	version=`"$JEUS_HOME"/../bin/jeusadmin -version | grep JEUS | awk '{print $2}'`
	JEUS_RUNENV="jeus"
	JEUS_ADMIN="jeusadmin"
	JEUS_PROPERTIES="jeus.properties"
fi
#echo "version: $version"
echo >> $OUTFILE
echo "***************************************시스템***************************************" >> $OUTFILE
ifconfig -a >> $OUTFILE 
uname -a >> $OUTFILE
echo "*********************************************************************************" >> $OUTFILE
echo "---------------------------------------------------------------------------------" >> $OUTFILE
echo " JEUS 7 Vulnerability Checker Version $BUILD_VER($LAST_UPDATE)" >> $OUTFILE
echo " HOSTNAME : `hostname`" >> $OUTFILE
echo " `uname -a` " >> $OUTFILE 
echo " Start at `date`" >> $OUTFILE
echo "---------------------------------------------------------------------------------" >> $OUTFILE


Jeus_01() {
echo ' ' >> $OUTFILE
echo "0101 START" >> $OUTFILE
echo -n '[ 1.1. 데몬 관리 ] ================================================'
echo '=======================================================================' >> $OUTFILE
echo '1.1. 데몬 관리' >> $OUTFILE
echo '=======================================================================' >> $OUTFILE
echo '▶ 점검기준' >> $OUTFILE
if [ "$os" = "WindowsNT" ]; then
	echo 'JEUS 실행계정이 SYSTEM 계정이 아니면 양호' >> $OUTFILE
else
	echo 'JEUS 실행계정이 root가 아닌 nobody 혹은 전용계정이면 양호' >> $OUTFILE
fi
echo '' >> $OUTFILE
echo '▶ 시스템 현황' >> $OUTFILE
if [ "$os" = "WindowsNT" ]; then
	pv -o"%i\t%u\t%f" | grep -i jeus >> $OUTFILE
	if [ `pv -o"%u" | grep jeus | grep -v grep | grep -v SYSTEM | wc -l` -eq -0 ]; then
		result1_1_1='Vulnerability'
	else
		result1_1_1='Good'
	fi
else
	ps -ef | grep -i jeus | grep -v grep | tail -50 >> $OUTFILE
	if [ `ps -ef | grep -i jeus | grep -v grep | wc -l` -gt 0 ]; then
		if [ `ps -ef | grep -i jeus | grep -v grep | grep -v root | wc -l` -eq 0 ]; then
			result1_1_1='Vulnerability'
		else
			result1_1_1='Good'
		fi
	else
		result1_1_1='해당없음'
	fi
fi
echo ' ' >> $OUTFILE
if [ $result1_1_1 = 'Good' ]; then
	result1_1='양호'
else
	result1_1='취약'
fi
#echo '★ 1.1. 결과 : ' $result1_1 >> $OUTFILE
#echo '★ 1.1. 결과 : ' $result1_1 >> $SUMMARY
echo '-----------------------------------------------------------------------' >> $OUTFILE
echo '[DONE]'
echo "0101 END" >> $OUTFILE
}



Jeus_02() {
	echo ' ' >> $OUTFILE
	echo "0102 START" >> $OUTFILE
	echo -n '[ 1.2. 홈 디렉터리 권한 설정 ] =================================='
	echo '===================================================================' >> $OUTFILE
	echo ' 1.2 홈 디렉터리 권한 설정' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE 
	if [ "$os" = "WindowsNT" ]; then
		echo '해당 디렉터리에 Everyone의 모든 사용 권한이 제거 되어있으면 양호' >> $OUTFILE 
	else
		echo '홈 디렉터리에 그룹과 다른 사용자의 쓰기 권한이 없는 750인 경우 양호' >> $OUTFILE 
	fi
	echo '' >> $OUTFILE
	echo '▶ 시스템 현황'>> $OUTFILE
	cat "$jeus"/domain.xml | grep path |grep -v '\.' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '|node 홈 디렉터리|' >> $OUTFILE
	result1_2_1='Good'
	if [ "$os" = "WindowsNT" ]; then
		cacls $jeus >> $OUTFILE
		if [ `cacls "$jeus" | grep -i Everyone | grep "F" | wc -l` -gt 0 ]; then
			result1_2_1='Vulnerability' 
		fi
	else
		ls -ld "$jeus" >> $OUTFILE
		if [ `ls -ld "$jeus" | grep -v '.r...-..-.'| wc -l` -gt 0 ]; then
			result1_2_1='Vulnerability'
		fi
	fi
	echo ' ' >> $OUTFILE
	echo '|소스 홈 디렉터리|' >> $OUTFILE
	result1_2_2='Good'
	if [ "$os" = "WindowsNT" ]; then
		cacls "$jeus/servers" >> $OUTFILE
		if [ `cacls "$jeus"/servers | grep -i Everyone | grep "F" | wc -l` -gt 0 ]; then
			result1_2_2='Vulnerability'
		fi
	else
		ls -ld "$jeus/servers" >> $OUTFILE
		if [ `ls -ld "$jeus"/servers | grep -v '.r...-..-.'| wc -l` -gt 0 ]; then
			result1_2_2='Vulnerability'
		fi
	fi
	
	if [ $result1_2_1 = 'Vulnerability' -o \( $result1_2_2 = 'Vulnerability' \) ];then
		result1_2='취약'
	else
		result1_2='양호' 
	fi
	#echo '★ 1.4. 결과 : ' $result1_2 >> $OUTFILE 
	#echo '★ 1.4. 결과 : ' $result1_2 >> $SUMMARY
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]' >> $OUTFILE
	echo "0102 END" >> $OUTFILE
}



Jeus_03() {
	echo ' ' >> $OUTFILE
	echo "0103 START" >> $OUTFILE
	echo -n '[ 1.3. 설정파일 권한 설정 ] =================================='
	echo '===================================================================' >> $OUTFILE
	echo ' 1.3. 설정파일 권한 설정' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE 
	if [ "$os" = "WindowsNT" ]; then
		echo '설정파일에 Everyone의 모든 사용 권한이 제거 되어있으면 양호'>> $OUTFILE 
	else
		echo '설정파일에 그룹과 다른 사용자의 읽기, 쓰기, 실행 권한이 없는 600인 경우 양호' >> $OUTFILE 
	fi
	echo '' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo ' | 설정 파일 | ' >> $OUTFILE
	result1_3_1='Good'
	result1_3_2='Good'
	result1_3_3='Good'
	result1_3_4='Good'
	result1_3_5='Good'
	result1_3_6='Good'
	if [ "$os" = "WindowsNT" ]; then
		cacls "$JEUS_HOME"/domains/nodes.xml >> $OUTFILE
		cacls "$jeus"/config/domain.xml >> $OUTFILE
		cacls "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
		cacls "$jeus"/config/security/SYSTEM_DOMAIN/policies.xml >> $OUTFILE
		cacls "$jeus"/config/servlet/web.xml >> $OUTFILE
		cacls "$jeus"/config/servlet/webcommon.xml >> $OUTFILE
		if [ `cacls "$JEUS_HOME"/domains/nodes.xml | grep -i Everyone | grep "F" | wc -l`-gt 0 ]; then
			result1_3_1='Vulnerability' 
		fi
		if [ `cacls "$jeus"/config/domain.xml | grep -i Everyone | grep "F" | wc -l`-gt 0 ]; then
			result1_3_2='Vulnerability' 
		fi
		if [ `cacls "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml | grep -i Everyone | grep "F" | wc -l`-gt 0 ]; then
			result1_3_3='Vulnerability' 
		fi
		if [ `cacls "$jeus"/config/security/SYSTEM_DOMAIN/policies.xml | grep -i Everyone | grep "F" | wc -l`-gt 0 ]; then
			result1_3_4='Vulnerability' 
		fi
		if [ `cacls "$jeus"/config/servlet/web.xml | grep -i Everyone | grep "F" | wc -l`-gt 0 ]; then
			result1_3_5='Vulnerability' 
		fi
		if [ `cacls "$jeus"/config/servlet/webcommon.xml | grep -i Everyone | grep "F" | wc -l`-gt 0 ]; then
			result1_3_6='Vulnerability' 
		fi
	else
		ls -l "$JEUS_HOME"/domains/nodes.xml >> $OUTFILE
		ls -l "$jeus"/config/domain.xml >> $OUTFILE
		ls -l "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
		ls -l "$jeus"/config/security/SYSTEM_DOMAIN/policies.xml >> $OUTFILE
		ls -l "$jeus"/config/servlet/web.xml >> $OUTFILE
		ls -l "$jeus"/config/config/servlet/webcommon.xml >> $OUTFILE
		if [ `ls -l "$JEUS_HOME"/domains/nodes.xml |grep -v '.r...-..-.'|wc -l` -gt 0 ]; then
			result1_3_1='Vulnerability' 
		fi
		if [ `ls -l "$jeus"/config/domain.xml |grep -v '.r...-..-.'|wc -l` -gt 0 ]; then
			result1_3_2='Vulnerability' 
		fi 
		if [ `ls -l "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml |grep -v '.r...-..-.'|wc -l` -gt 0 ]; then
			result1_3_3='Vulnerability' 
		fi 
		if [ `ls -l "$jeus"/config/security/SYSTEM_DOMAIN/policies.xml |grep -v '.r...-..-.'|wc -l` -gt 0 ]; then
			result1_3_4='Vulnerability' 
		fi
		if [ `ls -l "$jeus"/config/servlet/web.xml |grep -v '.r...-..-.'|wc -l` -gt 0 ]; then
			result1_3_5='Vulnerability' 
		fi 
		if [ `ls -l "$jeus"/config/servlet/webcommon.xml |grep -v '.r...-..-.'|wc -l` -gt 0 ]; then
			result1_3_6='Vulnerability' 
		fi 
	fi
	


	if [ \( $result1_3_1 = 'Vulnerability' \) -o \( $result1_3_2 = 'Vulnerability' \) -o \( $result1_3_3 = 'Vulnerability' \) -o \( $result1_3_4 = 'Vulnerability' \) -o \( $result1_3_5 = 'Vulnerability' \) -o \( $result1_3_6 = 'Vulnerability' \) ];then
		result1_3='취약'
	else
		result1_3='양호' 
	fi
	#echo '★ 1.3. 결과 : ' $result1_3 >> $OUTFILE 
	#echo '★ 1.3. 결과 : ' $result1_3 >> $SUMMARY
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0103 END" >> $OUTFILE
}



Jeus_04() {
	echo ' ' >> $OUTFILE
	echo "0104 START" >> $OUTFILE
	echo -n '[ 1.4. 로그 디렉터리/파일 권한 설정 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.4. 로그 디렉터리/파일 권한 설정 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE 
	echo '로그 디렉터리에 그룹과 다른 사용자의 쓰기 권한이 없는 750인 경우 양호' >> $OUTFILE
	echo '로그 파일에 그룹과 다른 사용자의 쓰기 권한이 없는 640인 경우 양호' >> $OUTFILE 
	echo '' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo ' | 로그 디렉터리 | ' >> $OUTFILE
	ls -l "$jeus"/servers/* | grep log >> $OUTFILE
	echo '' >> $OUTFILE
	echo ' | 로그 파일 | ' >> $OUTFILE
	ls -lR "$jeus"/servers/ | grep "\.log" >> $OUTFILE	
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0104 END" >> $OUTFILE
}

Jeus_05() {
	echo ' ' >> $OUTFILE
	echo "0105 START" >> $OUTFILE
	echo -n '[ 1.5. 로그 포맷 설정 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.5. 로그 포맷 설정 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' 로그 지시자가 포함되게 포그 포맷을 설정한 경우 양호 ' >> $OUTFILE
	echo ' 관리자 콘솔: [server] - [Engine] - [Web Engine] - [AccessLog] - [Format] 확인 ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo ' (수동 점검) ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0105 END" >> $OUTFILE
}

Jeus_06() {
	echo ' ' >> $OUTFILE
	echo "0106 START" >> $OUTFILE
	echo -n '[ 1.6. 로그 저장 주기 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.6. 로그 저장 주기 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' 법이나 회사 내규에 따라 로그 저장주기를 설정한 경우 양호 ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo ' (담당자 인터뷰 및 수동점검) ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0106 END" >> $OUTFILE
}

Jeus_07() {
	echo ' ' >> $OUTFILE
	echo "0107 START" >> $OUTFILE
	echo -n '[ 1.7. 헤더 정보 노출 방지 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.7. 헤더 정보 노출 방지 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' HTTP 응답 헤더에 서버 정보가 노출되지 않는 경우 양호 ' >> $OUTFILE
	echo ' [JEUS_HOME]/domains/[domains_name]/config/domain.xml 파일의 설정 값 확인 ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo ' "<field-name>P3P</field-name> ' >> $OUTFILE	
	echo ' <field-value>CP='CAO PSA CONI OTR OUR DEM ONL'</field-value>" 설정 확인' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo ' ※ 값이 없는 경우 Default 값으로 응답헤더 정보 없음(양호) ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	awk '/<field-name>/,/<\/field-name>/' "$jeus"/config/domain.xml >> $OUTFILE
	awk '/<field-value>/,/<\/field-value>/' "$jeus"/config/domain.xml >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0107 END" >> $OUTFILE
}

Jeus_08() {
	echo ' ' >> $OUTFILE
	echo "0108 START" >> $OUTFILE
	echo -n '[ 1.8. Session Timeout 설정 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.8. Session Timeout 설정 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' Session Timeout 을 30분 이하로 설정한 경우 양호 ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo "[domain.xml 의 <timeout>분</timeout> 설정 확인]" >> $OUTFILE
	awk '/<session-config>/,/<\/session-config>/' "$jeus"/config/domain.xml >> $OUTFILE

	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0108 END" >> $OUTFILE
}

Jeus_09() {
	echo ' ' >> $OUTFILE
	echo "0109 START" >> $OUTFILE
	echo -n '[ 1.9. 데이터소스의 패스워드 암호화 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.9. 데이터소스의 패스워드 암호화 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' 데이터소스의 패스워드가 암호화 되어있는 경우 양호 ' >> $OUTFILE
	echo ' 암호화 방식이 Base64가 아닌 다른 일방향 암호화로 설정되어 있는지 확인 ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo "[accounts.xml 의 <password> 설정 확인]" >> $OUTFILE
	awk '/<password>/,/<\/password>/' "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0109 END" >> $OUTFILE
}

Jeus_10() {
	echo ' ' >> $OUTFILE
	echo "0201 START" >> $OUTFILE
	echo -n '[ 2.1. 불필요한 파일 및 디렉터리 삭제 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 2.1. 불필요한 파일 및 디렉터리 삭제 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo '불필요한 파일 및 디렉터리를 삭제한 경우 양호' >> $OUTFILE
	echo 'samples 디렉터리 존재 시 취약' >> $OUTFILE
	echo '' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	ls -al "$JEUS_HOME" | grep samples >> $OUTFILE
	
	if [ ! -d "$JEUS_HOME/samples" ]; then
		echo 'Sample 디렉터리가 존재하지 않음' >> $OUTFILE 
	fi
	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]' 
	echo "0201 END" >> $OUTFILE
}

Jeus_11() {
	echo ' ' >> $OUTFILE
	echo "0301 START" >> $OUTFILE
	echo -n '[ 3.1. 보안 패치 적용 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 3.1. 보안 패치 적용 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' 주기적으로 보안패치를 적용한 경우 양호' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	$jeus/../../bin/jeusadmin -fullversion >> $OUTFILE

	echo ' ' >> $OUTFILE
	echo '|[최신 버전(2018.3)]' >> $OUTFILE 
	echo 'JEUS7.0 Fix5' >> $OUTFILE 
	echo 'JEUS6.0 Fix9' >> $OUTFILE 
	echo 'JEUS5.0 Fix27' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo "0301 END" >> $OUTFILE
}

Jeus_12() {
	echo ' ' >> $OUTFILE
	echo "0401 START" >> $OUTFILE
	echo -n '[ 4.1. 관리자 콘솔 접근통제 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 4.1. 관리자 콘솔 접근통제 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' 관리자 페이지를 사용하지 않거나 접근이 가능한 관리자 IP 주소와 유추하기 어려운 port를 지정하여 사용하는 경우 양호 ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo "[관리자 페이지의 비활성화(false) 확인]" >> $OUTFILE
	awk '/<enable-webadmin>/,/<\/enable-webadmin>/' "$jeus"/config/domain.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo "[관리자 페이지의 기본포트(9736) 사용 여부 확인]" >> $OUTFILE
	awk '/<listen-port>/,/<\/listen-port>/' "$jeus"/config/domain.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo "[관리자 페이지의 접근 제어 확인]" >> $OUTFILE
	awk '/<listener>/,/<\/listener>/' "$jeus"/config/domain.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	
	
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0401 END" >> $OUTFILE
}

Jeus_13() {
	echo ' ' >> $OUTFILE
	echo "0402 START" >> $OUTFILE
	echo -n '[ 4.2. 관리자 Default 계정명 변경 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 4.2. 관리자 Default 계정명 변경 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' Default 계정명인 administrator을 변경하여 사용하는 경우 양호 ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo "[accounts.xml 의 <user> 설정 확인]" >> $OUTFILE
	awk '/<user>/,/<\/user>/' "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
	echo "[policies.xml 의 <principal> 설정 확인]" >> $OUTFILE
	awk '/<role-permissions>/,/<\/role-permissions>/' "$jeus"/config/security/SYSTEM_DOMAIN/policies.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0402 END" >> $OUTFILE
}

Jeus_14() {
	echo ' ' >> $OUTFILE
	echo "0403 START" >> $OUTFILE
	echo -n '[ 4.3. 관리자 패스워드 암호정책 ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 4.3. 관리자 패스워드 암호정책 ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE
	echo ' 패스워드는 4가지 문자 중 3종류 이상을 조합하여 최소 8자리 이상 ' >> $OUTFILE
	echo ' 또는, 2종류 이상을 조합하여 최소 10자리 이상으로 사용하면 양호 ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo "[accounts.xml 의 <password> 설정에서 패스워드 확인(담당자 인터뷰)]" >> $OUTFILE
	awk '/<password>/,/<\/password>/' "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0403 END" >> $OUTFILE
}

Jeus_15() {
	echo ' ' >> $OUTFILE
	echo "0404 START" >> $OUTFILE
	echo -n '[ 4.4. accounts.xml 파일 권한 설정 ] =================================='
	echo '===================================================================' >> $OUTFILE
	echo ' 4.4. accounts.xml 파일 권한 설정' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '▶ 점검기준' >> $OUTFILE 
	if [ "$os" = "WindowsNT" ]; then
		echo 'accounts.xml 파일에 Everyone의 모든 사용 권한이 제거 되어있으면 양호'>> $OUTFILE 
	else
		echo 'accounts.xml 파일에 그룹과 다른 사용자의 읽기, 쓰기, 실행 권한이 없는 600인 경우 양호' >> $OUTFILE 
	fi
	echo '' >> $OUTFILE
	echo '▶ 시스템 현황' >> $OUTFILE
	echo ' | accounts.xml 파일 | ' >> $OUTFILE
	result4_4_1='Good'
	if [ "$os" = "WindowsNT" ]; then
		cacls "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
		if [ `cacls "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml | grep -i Everyone | grep "F" | wc -l`-gt 0 ]; then
			result4_4_1='Vulnerability' 
		fi
	else
		ls -l "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
		if [ `ls -l "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml |grep -v '.r...-..-.'|wc -l` -gt 0 ]; then
			result4_4_1='Vulnerability' 
		fi 
	fi
	if [ $result4_4_1 = 'Vulnerability' ];then
		result4_4='취약'
	else
		result4_4='양호' 
	fi
	#echo '★ 1.3. 결과 : ' $result4_4 >> $OUTFILE 
	#echo '★ 1.3. 결과 : ' $result4_4 >> $SUMMARY
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0404 END" >> $OUTFILE
}

Jeus_01
Jeus_02
Jeus_03
Jeus_04
Jeus_05
Jeus_06
Jeus_07
Jeus_08
Jeus_09
Jeus_10
Jeus_11
Jeus_12
Jeus_13
Jeus_14
Jeus_15


echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
#echo '| JEUS VULNERABILITY SUMMARY |' >> $OUTFILE
echo '===================================================================' >> $OUTFILE
if [ -f $SUMMARY ]; then
	cat $SUMMARY >> $OUTFILE 
fi
rm -f $TMPFILE 
rm -f $SUMMARY
echo '' >> $OUTFILE
os=`uname`
if [ "$os" = "WindowsNT" ]; then
	ipconfig /all >> $OUTFILE 
elif [ "%os" = "HP-UX" ]; then 
	lanscan -v >> $OUTFILE 
else
	ifconfig -a >> $OUTFILE 
fi
echo '===================================================================' >> $OUTFILE
echo "Terminated at `date`" >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo '***************************** End *****************************' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE

echo '↓↓↓↓↓↓↓↓↓↓↓↓↓↓ JEUS 관련 파일 전체 보기(수동 점검 용) ↓↓↓↓↓↓↓↓↓↓↓↓↓↓' >> $OUTFILE
echo ' ' >> $OUTFILE
echo ' ' >> $OUTFILE
echo "########################accounts.xml###############################" >> $OUTFILE
cat "$jeus"/config/domain.xml >> $OUTFILE
echo "#######################JEUSMain.xml###################################" >> $OUTFILE
cat "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
echo "######################################################################" >> $OUTFILE
echo '===================================================================' >> $OUTFILE
echo "Terminated at `date`" >> $OUTFILE
echo '*******************:********** End ***********************************'
if [ "$os" = "WindowsNT" ]; then
	echo "Result Filename: $OUTFILE"
else
	echo "$OUTFILE 파일을 회수해 주시기 바랍니다." 
fi
echo ''
#end script
