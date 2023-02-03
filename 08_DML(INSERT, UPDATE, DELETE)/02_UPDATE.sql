
/*                                                              221222 6교시 08_DML(INSERT, UPDATE, DELETE)
    < DML(Data Manipulation Language) >
        데이터 조작 언어로 테이블에 값을 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문이다.
   
    < UPDATE >
        테이블에 기록된 데이터를 수정하는 구문
        테이블의 행의 값을 수정하는 구문이다.
        SET 절에서 여러 개의 컬럼을 콤마(,)로 나열해서 값을 동시에 변경할 수 있다.
        WHERE 절을 생략하면 모든 행의 데이터가 변경된다.
        
        [표현법]
            - 1)
            UPDATE 테이블명
            SET 컬럼명 = 변경하려는 값,
                컬럼명 = 변경하려는 값,
                ...
            [WHERE 조건];
            
            - 2) 서브 쿼리를 사용해서 컬럼의 값을 변경할 수도 있다.
            UPDATE 테이블명
            SET 컬럼명 = (서브 쿼리),
                컬럼명 = (서브 쿼리),
                ...
            [WHERE 조건];
            
*/
-- 테스트를 진행할 테이블 생성
        CREATE TABLE DEPT_COPY
        AS SELECT *
           FROM DEPARTMENT;
    
        SELECT * FROM DEPT_COPY;        -- 컬럼명, 데이터 타입, 데이터, NOT NULL 제약 조건 복사

-- DEPT_COPY 테이블에서 DEPT_ID가 D9인 부서명을 '미래전략기획팀'으로 수정
        UPDATE DEPT_COPY
        SET DEPT_TITLE = '미래전략기획팀';
            -- WHERE 조건을 안 지정해 주면 "모든" 행에 적용됨. 그래서 조건을 걸어줌 걸어주면 조건을 만족하는 행만 지정 됨
        SELECT * FROM DEPT_COPY; 
    
        ROLLBACK;

    UPDATE DEPT_COPY
    SET DEPT_TITLE = '미래전략기획팀'
    WHERE DEPT_ID = 'D9';
    
    SELECT * FROM DEPT_COPY; 
    
    CREATE TABLE EMP_SALARY
    AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
       FROM EMPLOYEE;
       
    SELECT * FROM DEPT_COPY;
    SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블에서 노옹철 사원의 급여를 1000000원으로 변경
    UPDATE EMP_SALARY
    SET SALARY = 1000000
    WHERE EMP_NAME = '노옹철';
    
    SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블에서 선동일 사장의 급여를 7000000으로, 보너스를 0.2로 변경
-- 변경하려는 값이 여러 개일 때 한 번에 바꾸는 법
    UPDATE EMP_SALARY
    SET SALARY = 7000000,
        BONUS = 0.2
    WHERE EMP_NAME = '선동일';

    SELECT * FROM EMP_SALARY;

-- 모든 사원의 급여를 기존 급여에서 10플 인상한 금액(급여 * 1.1)으로 변경
    UPDATE EMP_SALARY
    SET SALARY = SALARY * 1.1;
    
    SELECT * FROM EMP_SALARY;

-- UPDATE 시 변경할 값은 해당 컬럼에 대한 제약 조건에 위배되면 안 된다.
    -- EMPLOYEE 테이블에 사번이 200번인 사원의 사원 번호를 NULL로 변경
    -- EMPLOYEE 테이블에서 사번은 제약조건 PRIMARY KEY. PRIMARY KEY는 식별자 역할을 함 그래서 중복도 빈 값도 안 됨 NOT NULL, UNIQUE가 자동으로 들어감
    UPDATE EMPLOYEE
    SET EMP_ID = NULL
    WHERE EMP_ID = 200;
        -- cannot update ("KH"."EMPLOYEE"."EMP_ID") to NULL 에러 발생. NOT NULL 제약 조건에 위배됨


    -- EMPLOYEE 테이블에 노옹철 사원의 부서 코드를 D0로 변경
    -- DEPT_CODE FOREIGN KEY(외래키) 연결 되어있음
    UPDATE EMPLOYEE
    SET DEPT_CODE = 'D9'    -- FOREIGN KEY 제약조건에 위배된다.
    WHERE EMP_NAME = '노옹철';
        -- parent key not found 에러 발생. 
            -- FOREIGN KEY로 참조하고 있는 부모 테이블에 있는 값이나 NULL로만 변경이 가능함 근데 DEPARTMENT테이블의 DEPT_ID에는 D1 ~ D9까지만 있음



-- UPDATE 시에 서브 쿼리를 사용할 수 있다.                           221222 7교시 08_DML(INSERT, UPDATE, DELETE)
-- 방명수 사원의 급여와 보너스를 유재식 사원의 급여, 보너스와 동일하게 변경

SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식';

    -- 1) 단일행 서브쿼리를 각각의 컬럼에 적용
    UPDATE EMP_SALARY
    SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_NAME = '유재식'),
        BONUS = (SELECT BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
    WHERE EMP_NAME = '방명수';

    SELECT * FROM EMP_SALARY WHERE EMP_NAME = '방명수';

    -- 2) 다중열 서브쿼리를 사용해서 SALARY, BONUS 컬럼을 한 번에 변경
    UPDATE EMP_SALARY
    SET (SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
    WHERE EMP_NAME = '방명수';

    SELECT * FROM EMP_SALARY WHERE EMP_NAME = '방명수';


-- EMP_SALARY 테이블에서 아시아 지역에 근무하는 직원들의 보너스를 0.3으로 변경
SELECT *
FROM EMP_SALARY, DEPT_COPY, LOCATION;

SELECT ES.EMP_NAME
FROM EMP_SALARY ES
INNER JOIN DEPT_COPY DC ON (ES.DEPT_CODE = DC.DEPT_ID)
INNER JOIN LOCATION L ON (DC.LOCATION_ID = L.LOCAL_CODE)
WHERE L.LOCAL_NAME LIKE 'ASIA%';

UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_NAME IN (SELECT ES.EMP_NAME                       -- IN 써야함!!!! = 아님!! 괄호 안의 값이 여러 개임 이럴 땐 = 연산 불가능!!!!!!!                                        !!!!!!!!
                   FROM EMP_SALARY ES
                   INNER JOIN DEPT_COPY DC ON (ES.DEPT_CODE = DC.DEPT_ID)
                   INNER JOIN LOCATION L ON (DC.LOCATION_ID = L.LOCAL_CODE)
                   WHERE L.LOCAL_NAME LIKE 'ASIA%'
);

SELECT *
FROM EMP_SALARY;

