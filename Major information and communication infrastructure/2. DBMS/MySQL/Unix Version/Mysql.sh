#!/bin/sh

LANG=C
export LANG

clear

DBVersion=0.6.3
DBLast_update=2017.09.01

RESULT_FILE=`hostname`"-mysql-result.txt"


echo "***************************************************************************************"
echo "***************************************************************************************"
echo "*                                                                                     *"
echo "*  MySQL Security Checklist version $DBVersion                                         *"
echo "*                                                                                     *"
echo "***************************************************************************************"
echo "***************************************************************************************"

echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo "��������������������             MySQL Security Check           	 ���������������������" >> $RESULT_FILE 2>&1
echo "��������������������      Copyright �� 2017, SK think Co. Ltd.    ���������������������" >> $RESULT_FILE 2>&1
echo "��������������������     Ver $DBVersion // Last update $DBLast_update ���������������������" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1



echo ''
echo ''
echo '[Mysql ���� ���]'
ps -ef |grep mysql


echo ''
echo ''
echo ''
echo "  Mysql ��ġ ���丮�� �Է��Ͻʽÿ�. "
echo "  Mysql ���� ������ /usr/bin ���丮�� �ִٸ�, /usr �� �Է��Ͽ��� �մϴ�." 
while true
do 
	echo "    (ex. /usr) : " 
    read mysql
    if [ $mysql ]
    then
		if [ -d $mysql ]
        then 
            if [ -f $mysql/bin/mysql ]
			then
				break
			else
				echo "�Է��Ͻ� ���丮�� �����ϳ�, ���� ��ο� mysql ������ �����ϴ�."
				echo " "
			fi
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


echo "Mysql root���� �н����尡 ������ �Ǿ� �ִ� ���                 1 "
echo "Mysql root���� �н����尡 NULL�� ������ �Ǿ� �ִ� ���          2 "
read my_pwd

#id/pwd üũ
if [ $my_pwd = "1" ] 
	then
		echo " "
		echo "[Mysql ���� ���� �Է�]"
		echo -n "(ex. ����/��й�ȣ -> root/test123) : " 
		read idpwd
		id=`echo $idpwd|awk -F'/' '{print $1}'`
		pwd2=`echo $idpwd|awk -F'/' '{print $2}'`
		
		SQL_query="$mysql/bin/mysql -u $id -p$pwd2"
else
		echo " "
		echo "[Mysql ���� ���� �Է�]"
		echo -n "(ex. root) : " 
		read id
		
		SQL_query="$mysql/bin/mysql -u $id"
fi

mkdir ./mytmp


#version üũ
$SQL_query -e "select version();" -t > ./mytmp/my_version.txt

if [ `cat ./mytmp/my_version.txt | grep -i "maria" | wc -l` -ge 1 ]
then
	my_ver="MariaDB"
	my_ver_re=1
elif [ `cat ./mytmp/my_version.txt | grep "5.5" | wc -l` -ge 1 ]
then
	my_ver="MySQL 5.5"
	my_ver_re=2
elif [ `cat ./mytmp/my_version.txt | grep "5.6" | wc -l` -ge 1 ]
then
	my_ver="MySQL 5.6"
	my_ver_re=3
elif [ `cat ./mytmp/my_version.txt | grep "5.7" | wc -l` -ge 1 ]
then
	my_ver="MySQL 5.7"
	my_ver_re=4
elif [ `cat ./mytmp/my_version.txt | grep "8.0" | wc -l` -ge 1 ]
then
	my_ver="MySQL 8.0"
	my_ver_re=8
else
	my_ver="MySQL etc"
	my_ver_re=1
fi


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "������ $my_ver, $my_ver_re �Դϴ�." >> $RESULT_FILE 2>&1
echo "��ġ ���丮�� $mysql �Դϴ�." >> $RESULT_FILE 2>&1
echo "pw���� üũ�� $my_pwd �Դϴ�." >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo "###############################  Kernel Information  ##################################" >> $RESULT_FILE 2>&1
uname -a                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1

echo " "
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "##################################  Start Time  #######################################"
date
echo "##################################  Start Time  #######################################" >> $RESULT_FILE 2>&1
date                                                                                           >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "

echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.01 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �⺻ ������ �н�����, ��å ���� �����Ͽ� ���"
echo "##### �⺻ ������ �н�����, ��å ���� �����Ͽ� ���" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: �⺻ ������ �н����带 �����Ͽ� ����ϴ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


if [ $my_ver_re -ge 4 ] 
	then
	$SQL_query -e "select host, user, authentication_string from mysql.user where user='root';" -t > ./mytmp/1-1.txt
else
	$SQL_query -e "select host, user, password from mysql.user where user='root';" -t > ./mytmp/1-1.txt
fi


if [ `cat ./mytmp/1-1.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-1.txt >> $RESULT_FILE 2>&1

else
	echo "���� ��� ����" >> $RESULT_FILE 2>&1
fi


echo " " >> $RESULT_FILE 2>&1
echo "1.01 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "�ش� ȣ��Ʈ�� ���Ͽ� Null User/Password�� ���ǰ� �����Ƿ� Null User�� �н����� ���� �� �����Ͽ��� �մϴ�." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1

















echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.02 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### scott �� Demonstration �� ���ʿ� ������ �����ϰų� ��ݼ��� �� ���"
echo "##### scott �� Demonstration �� ���ʿ� ������ �����ϰų� ��ݼ��� �� ���" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ���� ������ Ȯ���Ͽ� ���ʿ��� ������ ���� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user from mysql.user where user!='root';" -t > ./mytmp/1-2.txt


if [ `cat ./mytmp/1-2.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-2.txt >> $RESULT_FILE 2>&1
else
	echo "root���� �̿��� ������ �������� ����(���� ��� ����)" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.02 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "������� �ʰų� ���ʿ��� ������ ������� �����Ͽ��� �մϴ�." >> $RESULT_FILE 2>&1
echo "Anonymous ����(user �÷��� ��ĭ)�� �����ϰ�, �н����尡 �����Ǿ� ���� ������ DB�� ���� ������ ������." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.03 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �н������� ���Ⱓ �� ���⵵�� ����� ��å�� �µ��� ����"
echo "##### �н������� ���Ⱓ �� ���⵵�� ����� ��å�� �µ��� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: �н����带 �ֱ������� �����ϰ�, �н����� ��å�� ����Ǿ� �ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "���� ������ $my_ver�Դϴ�. ������ ���� ���ͺ� �ʿ�" >> $RESULT_FILE 2>&1
echo "validate_password Plugin�� 5.6 �̻� ����Ʈ�� ������(password_length, policy �� Ȯ�� ����)" >> $RESULT_FILE 2>&1
echo "authentication_string, password_expired, password_last_changed, password_lifetime, account_locked�÷��� 5.7�̻� ����" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "�� Plugin ���" >> $RESULT_FILE 2>&1

$SQL_query -e "show global variables like '%plu%';" -t > ./mytmp/1-3.txt
cat ./mytmp/1-3.txt >> $RESULT_FILE 2>&1

if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "�� �н����� ���� ���� �Ķ����(Plugin ����)" >> $RESULT_FILE 2>&1
	$SQL_query -e "show global variables like '%vali%';" -t > ./mytmp/1-32.txt
	cat ./mytmp/1-32.txt | grep -v -i "query_cache" >> $RESULT_FILE 2>&1
else
	echo "Plugin �̻��" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "�� �н����� ����, ��������, ������� �� �÷�" >> $RESULT_FILE 2>&1

if [ $my_ver_re -ge 4 ] 
then
	$SQL_query -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > ./mytmp/1-35.txt
	if [ `cat ./mytmp/1-35.txt |wc -l` -ge 1 ]
	then
		cat ./mytmp/1-35.txt >> $RESULT_FILE 2>&1
	else
		echo "���� ��� ����" >> $RESULT_FILE 2>&1
	fi
else
	echo "�� 5.7�̸� �ش� �÷� ����" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.03 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "v5.6 �̸��� ���ͺ�" >> $RESULT_FILE 2>&1
echo "v5.6 �̻󿡼� validate_password Plugin ���� ����(�Ʒ��� �����ϸ� ��ȣ))" >> $RESULT_FILE 2>&1
echo "- Validate_password_length 8 (�̻�)" >> $RESULT_FILE 2>&1
echo "- Validate_password_mixed_case_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_number_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_policy MEDIUM" >> $RESULT_FILE 2>&1
echo "LOW (8�� �̻�), MEDIUM (�⺻ 8�� �̻�,����,�ҹ���,�빮��,Ư�����ڸ� ����), STRONG(�⺻ 8�� �̻�,����,�ҹ���,�빮��,Ư������,�����ܾ� ����)" >> $RESULT_FILE 2>&1
echo "- Validate_password_special_char_count 1" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "�� Plugin ���" >> $RESULT_FILE 2>&1
	cat ./mytmp/1-3.txt | grep '\/' | awk '{print $4}' > ./mytmp/1-31.txt
	cat ./mytmp/1-31.txt >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
	
	echo "�� Plugin ��� �� ���ϵ�" >> $RESULT_FILE 2>&1
	ls -al `cat ./mytmp/1-31.txt` >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
else
	echo "Plugin �̻��" >> $RESULT_FILE 2>&1
fi
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.04 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �����ͺ��̽� ������ ������ �� �ʿ��� ���� �� �׷쿡 ���ؼ��� ���"
echo "##### �����ͺ��̽� ������ ������ �� �ʿ��� ���� �� �׷쿡 ���ؼ��� ���" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ������ �����ڱ����� ���� �ο� �Ǿ� �ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user,select_priv,insert_priv,Delete_priv from mysql.user where (select_priv='Y' or insert_priv='Y' or delete_priv='Y') and user<>'root';" -t > ./mytmp/1-4.txt

if [ `cat ./mytmp/1-4.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-4.txt >> $RESULT_FILE 2>&1
else
	echo "select_priv, insert_priv, delete_priv ������ �ο��� ������ �������� ����" >> $RESULT_FILE 2>&1
fi
echo '' >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.04 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo 'root�� ������ �Ϲݰ����� select_priv, insert_priv, delete_priv���� ���� �ο��Ǿ��ִ��� Ȯ�� ��, �ο��� ������ ���Ͽ� Ÿ�缺 ���� �� ���ʿ�� ������ ȸ���Ͽ��� ��' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.05 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �н����� ���뿡 ���� ����"
echo "##### �н����� ���뿡 ���� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: �Ķ���� ������ ����� ��� PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1 

echo " " >> $RESULT_FILE 2>&1
echo "1.05 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.06 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### DB ����� ���� ������ �ο�"
echo "##### DB ����� ���� ������ �ο�" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ����ں� ������ ����ϰ� �ִ� ���" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user from mysql.user;" -t > ./mytmp/1-6.txt


if [ `cat ./mytmp/1-6.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-6.txt >> $RESULT_FILE 2>&1
else
	echo "������ �������� ����(���� ��� ����)" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.06 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo '������� ��� ����' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.07 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### ���ݿ��� DB �������� ���� ����"
echo "##### ���ݿ��� DB �������� ���� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ���� IP �� ��Ʈ�� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


echo "mysql.user���̺�" >> $RESULT_FILE 2>&1 
$SQL_query -e "select host, user from mysql.user;" -t > ./mytmp/1-7-1.txt
cat ./mytmp/1-7-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "mysql.db���̺�" >> $RESULT_FILE 2>&1 
$SQL_query -e "select host, user from mysql.db;" -t > ./mytmp/1-7-2.txt
cat ./mytmp/1-7-2.txt >> $RESULT_FILE 2>&1


echo " " >> $RESULT_FILE 2>&1
echo "1.07 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo 'host �׸� ���� %������ �Ǿ� �ִ� ��� ��� IP�� ���� ������ ���������� �����Ͽ��� ��.' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1




























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.08 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### DBA�̿��� �ΰ����� ���� ����� �ý��� ���̺� ���� ���� ����"
echo "##### DBA�̿��� �ΰ����� ���� ����� �ý��� ���̺� ���� ���� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: DBA�� ���� ������ ���̺� �Ϲ� ����� ������ �Ұ��� �� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


$SQL_query -e "select host, user,select_priv from mysql.user where select_priv='Y' and user<>'root';" -t > ./mytmp/1-8-1.txt
$SQL_query -e "select host, user, db, select_priv from mysql.db where (db='mysql' and select_priv='Y') and user<>'root';" -t > ./mytmp/1-8-2.txt
$SQL_query -e "select DB,USER,TABLE_NAME, TABLE_PRIV from mysql.tables_priv where (db='mysql' and table_name='user') and table_priv='select';" -t > ./mytmp/1-8-3.txt
echo "[Mysql User ����]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/1-8-1.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-8-1.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql User�� select������ �������� ����" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1

echo "[Mysql DB ����]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/1-8-2.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-8-2.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql DB�� select ������ �������� ����" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1

echo "[Mysql Table ����]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/1-8-3.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-8-3.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql Table�� select ������ �������� ����" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1


echo " " >> $RESULT_FILE 2>&1
echo "1.08 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "root�� ������ �Ϲݰ����� select������ �ο��Ǿ��ִ��� Ȯ�� ��, �ο��� ������ ���Ͽ� Ÿ�缺 ���� �� ���ʿ�� ������ ȸ���Ͽ��� ��." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1





























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.09 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### ����Ŭ �����ͺ��̽��� ��� ������ �н����� ����"
echo "##### ����Ŭ �����ͺ��̽��� ��� ������ �н����� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: Listener�� �н����尡 �����Ǿ� �ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.09 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1



































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.10 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ����"
echo "##### ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ���ʿ��� ODBC/OLE-DB�� ��ġ���� ���� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL ���н� �迭 �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.10 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.11 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### ���� Ƚ���� �α��� ���� �� ��� ��å ����"
echo "##### ���� Ƚ���� �α��� ���� �� ��� ��å ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: �α��� �õ� Ƚ���� �����ϴ� ���� ������ ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL���� �ش� ��� �������� ����(N/A)" >> $RESULT_FILE 2>&1
echo "��, �ַ��, Ʈ���� ���� �̿��� ��� ��� ���� ����" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.11 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1









































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.12 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �����ͺ��̽��� �ֿ� ���� ��ȣ ���� ���� DB ������ umask�� 022�̻����� ����"
echo "##### �����ͺ��̽��� �ֿ� ���� ��ȣ ���� ���� DB ������ umask�� 022�̻����� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ������ umask�� 022 �̻����� �����Ǿ��ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "�� ���� �α��� ���� UMASK"                                                               >> $RESULT_FILE 2>&1
echo "------------------------------------------------"                                        >> $RESULT_FILE 2>&1
umask                                                                                          >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
if [ -f /etc/profile ]
then
	echo "�� /etc/profile ����(�ùٸ� ����: umask 022)"                                          >> $RESULT_FILE 2>&1
	echo "------------------------------------------------"                                      >> $RESULT_FILE 2>&1
	if [ `cat /etc/profile | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
		cat /etc/profile | grep -i umask | grep -v ^#                                              >> $RESULT_FILE 2>&1
	else
		echo "umask ������ �����ϴ�."                                                              >> $RESULT_FILE 2>&1
	fi
else
	echo "/etc/profile ������ �����ϴ�."                                                         >> $RESULT_FILE 2>&1
fi
echo " "                                                                                       >> $RESULT_FILE 2>&1
if [ -f /etc/csh.login ]
then
  echo "�� /etc/csh.login ����"                                                                >> $RESULT_FILE 2>&1
  echo "------------------------------------------------"                                      >> $RESULT_FILE 2>&1
  if [ `cat /etc/csh.login | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
  	cat /etc/csh.login | grep -i umask | grep -v ^#                                            >> $RESULT_FILE 2>&1
  else
		echo "umask ������ �����ϴ�."                                                              >> $RESULT_FILE 2>&1
	fi
else
  echo "/etc/csh.login ������ �����ϴ�."                                                       >> $RESULT_FILE 2>&1
fi
echo " "                                                                                       >> $RESULT_FILE 2>&1
if [ -f /etc/csh.login ]
then
  echo "�� /etc/csh.cshrc ����"                                                                >> $RESULT_FILE 2>&1
  echo "------------------------------------------------"                                      >> $RESULT_FILE 2>&1
  if [ `cat /etc/csh.cshrc | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
  	cat /etc/csh.cshrc | grep -i umask | grep -v ^#                                            >> $RESULT_FILE 2>&1
  else
		echo "umask ������ �����ϴ�."                                                              >> $RESULT_FILE 2>&1
	fi
else
  echo "/etc/csh.cshrc ������ �����ϴ�."                                                       >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.12 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "UMASK ���� 022 �̸� ��ȣ"                                                        >> $RESULT_FILE 2>&1
echo "(1) sh, ksh, bash ���� ��� /etc/profile ���� ������ �������"                 >> $RESULT_FILE 2>&1
echo "(2) csh, tcsh ���� ��� /etc/csh.cshrc �Ǵ� /etc/csh.login ���� ������ �������" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1



































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.13 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �����ͺ��̽��� �ֿ� ��������, �н����� ���� �� �ֿ� ���ϵ��� ���� ���� ����"
echo "##### �����ͺ��̽��� �ֿ� ��������, �н����� ���� �� �ֿ� ���ϵ��� ���� ���� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: �ֿ� ���� ���� �� ���͸��� �۹̼� ������ �Ǿ��ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "�� etc/my.cnf ���� ����" >> $RESULT_FILE 2>&1
ls -al /etc/my.cnf  > ./mytmp/1-13.txt

if [ `cat ./mytmp/1-13.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-13.txt >> $RESULT_FILE 2>&1
else
	echo "/etc/my.cnf ������ �������� ����." >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.13 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "etc/my.cnf ���� 600 �Ǵ� 640���� ����" >> $RESULT_FILE 2>&1 
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1










































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.14 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### ������ �̿��� ����ڰ� ����Ŭ �������� ������ ���� ������ �α� �� trace ���Ͽ� ���� ���� ���� ����"
echo "##### ������ �̿��� ����ڰ� ����Ŭ �������� ������ ���� ������ �α� �� trace ���Ͽ� ���� ���� ���� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: �ֿ� ���� ���� �� �α� ���Ͽ� ���� �۹̼��� �����ڷ� ������ ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.14 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.15 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �������α׷� �Ǵ� DBA ������ Role�� Public���� �������� �ʵ��� ����"
echo "##### �������α׷� �Ǵ� DBA ������ Role�� Public���� �������� �ʵ��� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: DBA ������ Role�� Public ���� �����Ǿ����� ���� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.15 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.16 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES�� FALSE�� ����"
echo "##### OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES�� FALSE�� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES������ FALSE�� �Ǿ��ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.16 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1




































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.17 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �н����� Ȯ���Լ��� �����Ǿ� ����Ǵ°�?"
echo "##### �н����� Ȯ���Լ��� �����Ǿ� ����Ǵ°�?" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: �н����� ���� �Լ��� ������ ����Ǵ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


echo "���� ������ $my_ver�Դϴ�. ������ ���� ���ͺ� �ʿ�" >> $RESULT_FILE 2>&1
echo "validate_password Plugin�� 5.6 �̻� ����Ʈ�� ������(password_length, policy �� Ȯ�� ����)" >> $RESULT_FILE 2>&1
echo "authentication_string, password_expired, password_last_changed, password_lifetime, account_locked�÷��� 5.7�̻� ����" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "�� Plugin ���" >> $RESULT_FILE 2>&1

$SQL_query -e "show global variables like '%plu%';" -t > ./mytmp/1-3.txt
cat ./mytmp/1-3.txt >> $RESULT_FILE 2>&1

if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "�� �н����� ���� ���� �Ķ����(Plugin ����)" >> $RESULT_FILE 2>&1
	$SQL_query -e "show global variables like '%vali%';" -t > ./mytmp/1-32.txt
	cat ./mytmp/1-32.txt | grep -v -i "query_cache" >> $RESULT_FILE 2>&1
else
	echo "Plugin �̻��" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "�� �н����� ����, ��������, ������� �� �÷�" >> $RESULT_FILE 2>&1

if [ $my_ver_re -ge 4 ] 
then
	$SQL_query -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > ./mytmp/1-35.txt
	if [ `cat ./mytmp/1-35.txt |wc -l` -ge 1 ]
	then
		cat ./mytmp/1-35.txt >> $RESULT_FILE 2>&1
	else
		echo "���� ��� ����" >> $RESULT_FILE 2>&1
	fi
else
	echo "�� 5.7�̸� �ش� �÷� ����" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "v5.6 �̸��� ���ͺ�" >> $RESULT_FILE 2>&1
echo "v5.6 �̻󿡼� validate_password Plugin ���� ����(�Ʒ��� �����ϸ� ��ȣ))" >> $RESULT_FILE 2>&1
echo "- Validate_password_length 8 (�̻�)" >> $RESULT_FILE 2>&1
echo "- Validate_password_mixed_case_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_number_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_policy MEDIUM" >> $RESULT_FILE 2>&1
echo "LOW (8�� �̻�), MEDIUM (�⺻ 8�� �̻�,����,�ҹ���,�빮��,Ư�����ڸ� ����), STRONG(�⺻ 8�� �̻�,����,�ҹ���,�빮��,Ư������,�����ܾ� ����)" >> $RESULT_FILE 2>&1
echo "- Validate_password_special_char_count 1" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "�� Plugin ���" >> $RESULT_FILE 2>&1
	cat ./mytmp/1-3.txt | grep '\/' | awk '{print $4}' > ./mytmp/1-31.txt
	cat ./mytmp/1-31.txt >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
	
	echo "�� Plugin ��� �� ���ϵ�" >> $RESULT_FILE 2>&1
	ls -al `cat ./mytmp/1-31.txt` >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
else
	echo "Plugin �̻��" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.17 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.18 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �ΰ����� ���� Object Owner�� �������� �ʴ°�?"
echo "##### �ΰ����� ���� Object Owner�� �������� �ʴ°�?" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: Object Owner �� ������ SYS, SYSTEM, ������ ���� ������ ���ѵ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.18 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1




























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.19 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### grant option�� role�� ���� �ο��ǵ��� ����"
echo "##### grant option�� role�� ���� �ο��ǵ��� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: WITH_GRANT_OPTION�� ROLE�� ���Ͽ� �����Ǿ��ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


$SQL_query -e "SELECT user,grant_priv FROM mysql.user;" -t > ./mytmp/1-19.txt


if [ `cat ./mytmp/1-19.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-19.txt >> $RESULT_FILE 2>&1
else
	echo "���� ��� ����" >> $RESULT_FILE 2>&1
fi


echo " " >> $RESULT_FILE 2>&1
echo "1.19 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.20 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �����ͺ��̽��� �ڿ� ���� ����� TRUE�� ����"
echo "##### �����ͺ��̽��� �ڿ� ���� ����� TRUE�� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: RESOURCE_LIMIT ������ �� �Ǿ��ִ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.20 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.21 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �����ͺ��̽��� ���� �ֽ� ������ġ�� ��� �ǰ� ������ ��� ����"
echo "##### �����ͺ��̽��� ���� �ֽ� ������ġ�� ��� �ǰ� ������ ��� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ������ �ֽ� ��ġ�� ������ ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select version();" -t > ./mytmp/1-21.txt
cat ./mytmp/1-21.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.21 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "2017�� 1�� ����" >> $RESULT_FILE 2>&1
echo "MySQL 8.0 development" >> $RESULT_FILE 2>&1
echo "MySQL 5.7 GA" >> $RESULT_FILE 2>&1
echo "MySQL 5.6 GA" >> $RESULT_FILE 2>&1
echo "MySQL 5.5 GA" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1





























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.22 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### �����ͺ��̽��� ����, ����, ���� ���� �������� ����� ������ ��å�� �����ϵ��� ����"
echo "##### �����ͺ��̽��� ����, ����, ���� ���� �������� ����� ������ ��å�� �����ϵ��� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: DBMS�� ���� �α� ���� ��å�� �����Ǿ� ������, ��å�� ����Ǿ��ִ� ���" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "�� case1. mysql ���� logging ��� Ȯ�� " >> $RESULT_FILE 2>&1 
$SQL_query -e "show global variables where Variable_name in ('version', 'log', 'general_log', 'general_log_file', 'log_error', 'log_output', 'slow_query_log', 'slow_query_log_file');" -t > ./mytmp/1-22-1.txt
cat ./mytmp/1-22-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "�� case2. /etc/my.cnf ���� Ȯ��" >> $RESULT_FILE 2>&1 
	if [ -f /etc/my.cnf ]
	then
		cat /etc/my.cnf | grep -v "^#" >> $RESULT_FILE 2>&1 
	else
		echo "/etc/my.cnf ���� ����"
	fi
	
echo " " >> $RESULT_FILE 2>&1 
echo " " >> $RESULT_FILE 2>&1 
echo "�� case3. audit_log plugin ��� Ȯ��" >> $RESULT_FILE 2>&1 
$SQL_query -e "show plugins;" -t > ./mytmp/1-22-2.txt
cat ./mytmp/1-22-2.txt | egrep -i "name|audit_log" >> $RESULT_FILE 2>&1 
echo " " >> $RESULT_FILE 2>&1 

echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
echo "�� case4. Ȯ�� �Ұ� �� �ַ�� ��� ���� ���ͺ� " >> $RESULT_FILE 2>&1 
echo " " >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.22 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "������ mysql ���� log������" >> $RESULT_FILE 2>&1
$SQL_query -e "show global variables like '%log%';" -t > ./mytmp/1-22-0.txt
cat ./mytmp/1-22-0.txt >> $RESULT_FILE 2>&1 

echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1

mydatadir=`ps -ef |grep mysql |grep datadir|awk -F'datadir' '{print $2}'|awk -F'=' '{print $2}'|awk -F' ' '{print $1}'|uniq -d`
echo "������ datadir��� -> $mydatadir" >> $RESULT_FILE 2>&1 
ls -al $mydatadir >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "������ plugin Ǯ ����Ʈ" >> $RESULT_FILE 2>&1 
cat ./mytmp/1-22-2.txt >> $RESULT_FILE 2>&1 
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1






























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.23 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### ���ȿ� ������� ���� ������ �����ͺ��̽��� ����ϰ� �ִ°�?"
echo "##### ���ȿ� ������� ���� ������ �����ͺ��̽��� ����ϰ� �ִ°�?" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: ���� ��ġ�� �����Ǵ� ������ ����ϴ� ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select version();" -t > ./mytmp/1-21.txt
cat ./mytmp/1-21.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.23 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1



























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.24 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### Audit Table�� �����ͺ��̽� ������ ������ ���� �ֵ��� ����"
echo "##### Audit Table�� �����ͺ��̽� ������ ������ ���� �ֵ��� ����" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "�� ����: Audit Table ���� ������ ������ �������� ������ ��� ��ȣ" >> $RESULT_FILE 2>&1 
echo "�� ��Ȳ" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL �ش���� ���� (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.24 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1

























echo " "
echo "***************************************** END *****************************************" >> $RESULT_FILE 2>&1
date                                                                                           >> $RESULT_FILE 2>&1
echo "***************************************** END *****************************************"
echo "END_RESULT"                                                                              >> $RESULT_FILE 2>&1

echo "�� �����۾��� �Ϸ�Ǿ����ϴ�. �����ϼ̽��ϴ�!"
echo " "

