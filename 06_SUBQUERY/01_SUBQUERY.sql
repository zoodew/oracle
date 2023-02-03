
/*                                      221219 7교시 ORACLE 06_SUBQUERY
    <SUBQUERY>
    - 하나의 SQL 문 안에 포함된 또 다른 SQL 문을 뜻한다.
    - 메인 쿼리 수행 전에 서브 쿼리가 먼저 수행된다.
    - 서브 쿼리는 반드시 괄호 () 안에 넣어서 표현해야 한다.
*/
-- 서브 쿼리 예시
    -- 1. 노옹철 사원과 같은 부서원들을 조회
        --  1) 노옹철 사원의 부서 코드 조회
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철';
            -- > 부서코드는 D9
        
        --  2) 부서 코드가 노옹철 사원의 부서 코드와 동일한 사원들을 조회
    SELECT EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D9';
    
    -- 위 두 단계를 하나의 쿼리로 작성  >> 서브 쿼리!  
    SELECT EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = (
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '노옹철'
    );
    
    -- 2. 전 직원의 평균 급여보다 더 많은 급여를 받고 있는 직원들의 사번, 직원명, 직급 코드, 급여를 조회
        -- 1) 전 직원의 평균 급여 조회
    SELECT AVG(NVL(SALARY, 0))
    FROM EMPLOYEE;
    
        -- 2) 전 직원 평균 급여보다 더 많은 급여를 받고 있는 직원들 조회
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE SALARY >= 3047662.60869565217391304347826086956522;
    
    -- 위 두 단계를 하나의 쿼리로 작성   >> 서브 쿼리!
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE SALARY >= (
        SELECT AVG(NVL(SALARY, 0))
        FROM EMPLOYEE
    );
          
          
          
/*                                      221219 8교시 ORACLE 06_SUBQUERY
    <서브 쿼리 분류>
    - 단일 행 서브 쿼리
    - 다중 행 서브 쿼리
    - 다중 열 서브 쿼리
    - 다중 행 다중 열 서브 쿼리
    
    1. 단일 행 서브 쿼리
        - 서브 쿼리의 조회 결과 값의 개수가 한 개일 때를 의미 (단일 행 단일 열)
*/          
-- 전체 사원들 중 최저 급여를 받는 직원의 사번, 이름, 직급 코드, 급여, 입사일 조회
    -- 1) 최저 급여 조회
    SELECT MIN(SALARY)
    FROM EMPLOYEE;

    -- 2) 1)번쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성    
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
    FROM EMPLOYEE
    WHERE SALARY = (
        SELECT MIN(SALARY)
        FROM EMPLOYEE
    );

-- 노옹철 사원의 급여보다 더 많이 받는 사원의 사번, 직원명, 부서명, 직급 코드, 급여 조회
    -- 1) 노옹철 사원의 급여 조회
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철';
    
    -- 2) 1)번쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성
        -- ANSI 표준 구문
        SELECT E.EMP_ID,
               E.EMP_NAME,
               D.DEPT_TITLE,
               E.JOB_CODE,
               E.SALARY
        FROM EMPLOYEE E
        INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
        WHERE E.SALARY > (SELECT SALARY
                          FROM EMPLOYEE
                          WHERE EMP_NAME = '노옹철'
        );

        -- 오라클 구문
        SELECT E.EMP_ID,
               E.EMP_NAME,
               D.DEPT_TITLE,
               E.JOB_CODE,
               E.SALARY
        FROM EMPLOYEE E, DEPARTMENT D
        WHERE E.DEPT_CODE = D.DEPT_ID
          AND E.SALARY > (SELECT SALARY
                          FROM EMPLOYEE
                          WHERE EMP_NAME = '노옹철'
        );

-- 부서별 급여의 합이 가장 큰 부서의 부서 코드, 급여의 합을 조회
    -- 급여의 합이 가장 큰 부서 구하기                                               -- 다시풀어보기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- 1) 부서별 급여의 합                                                     
    SELECT SUM(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
    -- 2) 부서별 급여의 합 중 가장 큰 값
    SELECT DEPT_CODE, MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;                 -- 에러 남 MAX를 씌우면 하나의 행인 그룹 함수로 나옴, DPET_CODE는 그루핑이 되어서 7개의 행으로 조회 행 수가 달라서 에러가 발생
            -- 해결 방안    > 서브 쿼리 사용

    -- 3) 1)번쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성
    -- 서브 쿼리는 WHERE 절 뿐만 아니라, SELECT / FROM / HAVING 절 에서 사용이 가능하다.
    SELECT DEPT_CODE, SUM(SALARY)
    FROM EMPLOYEE                                                          
    GROUP BY DEPT_CODE
    HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                          FROM EMPLOYEE
                          GROUP BY DEPT_CODE
    ) 
    ORDER BY DEPT_CODE;    

-- 전지연 사원이 속해있는 부서원들의 사번, 직원명, 전화번호, 직급명, 부서명, 입사 조회(단, 전지연 사원은 제외)
    -- 1) 전지연 사원이 속한 부서
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '전지연';
    
    -- 2) 1)번쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성
-- ANSI 표준 구문
    SELECT E.EMP_ID AS "사번",
           E.EMP_NAME AS "직원명",
           E.PHONE AS "전화번호",
           J.JOB_NAME AS "직급명",
           D.DEPT_TITLE AS "부서명",
           E.HIRE_DATE AS "입사일"
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
    WHERE DEPT_CODE = (SELECT DEPT_CODE
                       FROM EMPLOYEE
                       WHERE EMP_NAME = '전지연'
    ) AND E.EMP_NAME != '전지연';
    

-- ORACLE 구문
    SELECT E.EMP_ID AS "사번",
           E.EMP_NAME AS "직원명",
           E.PHONE AS "전화번호",
           J.JOB_NAME AS "직급명",
           D.DEPT_TITLE AS "부서명",
           E.HIRE_DATE AS "입사일"
    FROM EMPLOYEE E, DEPARTMENT D, JOB J
    WHERE E.DEPT_CODE = D.DEPT_ID
      AND E.JOB_CODE = J.JOB_CODE
      AND DEPT_CODE = (SELECT DEPT_CODE
                       FROM EMPLOYEE
                       WHERE EMP_NAME = '전지연'
    ) AND E.EMP_NAME != '전지연';
    


/*                                      221220 1교시 ORACLE 06_SUBQUERY
    <서브 쿼리>
    
    2. 다중 행 서브 쿼리
        - 서브 쿼리의 조회 결과 값의 개수가 여러 행일 때를 의미 (다중 행 단일 열)
        
        값이 하나가 아니라 여러 개라서 단순하게 = 식만으로 사용하지 못 함      ex) 1 = (1, 3, 4, 7) > 하나하나 비교가 안 됨 / 비교할 값이 하나여야 "=" 연산자 사용 가능
        값의 목록을 받는 연산자들을 사용해야 함
        - IN / NOT IN ( ... ) > 여러 값을 비교하는 연산자
                                 > 여러 값 중에 하나라도 일치하면 TRUE 일치하는 값이 없으면 FALSE
        - ANY, ALL
            ANY(값, 값, ...) : 여러 개의 값들 중에서 조건을 한 개라도 만족하면 TRUE 리턴
                                    cf)IN 연산자 -> ANY는 비교 연산자를 함께 사용함.
                                        SALARY = ANY( ... ) : IN과 같은 결과
                                        SALARY != ANY( ... ) : NOT IN과 같은 결과?????????????????????????????????????????????????????????????????????????????????
                                        SALARY > ANY( ... ) : 여러 값 중 최소값보다 크면 TRUE 리턴. 조건을 하나라도 만족하면 됨
                                        SALARY < ANY( ... ) : 여러 값 중 최대값보다 작으면 TRUE 리턴. 조건을 하나라도 만족하면 됨
            ALL(값, 값, ...) : 여러 개의 값들 중에서 조건을 모두 만족하면 TRUE 리턴                            
                                    cf)IN 연산자 ->  ALL은 비교 연산자를 함께 사용함.
                                        SALARY = ALL( ... ) : 불가! 하나의 SALARY값이 여러 개의 ALL값과 일치할 수 없으니까
                                        SALARY != ALL( ... ) : 모든 값들과 다르면 TRUE 리턴.
                                        SALARY > ALL( ...) : 여러 값 중 최대값보다 크면 TRUE 리턴.
                                        SALARY < ALL( ...) : 여러 값 중 최소값보다 작으면 TRUE 리턴.
                                                                
*/
-- 각 부서별 최고 급여를 받는 직원의 이름, 직급 코드, 부서 코드, 급여 조회
    -- 1)각 부서별 최고 급여 조회
    SELECT MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY DEPT_CODE;
    
    -- 2) 1)급여를 받는 사원들 조회
    SELECT EMP_NAME,
           JOB_CODE,
           DEPT_CODE,
           SALARY
    FROM EMPLOYEE
    WHERE SALARY IN (3660000, 2490000, 3760000, 3900000, 2550000, 800000, 2890000)
    ORDER BY DEPT_CODE;
    
    -- 3) 1),2) 쿼리문을 합쳐서 하나의 쿼리문으로 작성
    SELECT EMP_NAME,
           JOB_CODE,
           DEPT_CODE,
           SALARY
    FROM EMPLOYEE
    WHERE SALARY IN (SELECT MAX(SALARY)         -- 서브쿼리가 먼저 수행 > 여러 행의 결과값이 나옴 그래서 2번 쿼리처럼 수행이 됨            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    FROM EMPLOYEE               -- = 연산자 불가능 > 왜? 여러 값(오른쪽)과 하나의 값(왼쪽)을 "="로 비교할 수 없음 이럴 때 사용하는 게 "IN연산자"
                    GROUP BY DEPT_CODE
    )
    ORDER BY DEPT_CODE;

    
-- 직원에 대해 사번, 이름, 부서 코드, 구분(사수/사원) 조회
    -- 1) 사수에 해당하는 사번 조회
    SELECT DISTINCT MANAGER_ID      -- 중복제거 DISTINCT
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL;
    
    -- 2) 사번이 위와 같은 직원들의 사번, 이름, 부서 코드, 구분(사수) 조회
    SELECT EMP_ID AS "사번",
           EMP_NAME AS "이름",
           DEPT_CODE AS "부서 코드",
           '사수' AS "구분"
    FROM EMPLOYEE
    WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID                             --  IN!!!!!!!!!!!!!!!!!!비교하려는 값이 여러행이니까 "=" 아니고 IN 으로!!!!!!!!!!!!!!!!!!!
                     FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL
    );
    -- 일반 사원에 해당하는 정보 조회
    SELECT EMP_ID AS "사번",
           EMP_NAME AS "이름",
           DEPT_CODE AS "부서 코드",
           '사원' AS "구분"
    FROM EMPLOYEE
    WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID         -- 2)에서 IN을 NOT IN으로 바꾸기
                     FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL
    );
    
    -- 3) 위의 결과들을 하나의 결과로 확인 (UNION)
    SELECT EMP_ID AS "사번",
           EMP_NAME AS "이름",
           DEPT_CODE AS "부서 코드",
           '사수' AS "구분"
    FROM EMPLOYEE
    WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                     FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL
    )
    
    UNION
    
    SELECT EMP_ID AS "사번",
           EMP_NAME AS "이름",
           DEPT_CODE AS "부서 코드",
           '사원' AS "구분"
    FROM EMPLOYEE
    WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                     FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL
    );
    
        -- BUT, UNION은 사용을 최대한 지양한다. > 다른 방법 구하기 > 4)
    
    -- 4) SELECT 절에 서브 쿼리를 사용하는 방법                                              221220 2교시
    SELECT EMP_ID AS "사번",
           EMP_NAME AS "이름",
           DEPT_CODE AS "부서 코드",
           CASE WHEN EMP_ID IN (201, 204, 100, 200, 211, 207, 214) THEN '사수'
                ELSE '사원'
           END AS "구분"
    FROM EMPLOYEE;
            -- > CASE 안의 IN을 서브 쿼리로 변경
    SELECT EMP_ID AS "사번",
           EMP_NAME AS "이름",
           DEPT_CODE AS "부서 코드",
           CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
                                FROM EMPLOYEE
                                WHERE MANAGER_ID IS NOT NULL
                )
                THEN '사수'
                ELSE '사원'
           END AS "구분"
    FROM EMPLOYEE;
    -- SELECT 절에서도 서브 쿼리 사용 가능하다.
    
    
-- ANY / ALL 연산자 사용
-- 대리 직급임에도 과장 직급들의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급, 급여 조회
    -- 1) 과장 직급들의 급여 조회
    SELECT SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J5';
    
    -- 2) 지급이 대리인 직원들 중에서 위의 값의 목록 중에 하나라도 큰 경우
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J6'
      AND SALARY > ANY(2200000, 2500000, 3760000
    );
                        -- SALARY > 220만 OR SALARY > 250만 OR SALARY 376만
                        
    -- 3) 위의 쿼리문을 합쳐서 하나의 쿼리문으로 작성
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J6'
      AND SALARY > ANY(SELECT SALARY
                       FROM EMPLOYEE
                       WHERE JOB_CODE = 'J5'
    );

-- 과장 직급임에도 차장 직급의 최대 급여보다 더 많이 받는 직원들의 사번, 이름, 직급, 급여 조회
    -- 1) 차장 직급들의 급여 조회
    SELECT SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J4';
        -- 2800000, 1550000, 2490000, 2480000
    
    -- 최대 급여보다 더 많이 받는 > 모든 차장 직급 급여들 보다 크다 > ALL연산자 사용
    -- 2) 과장 직급임에도 차장 직급의 최대 급여보다 더 많이 받는 직원 조회
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J5' AND SALARY > ALL(2800000, 1550000, 2490000, 2480000);
            -- SALARY > 280만 AND SALARY > 155만 AND SALARY > 249만 AND SALARY > 248만
            
    -- 3) 위의 쿼리문을 합쳐서 하나의 쿼리문으로 작성
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J5' AND SALARY > ALL(SELECT SALARY
                                           FROM EMPLOYEE
                                           WHERE JOB_CODE = 'J4');
    



/*                                      221220 3교시 ORACLE 06_SUBQUERY
    <서브 쿼리>
    
    3. 다중 열 서브 쿼리
        - 서브 쿼리의 조회 결과 값은 한 행이지만 컬럼의 수가 여러 개일 때를 의미 (단일 행 다중 열)
*/
-- 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당하는 사원들을 조회
    -- 1) 하이유 사원의 부서 코드, 직급 코드 조회
    SELECT DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '하이유';
                    -- D5 ,J5
    -- 2) 부서 코드가 D5이면서 직급 코드가 J5인 사원들 조회
    SELECT EMP_NAME, DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5';
    
            -- 2)- 1 * 단일 행 서브 쿼리를 사용하는 방법
            SELECT EMP_NAME, DEPT_CODE, JOB_CODE
            FROM EMPLOYEE
            WHERE DEPT_CODE = (SELECT DEPT_CODE
                              FROM EMPLOYEE
                              WHERE EMP_NAME = '하이유'
                              )
            AND JOB_CODE = (SELECT JOB_CODE
                            FROM EMPLOYEE
                            WHERE EMP_NAME = '하이유'
            );    

-- 2)-2 다중 열 서브 쿼리를 사용하는 방법(이 챕터의 MAIN 방법)
    SELECT EMP_NAME, DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE (DEPT_CODE , JOB_CODE) = (('D5', 'J5'));  -- 괄호를 왜 두 번 치나? IN연산자로 생각해보기! IN(D5, D6)는 D5, D6를 각각 봐서 비교한다는 뜻
                -- 쌍비교 방식                        -- =도 똑같음(=는 1대1 비교 연산자!!!) (D5, D6)는 세트가 아니라서 세트로 보겠다고 () 한번 괄호쳐주고 그 밖에 또 비교를 위한 ()쳐줌
    
    SELECT EMP_NAME, DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE (DEPT_CODE , JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                    FROM EMPLOYEE
                                    WHERE EMP_NAME = '하이유'
    );

-- 박나라 사원과 직급 코드가 일치하면서 같은 사수를 가지고 있는 사원의 사번, 이름, 직급 코드, 사수 사번 조회
    -- 박나라 사원의 직급 코드와 사수 사번 조회
    SELECT JOB_CODE, MANAGER_ID
    FROM EMPLOYEE
    WHERE EMP_NAME = '박나라';
    -- 박나라 사원과 같은 직급 코드와 사수를 갖는 사원의 사번, 이름, 직급 코드, 사수 사번 조회
    SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
    FROM EMPLOYEE
    WHERE (JOB_CODE, MANAGER_ID) IN (SELECT JOB_CODE, MANAGER_ID
                                    FROM EMPLOYEE
                                    WHERE EMP_NAME = '박나라'
    );



/*                                      221220 3교시 ORACLE 06_SUBQUERY
    <서브 쿼리>
    
    4. 다중 행 다중 열 서브 쿼리
        - 서브 쿼리의 조회 결과 값이 여러 행, 여러 열일 때를 의미 (다중 행 다중 열)
*/
-- 각 직급별로 최소 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여 조회
    -- 1) 각 직급별 최소 급여 조회
    SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE;
    
    -- 2) 각 직급별로 최소 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여 조회
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J2' AND SALARY = '3700000'
       OR JOB_CODE = 'J7' AND SALARY = '1380000'
       OR JOB_CODE = 'J4' AND SALARY = '1550000';
        -- ... 다 이렇게 적어주면 나옴 그렇지만 너무 많음
    
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE (JOB_CODE, SALARY) IN (('J2','3700000'), ('J7', '1380000'), ('J4', '1550000'));
        -- 쌍비교 연산자 방식
                    -- 둘 다 식이 너무 길어짐 서브쿼리 사용하기!              

-- 2)-1 다중행 다중열 서브쿼리 사용해서 조회                                     2212120 4교시
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                 FROM EMPLOYEE
                                 GROUP BY JOB_CODE
    )
    ORDER BY JOB_CODE;


-- 각 부서별 최소 급여를 받는 사원들의 사번, 이름, 부서 코드, 급여 조회 (단, 부서가 없는 사원들은 부서 컬럼에 '부서 없음'이라고 뜨도록 만들기)
    -- 1) 각 부서별 최소 급여 조회
    SELECT NVL(DEPT_CODE, '부서 없음'), MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
    SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE, '부서 없음'), SALARY
    FROM EMPLOYEE       -- r 왼쪽에 NVL 안 써주면 IN 양쪽 값 비교 할 때 NULL값인 경우가 다르게 비교가 됨 왼 NULL 오 부서없음 > 그래서 NULL 컬럼이 조회되지 않음 제대로 비교해주기위해 붙여줌!!!!!!!!!!!!!!!!
    WHERE (NVL(DEPT_CODE, '부서 없음'), SALARY) IN (SELECT NVL(DEPT_CODE, '부서 없음'), MIN(SALARY)
                                  FROM EMPLOYEE
                                  GROUP BY DEPT_CODE
    )
    ORDER BY DEPT_CODE;



/*                                      221220 4교시 ORACLE 06_SUBQUERY
    <서브 쿼리 활용>
    
    <인라인 뷰 INLINE VIEW>
    
    - 메인 쿼리의 FROM 절에 서브 쿼리를 사용하는 것
    - 서브 쿼리를 수행한 결과를 테이블 대신 사용
    
    ROWNUM
        - 오라클에서 제공하는 컬럼, 조회된 순서대로 1부터 순번을 부여하는 컬럼
        - SELECT 실행시 수행됨
        
    WITH
        - 서브 쿼리에 이름을 붙여주고 인라인 뷰 대신 사용하는 것
        - 동일한 서브 쿼리가 여러 번 사용될 경우 중복 작성을 피할 수 있고 실행 속도도 빨라진다는 장점이 있음
*/
-- 전 직원 중 급여가 가장 높은 상위 5명의 순위, 이름, 급여 조회
    -- 1) 전 직원의 이름과 급여 조회
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE;
    
-- ROWNUM    >  오라클에서 제공하는 컬럼, 조회된 순서대로 1부터 순번을 부여하는 컬럼
    -- 2)-1 SALARY로 내림차순 정렬하고 WHERE에 ROWNUM <= 5로 출력하려고 설정 
        SELECT ROWNUM, EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC;  
            -- > ROWNUM 순서가 SALARY 내림차순대로 설정되지 않음
            --      왜? 이미 ROWNUM 순번이 정해진 다음에 정렬이 됨
            --          수행 순서 FROM > SELECT(ROWNUM이 여기서 정해짐) > ORDER BY
-- INLINE VIEW 활용법
    -- 2)-2 2)-1 해결 (INLINE VIEW 활용)
    SELECT *
    FROM (
        SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
    );

    SELECT ROWNUM AS "순위",
           EMP_NAME AS "이름",
           SALARY AS "급여"
    FROM (
        SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC
    )
    WHERE ROWNUM <= 5;


-- 부서별 평균 급여가 높은 세 개 부서의 부서 코드, 평균 급여 조회                            221220 4 OR 5 교시
   -- 1) 인라인 뷰를 사용하는 방법
        -- 부서별 평균 급여가 높은 순서
        SELECT NVL(DEPT_CODE, '부서없음'), AVG(NVL(SALARY,0))
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(NVL(SALARY,0)) DESC
        ;
    
        SELECT ROWNUM,
               NVL(DEPT_CODE, '부서없음'),
               AVG(NVL(SALARY,0))
        FROM (SELECT NVL(DEPT_CODE, '부서없음') AS "부서코드",
                     AVG(NVL(SALARY,0)) AS "평균급여"
              FROM EMPLOYEE
              GROUP BY DEPT_CODE
        ORDER BY  AVG(NVL(SALARY,0)) DESC)
        WHERE ROWNUM <= 3;
            -- 에러 발생 왜??? 
            -- 별칭 안 주면 SELECT에 호출된 컬럼명이 함수 호출 구문으로 되어있어서 에러남. 컬럼명이 아니라 함수호출구문으로 인식을 하기 때문에
            /*위의 '부서별 평균 급여가 높은 순서(1)' 여기도 SELECT에 식 들어있잖아요!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                     >> (1)식은 EMPLOYEE를 테이블로 사용함 EMPLOYEE테이블에는 DEPT_CODE도 SALARY도 다 컬럼으로 들어있음
                     그래서 SELECT에 적은 대로 식을 넣어도 조회가 잘 되는데
                     아래 식은 FROM절에 서브쿼리를 이용하여서 그걸 테이블로 사용중 그 테이블 안에는 부서코드와 평균급여가 컬럼으로 들어있지 DEPT_CODE, SALARY는 포함되어있지않음
                     그래서 함수호출 구문으로 인식을 하고 에러가 발생하게 됨!!!!!
            */
            -- 그래서 컬렴명에 별칭을 줘서 그 별칭으로 컬럼명 넣어줌 아래 식 참고
            
        SELECT ROWNUM AS "순위",
               "부서코드",
               FLOOR("평균급여")
        FROM (SELECT NVL(DEPT_CODE, '부서없음') AS "부서코드",
                     AVG(NVL(SALARY,0)) AS "평균급여"
              FROM EMPLOYEE
              GROUP BY DEPT_CODE
              ORDER BY  AVG(NVL(SALARY,0)) DESC)
        WHERE ROWNUM <= 3;
   
   
    -- 2) WITH를 사용하는 방법
    -- 테이블에 별칭 붙여주는 것
        WITH TOPN_SAL AS (
            SELECT NVL(DEPT_CODE, '부서없음') AS "부서코드",
                   AVG(NVL(SALARY,0)) AS "평균급여"
            FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY  AVG(NVL(SALARY,0)) DESC
        )
    
        SELECT ROWNUM, "부서코드", FLOOR("평균급여")
        FROM TOPN_SAL
        WHERE ROWNUM <= 3;



/*                                      221220 5교시 ORACLE 06_SUBQUERY
    <RANK 함수>
    
    - 데이터의 순위를 알아내는 함수
    
    RANK() OVER ( 순위를 나열할 기준 )      : 동일한 순위가 있는 경우 다음 등수를 건너뛰고 순위를 계산
    DENSE_RANK() OVER ( 순위를 나열할 기준 ): 동일한 순위가 있어도 다음 등수를 건너뛰지 않고 순위를 계산

*/
-- 사원별 급여가 높은 순서대로 순위 매겨서 순위, 직원명, 급여 조회
-- 공동 19위 두 명 뒤에 오는 순위는 21위
    SELECT RANK() OVER(ORDER BY SALARY DESC),
           EMP_NAME,
           SALARY
    FROM EMPLOYEE;

-- 공동 19위 두 명 뒤에 오는 순위는 20위
    SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC),
           EMP_NAME,
           SALARY
    FROM EMPLOYEE;
    
-- 상위 5명만 조회
    SELECT RANK() OVER(ORDER BY SALARY DESC),
           EMP_NAME,
           SALARY
    FROM EMPLOYEE
    WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;
        -- 에러 발생    >   RANK 함수는 WHERE 절에 사용할 수 없다.
                -- 서브 쿼리로 해결
    SELECT "RANK", EMP_NAME, SALARY
    FROM (
        SELECT RANK() OVER(ORDER BY SALARY DESC) AS "RANK",
               EMP_NAME,
               SALARY
        FROM EMPLOYEE
    )
    WHERE "RANK" <= 5;
    
