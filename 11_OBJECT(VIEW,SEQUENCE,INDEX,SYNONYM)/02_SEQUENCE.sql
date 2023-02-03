
/*                                                          221227 7교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <SEQUENCE>
    SEQUENCE는 오라클에서 제공하는 객체로 순차적으로 정수 값을 자동으로 생성한다.
    
    CREATE SEQUENCE 시퀀스명
        [START WITH 숫자]     - 처음 발생시킬 시작값을 지정 (기본값 : 1)
        [INCREMENT BY 숫자]   - 다음값에 대한 증가치를 지정 (기본값 : 1)
        [MAXVALUE 숫자]       - SEQUENCE에서 발생시킬 최대값을 지정
        [MINVALUE 숫자]       - SEQUENCE에서 발생시킬 최소값을 지정
        [CYCLE | NOCYCLE]    - 값의 순환 여부를 지정 NOCYCLE 반복 안 함 최대값 생성시 시퀀스 생성 중지 CYCLE 시퀀스의 최대값에 도달시 최소값(NO 시작값)으로 돌아가 다시 시작
        [CACHE | NOCACHE]    - 캐시메모리 사용 여부를 지정 NOCACHE 메모리 할당 사용 안 함 CACHE 캐시를 사용해 메모리에 미리 시퀀스값을 할당해 놓아서 속도가 빠르며 동시 사용자가 많은 경우 유리

    1. SEQUENCE 생성
*/
-- EMPLOYEE 테이블의 PRIMARY KEY값을 생성할 시퀀스 생성
    CREATE SEQUENCE SEQ_EMPID
    START WITH 300
    INCREMENT BY 5
    MAXVALUE 310
    NOCYCLE
    NOCACHE;

-- 현재 유저가 갖고있는 시퀀스 보여주는 쿼리문
    SELECT * FROM USER_SEQUENCES;



/*                                                          221227 8교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <SEQUENCE>
    SEQUENCE는 오라클에서 제공하는 객체로 순차적으로 정수 값을 자동으로 생성한다.
    
    2. SEQUENCE 사용
        - NEXTVAL는 시퀀스 값을 증가시키고 증가된 시퀀스 값을 리턴한다.
        - CURRVAL는 현재 시퀀스의 값을 리턴한다.

        시퀀스명.NEXTVAL;
        시퀀스명.CURRVAL;
*/
-- NEXTVAL를 한 번이라도 수행하지 않으면 CURRVAL를 가져올 수 없다.
-- CURRVAL(커런트 밸류)는 NEXTVAL(넥스트 밸류)를 사용한 후에 사용이 가능함
    SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 에러 발생 NEXTVAL 수행이 안 이루어져서
        
    SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 300 출력
    SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 300 출력 NEXTVAL 수행해서 에러 안 남
    SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 305 출력
    SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 310 출력
    
    -- 지정한 NEXTVAL 값을 초과했기 때문에 에러 발생
    SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 에러 발생
    SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 310 출력



/*                                                          221227 8교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <SEQUENCE>
    SEQUENCE는 오라클에서 제공하는 객체로 순차적으로 정수 값을 자동으로 생성한다.
    
    3. SEQUENCE 수정
    - SEQUENCE 수정 시 ALTER 구문을 사용해서 수정한다.
    - 단, START WITH 값 변경은 불가하기 때문에 변경하려면 삭제 후 다시 생성해야 한다

    ALTER SEQUENCE 시퀀스명
        [INCREMENT BY 숫자]
        [MAXVALUE 숫자]
        [MINVALUE 숫자]
        [CYCLE | NOCYCLE]   
        [CACHE | NOCACHE]   
*/
    ALTER SEQUENCE SEQ_EMPID
--    START WITH 200              -- 에러 발생 START WITH는 한 번 생성하면 변경 불가능. 변경 원하면 삭제 후 재생성 해야 함
    INCREMENT BY 10
    MAXVALUE 400;

    SELECT * FROM USER_SEQUENCES;

    SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 310
    SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 320 출력. 앞에서는 에러 났는데 MAXVALUE을 수정했기 때문에 에러 안 남



/*                                                          221227 8교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <SEQUENCE>
    SEQUENCE는 오라클에서 제공하는 객체로 순차적으로 정수 값을 자동으로 생성한다.
    
    4. SEQUENCE 삭제
        DROP SEQUENCE 시퀀스명;
    
    시퀀스도 OBJECT 임 > DROP으로 삭제함
*/
    DROP SEQUENCE SEQ_EMPID;

    SELECT * FROM USER_SEQUENCES;
    


/*                                                          221227 8교시 11_OBJECT(VIEW, SEQUENCE, INDEX, SYNONYM)
    <SEQUENCE>
    SEQUENCE는 오라클에서 제공하는 객체로 순차적으로 정수 값을 자동으로 생성한다.
    
    5. SEQUENCE 예시
*/
-- 1) 매번 새로운 사번이 발생되는 SEQUENCE 생성
    CREATE SEQUENCE SEQ_EMPID
    START WITH 300;

    SELECT * FROM USER_SEQUENCES;
    
-- 2) 매번 새로운 사번이 발생되는 SEQUENCE를 사용해 INSERT 구문을 작성
--    필수 입력 값 EMP_ID, EMP_NAME, EMP_NO 를 INSERT하기
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO)
    VALUES(SEQ_EMPID.NEXTVAL, '홍길동', '221227-3123456'); -- 300번으로 INSERT
            -- ㄴ 이렇게만 써주면 사번을 직접 입력하지 않아도 됨
    SELECT * FROM EMPLOYEE ORDER BY EMP_ID DESC;

    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO)
    VALUES(SEQ_EMPID.NEXTVAL, '성춘향', '221227-4987654'); -- 301번으로 INSERT

    SELECT * FROM EMPLOYEE ORDER BY EMP_ID DESC;

ROLLBACK;

