

/*                                                         221229 2교시 13_OBJECT(PROCEDURE, FUNCTION, TRIGGER)
    <FUNCTION>
        FUNCTION은 오라클에서 제공하는 객체로
        PROCEDURE와 거의 유사한 용도로 사용하지만 실행 결과를 되돌려 받을 수 있다는 점이 다르다.
*/
-- 사번을 입력받아 해당 사원의 보너스를 포함하는 연봉을 계산하고 리턴하는 함수 생성
CREATE FUNCTION BONUS_CALC(
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE
)
RETURN NUMBER
IS
    V_SALARY EMPLOYEE.SALARY%TYPE;
    V_BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT SALARY, NVL(BONUS, 0)
    INTO V_SALARY, V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;

    RETURN ((V_SALARY) + (V_SALARY * V_BONUS)) *12;
END;
/

-- 함수 호출
-- 방법 1) 함수를 SELECT구문에서 사용하기
SELECT BONUS_CALC('200') FROM DUAL;
-- 오라클에서 제공하는 함수 말고도 함수를 만들어서도 사용 가능함

-- 방법 2) EXECUTE 명령으로 함수 호출
-- 함수 호출 결과를 반환 받아 저장할 바인드 변수 선언

-- 반환값을 받아줘야하는데 안 받고 그냥 하면 에러남
EXECUTE BONUS_CALC('200');

            -- 바인드변수 선언
VARIABLE VAR_CALC_SALARY NUMBER;
            -- 바인드 변수에 함수 값 대입하기
EXEC :VAR_CALC_SALARY := BONUS_CALC('200');
PRINT VAR_CALC_SALARY;


-- EMPLOYY 테이블에서 전체 사원의 사번, 직원명, 급여, 보너스, 보너스를 포함한 연봉을 조회
-- 함수 만든 거 활용해서 조회해보기
                                            -- 함수명(매개변수)
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID) >= 40000000
ORDER BY BONUS_CALC(EMP_ID);
