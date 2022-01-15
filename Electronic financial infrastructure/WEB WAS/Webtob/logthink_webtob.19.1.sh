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
echo "################# WebtoB ���� ��ũ��Ʈ�� �����ϰڽ��ϴ� ###################"
echo ""
echo ""

alias ls=ls
alias grep=/bin/grep

echo '[WebtoB ���� ���]'
env |grep WEBTOBDI
echo ''
echo "  ${WEBTOBDIR}/config/�� �Է��Ͻʽÿ�. "
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
               echo "   �Է��Ͻ� ���丮�� �������� �ʽ��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
               echo " "
         fi
    else
         echo "   �߸� �Է��ϼ̽��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
         echo " "
   fi
done
echo " "


echo '[WebtoB ���� ȯ������]'
ls -al $webtob
echo ''
echo "  [ȯ������.m]�� �Է��Ͻʽÿ�. "
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
               echo "   �Է��Ͻ� ������ �������� �ʽ��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
               echo " "
         fi
    else
         echo "   �߸� �Է��ϼ̽��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
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
echo '============================== 1.1 ===================================='
echo "0101 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.1 ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'deploy�� ������ root���� Ȯ�� (root ���� �� ���)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1



if [ `ps -ef | grep webtob | grep -v grep |wc -l` -eq 0 ]
	then
	echo 'WebtoB�� �����ǰ� ���� �ʽ��ϴ�.' >> $CREATE_FILE_RESULT 2>&1
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
#echo '[���]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result1 = 'Vulnerability' ]
#	then
#	echo '[root] �������� �����Ǿ� �־� Web Applincation ������̳� Buffer Overflow ����� ���� �̿��ϴ� �����ڿ��� [root] ������ ȹ���� ������.' >> $CREATE_FILE_RESULT 2>&1
#	echo '(root������ �ƴ� �α����� �Ұ����� �Ϲݰ������� WebtoB ������ �ǰ���)' >> $CREATE_FILE_RESULT 2>&1
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
#echo '[���� ����]' >> $CREATE_FILE_RESULT 2>&1

#echo $fuser '   =   ' $result1>> $CREATE_FILE_RESULT 2>&1
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
echo 'Server Root �� 750������ �۹̼��� �ο��Ǿ��ִ��� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
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
#echo '[���]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
echo '�ǰ���� : DocumentRoot' $dwebtob '�� ���ٱ��ѵ� 755�� ������ ���� �ǰ���.'>> $CREATE_FILE_RESULT 2>&1
#echo '(�۹̼� 750���Ϸ� ������ �ǰ���)' >> $CREATE_FILE_RESULT 2>&1


#if [ `ls -al $dwebtob|awk '{print $1}'|grep '..........'|head -1|grep '.r......-.'|wc -l` -eq 0 ]
#	then
#
#	echo 'DocumentRoot �۹̼�   :   ' $dresult2 '   =   Vulnerability' >> $CREATE_FILE_RESULT 2>&1
#else
#	echo 'DocumentRoot �۹̼�   :   ' $dresult2 '   =   Good' >> $CREATE_FILE_RESULT 2>&1
#fi
#if [ `ls -al $swebtob|awk '{print $1}'|grep '..........'|head -1|grep '.r......-.'|wc -l` -eq 0 ]
#	then
#	echo 'ServerRoot �۹̼�   :   ' $sresult2 '   =   Vulnerability' >> $CREATE_FILE_RESULT 2>&1
#else
#	echo 'ServerRoot �۹̼�   :   ' $sresult2 '   =   Good' >> $CREATE_FILE_RESULT 2>&1
#fi
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0102 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.3 ===================================='
echo "0103 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.3 �������� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '���������� 600���� �۹̼��� �ο��Ǿ��ִ��� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
ls -al $webtob/$webtobm >> $CREATE_FILE_RESULT 2>&1
ls -al $webtob/wsconfig >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

#echo '| ' $webtobm ' |' >> $CREATE_FILE_RESULT 2>&1


#if [ `ls -al $webtob/$webtobm |grep -v '.r.....---'|wc -l` -eq 0 ]
#	then
#	echo '640���Ϸ� �����Ǿ� ����' >> $CREATE_FILE_RESULT 2>&1
#	result3='Good'
#else
#	echo '�������� �۹̼����� �����Ǿ� ����' >> $CREATE_FILE_RESULT 2>&1
#	result3='Vulnerability'
#fi

#echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#echo '[���]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result3 = 'Vulnerability' ]
#	then
#	echo '�������� �۹̼��� �������ϰ� �����Ǿ� �־� ���� 640����, ���丮750���Ϸ� �۹̼� ������ �ǰ���.' >> $CREATE_FILE_RESULT 2>&1
#fi
#echo '' >> $CREATE_FILE_RESULT 2>&1

#echo '[ '$webtobm ' ���� �۹̼� ]   =   ' $result3 >> $CREATE_FILE_RESULT 2>&1
#echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0103 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '============================== 1.4 ===================================='
echo "0104 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.4 ���丮 �˻� ��� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'DIRINDEX���� �����ϸ� Options ���� -index�� �����ؾ��� (-index�� �����Ǿ� ������ ��ȣ, DIRINDEX���� ������ ��ȣ)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
echo '| DIRINDEX�� |' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $webtob/$webtobm |grep DirIndex|wc -l` -eq 0 ]
	then
	echo 'DIRINDEX���� �������� ����' >> $CREATE_FILE_RESULT 2>&1
	result5='Good'
else
	cat $webtob/$webtobm |grep DirIndex >> $CREATE_FILE_RESULT 2>&1
	echo ' ' >> $CREATE_FILE_RESULT 2>&1
	 
	echo '| Options |' >> $CREATE_FILE_RESULT 2>&1
	if [ `cat $webtob/$webtobm |grep Options |wc -l` -eq 0 ]
		then
		echo 'Options ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
		result5='Vulnerability'
	else
		cat $webtob/$webtobm |grep Options >> $CREATE_FILE_RESULT 2>&1
		ind=`cat $webtob/$webtobm |grep Options |awk -F'"' '{print $2}'`

		if [ \( $ind = '-Index' \) -o \( $ind = '-index' \) -o \( $ind = '-INDEX' \) ]
			then
			echo '-index ���Ѽ����� �Ǿ� ����'  >> $CREATE_FILE_RESULT 2>&1
		else
			cat $webtob/$webtobm | grep -n index >> $CREATE_FILE_RESULT 2>&1
		fi
	fi
fi

echo ' ' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#echo '[���]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result5 = 'Vulnerability' ]
#	then
#	echo 'Options������ �������� �ʰų� Index �ɼ����� �Ǿ��־� ���丮 �����ϴ� ��� ��� ���� ����Ʈ�� �����'>> $CREATE_FILE_RESULT 2>&1
#	echo '(-Index���� ���� ������ �ǰ���.)'>> $CREATE_FILE_RESULT 2>&1
#fi
#	echo '(-Index���� ���� ������ �ǰ���.)'>> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1

#echo ' ���丮 �˻� ��� ����   =   ' $result5 >> $CREATE_FILE_RESULT 2>&1
#echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0104 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1



echo '============================== 1.5 ===================================='
echo "0105 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.5 �α� ���丮/���� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'Log�� ��� Ȯ���Ͽ� �ش� Log���͸��� �۹̼��� 750����, �α����� �۹̼��� 640�������� Ȯ��' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[����]' >> $CREATE_FILE_RESULT 2>&1
echo '�α��۹̼��� ������ �ѹ� Ȯ���Ͻñ� �ٶ��ϴ�.(���丮 �۹̼�)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm |grep ERRORLOG |grep -v '\*' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm |grep LOGGING |grep -v '\*' >> $CREATE_FILE_RESULT 2>&1

echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[�⺻��� log���͸�����]' >> $CREATE_FILE_RESULT 2>&1
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
	echo '[�α� ���� �۹̼�]' >> $CREATE_FILE_RESULT 2>&1
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
	echo '[�α� ���� �۹̼�]' >> $CREATE_FILE_RESULT 2>&1
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
#echo '[���]' >> $CREATE_FILE_RESULT 2>&1
#echo '-------------------------------------------------------------------' >> $CREATE_FILE_RESULT 2>&1
#if [ $result6 = 'Vulnerability' ]
#	then
#	echo '�α����� �۹̼��� �������ϰ� �����Ǿ� �־� ���� 640����, ���丮 750���Ϸ� �۹̼� ������ �ǰ���.'>> $CREATE_FILE_RESULT 2>&1
#	echo '' >> $CREATE_FILE_RESULT 2>&1
#fi
#echo 'Log �۹̼�   =   ' $result6 >> $CREATE_FILE_RESULT 2>&1
#echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo "0105 END" 															>> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1

echo '============================== 1.6 ===================================='
echo "0106 START"															>> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.6 �α� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo 'LogFormat�� Combined �������� ������ ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '�� ������ ���Ȱ��̵���� ����' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1

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
echo ' 1.7 �α� ���� �ֱ�'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[����]' >> $CREATE_FILE_RESULT 2>&1
echo '�α׸� ��ħ�� �°� ���� �� �������� ���� ��� ���' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
echo "����ڿ� ���ͺ並 ���� �α� ���� �� ���� ��Ȳ �ľ� �ʿ� (��������)" >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0107 END' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0108 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.8 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.8 ��� ���� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[����]' >> $CREATE_FILE_RESULT 2>&1
echo 'ServerTokens ���� off �� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm | cut -f 1 -d '#' | egrep -i 'WEBTOBDIR|ServerTokens' > 018temp.txt
if [ `cat 018temp.txt | egrep -i 'ServerTokens' | wc -l` -gt 0 ]; then
	cat 018temp.txt >> $CREATE_FILE_RESULT 2>&1
else
	echo "ServerTokens ������ ����." >> $CREATE_FILE_RESULT 2>&1
fi
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '0108 END' >> $CREATE_FILE_RESULT 2>&1
rm -rf 018temp.txt
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1


echo '0109 START' >> $CREATE_FILE_RESULT 2>&1
echo '============================== 1.9 ===================================='
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo ' 1.9 HTTP Method ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[����]' >> $CREATE_FILE_RESULT 2>&1
echo 'GET,POST,HEAD, OPTIONS�� ���� ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
cat $webtob/$webtobm | cut -f 1 -d '#' | egrep -i 'WEBTOBDIR|Method' > 019temp.txt
# Method ���� ������ ������ ���
if [ `cat 019temp.txt | egrep -i 'Method' | wc -l` -gt 0 ]; then
	# HEAD Method�� ������ ���
	cat 019temp.txt >> $CREATE_FILE_RESULT 2>&1
# Method ���� ������ ���� ���
else
	echo "Method ���� ������ ����.(Default ��ȣ)" >> $CREATE_FILE_RESULT 2>&1
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
echo ' 1.10 �н����� ���� ���� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[����]' >> $CREATE_FILE_RESULT 2>&1
echo '�н����� ���� �۹̼��� 600���ϸ� ��ȣ (AUTHENT ������ ������ ��ȣ)' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
if [ `cat $webtob/$webtobm | grep -i authent | wc -l` -eq 0 ]
	then
	echo 'AUTHENT ������ �������� ����. (��ȣ)' >> $CREATE_FILE_RESULT 2>&1
else
	userfile=`cat $webtob/$webtobm |grep -i userfile|awk -F'"' '{print $2}'`
	groupfile=`cat $webtob/$webtobm |grep -i groupfile|awk -F'"' '{print $2}'`
	echo '' >> $CREATE_FILE_RESULT 2>&1
	echo '(1) userfile �۹̼� |' >> $CREATE_FILE_RESULT 2>&1
	if [ -f $userfile ]
		then
		ls -al $userfile >> $CREATE_FILE_RESULT 2>&1
	else
		echo '�н����� ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
	fi

	echo '(2) groupfile �۹̼� |' >> $CREATE_FILE_RESULT 2>&1
	if [ -f $groupfile ]
		then
		ls -al $groupfile >> $CREATE_FILE_RESULT 2>&1
	else
		echo '�н����� ������ �������� ����' >> $CREATE_FILE_RESULT 2>&1
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
echo ' 2.1 ���ʿ��� ���͸� ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[����]' >> $CREATE_FILE_RESULT 2>&1
echo '���ʿ��� ���͸��� �����ϵ��� �ǰ�' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
if [ `find $webtob -name sample|wc -l` -eq 0 ]
	then
	echo 'Sample ���丮�� �������� ����' >> $CREATE_FILE_RESULT 2>&1
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
echo ' 3.1 ���� ��ġ ����'  >> $CREATE_FILE_RESULT 2>&1
echo '===================================================================' >> $CREATE_FILE_RESULT 2>&1
echo '[����]' >> $CREATE_FILE_RESULT 2>&1
echo '�ֱ������� ������ġ�� ������ ��� ��ȣ' >> $CREATE_FILE_RESULT 2>&1
echo '' >> $CREATE_FILE_RESULT 2>&1
echo '[��Ȳ]' >> $CREATE_FILE_RESULT 2>&1
$webtob/../bin/wscfl -version >> $CREATE_FILE_RESULT 2>&1
echo ' ' >> $CREATE_FILE_RESULT 2>&1
echo '[�ֽ� ����]' >> $CREATE_FILE_RESULT 2>&1
echo 'WebtoB 5.0 SP0 Fix #1 - 16. 08. 31'>> $CREATE_FILE_RESULT 2>&1
echo 'WebtoB 4.1 SP9 Fix #1 - 16. 06. 22'>> $CREATE_FILE_RESULT 2>&1
echo 'WebtoB 3.X ���� ����' >> $CREATE_FILE_RESULT 2>&1
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