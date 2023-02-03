

-- 춘 기술대학교 실습문제


/*-- BASIC SELECT*/

-- 1번. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열"으로 표시하도록 한다.        221214
SELECT DEPARTMENT_NAME AS "학과 명",
       CATEGORY AS "계열"
FROM TB_DEPARTMENT;

-- 2번. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
SELECT DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || '명 입니다.' AS "학과별 정원"
FROM TB_DEPARTMENT;



-- 3번. "국어국문학과"에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 누구인가?
--      (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '국어국문학과';

SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '001' AND SUBSTR(STUDENT_SSN, 8, 1) = '2' AND ABSENCE_YN = 'Y';

            -- 틀린 부분!!!! 국어국문학과의 코드를 구하는 식을 아예 작성하지 않았음



-- 4. 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시하고자 한다. 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY 1 DESC;

            -- 틀린 부분!!!! IN()에서 매개변수에 작은따옴표 안씌움!!!! 깜박하지 말기



-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오.
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다. 그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.
SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT
ORDER BY 1;



-- 10. 02 학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE SUBSTR(ENTRANCE_DATE, 1, 2) = '02' AND STUDENT_ADDRESS LIKE '전주시%' AND ABSENCE_YN = 'N';

                                                                                                                            -- 틀린부분!!!! LIKE!! 컬럼명 LIKE '%전주시%'!!!!!

    SELECT SUBSTR(ENTRANCE_DATE, 1)
    FROM TB_STUDENT;
    
    SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
    FROM TB_STUDENT
    WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) = 2002
        AND STUDENT_ADDRESS LIKE '전주%'
        AND ABSENCE_YN = 'N';





/*-- ADDITIONAL SELECT  - 함수*/

-- 1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른순으로 표시하는 SQL 문장을 작성하시오.
--    (단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
SELECT STUDENT_NO AS "학번",
       STUDENT_NAME AS "이름",
       TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') AS "입학년도"
FROM TB_STUDENT
WHERE DEPARTMENT_NO = 002 
ORDER BY 2;

                                                                                                                            -- 표랑 내 출력값 꼼꼼하게 비교하기!!!!! TO_CHAR 빼먹음


-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해보자.
--    (이때, 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';





-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오.
--    나이가 적은 사람에서 많은 사람 순서로 화면에 출력
--    교수 중 2000년 이후 출생자는 없음. 출력 헤더는 "교수이름", "나이"로 한다. 나이는 '만'으로 계산한다.

SELECT PROFESSOR_NAME AS "교수 이름",                                                                                           -- !!!!! 만나이 계산 한 번 더 해보기 !!!!! 왕왕틀림!!!!
       FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(PROFESSOR_SSN,1,6),'RRMMDD'))/12) || '세' AS "나이"
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1) = '1';




-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 출력 헤더는 "이름"이 찍히도록 한다.
--    성의 두 자인 경우는 교수는 없다고 가정하시오
SELECT SUBSTR(PROFESSOR_NAME,2) AS "이름"
FROM TB_PROFESSOR;




-- 5. 재수생 입학자를 구하여라. 이때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다.

SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE TO_CHAR(ENTRANCE_DATE, 'YYYY') - TO_CHAR('19' || SUBSTR(STUDENT_SSN,1,2)) = 20;                                       -- !!!!! 내가 만든 식 !!!!!

SELECT STUDENT_NO, STUDENT_NAME--, MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD'))/12           -- !!!!! 예시 코드 !!!!!
FROM TB_STUDENT
WHERE MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD'))/12 > 19                                   -- RR 쓰는 거 기억하기!!!!!!!!! YY RR 차이 !!!!!
    AND MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD'))/12 <= 20;

SELECT MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD'))/12
FROM TB_STUDENT;




-- 6. 2020년 크리스마스의 요일을 구하라
SELECT TO_CHAR(TO_DATE('2020/12/25'),'DAY')                                                                                 -- !!!!! T0_CHAR TO_DATE !!!!! 형식 몰랐음!!!!!!!! 틀림!!!!!!!!!!!
FROM DUAL;                                                                                                                  -- DAY 월요일 DY 월 D 2 / TO_DATE 안의 형식 2020-12-25도 20/12/25 도 기타 등등 다 됨 한번 해보기




-- 7. TO_DATE('99/12'11', 'YY/MM/DD'), TO_DATE('49/10'11', 'YY/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미하나?
--    TO_DATE('99/12'11', 'RR/MM/DD'), TO_DATE('49/10'11', 'RR/MM/DD')는??

-- 1) 2099년 12월 11일 / 2049년 10월 11일 2) 1999년 12월 11일 / 2049년 10월 11일
-- YY는 모두 2000년대
-- RR은 49이하는 2000년대 50이상은 1900년대(한 세기 전)
SELECT TO_CHAR(TO_DATE('99/10/11', 'YY/MM/DD'),'YYYY'), 
       TO_CHAR(TO_DATE('49/10/11', 'YY/MM/DD'),'YYYY'),
       TO_CHAR(TO_DATE('99/10/11', 'RR/MM/DD'), 'RRRR'), 
       TO_CHAR(TO_DATE('49/10/11', 'RR/MM/DD'), 'RRRR')
FROM DUAL;




-- 8. 춘 기술대학교 2000 년도 이후 입학자들은 학번이 A로 시작함. 2000년도 이전 학번 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하라.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';

-- 9. 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL문을 작성하라.
--    단, 출력 화면의 헤더는 "평점"이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시
SELECT ROUND(AVG(TG.POINT),1) AS "평점"                                                                                      -- 뻘짓함 이너조인 쓸 필요 없었음 앞으로는 데이터를 꼼꼼히 보자!!!
FROM TB_STUDENT TS
INNER JOIN TB_GRADE TG ON (TS.STUDENT_NO = TG.STUDENT_NO)
GROUP BY TS.STUDENT_NO
HAVING TS.STUDENT_NO = 'A517178';

SELECT ROUND(AVG(POINT), 1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

-- 10. 학과별 학생수를 구하여 "학과번호", "학생수(명)"의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
SELECT DEPARTMENT_NO AS "학과번호",
       COUNT(DEPARTMENT_NO) AS "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 SQL문을 작성하라
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;




-- 12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하라.
--     단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점"이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시

SELECT SUBSTR(TERM_NO,1,4) AS "년도",
       ROUND(AVG(NVL(POINT,0)), 1) AS "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'                                                                                                -- !!!!!WHERE GROUP BY 작성 순서 신경써!!!!!틀림!!!!!!!!
GROUP BY SUBSTR(TERM_NO,1,4)                                                                                                -- FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY
ORDER BY 년도;




-- 13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.
SELECT DEPARTMENT_NO, COUNT(*)                                                                                              -- 내가 한 거 밑에는 예시 코드!!!!! 틀림!!!!!!!틀림!!!!!!!!
FROM TB_STUDENT                                                                                                             -- 모든 그룹 함수는 NULL값을 자동으로 제외하고 값이 있는 것들만 계산함
WHERE ABSENCE_YN = 'Y'
GROUP BY DEPARTMENT_NO
ORDER BY 1;

SELECT DEPARTMENT_NO 학과코드명, COUNT(DECODE(ABSENCE_YN, 'Y', '1', NULL)) "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;





-- 14. 춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다. SQL 만들어라
SELECT STUDENT_NAME AS "동일이름", COUNT(*) AS "동명인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*) >= 2
ORDER BY 1;



--15. 학번이 A112113인 김고운 학생의 년도, 학기별 평점과 년도 별 누적 평점, 총 평점을 구하는 SQL문을 작성하시오.
--    단, 평점은 소수점 1자리까지만 반올림하여 표시한다.
SELECT SUBSTR(TERM_NO, 1, 4),SUBSTR(TERM_NO, 5,2), ROUND(AVG(POINT), 1)                                                     -- !!!!! 그룹 별 집계 내는 함수 ROLL UP, CUBE!!!!!
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4),SUBSTR(TERM_NO, 5,2))
ORDER BY 1;
    /*
        1) ROLLUP([,...])
            - 그룹 별 산출한 결과 값의 집계를 계산하는 함수
            - 첫 번째 매개값으로만 중간 집계를 내는 함수
        
        2) CUBE([,...])
            - 그룹 별 산출한 결과 값의 집계를 계산하는 함수
            - 매개값으로 전달된 모든 컬럼으로 중간 집계를 내는 함수 
    */





/*-- ADDITIONAL SELECT  - Option*/

-- 1. 학생 이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름과 오름차순으로 표시
SELECT STUDENT_NAME AS "학생 이름", STUDENT_ADDRESS AS "주소지"
FROM TB_STUDENT
ORDER BY 1;

-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;

-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하라
--    출력헤더 "학생이름", "학번", "거주지 주소"
SELECT STUDENT_NAME AS "학생이름",
       STUDENT_NO AS "학번",
       STUDENT_ADDRESS AS "거주지 주소"
FROM TB_STUDENT
WHERE (STUDENT_ADDRESS LIKE '경기도%' OR STUDENT_ADDRESS LIKE '강원도%') AND STUDENT_NO LIKE '9%'                             -- 괄호 치는 거 잊지 말기 NOT AND OR 순서!
ORDER BY STUDENT_NAME;

-- 4. 현재 법학과 교수 중 나이가 많은 사람부터 이름을 확인할 수 있는 SQL문을 작성하시오.
SELECT *
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '법학과';

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO = '005'
ORDER BY 2;

SELECT P.PROFESSOR_NAME, P.PROFESSOR_SSN
FROM TB_PROFESSOR P
INNER JOIN TB_DEPARTMENT D ON (P.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '법학과'
ORDER BY 2;



-- 5. 2004년 2학기에 'C3118100'과목을 수강한 학생들의 학점을 조회하라. 학점이 높은 학생부터 표시하고 학점이 같으면 학번이 낮은 학생부터 표시
SELECT STUDENT_NO, TO_CHAR(POINT, '9.99')                                                                                   -- TO_CHAR로 소수점까지 표현하는 법 잘 보기!
FROM TB_GRADE
WHERE TERM_NO = 200402 AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;                                                                                            -- 여러 개의 정렬 기준 콤마로 구분



-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력
SELECT S.STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME
FROM TB_STUDENT S
INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
ORDER BY 2;

-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL문장을 작성하시오
SELECT C.CLASS_NAME, D.DEPARTMENT_NAME
FROM TB_CLASS C
INNER JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO)
ORDER BY 2,1;

-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL문을 작성하시오.
SELECT C.CLASS_NAME, P.PROFESSOR_NAME
FROM TB_CLASS C
INNER JOIN TB_CLASS_PROFESSOR CP ON (C.CLASS_NO = CP.CLASS_NO)
INNER JOIN TB_PROFESSOR P ON (CP.PROFESSOR_NO = P.PROFESSOR_NO)
ORDER BY 2, 1;

-- 9. 8번 결과 중 '인문사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다. 이에 해당하는 과목 이름과 교수 이름을 출력하라
SELECT C.CLASS_NAME, P.PROFESSOR_NAME
FROM TB_CLASS C
INNER JOIN TB_CLASS_PROFESSOR CP ON (C.CLASS_NO = CP.CLASS_NO)
INNER JOIN TB_PROFESSOR P ON (CP.PROFESSOR_NO = P.PROFESSOR_NO)
INNER JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.CATEGORY = '인문사회'
ORDER BY 2, 1;




-- 10. 음악학과 학생들의 평점을 구하고 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL문장을 작성하시오.
--    평점은 소수점 1자리까지만 반올림하여 표시
SELECT S.STUDENT_NO, S.STUDENT_NAME, ROUND(AVG(POINT),1)
FROM TB_STUDENT S
INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
WHERE D.DEPARTMENT_NAME = '음악학과'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME;                                                                                      -- !!!!!정렬 할 때 제대로 잘 보기 하나인지두개인지 그이상인지!!!!!




-- 11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이 때 사용할 SQL문을 작성하시오
--     단, 출력헤더는 "학과 이름", "학생 이름", "지도교수이름"으로 출력
SELECT D.DEPARTMENT_NAME AS "학과 이름",
       S.STUDENT_NAME AS "학생 이름",
       P.PROFESSOR_NAME AS "지도교수이름"
FROM TB_STUDENT S
INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
INNER JOIN TB_PROFESSOR P ON (S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

-- 12. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL문장을 작성하시오.
SELECT *
FROM TB_STUDENT;
SELECT *                                                                                                                    -- !!!!!다시 풀어보기!!!!!
FROM TB_CLASS;
SELECT *
FROM TB_DEPARTMENT;
SELECT *
FROM TB_GRADE;

SELECT S.STUDENT_NAME, G.TERM_NO
FROM TB_STUDENT S
INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
INNER JOIN TB_CLASS C ON (G.CLASS_NO = C.CLASS_NO)
WHERE SUBSTR(G.TERM_NO, 1, 4) = '2007' AND C.CLASS_NAME = '인간관계론';  

-- 13. 예체능 계열 과목 중 과목 담당 교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력하는 SQL문을 작성하시오.
SELECT *
FROM TB_CLASS;
SELECT *
FROM TB_CLASS_PROFESSOR
;
SELECT *
FROM TB_DEPARTMENT
WHERE CATEGORY = '예체능';



SELECT C.CLASS_NAME, D.DEPARTMENT_NAME
FROM TB_CLASS C
LEFT JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO)
LEFT JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
WHERE D.CATEGORY = '예체능'
AND CP.PROFESSOR_NO IS NULL
ORDER BY 2, 1;





-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생 이름과 지도 교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 '지도교수 미지정'으로 표시하도록 SQL문을 작성하시오.
--     단, 출력헤더는 "학생이름", "지도교수"로 표시하며 고학번이 먼저 표시되도록 한다.
SELECT S.STUDENT_NAME AS "학생이름", NVL(P.PROFESSOR_NAME, '지도교수 미지정') AS "지도교수"                                    -- !!!!! 다시 풀어보기 !!!!!
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR P ON (S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
LEFT JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '서반아어학과'
ORDER BY S.STUDENT_NO;





-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL문을 작성하시오.
SELECT S.STUDENT_NO AS "학번",
       S.STUDENT_NAME AS "이름",
       D.DEPARTMENT_NAME AS "학과 이름",
       AVG(POINT) AS "평점"
FROM TB_STUDENT S
INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE S.ABSENCE_YN = 'N'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY S.STUDENT_NO;




-- 16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL문을 작성하시오.
SELECT G.CLASS_NO, C.CLASS_NAME, TRUNC(AVG(POINT), 8)                                                                      -- TRUNC 소수점 지정 가능 버림 함수 FLOOR 소수점 지정 불가능 버림 함수
FROM TB_GRADE G
INNER JOIN TB_CLASS C ON (G.CLASS_NO = C.CLASS_NO)
INNER JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '환경조경학과' AND C.CLASS_TYPE LIKE '전공%'
GROUP BY G.CLASS_NO, C.CLASS_NAME
ORDER BY 1;




-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL문을 작성하시오.
SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                         FROM TB_STUDENT
                         WHERE STUDENT_NAME = '최경희'
)
;




-- 18. 국어국문학과에서 총점수가 가장 높은 학생의 이름과 학번을 표시하는 SQL구문을 작성하시오.                                       -- !!!!!또 풀어보기!!!!!
SELECT S.STUDENT_NAME, S.STUDENT_NO, AVG(POINT)
FROM TB_STUDENT S
INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '국어국문학과'
GROUP BY S.STUDENT_NAME, S.STUDENT_NO
ORDER BY 3 DESC;

SELECT STUDENT_NO, STUDENT_NAME                                                                                             -- S.STUDENT_NAME 이런식으로 쓰면 안 나옴 
FROM (SELECT RANK() OVER(ORDER BY AVG(POINT) DESC) AS "RANK", S.STUDENT_NAME, S.STUDENT_NO                                  -- JOIN구문 식을 서브쿼리로 넣었으니 그냥 STUDENT_NAME이라고 적기
      FROM TB_STUDENT S
      INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
      INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
      WHERE D.DEPARTMENT_NAME = '국어국문학과'
      GROUP BY S.STUDENT_NAME, S.STUDENT_NO)
WHERE "RANK" = 1;

    -- 18번 예시 식
SELECT MAX(AVG(POINT))
FROM TB_STUDENT S
INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '국어국문학과'
GROUP BY S.STUDENT_NAME, S.STUDENT_NO;

SELECT S.STUDENT_NAME, S.STUDENT_NO
FROM TB_STUDENT S
INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '국어국문학과'
GROUP BY S.STUDENT_NAME, S.STUDENT_NO
HAVING AVG(POINT) = (SELECT MAX(AVG(POINT))
                     FROM TB_STUDENT S
                     INNER JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
                     INNER JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
                     WHERE D.DEPARTMENT_NAME = '국어국문학과'
                     GROUP BY S.STUDENT_NAME, S.STUDENT_NO
);



-- 19. 춘기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을파악하기 위한 SQL문을작성하시오.
-- 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
SELECT CATEGORY
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '환경조경학과';

SELECT DEPARTMENT_NAME AS "계열 학과명",
       ROUND(AVG(POINT), 1) AS "전공평점"
FROM TB_DEPARTMENT
INNER JOIN TB_CLASS USING (DEPARTMENT_NO)
INNER JOIN TB_GRADE USING (CLASS_NO)
WHERE CATEGORY = (SELECT CATEGORY
                  FROM TB_DEPARTMENT
                  WHERE DEPARTMENT_NAME = '환경조경학과'
)
AND CLASS_TYPE LIKE '%전공%'
GROUP BY DEPARTMENT_NAME
ORDER BY 1;





/*        DDL        */

-- 1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

-- 2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
CREATE TABLE TB_CLASS_TYPE (
    NO VARCHAR2(5),
    NAME VARCHAR2(10),
    CONSTRAINT TB_CLASS_TYPE_NO_PK PRIMARY KEY(NO)                                                                          -- COSTRAINT 제약조건명 제약조건(컬럼명)
);



-- 3. TB_CATEGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오.
ALTER TABLE TB_CATEGORY ADD CONSTRAINT TB_CATEGORY_NAME_PK PRIMARY KEY(NAME);                                               -- !!!!! ADD 넣는 거 잊지 말기!!!!!
                                                                                                                            -- 제약조건 생성 ALTER 테이블 ADD [제약조건명] 제약조건(컬럼명)


-- 4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
ALTER TABLE TB_CLASS_TYPE MODIFY NAME CONSTRAINT TB_CLASS_TYPE_NAME_NN NOT NULL;                                            -- NOT NULL 변경 > 3.ALTER ADD와 비교
                                                                                                                            -- ALTER 테이블 MODIFY 컬럼명 [제약조건명] NOT NULL


-- 5. 두 테이블에서 컬럼명이 NO인 것은 기존 타입을 유지하면서 크기는 10으로,
--    컬럼명이 NAME인 것은 마찬가지로 기존 타입을 유지하면서 크기 20으로 변경하시오.
SELECT * FROM TB_CATEGORY;
SELECT * FROM TB_CLASS_TYPE;

ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10);                                                                           -- 데이터 타입 변경 > ALTER 테이블 MODIFY 컬럼명 자료형
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);



-- 6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각각 TB_를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다.
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;                                                                -- 컬럼명 변경 > ALTER 테이블명 RENAME COLUMN 컬럼명 TO 바꿀컬럼명
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;



-- 7. TB_CATEGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
ALTER TABLE TB_CATEGORY RENAME CONSTRAINT TB_CATEGORY_NAME_PK TO PK_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME CONSTRAINT TB_CLASS_TYPE_NO_PK TO PK_NO;
