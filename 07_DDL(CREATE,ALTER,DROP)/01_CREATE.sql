/*                                                              221220 6교시 07_DDL(CREATE,ALTER,DROP)
    < DDL(Data Definition Language) >
        데이터 정의 언어로 오라클에서 제공하는 객체를 만들고(CREATE), 변경(ALTER)하고, 삭제(DROP)하는 등
        실제 데이터 값이 아닌 데이터의 구조를 정의하는 언어이다.


    < CREATE >
        데이터베이스 객체(테이블, 인덱스, 뷰, 함수 등, ...)를 생성하는 구문이다.
        
        <테이블 생성>
            [표현법]
                CREATE TABLE 테이블명 (
                    컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
                    컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
                    컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
                    ...
                );
*/
-- 회원에 대한 데이터를 담을 수 있는 MEMBER 테이블 생성
    CREATE TABLE MEMBER(
        ID VARCHAR2(20),
        PASSWORD VARCHAR2(20),
        NAME VARCHAR2(15),
        ENROLL_DATE DATE DEFAULT SYSDATE/*DERAULT 기본값 > 값이 들어가지 않았을 때 기본으로 넣는 데이터*/
    );


    DROP TABLE MEMBER;  /*잘못 만든 테이블 삭제하는 쿼리문*/


-- DESC MEMBER : 테이블의 구조를 표시해주는 구문.
    DESC MEMBER;

    SELECT * FROM MEMBER;   -- MEMBER 테이블 조회


-- USER TABLES : 사용자가 가지고 있는 테이블들의 구조를 확인하는 뷰 테이블이다.
    SELECT *
    FROM USER_TABLES;


-- USER_TAB_COLMNS : 사용자가 가지고 있는 테이블, 뷰의 컬럼과 관련된 정보를 조회하는 뷰 테이블이다.
    SELECT *
    FROM USER_TAB_COLUMNS;



/*                                                              221220 6교시 07_DDL(CREATE,ALTER,DROP)
    <CREATE>
        데이터베이스 객체(테이블, 인덱스, 뷰, 함수 등, ...)를 생성하는 구문이다.
        
        <컬럼 주석>
            [표현법]
                COMMENT ON COLUMN 테이블명.컬럼명 IS '주석 내용';
*/
COMMENT ON COLUMN MEMBER.ID IS '회원 아이디';                            -- ctrl enter 문장별로 다 해줘야 함
COMMENT ON COLUMN MEMBER.PASSWORD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원 가입일';


-- 테이블에 샘플 데이터 추가(INSERT)                                                                               221220 7교시
    -- INSERT INTO 테이블명[(컬럼명, ..., 컬럼명)] VALUES (값, ..., 값);
        -- 컬럼명 명시하면 명시된 컬럼에만 데이터 추가, 컬럼명 생략하면 모든 컬럼에 데이터 추가
        -- 값은 앞에서 컬럼명 명시했을 때 그 순서에 맞게 적으면 되고 컬럼명 생략시 모든 컬럼명 순서에 맞게 적기

    INSERT INTO MEMBER VALUES ('USER1', '1234', '문인수', '2022-12-20');   -- 컬럼명 생략한 경우. 모든 컬럼명 순서에 맞게 값 추가
    INSERT INTO MEMBER VALUES ('USER2', '5678', '홍길동', SYSDATE);        -- INSERT 작업시 날짜데이터는 리터럴뿐만 아니라 SYSDATE 사용 가능
    INSERT INTO MEMBER(ID, PASSWORD, NAME, ENROLL_DATE) VALUES ('USER3', '9999', '이몽룡', DEFAULT);  -- INSERT 작업시 날짜데이터는 리터럴뿐만 아니라 DEFAULT도 사용 가능 디폴트시 앞서 지정해둔 디폴트값 들어감 ex)여기선 SYSDATE
    INSERT INTO MEMBER(ID, PASSWORD) VALUES('USER4', '0000');               -- DEFAULT 안 적어주고 아예 생략해도 값이 없어서 DEFAULT가 실행돼 SYSDATE가 자동으로 들어간다.

    SELECT * FROM MEMBER;


-- COMMIT > 위에서 추가(INSERT 메모리 버퍼에 임시 저장)한 데이터를 실제 테이블에 반영한다. 확정
    COMMIT;         -- COMMIT을 하고서는 ROLLBACK을 해도 삭제되지 않음 완전히 확정된 거기 때문에
                    -- INSERT만 해서는 다른 계정에서 볼 수 없음 COMMIT을 해야 다른 계정에서 볼 수 있음


    ROLLBACK;       -- 내가 수행한 DML(데이터 추가 삭제 수정....) 작업들 되돌리는 기능


    SHOW AUTOCOMMIT;    -- 오토커밋 상태 보는 쿼리문       오토커밋은 꺼놓는 게 좋음 원활한 수정을 위하여 
    SET AUTOCOMMIT ON;  -- 오토커밋 켜는 쿼리문
    SET AUTOCOMMIT OFF; -- 오토커밋 끄는 쿼리문



/*                                                              221220 7교시 07_DDL(CREATE,ALTER,DROP)
    <제약 조건(CONSTRAINTS)>
    - 사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 저장될 값에 대한 제약 조건을 설정할 수 있다.
    - 제약조건은 데이터 무결성 보장을 목적으로 한다.(데이터 무결성 = 데이터의 정확성과 일관성을 유지시키는 것)
        
        제약조건 종류
        1) NOT NULL
        2) UNIQUE
        3) CHECK
        4) PRIMARY KEY
        5) FOREIGN KEY
        
            [표현법]
             1) 컬럼 레벨
                CREATE TABLE 테이블명(
                    컬럼명 자료형(크기) [CONSTRAINTS 제약조건명] 제약조건,
                    ...
                );
                
              2) 테이블 레벨
                CREATE TABLE 테이블명(
                    컬럼명 자료형(크기),
                    컬럼명 자료형(크기),
                    ...
                    [CONSTRAINTS 제약조건명] 제약조건 (컬럼명)
                );
        
        1. NOT NULL 제약 조건
            - 해당 컬럼에 반드시 값이 있어야 하는 경우에 사용한다.
            - NOT NULL 제약 조건은 반드시 컬럼 레벨에서만 설정이 가능하다.
*/

-- 기존 MEMBER 테이블(NOT NULL 제약 조건 설정 안 한 테이블)은 값에 NULL이 있어도 행의 삽입이 가능하다.
    INSERT INTO MEMBER VALUES (NULL, NULL, NULL, NULL);
        -- 실행하면 모든 컬럼값이 NULL인 행이 삽입됨
    SELECT * FROM MEMBER;
        
        
-- NOT NULL 제약 조건을 설정한 테이블 생성
    DROP TABLE MEMBER;  -- 위 NULL값 행 들어가서 테이블 삭제

    CREATE TABLE MEMBER(
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        ENROLL_DATE DATE DEFAULT SYSDATE
    );
        -- MEMBER 테이블의 열 가보면 NULLABLE에 NO 뜨는 거 확인 가능함


    -- NOT NULL 제약 조건에 위배되어 오류가 발생함
    INSERT INTO MEMBER VALUES (NULL, NULL, NULL, NULL);         
    INSERT INTO MEMBER VALUES ('USER1', NULL, NULL, NULL);


    -- NOT NULL 제약 조건이 걸려있는 컬럼에서는 반드시 값이 있어야 한다.
    INSERT INTO MEMBER VALUES ('USER1', '1234', '문인수', NULL);   -- ? ENFROLL_DATE 컬럼은 DEFAULT가 SYSDATE인데? > NULL도 값임! NULL을 명시적으로 준 것이라고 생각하면 됨!!!!!!!!!!!!!!!!!!!!!!
                                                                    -- DEFAULT 설정을 작동시키려면 아예 생략을 하거나 DEFAULT라고 명시해줘야함
    INSERT INTO MEMBER VALUES ('USER2', '5678', '홍길동', SYSDATE);
    INSERT INTO MEMBER(ID, PASSWORD, NAME, ENROLL_DATE) VALUES ('USER3', '9999', '이몽룡', DEFAULT);   -- ENROLL_DATE 컬럼 DEFAULT 지정
    INSERT INTO MEMBER(ID, PASSWORD, NAME) VALUES('USER4', '0000', '진도준');                          -- ENROLL_DATE 컬럼 아예 비워서 자동으로 DEFAULT 작동


-- 테이블의 데이터를 수정하는 SQL 구문 (나중에 다시 제대로 배울 것)                                          221220 8교시
    UPDATE MEMBER             -- UPDATE 테이블명
    SET ID = NULL             -- 바꾸려는 컬럼 값
    WHERE NAME = '문인수';     -- 조건 안 주면 테이블의 모든 ID 다 바꿔버림 조건을 걸어줘야 함
        -- NULL값으로 바꾸려니 에러 발생. NOT NULL 제약 조건이 걸려있기 때문에

    SELECT * FROM MEMBER;


-- 제약조건 확인
    -- 사용자가 작성한 제약 조건을 확인하는 뷰 테이블이다. (테이블 네임, 서치 컨디션으로 확인)
    SELECT *
    FROM USER_CONSTRAINTS;

    -- 사용자가 작성한 제약 조건이 걸려있는 컬럼을 확인하는 뷰 테이블이다.
    SELECT *
    FROM USER_CONS_COLUMNS;




/*                                                              221220 8교시 07_DDL(CREATE,ALTER,DROP)
    <제약 조건(CONSTRAINTS)>
    - 사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 저장될 값에 대한 제약 조건을 설정할 수 있다.
    - 제약조건은 데이터 무결성 보장을 목적으로 한다.(데이터 무결성 = 데이터의 정확성과 일관성을 유지시키는 것)
        
        2. UNIQUE 제약 조건
            - 컬럼에 중복된 값을 저장하거나 중복된 값으로 수정할 수 없도록 한다.
            - UNIQUE 제약조건은 컬럼 레벨, 테이블 레벨에서 모두 설정이 가능하다.
*/

    INSERT INTO MEMBER VALUES ('USER11', '1234', '문인수', DEFAULT);
    INSERT INTO MEMBER VALUES ('USER11', '1234', '문인수', DEFAULT);
    SELECT * FROM MEMBER;
        -- 아이디가 중복이 되어도 성공적으로 삽입이 됨 > 실생활에서는 아이디가 중복되면 안 됨 > 이럴 때 필요한 게 UNIQUE 제약 조건


-- UNIQUE 제약 조건을 설정한 테이블 생성( (1) 컬럼레벨에 조건 걸기 )
    DROP TABLE MEMBER;      -- UNIQUE 걸기 위해 중복 데이터 있는 테이블 삭제

    CREATE TABLE MEMBER(
        ID VARCHAR2(20) NOT NULL UNIQUE,                -- 한 컬럼에 여러 개의 제약 조건을 걸 수 있음
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        ENROLL_DATE DATE DEFAULT SYSDATE
    );                  -- 생성 후 MEMBER 테이블에서 열, 데이터,,, "제약조건" 들어가서 제약조건 걸렸는지 확인해보기 

    -- UNIQUE 제약 조건에 위배되었으므로 INSERT에 실패
    INSERT INTO MEMBER VALUES ('USER11', '1234', '문인수', DEFAULT);
            -- 두 번 실행하면 첫 번째는 성공, 두 번째는 에러 발생 이유. 아이디가 동일
    INSERT INTO MEMBER VALUES ('USER11', '1234', '성춘향', DEFAULT);
            -- 이름 바꿔도 에러 발생 이유. 아이디가 동일

-- UNIQUE 제약 조건을 설정한 테이블 생성( (2) 테이블레벨에 조건 걸기 AND 제약조건에 이름 생성 )
    DROP TABLE MEMBER;

    CREATE TABLE MEMBER(
        ID VARCHAR2(20) CONSTRAINT MEMBER_ID_NN NOT NULL,                   -- 제약 조건 이름 작성 표현법   > CONSTRAINT 이름 제약조건 > CONSTRAINT MEMBER_ID_NN NOT NULL 
        PASSWORD VARCHAR2(20) CONSTRAINT MEMBER_PASSWORD_NN NOT NULL,
        NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID)                                  -- 테이블 레벨에 제약 조건 걸기 > 제약조건(조건 걸 컬럼명)
    ); 

    -- UNIQUE 제약조건에 위배되었으므로 INSERT 실패
    INSERT INTO MEMBER VALUES ('USER11', '1234', '문인수', DEFAULT);
            -- 두 번 실행하면 첫 번째는 성공, 두 번째는 에러 발생 이유. 아이디가 동일
    INSERT INTO MEMBER VALUES ('USER11', '1234', '성춘향', DEFAULT);
            -- 얘도 동일하게 에러 나는데 스크립트를 보고 빠르게 에러 찾기 가능함. 이유. 제약 조건에 이름을 설정해줘서 어디서 에러가 났는지 확인 가능 


--여러 개의 컬럼을 묶어서 하나의 UNIQUE 제약 조건으로 설정 (단, 반드시 테이블 레벨로만 설정이 가능)                  221221 1교시 07_DDL(CREATE,ALTER,DROP)
    CREATE TABLE MEMBER(
        NO NUMBER NOT NULL UNIQUE,                      -- NO와 ID가 "각각" UNIQUE 제약 조건이 걸림. MEMBER 테이블의 제약 조건 들어가서 보기
        ID VARCHAR2(20) NOT NULL UNIQUE,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        ENROLL_DATE DATE DEFAULT SYSDATE
    ); 

    SELECT * FROM MEMBER;
    ROLLBACK;

    CREATE TABLE MEMBER(
        NO NUMBER NOT NULL,
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_NO_ID_UQ UNIQUE(NO,ID)       -- 테이블 레벨에서만 설정을 해야 여러 컬럼을 묶어서 "하나"의 UNIQUE 제약 조건으로 설정할 수가 있음
    );

    SELECT * FROM MEMBER;


    /* 여러 컬럼을 묶어서 UNIQUE 제약 조건을 설정하면
       제약 조건이 설정되어 있는 컬럼 값이 "모두" 중복되는 경우에만 오류가 발생한다.*/
    INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '문인수', DEFAULT);
    INSERT INTO MEMBER VALUES(2, 'USER1', '1234', '성춘향', DEFAULT);      -- 아이디가 중복되는데 왜 삽입이 되는거지? NO와 ID를 "각각" 보는 게 아니라 NO, ID를 "한 세트"로 보고 같은지 다른지 비교함
    INSERT INTO MEMBER VALUES(2, 'USER1', '1234', '홍길동', DEFAULT);      -- 에러 발생 UNIQUE가 설정된 "NO,ID 세트"가 같기 때문에 삽입 안 됨

    DROP TABLE MEMBER;

    CREATE TABLE MEMBER(
        NO NUMBER NOT NULL,
        ID VARCHAR2(20) CONSTRAINT MEMBER_ID_NN NOT NULL,
        PASSWORD VARCHAR2(20) CONSTRAINT MEMBER_PASSWORD_NN NOT NULL,
        NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID)
    ); 



/*                                                              221221 2교시 07_DDL(CREATE,ALTER,DROP)
    <제약 조건(CONSTRAINTS)>
    - 사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 저장될 값에 대한 제약 조건을 설정할 수 있다.
    - 제약조건은 데이터 무결성 보장을 목적으로 한다.(데이터 무결성 = 데이터의 정확성과 일관성을 유지시키는 것)
        
        3. CHECK 제약 조건
            - 컬럼에 기록되는 값에 조건을 설정하고 조건을 만족하는 값만 저장하거나 수정하도록 한다.
                ex) 나이 컬럼에 음수 들어가지 않게, 성별 컬럼에 남녀만 들어가게, ...
            - 비교 연산자를 이용하여 조건을 설정하며 비교 값을 리터럴만 사용 가능하고 변하는 값이나 함수 사용할 수 없다
            - CHECK 제약조건은 컬럼 레벨, 테이블 레벨에서 모두 설정이 가능하다.
            
            CHECK (조건식)     - 여러가지 비교 연산자 사용해서 설정. 함수 호출 구문은 사용 불가!
                CHECK (컬럼 [NOT] IN(값, 값, ...))
                CHECK (컬럼 = 값)
                CHECK (컬럼 BETWEEN 값 AND 값)
                CHECK (컬럼 LIKE '_문자')
                ...
*/
    DROP TABLE MEMBER;

    CREATE TABLE MEMBER(
        NO NUMBER NOT NULL,
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3),
        AGE NUMBER,
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID)
    ); 
    -- 테이블 생성하고 MEMBER 테이블의 열 들어가서 GENDER, AGE 잘 들어갔나 확인


    -- 유효하지 않은 값들도 성별, 나이에 INSERT 된다. 식 조건에는 문제가 안 되나 문맥상 유효하지 않음 . ex) 성별이 강 X. 나이가 -20살 X
    INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '문인수', '남', 21, DEFAULT);
    INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '성춘향', '여', 16, DEFAULT);
    INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '홍길동', '강', 30, DEFAULT);     -- '강'      > 3BYTE의 문자 데이터라서 문제 없이 데이터 삽입 됨
    INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '이몽룡', '남', -20, DEFAULT);    -- '-20'     > 숫자 데이터라서 문제 없이 데이터 삽입 됨
    SELECT * FROM MEMBER;


-- CHECK 제약조건을 설정한 테이블 생성
    DROP TABLE MEMBER;

    CREATE TABLE MEMBER(
        NO NUMBER NOT NULL,
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3) CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),     -- 컬럼 레벨에 GENDER 컬럼 CHECK 제약 조건 설정
        AGE NUMBER,
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
        CONSTRAINT MEMBER_AGE_CK CHECK(AGE  > 0)                                      -- 테이블 레벨에 AGE컬럼 CHECK 제약 조건 설정
    ); 

    INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '문인수', '남', 21, DEFAULT);
    INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '성춘향', '여', 16, DEFAULT);
    INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '홍길동', '강', 30, DEFAULT);     -- 성별에는 남 또는 여만 가능 
        -- GENDER 컬럼에 CHECK 제약 조건으로 '남' 또는 '여'만 입력 가능하도록 설정이 되었기 때문에 에러가 발생한다.
    INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '이몽룡', '남', -20, DEFAULT);     -- 음수는 불가능
        -- AGE 컬럼에 CHECK 제약 조건으로 0 보다 큰 값만  입력 가능하도록 설정이 되었기 때문에 에러가 발생한다.

    SELECT * FROM MEMBER;
    COMMIT;

-- 컬럼 수정에서도 제약 조건에 어긋나는 값을 넣으려 하면 에러 발생해서 수정 불가함
    UPDATE MEMBER
    SET GENDER = '약'         -- 변경하려고 하는 컬럼의 값
    WHERE NAME = '문인수';     -- 조건식 

    UPDATE MEMBER
    SET AGE = -10             -- 변경하려고 하는 컬럼의 값
    WHERE NAME = '문인수';     -- 조건식 



/*                                                              221221 2교시 07_DDL(CREATE,ALTER,DROP)
    <제약 조건(CONSTRAINTS)>
    - 사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 저장될 값에 대한 제약 조건을 설정할 수 있다.
    - 제약조건은 데이터 무결성 보장을 목적으로 한다.(데이터 무결성 = 데이터의 정확성과 일관성을 유지시키는 것)
        
        4. PRIMARY KEY(기본 키) 제약 조건
            - 테이블에서 한 행의 정보를 식별하기 위해 사용할 컬럼에 부여하는 제약조건이다.
            - PRIMARY KEY 제약조건을 설정하게 되면 자동으로 해당 컬럼에 NOT NULL, UNIQUE 제약조건이 걸린다.
            - PRIMARY KEY 제약조건은 컬럼 레벨, 테이블 레벨에서 모두 설정이 가능하다.
*/
    DROP TABLE MEMBER;

-- 컬럼 레벨에 PRIMARY KEY 제약 조건 거는 방식
    CREATE TABLE MEMBER(
        NO NUMBER CONSTRAINT MEMBER_NO_PK PRIMARY KEY,          -- 컬럼 레벨에 PRIMARY KEY 제약 조건 거는 방식
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3) CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
        AGE NUMBER,
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
        CONSTRAINT MEMBER_AGE_CK CHECK(AGE  > 0)
    ); 

    INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '문인수', '남', 21, DEFAULT);
    INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '성춘향', '여', 16, DEFAULT);
    INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '홍길동', '남', 30, DEFAULT);
    INSERT INTO MEMBER VALUES(3, 'USER4', '1234', '이몽룡', '남', 20, DEFAULT);
        -- 기본 키 중복으로 에러 발생
    INSERT INTO MEMBER VALUES(NULL, 'USER4', '1234', '이몽룡', '남', 20, DEFAULT);
        -- 기본 키가 NULL 이므로 에러 발생

    SELECT * FROM MEMBER;

    DROP TABLE MEMBER;


-- 테이블 레벨에 PRIMARY KEY 제약 조건 거는 방식  (여러 개의 컬럼을 하나로 묶어서)                                          221221 3교시
    CREATE TABLE MEMBER(
--          NO NUMBER PRIMARY KEY,                                    -- 이렇게 걸면 "각각" PRIMARY KEY 제약 조건 걸림
--          ID VARCHAR2(20) PRIMARY KEY,
        NO NUMBER,
        ID VARCHAR2(20),
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3),
        AGE NUMBER,
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_NO_ID_PK PRIMARY KEY(NO, ID),             -- NO, ID 묶어서 "하나의 PRIMARY KEY" 제약 조건 설정
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
        CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
        CONSTRAINT MEMBER_AGE_CK CHECK(AGE  > 0)
    ); 

    SELECT * FROM MEMBER;

    INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '문인수', '남', 21, DEFAULT);
    INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '성춘향', '여', 16, DEFAULT);
    INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '홍길동', '남', 30, DEFAULT);
    INSERT INTO MEMBER VALUES(3, 'USER4', '1234', '이몽룡', '남', 20, DEFAULT);     -- 삽입 성공 PRIMARY KEY 묶어서 걸었기 때문에 NO가 같아도 ID는 달라서 삽입이 가능
    INSERT INTO MEMBER VALUES(3, 'USER4', '1234', '심청이', '여', 16, DEFAULT);     -- 삽입 실패 PRIMARY KEY 묶어서 걸었기 때문에 NO, ID 둘 다 같아서 삽입이 불가능
        -- 회원번호, 아이디가 동일한 값이 이미 존재하기 때문에 에러가 발생한다.
    INSERT INTO MEMBER VALUES(NULL, 'USER4', '1234', '심청이', '여', 16, DEFAULT);
    INSERT INTO MEMBER VALUES(3, NULL, '1234', '심청이', '여', 16, DEFAULT);
    INSERT INTO MEMBER VALUES(NULL, NULL, '1234', '심청이', '여', 16, DEFAULT);
        -- 기본키로 설정된 컬럼에 NULL 값이 있으면 에러가 발생한다. NOT NULL은 묶은거 상관없이 제약 조건 건 컬럼 중 하나만 NULL이라도 삽입이 안 됨. 위의 세 행 모두 에러 발생

    SELECT * FROM MEMBER;



/*                                                              221221 3교시 07_DDL(CREATE,ALTER,DROP)
    <제약 조건(CONSTRAINTS)>
    - 사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 저장될 값에 대한 제약 조건을 설정할 수 있다.
    - 제약조건은 데이터 무결성 보장을 목적으로 한다.(데이터 무결성 = 데이터의 정확성과 일관성을 유지시키는 것)
        
        5. FOREIGN KEY(외래 키) 제약 조건
            - 외래 키는 다른 테이블을 참조하는 역할을 하며 외래 키를 통해 테이블 간의 관계를 형성 할 수 있다. (테이블 간 연결고리 역할)
            - 다른 테이블에 존재하는 값만을 가져야 하는 컬럼에 부여하는 제약조건이다. (단, NULL 값도 가질 수 있다)
            - 외래 키가 정의되어 있는 테이블 = 자식 테이블, 외래 키가 참조하는 테이블 = 부모 테이블
            - 참조되는 컬럼은 PK(PRIMARY KEY)이거나 UK(Unique key)만 가능하다.
            - FOREIGN KEY 제약조건은 컬럼 레벨, 테이블 레벨에서 모두 설정이 가능하다.
            
            [표현법]
            1) 컬럼 레벨 방식으로 지정
                컬럼명 자료형(크기) [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명[(컬럼명)] [삭제룰]
            
            2) 테이블 레벨 방식으로 지정
                [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(컬럼명)] [삭제룰]
                
            [삭제룰]
                부모 테이블의 데이터가 삭제됐을 때의 옵션
            1) ON DELETE RESTRICT : 자식 테이블의 참조키가 부모 테이블의 기본키 값을 참조하는 경우 부모 테이블의 행을 삭제할 수 없다. (기본값)
            2) ON DELETE SET NULL : 부모 테이블의 데이터 삭제 시 참조하고 있는 자식 테이블의 참조키 값이 NULL로 변경된다.
            3) ON DELETE CASCADE  : 부모 테이블의 데이터 삭제 시 참조하고 있는 자식 테이블의 참조키 값이 존재하는 행 전체가 삭제된다.
                    - 실제로 기본옵션 말고는 잘 사용하지 않음 이유! 데이터는 소중한 자산 회사는 데이터 삭제하는 것을 좋아하지 않음
*/
-- 회원 등급에 대한 데이터를 저장하는 테이블 생성 (부모 테이블)

    CREATE TABLE MEMBER_GRADE(
        GRADE_CODE NUMBER PRIMARY KEY,
        GRADE_NAME VARCHAR2(30) NOT NULL
    );      -- 하고서 PRIMARY KEY, NOT NULL 제약 조건 잘 걸렸나 데이터 열 제약조건 들어가서 보기
    SELECT * FROM MEMBER_GRADE;

    INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
    INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
    INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');

    SELECT * FROM MEMBER_GRADE;


-- FOREIGH KEY 제약 조건을 설정한 테이블 설정 (자식 테이블)

    DROP TABLE MEMBER;

    CREATE TABLE MEMBER(
        NO NUMBER,  
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3),
        AGE NUMBER,
        GRADE_ID NUMBER,            -- MEMBER_GRADE 테이블의 GRADE_CODE컬럼 참조(외래키 제약조건)할 거라서 같은 데이터 타입으로 만들어야 함 그래서 NUMBER 데이터 타입
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),                                        --  r 생략 가능 > 생략 시 자동으로 부모 테이블의 기본 키(PRIMARY KEY)로 연결. 적어주면 어느 컬럼과 연결할지 지정(PK나 UQ와만 가능)
        CONSTRAINT MEMBER_GRADE_ID_FK FOREIGN KEY(GRADE_ID) REFERENCES MEMBER_GRADE/*(GRADE_CODE)*/,    -- GRADE_ID를 가지고 MEMBER_GRADE테이블의 GRADE_CODE 참조할 거라는 뜻
        CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
        CONSTRAINT MEMBER_AGE_CK CHECK(AGE  > 0)
    ); 

-- 221221 4교시                                                                                                                               221221 4교시
    INSERT INTO MEMBER VALUES(1, 'UESR1', '1234', '문인수', '남', 22, 10, DEFAULT);     -- GRADE_ID는 MEMBER_GRADE의 GRADE_CODE와 동일해야 함
    INSERT INTO MEMBER VALUES(2, 'UESR2', '1234', '홍길동', '남', 30, 50, DEFAULT);     -- 부모테이블의 기본 키 GRADE_CODE에 없는 값인 50을 넣어서 에러 발생
        -- 50이라는 값이 MEMBER_GRADE 테이블의 GRADE_CODE 컬럼에서 제공하는 값이 아니므로 외래 키 제약 조건에 위배되어 에러가 발생한다.
    INSERT INTO MEMBER VALUES(2, 'UESR2', '1234', '홍길동', '남', 30, NULL, DEFAULT);   -- 외래 키 NULL 값은 가능하다.
        -- GRADE_ID 컬럼에 NULL 값은 사용 가능하다.

    SELECT * FROM MEMBER_GRADE;
    SELECT * FROM MEMBER;


-- MEMBER 테이블과 MEMBER_GRADE 테이블을 조인하여 ID, NAME, GRADE_NAME 조회
    -- ANSI 구문
    SELECT M.ID, M.NAME, G.GRADE_NAME
    FROM MEMBER M
    LEFT JOIN MEMBER_GRADE G ON (M.GRADE_ID = G.GRADE_CODE);    -- MEMBER 테이블에서 외래키 역할 하는 GRADE_ID컬럼과 MEMBER_GRADE 테이블의 기본키 역할을 하는 GRADE_CODE컬럼 JOIN
    -- ORACLE 구문
    SELECT M.ID, M.NAME, G.GRADE_NAME
    FROM MEMBER M, MEMBER_GRADE G
    WHERE M.GRADE_ID = G.GRADE_CODE(+);    

COMMIT;

-- 행을 지우는 명령
    -- MEMBER_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기
        -- DELETE FROM MEMBER_GRADE;       -- 이렇게만 쓰면 MEMBER_GRADE 테이블의 데이터 다 지워짐
    DELETE FROM MEMBER_GRADE
    WHERE GRADE_CODE = 10;          -- child record found 에러발생, 자식 테이블에서 값을 참조하고 있어서 삭제 안 됨
        -- 자식 테이블의 행들 중에 10을 사용하는 행이 있기 때문에 삭제할 수 없다.
    
    -- MEMBER_GRADE 테이블에서 GRADE_CODE가 30인 데이터 지우기
    DELETE FROM MEMBER_GRADE
    WHERE GRADE_CODE = 30;          -- 삭제 가능
        -- 자식 테이블의 행들 중에 30을 사용하는 행이 없기 때문에 삭제할 수 있다.

ROLLBACK;


-- ON DELETE SET NULL 옵션이 추가된 자식 테이블 생성
    DROP TABLE MEMBER;

    CREATE TABLE MEMBER(
        NO NUMBER,  
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3),
        AGE NUMBER,
        GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE(GRADE_CODE) ON DELETE SET NULL,       -- 삭제룰 ON DELETE SET NULL 추가
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
        CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
        CONSTRAINT MEMBER_AGE_CK CHECK(AGE  > 0)
    );

    INSERT INTO MEMBER VALUES(1, 'UESR1', '1234', '문인수', '남', 22, 10, DEFAULT);
    INSERT INTO MEMBER VALUES(2, 'UESR2', '1234', '홍길동', '남', 30, NULL, DEFAULT);

    SELECT * FROM MEMBER_GRADE;
    SELECT * FROM MEMBER;

COMMIT;

    DELETE FROM MEMBER_GRADE
    WHERE GRADE_CODE = 10;

    SELECT * FROM MEMBER_GRADE;
    SELECT * FROM MEMBER;                   -- 문인수의 GRADE_ID가 NULL로 바뀜
        -- 부모 테이블의 값이 문제없이 행이 삭제되는 것을 확인할 수 있다.
        -- 단, 자식 테이블을 조회해 보면 삭제된 행을 참조하고 있던 컬럼의 값이 NULL로 변경된 것을 확인할 수 있다.
    
    ROLLBACK;


-- ON DELETE CASCADE 옵션이 추가된 자식 테이블 생성
    DROP TABLE MEMBER;

    CREATE TABLE MEMBER(
        NO NUMBER,  
        ID VARCHAR2(20) NOT NULL,
        PASSWORD VARCHAR2(20) NOT NULL,
        NAME VARCHAR2(15) NOT NULL,
        GENDER CHAR(3),
        AGE NUMBER,
        GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE(GRADE_CODE) ON DELETE CASCADE,       -- 삭제룰 ON DELETE CASCADE 추가
        ENROLL_DATE DATE DEFAULT SYSDATE,
        CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
        CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
        CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
        CONSTRAINT MEMBER_AGE_CK CHECK(AGE  > 0)
    );

    INSERT INTO MEMBER VALUES(1, 'UESR1', '1234', '문인수', '남', 22, 10, DEFAULT);
    INSERT INTO MEMBER VALUES(2, 'UESR2', '1234', '홍길동', '남', 30, NULL, DEFAULT);
    INSERT INTO MEMBER VALUES(3, 'UESR3', '1234', '이몽룡', '남', 22, 10, DEFAULT);

    SELECT * FROM MEMBER_GRADE;
    SELECT * FROM MEMBER;

COMMIT;

    DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 10;

    SELECT * FROM MEMBER_GRADE;
    SELECT * FROM MEMBER;                   -- GRADE_CODE가 10인 문인수, 이몽룡 행 자체가 삭제됨 
        -- 부모 테이블의 값이 문제없이 행이 삭제되는 것을 확인할 수 있다.
        -- 단, 자식 테이블을 조회해 보면 삭제된 행을 참조하고 있던 컬럼의 행들이 모두 삭제된 것을 확인할 수 있다.

ROLLBACK;


-- 사용자가 작성한 제약조건을 확인하는 뷰 테이블이다.
SELECT UC.CONSTRAINT_NAME,
       UC.TABLE_NAME,
       UCC.COLUMN_NAME,
       UCC.POSITION,
       UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC
INNER JOIN USER_CONS_COLUMNS UCC ON (UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UC.TABLE_NAME = 'MEMBER';





/*                                                              221221 5교시 07_DDL(CREATE,ALTER,DROP)
    <서브 쿼리를 이용한 테이블 생성>
    - 서브 쿼리를 이용해서 SELECT의 조회 결과로 테이블을 생성하는 구문이다.
    - 컬럼명과 데이터 타입, 값이 복사되고, 제약조건은 NOT NULL만 복사된다
*/
-- EMPLOYEE 테이블을 복사한 새로운 테이블 생성(컬럼, 데이터 타입, 값, NOT NULL(제약조건은 NOT NULL만!) 복사됨)
    CREATE TABLE EMP_COPY
    AS SELECT *
       FROM EMPLOYEE;
        -- 테이블 열 들어가서 보면 주석, 디폴트, EMP_ID의 프라이머리키도 없음 > 복사되지 않았다

SELECT * FROM EMP_COPY;

-- MEMBER 테이블을 복사한 새로운 테이블 생성
    CREATE TABLE MEM_COPY
    AS SELECT *
       FROM MEMBER;
        -- 디폴트, 프라이머리키, 유니크, 외래키, 체크 제약조건 다(NOT NULL 제약조건 제외 모든 제약조건) 다 사라짐
   
SELECT * FROM MEM_COPY;

DROP TABLE EMP_COPY;
DROP TABLE MEM_COPY;


-- EMPLOYEE 테이블을 복사한 새로운 테이블 생성 (컬럼, 데이터 타입, NOT NULL 제약 조건을 > 복사 테이블의 "구조"만 복사)
    CREATE TABLE EMP_COPY
    AS SELECT *
       FROM EMPLOYEE
       WHERE 1 = 0;     -- SELECT ~ 문에 있는 모든 행들에 WHERE 조건절 수행 1 = 0은 항상 FALSE라서 맞는 행이 없어가지고 아무런 행도 조회되지 않음
                        -- 데이터는 복사되지 않고 테이블의 구조만 복사된다.

SELECT * FROM EMP_COPY;

DROP TABLE EMP_COPY;


-- EMPLOYEE 테이블에서 사번, 직원명, 급여, 연봉을 저장하는 새로운 복사 테이블 생성
    CREATE TABLE EMP_COPY
    AS SELECT EMP_ID AS "직원명",
              EMP_NAME AS "이름",
              SALARY AS "급여",
              SALARY * 12 AS "연봉"
       FROM EMPLOYEE;       -- (별칭 적기 전) 에러 발생 이유? 산술 연산이나 함수 호출 구문이 기술된 경우 별칭 정해줘야함

SELECT * FROM EMP_COPY;

DROP TABLE EMP_COPY;


------------------------------- 실습 문제 221221 5교시--------------------------------------------------------------------------------------------------


-- 도서 관리 프로그램을 만들기 위한 테이블 만들기
-- 이때, 제약 조건에 이름을 부여하고, 각 컬럼에 주석 달기

-- 1. 출판사들에 대한 데이터를 담기 위한 출판사 테이블 (테이블명 TB_PUBLISHER)
--  1) 컬럼   :   PUB_NO(주석 출판사 번호)   -- 기본 키
--               PUB_NAME(출판사명)         -- NOT NULL
--               PHONE(출판사 전화번호)
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER,
    PUB_NAME VARCHAR2(20) CONSTRAINT TB_PUBLISHER_PUB_NAME_NN NOT NULL,
    PHONE VARCHAR2(30),
    CONSTRAINT TB_PUBLISHER_PUB_NO_PK PRIMARY KEY(PUB_NO)
);

COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사 번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사 전화번호';

SELECT * FROM TB_PUBLISHER;

--  2) 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_PUBLISHER VALUES(1, '민음사', '02-1234-5678');
INSERT INTO TB_PUBLISHER VALUES(2, '창비', '031-7890-1234');
INSERT INTO TB_PUBLISHER VALUES(3, '시공사', '031-4567-7890');

SELECT * FROM TB_PUBLISHER;


-- 2. 도서들에 대한 데이터를 담기 위한 도서 테이블 (TB_BOOK)
--  1) 컬럼   :   BK_NO(도서번호)            -- 기본 키
--               BK_TITLE(도서명)           -- NOT NULL
--               BK_AUTHOR(저자명)          -- NOT NULL
--               BK_PRICE(가격)
--               BK_PUB_NO(출판사 번호)      -- 외래 키(TB_PUBLISHER 테이블을 참조하도록)
--                                             ㄴ 이때, 참조하고 있는 부모 데이터 삭제시 자식 데이터도 삭제되도록 옵션 지정
CREATE TABLE TB_BOOK(
    BK_NO NUMBER,
    BK_TITLE VARCHAR2(100) CONSTRAINT TB_BOOK_BK_TITLE_NN NOT NULL,
    BK_AUTHOR VARCHAR2(50) CONSTRAINT TB_BOOK_BK_AUTHOR_NN NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER,
    CONSTRAINT TB_BOOK_BK_NO_PK PRIMARY KEY(BK_NO),
    CONSTRAINT TB_BOOK_BK_PUB_NO_FK FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER ON DELETE CASCADE
);                      -- ㄴ 기본적으로 외래키는 참조하려는 컬럼이랑 같은 데이터 타입으로 설정함. 참조할 컬럼 설정 안 하면 기본키 설정 컬럼을 참조함

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사 번호';

SELECT * FROM TB_BOOK;

--  2) 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_BOOK VALUES(101, '내 이름은 정수 조장이죠', '이정수', 20000, 1);
INSERT INTO TB_BOOK VALUES(202, '민지는 민초가 싫어', '공민지', 15000, 3);
INSERT INTO TB_BOOK VALUES(303, '나는 언니가 아니야', '전오현', 18000, 2);
INSERT INTO TB_BOOK VALUES(404, '내사랑 피코크 초코과자', '박소현', 22000, 2);
INSERT INTO TB_BOOK VALUES(505, '물결표 느낌표 물결표 느낌표', '이정훈', 17000, 3);

SELECT * FROM TB_BOOK;

*/
-- 3. 회원에 대한 데이터를 담기 위한 회원 테이블 (TB_MEMBER)
--  1) 컬럼 : MEMBER_NO(회원번호) -- 기본 키
--           MEMBER_ID(아이디)   -- 중복 금지
--           MEMBER_PWD(비밀번호) -- NOT NULL
--           MEMBER_NAME(회원명) -- NOT NULL
--           GENDER(성별)        -- 'M' 또는 'F'로 입력되도록 제한
--           ADDRESS(주소)       
--           PHONE(연락처)       
--           STATUS(탈퇴 여부)     -- 기본값으로 'N' 그리고 'Y' 혹은 'N'으로 입력되도록 제약조건
--           ENROLL_DATE(가입일)  -- 기본값으로 SYSDATE, NOT NULL

CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER,
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(30) CONSTRAINT TB_MEMBER_MEMBER_PWD_NN NOT NULL,
    MEMBER_NAME VARCHAR2(30) CONSTRAINT TB_MEMBER_MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(1),
    ADDRESS VARCHAR2(150),
    PHONE VARCHAR2(20),
    STATUS CHAR(1) DEFAULT 'N',
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT TB_MEMBER_ENROLL_DATE_NN NOT NULL,
    CONSTRAINT TB_MEMBER_MEMBER_NO_PK PRIMARY KEY(MEMBER_NO),
    CONSTRAINT TB_MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_ID),
    CONSTRAINT TB_MEMBER_GENDER_CK CHECK(GENDER IN ('M', 'F')),
    CONSTRAINT TB_MEMBER_STATUS_CK CHECK(STATUS IN ('Y', 'N'))
);

COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴 여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';

SELECT * FROM TB_MEMBER;

--  2) 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_MEMBER VALUES(11, 'JSJS', '1234', '이정수', 'M', '서울특별시 서초구', '010-1234-5678', 'N', DEFAULT);
INSERT INTO TB_MEMBER VALUES(22, 'MJMJ', '5678', '공민지', 'F', '서울특별시 강서구', '010-4567-8910', DEFAULT, '2022-12-20');
INSERT INTO TB_MEMBER VALUES(33, 'JHJH', '8945', '이주희', 'F', '경기도 성남시', '010-7410-8520', 'Y', '2022-01-01');

SELECT * FROM TB_MEMBER;

-- 4. 도서를 대여한 회원에 대한 데이터를 담기 위한 대여 목록 테이블(TB_RENT)
--  1) 컬럼 : RENT_NO(대여번호) -- 기본 키
--           RENT_MEM_NO(대여 회원번호) -- 외래 키(TB_MEMBER와 참조)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_BOOK_NO(대여 도서번호) -- 외래 키(TB_BOOK와 참조)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_DATE(대여일) -- 기본값 SYSDATE

CREATE TABLE TB_RENT (
    RENT_NO NUMBER,
    RENT_MEM_NO NUMBER,
    RENT_BOOK_NO NUMBER,
    RENT_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT TB_RENT_RENT_NO_PK PRIMARY KEY(RENT_NO),
    CONSTRAINT TB_RENT_RENT_MEM_NO_FK FOREIGN KEY(RENT_MEM_NO) REFERENCES TB_MEMBER ON DELETE SET NULL,
    CONSTRAINT TB_RENT_RENT_BOOK_NO_FK FOREIGN KEY(RENT_BOOK_NO) REFERENCES TB_BOOK ON DELETE SET NULL
);

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';        
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여 회원번호';        
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여 도서번호';        
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';        

SELECT * FROM TB_RENT;

--  2) 샘플 데이터 5개 정도 
INSERT INTO TB_RENT VALUES(1, 22, 303, DEFAULT);
INSERT INTO TB_RENT VALUES(2, 22, 101, SYSDATE);
INSERT INTO TB_RENT VALUES(3, 11, 101, '2022-12-14');

SELECT * FROM TB_RENT;

-- 5. 101번 도서를 대여한 회원의 이름, 아이디, 대여일, 반납 예정일(대여일 + 7일)을 조회하시오.
SELECT *
FROM TB_MEMBER, TB_PUBLISHER, TB_BOOK, TB_RENT;

SELECT M.MEMBER_NAME,
       M.MEMBER_ID,
       R.RENT_BOOK_NO,
       R.RENT_DATE,
       R.RENT_DATE + 7
FROM TB_MEMBER M
LEFT JOIN TB_RENT R ON (M.MEMBER_NO = R.RENT_MEM_NO)
WHERE R.RENT_BOOK_NO = 101;

-- 6. 회원번호가 11번인 회원이 대여한 도서들의 도서명, 출판사명, 대여일, 반납예정일을 조회하시오.
SELECT *
FROM TB_MEMBER, TB_PUBLISHER, TB_BOOK, TB_RENT;

SELECT B.BK_TITLE, P.PUB_NAME, R.RENT_DATE, R.RENT_DATE - 7
FROM TB_RENT R
INNER JOIN TB_BOOK B ON (R.RENT_BOOK_NO = B.BK_NO)
INNER JOIN TB_PUBLISHER P ON (B.BK_PUB_NO = P.PUB_NO)
WHERE R.RENT_MEM_NO = 11;


------------------------------------------------------------------------------------------------------------------------------------------------------

