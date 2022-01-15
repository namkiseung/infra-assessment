#!c:/think/bin/sh

alias ls=c:/think/bin/ls
alias grep=c:/think/bin/grep
alias awk=c:/think/bin/gawk
alias find=c:/think/bin/find
alias tr=c:/think/bin/tr
alias wget=c:/think/bin/wget
alias wc=c:/think/bin/wc
alias cat=c:/think/bin/cat
alias cacls=c:/think/bin/cacls
alias sed=c:/think/bin/sed
alias pv=c:/think/bin/pv
alias mkdir=c:/think/bin/mkdir
alias pwd=c:/think/bin/pwd
alias date=c:/think/bin/date
alias uname=c:/think/bin/uname
alias reg=c:/think/bin/reg



set BUILD_VER=0.6.3
set LAST_UPDATE=2017.09.01


#set PATH=%PATH%;c:/think/bin

_HOSTNAME=`hostname`


think="c:/think"


_TMP_DIR=$think/tmp

ipconfig | egrep "IPv4|IP Address" | awk -F: '{print $2}' | awk '{print $1}' > ./tmp/ip_list.txt
if [ `cat ./tmp/ip_list.txt | awk '{print $1}' |grep "192." |wc -l` -gt 0 ]; then
	HOST_IP=`cat ./tmp/ip_list.txt |grep "192." |head -1`
else
	if [ `cat ./tmp/ip_list.txt | awk '{print $1}' |grep "10" |grep -v "110" | grep -v "210" |wc -l` -gt 0 ]; then
	HOST_IP=`cat ./tmp/ip_list.txt |grep "10." |grep -v "110." | grep -v "210." |head -1`
	else
	HOST_IP=`cat ./tmp/ip_list.txt |head -1`
	fi
fi

_PWD=`pwd`
_ORA_DIR=$_PWD
#_TMP_DIR=$_PWD/tmp
_RET_TXT=$_ORA_DIR/result/"think_${_HOSTNAME}_oracle_${HOST_IP}"_result.txt
_RET_TXT2=$_ORA_DIR/result/"think_${_HOSTNAME}_oracle_${HOST_IP}"_result.think




echo "" > $_RET_TXT 
echo "*****************************************************************************" >> $_RET_TXT 
echo "                           think Oracle Checklist                          " >> $_RET_TXT 
echo "*****************************************************************************" >> $_RET_TXT 
echo "      Copyright 2017 think Co. Ltd. All Rights Reserved. Ver$BUILD_VER	   " >> $_RET_TXT 
echo "                      Last modify date $LAST_UPDATE						   " >> $_RET_TXT 
echo "*****************************************************************************" >> $_RET_TXT 
echo "" >> $_RET_TXT 
echo "" >> $_RET_TXT 
echo "################################# Start Time ################################" >> $_RET_TXT 
date >> $_RET_TXT 
echo "" >> $_RET_TXT 

echo "#################################   Network Status   #################################" >> $_RET_TXT 
netstat -an | egrep -i "LISTEN|ESTABLISHED" >> $_RET_TXT 
echo " " >> $_RET_TXT 

echo "******************************* Start Script *********************************" >> $_RET_TXT
echo " " >> $_RET_TXT

# Oracle directory
_ORA_HOME2=`cat $_TMP_DIR/ora_home_dir.txt`
echo $_ORA_HOME2 > $_TMP_DIR/orahometest.txt
_ORA_HOME=`cat $_TMP_DIR/orahometest.txt`
_ORA_TNS=$_ORA_HOME/network/admin
_ORA_DBS=$_ORA_HOME/dbs
_ORA_VER=`cat $_TMP_DIR/1.0.txt | grep -i "ora" | grep [0-9] | awk -F" " '{print $1}' |\
          awk -F"." '{print $1}'`
#_ORA_VER=10

# Backup TNS file
if [ -f $_ORA_TNS/listener.ora ]
   then
	  cat $_ORA_TNS/listener.ora > $_TMP_DIR/listener.txt
fi
if [ -f $_ORA_TNS/sqlnet.ora ]
   then
      cat $_ORA_TNS/sqlnet.ora > $_TMP_DIR/sqlnet.txt
fi

# 1.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo "1.01 START"
echo "1.01 START" >> $_RET_TXT
echo "1.1 기본 계정의 패스워드, 정책 등을 변경하여 사용" >> $_RET_TXT
echo "===================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "기본 계정의  패스워드를 사용하지 않은 경우 양호" >> $_RET_TXT
echo "OPEN 된 계정의 경우만 확인"                      >> $_RET_TXT
echo "선택된 레코드가 없으면 양호" >> $_RET_TXT
echo "결과값에 나온 계정은 기본 패스워드 사용 계정이므로 취약" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/1.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.01 END" >> $_RET_TXT
# 1.1 END---------------------------------------------------------------------------------------


# 1.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.02 START"
echo "1.02 START" >> $_RET_TXT
echo "1.2 scott 등 Demonstration 및 불필요 계정을 제거하거나 잠금설정 후 사용" >> $_RET_TXT
echo "=======================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "계정 정보를 확인하여 불필요한 계정이 없는 경우 양호" >> $_RET_TXT
echo "참고. 담당자 인터뷰 필요" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/1.2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.02 END" >> $_RET_TXT
# 1.2 END---------------------------------------------------------------------------------------


# 1.3 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.03 START"
echo "1.03 START" >> $_RET_TXT
echo "1.3 패스워드의 사용기간 및 복잡도를 기관의 정책에 맞도록 설정" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "패스워드를 주기적으로 변경하고 패스워드 정책이 적용되어 있는 경우 양호" >> $_RET_TXT
echo "PASSWORD_LIFE_TIME 값이 90이하 그리고 PASSWORD_GRACE_TIME 값이 5 이상 양호 " >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/1.3.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.03 END" >> $_RET_TXT
# 1.3 END---------------------------------------------------------------------------------------


# 1.4 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.04 START"
echo "1.04 START" >> $_RET_TXT
echo "1.4 데이터베이스 관리자 권한을 꼭 필요한 계정 및 그룹에 대해서만 허용" >> $_RET_TXT
echo "=====================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "SYSDBA 권한이 부적절한 일반계정 및 어플리케이션 계정에 부여되어 있지 않을 경우 양호" >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
echo "- 1. SYSDBA 권한점검" >> $_RET_TXT
cat $_TMP_DIR/1.4.1.txt >> $_RET_TXT

echo "- 2. ADMIN에 부적합 계정 존재 여부 점검" >> $_RET_TXT
cat $_TMP_DIR/1.4.2.txt >> $_RET_TXT
echo "1,2번에서 선택된 레코드가 없으면 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.04 END" >> $_RET_TXT
# 1.4 END---------------------------------------------------------------------------------------


# 1.5 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.05 START"
echo "1.05 START" >> $_RET_TXT
echo "1.5 패스워드 재사용 제약 설정" >> $_RET_TXT
echo "=============================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "파라미터 설정이 적용된 경우 양호 (PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX)" >> $_RET_TXT
echo "PASSWORD_REUSE_TIME 값이 365 이상 그리고 PASSWORD_REUSE_MAX 값이 10 이하 양호" >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
echo " ">> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/1.5.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.05 END" >> $_RET_TXT
# 1.5 END---------------------------------------------------------------------------------------


# 1.6 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.06 START"
echo "1.06 START" >> $_RET_TXT
echo "1.6 DB 사용자 계정을 개별적으로 부여" >> $_RET_TXT
echo "====================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "일반 사용자 계정 사용자 계정 중에 공용으로 사용하는 계정이 없을 경우 양호" >> $_RET_TXT
echo "참고. 담당자 인터뷰 필요" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/1.6.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.06 END" >> $_RET_TXT
# 1.6 END---------------------------------------------------------------------------------------


# 2.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.01 START"
echo "2.01 START" >> $_RET_TXT
echo "2.1 원격에서 DB 서버로의 접속 제한" >> $_RET_TXT
echo "==================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "방화벽 설정 또는 디비접근제어 솔루션 적용 시 양호" >> $_RET_TXT
echo "원격 인증기능이 아래와 같이 비활성화(FALSE) 되어있으면 양호(솔루션 등 IP제어 인터뷰 필요) " >> $_RET_TXT
echo " - REMOTE_OS_AUTHENT=FALSE" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "* 버전별 파라미터 확인" >> $_RET_TXT
echo " - 9i 이상 버전 : SQL 구문으로 확인" >> $_RET_TXT
echo " - 8i 이하 버전 : init<SID>.ora 파일 확인" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
_INT_FILE="$_ORA_DBS/init*.ora"
if [ $_ORA_VER -ge 9 ] 
   then 
      cat $_TMP_DIR/2.1.txt >> $_RET_TXT
   else
      cat $_INT_FILE | grep -i REMOTE_OS >> $_RET_TXT
	  	  if [ `cat $_INT_FILE | grep -i "REMOTE_OS_AUTHENT" | grep -v "^#" | grep -i "FALSE" | wc -l` -eq 0 ]
			 then 
				echo "REMOTE_OS_AUTHENT설정 없음" >> $_RET_TXT
		  fi
fi
echo " " >> $_RET_TXT
echo "2.01 END" >> $_RET_TXT
# 2.1 END---------------------------------------------------------------------------------------


# 2.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.02 START"
echo "2.02 START" >> $_RET_TXT
echo "2.2 DBA이외의 인가되지 않은 사용자가 시스템 테이블에 접근할 수 없도록 설정" >> $_RET_TXT
echo "==========================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "DBA만 접근 가능하여야 할 테이블에 비인가자 계정이 접근 가능할 경우 취약" >> $_RET_TXT
echo "결과 값이 없을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/2.2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.02 END" >> $_RET_TXT
# 2.2 END---------------------------------------------------------------------------------------


# 2.3 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.03 START"
echo "2.03 START" >> $_RET_TXT
echo "2.3 오라클 데이터베이스의 경우 리스너의 패스워드를 설정하여 사용" >> $_RET_TXT
echo "================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "리스너의 패스워드가 설정 되어 있을 경우 양호 (10g 이상은 N/A)" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT

if [ `cat $_ORA_TNS/listener.ora | grep -i passwords | wc -l` -gt 0 ]
   then
      cat $_ORA_TNS/listener.ora | grep -i passwords >> $_RET_TXT
   else
      echo "password 설정이 설정이 되어있지 않음" >> $_RET_TXT
fi

#cat $_TMP_DIR/2.3.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.03 END" >> $_RET_TXT
# 2.3 END---------------------------------------------------------------------------------------


# 2.4 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.04 START"
echo "2.04 START" >> $_RET_TXT
echo "2.4 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거" >> $_RET_TXT
echo "================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "불필요한 ODBC/OLE-DB가 설치되지 않은 경우 양호" >> $_RET_TXT
cat $_TMP_DIR/2_4.txt >> $_RET_TXT

reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" >> $_RET_TXT

echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.04 END" >> $_RET_TXT
# 2.4 END---------------------------------------------------------------------------------------


# 2.5 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.05 START"
echo "2.05 START" >> $_RET_TXT
echo "2.5 일정 횟수의 로그인 실패 시 이에 대한 잠금정책 설정" >> $_RET_TXT
echo "======================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "일정한 횟수의 로그인 실패에 대한 계정잠금을 설정을 할 경우 양호" >> $_RET_TXT
echo "Failed_login_attempts 값이 5 으로 설정 되어 있으며, " >> $_RET_TXT
echo "password_lock_time이 값이 1/1140 일 경우 양호     " >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/2.5.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.05 END" >> $_RET_TXT
# 2.5 END---------------------------------------------------------------------------------------


# 2.6 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.06 START"
echo "2.06 START" >> $_RET_TXT
echo "2.6 데이터베이스의 주요 파일 보호 등을 위해 DB 계정의 umask를 022 이상으로 설정" >> $_RET_TXT
echo "===============================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "DB 계정의 umask를 022 이상으로 설정 되있을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
echo "Windows OS N/A" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.06 END" >> $_RET_TXT

# 2.6 END---------------------------------------------------------------------------------------


# 2.7 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.07 START"
echo "2.07 START" >> $_RET_TXT
echo "2.7 데이터베이스의 주요 설정파일, 패스워드 파일 등과 같은 주요 파일들의 접근 권한 설정" >> $_RET_TXT
echo "======================================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "■ $ORACLE_HOME/bin/ 아래 oracle, sqlplus, sqlldr, sqlload, proc, oraenv, oerr, exp, imp, tkprof, tnsping, wrap(퍼미션 755) " >> $_RET_TXT
echo "■ $ORACLE_HOME/bin 아래 svrmgr, lsnctl, dbsnmp (퍼미션 750) " >> $_RET_TXT
echo "■ $ORACLE_HOME/nework (퍼미션 755) " >> $_RET_TXT
echo "■ $ORACLE_HOME/network/admin 아래 listener.ora, sqlnet.ora 등 (퍼미션 755)" >> $_RET_TXT
echo "■ $ORACLE_HOME/lib (퍼미션 755) " >> $_RET_TXT
echo "■ $ORACLE_HOME/network/admin 아래 환경파일 tnsnames.ora, protocol.ora, sqlpnet.ora (퍼미션 644) " >> $_RET_TXT
echo "■ $ORACLE_HOME/dbs/init.ora (퍼미션 640) " >> $_RET_TXT
echo "■ $ORACLE_HOME/dbs/init<SID>.ora (퍼미션 640) " >> $_RET_TXT
echo "■ control, redo 로그 파일, 데이터 파일 ( 퍼미션 600 또는 640)" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
echo "Windows OS N/A" >> $_RET_TXT

echo " " >> $_RET_TXT
echo "버젼 및 설정에 따라 파일이 존재하지 않을 수 있음" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.07 END" >> $_RET_TXT

# 2.7 END---------------------------------------------------------------------------------------


# 2.8 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.08 START"
echo "2.08 START" >> $_RET_TXT
echo "2.8 관리자 이외의 사용자가 오라클 리스너의 접속을 통해 리스너 로그 및 trace 파일에 대한 변경설정" >> $_RET_TXT
echo "================================================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "listener.ora 파일에 ADMIN_RESTRICTIONS_LISTENER=ON 이 적용 되있을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT


echo " " >> $_RET_TXT
echo "- Listener 파일 접근제한 설정 -" >> $_RET_TXT
_ADM_FLAG="0"
if [ `cat "$_ORA_TNS/listener.ora" | grep -i ADMIN_REST | grep -v "^#" |\
      grep -i ON | wc -l` -eq 0 ]
   then
      _ADM_FLAG="1"
      echo "접근제어 설정이 되어있지 않습니다" >> $_RET_TXT
   else
      cat "$_ORA_TNS/listener.ora" | grep -i ADMIN_REST >> $_RET_TXT
fi


cat $_TMP_DIR/2.8.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.08 END" >> $_RET_TXT
# 2.8 END---------------------------------------------------------------------------------------


# 3.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.01 START"
echo "3.01 START" >> $_RET_TXT
echo "3.1 응용프로그램 또는 DBA 계정의 Role이 Public으로 설정되지 않도록 조정" >> $_RET_TXT
echo "=======================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "응용프로그램 또는 DBA 계정의 Role이 Public으로 설정되지 않을 경우 양호" >> $_RET_TXT
echo "선택된 레코드가 없으면 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/3.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.01 END" >> $_RET_TXT
# 3.1 END---------------------------------------------------------------------------------------


# 3.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.02 START"
echo "3.02 START" >> $_RET_TXT
echo "3.2 OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES를 FALSE로 설정" >> $_RET_TXT
echo "======================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES를 FALSE로 설정 되어있을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/3.2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.02 END" >> $_RET_TXT
# 3.2 END---------------------------------------------------------------------------------------


# 3.3 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.03 START"
echo "3.03 START" >> $_RET_TXT
echo "3.3 패스워드 확인함수 설정" >> $_RET_TXT
echo "==========================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "PASSWORD_VERIFY_FUNCTION 의 활성화시 양호 " >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/3.3.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.03 END" >> $_RET_TXT
# 3.3 END---------------------------------------------------------------------------------------


# 3.4 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.04 START"
echo "3.04 START" >> $_RET_TXT
echo "3.4 인가되지 않은 Object Owner의 존재 여부" >> $_RET_TXT
echo "==========================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "Object Owner는 SYS, SYSTEM과 같은 데이터베이스 관리자 계정과 응용 프로그램의 관리자 계정에만 존재할 경우 양호" >> $_RET_TXT
echo "해당 오브젝트의 소유자가 적절한지 담당자와 인터뷰" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/3.4.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.04 END" >> $_RET_TXT
# 3.4 END---------------------------------------------------------------------------------------


# 3.5 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.05 START"
echo "3.05 START" >> $_RET_TXT
echo "3.5 grant option이 role에 의해 부여되도록 설정" >> $_RET_TXT
echo "==============================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "테이블에 대한 GRANTABLE 옵션이 적절한 사용자에게만 부여되어 있을 경우 양호 " >> $_RET_TXT
echo "선택된 레코드가 없으면 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/3.5.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.05 END" >> $_RET_TXT
# 3.5 END---------------------------------------------------------------------------------------


# 3.6 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.06 START"
echo "3.06 START" >> $_RET_TXT
echo "3.6 데이터베이스의 자원 제한 기능을 TRUE로 설정" >> $_RET_TXT
echo "===============================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "데이터베이스 자원 제한 기능을 활성화 시 양호" >> $_RET_TXT
echo "RESOURCE_LIMIT TRUE 일 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/3.6.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.06 END" >> $_RET_TXT
# 3.6 END---------------------------------------------------------------------------------------


# 4.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.01 START"
echo "4.01 START" >> $_RET_TXT
echo "4.1 데이터베이스에 대해 최신 보안패치와 밴더 권고사항을 모두 적용" >> $_RET_TXT
echo "=================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "최신 보안패치 적용이 되어있을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/4.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.01 END" >> $_RET_TXT
# 4.1 END---------------------------------------------------------------------------------------


# 4.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.02 START"
echo "4.02 START" >> $_RET_TXT
echo "4.2 데이터베이스의 접근, 변경, 삭제 등의 감사기록이 기관의 감사기록 정책에 적합하도록 설정" >> $_RET_TXT
echo "==========================================================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "접근, 변경, 삭제 등의 감사 기록이 정책에 적합하도록 설정 되어있는 경우 양호" >> $_RET_TXT
echo "담당자 인터뷰 필요" >> $_RET_TXT
echo "DBsafer, DB-i 등과 같은 솔루션이나 DBMS 자체 감사기록 설정을 통해 감사 기록을 수집할 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/4.2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.02 END" >> $_RET_TXT
# 4.2 END---------------------------------------------------------------------------------------


# 4.3 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.03 START"
echo "4.03 START" >> $_RET_TXT
echo "4.3 보안에 취약하지 않은 버전의 데이터베이스를 사용" >> $_RET_TXT
echo "===================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "Oracle 12cg Release 1	12.1.0.2.0" >> $_RET_TXT
echo "Oracle 11g Release 2	11.2.0.2 zLinux64" >> $_RET_TXT
echo "Oracle 11g Release 2	11.2.0.1 All OS" >> $_RET_TXT
echo "Oracle 11g Release 1	11.1.0.7 Microsoft Windows Server 2008" >> $_RET_TXT
echo "Oracle 11g Release 1	11.1.0.6 All OS" >> $_RET_TXT
echo "Oracle 10g Release 2	10.2.0.5 Windows 64bit itanium" >> $_RET_TXT
echo "Oracle 10g Release 2	10.2.0.4 Windows, MAC OS X" >> $_RET_TXT
echo "Oracle 10g Release 2	10.2.0.1 All OS" >> $_RET_TXT
echo "Oracle 10g Release 1	10.1.0.5" >> $_RET_TXT
echo "Oracle 9i Release 2	9.2.0.8" >> $_RET_TXT
echo "Oracle 9i Release 1	9.0.1.4" >> $_RET_TXT
echo "Oracle 8i Release 3	8.1.7.4" >> $_RET_TXT
echo "Oracle 8i		8.0.6.3" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/4.3.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.03 END" >> $_RET_TXT

# 4.3 END---------------------------------------------------------------------------------------


# 5.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.01 START"
echo "5.01 START" >> $_RET_TXT
echo "5.1 Audit Table은 데이터베이스 관리자 계정에 속해 있도록 설정" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT

echo "[기준]" >> $_RET_TXT
echo "Audit Table은 데이터베이스 관리자 계정에만  속해 있을 경우 양호" >> $_RET_TXT
echo "AUD$ TAABLE이 관리자 계정에 속해있을 경우 " >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/5.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.01 END" >> $_RET_TXT
# 5.1 END---------------------------------------------------------------------------------------


# 참고.1 계정 정보 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "참고.1 계정 정보"
echo "참고.1 계정 정보" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "각 계정의 활성화 여부, 사용하는 profile 확인 시 참고" >> $_RET_TXT
echo " " >> $_RET_TXT
cat $_TMP_DIR/info1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
# 참고.1 계정 정보 END---------------------------------------------------------------------------------------


# 참고.2 계정별 role 정보 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "참고.2 계정별 role 정보"
echo "참고.2 계정별 role 정보" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "계정별 role의 확인 필요 시 참고" >> $_RET_TXT
echo "(ex> DBA권한의 계정 확인 등)" >> $_RET_TXT
echo " " >> $_RET_TXT
cat $_TMP_DIR/info2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
# 참고.2 계정별 role 정보 END---------------------------------------------------------------------------------------


# 참고.3 전체 Profile 정보 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "참고.3 전체 Profile 정보"
echo "참고.3 전체 Profile 정보" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo " " >> $_RET_TXT
cat $_TMP_DIR/info3.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
# 참고.3 전체 Profile 정보 END---------------------------------------------------------------------------------------


echo "" >> $_RET_TXT
echo "#################################################################################" >> $_RET_TXT
echo "########################## 스크립트 변수값 ###########################" >> $_RET_TXT
echo "#################################################################################" >> $_RET_TXT
echo "_ORA_TNS는 $_ORA_TNS" >> $_RET_TXT
echo "_ORA_DBS는 $_ORA_DBS" >> $_RET_TXT
echo "_ORA_VER는 $_ORA_VER" >> $_RET_TXT
echo "_ORA_HOME는 $_ORA_HOME" >> $_RET_TXT


echo "" >> $_RET_TXT
echo "#################################################################################" >> $_RET_TXT
echo "########################## cat $_ORA_TNS/listener.ora ###########################" >> $_RET_TXT
echo "#################################################################################" >> $_RET_TXT
if [ -f $_TMP_DIR/listener.txt ]
then
	cat $_TMP_DIR/listener.txt >> $_RET_TXT
else
	echo "입력하신 ORA_HOME 디렉토리 밑의 /network/admin/listener.ora가 존재하지 않음" >> $_RET_TXT
fi


echo "" >> $_RET_TXT
echo "#################################################################################" >> $_RET_TXT
echo "########################### cat $_ORA_TNS/sqlnet.ora ############################" >> $_RET_TXT
echo "#################################################################################" >> $_RET_TXT
if [ -f $_TMP_DIR/sqlnet.txt ]
then
	cat $_TMP_DIR/sqlnet.txt >> $_RET_TXT
else
	echo "입력하신 ORA_HOME 디렉토리 밑의 /network/admin/sqlnet.ora가 존재하지 않음" >> $_RET_TXT
fi


echo "" >> $_RET_TXT
echo "###############################################################################" >> $_RET_TXT
echo "############################# Oracle Version info ############################" >> $_RET_TXT 
echo "###############################################################################" >> $_RET_TXT
cat $_TMP_DIR/1.0.txt | grep -i "ora" >> $_RET_TXT


echo "" >> $_RET_TXT
echo "###############################################################################" >> $_RET_TXT
echo "################################ ifconfig -a ################################" >> $_RET_TXT
echo "###############################################################################" >> $_RET_TXT
ipconfig /all >> $_RET_TXT

echo "" >> $_RET_TXT
echo "################################# END Time ################################" >> $_RET_TXT 
date >> $_RET_TXT 

echo "" 
echo "######################### Script가 종료되었습니다 ###########################" 

echo " " >> $_RET_TXT 
echo " " >> $_RET_TXT 
echo "****************************** End Script ***********************************" >> $_RET_TXT
echo "END_RESULT" >> $_RET_TXT
echo " " >> $_RET_TXT 
