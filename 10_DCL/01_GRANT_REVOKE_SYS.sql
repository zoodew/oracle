/*                                                              221227 2교시 10_DCL
    <DCL (DATA CONTROL LANGUAGE)>
        데이터를 제어하는 구문으로 계정에게 시스템 권한 또는 객체에 대한 접근 권한을 부여(GRANT)하거나 회수(REVOKE)하는 구문이다.
        1) 시스템 권한
        2) 객체 접근 권한
        
    <시스템 권한>
        데이터베이스(DB)에 접근하는 권한, 오라클에서 제공하는 객체들을 생성/삭제할 수 있는 권한
            - CREATE SESSION : 데이터베이스에 접속할 수 있는 권한
            - CREATE TABLE : 테이블을 생성할 수 있는 권한
            - CREATE VIEW : 뷰를 생성할 수 있는 권한
            - CREATE USER : 계정을 생성할 수 있는 권한
            - DROP USER : 계정을 삭제할 수 있는 권한
            ...
            
            [표현법]
                GRANT 권한 TO 계정;
                GRANT 권한, 권한, 권한, ... TO 계정;            -- 권한 여러 개 줄 때
                REVOKE 권한[, 권한, 권한, ...] FROM 계정;
*/
-- 1. SAMPLE 계정 생성      (계정도 OBJECT임 그래서 CREATE ~ 구문으로 생성 가능, 현재접속계정은 SYS계정 최상위계정)
    CREATE USER SAMPLE IDENTIFIED BY SAMPLE;        -- IDENTIFIED 비번

-- 2. 계정에 접속하기 위해서 CREATE SESSION 권한 부여
    GRANT CREATE SESSION TO SAMPLE;

-- 3. SAMPLE 계정에서 테이블을 생성할 수 있는 CREATE TABLE 권한 부여 받기                   221227 2교시 02_GRANT_REVOKE_SAMPLE과 비교
    GRANT CREATE TABLE TO SAMPLE;

-- 4. 테이블 스페이스 할당(테이블, 뷰, 인덱스 등 객체들이 실제로 저장되는 물리적인 공간)
    ALTER USER SAMPLE QUOTA 2M ON SYSTEM;   -- SYSTEAM 테이블스페이스에 2M라는 공간을 할당하겠다.


/*
    <DCL (DATA CONTROL LANGUAGE)>
        데이터를 제어하는 구문으로 계정에게 시스템 권한 또는 객체에 대한 접근 권한을 부여(GRANT)하거나 회수(REVOKE)하는 구문이다.
        1) 시스템 권한
        2) 객체 접근 권한
        
    <객체 접근 권한>
        특정 객체를 조작할 수 있는 권한
            - SELECT, VIEW, SEQUENCE
            - INSERT : TABLE, VIEW
            - UPDATE : TABLE, VIEW
            - ALTER : TABLE, SEQUENCE
            ...
            
            [표현법]
                GRANT 권한[, 권한, 권한, ... ] ON 객체 TO 계정;
                REVOKE 권한[, 권한, 권한, ...] ON 객체 FROM 계정;
*/
-- 5. KH.EMPLOYEE 테이블을 조회할 수 있는 권한 부여
    GRANT SELECT ON KH.EMPLOYEE TO SAMPLE;  --KH.EMPLOYEE 객체를 조회할 수 있는 권한을 SAMPLE에게 부여.

-- 6. KH.DEPARTMENT 테이블을 조회할 수 있는 권한 부여
    GRANT SELECT ON KH.DEPARTMENT TO SAMPLE;

-- 7. KH.DEPARTMENT 테이블에 데이터를 삽입할 수 있는 권한 부여
    GRANT INSERT ON KH.DEPARTMENT TO SAMPLE;


-- 8. KH.DEPARTMENT 테이블에 데이터를 삽입할 수 있는 권한 회수                    221227 3교시
    REVOKE INSERT ON KH.DEPARTMENT FROM SAMPLE; -- SAMPLE 테이블에 부여되어있던 KH.DEPARTMENT에 INSERT 권한을 회수함


    SELECT * FROM KH.JOB;
    -- SYS는 최고 계정이라서 권한 부여 생성 이런 거 굳이 안 해도 다 가능함



/*                                                                              221227 3교시 10_ㅅ치
    <ROLE>
        권한들을 하나의 집합으로 묶어놓은 것을 ROLE이라고 한다.
        권한을 제어하는 데 용이함
*/
-- 반드시SYS계정에서만 가능
    SELECT *
    FROM ROLE_SYS_PRIVS
    --WHERE ROLE = 'CONNECT';
    --WHERE ROLE = 'RESOURCE';
    WHERE ROLE = 'MYROLE';


-- ROLE 을 직접 만들 수도 있다.
-- ROLE도 하나의 OBJECT(객체)라 생성이 가능
    CREATE ROLE MYROLE;
    GRANT CREATE SESSION, CREATE TABLE TO MYROLE;       -- MYROLE에 권한 부여
