/*
오라클 - git 연동용 ! 

< 221025 숙제 >

파일경로를 제외하고 파일명만 아래와 같이 출력하세요.
    
    create table tbl_files (
        fileno number(3)
        ,filepath varchar2(500)
    );
    insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls');
    insert into tbl_files values(2, 'c:\music.mp3');
    insert into tbl_files values(3, 'c:\documents\resume.hwp');
    commit;
    select * 
    from tbl_files;


출력결과 :
--------------------------
파일번호          파일명
---------------------------
1             salesinfo.xls
2             music.mp3
3             resume.hwp
---------------------------
*/

  create table tbl_files (
         fileno number(3)
        ,filepath varchar2(500)
);

 insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls');
 insert into tbl_files values(2, 'c:\music.mp3');
 insert into tbl_files values(3, 'c:\documents\resume.hwp');
   commit;
   
select * 
from tbl_files;

-- 출력 
SELECT rpad(fileno,4,' ') "파일번호", substr( filepath, instr( filepath, '\', -1)+1) "파일명"
from tbl_files;


 
--221025 실습문제 
-- 1. 직원명과 이메일 , 이메일 길이를 출력하시오
--          이름        이메일        이메일길이
--    ex)     홍길동 , hong@kh.or.kr         13

select emp_name "이름", email "이메일", length(email) "이메일길이" 
from employee;

--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
--    ex) 노옹철    no_hc
--    ex) 정중하    jung_jh

select emp_name, substr(email, 1, instr(email, '@')-1)
from employee;
 
-- 3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오 
--    그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--        직원명    년생      보너스
--    ex) 선동일    1962    0.3
--    ex) 송은희    1963      0

select emp_name,  emp_no, nvl(bonus,0)
from employee
where substr(emp_no,1,1) = '6';
 
-- ★ 4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
--       인원
--    ex) 3명

 select  count(*) || '명'  "사람수"
 from employee
 where  phone not like '010%' ;
 
 
-- 5. 직원명과 입사년월을 출력하시오 
--    단, 아래와 같이 출력되도록 만들어 보시오
--        직원명        입사년월
--    ex) 전형돈        2012년12월
--    ex) 전지연        1997년 3월
 
 select emp_name "직원명", to_char(to_date(hire_date),'yyyy"년" mm"월"') "입사년월"
 from employee;
 
 
-- 6. 직원명과 주민번호를 조회하시오
--    단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서출력 하시오
--    ex) 홍길동 771120-1******
 
 select  emp_name "직원명", replace( emp_no, substr(emp_no, 9),'*******')  "주민번호"
 from employee;
 
-- 7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임

select emp_name "직원명", job_code "직급코드",  to_char(salary*(1+ nvl(bonus,0) )*12,'fml999,999,999') "연봉(원)"
from employee;


-- 8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일

select emp_id "사번", emp_name"사원명", dept_code "부서코드" , hire_date "입사일"
from employee
where dept_code in ('D5','D9') and to_char(hire_date,'yyyy')='2004' ;

-- 9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--      * 주말도 포함 , 소수점 아래는 버림
--     * 퇴사자는 퇴사일-입사일로 계산

select emp_name "직원명", hire_date "입사일", -- quit_yn,  quit_date, nvl2(quit_date,quit_date,to_date(sysdate)) "근무여부",
         trunc( sysdate - ( nvl2(quit_date,quit_date,to_date(hire_date)) )) "근무일수"
from employee;

-- 10. 직원명, 부서코드, 생년월일, 나이(만나이) 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함

select   emp_name "직원명", dept_code "부서코드"
            ,decode(  substr(emp_no,1,1),'0','2000','1900' ) + substr( emp_no,1,2 ) || '년 '
                || to_char ( extract ( month from to_date( substr(emp_no,1,6))) , '00' )  || '월 '
                || to_char( extract ( day from  to_date( substr(emp_no,1,6))), '00' )  || '일'  "생년월일"  
    ,extract(year from sysdate) - ( case  when to_date( substr(emp_no,1,6)) like '0%' then 2000 else 1900   end + substr(emp_no,1,2))+1 "나이"
from employee;


--11.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.


select 
   emp_id, emp_name, emp_no, email, phone, dept_code, 
   case 
    when dept_code = 'D5' then '총무부'
    when dept_code = 'D6' then '기획부'
    when dept_code = 'D9' then '영업부'
    end "부서명"
from employee
where dept_code in( 'D5', 'D6', 'D9') 
order by dept_code;

