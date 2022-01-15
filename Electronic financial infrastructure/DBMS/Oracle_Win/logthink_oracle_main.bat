
@echo off


setlocal
set PATH=%PATH%;C:\logthink\bin
cd C:\logthink
mkdir C:\logthink\tmp
mkdir C:\logthink\result


::===========================Oracel Home Directory===========================
echo " "
cls
echo "################# Oracle Security Check is start ###################"
echo " "
:RUN
   echo " Input a Oracle home directory " 
   set /p ORA_HOME=(ex. C:/app/Administrator/product/11.2.0/dbhome_1) : 
   
   
if exist %ORA_HOME%\network (
	goto END
) else (
	echo "The directory you inputed does not exist. Please re-input."
    echo " "
	goto RUN
)

echo " "
:END
echo %ORA_HOME% > c:\logthink\tmp\ora_home_dir.txt

::===========================Oracel Home Directory===========================


::echo %1> ora_home_dir.txt



::============================================================================================
::===================win점검항목 임시(sh파일 내 실행불가하여 여기에 작성)=====================
::============================================================================================


::2.4 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 2>nul
if errorlevel 1 (
	echo 불필요한 ODBC/OLE-DB가 설치되지 않음 > C:\logthink\tmp\4.2.txt 2>nul
) else (
	reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" > C:\logthink\tmp\4.2.txt 2>nul
)
::2.4 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거 



::===========================OPatch Hang 방지===========================
::%ORA_HOME%\OPatch\opatch lsinventory | grep node > c:\tmp\1.71.txt
::===========================OPatch Hang 방지===========================


::============================================================================================
::===================win점검항목 임시(sh파일 내 실행불가하여 여기에 작성)=====================
::============================================================================================


sqlplus "/as sysdba" @logthink_oracle_windows_v19.1.sql

sh logthink_oracle_result_v19.1.sh

rd /s/Q c:\logthink\tmp
rd /s/Q c:\logthink\result

pause