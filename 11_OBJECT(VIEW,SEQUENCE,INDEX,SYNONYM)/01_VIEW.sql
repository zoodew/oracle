
/*                                                          221227 3교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW>
        SELECT 구문을 저장할 수 있는 객체이다.
        데이터를 저장하고 있지 않으며 VIEW 에 접근할 때 SQL을 수행하면서 결과값을 가져온다.
        조회하는 용도로 사용
*/
-- VIEW 사용하지 '않고' 데이터 조회하기
    -- '한국'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
    WHERE N.NATIONAL_NAME = '한국';

    -- '러시아'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
    WHERE N.NATIONAL_NAME = '러시아';

    -- '일본'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
    WHERE N.NATIONAL_NAME = '일본';
    
        -- > 위의 세 쿼리문을 보면 WHERE절 빼고 다 동일함. 공통으로 사용되는 쿼리문, 자주 조회되는 쿼리문,..
        --      이런 쿼리문들을 VIEW로 만들어서 빠르게 간편하게 쉽게 사용 가능

    
-- VIEW 작성

    -- 관리자 계정으로 CREATE VIEW 권한을 부여
    GRANT CREATE VIEW TO KH;    -- 'SYS' 계정으로 변경 후(오른편 위쪽 구석에) 수행! 수행 후 다시 'KH'로 계정 변경 후 아래 쿼리문 수행!
    
    CREATE VIEW V_EMPLOYEE     /*VIEW도 객체라서 CREATE로 작성*/
    AS SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME                     -- 공통된 쿼리문을 서브쿼리로 AS에 넣어줌
       FROM EMPLOYEE E
       INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
       INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
       INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);
        -- 바로 위 권한 부여 구문(GRANT~) 수행 전!에 조회하면 KH 계정에서 VIEW를 생성할 수 있는 권한이 없어서 에러 발생
        --                      An attempt was made to perform a database operation without the necessary privileges.
        -- GRANT CREATE VIEW TO ~ 로 권한을 부여한 후에 VIEW 생성 쿼리문 수행하기
    
    -- VIEW는 가상의 테이블로 실제 데이터가 담겨있는 것은 아니다. VIEW가 만들어졌다고 해서 데이터를 갖고 있는 게 아님. 서브쿼리만 갖고 있음
    SELECT *
    FROM V_EMPLOYEE;
    
        -- 접속한 계정이 가지고 있는 VIEW에 대한 정보를 조회하는 뷰 테이블이다.
        SELECT * FROM USER_VIEWS;
            -- 조회후 TEXT를 보면 VIEW를 만들 때 지정한 서브쿼리가 그대로 들어있음.
            -- VIEW를 가지고 테이블처럼 사용하면 > TEXT가 갖고있는 쿼리문 수행 후 그 결과를 테이블처럼 사용하는 것!

-- VIEW 사용하여 데이터 조회        
    -- '한국'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회
    SELECT *
    FROM V_EMPLOYEE
    WHERE NATIONAL_NAME = '한국';

    -- '러시아'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회
    SELECT *
    FROM V_EMPLOYEE
    WHERE NATIONAL_NAME = '러시아';

    -- '일본'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회
    SELECT *
    FROM V_EMPLOYEE
    WHERE NATIONAL_NAME = '일본';
    



/*                                                          221227 4교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW 컬럼에 별칭 부여>
*/
    -- 사원의 사번, 직원명, 성별, 근무년수 조회
    SELECT EMP_ID,
           EMP_NAME,
           DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자'),
           EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)                                                                -- !!!!!!!!!엑스트랙함수 다시보기!!!!!
    FROM EMPLOYEE;

    -- 위 쿼리문을 갖고 VIEW생성
    CREATE VIEW V_EMP
    AS SELECT EMP_ID,
              EMP_NAME,
              DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자'),
              EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE;
-- VIEW 작성 시 컬럼명에 함수호출구문, 연산식이 들어가면 에러 발생       must name this expression with a column alias   (INLINE VIEW 참조)
    
    -- 1) 서브쿼리에서 별칭을 부여하는 방법
    CREATE VIEW V_EMP
    AS SELECT EMP_ID,
              EMP_NAME,
              DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자') AS "성별",
              EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
    FROM EMPLOYEE;

    SELECT * FROM V_EMP;

    -- 2) VIEW 생성 시 VIEW 이름 옆에 '모든' 컬럼에 별칭을 부여하는 방법
    CREATE OR REPLACE VIEW V_EMP("사번", "직원명", "성별", "근무년수")                 /* OR REPLACE : 기존의 동일한 이름을 가진 뷰가 있으면 덮어씀 */
    AS SELECT EMP_ID,          -- ㄴ 조회되는 모든 컬럼에 별칭을 부여해야 한다. 순서도 똑같이.
              EMP_NAME,
              DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자'),
              EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE;

    SELECT * FROM V_EMP;


DROP VIEW V_EMP;
DROP VIEW V_EMPLOYEE;




/*                                                          221227 4교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW를 이용한 DML(INSERT, UPDATE, DELETE) 사용>
        VIEW를 이용해서 DML작업을 하면 실제 데이터가 담겨있는 TABLE에 DML 작업이 수행됨
*/
-- JOB 테이블을 사용한 V_JOB VIEW 생성
    CREATE VIEW V_JOB
    AS SELECT *
       FROM JOB;

-- VIEW에 SELECT
    SELECT * FROM V_JOB;
    SELECT JOB_CODE, JOB_NAME FROM V_JOB;
    SELECT JOB_NAME FROM V_JOB;
    
-- VIEW에 INSERT
    INSERT INTO V_JOB VALUES('J8', '알바');
        -- VIEW에 INSERT하고 있음 조회해보면 VIEW에 J8추가되고 JOB 테이블에도 J8이 추가됨
        -- VIEW에 작업한 것처럼 보이지만 VIEW가 아니라 서브쿼리에 사용된 기본 테이블(JOB)에 실제 변경 작업을 해준 것
    SELECT * FROM V_JOB;
    SELECT * FROM JOB;
    
-- VIEW에 UPDATE 
    UPDATE V_JOB
    SET JOB_NAME = '인턴'
    WHERE JOB_CODE = 'J8';
        -- VIEW에 UPDATE하고 있음 조회해보면 VIEW에 알바가 인턴으로 변경 됐고 JOB 테이블에도 인턴으로 변경됨
        -- VIEW에 작업한 것처럼 보이지만 VIEW가 아니라 서브쿼리에 사용된 기본 테이블(JOB)에 실제 변경 작업을 해준 것
    SELECT * FROM V_JOB;
    SELECT * FROM JOB;

-- VIEW에 DELETE 
    DELETE
    FROM V_JOB
    WHERE JOB_CODE = 'J8';
        -- VIEW에 DELETE하고 있음 조회해보면 VIEW에 J8이 지워졌고 JOB테이블에서도 J8이 지워짐
        -- VIEW에 작업한 것처럼 보이지만 VIEW가 아니라 서브쿼리에 사용된 기본 테이블(JOB)에 실제 변경 작업을 해준 것
    SELECT * FROM V_JOB;
    SELECT * FROM JOB;




/*                                                          221227 4교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <DML 구문으로 VIEW 조작이 불가능한 경우>
        1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
        2. 뷰에 포함되지 않은 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우
        3. 산술 표현식으로 정의된 경우
        4. 그룹 함수나 GROUP BY 절을 포함한 경우
        5. DISTINCT를 포함한 경우
        6. JOIN을 이용해 여러 테이블을 연결한 경우
*/
-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
    CREATE OR REPLACE VIEW V_JOB
    AS SELECT JOB_CODE
       FROM JOB;
            -- VIEW에 JOB_CODE라는 컬럼 하나만 포함   
    SELECT * FROM V_JOB;

-- INSERT
    INSERT INTO V_JOB VALUES('J8', '인턴');
        -- V_JOB VIEW는 JOB_CODE라는 하나의 컬럼만 갖고 있는데 두 개의 컬럼을 INSERT하려 해서 too many values 에러 발생
    INSERT INTO V_JOB VALUES('J8');     -- INSERT 가능 컬럼이 동일함
    SELECT * FROM V_JOB;
    SELECT * FROM JOB;                  -- JOB_CODE 컬럼에만 값 J8을 INSERT했기 때문에 JOB_NAME 컬럼은 NULL

-- UPDATE
    UPDATE V_JOB
    SET JOB_NAME = '인턴'
    WHERE JOB_CODE = 'J8';
        -- V_JOB VIEW에는 JOB_NAME 컬럼이 없음 에러 발생 "JOB_NAME": invalid identifier

    UPDATE V_JOB
    SET JOB_CODE = 'J0'
    WHERE JOB_CODE = 'J8';

    SELECT * FROM V_JOB;
    SELECT * FROM JOB;
        -- VIEW 에 포함된 컬럼의 값을 변경하는 것은 가능하지만 VIEW에 포함되지 않은 컬럼을 변경하려고 하면 에러가 발생한다.
    
-- DELETE
    DELETE
    FROM V_JOB                  -- 여기까지만 쓰면 V_JOB데이터 다 삭제됨. WHERE 조건 걸어줘야 지정된 데이터만 삭제됨
    WHERE JOB_NAME = '사원';
        --  에러 발생 "JOB_NAME": invalid identifier
        
    DELETE
    FROM V_JOB
    WHERE JOB_CODE = 'J0';

    SELECT * FROM V_JOB;
    SELECT * FROM JOB;


-- 2. 뷰에 포함되지 않은 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우                    221227 5교시
    CREATE OR REPLACE VIEW V_JOB
    AS SELECT JOB_NAME                  -- JOB_NAME만을 컬럼으로 갖는 VIEW 작성
       FROM JOB;
   
    SELECT * FROM V_JOB;
    SELECT * FROM JOB;
    
-- INSERT
    INSERT INTO V_JOB VALUES('인턴');
        -- VIEW에 있는 JOB_NAME 컬럼에만 INSERT 될 수 있게 작성
        -- cannot insert NULL into ("KH"."JOB"."JOB_CODE") 에러 발생
        -- JOB 테이블의 JOB_CODE는 PRIMARY KEY 역할. 행을 식별하는 식별자 역할. PRIMARY KEY는 기본적으로 NOT NULL UNIQUE 제약조건 걸림
        -- JOB_CODE는 NOT NULL이라 비우면 안되는데 JOB_NAME에만 INSERT 하는 쿼리문 작성해서 에러 발생
        
-- UPDATE
    UPDATE V_JOB
    SET JOB_NAME = '인턴'
    WHERE JOB_NAME = '사원';
    
    SELECT * FROM V_JOB;
    SELECT * FROM JOB;

-- DELETE
-- EMPLOYEE 테이블의 FOREIGN KEY 제약조건이 걸려있기 때문에 '인턴' 행을 참조하고 있는 컬럼이 있어서 삭제 불가오류 발생한다.
    DELETE
    FROM V_JOB
    WHERE JOB_NAME = '인턴';
        -- 에러 발생 왜?
        
    SELECT * FROM V_JOB;
    SELECT * FROM JOB;
    
ROLLBACK; 
    
    
-- 3. 산술 표현식으로 정의된 경우
    ALTER TABLE EMPLOYEE MODIFY JOB_CODE NULL;      -- 컬럼 수정 방법(NULL일 때)
    
    -- 사원의 연봉 정보를 조회하는 뷰
    CREATE VIEW V_EMP_SALARY
    AS SELECT EMP_ID,
              EMP_NAME,
              EMP_NO,
              SALARY,
              SALARY * 12 AS "연봉"   -- 연산식 > "별칭" 써주기
       FROM EMPLOYEE;
    
    SELECT * FROM V_EMP_SALARY;
    
-- INSERT
-- 산술 연산으로 정의된 컬럼은 데이터 삽입이 불가능함. 가상의 컬럼
    INSERT INTO V_EMP_SALARY VALUES('300', '홍길동', '221227-3175230', 300000, 3600000);
            -- VIEW의 연봉 컬럼은 산술 연산으로 만들어낸 가상의 컬럼. 실제 테이블에 존재하는 컬럼이 아님. 그래서 데이터 삽입이 불가능함
            -- virtual column not allowed here
-- 산술 연산과 무관한 컬럼은 데이터 삽입이 가능함.
    INSERT INTO V_EMP_SALARY(EMP_ID, EMP_NAME, EMP_NO, SALARY) VALUES('300', '홍길동', '221227-3175230', 300000);
            -- 산술 연산이 있는 연봉 컬럼은 INSERT하지 않아서 삽입 가능
            
    SELECT * FROM V_EMP_SALARY;

-- UPDATE
-- 산술 연산으로 정의된 컬럼은 데이터 변경 불가능
    UPDATE V_EMP_SALARY
    SET "연봉" = 4000000
    WHERE EMP_ID = '300';
        -- "연봉" 컬럼은 실제 서브 쿼리에서 데이터를 갖고 오는 테이블에 존재하는 컬럼이 아님
        -- 가상의 컬럼에 데이터를 업데이트 하려 하면 에러가 발생함. virtual column not allowed here

-- 산술 연산과 무관한 컬럼은 데이터 변경이 가능
    UPDATE V_EMP_SALARY
    SET SALARY = 400000
    WHERE EMP_ID = '300';  
        -- 수정 가능
    SELECT * FROM V_EMP_SALARY;
    
-- DELETE
    DELETE
    FROM V_EMP_SALARY
    WHERE "연봉" = 4800000;
        -- 잉 삭제 가능? > 값을 INSERT나 UPDATE하는 것은 안되나 DELETE는 가능하다. 행 전체가 삭제됨

    SELECT * FROM V_EMP_SALARY;

ROLLBACK;


-- 4. 그룹 함수나 GROUP BY 절을 포함한 경우
-- INSERT, UPDATE, DELETE 다 불가능

-- 부서별 급여의 합계, 평균을 조회
    SELECT NVL(DEPT_CODE, '부서없음'),
           SUM(SALARY),
           FLOOR(AVG(NVL(SALARY,0)))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;

    CREATE OR REPLACE VIEW V_EMP_SALARY("부서코드", "합계", "평균")
    AS SELECT NVL(DEPT_CODE, '부서없음'),
              SUM(SALARY),
              FLOOR(AVG(NVL(SALARY,0)))
       FROM EMPLOYEE
       GROUP BY DEPT_CODE;
        -- 별칭 안 붙여주면 에러 발생 must name this expression with a column alias

SELECT * FROM V_EMP_SALARY;

-- INSERT (에러 발생)
    INSERT INTO V_EMP_SALARY VALUES('DO', 8000000, 4000000);
            -- virtual column not allowed here 가상의 컬럼이라 INSERT 안 됨
    INSERT INTO V_EMP_SALARY("부서코드") VALUES('DO');
            -- virtual column not allowed here
    SELECT * FROM V_EMP_SALARY;


-- UPDATE (에러 발생)
    UPDATE V_EMP_SALARY
    SET "합계" = 8820000
    WHERE "부서코드" = 'D1';
            -- 조회될 때 보이기는 하나의 행이나 여러 행이 그룹으로 묶인 데이터임. 그걸 바꾸면 그루핑 된 애들 안에 데이터까지 바뀌어야 함 에러발생
    
    UPDATE V_EMP_SALARY
    SET "부서코드" = 'D0'
    WHERE "부서코드" = 'D1';
            -- 조회될 때 보이기는 하나의 행이나 여러 행이 그룹으로 묶인 데이터임. 묶인 애들 속의 데이터까지 다 바뀌어야 함 에러 발생


-- DELETE (에러 발생)
    DELETE
    FROM V_EMP_SALARY
    WHERE "부서코드" = 'D1';   
            -- 조회될 때 보이기는 하나의 행이나 여러 행이 그룹으로 묶인 데이터임. 묶인 애들도 다 지워져야 함 에러 발생        


-- 5. DISTINCT를 포함한 경우                                                                    221227 6교시
-- INSERT UPDATE DELETE 다 불가능
-- 중복 제거 DISTINCT
    SELECT DISTINCT JOB_CODE
    FROM EMPLOYEE;

    CREATE VIEW V_EMP_JOB
    AS SELECT DISTINCT JOB_CODE
       FROM EMPLOYEE;

    SELECT * FROM V_EMP_JOB;

-- INSERT
    INSERT INTO V_EMP_JOB VALUES('J8');
        -- 조회된 행들이 하나의 행처럼 보여도 중복을 제거한 거라서 여러 행이 겹쳐져 있는 것임 GROUPBY와 비슷한 이유로 에러발생
        -- data manipulation operation not legal on this view
    
-- UPDATE
    UPDATE V_EMP_JOB
    SET JOB_CODE = 'J8'
    WHERE JOB_CODE = 'J7';
        -- J7 이 하나의 행이 아니라 중복되는 걸 겹쳐놓은 거라서 수정 불가
    
-- DELETE
    DELETE
    FROM V_EMP_JOB
    WHERE JOB_CODE = 'J7';
        -- J7 이 하나의 행이 아니라 중복되는 걸 겹쳐놓은 거라서 수정 불가
        

-- 6. JOIN을 이용해 여러 테이블을 연결한 경우
-- 직원들의 사번, 직원명, 주민번호, 부서명을 조회
    SELECT E.EMP_ID, E.EMP_NAME, E.EMP_NO, D.DEPT_TITLE
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

-- 위의 구문 갖고 VIEW 생성
    CREATE VIEW V_EMP_DEPT
    AS SELECT E.EMP_ID,
              E.EMP_NAME,
              E.EMP_NO,
              D.DEPT_TITLE
       FROM EMPLOYEE E
       INNER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

    SELECT * FROM V_EMP_DEPT;

-- INSERT
    INSERT INTO V_EMP_DEPT VALUES('300', '홍길동', '221227-3888888', '총무부');
            -- 총무부는 DEPARTMENT 테이블에 있는 데이터  > 에러 발생
    INSERT INTO V_EMP_DEPT(EMP_ID, EMP_NAME, EMP_NO) VALUES('300', '홍길동', '221227-3888888');
            -- INSERT는 되지만 VIEW로는 조회되지 않음 기존 테이블에서만 조회 가능
    SELECT * FROM V_EMP_DEPT;
    SELECT * FROM EMPLOYEE;
        -- FROM절에 적힌 기준 테이블(EMPLLOYEE)에 있는 컬럼에만 INSERT가 가능, JOIN절에 있는 테이블의 컬럼에는 INSERT 불가
    
    
-- UPDATE
    UPDATE V_EMP_DEPT
    SET DEPT_TITLE = '총무1팀'     -- DEPARTMENT에있음 DEPT_TITLE > DEPARTMENT의DEPT_TITLE이바뀌면 DEPARTMENT에서 같은 데이터값을 가지던 컬럼들 까지 다 바뀌게 됨 > 에러 발생
    WHERE EMP_ID = '200';
        -- DEPT_TITLE은 DEPARTMENT 테이블에 있는 컬럼. DEPT_TITLE이 바뀌면 DEPARTMENT에서 같은 데이터값을 갖는 컬럼들까지 다 바뀌게 됨
        -- EMP_ID 가 200일 때뿐만 아니라, EMP테이블의 D9 다 총무부 > 총무1팀으로 바뀜      에러 발생

    UPDATE V_EMP_DEPT
    SET EMP_NAME = '서동일' 
    WHERE EMP_ID = '200';
        -- FROM절에 있는 기준이 되는 테이블(EMPLLOYEE)에 있는 컬럼에만 UPDATE가 가능,  JOIN절에 있는 테이블의 컬럼은 UPDATE 불가
    SELECT * FROM V_EMP_DEPT;
    SELECT * FROM EMPLOYEE;

-- DELETE
-- 서브 쿼리의 FROM 절에 기술한 테이블에만 영향을 끼친다.
    DELETE
    FROM V_EMP_DEPT
    WHERE EMP_ID = '200';

    DELETE
    FROM V_EMP_DEPT
    WHERE DEPT_TITLE = '총무부';

    -- DELETE는 어떻게 하든 가능함! 대신 FROM절의 테이블의 행에만 영향을 미침
    SELECT * FROM V_EMP_DEPT;
    SELECT * FROM EMPLOYEE;
    SELECT * FROM DEPARTMENT;

ROLLBACK;






/*                                                          221227 6교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW 옵션>
    
    1. OR REPLACE
    - 기존에 동일한 뷰가 있을 경우 덮어쓰고, 존재하지 않으면 뷰를 새로 생성한다.
*/
    CREATE VIEW V_EMP
    AS SELECT EMP_NAME, SALARY, HIRE_DATE
       FROM EMPLOYEE;

    SELECT * FROM V_EMP;
    SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP';

    CREATE OR REPLACE VIEW V_EMP 
    AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
       FROM EMPLOYEE;

    SELECT * FROM V_EMP;
    SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP'; -- 위랑 TEXT 달라졌는지 비교해보기


/*                                                          221227 6교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW 옵션>
    
    2. NOFORCE / FORCE

        1) NOFORCE
        - 서브쿼리에 기술된 테이블이 존재해야만 뷰가 생성된다 (기본값, 별도로 옵션을 주지 않아도 됨)
*/
    CREATE /*NOFORCE*/ VIEW V_EMP_02
    AS SELECT *
       FROM TEST;   -- 없는 테이블
            -- TEST 테이블 없을 때! table or view does not exist 에러 발생

    -- TEST 테이블을 생성한 이후부터는 VIEW 생성 가능   테이블 생성 후 위 CREATE 문 수행 다시 해보면 정상적으로 뷰가 생성되는 것을 볼 수 있음
    CREATE TABLE TEST(
        TID NUMBER
    );

    DROP TABLE TEST;
    DROP VIEW V_EMP_02;


/*                                                          221227 6교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW 옵션>
    
    2. NOFORCE / FORCE

        2) FORCE
        - 서브쿼리에 기술된 테이블이 존재하지 않아도 VIEW는 생성되나 테이블이 없기 때문에 데이터를 조회할 수는 없다. VIEW 사용도 에러 발생
*/
    CREATE FORCE VIEW V_EMP_02
    AS SELECT *
       FROM TEST;

    SELECT * FROM V_EMP_02;     -- 뷰 생성은 됐지만 테이블이 없어서 조회는 불가능

    -- TEST 테이블을 생성한 이후부터는 VIEW 조회 가능
    CREATE TABLE TEST(
        TID NUMBER
    );

    SELECT * FROM V_EMP_02;


/*                                                          221227 7교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW 옵션>
    
    3. WITH CHECK OPTION
        서브 쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
*/
    CREATE VIEW V_EMP_03
    AS SELECT *
       FROM EMPLOYEE
       WHERE SALARY >= 3000000;

    SELECT * FROM V_EMP_03;

-- 선동일 사장의 급여를 200만원으로 변경 (원래 800만원)
-- 서브 쿼리의 조건에 부합하지 않아도 변경이 가능하다.
    UPDATE V_EMP_03
    SET SALARY = 2000000
    WHERE EMP_ID = '200';

    SELECT * FROM V_EMP_03; -- 선동일 사장 안 보임 이유! 선동일 사장은 200만원으로 서브쿼리 조건에 부합하지 않아서 빠지게 됨

ROLLBACK;       -- 선동일 사장 월급 원래대로 800만

    SELECT * FROM V_EMP_03;
    SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP_03';

    CREATE OR REPLACE VIEW V_EMP_03
    AS SELECT *
       FROM EMPLOYEE
       WHERE SALARY >= 3000000
    WITH CHECK OPTION;

    SELECT * FROM V_EMP_03;
    SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP_03';      -- TEXT 끝에 WITH CHECK OPTION이 들어갔나 확인

--서브 쿼리의 조건에 부합하지 않기 때문에 변경이 불가능하다.
    UPDATE V_EMP_03
    SET SALARY = 2000000
    WHERE EMP_ID = '200';
        -- 에러 발생 view WITH CHECK OPTION where-clause violation
        -- 변경하려는 값(2000000)이 조건(WHERE SALARY >= 3000000)에 맞지 않아서 에러 발생함 

-- 선동일 사장의 급여를 400만원으로 변경
--서브 쿼리의 조건에 부합하기 때문에 변경이 가능하다.
    UPDATE V_EMP_03
    SET SALARY = 4000000
    WHERE EMP_ID = '200';
        -- 변경하려는 값(4000000)이 조건에 부합하기 때문에 변경이 가능하다.
    SELECT * FROM V_EMP_03;

ROLLBACK;


/*                                                          221227 7교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW 옵션>
    
    4. WITH READ ONLY
        뷰에 대해 조회만 가능하다. (DML(INSERT, UPDATE, DELETE) 수행 불가)
*/
    CREATE VIEW V_DEPT
    AS SELECT *
       FROM DEPARTMENT
    WITH READ ONLY;

    SELECT * FROM V_DEPT;
    SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_DEPT';

-- INSERT
    INSERT INTO V_DEPT VALUES ('D0', '해외영업 4부', 'L5');
        -- cannot perform a DML operation on a read-only view 에러 READ ONLY!
        
-- UPDATE
    UPDATE V_DEPT
    SET LOCATION_ID = 'L2'
    WHERE DEPT_TITLE = '해외영업2부';
        -- cannot perform a DML operation on a read-only view 에러

-- DELETE
    DELETE
    FROM V_DEPT
    WHERE DEPT_TITLE = 'D1';
        -- cannot perform a DML operation on a read-only view 에러

-- INSER UPDATE DELETE 다 안 되고 SELECT만 가능함 읽기전용 VIEW
    SELECT * FROM V_DEPT;
    SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_DEPT';



/*                                                          221227 7교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <VIEW 삭제>
    
    DROP VIEW 뷰명;
*/
DROP VIEW V_DEPT;
DROP VIEW V_EMP;
DROP VIEW V_EMP_02;
DROP VIEW V_EMP_03;
DROP VIEW V_EMP_DEPT;
DROP VIEW V_EMP_JOB;
DROP VIEW V_EMP_SALARY;
DROP VIEW V_JOB;


SELECT * FROM USER_VIEWS;       -- 해당 유저가 갖고 있는 VIEW 보여주는 구문
