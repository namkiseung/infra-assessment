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


# Oracle Processor Ȯ��
if [ `ps -ef | grep -i ora_ | grep -i smon | wc -l` -eq 0 ]
   then
      echo ""
      echo "################# Oracle Database�� ���������� �ʽ��ϴ� ###################" 
      echo ""
      echo " ����Ŭ ������ ���ؼ��� Database�� ���� ���̾�� �մϴ�."
      echo ""
      echo ""
      echo "                     < Database ���� ���(��) >"
      echo " ---------------------------------------------------------------------"
      echo "  1. ����Ŭ SYS �������� SQLPLUS�� ���� �� Database ����"
      echo "    # SQLPLUS /NOLOG"
      echo "    SQL> CONNECT SYS/��й�ȣ AS SYSDBA "      
      echo ""   
      echo "    SQL> STARTUP "
      echo ""
      echo "  2. Database�� ����� �� SYS �������� ���ܽ�ũ��Ʈ�� �� �����Ͻʽÿ�."
      echo "    SQL> @logthink_oracle_unix_[����].sql "
      echo " ---------------------------------------------------------------------"
      echo " "
      echo "###########################################################################" 
      echo " "
      exit 1
fi

# Oracle ���� ��ũ��Ʈ ����
echo ""
echo "################# Oracle ���� ��ũ��Ʈ�� �����ϰڽ��ϴ� ###################"
echo ""
echo ""
echo "[���� ���� ���� ORACLE ���]"
echo $ORACLE_HOME 
echo ""
echo ""
echo ""
echo " > ����Ŭ Ȩ ���͸��� �Է��Ͻʽÿ�. "
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
               echo "   �Է��Ͻ� ���͸��� �������� �ʽ��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
               echo " "
         fi
      else
         echo "   �߸� �Է��ϼ̽��ϴ�. �ٽ� �Է��Ͽ� �ֽʽÿ�."
         echo " "
   fi
done
echo " "
#TEST
#_ORA_HOME="/usr/local/oracle/product/9.2.0"
echo $_ORA_HOME > $_TMP_DIR/ora_home_dir.txt

# end script
