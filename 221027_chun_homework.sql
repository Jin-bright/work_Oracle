--   221027 chun 계정으로 
-- 1. 의학계열 학과 학생들의 학번/학생명/학과명 조회 

select s.student_no, s.student_name, d.department_name
from tb_student s join tb_department d
            on s.department_no = d.department_no
where  d.category like '%의학%';

--2. 2005학년도 입학생의 학생명 /담당교수명 조회 ( null 도 조회)
select s.student_name,
            nvl(p.professor_name,'없음')
from  tb_student s left join tb_professor p
        on s.coach_professor_no = p.professor_no
where extract ( year from entrance_date) = 2005;

--3. 자연과학계열의 수업명 ,학과명 조회 
SELECT c.class_name,
                d.department_name, d.category
FROM tb_class c  join tb_department d
            on c.department_no = d.department_no
where d.category = '자연과학';            
    

-- 4. 담당학생이 한명도 없는 교수 조회
-- 학생테이블
SELECT *
FROM tb_student;

-- 교수테이블
SELECT *
FROM tb_professor;

-- 교수테이블
SELECT 
                s.student_name,
                s.coach_professor_no,
                p.professor_no,  
                 p.professor_name
FROM  tb_professor p left join tb_student s 
            on  p.professor_no = s.coach_professor_no
where s.coach_professor_no is null;


-- 221027  @실습문제 - chun
--1. 학번, 학생명, 계열, 학과명 조회 -- 학과 지정이 안된 학생은 존재하지 않는다.
select  s.student_no "학번",
            s.student_name "학생명",
            d.category "계열",
            d.department_name "학과명"
from tb_student s join tb_department d
        on s.department_no = d.department_no;

--2. 수업번호, 수업명, 교수번호, 교수명 조회
select c.class_no "수업번호", 
            c.class_name "수업명",
            cp.professor_no "교수번호",
            p.professor_name "교수명"
from  tb_class c join  tb_class_professor  cp
        on c.class_no = cp.class_no
            join tb_professor p
        on  cp.professor_no = p.professor_no;

--3. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)
select 
g.term_no "학기",
s.student_no "학번",
s.student_name "학생명",
c.class_name "수업명",
g.point "점수"
from tb_student s left  join  tb_grade g 
                on s.student_no = g.student_no
            left join   tb_class c
                on g.class_no = c.class_no
where s.student_name ='송박선'
order by "학기";

--4. 학생별 전체 평점(소수점이하 첫째자리 버림) 조회 (학번, 학생명, 평점)
--같은 학생이 여러학기에 걸쳐 같은 과목을 이수한 데이터 있으나, 전체 평점으로 계산함.

select
            c.student_no "학번",
            s.student_name "학생명",
            c.stupoint "평점"
from tb_student s left  join (  SELECT   student_no,  trunc( (sum(point) / count ( student_no)),1)   stupoint 
                                                     FROM tb_grade    group by student_no ) c
                                               on   s.student_no =  c.student_no ;




-- 4번 학번/평점 ok 
SELECT   student_no "학번", trunc( (sum(point) / count ( student_no)),1 )"평점"
FROM tb_grade group by student_no;


--5. 교수번호, 교수명, 담당학생명수 조회 -- 단, 5명 이상의 학생이 담당하는 교수만 출력
select
    p.professor_no "교수번호",
    p.professor_name "교수명",
    count(s.coach_professor_no  ) "담당학생수"

from tb_student  s right outer  join  tb_professor p   
            on s.coach_professor_no = p.professor_no  

group by p.professor_no,  p.professor_name
having count(s.coach_professor_no ) >=5;





--  이건 잘못구했는데 왜 이렇게 하면 안나오는거지 ? 
--  이렇게 하면 교수명 + 담당학생 이름까지는 나옴  . 이 학생수를 어떻게 count 하지 ?
select p.professor_no "교수번호",
            p.professor_name "교수명",
            s.student_name "담당학생이름",
            cc.num
from  tb_professor p join tb_student s
                on p.professor_no =  s.coach_professor_no   
            cross join ( 
            select  count(s.coach_professor_no  ) num
            from tb_student  s right outer  join  tb_professor p   on s.coach_professor_no = p.professor_no  group by p.professor_no)  cc  ;
