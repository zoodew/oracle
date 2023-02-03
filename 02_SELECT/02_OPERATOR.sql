-- <연산자>

/*                                  221212 7교시  ORACLE 02_DQL(SELECT)
    <연결 연산자>
    - ||를 사용하여 여러 컬럼을 하나의 컬럼인 것처럼 연결하거나 컬럼과 리터럴을 연결할 수 있다.
*/
-- EMPLOYEE 테이블에서 사번, 직원명, 급여를 연결해서 조회
SELECT EMP_ID, EMP_NAME, SALARY     -- 각 컬럼이 구분돼서 출력
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || SALARY -- 하나의 컬럼으로 조회한 것처럼 출력
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 급여를 리터럴과 연결해서 조회
SELECT EMP_NAME, '의 월급은 ', SALARY, '원 입니다.'
FROM EMPLOYEE;

SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' AS "급여정보"
FROM EMPLOYEE;



/*                                  221212 7교시  ORACLE 02_DQL(SELECT)
    <논리 연산자, 비교 연산자>
*/
-- 1) EMPLOYEE 테이블에서 부서 코드가 D6번이면서 급여가 300만원 이상인 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' AND SALARY >= 3000000;

-- 2) EMPLOYEE 테이블에서 직급 코드가 J1와 일치하는 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J1';
        -- SELECT에 없는 컬럼을 조건으로 걸어도 출력 가능. 왜냐하면 실행 순서가 FROM 절이 제일 처음이라서 EMPLOYEE 테이블을 읽은 상태. 따라서 WHERE 조건으로 SELECT에 없는 JOB_CODE를 거는 게 가능함

-- 3) EMPLOYEE 테이블에서 부서 코드가 D5이거나 급여가 500만원 이상인 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY >= 5000000;

-- 4) EMPLOYEE 테이블에서 급여가 350만원 이상 600만원 이하를 받는 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000
-- WHERE 3500000 <= SALARY <= 6000000;      -- 불가능! 밑의 BETWEEN AND 이어서 보기
ORDER BY SALARY;



/*                                  221212 8교시  ORACLE 02_DQL(SELECT)
    <BETWEEN AND>
        - NOT 연산자는 컬럼명 앞 또는 BETWEEN 앞에 사용 가능
        - 날짜 데이터의 범위를 구할 때도 사용할 수 있음
*/
-- 1) (논리 비교 연산자 4)와 같이 놓고 보기) EMPLOYEE 테이블에서 급여가 350만원 이상 600만원 이하를 받는 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000
ORDER BY SALARY;

-- 2) EMPLOYEE 테이블에서 급여가 350만원 이상 600만원 이하가 아닌 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 6000000
-- WHERE NOT SALARY BETWEEN 3500000 AND 6000000             -- NOT 연산자는 컬럼명 앞 또는 BETWEEN 앞에 사용 가능
ORDER BY SALARY;

-- 3) EMPLOYEE 테이블에서 입사일이 '90/01/01' ~ '01/01/01'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01'           -- 날짜 데이터 리터럴 작은따옴표('')
ORDER BY HIRE_DATE DESC;

-- 4) EMPLOYEE 테이블에서 입사일이 '90/01/01' ~ '01/01/01'이 아닌 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
--WHERE HIRE_DATE NOT BETWEEN '90/01/01' AND '01/01/01'     -- NOT 연산자는 컬럼명 앞 또는 BETWEEN 앞에 사용 가능     
WHERE NOT HIRE_DATE BETWEEN '90/01/01' AND '01/01/01'
ORDER BY HIRE_DATE DESC;



/*                                  221213 1교시  ORACLE 02_DQL(SELECT)
    <LIKE>
        - '%' : 0 글자 이상 한 글자 이상이 아니라 0 글자 이상이다!
            ex) 컬럼 LIKE '문자%'  => 컬럼 값 중에 '문자'로 시작하는 모든 행을 조회한다.
                컬럼 LIKE '%문자'  => 컬럼 값 중에 '문자'로 끝나는 모든 행을 조회한다. 한 글자도, 0 글자도, 열 글자도 다 괜찮음.
                컬럼 LIKE '%문자%' => 컬럼 값 중에 '문자'가 포함되어있는 모든 행을 조회한다.
        - '_' : 1 글자
            ex) 컬럼 LIKE '_문자'  => 컬럼 값 중에 '문자' 앞에 무조건 한 글자가 오는 모든 행을 조회한다.
                컬럼 LIKE '__문자' => 컬럼 값 중에 '문자' 앞에 무조건 두 글자가 오는 모든 행을 조회한다.
                
        - 와일드카드 문자를 특수문자로 사용해야 하는 경우 데이터로 처리할 와일드카드 문자 앞에 임의의 특수문자를 사용하고 ESCAPE로 등록하여 처리한다.         
*/
-- 1) EMPLOYEE 테이블에서 성이 전 씨인 사원의 직원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- 2) EMPLOYEE 테이블에서 이름 중에 '하'가 포함된 사원의 직원명, 주민번호, 부서 코드 조회
SELECT EMP_NAME, EMP_NO,DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';    -- '%'는 0 글자가 들어가도 괜찮음

-- 3) EMPLOYEE 테이블에서 김씨 성이 아닌 사원의 사번, 직원명, 입사일 조회  -> NOT 연산자
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
 WHERE EMP_NAME NOT LIKE '김%';       -- NOT은 컬럼명, LIKE 둘 중 한 곳의 앞에 위치하면 됨 
-- WHERE NOT EMP_NAME LIKE '김%';
-- WHERE NOT EMP_NAME NOT LIKE '김%';   --  NOT을 두 번 써주면 부정의 부정 -> 참이 됨

-- 221213 2교시
-- 4)EMPLOYEE 테이블에서 전화번호 네번째 자리가 9로 시작하는 사원의 사번, 직원명, 전화번호, 이메일 조회
-- 와일드카드 : _(1글자), %(0글자 이상)
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';           -- 테이블의 데이터 자료 변경 커밋 누르기 선동일의 폰번호 01 99546325로 바꿔서 공백도 포함하는지 테스트해보기

-- 5) EMPLOYEE 테이블에서 이메일 중 '_'앞 글자가 세 자리인 이메일 주소를 가진 사원의 사번, 직원명, 이메일 조회
-- 데이터로 처리할 값 앞에 임의의 문자를 제시하고 임의의 문자를 ESCAPE 옵션에 등록한다.
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___#_%' ESCAPE '#'; -- 가능
-- WHERE EMAIL LIKE '___\_%'; ESCAPE '\';   -- ESCAPE 특수문자는 아무거나 써도 괜찮음. 특수문자 뒤의 '_'는 와일드 카드의 기능을 잃고 일반적인 특수문자로 인식이 됨
-- WHERE EMAIL LIKE '____%';  와일드카드와 데이터 값이 구분되지 않는다.


---------------------------------실습문제   221212 3교시-------------------------------
-- 1. EMPLOYEE 테이블에서 이름 끝이 '연'으로 끝나는 사원의 직원명, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

-- 2. EMPLOYEE 테이블에서 전화번호 처음 세 자리가 010이 아닌 사원의 이름, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
-- WHERE NOT PHONE LIKE '010%';     -- NOT을 컬럼명 앞 LIKE 앞 두 군데 붙일 수 있음

-- 3. DEPARTMET 테이블에서 해외영업부에 대한 모든 컬럼을 조회
SELECT *
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%';

-------------------------------------------------------------------------------------



/*                                  221213 2교시  ORACLE 02_DQL(SELECT)
    <IS NULL>
    - 비교하려는 값의 NULL 여부를 확인하는 연산자
*/
-- 1) EMPLOYEE 테이블에서 보너스를 받지 않는 사원의 사번, 직원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;
-- WHERE BONUS IS NOT NULL; -- NULL이 아닌 값을 출력하고 싶을 때
-- WHERE BONUS = NULL;  -- NULL은 비교 연산자로 비교할 수 없다. 불가능

--221213 3교시
-- 2) EMPLOYEE 테이블에서 관리자(사수)가 없는 사원의 이름, 부서 코드 조회
SELECT EMP_NAME, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 3) EMPLOYEE 테이블에서 관리자도 없고 부서도 배치 받지 않은 사원의 이름, 부서 코드 조회
SELECT EMP_NAME, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- 4) EMPLOYEE 테이블에서 부서 배치를 받진 않았지만 보너스를 받는 사원의 직원명, 부서 코드, 보너스 조회
SELECT EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;



/*                                  221213 3교시  ORACLE 02_DQL(SELECT)
    <IN>
    - 비교하려는 값과 일치하는 값이 목록에 있는지 확인하는 연산자
*/
-- 1) EMPLOYEE 테이블에서 부서 코드가 'D5', 'D6', 'D8'인 부서원들의 직원명, 부서 코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D8';     -- IN 사용하지 않고 쓴 방법. IN 연산자가 더 간편할 뿐 이것도 가능함 
WHERE DEPT_CODE IN ('D5', 'D6', 'D8')
ORDER BY DEPT_CODE;



/*                                  221213 3교시  ORACLE 02_DQL(SELECT)
    <연산자 우선순위>
    - 다 외울 필요는 없다 참고만 하기. 논리 연산자만 NOT > AND > OR 순인 것 주의하기
    - 괄호는 0순위
*/
-- 1) EMPLOYEE 테이블에서 직급 코드가 J4 또는 J7 직급인 사원들 중 급여가 200만원 이상인 사원들의 이름, 직급 코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
-- WHERE JOB_CODE = 'J4' OR JOB_CODE = 'J7' AND SALARY >= 2000000;  -- 불가! OR보다 AND가 먼저 실행. {(JOB_CODE = 'J7') AND (SALARY >= 2000000)}부터 연산되고 그다음에 {(앞의 식 결과) OR (JOB_CODE = 'J4')} 실행 
WHERE (JOB_CODE = 'J4' OR JOB_CODE = 'J7') AND SALARY >= 2000000;   -- 괄호를 쳐서 먼저 연산해줌 괄호 = 0순위 연산자임
-- WHERE JOB_CODE IN ('J4', 'J7') AND SALARY >= 2000000;            -- 맞는 식

