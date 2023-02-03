/*
    함수
        - 하나의 프로그램에서 반복적으로 사용되는 부분들을 분리하여 작성해 놓은 작은 서브 프로그램
        - 호출하여 사용하고 호출하면서 값을 전달하고(매개값을 사용할 수 있다는 뜻) 결과를 리턴 받을 수 있음
        - 단일 행 함수   : 각 행마다 반복적으로 적용되어 입력받은 행의 개수만큼 결과를 반환하는 함수
          그룹 함수      : 특정 행들의 집함으로 그룹이 형성되어 적용. 각 그룹 당 한 개의 결과를 반환하는 함수 
*/


-- 단일 행 함수
/*                                                  221213 4교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    1) LENGTH / LENGTHB         >   주어진 문자열의 길이(문자 개수 / BYTE)를 반환
       LENGTH(컬럼 | '문자값') : 글자 수 반환                             #참조! : '|'는 '혹은' 이라는 뜻 컬럼이나 문자값 어떤 것이든 들어가도 된다는 의미
       LENGTHB(컬럼 | '문자값') : 글자의 바이트 수 반환
      
       한글 한 글자 -> 3BYTES
       영문자, 숫자, 특수문자 한 글자 -> 1BYTE
*/
SELECT LENGTH('오라클'), LENGTHB('오라클')    -- LENGTH 글자 수를 셈. 오 라 클 -> 3 / LENGTHB 바이트 수를 셈. 오 3 라 3 클 3 -> 9
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),   -- LENGTH LENGTHB는 단일 행 함수 - > 모든 행마다 반복적으로 LENGTH LENGTHB 적용
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;



/*                                                  221213 4교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    2) INSTR            >   문자의 시작 위치값 반환
       INSTR('1)문자값', '2)문자값'[, 3)POSITION, 4)OCCURRENCE])
       
       - 반환값이 없으면 0 출력
      
       1) 2번 문자값을 찾을 값
       2) 1번 문자값 중에서 찾아내야하는 값
       3) POSITION : 왼오순으로 찾을지 오왼순으로 찾을지 설정(기본값 1)
          1 : 앞에서부터 찾는다.
         -1 : 뒤에서부터 찾는다.
         POSITION과 별개로 문자값의 위치가 몇 번째인지 셀 때는 항상 왼오순으로 셈
       4) 몇 번째 2번 문자값을 찾을지 지정
*/
SELECT INSTR('AABAACAABBAA', 'B')           -- ('1문자값('AABAACAABBAA')'에서, '2문자값('B')' 찾아서 그 위치값 반환) 
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1)           -- ('1문자값'에서, '2문자값' 찾아 위치값 반환할 때, 세 번째 매개변수가 1이면 왼>오로 순으로 찾아라. 값이 몇 번째 위치에 있는지 셀 때는 항상 왼쪽부터!) 
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1)           -- ('1문자값'에서, '2문자값' 찾아 위치값 반환할 때, 세 번째 매개변수가 -1이면 오>왼 순으로 찾아라. 값이 몇 번째 위치에 있는지 셀 때는 항상 왼쪽부터!) 
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1, 2)           -- ('문자값'에서, '문자값' 찾아 위치값 반환할 때, 세 번째 매개변수가 1이면 왼>오로 순서 세기) 
FROM DUAL;      -- 9 출력됨. > 'AABAACAABBAA'에서, 'B'의 위치값 반환하는데, 1이니 왼>오 순으로 찾기, 근데 네 번째 매개변수가 2이니까 두번째 'B'의 위치 찾기

SELECT INSTR('AABAACAABBAA', 'B', 1, -1)
FROM DUAL;      -- 음수 사용 불가

SELECT INSTR('AABAACAABBAA', 'B', -1, 3) 
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1, 4)            -- 반환값이 없으면 0 출력
FROM DUAL;


SELECT EMAIL, INSTR(EMAIL, '@'), INSTR(EMAIL, 's', 1, 2)        -- 영어 대소문자 구분함
FROM EMPLOYEE;  -- 반환값이 없으면 0 출력



/*                                                  221213 4교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    3) LPAD/RPAD            >   주어진 문자열에 임의의 문자열을 왼쪽/오른쪽에 덧붙여 지정한 길이의 문자열을 반환
       LPAD/RPAD('1)문자값', 2)길이[, '3)문자값'])
      
       1) 2번 길이만큼 문자열을 반환할 기본 문자열
       2) 1번 문자열에서 반환할 문자열 길이
       3) 반환할 길이(2)가 주어진 문자열(1)의 길이보다 길 경우 그 공백을 채울 문자열
            - LPAD : 오른쪽으로 정렬하고 공백이나 지정 문자열로 왼쪽을 채움
            - RPAD : 왼쪽으로 정렬하고 공백이나 지정 문자열로 오른쪽을 채움
*/
SELECT LPAD('HELLO', 3)      -- 주어진 문자열(HELLO) 중에서 주어진 길이(3)만큼의 문자열을 반환
FROM DUAL;  -- HEL 출력

SELECT LPAD('HELLO', 10)     -- 10만큼의 길이 중 HELLO 값을 오른쪽으로 정렬하고 공백을 왼쪽으로 채운다.
FROM DUAL;  -- '     HELLO' 출력

SELECT LPAD('HELLO', 10, 'A') -- 10만큼의 길이 중 HELLO 값을 오른쪽으로 정렬하고 공백에 'A'를 채운다.
FROM DUAL;  -- 'AAAAAHELLO' 출력

SELECT RPAD('HELLO', 3)
FROM DUAL;  -- HEL 출력

SELECT RPAD('HELLO', 10)       -- 10만큼의 길이 중 HELLO 값은 왼쪽으로 정렬하고 공백을 오른쪽으로 채운다.
FROM DUAL;  -- 'HELLO     ' 출력

SELECT RPAD('HELLO', 10, '*')   -- 10만큼의 길이 중 HELLO 값은 왼쪽으로 정렬하고 공백을 '*'로 채운다.
FROM DUAL;  -- 'HELLO*****' 출력

SELECT LPAD(EMAIL, 20) FROM EMPLOYEE;   -- 공백을 왼쪽으로 채우니 , 오른쪽 정렬이 됨
SELECT RPAD(EMAIL, 20) FROM EMPLOYEE;   -- 왼쪽 정렬이 됨

-- 주민등록번호 '991213-1******' 형태로 출력
SELECT RPAD('991213-1', 14, '*')
FROM DUAL;



/*                                                  221213 5교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    4) LTRIM/RTRIM          >   주어진 문자열의 왼/오른쪽에서 지정한 문자를 제거한 나머지를 반환           cf)JAVA trim 공백 없애는 함수
       LTRIM/RTRIM('1)문자값' [, '2)문자값'])
            
      1) 공백이나 주어진 문자값(2)를 삭제할 기준 문자열
      2) (1)문자열에서 삭제할 문자값. 2)를 생략하면 공백을 제거함(기본값)
      
      - 주어진 문자값을 제거할 때 1)에 있는 문자열을 2)로 가져가서 하나하나 대조하기 있으면 제거, 없으면 멈춤
      - 2)문자값이 한 개(ex. '1')가 아니라 두 개 이상(ex. '123')이면 그걸 통으로 봐서 비교하는 게 아니라 각각 개별로 보고 각각 비교해서 제거하기
      
      LTRIM : 왼쪽에서 삭제
      RTRIM : 오른쪽에서 삭제
*/
SELECT '    KH', LTRIM('    KH'), LTRIM('KH    ') FROM DUAL;     -- 제거하고자 하는 문자 생략시 기본값으로 공백을 제거한다. LTRIM이라서 왼쪽 공백 지워줌
SELECT LTRIM('000123456') FROM DUAL;
SELECT LTRIM('00123456', '0') FROM DUAL;   -- 000123456에서 0을 제거 매개변수1의 첫번째 0과 매개변수2의 0 비교 삭제, 매개변수1의 두번째 0과 매개변수2의 0 비교 삭제 매개변수1의 1과 매개변수2의 0 비교 다름 멈춤! 출력 123456
SELECT LTRIM(' 000123456', '0') FROM DUAL;  -- 매개변수1과 매개변수2 비교. 매개변수1의 첫번째 공백과 매개변수2의 0 비교. 다르기 때문에 끝! ' 000123456' 그대로 출력
SELECT LTRIM('123123456', '123') FROM DUAL;
/* 위의 코드 리뷰
    '123123456'에서 차례대로 1부터 6까지 하나하나 가져와서 매개변수2의 '123'과 각각 대조
    매개변수1의 첫번째1과 매개변수2의 첫번째1 비교 > 같음 > 제거
    매개변수1의 두번째2와 매개변수2의 첫번째1 비교 > 다름 > 매개변수2의 다음 값으로 > 매개변수2의 두번째2와 비교 > 같음 > 제거
    매개변수1의 세번째3과 매개변수2의 첫번째1 비교 > 다름 > 매개변수2의 다음 값으로 > 매개변수2의 두번째2와 비교 > 다름 > 매개변수2의 다음 값으로 > 매개변수2의 세번째3과 비교 > 같음 > 제거
    매개변수1의 네번째1과 매개변수2의 첫번째1 비교 > 같음 > 제거
    ...
    매개변수1의 일곱번째4와 매개변수2의 첫번째1 비교 > 다름 > 매개변수2의 다음 값으로 > 매개변수2의 두번째2와 비교 > 다름 > 매개변수2의 다음 값으로 > 매개변수2의 세번째3과 비교 > 다름 > 다음값 없음 TRIM 함수 멈춤 > 그 이후 값 출력
*/
SELECT LTRIM('123123456', '213') FROM DUAL; -- 456 출력. 왜? 매개변수값을 통으로 보는 게 아니라 하나하나 개별로 보고 비교해야 해서 매개변수1의 값을 가지고 매개변수2 값들과 비교하기 4는 매개변수2의 값들 어느것과도 같지 않아서 제거 불가능
SELECT LTRIM('123123KH123', '123') FROM DUAL; -- KH123 출력. 왜? k와 일치하는 값이 매개변수2에 없음 k에서 제거를 멈추고 그 이후 값 출력

SELECT '    KH', RTRIM('    KH'), RTRIM('KH    ') FROM DUAL;    -- RTRIM은 오른쪽에서부터 지움
SELECT RTRIM('KH    ', ' ' ) FROM DUAL;
SELECT RTRIM('000123000456000', '0') FROM DUAL; -- 매개변수1의 값들을 오른쪽에서부터 하나하나 기준으로 잡고 매개변수 2의 값과 비교하기 6과 0이 일치하지 않기 때문에 멈추고 그 나머지를 출력

-- 양쪽 문자 제거
SELECT LTRIM(RTRIM('000123000456000', '0'), '0') FROM DUAL;     -- 함수 중첩 사용
SELECT TRIM ('000123000456000', '0') FROM DUAL;



/*                                                  221213 5교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    5) TRIM                                                               cf)JAVA trim 공백 없애는 함수
       TRIM('[[LEADING(앞) | TRAILING(뒤) | BOTH(양쪽)] '1)문자값' FROM] '2)문자값'')
 
       - 2)문자값에서 1)문자값을 삭제
       - TRIM('문자값') > 문자값에 있는 공백을 삭제    1)을 생략하면 공백을 지워줌
*/
SELECT TRIM('    KH    ') FROM DUAL;    -- 양쪽에 있는 공백을 지워줌
SELECT TRIM('    K H    ') FROM DUAL;    -- 양쪽에 있는 공백을 지워줌 문자열 가운데 공백은 삭제 안 됨
SELECT TRIM(' ' FROM '    KH    ') FROM DUAL;    --  2)문자값('    KH    )에서 1)문자값(' ') 지워줌
SELECT TRIM(BOTH ' ' FROM '    KH    ') FROM DUAL;    --  2)문자값에서 1)문자값을 양쪽에서 삭제. 바로 위 166행과 동일 > 양쪽에서 지울 땐 BOTH 생략 가능

SELECT TRIM ('Z' FROM 'ZZZKHZZZ') FROM DUAL;    -- 2)문자값(ZZZKHZZZ)에서 하나씩 가져와서 1)문자값(Z)와 비교 지움
SELECT TRIM ('Z' FROM 'ZZZKZHZZZ') FROM DUAL;
SELECT TRIM (BOTH 'Z' FROM 'ZZZKHZZZ') FROM DUAL;   -- 169행과 동일 > 양쪽에서 지울 땐 BOTH 생략 가능
SELECT TRIM (LEADING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;    -- 앞쪽만 지움
SELECT TRIM (TRAILING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;   -- 뒤쪽만 지움



/*                                                  221213 5교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    6) SUBSTR
       SUBSTR('문자값', POSITION [, LENGTH])
       
       POSITION 출력 시작 위치
        - 양수 : 왼쪽부터 오른쪽으로 순서 세기
        - 음수 : 오른쪽부터 왼쪽으로 순서 세기
            음수로 오왼으로 순서 세어가도 '출력은 다시 왼오순!!'
*/
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;       -- THEMONEY 출력. 'SHOWMETHEMONEY'에서 7번째 위치부터 끝까지(LENGTH 지정을 안 해서) 쭉 출력
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;    -- ME 출력. 'SHOWMETHEMONEY'에서 5번째 위치부터 두 개 출력
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;   -- 오른쪽부터 왼쪽으로 가면서 8번째 위치 찾아서 거기서 왼>오로 세 개 출력
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;     -- '우 미 더' 출력. 공백도 포함한다.

-- EMPLOYEE 테이블에서 주민번호에서 성별을 나타내는 부분만 잘라서 조회 (직원명, 성별코드 조회)
SELECT EMP_NAME AS "직원명",
       SUBSTR(EMP_NO, 8, 1) AS "양수로 구한 성별코드"   -- 매개값 컬럼명으로 지정 가능함
FROM EMPLOYEE;

SELECT EMP_NAME AS "직원명",
       SUBSTR(EMP_NO, -7, 1) AS "음수로 구한 성별코드"
FROM EMPLOYEE;

                                                                                                                        -- 221213 6교시
-- EMPLOYEE 테이블에서 여자 사원의 직원명, 성별코드 조회
SELECT EMP_NAME AS "직원명",
       SUBSTR(EMP_NO, 8, 1) AS "성별코드"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2;
-- WHERE "성별코드" = 2;        -- 별칭으로 식 쓰는 것 불가능. FROM WHERE SELECT ORDER BY 순서라서

-- EMPLOYEE 테이블에서 남자 사원의 직원명, 성별(남)을 조회
SELECT EMP_NAME AS "직원명",
       '남' AS "성별"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

SELECT EMP_NAME AS "직원명",
       '남' AS "성별"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;------------------------------------------------------------------------------------------------------------------------------질문 문자처리함순데 '1' 아니고 1 자동형변환?

-- EMPLOYEE 테이블에서 주민등록번호 첫 번째 자리부터 성별까지 추출한 결과값에 오른쪽에 * 문자를 채워서 14글자 반환
-- ex) 991213-1******
SELECT RPAD(SUBSTR('991213-1222222', 1, 8), 14, '*')
FROM DUAL;

SELECT EMP_NAME AS "직원명",
       RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') AS "주민등록번호"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 이메일, 아이디(이메일에서 '@' 앞의 문자값만 출력)를 조회
-- ex) sun_di@kh.or.kr -> sun_di
SELECT SUBSTR('sun_di@kh.or.kr', 1, 6)
FROM DUAL;

SELECT INSTR('sun_di@kh.or.kr', '@')
FROM DUAL;

SELECT SUBSTR('sun_di@kh.or.kr', 1, INSTR('sun_di@kh.or.kr', '@')-1)
FROM DUAL;

SELECT INSTR(EMAIL, '@')
FROM EMPLOYEE;

SELECT EMP_NAME AS "직원명",
       EMAIL AS "이메일",
       SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1) - 1) AS "아이디"    -- 방법 1
--     LPAD(EMAIL, INSTR(EMAIL, '@', 1) - 1) AS "아이디"         -- 방법 2
--     SUBSTR(EMAIL, 1, LENGTH(EMAIL) - 9) AS "아이디"         -- 방법 3 BUT, 도메인이 달라지면 안 됨 참고만 하기!      
FROM EMPLOYEE;



/*                                                  221213 6교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    7) LOWER / UPPER / INITCAP
       LOWER/UPPER/INITCAP('문자값')
*/
SELECT 'welcome to my world' FROM DUAL;
SELECT UPPER ('welcome to my world') FROM DUAL;     -- WELCOME TO MY WORLD > 대문자 출력
SELECT LOWER ('WELCOME TO MY WORLD') FROM DUAL;     -- welcome to my world > 소문자 출력
SELECT INITCAP('welcome to my world') FROM DUAL;    -- Welcome To My World > 구분되는 단어마다 대문자 출력



/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    8) CONCAT
       CONCAT('문자값', '문자값')
       
       - CONCAT은 두 개의 문자열만 전달받을 수 있다.
*/
SELECT CONCAT('가나다라', 'ABCD') FROM DUAL;    -- 가나다라ABCD 출력. 두 개의 문자 데이터를 하나로 합쳐서 출력
SELECT '가나다라' || 'ABCD' FROM DUAL;          -- CONCAT 함수는 연결연산자(||)와 동일한 결과를 출력한다

SELECT CONCAT('가나다라', 'ABCD', '1234') FROM DUAL;            -- CONCAT 함수는 두 개의 문자열만 전달받을 수 있다.
SELECT '가나다라' || 'ABCD' || '1234' FROM DUAL;                -- 연결연산자는 연결할 수 있는 개수 제한이 없다.
SELECT CONCAT(CONCAT('가나다라', 'ABCD'), '1234') FROM DUAL;    -- CONCAT으로 세 개 이상의 문자열을 잇고 싶으면 중첩 함수 쓰면 된다.

SELECT CONCAT(EMP_ID, EMP_NAME)
FROM EMPLOYEE;



/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 문자 처리 함수>
    
    9) REPLACE
       REPLACE('1)문자값', '2)문자값', '3)문자값')
       1) 기준이 되는 문자값
       2) 1)문자값에서 변경하려고 하는 문자값
       3) 2)를 변경할 문자값
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')     -- 역삼동을 삼성동으로 변경
FROM DUAL;

-- EMPLOYEE 테이블에서 이메일의 kh.or.kr을 gmail.com으로 변경해서 조회
SELECT EMP_NAME,
       EMAIL,
       REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;







/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 숫자 처리 함수>
    
    1) ABS
       ABS(NUMBER)
       
       절대값 구하는 함수
*/
SELECT ABS(10.9) FROM DUAL;
SELECT ABS(-10.9) FROM DUAL;



/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 숫자 처리 함수>
    
    2) MOD
       MOD(NUMBER, DIVISION)
       
       나머지 구하는 함수           cf) JAVA의 % 연산자와 동일
*/
SELECT 10 % 3 FROM DUAL;    -- 오라클에서는 나머지 연산인 % 연산 지원하지 않음
SELECT 10 + 3, 10 - 3, 10 * 3, 10 / 3, MOD(10,3) FROM DUAL;     -- 더하기, 빼기, 곱하기, 나누기, 나머직값(10에서 3 나눈 값의 나머지) 
SELECT MOD(-10, 3) FROM DUAL;
SELECT MOD(10, -3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;
SELECT MOD(-10.9, 3) FROM DUAL;



/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 숫자 처리 함수>
    
    3) ROUND
       ROUND(NUMBER [, POSITION])
       
       반올림 함수
       
       POSITION - 기본0 (생략) : 소수점 기준으로 반올림
                  양수 : 반올림 기준이 오른쪽으로 한칸씩 이동
                  음수 : 반올림 기준이 왼쪽으로 한칸씩 이동
*/
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.556) FROM DUAL;        -- POSITION 생략시 POSITION = 0 > 소수점을 기준으로 반올림
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, 4) FROM DUAL;
SELECT ROUND(123.456, -1) FROM DUAL;
SELECT ROUND(126.456, -1) FROM DUAL;
SELECT ROUND(123.456, -3) FROM DUAL;    -- 0
SELECT ROUND(553.456, -3) FROM DUAL;    -- 1000



/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 숫자 처리 함수>
    
    4) CEIL
       CEIL(NUMBER)
       
       올림 함수
       
       POSITION이 '없음' (cf. ROUND 함수) 무조건 소수점 기준으로 올림
*/
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(123.456, 2) FROM DUAL;      -- 에러 발생. POSITION 지정 못 함. 무조건 소수점 기준으로 올림



/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 숫자 처리 함수>
    
    5) FLOOR
       FLOOR(NUMBER)
       
       버림 함수
       
       POSITION이 없음 (cf. ROUND 함수) 무조건 소수점 기준으로 버림
*/
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(456.789) FROM DUAL;
SELECT FLOOR(123.456, 1) FROM DUAL;      -- 에러 발생. POSITION 지정 못 함. 무조건 소수점 기준으로 버림



/*                                                  221213 7교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 숫자 처리 함수>
    
    ６) TRUNC
       TRUNC(NUMBER [, POSITION])
       
       버리는 위치를 지정한 버림 함수
       
       POSITION - 기본 0 (생략) : 소수점 기준으로 버림
                  양수 : 버림 기준이 오른쪽으로 한칸씩 이동
                  음수 : 버림 기준이 왼쪽으로 한칸씩 이동
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(456.789) FROM DUAL;
SELECT TRUNC(123.456, 0) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;







/*                                                  221214 1교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 날짜 처리 함수>
    
    1) SYSDATE
        시스템에 저장되어 있는 현재 날짜를 반환
*/
SELECT SYSDATE FROM DUAL;

-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';          -- 얘로 포맷 변경 후 SYSDATE 함수 다시 호출하면 이전과 다르게 나옴
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';                     -- 다시 '원래'대로 포맷 변경



/*                                                  221214 1교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 날짜 처리 함수>
    
    2) MONTHS_BETWEEEN(날짜 데이터, 날짜 데이터)
        주어진 날짜 데이터 두 개의 개월 수 차이를 반환
        
        - 매개변수2 - 매개변수1
*/
SELECT MONTHS_BETWEEN(SYSDATE, '20220525') FROM DUAL;   -- 출력하면 두 날짜의 차이가 소수점으로 나옴
SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, '20220525')) FROM DUAL;    -- 소수점으로 출력되는 값을 소수점 버림하고 정수형으로 출력
SELECT MONTHS_BETWEEN('20220525', SYSDATE) FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 근무 개월 수 조회
SELECT EMP_NAME AS "직원명",
       HIRE_DATE AS "입사일",
       FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS "근무 개월 수"       -- 매개변수 위치 바꿔주면 값이 달라짐 '매개변수2 - 매개변수1'의 형식
FROM EMPLOYEE;



/*                                                  221214 1교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 날짜 처리 함수>
    
    2) ADD_MONTHS(날짜 데이터, 숫자)
        주어진 날짜에 지정된 개월 수를 더하여 날짜 데이터를 반환
*/
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 입사 후 6개월이 된 날짜를 조회
SELECT EMP_NAME AS "직원명",
       HIRE_DATE  AS "입사일",
       ADD_MONTHS(HIRE_DATE, 6) AS "입사 후 6개월"
FROM EMPLOYEE;



/*                                                  221214 1교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 날짜 처리 함수>
    
    2) NEXT_DAY(날짜 데이터, 요일 데이터[문자형, 숫자형])
        주어진 날짜에 인자로 받은 요일이 가장 가까운 날짜를 반환한다.
        
        - 1 : 일요일, 2 : 월요일, ... 7 : 토요일
        - 요일정보를 현재 설정 언어에 맞게 넣어줘야 함
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 2) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAY') FROM DUAL;      -- 오류남 왜? 현재 언어가 한글로 되어있어서. 영어로 되어있다면 오류 발생하지 않음
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MON') FROM DUAL;

-- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;      -- 언어를 영어로 바꿈 이렇게 하면 'MONDAY' 'MON'은 호출되고 '월요일' '월'은 오류가 발생함
ALTER SESSION SET NLS_LANGUAGE = KOREAN;



/*                                                  221214 2교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 날짜 처리 함수>
    
    3) LAST_DAY(날짜 데이터)
        주어진 날짜가 속한 달의 마지막 날짜 반환
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('20221114') FROM DUAL;
SELECT LAST_DAY('20/02/01') FROM DUAL;
SELECT LAST_DAY('20/2/1') FROM DUAL;
SELECT LAST_DAY('2020/2/1') FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 입사월의 마지막 날짜 조회
SELECT EMP_NAME,
       HIRE_DATE,
       LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;



/*                                                  221214 2교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 날짜 처리 함수>
    
    4) EXTRACT(YEAR|MONTH|DAY FROM 날짜데이터)
        주어진 날짜에서 년, 월, 일 정보를 추출하여 반환한다
*/
SELECT EXTRACT(YEAR FROM SYSDATE),
       EXTRACT(MONTH FROM SYSDATE),
       EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME AS "직원명",
       HIRE_DATE,    -- 여기서는 YY/MM/DD로 두 자리씩 보이는데 년도 추출하면 YYYY 네 자리로 나옴 상관없음 날짜 추출 형식을 YY/M/DD로 설정해놓은 것일 뿐 안에 들어있는 데이터는 YYYY임
       EXTRACT(YEAR FROM HIRE_DATE) AS "입사년도",
       EXTRACT(MONTH FROM HIRE_DATE) AS "입사월",
       EXTRACT(DAY FROM HIRE_DATE) AS "입사일"
FROM EMPLOYEE
-- ORDER BY EXTRACT(YEAR FROM HIRE_DATE) DESC;
-- ORDER BY "입사년도" DESC;
-- ORDER BY 3 DESC;        -- 컬럼 순서로도 정렬 가능!!!! 0부터 아니고 1부터임!
-- ORDER BY "입사년도" DESC, "입사월";    -- 정렬 기준 여러 개 적용 가능. 1번 정렬 기준으로 정렬 후 같은 값일 때 두 번째 정렬 기준으로 정렬 시작 > 입사년도로 내림차순 정렬 후 같은 입사년도를 가진 사람은 입사월로 오름차순 정렬
ORDER BY 3 DESC, 4, 5;   -- 입사년도로 내림차순 정렬 후 같은 해에 입사한 사람끼리 입사월로 오름차순 정렬, 같은 월에 입사한 사람끼리 입사일로 오름차순 정렬







/*                                                  221214 2교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 형 변환 함수>
    
    1) TO_CHAR(날짜|숫자 데이터 [, FORMAT])
        주어진 날짜 또는 숫자형 데이터를 문자 타입으로 변환해서 [원하는 형태로] 반환
        결과값 : CHARACTER
*/
-- 숫자 데이터 타입 -> 문자 데이터 타입
SELECT TO_CHAR(1234) FROM DUAL;                 -- 숫자 데이터 1234를 문자 데이터 '1234'로 변환
SELECT TO_CHAR(1234, '999999') FROM DUAL;       -- 9 : 숫자 하나를 의미. 여섯 칸의 공간을 확보. 오른쪽 정렬. 채워지지 않은 부분을 공백으로 채움
SELECT TO_CHAR(1234, 'FM999999') FROM DUAL;     -- FM : 공백을 지움
SELECT TO_CHAR(1234, '000000') FROM DUAL;       -- 여섯 칸의 공간을 확보. 오른쪽 정렬. 채워지지 않은 부분을 0으로 채워서 변환
SELECT TO_CHAR(12345678, '999999') FROM DUAL;   -- 포맷의 형식을 넘어서는 데이터값을 넣고 호출 시 ###### 호출
SELECT TO_CHAR(1234, 'L999999') FROM DUAL;      -- L : 현재 설정된 언어의 통화 표시
SELECT TO_CHAR(1234, '$999999') FROM DUAL;      -- $ : 달러 표시
SELECT TO_CHAR(1234, 'L99,999,999') FROM DUAL;  -- 자리수 구분
                        /* 9999 네 칸의 공간을 확보 99999 다섯 칸의 공간을 확보. 근데 출력하니 공백이 많아??이렇게 여기에 너무 연연하지 말기
                            공백은 자동으로 생겨서 지정한 포맷형식보다 많게 나올 수 있음
                            간단하게 포맷이 999이면 데이터 값이 세 자리를 넘어섰을 때 #으로 뜬다는 것만 알아두기*/ 

-- EMPLOYEE 테이블에서 직원명, 급여, 연봉 조회(급여, 연봉 자리수 구분 , 통화 표시까지)
SELECT EMP_NAME AS "직원명",
       TO_CHAR(SALARY, 'FML99,999,999') AS "급여",            -- FM : 공백 지우기
       TO_CHAR(SALARY * 12, 'FML99,999,999') AS "연봉"
FROM EMPLOYEE
ORDER BY 3 DESC;



-- 날짜 데이터 타입 -> 문자 데이터 타입                                             221214 3교시
SYSTEM SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE) FROM DUAL;                  
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;   -- 오전 오후 구분 AM이라고 적어도 오후에는 오후라고 뜨고 PM이라고 적어도 오전 시간에는 오전이라고 뜸. 
SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') FROM DUAL; -- 24시간 형식
SELECT TO_CHAR(SYSDATE,'MON, DY, YYYY') FROM DUAL;  -- MON : 월 1월 2월 3월로 월까지 뜸  DY  : 요일 월, 화, 수, 목, ...
SELECT TO_CHAR(SYSDATE, 'DAY') FROM DUAL;           --                                DAY : 요일 월요일, 화요일, 수요일, 목요일, ...
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD(DY)') FROM DUAL;

-- 연도에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'),
       TO_CHAR(SYSDATE, 'RRRR'),    --  r 하단의 'YY와 RR 비교' 보기 ctrl f
       TO_CHAR(SYSDATE, 'YY'),      -- YY : 50 기준 현재 이전 세기 구분 X
       TO_CHAR(SYSDATE, 'RR'),      -- RR : 50 기준 50 이상은 이전 세기 50 미만은 현재 세기
       TO_CHAR(SYSDATE, 'YEAR')     -- 영어로 표기
FROM DUAL;

-- 월에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'MM'),      -- 12
       TO_CHAR(SYSDATE, 'MON'),     -- 12월, DEC 언어에 따라 바뀜
       TO_CHAR(SYSDATE, 'MONTH'),   -- 12월, DECEMBER 언어에 따라 바뀜 
       TO_CHAR(SYSDATE, 'RM')       -- XII  로마자 표기
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- 일에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'D'),       -- 4    한 주를 기준으로 몇 번째 날인지 221214기준 4 일요일이 1 월요일이 2....
       TO_CHAR(SYSDATE, 'DD'),      -- 14   한 달을 기준으로 몇 번째 날인지
       TO_CHAR(SYSDATE, 'DDD'),     -- 348  1 년을 기준으로 몇 번째 날인지 
FROM DUAL;

-- 요일에 대한 포맷            인강듣기 3교시 20분~
SELECT TO_CHAR(SYSDATE, 'DAY'),     -- 수요일  WENDSDAY       기본 언어 설정에 따라 출력값이 달라짐
       TO_CHAR(SYSDATE, 'DY')       -- 수     WED
FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일 조회
-- 단, 입사일은 포맷을 지정해서 조회한다. (2022-12-14(수))
SELECT EMP_NAME AS "직원명",
       TO_CHAR(HIRE_DATE, 'YYYY-MM-DD(DY)') AS "년-월-일(요일)"
FROM EMPLOYEE;

-- 단, 입사일은 포맷을 지정해서 조회한다. (2022년 12월 14일(수))
SELECT EMP_NAME AS "직원명",
       TO_CHAR(HIRE_DATE, 'YYYY"년 " MONTH DD"일"(DY)') AS "년-월-일-(요일)"
FROM EMPLOYEE;


/*                                                  221214 3교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 형 변환 함수>
    
    2) TO_DATE(숫자|문자 데이터 [, FORMAT])
        주어진 숫자 또는 문자형 데이터를 날짜 타입으로 변환해서 [원하는 형태로] 반환
*/
-- 숫자 데이터 타입 -> 날짜 데이터 타입
SELECT TO_DATE(20221214) FROM DUAL;
SELECT TO_DATE(20221214113830) FROM DUAL;   -- 날짜 포맷에 따라 에러 발생 유무가 달라짐. 1번 날짜 포맷은 시분초 정보가 나와있어서 에러 안 남 2번 포맷은 연월일 정보만 나와있어서 에러 발생

-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

SELECT TO_DATE(20221214113830, 'YYYY-MM-DD HH:MI:SS') FROM DUAL;    -- 2번 날짜 포맷인데도 에러 안 남! 설명 적기!!!!!!!!!



-- 문자 데이터 타입 -> 날짜 데이터 타입
SELECT TO_DATE('20221214') FROM DUAL;
SELECT TO_DATE('20221214114330') FROM DUAL;     -- 에러 발생 날짜 포맷에 따라 받아오는 정보가 다름 기본적으로는 포맷을 참고한다 생각하기
SELECT TO_DATE('20221214 114330', 'YYYY-MM-DD HH:MI:SS') FROM DUAL; -- 기본적으로는 설정되어있는 포맷에 따라 정보를 만들지만 포맷을 따로 설정해주면 에러가 나지 않고 출력이 됨
                                                                    -- BUT 기본 날짜 포맷이 2번으로 설정되어있어서 출력이 22/12/14로 됨 포맷을 1번으로 바꿔주면 2022-12-14 11:43:30로 출력
                                                                    
                                                                    
-- YY와 RR 비교                                                        221214 4교시 ORACLE 03_ 함수(Function)
-- YY는 무조건 현재 세기를 반영하고, RR은 50 미만이면 현재 세기를 반영, 50 이상이면 이전 세기를 반영한다.
            -- 날짜 포맷 1번으로 변경하고 보기
SELECT TO_DATE('140630', 'YYMMDD') FROM DUAL;   -- 2014-06-30 12:00:00 출력
SELECT TO_DATE('980630', 'YYMMDD') FROM DUAL;   -- 2098-06-30 12:00:00 출력

SELECT TO_DATE('140630', 'RRMMDD') FROM DUAL;   -- 2014-06-30 12:00:00 출력
SELECT TO_DATE('980630', 'RRMMDD') FROM DUAL;   -- 1998-06-30 12:00:00 출력

-- EMPLOYEE 테이블에서 1998년 1월 1일 이후에 입사한 사원의 사번, 이름, 입사일 조회
SELECT EMP_ID,
       EMP_NAME,
       HIRE_DATE
FROM EMPLOYEE
-- WHERE HIRE_DATE > TO_DATE('19980101', 'YYYYMMDD')
-- WHERE HIRE_DATE > TO_DATE('19980101', 'YYMMDD')      -- YY는 20980101로 변환 사용 불가 YYYY 써줘야함
-- WHERE HIRE_DATE > TO_DATE('19980101', 'RRMMDD')      -- RR은 19980101로 변환
WHERE HIRE_DATE > '19980101'                            -- 굳이 형변환 안 해줘도 1번 포맷형식에 따라서 '19980101'을 날짜 데이터로 변환시켜줘서 비교를 해줌
ORDER BY HIRE_DATE;



/*                                                  221214 4교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 형 변환 함수>
    
    3) TO_NUMBER(문자 데이터 [, FORMAT])
        주어진 문자형 데이터를 숫자 타입으로 변환해서 [원하는 형태로] 반환
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;       -- 123456789 출력 0 사라짐 숫자로 바뀐 걸 알 수 있음
SELECT '123' + '456' FROM DUAL;                 -- 오라클에서 + : 산술연산 /  둘 다 문자형이지만 산술 연산자가 들어가서 자동으로 숫자 타입으로 형 변환 뒤 연산처리를 한다.
SELECT '123' + '456A' FROM DUAL;                -- 에러. 숫자 형태의 문자 데이터만 자동 형 변환이 됨
SELECT '10,000,000' + '500,000' FROM DUAL;      -- 에러. 콤마(,)는 편하게 숫자를 읽을 수 있게 넣은 문자에 불과 숫자 형태가 아님 자동 형 변환 불가능

SELECT TO_NUMBER('10,000,000') FROM DUAL;       -- 에러
SELECT TO_NUMBER('10,000,000', '999,999,999') FROM DUAL;    -- 포맷을 참조해서 아 문자데이터에서 콤마(,)는 구분하는 애구나, 9 자리만 숫자구나 인식할 수 있게해줌
SELECT TO_NUMBER('500,000', '999,999') FROM DUAL;

SELECT '10,000,000' + '500,000' FROM DUAL; 
SELECT TO_NUMBER('10,000,000', '99,999,999') + TO_NUMBER('500,000', '999,999') FROM DUAL;
SELECT TO_CHAR(TO_NUMBER('10,000,000', '99,999,999') + TO_NUMBER('500,000', '999,999'), '999,999,999,999') FROM DUAL;







/*                                                  221214 4교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - NULL 처리 함수>
    
    1) NVL(P1, P2)
        P1이 NULL이 아닐 경우 P1을 그대로 반환
        P1이 NULL일 경우 P2를 반환
*/
-- EMPLOYEE 테이블에서 직원명, 보너스, 보너스가 포함된 연봉 조회
SELECT EMP_NAME AS "직원명",
       NVL(BONUS, 0) AS "보너스",
       TO_CHAR(NVL(( SALARY + ( SALARY * BONUS )) * 12, SALARY * 12), '999,999,999,999') AS "연봉(+ 보너스)",      -- 내가 한 거아래랑 비교해보기 같은 값 나옴
       TO_CHAR(( SALARY + ( SALARY * NVL(BONUS, 0))) * 12, 'FML999,999,999,999') AS "연봉(+보너스)"               -- 수업 때 한 거 FM 공백 지우기 L 통화기호 넣기
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 직원명, 부서 코드 조회(단, 부서 코드가 NULL이면 '부서없음' 출력)
SELECT EMP_NAME AS "직원명",
       NVL(DEPT_CODE, '부서없음') AS "부서 코드"
FROM EMPLOYEE
ORDER BY DEPT_CODE DESC;        -- DESC 정렬 NULLS FIRST가 기본



/*                                                  221214 5교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - NULL 처리 함수>
    
    1) NVL2(P1, P2, P3)
        P1이 NULL이 아닐 경우 P2를 반환
        P1이 NULL일 경우 P3을 반환
*/
-- 어떤 상황에 사용하는지? 회사 상황이 안 좋아서 보너스를 0.1로 동결. 이게 평생 가는 게 아니라 상황이 좋아지면 다시 돌릴 예정. 이런 상황에 사용

-- EMPLOYEE 테이블에서 보너스를 0.1로 동결하여 직원명, 보너스, 동결된 보너스, 보너스가 포함된 연봉 조회
        -- BONUS 값이 있으면 0.1로 동결 BONUS 값이 없으면 0
SELECT EMP_NAME AS "직원명",
       NVL(BONUS,0) AS "보너스율",
       SALARY AS "급여",
       NVL2(BONUS, 0.1, 0) AS "동결된 보너스율",
       (SALARY + ( SALARY * NVL2(BONUS, 0.1, 0))) * 12 AS "연봉(+동결 보너스)"
FROM EMPLOYEE;



/*                                                  221214 5교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - NULL 처리 함수>
    
    3) NULLIF(P1, P2)
        주어진 두 개의 값이 동일하면 NULL, 동일하지 않으면 P1을 반환
*/
SELECT NULLIF('123', '123') FROM DUAL;      -- 데이터 타입 맞춰주기
SELECT NULLIF('123', '456') FROM DUAL;

SELECT NULLIF(123, 123) FROM DUAL;
SELECT NULLIF(123, 456) FROM DUAL;







/*                                                  221214 5교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 선택 함수>
    
    1) DECODE
        DECODE(컬럼 또는 값(계산식), 조건 1, 결과 1, 조건 2, 결과 2, ..., DEFAULT)
            - 컬럼 또는 값과 조건 1이 같으면 결과 1 반환
            - 컬럼 또는 값과 조건 2가 같으면 결과 2 반환
            - 조건 결과는 개수 제한이 없음
            - 어떤 조건과도 같지 않다면 DEFAULT 반환
*/
-- EMPLOYEE 테이블에서 사번, 직원명, 주민번호, 성별(남자, 여자) 조회
SELECT EMP_ID AS "사번",
       EMP_NAME AS "직원명",
       EMP_NO AS "주민번호",
       DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자', 3, '남자', 4, '여자', '잘못된 주민번호입니다.') AS "성별"
FROM EMPLOYEE
ORDER BY "성별";

-- EMPLOYEE 테이블에서 직원명, 직급 코드, 기존 급여, 인상된 급여를 조회
-- 직급 코드가 J7인 사원은 급여를 10% 인상
-- 직급 코드가 J6인 사원은 급여를 15% 인상
-- 직급 코드가 J5인 사원은 급여를 20% 인상
-- 그 외 직급의 사원은 급여를 5% 인상
SELECT EMP_NAME AS "직원명",
       JOB_CODE AS "직급 코드",
       SALARY AS "기존 급여",
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, 'J6', SALARY * 1.15, 'J5', SALARY * 1.2, SALARY * 1.05) AS "인상된 급여"
FROM EMPLOYEE;

SELECT EMP_NAME AS "직원명",
       JOB_CODE AS "직급 코드",
       SALARY AS "기존 급여",
       DECODE(JOB_CODE, 'J7', 0.1, 'J6', 0.15, 'J5', 0.2, 0.05) AS "인상율",
       SALARY + (DECODE(JOB_CODE, 'J7', 0.1, 'J6', 0.15, 'J5', 0.2, 0.05) * SALARY) AS "인상된 급여"
--     SALARY + ("인상율" * SALARY) AS "인상된 급여"        
FROM EMPLOYEE;
        -- 별칭은 SELECT 다 돌아야 생성됨!!!!!! SELECT 안에서 별칭 사용 불가



/*                                                  221214 6교시 ORACLE 03_ 함수(Function)
    <단일 행 함수 - 선택 함수>
    
    2) CASE
        CASE WHEN 조건 1 THEN 결과 1
             WHEN 조건 2 THEN 결과 2
             WHEN 조건 3 THEN 결과 3
             ...
             ELSE 결과
        END     
            - 조건 1을 만족하면 결과 1 반환, 조건 2를 만족하면 결과 2 반환 ... 아무 조건도 만족하지 못하면 ELSE 결과 반환
*/
-- EMPLOYEE 테이블에서 사번, 직원명, 주민번호, 성별(남자, 여자) 조회
SELECT EMP_ID AS "사번",
       EMP_NAME AS "직원명",
       EMP_NO AS "주민번호",
       CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) = 2 THEN '여자'
            WHEN SUBSTR(EMP_NO, 8, 1) = 3 THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) = 4 THEN '여자'
            ELSE '잘못된 주민번호입니다.'
       END  AS "성별"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 급여, 급여 등급(1 ~ 4) 조회
-- SALARY 값이 500 만원 초과일 경우 1등급
-- SALARY 값이 500 만원 이하 350 만원 초과일 경우 2등급
-- SALARY 값이 350 만원 이하 200 만원 초과일 경우 3등급
-- SALARY 값이 그 외일 경우 4등급
SELECT EMP_NAME AS "직원명",
       TO_CHAR(SALARY, 'FM999,999,999') AS "급여",
       CASE WHEN SALARY > 5000000 THEN '1등급'    -- 이 조건에서 500만원 넘는 사람은 다 걸려서 빠짐 그래서 바로 밑처럼 쓸 필요 없고(밑에도 출력은 됨 BUT, 비효율적) 350 초과만 적어주면 됨
--          WHEN SALARY > 3500000 AND SALARY <= 5000000 THEN '2등급'
            WHEN SALARY > 3500000 THEN '2등급'
            WHEN SALARY > 2000000 THEN '3등급'
            ELSE '4등급'
       END  AS "급여 등급"
FROM EMPLOYEE
ORDER BY "급여" DESC;









-- 그룹 함수
-- 하나 이상의 행을 그룹으로 묶어 연산하며 총합, 평균 등을 하나의 컬럼으로 반환하는 함수
-- 주의 모든 그룹 함수는 NULL값을 자동으로 제외하고 값이 있는 것들만 계산함



/*                                                  221214 6교시 ORACLE 03_ 함수(Function)
    <그룹 함수>
    1) SUM
        - 숫자 타입의 컬럼만 올 수 있음
            ex)EMPLOYEE 테이블에서 EMP_NAME으로는 SUM 사용 불가
*/
-- EMPLOYEE 테이블에서 전 사원의 총 급여의 합계를 조회
SELECT TO_CHAR(SUM(SALARY), 'FML999,999,999')       -- L 현재 사용 언어 통화기호 / FM 공백제거
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 남자 사원의 총 급여의 합계를 조회
SELECT SUM(CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN SALARY   -- 내가 한 거
           ELSE NULL
       END)
FROM EMPLOYEE;

SELECT SUM(SALARY)                  -- 선생님 코드
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';       -- EMPLOYEE 테이블에서 WHERE 조건식에 맞는 애들만 골라서 SELECT 수행

-- EMPLOYEE 테이블에서 여자 사원의 총 급여의 합계를 조회
SELECT SUM(DECODE(SUBSTR(EMP_NO, 8, 1), 1, NULL, SALARY))   -- 내가 한 거
FROM EMPLOYEE;

SELECT TO_CHAR(SUM(SALARY), 'FML999,999,999,999,999')       -- 선생님 코드
FROM EMPLOYEE                       -- ㄴ 형식 만들 때 999,999,999,999 넉넉하게 잡아도 괜찮음 굳이 값이랑 딱 맞출 필요 없음
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- EMPLOYEE 테이블에서 전 사원의 총 연봉의 합계를 조회
SELECT SUM(SALARY * 12)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원들의 총 연봉의 합계를 조회
SELECT SUM(DECODE(DEPT_CODE, 'D5', SALARY * 12, NULL))  -- 내가 한 거
FROM EMPLOYEE;

SELECT SUM(SALARY * 12)             -- 성생님 코드
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';



/*                                                  221214 7교시 ORACLE 03_ 함수(Function)
    <그룹 함수>
    2) AVG
        - 기본적으로는 NULL값이 제외되고(그룹함수의 기본) 계산이 됨 > 평균값 낼 때 NULL값을 포함할지 안 할지 고민해서 코드 작성
        - 숫자 타입의 컬럼만 올 수 있음
*/
-- EMPLOYEE 테이블에서 전 사원의 급여 평균 조회
SELECT ROUND(AVG(SALARY))                                         -- NULL값 '제외'한 평균값
FROM EMPLOYEE;

SELECT TO_CHAR(ROUND(AVG(NVL(SALARY, 0))), 'FML99,999,999')       -- NULL값 '포함'한 평균값 (SALARY는 NULL값이 없어서 출력값은 동일함)
FROM EMPLOYEE;



/*                                                  221214 7교시 ORACLE 03_ 함수(Function)
    <그룹 함수>
    3) MIN / MAX
        - 모든 타입의 데이터를 다 받을 수 있다. ex) 날짜는 크고 작고 구분 가능, 문자는 사전순으로 크기 구분 가능
            cf) SUM, AVG 숫자 데이터만 가능
        - 여러 개의 MIN MAX 출력 할 때 어떤 건 함수 사용하고 어떤 건 함수 사용 안 하고 이렇게 못 함 하려면 다 하거나 다 안 하거나 이래야 함    
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';     -- 날짜 포맷 이거로 변경하고 아래 코드들 출력해보기 다 하면 위에 날짜 포맷 변경 가서 1번으로 변경

SELECT MIN(EMP_NAME),
       MIN(SALARY),
       HIRE_DATE            -- 이러면 에러 남.
FROM EMPLOYEE;              -- 왜?? 단일 행 함수는 개별 행 다 나오는데 그룹 함수는 하나의 행으로 출력됨. 그래서 에러 남 써주려면 다 써주든가 다 안쓰든가 해야함 

SELECT MIN(EMP_NAME), MAX(EMP_NAME),
       MIN(SALARY), MAX(SALARY),
       MIN(HIRE_DATE), MAX(HIRE_DATE)
FROM EMPLOYEE; 



/*                                                  221214 7교시 ORACLE 03_ 함수(Function)
    <그룹 함수>
    4) COUNT
        - 조회된 행의 개수를 반환
        - COUNT(*)              : 조회 결과에 해당하는 모든 행 개수를 반환
        - COUNT(컬럼명)          : 제시한 컬럼 값이 NULL이 아닌 행의 개수를 반환
        - COUNT(DISTINCT 컬럼명) : 해당 컬럼 값의 중복을 제거한 행의 개수를 반환(NULL도 제외)
*/
-- EMPLOYEE 테이블에서 전체 사원의 수를 조회
SELECT COUNT(*)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 남자 사원의 수를 조회
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- EMPLOYEE 테이블에서 보너스를 받는 직원의 수를 조회
SELECT COUNT(BONUS)             -- NULL은 제외하고 세는 게 그룹 함수의 기본이라 특별한 식을 걸지 않아도 알아서 NULL 빼고 계산해줌
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;
--WHERE BONUS != NULL;      -- 불가. NULL값이 있나 없나는 부등호로 하는 게 아니라 IS NULL로 따져야 함

-- EMPLOYEE 테이블에서 퇴사한 직원의 수를 조회
    -- ENT_DATE가 NULL이면 퇴사자 재직중 값이 있으면 퇴사자. ENT_YN가 Y이면 퇴사자 N이면 재직중
SELECT COUNT(*)
FROM EMPLOYEE
WHERE ENT_DATE IS NOT NULL;

SELECT COUNT(ENT_DATE) FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

-- EMPLOYEE 테이블에서 부서가 배치 된 사원의 수를 조회
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

-- EMPLOYEE 테이블에서 현재 사원들이 속해있는 부서의 수를 조회
    -- DISTINCT 부서 코드 중복을 삭제해주면 됨
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 현재 사원들이 분포되어있는 직급의 수를 조회
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;
