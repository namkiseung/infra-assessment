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
echo "***************************************�ý���***************************************" >> $OUTFILE
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
echo -n '[ 1.1. ���� ���� ] ================================================'
echo '=======================================================================' >> $OUTFILE
echo '1.1. ���� ����' >> $OUTFILE
echo '=======================================================================' >> $OUTFILE
echo '�� ���˱���' >> $OUTFILE
if [ "$os" = "WindowsNT" ]; then
	echo 'JEUS ��������� SYSTEM ������ �ƴϸ� ��ȣ' >> $OUTFILE
else
	echo 'JEUS ��������� root�� �ƴ� nobody Ȥ�� ��������̸� ��ȣ' >> $OUTFILE
fi
echo '' >> $OUTFILE
echo '�� �ý��� ��Ȳ' >> $OUTFILE
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
		result1_1_1='�ش����'
	fi
fi
echo ' ' >> $OUTFILE
if [ $result1_1_1 = 'Good' ]; then
	result1_1='��ȣ'
else
	result1_1='���'
fi
#echo '�� 1.1. ��� : ' $result1_1 >> $OUTFILE
#echo '�� 1.1. ��� : ' $result1_1 >> $SUMMARY
echo '-----------------------------------------------------------------------' >> $OUTFILE
echo '[DONE]'
echo "0101 END" >> $OUTFILE
}



Jeus_02() {
	echo ' ' >> $OUTFILE
	echo "0102 START" >> $OUTFILE
	echo -n '[ 1.2. Ȩ ���͸� ���� ���� ] =================================='
	echo '===================================================================' >> $OUTFILE
	echo ' 1.2 Ȩ ���͸� ���� ����' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE 
	if [ "$os" = "WindowsNT" ]; then
		echo '�ش� ���͸��� Everyone�� ��� ��� ������ ���� �Ǿ������� ��ȣ' >> $OUTFILE 
	else
		echo 'Ȩ ���͸��� �׷�� �ٸ� ������� ���� ������ ���� 750�� ��� ��ȣ' >> $OUTFILE 
	fi
	echo '' >> $OUTFILE
	echo '�� �ý��� ��Ȳ'>> $OUTFILE
	cat "$jeus"/domain.xml | grep path |grep -v '\.' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '|node Ȩ ���͸�|' >> $OUTFILE
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
	echo '|�ҽ� Ȩ ���͸�|' >> $OUTFILE
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
		result1_2='���'
	else
		result1_2='��ȣ' 
	fi
	#echo '�� 1.4. ��� : ' $result1_2 >> $OUTFILE 
	#echo '�� 1.4. ��� : ' $result1_2 >> $SUMMARY
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]' >> $OUTFILE
	echo "0102 END" >> $OUTFILE
}



Jeus_03() {
	echo ' ' >> $OUTFILE
	echo "0103 START" >> $OUTFILE
	echo -n '[ 1.3. �������� ���� ���� ] =================================='
	echo '===================================================================' >> $OUTFILE
	echo ' 1.3. �������� ���� ����' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE 
	if [ "$os" = "WindowsNT" ]; then
		echo '�������Ͽ� Everyone�� ��� ��� ������ ���� �Ǿ������� ��ȣ'>> $OUTFILE 
	else
		echo '�������Ͽ� �׷�� �ٸ� ������� �б�, ����, ���� ������ ���� 600�� ��� ��ȣ' >> $OUTFILE 
	fi
	echo '' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo ' | ���� ���� | ' >> $OUTFILE
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
		result1_3='���'
	else
		result1_3='��ȣ' 
	fi
	#echo '�� 1.3. ��� : ' $result1_3 >> $OUTFILE 
	#echo '�� 1.3. ��� : ' $result1_3 >> $SUMMARY
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0103 END" >> $OUTFILE
}



Jeus_04() {
	echo ' ' >> $OUTFILE
	echo "0104 START" >> $OUTFILE
	echo -n '[ 1.4. �α� ���͸�/���� ���� ���� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.4. �α� ���͸�/���� ���� ���� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE 
	echo '�α� ���͸��� �׷�� �ٸ� ������� ���� ������ ���� 750�� ��� ��ȣ' >> $OUTFILE
	echo '�α� ���Ͽ� �׷�� �ٸ� ������� ���� ������ ���� 640�� ��� ��ȣ' >> $OUTFILE 
	echo '' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo ' | �α� ���͸� | ' >> $OUTFILE
	ls -l "$jeus"/servers/* | grep log >> $OUTFILE
	echo '' >> $OUTFILE
	echo ' | �α� ���� | ' >> $OUTFILE
	ls -lR "$jeus"/servers/ | grep "\.log" >> $OUTFILE	
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0104 END" >> $OUTFILE
}

Jeus_05() {
	echo ' ' >> $OUTFILE
	echo "0105 START" >> $OUTFILE
	echo -n '[ 1.5. �α� ���� ���� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.5. �α� ���� ���� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' �α� �����ڰ� ���Եǰ� ���� ������ ������ ��� ��ȣ ' >> $OUTFILE
	echo ' ������ �ܼ�: [server] - [Engine] - [Web Engine] - [AccessLog] - [Format] Ȯ�� ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo ' (���� ����) ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0105 END" >> $OUTFILE
}

Jeus_06() {
	echo ' ' >> $OUTFILE
	echo "0106 START" >> $OUTFILE
	echo -n '[ 1.6. �α� ���� �ֱ� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.6. �α� ���� �ֱ� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' ���̳� ȸ�� ���Կ� ���� �α� �����ֱ⸦ ������ ��� ��ȣ ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo ' (����� ���ͺ� �� ��������) ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0106 END" >> $OUTFILE
}

Jeus_07() {
	echo ' ' >> $OUTFILE
	echo "0107 START" >> $OUTFILE
	echo -n '[ 1.7. ��� ���� ���� ���� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.7. ��� ���� ���� ���� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' HTTP ���� ����� ���� ������ ������� �ʴ� ��� ��ȣ ' >> $OUTFILE
	echo ' [JEUS_HOME]/domains/[domains_name]/config/domain.xml ������ ���� �� Ȯ�� ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo ' "<field-name>P3P</field-name> ' >> $OUTFILE	
	echo ' <field-value>CP='CAO PSA CONI OTR OUR DEM ONL'</field-value>" ���� Ȯ��' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo ' �� ���� ���� ��� Default ������ ������� ���� ����(��ȣ) ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
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
	echo -n '[ 1.8. Session Timeout ���� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.8. Session Timeout ���� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' Session Timeout �� 30�� ���Ϸ� ������ ��� ��ȣ ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo "[domain.xml �� <timeout>��</timeout> ���� Ȯ��]" >> $OUTFILE
	awk '/<session-config>/,/<\/session-config>/' "$jeus"/config/domain.xml >> $OUTFILE

	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0108 END" >> $OUTFILE
}

Jeus_09() {
	echo ' ' >> $OUTFILE
	echo "0109 START" >> $OUTFILE
	echo -n '[ 1.9. �����ͼҽ��� �н����� ��ȣȭ ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 1.9. �����ͼҽ��� �н����� ��ȣȭ ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' �����ͼҽ��� �н����尡 ��ȣȭ �Ǿ��ִ� ��� ��ȣ ' >> $OUTFILE
	echo ' ��ȣȭ ����� Base64�� �ƴ� �ٸ� �Ϲ��� ��ȣȭ�� �����Ǿ� �ִ��� Ȯ�� ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo "[accounts.xml �� <password> ���� Ȯ��]" >> $OUTFILE
	awk '/<password>/,/<\/password>/' "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0109 END" >> $OUTFILE
}

Jeus_10() {
	echo ' ' >> $OUTFILE
	echo "0201 START" >> $OUTFILE
	echo -n '[ 2.1. ���ʿ��� ���� �� ���͸� ���� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 2.1. ���ʿ��� ���� �� ���͸� ���� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo '���ʿ��� ���� �� ���͸��� ������ ��� ��ȣ' >> $OUTFILE
	echo 'samples ���͸� ���� �� ���' >> $OUTFILE
	echo '' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	ls -al "$JEUS_HOME" | grep samples >> $OUTFILE
	
	if [ ! -d "$JEUS_HOME/samples" ]; then
		echo 'Sample ���͸��� �������� ����' >> $OUTFILE 
	fi
	echo ' ' >> $OUTFILE
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]' 
	echo "0201 END" >> $OUTFILE
}

Jeus_11() {
	echo ' ' >> $OUTFILE
	echo "0301 START" >> $OUTFILE
	echo -n '[ 3.1. ���� ��ġ ���� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 3.1. ���� ��ġ ���� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' �ֱ������� ������ġ�� ������ ��� ��ȣ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	$jeus/../../bin/jeusadmin -fullversion >> $OUTFILE

	echo ' ' >> $OUTFILE
	echo '|[�ֽ� ����(2018.3)]' >> $OUTFILE 
	echo 'JEUS7.0 Fix5' >> $OUTFILE 
	echo 'JEUS6.0 Fix9' >> $OUTFILE 
	echo 'JEUS5.0 Fix27' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo "0301 END" >> $OUTFILE
}

Jeus_12() {
	echo ' ' >> $OUTFILE
	echo "0401 START" >> $OUTFILE
	echo -n '[ 4.1. ������ �ܼ� �������� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 4.1. ������ �ܼ� �������� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' ������ �������� ������� �ʰų� ������ ������ ������ IP �ּҿ� �����ϱ� ����� port�� �����Ͽ� ����ϴ� ��� ��ȣ ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo "[������ �������� ��Ȱ��ȭ(false) Ȯ��]" >> $OUTFILE
	awk '/<enable-webadmin>/,/<\/enable-webadmin>/' "$jeus"/config/domain.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo "[������ �������� �⺻��Ʈ(9736) ��� ���� Ȯ��]" >> $OUTFILE
	awk '/<listen-port>/,/<\/listen-port>/' "$jeus"/config/domain.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo "[������ �������� ���� ���� Ȯ��]" >> $OUTFILE
	awk '/<listener>/,/<\/listener>/' "$jeus"/config/domain.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	
	
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0401 END" >> $OUTFILE
}

Jeus_13() {
	echo ' ' >> $OUTFILE
	echo "0402 START" >> $OUTFILE
	echo -n '[ 4.2. ������ Default ������ ���� ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 4.2. ������ Default ������ ���� ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' Default �������� administrator�� �����Ͽ� ����ϴ� ��� ��ȣ ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo "[accounts.xml �� <user> ���� Ȯ��]" >> $OUTFILE
	awk '/<user>/,/<\/user>/' "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
	echo "[policies.xml �� <principal> ���� Ȯ��]" >> $OUTFILE
	awk '/<role-permissions>/,/<\/role-permissions>/' "$jeus"/config/security/SYSTEM_DOMAIN/policies.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	

	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0402 END" >> $OUTFILE
}

Jeus_14() {
	echo ' ' >> $OUTFILE
	echo "0403 START" >> $OUTFILE
	echo -n '[ 4.3. ������ �н����� ��ȣ��å ] ============================='
	echo '==================================================================='>>$OUTFILE
	echo ' 4.3. ������ �н����� ��ȣ��å ' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE
	echo ' �н������ 4���� ���� �� 3���� �̻��� �����Ͽ� �ּ� 8�ڸ� �̻� ' >> $OUTFILE
	echo ' �Ǵ�, 2���� �̻��� �����Ͽ� �ּ� 10�ڸ� �̻����� ����ϸ� ��ȣ ' >> $OUTFILE
	echo ' ' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo "[accounts.xml �� <password> �������� �н����� Ȯ��(����� ���ͺ�)]" >> $OUTFILE
	awk '/<password>/,/<\/password>/' "$jeus"/config/security/SYSTEM_DOMAIN/accounts.xml >> $OUTFILE
	echo ' ' >> $OUTFILE	
	echo '---------------------------------------------------------------------------------' >> $OUTFILE
	echo '[DONE]'
	echo "0403 END" >> $OUTFILE
}

Jeus_15() {
	echo ' ' >> $OUTFILE
	echo "0404 START" >> $OUTFILE
	echo -n '[ 4.4. accounts.xml ���� ���� ���� ] =================================='
	echo '===================================================================' >> $OUTFILE
	echo ' 4.4. accounts.xml ���� ���� ����' >> $OUTFILE
	echo '===================================================================' >> $OUTFILE
	echo '�� ���˱���' >> $OUTFILE 
	if [ "$os" = "WindowsNT" ]; then
		echo 'accounts.xml ���Ͽ� Everyone�� ��� ��� ������ ���� �Ǿ������� ��ȣ'>> $OUTFILE 
	else
		echo 'accounts.xml ���Ͽ� �׷�� �ٸ� ������� �б�, ����, ���� ������ ���� 600�� ��� ��ȣ' >> $OUTFILE 
	fi
	echo '' >> $OUTFILE
	echo '�� �ý��� ��Ȳ' >> $OUTFILE
	echo ' | accounts.xml ���� | ' >> $OUTFILE
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
		result4_4='���'
	else
		result4_4='��ȣ' 
	fi
	#echo '�� 1.3. ��� : ' $result4_4 >> $OUTFILE 
	#echo '�� 1.3. ��� : ' $result4_4 >> $SUMMARY
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

echo '��������������� JEUS ���� ���� ��ü ����(���� ���� ��) ���������������' >> $OUTFILE
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
	echo "$OUTFILE ������ ȸ���� �ֽñ� �ٶ��ϴ�." 
fi
echo ''
#end script
