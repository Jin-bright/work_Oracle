/* 221026_ 경매문제 
## @실습문제:경매
a. 경매테이블에서 경매번호, 경매종료시각, 남은시간(일시분초)를 출력.
b. tbl_auction 테이블에서 종료일자까지 하루미만인것만 경매번호, 종료일자, 남은기간으로 나타내세요.

2. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오
=> decode, sum 사용

-------------------------------------------------------------------------
 1998년   1999년   2000년   2001년   2002년   2003년   2004년  전체직원수
-------------------------------------------------------------------------
*/
    create table tbl_auction(
        auction_no number,
        expire_date date  );
    
    insert into tbl_auction values(1,to_date('2022-10-25 22:00:00','yyyy-mm-dd hh24:mi:ss'));
    insert into tbl_auction values(2,to_date('2022-10-26 22:00:00','yyyy-mm-dd hh24:mi:ss'));
    insert into tbl_auction values(3,to_date('2022-10-27 23:00:00','yyyy-mm-dd hh24:mi:ss'));
    insert into tbl_auction values(4,to_date('2022-11-01 14:00:00','yyyy-mm-dd hh24:mi:ss'));
    commit;
    
    select * from tbl_auction;
    
    select auction_no as "경매번호",
        to_char(expire_date,'yyyy-mm-dd hh24:mi:ss') as "종료일자"
    from tbl_auction;

--a. 경매테이블에서 경매번호, 경매종료시각, 남은시간(일시분초)를 출력.
--  단,    numtodsinterval(expire_date-sysdate,'day') "남은기간" 이 인터벌로 해보기 

    select auction_no as "경매번호", 
                to_char(expire_date,'yyyy-mm-dd hh24:mi:ss') as "종료일자",
             numtodsinterval( expire_date - sysdate, 'day')  "일"
             -- 이런식으로 해서 extract로 일/시간/분/초 이렇게 추출하면됨 
    from tbl_auction;
    
-- 2. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
-- 아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오
-- => decode, sum 사용
    
select * from employee;

-- 이런식으로 푸는거 생각해보기 ,, 와우,,
-- 근데 sum은 그룹함수 아닌가 ?
select
    sum(decode(to_char(hire_date, 'yyyy'), '1998', 1, 0)) "1998년",
    sum(decode(to_char(hire_date, 'yyyy'), '1999', 1, 0)) "1999년",
    sum(decode(to_char(hire_date, 'yyyy'), '2000', 1, 0)) "2000년",
    sum(decode(to_char(hire_date, 'yyyy'), '2001', 1, 0)) "2001년",
    sum(decode(to_char(hire_date, 'yyyy'), '2002', 1, 0)) "2002년",
    sum(decode(to_char(hire_date, 'yyyy'), '2003', 1, 0)) "2003년",
    sum(decode(to_char(hire_date, 'yyyy'), '2004', 1, 0)) "2004년",
    count(*) "전체직원수"
from
    employee;
    
-- <<  선생님 답 >> 
--1-a. 경매테이블에서 경매번호, 경매종료시각, 남은시간(일시분초)를 출력.
-- 방법 1) 

    select auction_no 경매번호,
          to_char(expire_date,'yyyy-mm-dd hh24:mi:ss') "경매마감시각",
          --trunc((expire_date -sysdate)*24*60*60) "남은 초수",
          trunc(trunc((expire_date -sysdate)*24*60*60)/60/60/24)||'일 '||
          mod(trunc(trunc((expire_date -sysdate)*24*60*60)/60/60),24)||'시간 '||
          mod(trunc(trunc((expire_date -sysdate)*24*60*60)/60),60)||'분 '||
          mod(trunc((expire_date -sysdate)*24*60*60),60)||'초' "남은 기간"
    from tb_auction;

    --★  인터벌로 해결해보자 ★
    select auction_no 경매번호,
                expire_Date, 
                expire_date-sysdate
      --          numtodsinterval(expire_date-sysdate,'day') "남은기간"
             ,extract ( day from numtodsinterval(expire_date-sysdate,'day')) 일
             ,extract ( hour from numtodsinterval(expire_date-sysdate,'day')) 시간
             ,extract ( minute from numtodsinterval(expire_date-sysdate,'day')) 분
            ,extract ( second from numtodsinterval(expire_date-sysdate,'day')) 초
    from tbl_auction
    where (expire_date - sysdate ) >0 and  (expire_date - sysdate ) <1  ;
    --where expire_date - sysdate between 0 and 1; 

1-b. tbl_auction 테이블에서 종료일자까지 하루미만인것만 경매번호, 종료일자, 남은기간으로 나타내세요.

    select auction_no 경매번호,
          to_char(expire_date,'yyyy-mm-dd hh24:mi:ss') "경매마감시각",
          trunc(trunc((expire_date -sysdate)*24*60*60)/60/60/24)||'일 '||
          mod(trunc(trunc((expire_date -sysdate)*24*60*60)/60/60),24)||'시간 '||
          mod(trunc(trunc((expire_date -sysdate)*24*60*60)/60),60)||'분 '||
          mod(trunc((expire_date -sysdate)*24*60*60),60)||'초' "남은 기간"
    from tb_auction
    where expire_date-sysdate < 1;




2. 

    select sum(decode(extract(year from hire_date),1998,1)) as "1998년"
         , sum(decode(extract(year from hire_date),1999,1)) as "1999년"
         , sum(decode(extract(year from hire_date),2000,1)) as "2000년"
         , sum(decode(extract(year from hire_date),2001,1)) as "2001년"
         , sum(decode(extract(year from hire_date),2002,1)) as "2002년"
         , sum(decode(extract(year from hire_date),2003,1)) as "2003년"
         , sum(decode(extract(year from hire_date),2004,1)) as "2004년"
         , sum(*) as 전체직원수
    from employee
    where quit_yn = 'N';
    
    /*
221026 chun    @실습문제풀이
    */

--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열" 으로 표시하도록 한다.
SELECT department_name " 학과 명"
                , category "계열"
FROM tb_department;

-- << 쌤답 >> 
--1번
SELECT DEPARTMENT_NAME AS "학과 명",
       CATEGORY AS 계열
FROM TB_DEPARTMENT;


-- 2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력핚다.
select  department_name || '의 정원은 ' ||  capacity || '명 입니다.' "학과별 정원"
from tb_department;

-- << 쌤답 >> 
SELECT DEPARTMENT_NAME ||'의 정원은 '|| CAPACITY ||' 명 입니다.' AS "학과별 정원"
FROM   TB_DEPARTMENT;


--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 누구인가?
-- (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
SELECT tb_student.student_name
FROM tb_student, tb_department
where ( substr(student_ssn,8,1)='2'  or substr(student_ssn,8,1)='4')  and 
            ( tb_student.department_no = '001' and  tb_department.department_no='001')  and
             (tb_student.absence_yn='Y') ;
             
-- << 쌤답 >>
select *
from tb_student;

--국어국문학과 학과코드 구하기 --001
SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME='국어국문학과';

--국어국문학과, 휴학생, 여학생
SELECT STUDENT_NAME
FROM   TB_STUDENT
WHERE  DEPARTMENT_NO='001'
AND    ABSENCE_YN      ='Y'
AND SUBSTR(STUDENT_SSN, 8, 1) = 2;


-- 4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 그 대상자들 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오
--A513079, A513090, A513091, A513110, A513119
SELECT *
FROM tb_student
where student_no BETWEEN 'A513079' and 'A513119';
-- << 쌤답 >>
SELECT STUDENT_NAME
FROM   TB_STUDENT
WHERE  STUDENT_NO IN ('A513079','A513090','A513091','A513110','A513119');


-- 5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오
SELECT department_name, category
FROM tb_department
WHERE capacity >= 20 and capacity <= 30;
-- << 쌤답 >>
SELECT DEPARTMENT_NAME,
       CATEGORY
FROM   TB_DEPARTMENT
WHERE CAPACITY > 20 AND CAPACITY < 30;
--WHERE  CAPACITY BETWEEN 20 AND 30;


-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다. 그럼 춘기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
SELECT professor_name
FROM tb_professor
where department_no is null;
-- << 쌤답 >>
SELECT PROFESSOR_NAME
FROM   TB_PROFESSOR
WHERE  DEPARTMENT_NO IS NULL;

--7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.
SELECT *
FROM tb_student
WHERE department_no is null;
-- << 쌤답 >>
SELECT *
FROM   TB_STUDENT
WHERE  DEPARTMENT_NO IS NULL;

--8. . 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오.
SELECT class_no
FROM tb_class
where preattending_class_no is not null;
-- << 쌤답 >>
SELECT CLASS_NO
FROM   TB_CLASS
WHERE  PREATTENDING_CLASS_NO IS NOT NULL;

-- 9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
SELECT DISTINCT category
FROM tb_department
order by category;
-- << 쌤답 >>
SELECT DISTINCT CATEGORY 
FROM   TB_DEPARTMENT;


-- 10. 02 학번 전주 거주자들의 모임을 맊들려고 핚다. 휴학핚 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오
-- 오답 :     EXTRACT(YEAR FROM ENTRANCE_DATE) = 2002 

SELECT student_no, student_name, student_ssn
FROM tb_student
where (student_no like 'A2%') and (student_address like '%전주%') and absence_yn='N'
ORDER by student_name;

-- << 쌤답 >> 
SELECT STUDENT_NO,
       STUDENT_NAME,
          STUDENT_SSN 
FROM   TB_STUDENT
WHERE  
    EXTRACT(YEAR FROM ENTRANCE_DATE) = 2002
    AND    ABSENCE_YN='N'
    AND    STUDENT_ADDRESS LIKE '%전주%';
    