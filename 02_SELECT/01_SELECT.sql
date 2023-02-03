/*                                  221212 3교시  ORACLE 02_DQL(SELECT)
    <SELECT>
      [표현법]
        SELECT 컬럼 [, 컬럼, ... ]
        FROM 테이블명;                          세미콜론(;) : 한 문장이 끝났다는 의미
*/
-- 1) EMPLOYEE 테이블에서 전체 사원들의 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY         -- EMP_NAME을 EMP_ AGE로 바꿔보기 EMPLOYEE 테이블에 없는 데이터라 오류가 남
FROM EMPLOYEE;

-- 2) 쿼리는 대소문자를 가리지 않지만 관례상 대문자로 작성한다.
select emp_id, emp_name, salary
from employee;                          -- 문장의 끝에는 반드시 세미콜론(;) 넣어주기 거기서 문장이 끝난다는 뜻

-- 3) EMPLOYEE  테이블에서 전체 사원들의 모든 컬럼 조회
SELECT *                                -- 모든 컬럼을 조회하는 방법 별(*)
FROM EMPLOYEE;

-- 4) 현재 계정이 소유한 테이블 목록 조회
SELECT * FROM TABS;

-- 테이블 구조 확인 (컬럼 정보) DESC(describe)
DESC EMPLOYEE;


---------------------------------실습문제   221212 3교시-------------------------------
-- 1. JOB 테이블의 모든 컬럼 조회
SELECT *
FROM JOB;

-- 2. JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME                         -- 원하는 컬럼 가져올 때 SELECT * FROM 테이블명 적고서 * 지우고 ctrl enter 누르면 지정 테이블에 있는 칼럼 목록 쭉 뜸
FROM JOB;

-- 3. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT *
FROM DEPARTMENT;

-- 4. EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 조회
SELECT EMP_NAME,                        -- SELECT FROM 쭉 다 한 줄에 써도 무방하고 띄어써도 무방함 보기 쉽게 정리하기
       EMAIL,
       PHONE,
       HIRE_DATE
FROM EMPLOYEE;

-- 5. EMPLOYEE 테이블의 입사일, 직원명, 급여 조회
SELECT HIRE_DATE, EMP_NAME, SALARY      -- 조회할 때 컬럼의 순서 중요하지 않음. 테이블에 있는 순서대로 넣을 필요 없고 가져오고 싶은대로 가져와도 됨
FROM EMPLOYEE;

-------------------------------------------------------------------------------------



/*                                  221212 4교시  ORACLE 02_DQL(SELECT)
    <컬럼의 산술 연산>
*/
-- 1) EMPLOYEE 테이블에서 직원명, 직원의 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY, SALARY * 12
FROM EMPLOYEE;

-- 2) EMPLOYEE 테이블에서 직원명, 연봉, 보너스가 포함된 연봉((급여 + (보너스 * 급여)) * 12) 조회
-- 산술 연산 중 NULL 값이 존재할 경우 산술 연산의 결과는 무조건 NULL이다. (ex 보너스가 없는 직원의 보너스 포함된 연봉 값 NULL)
SELECT EMP_NAME,
       SALARY,
       SALARY * 12,
--     (SALARY + ( BONUS * SALARY )) * 12 
       (SALARY + ( NVL(BONUS, 0) * SALARY )) * 12       -- NULL처리 함수 : NVL(컬럼명, 컬럼의 값이 NULL이면 반환할 값)
FROM EMPLOYEE;

-- 3) EMPLOYEE 테이블에서 직원명, 입사일, 근무일수(오늘 날짜 - 입사일)
-- SYSDATE는 현재 날짜를 출력한다.
SELECT SYSDATE
FROM DUAL;

-- DATE 타입도 연산이 가능하다.
SELECT EMP_NAME,
       HIRE_DATE,
       CEIL(SYSDATE - HIRE_DATE)          -- 오라클에서는 실수정 정수형 구분 없음 그래서 숫자데이터는 소수점이 나옴
FROM EMPLOYEE;                            -- ㄴ CEIL() 매개값으로 전달되는 수를 올림하는 함수



/*                                  221212 4교시  ORACLE 02_DQL(SELECT)
    <컬럼 별칭>
        [표현법]
            컬럼 AS 별칭 / 컬럼 AS "별칭" / 컬럼 별칭 / 컬럼 "별칭"
            - AS 생략 가능
            - 큰따옴표("") : 별칭에 띄어쓰기나 특수문자가 있을 경우 인식이 어려울 수 있어서 큰따옴표를 넣어줌
*/
-- 1) EMPLOYEE 테이블에서 직원명, 연봉, 보너스가 포함된 연봉((급여 + (보너스 * 급여)) * 12) 조회
SELECT EMP_NAME AS 직원명,
       SALARY * 12  AS "연봉",
       (SALARY + (BONUS * SALARY)) * 12 "총 소득(원)"
FROM EMPLOYEE;



/*                                  221212 4교시  ORACLE 02_DQL(SELECT)
    <리터럴>
*/
-- 1) 문자나 날짜 리터럴 작성할 때 작은따옴표('') 붙이기 cf) 별칭 큰따옴표("")
SELECT 1
FROM EMPLOYEE;  -- 1이라는 데이터가 EMPLOYEE 테이블 행의 개수만큼 반복돼서 출력

SELECT 1
FROM DUAL;      -- DUAL 테이블 오라클 자체에서 제공되는 테이블, 함수를 사용해 계산 후 결과값을 확인할 때 사용하는 테이블

-- 2) EMPLOYEE 테이블에서 사번, 직원명, 급여, 단위(원) 조회
SELECT EMP_ID AS "사번",
       EMP_NAME AS "직원명",
       SALARY AS "급여",
       '원' AS "단위(원)"       -- 모든 행에 반복적으로 출력 문자나 날짜 리터럴 작성할 때 작은따옴표('') 붙이기
FROM EMPLOYEE;



/*                                  221212 5교시  ORACLE 02_DQL(SELECT)
    <DISTINCT>  
        - 컬럼에 포함된 데이터 중 중복 값을 제외하고 한 번씩만 표시하고자 할 때 사용
        - SELECT 절에서 한 번만 기술 가능하다.
*/
-- 1) EMPLOYEE 테이블에서 직급 코드 조회
SELECT JOB_CODE
FROM EMPLOYEE;

-- 2) EMPLOYEE 테이블에서 직급 코드(중복 제거) 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE              -- SELECT 결과에서 중복되는 애들 다 제거 후 한 번만 출력 ex) J2가 여러 개였으면 다 제거하고 한 번만
ORDER BY JOB_CODE;         -- ORDER BY 컬럼 : 오름차순 정렬 ORDER BY 컬럼 DESC : 내림차순 정렬

-- 3) EMPLOYEE 테이블에서 부서 코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE;

-- 4) EMPLOYEE 테이블에서 부서 코드(중복 제거) 조회
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE
ORDER BY DEPT_CODE DESC;       -- ORDER BY 컬럼 DESC : 내림차순 정렬

-- 5) DISTINCT는 SELECT 절에 한 번만 기술할 수 있다.
-- SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE         이렇게 컬럼별로 작성하는 것 불가능함
SELECT DISTINCT JOB_CODE, DEPT_CODE    -- 두 개 이상의 컬럼을 나열하면 JOB_CODE, DEPT_CODE 두 열을 합친 한 행을 한 뭉치로 본다.
FROM EMPLOYEE;                         --   ㄴ DISTINCT를 했을 때 그 한 뭉치를 하나로 삼고 그것과 중복되는 값을 찾아서 지움 각 열을 개별적으로 보지 않음




/*                                  221212 5교시  ORACLE 02_DQL(SELECT)
    <WHERE>
      [표현법]
        SELECT 컬럼 [, 컬럼, ...]
        FROM 테이블명
        WHERE 조건식;                  조건에 맞는 행들만 출력
*/
-- 1) EMPLOYEE 테이블에서 부서 코드가 D9와 일치하는 사원들의 모든 컬럼을 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';     -- 그냥 D9라고 적으면 안 되고 데이터 타입에 맞는 표기법 써줘야 함 테이블에 들어가 열 안에 들어가서 무슨 데이터 타입인지 확인가능. char이니 문자타입 문자는 작은따옴표('')

-- 2) EMPLOYEE  테이블에서 부서 코드가 D9와 일치하는 사원들의 직원명, 부서 코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE                           -- 블럭 잡고 ctrl enter시 그 블럭잡힌 부분만 출력
WHERE DEPT_CODE = 'D9';

-- 3) EMPLOYEE 테이블에서 부서 코드가 D9와 일치하지 않는 사원들의 사번, 직원명, 부서 코드 조회
SELECT EMP_NO, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE != 'D9';

-- 4) EMPLOYEE 테이블에서 급여가 400만원 이상인 직원들의 직원명, 부서 코드, 급여 조회
SELECT EMP_NAME AS "직원명",
       DEPT_CODE AS "부서 코드",
       SALARY AS "급여"
FROM EMPLOYEE
WHERE SALARY >= 4000000;                   -- 숫자라서 '' 필요없음


---------------------------------실습문제   221212 5교시-------------------------------
-- 1. EMPLOYEE 테이블에서 재직 중(ENT_YN 값이 'N')인 직원들의 사번, 직원명, 입사일 조회
SELECT EMP_ID AS "사번",
       EMP_NAME AS "직원명",
       HIRE_DATE AS "입사일",
       '재직중' AS "근무여부"  -- 리터럴 : 모든 행에 반복적으로 출력
FROM EMPLOYEE
WHERE ENT_YN = 'N';         -- cf) JAVA의 =와 헷갈리지 말기! JAVA = 는 대입연산자, ORACLE의 =는 등호

-- 2. EMPLOYEE 테이블에서 급여가 300만원 이상인 직원의 직원명, 급여, 입사일을 조회
SELECT EMP_NAME AS "직원명", SALARY AS "급여", HIRE_DATE AS "입사일"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 3. EMPLOYEE 테이블에서 연봉이 5000만원 이상인 직원의 직원명, 급여, 연봉, 입사일 조회
SELECT EMP_NAME AS "직원명",
       SALARY AS "급여",
       SALARY * 12 AS "연봉",
       HIRE_DATE AS "입사일"
FROM EMPLOYEE
WHERE ( SALARY * 12 ) >= 50000000;
-- WHERE "연봉" >= 50000000;      -- 불가! 이유 > 실행 순서는 작성순이 아니다. 실행 순서는 1) FROM 2) WHERE 3) SELECT임 별칭은 마지막 3) 때 붙기 때문에 WHERE절 실행 시기에는 별칭을 모름

-------------------------------------------------------------------------------------



/*                                  221212 6교시  ORACLE 02_DQL(SELECT)
    <ORDER BY>
      [표현법]
        SELECT 컬럼 [, 컬럼, ...]
        FROM 테이블명
        WHERE 조건식
        ORDER BY 컬럼명|별칭|컬럼순번 [ASC | DESC] [NULLS FIRST | NULLS LAST];                       - 정렬의 기준이 되는 컬럼
                - ORDER BY는 제일 마지막에 실행되기 때문에 컬럼명 말고 별칭, 컬럼 순번으로도 지정이 가능하다.
                - ASC > 오름차순, DESC > 내림차순. 생략하면 기본 ASC 오름차순
                - NULLS FIRST > NULL값을 먼저 출력. NULLS LAST > NULL값을 나중에 출력.
                - 오름차순 정렬은 기본적으로 NULLS LAST
                - 내림차순 정렬은 기본적으로 NULLS FIRST
                - 정렬은 기준을 여러 개 제시할 수 있다.
                
        <SELECT 문의 실행 순서>
            1. FROM 절
            2. WHERE 절
            3. SELECT 절
            4. ORDER BY 절   (ORDER BY는 언제나 제일 마지막에 실행)
*/
-- 1) EMPLOYEE 테이블에서 BONUS로 오름차순 정렬
SELECT *
FROM EMPLOYEE
--ORDER BY BONUS;
ORDER BY BONUS ASC;     -- 오름차순 정렬은 기본적으로 NULLS LAST
--ORDER BY BONUS ASC NULLS FIRST; -- 오름차순, NULL값을 먼저 출력

-- 2) EMPLOYEE 테이블에서 BONUS로 내림차순 정렬(단, BONUS 값이 일치할 경우에는 SALARY를 가지고 오름차순 정렬)
SELECT *
FROM EMPLOYEE
--ORDER BY BONUS DESC;       -- 내림차순 정렬은 기본적으로 NULLS FIRST
--ORDER BY BONUS DESC NULLS LAST; -- 내림차순, NULL값을 나중에 출력
ORDER BY BONUS DESC, SALARY ASC;    -- 정렬은 기준을 여러 개 제시할 수 있다. 콤마(,)로 나열. 내림 오름차순도 각 조건별로 다르게 걸 수 있음

-- 3) EMPLOYEE 테이블에서 연봉별 내림차순으로 정렬된 직원들의 직원명, 연봉 조회
SELECT EMP_NAME AS "직원명",
       SALARY * 12 AS "연봉"
FROM EMPLOYEE
--ORDER BY SALARY * 12 DESC;
--ORDER BY "연봉" DESC;           -- 별칭을 통한 정렬도 가능. ORDER BY의 실행 순서 맨 마지막!
ORDER BY 2 DESC;                  -- 컬럼 순번을 통한 정렬도 가능. ORDER BY의 실행 순서 맨 마지막!

