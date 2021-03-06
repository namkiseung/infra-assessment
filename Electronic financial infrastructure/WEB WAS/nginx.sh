LANG=C
export LANG



echo "*************************************************************"		
echo "******** Logthink System Checklist for NginX ver 1.0 *********"		 
echo "*******  Copyright 2018 Logthink. All right Reserved  ********"			
echo "*************************************************************"		
DATE=`date +%Y-%m-%d`
echo " "
NginX_EXE=`ps -ef | grep -i nginx | egrep -v 'awk|grep' | awk -F' ' '{print $11}' | sed '/^$/d'`
NginX_CONF='/etc/nginx/nginx.conf'
NginX_ETC='/etc/nginx'
NginX_MAIN='nforum.conf'

echo "NginX Confing ================> $NginX_CONF"

if [ ! -f $NginX_CONF ]; then
	echo ""
	echo "nginx config file : Ex) /etc/nginx/nginx.conf"
	read NginX_CONF
	echo ""
	
	echo "nginx config directory : Ex) /etc/nginx"
	read NginX_ETC
	echo ""
	
	if [ ! -f $NginX_CONF ]; then
		echo ""
		echo "******************* ERROR *******************"
		echo "*** Web entered incorrectly. Please re-run"
		echo "******************* ERROR *******************"
		echo ""
		exit 0
	fi
fi


legacy=0
if [ `cat $NginX_CONF | egrep 'root|location' | wc -l` -ge 2 ]; then
	echo 'NginX legacy version'
	NginX_HOME=`cat $NginX_CONF | grep root | grep -v '#'| awk -F' ' '{print $2}' | sed 's/\;//g'`
	legacy=1
else
	NginX_HOME=`cat $NginX_ETC/conf.d/$NginX_MAIN | grep root | awk -F' ' '{print $2}' | sed 's/\;//g'`
fi


NginX_ErrorLog=`cat $NginX_CONF | grep error_log | awk -F' ' '{print $2}' | sed 's/\;//g'`
NginX_AccessLog=`cat $NginX_CONF | grep -i access_log | awk -F 'access_log' '{print $2}' | awk -F' ' '{print $1}' | sed 's/\;//g'`

HOSTNAME=`hostname`

RES_LAST_FILE=NginX_${HOSTNAME}_${DATE}.asvd

echo "*************************************************************"			> ./$RES_LAST_FILE 2>&1	
echo "******** Logthink System Checklist for NginX ver 1.0 *********"		 >> ./$RES_LAST_FILE 2>&1		
echo "*******  Copyright 2018 Logthink. All right Reserved  ********"			>> ./$RES_LAST_FILE 2>&1	
echo "*************************************************************"			>> ./$RES_LAST_FILE 2>&1

echo "* Start Time "							                      	>> ./$RES_LAST_FILE 2>&1
date 							                               		>> ./$RES_LAST_FILE 2>&1
echo " "						                             				>> ./$RES_LAST_FILE 2>&1

os=`uname`


# Support "echo -n " in SunOS Envrionment
if [ "$os" = "SunOS" ]; then
	alias echo=/usr/ucb/echo
fi

if [ \( "$os" = "AIX" \) -o \( "$os" = "SunOS" \) ]; then
	alias ifconfig=/usr/sbin/ifconfig
fi

IP=`netstat -in | grep -v "127" | awk ' { print $4; } ' | egrep '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1`
OS_VERSION="uname -a"
OS_TYPE=NGINX_LINUX

echo WEBSERVER NGINX_LINUX HeaderInfo {Logthink{ >> ./$RES_LAST_FILE 2>&1 

echo -e " ** ASVD_INFO:  NGINX_LINUX" >> ./$RES_LAST_FILE 2>&1
echo " ** Start_time:\t\t" `date` >> ./$RES_LAST_FILE 2>&1
echo " ** HOSTNAME:\t\t " $HOSTNAME >> ./$RES_LAST_FILE 2>&1
echo " ** IP ADDRESS:\t\t " $IP >> ./$RES_LAST_FILE 2>&1
echo " ** OS TYPE:\t\t " $OS_TYPE >> ./$RES_LAST_FILE 2>&1
echo " ** OS VERSION:\t\t " `$OS_VERSION` >> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 

echo ""	>> ./$RES_LAST_FILE 2>&1
echo "" >> ./$RES_LAST_FILE 2>&1



echo "***************************** Start **********************************"
echo WEBSERVER NGINX_LINUX NGINXLINUX001 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 1-01 ???????????? ???????????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
	ps -ef | grep -i nginx | grep -v grep 								                    >> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 1-01 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1


echo WEBSERVER NGINX_LINUX NGINXLINUX002 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 1-02 ???????????? ?????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	ls -al $NginX_ETC                                    >> ./$RES_LAST_FILE 2>&1	
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 1-02 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1


echo WEBSERVER NGINX_LINUX NGINXLINUX003 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 1-03 ??????/???????????? ?????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "---------------< source file >---------------"				>> ./$RES_LAST_FILE 2>&1
	ls -aRl $NginX_HOME                                                                 >> ./$RES_LAST_FILE 2>&1
echo "---------------< config file >---------------"				>> ./$RES_LAST_FILE 2>&1
	ls -al $NginX_CONF                                                         >> ./$RES_LAST_FILE 2>&1
	ls -al $NginX_ETC/conf.d                                                            >> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 1-03 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX004 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 1-04 ?????? ????????????/?????? ?????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
echo "---------------< Error Log >---------------"				>> ./$RES_LAST_FILE 2>&1
	ls -aRl $NginX_ErrorLog	                                    >> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
echo "---------------< Access Log >---------------"				>> ./$RES_LAST_FILE 2>&1
	ls -aRl $NginX_AccessLog                                                            >> ./$RES_LAST_FILE 2>&1
	ls -aRl /var/log/nginx                                                            >> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 1-04 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX005 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 2-01 ???????????? ????????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	cat $NginX_CONF | grep -i autoindex	                                    >> ./$RES_LAST_FILE 2>&1	
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 2-01 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX006 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 2-02 Folowsymlinks ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	cat $NginX_CONF | grep -i "disable_symlinks"                                  >> ./$RES_LAST_FILE 2>&1	
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 2-02 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX007 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 2-03 ?????? ????????? ???????????? ????????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	cat $NginX_CONF | grep -i "server_tokens"                                  >> ./$RES_LAST_FILE 2>&1	
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 2-03 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX008 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 2-04 HTTP ????????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	cat $NginX_CONF | grep -i "limit_except" -A3                                  >> ./$RES_LAST_FILE 2>&1	
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 2-04 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX009 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 2-05 ?????? ?????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	cat $NginX_CONF | egrep -i "error_log|access_log"                                  >> ./$RES_LAST_FILE 2>&1
	cat $NginX_CONF | grep -i "log_format" -A5                                      >> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 2-05 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX010 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 2-06 ?????? ????????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	if [ $legacy -ge 1 ] ; then
		cat $NginX_CONF | grep -i "error_page" -A3										>> ./$RES_LAST_FILE 2>&1
	else
		cat $NginX_ETC/conf.d/$NginX_MAIN | grep -i "error_page" -A3                                  >> ./$RES_LAST_FILE 2>&1
	fi

echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 2-06 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

echo WEBSERVER NGINX_LINUX NGINXLINUX011 {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo "##### 3-01 ?????? ?????? ?????? ###############"								>> ./$RES_LAST_FILE 2>&1
echo " "																			>> ./$RES_LAST_FILE 2>&1
	`echo $NginX_EXE -v`                                                              >> ./$RES_LAST_FILE 2>&1	
	nginx -v                                                              >> ./$RES_LAST_FILE 2>&1	
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo "##### 3-01 Checked ###############"
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1






echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo }Logthink} >> ./$RES_LAST_FILE 2>&1 
echo WEBSERVER NGINX_LINUX ETC {Logthink{ >> ./$RES_LAST_FILE 2>&1 
echo "================== ETC ========================"				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
	echo "##### nginx.conf ###############"			>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
	cat $NginX_CONF											>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1
echo " " 																				>> ./$RES_LAST_FILE 2>&1

if [ $legacy -eq 0 ]; then
	echo " " 																				>> ./$RES_LAST_FILE 2>&1
		ConfFile=`find $NginX_ETC/conf.d`
		for dir in $ConfFile
		do
			echo "##### $dir #############" 											>> ./$RES_LAST_FILE 2>&1
			cat $dir												                        >> ./$RES_LAST_FILE 2>&1
			echo " " 																				>> ./$RES_LAST_FILE 2>&1
			echo " " 																				>> ./$RES_LAST_FILE 2>&1
			echo " " 																				>> ./$RES_LAST_FILE 2>&1
			echo " " 																				>> ./$RES_LAST_FILE 2>&1
		done
	echo " " 																				>> ./$RES_LAST_FILE 2>&1
	echo " " 																				>> ./$RES_LAST_FILE 2>&1
	echo " " 																				>> ./$RES_LAST_FILE 2>&1
	echo " " 																				>> ./$RES_LAST_FILE 2>&1
fi

cat /etc/nginx/conf.d/nforum.conf																				>> ./$RES_LAST_FILE 2>&1



echo "================== End of Script ========================"				>> ./$RES_LAST_FILE 2>&1
echo " "
echo "================== End of Script ========================"
echo " "															>> ./$RES_LAST_FILE 2>&1
exit 0


