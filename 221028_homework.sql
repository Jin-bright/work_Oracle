--221028  @실습문제 - chun

-- 학과 테이블
SELECT *FROM tb_department;
-- 학생테이블
SELECT * FROM tb_student;
-- 교수테이블
SELECT * FROM tb_professor;
-- 과목 테이블
SELECT * FROM tb_class;
-- 과목-교수 테이블
SELECT * FROM tb_class_professor;
-- 학점 테이블
SELECT * FROM tb_grade;

--1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른순으로 표시하는  SQL 문장을 작성하시오.
-- ( 단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 핚다.)

SELECT  s.student_no 학번,
                s.student_name 이름, 
                to_char(s.entrance_date,'yyyy-mm-dd')   입학년도
                
FROM tb_student s join tb_department d  
            on s.department_no = d.department_no
where s.department_no = '002'
order by s.entrance_date;

-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 핚 명 있다고 핚다. 
-- 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. 
-- (* 이때 올바르게 작성핚 SQL  문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)

--  원인 ? 뭐지 ,, 잘나오는데,, 이름 와일드카드 잘못쓰면 안나올거같고, like 연산자 말고 = 이런 동등비교연산자 쓰면 안나올거같음 
SELECT  professor_name "이름",
                tb_professor.professor_ssn "주민번호"
FROM tb_professor
where professor_name not like '___';

-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 
-- 단 이때 나이가 적은 사람에서 맋은 사람 순서로 화면에 출력되도록 만드시오. 
-- (단, 교수 중 2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로 계산한다.)
-- ★ 만나이(공식) = trunc(  months_between(오늘, 생일) ) /12
SELECT  professor_name  "교수이름",
                trunc(months_between(sysdate,   1900 + substr(professor_ssn,1,2) || substr(professor_ssn,3,4))/12) "나이"          
FROM  tb_professor
where   substr(professor_ssn,8,1) = '1' or  ( substr(professor_ssn,8,1) = '3' ) 
order by months_between(sysdate,   1900 + substr(professor_ssn,1,2) || substr(professor_ssn,3,4))/12;


--4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 출력 헤더는 이름‛ 이 찍히도록 한다. 
-- (성이 2 자인 경우는 교수는 없다고 가정하시오)
SELECT  substr(professor_name,2)  "이름"
FROM tb_professor;

--5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 
--이때,  19 살에 입학하면 재수를 하지 않은 것으로 간주한다.  난 246 행나오는데 ,,

SELECT  student_no,
                student_name
--   months_between(entrance_date,
--   to_date((decode( substr(student_ssn,8,1),'1',1900,'2',1900 , 2000)  + substr(student_ssn,1,2) )  ||  substr(student_ssn,3,4), 'yyyy/mm/dd' ))/12+1
--    "나이"

FROM tb_student
where 
months_between(entrance_date,
to_date((decode( substr(student_ssn,8,1),'1',1900,'2',1900 , 2000)  + substr(student_ssn,1,2) )  ||  substr(student_ssn,3,4), 'yyyy/mm/dd' ))/12+1 >= 20


    
--6. 2020 년 크리스마스는 무슨 요일인가?
select  to_char( to_date(20201225), 'yyyy/mm/dd Day' ) "2020년크리스마스"
from dual;

--7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇월 몇 일을 의미할까? 
-- 또 TO_DATE('99/10/11','RR/MM/DD'),  TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까?

-- TO_DATE('99/10/11','YYYY/MM/DD')  => 1999년 10월 11일 
-- TO_DATE('49/10/11','YY/MM/DD') =>1949년 10월 11 일 
-- TO_DATE('99/10/11','RR/MM/DD')  => 1950 ~ 2050 까지 니까 1999년 10월 11일  
-- TO_DATE('49/10/11','RR/MM/DD')  => 2049년 10월 11일 

--8. 춘 기술대학교의 2000 년도 이후 입학자들은 학번이 A 로 시작하게 되어있다. 
--2000 년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오

SELECT student_no "2000년도 전 입학자 학번",
               student_name "이름"
FROM tb_student
where  extract ( year from entrance_date ) < 2000;

--9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 단,
--이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한
--자리까지만  표시한다.

select  round(sum(g.point)/count(g.point),1)  평점
FROM tb_student s join  tb_grade g
            on s.student_no = g.student_no
where g.student_no = 'A517178';

--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
    
select      d.department_no 학과번호,
                  count (s.student_no) "학생수(명)"

from tb_student s  join tb_department d
        on s.department_no = d.department_no
group by s.department_no
order by s.department_no;

--11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오.

SELECT count(*)
FROM tb_student
where tb_student.coach_professor_no is null;

--12. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 
--단,  이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.

select substr(g.term_no,1,4) "년도",
           round( sum(g.point) / count(substr(g.term_no,1,4)),1) "년도 별 평점"
 --              decode(substr(g.term_no,1,4),2001,sum(g.point),2002,sum(g.point),2003,sum(g.point),2004,sum(g.point))
FROM tb_student  s join tb_grade g 
            on s.student_no = g.student_no
where g.student_no = 'A112113'
group by  substr(g.term_no,1,4)
order by  substr(g.term_no,1,4);

--13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.

select  d.department_no "학과코드명",
            sum(decode( s.absence_yn,'Y',1,0)) "휴학생수"
from tb_student s join tb_department d
            on s.department_no =  d.department_no
group by d.department_no
order by d.department_no;

--14. 춘 대학교에 다니는 동명이인학생들의 이름을 찾고자 핚다. 어떤 SQL 문장을 사용하면 가능하겠는가?

SELECT student_name   "동일이름"
                ,count( student_name) "동명인 수"
FROM tb_student         
group by student_name
having count( student_name) >= 2 
order  by tb_student.student_name;

--15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총 평점을 구하는 SQL 문을 작성하시오. 
--(단, 평점은 소수점 1 자리까지맊 반올림하여 표시한다.)
select case 
            when grouping(substr(g.term_no,1,4))= 1 then ' '  
            else substr(g.term_no,1,4)  end "년도",
            case 
            when grouping(substr(g.term_no,5,2))= 1 then ' '
            else  (substr(g.term_no,5,2))   end "학기",
            round(avg(g.point),1)"평점"
            
FROM tb_student  s join tb_grade g 
                on s.student_no = g.student_no
where g.student_no = 'A112113'
group by  rollup(substr(g.term_no,1,4), substr(g.term_no,5,2))
order by decode(년도,'2001',1,'2002',2,'2003',3,'2004',4,5),  
                decode(학기,'01',1,'02',2,'03',3,'04',4,' ',5);
