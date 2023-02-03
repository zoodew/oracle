

/*                                                         221229 2교시 13_OBJECT(PROCEDURE, FUNCTION, TRIGGER)
    <CURSOR>
        SQL 구문의 처리 결과를 담고 있는 객체이다.
        CURSOR 사용 시 여러 행으로 나타난 처리 결과에 순차적으로 접근이 가능하다.
        cf)INTO절 하나의 행만 담고 CURSOR 여러 행을 담음 결과가 한 행으로 나오면 INTO절 여러행으로 나오면 CURSOR
        
    <CURSOR 종류>
        1. 묵시적 커서
            - 오라클에서 자동으로 생성되어 사용하는 커서이다.(커서명 : SQL)
            - PL/SQL에서 SQL문 실행 시마다 자동으로 만들어져서 사용된다.

        2. 명시적 커서
            - 사용자가 직접 선언해서 사용할 수 있는 이름이 있는 커서이다.
            
            [표현법]
                CURSOR 커서명 IS SELECT 문        - 커서 선언
                
                OPEN CURSOR;                    -커서 오픈
                FETCH 커서명 INTO 변수[, 변수, ...];          - 조회되는 여러 행의 데이터중 커서로 받아온 데이터를 변수에 담는
                ...
                CLOSE 커서명;
                
        * 커서 속성
            커서명%FOUND       :   커서 영역에 남아있는 행의 수가 한 개 이상일 경우 TRUE, 그렇지 않으면 FALSE 리턴
            커서명%NOTFOUND    :   커서 영역에 남아있는 행의 수가 없으면 TRUE, 그렇지 않으면 FALSE
            커서명%ISOPEN      :   커서가 OPEN 상태인 경우 TRUE, 그렇지 않으면 FALSE (묵시적 커서는 항상 FALSE이다)
            커서명%ROWCOUNT    :   SQL 처리 결과로 얻어온 행(ROW)의 수
*/
SET SERVEROUTPUT ON;

-- 1. 묵시적 커서
SELECT * FROM EMP_COPY;

-- PL/SQL에서 EMP_COPY 테이블의 BONUS가 NULL인 사원의 BONUS를 0 으로 수정
BEGIN
    UPDATE EMP_COPY
    SET BONUS = 0
    WHERE BONUS IS NULL;
    
    -- 묵시적 커서 사용
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '행 수정됨');
END;
/
SELECT * FROM EMP_COPY;

ROLLBACK;

--                                                          221229 3교시
-- 2. 명시적 커서
-- 급여가 3000000 이상인 사원의 사번, 이름, 급여 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    
    --커서 선언     > 커서 선언했을때 SELECT구문실행되는게 아니라 선언된상태기만 함 OPEN을해줘야함
    CURSOR C1 IS
        SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMPLOYEE
        WHERE SALARY >= 3000000;
BEGIN
    -- 커서 오픈
    OPEN C1;
    
    -- 행의 개수만큼 반복시켜줘야함 > 반복문 사용
    LOOP
        --커서 패치
        FETCH C1 INTO EID, ENAME, SAL;
        
        -- 반복문의 종료 조건
        EXIT WHEN C1%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(EID || ' ' || ENAME  || ' ' || SAL);
    END LOOP;
    
    -- 커서 종료
    CLOSE C1;
END;
/


-- 프로시저 생성, 실행
-- 전체 부서에 대해 부서 코드, 부서명, 지역 조회
CREATE PROCEDURE CURSOR_DEPT
IS
    DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPARTMENT;
BEGIN
    OPEN C1;
    LOOP
        FETCH C1 INTO DEPT.DEPT_ID, DEPT.DEPT_TITLE, DEPT.LOCATION_ID;
        
        EXIT WHEN C1%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
    END LOOP;
    
    
    CLOSE C1;
END;
/

EXECUTE CURSOR_DEPT;


-- FOR LOOF를 이용한 커서 사용
-- 1) LOOP 시작 시 자동으로 커서를 OPEN 한다.
-- 2) 반복할 때마다 FETCH도 자동으로 실행된다.
-- 3) LOOP 종료 시 자동으로 커서를 CLOSE 한다.
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPARTMENT;
BEGIN
    FOR DEPT IN C1
    LOOP
        DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXECUTE CURSOR_DEPT;


-- CURSOR를 선언하지 않고 사용하는 방법
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    DEPT DEPARTMENT%ROWTYPE;
-- CURSOR를 선언하지않고 사용하는 방법
--    CURSOR C1 IS
--        SELECT * FROM DEPARTMENT;
BEGIN
--    FOR DEPT IN C1
    -- 추가
    FOR DEPT IN (SELECT * FROM DEPARTMENT)
    LOOP
        DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXECUTE CURSOR_DEPT;




