#!/bin/sh


echo ""
echo "###########################################################################"
echo "#        Copyright (c) 2019 logthink Co. Ltd. All Rights Reserved.         #"
echo "###########################################################################"

alias ls=ls
alias grep=/bin/grep

if [ -f /usr/ucb/echo ]
   then
      alias echo=/usr/ucb/echo
fi

_HOSTNAME=`/bin/hostname`
_PWD=`/bin/pwd`

mkdir $_PWD/tmp
_TMP_DIR=$_PWD/tmp


# Oracle Processor 확인
if [ `ps -ef | grep -i ora_ | grep -i smon | wc -l` -eq 0 ]
   then
      echo ""
      echo "################# Oracle Database가 실행중이지 않습니다 ###################" 
      echo ""
      echo " 오라클 진단을 위해서는 Database가 구동 중이어야 합니다."
      echo ""
      echo ""
      echo "                     < Database 실행 방법(예) >"
      echo " ---------------------------------------------------------------------"
      echo "  1. 오라클 SYS 계정으로 SQLPLUS에 접속 후 Database 실행"
      echo "    # SQLPLUS /NOLOG"
      echo "    SQL> CONNECT SYS/비밀번호 AS SYSDBA "      
      echo ""   
      echo "    SQL> STARTUP "
      echo ""
      echo "  2. Database가 실행된 후 SYS 계정으로 진단스크립트를 재 실행하십시오."
      echo "    SQL> @logthink_oracle_unix_[버전].sql "
      echo " ---------------------------------------------------------------------"
      echo " "
      echo "###########################################################################" 
      echo " "
      exit 1
fi

# Oracle 진단 스크립트 실행
echo ""
echo "################# Oracle 진단 스크립트를 실행하겠습니다 ###################"
echo ""
echo ""
echo "[현재 구동 중인 ORACLE 경로]"
echo $ORACLE_HOME 
echo ""
echo ""
echo ""
echo " > 오라클 홈 디렉터리를 입력하십시오. "
while true
do 
   echo -n "    (ex. /usr/local/oracle/product/9.2.0) : " 
   read _ORA_HOME 
   if [ $_ORA_HOME ]
      then
         if [ -d $_ORA_HOME/network ]
            then 
               break
            else
               echo "   입력하신 디렉터리가 존재하지 않습니다. 다시 입력하여 주십시오."
               echo " "
         fi
      else
         echo "   잘못 입력하셨습니다. 다시 입력하여 주십시오."
         echo " "
   fi
done
echo " "
#TEST
#_ORA_HOME="/usr/local/oracle/product/9.2.0"
echo $_ORA_HOME > $_TMP_DIR/ora_home_dir.txt

# end script
