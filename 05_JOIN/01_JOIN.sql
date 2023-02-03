
/*                                      221216 5,6교시 ORACLE 05_JOIN
    <JOIN>
    - JOIN은 하나 이상의 테이블에서 데이터를 조회하기 위해 사용되는 구문이다.
    - ​JOIN은 각 테이블 간에 특정 조건을 만족하는 데이터를 합쳐서 하나의 결과(Result Set)로 조회한다.
    
    1) INNER JOIN
    - INNER JOIN은 조인하려는 테이블들에서 공통된 컬럼의 값이 일치되는 행들을 하나의 행으로 연결하여 결과(Result Set)를 조회한다.
    - INNER JOIN은 공통된 컬럼에서 공통된 값이 없거나 컬럼에 값이 없는 행은 조회되지 않는다.       cf) OUTER JOIN
        [표현법]
            1) ORACLE 전용 구문
                SELECT 컬럼, ...
                FROM 테이블1, 테이블2, ...                            -> 조회하고자 하는 테이블 다 FROM에 나열
                WHERE 테이블1.컬럼명 = 테이블2.컬럼명                   -> WHERE에 JOIN 조건 기술
        
            2) ANSI 표준 구문                   > ORACLE 말고도 MySQL이나 기타 다른 곳에서도 사용 가능

                - INNER JOIN ON 사용법
                SELECT 컬럼, ...
                FROM 테이블1                                           -> 기준이 되는 테이블 하나만 작성
                (INNER) JOIN 테이블2 ON (테이블1.컬럼명 = 테이블2.컬럼명)  -> JOIN 같이 조회하고자 하는 테이블 기술 ON 조건 기술

                - INNER JOIN USING 사용법 (단, USING은 각 테이블에서 사용하는 컬럼명이 동일할 때만 사용 가능
                SELECT 컬럼, ...
                FROM 테이블1                                           -> 기준이 되는 테이블 하나만 작성
                (INNER) JOIN 테이블2 USING 겹치는 컬럼명                 -> USING 뒤에는 중복되는 컬럼명만 작성
            
            - 연결하는 각 테이블의 컬럼명이 같다면 컬럼명 앞에 테이블명 적어서(테이블명.컬럼명) 명확하게 해주기
                (컬럼명이 같지 않더라도 명확성을 위해 항상 '테이블명.컬럼명' 형식을 써주는 것이 좋다
    
*/
-- @> 각 사원들의 사번, 직원명, 부서 코드, 부서명 (각 테이블에서 연결할 두 컬럼명이 "다른" 경우)
    SELECT EMP_ID AS "사번", EMP_NAME AS "직원명", DEPT_CODE AS "부서 코드"
    FROM EMPLOYEE;
    
    SELECT DEPT_ID AS "부서 코드", DEPT_TITLE AS "부서명"
    FROM DEPARTMENT;
    
-- &> 각 사원들의 사번, 직원명, 직급 코드, 직급명 (각 테이블에서 연결할 두 컬럼명이 "같은" 경우)
    SELECT EMP_ID AS "사번", EMP_NAME AS"직원명", JOB_CODE AS "직급 코드"
    FROM EMPLOYEE;
    
    SELECT JOB_CODE AS "직급 코드", JOB_NAME AS "직급명"
    FROM JOB;


-- ORACLE 전용 구문으로 작성한 JOIN 쿼리

    -- 1) @> 연결할 두 컬럼명이 "다른" 경우
    -- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 사번, 직원명, 부서 코드, 부서명을 조회
    -- 일치하는 값이 없는 행은 조회에서 제외된다. (ex. DEPT_CODE가 NULL인 사원, DEPT_ID IN(D3, D4, D7)인 사원)
    SELECT EMP_ID,
           EMP_NAME,
           DEPT_ID,                         -- DEPT_CODE를 써도 무방 아무거나 사용해도됨
           DEPT_TITLE
    FROM EMPLOYEE, DEPARTMENT
    WHERE DEPT_CODE = DEPT_ID
    ORDER BY DEPT_CODE;

    -- 2) &> 연결할 두 컬럼명이 "같은" 경우
    -- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 직원명, 직급 코드, 직급명을 조회

    -- 2)-1 오라클 방법. 테이블명을 이용하는 방법
    SELECT EMPLOYEE.EMP_ID,
           EMPLOYEE.EMP_NAME,
           EMPLOYEE/*혹은 JOB*/.JOB_CODE,     -- JOB_CODE가 양 테이블에 다 있어서 모호함 에러 발생 컬럼명 앞에 어느 테이블에서 왔다고 꼭 지정해주기
           JOB.JOB_NAME                      -- 양 테이블에 중복되지 않는 컬럼이라도 꼭 써야하는 건 아니지만 명확하게 해주기 위해 테이블명을 앞에 적어주는게 좋음
    FROM EMPLOYEE, JOB
    WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;     -- JOB_CODE가 양 테이블에 다 있어서 앞에 어느 테이블에서 왔다고 지정해주기

    -- 2)-2 오라클 방법. 테이블의 별칭을 이용하는 방법(가독성 향상 방법)
    SELECT E.EMP_ID,
           E.EMP_NAME,
           E/*혹은 J*/.JOB_CODE,
           J.JOB_NAME  
    FROM EMPLOYEE E, JOB J                      -- FROM 테이블명1 별칭1, 테이블명2 별칭2, ...   별칭 넣어주기 FROM 절에서 테이블 적고 뒤에 별칭
    WHERE E.JOB_CODE = J.JOB_CODE;


-- ANSI 표준 구문으로 작성한 JOIN 쿼리

    -- 1) @> 연결할 두 컬럼명이 "다른" 경우
    -- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 사번, 직원명, 부서 코드, 부서명을 조회
    SELECT EMP_ID,
           EMP_NAME,
           DEPT_CODE,
           DEPT_TITLE
    FROM EMPLOYEE                                       -- FROM 절 기준이 되는 테이블명
    INNER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);     -- (INNER) JOIN 연결할 테이블명 ON 조건 기술

    -- 2) &> 연결할 두 컬럼명이 "같은" 경우
    -- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 직원명, 직급 코드, 직급명을 조회

    -- 2)-1 ANSI 방법. 테이블명을 이용하는 방법
    SELECT EMP_ID,
           EMP_NAME,
           EMPLOYEE/*혹은 JOB*/.JOB_CODE,         -- JOB_CODE가 양 테이블에 다 있어서 모호함 에러 발생 컬럼명 앞에 어느 테이블에서 왔다고 꼭 지정해주기
           JOB.JOB_NAME                          -- 양 테이블에 중복되지 않는 컬럼이라도 꼭 써야하는 건 아니지만 명확하게 해주기 위해 테이블명을 앞에 적어주는게 좋음
    FROM EMPLOYEE
    INNER JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

    -- 2)-2 ANSI 방법. 테이블의 별칭을 이용하는 방법(가독성 향상 방법)
    SELECT E.EMP_ID,
           E.EMP_NAME,
           E/*혹은 J*/.JOB_CODE,
           J.JOB_NAME
    FROM EMPLOYEE E
    INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;

    -- 2)-3 ANSI 방법. USING 구문을 이용하는 방법
    SELECT EMP_ID,
           EMP_NAME,
           JOB_CODE,                                -- USING절을 통해 각 테이블을 가져와서 하나로 인식하기 때문에 굳이 테이블명이나 테이블별칭을 붙이지 않아도 됨
           JOB_NAME
    FROM EMPLOYEE
    INNER JOIN JOB USING (JOB_CODE);                -- USING절에는 중복되는 컬럼명만 적어주면 됨
    
    -- 2)-4 ANSI 방법. NATURAL JOIN 구문을 이용하는 방법
    -- 알아서 자기가 JOIN함 동일한 이름이 있는 경우는 제대로 JOIN이 안 될 수도 있음 2)-4는 참고만 하기!!!
    SELECT EMP_ID,
           EMP_NAME,
           JOB_CODE,
           JOB_NAME
    FROM EMPLOYEE
    NATURAL JOIN JOB;

-------------------------------------------------------------------------------------------------------------------------------------

-- JOIN을 하면서 조건도 거는 쿼리문 작성

-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 직급이 대리인 사원의 사번, 직원명, 직급명, 급여를 조회    
-- 1) 오라클 구문으로 작성
    -- 오라클 구문에서는 JOIN 조건 검색 조건 다 WHERE 절에 작성한다.
    SELECT E.EMP_ID,
           E.EMP_NAME,
           J.JOB_NAME,
           E.SALARY
    FROM EMPLOYEE E, JOB J
    WHERE E.JOB_CODE = J.JOB_CODE AND J.JOB_NAME = '대리';

-- 2) ANSI 표준 구문으로 작성
    -- ANSI 표준 구문에서는 JOIN 조건은 ON 절에 검색 조건은 WHERE 절에 작성한다.
    SELECT E.EMP_ID,
           E.EMP_NAME,
           J.JOB_NAME,
           E.SALARY
    FROM EMPLOYEE E
    INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
    WHERE J.JOB_NAME = '대리';


--------------- 실습 문제 -----------------------------------------------------------------------------------------------

-- 1. DEPARTMENT 테이블과 LOCATION 테이블을 조인하여 부서 코드, 부서명, 지역 코드, 지역명을 조회
-- 오라클
SELECT D.DEPT_ID,
       D.DEPT_TITLE,
       L.LOCAL_CODE,
       L.LOCAL_NAME
FROM DEPARTMENT D, LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;

-- ANSI
SELECT D.DEPT_ID,
       D.DEPT_TITLE,
       D.LOCATION_ID,
       L.LOCAL_NAME
FROM DEPARTMENT D
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- 2. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 보너스를 받는 사원들의 사번, 직원명, 보너스, 부서명을 조회
-- 오라클
SELECT E.EMP_ID,
       E.EMP_NAME,
       E.BONUS,
       D.DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND BONUS IS NOT NULL;

-- ANSI
SELECT E.EMP_ID,
       E.EMP_NAME,
       E.BONUS,
       D.DEPT_TITLE
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE BONUS IS NOT NULL;

SELECT E.EMP_ID,
       E.EMP_NAME,
       E.BONUS,
       D.DEPT_TITLE
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID AND BONUS IS NOT NULL);
        -- ON 절에 검색 조건 넣어도 문제는 없으나 WHERE 절에 검색 조건 적는 게 정석 방법

-- 3. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 인사관리부가 아닌 사원들의 직원명, 부서명, 급여를 조회
-- 오라클
SELECT E.EMP_NAME,
       D.DEPT_TITLE,
       E.SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND DEPT_TITLE != '인사관리부';

-- ANSI
SELECT E.EMP_NAME,
       D.DEPT_TITLE,
       E.SALARY
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE DEPT_TITLE != '인사관리부';

-- 4. EMPLOYEE 테이블과 DEPARTMENT 테이블, JOB 테이블을 조인해서 사번, 직원명, 부서명, 직급명을 조회
-- 오라클
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID AND E.JOB_CODE = J.JOB_CODE;

-- ANSI                                             -- 다중 조인 할 때 INNER JOIN 절을 여러 개 만들어 주기 뒤에서 자세히 학습
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;        -- ON 절에 조건 적을 때 괄호 적든 안 적든 상관 없음


--------------------------------------------------------------------------------------------------------------------------------



/*                                      221219 1교시 ORACLE 05_JOIN
    <JOIN>
    - JOIN은 하나 이상의 테이블에서 데이터를 조회하기 위해 사용되는 구문이다.
    - ​JOIN은 각 테이블 간에 특정 조건을 만족하는 데이터를 합쳐서 하나의 결과(Result Set)로 조회한다.
    
    2) OUTER JOIN
    - OUTER JOIN은 두 테이블 간의 JOIN시, INNER JOIN과 다르게 공통된 컬럼에서 공통된 값이 없거나 컬럼에 값이 없는 행들도 함께 조회하기 위해서 사용되는 구문이다.
        단, 반드시 기준이 되는 테이블(컬럼)을 지정해야 한다. (LEFT, RIGHT, FULL, (+))
*/
    -- OUTER JOIN 과 비교할 INNER JOIN 구문 작성
    -- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 사원들의 사원명, 부서명, 급여, 연봉
    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
    FROM EMPLOYEE E, DEPARTMENT D
    WHERE E.DEPT_CODE = D.DEPT_ID;

    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY *12
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;
    -- INNER JOIN, EMPLOYEE 테이블에서 DEPT_CODE가 NULL인 값들은 조회되지 않음, DEPARTMENT 테이블의 DEPT_TITLE이 D3, D4, D7 조회되지 않음
        -- 부서가 지정되지 않은 사원 두 명에 대한 정보가 조회되지 않는다.
        -- 부서가 지정되어 있어도 DEPARTMENT에 부서에 대한 정보가 없으면 조회되지 않는다.
            --> 이럴 때 사용하는 게 OUTER JOIN


/*                                      221219 1교시 ORACLE 05_JOIN
    <JOIN> - OUTER JOIN
    
    2)-1 LEFT OUTER JOIN
        - 두 테이블 중 왼편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행한다.
*/
-- ANSI 표준 구문
    -- 부서 코드가 없던 사원(이오리, 하동운)의 정보가 출력된다.                cf) INNER JOIN에서는 부서 코드가 NULL인 값 조회되지 않음
    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
    FROM EMPLOYEE E
    LEFT /* OUTER */ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    ORDER BY E.DEPT_CODE DESC;
        -- 테이블 기준. 기준이 되는 테이블은 겹치는 조건에 부합하지 않는 행도 모두 결합되어야 한다.
        -- 즉 EMPLOYEE 테이블의 것은 모두 출력되어야 함

-- 오라클 구문
    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
    FROM EMPLOYEE E, DEPARTMENT D
    WHERE E.DEPT_CODE = D.DEPT_ID(+)
    ORDER BY E.DEPT_CODE DESC;
        -- 컬럼 기준. 값이 없어서 조회 안 되어야 하는데 조회를 하려하는 컬럼이 있는 쪽에다 (+)기호 추가 > 대상 테이블(기준 테이블의 반대) 컬럼에 기호 붙이기
        -- 즉 EMPLOYEE 테이블에서 DEPT_CODE가 존재할 경우 DPET_TITLE 컬럼을 가져오고 매칭되는 데이터가 없으면 NULL 조회



/*                                      221219 1교시 ORACLE 05_JOIN
    <JOIN> - OUTER JOIN
    
    2-2) RIGHT OUTER JOIN
        - 두 테이블 중 오른편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행한다.
*/
-- ANSI 표준 구문
    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY *12
    FROM EMPLOYEE E
    RIGHT /*OUTER*/ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    ORDER BY E.DEPT_CODE DESC;
        -- DEPARTMENT 기준으로 JOIN이라서 DEPARTMENT 테이블의 데이터의 값은 다 출력
        
-- 오라클 구문
    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY *12
    FROM EMPLOYEE E, DEPARTMENT D
    WHERE E.DEPT_CODE(+) = D.DEPT_ID
    ORDER BY E.DEPT_CODE DESC;
        -- 대상 테이블 컬럼에 기호 붙이기 (+)는 한 쪽에만 붙일 수 있다.



/*                                      221219 2교시 ORACLE 05_JOIN
    <JOIN> - OUTER JOIN
    
    2)-3 FULL OUTER JOIN
        - 두 테이블이 가진 모든 행을 조회할 수 있다.(단, 오라클 구문은 지원하지 않는다.)
*/
-- ANSI 표준 구문
    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY *12
    FROM EMPLOYEE E
    FULL OUTER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    ORDER BY E.DEPT_CODE DESC;

-- ORACLE 표준 구문(FULL OUTER JOIN은 오라클 표준 구문 지원 X)
-- 에러 발생 FULL OUTER는 ANSI 표준 구문만 지원한다.
    SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY *12
    FROM EMPLOYEE E , DEPARTMENT D
    WHERE E.DEPT_CODE(+)  = D.DEPT_ID(+)
    ORDER BY E.DEPT_CODE DESC;



/*                                      221219 2교시 ORACLE 05_JOIN
    <JOIN>
    - JOIN은 하나 이상의 테이블에서 데이터를 조회하기 위해 사용되는 구문이다.
    - ​JOIN은 각 테이블 간에 특정 조건을 만족하는 데이터를 합쳐서 하나의 결과(Result Set)로 조회한다.
    
    3) CROSS JOIN
    - 조인되는 모든 테이블의 각 행들이 서로서로 매핑된(곱해진) 데이터가 검색된다.
    - 과부하 위험이 있어서 잘 사용되지 않음
*/
-- ANSI 표준 구문
SELECT E.EMP_NAME, D.DEPT_TITLE
FROM EMPLOYEE E             -- 23행
CROSS JOIN DEPARTMENT D     -- 9행   > 23 * 9 = 207행 조회
ORDER BY E.EMP_NAME;
    -- EMP_NAME 데이터가 DETP_TITLE의 데이터와 하나씩 다 매핑
        -- EMP_NAME의 김해술이 인사관리부부터 해외영업3부까지

-- 오라클 구문
-- WHERE 절을 지우면 됨
SELECT E.EMP_NAME, D.DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
ORDER BY E.EMP_NAME;



/*                                      221219 2교시 ORACLE 05_JOIN
    <JOIN>
    - JOIN은 하나 이상의 테이블에서 데이터를 조회하기 위해 사용되는 구문이다.
    - ​JOIN은 각 테이블 간에 특정 조건을 만족하는 데이터를 합쳐서 하나의 결과(Result Set)로 조회한다.
    
    4) NON EQUAL JOIN
    - 조인 조건에 등호(=)를 사용하지 않는 조인문을 비등가 조인이라고 한다.
    - >, <, >=, <=, BETWEEN, IN,... 등을 사용
    - ANSI 구문으로는 JOIN ON 구문으로만 사용이 가능하다.(USING은 사용 불가)
*/
-- EMPLOYEE 테이블과 SALARY GRADE 테이블을 비등가 조인하여 직원명, 급여, 급여 등급 조회
-- ANSI 표준 구문
SELECT E.EMP_NAME, E.SALARY, S.*
FROM EMPLOYEE E
INNER JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
        -- INNER JOIN이라서 조건에 부합하지 않는 방명수 사원 조회 안 됨  (이거 조회할 때 방명수 사원 급여 138만원을 38만원으로 바꾸고 해보기)
SELECT E.EMP_NAME, E.SALARY, S.*
FROM EMPLOYEE E
LEFT OUTER JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
        -- OUTER JOIN을 써서 방명수까지 조회 가능
        
-- ORACLE구문                     221219 3교시
SELECT E.EMP_NAME, E.SALARY, S.*
FROM EMPLOYEE E, SAL_GRADE S
WHERE E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

SELECT E.EMP_NAME, E.SALARY, S.*
FROM EMPLOYEE E, SAL_GRADE S
-- WHERE E.SALARY (+) BETWEEN S.MIN_SAL AND S.MAX_SAL;
WHERE E.SALARY BETWEEN S.MIN_SAL(+) AND S.MAX_SAL(+);       -- 방명수 사원 정보 조회(방명수 급여 38로 바꾸고 하기 여기까지 그 이후에 138로 바꾸기)



/*                                      221219 3교시 ORACLE 05_JOIN
    <JOIN>
    - JOIN은 하나 이상의 테이블에서 데이터를 조회하기 위해 사용되는 구문이다.
    - ​JOIN은 각 테이블 간에 특정 조건을 만족하는 데이터를 합쳐서 하나의 결과(Result Set)로 조회한다.
    
    5) SELF JOIN
    - 동일한 테이블을 조인하는 경우에 사용한다. 자기 자신과 조인을 맺는다.
*/
-- EMPLOYEE 테이블을 SLEF JOIN 하여 사번, 사원 이름, 부서 코드, 사수 사번, 사수 이름
-- ANSI 표준 구문
    SELECT E.EMP_ID AS "사번",
           E.EMP_NAME AS "사원 이름",
           E.DEPT_CODE AS "부서 코드",
           E.MANAGER_ID AS "사수 사번",
           M.EMP_NAME AS "사수 이름"
    FROM EMPLOYEE E
    INNER JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID); -- 사수 사번을 갖고 있는 행들만 조회됨
            -- 사수 정보가 없는 애들만 조회???????

    SELECT E.EMP_ID AS "사번",
           E.EMP_NAME AS "사원 이름",
           E.DEPT_CODE AS "부서 코드",
           E.MANAGER_ID AS "사수 사번",
           M.EMP_NAME AS "사수 이름"
    FROM EMPLOYEE E
    LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);           
            -- 사수가 없는 사원들까지 조회하려면 LEFT 써줘야함 써 주는 쪽이 다 조회되는 쪽임

-- ORACLE 구문
    SELECT E.EMP_ID AS "사번",
           E.EMP_NAME AS "사원 이름",
           E.DEPT_CODE AS "부서 코드",
           E.MANAGER_ID AS "사수 사번",
           M.EMP_NAME AS "사수 이름"
    FROM EMPLOYEE E, EMPLOYEE M
    WHERE E.MANAGER_ID = M.EMP_ID;
    
    SELECT E.EMP_ID AS "사번",
           E.EMP_NAME AS "사원 이름",
           E.DEPT_CODE AS "부서 코드",
           E.MANAGER_ID AS "사수 사번",
           M.EMP_NAME AS "사수 이름"
    FROM EMPLOYEE E, EMPLOYEE M
    WHERE E.MANAGER_ID = M.EMP_ID(+);



/*                                      221219 3교시 ORACLE 05_JOIN
    <JOIN>
    - JOIN은 하나 이상의 테이블에서 데이터를 조회하기 위해 사용되는 구문이다.
    - ​JOIN은 각 테이블 간에 특정 조건을 만족하는 데이터를 합쳐서 하나의 결과(Result Set)로 조회한다.
    
    6) 다중 JOIN
    - 여러 개의 테이블을 조인하는 경우에 사용한다.
    - ANSI 표준의 구문은 "순서"도 중요하게 봐야 한다!!
*/
-- EMPLOYEE, DEPARTMENT, LOCATION 테이블을 다중 JOIN 하여 사번, 직원명, 부서명, 지역명 조회
    SELECT * FROM EMPLOYEE;
    SELECT * FROM DEPARTMENT;   -- E.DEPT_CODE와 D.DEPT_ID JOIN 가능
    SELECT * FROM LOCATION;     -- D.LOCATION_ID와 L.LOCAL_CODE JOIN 가능

    -- ANSI 표준 구문
    SELECT E.EMP_ID AS "사원명",
           E.EMP_NAME AS "직원명",
           D.DEPT_TITLE AS "부서명",
           L.LOCAL_NAME AS "지역명"
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
        -- ANSI 표준 구문은 다중 JOIN의 순서 신경써야 한다.
    
    SELECT E.EMP_ID AS "사원명",
           E.EMP_NAME AS "직원명",
           D.DEPT_TITLE AS "부서명",
           L.LOCAL_NAME AS "지역명"
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
            -- OUTER JOIN을 할 때는 JOIN 시켜주는 테이블들 '다' OUTER 형식으로 써준다.
            -- 왜냐하면 하나만 OUTER JOIN 해줬을 때 거기까지는 제대로 OUTER JOIN 돼서 NULL값 까지 다 조회되는데 다시 INNER JOIN으로 조회되어서 NULL값 빠져버림

    -- ORACLE 구문
    -- 단, 지역명이 ASIA1 사원들만 조회
    SELECT E.EMP_ID AS "사원명",
           E.EMP_NAME AS "직원명",
           D.DEPT_TITLE AS "부서명",
           L.LOCAL_NAME AS "지역명"
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
    WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE AND L.LOCAL_NAME = 'ASIA1'; 
            -- ORACLE 구문은 JOIN 순서 상관없다.


--------------- 다중 조인 실습 문제 221219 4교시---------------------------------------------------------------------------
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
SELECT * FROM NATIONAL;
SELECT * FROM SAL_GRADE;

-- 1. 사번, 직원명, 부서명, 지역명, 국가명 조회
-- ANSI
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);

SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);

-- ORACLE
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE;

SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+) AND D.LOCATION_ID = L.LOCAL_CODE(+) AND L.NATIONAL_CODE = N.NATIONAL_CODE(+);


-- 2. 사번, 직원명, 부서명, 지역명, 국가명, 급여 등급 조회
-- ANSI
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명",
       S.SAL_LEVEL AS "급여 등급"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
INNER JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명",
       S.SAL_LEVEL AS "급여 등급"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
LEFT JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL)
ORDER BY 부서명, 사번;

-- ORACLE
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명",
       S.SAL_LEVEL AS "급여 등급"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE AND L.NATIONAL_CODE = N.NATIONAL_CODE AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "지역명",
       N.NATIONAL_NAME AS "국가명",
       S.SAL_LEVEL AS "급여 등급"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID(+) AND D.LOCATION_ID = L.LOCAL_CODE(+) AND L.NATIONAL_CODE = N.NATIONAL_CODE(+) AND E.SALARY BETWEEN S.MIN_SAL(+) AND S.MAX_SAL(+)
ORDER BY 부서명, 사번;

--------------------------------------------------------------------------------------------------------------------------------


--------------- JOIN 종합 실습 문제 221219 4교시---------------------------------------------------------------------------
-- 1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원들의 사번, 직원명, 직급명, 부서명, 근무지역, 급여를 조회하세요.
-- ANSI 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역",
       E.SALARY AS "급여"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)        -- DEPARTMENT의 컬럼과 LOCATION의 컬럼을 조인할거라 D를 먼저 E와 조인해주기
--WHERE J.JOB_NAME = '대리' AND L.LOCAL_NAME LIKE 'ASIA%'
;

SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역",
       E.SALARY AS "급여"
FROM EMPLOYEE E
LEFT JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
--WHERE J.JOB_NAME = '대리' AND L.LOCAL_NAME LIKE 'ASIA%'
;

-- 오라클 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역",
       E.SALARY AS "급여"
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND J.JOB_NAME = '대리'
  AND L.LOCAL_NAME LIKE 'ASIA%';

SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역",
       E.SALARY AS "급여"
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE(+)
  AND E.DEPT_CODE = D.DEPT_ID(+)
  AND D.LOCATION_ID = L.LOCAL_CODE(+)                       --  ?D.LOCATION (+)안해도되나요 > 네. (+)는 한 쪽에만 붙여줍니다.
  AND J.JOB_NAME = '대리'
  AND L.LOCAL_NAME LIKE 'ASIA%';


-- 2. 70년대생 이면서 여자이고, 성이 전 씨인 직원들의 직원명, 주민번호, 부서명, 직급명을 조회하세요.
-- ANSI 구문
SELECT E.EMP_NAME AS "직원명",
       E.EMP_NO AS "주민번호",
       D.DEPT_TITLE AS "부서명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE SUBSTR(EMP_NO, 1, 1) = '7'
  AND SUBSTR(EMP_NO, 8, 1) = '2'
  AND EMP_NAME LIKE '전%';         --  '7'이 아니라 7처럼 숫자로 써도 나오는 거 자동 형변환?????????????????????????????????

-- 오라클 구문
SELECT E.EMP_NAME AS "직원명",
       E.EMP_NO AS "주민번호",
       D.DEPT_TITLE AS "부서명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
  AND SUBSTR(EMP_NO, 1, 1) = '7'
  AND SUBSTR(EMP_NO, 8, 1) = '2'
  AND EMP_NAME LIKE '전%';


-- 3. 보너스를 받는 직원들의 직원명, 보너스, 연봉, 부서명, 근무지역을 조회하세요.
--    단, 부서 코드가 없는 사원도 출력될 수 있게 Outer JOIN 사용
-- ANSI 구문
SELECT E.EMP_NAME AS "직원명",
       E.BONUS AS "보너스",
       E.SALARY * 12 AS "연봉",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE BONUS IS NULL;

-- 오라클 구문
SELECT E.EMP_NAME AS "직원명",
       E.BONUS AS "보너스",
       E.SALARY * 12 AS "연봉",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID(+) AND D.LOCATION_ID = L.LOCAL_CODE(+) AND BONUS IS NULL;


-- 4. 한국과 일본에서 근무하는 직원들의 직원명, 부서명, 근무지역, 근무 국가를 조회하세요.
-- ANSI 구문
SELECT E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역",
       N.NATIONAL_NAME AS "근무 국가"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME IN ('한국', '일본');

-- 오라클 구문
SELECT E.EMP_NAME AS "직원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역",
       L.NATIONAL_CODE AS "근무 국가"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE AND L.NATIONAL_CODE = N.NATIONAL_CODE AND N.NATIONAL_NAME IN ('한국', '일본');


-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균 급여(정수 처리)를 조회하세요.
--    단, 부서 배치가 안된 사원들의 평균도 같이 나오게끔 해주세요^^
-- ANSI 구문                                                                                          ???? 그룹바이 SELECT에 있는 애로만 가능???????????????????????????
SELECT D.DEPT_TITLE AS "부서명",
       TRUNC(AVG(NVL(E.SALARY, 0))) AS "평균 급여"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY D.DEPT_TITLE
ORDER BY D.DEPT_TITLE;

-- 오라클 구문
SELECT D.DEPT_TITLE AS "부서명",
       TRUNC(AVG(NVL(E.SALARY, 0))) AS "평균 급여"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+)
GROUP BY D.DEPT_TITLE
ORDER BY D.DEPT_TITLE;


-- 6. 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회하시오.
-- ANSI 구문                                                                                          !!!!!!!! 해빙 그룹 조건 다시 공부!!!!!!!!!!!!!!
SELECT D.DEPT_TITLE AS "부서명",
       SUM(E.SALARY) AS "급여의 합"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000
ORDER BY D.DEPT_TITLE;

-- 오라클 구문
SELECT D.DEPT_TITLE AS "부서명",
       SUM(E.SALARY) AS "급여의 합"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+)
GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000
ORDER BY D.DEPT_TITLE;


-- 7. 사번, 직원명, 직급명, 급여 등급, 구분을 조회
--    이때 구분에 해당하는 값은 아래와 같이 조회 되도록 하시오.
--    급여 등급이 S1, S2인 경우 '고급'
--    급여 등급이 S3, S4인 경우 '중급'
--    급여 등급이 S5, S6인 경우 '초급'
-- ANSI 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       S.SAL_LEVEL AS "급여 등급",
       DECODE(S.SAL_LEVEL, 'S1', '고급', 'S2', '고급', 'S3', '중급', 'S4', '중급', 'S5','초급', 'S6', '초급') AS "구분"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);                                            -- BETWEEN!!!!!!??? 공부!!!!!!!!!!!!!

-- 오라클 구문                                                                       DECODE랑 CASE 둘 다 사용하는 법 익히기
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       S.SAL_LEVEL AS "급여 등급",
       CASE
            WHEN S.SAL_LEVEL IN ('S1', 'S2') THEN '고급'
            WHEN S.SAL_LEVEL IN ('S3', 'S4') THEN '중급'
            WHEN S.SAL_LEVEL IN ('S5', 'S6') THEN '초급'
       END     
FROM EMPLOYEE E, JOB J, SAL_GRADE S
WHERE E.JOB_CODE = J.JOB_CODE AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;


-- 8. 보너스를 받지 않는 직원들 중 직급 코드가 J4 또는 J7인 직원들의 직원명, 직급명, 급여를 조회하시오.
-- ANSI 구문
SELECT E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       E.SALARY AS "급여"
FROM EMPLOYEE E
LEFT JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE (BONUS IS NULL) AND (J.JOB_CODE = 'J4' OR J.JOB_CODE = 'J7');

-- 오라클 구문
SELECT E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       E.SALARY AS "급여"
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND (BONUS IS NULL) AND (J.JOB_CODE = 'J4' OR J.JOB_CODE = 'J7');


-- 9. 부서가 있는 직원들의 직원명, 직급명, 부서명, 근무 지역을 조회하시오.
-- ANSI 구문
SELECT E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- 오라클 구문
-- ANSI 구문
SELECT E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역"
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE AND E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE;


-- 10. 해외영업팀에 근무하는 직원들의 직원명, 직급명, 부서 코드, 부서명을 조회하시오.
-- ANSI 구문
SELECT E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       E.DEPT_CODE AS "부서코드",
       D.DEPT_TITLE AS "부서명"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE D.DEPT_TITLE LIKE '해외영업%부'
ORDER BY D.DEPT_TITLE;

-- 오라클 구문
SELECT E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명",
       E.DEPT_CODE AS "부서코드",
       D.DEPT_TITLE AS "부서명"
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE AND E.DEPT_CODE = D.DEPT_ID AND D.DEPT_TITLE LIKE '해외영업%부'
ORDER BY D.DEPT_TITLE;


-- 11. 이름에 '형'자가 들어있는 직원들의 사번, 직원명, 직급명을 조회하시오.
-- ANSI 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.EMP_NAME LIKE '%형%';

-- 오라클 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "직원명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND E.EMP_NAME LIKE '%형%';

--------------------------------------------------------------------------------------------------------------------------------

