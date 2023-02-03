

/*                                                              221221 8교시 07_DDL(CREATE,ALTER,DROP)
    < DDL(Data Definition Language) >
        데이터 정의 언어로 오라클에서 제공하는 객체를 만들고(CREATE), 변경(ALTER)하고, 삭제(DROP)하는 등
        실제 데이터 값이 아닌 데이터의 구조를 정의하는 언어이다.
    
    
    < ALTER >
        데이터베이스 객체(테이블, 인덱스, 뷰 등)를 수정하는 구문이다.
    
    < 테이블 수정 >
*/
-- 실습에 사용할 테이블 생성
    CREATE TABLE DEPT_COPY
    AS SELECT *
       FROM DEPARTMENT;

    SELECT * FROM DEPT_COPY;



/*                                                              221221 8교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    1. 컬럼 추가 / 수정 / 삭제 / 이름 변경
      
      1) 컬럼 추가 (ADD)
        ALTER TABLE 테이블명 ADD 컬럼명 데이터타입 [DEFAULT 기본값];
*/
-- DEPT_COPY 테이블에 CNAME 컬럼을 테이블 맨 뒤에 추가한다.
-- 기본값을 지정하지 않으면 새로 추가된 컬럼은 NULL 값으로 채워진다.
    ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

    SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블에 LNAME 컬럼을 테이블 맨 뒤에 추가한다. (기본값 : 대한민국)
    ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(40) DEFAULT '대한민국';

    SELECT * FROM DEPT_COPY;



/*                                                              221221 8교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    1. 컬럼 추가 / 수정 / 삭제 / 이름 변경
      
      2) 컬럼 수정 (MODIFY)
      - 데이터 타입 변경
        ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입
      - 기본값 변경
        ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT 기본값;
*/
-- DEPT_COPY 테이블의 DEPT_ID 컬럼의 데이터 타입을 CHAR(3)으로 변경
    ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
    
        /* 
        -- 위에서 CHAR(2)에서 CHAR(3)으로 바꾼 DEPT_COPY 테이블의 DEPT_ID 컬럼의 데이터 타입을 CHAR(2)으로 변경
    
        @ cannot decrease column length because some value is too big 에러 발생.
        CHAR는 고정길이임. 2에서 3으로 바꾸면 들어있던 데이터가 이전에 2BYTE였어도(ex D1, D2, ...) 'D1 '(공백생성)인 3BYTE로 바뀐다.
                                                                            2BYTE 채우고 나머지 1BYTE는 공백으로 채워준것
        그래서 다시 2BYTE로 줄이려고 하면 데이터 손실이 생기니까 에러가 나게 됨
        */
        ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(2);

-- DEPT_COPY 테이블에 CNAME 컬럼의 데이터 타입을 NUMBER로 변경
-- 들어있던 데이터 값이 없었기 때문에 데이터 타입 변경이 가능하다.
    ALTER TABLE DEPT_COPY MODIFY CNAME NUMBER;


/* DEPT_COPY 테이블의 DEPT_TITLE 컬럼의 데이터 타입을 VARCHAR2(40)로 변경
                    LOCATION_ID 컬럼의 데이터 타입을 VARCHAR2(2)로 변경
                          LNAME 컬럼의 기본값을 미국으로 변경 */
-- 각각 바꾸기
    ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40);
    ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR(2);
    ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';    -- 기본값을 수정해도 이미 생성된 기본값은 바뀌지 않음. 여전히 '대한민국' 수정 후 추가되는 값들에 대해서만 수정후 데이터가 조회됨

-- 여러 개를 한번에 수정
    ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';

SELECT *
FROM DEPT_COPY;



/*                                                              221222 1교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    1. 컬럼 추가 / 수정 / 삭제 / 이름 변경
      
      3) 컬럼 삭제 (DROP)
        ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
      
      - 데이터 값이 기록되어 있어도 같이 삭제된다. (삭제된 컬럼 복구는 불가능)
      - 테이블에는 최소 한 개의 컬럼은 존재해야 한다
*/
-- DETP_COPY 테이블의 DEPT_ID 컬럼 삭제
    ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;

    SELECT * FROM DEPT_COPY;

    ROLLBACK;           -- DDL 구문은 ROLLBACK으로 복구 불가능

    ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
    ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
    ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
                        -- 여기까지는 삭제 가능
    SELECT * FROM DEPT_COPY;

-- 테이블에 최소 한 개의 컬럼은 존재해야 한다.
    ALTER TABLE DEPT_COPY DROP COLUMN LNAME;    -- 에러 발생. 삭제 불가능


    SELECT * FROM DEPT_COPY;
    SELECT * FROM MEMBER_GRADE;
    SELECT * FROM MEMBER;
    -- 참조 되고 있는 컬럼이 있다면 삭제가 불가능하다. MEMBER_GRADE 부모테이블의 GRADE_CODE는 MEMBER 자식테이블의 GRADE_ID 컬럼과 참조 관계중
    ALTER TABLE MEMBER_GRADE DROP COLUMN GRADE_CODE;
    -- 그래도 삭제하고싶어! 그럴 땐
-- < CASCADE CONSTRAINTS > 사용!
    -- 지정한 부모테이블의 컬럼이 삭제되면서 참조하고 있는 자식 테이블의 FORIEGN KEY 제약조건 삭제됨(MEMBER 테이블의 GRADE_ID 컬럼에 설정되어있던 FORIEGN KEY 삭제)
    ALTER TABLE MEMBER_GRADE DROP COLUMN GRADE_CODE CASCADE CONSTRAINTS;



/*                                                              221222 1교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    1. 컬럼 추가 / 수정 / 삭제 / 이름 변경
      
      4) 컬럼명 변경 (RENAME)
        ALTER TABLE 테이블명 RENAME COLUMN 기존컬럼명 TO 변경할컬럼명;
*/
-- DEPT_COPY 테이블에서 LNAME 컬럼명을 LOCATION_NAME으로 변경
    ALTER TABLE DEPT_COPY RENAME COLUMN LNAME TO LOCATION_NAME;

    SELECT * FROM DEPT_COPY;

DROP TABLE DEPT_COPY;






/*                                                              221222 2교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    2. 제약조건 추가 / 삭제 / 이름 변경
      
      1) 제약조건 추가 (ADD)
      - 제약조건 추가
        ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 제약조건(컬럼명);
      - NOT NULL 추가
        ALTER TABLE 테이블명 MODIFY 컬럼명 [CONSTRAINT 제약조건명] NOT NULL;

      NOT NULL 제약조건의 경우 ALTER와 MODIFY 구문을 이용해서 제약조건을 추가해야 한다.
*/
-- 실습에 사용할 테이블 생성
    CREATE TABLE DEPT_COPY
    AS SELECT *
       FROM DEPARTMENT;
            -- 서브 쿼리를 사용해 테이블을 생성할 때, 제약조건은 NOT NULL 제약조건만 복사됨

    SELECT * FROM DEPT_COPY;    -- 테이블에 가서 제약조건 확인해보기 NOT NULL 빼고 아무것도 없음

    
-- DEPT_COPY 테이블의 DEPT_ID 컬럼에 PRIMARY KEY 제약조건 추가
    ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_DEPT_ID_PK PRIMARY KEY(DEPT_ID);

-- DEPT_COPY 테이블의 DEPT_TITLE 컬럼에 UNUQUE, NOT NULL 제약조건 추가
    ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_DEPT_TITLE_UQ UNIQUE(DEPT_TITLE);
    ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE CONSTRAINT DEPT_COPY_DEPT_TITLE_NN NOT NULL;

    SELECT * FROM DEPT_COPY;

-- EMPLOYEE 테이블의 DEPT_CODE, JOB_CODE 컬럼에 FOREIGN KEY 제약조건을 추가
    -- 각각 추가하는 법 (권장)
        ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_DEPT_CODE_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;
              --> REFERENCES DEPARTMENT(DEPT_ID) > DEP테이블의 DEPT_ID 컬럼과 연결하겠다. ()생략해도되는이유? DEPT_ID가 PK제약조건이 걸려있음. 외래키는 PK나 UQ와 연결. 미지정시 PK와 연결
        ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_JOB_CODE_FK FOREIGN KEY(JOB_CODE) REFERENCES JOB;
    -- 한 번에 추가하는 법
        ALTER TABLE EMPLOYEE
        ADD CONSTRAINT EMP_DEPT_CODE_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID)
        ADD CONSTRAINT EMP_JOB_CODE_FK FOREIGN KEY(JOB_CODE) REFERENCES JOB(JOB_CODE);
    
--  MEMBER_GRADE의 GRADE_CODE 컬럼에 PRIMARY KEY, NOT NULL 제약 조건을 추가
    DROP TABLE MEMBER_GRADE;    -- 외래키로 연결된 테이블 삭제할 때 부모테이블(참조된) 먼저 삭제 그 이후에 자식테이블 삭제
    DROP TABLE MEMBER;
    
    CREATE TABLE MEMBER_GRADE(
        GRADE_CODE NUMBER,
        GRADE_NAME VARCHAR2(30)
    );

    ALTER TABLE MEMBER_GRADE ADD CONSTRAINT MEMER_GRADE_GRADE_CODE_PK PRIMARY KEY(GRADE_CODE);
    ALTER TABLE MEMBER_GRADE MODIFY GRADE_NAME CONSTRAINT MEMBER_GRADE_NAME_NN NOT NULL;        --                                          !!!!! NOTNULL 추가문 일반 제약조건과 비교 !!!!!
    
            -- 다음 실습 위한 데이터 추가 ALTER와는 상관 없음
            INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
            INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
            INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');

            SELECT * FROM MEMBER_GRADE;
    
    
-- MEMBER 테이블의 PRIMARY KEY, UNIQUE, FOREIGN KEY, CHECK 제약조건을 추가

    CREATE TABLE MEMBER(
        NO NUMBER,  
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3),
        AGE NUMBER,
        GRADE_ID NUMBER,
        ENROLL_DATE DATE DEFAULT SYSDATE
    ); 

    ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO);
    ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_ID_UQ UNIQUE(ID);
    ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_GRADE_ID_FK FOREIGN KEY(GRADE_ID) REFERENCES MEMBER_GRADE;
    ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여'));
    ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_AGE_CK CHECK(AGE  > 0);
    -- 01_CREATE의 460행에 테이블이다. CREATE시 한 번에 제약조건 설정한 것(460행)을 위와 같이 테이블 생성과 제약 조건 설정을 따로 꺼내서 보기 쉽게 정리할 수도 있음
    -- (개인 취향임 보기 쉽게 만들기만 하면 됨)


            -- 다음 실습 위한 데이터 추가 ALTER와는 상관 없음
            INSERT INTO MEMBER VALUES(1, 'UESR1', '1234', '문인수', '남', 22, 10, DEFAULT);
            INSERT INTO MEMBER VALUES(2, 'UESR2', '1234', '홍길동', '남', 30, NULL, DEFAULT);
            INSERT INTO MEMBER VALUES(3, 'UESR3', '1234', '이몽룡', '남', 22, 10, DEFAULT);
            SELECT * FROM MEMBER;



/*                                                              221222 3교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    2. 제약조건 추가 / 삭제 / 이름 변경
      
      2) 제약조건 삭제 (DROP)
      - 제약조건 삭제
        ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
      - NOT NULL 삭제
        ALTER TABLE 테이블명 MODIFY 컬럼명 NULL;

      NOT NULL 제약조건의 경우 ALTER와 MODIFY 구문을 이용해서 제약조건을 삭제해야 한다.
      제약조건의 수정은 불가능하기 때문에 삭제 후 다시 제약조건을 추가해야 한다.
*/
-- DEPT_COPY 테이블의 DEPT_COPY_DEPT_ID_PK 제약조건 삭제
    ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_DEPT_ID_PK;

-- DEPT_COPY 테이블의 DEPT_COPY_DEPT_TITLE_UQ, DEPT_COPY_DEPT_TITLE_NN 제약조건 삭제
    ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_DEPT_TITLE_UQ;
    ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NULL;



/*                                                              221222 3교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    2. 제약조건 추가 / 삭제 / 이름 변경
      
      3) 제약조건명 변경 (RENAME)
        ALTER TABLE 테이블명 RENAME CONSTRAINT 기존 제약조건명 TO 변경할 제약조건명;
*/
-- DEPT_COPY 테이블의 SYS_C007215 제약조건명을 DEPT_COPY_DEPT_ID_NN로 변경
     ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007215 TO DEPT_COPY_DEPT_ID_NN;

-- DEPT_COPY 테이블의 SYS_C007216 제약조건명을 DEPT_COPY_LOCATION_ID_NN로 변경   
     ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007216 TO DEPT_COPY_LOCATION_ID_NN;







/*                                                              221222 3교시 07_DDL(CREATE,ALTER,DROP)
    < ALTER >
    
    4. 테이블명 변경
        - ALTER TABLE 테이블명 RENAME TO 변경할 테이블명;
        - RENAME 기존 테이블명 TO 변경할 테이블명;
*/
-- DEPT_COPY 테이블의 이름을 DEPT_TEST로 변경
    -- 1) ALTER TABLE 방법
        ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;
    -- 2) RENAME 방법
        RENAME DEPT_COPY TO  DEPT_TEST;




/*                                                              221222 3교시 07_DDL(CREATE,ALTER,DROP)
    < DROP >
        데이터베이스 객체(테이블, 인덱스, 뷰 등)를 삭제하는 구문이다.
*/
-- DEPT_TEST 테이블 삭제
    DROP TABLE DEPT_TEST;

-- MEMBER_GRADE 테이블 삭제
-- 참조되고 있는 부모 테이블은 함부로 삭제가 되지 않는다. 참조하고 있는 자식테이블이 있기 때문에
    DROP TABLE MEMBER_GRADE;        -- unique/primary keys in table referenced by foreign keys 에러 발생

-- 만약에 부모 테이블을 삭제하고자 한다면
    -- 1) 자식 테이블을 먼저 삭제한 후 부모 테이블을 삭제한다.
        DROP TABLE MEMBER;          -- 자식 테이블
        DROP TABLE MEMBER_GRADE;    -- 부모 테이블

    -- 2) 부모 테이블을 삭제할 때 자식 테이블에 걸려 있던 FOREIGN KEY 제약조건도 함께 삭제한다. 옵션 지정 삭제
        DROP TABLE MEMBER_GRADE CASCADE CONSTRAINTS;
-- CASCADE CONSTRAINTS 삭제되는 테이블 MEMBER_GRADE와 참조 관계에 있던 MEMBER 테이블의 GRADE_ID 컬럼의 FOREIGN KEY 제약조건 삭제됨!!!!!!!!                                       !!!!!!!!!!!!!!

