
@echo off


setlocal
set PATH=%PATH%;C:\think\bin
cd C:\think
mkdir C:\think\tmp
mkdir C:\think\result


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
echo %ORA_HOME% > c:\think\tmp\ora_home_dir.txt

::===========================Oracel Home Directory===========================


::echo %1> ora_home_dir.txt



::============================================================================================
::===================win점검항목 임시(sh파일 내 실행불가하여 여기에 작성)=====================
::============================================================================================


::2.4 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" 2>nul
if errorlevel 1 (
	echo 불필요한 ODBC/OLE-DB가 설치되지 않음 > C:\think\tmp\2_4.txt 2>nul
) else (
	reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" > C:\think\tmp\2_4.txt 2>nul
)
::2.4 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거 



::===========================OPatch Hang 방지===========================
::%ORA_HOME%\OPatch\opatch lsinventory | grep node > c:\tmp\1.71.txt
::===========================OPatch Hang 방지===========================


::============================================================================================
::===================win점검항목 임시(sh파일 내 실행불가하여 여기에 작성)=====================
::============================================================================================


sqlplus "/as sysdba" @think_oracle.sql

sh think_make_result.sh

rd /s/Q c:\think\tmp

pause