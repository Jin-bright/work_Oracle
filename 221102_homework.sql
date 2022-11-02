221102 - <DQL종합실습문제>
--문제1-  기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오
select e.emp_name 이름,
            e.dept_code 부서코드,
            e.salary 급여
from employee e join department d 
            on e.dept_code = d.dept_id 
where d.dept_title = '기술지원부';



--★★★ 문제2 - 기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오

1) 연봉 기준 결과 (연봉 계산 => (급여 + (급여*보너스))*12 )
--   연봉이있는 새 테이블 만들기  --
select   e.*,   (e.salary+(e.salary*nvl(e.bonus,0)))*12 annual_sal  from employee e;
-----------------------------------------------
select e.emp_name 이름, 
            e.dept_code 부서코드, 
            e.salary 급여  

from ( select e.*,
                       (e.salary+(e.salary*nvl(e.bonus,0)))*12 annual_sal
            from employee e
 ) e

where annual_sal  = 
( select max ( (e.salary+(e.salary*nvl(e.bonus,0)))*12)  from employee e join department d  on e.dept_code = d.dept_id  where dept_title = '기술지원부' );


2) 급여 기준 결과 
 select e.emp_name 이름,
            e.dept_code 부서코드,
            e.salary 급여
from employee e
where e.salary = ( select max(salary) from employee e join department d  on e.dept_code = d.dept_id  where dept_title = '기술지원부') ;



--문제3 -  매니저가 있는 사원중에 월급이 전체사원 평균보다 많은 사원의   사번,이름,매니저 이름, 월급을 구하시오. 
--1. JOIN을 이용하시오
select e.emp_id 사번,
            e.emp_name 이름 ,
            y.emp_name 매니저이름,
            e.salary 월급
from employee e join employee y 
        on e.manager_id  = y.emp_id 
where e.salary > ( select avg(salary) from employee );

--2. JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기
select e.emp_id 사번,
            e.emp_name 이름 ,
            ( select p.emp_name  from employee p  where p.emp_id = e.manager_id  )  매니저이름,
            e.salary 월급
from employee  e
where e.manager_id  is not null    and 
             e.salary >  ( select avg(salary) from employee );


--문제4 - 같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회
select e.emp_name 이름,
            e.job_code 직급코드,
            e.salary 급여,
            e.sal_level 급여등급      
from employee  e
where  e.salary >=   (  select avg(salary) from employee  where job_code = e.job_code );



-- 문제5 - 부서별 평균 급여가 3000000 이상인 부서명, 평균 급여 조회
-- 단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리
select distinct nvl(d.dept_title,'인턴') 부서명, 
          (  select trunc(avg(salary)) from employee  where nvl(dept_code,'인턴') = nvl(e.dept_code,'인턴') ) 평균급여  
from employee e left join department d
        on e.dept_code = d.dept_id 
where    (  select avg(salary) from employee  where dept_code  = e.dept_code ) >= 3000000;



--문제6 -  직급의 연봉 평균보다 적게 받는 여자사원의 사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오
--연봉 계산 => (급여 + (급여*보너스))*12    
select e.emp_name 사원명,
            ( select job_name from job where job_code = e.job_code ) 직급명,
            ( select dept_title from department  where dept_id = e.dept_code ) 부서명,
            annual_sal 연봉
from ( 
                select e.*,
                            (e.salary+(e.salary*nvl(e.bonus,0)))*12 annual_sal,
                            ( select avg( (salary+(salary*nvl(bonus,0)))*12  ) from employee where job_code = e.job_code ) avg_sal,
                            decode(substr(emp_no,8,1),'2','여','4','여','남') fm
                from employee e
    ) e 
where ( fm='여')  and  ( avg_sal > e.annual_sal);





-문제7
--다음 도서목록테이블을 생성하고, 공저인 도서만 출력하세요.
--공저 : 두명이상의 작가가 함께 쓴 도서
create table tbl_books (
book_title  varchar2(50)
,author     varchar2(50)
,loyalty     number(5)
);

insert into tbl_books values ('반지나라 해리포터', '박나라', 200);
insert into tbl_books values ('대화가 필요해', '선동일', 500);
insert into tbl_books values ('나무', '임시환', 300);
insert into tbl_books values ('별의 하루', '송종기', 200);
insert into tbl_books values ('별의 하루', '윤은해', 400);
insert into tbl_books values ('개미', '장쯔위', 100);
insert into tbl_books values ('아지랑이 피우기', '이오리', 200);
insert into tbl_books values ('아지랑이 피우기', '전지연', 100);
insert into tbl_books values ('삼국지', '노옹철', 200);
insert into tbl_books values ('별의 하루', '대북혼', 300);

-- 책제목 똑같은 이름이 2개 이상 나오면 출력 
select  distinct bt.book_title
from( 
        select book_title, 
                    author,
                    rank() over ( order by  book_title) rank,
                    row_number() over(order by book_title  ) rownumm
        from tbl_books
) bt 
where rownumm - rank >= 1 
