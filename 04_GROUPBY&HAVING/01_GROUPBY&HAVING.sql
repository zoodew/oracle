/*                                      221216 1교시 ORACLE 04_GROUP_BY HAVING
    <GROUP BY>
        그룹 기준을 제시할 수 있는 구문이다.
        여러 개의 값들을 하나의 그룹으로 묵어서 처리할 목적으로 사용한다.
*/

-- 전체 사원의 급여의 총합을 구한 결과 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 부서코드를 기준으로 합계를 내보고싶음 에러 발생. 왜?  > 단일 행 함수와 그룹 함수가 같이 사용되었음 사용하는 행 개수가 달라서 에러
SELECT DETP_CODE,
       SUM(SALARY)
FROM EMPLOYEE;
    -- >해결  > GROUP BY
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE         -- 이 행 빼고 안 빼고 출력해보며 있을 때 없을 때 비교해보기
ORDER BY DEPT_CODE;
    -- DEPT_CODE 컬럼을 기준으로 같은 값을 가진 행들을 그룹으로 묶는다.
    -- (DISTINCT와 다름 DISTINCT는 중복되는 컬럼 제거, GROUP BY는 같은 그룹으로 묶기)

-- 각 부서별 그룹으로 묶어서 부서별 급여의 총합을 조회
SELECT DEPT_CODE, SUM(SALARY)       -- 이 에러나는 쿼리를 그룹바이로 정리
FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY)   -- 그룹별로 SUM(SALARY) 한 것 D1끼리 급여 합계 , D2끼리 급여 합계.....
FROM EMPLOYEE
GROUP BY DEPT_CODE;             -- DEPT_CODE를 기준으로 한 그룹으로 묶임

-- cf) DISTINCT             
SELECT DISTINCT DEPT_CODE, SUM(SALARY)  -- DISTINCT > 단순히 중복만 지우는 것. 단일 행 함수인 것은 동일함 중복 되는 D1 다 지우고 하나의 D1만 출력 중복 D2 다 지우고 하나의 D2만 이런식으로..
FROM EMPLOYEE                           -- 그래서 여전히 출력 불가. 에러발생
ORDER BY DEPT_CODE;


-- EMPLOYEE 테이블에서 각 부서별 사원의 수를 조회
SELECT NVL(DEPT_CODE, '부서없음'),
       COUNT(*)                 -- 내가 쓴 쿼리 COUNT(EMP_NAME) 근데 딱히 EMP_NAME 써 줄 필요 없고 간단히 *로 처리해도됨
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 각 부서별 보너스를 받는 사원의 수를 조회
SELECT NVL(DEPT_CODE, '부서없음') AS "부서명",
       COUNT(BONUS) AS "보너스를 받는 사원 수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 각 직급별 사원의 수를 조회
SELECT JOB_CODE AS "직급명",
       COUNT(*) AS "사원 수"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 각 직급별 보너스를 받는 사원의 수를 조회
SELECT JOB_CODE AS "직급명",
       COUNT(BONUS) AS "보너스를 받는 사원 수"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;


-- 221216 2교시
-- EMPLOYEE 테이블에서 부서별 사원 수, 보너스를 받는 사원의 수, 급여의 합, 평균 급여, 최고 급여, 최저 급여를 조회           
-- 급여의 합, 평균 급여(소수점 안 나오게 버림), 최고 급여, 최저 급여는 세 자리마다 콤마(,) 찍기 공백 지움. 부서별 오름차순
SELECT NVL(DEPT_CODE, '부서없음') AS "부서 코드",
       COUNT(*) AS "사원 수",
       COUNT(BONUS) AS "보너스를 받는 사원 수",
       TO_CHAR(SUM(SALARY), 'FM999,999,999,999') AS "급여의 합",
--       TO_CHAR(TRUNC(AVG(SALARY)), 'FM999,999,999,999') AS "평균 급여",   -- 평균 주의!!!!!! 그룹 함수는 NULL값 포함 안 함 평균 낼 때 NULL을 포함할 지 안 할지에 따라 식이 달라짐! 주의!!!!!!!
       TO_CHAR(TRUNC(AVG(NVL(SALARY, 0))), 'FM999,999,999,999') AS "평균 급여",
       TO_CHAR(MAX(SALARY), 'FM999,999,999,999') AS "최고 급여",
       TO_CHAR(MIN(SALARY), 'FM999,999,999,999') AS "최저 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 성별 별 사원의 수를 조회
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여', 3, '남', 4, '여') AS "성별",
       SUBSTR(EMP_NO, 8, 1) AS "성별 코드",
       COUNT(*) AS "사원의 수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);      -- GROUP BY에는 컬럼명, 계산식, 함수 호출 구문이 올 수 있다.(단!!! 컬럼 순벌, 별칭은 사용할 수 없다.)

-- EMPLOYEE 테이블에서 부서 코드와 직급 코드가 같은 사원의 수, 급여의 합을 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE                   -- SELECT에 그룹함수로 묶인 컬럼이 아닌 일반적인 컬럼을 두 개 주는데 GROUP BY 기준으로는 하나의 컬럼만 지정하면 에러가 남 
GROUP BY DEPT_CODE;             -- 하나는 묶여서 나오고 하나는 원래 행 개수대로 그대로 나오게 돼서

SELECT DEPT_CODE, JOB_CODE,
       COUNT(*),
       SUM(SALARY)
FROM EMPLOYEE  
GROUP BY DEPT_CODE, JOB_CODE    -- 부서코드와 직급코드를 한 세트로 보고 두 가지 컬럼 다 같은 행끼리 묶는다.
ORDER BY DEPT_CODE, JOB_CODE;



/*                                      221216 2교시 ORACLE 04_GROUP_BY HAVING
    <HAVING>
        그룹에 대한 조건을 제시할 때 사용하는 구문. 주로 그룹함수의 결과를 가지고 수행
    
    
    <실행 순서>
        FROM > 
        WHERE > 
        GROUP BY > 
        HAVING > 
        SELECT > 
        ORDER BY 
*/
-- EMPLOYEE 테이블에서 부서별로 급여가 300만원 이상인 직원의 평균 급여를 조회
SELECT DEPT_CODE AS "부서 코드",
       AVG(NVL(SALARY, 0)) AS "평균 급여"
FROM EMPLOYEE
WHERE SALARY >= 3000000         -- '"평균 급여"가 300만원 이상인 "부서"'가 아니라 '부서별로 급여가 300만원 이상인 "직원"의 평균 급여' > WHERE절로 사용 가능
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;
            -- 위 아래 비교!!!
-- EMPLOYEE 테이블에서 부서별 평균 급여가 300만원 이상인 부서의 부서 코드, 평균 급여를 조회
SELECT DEPT_CODE AS "부서 코드",
       AVG(NVL(SALARY, 0)) AS "평균 급여"
FROM EMPLOYEE
-- WHERE AVG(SALARY) >= 3000000 -- 에러 발생. GROUP BY 절이 WHERE 절보다 나중에 수행돼서 그룹에 대한 조건을 WHERE에 걸 수 없음. 그래서 HAVING절에 그룹에 대한 조건 적어줌
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

SELECT DEPT_CODE AS "부서 코드",
       FLOOR(AVG(NVL(SALARY, 0))) AS "평균 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE                      -- 부서별로 묶음
HAVING FLOOR(AVG(SALARY)) >= 3000000           -- 묶은 부서별로 급여의 평균이 300이 넘는 묶음이 있나 봄
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급별 총 급여의 합이 10,000,000 이상인 직급만 조회
SELECT JOB_CODE AS "직급 코드",
       SUM(SALARY)AS "총 급여의 합"
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 부서별 보너스를 받는 사원이 '없는' 부서만 조회       -- ????????????????????????????????????????????????또 풀어보기
SELECT DEPT_CODE AS "부서 코드",
       COUNT(BONUS) AS "보너스를 받는 사원의 수"        -- 보너스를 받는 사원의 수 왜냐하면 그룹 함수는 NULL값은 빠지기 때문에 보너스 받는 사원의 수가 없으면 0으로 나옴
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0     -- COUNT(BONUS)가 그룹함수인데 그룹함수에 조건 거는 건 WHERE에서 사용 못 해서 HAVING 써줌
ORDER BY DEPT_CODE;



/*                                      221216 3교시 ORACLE 04_GROUP_BY HAVING
    <집계 함수>
    
    1) ROLLUP([,...])
        - 그룹 별 산출한 결과 값의 집계를 계산하는 함수
        - 첫 번째 매개값으로만 중간 집계를 내는 함수
        
    2) CUBE([,...])
        - 그룹 별 산출한 결과 값의 집계를 계산하는 함수
        - 매개값으로 전달된 모든 컬럼으로 중간 집계를 내는 함수       
*/
-- EMPLOYEE 테이블에서 직급별 급여의 합계를 조회
SELECT JOB_CODE AS "직급 코드",
       SUM(SALARY) AS "직급별 급여의 합계"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

SELECT JOB_CODE AS "직급 코드",
       SUM(SALARY) AS "직급별 급여의 합계"
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)       -- 8행 NULL 출력 >     ROLLUP : 마지막 행에 전체 총 급여의 합계까지 조회
ORDER BY JOB_CODE;

SELECT JOB_CODE AS "직급 코드",
       SUM(SALARY) AS "직급별 급여의 합계"
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)         -- 8행 NULL 출력 >     CUBE : 마지막 행에 전체 총 급여의 합계까지 조회  하나의 컬럼만 조회할 때에는 ROLLUP COBE  차이가 없음
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 직급 코드와 부서 코드가 같은 사원들의 급여의 합계를 조회
SELECT JOB_CODE AS "직급 코드", DEPT_CODE AS "부서 코드",
       SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE, DEPT_CODE
ORDER BY JOB_CODE, DEPT_CODE;

SELECT JOB_CODE AS "직급 코드", DEPT_CODE AS "부서 코드",
       SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE, DEPT_CODE)        -- ROLL UP  : 첫 번째 매개값으로만 중간 집계를 내는 함수
ORDER BY JOB_CODE, DEPT_CODE;

SELECT JOB_CODE AS "직급 코드", DEPT_CODE AS "부서 코드",
       SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE, DEPT_CODE)          -- CUBE       : 매개값으로 전달된 모든 컬럼으로 중간 집계를 내는 함수
ORDER BY JOB_CODE, DEPT_CODE;


