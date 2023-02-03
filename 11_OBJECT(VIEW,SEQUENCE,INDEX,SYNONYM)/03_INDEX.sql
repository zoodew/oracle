
/*                                                          2212288 1교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <INDEX>
    INDEX는 오라클에서 제공하는 객체이다.
    SQL 명령문의 처리 속도를 향상시키기 위해서 행들의 위치 정보를 가지고 있다.
    
    인덱스 실무에서 중요함 실습은 데이터가 많이 없어서 하지 못했지만 성능 향상을 위해 정말 중요하게 쓰임 잘 사용하기
    
    1) 비고유 인덱스
    2) 결합 인덱스
*/
    SELECT ROWID, E.*
    FROM EMPLOYEE E;
-- ROWID : 데이터베이스에 저장되어 있는 데이터의 주소. 실제로 데이터가 저장되어 있는 주소값
-- ROWID라는 컬럼 만들지 않았는데 조회 가능 -> 오라클에 기본으로 있는 것이라서

-- 인덱스에 대한 정보 조회
    SELECT * FROM USER_INDEXES;
-- 인덱스가 걸려있는 컬럼 조회
    SELECT * FROM USER_IND_COLUMNS;

-- 인덱스 없는 상태 -> 실행 계획으로 확인하면 TABLE FULL SCAN을 통해서 데이터를 조회하는 것을 확인할 수 있다. 색깔창 안 초록 세모 옆 원통에 알고리즘 도안
    SELECT *
    FROM EMPLOYEE;
    -- 조회 후 위의 계획설명 눌러보기
        -- >  COST      : 메모리나 CPU를 얼마나 사용했는지 보여줌. 낮으면 낮을수록 좋음 사용하는 자원의 양이 적다는 뜻
        -- >  OPTION    : 데이터를 어떻게 찾을지 FULL은 모든 데이터 조회

-- 인덱스가 걸린 컬럼으로 데이터를 조회해도 데이터가 많지 않으면 TABLE FULL SCAN으로 찾는다.
-- 데이터가 얼마 없으면 오라클에서 굳이 인덱스를 사용해서 데이터를 조회하지 않는다. 안 해도 빠르게 찾을 수 있음 인덱스를 찾고 그거로 다시 찾는 게 더 느림
    SELECT *
    FROM EMPLOYEE
    WHERE EMP_ID = 200;


-- 춘 대학교 계정 STUDY로 접속 후 실습 (오른쪽 구석에서 STUDY로 바꾸기)--------------------------------------------------------------------------------------------

    SELECT *
    FROM TB_STUDENT
    WHERE STUDENT_NAME = '한효종';
    -- 실행계획 > 인덱스 안 걸려 있음  FULL SCAN(모든 데이터 조회)을 타고 COST 5 듦(사용하는 자원의 양)

    SELECT *
    FROM TB_STUDENT
    WHERE STUDENT_NO = 'A511320';
    -- 실행계획 > 인덱스 걸려 있음 옵션 UNIQUE INDEX SCAN, COST 2        --> 같은 데이터(한효종)를 조회하는데 위(38행)보다 자원 적게 쓰고 빠르게 조회 가능



-- 비고유 인덱스 생성                                       221228 2교시
    CREATE INDEX IDX_STUDENT_NAME       -- 인덱스 이름
    ON TB_STUDENT(STUDENT_NAME);        -- 테이블명(컬럼명)

    SELECT *
    FROM TB_STUDENT
    WHERE STUDENT_NAME = '한효종';
    -- 인덱스 생성 후 실행계획 > 인덱스 걸려 있음 옵션 RANGE SCAN, COST 2      --> 기존보다 COST 숫자가 줄어듦 좀 더 빠르게 성능좋게 효율성 UP!



-- 결합 인덱스 생성
-- 두 개의 컬럼으로 인덱스 생성
    SELECT *
    FROM TB_GRADE
    WHERE STUDENT_NO = 'A357025' AND CLASS_NO = 'C4507100';
    -- A357025 C4507100의 학점 조회  > FULL SCAN태우고 COST 8

    CREATE INDEX IDX_STUDENT_CLASS_NO
    ON TB_GRADE(STUDENT_NO, CLASS_NO);

    SELECT *
    FROM TB_GRADE
    WHERE STUDENT_NO = 'A357025' AND CLASS_NO = 'C4507100';
    -- COST 2로 줄어듦

    -- 자주 사용하는 컬럼들 INDEX 생성해두면 좋다. 검색할 때 성능이 향상됨


-- INDEX 삭제
-- DROP INDEX 인덱스명;
    DROP INDEX IDX_STUDENT_NAME;
    DROP INDEX IDX_STUDENT_CLASS_NO;

---------춘 대학교 STUDY 계정 끝---------------------------------------------------------------------------------------------------------
