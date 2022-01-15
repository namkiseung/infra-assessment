
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
echo "################# Tomcat ���� ��ũ��Ʈ�� �����ϰڽ��ϴ� ###################"
echo ""
echo ""

alias ls=ls
alias grep=/bin/grep

echo '[Tomcat ���� Ȯ��]'
echo ''
ps -ef |grep -i tomcat |grep -v grep
echo ''
echo '[env ����]'
env | grep TOMCAT   
echo ''                                                                   
echo '[���� Tomcat ��ġ ���]'
#ps -ef |grep -i  tomcat|awk -F'home' '{print $2}'|awk '{print $1}'|grep =|tail -1
ps -ef |grep -i tomcat |awk -F'home' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'
echo ''
#echo '[���� ���� conf���� ���]' 
#ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / 


#echo '[���� ���� conf���� ���]' >> $CREATE_FILE_RESULT 2>&1
#ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / >> $CREATE_FILE_RESULT 2>&1
#echo '' >> $CREATE_FILE_RESULT 2>&1
#echo '' >> $CREATE_FILE_RESULT 2>&1
#/svc/was/tomcat6.0.20/Svr1
#/svc/was/tomcat6.0.20/Svr2
echo ''
echo '' >> $CREATE_FILE_RESULT 2>&1
echo ''
echo "�� �� ������ Ȯ���Ͻð� Tomcat ��ġ ���͸��� �Է��Ͻʽÿ�. "
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
               echo "   �Է��Ͻ� ���͸��� �������� �ʽ��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
               echo " "
         fi
    else
         echo "   �߸� �Է��ϼ̽��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
         echo " "
   fi
done

#echo '[���� Tomcat ��ġ ���]' >> $CREATE_FILE_RESULT 2>&1
#ps -ef |grep -i tomcat|awk -F'home' '{print $2}'|awk '{print $1}'|grep =|tail -1 >> $CREATE_FILE_RESULT 2>&1
#ps -ef |grep -i tomcat|awk -F'home' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
echo ''



#Dcatalina.Base
bcount=`ps -ef |grep -i tomcat |awk -F'base' '{print $2}'|awk '{print $1}'|awk -F'=' '{print $2}'|grep / |wc -l`


#Dcatalina.Base ���
if [ $bcount -gt 5 ]
	then
	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
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
	#	echo 'Dcatalina.Base�� ����' >> $CREATE_FILE_RESULT 2>&1
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
echo "  ��  Launching Time: `date`                                                                      " >> $CREATE_FILE_RESULT 2>&1
echo "  ��  Result File: $CREATE_FILE_RESULT                                                            " >> $CREATE_FILE_RESULT 2>&1
echo "  ��  Hostname: `hostname`                                                                        " >> $CREATE_FILE_RESULT 2>&1
ipadd=`ifconfig -a | grep "inet " | awk -F":" '{i=1; while(i<=NF) {print $i; i++}}' | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | egrep "^[1-9]" | egrep -v "^127|^255|255$"`
echo "  ��  ip address: `echo $ipadd`                                                                        " >> $CREATE_FILE_RESULT 2>&1
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
echo ' 1.1 ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat�� ������ root ���� ���� WAS ���� �������� �������̸� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
ps -ef |grep -i tomcat |grep -v "Tomcat_script" | grep -v "grep" >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

if [ `ps -ef | grep -i tomcat | grep -v "Tomcat_script" | grep -v "grep" | grep -v "root" | wc -l` -eq 0 ]
	then
        	result2_1='�� ���'
else
	result2_1='�� ��ȣ'
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
echo '�� Tomcat�� ������ root ���� ���� WAS ���� �������� �����Ͽ� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $result2_1  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0101 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 1.2 =============================='
echo "0102 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.2 �������� ���丮 ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���� ���� Ȩ���丮 �۹̼��� WAS���� ���� �����̸� 750���� �����Ǿ� �ִ°�� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1


echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[ �������� ]' >> $CREATE_FILE_RESULT 2>&1
echo '���(���� 6.x, 7.x) : '$tomcat'/webapps' >> $CREATE_FILE_RESULT 2>&1
ls -alL $tomcat/webapps |grep manager >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '���(���� 4.x, 5.x) : '$tomcat'/server/webapps' >> $CREATE_FILE_RESULT 2>&1
ls -alL $tomcat/server/webapps |grep manager >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

if [ `ls -alL $tomcat/webapps |grep manager|grep -v '.r...-.---'|wc -l ` -eq 0 ]
	then
	sresult2_2='�� ��ȣ'
else
	sresult2_2='�� ���'
fi

echo '�� ���� ���� Ȩ���丮 �۹̼��� 750���Ϸ� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $sresult2_2 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0102 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.3 =============================='
echo "0103 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.3 �������� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat �������� �۹̼��� WAS���� ���� �����̸� 600 �Ǵ� 700���� �����Ǿ� �ִ� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

cresult2_32='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
	#for folder in $confall
	#	do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/ >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/conf/|egrep ".xml|.properties|.policy"|grep -v 'd.........' >> $CREATE_FILE_RESULT 2>&1
					if [ `ls -alL $tomcat/conf/|egrep ".xml|.properties|.policy"|grep -v 'd.........'|grep -v '....------'|wc -l` -gt 0 ]
						then
							cresult2_32='�� ���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
	#done
#fi

echo '�� Tomcat conf ���͸� ������ �������� �۹̼��� 600 �Ǵ� 700���Ϸ� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult2_32 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0103 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 1.4 =============================='
echo "0104 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.4 ���丮 �˻� ��� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'web.xml������ listing������ false�� �����Ǿ������� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1


cresult1_8='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/web.xml >> $CREATE_FILE_RESULT 2>&1
					mcount=`cat $tomcat/conf/web.xml|grep -v '!--'|grep -n ' '|grep listing|awk -F':' '{print $1}'`
					mcount=`expr $mcount + 1`
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep listing|awk -F':' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep $mcount|head -1|awk -F':' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep $mcount|head -1|awk -F':' '{print $2}'|awk -F'>' '{print $2}'|awk -F'<' '{print $1}'` = 'true' ]
						then
							cresult1_8='�� ���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�� ���丮 ���� �� �ֿ� ���������� ������ ���� ��ų �� �ִ� listing ���� �� false�� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_8 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0104 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.5 =============================='
echo "0105 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.5 �α� ���丮/���� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '�α� ���丮 �۹̼� WAS���� ���� �����̸� 750, �α� ���� �۹̼� 640���� �����Ǿ� �ִ� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1


result2_55='��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					log=`cat $tomcat/conf/server.xml|grep -v '!--'|grep -n ' '|grep 'valves.AccessLog'|awk -F'"' '{print $4}'`
					if [ `ls -alL $tomcat|grep $log|grep -v '.....-.---'|wc -l` -gt 0 ]
					then
							result2_55='���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi



result2_5='��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					log=`cat $tomcat/conf/server.xml|grep -v '!--'|grep -n ' '|grep 'valves.AccessLog'|awk -F'"' '{print $4}'`
                    echo '| Log ���丮 |' $tomcat/$log >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/$log >> $CREATE_FILE_RESULT 2>&1
					if [ `ls -alL $tomcat/$log|grep -v 'd.........' |grep -v 'total'|grep -v '...-.-----'|wc -l` -gt 0 ]
					then
							result2_5='���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

#if [ \( $result2_55 = "���" \) -o \( $result2_5 = "���" \) ]
#	then
#		result2_555='�� ���'
#	else
#		result2_555='�� ��ȣ'
#fi



echo '�� �α����� �۹̼��� 640����, ���丮 750���Ϸ� ������ �ǰ���.'>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $result2_555 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0105 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.6 =============================='
echo "0106 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.6 �α� ���� ���� '  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '�α� ���� ������  combined�� �Ǿ� ������ ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1


cresult1_5='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/server.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/server.xml | grep -v '\-\-'| grep -v '#' | grep 'pattern=' | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '^pattern' >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/server.xml | grep -v '\-\-'| grep -v '#' | grep 'pattern=' | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}' | grep '^pattern' | grep -i 'combined'| wc -l` -eq 0 ]
						then
							cresult1_5='�� ���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�� �α� ������ combined�� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_5 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0106 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.7 =============================='
echo "0107 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.7 �α� ���� �ֱ� '  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���� ������ �ּ� �α� ���� �Ⱓ��� ��� �� �����ϰ� ������ ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ���ͺ� ���� : ����� ���ͺ並 ���ؼ� �α������ֱ� �� ����, �����Ȳ �ľ� �ʿ�' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0107 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.8 =============================='
echo "0108 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.8 HTTP Method ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'HTTP Method�� GET, POST, HEAD, OPTIONS�� ���Ǿ� �ִ°�� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

cresult1_7='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/web.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ''|grep -i forbidden  >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ''|grep -i method >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ''|grep -i method | egrep -i "put|delete|trace"|wc -l` -lt 3 ]
						then
							cresult1_7='�� ���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�� web.xml ���Ͽ��� PUT, DELETE, TRACE Method ������ ����' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_7 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0108 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '============================== 1.9 =============================='
echo "0109 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.9 Session Timeout ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'Session Timeout 30�� �̳��� ���� (Default = 30) ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

cresult1_9='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/web.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep -n ' '|grep session-timeout|awk -F':' '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					if [ `cat $tomcat/conf/web.xml|grep -v '\!\-\-'|grep session-timeout|awk -F">" '{print $2}'|awk -F"<" '{print $1}'` -gt 30 ]
						then
							cresult1_9='�� ���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�� Session Timeout 30�� �̳��� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $cresult1_9 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0109 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 2.1 =============================='
echo "0201 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.1 ���ʿ��� Examples ���� �� ���͸� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '��� ���ʿ��� examples ���丮�� ���� �Ǿ� ������ ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

result3_1='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/webapps/ >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/webapps/|grep 'd.........' >> $CREATE_FILE_RESULT 2>&1
					if [ `ls $tomcat/webapps|grep -w examples|wc -l` -ge 1 ]
						then
							result3_1='�� ���'
					else
						echo $tomcat/webapps/examples/ '���丮 ����' >> $CREATE_FILE_RESULT 2>&1
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�� example ���丮�� ���ʿ�� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo $result3_1 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0201 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 2.2 =============================='
echo "0202 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.2 ���μ��� ������� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '���ʿ��� ���μ��� ���� ���丮�� ���� �Ǿ� ������ ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

result3_2='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat >> $CREATE_FILE_RESULT 2>&1
					find $tomcat -name catalina-manager.jar  >> $CREATE_FILE_RESULT 2>&1
					if [ `find $tomcat -name catalina-manager.jar|wc -l` -ge 1 ]
						then
							result3_2='�� ���'
					else
						echo $tomcat/'catalina-manager.jar ���� ����' >> $CREATE_FILE_RESULT 2>&1
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�� Tomcat ��ġ�� ������ ���μ��� ���� ����� ���󿡼� �����ϹǷ� catalina-manager.jar ���� ����' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo  $result3_2 >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0202 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 3.1 =============================='
echo "0301 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 3.1 ���� ��ġ ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '���� ħ�� ������ ���� �ֱ������� �ֽ� ��ġ ���� �۾��� ����ǰ� ������ ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[ �������� Tomcat Version ]'  >> $CREATE_FILE_RESULT 2>&1
sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}' >> $CREATE_FILE_RESULT 2>&1

ver=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'`
ver1=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'|awk -F'.' '{print $1}'`
ver2=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'|awk -F'.' '{print $2}'`
ver3=`sh $tomcat/bin/version.sh |grep version|awk -F':' '{print $2}'|awk -F'/' '{print $2}'|awk -F'.' '{print $3}'`


#if [ $ver1 -eq 8 -a $ver2 -eq 0 ]
#	then
#	if [ $ver3 -ge 50 ]
#		then 
#			result4_11='�� ��ȣ'
#	fi
#fi			
#if [ $ver1 -eq 7 -a $ver2 -eq 0 ]
#	then
#	if [ $ver3 -ge 51 ]
#		then 
#			result4_11='�� ��ȣ'
#		else
#			result4_11='�� ���'
#	fi
#fi			
#if [ $ver1 -eq 6 -a $ver2 -eq 0 ]
#	then
#	if [ $ver3 -ge 37 ]
#		then
#			result4_11='�� ��ȣ'
#		else
#			result4_11='�� ���'
#	fi
#fi
#if [ $ver1 -eq 5 -a $ver2 -eq 5 ]
#	then
#	if [ $ver3 -ge 35 ]
#		then
#			result4_11='�� ��ȣ'
#		else
#			result4_11='�� ���'
#	fi
#fi

echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[�ֽ� ����]' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 9.0.x	9.0.05' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 8.5.x	8.5.28' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 8.0.x	8.0.50' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 7.0.x	7.0.85' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 6.0.x	6.0.37' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 5.5.x	5.5.35' >> $CREATE_FILE_RESULT 2>&1
echo 'Tomcat 5.5���� �̸��� ������� �Ϸ�� ���� ��ġ ���� ����' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ���⵵ �� ���� �ֽ� ��ġ ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#echo $result4_11  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0301 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.1 =============================='
echo "0401 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.1 ������ �ܼ� ��������'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���ʿ��� ���, Tomcat ������ �ܼ� ��� �����Ǿ� �ְ�, �ʿ��� ��� Default Port �����ؼ� ����ϴ� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '1) Tomcat ������ �ܼ� Ȯ��'  >> $CREATE_FILE_RESULT 2>&1

cresult4_1_1='��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/webapps |grep -w manager >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/webapps |grep -w admin >> $CREATE_FILE_RESULT 2>&1
					#find $tomcat -name admin.xml >> $CREATE_FILE_RESULT 2>&1
					#find $tomcat -name manager.xml >> $CREATE_FILE_RESULT 2>&1
					if [ \( `ls -alL $tomcat/webapps |grep -w manager |wc -l` -ge 1 \) -o \( `ls -alL $tomcat/webapps |grep -w admin |wc -l` -ge 1 \) ]
						then
							cresult4_1_1='���'
					else
						echo 'admin.xml, manager.xml ���� ����' >> $CREATE_FILE_RESULT 2>&1
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

if [ $cresult4_1_1 = "���" ]
then
echo '2) Default ��Ʈ(8080) Ȯ��'  >> $CREATE_FILE_RESULT 2>&1

cresult4_1_2='��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/server.xml >> $CREATE_FILE_RESULT 2>&1
					cat $tomcat/conf/server.xml |grep 'Connector port'|grep -v '#'|awk -F" " '{print $2}' >> $CREATE_FILE_RESULT 2>&1
					#if [ `cat $tomcat/conf/server.xml |grep 'Connector port'|awk '{print $2}'|awk -F'"' '{print $2}'` = '8080' ]
					if [ `cat $tomcat/conf/server.xml |grep 'Connector port'|grep -v '#'|awk '{print $2}'|grep 8080|wc -l` -ge 1 ]
						then
							cresult4_1_2='���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi
fi

if [ $cresult4_1_1 = "���" ]
	then
		if [ $cresult4_1_2 = "���" ]
			then
				result44_1='�� ���'
		else
			result44_1='�� ��ȣ'
		fi
else
	result44_1='�� ��ȣ'
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[���� ���]' >> $CREATE_FILE_RESULT 2>&1	
echo '(�� 1) telnet 127.0.0.1 8080 ���� ���� �� GET http://127.0.0.1/admin/ HTTP/1.0�� ��û �� 200 OK(Tomcat���� ��������)�� ���� ��� ���' >> $CREATE_FILE_RESULT 2>&1	
echo '(�� 2) telnet 127.0.0.1 8080 ���� ���� �� GET http://127.0.0.1/manager/ HTTP/1.0�� ��û �� 200 OK(Tomcat���� ��������)�� ���� ��� ���' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	
echo '�� ���ʿ��� ���, Tomcat ������ �ܼ� ��� �����ϰ�, �ʿ��� ��� Default Port ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	

#echo $result44_1  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0401 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.2 =============================='
echo "0402 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.2 ������ default ������ ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '������ �ܼ� default ������ ������ �������� �����Ͽ� ����ϰų�' >> $CREATE_FILE_RESULT 2>&1
echo 'default ������ ���� �Ǵ� �ּ�ó�� �Ǿ� �ִ� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					awk '/<tomcat-users>/,/<\/tomcat-users>/' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�� ������ �ܼ� default �������� ���� ���� �������� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	

echo '�� N/A'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0402 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.3 =============================='
echo "0403 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.3 ������ �н����� ��ȣ��å'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '�н����� ���� ��å�� �°� ������̸� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '4���� ���� �� 3���� �̻��� �����Ͽ� �ּ� 8�ڸ��̻� �Ǵ�' >> $CREATE_FILE_RESULT 2>&1
echo '4���� ���� �� 2���� �̻��� �����Ͽ� �ּ� 10�ڸ� �̻����� ��� ���̸� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					awk '/<tomcat-users>/,/<\/tomcat-users>/' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi

echo '�н����� ���� ��å�� �°� ����/����/Ư������ �� 3���� �̻� ��������' >> $CREATE_FILE_RESULT 2>&1	
echo '8�ڸ� �̻��� ���̷� ���� �Ǵ� 2���� �̻� 10�ڸ� �������� ����' >> $CREATE_FILE_RESULT 2>&1	
echo ' ' >> $CREATE_FILE_RESULT 2>&1	

echo '�� N/A'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0403 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 4.4 =============================='
echo "0404 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 4.4 tomcat-users.xml ���� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '�н����� ����(tomcat-users.xml)�� WAS���� ���� �����̸�, �۹̼��� 600�̸� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

result4_4='�� ��ȣ'

#if [ $bcount -gt 9 ]
#	then
#	echo 'Dcatalina.Base�� �ʹ� ���� ���������Ͻñ� �ٶ��ϴ�.'
#	bcount=10
#else
#	for folder in $confall
#		do
			if [ -d $tomcat ]
				then
					echo '[ Tomcat ���� ���丮 ]' $tomcat/conf/tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					ls -alL $tomcat/conf|grep tomcat-users.xml >> $CREATE_FILE_RESULT 2>&1
					if [ `ls -alL $tomcat/conf|grep tomcat-users.xml|grep -v '...-------'|wc -l` -ge 1 ]
						then
							result4_4='�� ���'
					fi
					echo '' >> $CREATE_FILE_RESULT 2>&1
					echo '' >> $CREATE_FILE_RESULT 2>&1
			fi
#	done
#fi


echo '�� �н����� ����(tomcat-users.xml) �۹̼� 600���� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

#echo $result4_4  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0404 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' =================== �� ���� server.xml ==================='  >> $CREATE_FILE_RESULT 2>&1
cat $tomcat/conf/server.xml  >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '****************************** End ***********************************' 
#end script