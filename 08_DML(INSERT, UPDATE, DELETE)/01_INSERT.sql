
/*                                                              221222 4교시 08_DML(INSERT, UPDATE, DELETE)
    < DML(Data Manipulation Language) >
        데이터 조작 언어로 테이블에 값을 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문이다.
   
    < INSERT >
        테이블에 새로운 행을 추가하는 구문이다.
        
        [표현법]
            1) INSERT INTO 테이블명 VALUES(값, 값, ..., 값);
                - 테이블의 "모든" 컬럼에 값을 INSERT 하고자 할 때 사용한다.
                - 컬럼 순번을 지켜서 모든 VALUES 값을 나열해야 한다.
                        나열된 컬럼과 데이터 타입이 다르거나 개수가 맞지 않다거나 하면 에러가 발생
            
            2) INSERT INTO 테이블명(컬럼, 컬럼, ..., 컬럼) VALUES(값, 값, ..., 값);
                - 테이블의 특정 컬럼에 값을 INSERT 하고자 할 때 사용한다.
                - 테이블명(컬럼...)에 나열되지 않은 컬럼들은 기본적으로 NULL 값이 들어간다.
                    단, 기본값(DEFAULT)이 지정되어 있으면 NULL이 아닌 기본값이 들어간다.
                - NOT NULL 제약 조건이 걸려있는 컬럼은 반드시 선택해서 값을 제시해야 한다.
            
            3) INSERT INTO 테이블명 (서브 쿼리);
                - VALUES를 대신해서 서브 쿼리로 조회한 결과값을 통째로 INSERT 한다.
                    서브 쿼리로 조회된 모든 행 결과를 INSERT 함. 여러 행을 INSERT 할 수 있음.      cf) 1),2)는 하나의 행만 INSERT
                - 서브 쿼리의 결과값이 INSERT 문에 지정된 테이블 컬럼의 개수, 순서 데이터 타입과 같아야 한다.
*/
-- 테스트에 사용할 테이블을 생성

        CREATE TABLE EMP_01 (
            EMP_ID NUMBER PRIMARY KEY,
            EMP_NAME VARCHAR2(30) NOT NULL,
            DEPT_TITLE VARCHAR2(30),
            HIRE_DATE DATE DEFAULT SYSDATE NOT NULL
        );
    
-- INSERT ( 표현법1)을 사용 )
    INSERT INTO EMP_01 VALUES (100, '문인수', '서비스 개발팀', SYSDATE);
    
    -- 모든 컬럼에 값을 지정하지 않아서 에러 발생
    INSERT INTO EMP_01 VALUES (200, '홍길동', '개발 지원팀');   -- HIRE_DATE에 디폴트를 걸어놨어도 1)INSERT 쿼리문 자체는 "모든" 컬럼에 INSERT를 받겠다는 뜻이라 에러남     cf) 표현법2)
    -- 데이터 타입이 맞기에 에러는 발생하지 않지만 데이터가 잘못 저장된다. INSERT 순서 잘 보고 넣기!
    INSERT INTO EMP_01 VALUES (300, '인사팀', '홍길동', DEFAULT);
    -- 컬럼 순서와 데이터 타입이 맞지 않아서 에러 발생
    INSERT INTO EMP_01 VALUES ('인사팀', 300, '홍길동', DEFAULT);

        SELECT * FROM EMP_01;

-- INSERT ( 표현법2)을 사용 )
    INSERT INTO EMP_01(EMP_ID, EMP_NAME, DEPT_TITLE, HIRE_DATE) VALUES (400, '진도준', '보안팀', NULL);
                    -- HIRE_DATE DATE DEFAULT SYSDATE 상태 > NULL도 값임 NULL이라는 값을 넘겨준 것 그래서 기본값인 SYSDATE가 아니라 (null)이 들어감
                    -- HIRE_DATE DATE DEFAULT SYSDATE NOT NULL 상태 > 에러 발생 cannot insert NULL into ("KH"."EMP_01"."HIRE_DATE")
    INSERT INTO EMP_01(EMP_NAME, EMP_ID, DEPT_TITLE, HIRE_DATE) VALUES ('이몽룡', 500, '마케팅팀', SYSDATE);
                    -- INSERT하고자 하는 컬럼 순번은 자유롭게 적을 수 있음 적은 컬럼순과 INSERT 할 VALUES 값 순서만 맞추면 됨
    INSERT INTO EMP_01(EMP_ID, EMP_NAME) VALUES (600, '성춘향');
                    -- 선택되지 않은 컬럼은 기본적으로 NULL, 기본값을 설정하면 그 값이 들어감. DEPT_TITLE는 NULL, HIRE_DATE는 SYSDATE
    INSERT INTO EMP_01(EMP_ID, DEPT_TITLE) VALUES ('700', '마케팅팀');
                    -- 에러 발생. NOT NULL 제약조건이 걸린 EMP_NAME에 값을 INSERT 해주지 않음. 값을 적지 않아서 NULL이 들어가야 하는데 NOT NULL 제약조건 걸림
    INSERT INTO EMP_01(EMP_ID, EMP_NAME, DEPT_TITLE) VALUES(800, '심청이', '마케팅팀');
                    -- HIRE_DATE DATE DEFAULT SYSDATE 상태 > HIRE_DATE 기본값 들어감
                    -- HIRE_DATE DATE DEFAULT SYSDATE NOT NULL 상태 > 삽입 됨! 왜? 진짜 NULL이 아니라 기본값이 있기 때문에 NOT NULL 제약 조건이 걸려있어도 기본값으로 행 삽입이 됨

        SELECT * FROM EMP_01;
                                                              
-- INSERT ( 표현법3)을 사용 )                                     221222 5교시 08_DML(INSERT, UPDATE, DELETE)
    DELETE FROM EMP_01;

-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 
-- 직원들의 사번, 이름, 부서명, 입사일을 조회해서 EMP_01 테이블에 INSERT 하시오.
            SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.HIRE_DATE
            FROM EMPLOYEE E
            INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);

    INSERT INTO EMP_01 (SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.HIRE_DATE
                        FROM EMPLOYEE E
                        INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID));
            -- 테이블 컬럼과 서브쿼리로 조회한 데이터 컬럼의 "개수"와 "순서", "데이터 타입"이 맞아야 한다. 

    -- 테이블 컬럼 순서와 서브쿼리로 조회한 데이터 컬럼의 "순서"가 맞지 않아서 에러가 발생
    INSERT INTO EMP_01 (SELECT E.EMP_NAME, E.EMP_ID, D.DEPT_TITLE, E.HIRE_DATE
                        FROM EMPLOYEE E
                        INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID));

    -- 서브 쿼리로 조회한 데이터의 컬럼의 개수가 테이블의 컬럼의 "개수"보다 많아서 에러가 발생
    INSERT INTO EMP_01 (SELECT E.EMP_ID, E.EMP_NAME, E.SALARY, D.DEPT_TITLE, E.HIRE_DATE
                        FROM EMPLOYEE E
                        INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID));


-- 데이터 삭제 구문 아무것도 안 적으면 모든 데이터 다 삭제됨
DELETE FROM EMP_01;
    
    
-- EMPLOYEE 테이블에서 직원들의 사번, 직원명을 조회해서 EMP_01 테이블에 INSERT 하시오.
    SELECT EMP_ID, EMP_NAME
    FROM EMPLOYEE;

    INSERT INTO EMP_01(EMP_ID, EMP_NAME) (
        SELECT EMP_ID, EMP_NAME
        FROM EMPLOYEE
    );       

    SELECT * FROM EMP_01;

DROP TABLE EMP_01;



/*                                                              221222 5교시 08_DML(INSERT, UPDATE, DELETE)
    < DML(Data Manipulation Language) >
        데이터 조작 언어로 테이블에 값을 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문이다.
   
    < INSERT ALL >
        두 개 이상의 테이블에 각각 INSERT 하는데 동일한 서브 쿼리가 사용되는 경우
        INSERT ALL을 이용해서 여러 테이블에 한 번에 데이터 삽입이 가능하다.
        
        [표현법]
            1) INSERT ALL
               INTO 테이블명1[(컬럼, 컬럼, ..., 컬럼)] VALUES(값, 값, ..., 값)
               INTO 테이블명2[(컬럼, 컬럼, ..., 컬럼)] VALUES(값, 값, ..., 값)
               서브쿼리;
                - 서브 쿼리를 수행하고 조회된 결과를 각각의 테이블에 삽입
            
            2) INSERT ALL
               WHEN 조건1 THEN
                    INTO 테이블명1[(컬럼, 컬럼, ..., 컬럼)] VALUES(값, 값, ..., 값)
               WHEN 조건2 THEN
                    INTO 테이블명2[(컬럼, 컬럼, ..., 컬럼)] VALUES(값, 값, ..., 값)
               서브 쿼리;
                - 서브 쿼리를 수행하고 조건1이 맞으면 서브 쿼리의 데이터를 테이블1에 삽입, 조건1이 안 맞고 조건2가 맞다면 테이블2에 값 삽입
            
*/
-- INSERT ALL 표현법 1)
    -- 테스트할 테이블 만들기 (테이블 구조만 복사)
        CREATE TABLE EMP_DEPT
        AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
           FROM EMPLOYEE
           WHERE 1 = 0;
       
        CREATE TABLE EMP_MANAGER
        AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
           FROM EMPLOYEE
           WHERE 1 = 0;
       
    SELECT * FROM EMP_DEPT;
    SELECT * FROM EMP_MANAGER;

-- EMP_DEPT 테이블에 부서 코드가 D1인 직원의 사번, 이름, 부서코드, 입사일을 삽입하고
-- EMP_MANAGER 테이블에 부서 코드가 D1인 직원의 사번, 이름, 관리자 사번을 조회하여 삽입한다.
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

    INSERT ALL
    INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D1';
        
    SELECT * FROM EMP_DEPT;
    SELECT * FROM EMP_MANAGER;

DROP TABLE EMP_DEPT;
DROP TABLE EMP_MANAGER;


-- INSERT ALL 표현법 2)                                            221222 6교시 08_DML(INSERT, UPDATE, DELETE)
    -- 테스트할 테이블 만들기 (테이블 구조만 복사)
        CREATE TABLE EMP_OLD
        AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
           FROM EMPLOYEE
           WHERE 1 = 0;
    
        CREATE TABLE EMP_NEW
        AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
           FROM EMPLOYEE
           WHERE 1 = 0;

    SELECT * FROM EMP_OLD;
    SELECT * FROM EMP_NEW;

-- EMPLOYEE 테이블의 입사일을 기준으로
-- 2000년 1월 1일 이전에 입사한 사원의 정보는 EMP_OLD 테이블에 삽입하고
-- 2000년 1월 1일 이후에 입사한 사원의 정보는 EMP_NEW 테이블에 삽입한다.
    SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
    FROM EMPLOYEE;

    INSERT ALL
    WHEN HIRE_DATE < '2000/01/01' THEN                              -- 2) 서브 쿼리 각 행이랑 조건을 비교 000101보다 작으면 3)가서 INSERT
        INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, SALARY, HIRE_DATE)    -- 3) 
    WHEN HIRE_DATE >= '2000/01/01' THEN                             -- 4) 2)조건이랑 안 맞으면 4)로 와서 비교 000101 보다 크거나 같으면 5)가서 INSERT
        INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, SALARY, HIRE_DATE)    -- 5) 
    SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE                      -- 1) 서브 쿼리 수행
    FROM EMPLOYEE;

DROP TABLE EMP_OLD;
DROP TABLE EMP_NEW;

