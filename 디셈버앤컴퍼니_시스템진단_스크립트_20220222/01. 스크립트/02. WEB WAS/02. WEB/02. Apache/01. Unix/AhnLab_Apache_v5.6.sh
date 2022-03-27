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
echo "##### WA-001 �� ���μ��� ���� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
echo "---------------< ���μ��� >---------------"															>> ./$RES_LAST_FILE 2>&1
ps -ef | grep -v grep | grep httpd 								 										>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< httpd.conf >---------------"															>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | egrep "User |Group ")													>> ./$RES_LAST_FILE 2>&1

echo "1.1  ���μ����� Root �� �����Ǵ��� Ȯ��"																>> ./$RES_LAST_FILE 2>&1
echo "1.2  Ȯ�� �Ұ����� ��� httpd.conf ���� � ����ڸ� ���� �����ϴ��� Ȯ��"							>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : ���� Web Server �������� ���񽺰� �����Ǵ� ���"												>> ./$RES_LAST_FILE 2>&1
echo "��� : ���� Web Server �������� ���񽺰� �������� ���� ���"											>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1

echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE002 ##"
echo "##### WA-002 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-002 ���͸� ���� ���� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
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


echo "1.1  �� Apache ���� ���丮�� ���� ���� Ȯ��"														>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : ���͸� �����ڰ� ���� Web Server �����̰�, ������ 750(-rwxr-x---) �Ǵ� 755(drwxr-xr-x)�� ���"	>> ./$RES_LAST_FILE 2>&1
echo "��� : ���͸� �����ڰ� ���� Web Server ������ �ƴϰų�, ������ 750(-rwxr-x---) �Ǵ� 755(drwxr-xr-x)�� �ƴ� ���"	>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE003 ##"
echo "##### WA-003 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-003 �ҽ�/�������� ���� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  Apache �������� ���� Ȯ��"																		>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : �ҽ� ���� �����ڰ� ���� Web Server �����̰�, ������ 754(-rwxr-xr--) ������ ��� "				>> ./$RES_LAST_FILE 2>&1
echo "��ȣ : ���� ���� �����ڰ� ���� Web Server �����̰�, ������ 700(-rwx------) ������ ���"				>> ./$RES_LAST_FILE 2>&1
echo "��� : �ҽ� ���� �����ڰ� ���� Web Server ������ �ƴϰų�, ������ 754(-rwxr-xr--) ���� ���� ���"		>> ./$RES_LAST_FILE 2>&1
echo "��� : ���� ���� �����ڰ� ���� Web Server ������ �ƴϰų�, ������ 700(-rwx------) ���� ���� ���"		>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE004 ##"
echo "##### WA-004 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-004 �α� ���͸�/���� ���� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  �α� ���͸� �� ���� ���Ѽ���"																	>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : ���͸� �����ڰ� ���� Web Server �����̰�, ������ 750(-rwxr-x---) ������ ��� "				>> ./$RES_LAST_FILE 2>&1
echo "��ȣ : ���� �����ڰ� ���� Web Server �����̰�, ������ 640(-rw-r-----) ������ ���"					>> ./$RES_LAST_FILE 2>&1
echo "��� : ���͸� �����ڰ� ���� Web Server ������ �ƴϰų�, ������ 750(-rwxr-x---) ���� ���� ���"		>> ./$RES_LAST_FILE 2>&1
echo "��� : ���� �����ڰ� ���� Web Server ������ �ƴϰų�, ������ 640(-rw-r-----) ���� ���� ���"			>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE005 ##"
echo "##### WA-005 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-005 ���͸� ������ ���� ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  ���丮 ������ ����Ȯ�� ( <Directory> </Directory> ���̿� Indexes ���� �Ǵ� -Indexes �Ǵ� IncludeNoExec ����)"		>> ./$RES_LAST_FILE 2>&1																		>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : -Indexex �Ǵ� IncludeNoExec �����Ǿ� �ִ� ���"												>> ./$RES_LAST_FILE 2>&1
echo "��� :  Indexes �����Ǿ� �ִ� ���"																	>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE006 ##"
echo "##### WA-006 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-006 FollowSymLinks ���� ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  Options�� FollowSymLinks ����Ȯ��"															>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : FollowSymLinks ���� ���� ���ų�, -FollowSymLinks �����Ǿ� �ִ� ���"							>> ./$RES_LAST_FILE 2>&1
echo "��� : FollowSymLinks �����Ǿ� �ִ� ���"															>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1



echo "## LINUX_APACHE007 ##"
echo "##### WA-007 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-007 ���ʿ��� ���� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  ���ʿ��� ���� �Ǵ� �⺻ CGI ��ũ��Ʈ ������ ���� Ȯ��"											>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : ���ʿ��� ���� �Ǵ� �⺻ CGI ��ũ��Ʈ ������ �������� �ʴ� ���"									>> ./$RES_LAST_FILE 2>&1
echo "��� : ���ʿ��� ���� �Ǵ� �⺻ CGI ��ũ��Ʈ ������ �����ϴ� ���"										>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE008 ##"
echo "##### WA-008 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-008 ���� �޽��� ��� ���� ����� ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerTokens (��������) >---------------"												>> ./$RES_LAST_FILE 2>&1	
(cat $HTTPD_CONF | grep -v '#' | grep ServerTokens)														>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerTokens (extra/httpd-default.conf etc...)>---------------"								>> ./$RES_LAST_FILE 2>&1
for dir in $EXTRA_CONF_FILES
do 
if [ `cat $dir | grep -v '#' | grep "ServerTokens" | wc -l` -ge 1 ]; then
(cat $dir | grep -v '#' | grep "ServerTokens")													>> ./$RES_LAST_FILE 2>&1
fi
done
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ServerSignature (��������) >---------------"											>> ./$RES_LAST_FILE 2>&1	
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

echo "1.1  ���� �ñ״�ó Ȯ��"																			>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : ServerTokens�� Prod �Ǵ� ProductOnly�� ���� �Ǿ��ְ�, ServerSignature�� off�� ���� �Ǿ� �ִ� ���"		>> ./$RES_LAST_FILE 2>&1
echo "��� : ServerTokens�� Prod �Ǵ� ProductOnly�� ������ �ȵǾ��ְ�, ServerSignature�� off�� ���� �ȵǾ� �ִ� ���">> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE009 ##"
echo "##### WA-009 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-009 MultiViews �ɼ� ��Ȱ��ȭ ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  ���� ����Ȯ��"																					>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : MultiViews ���� ���� ���ų�, -MultiViews ������ �Ǿ��ִ� ��� "								>> ./$RES_LAST_FILE 2>&1
echo "��� : MultiViews �����̾� �ִ� ���"																>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1






echo "## LINUX_APACHE010 ##"
echo "##### WA-010 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-010 HTTP Method ���� ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< Limit ���� >---------------"															>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | grep -v ServerLimit | grep Limit	)									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< TraceEnable >---------------"														>> ./$RES_LAST_FILE 2>&1	
(cat $HTTPD_CONF | grep -v '#' | grep 'TraceEnable ')													>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  ���ʿ��� Method ���ѵǾ��ִ��� Ȯ��"															>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : TraceEnable Off ���� �Ǿ� �ְ�, Dav Off �����Ǿ� �ִ� ��� (Default �� : Dav on) "				>> ./$RES_LAST_FILE 2>&1
echo "��ȣ : 'Limit', 'LimitExcept'�� PUT, DELETE �� ���ʿ��� �޼ҵ尡 �������� ���� ���"					>> ./$RES_LAST_FILE 2>&1
echo "��� : TraceEnable On ���� �Ǿ� �ְ�, Dav On �����Ǿ� �ִ� ��� (Default �� : Dav on)"				>> ./$RES_LAST_FILE 2>&1
echo "��� : 'Limit', 'LimitExcept'�� PUT, DELETE �� ���ʿ��� �޼ҵ尡 ������ ���"							>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE011 ##"
echo "##### WA-011 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-011 �α� ���� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "---------------< ErrorLog (��������)>---------------"													>> ./$RES_LAST_FILE 2>&1
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
echo "---------------< CustomLog (��������) >---------------"												>> ./$RES_LAST_FILE 2>&1
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
echo "----------< Combined�� ���� ��� LogFormat �κ� Ȯ�� >----------"           							>> ./$RES_LAST_FILE 2>&1
(cat $HTTPD_CONF | grep -v '#' | grep LogFormat)       														>> ./$RES_LAST_FILE 2>&1



echo "1.1  ������ �α׷����� ����Ͽ� �α��ϴ��� Ȯ��"														>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : �α����� ���� ���� combined �̰ų�, �Ʒ� LogFormat ���þ ���� �Ǿ� ���� ���"				>> ./$RES_LAST_FILE 2>&1
echo "      LogFormat %h %l %u %t \%r\ %>s %b \%{Referer}i\ \{User-agent}i\ "							>> ./$RES_LAST_FILE 2>&1
echo "��� : �α����� ���� ���� combined �� �ƴϰų�, �Ʒ� LogFormat ���þ ���� �Ǿ� ���� ���� ���"		>> ./$RES_LAST_FILE 2>&1
echo "      LogFormat %h %l %u %t \%r\ %>s %b \%{Referer}i\ \{User-agent}i\ "							>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1




echo "## LINUX_APACHE012 ##"
echo "##### WA-012 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-012 ���� ���ε� �� �ٿ�ε� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
if [ `grep -n -i options $HTTPD_CONF | grep -v '#' | grep -i limitrequestbody | wc -l` -ge 1 ]; then
echo "@ OK"																						>> ./$RES_LAST_FILE 2>&1
grep -n -i limitrequestbody $HTTPD_CONF | grep -v '#'											>> ./$RES_LAST_FILE 2>&1
else
echo "No limit capacity to upload and download"													>> ./$RES_LAST_FILE 2>&1
fi
echo " " 																									>> ./$RES_LAST_FILE 2>&1	
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "1.1  ���� ���ε� �� �ٿ�ε� �뷮���� Ȯ��"															>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : limitrequestbody �� ���� ���� ���ε� �� �ٿ�ε� �뷮�� �����ϴ� ���"							>> ./$RES_LAST_FILE 2>&1
echo "��� : ���� ���ε� �� �ٿ�ε� �뷮�� ���Ѿ��� ���"													>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE013 ##"
echo "##### WA-013 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-013 �� ���� ������ �и� ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  �� ���񽺸� ���� ���ϵ��� ���� ����� �ٸ� ������ �����ϴ��� Ȯ��"									>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : �� ���� ���ϰ� Apache ������ �ٸ� ������ �и� �Ǿ� ���� ���"									>> ./$RES_LAST_FILE 2>&1
echo "��� : �� ���� ���ϰ� Apache ������ �ٸ� ������ �и� �ȵǾ� ���� ���"								>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
rm -rf u-58.txt
rm -rf u-59.txt






echo "## LINUX_APACHE014 ##"
echo "##### WA-014 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-014 ���� ���͸� ���� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo "##### allowoveride #####"																			>> ./$RES_LAST_FILE 2>&1

echo "---------------< �������� >---------------"														>> ./$RES_LAST_FILE 2>&1
cat $HTTPD_CONF | grep -v '#' | grep -i allowoverride													>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : allowoveride�� None �Ǵ� authconfig�� �����Ǿ��ִ� ���"										>> ./$RES_LAST_FILE 2>&1
echo "��� : allowoveride�� ��ȣ �̿ܿ� �ٸ� ������ ������ ���"											>> ./$RES_LAST_FILE 2>&1
echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1





echo "## LINUX_APACHE015 ##"
echo "##### WA-015 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-015 ���� �޽��� ���� ###############"														>> ./$RES_LAST_FILE 2>&1
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

echo "1.1  �⺻ ������������ �ƴ� ����� ������ ������������ ����ϴ��� Ȯ��"									>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : [1],[2] ���� ��� ���� ���"																	>> ./$RES_LAST_FILE 2>&1
echo "		+ [1] ��������� ErrorDocument ������ �Ǿ� ���� ���"											>> ./$RES_LAST_FILE 2>&1
echo "		+ [2] [1]�� ���������� ��ο� �ִ� ������ ���� ���"											>> ./$RES_LAST_FILE 2>&1
echo "��� : [1],[2] ���� �� �ϳ��� ������ ���"															>> ./$RES_LAST_FILE 2>&1
echo "		+ [1] ��������� ErrorDocument ������ �ȵǾ� ���� ���"										>> ./$RES_LAST_FILE 2>&1
echo "		+ [2] [1]�� url ��ο� �ִ� ������ ���� ���"													>> ./$RES_LAST_FILE 2>&1

echo "##### END #####" 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1



echo "## LINUX_APACHE016 ##"
echo "##### WA-016 #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### START #####"																					>> ./$RES_LAST_FILE 2>&1
echo "##### WA-016 �ֽ� ��ġ ���� ###############"														>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
$HTTP_CONF -v								 															>> ./$RES_LAST_FILE 2>&1
$APACHE_CONF -v 																						>> ./$RES_LAST_FILE 2>&1
apachectl -v								 															>> ./$RES_LAST_FILE 2>&1

echo "1.1  �ֽź�����ġ ����Ȯ��"																			>> ./$RES_LAST_FILE 2>&1

echo "��ȣ : �ֱ������� ��ġ�� �����ϴ� ���"																>> ./$RES_LAST_FILE 2>&1
echo "��� : �ֱ������� ��ġ�� �������ϴ� ���"																>> ./$RES_LAST_FILE 2>&1
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
echo "##### ��������(cat httpd.conf) ###############"														>> ./$RES_LAST_FILE 2>&1														>> ./$RES_LAST_FILE 2>&1
cat $HTTPD_CONF 																						>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1
echo " " 																									>> ./$RES_LAST_FILE 2>&1

echo "##### �ܺ� �������� (find *.conf) ###############"														>> ./$RES_LAST_FILE 2>&1
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