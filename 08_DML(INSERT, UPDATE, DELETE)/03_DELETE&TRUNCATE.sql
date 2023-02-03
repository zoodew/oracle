
/*                                                              221222 7교시 08_DML(INSERT, UPDATE, DELETE)
    < DML(Data Manipulation Language) >
        데이터 조작 언어로 테이블에 값을 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문이다.
   
    < DELETE >
        테이블에 기록 된 데이터를 삭제하는 구문이다.
        행 단위로 삭제하는 구문이다.
        WHERE 절을 생략하면 "모든" 행의 데이터가 삭제된다.        cf) 모두 다 삭제 되지만 다른 구문 TRUNCATE
        
        [표현법]
            DELETE FROM 테이블명
            [WHERE 조건];
*/
COMMIT;

-- EMP_SALARY 테이블에서 선동일 사장의 데이터를 지우기
DELETE FROM EMP_SALARY;
SELECT * FROM EMP_SALARY;

ROLLBACK;       -- ROLLBACK > 마지막 COMMIT 시점으로 돌아감


    /*
    DELETE 조심히 써야 함 아무 생각 없이 하다보면 원하지 않았던 데이터가 삭제되거나 전체 다 삭제될 수도 있다
    SELECT 구문 써서 조심히 신중하게 사용하기
    */
-- 우선 SELECT * 살리고 DELETE 주석 처리 해두고서 지우길 원하는 데이터가 맞는지 확인한 후에 맞다면 SELECT *을 주석처리하고 DELETE 주석을 풀어서 삭제함
SELECT *
--DELETE
FROM EMP_SALARY
WHERE EMP_NAME = '선동일';


-- EMP_SALARY 테이블에서 DEPT_CODE가 D5인 직원들을 삭제
SELECT *
--DELETE
FROM EMP_SALARY
WHERE DEPT_CODE = 'D5';

ROLLBACK;

SELECT * FROM EMP_SALARY;

/*                                                              221222 7교시 08_DML(INSERT, UPDATE, DELETE)
    < DML(Data Manipulation Language) >
        데이터 조작 언어로 테이블에 값을 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문이다.
   
    < TRUNCATE >
        테이블의 전체 행을 삭제할 때 사용하는 구문이다. 
        별도의 조건을 제시할 수 없다. WHERE 조건 식을 사용하지 않음
        DELETE보다 수행 속도가 빠르다.    DELETE는 한 행 한 행 지워나가는데 (조건도 맞나 보고..) TRUNCATE는 그냥 싹 지워버림
        ROLLBACK을 통해 복구 불가능하다.
        
        [표현법]
            TRUNCATE TABLE 테이블명;
            
*/
SELECT * FROM EMP_SALARY;
SELECT * FROM DEPT_COPY;

DELETE FROM EMP_SALARY;
DELETE FROM DEPT_COPY;

ROLLBACK;                   -- DELETE는 데이터 살리기 가능   ROLLBACK 됨
                            -- 물리적인 데이터 저장할 공간은 남아 있음
TRUNCATE TABLE EMP_SALARY;
TRUNCATE TABLE DEPT_COPY;

ROLLBACK;                   -- TRUNCATE는 데이터 살리기 불가능  ROLLBACK 안 됨
                            -- 물리적인 데이터 저장 공간까지 다 지워짐 아예 초기 상태로 돌아감