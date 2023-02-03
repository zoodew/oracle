
/*                                                          221228 2교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <SYNONYM>
    SYNONYM은 오라클에서 제공하는 객체로 데이터베이스 객체에 별칭을 생성한다.
    SYNONYM을 사용하면 다른 사용자가 제공하는 객체를 참조할 때 간단하게 사용할 수 있다.
    
    1) 비공개 SYNONYM
        객체에 대한 접근 권한을 부여받은 사용자가 정의한 동의어로 해당 사용자만 사용이 가능하다.
    2) 공개 SYNONYM
        관리자 권한을 가진 사용자(DBA)가 정의한 동의어로 모든 사용자가 사용이 가능하다.(ex.DUAL)
*/
--    1. 비공개 SYNONUM 생성
    -- 관리자 계정으로 KH계정에 SYNONYM을 생성할 수 있는 생성 권한을 준다. (SYS계정에서 하기!!)
    GRANT CREATE SYNONYM TO KH;

    SELECT *
    FROM ROLE_SYS_PRIVS
    WHERE ROLE = 'RESOURCE';

    -- EMPLOYEE 테이블에 비공개 SYNONYM 생성(이 계정에서만 사용가능한 동의어) (KH 계정으로 다시 바꾸기)
    CREATE SYNONYM EMP FOR EMPLOYEE;

    SELECT * FROM EMPLOYEE;
    SELECT * FROM EMP;
        -- EMPLOYEE를 SYNONUM인 EMP로 줄여서 사용 가능 결과 동일하게 나온다.


--  2. 공개 SYNONYM 생성 (관리자계정(SYS)으로 접속하고 수행)
    CREATE PUBLIC SYNONYM DEPT FOR KH.DEPARTMENT;
    -- 접속에서 SYS 계정의 공용동의어에서 찾아보기

    -- STUDY 계정 (공개 SYNONYM은 모든 사용자가 사용 가능하니 다른 계정으로 접속해서 확인해보기)으로 접속
    -- STUDY 계정은 KH.DEPARTMENT에 접근할 수 있는 권한 없음
    SELECT * FROM KH.DEPARTMENT;
    SELECT * FROM DEPT;                 -- 권한 없어서 에러 발생

    -- 관리자 계정으로 다른 사용자 계정에서 테이블에 접근할 수 있는 권한을 준다. (SYS계정 들어가서 실행)
    GRANT SELECT ON KH.DEPARTMENT TO STUDY;

    -- STUDY로 넘어와서 다시 조회
    SELECT * FROM KH.DEPARTMENT;        -- 권한을 부여받아서 에러 발생 없이 제대로 뜸
    SELECT * FROM DEPT;                 -- 동의어도 제대로 조회되는 것 볼 수 있다.


-- SYNONYM 삭제
    -- KH 계정 접속 후 비공개 동의어 삭제
    DROP SYNONYM EMP;
    -- 관리자(SYS) 계정 접속 후 공개동의어 삭제
    DROP PUBLIC SYNONYM DEPT;

-- 접속 창에서 삭제 됐는지 확인까지 해보기
