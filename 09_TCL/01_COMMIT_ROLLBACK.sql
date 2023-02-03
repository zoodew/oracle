/*                                                              221227 1교시 09_TCL
    <TCL(TRANSACTION CONTROL LANGUAGE)>
        트랜젝션을 제어하는 언어이다.
        데이터베이스는 데이터의 변경 사항(INSERT, UPDATE, DELETE)들을 묶어서 하나의 트랜잭션에 담아서 처리한다.

    <트랜잭션>
        하나의 논리적인 작업 단위를 트랜젝션이라고 한다. 쪼갤 수 없는 업무 처리의 최소 단위
            EX) ATM에서 현금 출력
                1. 카드 삽입
                2. 메뉴 선택
                3. 금액 확인 빛 인증
                4. 실제 계좌에서 금액만큼 인출
                5. 현금 인출
                6. 완료
    각각의 업무들을 묶어서 하나의 작업 단위로 만드는 것을 트랜잭션이라고 한다.
    하나의 트랜잭션으로 묶인 작업들은 반드시 한번에 이루어져야하고 작업 중 하나라도 틀릴시 취소가 되어야함

    <COMMIT>
        모든 작업들을 정상적으로 처리하겠다고 확정하는 구문이다.

    <ROLLBACK>
        모든 작업들을 취소하겠다고 확정하는 구문이다.(마지막 COMMIT 시점으로 돌아간다.)

    <SAVEPOINT>
        저장점을 지정하고 ROLLBACK 진행 시 전체 작업을 ROLLBACK 하는 것이 아닌 SAVEPOINT까지 일부만 ROLLBACK한다.
        일부만 ROLLBACK
        
        [표현법]
            SAVEPOINT 포인트명;
            ...
            ROLLBACK TO 포인트명;
*/
-- 테스트용 테이블 생성
    CREATE TABLE EMP_TEST                               --서브쿼리로 복사해오는 구문 제약조건은 NOT NULL만
    AS SELECT EMP_ID, EMP_NAME, DEPT_CODE
       FROM EMPLOYEE;

    COMMIT;

-- EMP_TEST 테이블에서 EMP_ID가 213, 218번인 사원 삭제
    --SELECT *                                          -- DELETE시 SELECT 먼저해서 원하는 데이터가 맞는지 확인 먼저 후 DELETE 수행
    DELETE
    FROM EMP_TEST
    WHERE EMP_ID IN ('213', '218');

-- 두 개의 행이 삭제된 시점에 SAVEPOINT 지정
    SAVEPOINT SP1;

-- EMP_TEST 테이블에서 EMP_ID가 200인 사원 삭제
    --SELECT *
    DELETE
    FROM EMP_TEST
    WHERE EMP_ID = '200';

-- ROLLBACK 기존대로라면 213 218 지워진 거까지 다 되어야함 ROLLBACK은 마지막 COMMIT시점까지!
-- SAVEPOINT 지정하면 마지막 COMMIT 시점이 아닌 SAVEPOINT 지정한 곳으로 ROLLBACK이 됨

    ROLLBACK;

    SELECT* FROM EMP_TEST;  -- SAVEPOINT 지정까지만 ROLLBACK이 되어서 200번만 돌아옴

    ROLLBACK;               -- SAVEPOINT로 ROLLBACK 후 한 번 더 ROLLBACK하면?

    SELECT * FROM EMP_TEST; -- 앞에서 작업한 것까지 나옴(213 218 삭제도) 왜냐 COMMIT으로 확정한 상태가 아녔어서 ROLLBACK이 가능

-- EMP_TEST 테이블에서 EMP_ID가 202번인 사원 삭제
    --SELECT *
    DELETE
    FROM EMP_TEST
    WHERE EMP_ID = '202';

    SELECT * FROM EMP_TEST;

-- DDL구문을 실행하는 순간 기존의 메모리 버퍼에 임시 저장된 변경 사항들이 무조건 DB에 반영된다. 쉽게 DDL구문 실행 시 COMMIT된다고 생각하기
    CREATE TABLE TEST(
        TID NUMBER
    );

    ROLLBACK;

    SELECT * FROM EMP_TEST;     -- 중간에 DDL구문을 수행(ex. TEST테이블생성)하면 ROLLBACK을 해도 돌아오지않음(202번 안돌아옴) DDL시 자동 COMMIT시켜줌

    -- 지금까지 실습했던 테이블 다 삭제
    DROP TABLE DEPT_COPY;
    DROP TABLE EMP_SLAARY;
    DROP TABLE EMP_TEST;
    DROP TABLE TEST;

