
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

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#################################  Preprocessing...  #####################################"
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

# FTP ���� ����Ȯ��
find /etc/ -name "proftpd.conf" | grep "/etc/"                                                     > proftpd.txt
find /etc/ -name "vsftpd.conf" | grep "/etc/"                                                      > vsftpd.txt
profile=`cat proftpd.txt`
vsfile=`cat vsftpd.txt`


############################### APACHE Check Process Start ##################################

#0. �ʿ��� �Լ� ����

apache_awk() {
	if [ `ps -ef | grep -i $1 | grep -v "ns-httpd" | grep -v "grep" | awk '{print $8}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
	then
		apaflag=8
	elif [ `ps -ef | grep -i $1 | grep -v "ns-httpd" | grep -v "grep" | awk '{print $9}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
	then
		apaflag=9
	fi
}


# 1. ����ġ ���μ��� ���� ���� Ȯ�� �� ����ġ TYPE �Ǵ�, awk �÷� Ȯ��

if [ `ps -ef | grep -i "httpd" | grep -v "ns-httpd" | grep -v "lighttpd" | grep -v "grep" | wc -l` -gt 0 ]
then
	apache_type="httpd"
	apache_awk $apache_type

elif [ `ps -ef | grep -i "apache2" | grep -v "ns-httpd" | grep -v "lighttpd" | grep -v "grep" | wc -l` -gt 0 ]
then
	apache_type="apache2"
	apache_awk $apache_type
else
	apache_type="null"
	apaflag=0	
fi

# 2. ����ġ Ȩ ���丮 ��� Ȯ��

if [ $apaflag -ne 0 ]
then

	if [ `ps -ef | grep -i $apache_type | grep -v "ns-httpd" | grep -v "grep" | awk -v apaflag2=$apaflag '{print $apaflag2}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
	then
		APROC1=`ps -ef | grep -i $apache_type | grep -v "ns-httpd" | grep -v "grep" | awk -v apaflag2=$apaflag '{print $apaflag2}' | grep "/" | grep -v "httpd.conf" | uniq`
		APROC=`echo $APROC1 | awk '{print $1}'`
		$APROC -V > APROC.txt 2>&1
				
		ACCTL=`echo $APROC | sed "s/$apache_type$/apachectl/"`
		$ACCTL -V > ACCTL.txt 2>&1
				
		if [ `cat APROC.txt | grep -i "root" | wc -l` -gt 0 ]
		then
			AHOME=`cat APROC.txt | grep -i "root" | awk -F"\"" '{print $2}'`
			ACFILE=`cat APROC.txt | grep -i "server_config_file" | awk -F"\"" '{print $2}'`
		else
			AHOME=`cat ACCTL.txt | grep -i "root" | awk -F"\"" '{print $2}'`
			ACFILE=`cat ACCTL.txt | grep -i "server_config_file" | awk -F"\"" '{print $2}'`
		fi
	fi
	
	if [ -f $AHOME/$ACFILE ]
	then
		ACONF=$AHOME/$ACFILE
	else
		ACONF=$ACFILE
	fi	
fi

# 3. ���ʿ��� ���� ����

rm -rf APROC.txt
rm -rf ACCTL.txt

################################ APACHE Check Process End ###################################

clear

echo " " > $HOSTNAME.linux.result.txt 2>&1

echo "***************************************************************************************"
echo "***************************************************************************************"
echo "*                                                                                     *"
echo "*  Linux Security Checklist version $SVersion                                         *"
echo "*                                                                                     *"
echo "***************************************************************************************"
echo "***************************************************************************************"

echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo "��������������������             Linux Security Check           	 ���������������������" >> $HOSTNAME.linux.result.txt 2>&1
echo "��������������������      Copyright �� 2019, SK think Co. Ltd.    ���������������������" >> $HOSTNAME.linux.result.txt 2>&1
echo "��������������������     Ver $SVersion // Last update $SLast_update ���������������������" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "##################################  Start Time  #######################################"
date
echo "##################################  Start Time  #######################################" >> $HOSTNAME.linux.result.txt 2>&1
date                                                                                           >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "*************************************** START *****************************************"
echo "*************************************** START *****************************************" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        1. ����� ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0101 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           root ���� ���� ���� ����            ####################"
echo "####################           root ���� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����1: [telnet] /etc/securetty ���Ͽ� pts/* ������ ������ ������ ���"                          >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ����2: [telnet] /etc/securetty ���Ͽ� pts/* ������ ���ų� �ּ�ó���� �Ǿ� �ְ�,"                >> $HOSTNAME.linux.result.txt 2>&1 
echo "��        : /etc/pam.d/login���� auth required /lib/security/pam_securetty.so ���ο� �ּ�(#)�� ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: [SSH] /etc/ssh/sshd_config ���Ͽ� PermitRootLogin no�� �����Ǿ� ���� ��� ��ȣ"       >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� [telnet] /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� [telnet] ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
		flag1="M/T"
	else
		echo "�� Telnet Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
		flag1="Disabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� [telnet] /etc/securetty ���� ����"                                                             >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/securetty | grep "pts" | wc -l` -gt 0 ]
then
	cat /etc/securetty | grep "pts"                                                              >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "/etc/securetty ���Ͽ� pts/0~pts/x ������ �����ϴ�."                                    >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� [telnet] /etc/pam.d/login ���� ����"                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/pam.d/login | grep "pam_securetty.so"                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� [SSH] ���� ���� Ȯ��"                                                               >> $HOSTNAME.linux.result.txt 2>&1
echo "--------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
then
  echo "�� SSH Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
  flag2="Disabled"
else
  ps -ef | grep sshd | grep -v grep                                                         >> $HOSTNAME.linux.result.txt 2>&1
	flag2="Enabled"
fi
echo " " >> $HOSTNAME.linux.result.txt 2>&1
echo "�� [SSH] /opt/ssh/etc/sshd_config ���� Ȯ�� " >> $HOSTNAME.linux.result.txt 2>&1
echo "--------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/ssh/sshd_config | egrep -i 'PermitRootLogin' | wc -l` -eq 0 ]
then
  echo "�� sshd_config ���� ������ �ȵǾ� ���� " >> $HOSTNAME.linux.result.txt 2>&1
	flag3="Fail"
 else
  cat /etc/ssh/sshd_config | egrep -i 'PermitRootLogin' >> $HOSTNAME.linux.result.txt 2>&1
	flag3="M/T"
fi	
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$flag1":"$flag2":"$flag3                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0101 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0102 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���� ��� �Ӱ谪 ����            ####################"
echo "####################           ���� ��� �Ӱ谪 ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/pam.d/system-auth(common-auth) ���Ͽ� �Ʒ��� ���� ������ ������ ��ȣ"       >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (auth required /lib/security/pam_tally.so deny=5 unlock_time=120 no_magic_root)" >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (account required /lib/security/pam_tally.so no_magic_root reset)"             >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1

if [ -f /etc/pam.d/system-auth ]
then
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/pam.d/system-auth ���� ����(auth, account)"                                    >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	egrep "auth|account" /etc/pam.d/system-auth                                                  >> $HOSTNAME.linux.result.txt 2>&1

else	
	if [ -f /etc/pam.d/common-auth ]
	then
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo "�� /etc/pam.d/common-auth ���� ����(auth, account, include)"                         >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
		egrep "auth|account|include" /etc/pam.d/common-auth | grep -v "#"                          >> $HOSTNAME.linux.result.txt 2>&1
	fi
fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/pam.d/sshd ���� ����(auth, account)"                                           >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1

	egrep "auth|account|include" /etc/pam.d/sshd | grep -v "#"                                   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"      			                                                                 >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0102 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  



echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        2. ���� ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0201 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ������ �������� �ʴ� GID ����            ####################"
echo "####################           ������ �������� �ʴ� GID ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �������� �������� �ʴ� �� �׷��� �߰ߵ��� ���� ��� ��ȣ"                        >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� �������� �������� �ʴ� �׷�"                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	for gid in `awk -F: '$4==null {print $3}' /etc/group`
	do
		if [ `grep -c $gid /etc/passwd` -eq 0 ]
		then
			grep $gid /etc/group                                                                     >> nullgid.txt
		fi		
	done

if [ `cat nullgid.txt | wc -l` -eq 0 ]
then
		echo "�������� �������� �ʴ� �׷��� �߰ߵ��� �ʾҽ��ϴ�."                                  >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=0 	                                                                           >> $HOSTNAME.linux.result.txt 2>&1
else
		cat nullgid.txt                                                                            >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=`cat nullgid.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`                    >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0201 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf nullgid.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  


echo "0202 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ����� shell ����            ####################"
echo "####################           ����� shell ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �α����� �ʿ����� ���� �ý��� ������ /bin/false(nologin) ���� �ο��Ǿ� ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� �α����� �ʿ����� ���� �ý��� ���� Ȯ��"                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/passwd ]
  then
   cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher" | grep -v "admin" > temp202.txt 
   cat temp202.txt 																																						 >> $HOSTNAME.linux.result.txt 2>&1
   echo " "                                                                                    >> $HOSTNAME.linux.result.txt 2>&1
   echo Result=`egrep -v "false|nologin" temp202.txt | wc -l` >> $HOSTNAME.linux.result.txt 2>&1
    
  else
    echo "/etc/passwd ������ �����ϴ�."                                                        >> $HOSTNAME.linux.result.txt 2>&1
    echo Result=0                                                                              >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0202 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf temp202.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  


echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        3. ��й�ȣ ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0301 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           SNMP ���� Get community ��Ʈ�� ���� ����            ####################"
echo "####################           SNMP ���� Get community ��Ʈ�� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: SNMP Get Community �̸��� public �� �ƴ� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� SNMP ���� Ȱ��ȭ ���� Ȯ��(UDP 161)"                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `netstat -na | grep ":161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "�� SNMP Service Disable"                                                               >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
else
	netstat -na | grep ":161 " | grep -i "^udp"                                                  >> $HOSTNAME.linux.result.txt 2>&1
	flag1="M/T"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� SNMP Community String ���� ��"                                                        >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/snmpd.conf ]
then
	echo "�� /etc/snmpd.conf ���� ����:"                                                          >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#"           >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi
if [ -f /etc/snmp/snmpd.conf ]
then
	echo "�� /etc/snmp/snmpd.conf ���� ����:"                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/snmp/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#"      >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi
if [ -f /etc/snmp/conf/snmpd.conf ]
then
	echo "�� /etc/snmp/conf/snmpd.conf ���� ����:"                                                >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/snmp/conf/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#" >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi
if [ -f /SI/CM/config/snmp/snmpd.conf ]
then
	echo "�� /SI/CM/config/snmp/snmpd.conf ���� ����:"                                            >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /SI/CM/config/snmp/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#" >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi
if [ -f snmpd.txt ]
then
	rm -rf snmpd.txt
else
	echo "snmpd.conf ������ �����ϴ�."                                                           >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0301 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0302 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           SNMP ���� Set community ��Ʈ�� ���� ����            ####################"
echo "####################           SNMP ���� Set community ��Ʈ�� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: SNMP Set Community �̸��� public, private �� �ƴ� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� SNMP ���� Ȱ��ȭ ���� Ȯ��(UDP 161)"                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `netstat -na | grep ":161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "�� SNMP Service Disable"                                                               >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
else
	netstat -na | grep ":161 " | grep -i "^udp"                                                  >> $HOSTNAME.linux.result.txt 2>&1
	flag1="M/T"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� SNMP Community String ���� ��"                                                        >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/snmpd.conf ]
then
	echo "�� /etc/snmpd.conf ���� ����:"                                                          >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#"           >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi
if [ -f /etc/snmp/snmpd.conf ]
then
	echo "�� /etc/snmp/snmpd.conf ���� ����:"                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/snmp/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#"      >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi
if [ -f /etc/snmp/conf/snmpd.conf ]
then
	echo "�� /etc/snmp/conf/snmpd.conf ���� ����:"                                                >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/snmp/conf/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#" >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi
if [ -f /SI/CM/config/snmp/snmpd.conf ]
then
	echo "�� /SI/CM/config/snmp/snmpd.conf ���� ����:"                                            >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
	cat /SI/CM/config/snmp/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#" >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > snmpd.txt
fi

if [ -f snmpd.txt ]
then
	rm -rf snmpd.txt
else
	echo "snmpd.conf ������ �����ϴ�."                                                           >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0302 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0303 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ��й�ȣ ������å ����            ####################"
echo "####################           ��й�ȣ ������å ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����1: /etc/login.defs ���� ���� ���� �׸���� �����Ǿ� ���� ��� ��ȣ"            					   >> $HOSTNAME.linux.result.txt 2>&1 
echo "* PASS\_MAX\_DAYS, PASS\_MIN\_DAYS, PASS\_MIN\_LEN, PASS\_WARN\_AGE "                      >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ����2: /etc/pam.d/system-auth �Ǵ� /etc/security/pwquality.conf ���� ���� ���� �׸���� �����Ǿ� ���� ��� ��ȣ"            					   >> $HOSTNAME.linux.result.txt 2>&1 
echo "* minlen, dcredit, ucredit, lcredit, ocredit, minclass"                      >> $HOSTNAME.linux.result.txt 2>&1 

echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/login.defs ]
then
  cat /etc/login.defs | egrep "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
else
  echo "/etc/login.defs ������ �����ϴ�."                                                          >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/pam.d/system-auth ]
then
  cat /etc/pam.d/system-auth | egrep "pam_cracklib.so"                                         >> $HOSTNAME.linux.result.txt 2>&1
else
  echo "/etc/pam.d/system-auth ������ �����ϴ�."                                                          >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/security/pwquality.conf ]
then
  cat /etc/security/pwquality.conf | egrep "minlen|dcredit|ucredit|lcredit|ocredit|minclass"    >> $HOSTNAME.linux.result.txt 2>&1
else
  echo "/etc/security/pwquality.conf ������ �����ϴ�."                                                          >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0303 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                      >> $HOSTNAME.linux.result.txt 2>&1


echo "0304 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ��й�ȣ �������� ��ȣ            ####################"
echo "####################           ��й�ȣ �������� ��ȣ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �н����尡 /etc/shadow ���Ͽ� ��ȣȭ �Ǿ� ����ǰ� ������ ��ȣ"                  >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/passwd ]
then
	if [ `awk -F: '$2=="x"' /etc/passwd | wc -l` -eq 0 ]
	then
		echo "�� /etc/passwd ���Ͽ� �н����尡 ��ȣȭ �Ǿ� ���� �ʽ��ϴ�."                         >> $HOSTNAME.linux.result.txt 2>&1

	else
		echo "�� /etc/passwd ���Ͽ� �н����尡 ��ȣȭ �Ǿ� �ֽ��ϴ�."                              >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "�� /etc/passwd ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "     	                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo Result=`awk -F: '$2=="x"' /etc/passwd | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`		       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0304 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  


echo "0305 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �������� �ʴ� ���� �� ��й�ȣ ����            ####################"
echo "####################           �������� �ʴ� ���� �� ��й�ȣ ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����1: ���ʿ��� ������ �������� �ʴ� ��� ��ȣ(90�� �̻� �α��� ���� �ʴ� ���� ����)"							                           >> $HOSTNAME.linux.result.txt 2>&1
echo "��     : /etc/passwd ���� ������ �����Ͽ� ���ʿ��� ���� �ĺ� (���ͺ� �ʿ�)"               >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����2: ���� �н����� �������� 90�� ������ ��� ��ȣ"                                    >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/passwd ���� ����"                          							                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
    cat /etc/passwd                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ������, ���� �ֱ� �н����� ������(1970�� 1�� 1�Ϻ��� �н����尡 ������ ��¥�� �ϼ�)"                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
awk -F":" '{print $1 "\t\t" $3}' /etc/shadow                                                   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"																			   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0305 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  


echo "0306 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "############################################# ##########################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���߰����� ��й�ȣ ��� ����            ####################"
echo "####################           ���߰����� ��й�ȣ ��� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �н����� �ʵ忡 ���߰� �Ұ����� ������ ������ ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/shadow 				         												   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0306 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  



echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        4. ���� �� ���͸� ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0401 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           /dev�� �������� �ʴ� device ���� ����            ####################"
echo "####################           /dev�� �������� �ʴ� device ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� : dev �� �������� ���� Device ������ �����ϰ�, �������� ���� Device�� ���� ���� ��� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "��        : (�Ʒ� ������ ����� major, minor Number�� ���� �ʴ� ������)"                  >> $HOSTNAME.linux.result.txt 2>&1
echo "��        : (.devlink_db_lock/.devfsadm_daemon.lock/.devfsadm_synch_door/.devlink_db�� Default�� ���� ����)" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
find /dev -type f -exec ls -l {} \;                                                            > 4.01.txt

if [ -s 4.01.txt ]
then
	cat 4.01.txt                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� dev �� �������� ���� Device ������ �߰ߵ��� �ʾҽ��ϴ�."                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0401 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf 4.01.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0402 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Ȩ���丮�� ������ ���丮�� ���� ����            ####################"
echo "####################           Ȩ���丮�� ������ ���丮�� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: Ȩ ���͸��� �������� �ʴ� ������ �߰ߵ��� ������ ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1
# Ȩ ���丮�� �������� �ʴ� ���, �Ϲ� ����ڰ� �α����� �ϸ� ������� ���� ���͸��� /�� �α��� �ǹǷ� ����,���Ȼ� ������ �߻���.
# ��) �ش� �������� ftp �α��� �� / ���͸��� �����Ͽ� �߿� ������ ����� �� ����.
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� Ȩ ���͸��� �������� ���� ����"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
flag=0
for dir in $HOMEDIRS
do
	if [ ! -d $dir ]
	then
		awk -F: '$6=="'${dir}'" { print "�� ������(Ȩ���͸�):"$1 "(" $6 ")" }' /etc/passwd        >> $HOSTNAME.linux.result.txt 2>&1
		flag=`expr $flag + 1`
		echo " "                                                                                   > 4.02.txt
	fi
done

if [ ! -f 4.02.txt ]
then
	echo "Ȩ ���͸��� �������� ���� ������ �߰ߵ��� �ʾҽ��ϴ�. (��ȣ)"                        >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=0                                                                                >> $HOSTNAME.linux.result.txt 2>&1
else
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0402 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf 4.02.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0403 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ������ ���� �� ���丮 �˻� �� ����            ####################"
echo "####################           ������ ���� �� ���丮 �˻� �� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ���丮 ���� ������ ������ Ȯ�� �� �˻� �Ͽ� , ���ʿ��� ������ ������ �Ϸ��� ��� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
find /tmp -name ".*" -ls                                                                       > temp403.txt
find /home -name ".*" -ls                                                                      >> temp403.txt
find /usr -name ".*" -ls                                                                       >> temp403.txt
find /var -name ".*" -ls                                                                       >> temp403.txt
head -10 temp403.txt                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "���� ����Ʈ���� ������ ���� Ȯ��"                                                        >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0403 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
rm -rf temp403.txt
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        5. ���� ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0501 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ftp ���� shell ����            ####################"
echo "####################           ftp ���� shell ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ftp ���񽺰� ��Ȱ��ȭ �Ǿ� ���� ��� ��ȣ"                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : ftp ���� ��� �� ftp ������ /bin/false ���� �ο��ϸ� ��ȣ" 				 >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "(1)/etc/service����: ��Ʈ ���� X (Default 21�� ��Ʈ)"                                  >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}'    >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(2)ProFTP ��Ʈ: ��Ʈ ���� X (/etc/service ���Ͽ� ������ ��Ʈ�� �����)"              >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(2)ProFTP ��Ʈ: ProFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(3)VsFTP ��Ʈ: ��Ʈ ���� X (Default 21�� ��Ʈ �����)"                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(3)VsFTP ��Ʈ: VsFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                        >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
################# /etc/services ���Ͽ��� ��Ʈ Ȯ�� #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd ���� ��Ʈ Ȯ�� ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd ���� ��Ʈ Ȯ�� ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� ftp ���� �� Ȯ��"                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	if [ `cat /etc/passwd | awk -F: '$1=="ftp"' | wc -l` -gt 0 ]
	then
		cat /etc/passwd | awk -F: '$1=="ftp"'                                                        >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat /etc/passwd | awk -F: '$1=="ftp" {print $7}' | egrep -v "nologin|false" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "ftp ������ �������� ����.(��ȣ)"                                                       >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat /etc/passwd | awk -F: '$1=="ftp"' | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	fi
	
else
	echo "�� FTP Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0501 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0502 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           SNMP ���� ���� ����            ####################"
echo "####################           SNMP ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: SNMP ���񽺸� ���ʿ��� �뵵�� ������� ���� ��� ��ȣ"                           >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
# SNMP���񽺴� ���۽� /etc/service ������ ��Ʈ�� ������� ����.
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ `netstat -na | grep ":161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "�� SNMP Service Disable"                                                               >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="Disabled"                                                                         >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� SNMP ���� Ȱ��ȭ ���� Ȯ��(UDP 161)"                                              >> $HOSTNAME.linux.result.txt 2>&1
  echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	netstat -na | grep ":161 " | grep -i "^udp"                                                 >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="Enabled"                                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0502 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0503 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache ������ ���� ����            ####################"
echo "####################           Apache ������ ���� ����           ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ServerTokens �����ڷ� ����� ���۵Ǵ� ������ ������ �� ����.(ServerTokens Prod ������ ��� ��ȣ)" >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : ServerTokens Prod ������ ���� ��� Default ����(ServerTokens Full)�� �����."  >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	
	echo "�� $ACONF ���� ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	if [ `cat $ACONF | grep -i "ServerTokens" | grep -v '\#' | wc -l` -gt 0 ]
	then
		cat $ACONF | grep -i "ServerTokens" | grep -v '\#'                                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat $ACONF | grep -i "ServerTokens" | grep -v '\#' | awk -F" " '{print $2}'`
	else
		echo "ServerTokens �����ڰ� �����Ǿ� ���� �ʽ��ϴ�.(���)"                                 >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0503 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        6. ���� ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0601 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Sendmail Log Level �̼���           ####################"
echo "####################           Sendmail Log Level �̼���            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: LogLevel �������� 9 �̻��� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                          
echo "�� sendmail ���μ��� Ȯ��"                                    					                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	Result="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.linux.result.txt 2>&1
	
	echo " "                                                                                  	 >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/mail/sendmail.cf ���� Ȯ��"                                                          >> $HOSTNAME.linux.result.txt 2>&1
	echo "-------------------------------------------" 												>> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
		if [ `cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel | wc -l` -eq 0 ]
		then 
			echo "LogLevel ������ �ȵǾ� ����"																>> $HOSTNAME.linux.result.txt 2>&1
			Result="M/T"			
		else
			if [ `cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel | awk -F= '{print $2}'` -ge 9 ]
			then 
				cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel									>> $HOSTNAME.linux.result.txt 2>&1
				Result="success"																	
			else 
				cat /etc/mail/sendmail.cf | grep -i LogLevel												>> $HOSTNAME.linux.result.txt 2>&1
				Result="fail"											
			fi
		fi
	else
		echo "�� /etc/mail/sendmail.cf ������ �������� ����"                                              >> $HOSTNAME.linux.result.txt 2>&1
	fi

	echo " "                                                                 					    >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/sendmail.cf ���� Ȯ��"                                                               >> $HOSTNAME.linux.result.txt 2>&1
	echo "-------------------------------------------"  											>> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	then
		if [ `cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel | wc -l` -eq 0 ]
		then 
			echo "�� LogLevel ������ �ȵǾ� ����"                                             					>> $HOSTNAME.linux.result.txt 2>&1
			Result="M/T"			
		else  
			if [ `cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel | awk -F= '{print $2}'` -ge 9 ]
			then
				cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel 											>> $HOSTNAME.linux.result.txt 2>&1
				Result="success"																
			else 
				cat /etc/sendmail.cf | grep -i LogLevel															>> $HOSTNAME.linux.result.txt 2>&1
				Result="fail"																
			fi
		fi    
	else
		echo "�� /etc/sendmail.cf ������ �������� ����"                                  			            >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "�� Sendmail Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	Result="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "[����]"                                                                              	   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "/etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     	 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                        		 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� Sendmail Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "���� ��Ʈ Ȯ�� �Ұ�" 				                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$Result	                       			                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0601 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0602 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           NFS ��������            ####################"
echo "####################           NFS ��������            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����1: NFS ���� ������ �������� ������ ��ȣ"                                           >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����2: NFS ���� ������ �����ϴ� ��� /etc/exports ���Ͽ� everyone ���� ������ ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� NFS Server Daemon(nfsd)Ȯ��"                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
 then
   ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep"                >> $HOSTNAME.linux.result.txt 2>&1
   flag="M/T"
 else
   echo "�� NFS Service Disable"                                                               >> $HOSTNAME.linux.result.txt 2>&1
   flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/exports ���� ����"                                                               >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/exports ]
then
	if [ `cat /etc/exports | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/exports | grep -v "^#" | grep -v "^ *$"                                           >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "���� ������ �����ϴ�."                                                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
  echo "/etc/exports ������ �����ϴ�."                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag					                                                       >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0602 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0603 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           $HOME/.rhosts, hosts.equiv ��� ����            ####################"
echo "####################           $HOME/.rhosts, hosts.equiv ��� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: r-commands ���񽺸� ������� ������ ��ȣ"                                        >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : r-commands ���񽺸� ����ϴ� ��� HOME/.rhosts, hosts.equiv ����Ȯ��"          >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (1) .rhosts ������ �����ڰ� �ش� ������ �������̰�, �۹̼� 600, ���뿡 + �� �����Ǿ� ���� ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (2) /etc/hosts.equiv ������ �����ڰ� root �̰�, �۹̼� 600, ���뿡 + �� �����Ǿ� ���� ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep :$port | grep -i "^tcp"                                                  > 6.03.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep :$port | grep -i "^tcp"                                                  >> 6.03.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep :$port | grep -i "^tcp"                                                  >> 6.03.txt
fi

if [ -s 6.03.txt ]
then
	cat 6.03.txt | grep -v '^ *$'                                                                >> $HOSTNAME.linux.result.txt 2>&1
	flag="M/T"
else
	echo "�� r-command Service Disable"                                                          >> $HOSTNAME.linux.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/hosts.equiv ���� ����"                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/hosts.equiv ]
	then
		echo "(1) Permission: (`ls -al /etc/hosts.equiv`)"                                         >> $HOSTNAME.linux.result.txt 2>&1
		echo "(2) ���� ����:"                                                                      >> $HOSTNAME.linux.result.txt 2>&1
		echo "----------------------------------------"                                            >> $HOSTNAME.linux.result.txt 2>&1
		if [ `cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
		then
			cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$'                                      >> $HOSTNAME.linux.result.txt 2>&1
		else
			echo "���� ������ �����ϴ�."                                                             >> $HOSTNAME.linux.result.txt 2>&1
		fi
	else
		echo "/etc/hosts.equiv ������ �����ϴ�."                                                   >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����� home directory .rhosts ���� ����"                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u`
FILES="/.rhosts"

for dir in $HOMEDIRS
do
	for file in $FILES
	do
		if [ -f $dir$file ]
		then
			echo " "                                                                                 > rhosts.txt
			echo "# $dir$file ���� ����:"                                                            >> $HOSTNAME.linux.result.txt 2>&1
			echo "(1) Permission: (`ls -al $dir$file`)"                                              >> $HOSTNAME.linux.result.txt 2>&1
			echo "(2) ���� ����:"                                                                    >> $HOSTNAME.linux.result.txt 2>&1
			echo "----------------------------------------"                                          >> $HOSTNAME.linux.result.txt 2>&1
			if [ `cat $dir$file | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
			then
				cat $dir$file | grep -v "#" | grep -v '^ *$'                                           >> $HOSTNAME.linux.result.txt 2>&1
			else
				echo "���� ������ �����ϴ�."                                                           >> $HOSTNAME.linux.result.txt 2>&1
			fi
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		fi
	done
done
if [ ! -f rhosts.txt ]
then
	echo ".rhosts ������ �����ϴ�."                                                              >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag                                                                          >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0603 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf rhosts.txt
rm -rf 6.03.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0604 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���� IP �� ��Ʈ ����            ####################"
echo "####################           ���� IP �� ��Ʈ ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����1: /etc/hosts.deny ���Ͽ� All Deny(ALL:ALL) ������ ��ϵǾ� �ְ�,"                 >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����2: /etc/hosts.allow ���Ͽ� ���� ��� IP�� ��ϵǾ� ������ ��ȣ"                    >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/hosts.allow ���� ����"                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/hosts.allow ]
then
	if [ ! `cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$'                                       >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "���� ������ �����ϴ�."                                                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/hosts.allow ������ �����ϴ�."                                                     >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/hosts.deny ���� ����"                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/hosts.deny ]
then
	if [ ! `cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$'                                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "���� ������ �����ϴ�."                                                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/hosts.deny ������ �����ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"	                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0604 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "


echo "0605 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache ���� ���丮 ���� ����            ####################"
echo "####################           Apache ���� ���丮 ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: httpd.conf ������ Directory �κ��� AllowOverride None ������ �ƴϸ� ��ȣ"        >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "�� $ACONF ���� ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |AllowOverride|</Directory" | grep -v '\#'                 >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |AllowOverride|</Directory" | grep -v '\#' | grep AllowOverride | awk -F" " '{print $2}' | grep -v none | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "�� Apache ���������� ã�� �� �����ϴ�.(��������)"                                  >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0605 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0606 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache �� ���μ��� ���� ����            ####################"
echo "####################           Apache �� ���μ��� ���� ����           ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �� ���μ��� ������ ���� ���� ��� ��ȣ(User root, Group root �� �ƴ� ���)"      >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	echo "�� $ACONF ���� ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1	
	cat $ACONF | grep -i "^user"                                                                 >> $HOSTNAME.linux.result.txt 2>&1
	cat $ACONF | grep -i "^group"                                                                >> $HOSTNAME.linux.result.txt 2>&1
	
	flag2=`cat $ACONF | grep -i "^user" | awk -F" " '{print $2}'`":"`cat $ACONF | grep -i "^group" | awk -F" " '{print $2}'`
	
	if [ $apache_type = "apache2" ]
	then
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo "�� envvars ���� ���� Ȯ��"                                                           >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
		cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^User" | awk '{print $2}' | sed 's/[${}]//g'`  >> $HOSTNAME.linux.result.txt 2>&1	
		cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^Group" | awk '{print $2}' | sed 's/[${}]//g'` >> $HOSTNAME.linux.result.txt 2>&1	
		usercheck=`cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^User" | awk '{print $2}' | sed 's/[${}]//g'` | awk -F"=" '{print $2}'`
		groupcheck=`cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^Group" | awk '{print $2}' | sed 's/[${}]//g'` | awk -F"=" '{print $2}'`
		flag2=$usercheck":"$groupcheck
	fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� $apache_type ���� ���� ���� Ȯ��"                                                   >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	ps -ef | grep $apache_type | grep -v grep                                                    >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled:Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0606 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0607 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ������ �׷쿡 �ּ����� ����� ����            ####################"
echo "####################           ������ �׷쿡 �ּ����� ����� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ������ �׷쿡 ���ʿ��� ������ ���� ��� ��ȣ"             >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ������ ����"                                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    awk -F: '$3==0 { print $1 " -> UID=" $3 }' /etc/passwd                                     >> $HOSTNAME.linux.result.txt 2>&1
  else
    echo "/etc/passwd ������ �����ϴ�."                                                        >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ������ ������ ���Ե� �׷� Ȯ��"                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
for group in `awk -F: '$3==0 { print $1}' /etc/passwd`
do
	cat /etc/group | grep "$group"                                                               >> $HOSTNAME.linux.result.txt 2>&1
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0607 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0608 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Crontab �������� ���� ���� ����            ####################"
echo "####################           Crontab �������� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: others�� �б�/���� ������ ���� ��� ��ȣ"                        						 >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	if [ -d /var/spool/cron/crontabs/ ]
	then
		echo "/var/spool/cron/crontabs �������� ���� Ȯ��"                                                       >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
		ls -alL /var/spool/cron/crontabs | egrep -v "total|^d"																>> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "/var/spool/cron �������� ���� Ȯ��"                                                       >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
		ls -alL /var/spool/cron | egrep -v "total|^d"																			>> $HOSTNAME.linux.result.txt 2>&1
	fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"																					>> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0608 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0609 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �ý��� ���丮 ���Ѽ��� �̺�            ####################"
echo "####################           �ý��� ���丮 ���Ѽ��� �̺�            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: others�� ���� ������ ���� ��� ��ȣ"                        						 >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin /usr/lbin"
for dir in $HOMEDIRS
do
  ls -dal $dir                                     >> $HOSTNAME.linux.result.txt 2>&1
done
echo " "										 >> $HOSTNAME.linux.result.txt 2>&1
HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin /usr/lbin"
for dir in $HOMEDIRS
do          
  if [ -d $dir ]
  then
    if [ `ls -dal $dir | awk -F" " '{print $1}' | grep "l........." | wc -l` -eq 1 ] 
    then
      echo "Manual" >> 6.09.txt
    elif [ `ls -dal $dir | awk -F" " '{print $1}' | grep "........w." | wc -l` -eq 1 ] 
    then
      echo "Fail"  >> 6.09.txt
    else 
      echo "Success" >> 6.09.txt 
    fi
  else
    echo "Success" >> 6.09.txt                                          
  fi
done

if [ `cat 6.09.txt | grep "Fail" | wc -l` -eq 1 ]
then 
  Result="Fail"
elif [ `cat 6.09.txt | grep "Manual" | wc -l` -eq 1 ]
then
  Result="M/T"
else 
  Result="Success"
fi  
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$Result																					>> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0609 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf 6.09.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0610 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �ý��� ��ŸƮ�� ��ũ��Ʈ ���� ���� ����            ####################"
echo "####################           �ý��� ��ŸƮ�� ��ũ��Ʈ ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: others�� ���� ������ ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/init.d /etc/rc2.d /etc/rc3.d /etc/rc.d/init.d ���� ���� Ȯ��"                                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	DIR_STARTUP="/etc/init.d /etc/rc2.d /etc/rc3.d /etc/rc.d/init.d"
	for ldir in $DIR_STARTUP; 
		do
		echo "�� $ldir/* ���� ����"																>> $HOSTNAME.linux.result.txt 2>&1
		if [ -d $ldir ]
		then
			ls -aldL $ldir/* | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"			>> $HOSTNAME.linux.result.txt 2>&1
		else
			echo "�������� ����."                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		fi
		done	
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0610 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0611 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           /etc/passwd ���� ������ �� ���� ����            ####################"
echo "####################           /etc/passwd ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/passwd ������ �����ڰ� root �̰�, ������ 644 ���� �̸� ��ȣ"                     >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    ls -alL /etc/passwd                                                                        >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result=`perm /etc/passwd | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`                             >> $HOSTNAME.linux.result.txt 2>&1
  else
    echo "�� /etc/passwd ������ �����ϴ�."                                                     >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result="Null:Null"                                                                    >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0611 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0612 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           /etc/shadow ���� ������ �� ���� ����            ####################"
echo "####################           /etc/shadow ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/shadow ������ �����ڰ� root �̰�, ������ 400 �̸� ��ȣ"                     >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/shadow ]
then
	ls -alL /etc/shadow                                                                          >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  echo Result=`perm /etc/shadow | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`                             >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� /etc/shadow ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  echo Result="Null:Null"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0612 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0613 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           /etc/hosts ���� ������ �� ���� ����            ####################"
echo "####################           /etc/hosts ���� ������ �� ���� ����           ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/hosts ������ �����ڰ� root �̰�, ������ 600 �̸� ��ȣ"                      >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/hosts ]
  then
    ls -alL /etc/hosts                                                                         >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result=`perm /etc/hosts | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   					                 >> $HOSTNAME.linux.result.txt 2>&1
   else
    echo "�� /etc/hosts ������ �����ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result="Null:Null"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0613 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0614 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           C �����Ϸ� ���� �� ���� ���� ����            ####################"
echo "####################           C �����Ϸ� ���� �� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �����Ϸ��� others ��������� ���� �� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
DIR_temp="/usr/bin/cc /usr/bin/gcc /usr/ucb/cc /usr/ccs/bin/cc /opt/ansic/bin/cc /usr/vac/bin/cc /usr/local/bin/gcc"
	for dir in $DIR_temp; do
		if [ -f $dir ]
		then
			echo " "                                                                                >> $HOSTNAME.linux.result.txt 2>&1
			echo "�� $dir ���� ����"																>> $HOSTNAME.linux.result.txt 2>&1
			ls -alL $dir																		>> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                >> $HOSTNAME.linux.result.txt 2>&1
		else
			echo "�� $dir �������� ����."																>> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                >> $HOSTNAME.linux.result.txt 2>&1
		fi
	done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0614 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0615 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           /etc/(x)inetd.conf ���� ������ �� ���� ����            ####################"
echo "####################           /etc/(x)inetd.conf ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/(x)inetd.conf ���� �� /etc/xinetd.d/ ���� ��� ������ �����ڰ� root �̰�, ������ 600 �̸� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/xinetd.conf ����"                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/xinetd.conf ]
then
	ls -alL /etc/xinetd.conf                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	flag1=`perm /etc/xinetd.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/etc/xinetd.conf ������ �����ϴ�."                                                     >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/xinetd.d/ ����"                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -d /etc/xinetd.d ]
then
	ls -al /etc/xinetd.d/*                                                                  	   > temp615.txt
	cat temp615.txt 																																						 >> $HOSTNAME.linux.result.txt 2>&1
	
	for file in `awk -F" " '{ print $9 }' temp615.txt`
	do
		if [ `perm $file | awk -F" " '{ print substr($1, 2, 3) }' | sed -e 's/^ *//g' -e 's/ *$//g'` -gt 600 -o `ls -l $file | awk -F" " '{print $3}'` != "root" ]
		then
			flag2="F"
			break
		else
			flag2="O"
		fi	
	done
	
else
	echo "/etc/xinetd.d ���͸��� �����ϴ�."                                                    >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/inetd.conf ����"                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/inetd.conf ]
then
	ls -alL /etc/inetd.conf                                                                      >> $HOSTNAME.linux.result.txt 2>&1
	flag3=`perm /etc/inetd.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/etc/inetd.conf ������ �����ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
	flag3="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag3":"$flag2                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0615 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf temp615.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0616 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           /etc/syslog.conf ���� ������ �� ���� ����            ####################"
echo "####################           /etc/syslog.conf ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/(r)syslog.conf ������ �����ڰ� root�̰� ������ 644 �̸� ��ȣ"               >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
    ls -alL /etc/syslog.conf                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result=`perm /etc/syslog.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   			               >> $HOSTNAME.linux.result.txt 2>&1
elif [ -f /etc/rsyslog.conf ]
then
	ls -alL /etc/rsyslog.conf                                                           	       >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                          	         >> $HOSTNAME.linux.result.txt 2>&1
  echo Result=`perm /etc/rsyslog.conf | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`   			    	           >> $HOSTNAME.linux.result.txt 2>&1
else
    echo "�� /etc/(r)syslog.conf ������ �����ϴ�."                                             >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result="0"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0616 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0617 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           SUID, SGID, Sticky bit ���� ���� ����            ####################"
echo "####################           SUID, SGID, Sticky bit ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ���ʿ��� SUID/SGID ������ �������� ���� ��� ��ȣ"                               >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
find /usr -xdev -user root -type f \( -perm -04000 -o -perm -02000 \) -exec ls -al  {}  \;     > 6.17.txt
find /sbin -xdev -user root -type f \( -perm -04000 -o -perm -02000 \) -exec ls -al  {}  \;    >> 6.17.txt
if [ -s 6.17.txt ]
then
	linecount=`cat 6.17.txt | wc -l`
	if [ $linecount -gt 10 ]
  then
  	echo "SUID,SGID,Sticky bit ���� ���� (���� 10��)"                                          >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	  head -10 6.17.txt                                                                          >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  	echo " �� �� "$linecount"�� ���� ���� (��ü ����� ��ũ��Ʈ ��� ���� Ȯ��)"               >> $HOSTNAME.linux.result.txt 2>&1
  	echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=$linecount                                                               	       >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
	else
  	echo "SUID,SGID,Sticky bit ���� ����"                                                      >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	  cat 6.17.txt                                                                               >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  	echo " �� "$linecount"�� ���� ����"                                                        >> $HOSTNAME.linux.result.txt 2>&1
  	echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=$linecount                                                               	       >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  fi
else
	echo "�� SUID/SGID�� ������ ������ �߰ߵ��� �ʾҽ��ϴ�."                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " " 		                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=0                                                   				            	       >> $HOSTNAME.linux.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0617 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0618 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Ȩ���丮 ������ �� ���� ����            ####################"
echo "####################           Ȩ���丮 ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: Ȩ ���͸��� �����ڰ� /etc/passwd ���� ��ϵ� Ȩ ���͸� ����ڿ� ��ġ�ϰ�,"   >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : Ȩ ���͸��� Ÿ����� ��������� ������ ��ȣ"                                 >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����� Ȩ ���͸�"                                                                   >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
for dir in $HOMEDIRS
do
	if [ -d $dir ]
	then
		ls -dal $dir | grep '\d.........'                                                          >> $HOSTNAME.linux.result.txt 2>&1
	fi
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0618 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0619 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           world writable ���� ����            ####################"
echo "####################           world writable ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ���ʿ��� ������ �ο��� world writable ������ �������� ���� ��� ��ȣ"            >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ���� �� ���Ⱑ�� ���� ���� Ȯ���Ͽ� �����ϴ� ��� ��ȣ"  						   >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
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
  	echo "World Writable ���� (���� 10��)"                                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	  head -10 world-writable.txt                                                                >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  	echo " �� �� "$linecount"�� ���� ���� (��ü ����� ��ũ��Ʈ ��� ����  Ȯ��)"              >> $HOSTNAME.linux.result.txt 2>&1
		echo " " 		                                                                               >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=$linecount                                                               	     >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo "0619 END"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
   else
    echo "World Writable ����"                                                                 >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	  cat world-writable.txt                                                                     >> $HOSTNAME.linux.result.txt 2>&1
    echo " �� "$linecount"�� ���� ����"                                                        >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=$linecount                                                               	     >> $HOSTNAME.linux.result.txt 2>&1
		echo " " 		                                                                               >> $HOSTNAME.linux.result.txt 2>&1
		echo "0619 END"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
    echo "�� World Writable ������ �ο��� ������ �߰ߵ��� �ʾҽ��ϴ�."                         >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result=0 				                                                              	     >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo "0619 END"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0620 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Crontab �������� ���� ���� ����            ####################"
echo "####################           Crontab �������� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: crontab �������Ͽ� others ���� ������ ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
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
				echo "�� "$file" ���� Ȯ��"             					                            >> $HOSTNAME.linux.result.txt 2>&1
				ls -alL $file			                      		                             >> $HOSTNAME.linux.result.txt 2>&1
			fi
		done
	else	
		echo "crontab ���������� �������� ����"       		 			                            >> $HOSTNAME.linux.result.txt 2>&1
	fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0620 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "



echo "0621 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###           �����, �ý��� �������� �� ȯ������ ������ �� ���� ����            ###"
echo "###          �����, �ý��� �������� �� ȯ������ ������ �� ���� ����            ###" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: Ȩ ���͸� ȯ�溯�� ���� �����ڰ� root �Ǵ� �ش� �������� �����Ǿ� �ְ�"        >> $HOSTNAME.linux.result.txt 2>&1
echo "��     : Ȩ���͸� ȯ�溯�� ���Ͽ� ������ �̿ܿ� ���� ������ ���ŵǾ� ������ ��ȣ"       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� Ȩ���͸� ȯ�溯�� ����"                                                             >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

for file in $FILES
do
  FILE=/$file
  if [ -f $FILE ]
  then
    ls -alL $FILE                                                                              >> $HOSTNAME.linux.result.txt 2>&1
  fi
done

for dir in $HOMEDIRS
do
  for file in $FILES
  do
    FILE=$dir/$file
    if [ -f $FILE ]
    then
      ls -alL $FILE                                                                            >> $HOSTNAME.linux.result.txt 2>&1
    fi
  done
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0621 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0622 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           /etc/services ���� ������ �� ���� ����            ####################"
echo "####################           /etc/services ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/services ������ �����ڰ� root�̰� ������ 644 �̸� ��ȣ"                     >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/services ]
  then
    ls -alL /etc/services                                                                      >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result=`perm /etc/services | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`  		 			               >> $HOSTNAME.linux.result.txt 2>&1
   else
    echo "�� /etc/services ������ �����ϴ�."                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
    echo Result="Null:Null"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0622 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0623 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           xterm ���� ���� ���� ����            ####################"
echo "####################           xterm ���� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ���ϱ����� 750���Ϸ� �����Ǿ� �ְ�, �����ڰ� root�� ������ ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /usr/bin/xterm ]
then
	ls -alL /usr/bin/xterm     																>> $HOSTNAME.linux.result.txt 2>&1
  
if [ `ls -alL /usr/bin/xterm | grep "...-------" | wc -l` -eq 1 ]
then
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="success"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
else
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="fail"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
fi
else
	echo "�� /usr/bin/xterm ������ �������� ����"                                              >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="success"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0623 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0624 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           hosts.lpd ���� ������ �� ���� ����            ####################"
echo "####################           hosts.lpd ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/hosts.lpd ������ �����ڰ� root �̰�, ������ 600 �̸� ��ȣ"                   >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/hosts.lpd ]
then
	ls -alL /etc/hosts.lpd                                                                        >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                         	        	 >> $HOSTNAME.linux.result.txt 2>&1
  echo Result=`perm /etc/hosts.lpd | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`  			 		   >> $HOSTNAME.linux.result.txt 2>&1
 else
  echo "�� /etc/hosts.lpd ������ �����ϴ�. (��ȣ)"                                              >> $HOSTNAME.linux.result.txt 2>&1
  echo " "                                                                         	        	 >> $HOSTNAME.linux.result.txt 2>&1
  echo Result="Null:Null"																	 >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0624 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0625 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           at �������� ���� ������ �� ���� ����            ####################"
echo "####################           at �������� ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: at.allow �Ǵ� at.deny ���� ������ 640 �����̰� �����ڰ� root�� ��� ��ȣ"        >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� at.allow ���� ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "---------------- --------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/at.allow ]
then
	ls -alL /etc/at.allow                                                                        >> $HOSTNAME.linux.result.txt 2>&1
	flag1=`perm /etc/at.allow | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/etc/at.allow ������ �����ϴ�."                                                        >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� at.deny ���� ���� Ȯ��"                                                               >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/at.deny ]
then
	ls -alL /etc/at.deny                                                                         >> $HOSTNAME.linux.result.txt 2>&1
	flag2=`perm /etc/at.deny | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/etc/at.deny ������ �����ϴ�."                                                         >> $HOSTNAME.linux.result.txt 2>&1
	flag2="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0625 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0626 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ������ �ý��� �α����� ���� ����            ####################"
echo "####################           ������ �ý��� �α����� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ���͸� �� �α� ���ϵ��� ������ 644 ������ �� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
DIR_LOG="/var/log"
for ldir in $DIR_LOG; do
	echo $ldir"/* Ȯ��"                                                              		>> $HOSTNAME.linux.result.txt 2>&1
	echo "-------------------------------------------"  										>> $HOSTNAME.linux.result.txt 2>&1
	ls -aldL $ldir/*																			>> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0626 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0627 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "##################                   SU ��� ��밡�� �׷� ���� �̺�               ##################"
echo "##################                   SU ��� ��밡�� �׷� ���� �̺�               ##################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����1: /etc/pam.d/su ���� ������ �Ʒ��� ���� ��� ��ȣ"                                >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����2: �Ʒ� ������ ���ų�, �ּ� ó���� �Ǿ� ���� ��� ��ȣ" 								   >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����3: su ��� ������ ������ 4750 �̰� Ư�� �׷츸 ��� �� �� �ֵ��� ���� �Ǿ������� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "��      : (auth  required  /lib/security/pam_wheel.so debug group=wheel) �Ǵ�"            >> $HOSTNAME.linux.result.txt 2>&1
echo "��      : (auth  required  /lib/security/\$ISA/pam_wheel.so use_uid)"                     >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/pam.d/su ���� ����"                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/pam.d/su ]
then
	if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | wc -l` -eq 0 ]
	then
		echo "pam_wheel.so ���� ������ �����ϴ�."                                                  >> $HOSTNAME.linux.result.txt 2>&1
	else
		cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust'                                  >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/pam.d/su ������ ã�� �� �����ϴ�."                                                >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� su ���ϱ���"                                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `which su | grep -v 'no ' | wc -l` -eq 0 ]
then
	echo "su ��� ������ ã�� �� �����ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
else
	sucommand=`which su`;
	ls -alL $sucommand                                                                           >> $HOSTNAME.linux.result.txt 2>&1
	sugroup=`ls -alL $sucommand | awk '{print $4}'`;
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� su ��ɱ׷�"                                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/pam.d/su ]
then
	if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | grep 'group' | awk -F"group=" '{print $2}' | awk -F" " '{print $1}' | wc -l` -gt 0 ]
	then
		pamsugroup=`cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | grep 'group' | awk -F"group=" '{print $2}' | awk -F" " '{print $1}'`
		echo "- su��� �׷�(PAM���): `egrep "^$pamsugroup" /etc/group`"                         >> $HOSTNAME.linux.result.txt 2>&1
	else
		if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | egrep -v 'trust|#' | wc -l` -gt 0 ]
		then
			echo "- su��� �׷�(PAM���): `egrep "^wheel" /etc/group`"                             >> $HOSTNAME.linux.result.txt 2>&1
		fi
	fi
fi
echo "- su��� �׷�(�������): `egrep "^$sugroup" /etc/group`"                               >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"      			                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0627 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "    


echo "0628 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Cron ���� ������ �� ���� ����            ####################"
echo "####################           Cron ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: cron.allow �Ǵ� cron.deny ���� ������ 640 �����̰� �����ڰ� root�� ��� ��ȣ"    >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� cron.allow ���� ���� Ȯ��"                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/cron.allow ]
then
	ls -alL /etc/cron.allow                                                                      >> $HOSTNAME.linux.result.txt 2>&1
	flag1=`perm /etc/cron.allow | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/etc/cron.allow ������ �����ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� cron.deny ���� ���� Ȯ��"                                                             >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/cron.deny ]
then
	ls -alL /etc/cron.deny                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	flag2=`perm /etc/cron.deny | awk -F" " '{print $4 ":" substr($1, 2, 3) }'`
else
	echo "/etc/cron.deny ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	flag2="Null:Null"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0628 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0629 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           cron ���� �� ���� ������            ####################"
echo "####################           cron ���� �� ���� ������            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: cron.allow, cron.deny ���� ���ο� ������ �����ϴ� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "     : cron.allow, cron.deny ���� �� �� ���� ���(root�� cron ��� ����)��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	FILE_CRONUSER="/etc/cron.d/cron.allow /etc/cron.d/cron.deny /etc/cron.allow /etc/cron.deny"
	for hfile in $FILE_CRONUSER
	do
	if [ -f $hfile ]; then
		ls -alL $hfile                                                                           >> $HOSTNAME.linux.result.txt 2>&1
		echo "�� "$hfile" ���� �ϴ� ���� Ȯ��(������ ���� ��� ����)"                                          			  >> $HOSTNAME.linux.result.txt 2>&1
		cat $hfile  |  sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"               >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	else 
		echo "�� "$hfile" ������ �������� ����"                                          						   >> $HOSTNAME.linux.result.txt 2>&1	
		echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi
	done
	
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0629 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0630 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ftpusers ���� ������ �� ���� ����            ####################"
echo "####################           ftpusers ���� ������ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ftpusers ������ �����ڰ� root�̰�, ������ 640 �̸��̸� ��ȣ"                     >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : [FTP ������ ����Ǵ� ����]"                                                    >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (1)ftpd: /etc/ftpusers �Ǵ� /etc/ftpd/ftpusers"                                >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (2)proftpd: /etc/ftpusers �Ǵ� /etc/ftpd/ftpusers"                             >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (3)vsftpd: /etc/vsftpd/ftpusers, /etc/vsftpd/user_list (�Ǵ� /etc/vsftpd.ftpusers, /etc/vsftpd.user_list)" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "(1)/etc/service����: ��Ʈ ���� X (Default 21�� ��Ʈ)"                                  >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(2)VsFTP ��Ʈ: ��Ʈ ���� X (Default 21�� ��Ʈ �����)"                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(2)VsFTP ��Ʈ: VsFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                        >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}'    >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(3)ProFTP ��Ʈ: ��Ʈ ���� X (/etc/service ���Ͽ� ������ ��Ʈ�� �����)"              >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(3)ProFTP ��Ʈ: ProFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
################# /etc/services ���Ͽ��� ��Ʈ Ȯ�� #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                               >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd ���� ��Ʈ Ȯ�� ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd ���� ��Ʈ Ȯ�� ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� ftpusers ���� ������ �� ���� Ȯ��"                                                    >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
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
		cat ftpusers.txt | grep -v "^ *$"                                                            >> $HOSTNAME.linux.result.txt 2>&1
		
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
		echo "ftpusers ������ ã�� �� �����ϴ�. (FTP ���� ���� �� ���)"                           >> $HOSTNAME.linux.result.txt 2>&1
		flag2="F"
	fi

else
	echo "�� FTP Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi


echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0630 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        7. ���� ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0701 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���ʿ��� SMTP ���� ���� ����            ####################"
echo "####################           ���ʿ��� SMTP ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: SMTP�� ���� ������ �ʰų�, ������ ��� ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� sendmail ���μ��� Ȯ��"                                    					                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Enabled"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� Sendmail Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"   		       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Enabled"
	else
		echo "�� Sendmail Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Disabled"
	fi
else
	echo "���� ��Ʈ Ȯ�� �Ұ�" 				                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "0701 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0702 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           SMTP ���� expn/vrfy ��ɾ� ���� ���� ����            ####################"
echo "####################           SMTP ���� expn/vrfy ��ɾ� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: SMTP ���񽺸� ������� �ʰų� noexpn, novrfy �ɼ��� �����Ǿ� ���� ��� ��ȣ"     >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� sendmail ���μ��� Ȯ��"                                    					                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/sendmail.cf ������ �ɼ� Ȯ��"                                                    >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	  then
	    grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions                                      >> $HOSTNAME.linux.result.txt 2>&1
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
	  echo "/etc/sendmail.cf ������ �����ϴ�."                                                   >> $HOSTNAME.linux.result.txt 2>&1
	  flag2="Null"
	fi
else
	echo "�� Sendmail Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "[����]"                                                                              	   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "/etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     	 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                        		 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� Sendmail Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "���� ��Ʈ Ȯ�� �Ұ�" 				                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0702 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 



echo "0703 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ����� ������ Sendmail ��� ����            ####################"
echo "####################           ����� ������ Sendmail ��� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: sendmail ������ ���������� �����ϰ�, ��ġ�� ���� ���(8.15.2 �̻�) ��ȣ"                                            >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� sendmail ���μ��� Ȯ��"                                    					                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                  	 >> $HOSTNAME.linux.result.txt 2>&1
	
	echo "�� sendmail ����Ȯ��"                                                                  >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	   then
	     grep -v '^ *#' /etc/mail/sendmail.cf | grep DZ                                          >> $HOSTNAME.linux.result.txt 2>&1
	   else
	     echo "/etc/mail/sendmail.cf ������ �����ϴ�."                                           >> $HOSTNAME.linux.result.txt 2>&1
	fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� Sendmail Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "[����]"                                                                              	   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "/etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     	 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                        		 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� Sendmail Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "���� ��Ʈ Ȯ�� �Ұ�" 				                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$flag1                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0703 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0704 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Sendmail ���� �ź� ���� ��� �̼���            ####################"
echo "####################           Sendmail ���� �ź� ���� ��� �̼���            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: sendmail.cf ���ο� ���� �Ķ���͵��� �����ϰ� �����Ǿ� ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� sendmail ���μ��� Ȯ��"                                    					                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.linux.result.txt 2>&1
	echo " "         >> $HOSTNAME.linux.result.txt 2>&1

	echo "�� /etc/mail/sendmail.cf ���� Ȯ��"                                                  >> $HOSTNAME.linux.result.txt 2>&1
  echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
  if [ -f /etc/mail/sendmail.cf ]
  then
    if [ `cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#" | wc -l` -eq 5 ]
    then
      cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#"        >> $HOSTNAME.linux.result.txt 2>&1
      flag2="M/T"
    else
      cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"        >> $HOSTNAME.linux.result.txt 2>&1
      echo "�� �Ķ���� ������ ����Ǿ� ���� ����"                                          >> $HOSTNAME.linux.result.txt 2>&1
      flag2="Fail"
    fi
  else
    echo "�� /etc/mail/sendmail.cf ������ �������� ����"                                          >> $HOSTNAME.linux.result.txt 2>&1
  fi
  
  echo " "         >> $HOSTNAME.linux.result.txt 2>&1
  echo "�� /etc/sendmail.cf ���� Ȯ��"                                                  >> $HOSTNAME.linux.result.txt 2>&1
  echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
  if [ -f /etc/sendmail.cf ]
  then
    if [ `cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#" | wc -l` -eq 5 ]
    then
      cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#"        >> $HOSTNAME.linux.result.txt 2>&1
      flag3="M/T"
    else
      cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"        >> $HOSTNAME.linux.result.txt 2>&1
      echo "�� �Ķ���� ������ �ȵǾ� ����"                                          >> $HOSTNAME.linux.result.txt 2>&1
      flag3="Fail"
    fi
  else
    echo "�� /etc/sendmail.cf ������ �������� ����"                                          >> $HOSTNAME.linux.result.txt 2>&1
  fi
	
	
else
	echo "�� Sendmail Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "[����]"                                                                              	   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "/etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     	 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                        		 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� Sendmail Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "���� ��Ʈ Ȯ�� �Ұ�" 				                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$flag1":"$flag2":"$flag3														         		       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0704 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0705 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���� ���� ������ ����            ####################"
echo "####################           ���� ���� ������ ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: SMTP ���񽺸� ������� �ʰų� ������ ������ �����Ǿ� ���� ��� ��ȣ"             >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (R$* $#error $@ 5.7.1 $: "550 Relaying denied" �ش� ������ �ּ��� ���ŵǾ� ������ ��ȣ)" >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (sendmail ���� 8.9 �̻��� ��� ����Ʈ�� ���� ���� ������ ���� ������ �Ǿ� �����Ƿ� ��ȣ)" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� sendmail ���μ��� Ȯ��"                                    					                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	ps -ef | grep sendmail | grep -v grep														 >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Enabled"
	echo " "                                                                                  	 >> $HOSTNAME.linux.result.txt 2>&1
	
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/mail/sendmail.cf ������ �ɼ� Ȯ��"                                             >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	  then
	    cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied"                         >> $HOSTNAME.linux.result.txt 2>&1
	    flag2=`cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied" | grep -v ^# | wc -l`
	  else
	    echo "/etc/mail/sendmail.cf ������ �����ϴ�."                                            >> $HOSTNAME.linux.result.txt 2>&1
	    flag2="Null"
	fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� sendmail ����Ȯ��"                                                                    >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	   then
	     grep -v '^ *#' /etc/mail/sendmail.cf | grep DZ                                          >> $HOSTNAME.linux.result.txt 2>&1
	   else
	     echo "/etc/mail/sendmail.cf ������ �����ϴ�."                                           >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "�� Sendmail Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "[����]"                                                                              	   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "/etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                    		 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                       	   >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� Sendmail Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "���� ��Ʈ Ȯ�� �Ұ�" 				                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0705 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 

echo "0706 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �Ϲݻ������ Sendmail ���� ����            ####################"
echo "####################           �Ϲݻ������ Sendmail ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: SMTP ���񽺸� ������� �ʰų� ������ ������ �����Ǿ� ���� ��� ��ȣ"             >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (restrictqrun �ɼ��� �����Ǿ� ���� ��� ��ȣ)"                                 >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� sendmail ���μ��� Ȯ��"                                    					                 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	ps -ef | grep sendmail | grep -v grep														>> $HOSTNAME.linux.result.txt 2>&1
	flag1="Enabled"
	echo " "                                                                                  	 >> $HOSTNAME.linux.result.txt 2>&1
	
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/mail/sendmail.cf ������ �ɼ� Ȯ��"                                             >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	  then
	    grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions                               >> $HOSTNAME.linux.result.txt 2>&1
	    flag2=`grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions | grep restrictqrun | wc -l`
	  else
	    echo "/etc/mail/sendmail.cf ������ �����ϴ�."                                            >> $HOSTNAME.linux.result.txt 2>&1
	    flag2="Null"
	fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� Sendmail Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "[����]"                                                                              	   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "/etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                    		 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                        		 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� Sendmail Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "���� ��Ʈ Ȯ�� �Ұ�" 				                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0706 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0707 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ftpusers ���� �� �ý��� ���� ���� ����            ####################"
echo "####################           ftpusers ���� �� �ý��� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ftp �� ������� �ʰų�, ftp ���� ftpusers ���Ͽ� root�� ���� ��� ��ȣ"        >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : [FTP ������ ����Ǵ� ����]"                                                    >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (1)ftpd: /etc/ftpusers �Ǵ� /etc/ftpd/ftpusers"                                >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (2)proftpd: /etc/ftpusers �Ǵ� /etc/ftpd/ftpusers"                             >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (3)vsftpd: /etc/vsftpd/ftpusers, /etc/vsftpd/user_list (�Ǵ� /etc/vsftpd.ftpusers, /etc/vsftpd.user_list)" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "(1)/etc/service����: ��Ʈ ���� X (Default 21�� ��Ʈ)"                                  >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(2)VsFTP ��Ʈ: ��Ʈ ���� X (Default 21�� ��Ʈ �����)"                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(2)VsFTP ��Ʈ: VsFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                        >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}'    >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(3)ProFTP ��Ʈ: ��Ʈ ���� X (/etc/service ���Ͽ� ������ ��Ʈ�� �����)"              >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(3)ProFTP ��Ʈ: ProFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
################# /etc/services ���Ͽ��� ��Ʈ Ȯ�� #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                               >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd ���� ��Ʈ Ȯ�� ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd ���� ��Ʈ Ȯ�� ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� ftpusers ���� ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                       > ftpusers.txt
	ServiceDIR="/etc/ftpusers /etc/ftpd/ftpusers /etc/vsftpd/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd/user_list /etc/vsftpd.user_list"
	for file in $ServiceDIR
	do
		if [ -f $file ]
		then
			if [ `cat $file | grep "root" | grep -v "^#" | wc -l` -gt 0 ]
			then
				echo "�� $file ���ϳ���: `cat $file | grep "root" | grep -v "^#"` ������ ��ϵǾ� ����."  >> ftpusers.txt
				echo "check"                                                                             > check.txt
				flag2=`cat $file | grep "root" | grep -v "^#"`
			else
				echo "�� $file ���ϳ���: root ������ ��ϵǾ� ���� ����."                                 >> ftpusers.txt
				echo "check"                                                                             > check.txt
				flag2="F"
			fi
		fi
	done
	
	if [ -f check.txt ]
	then
		cat ftpusers.txt | grep -v "^ *$"                                                            >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "ftpusers ������ ã�� �� �����ϴ�. (FTP ���� ���� �� ���)"                           >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Null"
	fi

else
	echo "�� FTP Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1	
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0707 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
rm -rf check.txt
rm -rf ftpusers.txt
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0708 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           .netrc ���� �� ȣ��Ʈ ���� ����            ####################"
echo "####################           .netrc ���� �� ȣ��Ʈ ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� : .netrc ���� ���ο� ���̵�, �н����� �� �ΰ��� ������ ������ ���� ������ 600�� ��� ��ȣ"                 >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
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
          echo " "                                                                               >> $HOSTNAME.linux.result.txt 2>&1
          echo "�� $dir Ȩ���͸��� .netrc ���� ���� �� ���� �� Ȯ��"            			                   >> $HOSTNAME.linux.result.txt 2>&1
		  ls -aldL $dir/$hfile                                                                     >> $HOSTNAME.linux.result.txt 2>&1
          echo "----------------------------------------"                                          >> $HOSTNAME.linux.result.txt 2>&1
          cat $dir/$hfile                                                                          >> $HOSTNAME.linux.result.txt 2>&1
		  echo " "                                                                               >> $HOSTNAME.linux.result.txt 2>&1
        else
          echo "�� dir/$hfile ������ �������� ����"                                         >> $HOSTNAME.linux.result.txt 2>&1
        fi
      done                                                                                       
    else
      echo "�� $dir Ȩ���͸��� .netrc ������ �������� ����"                               >> $HOSTNAME.linux.result.txt 2>&1
    fi
  else
    echo "�� $dir Ȩ���͸��� �������� ����"                                             >> $HOSTNAME.linux.result.txt 2>&1
  fi
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0708 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0709 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Anonymous FTP ��Ȱ��ȭ            ####################"
echo "####################           Anonymous FTP ��Ȱ��ȭ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: Anonymous FTP (�͸� ftp)�� ��Ȱ��ȭ ������ ��� ��ȣ"                            >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (1)ftpd�� ����� ���: /etc/passwd ���ϳ� FTP �Ǵ� anonymous ������ �������� ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (2)proftpd�� ����� ���: /etc/passwd ���ϳ� FTP ������ �������� ������ ��ȣ"  >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (3)vsftpd�� ����� ���: vsftpd.conf ���Ͽ��� anonymous_enable=NO �����̸� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "(1)/etc/service����: ��Ʈ ���� X (Default 21�� ��Ʈ)"                                  >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}'    >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(2)ProFTP ��Ʈ: ��Ʈ ���� X (/etc/service ���Ͽ� ������ ��Ʈ�� �����)"              >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(2)ProFTP ��Ʈ: ProFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(3)VsFTP ��Ʈ: ��Ʈ ���� X (Default 21�� ��Ʈ �����)"                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(3)VsFTP ��Ʈ: VsFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                        >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
################# /etc/services ���Ͽ��� ��Ʈ Ȯ�� #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd ���� ��Ʈ Ȯ�� ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd ���� ��Ʈ Ȯ�� ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� Anonymous FTP ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	if [ -s vsftpd.txt ]
	then
		cat $vsfile | grep -i "anonymous_enable" | awk '{print "�� VsFTP ����: " $0}'                 >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat $vsfile | grep -i "anonymous_enable" | grep -i "YES" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		if [ `cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l` -gt 0 ]
		then
			echo "�� ProFTP, �⺻FTP ����:"                                                               >> $HOSTNAME.linux.result.txt 2>&1
			cat /etc/passwd | egrep "^ftp:|^anonymous:"                                                  >> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
			flag2=`cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'` 
			echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		else
			echo "�� ProFTP, �⺻FTP ����: /etc/passwd ���Ͽ� ftp �Ǵ� anonymous ������ �����ϴ�."        >> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
			flag2=`cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
		fi	
	fi
else
	echo "�� FTP Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0709 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0710 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           NFS ���� ��Ȱ��ȭ            ####################"
echo "####################           NFS ���� ��Ȱ��ȭ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ���ʿ��� NFS ���� ���� ������ ���ŵǾ� �ִ� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� NFS Server Daemon(nfsd)Ȯ��"                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
 then
   ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep"                >> $HOSTNAME.linux.result.txt 2>&1
   flag1="Enabled_Server"
 else
   echo "�� NFS Service Disable"                                                               >> $HOSTNAME.linux.result.txt 2>&1
   flag1="Disabled_Server"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� NFS Client Daemon(statd,lockd)Ȯ��"                                                   >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd|kblockd" | wc -l` -gt 0 ] 
  then
    ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd|kblockd"            >> $HOSTNAME.linux.result.txt 2>&1
    flag2="Enabled_Client"
  else
    echo "�� NFS Client(statd,lockd) Disable"                                                  >> $HOSTNAME.linux.result.txt 2>&1
    flag2="Disabled_Client"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0710 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0711 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���ʿ��� RPC���� ���� ����            ####################"
echo "####################           ���ʿ��� RPC���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ���ʿ��� rpc ���� ���񽺰� �������� ������ ��ȣ"                                 >> $HOSTNAME.linux.result.txt 2>&1
echo "(rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd)" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd"

echo "�� ���ʿ��� RPC ���� ���� Ȯ��"                                                        >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
ps -ef | egrep $SERVICE_INETD | grep -v grep																									 >> $HOSTNAME.linux.result.txt 2>&1
	echo "��� ���� �������� ������ ��ȣ."                                         						   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=`ps -ef | egrep $SERVICE_INETD | grep -v grep | wc -l`                           >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0711 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0712 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           automountd ����            ####################"
echo "####################           automountd ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: automountd ���񽺰� �������� ���� ��� ��ȣ"                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� Automountd Daemon Ȯ��"                                                               >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi" | wc -l` -gt 0 ] 
 then
   ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi"              >> $HOSTNAME.linux.result.txt 2>&1
   flag="Enabled"
 else
   echo "�� Automountd Daemon Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
   flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0712 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0713 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           tftp, talk ���� ��Ȱ��ȭ            ####################"
echo "####################           tftp, talk ���� ��Ȱ��ȭ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: tftp, talk, ntalk ���񽺰� ���� ������ ���� ��쿡 ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp"                    >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp"                    >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "  " $2}' | grep "udp"                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > 7.13.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > 7.13.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > 7.13.txt
	fi
fi

if [ -f 7.13.txt ]
then
	rm -rf 7.13.txt
	flag="Enabled"
else
	echo "�� tftp, talk, ntalk Service Disable"                                                  >> $HOSTNAME.linux.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0713 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 

echo "0714 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ������ ��й�ȣ �� ���� ����            ####################"
echo "####################           ������ ��й�ȣ �� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �������� ��й�ȣ�� ��� �����Ǿ� ���� ��� ��ȣ"                       						   >> $HOSTNAME.linux.result.txt 2>&1 
echo "		: �н����� ���� !! �� ��� �н����� �̼��� "                       						   >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "/etc/shadow ���� (Login name, �н����� ��)"                                              	>> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------"                                >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/shadow | awk -F: '{print $1"\t\t"$2}'  												   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"          	                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0714 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                      >> $HOSTNAME.linux.result.txt 2>&1

echo "0715 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Finger ���� ��Ȱ��ȭ            ####################"
echo "####################           Finger ���� ��Ȱ��ȭ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: Finger ���񽺰� ��Ȱ��ȭ �Ǿ� ���� ��� ��ȣ"                                    >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "�� Finger Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	else
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
	fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=`netstat -na | grep ":$port " | grep -i "^tcp" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`                         >> $HOSTNAME.linux.result.txt 2>&1
else
	if [ `netstat -na | grep ":79 " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "�� Finger Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	else
		netstat -na | grep ":79 " | grep -i "^tcp"                                                >> $HOSTNAME.linux.result.txt 2>&1
	fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=`netstat -na | grep ":79 " | grep -i "^tcp" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`                		         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0715 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0716 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���ʿ��� DMI ���� ���� ����            ####################"
echo "####################           ���ʿ��� DMI ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: dmi ���񽺰� �������� ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "LINUX�� �ش���� ����"                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0716 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0717 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           r �迭 ���� ��Ȱ��ȭ            ####################"
echo "####################           r �迭 ���� ��Ȱ��ȭ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: r-commands ���񽺸� ������� ������ ��ȣ"                                        >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��(���� ������ ��� �� ����)"                             >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ -f rcommand.txt ]
then
	rm -rf rcommand.txt
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="Enabled"										 																									   >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� r-commands Service Disable"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="Disabled"																																		   >> $HOSTNAME.linux.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0717 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0718 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           DoS ���ݿ� ����� ���� ��Ȱ��ȭ            ####################"
echo "####################           DoS ���ݿ� ����� ���� ��Ȱ��ȭ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: DoS ���ݿ� ����� echo , discard , daytime , chargen ���񽺸� ������� �ʾ��� ��� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "tcp"                 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "udp"                 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp"                 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp"                 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp"                 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp"                 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp"                 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp"                 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��(���� ������ ��� �� ����)"                             >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ -f unnecessary.txt ]
then
	rm -rf unnecessary.txt
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="Enabled"										 																									   >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "���ʿ��� ���񽺰� �����ϰ� ���� �ʽ��ϴ�.(echo, discard, daytime, chargen)"            >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="Disabled"										 																									   >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0718 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0719 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           FTP ���� ���� ����            ####################"
echo "####################           FTP ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ftp ���񽺰� ��Ȱ��ȭ �Ǿ� ���� ��� ��ȣ"                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "(1)/etc/service����: ��Ʈ ���� X (Default 21�� ��Ʈ)"                                  >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(2)VsFTP ��Ʈ: ��Ʈ ���� X (Default 21�� ��Ʈ �����)"                               >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(2)VsFTP ��Ʈ: VsFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                        >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}'    >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "(3)ProFTP ��Ʈ: ��Ʈ ���� X (/etc/service ���Ͽ� ������ ��Ʈ�� �����)"              >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "(3)ProFTP ��Ʈ: ProFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�."                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
################# /etc/services ���Ͽ��� ��Ʈ Ȯ�� #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   > ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                               >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     > ftpenable.txt
fi
################# vsftpd ���� ��Ʈ Ȯ�� ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi
################# proftpd ���� ��Ʈ Ȯ�� ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"
else
	echo "�� FTP Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1                                                                           >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0719 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0720 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���ʿ��� Tmax WebtoB ���� ���� ����            ####################"
echo "####################           ���ʿ��� Tmax WebtoB ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: WebToB �������� �������� ���� �� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���μ��� ���� ���� Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	Tempps=`echo "wsm[^a-z\.].*webtob|wsm[^a-z\.].*webtob|wsm|webtob" | sed "s/|/ /g"`
	temp_webtob1=0
	for ps in $Tempps
	do
		resTemp=`ps -ef | egrep "[^a-z]$ps[^a-z\.]|[^a-z]$ps$" | grep -v "grep" | sort | uniq`
		if [ "$resTemp" ]; then
			echo -e "$resTemp"                                             							>> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
			$temp_webtob1=1
		fi
	done
	
	if [ $temp_webtob1 -eq 0 ]
	then 
		echo "WebtoB�� ���������� ����"                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi
	
echo "�� inetd ���� Ȯ��"                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	temp_webtob2=0
	Tempinetd=`echo "wsm|webtob" | sed "s/|/ /g"`
	for inetd in $Tempinetd
	do
		if [ -f "/etc/xinetd.d/$inetd" ]; then
			resTemp=`cat "/etc/xinetd.d/$inetd" | egrep -v "^#" | egrep "disable" | egrep "no" | egrep -v "^$"`
			if [ "$resTemp" ]; then
				echo -e "$resTemp" | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"      >> $HOSTNAME.linux.result.txt 2>&1
				echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
				$temp_webtob2=1
			fi
		fi
		
		if [ -f /etc/inetd.conf ]; then
			resTemp=`cat /etc/inetd.conf | egrep -v "^#" | egrep -i "^$inetd[d]?[^a-z]|[^a-z]$inetd[d]?[^a-z]" | egrep -v "^$"`
			if [ "$resTemp" ]; then
				echo -e "$resTemp" | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"          >> $HOSTNAME.linux.result.txt 2>&1
				echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
				$temp_webtob2=1
			fi
		fi
	done
	
	if [ $temp_webtob2 -eq 0 ]
	then 
		echo "WebtoB ������ �������� ����"                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi
echo Result="M/T"										 									 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0720 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0721 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache ���丮 ������ ����            ####################"
echo "####################           Apache ���丮 ������ ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: httpd.conf ������ Directory �κ��� Options �����ڿ� Indexes�� �����Ǿ� ���� ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	echo "�� httpd ���� ���� Ȯ��"                                                         		 >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	ps -ef | grep "httpd" | grep -v "grep"                                					     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� httpd �������� ���"                                                          		 >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f Inf_apaTemp.txt ]
	then
		cat Inf_apaTemp.txt                                                           			 >> $HOSTNAME.linux.result.txt 2>&1
		rm -rf Inf_apaTemp.txt
	fi
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
	echo $ACONF																					 >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	
	if [ -f $ACONF ]
	then
		echo "�� Indexes ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"    >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |Indexes|</Directory" | grep -v '\#'                   >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |Indexes|</Directory" | grep -v '\#' | grep Indexes | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "�� Apache ���������� ã�� �� �����ϴ�.(��������)"                                  >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0721 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0722 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache ���ʿ��� ���� ����           ####################"
echo "####################           Apache ���ʿ��� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����  : Server_Root �Ǵ� DocumentRoot �� manual ���͸��� �������� �ʰų�,"           >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : test-cgi, printenv ������ �������� �ʴ� ��� ��ȣ"  									         >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="M/T"
	echo "�� ServerRoot Directory" 	 	                                                           >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      	 >> $HOSTNAME.linux.result.txt 2>&1
	echo $AHOME																																									 >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� DocumentRoot Directory" 	                                                           >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"    		 >> $HOSTNAME.linux.result.txt 2>&1
	if [ $apache_type = "httpd" ]
	then
		DOCROOT=`cat $ACONF | grep -i ^DocumentRoot | awk '{print $2}' | sed 's/"//g'` 2>&1
		echo $DOCROOT																																							 >> $HOSTNAME.linux.result.txt 2>&1
	elif [ $apache_type = "apache2" ]
	then
		cat $AHOME/sites-enabled/*.conf | grep -i "DocumentRoot" | awk '{print $2}' | uniq         > apache2_DOCROOT.txt 2>&1
		cat apache2_DOCROOT.txt																																		 >> $HOSTNAME.linux.result.txt 2>&1
	fi
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1

	find $AHOME -name "cgi-bin" -exec ls -l {} \;																								 > unnecessary_file.txt 2>&1
	find $AHOME -name "printenv" -exec ls -l {} \;																							 >> unnecessary_file.txt 2>&1
	find $AHOME -name "manual" -exec ls -ld {} \;																								 > unnecessary_directory.txt 2>&1
	
	find $DOCROOT -name "cgi-bin" -exec ls -l {} \;																							 >> unnecessary_file.txt 2>&1
	find $DOCROOT -name "printenv" -exec ls -l {} \;																						 >> unnecessary_file.txt 2>&1
	
	if [ $apache_type = "apache2" ]
	then
		for docroot2 in `cat ./apache2_DOCROOT.txt`
		do
			find $docroot2 -name "cgi-bin" -exec ls -l {} \;																					 >> unnecessary_file.txt 2>&1
			find $docroot2 -name "printenv" -exec ls -l {} \;																					 >> unnecessary_file.txt 2>&1
			find $docroot2 -name "manual" -exec ls -ld {} \;																					 >> unnecessary_directory.txt 2>&1
		done
	fi
	
		echo "�� test-cgi, printenv ���� Ȯ��"       					                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
		if [ `cat ./unnecessary_file.txt | wc -l` -eq 0 ]
		then
			echo "�� test-cgi, printenv ������ �������� �ʽ��ϴ�."		                               >> $HOSTNAME.linux.result.txt 2>&1
		else
			cat ./unnecessary_file.txt																															 >> $HOSTNAME.linux.result.txt 2>&1
		fi
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1

		echo "�� manual ���丮 Ȯ��"				       					                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
		if [ `cat ./unnecessary_directory.txt | wc -l` -eq 0 ]
		then
			echo "�� manual ���丮�� �������� �ʽ��ϴ�."		  				                             >> $HOSTNAME.linux.result.txt 2>&1
		else
			cat ./unnecessary_directory.txt																													 >> $HOSTNAME.linux.result.txt 2>&1
		fi
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
rm -rf ./unnecessary_file.txt
rm -rf ./unnecessary_directory.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0722 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 

echo "0723 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache ���� ���ε� �� �ٿ�ε� ����            ####################"
echo "####################           Apache ���� ���ε� �� �ٿ�ε� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �ý��ۿ� ���� ���� ���ε� �� �ٿ�ε忡 ���� �뷮�� ���ѵǾ� �ִ� ��� ��ȣ(���ϻ����� 5M�ǰ�)"     >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : <Directory ���>�� LimitRequestBody �����ڿ� ���ѿ뷮�� �����Ǿ� �ִ� ��� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "�� $ACONF ���� ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |LimitRequestBody|</Directory" | grep -v '\#'              >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |LimitRequestBody|</Directory" | grep -v '\#' | grep LimitRequestBody | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "�� Apache ���������� ã�� �� �����ϴ�.(��������)"                                  >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0723 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 



echo "0724 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache �� ���� ������ �и�            ####################"
echo "####################           Apache �� ���� ������ �и�            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: DocumentRoot�� �⺻ ���͸��� �ƴ� ������ ���丮�� ������ ��� ��ȣ" 				 >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="M/T"
	if [ -f $ACONF ]
	then
		echo "�� DocumentRoot Ȯ��"  		                                                           >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
		if [ $apache_type = "httpd" ]
		then
			echo $DOCROOT																																						 >> $HOSTNAME.linux.result.txt 2>&1
		elif [ $apache_type = "apache2" ]
		then
			for docroot2 in `cat ./apache2_DOCROOT.txt`
			do
				echo $docroot2																																				 >> $HOSTNAME.linux.result.txt 2>&1
			done
		fi
	else
		echo "�� Apache ���������� ã�� �� �����ϴ�.(��������)"                                  	 >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1				                                                                   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
rm -rf ./apache2_DOCROOT.txt
echo "0724 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0725 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Apache ��ũ ������ ����            ####################"
echo "####################           Apache ��ũ ������ ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: Options �����ڿ��� �ɺ� ��ũ�� �����ϰ� �ϴ� �ɼ��� FollowSymLinks�� ���ŵ� ��� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "�� $ACONF ���� ���� Ȯ��"                                                              >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |FollowSymLinks|</Directory" | grep -v '\#'                >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |FollowSymLinks|</Directory" | grep -v '\#' | grep FollowSymLinks | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "�� Apache ���������� ã�� �� �����ϴ�.(��������)"                                  >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "�� Apache Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0725 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0726 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ������ Apache Tomcat �⺻ ���� ��� ����            ####################"
echo "####################           ������ Apache Tomcat �⺻ ���� ��� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ������ ����/�н����� tomcat/admin �̿��� �ٸ� �н������ �����Ǿ� ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "	   : Tomcat6.x�� 7.x �̻��� Default ������ �ּ�ó�� Ȯ�� �ʿ�."                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

echo "�� Tomcat ���� Ȯ��(���μ���)"                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep -i "tomcat" | grep -v "grep" | wc -l` -gt 0 ]
then
	ps -ef | grep -i "tomcat" | grep -v "grep"                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

	echo "�� tomcat-user.xml ���� ���� Ȯ��($CATALINA_HOME\conf\tomcat-user.xml)"                                            >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	if [ -d $CATALINA_HOME ]
	then
		if [ -f $CATALINA_HOME\conf\tomcat-user.xml ] 
		then
			ls -alL $CATALINA_HOME\conf\tomcat-user.xml                                                     >> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
			cat $CATALINA_HOME\conf\tomcat-user.xml | egrep "username|password"                           >> $HOSTNAME.linux.result.txt 2>&1
		else
			echo "tomcat-user.xml ������ �������� ����"                                                               >> $HOSTNAME.linux.result.txt 2>&1
		fi
	else
		echo "�⺻ ȯ�溯�� �� ���� ��� ������ (�������� �ʿ�)"                                                        >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "Tomcat ���񽺰� �����ǰ� ���� ����"                                            >> $HOSTNAME.linux.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0726 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0727 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           DNS Inverse Query ���� ����            ####################"
echo "####################           DNS Inverse Query ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: option ���ο� fake-iquery ������ ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	echo "�� ���� Ȯ��"																		  >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/named.boot Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/named.boot  ]
	then
		cat /etc/named.boot                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/named.boot ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi

	echo "�� /etc/named.conf Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/named.conf  ]
	then
		cat /etc/named.conf                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/named.conf ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi

	echo "�� /etc/bind/named.boot Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/bind/named.boot  ]
	then
		cat /etc/bind/named.boot                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/bind/named.boot ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi

		echo "�� /etc/bind/named.conf Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/bind/named.conf  ]
	then
		cat /etc/bind/named.conf                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/bind/named.conf ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi
	
		echo "�� /etc/bind/named.conf.options Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/bind/named.conf.options  ]
	then
		cat /etc/bind/named.conf.options                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/bind/named.conf.options ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi
  Result="M/T"
else
	echo "�� DNS Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	Result="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$Result                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0727 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0728 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           BIND ���� ���� ���� ����            ####################"
echo "####################           BIND ���� ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: option ���ο� version ������ ���� ��� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "      : named ���μ����� �����ϸ� option ���ο� version ������ �ִ� ��� ���"  >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	echo "�� ���� Ȯ��"																		  >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	grep version /etc/named.conf															  >> $HOSTNAME.linux.result.txt 2>&1
	echo " "        																			 >> $HOSTNAME.linux.result.txt 2>&1
	grep version /etc/bind/named.conf														  >> $HOSTNAME.linux.result.txt 2>&1
	Result="M/T"
else
  echo "�� DNS Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
  Result="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result=$Result                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0728 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0729 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           DNS Recursive Query ���� ����            ####################"
echo "####################           DNS Recursive Query ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: options { } ���ο� recursion yes �ɼ��� ���ų� no �� ������ ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	echo "�� ���� Ȯ��"																		  >> $HOSTNAME.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	echo "�� /etc/named.boot Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/named.boot  ]
	then
		cat /etc/named.boot                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/named.boot ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi

	echo "�� /etc/named.conf Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/named.conf  ]
	then
		cat /etc/named.conf                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/named.conf ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi

	echo "�� /etc/bind/named.boot Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/bind/named.boot  ]
	then
		cat /etc/bind/named.boot                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/bind/named.boot ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi

		echo "�� /etc/bind/named.conf Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/bind/named.conf  ]
	then
		cat /etc/bind/named.conf                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/bind/named.conf ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi
	
		echo "�� /etc/bind/named.conf.options Ȯ��" 								                                    >> $HOSTNAME.linux.result.txt 2>&1
	if [ -f /etc/bind/named.conf.options  ]
	then
		cat /etc/bind/named.conf.options                              					                        >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� /etc/bind/named.conf.options ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
	fi
  Result="M/T"
else
	echo "�� DNS Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	Result="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
 echo Result=$Result                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0729 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0730 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           DNS ���� ���� ��ġ            ####################"
echo "####################           DNS ���� ���� ��ġ            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: DNS ���񽺸� ������� �ʰų�, ��ȣ�� ������ ����ϰ� ���� ��쿡 ��ȣ"           >> $HOSTNAME.linux.result.txt 2>&1
echo "        : (��ȣ�� ����: BIND 9.3.5-p1, BIND 9.4.2-p1, BIND 9.5.0-p1 �̻�)"           >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
DNSPR=`ps -ef | grep named | grep -v "grep" | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}'| grep "/" | uniq`
DNSPR=`echo $DNSPR | awk '{print $1}'`
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	flag1="M/T"
	if [ -f $DNSPR ]
	then
    echo "BIND ���� Ȯ��"                                                                      >> $HOSTNAME.linux.result.txt 2>&1
    echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
    $DNSPR -v | grep BIND                                                                      >> $HOSTNAME.linux.result.txt 2>&1
  else
    echo "$DNSPR ������ �����ϴ�."                                                             >> $HOSTNAME.linux.result.txt 2>&1
  fi
else
  echo "�� DNS Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
  flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0730 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0731 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           NIS, NIS+ ����            ####################"
echo "####################           NIS, NIS+ ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: NIS ���񽺰� ��Ȱ��ȭ �Ǿ� �ְų�, �ʿ� �� NIS+�� ����ϴ� ��� ��ȣ"            >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated|rpc.nids"

if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "�� NIS, NIS+ Service Disable"                                                        >> $HOSTNAME.linux.result.txt 2>&1
	flag="Disabled"
else
	echo "�� NIS+ ������ rpc.nids��"														   >> $HOSTNAME.linux.result.txt 2>&1
	ps -ef | egrep $SERVICE | grep -v "grep"                                                   >> $HOSTNAME.linux.result.txt 2>&1
	
	if [ `ps -ef | grep "rpc.nids" | grep -v "grep" | wc -l` -eq 0 ]
	then
		flag="Enabled"
	else
		flag="nis+"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag                                                                          >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0731 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0732 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           DNS Zone Transfer ����            ####################"
echo "####################           DNS Zone Transfer ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: DNS ���񽺸� ������� �ʰų� Zone Transfer �� ���ѵǾ� ���� ��� ��ȣ"           >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� DNS ���μ��� Ȯ�� " >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep named | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "�� DNS Service Disable"                                                                >> $HOSTNAME.linux.result.txt 2>&1
	flag="Disabled"
else
	ps -ef | grep named | grep -v "grep"                                                         >> $HOSTNAME.linux.result.txt 2>&1
	flag="M/T"
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ `ls -al /etc/rc.d/rc*.d/* | grep -i named | grep "/S" | wc -l` -gt 0 ]
then
	ls -al /etc/rc.d/rc*.d/* | grep -i named | grep "/S"                                         >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
fi
if [ -f /etc/rc.tcpip ]
then
	cat /etc/rc.tcpip | grep -i named                                                            >> $HOSTNAME.linux.result.txt 2>&1
	echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
fi
echo "�� /etc/named.conf ������ allow-transfer Ȯ�� (BIND8 DNS ����)"                                           >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/named.conf ]
then
	cat /etc/named.conf | grep 'allow-transfer'                                                  >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "/etc/named.conf ������ �����ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/named.boot ������ xfrnets Ȯ�� (BIND4.9 DNS ����)"                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/named.boot ]
then
	cat /etc/named.boot | grep "\xfrnets"                                                        >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "/etc/named.boot ������ �����ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag                                                                            >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0732 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0733 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���� �� ���丮 ������ ����            ####################"
echo "####################           ���� �� ���丮 ������ ����           ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �����ڰ� �������� �ʴ� ���� �� ���丮�� �������� ���� ��� ��ȣ"               >> $HOSTNAME.linux.result.txt 2>&1
echo "�� �� ���� �����ڸ��� ������ ��찡 �����Ƿ� ����� Ȯ�� �ʼ�"		               >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� �����ڰ� �������� �ʴ� ���� (������ => ������ġ: ���)"                               >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
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
		echo "�����ڰ� �������� �ʴ� ���� (���� 10��)"                                             >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
	  head -10 7.33.txt                                                                          >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  	echo " �� �� "$linecount"�� ���� ���� (��ü ����� ��ũ��Ʈ ��� ���� Ȯ��)"               >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=$linecount                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo "0733 END"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�����ڰ� �������� �ʴ� ����"                                                         >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
		cat 7.33.txt                                                                               >> $HOSTNAME.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  	echo " �� "$linecount"�� ���� ����"                                                        >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo Result=$linecount                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.linux.result.txt 2>&1
		echo "0733 END"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
  echo "------------------------------------------------------------------------------"        >> $HOSTNAME.linux.result.txt 2>&1
  echo "�����ڰ� �������� �ʴ� ������ �߰ߵ��� �ʾҽ��ϴ�."                                    >> $HOSTNAME.linux.result.txt 2>&1
  echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=0					                                                                       >> $HOSTNAME.linux.result.txt 2>&1	
  echo " "                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
	echo "0733 END"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0734 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           root Ȩ, �н� ���丮 ���� �� �н� ����            ####################"
echo "####################           root Ȩ, �н� ���丮 ���� �� �н� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: Path ������ ��.��,"::" �� �� ���̳� �߰��� ���ԵǾ� ���� ���� ��� ��ȣ"                >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� PATH ���� Ȯ��"                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
echo $PATH                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0734 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0735 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           UMASK ���� ����            ####################"
echo "####################           UMASK ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����1: ������ umask ���� 022�̻��� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ����2: �������Ͽ� ����� umask���� 022�̻��� ��� ��ȣ"                                                        >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (1) sh, ksh, bash ���� ��� /etc/profile ���� ������ �������"                 >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (2) ������ ȯ�����Ͽ��� umask ���� Ȯ��(��� ���� �ϴ� Ȯ��)"                        >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� �α����� ������ UMASK ���� ��"                                                               >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.linux.result.txt 2>&1
umask                                                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

echo "�� /etc/profile ����(�ǰ� ����: umask 022)"                                            >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/profile ]
then
	if [ `cat /etc/profile | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
		cat /etc/profile | grep -A 1 -B 1 -i umask | grep -v ^#                                 >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "umask ������ �����ϴ�."                                                              >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/profile ������ �����ϴ�."                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ������ ȯ������ umask ������ Ȯ��"                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
for dir in $HOMEDIRS
do
	if [ -d $dir ]
	then
		echo "�� $dir ���丮 �� ȯ������ Ȯ��"                        							                                >> $HOSTNAME.linux.result.txt 2>&1
		echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		
		if [ -f $dir/.profile ]
		then
			echo " - $dir/.profile ���� ����, umask ������ Ȯ��"				       			                         >> $HOSTNAME.linux.result.txt 2>&1
			cat $dir/.profile | grep "umask"                                                      		  >> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		fi
		
		if [ -f $dir/.*shrc ]
		then
			echo " - $dir/.*shrc ���� ����, umask ������ Ȯ��"            			                                  >> $HOSTNAME.linux.result.txt 2>&1
			cat $dir/.*shrc | grep "umask"                                                        >> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		fi
		
		if [ -f $dir/.login ]
		then
			echo " - $dir/.login ���� ����, umask ������ Ȯ��"           				                                   >> $HOSTNAME.linux.result.txt 2>&1
			cat $dir/.login | grep "umask"                                                        >> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		fi
		
		if [ -f $dir/.bash_profile ]
		then
			echo " - $dir/.bash_profile ���� ����, umask ������ Ȯ��"                						             >> $HOSTNAME.linux.result.txt 2>&1
			cat $dir/.bash_profile | grep "umask"                                                        >> $HOSTNAME.linux.result.txt 2>&1
			echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
		fi
	fi
done

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="M/T"	                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0735 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0736 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���� ���� ���� ���� �̼���            ####################"
echo "####################           ���� ���� ���� ���� �̼���            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: noexec\_user\_stack �� �������� 1�̸� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "LINUX�� �ش���� ����"                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0736 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 

echo "0737 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           TCP ISS ���� ����            ####################"
echo "####################           TCP ISS ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: TCP\_STRONG\_ISS �� 2�� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "LINUX�� �ش���� ����"                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0737 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "


echo "0738 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           root ������ ������ UID ����            ####################"
echo "####################           root ������ ������ UID ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: root �������� UID�� 0�̸� ��ȣ"                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    awk -F: '$3==0 { print $1 " -> UID=" $3 }' /etc/passwd > 7.38.txt
    cat 7.38.txt                                     >> $HOSTNAME.linux.result.txt 2>&1
  else
    echo "�� /etc/passwd ������ �������� �ʽ��ϴ�."                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "Result="`cat 7.38.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'` 												 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0738 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  
rm -rf 7.38.txt


echo "0739 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �Ϲ� ������ ������ UID ����            ####################"
echo "####################           �Ϲ� ������ ������ UID ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ������ UID�� ������ ������ �������� ���� ��� ��ȣ"                              >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ������ UID�� ����ϴ� ���� "                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
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
	sort -k 1 total-equaluid.txt | uniq -d                                                       >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "������ UID�� ����ϴ� ������ �߰ߵ��� �ʾҽ��ϴ�."                                     >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "	                                                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo Result=`sort -k 1 total-equaluid.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`				   >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0739 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf equaluid.txt
rm -rf total-equaluid.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  


echo "0740 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���ʿ��� TELNET ���� ���� ����            ####################"
echo "####################           ���ʿ��� TELNET ���� ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: TELNET ���񽺰� ���� ������ �ʰų�, ������ ��� ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȯ��"                  															>> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
echo "��-1 TELNET Ȯ��"                 															 >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "��-2 SSH Ȯ��"                  															>> $HOSTNAME.linux.result.txt 2>&1
echo " " > ssh-result.txt
ServiceDIR="/etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /usr/local/sshd/etc/sshd_config /usr/local/ssh/etc/sshd_config"
for file in $ServiceDIR
do
	if [ -f $file ]
	then
		if [ `cat $file | grep "^Port" | grep -v "^#" | wc -l` -gt 0 ]
		then
			cat $file | grep "^Port" | grep -v "^#" | awk '{print "SSH ��������('${file}'): " $0 }'      >> ssh-result.txt
			port1=`cat $file | grep "^Port" | grep -v "^#" | awk '{print $2}'`
			echo " "                                                                                 > port1-search.txt
		else
			echo "SSH ��������($file): ��Ʈ ���� X (Default ����: 22��Ʈ ���)"                      >> ssh-result.txt
		fi
	fi
done
if [ `cat ssh-result.txt | grep -v "^ *$" | wc -l` -gt 0 ]
then
	cat ssh-result.txt | grep -v "^ *$"                                                          >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "SSH ��������: ���� ������ ã�� �� �����ϴ�."                                           >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
echo "��-1 TELNET"                                                       						  >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $HOSTNAME.linux.result.txt 2>&1
		flag1="Enabled"
	else
		echo "�� Telnet Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
		flag1="Disabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "��-2 SSH Ȯ��"                                                        						 >> $HOSTNAME.linux.result.txt 2>&1
if [ -f port1-search.txt ]
then
	if [ `netstat -na | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	then
		echo "�� SSH Service Disable"                                                              >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Disabled"
	else
		netstat -na | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Enabled"
	fi
else
	if [ `netstat -na | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	then
		echo "�� SSH Service Disable"                                                              >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Disabled"
	else
		netstat -na | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN"                              >> $HOSTNAME.linux.result.txt 2>&1
		flag2="Enabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo " "         
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0740 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
rm -rf port1-search.txt
rm -rf ssh-result.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0741 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ���� ���� ���� Ÿ�Ӿƿ� �̼���            ####################"
echo "####################           ���� ���� ���� Ÿ�Ӿƿ� �̼���            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/profile ���� TMOUT=600 �Ǵ� /etc/csh.login ���� autologout=10 ���Ϸ� �����Ǿ� ������ ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (1) sh, ksh, bash ���� ��� /etc/profile ���� ������ �������"                 >> $HOSTNAME.linux.result.txt 2>&1
echo "��       : (2) csh, tcsh ���� ��� /etc/csh.cshrc �Ǵ� /etc/csh.login ���� ������ �������" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� �α��� ���� TMOUT"                                                               >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.linux.result.txt 2>&1
if [ `set | egrep -i "TMOUT|autologout" | wc -l` -gt 0 ]
	then
		set | egrep -i "TMOUT|autologout"                                                            >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "TMOUT �� �����Ǿ� ���� �ʽ��ϴ�."                                                      >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� TMOUT ���� Ȯ��"                                                                      >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/profile ����"                                                                    >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/profile ]
then
  if [ `cat /etc/profile | grep -i TMOUT | grep -v "^#" | wc -l` -gt 0 ]
  then
  	cat /etc/profile | grep -i TMOUT | grep -v "^#"                                            >> $HOSTNAME.linux.result.txt 2>&1
  else
  	echo "TMOUT �� �����Ǿ� ���� �ʽ��ϴ�."                                                    >> $HOSTNAME.linux.result.txt 2>&1
  fi
else
  echo "/etc/profile ������ �����ϴ�."                                                         >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/csh.login ����"                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/csh.login ]
then
  if [ `cat /etc/csh.login | grep -i autologout | grep -v "^#" | wc -l` -gt 0 ]
  then
  	cat /etc/csh.login | grep -i autologout | grep -v "^#"                                     >> $HOSTNAME.linux.result.txt 2>&1
  else
  	echo "autologout �� �����Ǿ� ���� �ʽ��ϴ�."                                               >> $HOSTNAME.linux.result.txt 2>&1
  fi
else
  echo "/etc/csh.login ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/csh.cshrc ����"                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/csh.cshrc ]
then
  if [ `cat /etc/csh.cshrc | grep -i autologout | grep -v "^#" | wc -l` -gt 0 ]
  then
  	cat /etc/csh.cshrc | grep -i autologout | grep -v "^#"                                     >> $HOSTNAME.linux.result.txt 2>&1
  else
  	echo "autologout �� �����Ǿ� ���� �ʽ��ϴ�."                                               >> $HOSTNAME.linux.result.txt 2>&1
  fi
else
  echo "/etc/csh.cshrc ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0741 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "  


echo "0742 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �ý��� ��� ���ǻ��� �����            ####################"
echo "####################           �ý��� ��� ���ǻ��� �����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/issue.net�� /etc/motd ���Ͽ� �α׿� �ý��� ��� ���ǻ��� ���� �ȳ�(���) ������ �����Ǿ� ���� ��� ��ȣ"  >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/motd ���� ����: "                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/motd ]
then
	if [ `cat /etc/motd | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/motd | grep -v "^ *$"                                                             >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "��� �޽��� ���� ������ �����ϴ�.(���)"                                             >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/motd ������ �����ϴ�."                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/issue.net ���� ����: "                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��"                                                      >> $HOSTNAME.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��"                                                          >> $HOSTNAME.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                           >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�� Telnet Service Disable"                                                           >> $HOSTNAME.linux.result.txt 2>&1
	fi
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� /etc/issue.net ���� ����:"                                                             >> $HOSTNAME.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/issue.net ]
then
	if [ `cat /etc/issue.net | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/issue.net | grep -v "^#" | grep -v "^ *$"                                         >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "��� �޽��� ���� ������ �����ϴ�.(���)"                                             >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/issue.net ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0742 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        8. ��ġ ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0801 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �ֽ� ������ġ �� ���� �ǰ���� ����            ####################"
echo "####################           �ֽ� ������ġ �� ���� �ǰ���� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: ��ġ ���� ��å�� �����Ͽ� �ֱ������� ��ġ�� �����ϰ� ���� ��� ��ȣ"             >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� uname -a"                                    	                                  	   >> $HOSTNAME.linux.result.txt 2>&1
uname -a 																						>> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� lsb_release -a"                                    	                                 >> $HOSTNAME.linux.result.txt 2>&1
lsb_release -a 																					 >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0801 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        9. ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "0901 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           Cron ���� ���� �α� �̼���            ####################"
echo "####################           Cron ���� ���� �α� �̼���            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /etc/default/cron ���Ͽ� CRONLOG=YES �� �����Ǿ� �ִ� ��� ��ȣ"        >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "LINUX�� �ش���� ����"                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0901 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0902 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �α��� ���� ���� ��� �̼���            ####################"
echo "####################           �α��� ���� ���� ��� �̼���            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: /var/adm/loginlog ������ �����ϸ�, �����ڴ� ������, ������ 600���� �����Ǿ� ���� ��� ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "LINUX�� �ش���� ����"                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo Result="N/A"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0902 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0903 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �α��� ������ ���� �� ����            ####################"
echo "####################           �α��� ������ ���� �� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: �αױ�Ͽ� ���� ������ ����, �м�, ����Ʈ �ۼ� �� ���� �̷������ �ִ� ��� ��ȣ" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����� ���ͺ� �� ����Ȯ��"                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ���� �ֱ�� �α׸� �����ϰ� �ִ°�?"                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "�� �α� ���˰���� ���� ��������� �����ϴ°�?"                                        >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0903 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo "0904 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           �̺�Ʈ �α׿� ���� ���� ���� ���� �̺�            ####################"
echo "####################           �̺�Ʈ �α׿� ���� ���� ���� ���� �̺�            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: grep rootok /etc/pam.d/su ����� auth sufficient /lib/security/pam_rootok.so debug �� ���� debug �ɼ��� ������ ��ȣ"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "��������: (1) /etc/login.defs �Ǵ� (r)syslog.conf���� sulog ���� ��θ� ������ ������ �� ����"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "��������: (2) /etc/logrotate.d/syslog���� sulog ���� ��θ� ������ ������ �� ����"                         >> $HOSTNAME.linux.result.txt 2>&1 
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/pam.d/su ]
then
	if [ `cat /etc/pam.d/su | grep "" | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/pam.d/su | grep "rootok" | grep -v "^#" | grep -v "^ *$"            >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "�������� �������� ����."                                             >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/pam.d/su ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/login.defs ]
then
	if [ `cat /etc/login.defs | grep "" | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/login.defs | grep "sulog|secure" | grep -v "^#" | grep -v "^ *$"            >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "sulog ������ �������� ����."                                             >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/login.defs ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
	cat /etc/syslog.conf | grep "sulog|secure" | grep -v "^#" | grep -v "^ *$"            >> $HOSTNAME.linux.result.txt 2>&1
elif [ -f /etc/rsyslog.conf ]
then
	cat /etc/rsyslog.conf | grep "sulog|secure" | grep -v "^#" | grep -v "^ *$"            >> $HOSTNAME.linux.result.txt 2>&1
else
	echo "/etc/(r)syslog.conf ������ �����ϴ�."                                             >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/logrotate.d/syslog ]
then
	if [ `cat /etc/logrotate.d/syslog | grep "" | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/logrotate.d/syslog | grep "sulog|secure" | grep -v "^#" | grep -v "^ *$"            >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "sulog ������ �������� ����."                                             >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/logrotate.d/syslog ������ �����ϴ�."                                                       >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "0904 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 

echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "###########################        10. �α� ����        ################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo "1001 START"                                                                              >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "####################           ��å�� ���� �ý��� �α� ����            ####################"
echo "####################           ��å�� ���� �ý��� �α� ����            ####################" >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ����: syslog �� �߿� �α� ������ ���� ������ �Ǿ� ���� ��� ��ȣ"                      >> $HOSTNAME.linux.result.txt 2>&1
echo "�� ��Ȳ"                                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� SYSLOG ���� ���� Ȯ��"                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ `ps -ef | grep 'syslog' | grep -v 'grep' | wc -l` -eq 0 ]
then
	echo "�� SYSLOG Service Disable"                                                             >> $HOSTNAME.linux.result.txt 2>&1
else
	ps -ef | grep 'syslog' | grep -v 'grep'                                                      >> $HOSTNAME.linux.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� syslog ���� Ȯ��"                                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
	if [ `cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$"                                    >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "/etc/syslog.conf ���Ͽ� ���� ������ �����ϴ�.(�ּ�, ��ĭ ����)"                   >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/syslog.conf ������ �����ϴ�."                                                    >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "�� rsyslog ���� Ȯ��"                                                                     >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/rsyslog.conf ]
then
	if [ `cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$"                                    >> $HOSTNAME.linux.result.txt 2>&1
	else
		echo "/etc/rsyslog.conf ���Ͽ� ���� ������ �����ϴ�.(�ּ�, ��ĭ ����)"                   >> $HOSTNAME.linux.result.txt 2>&1
	fi
else
	echo "/etc/rsyslog.conf ������ �����ϴ�."                                                    >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
	echo Result="M/T"                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "1001 END"                                                                                >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " " 


echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
rm -rf proftpd.txt
rm -rf vsftpd.txt
echo "***************************************** END *****************************************" >> $HOSTNAME.linux.result.txt 2>&1
date                                                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo "***************************************** END *****************************************"

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "@@FINISH"                                                                        	       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
     
echo "#################################   Process Status   ##################################"
echo "#################################   Process Status   ##################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "END_RESULT"                                                                              >> $HOSTNAME.linux.result.txt 2>&1


echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "=========================== System Information Query Start ============================"
echo "=========================== System Information Query Start ============================" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "###############################  Kernel Information  ##################################"
echo "###############################  Kernel Information  ##################################" >> $HOSTNAME.linux.result.txt 2>&1
uname -a                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "################################## IP Information #####################################"
echo "################################## IP Information #####################################" >> $HOSTNAME.linux.result.txt 2>&1
ifconfig -a                                                                                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "################################   Network Status   ###################################"
echo "################################   Network Status   ###################################" >> $HOSTNAME.linux.result.txt 2>&1
netstat -an | egrep -i "LISTEN|ESTABLISHED"                                                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#############################   Routing Information   #################################"
echo "#############################   Routing Information   #################################" >> $HOSTNAME.linux.result.txt 2>&1
netstat -rn                                                                                    >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "################################   Process Status   ###################################"
echo "################################   Process Status   ###################################" >> $HOSTNAME.linux.result.txt 2>&1
ps -ef                                                                                         >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "###################################   User Env   ######################################"
echo "###################################   User Env   ######################################" >> $HOSTNAME.linux.result.txt 2>&1
env                                                                                            >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "=========================== System Information Query End =============================="
echo "=========================== System Information Query End ==============================" >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "[����] /etc/passwd, /etc/security/passwd, /etc/shadow ���� ����"                         >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    echo "�� /etc/passwd ����"                                                                 >> $HOSTNAME.linux.result.txt 2>&1
    cat /etc/passwd                                                                            >> $HOSTNAME.linux.result.txt 2>&1
  else
    echo "/etc/passwd ������ �����ϴ�."                                                        >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/security/passwd ]
  then
    echo "�� /etc/security/passwd ����"                                                        >> $HOSTNAME.linux.result.txt 2>&1
    cat /etc/security/passwd                                                                   >> $HOSTNAME.linux.result.txt 2>&1
  else
    echo "/etc/security/passwd ������ �����ϴ�."                                               >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
if [ -f /etc/shadow ]
  then
    echo "�� /etc/shadow ����"                                                                 >> $HOSTNAME.linux.result.txt 2>&1
    cat /etc/shadow                                                                            >> $HOSTNAME.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1


echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "[����] /etc/security/user ���� ����"                        														 >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
	cat /etc/security/user                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo "[����] /etc/group ����"                                                                  >> $HOSTNAME.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.linux.result.txt 2>&1
cat /etc/group                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1




		echo "[����] �����ڰ� �������� �ʴ� ���� ��ü ���"                                        >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
		cat 7.33.txt                                                                               >> $HOSTNAME.linux.result.txt 2>&1
		rm -rf 7.33.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1		
		
		echo "[����] SUID,SGID,Sticky bit ���� ���� ��ü ���"                                     >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
    cat 6.17.txt                                                                               >> $HOSTNAME.linux.result.txt 2>&1
    rm -rf 6.17.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1    
    
    echo "[����] World Writable ���� ��ü ���"                                                >> $HOSTNAME.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      >> $HOSTNAME.linux.result.txt 2>&1
    cat world-writable.txt                                                                     >> $HOSTNAME.linux.result.txt 2>&1
    rm -rf world-writable.txt
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1    
    




echo "[����] ����� �� profile ����"                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo ": ����� profile �Ǵ� profile �� TMOUT ������ ���� ��� ��� ���� (/etc/profile�� ����)" >> $HOSTNAME.linux.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

awk -F: '{print $1 ":" $6}' /etc/passwd > profilepath.txt

for result in `cat profilepath.txt`
do
	echo $result > tempfile.txt
	var=`awk -F":" '{print $2}' tempfile.txt`

	if [ $var = "/" ]
	then
		if [ `ls -f / | grep "^\.profile$" | wc -l` -gt 0 ]
		then
			filename=`ls -f / | grep "^\.profile$"`

			if [ `grep -i TMOUT /$filename | grep -v "^#" | wc -l` -gt 0 ]
			then
				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.linux.result.txt 2>&1
				echo "-----------------------------------------------"                                 >> $HOSTNAME.linux.result.txt 2>&1
				grep -i TMOUT /$filename | grep -v "^#"	                                               >> $HOSTNAME.linux.result.txt 2>&1
				echo " "                                                                               >> $HOSTNAME.linux.result.txt 2>&1
# ����� profile�� �����ϴ� ��츸 ����ϱ� ���� �ּ� ó��
#			else
#				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.linux.result.txt 2>&1
#                         	echo "----------------------------------------"                      >> $HOSTNAME.linux.result.txt 2>&1
#                         	echo $filename"�� TMOUT ������ �������� ����"                        >> $HOSTNAME.linux.result.txt 2>&1
#				echo " "                                                                               >> $HOSTNAME.linux.result.txt 2>&1
			fi
#		else
#                        awk -F":" '{print $1}' tempfile.txt                                    >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "----------------------------------------"                        >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "����� profile ������ �������� ����"                             >> $HOSTNAME.linux.result.txt 2>&1
#			echo " "                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
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
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.linux.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.linux.result.txt 2>&1
                                grep -i TMOUT $pathname/$filename | grep -v "^#"               >> $HOSTNAME.linux.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.linux.result.txt 2>&1
# ����� profile�� �����ϴ� ��츸 ����ϱ� ���� �ּ� ó��
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.linux.result.txt 2>&1
#                                echo "----------------------------------------"                >> $HOSTNAME.linux.result.txt 2>&1
#                                echo $filename"�� TMOUT ������ �������� ����"                  >> $HOSTNAME.linux.result.txt 2>&1
#                                echo " "                                                       >> $HOSTNAME.linux.result.txt 2>&1
                        fi
#                else
#                        awk -F":" '{print $1}' tempfile.txt                                    >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "----------------------------------------"                        >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "����� profile ������ �������� ����"                             >> $HOSTNAME.linux.result.txt 2>&1
#                        echo " "                                                               >> $HOSTNAME.linux.result.txt 2>&1
								 fi
				fi				 
	fi
done
rm -rf tempfile.txt

echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

echo "[����] ����� �� profile ����"                                                           >> $HOSTNAME.linux.result.txt 2>&1
echo ": ����� profile �Ǵ� profile �� UMASK ������ ���� ��� ��� ���� (/etc/profile�� ����)" >> $HOSTNAME.linux.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1

for result in `cat profilepath.txt`
do
	echo $result > tempfile.txt
	var=`awk -F":" '{print $2}' tempfile.txt`

	if [ $var = "/" ]
	then
		if [ `ls -f / | grep "^\.profile$" | wc -l` -gt 0 ]
		then
			filename=`ls -f / | grep "^\.profile$"`

			if [ `grep -i umask /$filename | grep -v "^#" | wc -l` -gt 0 ]
			then
				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.linux.result.txt 2>&1
				echo "-----------------------------------------------"                                 >> $HOSTNAME.linux.result.txt 2>&1
				grep -A 1 -B 1 -i umask /$filename | grep -v "^#"	                                               >> $HOSTNAME.linux.result.txt 2>&1
				echo " "                                                                               >> $HOSTNAME.linux.result.txt 2>&1
# ����� profile�� �����ϴ� ��츸 ����ϱ� ���� �ּ� ó��
#			else
#				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.linux.result.txt 2>&1
#                         	echo "----------------------------------------"                    >> $HOSTNAME.linux.result.txt 2>&1
#                         	echo $filename"�� UMASK ������ �������� ����"                      >> $HOSTNAME.linux.result.txt 2>&1
#				echo " "                                                                               >> $HOSTNAME.linux.result.txt 2>&1
			fi
#		else
#                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "----------------------------------------"                       >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "����� profile ������ �������� ����"                            >> $HOSTNAME.linux.result.txt 2>&1
#			echo " "                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
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
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.linux.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.linux.result.txt 2>&1
                                grep -A 1 -B 1 -i umask $pathname/$filename | grep -v "^#"               >> $HOSTNAME.linux.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.linux.result.txt 2>&1
# ����� profile�� �����ϴ� ��츸 ����ϱ� ���� �ּ� ó��
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                           >> $HOSTNAME.linux.result.txt 2>&1
#                                echo "----------------------------------------"               >> $HOSTNAME.linux.result.txt 2>&1
#                                echo $filename"�� UMASK ������ �������� ����"                 >> $HOSTNAME.linux.result.txt 2>&1
#                                echo " "                                                      >> $HOSTNAME.linux.result.txt 2>&1
                        fi
#                else
#                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "----------------------------------------"                       >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "����� profile ������ �������� ����"                            >> $HOSTNAME.linux.result.txt 2>&1
#                        echo " "                                                              >> $HOSTNAME.linux.result.txt 2>&1
								 fi
					fi			 
	fi
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
rm -rf profilepath.txt
rm -rf tempfile.txt grep "^\.profile$" | wc -l` -gt 0 ]
                then
                        filename = `ls -f $pathname | grep "^\.profile$"`

                        if [ `grep -i umask $pathname/$filename | grep -v "^#" | wc -l` -gt 0 ]
                        then
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.linux.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.linux.result.txt 2>&1
                                grep -A 1 -B 1 -i umask $pathname/$filename | grep -v "^#"               >> $HOSTNAME.linux.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.linux.result.txt 2>&1
# ����� profile�� �����ϴ� ��츸 ����ϱ� ���� �ּ� ó��
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                           >> $HOSTNAME.linux.result.txt 2>&1
#                                echo "----------------------------------------"               >> $HOSTNAME.linux.result.txt 2>&1
#                                echo $filename"�� UMASK ������ �������� ����"                 >> $HOSTNAME.linux.result.txt 2>&1
#                                echo " "                                                      >> $HOSTNAME.linux.result.txt 2>&1
                        fi
#                else
#                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "----------------------------------------"                       >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "����� profile ������ �������� ����"                            >> $HOSTNAME.linux.result.txt 2>&1
#                        echo " "                                                              >> $HOSTNAME.linux.result.txt 2>&1
								 fi
					fi			 
	fi
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
rm -rf profilepath.txt
rm -rf tempfile.txtxt 2>&1
								 fi
					fi			 
	fi
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
rm -rf profilepath.txt
rm -rf tempfile.txt?����"                            >> $HOSTNAME.linux.result.txt 2>&1
#			echo " "                                                                                 >> $HOSTNAME.linux.result.txt 2>&1
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
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.linux.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.linux.result.txt 2>&1
                                grep -A 1 -B 1 -i umask $pathname/$filename | grep -v "^#"               >> $HOSTNAME.linux.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.linux.result.txt 2>&1
# ����� profile�� �����ϴ� ��츸 ����ϱ� ���� �ּ� ó��
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                           >> $HOSTNAME.linux.result.txt 2>&1
#                                echo "----------------------------------------"               >> $HOSTNAME.linux.result.txt 2>&1
#                                echo $filename"�� UMASK ������ �������� ����"                 >> $HOSTNAME.linux.result.txt 2>&1
#                                echo " "                                                      >> $HOSTNAME.linux.result.txt 2>&1
                        fi
#                else
#                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "----------------------------------------"                       >> $HOSTNAME.linux.result.txt 2>&1
#                        echo "����� profile ������ �������� ����"                            >> $HOSTNAME.linux.result.txt 2>&1
#                        echo " "                                                              >> $HOSTNAME.linux.result.txt 2>&1
								 fi
					fi			 
	fi
done
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.linux.result.txt 2>&1
rm -rf profilepath.txt
rm -rf tempfile.txt                                                    >> $HOSTNAME.linux.result.txt 2>&1
rm -rf profilepath.txt
rm -rf tempfile.txt