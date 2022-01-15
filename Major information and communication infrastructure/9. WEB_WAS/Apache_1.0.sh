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
echo "################# Apache ���� ��ũ��Ʈ�� �����ϰڽ��ϴ� ###################"
echo ""
echo ""

alias ls=ls
alias grep=/bin/grep

echo '[Apache ���� Ȯ��]'
echo ''
ps -ef | grep -v grep | grep httpd | grep -v grep
echo ''

echo '[env ����]'
env | grep APACHE
echo ''             

echo '[Apache httpd.conf ���]'

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
	  echo 'Apache�� �������� �ʽ��ϴ�.'
      exit
fi

echo ''

echo "�� �� ��θ� �����Ͽ� ������� httpd.conf ���� ��θ� �Է��Ͻʽÿ�. "

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
			echo "   �Է��Ͻ� ��ΰ� �������� �ʽ��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
			echo " "
	   fi
	else
		echo "   �߸� �Է��ϼ̽��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
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
echo '============================== 1.1 ===================================='
echo "0101 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.1 ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���� ������ root�� �ƴ� ������ ���� �������� ������' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
ps -ef |grep httpd |grep -v grep >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[httpd.conf ����]' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep 'User ' |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep 'Group ' |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
if [ `ps -ef |grep httpd |grep -v grep| wc -l` -eq 0 ]
	then 
		result1='���'
fi
if [ `ps -ef | grep httpd | grep -v grep | grep -v root | wc -l` -eq 0 ]
		then
                        	result1='���'
	elif [ `ps -ef |grep httpd | grep -v grep | grep root | wc -l` -ge 3 ]
		then
			result1='���'
	else
		result1='��ȣ'
		
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
echo '�� Apache�� ���μ����� root ���� ���� WEB ���� ���� �������� ������ ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#if [ $result1 = '���' ]
#	then
#		echo '�� ��� - ���� ����' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��ȣ - ���� ����' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0101 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.2 ===================================='
echo "0102 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.2 �������� ���丮 ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'Server Root�� ������ ������� �����̸� 750������ �۹̼��� �ο��Ǿ��ִ��� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep ServerRoot |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
seroot=`cat $conf/httpd.conf |grep ServerRoot |grep -v '#'|awk -F'"' '{print $2}'`

echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[ ServerRoot ]' $seroot >> $CREATE_FILE_RESULT 2>&1
ls -alL $seroot|grep '.r........'|head -1 >> $CREATE_FILE_RESULT 2>&1
sresult2=`ls -alL  $seroot|grep '..........'|head -1|awk '{print $1}'`

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� �������� ���丮�� �Ϲ� ����ڰ� ������ �� ������ 750 ���� ���� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ `ls -alL $seroot|grep '..........'|head -1|grep -v '.....-.---'|wc -l` -gt 0 ]
#	then
#	echo '�� ��� - �������� ���丮 ���� ����' >> $CREATE_FILE_RESULT 2>&1
#else
#	echo '��	��ȣ - �������� ���丮 ���� ����' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0102 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.3 ================================'
echo "0103 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.3 �������� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���������� ������ ������� �����̸� 600 �Ǵ� 700������ �۹̼��� �ο��Ǿ��ִ��� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[Include ��������]' >> $CREATE_FILE_RESULT 2>&1
cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
result3='��ȣ'
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
						result3='���'
				fi
			else
				ls -alL $conpath >> $CREATE_FILE_RESULT 2>&1
		fi
done

echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '[��������]' >> $CREATE_FILE_RESULT 2>&1

ls -alLR $conf >> $CREATE_FILE_RESULT 2>&1

if [ `ls -alLR $conf | grep '\.conf*'| grep -v '....------'|wc -l` -gt 0 ] 
	then
		result3='���'
fi




echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ ���� ���� ������ 600 �Ǵ� 700 ���Ϸ� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ \( $result3 = '��ȣ' \) ]
#	then
#		echo '�� ��ȣ - �������� ���� ����' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��� - �������� ���� ����' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0103 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.4 ===================================='
echo "0104 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.4 ���丮 �˻� ��� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '<Directory>��忡 �ο��� Indexes�ɼ��� �����ϵ��� �ǰ���' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-autoindex.conf ���� include ����]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result4='��ȣ'
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
		echo "httpd-autoindex.conf ������ include �Ǿ� ���� ����" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
	

#Start
#Include
if [ \( $incOX = 'O' \) ]
	then
		echo '[httpd-autoindex.conf - index ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $index ]
			then
				cat $index |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| Indexes|</Directory' >> $CREATE_FILE_RESULT 2>&1
				if [ `cat $index |grep -v '#'|grep -i ' Options' |grep -i ' Indexes'| wc -l` -eq 0 ]
					then
						echo 'Indexes �ɼ� ������ ����' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						result4='���'
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi
		fi
fi
	
#httpd.conf
echo '[httpd.conf - index ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		cat $conf/httpd.conf |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| Indexes|</Directory' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $conf/httpd.conf |grep -v '#'|grep -i ' Options'|egrep -i ' Indexes' | wc -l` -eq 0 ]
			then
				echo 'Indexes �ɼ� ������ ����' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				result4='���'
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi
fi
#End


echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ ���� ���Ͽ��� ����丮 �˻� ��� ���Ÿ� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $incOX = 'X' \) ]
#	then
#		echo "httpd-autoindex.conf ������ include �Ǿ� ���� ����" >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0104 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1






echo '============================== 1.5 ===================================='
echo "0105 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.5 �α� ���丮/���� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'Log�� ��� Ȯ���Ͽ� �ش� Log���丮�� �۹̼��� ������ ������� �����̸� 750�����̰ų� �α����� �۹̼��� 640�������� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-vhosts.conf ���� include ����]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result5='��ȣ'
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
		echo "httpd-vhosts.conf ������ include �Ǿ� ���� �ʽ��ϴ�." >> $CREATE_FILE_RESULT 2>&1
fi
echo "" >> $CREATE_FILE_RESULT 2>&1

#�켱���� �Ǻ�
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
	echo '[httpd-vhosts.conf ���� Ȯ��]'  >> $CREATE_FILE_RESULT 2>&1
		if [ -f $vhosts ]
			then
				if [ `cat $vhosts |grep -v '#'|egrep -i 'ErrorLog|CustomLog'|wc -l` -eq 0 ]
					then
						echo 'ErrorLog, CustomLog ������ ����' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						cat $vhosts |grep -v '#'|egrep -i 'ErrorLog|CustomLog'| grep -v "#"  >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi
		echo '| Log �۹̼� Ȯ�� |'  >> $CREATE_FILE_RESULT 2>&1
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
											result5='���'
											
									fi
									if [ `ls -alL $logpath |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='���'
									fi
							fi
						else
							if [ -d $logpath/ ]
								then
									echo $logpath/ >> $CREATE_FILE_RESULT 2>&1
									ls -alL $logpath/ >> $CREATE_FILE_RESULT 2>&1
									if [ `ls -alL $logpath/ |grep '^-.........' |grep -v '...-.-----'|wc -l` -gt 0 ]
										then
											result5='���'
									fi
									if [ `ls -alL $logpath/ |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='���'
									fi
							fi
					fi
			done
		fi
	fi

else
#httpd.conf
echo "[ "$conf"/httpd.conf �α� ���� ]" >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		if [ `cat $conf/httpd.conf |egrep -i 'ErrorLog|CustomLog'| grep -v "#"| wc -l` -eq 0 ]
			then
				echo 'ErrorLog, CustomLog ������ ����' >> $CREATE_FILE_RESULT 2>&1
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
											result5='���'
											
									fi
									if [ `ls -alL $logpath |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='���'
											
									fi
							fi
						else
							if [ -d $logpath/ ]
								then
									echo $logpath/ >> $CREATE_FILE_RESULT 2>&1
									ls -alL $logpath/ >> $CREATE_FILE_RESULT 2>&1
									if [ `ls -alL $logpath/ |grep '^-.........' |grep -v '...-.-----'|wc -l` -gt 0 ]
										then
											result5='���'
											
									fi
									if [ `ls -alL $logpath/ |grep '^d.........'|grep " . "|grep -v '.....-.---'|wc -l` -gt 0 ]
										then
											result5='���'
											
									fi
							fi
					fi
			done
		fi
#End
fi
		
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� �α� ���͸��� 750���� �������� ������ 640���� �������� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result5 = '��ȣ' \) ]
#then
#	echo '�� ��ȣ - �α� ���丮/���� ���� ����' >> $CREATE_FILE_RESULT 2>&1 
#else
#	echo '�� ��� - �α� ���丮/���� ���� ����' >> $CREATE_FILE_RESULT 2>&1 
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
echo ' 1.6 �α� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'LogFormat�� Combined���º��� ���ϰ� �����Ǿ������� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-vhosts.conf ���� include ����]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result6='��ȣ'
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
		echo "httpd-vhosts.conf ������ include �Ǿ� ���� �ʽ��ϴ�." >> $CREATE_FILE_RESULT 2>&1
fi
echo "" >> $CREATE_FILE_RESULT 2>&1

#�켱���� �Ǻ�
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
	echo '[httpd-vhosts.conf ���� Ȯ��]'  >> $CREATE_FILE_RESULT 2>&1
		if [ -f $vhosts ]
			then
				if [ `cat $vhosts |grep -v '#'|egrep -i 'CustomLog' | wc -l` -eq 0 ]
					then
						echo 'CustomLog ������ ����' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						cat $vhosts |grep -v '#'|egrep -i 'CustomLog'  >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi		
				if [ `cat $vhosts |egrep -i 'CustomLog'| grep -v "\#" | grep -v "combined" | wc -l` -gt 0 ]
					then
						result6='���'
				fi
			else
				echo "httpd-vhosts.conf ������ �������� ����" >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi
	echo "" >> $CREATE_FILE_RESULT 2>&1
else
#httpd.conf
echo "[ "$conf"/httpd.conf �α� ���� ]" >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		if [ `cat $conf/httpd.conf |grep -v '#'|egrep -i 'CustomLog' | wc -l` -eq 0 ]
			then
				echo 'CustomLog ������ ����' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				cat $conf/httpd.conf |grep -v '#'|egrep -i 'CustomLog'  >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi		
fi

if [ `cat $conf/httpd.conf |egrep -i 'CustomLog'| grep -v "\#" | grep -v "combined" | wc -l` -gt 0 ]
	then
		result6='���'
fi
#End
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ �α� �����ڰ� ���Եǰ� �α� ������ combined�� ���� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result6 = '��ȣ' \) ]
#then
#	echo '�� ��ȣ - �α� ���� ����' >> $CREATE_FILE_RESULT 2>&1 
#else
#	echo '�� ��� - �α� ���� ����' >> $CREATE_FILE_RESULT 2>&1 
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0106 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1







echo '============================== 1.7 ===================================='
echo "0107 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.7 �α� ���� �ֱ� '  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '������� �� ����������ȣ��, ��Կ� ������ �α� �����ֱ� ���� ����' >> $CREATE_FILE_RESULT 2>&1
echo '�α� ���� �Ⱓ, �������� Ȯ��/����, ���� ������ġ�� ��� �� �� ������ ���Ȱ��̵���� ���� ����' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ���ͺ� �ʿ�' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ - �α� ���� �ֱ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0107 END" 															>> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.8 ===================================='
echo "0108 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.8 ��� ���� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'ServerTokens���� Prod�� �����Ǿ� �ִ��� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo 'ServerSignature�� Off�� �����Ǿ� �ִ��� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-default.conf ���� include ����]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result8='��ȣ'
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
		echo "httpd-default.conf ������ include �Ǿ� ���� ����" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#�켱���� �Ǻ�
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
		echo '[httpd-default.conf ���� ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $header ]
			then
				if [ `cat $header |egrep -i 'ServerTokens|ServerSignature'|grep -v '#'|wc -l` -eq 0 ]
					then
						echo 'ServerTokens, ServerSignature ������ ����' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						cat $header |egrep -i 'ServerTokens|ServerSignature'|grep -v '#' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
				fi
			else
				echo 'httpd-default.conf ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
		fi

		if [ \( $incOX = 'O' \) ]
			then
				if [ -f $header ]
					then
						if [ `cat $header |grep -v '#' | grep -i 'ServerTokens'| grep -i "prod" | wc -l` -eq 0 ]
							then
								result8='���'
						fi
						if [ `cat $header |grep -v '#' | grep -i 'ServerSignature'| grep -i "off" | wc -l` -eq 0 ]
							then
								result8='���'
						fi
				fi
		fi

else
#httpd.conf
echo '[httpd.conf ���� ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		if [ `cat $conf/httpd.conf |egrep -i 'ServerTokens|ServerSignature'|grep -v '#'|wc -l` -eq 0 ]
			then
				echo 'ServerTokens, ServerSignature ������ ����' >> $CREATE_FILE_RESULT 2>&1
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
				result8='���'
		fi
		if [ `cat $conf/httpd.conf |grep -v '#' | grep -i 'ServerSignature'| grep -i "off" | wc -l` -eq 0 ]
			then
				result8='���'
		fi
fi
#End
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ ���� ���Ͽ��� ServerTokens���� Prod�� ServerSignature�� Off�� ������ �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ \( $result8 = '��ȣ' \) ]
#	then
#		echo '�� ��ȣ - ��� ���� ���� ����' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��� - ��� ���� ���� ����' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0108 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '============================== 1.9 ===================================='
echo "0109 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.9 HTTP Method ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���ʿ��� Method ���� ������ �Ǿ� �ִ��� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '(Default ������ GET, POST, HEAD, OPTIONS, TRACE Method�� ����ϰ� ����)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '| Trace Method ���� |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $conf/httpd.conf | grep -i TraceEnable | grep -i off | grep -v "\#" |wc -l` -eq 0 ]
then
	echo 'TraceEnable On/Off ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
else
	cat $conf/httpd.conf | grep -i TraceEnable >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '| Dav ��� ��� ���� : ��� Load Ȯ�� |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -eq 0 ]
then
	echo 'Dav ����� Load�ϰ� ���� ����' >> $CREATE_FILE_RESULT 2>&1
else
	cat $conf/httpd.conf | grep -i LoadModule | grep -i Dav  >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	echo '| Dav ��� ��� ���� : Dav on ���� Ȯ�� |' >> $CREATE_FILE_RESULT 2>&1
	if [ `cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep -i "On|Off" | wc -l` -gt 0 ]
		then
			cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep "on|off" >> $CREATE_FILE_RESULT 2>&1
		else
			echo 'Dav On/Off ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
	fi
fi

result11='��ȣ'

if [ `cat $conf/httpd.conf | grep -i TraceEnable | grep -i off | grep -v '#' |wc -l` -eq 0 ]
then
	result11='���'
fi

if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -gt 0 ]
	then
		if [ `cat $conf/httpd.conf | grep -i dav | grep -i on | grep -v '#' |wc -l` -gt 0 ]
			then
				result11='���'
		fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� HTTP Method �� GET, POST, HEAD, OPTIONS �� ����ϵ���' >> $CREATE_FILE_RESULT 2>&1
echo '   TraceEnable Off ������ Dav ����� Load�� ��� Dav Off ������ �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ $result11 = '���' ]
#	then
#		echo '�� ��� - HTTP Method ����' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��ȣ - HTTP Method ����' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0109 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1





echo '============================== 1.10 ===================================='
echo "0110 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.10 FollowSymLinks �ɼ� ��Ȱ��ȭ'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '<Directory>��忡 FollowSymLinks�ɼ��� ���� �Ǵ� ���ŵǾ��ִ� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-autoindex.conf ���� include ����]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result9='��ȣ'
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
		echo "httpd-autoLinks.conf ������ include �Ǿ� ���� ����" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#Start
#Include
if [ \( $incOX = 'O' \) ]
	then
		echo '[httpd-autoLinks.conf - MultiLinks ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $Links ]
			then
				cat $Links |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| FollowSymLinks|</Directory' >> $CREATE_FILE_RESULT 2>&1
				if [ `cat $Links |grep -v '#'|grep -i ' Options'|grep -i ' FollowSymLinks'|wc -l` -eq 0 ]
					then
						echo 'MultiLinks �ɼ� ������ ����' >> $CREATE_FILE_RESULT 2>&1
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
					else
						echo ' ' >> $CREATE_FILE_RESULT 2>&1
						result9='���'
				fi
			else
				echo 'httpd-autoLinks.conf ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
		fi
fi

#httpd.conf
echo '[httpd.conf ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		cat $conf/httpd.conf |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| FollowSymLinks|</Directory' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $conf/httpd.conf |grep -v '#'|grep -i ' Options'|grep -i ' FollowSymLinks'|wc -l` -eq 0 ]
			then
				echo 'MultiLinks �ɼ� ������ ����' >> $CREATE_FILE_RESULT 2>&1
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
			else
				echo ' ' >> $CREATE_FILE_RESULT 2>&1
				result9='���'
		fi
fi

#End

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ ���� ���Ͽ��� FollowSymLinks �ɼ��� ���Ÿ� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result9 = '��ȣ' \) ]
#	then
#		echo '�� ��ȣ - FollowSymLinks �ɼ� ��Ȱ��ȭ' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��� - FollowSymLinks �ɼ� ��Ȱ��ȭ' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0110 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.11 ===================================='
echo "0111 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.11 MultiViews �ɼ� ��Ȱ��ȭ'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '<Directory>��忡 MultiViews�ɼ��� ���� �Ǵ� ���ŵǾ��ִ� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '[httpd-autoindex.conf ���� include ����]' >> $CREATE_FILE_RESULT 2>&1
confinc=`cat $conf/httpd.conf |grep -i "^Include " |grep -v '#' |awk '{print $2}'`
incOX="X"
priority='X'
result10='��ȣ'
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
		echo "httpd-autoViews.conf ������ include �Ǿ� ���� ����" >> $CREATE_FILE_RESULT 2>&1
fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1


#Start
#Include
if [ \( $incOX = 'O' \) ]
	then
		echo '[httpd-autoViews.conf - MultiViews ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
		if [ -f $Views ]
			then
				cat $Views |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| MultiViews|</Directory' >> $CREATE_FILE_RESULT 2>&1
				if [ `cat $Views |grep -v '#'|grep -i ' Options'|grep -i ' MultiViews'|wc -l` -eq 0 ]
					then
					echo 'MultiViews �ɼ� ������ ����' >> $CREATE_FILE_RESULT 2>&1
					echo ' ' >> $CREATE_FILE_RESULT 2>&1
				else
					echo ' ' >> $CREATE_FILE_RESULT 2>&1
					result10='���'
				fi
			else
				echo 'httpd-autoViews.conf ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
		fi
fi

#httpd.conf
echo '[httpd.conf ���� Ȯ��]' >> $CREATE_FILE_RESULT 2>&1
if [ -f $conf/httpd.conf ]
	then
		cat $conf/httpd.conf |grep -v '#'|egrep -i '<Directory| Options|</Directory'|egrep -i '<Directory| MultiViews|</Directory' >> $CREATE_FILE_RESULT 2>&1
		if [ `cat $conf/httpd.conf |grep -v '#'|grep -i ' Options'|grep -i ' MultiViews'|wc -l` -eq 0 ]
			then
			echo 'MultiViews �ɼ� ������ ����' >> $CREATE_FILE_RESULT 2>&1
			echo ' ' >> $CREATE_FILE_RESULT 2>&1
		else
			echo ' ' >> $CREATE_FILE_RESULT 2>&1
			result10='���'
		fi
fi

#End


echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ ���� ���Ͽ��� MultiViews �ɼ� ���Ÿ� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ \( $result10 = '��ȣ' \) ]
#	then
#		echo '�� ��ȣ - MultiViews �ɼ� ��Ȱ��ȭ' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��� - MultiViews �ɼ� ��Ȱ��ȭ' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0111 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1







echo '============================== 2.1 ===================================='
echo "0201 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.1 ���ʿ��� Manual ���� �� ���͸� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���ʿ��� Manual ���͸� �� �⺻ CGI��ũ��Ʈ�� �������� ������ ��ȣ ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

echo '| CGI ��ũ��Ʈ Ȯ�� | ' >> $CREATE_FILE_RESULT 2>&1
if [ \( `ls -alL $apache/cgi-bin/ | grep printenv|wc -l` -eq 0 \) -a \( `ls -alL $apache/cgi-bin/ | grep test-cgi|wc -l` -eq 0 \) ]
then 
	echo 'CGI ��ũ��Ʈ�� �������� ����' >> $CREATE_FILE_RESULT 2>&1
else
	ls -alL $apache/cgi-bin/ >> $CREATE_FILE_RESULT 2>&1
fi

echo '' >> $CREATE_FILE_RESULT 2>&1
echo '| Manual ���͸� Ȯ�� |' >> $CREATE_FILE_RESULT 2>&1
if [ `ls -alL $apache/ | grep manual | wc -l` -eq 0 ]
then
	echo 'Manual ���͸��� �������� ����' >> $CREATE_FILE_RESULT 2>&1
else
	ls -alL $apache/ | grep manual >> $CREATE_FILE_RESULT 2>&1	
fi

result21='��ȣ'

if [ \( `ls -alL $apache/cgi-bin/ | grep printenv|wc -l` -eq 0 \) -a \( `ls -alL $apache/cgi-bin/ | grep test-cgi|wc -l` -gt 0 \) ]
	then
		result21='���'
fi

if [ `ls -alL $apache/ | grep -i manual | wc -l` -gt 0 ]
then
	result21='���'
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo 'Manual ���丮 �� �⺻ CGI ��ũ��Ʈ ������ �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ $result21 = '���' ]
#	then
#		echo '�� ��� - ���ʿ��� Manual ���丮 ����' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��ȣ - ���ʿ��� Manual ���丮 ����' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0201 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1





echo '============================== 2.2 ===================================='
echo "0202 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 2.2 WebDAV ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo 'Dva Module Load �� WebDAV ���� ������ �Ǿ� ������ ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1
echo '| Dav ��� ��� ���� : ��� Load Ȯ�� |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -eq 0 ]
then
	echo 'Dav ����� Load�ϰ� ���� ����' >> $CREATE_FILE_RESULT 2>&1
else
	cat $conf/httpd.conf | grep -i LoadModule | grep -i Dav  >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	echo '| Dav ��� ��� ���� : Dav on ���� Ȯ�� |' >> $CREATE_FILE_RESULT 2>&1
	if [ `cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep -i "On|Off" | wc -l` -gt 0 ]
		then
			cat $conf/httpd.conf | grep -i "Dav " | grep -v '#' | egrep "on|off" >> $CREATE_FILE_RESULT 2>&1
		else
			echo 'Dav On/Off ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
	fi
fi

result22='��ȣ'


if [ `cat $conf/httpd.conf | grep -i LoadModule | grep -i dav | grep -v "\#" | wc -l` -gt 0 ]
	then
		if [ `cat $conf/httpd.conf | grep -i dav | grep -i on | grep -v '#' |wc -l` -gt 0 ]
			then
				result22='���'
		fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '   TraceEnable Off ������ Dav ����� Load�� ��� Dav Off ������ �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
#if [ $result22 = '���' ]
#	then
#		echo '�� ��� - HTTP Method ����' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��ȣ - HTTP Method ����' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0202 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1





echo '============================== 3.1 ===================================='
echo "0301 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 3.1 ���� ��ġ ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '�� ����' >> $CREATE_FILE_RESULT 2>&1
echo '���� ħ�� ������ ���Ͽ� �ֱ����� ������ġ�� �����ϴ� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

echo '�� ��Ȳ' >> $CREATE_FILE_RESULT 2>&1

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
			result31='��ȣ'
		else
			result31='���'
		fi
fi
if [ $ver1 -eq 2 -a $ver2 -eq 0 ]
	then
		if [ $ver3 -ge 65 ]
			then
			result31='��ȣ'
		else
			result31='���'
		fi		
fi
if [ $ver1 -eq 2 -a $ver2 -eq 2 ]
	then
		if [ $ver3 -ge 20 ]
			then
			result31='��ȣ'
		else
			result31='���'
		fi
fi
if [ $ver1 -eq 2 -a $ver2 -eq 4 ]
	then
		if [ $ver3 -ge 3 ]
			then
			result31='��ȣ'
		else
			result31='���'
		fi
fi

else
echo '���� ������ ã�� �� ����(���� Ȯ�� �ʿ�)' >> $CREATE_FILE_RESULT 2>&1
result31='���'
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�Ʒ� ����Ʈ �� �ֽ� ������ �����Ͽ� ���� ���⵵ �� �� ��ġ�� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#if [ $result31 = '���' ]
#	then
#		echo '�� ��� - ���� ��ġ ����' >> $CREATE_FILE_RESULT 2>&1
#	else
#		echo '�� ��ȣ - ���� ��ġ ����' >> $CREATE_FILE_RESULT 2>&1
#fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '�� Apache Securty Update:' >> $CREATE_FILE_RESULT 2>&1
echo 'http://httpd.apache.org/security_report.html' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[�ֽ� ����]' >> $CREATE_FILE_RESULT 2>&1
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
echo ' =================== �� ���� httpd.conf ==================='  >> $CREATE_FILE_RESULT 2>&1
cat $apache/conf/httpd.conf  >> $CREATE_FILE_RESULT 2>&1

#end script