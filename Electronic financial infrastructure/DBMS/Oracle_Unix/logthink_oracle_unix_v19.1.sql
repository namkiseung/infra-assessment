WHENEVER OSERROR EXIT
WHENEVER SQLERROR EXIT SQL.SQLCODE


HOST ./logthink_oracle_main.sh

PROMPT
PROMPT
PROMPT ### ORACLE Version1.0 Check ###
col product format a30
col version format a20
SPOOL ./tmp/1.0.txt
SELECT version, product FROM product_component_version;
SPOOL OFF


PROMPT
PROMPT
PROMPT  1.1 비인가자의 접근 차단을 위한 사용자 계정 관리
PROMPT  ===========================
PROMPT
col username format a15
col account_status format a20
SPOOL ./tmp/1.1.txt
select username,ACCOUNT_STATUS from dba_users 
where ACCOUNT_STATUS = 'OPEN' 
and username in ('SCOTT','HR','OE','PM','SH',
'COMPANY','MFG','FINANCE','ANYDATA_USER',
'ANYDSET_USER','ANYTYPE_USER','AQJAVA','AQUSER',
'AQXMLUSER','GPFD','GPLD','MMO2','XMLGEN1',
'BLAKE','ADAMS','CLARK','JONES')
or username like 'QS%'
or username like 'USER%'
or username like '%DEMO%'
or username like 'SERVICECONSUMER%';
SPOOL OFF




PROMPT
PROMPT
PROMPT  1.2 로그인 실패 횟수에 따른 잠금시간 등 계정 잠금 정책 설정
PROMPT  ===========================
PROMPT
col username format a15
col profile format a20
col resource_name format a25
col limit format a10
SPOOL ./tmp/1.2.txt
select DU.username, DP.profile, DP.resource_name, DP.limit from dba_users DU INNER JOIN dba_profiles DP ON DP.profile = DU.profile 
where DU.account_status = 'OPEN' 
and DP.resource_name in ('FAILED_LOGIN_ATTEMPTS','PASSWORD_LOCK_TIME');
SPOOL OFF



PROMPT
PROMPT
PROMPT  1.3 SYSDBA 로그인 제한 설정
PROMPT  ===========================
col username format a15
col profile format a20
col resource_name format a25
col limit format a10
SPOOL ./tmp/1.3.txt
SPOOL OFF
PROMPT


PROMPT
PROMPT
PROMPT  2.1 패스워드 재사용에 대한 제약이 설정 여부
PROMPT  =========================
PROMPT
col username format a15
col profile format a20
col resource_name format a25
col limit format a10
SPOOL ./tmp/2.1.txt
select DU.username, DP.profile, DP.resource_name, DP.limit from dba_users DU INNER JOIN dba_profiles DP ON DP.profile = DU.profile 
where DU.account_status = 'OPEN' 
and DP.resource_name in ('PASSWORD_REUSE_TIME','PASSWORD_REUSE_MAX');
SPOOL OFF



PROMPT
PROMPT
PROMPT 
PROMPT	2.2 DB 사용자 계정을 개별적으로 부여
PROMPT  ========================================================================
PROMPT
col username format a15
col account_status format a15
SPOOL ./tmp/2.2.txt
select username, account_status from dba_users where account_status='OPEN';
SPOOL OFF
PROMPT



PROMPT
PROMPT
PROMPT  3.1 유추가능한 비밀번호 설정여부(DB계정)     
PROMPT  ========================
PROMPT



PROMPT
PROMPT
PROMPT
PROMPT	3.2 기본 계정 및 패스워드 변경(디폴트 ID 및 패스워드 변경 및 잠금)
PROMPT  ========================
PROMPT
PROMPT
col username format a10
col password format a17
col account_status format a20
SPOOL ./tmp/3.2.txt
SELECT username, password, account_status FROM dba_users
WHERE password = 
Decode(username,'#INTERNAL','38379FC3621F7DA2','#INTERNAL','87DADF57B623B777',
'ABM','D0F2982F121C7840','ADAMS','72CDEF4A3483F60D','ADLDEMO','147215F51929A6E8'
,'CTXDEMO','CB6B5E9D9672FE89'
,'CTXSYS','71E687F036AD56E5','CTXSYS','24ABAB8B06281B4C','CTXSYS','A13C035631643BA0'
,'HR','33EBE1C63D5B7FEF','HR','6399F3B38EDF3288','HR','4C6D73C3E8B0F0DA'
,'INTERNAL','AB27B53EDC5FEF41','INTERNAL','E0BF7F3DDE682D3B'
,'JONES','B9E99443032F059D'
,'MASTER','9C4F452058285A74'
,'MDSYS','72979A94BAD2AF80'
,'OE','9C30855E7E0CB02D','OE','62FADF01C4DC1ED4','OE','D1A2DFC623FDA40A'
,'ORACLE','38E38619A12E0257'
,'ORADBA','C37E732953A8ABDB'
,'ORANGE','3D9B7E34A4F7D4E9'
,'DBSNMP','E066D214D5421CCC'
,'DBVISION','F74F7EF36A124931'
,'DEMO','4646116A123897CF'
,'HR','6E0C251EABE4EBB8'
,'ADAMS','72CDEF4A3483F60D'
,'ANDY','B8527562E504BC3F'
,'BLAKE','9435F2E60569158E'
,'SYSMAN','447B729161192C24'
,'SYSTEM','8BF0DA8E551DE1B9','SYSTEM','1B9F1F9A5CB9EB31','SYSTEM','D4DF7931AB130E37','SYSTEM','2D594E86F93B17A1','SYSTEM','4861C2264FB17936'
,'SYSTEM','970BAA5B81930A40','SYSTEM','135176FFB5BA07C9','SYSTEM','E4519FCD3A565446','SYSTEM','66A490AEAA61FF72','SYSTEM','10B0C2DA37E11872','SYSTEM','4438308EE0CAFB7F'
,'TEST','26ED9DD4450DD33C','TEST','7A0F2B316C212D67'
,'TEST_USER','C0A0F776EBBBB7FB'
,'USER','74085BE8A9CF16B4'
,'USER0','8A0760E2710AB0B4'
,'USER1','BBE7786A584F9103'
,'WKPROXY','B97545C4DD2ABE54'
,'WKSYS','69ED49EE1851900D','WKSYS','545E13456B7DDEA0'
,'WK_SYS','79DF7A1BD138CF11'
,'WK_TEST','29802572EB547DBF'
,'ORDSYS','7EFA02EC7EA6B86F'
,'OUTLN','4A3BA55E08595C81'
,'PM','72E382A52E89575A','PM','C7A235E6D2AF6018'
,'QS','8B09C6075BDF2DC4','QS','4603BCD2744BDE4F'
,'QS_ADM','991CDDAD5C5C32CA','QS_ADM','3990FB418162F2A0'
,'QS_CB','CF9CFACF5AE24964','QS_CB','870C36D8E6CD7CF5'
,'QS_CBADM','7C632AFB71F8D305','QS_CBADM','20E788F9D4F1D92C'
,'QS_CS','91A00922D8C0F146','QS_CS','2CA6D0FC25128CF3'
,'QS_ES','E6A6FA4BB042E3C2','QS_ES','9A5F2D9F5D1A9EF4'
,'QS_OS','FF09F3EB14AE5C26','QS_OS','0EF5997DC2638A61'
,'QS_WS','24ACF617DD7D8F2F','QS_WS','0447F2F756B4F460'
,'SAMPLE','E74B15A3F7A19CA8'
,'SCOTT','F894844C34402B67','SCOTT','7AA1A84E31ED7771'
,'SH','9793B3777CD3BD1A','SH','54B253CBBAAA8C48','SH','1729F80C5FA78841'
,'SYS','D4C5016086B2DC6A','SYS','43BE121A2A135FF3','SYS','5638228DAF52805F','SYS','8A8F025737A9097A','SYS','4DE42795E66117AE'
,'SYS','66BC3FF56063CE97','SYS','57D7CFA12BB5BABF','SYS','A9A57E819B32A03D','SYS','2905ECA56A830226','SYS','64074AF827F4B74A'
,'SYSADM','BA3E855E93B5B9B0'
,'SYSADMIN','DC86E8DEAA619C1A'
,'SYSMAN','639C32A115D2CA57'
,username) and account_status='OPEN';
SPOOL OFF



PROMPT
PROMPT
PROMPT
PROMPT	3.3 비밀번호 복잡도 설정
PROMPT  ========================
PROMPT
PROMPT
col username format a15
col profile format a20
col resource_name format a25
col limit format a10
SPOOL ./tmp/3.3.txt
select A.username, B.profile, B.resource_name, B.limit
from dba_users A,dba_profiles B
where A.profile = B.profile and B.resource_name = 'PASSWORD_VERIFY_FUNCTION' and A.account_status ='OPEN';
SPOOL OFF
SPOOL ./tmp/3.31.txt
SPOOL OFF
SPOOL ./tmp/3.32.txt
SPOOL OFF


PROMPT
PROMPT
PROMPT
PROMPT 	3.4 비밀번호의 주기적인 변경
PROMPT  ========================
PROMPT
col username format a15
col profile format a20
col resource_name format a25
col limit format a10
SPOOL ./tmp/3.4.txt
select DU.username, DP.profile, DP.resource_name, DP.limit 
from dba_users DU INNER JOIN dba_profiles DP ON DP.profile = DU.profile 
where DU.account_status = 'OPEN' 
and DP.resource_name in ('PASSWORD_LIFE_TIME' ,'PASSWORD_GRACE_TIME');
SPOOL OFF



PROMPT
PROMPT
PROMPT  3.5 listener 비밀번호 설정 및 디폴트 포트 변경
PROMPT  ===========================
PROMPT
SPOOL ./tmp/3.5.txt
PROMPT 10g 이상은 (N/A)
SPOOL OFF




PROMPT
PROMPT
PROMPT  4.1 DBA이외의 인가되지 않은 사용자가 시스템 테이블에 접근할 수 없도록 설정
PROMPT  ===========================
PROMPT
col grantee format a15
col privilege format a20
col owner format a15
col table_name format a20

SPOOL ./tmp/4.1.txt
select A.grantee, A.privilege, A.owner, A.table_name from
(
  select grantee,privilege,owner,table_name  from dba_tab_privs
  where (owner='SYS' or table_name like 'DBA_%')
  and privilege <> 'EXECUTE'
  and grantee not in ('PUBLIC','AQ_ADMINISTRATOR_ROLE'
  ,'AQ_USER_ROLE','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','TRACESVR','CTXSYS','DBA','DELETE_CATALOG_ROLE','EXECUTE_CATALOG_ROLE','EXP_FULL_DATABASE','GATHER_SYSTEM_STATISTICS','
  HS_ADMIN_ROLE','IMP_FULL_DATABASE','LOGSTDBY_ADMINISTRATOR','MDSYS','ODM','OEM_MONITOR','OLAPSYS','ORDSYS','OUTLN','RECOVERY_CATALOG_OWNER','SELECT_CATALOG_ROLE','SNMPAGENT','SYSTEM','WKSYS','WKUSER','WMSYS','WM_ADMIN_ROLE','XDB','LBACSYS','PERFSTAT','XDBADMIN',
  'ANONYMOUS','APPQOSSYS','DBMON','DBSNMP','DIP','DMSYS','EXFSYS','MDDATA','MGMT_VIEW','ORACLE_OCM','ORDDATA','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','SI_INFORMTN_SCHEMA','SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SQLTXPLAIN','SYS','SYSMAN','SYSMAN_MDS','TSMSYS')
  and grantee not in (select grantee from dba_role_privs where granted_role='DBA') order by grantee
) A, 
(
  select username,ACCOUNT_STATUS from dba_users where ACCOUNT_STATUS = 'OPEN'
)B
where B.username = A.grantee;
SPOOL OFF



PROMPT
PROMPT
PROMPT  4.2 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거
PROMPT  ===========================
PROMPT
PROMPT Oracle은 해당사항 없음 : N/A (N/A)
SPOOL ./tmp/4.2.txt
SPOOL OFF



PROMPT
PROMPT
PROMPT  4.3 데이터베이스의 주요 설정파일, 패스워드 파일 등 주요 파일들의 접근 권한 적절성 여부
PROMPT  ===========================
PROMPT
SPOOL ./tmp/4.3.control.txt
SELECT name FROM v$controlfile;
SPOOL OFF
SPOOL ./tmp/4.3.spfile.txt
select value from v$parameter where name='spfile';
SPOOL OFF
SPOOL ./tmp/4.3.logfile.txt
select member from V$logfile;
SPOOL OFF
SPOOL ./tmp/4.3.datafile.txt	
select name from V$datafile;
SPOOL OFF



PROMPT
PROMPT
PROMPT  4.4 데이터베이스의 주요 파일 보호 등을 위한 DB 계정의 umask 설정
PROMPT  ===========================
PROMPT
PROMPT 서버 취약점 점검을 통한 확인
SPOOL ./tmp/4.4.txt
SPOOL OFF



PROMPT
PROMPT
PROMPT  4.5 오라클 리스너 로그 및 trace 파일에 대한 파일권한 적절성 여부
PROMPT  ===========================
PROMPT
PROMPT 기존 스크립트 내용 수정
SPOOL ./tmp/4.5.txt
SPOOL OFF



PROMPT
PROMPT
PROMPT  5.1 패스워드 확인함수 적용 여부
PROMPT  ===========================
PROMPT
col username format a15
col profile format a20
col resource_name format a25
col limit format a10
SPOOL ./tmp/5.1.txt
select A.username, B.profile, B.resource_name, B.limit
from dba_users A,dba_profiles B
where A.profile = B.profile and B.resource_name = 'PASSWORD_VERIFY_FUNCTION' and A.account_status ='OPEN';
SPOOL OFF



PROMPT
PROMPT
PROMPT  5.2 Role에 의한 grant option 설정 여부
PROMPT  ===========================
PROMPT
col grantee format a15
col owner format a15
col table_name format a30
col grantable format a10
SPOOL ./tmp/5.2.txt
select
  A.grantee, A.owner, A.table_name, A.grantable
from
(
  select grantee,owner,table_name, grantable from dba_tab_privs
  where grantable='YES'
  and owner not in ('SYS','MDSYS','ORDPLUGINS','ORDSYS','SYSTEM',
  'WMSYS','SDB','LBACSYS')
  and grantee not in (select grantee from dba_role_privs where
  granted_role='DBA') order by grantee
) A,
  dba_users B
where
  A.grantee = B.username and B.account_status = 'OPEN'
union select
  grantee,owner,table_name, grantable from dba_tab_privs
where grantable='YES'
and owner not in ('SYS','MDSYS','ORDPLUGINS','ORDSYS','SYSTEM',
'WMSYS','SDB','LBACSYS')
and grantee not in (select grantee from dba_role_privs where
granted_role='DBA') and grantee = 'PUBLIC' order by grantee;
SPOOL OFF



PROMPT
PROMPT
PROMPT  5.3 인가되지 않은 Object Owner가 존재 여부
PROMPT  ===========================
PROMPT
col owner format a15
col object_name format a30
SPOOL ./tmp/5.3.txt
select owner,object_name from dba_objects 
where owner in (select username from dba_users where account_status = 'OPEN')
and owner not in
('SYS','SYSTEM','MDSYS','CTXSYS','ORDSYS','ORDPLUGINS','TSMSYS','EXFSYS','DMSYS'
,'AURORA$JIS$UTILITY$','HR','ODM','ODM_MTR','OE','OLAPDBA'
,'OLAPSYS','OSE$HTTP$ADMIN','OUTLN','LBACSYS','MTSYS','PM'
,'PUBLIC','QS','QS_ADM','QS_CB','QS_CBADM','DBSNMP','QS_CS'
,'QS_ES','QS_OS','QS_WS','RMAN','SH','WKSYS','WMSYS','XDB'
,'ANONYMOUS','APPQOSSYS','DBMON','DIP','MDDATA','MGMT_VIEW','ORACLE_OCM','ORDDATA','OWBSYS','OWBSYS_AUDIT','PERFSTAT','SI_INFORMTN_SCHEMA','SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SQLTXPLAIN','SYSMAN','SYSMAN_MDS','WMSYS','XDB')
and owner not in (select grantee from dba_role_privs where granted_role='DBA');
SPOOL OFF
PROMPT



PROMPT
PROMPT
PROMPT  5.4 데이터베이스의 자원 제한 기능 설정 여부
PROMPT  ===========================
PROMPT
SPOOL ./tmp/5.4.txt
Select name, value from v$parameter where name='resource_limit';
SPOOL OFF
PROMPT



PROMPT
PROMPT
PROMPT  6.1 DBA 계정 권한 관리
PROMPT  ===========================
PROMPT
col USERNAME format a15
col grantee format a10
col privilege format a20
col sysdba format a15
col admin_option format a3

SPOOL ./tmp/6.1.1.txt
SELECT USERNAME, sysdba FROM V$PWFILE_USERS 
WHERE username in (select username from dba_users where account_status = 'OPEN') 
and USERNAME NOT IN (SELECT GRANTEE FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='DBA') 
and username NOT IN ('SYS','CTXSYS','MDSYS','ODM','OLAPSYS','MTSSYS','ORDPLUGINS','ORDSYS','SYSTEM','WKSYS','WMSYS','XDB','LBACSYS','PERFSTAT','SYSMAN','DMSYS','EXFSYS','WK_TEST','IMP_FULL_DATABASE','FLOWS_030000','MGMT_VIEW','INTERNAL')
and sysdba='TRUE';
SPOOL OFF

SPOOL ./tmp/6.1.2.txt
select grantee, privilege, admin_option from dba_sys_privs 
where grantee in (select username from dba_users where account_status = 'OPEN')
and grantee not in ('SYS','SYSTEM','AQ_ADMINISTRATOR_ROLE','DBA','MDS YS','LBACSYS','SCHEDULER_ADMIN','WMSYS')
and admin_option='YES'
and grantee not in (select grantee from dba_role_privs where granted_role='DBA');
SPOOL OFF



PROMPT
PROMPT
PROMPT  6.2 원격에서 DB 서버로의 접속 제한
PROMPT  ===========================
PROMPT
PROMPT  특정 IP에서만 접속 가능하도록 방화벽 등이 설정되어 있는지 확인
PROMPT  
col name format a20
col value format a15
SPOOL ./tmp/6.2.txt
SELECT name, value FROM v$parameter WHERE name='remote_os_authent';
SPOOL OFF



PROMPT
PROMPT
PROMPT  6.3 OS_ROLES,  REMOTE_OS_ROLES 설정
PROMPT  ===========================
PROMPT
col name format a20
col value format a15
SPOOL ./tmp/6.3.txt
select name, value from v$parameter where name='os_roles' or name='remote_os_authent' or name='remote_os_roles';
SPOOL OFF



PROMPT
PROMPT
PROMPT  6.4 응용프로그램 또는 DBA 계정의 Role의 Public 설정 점검
PROMPT  ===========================
PROMPT
col grantee format a15
col granted_role format a25
SPOOL ./tmp/6.4.txt
select grantee,granted_role from dba_role_privs where grantee='PUBLIC';
SPOOL OFF



PROMPT
PROMPT
PROMPT  7.1 세션 Idle timeout 설정
PROMPT  ===========================
SPOOL ./tmp/7.1.txt
select resource_name, limit from dba_profiles where profile='DEFAULT';
SPOOL OFF


PROMPT
PROMPT
PROMPT  8.1 데이터베이스 최신 보안패치와 밴더 권고사항 적용
PROMPT  ===========================
PROMPT
col product format a50
col version format a15
SPOOL ./tmp/8.1.txt
SELECT product, version FROM product_component_version;
SPOOL OFF  
PROMPT



PROMPT
PROMPT
PROMPT  8.2 보안에 취약하지 않은 버전의 데이터베이스 사용 여부
PROMPT  ===========================
SPOOL ./tmp/8.2.txt
select banner from v$version where banner like 'Oracle%';
SPOOL OFF
PROMPT



PROMPT
PROMPT
PROMPT  9.1 감사 기능 설정 점검
PROMPT  ===========================
col name format a20
col value format a30
SPOOL ./tmp/9.1.txt
SELECT name, value FROM v$parameter WHERE name='audit_trail';
SPOOL OFF
PROMPT


PROMPT
PROMPT
PROMPT  10.1 DB서버 중요정보 암호화 적용 여부
PROMPT  ===========================



PROMPT
PROMPT
PROMPT  11.1 데이터베이스 관리자 계정에 Audit Table이 속해 있는 여부
PROMPT  ===========================
PROMPT
col table_name format a10
col owner format a10
SPOOL ./tmp/11.1.txt
select table_name, owner from dba_tables where table_name='AUD$';
SPOOL OFF
PROMPT




PROMPT
PROMPT
PROMPT  #. 참고 정보 수집
PROMPT  ==============================
PROMPT
col username format a15
col profile format a20
col account_status format a20
col grantee format a20
col granted_role format a30
col admin_option format a13
SPOOL ./tmp/info1.txt
select username, profile, account_status from dba_users;
SPOOL OFF
SPOOL ./tmp/info2.txt
select grantee, granted_role,admin_option from dba_role_privs;
SPOOL OFF
SPOOL ./tmp/info3.txt
select * from dba_profiles;
SPOOL OFF
SPOOL ./tmp/rac.txt
select * from v$option where parameter='Real Application Clusters';
SPOOL OFF

PROMPT
PROMPT
PROMPT 스크립트 결과물을 생성하고 있습니다. 잠시만 기다려 주십시오.

HOST ./logthink_oracle_result_v19.1.sh

PROMPT SQL 스크립트가 완료되었습니다
PROMPT

EXIT
