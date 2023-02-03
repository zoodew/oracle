/*                                      221216 3교시 ORACLE 04_GROUP_BY HAVING
    <집합 연산자>
        - 여러 개의 쿼리문을 하나의 쿼리문으로 만드는 연산자.
        - 여러 개의 쿼리문에서 조회(SELECT)하려고 하는 컬럼의 개수와 이름이 같아야 집합 연산자를 사용할 수 있다.
        - WHERE 에서 하나로 묶을 수 있는 경우가 많음 그럴 땐 최대한 하나로 간단하게 묶어서 쓰기 어쩔 수 없는 상황에서 쓰기
        
    1) UNION(합집합)
        - 여러 개의 쿼리 결과를 합치는 연산자
        - 중복되는 행은 제거된다.
        - WHERE OR 연산자로 처리 가능
*/
-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원들의 사번, 직원명, 부서 코드, 급여를 조회    ( 총 6 명 조회)
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- EMPLOYEE 테이블에서 급여가 300 초과인 사원들의 사번, 직원명, 부서 코드, 급여를 조회   ( 총 8 명 조회)  
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 1) UNION     위의 두 쿼리문 유니온으로 합체
-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 사번, 직원명, 부서 코드, 급여를 조회.
SELECT EMP_ID,          -- ----------여기서부터
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'  -- 하나의 쿼리이기 때문에 세미콜론 지워줌

UNION               -- UNION으로 합침

SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- -----------여기까지가 하나의 쿼리 
                                                -- ? 위 쿼리 6 명 아래 쿼리 8명인데 왜 12 명이지? 값이 똑같은 중복되는 행은 지워줌!
-- 참고) 위 쿼리문 대신에 WHERE 절에 OR 연산자를 사용해 처리할 수 있음
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;     -- 위의 UNION 이랑 같은 값 나옴 가능하면 WHERE절에 OR 연산자 써서 처리



/*                                      221216 4교시 ORACLE 04_GROUP_BY HAVING
    <집합 연산자>
        - 여러 개의 쿼리문을 하나의 쿼리문으로 만드는 연산자.
        - 여러 개의 쿼리문에서 조회(SELECT)하려고 하는 컬럼의 개수와 이름이 같아야 집합 연산자를 사용할 수 있다.
        - WHERE 에서 하나로 묶을 수 있는 경우가 많음 그럴 땐 최대한 하나로 간단하게 묶어서 쓰기 어쩔 수 없는 상황에서 쓰기
        
    2) UNION ALL(합집합)
        - 중복 행 제거를 하지 않는다.
*/
-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 사번, 직원명, 부서 코드, 급여를 조회.
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL               -- UNION ALL로 합침                             -- UNION ALL : 중복제거 안 함  cf) UNION : 중복 제거 함

SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;



/*                                      221216 4교시 ORACLE 04_GROUP_BY HAVING
    <집합 연산자>
        - 여러 개의 쿼리문을 하나의 쿼리문으로 만드는 연산자.
        - 여러 개의 쿼리문에서 조회(SELECT)하려고 하는 컬럼의 개수와 이름이 같아야 집합 연산자를 사용할 수 있다.
        - WHERE 에서 하나로 묶을 수 있는 경우가 많음 그럴 땐 최대한 하나로 간단하게 묶어서 쓰기 어쩔 수 없는 상황에서 쓰기
        
    3) INTERSECT(교집합)
        - WHERE AND 연산자로 처리 가능
*/
-- EMPLOYEE 테이블에서 부서 코드가 D5이면서 급여가 300만원 초과인 사원들의 사번, 직원명, 부서 코드, 급여를 조회.
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT                                       -- INTERSECT로 교집합

SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 참고) 위 쿼리문 대신에 WHERE 절에 AND 연산자를 사용해 처리할 수 있음
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;



/*                                      221216 4교시 ORACLE 04_GROUP_BY HAVING
    <집합 연산자>
        - 여러 개의 쿼리문을 하나의 쿼리문으로 만드는 연산자.
        - 여러 개의 쿼리문에서 조회(SELECT)하려고 하는 컬럼의 개수와 이름이 같아야 집합 연산자를 사용할 수 있다.
        - WHERE 에서 하나로 묶을 수 있는 경우가 많음 그럴 땐 최대한 하나로 간단하게 묶어서 쓰기 어쩔 수 없는 상황에서 쓰기
        
    4) MINUS
        - 첫 번째 쿼리문에서 두 번째 쿼리문과 겹치는 부분을 제외함
        - WHERE AND 연산자로 처리 가능
*/
-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원들 중에서 급여가 300만원 초과인 사원들은 제외해서 조회
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS                                       

SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 참고) 위 쿼리문 대신에 WHERE 절에 AND 연산자를 사용해 처리할 수 있음
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;



/*                                      221216 4교시 ORACLE 04_GROUP_BY HAVING
    <집합 연산자>
        - 여러 개의 쿼리문을 하나의 쿼리문으로 만드는 연산자.
        - 여러 개의 쿼리문에서 조회(SELECT)하려고 하는 컬럼의 개수와 이름이 같아야 집합 연산자를 사용할 수 있다.
        - WHERE 에서 하나로 묶을 수 있는 경우가 많음 그럴 땐 최대한 하나로 간단하게 묶어서 쓰기 어쩔 수 없는 상황에서 쓰기
        
    5) GROUPING SETS
        - 그룹 별로 처리된 여러 개의 쿼리 결과를 한 번에 합친 결과로 추출한다.
        
*/
-- 부서별 사원수
SELECT DEPT_CODE AS "부서코드",
       COUNT(*) AS "사원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 직급별 사원수
SELECT JOB_CODE AS "직급코드",
       COUNT(*) AS "사원수"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 부서별, 직급별 사원수
--  1) UNION ALL 연산자를 사용하는 방법       -- UNION ALL은 완벽하게 정리되지 못함 BUT 지금까지 배운거로는 이정도 정리가 최선
SELECT DEPT_CODE AS "부서코드",
       COUNT(*) AS "사원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE

UNION ALL

SELECT JOB_CODE AS "직급코드",
       COUNT(*) AS "사원수"
FROM EMPLOYEE
GROUP BY JOB_CODE;

--  2) GROUPING SETS을 통해 위 두 쿼리를 하나의 쿼리로 합치기
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY GROUPING SETS(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE;
            -- 출력의 14행 > DEPT_CODE의 부서가 없는 애들의 사원수인데 정렬하다보니 맨 밑으로 가버림
 
 
-- EMPLOYEE 테이블에서 부서 코드, 직급 코드, 사수 사번이 동일한 사원의 급여 평균 조회

-- 밑의 세 가지 따로 구한 뒤 후에 GROUPING SETS 써서 합치기
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY,0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID
ORDER BY DEPT_CODE, JOB_CODE, MANAGER_ID;

-- EMPLOYEE 테이블에서 부서 코드, 사수 사번이 동일한 사원의 급여 평균 조회
SELECT DEPT_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY,0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE, MANAGER_ID
ORDER BY DEPT_CODE, MANAGER_ID;

-- EMPLOYEE 테이블에서 직급 코드 , 사수 사번이 동일한 사원의 급여 평균 조회
SELECT JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY,0)))
FROM EMPLOYEE
GROUP BY JOB_CODE, MANAGER_ID
ORDER BY JOB_CODE, MANAGER_ID;

-- 위의 쿼리를 각각 실행해서 합친 것과 동일한 결과를 갖는 쿼리문
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY,0)))
FROM EMPLOYEE
GROUP BY GROUPING SETS((DEPT_CODE, JOB_CODE, MANAGER_ID), (DEPT_CODE, MANAGER_ID), (JOB_CODE, MANAGER_ID));


