

/*                                                         221229 4교시 13_OBJECT(PROCEDURE, FUNCTION, TRIGGER)
    <TRIGGER>
        TRIGGER는 오라클에서 제공하는 객체로
        테이블이나 뷰가 DML(INSERT, UPDATE, DELETE)문에 의해 변경될 경우 자동으로 실행될 내용을 정의하여 저장한다.
        
        [표현법]
            CREATE [OR REPLACE] TRIGGER 트리거명
            BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명
            [FOR EACH ROW] --> 행 트리거
            [DECLARE
                선언부]
            BEGIN
                실행부 (해당 위에 지정된 이벤트 발생 시 자동으로 실행할 구문)
            [EXCEPTION
                예외처리부]
            END;
            /   
*/
-- 1. 문장 트리거(STATEMENT TRIGGER)
--    해당 SQL 문에 대해 '한 번만' 트리거를 실행한다.
-- EMPLOYEE 테이블에 새로운 행이 INSERT 될 때 '신입사원이 입사했습니다.' 메시지를 자동으로 출력하는 트리거 생성
CREATE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE        -- EMPLOYEE 테이블에 INSERT가 작동한 이후에 라는 뜻
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
END;
/

--시퀀스 사용해서 EMP_ID 값 대입
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO) VALUES(SEQ_EMPID.NEXTVAL, '문인수', '201229-3666666');
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO) VALUES(SEQ_EMPID.NEXTVAL, '공유', '221229-3777777');

ROLLBACK;


-- 2. 행 트리거(ROW TRIGGER)
--    해당 SQL 문에 영향을 받는 행'마다' 트리거를 실행한다. (FOR EACH ROW 옵션을 기술)
--    :OLE  :    수정,삭제 전 기존 데이터에 접근 가능
--    :NEW  :    입력, 수정 후 바뀐 데이터에 접근 가능
-- EMPLOYEE 테이블에 UPDATE 수행 한 후 '업데이트 실행' 메시지를 자동으로 출력
CREATE OR REPLACE TRIGGER TRG_02
AFTER UPDATE ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('업데이트 실행');
END;
/

-- EMPLOYEE 테이블에서 부서코드가 D9인 직원들의 부서코드를 D3로 변경
UPDATE EMPLOYEE
SET DEPT_CODE = 'D3'
WHERE DEPT_CODE = 'D9';
    -- 문장(바로 위 문장)에 대해서 트리거 한 번만 수행 (문장 트리거)

ROLLBACK;    


-- 행 트리거 생성
-- FOR EACH ROW 넣어주기
CREATE OR REPLACE TRIGGER TRG_02
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('업데이트 실행');
END;
/

UPDATE EMPLOYEE
SET DEPT_CODE = 'D3'
WHERE DEPT_CODE = 'D9';
    -- 영향을 받은 행마다 트리거를 발생(행 트리거)

ROLLBACK;

-- :OLD , :NEW 사용 실습
CREATE OR REPLACE TRIGGER TRG_02
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('변경 전 : ' || :OLD.DEPT_CODE || ', 변경 후 : ' || :NEW.DEPT_CODE);
END;
/

UPDATE EMPLOYEE
SET DEPT_CODE = 'D3'
WHERE DEPT_CODE = 'D9';


-- 상품 입/출고 관련 예시

-- 1. 상품에 대한 데이터를 보관할 테이블 생성
-- 테이블명 TB_PRODUCT
CREATE TABLE TB_PRODUCT (
    PCODE NUMBER,                   -- 상품코드
    PNAME VARCHAR2(150),            -- 상품명
    BRAND VARCHAR2(100),            -- 브랜드
    PRICE NUMBER,                   -- 가격
    STOCK NUMBER DEFAULT 0,          -- 재고
    CONSTRAINT TB_PRODUCT_PCODE_PK PRIMARY KEY(PCODE)
);

SELECT * FROM TB_PRODUCT;

-- 시퀀스 생성 후 데이터 삽입
-- 상품코드가 중복되지 않게 항상 새로운 번호를 발생하는 시퀀스 생성
CREATE SEQUENCE SEQ_PCODE;

-- 샘플 데이터 세 개 INSERT
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰14', '애플', 1000000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, 'Z플립', '삼성', 1500000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '샤오미폰', '샤오미', 500000, DEFAULT);

COMMIT;

SELECT * FROM TB_PRODUCT;

--                                                                      221229 5교시
-- 2. 상품 입/출고 상세 이력 테이블 생성 (TB_PRODETAIL)
CREATE TABLE TB_PRODETAIL (
    DCODE NUMBER,               -- 입출고 이력 코드
    PCODE NUMBER,               -- 상품 코드(외래키로 지정 TB_PRODUCT테이블의 PCODE 참조(PK))    PCODE참조
    STATUS VARCHAR2(10),        -- 상태(입고/출고)
    AMOUNT NUMBER,              -- 입/출고 수량
    DDATE DATE DEFAULT SYSDATE, -- 상품 입/출고 일자
    CONSTRAINT TB_PRODETAIL_DCODE_PK PRIMARY KEY(DCODE),
    CONSTRAINT TB_PRODETAIL_PCODE_FK FOREIGN KEY(PCODE) REFERENCES TB_PRODUCT,
    CONSTRAINT TB_PRODETAIL_STATUS_CK CHECK(STATUS IN ('입고', '출고'))
);

-- 시퀀스 생성 후 데이터 삽입
-- 입출고 이력 코드가 중복되지 않게 항상 새로운 번호를 발생하는 시퀀스 생성
CREATE SEQUENCE SEQ_DCODE;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

-- 1번 상품이 22/12/20 날짜로 10개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, '입고', 10, '22/12/20');    -- 두번째 컬럼 FK라서 PCODE값만 들어갈수있음
-- 입고가 되면 TB_PRODUCT 테이블의 1번 상품의 재고 수량도 변경해야 한다.
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 1;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

-- 2번 상품이 22/12/21 날짜로 20개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, '입고', 20, '22/12/21');
-- TB_PRODUCT 2번 상품 재고 수량 변경
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 2;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

-- 3번 상품이 22/12/21 날짜로 5개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, '입고', 5, '22/12/21');
-- TB_PRODUCT 3번 상품 재고 수량 변경
UPDATE TB_PRODUCT
SET STOCK = STOCK + 5
WHERE PCODE = 3;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

-- 2번 상품이 22/12/22 날짜로 5개 출고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, '출고', 5, '22/12/22');
-- TB_PRODUCT 2번 상품 재고 수량 변경
UPDATE TB_PRODUCT
SET STOCK = STOCK - 5
WHERE PCODE = 2;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

COMMIT;
    -- 일일히 하나씩 바꾸는 거 시간도 많이 걸리고 실수가 일어날 가능성이 높음

--                                                                  221228 6교시
-- TB_PRODETAIL 테이블에 입출고 데이터가 INSERT 되면
-- TB_PRODUCT 테이블에 재고수량이 자동으로 UPDATE 되도록 트리거를 생성
CREATE OR REPLACE TRIGGER TRG_PRO_STOCK
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(:NEW.STATUS || ' ' || :NEW.AMOUNT || ' ' || :NEW.PCODE);       -- 업데이트할때 필요한 데이터들
    
    -- 상품이 입고된 경우 (재고 증가)
    IF (:NEW.STATUS = '입고') THEN
        UPDATE TB_PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
    
    -- 상품이 출고된 경우 (재고 감소)
    IF (:NEW.STATUS = '출고') THEN
        UPDATE TB_PRODUCT
        SET STOCK= STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;        
    END IF;
    
--  트리거에서는 TCL 구문이 포함될 수 없다.    여기서 COMMIT해버리면 INSERT하는 순간 COMMIT이 됨
--  COMMIT;
--  ROLLBACK;
END;
/

-- 2번 상품이 '22/12/25' 날짜로 20개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, '입고', 20, '22/12/25');

-- 2번 상품이 '22/12/25' 날짜로 5개 출고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, '출고', 5, '22/12/25');

-- 3번 상품이 오늘 날짜로 100개 입고
INSERT INTO TB_PRODETAIL(DCODE, PCODE, STATUS, AMOUNT)
VALUES(SEQ_DCODE.NEXTVAL, 3, '입고', 100);       -- DDATE 컬럼 기본값이 SYSDATE라서 아무것도안써주면 SYSDATE들어감 

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;             -- 맨 마지막에 COMMIT 한번해주기 데이터 차 있는 상태로

ROLLBACK;

COMMIT;

