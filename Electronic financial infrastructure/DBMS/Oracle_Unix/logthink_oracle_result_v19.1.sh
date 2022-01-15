#!/bin/sh

alias ls=ls
alias grep=/bin/grep

_PWD=`/bin/pwd`
_ORA_DIR=$_PWD
_TMP_DIR=$_PWD/tmp
_ORA_SID=$ORACLE_SID
_RET_TXT=$_ORA_DIR/`hostname`"_"`date +%m%d`"_oracle_"$_ORA_SID.txt


Version=19.1
Last_modify=2019.02


echo "" > $_RET_TXT 
echo "*****************************************************************************" >> $_RET_TXT 
echo "                           think Oracle Checklist                          " >> $_RET_TXT 
echo "*****************************************************************************" >> $_RET_TXT 
echo "        Copyright 2019 think Co. Ltd. All Rights Reserved. Ver$Version	   " >> $_RET_TXT 
echo "                      Last modify date $Last_modify						   " >> $_RET_TXT 
echo "*****************************************************************************" >> $_RET_TXT 
echo "" >> $_RET_TXT 
echo "" >> $_RET_TXT 
echo "################################# Start Time ################################" >> $_RET_TXT 
echo "" >> $_RET_TXT 
date >> $_RET_TXT 

echo "******************************* Start Script *********************************" >> $_RET_TXT
echo " " >> $_RET_TXT

# Oracle directory
_ORA_HOME=`cat $_TMP_DIR/ora_home_dir.txt`
_ORA_TNS=$_ORA_HOME/network/admin
_ORA_DBS=$_ORA_HOME/dbs
_ORA_VER=`cat $_TMP_DIR/1.0.txt | grep -i "ora" | grep [0-9] | awk -F" " '{print $1}' |\
          awk -F"." '{print $1}'`
#_ORA_VER=10

# Backup TNS file
if [ -f $_ORA_TNS/listener.ora ]
   then
      cat "$_ORA_TNS/listener.ora" > $_TMP_DIR/listener.txt
fi
if [ -f $_ORA_TNS/sqlnet.ora ]
   then
      cat "$_ORA_TNS/sqlnet.ora" > $_TMP_DIR/sqlnet.txt
fi


# 1.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "1.01 START" >> $_RET_TXT
echo "1.1 비인가자의 접근 차단을 위한 사용자 계정 관리" >> $_RET_TXT
echo "==========================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "계정 정보를 확인하여 불필요한 계정이 없는 경우 양호" >> $_RET_TXT
echo "참고. 담당자 인터뷰 필요" >> $_RET_TXT
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
echo "1.02 START" >> $_RET_TXT
echo "1.2 로그인 실패 횟수에 따른 잠금시간 등 계정 잠금 정책 설정" >> $_RET_TXT
echo "==================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "일정한 횟수의 로그인 실패에 대한 계정잠금을 설정을 할 경우 양호" >> $_RET_TXT
echo "Failed_login_attempts 값이 3 으로 설정 되어 있으며, " >> $_RET_TXT
echo "password_lock_time 값이 설정되어 있을 경우 양호     " >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
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
echo "1.03 START" >> $_RET_TXT
echo "1.3 SYSDBA 로그인 제한 설정" >> $_RET_TXT
echo "================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "아이디, 패스워드 없이 인증이 불가하도록 설정되어 있으면 양호" >> $_RET_TXT
echo "SQLNET.ORA 파일안에 SQLNET.AUTHENTICATION_SERVICES=(NONE) 설정 되어 있을 경우 양호" >> $_RET_TXT
echo "(RAC인 경우 N/A로 진단)" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT

echo "◎ RAC 확인 " >> $_RET_TXT
cat $_TMP_DIR/rac.txt >> $_RET_TXT
rm -rf $_TMP_DIR/rac.txt
echo " " >> $_RET_TXT
echo "◎ sqlnet.ora 파일 확인" >> $_RET_TXT
if [ -f $_ORA_TNS/sqlnet.ora ]
then
	cat $_ORA_TNS/sqlnet.ora | grep -i "sqlnet.authentication" >> $_RET_TXT
else
	echo "☞ sqlnet.ora 파일이 존재하지 않음" >> $_RET_TXT
fi
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT


echo " " >> $_RET_TXT
echo "1.03 END" >> $_RET_TXT
# 1.3 END---------------------------------------------------------------------------------------


# 2.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.01 START" >> $_RET_TXT
echo "2.1 패스워드 재사용에 대한 제약이 설정 여부" >> $_RET_TXT
echo "===================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "파라미터 설정이 적용된 경우 양호 (PASSWORD_REUSE_TIME, PASSWORD_REUSE_MAX)" >> $_RET_TXT
echo "PASSWORD_REUSE_TIME 값이 365 이상 그리고 PASSWORD_REUSE_MAX 값이 10 이하 양호" >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
echo " ">> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/2.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.01 END" >> $_RET_TXT
# 2.1 END---------------------------------------------------------------------------------------


# 2.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.02 START" >> $_RET_TXT
echo "2.2 DB 사용자 계정을 개별적으로 부여" >> $_RET_TXT
echo "=======================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "사용자 계정 중에 공용으로 사용하는 계정이 없을 경우 양호" >> $_RET_TXT
echo "참고. 담당자 인터뷰 필요" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/2.2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "2.02 END" >> $_RET_TXT
# 2.2 END---------------------------------------------------------------------------------------


# 3.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.01 START" >> $_RET_TXT
echo "3.1 유추가능한 비밀번호 설정여부(DB계정)" >> $_RET_TXT
echo "=============================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "비밀번호 유추 가능 계정 미존재 시 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
echo "인터뷰 점검 : 담당자 인터뷰를 통해 패스워드 설정 정책 확인필요" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.01 END" >> $_RET_TXT
# 3.1 END---------------------------------------------------------------------------------------


# 3.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.02 START" >> $_RET_TXT
echo "3.2 기본 계정 및 패스워드 변경(디폴트 ID 및 패스워드 변경 및 잠금)" >> $_RET_TXT
echo "====================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "기본 계정의  패스워드를 사용하지 않은 경우 양호" >> $_RET_TXT
echo "OPEN 된 계정의 경우만 확인"                      >> $_RET_TXT
echo "선택된 레코드가 없으면 양호" >> $_RET_TXT
echo "결과값에 나온 계정은 기본 패스워드 사용 계정이므로 취약" >> $_RET_TXT
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
echo "3.03 START" >> $_RET_TXT
echo "3.3 비밀번호 복잡도 설정" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "PASSWORD_VERIFY_FUNCTION이 활성화되어 있고 복잡도 및 패스워드 길이 설정이 되어 있으면 양호 " >> $_RET_TXT
echo "관련 솔루션을 통하여 복잡도 설정이 통제되는 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT

echo "① Verify_function 쿼리 확인" >> $_RET_TXT
echo "--------------------------------" >> $_RET_TXT
cat $_TMP_DIR/3.3.txt >> $_RET_TXT
rm -rf $_TMP_DIR/3.3.txt
echo " " >> $_RET_TXT

echo "② Verify_function 설정 확인" >> $_RET_TXT
echo "--------------------------------" >> $_RET_TXT
if [ -f $_ORA_HOME/rdbms/admin/utlpwdmg.sql ]
then
	echo "◎ Oracle 11g 이하 버전 확인" >> $_RET_TXT
	cat $_ORA_HOME/rdbms/admin/utlpwdmg.sql | egrep -i "length|verify_function" >> $_RET_TXT
	echo " " >> $_RET_TXT
	echo "◎ Oracle 12c 이상 버전 확인" >> $_RET_TXT
	cat $_ORA_HOME/rdbms/admin/utlpwdmg.sql | egrep -i "complexity_check|verify_function|life_time" >> $_RET_TXT
	echo " " >> $_RET_TXT
else
	"☞ $_ORA_HOME/rdbms/admin/utlpwdmg.sql 파일이 존재하지 않음" >> $_RET_TXT
fi
echo " " >> $_RET_TXT

echo "③ Verify_function 설정 확인(11g이하)" >> $_RET_TXT
echo "--------------------------------" >> $_RET_TXT
cat $_TMP_DIR/3.31.txt >> $_RET_TXT
rm -rf $_TMP_DIR/3.31.txt
echo " " >> $_RET_TXT

echo "③ Verify_function 설정 확인(11g)" >> $_RET_TXT
echo "--------------------------------" >> $_RET_TXT
cat $_TMP_DIR/3.32.txt >> $_RET_TXT


echo " " >> $_RET_TXT
echo "3.03 END" >> $_RET_TXT
# 3.3 END---------------------------------------------------------------------------------------



# 3.4 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.04 START" >> $_RET_TXT
echo "3.4 비밀번호의 주기적인 변경" >> $_RET_TXT
echo "=====================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "패스워드를 주기적으로 변경하고 패스워드 정책이 적용되어 있는 경우 양호" >> $_RET_TXT
echo "PASSWORD_LIFE_TIME 값이 90이하 그리고 PASSWORD_GRACE_TIME 값이 5 이상 양호 " >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
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
echo "3.05 START" >> $_RET_TXT
echo "3.5 listener 비밀번호 설정 및 디폴트 포트 변경" >> $_RET_TXT
echo "================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "listener의 비밀번호 설정이 정상적으로 되어 있고, 포트번호가 디폴트 포트번호인 1521이 아닌 경우" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "◎ listener.ora 파일 확인" >> $_RET_TXT
if [ -f $_ORA_HOME/network/admin/listener.ora ]
then
	cat $_ORA_HOME/network/admin/listener.ora >> $_RET_TXT
else
  echo "☞ listener.ora 파일이 존재하지 않음" >> $_RET_TXT
fi

echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "3.05 END" >> $_RET_TXT
# 3.5 END---------------------------------------------------------------------------------------



# 4.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.01 START" >> $_RET_TXT
echo "4.1 DBA이외의 인가되지 않은 사용자가 시스템 테이블에 접근할 수 없도록 설정" >> $_RET_TXT
echo "======================================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "DBA만 접근 가능하여야 할 테이블에 비인가자 계정이 접근 가능할 경우 취약" >> $_RET_TXT
echo "결과 값이 없을 경우 양호" >> $_RET_TXT
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
echo "4.02 START" >> $_RET_TXT
echo "4.2 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거" >> $_RET_TXT
echo "=================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "- Oracle은 해당사항 없음 : N/A" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.2 END" >> $_RET_TXT
# 4.2 END---------------------------------------------------------------------------------------


# 4.3 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.03 START" >> $_RET_TXT
echo "4.3 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 적절성 여부" >> $_RET_TXT
echo "==========================================================================================" >> $_RET_TXT
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
echo "■ $ORACLE_HOME/bin/ 아래 oracle, sqlplus, sqlldr, sqlload, proc, oraenv, oerr, exp, imp, tkprof, tnsping, wrap(퍼미션 755) " >> $_RET_TXT
ls -al $_ORA_HOME/bin/oracle >> $_RET_TXT
ls -al $_ORA_HOME/bin/sqlplus >> $_RET_TXT
ls -al $_ORA_HOME/bin/sqlldr >> $_RET_TXT
ls -al $_ORA_HOME/bin/sqlload >> $_RET_TXT
ls -al $_ORA_HOME/bin/proc >> $_RET_TXT
ls -al $_ORA_HOME/bin/oraenv >> $_RET_TXT
ls -al $_ORA_HOME/bin/oerr >> $_RET_TXT
ls -al $_ORA_HOME/bin/exp >> $_RET_TXT
ls -al $_ORA_HOME/bin/imp >> $_RET_TXT
ls -al $_ORA_HOME/bin/tkprof >> $_RET_TXT
ls -al $_ORA_HOME/bin/tnsping >> $_RET_TXT
ls -al $_ORA_HOME/bin/wrap >> $_RET_TXT
echo " " >> $_RET_TXT
echo "■ $ORACLE_HOME/bin 아래 svrmgr, lsnctl, dbsnmp (퍼미션 750) " >> $_RET_TXT
ls -al $_ORA_HOME/bin/svrmgr >> $_RET_TXT
ls -al $_ORA_HOME/bin/lsnrctl >> $_RET_TXT
ls -al $_ORA_HOME/bin/dbsnmp >> $_RET_TXT
echo " " >> $_RET_TXT
echo "■ $ORACLE_HOME/network (퍼미션 755) " >> $_RET_TXT
ls -al $_ORA_HOME | grep -w network >> $_RET_TXT
echo " " >> $_RET_TXT
echo "■ $ORACLE_HOME/network/admin 아래 listener.ora, sqlnet.ora 등 (퍼미션 755)" >> $_RET_TXT
ls -al $_ORA_HOME/network/admin/listener.ora >> $_RET_TXT
ls -al $_ORA_HOME/network/admin/sqlnet.ora >> $_RET_TXT
echo " " >> $_RET_TXT
echo "■ $ORACLE_HOME/lib (퍼미션 755) " >> $_RET_TXT
ls -al $_ORA_HOME | grep -w lib >> $_RET_TXT
echo " " >> $_RET_TXT
echo "■ $ORACLE_HOME/network/admin 아래 환경파일 tnsnames.ora, protocol.ora, sqlpnet.ora (퍼미션 644) " >> $_RET_TXT
ls -al $_ORA_HOME/network/admin/tnsnames.ora >> $_RET_TXT
ls -al $_ORA_HOME/network/admin/protocol.ora >> $_RET_TXT
ls -al $_ORA_HOME/network/admin/sqlnet.ora >> $_RET_TXT
echo " " >> $_RET_TXT
echo "■ $ORACLE_HOME/dbs 아래 init.ora, init<SID>.ora (퍼미션 640) " >> $_RET_TXT
ls -al $_ORA_HOME/dbs/init*.ora >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT

echo "■ Control Files 권한 (퍼미션 600 or 640)" >> $_RET_TXT
_CONTROL=`cat $_TMP_DIR/4.3.control.txt | grep / | awk -F, '{print $1}'`
for check_file in $_CONTROL
do
   if [ -f $check_file ]
      then
         ls -l $check_file >> $_RET_TXT
      else
         echo ""$check_file" : character or block special file." >> $_RET_TXT
   fi
done

echo " " >> $_RET_TXT
echo "■ data Files 권한 (퍼미션 600 or 640)" >> $_RET_TXT
_DATA_FILE=`cat $_TMP_DIR/4.3.datafile.txt | grep / | awk -F, '{print $1}'`
for check_file in $_DATA_FILE
do
   if [ -f $check_file ]
      then
         ls -l $check_file >> $_RET_TXT
      else
         echo ""$check_file" : character or block special file." >> $_RET_TXT
   fi
done

echo " " >> $_RET_TXT
echo "■ Log Files 권한 (퍼미션 600 or 640)" >> $_RET_TXT
_LOG_FILE=`cat $_TMP_DIR/4.3.logfile.txt | grep / | awk -F, '{print $1}'`
for check_file in $_LOG_FILE
do
   if [ -f $check_file ]
      then
         ls -l $check_file >> $_RET_TXT
      else
         echo ""$check_file" : character or block special file." >> $_RET_TXT
   fi
done

echo " " >> $_RET_TXT
echo "■ spfiles 권한 (퍼미션 600 or 640)" >> $_RET_TXT
_SP_FILE=`cat $_TMP_DIR/4.3.spfile.txt | grep / | awk -F, '{print $1}'`
for check_file in $_SP_FILE
do
   if [ -f $check_file ]
      then
         ls -l $check_file >> $_RET_TXT
      else
         echo ""$check_file" : character or block special file." >> $_RET_TXT
   fi
done
echo " " >> $_RET_TXT
echo "4.03 END" >> $_RET_TXT
# 4.3 END---------------------------------------------------------------------------------------



# 4.4 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.04 START" >> $_RET_TXT
echo "4.4 데이터베이스의 주요 파일 보호 등을 위한 DB 계정의 umask 설정" >> $_RET_TXT
echo "======================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "DB 계정의 umask를 022 이상으로 설정 되있을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
umask >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.04 END" >> $_RET_TXT
# 4.4 END---------------------------------------------------------------------------------------



# 4.5 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.05 START" >> $_RET_TXT
echo "4.5 오라클 리스너 로그 및 trace 파일에 대한 파일권한 적절성 여부" >> $_RET_TXT
echo "===============================================================================" >> $_RET_TXT
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
cat $_TMP_DIR/4.5.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "4.05 END" >> $_RET_TXT
# 4.5 END---------------------------------------------------------------------------------------



# 5.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.01 START" >> $_RET_TXT
echo "5.1 패스워드 확인함수 적용 여부" >> $_RET_TXT
echo "===================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "PASSWORD_VERIFY_FUNCTION 의 활성화시 양호 " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/5.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.01 END" >> $_RET_TXT
# 5.1 END---------------------------------------------------------------------------------------



# 5.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.02 START" >> $_RET_TXT
echo "5.2 Role에 의한 grant option 설정 여부" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "테이블에 대한 GRANTABLE 옵션이 적절한 사용자에게만 부여되어 있을 경우 양호 " >> $_RET_TXT
echo "선택된 레코드가 없으면 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/5.2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.02 END" >> $_RET_TXT
# 5.2 END---------------------------------------------------------------------------------------



# 5.3 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.03 START" >> $_RET_TXT
echo "5.3 인가되지 않은 Object Owner가 존재 여부" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "Object Owner는 SYS, SYSTEM과 같은 데이터베이스 관리자 계정과 응용 프로그램의 관리자 계정에만 존재할 경우 양호" >> $_RET_TXT
echo "해당 오브젝트의 소유자가 적절한지 담당자와 인터뷰" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/5.3.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.03 END" >> $_RET_TXT
# 5.3 END---------------------------------------------------------------------------------------



# 5.4 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.04 START" >> $_RET_TXT
echo "5.4 데이터베이스의 자원 제한 기능 설정 여부" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "데이터베이스 자원 제한 기능을 활성화 시 양호" >> $_RET_TXT
echo "RESOURCE_LIMIT TRUE 일 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/5.4.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "5.04 END" >> $_RET_TXT
# 5.4 END---------------------------------------------------------------------------------------



# 6.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "6.01 START" >> $_RET_TXT
echo "6.1 DBA 계정 권한 관리" >> $_RET_TXT
echo "======================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "SYSDBA 권한이 부적절한 일반계정 및 어플리케이션 계정에 부여되어 있지 않을 경우 양호" >> $_RET_TXT
echo "참고. 점검 대상 기관의 지침에 따라 기준이 변동 될 수 있음" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
echo "- 1. SYSDBA 권한점검" >> $_RET_TXT
cat $_TMP_DIR/6.1.1.txt >> $_RET_TXT
echo "- 2. ADMIN에 부적합 계정 존재 여부 점검" >> $_RET_TXT
cat $_TMP_DIR/6.1.2.txt >> $_RET_TXT
echo "1,2번에서 선택된 레코드가 없으면 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "6.01 END" >> $_RET_TXT
# 6.1 END---------------------------------------------------------------------------------------



# 6.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "6.02 START" >> $_RET_TXT
echo "6.2 원격에서 DB 서버로의 접속 제한" >> $_RET_TXT
echo "================================================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "방화벽 설정 또는 디비접근제어 솔루션 적용 시 양호" >> $_RET_TXT
echo "원격 인증기능이 아래와 같이 비활성화(FALSE) 되어있으면 양호" >> $_RET_TXT
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
      cat $_TMP_DIR/6.2.txt >> $_RET_TXT
   else
      cat $_INT_FILE | grep -i REMOTE_OS >> $_RET_TXT
	  	  if [ `cat $_INT_FILE | grep -i "REMOTE_OS_AUTHENT" | grep -v "^#" | grep -i "FALSE" | wc -l` -eq 0 ]
			 then 
				echo "REMOTE_OS_AUTHENT설정 없음" >> $_RET_TXT
		  fi
fi
echo " " >> $_RET_TXT
echo "6.02 END" >> $_RET_TXT
# 6.2 END---------------------------------------------------------------------------------------



# 6.3 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "6.03 START" >> $_RET_TXT
echo "6.3 OS_ROLES,  REMOTE_OS_ROLES 설정" >> $_RET_TXT
echo "=======================================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "OS_ROLES, REMOTE_OS_AUTHENTICATION, REMOTE_OS_ROLES를 FALSE로 설정 되어있을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/6.3.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "6.03 END" >> $_RET_TXT
# 6.3 END---------------------------------------------------------------------------------------



# 6.4 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "6.04 START" >> $_RET_TXT
echo "6.4 응용프로그램 또는 DBA 계정의 Role의 Public 설정 점검" >> $_RET_TXT
echo "==========================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "응용프로그램 또는 DBA 계정의 Role이 Public으로 설정되지 않을 경우 양호" >> $_RET_TXT
echo "선택된 레코드가 없으면 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/6.4.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "6.04 END" >> $_RET_TXT
# 6.4 END---------------------------------------------------------------------------------------



# 7.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "7.01 START" >> $_RET_TXT
echo "7.1 세션 Idle timeout 설정" >> $_RET_TXT
echo "==============================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "세션 Idle timeout 설정(5분) 혹은 관련 솔루션을 통하여 해당 기능 사용 " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT

echo "세션 Idle timeout 설정 확인 " >> $_RET_TXT
cat $_TMP_DIR/7.1.txt >> $_RET_TXT
rm -rf $_TMP_DIR/7.1.txt
echo " " >> $_RET_TXT

echo " " >> $_RET_TXT
echo "7.01 END" >> $_RET_TXT
# 7.1 END---------------------------------------------------------------------------------------



# 8.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "8.01 START" >> $_RET_TXT
echo "8.1 데이터베이스 최신 보안패치와 밴더 권고사항 적용" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "최신 보안패치 적용이 되어있을 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT

echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/8.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "8.01 END" >> $_RET_TXT
# 8.1 END---------------------------------------------------------------------------------------



# 8.2 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "8.02 START" >> $_RET_TXT
echo "8.2 보안에 취약하지 않은 버전의 데이터베이스 사용 여부" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXTecho "[기준]" >> $_RET_TXT
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
cat $_TMP_DIR/8.2.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "8.02 END" >> $_RET_TXT
# 8.2 END---------------------------------------------------------------------------------------



# 9.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "9.01 START" >> $_RET_TXT
echo "9.1 감사 기능 설정 점검" >> $_RET_TXT
echo "===============================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "오라클 자체 기본 감사 기능이 실행 중 이거나(audit_trail=none 외에 설정) 솔루션을 통해 DBMS감사 기능을 수행중 일 경우 양호" >> $_RET_TXT
echo "접근, 변경, 삭제 등의 감사 기록이 정책에 적합하도록 설정 되어있는 경우 양호" >> $_RET_TXT
echo "담당자 인터뷰 필요" >> $_RET_TXT
echo "DBsafer, DB-i 등과 같은 솔루션이나 DBMS 자체 감사기록 설정을 통해 감사 기록을 수집할 경우 양호" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/9.1.txt >> $_RET_TXT


echo " " >> $_RET_TXT
echo "9.01 END" >> $_RET_TXT
# 9.1 END---------------------------------------------------------------------------------------


# 10.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "10.01 START" >> $_RET_TXT
echo "10.1 DB서버 중요정보 암호화 적용 여부" >> $_RET_TXT
echo "==========================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "주민등록번호/비밀번호 등 주요정보에 대해서 암호화가 적용되어 있는지 여부" >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
echo "인터뷰 점검 : 담당자 인터뷰 또는 실사를 통해 중요정보 대한 암호화 적용여부 확인" >> $_RET_TXT



echo " " >> $_RET_TXT
echo "10.01 END" >> $_RET_TXT
# 10.1 END---------------------------------------------------------------------------------------



# 11.1 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "11.01 START" >> $_RET_TXT
echo "11.1 데이터베이스 관리자 계정에 Audit Table이 속해 있는 여부" >> $_RET_TXT
echo "=============================================================" >> $_RET_TXT
echo "[기준]" >> $_RET_TXT
echo "Audit Table은 데이터베이스 관리자 계정에만  속해 있을 경우 양호" >> $_RET_TXT
echo "AUD$ TAABLE이 관리자 계정에 속해있을 경우 " >> $_RET_TXT
echo " " >> $_RET_TXT
echo "[현황]" >> $_RET_TXT
cat $_TMP_DIR/11.1.txt >> $_RET_TXT
echo " " >> $_RET_TXT
echo "11.01 END" >> $_RET_TXT
# 11.1 END---------------------------------------------------------------------------------------








# 참고.1 계정 정보 START-------------------------------------------------------------------------------------
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
echo " " >> $_RET_TXT
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

echo "" 
echo "######################### Script가 종료되었습니다 ###########################" 


echo " " >> $_RET_TXT 
echo " " >> $_RET_TXT 
echo "======================= System Information Query Start ======================" >> $_RET_TXT 
echo "" >> $_RET_TXT
echo "" >> $_RET_TXT
echo "################################## uname -a #################################" >> $_RET_TXT 
uname -a >> $_RET_TXT
echo "" >> $_RET_TXT

echo "################################ ifconfig -a ################################" >> $_RET_TXT
if [ `uname | grep -i hp-ux | wc -l` -eq 1 ]
   then
      if [ `lanscan -i | grep lan0 | wc -l` -eq 1 ]
         then
            ifconfig lan0 >> $_RET_TXT
      fi
      if [ `lanscan -i | grep lan1 | wc -l` -eq 1 ]
         then
            ifconfig lan1 >> $_RET_TXT
      fi
   else
      ifconfig -a >> $_RET_TXT
fi
echo "" >> $_RET_TXT

echo "############################ ps -ef | grep ora ##############################" >> $_RET_TXT
ps -ef | grep ora >> $_RET_TXT
echo "" >> $_RET_TXT

echo "################################### /bin/env ###################################" >> $_RET_TXT
env >> $_RET_TXT
echo "" >> $_RET_TXT

echo "############################## cat /etc/passwd ##############################" >> $_RET_TXT
cat /etc/passwd >> $_RET_TXT
echo "" >> $_RET_TXT

echo "############################## cat /etc/group ###############################" >> $_RET_TXT
cat /etc/group >> $_RET_TXT
echo "" >> $_RET_TXT

echo "########################## cat $_ORA_TNS/listener.ora ###########################" >> $_RET_TXT
cat $_ORA_TNS/listener.ora >> $_RET_TXT
echo "" >> $_RET_TXT

echo "########################### cat $_ORA_TNS/sqlnet.ora ############################" >> $_RET_TXT
cat $_ORA_TNS/sqlnet.ora >> $_RET_TXT

echo " " >> $_RET_TXT 
echo " " >> $_RET_TXT 
echo "======================= System Information Query End ========================" >> $_RET_TXT 
echo "" >> $_RET_TXT
echo "" >> $_RET_TXT
echo "" >> $_RET_TXT
echo "############################### End Time ####################################" >> $_RET_TXT
echo "" >> $_RET_TXT
date >> $_RET_TXT
echo " " >> $_RET_TXT
echo "****************************** End Script ***********************************" >> $_RET_TXT
rm -rf $_TMP_DIR

echo "☞ 진단작업이 완료되었습니다. 수고하셨습니다!"
