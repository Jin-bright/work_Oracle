-- * 221028_ @실습문제
-- 1. 2020년 12월 25일이 무슨 요일인지 조회하시오.

select to_char( to_date('2020/12/25'), 'yyyy/mm/dd day')
from dual;

-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.

select e.emp_name "사원명", 
            e.emp_no "주민번호", 
            d.dept_title "부서명",
            j.job_name "직급"
from 
        employee e left join job j 
            on e.job_code  = j.job_code
        left join department  d
            on  e.dept_code = d.dept_id
            
where (substr(e.emp_no,1,1)='7') and   (substr(e.emp_no,8,1)='2') and   e.emp_name like '전%';

--★  3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
--1)  나이 적은 순 대로 정렬  
select 
                 e.emp_id "사번",
            e.emp_name "사원명", 
trunc(months_between( sysdate, to_date(decode(substr(e.emp_no,8,1),'1',1900,'2',1900,2000)+ substr(e.emp_no,1,2) || substr(e.emp_no,3,4)) )/12) "만나이",
            d.dept_title "부서명",
            j.job_name "직급"
        
from 
        employee e left join job j 
            on e.job_code  = j.job_code
        left join department  d
            on  e.dept_code = d.dept_id
            
group by e.emp_id, e.emp_name, e.emp_no, d.dept_title, j.job_name
order by 만나이;

--2) only  나이만 조회가능, ,
select 
min(trunc(months_between( sysdate, to_date(decode(substr(e.emp_no,8,1),'1',1900,'2',1900,2000)+ substr(e.emp_no,1,2) || substr(e.emp_no,3,4)) )/12)) "나이"
from 
        employee e left join job j 
            on e.job_code  = j.job_code
        left join department  d
            on  e.dept_code = d.dept_id;

--3) 특정조건식 걸어서 조회 

 select 
                 e.emp_id "사번",
            e.emp_name "사원명", 
trunc(months_between( sysdate, to_date(decode(substr(e.emp_no,8,1),'1',1900,'2',1900,2000)+ substr(e.emp_no,1,2) || substr(e.emp_no,3,4)) )/12) "만나이",
            d.dept_title "부서명",
            j.job_name "직급"
        
from 
        employee e left join job j 
            on e.job_code  = j.job_code
        left join department  d
            on  e.dept_code = d.dept_id
            
where substr(e.emp_no,1,2) = '07' 
            
group by e.emp_id, e.emp_name, e.emp_no, d.dept_title, j.job_name
order by 만나이;


--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.

select  e.emp_id "사번",
             e.emp_name "사원명", 
             d.dept_title "부서명"
from 
        employee e left join department  d
            on  e.dept_code = d.dept_id
where  e.emp_name like '%형%';


--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.

select   e.emp_name "사원명", 
             j.job_name "직급명",
             d.dept_id "부서코드",
             d.dept_title "부서명"
from   employee e left join job j 
                on e.job_code  = j.job_code
            left join department  d
                on  e.dept_code = d.dept_id;
where  d.dept_title like '%해외영업%';

--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

select   e.emp_name "사원명", 
              e.bonus "보너스포인트",
             d.dept_title "부서명",
             l.local_name  "근무지역명"
from   employee e left join department  d
                on  e.dept_code = d.dept_id
            left join location l
                on d.location_id = l.local_code
where  e.bonus is not null;

--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.

select   e.emp_name "사원명", 
              j.job_name  "직급명",
             d.dept_title "부서명",
             l.local_name  "근무지역명"
from   employee e  left join job j
                on e.job_code = j.job_code             
            left join department  d
                on  e.dept_code = d.dept_id
            left join location l
                on d.location_id = l.local_code
where  d.dept_id = 'D2';


--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
select e.emp_name "사원명",  j.job_name  "직급명",  e.salary "급여",    e.salary *12 "연봉"
  
from employee e left join  job j 
            on e.job_code = j.job_code 
          left join sal_grade s
             on e.sal_level =  s.sal_level 
where     e.salary >  s.max_sal ;
          
          
--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.

select   e.emp_name "사원명",     d.dept_title "부서명",      l.local_name "지역명",             n.national_name "국가명"
from 
        employee e left join department  d
            on  e.dept_code = d.dept_id
        left join location l
            on d.location_id = l.local_code
        left join nation n
            on l.national_code = n.national_code
where n.national_code = 'KO' or n.national_code  = 'JP';

--  10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.  self join 사용
-- 1) 총 88행  +2행(null) ★ null인 애들 이름나오게 하려면 ? 

select   e.emp_name"사원명",
              nvl(e.dept_code,'인턴') "부서코드",
              p.emp_name "동료이름"             
from    employee e left join employee p 
                on e.dept_code = p.dept_code                
where  (e.dept_code = p.dept_code) or (e.dept_code is null and  p.dept_code  is null) 
order by 부서코드;

--2) 자기 이름 중복안되게 하면 null인애들은 안나옴 
select   e.emp_name"사원명",
              nvl(e.dept_code,'인턴') "부서코드",
              p.emp_name "동료이름"
              
from employee e left join employee p 
            on e.dept_code = p.dept_code
where  (e.dept_code = p.dept_code)  and  (e.emp_name != p.emp_name) 
order by 부서코드;


--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select e.emp_name"사원명", 
                j.job_name "직급명",  
                e.salary"급여"
from employee e left join job  j
            on e.job_code = j.job_code                 
where e.bonus is null and (j.job_name in ('차장', '사원')) ;



--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.

select sum( decode(quit_yn,'N',1,0))  as "재직중 직원수",
            sum( decode(quit_yn,'Y',1,0))  as "퇴사한 직원수"
from employee;
