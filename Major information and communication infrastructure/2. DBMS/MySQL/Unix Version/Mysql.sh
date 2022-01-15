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
echo "■■■■■■■■■■■■■■■■■■■             MySQL Security Check           	 ■■■■■■■■■■■■■■■■■■■■" >> $RESULT_FILE 2>&1
echo "■■■■■■■■■■■■■■■■■■■      Copyright ⓒ 2017, SK think Co. Ltd.    ■■■■■■■■■■■■■■■■■■■■" >> $RESULT_FILE 2>&1
echo "■■■■■■■■■■■■■■■■■■■     Ver $DBVersion // Last update $DBLast_update ■■■■■■■■■■■■■■■■■■■■" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1



echo ''
echo ''
echo '[Mysql 구동 경로]'
ps -ef |grep mysql


echo ''
echo ''
echo ''
echo "  Mysql 설치 디렉토리를 입력하십시오. "
echo "  Mysql 실행 파일이 /usr/bin 디렉토리에 있다면, /usr 를 입력하여야 합니다." 
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
				echo "입력하신 디렉토리는 존재하나, 하위 경로에 mysql 파일이 없습니다."
				echo " "
			fi
        else
            echo "   입력하신 디렉토리가 존재하지 않습니다. 다시 입력하여 주십시오."
            echo " "
        fi
    else
		echo "   잘못 입력하셨습니다. 다시 입력하여 주십시오."
        echo " "
	fi
done
echo " "


echo "Mysql root계정 패스워드가 설정이 되어 있는 경우                 1 "
echo "Mysql root계정 패스워드가 NULL로 설정이 되어 있는 경우          2 "
read my_pwd

#id/pwd 체크
if [ $my_pwd = "1" ] 
	then
		echo " "
		echo "[Mysql 구동 계정 입력]"
		echo -n "(ex. 계정/비밀번호 -> root/test123) : " 
		read idpwd
		id=`echo $idpwd|awk -F'/' '{print $1}'`
		pwd2=`echo $idpwd|awk -F'/' '{print $2}'`
		
		SQL_query="$mysql/bin/mysql -u $id -p$pwd2"
else
		echo " "
		echo "[Mysql 구동 계정 입력]"
		echo -n "(ex. root) : " 
		read id
		
		SQL_query="$mysql/bin/mysql -u $id"
fi

mkdir ./mytmp


#version 체크
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
echo "버전은 $my_ver, $my_ver_re 입니다." >> $RESULT_FILE 2>&1
echo "설치 디렉토리는 $mysql 입니다." >> $RESULT_FILE 2>&1
echo "pw유뮤 체크는 $my_pwd 입니다." >> $RESULT_FILE 2>&1
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
echo "##### 기본 계정의 패스워드, 정책 등을 변경하여 사용"
echo "##### 기본 계정의 패스워드, 정책 등을 변경하여 사용" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 기본 계정의 패스워드를 변경하여 사용하는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
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
	echo "쿼리 결과 없음" >> $RESULT_FILE 2>&1
fi


echo " " >> $RESULT_FILE 2>&1
echo "1.01 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "해당 호스트에 대하여 Null User/Password가 사용되고 있으므로 Null User를 패스워드 변경 및 삭제하여야 합니다." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1

















echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.02 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### scott 등 Demonstration 및 불필요 계정을 제거하거나 잠금설정 후 사용"
echo "##### scott 등 Demonstration 및 불필요 계정을 제거하거나 잠금설정 후 사용" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 계정 정보를 확인하여 불필요한 계정이 없는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user from mysql.user where user!='root';" -t > ./mytmp/1-2.txt


if [ `cat ./mytmp/1-2.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-2.txt >> $RESULT_FILE 2>&1
else
	echo "root계정 이외의 계정이 존재하지 않음(쿼리 결과 없음)" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.02 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "사용하지 않거나 불필요한 계정이 있을경우 삭제하여야 합니다." >> $RESULT_FILE 2>&1
echo "Anonymous 계정(user 컬럼이 빈칸)이 존재하고, 패스워드가 설정되어 있지 않으면 DB에 임의 접속이 가능함." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.03 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 패스워드의 사용기간 및 복잡도를 기관의 정책에 맞도록 설정"
echo "##### 패스워드의 사용기간 및 복잡도를 기관의 정책에 맞도록 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 패스워드를 주기적으로 변경하고, 패스워드 정책이 적용되어 있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "현재 버전은 $my_ver입니다. 버전에 따라 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)" >> $RESULT_FILE 2>&1
echo "authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "● Plugin 경로" >> $RESULT_FILE 2>&1

$SQL_query -e "show global variables like '%plu%';" -t > ./mytmp/1-3.txt
cat ./mytmp/1-3.txt >> $RESULT_FILE 2>&1

if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "● 패스워드 검증 관련 파라미터(Plugin 관련)" >> $RESULT_FILE 2>&1
	$SQL_query -e "show global variables like '%vali%';" -t > ./mytmp/1-32.txt
	cat ./mytmp/1-32.txt | grep -v -i "query_cache" >> $RESULT_FILE 2>&1
else
	echo "Plugin 미사용" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "● 패스워드 만료, 변경일자, 계정잠김 등 컬럼" >> $RESULT_FILE 2>&1

if [ $my_ver_re -ge 4 ] 
then
	$SQL_query -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > ./mytmp/1-35.txt
	if [ `cat ./mytmp/1-35.txt |wc -l` -ge 1 ]
	then
		cat ./mytmp/1-35.txt >> $RESULT_FILE 2>&1
	else
		echo "쿼리 결과 없음" >> $RESULT_FILE 2>&1
	fi
else
	echo "☞ 5.7미만 해당 컬럼 없음" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.03 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "v5.6 미만은 인터뷰" >> $RESULT_FILE 2>&1
echo "v5.6 이상에서 validate_password Plugin 사용시 설정(아래를 만족하면 양호))" >> $RESULT_FILE 2>&1
echo "- Validate_password_length 8 (이상)" >> $RESULT_FILE 2>&1
echo "- Validate_password_mixed_case_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_number_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_policy MEDIUM" >> $RESULT_FILE 2>&1
echo "LOW (8자 이상), MEDIUM (기본 8자 이상,숫자,소문자,대문자,특수문자를 포함), STRONG(기본 8자 이상,숫자,소문자,대문자,특수문자,사전단어 포함)" >> $RESULT_FILE 2>&1
echo "- Validate_password_special_char_count 1" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "● Plugin 경로" >> $RESULT_FILE 2>&1
	cat ./mytmp/1-3.txt | grep '\/' | awk '{print $4}' > ./mytmp/1-31.txt
	cat ./mytmp/1-31.txt >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
	
	echo "● Plugin 경로 내 파일들" >> $RESULT_FILE 2>&1
	ls -al `cat ./mytmp/1-31.txt` >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
else
	echo "Plugin 미사용" >> $RESULT_FILE 2>&1
fi
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.04 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 데이터베이스 관리자 권한을 꼭 필요한 계정 및 그룹에 대해서만 허용"
echo "##### 데이터베이스 관리자 권한을 꼭 필요한 계정 및 그룹에 대해서만 허용" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 계정별 관리자권한이 차등 부여 되어 있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user,select_priv,insert_priv,Delete_priv from mysql.user where (select_priv='Y' or insert_priv='Y' or delete_priv='Y') and user<>'root';" -t > ./mytmp/1-4.txt

if [ `cat ./mytmp/1-4.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-4.txt >> $RESULT_FILE 2>&1
else
	echo "select_priv, insert_priv, delete_priv 권한이 부여된 계정이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo '' >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.04 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo 'root를 제외한 일반계정에 select_priv, insert_priv, delete_priv권한 등이 부여되어있는지 확인 후, 부여된 계정에 대하여 타당성 검토 후 불필요시 권한을 회수하여야 함' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.05 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 패스워드 재사용에 대한 제약"
echo "##### 패스워드 재사용에 대한 제약" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 파라미터 설정이 적용된 경우 PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1 

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
echo "##### DB 사용자 계정 개별적 부여"
echo "##### DB 사용자 계정 개별적 부여" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 사용자별 계정을 사용하고 있는 경우" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user from mysql.user;" -t > ./mytmp/1-6.txt


if [ `cat ./mytmp/1-6.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-6.txt >> $RESULT_FILE 2>&1
else
	echo "계정이 존재하지 않음(쿼리 결과 없음)" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.06 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo '공용계정 사용 금지' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.07 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 원격에서 DB 서버로의 접속 제한"
echo "##### 원격에서 DB 서버로의 접속 제한" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 허용된 IP 및 포트에 대한 접근 통제가 되어 있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


echo "mysql.user테이블" >> $RESULT_FILE 2>&1 
$SQL_query -e "select host, user from mysql.user;" -t > ./mytmp/1-7-1.txt
cat ./mytmp/1-7-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "mysql.db테이블" >> $RESULT_FILE 2>&1 
$SQL_query -e "select host, user from mysql.db;" -t > ./mytmp/1-7-2.txt
cat ./mytmp/1-7-2.txt >> $RESULT_FILE 2>&1


echo " " >> $RESULT_FILE 2>&1
echo "1.07 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo 'host 항목에 대해 %설정이 되어 있는 경우 모든 IP에 대한 접근이 가능함으로 제거하여야 함.' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1




























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.08 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### DBA이외의 인가되지 않은 사용자 시스템 테이블 접근 제한 설정"
echo "##### DBA이외의 인가되지 않은 사용자 시스템 테이블 접근 제한 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: DBA만 접근 가능한 테이블에 일반 사용자 접근이 불가능 할 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


$SQL_query -e "select host, user,select_priv from mysql.user where select_priv='Y' and user<>'root';" -t > ./mytmp/1-8-1.txt
$SQL_query -e "select host, user, db, select_priv from mysql.db where (db='mysql' and select_priv='Y') and user<>'root';" -t > ./mytmp/1-8-2.txt
$SQL_query -e "select DB,USER,TABLE_NAME, TABLE_PRIV from mysql.tables_priv where (db='mysql' and table_name='user') and table_priv='select';" -t > ./mytmp/1-8-3.txt
echo "[Mysql User 권한]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/1-8-1.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-8-1.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql User에 select권한이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1

echo "[Mysql DB 권한]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/1-8-2.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-8-2.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql DB에 select 권한이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1

echo "[Mysql Table 권한]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/1-8-3.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-8-3.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql Table에 select 권한이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1


echo " " >> $RESULT_FILE 2>&1
echo "1.08 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "root를 제외한 일반계정에 select권한이 부여되어있는지 확인 후, 부여된 계정에 대하여 타당성 검토 후 불필요시 권한을 회수하여야 함." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1





























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.09 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 오라클 데이터베이스의 경우 리스너 패스워드 설정"
echo "##### 오라클 데이터베이스의 경우 리스너 패스워드 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: Listener의 패스워드가 설정되어 있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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
echo "##### 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거"
echo "##### 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 불필요한 ODBC/OLE-DB가 설치되지 않은 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 유닉스 계열 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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
echo "##### 일정 횟수의 로그인 실패 시 잠금 정책 설정"
echo "##### 일정 횟수의 로그인 실패 시 잠금 정책 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 로그인 시도 횟수를 제한하는 값을 설정한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL에서 해당 기능 지원하지 않음(N/A)" >> $RESULT_FILE 2>&1
echo "단, 솔루션, 트리거 등을 이용할 경우 기능 구현 가능" >> $RESULT_FILE 2>&1

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
echo "##### 데이터베이스의 주요 파일 보호 등을 위해 DB 계정의 umask를 022이상으로 설정"
echo "##### 데이터베이스의 주요 파일 보호 등을 위해 DB 계정의 umask를 022이상으로 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 계정의 umask가 022 이상으로 설정되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "☞ 현재 로그인 계정 UMASK"                                                               >> $RESULT_FILE 2>&1
echo "------------------------------------------------"                                        >> $RESULT_FILE 2>&1
umask                                                                                          >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
if [ -f /etc/profile ]
then
	echo "① /etc/profile 파일(올바른 설정: umask 022)"                                          >> $RESULT_FILE 2>&1
	echo "------------------------------------------------"                                      >> $RESULT_FILE 2>&1
	if [ `cat /etc/profile | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
		cat /etc/profile | grep -i umask | grep -v ^#                                              >> $RESULT_FILE 2>&1
	else
		echo "umask 설정이 없습니다."                                                              >> $RESULT_FILE 2>&1
	fi
else
	echo "/etc/profile 파일이 없습니다."                                                         >> $RESULT_FILE 2>&1
fi
echo " "                                                                                       >> $RESULT_FILE 2>&1
if [ -f /etc/csh.login ]
then
  echo "② /etc/csh.login 파일"                                                                >> $RESULT_FILE 2>&1
  echo "------------------------------------------------"                                      >> $RESULT_FILE 2>&1
  if [ `cat /etc/csh.login | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
  	cat /etc/csh.login | grep -i umask | grep -v ^#                                            >> $RESULT_FILE 2>&1
  else
		echo "umask 설정이 없습니다."                                                              >> $RESULT_FILE 2>&1
	fi
else
  echo "/etc/csh.login 파일이 없습니다."                                                       >> $RESULT_FILE 2>&1
fi
echo " "                                                                                       >> $RESULT_FILE 2>&1
if [ -f /etc/csh.login ]
then
  echo "③ /etc/csh.cshrc 파일"                                                                >> $RESULT_FILE 2>&1
  echo "------------------------------------------------"                                      >> $RESULT_FILE 2>&1
  if [ `cat /etc/csh.cshrc | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
  	cat /etc/csh.cshrc | grep -i umask | grep -v ^#                                            >> $RESULT_FILE 2>&1
  else
		echo "umask 설정이 없습니다."                                                              >> $RESULT_FILE 2>&1
	fi
else
  echo "/etc/csh.cshrc 파일이 없습니다."                                                       >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.12 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "UMASK 값이 022 이면 양호"                                                        >> $RESULT_FILE 2>&1
echo "(1) sh, ksh, bash 쉘의 경우 /etc/profile 파일 설정을 적용받음"                 >> $RESULT_FILE 2>&1
echo "(2) csh, tcsh 쉘의 경우 /etc/csh.cshrc 또는 /etc/csh.login 파일 설정을 적용받음" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1



































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.13 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 설정"
echo "##### 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 주요 설정 파일 및 디렉터리의 퍼미션 설정이 되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "● etc/my.cnf 파일 권한" >> $RESULT_FILE 2>&1
ls -al /etc/my.cnf  > ./mytmp/1-13.txt

if [ `cat ./mytmp/1-13.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-13.txt >> $RESULT_FILE 2>&1
else
	echo "/etc/my.cnf 파일이 존재하지 않음." >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "1.13 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "etc/my.cnf 파일 600 또는 640으로 설정" >> $RESULT_FILE 2>&1 
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1










































echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.14 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 관리자 이외의 사용자가 오라클 리스너의 접속을 통해 리스너 로그 및 trace 파일에 대한 변경 권한 제한"
echo "##### 관리자 이외의 사용자가 오라클 리스너의 접속을 통해 리스너 로그 및 trace 파일에 대한 변경 권한 제한" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 주요 설정 파일 및 로그 파일에 대한 퍼미션을 관리자로 설정한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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
echo "##### 응용프로그램 또는 DBA 계정의 Role이 Public으로 설정되지 않도록 조정"
echo "##### 응용프로그램 또는 DBA 계정의 Role이 Public으로 설정되지 않도록 조정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: DBA 계정의 Role이 Public 으로 설정되어있지 않은 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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
echo "##### OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES를 FALSE로 설정"
echo "##### OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES를 FALSE로 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES설정이 FALSE로 되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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
echo "##### 패스워드 확인함수가 설정되어 적용되는가?"
echo "##### 패스워드 확인함수가 설정되어 적용되는가?" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 패스워드 검증 함수로 검증이 진행되는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


echo "현재 버전은 $my_ver입니다. 버전에 따라 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)" >> $RESULT_FILE 2>&1
echo "authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "● Plugin 경로" >> $RESULT_FILE 2>&1

$SQL_query -e "show global variables like '%plu%';" -t > ./mytmp/1-3.txt
cat ./mytmp/1-3.txt >> $RESULT_FILE 2>&1

if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "● 패스워드 검증 관련 파라미터(Plugin 관련)" >> $RESULT_FILE 2>&1
	$SQL_query -e "show global variables like '%vali%';" -t > ./mytmp/1-32.txt
	cat ./mytmp/1-32.txt | grep -v -i "query_cache" >> $RESULT_FILE 2>&1
else
	echo "Plugin 미사용" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "● 패스워드 만료, 변경일자, 계정잠김 등 컬럼" >> $RESULT_FILE 2>&1

if [ $my_ver_re -ge 4 ] 
then
	$SQL_query -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > ./mytmp/1-35.txt
	if [ `cat ./mytmp/1-35.txt |wc -l` -ge 1 ]
	then
		cat ./mytmp/1-35.txt >> $RESULT_FILE 2>&1
	else
		echo "쿼리 결과 없음" >> $RESULT_FILE 2>&1
	fi
else
	echo "☞ 5.7미만 해당 컬럼 없음" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "v5.6 미만은 인터뷰" >> $RESULT_FILE 2>&1
echo "v5.6 이상에서 validate_password Plugin 사용시 설정(아래를 만족하면 양호))" >> $RESULT_FILE 2>&1
echo "- Validate_password_length 8 (이상)" >> $RESULT_FILE 2>&1
echo "- Validate_password_mixed_case_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_number_count 1" >> $RESULT_FILE 2>&1
echo "- Validate_password_policy MEDIUM" >> $RESULT_FILE 2>&1
echo "LOW (8자 이상), MEDIUM (기본 8자 이상,숫자,소문자,대문자,특수문자를 포함), STRONG(기본 8자 이상,숫자,소문자,대문자,특수문자,사전단어 포함)" >> $RESULT_FILE 2>&1
echo "- Validate_password_special_char_count 1" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
if [ "`cat ./mytmp/1-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "● Plugin 경로" >> $RESULT_FILE 2>&1
	cat ./mytmp/1-3.txt | grep '\/' | awk '{print $4}' > ./mytmp/1-31.txt
	cat ./mytmp/1-31.txt >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
	
	echo "● Plugin 경로 내 파일들" >> $RESULT_FILE 2>&1
	ls -al `cat ./mytmp/1-31.txt` >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
else
	echo "Plugin 미사용" >> $RESULT_FILE 2>&1
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
echo "##### 인가되지 않은 Object Owner가 존재하지 않는가?"
echo "##### 인가되지 않은 Object Owner가 존재하지 않는가?" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: Object Owner 의 권한이 SYS, SYSTEM, 관리자 계정 등으로 제한된 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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
echo "##### grant option이 role에 의해 부여되도록 설정"
echo "##### grant option이 role에 의해 부여되도록 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: WITH_GRANT_OPTION이 ROLE에 의하여 설정되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 


$SQL_query -e "SELECT user,grant_priv FROM mysql.user;" -t > ./mytmp/1-19.txt


if [ `cat ./mytmp/1-19.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-19.txt >> $RESULT_FILE 2>&1
else
	echo "쿼리 결과 없음" >> $RESULT_FILE 2>&1
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
echo "##### 데이터베이스의 자원 제한 기능을 TRUE로 설정"
echo "##### 데이터베이스의 자원 제한 기능을 TRUE로 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: RESOURCE_LIMIT 설정이 로 되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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
echo "##### 데이터베이스에 대해 최신 보안패치와 밴더 권고 사항을 모두 적용"
echo "##### 데이터베이스에 대해 최신 보안패치와 밴더 권고 사항을 모두 적용" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 버전별 최신 패치를 적용한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select version();" -t > ./mytmp/1-21.txt
cat ./mytmp/1-21.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.21 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "2017년 1월 기준" >> $RESULT_FILE 2>&1
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
echo "##### 데이터베이스의 접근, 변경, 삭제 등의 감사기록이 기관의 감사기록 정책에 적합하도록 설정"
echo "##### 데이터베이스의 접근, 변경, 삭제 등의 감사기록이 기관의 감사기록 정책에 적합하도록 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: DBMS의 감사 로그 저장 정책이 수립되어 있으며, 정책이 적용되어있는 경우" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "● case1. mysql 지원 logging 기능 확인 " >> $RESULT_FILE 2>&1 
$SQL_query -e "show global variables where Variable_name in ('version', 'log', 'general_log', 'general_log_file', 'log_error', 'log_output', 'slow_query_log', 'slow_query_log_file');" -t > ./mytmp/1-22-1.txt
cat ./mytmp/1-22-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "● case2. /etc/my.cnf 파일 확인" >> $RESULT_FILE 2>&1 
	if [ -f /etc/my.cnf ]
	then
		cat /etc/my.cnf | grep -v "^#" >> $RESULT_FILE 2>&1 
	else
		echo "/etc/my.cnf 파일 없음"
	fi
	
echo " " >> $RESULT_FILE 2>&1 
echo " " >> $RESULT_FILE 2>&1 
echo "● case3. audit_log plugin 사용 확인" >> $RESULT_FILE 2>&1 
$SQL_query -e "show plugins;" -t > ./mytmp/1-22-2.txt
cat ./mytmp/1-22-2.txt | egrep -i "name|audit_log" >> $RESULT_FILE 2>&1 
echo " " >> $RESULT_FILE 2>&1 

echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
echo "● case4. 확인 불가 시 솔루션 사용 여부 인터뷰 " >> $RESULT_FILE 2>&1 
echo " " >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1.22 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "☞참고 mysql 지원 log설정들" >> $RESULT_FILE 2>&1
$SQL_query -e "show global variables like '%log%';" -t > ./mytmp/1-22-0.txt
cat ./mytmp/1-22-0.txt >> $RESULT_FILE 2>&1 

echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1

mydatadir=`ps -ef |grep mysql |grep datadir|awk -F'datadir' '{print $2}'|awk -F'=' '{print $2}'|awk -F' ' '{print $1}'|uniq -d`
echo "☞참고 datadir경로 -> $mydatadir" >> $RESULT_FILE 2>&1 
ls -al $mydatadir >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "☞참고 plugin 풀 리스트" >> $RESULT_FILE 2>&1 
cat ./mytmp/1-22-2.txt >> $RESULT_FILE 2>&1 
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1






























echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.23 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 보안에 취약하지 않은 버전의 데이터베이스를 사용하고 있는가?"
echo "##### 보안에 취약하지 않은 버전의 데이터베이스를 사용하고 있는가?" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 보안 패치가 지원되는 버전을 사용하는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
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
echo "##### Audit Table은 데이터베이스 관리자 계정에 속해 있도록 설정"
echo "##### Audit Table은 데이터베이스 관리자 계정에 속해 있도록 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: Audit Table 접근 권한이 관리자 계정으로 설정한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

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

echo "☞ 진단작업이 완료되었습니다. 수고하셨습니다!"
echo " "

