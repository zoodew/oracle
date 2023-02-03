
/*                                                         221228 8교시 13_OBJECT(PROCEDURE, FUNCTION, TRIGGER)
    <PROCEDURE>
        PROCEDURE는 오라클에서 제공하는 객체로 PL/SQL 문을 저장하여 필요할 때마다
        복잡한 구문을 다시 입력할 필요 없이 간단하게 호출해서 실행 결과를 얻을 수 있다.
*/
SET SERVEROUTPUT ON;

    -- 테스트용 테이블 생성
    CREATE TABLE EMP_COPY
    AS SELECT *
       FROM EMPLOYEE;

    SELECT * FROM EMP_COPY;

-- EMP_COP 테이블의 모든 데이터를 삭제하는 프로시저 생성
    CREATE PROCEDURE DEL_ALL_EMP        -- 수행하면 Procedure DEL_ALL_EMP이(가) 컴파일되었습니다.
    IS                                  --    >  이거 수행한다고 데이터가 다 삭제되는 거 아님! 프로시저가 만들어진 것일 뿐이다.
    BEGIN
        DELETE FROM EMP_COPY;
        COMMIT;
    END;
    /

    SELECT * FROM USER_SOURCE;      -- 프로시저 관리하는 뷰테이블 조회        프로시저 작성구문이 라인별로 저장되어있음


-- DEL_ALL_EMP 프로시저 호출
    EXECUTE DEL_ALL_EMP;        -- PL/SQL 프로시저가 성공적으로 완료되었습니다. 이 때 PROCEDURE의 BEGIN부 실행됨

    SELECT * FROM EMP_COPY;     -- 데이터 삭제된 거 확인 가능


-- 프로시저 삭제
    DROP PROCEDURE DEL_ALL_EMP;
    DROP TABLE EMP_COPY;



/*                                                         221229 1교시 13_OBJECT(PROCEDURE, FUNCTION, TRIGGER)
    <PROCEDURE>
        PROCEDURE는 오라클에서 제공하는 객체로 PL/SQL 문을 저장하여 필요할 때마다
        복잡한 구문을 다시 입력할 필요 없이 간단하게 호출해서 실행 결과를 얻을 수 있다.
        
    1. 매개변수가 있는 프로시저
*/
    -- 테스트용 테이블 생성
    CREATE TABLE EMP_COPY
    AS SELECT *
       FROM EMPLOYEE;

    SELECT * FROM EMP_COPY;

-- 사번을 입력받아서 해당하는 사번의 사원을 삭제하는 프로시저 생성
CREATE PROCEDURE DEL_EMP_ID (               -- CREATE PROCEDURE 프로시저명(매개변수)
    P_EMP_ID EMPLOYEE.EMP_ID%TYPE           -- 입력받은 값 받을 매개변수 선언. 변수명 데이터타입
)
IS
BEGIN
    DELETE FROM EMP_COPY
    WHERE EMP_ID = P_EMP_ID;                -- EMP_ID가 입력 받은 매개값이랑 같을 때 삭제
END;
/


-- 프로시저 실행
-- 에러 발생 매개값을 안 줘서
EXEC DEL_EMP_ID;                            -- 프로시저 삭제 호출구문 단축키 EXEC

EXEC DEL_EMP_ID('205');
-- 사용자가 입력한 값도 전달이 가능하다.
EXEC DEL_EMP_ID('&사번');                 -- 호출받은 값 삭제

SELECT * FROM EMP_COPY;

ROLLBACK;

SELECT * FROM EMP_COPY;


/*                                                         221229 1교시 13_OBJECT(PROCEDURE, FUNCTION, TRIGGER)
    <PROCEDURE>
        PROCEDURE는 오라클에서 제공하는 객체로 PL/SQL 문을 저장하여 필요할 때마다
        복잡한 구문을 다시 입력할 필요 없이 간단하게 호출해서 실행 결과를 얻을 수 있다.
        
    2. IN/OUT 매개변수가 있는 프로시저
        IN  사용자로부터 값을 입력받아 PROCEDURE로 전달해 주는 역할을 한다. (기본값)
        OUT PROCEDURE에서 호출 환경으로 값을 전달하는 역할을 한다.
*/
-- 사번을 입력받아서 해당하는 사원의 이름, 급여, 보너스를 전달하는 프로시저

-- 프로시저 생성
-- 매개변수 네 개 사번, 이름, 급여, 보너스 > IN 사번(사번을 입력 받을 거라서) OUT 이름 급여 보너스(받은 입력값을 전달할거라서)
CREATE PROCEDURE SELECT_EMP_ID (
    P_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
    P_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
    P_SALARY OUT EMPLOYEE.SALARY%TYPE,
    P_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS
BEGIN
    SELECT EMP_NAME, SALARY, BONUS
    INTO P_EMP_NAME, P_SALARY, P_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
END;
/


-- 프로시저 호출

-- 바인드 변수 선언 바인드 변수 ( 프로시저 호출하고 아웃매개변수에 담긴 값을 전달받는 통로역할을 하는 변수)
VAR VAR_EMP_NAME VARCHAR2(30);      -- DBMS자체에 변수 선언해서 쓰는 거. 
VAR VAR_SALARY NUMBER;                  -- OUT 변수에 받은 값을 바인드 변수에 전달함
VAR VAR_BONUS NUMBER;
        -- 아웃변수에 담은 값이 바인드변수에 전달됨. 바인드 변수는 앞에 콜롬 찍어주기
-- 바인드 변수는 ':변수명' 형태로 참조 가능
EXEC SELECT_EMP_ID('200', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

-- 바인드 변수의 값을 출력하기 위해 PRIN 구문을 사용한다.
PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;

--                                                                                          221229 1교시
-- SET AUTOPRINT [ON/OFF] : ON일 때. 바인드 변수의 값이 변경되면 변수의 값을 자동으로 출력한다. (기본은 OFF상태) 별도의 PRINT 구문 없어도 출력이 됨
SET AUTOPRINT ON;
EXEC SELECT_EMP_ID('&사번', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

