                                                                    -- 221227 2교시
-- CREATE TABLE 권한이 없기 때문에 오류가 발생한다.
-- 3. SAMPLE 계정에서 테이블을 생성할 수 있는 CREATE TABLE 권한 부여 받기
-- 4. 테이블 스페이스 할당(테이블, 뷰, 인덱스 등 객체들이 실제로 저장되는 물리적인 공간)
    CREATE TABLE TEST(
        TID NUMBER
    );                              -- 221227 2교시 다시 꼭 보기 이해 2~30퍼 상태

    SELECT * FROM TEST;
    INSERT INTO TEST VALUES(1);
    DROP TABLE TEST;

-- 다른 계정의 테이블에 접근할 수 있는 권한이 없기 때문에 오류가 발생한다.
-- 5. KH.EMPLOYEE 테이블을 조회할 수 있는 권한 부여 받기
    SELECT * FROM KH.EMPLOYEE;  --KH계정의 EMPLOYEE 테이블 조회하고싶을 때
        -- 권한은 모두 SYS 계정에서 부여함

-- 6. KH.DEPARTMENT 테이블을 조회할 수 있는 권한 부여 받기
    SELECT * FROM KH. DEPARTMENT;

-- 7. KH.DEPARTMENT 테이블에 데이터를 삽입할 수 있는 권한 부여 받기
    INSERT INTO KH.DEPARTMENT VALUES ('D0', '인사팀', 'L2');

ROLLBACK;

-- 8. 권한 회수 후 수행 > 에러 발생                                    221227 3교시
    INSERT INTO KH.DEPARTMENT VALUES ('D0', '인사팀', 'L2');
