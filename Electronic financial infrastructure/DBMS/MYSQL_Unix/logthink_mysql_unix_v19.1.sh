 #!/bin/sh

LANG=C
export LANG

clear

DBVersion=19.1
DBLast_update=2019.02

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
echo "■■■■■■■■■■■■■■■■■■■      Copyright ⓒ 2019, logthink Co. Ltd.    ■■■■■■■■■■■■■■■■■■■■" >> $RESULT_FILE 2>&1
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


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        1. 사용자 인증        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0101 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 비인가자의 접근 차단을 위한 사용자 계정 관리"
echo "##### 비인가자의 접근 차단을 위한 사용자 계정 관리" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 계정 정보를 확인하여 불필요한 계정이 없는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user from mysql.user where user!='root';" -t > ./mytmp/1-1.txt

if [ `cat ./mytmp/1-1.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/1-1.txt >> $RESULT_FILE 2>&1
else
	echo "root계정 이외의 계정이 존재하지 않음(쿼리 결과 없음)" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "0101 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "사용하지 않거나 불필요한 계정이 있을경우 삭제하여야 합니다." >> $RESULT_FILE 2>&1
echo "Anonymous 계정(user 컬럼이 빈칸)이 존재하고, 패스워드가 설정되어 있지 않으면 DB에 임의 접속이 가능함." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0102 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 로그인 실패 횟수에 따른 잠금시간 등 계정 잠금 정책 설정"
echo "##### 로그인 실패 횟수에 따른 잠금시간 등 계정 잠금 정책 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 로그인 시도 횟수를 제한하는 값을 설정한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL에서 해당 기능 지원하지 않음(N/A)" >> $RESULT_FILE 2>&1
echo "단, 솔루션, 트리거 등을 이용할 경우 기능 구현 가능" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0102 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0103 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### SYSDBA 로그인 제한 설정"
echo "##### SYSDBA 로그인 제한 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: root 패스워드가 null로 설정되어있는 경우 취약" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user, password from mysql.user;" -t > ./mytmp/1-3-1.txt
cat ./mytmp/1-3-1.txt >> $RESULT_FILE 2>&1
$SQL_query -e "select host, user, password from mysql.user where user='root';" -t > ./mytmp/1-3-2.txt
cat ./mytmp/1-3-2.txt >> $RESULT_FILE 2>&1


echo " " >> $RESULT_FILE 2>&1
echo "0103 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        2. 계정 관리        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0201 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 패스워드 재사용에 대한 제약이 설정 여부"
echo "##### 패스워드 재사용에 대한 제약이 설정 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 파라미터 설정이 적용된 경우 PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1 

echo " " >> $RESULT_FILE 2>&1
echo "0201 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0202 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### DB 사용자 계정을 개별적으로 부여"
echo "##### DB 사용자 계정을 개별적으로 부여" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 사용자별 계정을 사용하고 있는 경우" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user from mysql.user;" -t > ./mytmp/2-2.txt


if [ `cat ./mytmp/2-2.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/2-2.txt >> $RESULT_FILE 2>&1
else
	echo "계정이 존재하지 않음(쿼리 결과 없음)" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "0202 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        3. 비밀번호 관리        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0301 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 유추가능한 비밀번호 설정여부(DB계정)"
echo "##### 유추가능한 비밀번호 설정여부(DB계정)" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 비밀번호 유추 가능 계정이 없을 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "인터뷰-담당자 인터뷰를 통해 우추 가능한 패스워드를 사용하는지 여부 점검" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0301 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0302 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 기본 계정 및 패스워드 변경(디폴트 ID 및 패스워드 변경 및 잠금)"
echo "##### 기본 계정 및 패스워드 변경(디폴트 ID 및 패스워드 변경 및 잠금)" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 기본 계정의 패스워드를 변경하여 사용하는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
if [ $my_ver_re -ge 4 ] 
	then
	$SQL_query -e "select host, user, authentication_string from mysql.user where user='root';" -t > ./mytmp/3-2.txt
else
	$SQL_query -e "select host, user, password from mysql.user where user='root';" -t > ./mytmp/3-2.txt
fi

if [ `cat ./mytmp/3-2.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/3-2.txt >> $RESULT_FILE 2>&1

else
	echo "쿼리 결과 없음" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "0302 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "해당 호스트에 대하여 Null User/Password가 사용되고 있으므로 Null User를 패스워드 변경 및 삭제하여야 합니다." >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0303 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 비밀번호 복잡도 설정"
echo "##### 비밀번호 복잡도 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 비밀번호 복잡도 설정이 되어 있거나, 관련 솔루션을 통하여 복잡도 설정이 통제되는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "현재 버전은 $my_ver입니다. 버전에 따라 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)" >> $RESULT_FILE 2>&1
echo "authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "● Plugin 경로" >> $RESULT_FILE 2>&1

$SQL_query -e "show global variables like '%plu%';" -t > ./mytmp/3-3.txt
cat ./mytmp/3-3.txt >> $RESULT_FILE 2>&1

if [ "`cat ./mytmp/3-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "● 패스워드 검증 관련 파라미터(Plugin 관련)" >> $RESULT_FILE 2>&1
	$SQL_query -e "show global variables like '%vali%';" -t > ./mytmp/3-3-1.txt
	cat ./mytmp/3-3-1.txt | grep -v -i "query_cache" >> $RESULT_FILE 2>&1
else
	echo "Plugin 미사용" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0303 END" >> $RESULT_FILE 2>&1
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
if [ "`cat ./mytmp/3-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "● Plugin 경로" >> $RESULT_FILE 2>&1
	cat ./mytmp/3-3.txt | grep '\/' | awk '{print $4}' > ./mytmp/3-3-0.txt
	cat ./mytmp/3-3-0.txt >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
	
	echo "● Plugin 경로 내 파일들" >> $RESULT_FILE 2>&1
	ls -al `cat ./mytmp/3-3-0.txt` >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
else
	echo "Plugin 미사용" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0304 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 비밀번호의 주기적인 변경"
echo "##### 비밀번호의 주기적인 변경" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 패스워드를 주기적으로 변경하고, 패스워드 정책이 적용되어 있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "현재 버전은 $my_ver입니다. 버전에 따라 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "validate_password Plugin은 5.6 이상 디폴트로 존재함(password_length, policy 등 확인 가능)" >> $RESULT_FILE 2>&1
echo "authentication_string, password_expired, password_last_changed, password_lifetime, account_locked컬럼은 5.7이상 존재" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "● Plugin 경로" >> $RESULT_FILE 2>&1

cat ./mytmp/3-3.txt >> $RESULT_FILE 2>&1


echo " " >> $RESULT_FILE 2>&1
echo "● 패스워드 만료, 변경일자, 계정잠김 등 컬럼" >> $RESULT_FILE 2>&1

if [ $my_ver_re -ge 4 ] 
then
	$SQL_query -e "select host, user, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked from mysql.user;" -t > ./mytmp/3-4-2.txt
	if [ `cat ./mytmp/3-4-2.txt |wc -l` -ge 1 ]
	then
		cat ./mytmp/3-4-2.txt >> $RESULT_FILE 2>&1
	else
		echo "쿼리 결과 없음" >> $RESULT_FILE 2>&1
	fi
else
	echo "☞ 5.7미만 해당 컬럼 없음" >> $RESULT_FILE 2>&1
fi

echo " " >> $RESULT_FILE 2>&1
echo "0104 END" >> $RESULT_FILE 2>&1
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
if [ "`cat ./mytmp/3-3.txt | grep '\/' | wc -l`" -ge "1" ]
then
	echo " " >> $RESULT_FILE 2>&1
	echo "● Plugin 경로" >> $RESULT_FILE 2>&1
	cat ./mytmp/3-3.txt | grep '\/' | awk '{print $4}' > ./mytmp/3-4-0.txt
	cat ./mytmp/3-4-0.txt >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
	
	echo "● Plugin 경로 내 파일들" >> $RESULT_FILE 2>&1
	ls -al `cat ./mytmp/3-4-0.txt` >> $RESULT_FILE 2>&1
	echo " " >> $RESULT_FILE 2>&1
else
	echo "Plugin 미사용" >> $RESULT_FILE 2>&1
fi
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0305 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### listener 비밀번호 설정 및 디폴트 포트 변경"
echo "##### listener 비밀번호 설정 및 디폴트 포트 변경" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: listener의 비밀번호 설정이 정상적으로 되어 있고, 디폴트 포트번호가 아닌 경우 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1 
echo " " >> $RESULT_FILE 2>&1
echo "0305 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        4. 접근 관리        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0401 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### DBA이외의 인가되지 않은 사용자가 시스템 테이블에 접근할 수 없도록 설정"
echo "##### DBA이외의 인가되지 않은 사용자가 시스템 테이블에 접근할 수 없도록 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: DBA만 접근 가능한 테이블에 일반 사용자 접근이 불가능 할 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
$SQL_query -e "select host, user,select_priv from mysql.user where select_priv='Y' and user<>'root';" -t > ./mytmp/4-1-1.txt
$SQL_query -e "select host, user, db, select_priv from mysql.db where (db='mysql' and select_priv='Y') and user<>'root';" -t > ./mytmp/4-1-2.txt
$SQL_query -e "select DB,USER,TABLE_NAME, TABLE_PRIV from mysql.tables_priv where (db='mysql' and table_name='user') and table_priv='select';" -t > ./mytmp/4-1-3.txt
echo "[Mysql User 권한]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/4-1-1.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/4-1-1.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql User에 select권한이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1

echo "[Mysql DB 권한]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/4-1-2.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/4-1-2.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql DB에 select 권한이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1

echo "[Mysql Table 권한]" >> $RESULT_FILE 2>&1
if [ `cat ./mytmp/4-1-3.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/4-1-3.txt >> $RESULT_FILE 2>&1
else
	echo "Mysql Table에 select 권한이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo " " >> $RESULT_FILE 2>&1
echo "0401 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0402 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거"
echo "##### 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 불필요한 ODBC/OLE-DB가 설치되지 않은 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 유닉스 계열 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0402 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0403 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 적절성 여부"
echo "##### 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 적절성 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 주요 설정 파일 및 디렉터리의 퍼미션 설정이 되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1
echo "0403 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0404 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 데이터베이스의 주요 파일 보호 등을 위한 DB 계정의 umask 설정"
echo "##### 데이터베이스의 주요 파일 보호 등을 위한 DB 계정의 umask 설정" >> $RESULT_FILE 2>&1
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

echo "0404 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "UMASK 값이 022 이면 양호"                                                        >> $RESULT_FILE 2>&1
echo "(1) sh, ksh, bash 쉘의 경우 /etc/profile 파일 설정을 적용받음"                 >> $RESULT_FILE 2>&1
echo "(2) csh, tcsh 쉘의 경우 /etc/csh.cshrc 또는 /etc/csh.login 파일 설정을 적용받음" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0405 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 오라클 리스너 로그 및 trace 파일에 대한 파일권한 적절성 여부"
echo "##### 오라클 리스너 로그 및 trace 파일에 대한 파일권한 적절성 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 주요 설정 파일 및 로그 파일에 대한 퍼미션을 관리자로 설정한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

echo "0405 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        5. 옵션 관리        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0501 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 패스워드 확인함수 적용 여부"
echo "##### 패스워드 확인함수 적용 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 패스워드 검증 함수로 검증이 진행되는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "0501 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0502 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### Role에 의한 grant option 설정 여부"
echo "##### Role에 의한 grant option 설정 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: WITH_GRANT_OPTION이 ROLE에 의하여 설정되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1



echo "0503 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 인가되지 않은 Object Owner가 존재 여부"
echo "##### 인가되지 않은 Object Owner가 존재 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: Object Owner 의 권한이 SYS, SYSTEM, 관리자 계정 등으로 제한된 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

echo "0503 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0504 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 데이터베이스의 자원 제한 기능 설정 여부"
echo "##### 데이터베이스의 자원 제한 기능 설정 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: RESOURCE_LIMIT 설정이 로 되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

echo "0504 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        6. 권한 관리        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0601 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### DBA 계정 권한 관리"
echo "##### DBA 계정 권한 관리" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 계정별 관리자권한이 차등 부여 되어 있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select host, user,select_priv,insert_priv,Delete_priv from mysql.user where (select_priv='Y' or insert_priv='Y' or delete_priv='Y') and user<>'root';" -t > ./mytmp/6-1.txt

if [ `cat ./mytmp/6-1.txt |wc -l` -ge 1 ]
	then
	cat ./mytmp/6-1.txt >> $RESULT_FILE 2>&1
else
	echo "select_priv, insert_priv, delete_priv 권한이 부여된 계정이 존재하지 않음" >> $RESULT_FILE 2>&1
fi
echo '' >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0601 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo 'root를 제외한 일반계정에 select_priv, insert_priv, delete_priv권한 등이 부여되어있는지 확인 후, 부여된 계정에 대하여 타당성 검토 후 불필요시 권한을 회수하여야 함' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0602 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 원격에서 DB 서버로의 접속 제한"
echo "##### 원격에서 DB 서버로의 접속 제한" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 허용된 IP 및 포트에 대한 접근 통제가 되어 있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "mysql.user테이블" >> $RESULT_FILE 2>&1 
$SQL_query -e "select host, user from mysql.user;" -t > ./mytmp/6-2-1.txt
cat ./mytmp/6-2-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1 
echo "mysql.db테이블" >> $RESULT_FILE 2>&1 
$SQL_query -e "select host, user from mysql.db;" -t > ./mytmp/6-2-2.txt
cat ./mytmp/6-2-2.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0602 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo 'host 항목에 대해 %설정이 되어 있는 경우 모든 IP에 대한 접근이 가능함으로 제거하여야 함.' >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0603 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### OS_ROLES,  REMOTE_OS_ROLES 설정  "
echo "##### OS_ROLES,  REMOTE_OS_ROLES 설정  " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES설정이 FALSE로 되어있는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0603 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0604 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 응용프로그램 또는 DBA 계정의 Role의 Public 설정 점검"
echo "##### 응용프로그램 또는 DBA 계정의 Role의 Public 설정 점검" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: DBA 계정의 Role이 Public 으로 설정되어있지 않은 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0604 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        7. 설정 관리        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0701 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 세션 Idle timeout 설정"
echo "##### 세션 Idle timeout 설정" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 세션 Idle timeout 설정(5분) 혹은 관련 솔루션을 통하여 해당 기능 사용할 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "timeout 설정 쿼리결과" >> $RESULT_FILE 2>&1 
$SQL_query -e "show variables like '%timeout%';" -t > ./mytmp/7-1.txt
cat ./mytmp/7-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0701 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        8. 패치 관리        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0801 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 데이터베이스 최신 보안패치와 밴더 권고사항 적용  "
echo "##### 데이터베이스 최신 보안패치와 밴더 권고사항 적용  " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 버전별 최신 패치를 적용한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select version();" -t > ./mytmp/8-1.txt
cat ./mytmp/8-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0801 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0802 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 보안에 취약하지 않은 버전의 데이터베이스 사용 여부"
echo "##### 보안에 취약하지 않은 버전의 데이터베이스 사용 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 보안 패치가 지원되는 버전을 사용하는 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "select version();" -t > ./mytmp/8-2.txt
cat ./mytmp/8-2.txt >> $RESULT_FILE 2>&1

echo "0802 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        9. 감사        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "0901 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 감사 기능 설정 점검"
echo "##### 감사 기능 설정 점검" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 기본 감사 기능이 실행 중 이거나 솔루션을 통해 DBMS감사 기능을 수행 중 일 경우 양호" >> $RESULT_FILE 2>&1
echo "      : DBMS의 감사 로그 저장 정책이 수립되어 있으며, 정책이 적용되어있는 경우" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

$SQL_query -e "show variables like '%general_log%';" -t > ./mytmp/9-1.txt
cat ./mytmp/9-1.txt >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "0901 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        10. 관리적 물리적 보안        ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1001 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### DB서버 중요정보 암호화 적용 여부"
echo "##### DB서버 중요정보 암호화 적용 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: 비밀번호 칼럼(Column)에 암호화 되어 저장할 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 

echo "인터뷰 점검 : 담당자와 인터뷰를 통해 개인정보 및 비밀번호등 중요정보 암호화여부 확인필요" >> $RESULT_FILE 2>&1

echo " " >> $RESULT_FILE 2>&1
echo "1001 END" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "=======================================================================================" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1


echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "###########################        11. 로그 관리       ################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1


echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1101 START" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "##### 데이터베이스 관리자 계정에 Audit Table이 속해 있는 여부"
echo "##### 데이터베이스 관리자 계정에 Audit Table이 속해 있는 여부" >> $RESULT_FILE 2>&1
echo "#######################################################################################" >> $RESULT_FILE 2>&1
echo "■ 기준: Audit Table 접근 권한이 관리자 계정으로 설정한 경우 양호" >> $RESULT_FILE 2>&1 
echo "■ 현황" >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1 
echo "MySQL 해당사항 없음 (N/A)" >> $RESULT_FILE 2>&1
echo "1101 END" >> $RESULT_FILE 2>&1
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

rm -rf ./mytmp

echo "☞ 진단작업이 완료되었습니다. 수고하셨습니다!"
echo " "

