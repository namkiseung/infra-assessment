#!/bin/sh

# LANG=ko_KR.UTF-8							export LANG

# Create DATE	: 2021-04-07 
# Version		: V1.3


# Variation Definition
# __FILEHD__	: Head name for a result and rawlog file
# __RESULT__	: Result File


# 전역변수 설정
__FILEHD__=$(hostname -s)'_PostgreSQL_'
__RESULT__=$__FILEHD__.log
#__RESULT__=$__FILEHD__'_RAW.log'



# 변수 List

echo "[1/3] Please enter DBA ID:"
#PGUSER=system
read PGUSER
echo "[2/3] Please enter DBA Password:"
read PGPASS
#PGPASS=Ahnlab1004
echo "[3/3] Please enter POST_HOME(ex: /etc/postgresql/8.4/main, POSTGRES_DATADIR:-~postgres/data):"
find / -name "postgresql.conf" 2>/dev/null | rev | cut -d '/' -f 2- | rev
read POST_HOME
#POST_HOME=/var/lib/postgresql/8.4/main

PG_USER=$PGUSER									export PG_USER
PGPASSWORD=$PGPASS							export PGPASSWORD


PG_OS=$(cat /etc/issue)
PG_KERNEL=$(uname -a)

#__PG_CONN__="psql -h 127.0.0.1 -U $PG_USER -c"



echo "start the program." >> $__RESULT__
echo "1. Default information" >> $__RESULT__
echo " 1) OS: " $PG_OS >> $__RESULT__
echo " 2) Kernel: " $PG_KERNEL >> $__RESULT__



echo "TITLE=진단을 시작합니다."
echo "::::::::::" $TITLE "::::::::::"
echo ""
echo "" >> $__RESULT__
TITLE="DBM-001 취약하게 설정된 비밀번호 존재"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-001=C" >> $__RESULT__
echo "수동진단 : 취약하게 설정된 비밀번호 존재 여부 " >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "SELECT usename, passwd FROM PG_SHADOW;" >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-003 업무상 불필요한 계정 존재";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-003=C" >> $__RESULT__
echo "인터뷰필요 : 사용하지 않는 계정에 대한 인터뷰 필요" >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "select rolname, rolcanlogin, rolvaliduntil from pg_authid;" >> $__RESULT__
echo "" >> $__RESULT__
echo "" >> $__RESULT__
echo "참고 : rolname(계정이름), rolcanlogin(로그인가능 여부, Default: t), rolvaliduntil(로그인 유효기간, Default:NULL)" >> $__RESULT__
echo "사용하지 않는 계정에 대해 rolcanloing 컬럼이 t일 경우 취약"  >> $__RESULT__
echo "rolvaliduntil 컬럼이 NULL인 경우 취약 (DBM-003-04 항목과 동일)" >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-004 업무상 불필요하게 관리자 권한이 부여된 계정 존재";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-004=C" >> $__RESULT__
echo "인터뷰필요 : 사용하지 않는 계정에 대한 인터뷰 필요" >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "select * from pg_user" >> $__RESULT__
echo "불필요하게 관리자 권한(usecreatedb, usesuper, userepl)이 t일 경우 취약"  >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-005 데이터베이스 내 중요정보 암호화 미적용"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-005=C" >> $__RESULT__
echo "인터뷰필요 : 데이터베이스 내에 주민등록번호, 비밀번호 등과 같은 중요정보가 평문으로 존재하는지 확인 " >> $__RESULT__
echo "" >> $__RESULT__
cat $POST_HOME/postgresql.conf |grep password_encryption >> $__RESULT__

 
echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-006 로그인 실패 횟수에 따른 접속 제한 설정 미흡"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-006=C" >> $__RESULT__
echo "인터뷰필요 : 플러그인(fail2ban), 장비, 써드파티 솔루션 등을 통해 로그인 실패 횟수에 따른 계정 접속 제한 설정 여부" >> $__RESULT__
echo "" >> $__RESULT__
echo "fail2ban 확인" >> $__RESULT__
cat /etc/fail2ban/jail.conf | grep -v "^#" >> $__RESULT__

 
echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-007 비밀번호의 복잡도 정책 설정 미흡";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-007=C" >> $__RESULT__
echo "인터뷰필요 : 패스워드 정책 관련 인터뷰 필요" >> $__RESULT__
echo "" >> $__RESULT__
echo "  07-01. 패스워드는 숫자, 영문 소문자, 영문 대문자, 특수문자 중 몇가지를 조합하여 사용하도록 정책이 마련되어 있습니까?" >> $__RESULT__
echo "  07-02. 패스워드는 최소한 몇 글자 이상 사용하도록 정책 및 지침이 마련되어 있습니까?" >> $__RESULT__
echo "  07-03. 패스워드는 암호화(또는 해쉬값) 되어 저장/보관 되고 있습니까?" >> $__RESULT__
echo "  07-04. 패스워드는 몇일에 한번씩 바꾸도록 정책 및 지침으로 관리/감독이 이루어지고 있습니까?" >> $__RESULT__
echo "  07-05. 패스워드는 해쉬 또는 암호화(AES, SEED 등) 중 어떠한 알고리즘을 사용되고 있습니까?" >> $__RESULT__
echo "" >> $__RESULT__
echo "  *** 계정 별 패스워드(PASSWD) 정보 및 만료기간(VALUNTIL): PG_SHADOW" >> $__RESULT__
psql -U $PG_USER -c "SELECT usename, usesysid, passwd, valuntil FROM PG_SHADOW" >> $__RESULT__
echo "  *** 참고: PostgreSQL은 패스워드 저장 시, 해쉬 알고리즘을 사용하며 MD5 알고리즘만 지원함. (암호화 모듈은 지원하지 않음)"

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-008 주기적인 비밀번호 변경 미흡"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-008=C" >> $__RESULT__
echo "인터뷰필요 : 패스워드 주기적인 변경 여부 " >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "SELECT usename, usesysid, passwd, valuntil FROM PG_SHADOW" >> $__RESULT__
echo "" >> $__RESULT__
echo "  *** 계정 별 패스워드(PASSWD) 정보 및 만료기간(VALUNTIL): PG_SHADOW" >> $__RESULT__


echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-009 사용되지 않는 세션 종료 미흡"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-009=C" >> $__RESULT__
echo "수동진단 : 세션 종료 설정 " >> $__RESULT__
echo "" >> $__RESULT__
echo "1) 9.6 미만의 버전을 사용할 경우 " >> $__RESULT__
cat $POST_HOME/postgresql.conf |grep statement_timeout >> $__RESULT__
echo "참고 : statement_timeout: 지정된 시간이상의 쿼리에 대해서는 모두 중단 시켜 버립니다. 0은 Disable이고 셋팅은 milliseconds로 하시면 됩니다." >> $__RESULT__
echo "" >> $__RESULT__
echo "2) 9.6 이상의 버전을 사용할 경우 " >> $__RESULT__
cat $POST_HOME/postgresql.conf |grep idle_in_transaction_session_timeout >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "show idle_in_transaction_session_timeout;" >> $__RESULT__
echo "" >> $__RESULT__
echo "참고 : idle_in_transaction_session_timeout: 기본값이 0이며, 0일 경우 이 값을 사용하지 않는 것" >> $__RESULT__


echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-011 감사 로그 수집 및 백업 미흡"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-011=C" >> $__RESULT__
echo "수동체크 : postgresql.conf 파일 중 아래 4개의 설정값이 활성화(on) 되어 있는지 확인" >> $__RESULT__
echo "" >> $__RESULT__
cat $POST_HOME/postgresql.conf | grep "log_connections" >> $__RESULT__
cat $POST_HOME/postgresql.conf | grep "log_disconnections" >> $__RESULT__
cat $POST_HOME/postgresql.conf | grep "log_duration" >> $__RESULT__
cat $POST_HOME/postgresql.conf | grep "log_timestamp" >> $__RESULT__
echo "*****************************************************************" >> $__RESULT__
echo "아래 4개의 설정값이 ON 인지 확인" >> $__RESULT__
echo "	log_connections = on"  >> $__RESULT__
echo "	log_disconnections = on"  >> $__RESULT__
echo "	log_duration = on"  >> $__RESULT__
echo "	log_timestamp =on"  >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-013 원격 접속에 대한 접근 제어 미흡"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-013=C" >> $__RESULT__
echo "수동체크 : 환경설정파일 확인 pg_hba.conf, postgresql.conf" >> $__RESULT__
echo "" >> $__RESULT__
echo "[pg_hba.conf]" >> $__RESULT__
cat $POST_HOME/pg_hba.conf | egrep host | egrep all >> $__RESULT__
echo "" >> $__RESULT__
echo "[postgresql.conf]" >> $__RESULT__
cat $POST_HOME/postgresql.conf | grep listen_address >> $__RESULT__
echo "" >> $__RESULT__
echo "※ postgresql.conf에서 listen_address 정보와 pg_hba.conf에서 host 정보가" >> $__RESULT__
echo "  1) 특정 IP가 1개 이상 설정되며, pg_hba.conf에서 host 정보가 localhost(e.g.  127.0.0.1/32) 설정 시 양호" >> $__RESULT__
echo "  2) 특정 IP가 1개 이상 설정되며, pg_hba.conf에서 host 정보가 네트워크 대역(e.g.  192.168.10.0/32) 설정 시 양호" >> $__RESULT__
echo "  3) 특정 IP가 1개 이상 설정되며, pg_hba.conf에서 host 정보가 0.0.0.0/0 설정 시 양호" >> $__RESULT__
echo "  4) * 로 설정되고, pg_hba.conf에서 host 정보가 localhost(e.g 127.0.0.1) 설정 시 양호" >> $__RESULT__
echo "  5) * 로 설정되고, pg_hba.conf에서 host 정보가 네트워크 대역(e.g.  192.168.10.0/32) 설정 시 양호" >> $__RESULT__
echo "  6) * 로 설정되고, pg_hba.conf에서 host 정보가 0.0.0.0/0 설정되어 있으면 취약 (모든 IP에 대하여 TCP Connection이 가능)" >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-015 Public Role에 불필요한 권한 존재"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-015=C" >> $__RESULT__
echo "인터뷰필요 : Public Role에 불필요한 권한 존재 여부" >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "\l"  >> $__RESULT__
psql -U $PG_USER -c "\dn+"  >> $__RESULT__


echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-016 최신 보안패치와 벤더 권고사항 미적용"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-016=C" >> $__RESULT__
echo "수동체크 : 설치된 %PG_VER% 이 LATEST Version인지 확인." >> $__RESULT__
echo "" >> $__RESULT__
echo "[현재 버전]" >> $__RESULT__
psql --version  >> $__RESULT__
echo "" >> $__RESULT__
echo "LATEST RELEASES: 2022. 01. " >> $__RESULT__
echo "Version 	/ LATEST	/ Supported		/ First release	/ EOL" >> $__RESULT__
echo "14		/ 14.1		/ YES			/ 2021-09-30	/ -" >> $__RESULT__
echo "13		/ 13.5		/ YES			/ 2020-09-24	/ -" >> $__RESULT__
echo "12		/ 12.9		/ YES			/ 2019-10.03	/ -" >> $__RESULT__
echo "11		/ 11.14		/ YES			/ 2018-10-18	/ -" >> $__RESULT__
echo "10		/ 10.19		/ YES			/ 2017-10-05	/ -" >> $__RESULT__
echo "9.6		/ 9.6.24	/ YES			/ 2016-09-29	/ 2021-11-11" >> $__RESULT__
echo "9.5		/ 9.5.25	/ YES			/ 2016-01-07	/ 2021-02-11" >> $__RESULT__
echo "9.4		/ 9.4.26	/ YES			/ 2014-12-18	/ 2020-02-13" >> $__RESULT__
echo "9.3		/ 9.3.25	/ YES			/ 2013-09-09	/ 2018-11-08" >> $__RESULT__
echo "9.2		/ 9.2.19	/ YES			/ 2012-09-10	/ 2017-11-09" >> $__RESULT__
echo "9.1		/ 9.1.24	/ NO			/ 2011-09-12	/ 2016-10-27" >> $__RESULT__
echo "9.0		/ 9.0.23	/ NO			/ 2010-09-20 	/ 2015-10-08" >> $__RESULT__
echo "8.4		/ 8.4.22	/ NO			/ 2009-07-01 	/ 2014-07-24" >> $__RESULT__
echo "8.3		/ 8.3.23	/ NO			/ 2008-02-04 	/ 2013-02-07" >> $__RESULT__
echo "8.2		/ 8.2.23	/ NO			/ 2006-12-05 	/ 2011-12-05" >> $__RESULT__
echo "8.1		/ 8.1.23	/ NO			/ 2005-11-08 	/ 2010-11-08" >> $__RESULT__
echo "8.0		/ 8.0.26	/ NO			/ 2005-01-19 	/ 2010-10-01" >> $__RESULT__
echo "7.4		/ 7.4.30	/ NO			/ 2003-11-17	/ 2010-10-01" >> $__RESULT__
echo "7.3		/ 7.3.21	/ NO			/ 2002-11-27	/ 2007-11-27" >> $__RESULT__
echo "7.2		/ 7.2.8		/ NO			/ 2002-02-04 	/ 2007-02-04" >> $__RESULT__
echo "7.1		/ 7.1.3		/ NO			/ 2001-04-13 	/ 2006-04-13" >> $__RESULT__
echo "7.0		/ 7.0.3		/ NO			/ 2000-05-08	/ 2005-05-08" >> $__RESULT__
echo "6.5		/ 6.5.3		/ NO			/ 1999-06-09 	/ 2004-06-09" >> $__RESULT__
echo "6.4		/ 6.4.2		/ NO			/ 1998-10-30 	/ 2003-10-30" >> $__RESULT__
echo "6.3		/ 6.3.2		/ NO			/ 1998-03-01 	/ 2003-03-01" >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-017 업무상 불필요한 시스템 테이블 접근 권한 존재";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-017=C" >> $__RESULT__
echo "인터뷰필요 : 업무상 불필요한 시스템 테이블 접근 권한 존재 여부" >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "\l">> $__RESULT__
psql -U $PG_USER -c "\dp">> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-019 비밀번호 재사용 방지 설정 미흡";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-019=C" >> $__RESULT__
echo "인터뷰필요 : 플러그인, 장비, 써드파티 솔루션 등을 통해 이전 비밀번호 재사용 제한 설정 여부" >> $__RESULT__
echo "" >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-020 사용자별 계정 분리 미흡";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-020=C" >> $__RESULT__
echo "인터뷰필요 : 사용자별 계정을 부여해서 사용하고 있거나 어플리케이션별 계정을 부여해서 사용 여부" >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "SELECT r.datname, ARRAY(SELECT m.rolname FROM pg_authid m JOIN pg_database b ON (m.oid = b.datdba) WHERE m.oid = r.datdba and b.DATISTEMPLATE = FALSE) as owner FROM pg_database r where r.DATISTEMPLATE = FALSE" >> $__RESULT__
psql -U $PG_USER -c "select * from pg_user">> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-022 설정 파일 및 중요정보가 포함된 파일의 접근 권한 설정 미흡";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
ls -alL $POST_HOME/postgresql.conf >> $__RESULT__	
ls -alL $POST_HOME/pg_hba.conf >> $__RESULT__	
ls -alL $POST_HOME/pg_ident.conf >> $__RESULT__	
echo "" >> $__RESULT__
echo "양호 : 시스템 주요 파일 권한이 아래의 조건보다 낮게 부여된 경우" >> $__RESULT__												
echo "취약 : 시스템 주요 파일 권한이 아래의 조건보다 높게 부여된 경우" >> $__RESULT__								
echo "	1. postgresql.conf 권한: 640" >> $__RESULT__							
echo "	2. pg_hba.conf 권한: 640" >> $__RESULT__										
echo "	3. pg_ident.conf 권한: 640" >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-024 불필요하게 WITH GRANT OPTION 옵션이 설정된 권한 존재";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-024=C" >> $__RESULT__
echo "인터뷰필요 : 불필요하게 WITH GRANT OPTION 옵션이 설정되어 있는 권한 존재 여부" >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "SELECT grantor,grantee,table_name,privilege_type,is_grantable FROM information_schema.role_table_grants WHERE is_grantable='YES';" >> $__RESULT__


echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-025 서비스 지원이 종료된(EoS) 데이터베이스 사용"
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
### https://www.postgresql.org/support/versioning/
echo "DBM-025=C" >> $__RESULT__
echo "수동진단 : 데이터베이스 EOS 여부" >> $__RESULT__
echo "수동체크 : 설치된 버전이 EOL(End of Lelease)를 지원하는지 확인." >> $__RESULT__
echo "[현재 버전]" >> $__RESULT__
psql --version  >> $__RESULT__
echo "" >> $__RESULT__
echo "LATEST RELEASES: 2022. 01. " >> $__RESULT__
echo "Version 	/ LATEST	/ Supported		/ First release	/ EOL" >> $__RESULT__
echo "14		/ 14.1		/ YES			/ 2021-09-30	/ -" >> $__RESULT__
echo "13		/ 13.5		/ YES			/ 2020-09-24	/ -" >> $__RESULT__
echo "12		/ 12.9		/ YES			/ 2019-10.03	/ -" >> $__RESULT__
echo "11		/ 11.14		/ YES			/ 2018-10-18	/ -" >> $__RESULT__
echo "10		/ 10.19		/ YES			/ 2017-10-05	/ -" >> $__RESULT__
echo "9.6		/ 9.6.24	/ YES			/ 2016-09-29	/ 2021-11-11" >> $__RESULT__
echo "9.5		/ 9.5.25	/ YES			/ 2016-01-07	/ 2021-02-11" >> $__RESULT__
echo "9.4		/ 9.4.26	/ YES			/ 2014-12-18	/ 2020-02-13" >> $__RESULT__
echo "9.3		/ 9.3.25	/ YES			/ 2013-09-09	/ 2018-11-08" >> $__RESULT__
echo "9.2		/ 9.2.19	/ YES			/ 2012-09-10	/ 2017-11-09" >> $__RESULT__
echo "9.1		/ 9.1.24	/ NO			/ 2011-09-12	/ 2016-10-27" >> $__RESULT__
echo "9.0		/ 9.0.23	/ NO			/ 2010-09-20 	/ 2015-10-08" >> $__RESULT__
echo "8.4		/ 8.4.22	/ NO			/ 2009-07-01 	/ 2014-07-24" >> $__RESULT__
echo "8.3		/ 8.3.23	/ NO			/ 2008-02-04 	/ 2013-02-07" >> $__RESULT__
echo "8.2		/ 8.2.23	/ NO			/ 2006-12-05 	/ 2011-12-05" >> $__RESULT__
echo "8.1		/ 8.1.23	/ NO			/ 2005-11-08 	/ 2010-11-08" >> $__RESULT__
echo "8.0		/ 8.0.26	/ NO			/ 2005-01-19 	/ 2010-10-01" >> $__RESULT__
echo "7.4		/ 7.4.30	/ NO			/ 2003-11-17	/ 2010-10-01" >> $__RESULT__
echo "7.3		/ 7.3.21	/ NO			/ 2002-11-27	/ 2007-11-27" >> $__RESULT__
echo "7.2		/ 7.2.8		/ NO			/ 2002-02-04 	/ 2007-02-04" >> $__RESULT__
echo "7.1		/ 7.1.3		/ NO			/ 2001-04-13 	/ 2006-04-13" >> $__RESULT__
echo "7.0		/ 7.0.3		/ NO			/ 2000-05-08	/ 2005-05-08" >> $__RESULT__
echo "6.5		/ 6.5.3		/ NO			/ 1999-06-09 	/ 2004-06-09" >> $__RESULT__
echo "6.4		/ 6.4.2		/ NO			/ 1998-10-30 	/ 2003-10-30" >> $__RESULT__
echo "6.3		/ 6.3.2		/ NO			/ 1998-03-01 	/ 2003-03-01" >> $__RESULT__
echo "|" >> $__RESULT__

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-026 데이터베이스 구동 계정의 umask 설정 미흡";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
if [[ "$(umask | grep '^[0-7][0-7][2-7][2-7]$')" != "" ]]; then
  echo "DBM-026=O,|양호 : UMASK 가 022 이상으로 설정이 되어 있습니다. - 현재 설정 값 : $(umask)|" >> $__RESULT__
else
  echo "DBM-026=X,|취약 : UMASK 가 설정이 되어 있지 않거나 022 보다 낮은 권한으로 설정되어 있습니다. - 현재 설정 값 : $(umask)|" >> $__RESULT__
fi

echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-028 업무상 불필요한 데이터베이스 Object 존재";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-028=C" >> $__RESULT__
echo "인터뷰필요 : 업무상 불필요한 데이터베이스 Object 존재 여부" >> $__RESULT__
echo "" >> $__RESULT__
psql -U $PG_USER -c "SELECT distinct relname, relowner FROM pg_class;" >> $__RESULT__


echo ""
echo "" >> $__RESULT__
echo ""
TITLE="DBM-032 데이터베이스 접속 시 통신구간에 비밀번호 평문 노출";
echo "########## Working : "$TITLE
echo "########## Working : "$TITLE >> $__RESULT__
echo "DBM-032=C" >> $__RESULT__
echo "수동체크 : 환경설정파일 확인 pg_hba.conf, postgresql.conf" >> $__RESULT__
echo "" >> $__RESULT__
echo "[pg_hba.conf]" >> $__RESULT__
cat $POST_HOME/pg_hba.conf | grep TYPE >> $__RESULT__
cat $POST_HOME/pg_hba.conf | grep -v "^#" >> $__RESULT__
echo "[postgresql.conf]" >> $__RESULT__
cat $POST_HOME/postgresql.conf |grep ssl >> $__RESULT__
echo "  1) pg_hba.conf에서 hostssl 이 설정 시 해당 주소에서 들어오는 ssl연결만 허용하면 양호" >> $__RESULT__
echo "  2) pg_hba.conf에서 (auth)method 필드값 md5, password 이외로 설정되어 있으면 양호" >> $__RESULT__
echo "  3) postgresql.conf에서 ssl=on 으로 설정 시 ssl 허용이므로 양호(false일경우 취약)" >> $__RESULT__
 
echo ""
echo ""
echo "" >> $__RESULT__
echo "" >> $__RESULT__
echo "" >> $__RESULT__
echo "" >> $__RESULT__
echo "######## etc ########" >> $__RESULT__
echo "참고 1) pg_hba.conf 내용" >> $__RESULT__
cat $POST_HOME/pg_hba.conf >> $__RESULT__
echo "" >> $__RESULT__
echo "" >> $__RESULT__
echo "######## etc ########" >> $__RESULT__
echo "참고 2) postgresql.conf 내용" >> $__RESULT__
cat $POST_HOME/postgresql.conf >> $__RESULT__
echo "" >> $__RESULT__
echo "" >> $__RESULT__
echo "####################" >> $__RESULT__
echo "" >> $__RESULT__


##진단항목
##DBM-001 [C]	취약하게 설정된 비밀번호 존재
##DBM-003 [C]	업무상 불필요한 계정 존재
##DBM-004 [C]	업무상 불필요하게 관리자 권한이 부여된 계정 존재
##DBM-005 [C]	데이터베이스 내 중요정보 암호화 미적용
##DBM-006 [C]	로그인 실패 횟수에 따른 접속 제한 설정 미흡
##DBM-007 [C]	비밀번호의 복잡도 정책 설정 미흡
##DBM-008 [C]	주기적인 비밀번호 변경 미흡
##DBM-009 [C]	사용되지 않는 세션 종료 미흡
##DBM-011 [C]	감사 로그 수집 및 백업 미흡
##DBM-013 [C]	원격 접속에 대한 접근 제어 미흡
##DBM-015 [C]	Public Role에 불필요한 권한 존재
##DBM-016 [C]	최신 보안패치와 벤더 권고사항 미적용
##DBM-017 [C]	업무상 불필요한 시스템 테이블 접근 권한 존재
##DBM-019 [C]	비밀번호 재사용 방지 설정 미흡
##DBM-020 [C]	사용자별 계정 분리 미흡
##DBM-022 [C]	설정 파일 및 중요정보가 포함된 파일의 접근 권한 설정 미흡
##DBM-024 [C]	불필요하게 WITH GRANT OPTION 옵션이 설정된 권한 존재
##DBM-025 [C]	서비스 지원이 종료된(EoS) 데이터베이스 사용
##DBM-026 [O]	데이터베이스 구동 계정의 umask 설정 미흡
##DBM-028 [C]	업무상 불필요한 데이터베이스 Object 존재
##DBM-032 [C]	데이터베이스 접속 시 통신구간에 비밀번호 평문 노출


unset PGPASSWORD