
/*                                                          221228 3교시 12_PL/SQL(Procedural Language extension to SQL)
    <PL/SQL>
        PL/SQL은 오라클에서 제공하는 절차적인 프로그래밍 언어이다.
        SQL 문의 반복적인 실행이나 조건에 따른 분기 등 다양한 기능을 제공한다.
        PL/SQL은 선언부(DECLARE SECTION), 실행부(EXECUTABLE SECTION), 예외 처리부(EXCEPTION SECTION)로 구성된다.
*/
-- 출력 기능 활성화 ( 실행하면 스크립트 화면에 출력됨)
    SET SERVEROUTPUT ON;

-- HELLO ORACLE 출력
    -- DECLARE 선언부 EXCEPTION 예외처리부 생략 가능
    -- BEGIN END 필수
    -- 끝에 / 슬래시 필수
    BEGIN
        DBMS_OUTPUT.PUT_LINE('HELLO ORACLE!');
    END;
    /


/*                                                         221228 3교시 12_PL/SQL(Procedural Language extension to SQL)
    1. 선언부
        변수 및 상수를 선언하는 영역이다. (선언과 동시에 초기화도 가능)
        변수 및 상수는 일반 타입 변수, 레퍼런스 타입 변수, ROW 타입 변수로 선언해서 사용할 수 있다.

    1) 일반 타입 변수 선언 및 초기화
        
        [표현법]
        DECLARE
            -- 선언부
            변수명 [CONSTANT(상수)] 자료형(크기) [:= 값];
        BEGIN
            -- 실행부
            ...
        END;
         /
*/
-- 선언부에서 변수 선언 가능
    DECLARE
        EID NUMBER;                           -- 변수 선언  :   변수명 데이터 타입
        ENAME VARCHAR2(15) := '문인수';        -- 변수 선언과 동시에 초기화
        PI CONSTANT NUMBER := 3.14;           -- 상수                 -- 상수는 선언과 동시에 초기화만 가능! BEGIN에서 초기화 불가
    BEGIN   
        EID := 300;                           -- 변수 초기화           -- 오라클에서는 '='앞에 ':' 넣어야 대입연산자(:=)
        ENAME := '공유';                                              -- 상수가 아니라 변수이기 때문에 언제든지 값 변경 가능
    --    PI := 3.15;                         -- 상수라서 초기화 후 값 변경이 불가능. 주석 풀면 에러 발생
    
        DBMS_OUTPUT.PUT_LINE('EID : ' || EID);          -- 변수 출력
        DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);      -- 변수 출력
        DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
    END;
    /



/*                                                         221228 3교시 12_PL/SQL(Procedural Language extension to SQL)
    1. 선언부
        변수 및 상수를 선언하는 영역이다. (선언과 동시에 초기화도 가능)
        변수 및 상수는 일반 타입 변수, 레퍼런스 타입 변수, ROW 타입 변수로 선언해서 사용할 수 있다.

    2) 레퍼런스 타입 변수 선언 및 초기화
        레퍼런스 타입 변수의 데이터 타입은 테이블의 컬럼의 데이터 타입을 참조한다.
    
        [표현법]
          DECLARE
            -- 선언부
            변수명 [CONSTANT] 테이블명.컬럼명%TYPE [:= 값];
          BEGIN
            -- 실행부
            ...
          END;
          /
*/
-- 노옹철 사원의 사번, 직원명, 급여 정보를 조회해서 출력한다.
    SELECT EMP_ID, EMP_NAME, SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철';
        --이 결과를 변수에 담아주기 변수 선언시 테이블에 있는 데이터 타입을 참조하기

    DECLARE
        EID EMPLOYEE.EMP_ID%TYPE;       -- EMPLOYEE 테이블의 EMP_ID 컬럼의 데이터 타입을 참조해서 변수를 만들겟다. > EID의 데이터 타입 = VARCHAR2(3)
        ENAME EMPLOYEE.EMP_NAME%TYPE;   -- VARCHAR2(20)
        SAL EMPLOYEE.SALARY%TYPE;       -- NUMBER
    BEGIN
        SELECT EMP_ID, EMP_NAME, SALARY -- SELECT한 결과물을 변수에 담기 SELECT 다음에 INTO 변수명, ...
        INTO EID, ENAME, SAL            -- 어떤 변수에 담을지를 작성. 컬럼순에 따라서 지정 EMP_ID 컬럼 데이터를 EID에 EMP_NAME 컬럼 데이터를 ENAME에...
        FROM EMPLOYEE
        WHERE EMP_NAME = '노옹철';
    
        DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
        DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
        DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    END;
    /

-- 입력 받은 직원명을 찾아 그 직원의 사번, 직원명, 급여 정보를 조회해 출력
    DECLARE
        EID EMPLOYEE.EMP_ID%TYPE;
        ENAME EMPLOYEE.EMP_NAME%TYPE;
        SAL EMPLOYEE.SALARY%TYPE;
    BEGIN
        SELECT EMP_ID, EMP_NAME, SALARY
        INTO EID, ENAME, SAL
        FROM EMPLOYEE
        WHERE EMP_NAME = '&직원명';        -- '&@@'    :   값을 입력받기 위한 창을 띄움. 선동일 노옹철 유재식 넣어보기
    
        DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
        DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
        DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    END;
    /

-- 실습                                                                               221228 4교시 12_PL/SQL(Procedural Language extension to SQL)
-- 레퍼런스 타입의 변수로 EID, ENAME, JCODE, DTITLE, SAL를 선언하고
-- 각 변수의 자료형은 EMPLOYEE 테이블의 EMP_ID, EMP_NAME, JOB_CODE, SALARY 컬럼과 DEPARTMENT 테이블의 DEPT_TITLE 컬럼의 자료형을 참조한다.
-- 사용자가 입력한 사번과 일치하는 사원을 조회한 후 조회 결과를 출력한다.
    SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, D.DEPT_TITLE, E.SALARY
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);

    DECLARE
        EID EMPLOYEE.EMP_ID%TYPE;
        ENAME EMPLOYEE.EMP_NAME%TYPE;
        JCODE EMPLOYEE.JOB_CODE%TYPE;
        DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
        SAL EMPLOYEE.SALARY%TYPE;
    BEGIN
        SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, D.DEPT_TITLE, E.SALARY
        INTO EID, ENAME, JCODE, DTITLE, SAL
        FROM EMPLOYEE E
        INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
        WHERE E.EMP_ID = '&사번';
    
        DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
        DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
        DBMS_OUTPUT.PUT_LINE('직급 : ' || JCODE);
        DBMS_OUTPUT.PUT_LINE('부서 : ' || DTITLE);
        DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    END;
    /



/*                                                         221228 4교시 12_PL/SQL(Procedural Language extension to SQL)
    1. 선언부
        변수 및 상수를 선언하는 영역이다. (선언과 동시에 초기화도 가능)
        변수 및 상수는 일반 타입 변수, 레퍼런스 타입 변수, ROW 타입 변수로 선언해서 사용할 수 있다.

    3) ROW 타입 변수 선언 및 초기화
        하나의 테이블의 여러 컴럼의 값을 한꺼번에 저장할 수 있는 변수를 선언할 수 있다
*/
    DECLARE
        EMP EMPLOYEE%ROWTYPE;
    BEGIN
        SELECT *                -- 하나의 행에 있는 모든 컬럼의 값을 한꺼번에 ROW타입 변수에 다 담아 놓음
        INTO EMP
        FROM EMPLOYEE
        WHERE EMP_NAME = '&직원명';
    
        DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);                                -- 변수명.조회할컬럼명
        DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('주민번호 : ' || EMP.EMP_NO);
        DBMS_OUTPUT.PUT_LINE('이메일 : ' || EMP.EMAIL);
        DBMS_OUTPUT.PUT_LINE('급여 : ' || TO_CHAR(EMP.SALARY, 'FML999,999,999'));     -- 출력 구문에 함수도 사용 가능함
        DBMS_OUTPUT.PUT_LINE('입사일 : ' || TO_CHAR(EMP.HIRE_DATE, 'YYYY"년" MM"월" DD"일"'));    -- 년월일 패턴 잘 보기 년월일은 "큰따옴표"로 묶기
    END;
    /




/*                                                         221228 4교시 12_PL/SQL(Procedural Language extension to SQL)
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직을 기술하는 영역이다.
    
    1) 선택문
        1-1) IF 구문
            IF 조건식 THEN
              실행 문장
            END IF;
*/
-- 사번을 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스를 출력
-- 단, 보너스를 받지 않는 사원은 보너스 출력 전에 '보너스를 지급받지 않는 사원입니다.'라는 문구를 출력한다.
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE;

    DECLARE
        EID EMPLOYEE.EMP_ID%TYPE;
        ENAME EMPLOYEE.EMP_NAME%TYPE;
        SAL EMPLOYEE.SALARY%TYPE;
        BONUS EMPLOYEE.BONUS%TYPE;
    BEGIN
        SELECT EMP_ID,
               EMP_NAME,
               SALARY,
               NVL(BONUS, 0)        -- 보너스가 없으면 0 출력 되게 함
        INTO EID, ENAME, SAL, BONUS
        FROM EMPLOYEE
        WHERE EMP_ID = '&사번';
    
        DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
        DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
        DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
        IF (BONUS/*변수 BONUS임!*/ = 0) THEN                       -- 보너스가 0일때 출력구문 작성 식   IF 조건식을 만족할 때 THEN 실행 만족하지 않으면 END IF
            DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS);
    END;
    /


/*                                                         221228 4교시 12_PL/SQL(Procedural Language extension to SQL)
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직을 기술하는 영역이다.
    
    1) 선택문
        1-2) IF ~  ELSE 구문
            IF 조건식 THEN
              실행 문장
            ELSE 
              실행 문장
            END IF;
*/
-- 위의 PL/SQL 구문을 IF ~ ELSE 구문으로 변경하여 작성
    DECLARE
        EID EMPLOYEE.EMP_ID%TYPE;
        ENAME EMPLOYEE.EMP_NAME%TYPE;
        SAL EMPLOYEE.SALARY%TYPE;
        BONUS EMPLOYEE.BONUS%TYPE;
    BEGIN
        SELECT EMP_ID,
               EMP_NAME,
               SALARY,
               NVL(BONUS, 0)
        INTO EID, ENAME, SAL, BONUS
        FROM EMPLOYEE
        WHERE EMP_ID = '&사번';
    
        DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
        DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
        DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
        IF (BONUS/*변수 BONUS임!*/ = 0) THEN                           -- (조건식)을 만족하면 THEN 실행 만족하지 않으면 ELSE 실행
            DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS);
        END IF;
    END;
    /


/*                                                         221228 5교시 12_PL/SQL(Procedural Language extension to SQL)
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직을 기술하는 영역이다.
    
    1) 선택문
        1-3) IF ~  ELSIF ~ ELSE 구문
            IF 조건식 THEN
              실행 문장
            ELSIF 조건식 THEN
              실행 문장
              ...
            ELSE
              실행 문장
            END IF;          
*/
-- 사용자에게 점수를 입력받아 SCORE 변수에 저장한 후 학점은 입력된 점수에 따라 GRADE 변수에 저장한다.
-- 90점 이상은 'A', 80점 이상은 'B', 70점 이상은 'C', 60점 이상은 'D', 60점 미만은 'F'
-- 출력은 '당신의 점수는 95점이고, 학점은 A학점입니다.'와 같이 출력한다.
    DECLARE
        SCORE NUMBER;                                            -- 변수 선언
        GRADE CHAR(1);
    BEGIN
        SCORE := '&점수';                                         -- 사용자에게서 점수 입력 받아서 SCORE 변수 초기화

        IF (SCORE >= 90) THEN
            GRADE := 'A';
        ELSIF (SCORE >= 80) THEN
            GRADE := 'B';
        ELSIF (SCORE >= 70) THEN
            GRADE := 'C';
        ELSIF (SCORE >= 60) THEN
            GRADE := 'D';
        ELSE
            GRADE := 'F';   
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다.');        -- 입력받은 점수 출력
    END;
    /

-- 사용자에게 입력받은 사번과 일치하는 사원의 급여 조회 후 출력한다.
-- 조회한 급여는 SAL 변수에 대입
-- 급여가 500만원 이상이면 '고급', 300만원 이상이면 '중급', 300만원 미만이면 '초급'으로 등급을 정하고
-- 출력은 '해당 사원의 급여 등급은 고급입니다.'와 같이 출력한다.
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';

    DECLARE
        SAL EMPLOYEE.SALARY%TYPE;
        GRADE VARCHAR2(10);
    BEGIN
        SELECT SALARY
        INTO SAL
        FROM EMPLOYEE
        WHERE EMP_ID = '&사번';
    
        IF (SAL >= 5000000) THEN
            GRADE := '고급';
        ELSIF (SAL >= 3000000) THEN
            GRADE := '중급';
        ELSE
            GRADE := '초급';
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
    END;
    /

-- SAL_GRADE 테이블을 이용한 출력
-- 급여가 MIN MAX 사이면 그에 맞는 SAL_LEVEL 출력
    SELECT SAL_LEVEL
    FROM SAL_GRADE;

    DECLARE
        SAL EMPLOYEE.SALARY%TYPE;
        GRADE VARCHAR2(10);
    BEGIN
        SELECT SALARY               -- 급여정보를 변수 SAL에 담은 SELECT문
        INTO SAL
        FROM EMPLOYEE
        WHERE EMP_ID = '&사번';
    
        SELECT SAL_LEVEL            -- 급여 정보를 변수 SAL에 담아서 그걸 WHERE 조건식에 사용
        INTO GRADE                  -- SELECT된 SAL_LEVEL의 값을 GRADE변수에 담아줌
        FROM SAL_GRADE
        WHERE SAL BETWEEN MIN_SAL AND MAX_SAL;
                -- 첫번째 쿼리문에서 받아온 데이터를 다음 쿼리문에서 그대로 사용할 수 있다.
        DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
    END;
    /


/*                                                         221228 5교시 12_PL/SQL(Procedural Language extension to SQL)
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직을 기술하는 영역이다.
    
    1) 선택문
        1-4) CASE 구문                cf) JAVA의 switch 구문
            CASE 비교 대상
              WHEN 비교값 1 THEN 결과값 1
              WHEN 비교값 2 THEN 결과값 2
              ...
              [ELSE 결과값]
            END;   
*/
-- 사번을 입력받은 후에 사원의 모든 컬럼 데이터를 EMP라는 ROWTYPE 변수에 대입하고 DEPT_CODE에 따라서 알맞은 부서를 출력한다.
    DECLARE
        EMP EMPLOYEE%ROWTYPE;               -- ROWTYPE 변수 : EMPLOYEE 테이블의 모든 컬럼을 받을 수 있는 변수 선언
        DNAME VARCHAR2(30);
    BEGIN
        SELECT *                            -- ROWTYPE변수라서 모든 컬럼의 데이터 다 가져올 수 있음
        INTO EMP
        FROM EMPLOYEE
        WHERE EMP_ID = '&사번';
    
        DNAME := CASE EMP.DEPT_CODE                 -- EMP.DEPT_CODE 값이        ROWTYPE과 짝 EMP.DEPT_CODE(변수명.컬럼명) DEPT_CODE의 값을 가져오는 변수 EMP의 값이
                    WHEN 'D1' THEN '인사관리부'       -- D1이면 DNAME 변수에 '인사관리부' 대입
                    WHEN 'D2' THEN '회계관리부'
                    WHEN 'D3' THEN '마케팅부'
                    WHEN 'D4' THEN '국내영업부'
                    WHEN 'D5' THEN '해외영업1부'
                    WHEN 'D6' THEN '해외영업2부'
                    WHEN 'D7' THEN '해외영업3부'
                    WHEN 'D8' THEN '기술지원부'
                    WHEN 'D9' THEN '총무부'
                    ELSE '부서없음'                   -- 만족하는 값이 없으면 '부서없음' 대입
                END;
    
        DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);
        DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('부서 코드 : ' || EMP.DEPT_CODE);
        DBMS_OUTPUT.PUT_LINE('부서명 : ' || DNAME);
    END;
    /



/*                                                         221228 6교시 12_PL/SQL(Procedural Language extension to SQL)
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직을 기술하는 영역이다.
    
    2) 반복문
        2-1) BASIC LOOP
            LOOP
              반복적으로 실행시킬 구문

              [반복문을 빠져나갈 조건문 작성]
              1) IF 조건식 THEN
                    EXIT;
                 END IF; 
              2) EIXT WHEN 조건식;
            END LOOP;
*/
-- 1 ~ 5까지 순차적으로 1씩 증가하는 값을 출력
    DECLARE
        NUM NUMBER := 1;
    BEGIN
        LOOP                                -- LOOP에서 END LOOP 까지 반복함
            DBMS_OUTPUT.PUT_LINE(NUM);       
        
            NUM := NUM + 1;                 -- 반복문 조건식 없으면 무한루프, 멈추려면 조건을 걸어줘야함
        
--          IF (NUM > 5) THEN               -- 조건식 1) IF
--              EXIT;
--          END IF;
        
            EXIT WHEN NUM > 5;              -- 조건식 2)EXIT WHEN 조건식;
        END LOOP;
    END;
    /


/*                                                         221228 6교시 12_PL/SQL(Procedural Language extension to SQL)
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직을 기술하는 영역이다.
    
    2) 반복문
        2-2) WHILE LOOF
            WHILE 조건식
            LOOP
              반복적으로 실행할 구문;
            END LOOP; 
*/
-- 1 ~ 5까지 순차적으로 1씩 증가하는 값을 출력
    DECLARE
        NUM NUMBER := 1;
    BEGIN
        WHILE NUM <= 5                      -- WHILE 기간 동안 반복문이 반복되는것
        LOOP                                -- WHILE 조건식에 부합할 때 출력. 부합하지 않으면 EXIT
            DBMS_OUTPUT.PUT_LINE(NUM);
            NUM := NUM + 1;
        END LOOP;
    END;
    /


-- 구구단 (2 ~ 9 단 출력)
    DECLARE                         -- 내가 한 것           -- 왜 틀렸는지 알아보기
        NUM1 NUMBER := 2;                                  -- NUM2가 10으로 넘어감 
        NUM2 NUMBER := 1;
    BEGIN
        WHILE NUM1 <= 9
        LOOP        
            WHILE NUM2 <= 9
            LOOP
                DBMS_OUTPUT.PUT_LINE(NUM1 || ' X ' || NUM2 || ' = ' || NUM1 * NUM2);
                NUM2 := NUM2 + 1;
            END LOOP;
        
            NUM1 := NUM1 + 1;        
        END LOOP;
    END;
    /

    DECLARE                         -- 예시 쿼리문
        DAN NUMBER := 2;
        SU NUMBER;
    BEGIN
        WHILE DAN <= 9          -- 단 반복
        LOOP
            SU := 1;            -- 반복할 때마다 SU를 1로 초기화. 2단일때도 1로 초기화 3단일때도 1로 초기화.....
            WHILE SU <= 9
            LOOP
                DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || DAN * SU);
            
                SU := SU + 1;
            END LOOP;
        
            DAN := DAN + 1;        
        END LOOP;
    END;
    /


/*                                                         221228 6교시 12_PL/SQL(Procedural Language extension to SQL)
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직을 기술하는 영역이다.
    
    2) 반복문
        2-3) FOR LOOP
            FOR 변수 IN [REVERSE] 초기값..최종값
            LOOP
              반복적으로 실행할 구문;
            END LOOP;
*/
-- 1 ~ 5까지 순차적으로 1씩 증가하는 값을 출력
    BEGIN                       -- 변수가 필요 없어서 DECLARE 없이 BEGIN부터 시작
        FOR NUM IN 1..5
        LOOP
            DBMS_OUTPUT.PUT_LINE(NUM);
        END LOOP;
    END;
    /

-- 역순으로 출력
-- 최종값에서부터 초기값까지 순차적으로
    BEGIN
        FOR NUM IN REVERSE 1..5
        LOOP
            DBMS_OUTPUT.PUT_LINE(NUM);
        END LOOP;
    END;
    /

-- 구구단 (2 ~ 9단) 출력. (단, 짝수단만 출력한다.)             221228 7교시
    BEGIN
        FOR DAN IN 2..9
        LOOP
            IF (MOD(DAN, 2) = 0) THEN                 -- MOD 나머지 함수 오라클은 나머지 구하는 연산자 없음 MOD함수로 구해줘야함

            FOR SU IN 1..9
            LOOP
                DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || DAN * SU);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('-------------------------');
        
            END IF;
        END LOOP;
    END;
    /


-- 반복문을 이용한 데이터 삽입
    DROP TABLE TEST;

    CREATE TABLE TEST (
        NUM NUMBER,
        CREATE_DATE DATE
    );

    SELECT * FROM TEST;

    -- TEST 테이블에 10개의 행을 INSERT하는 PL/SQL 작성
    BEGIN
        FOR NUM IN 1..10
        LOOP
            INSERT INTO TEST VALUES(NUM, SYSDATE); 
--            COMMIT;
        END LOOP;
    END;
    /

    SELECT * FROM TEST;     -- 데이터 10개들어간거 확인 가능

-- PL/SQL 수행된다고해서 COMMIT되는 거 아니다. 따로 COMMIT넣어줘야함. 반복문 COMMIT 주석 풀고 삽입 후에 ROLLBACK 다시 해보기 > 안 됨
    ROLLBACK;               

-- TRUNCATE     :   TEST 테이블 데이터 다 날려줌 COMMIT 된 상태라도 다 지워짐
    TRUNCATE TABLE TEST; 


-- 짝수면 COMMIT 홀수면 ROLLBACK;
--  COMMIT ROLLBACK이 정상적으로 작동하는지 보기 위해
    BEGIN
        FOR NUM IN 1..10
        LOOP
            INSERT INTO TEST VALUES(NUM, SYSDATE); 
        
            IF (MOD(NUM, 2) = 0) THEN
                COMMIT;                         -- 짝수는 COMMIT해서 ROLLBACK 해도 지워지지 않음
            ELSE
                ROLLBACK;                       -- 홀수는 COMMIT을 안 해서 ROLLBACK 하면 지워짐
            END IF;
        END LOOP;
    END;
    /
    SELECT * FROM TEST;     -- COMMIT ROLLBACK이 정상적으로 작동하는지 보기 위해 > 짝수만 출력됨




/*                                                         221228 7교시 12_PL/SQL(Procedural Language extension to SQL)
    3. PL/SQL 예외 처리부
        PL/SQL 문에서 발생한 예외를 예외 처리부에서 처리가 가능하다
        
        * 오라클에서 미리 정의되어있는 예외
            - NO_DATA_FOUND     : SELECT 문의 수행 결과가 한 행도 없을 경우 발생
            - TOO_MANY_ROWS     : 한 행이 리턴되어야 하는데 SELECT 문에서 여러 개의 행을 반환할 때 발생
            - ZERO_DIVIDE       : 숫자를 0으로 나눌 때 발생
            - DUP_VAL_ON_INDEX  : UNIQUE 제약조건을 가진 컬럼에 중복된 데이터가 INSERT 될 때 발생
    
    DECLARE
    ...
    BEGIN
    ...
    EXCEPTION
          WHEN 예외명 1 THEN 예외 처리 구문 1;
          WHEN 예외명 2 THEN 예외 처리 구문 2;
          ...
          WHEN OTHERS THEN 예외 처리 구문;
    END
*/
-- ZERO_DIVIDE      :   사용자가 입력한 수로 나눗셈 연산한 결과 출력
    BEGIN
        DBMS_OUTPUT.PUT_LINE(10/&숫자);
    EXCEPTION
        WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('나누기 연산시 0으로 나눌 수 없습니다.');   -- 나눌 값에 0 넣었을 때 에러 발생
    END;
    /

-- DUP_VAL_ON_INDEX     :   UNIQUE 제약 조건 위배시
    BEGIN
        UPDATE EMPLOYEE
        SET EMP_ID = '200'
        WHERE EMP_NAME = '&이름';
    EXCEPTION                               -- 예외 발생시 에러를 띄우는 게 아니라 정상적으로 종료될 수 있게 만들어 주는구문
        WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
    END;
    /
    -- unique constraint (%s.%s) violated" 에러 발생 EMP_ID 중복 불가 PK제약조건 걸려있어서 UQ NN제약조건 갖고있음

-- NO_DATA_FOUND, TOO_MANY_ROWS 테스트
    -- 조회되는 데이터가 없을 때
    SELECT EMP_ID, DEPT_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D3';

    -- 너무 많은 행이 조회가 되었을 때
    SELECT EMP_ID, DEPT_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

    DECLARE
        EID EMPLOYEE.EMP_ID%TYPE;
        DCODE EMPLOYEE.DEPT_CODE%TYPE;
    BEGIN
        SELECT EMP_ID, DEPT_CODE
        INTO EID, DCODE
        FROM EMPLOYEE
        WHERE DEPT_CODE = '&부서코드';
    
        DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
        DBMS_OUTPUT.PUT_LINE('부서코드 : ' || DCODE);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
        WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('에러가 발생했습니다. 관리자에게 문의해 주세요');
    END;
    /
-- >  D4 입력시 정상 조회. 데이터 하나라서
--`>  D3 입력시 no data found 에러 발생. 데이터가 반드시 하나는 있어야 
-- >  D1 입력시 exact fetch returns more than requested number of rows 에러 발생. 한 행이 리턴되어야 하는데 SELECT 문에서 여러 개의 행을 반환할 때 발생
-- 너무 많아도 없어도 문제
