-- 221109  @실습문제 - pl/sql 제어문, function, procedure
/*-------------------------------------------------------------------------------------------
1. 사번을 입력받고, 관리자에 대한 성과급을 지급하려하는 익명블럭 작성
    - 관리하는 사원이 5명이상은 급여의 15% 지급 : '성과급은 ??원입니다.'
    - 관리하는 사원이 5명미만은 급여의 10% 지급 : ' 성과급은 ??원입니다.'
    - 관리하는 사원이 없는 경우는 '대상자가 아닙니다.'
-------------------------------------------------------------------------------------------*/
declare 
    v_emp_id employee.emp_id%type  := '&사번'; 
    v_salary number;
    cnt number := 0 ;
begin 

        select  ( select count(manager_id) from employee where manager_id = v_emp_id ) v_cnt,
                     ( select salary  from employee  where emp_id = v_emp_id ) v_sal        
        into cnt , v_salary 
        from employee 
        where manager_id = v_emp_id
        group by manager_id;
 
        
        if cnt < 5 then dbms_output.put_line (  '관리하는 사원 수 : ' || cnt   || ' |  성과급은  ' ||  (v_salary*0.1) ||  '원 입니다.' );
        else 
             dbms_output.put_line (   '관리하는 사원 수 : ' || cnt   || ' |   성과급은  ' ||  (v_salary * 0.15) ||  '원 입니다.' );
        end if;
        
        exception 
            when no_data_found then  dbms_output.put_line ('대상자가 아닙니다.');
        
end;
/
--------------------------------------------------------------------------------------------------------------
2. TBL_NUMBER 테이블에 0~99사이의 난수를 100개 저장하고, 입력된 난수의 합계를 출력하는 익명블럭을 작성하세요.
            TBL_NUMBER테이블(sh 계정)을 먼저 생성후 작업하세요.
            - id number pk : sequence객체 생성후 채번할것.
            - num number : 난수
            - reg_date date : 기본값 현재시각
---------------------------------------------------------------------------------------------------------------
--1) 테이블만들기 
create table  TBL_NUMBER ( 
    id number(5),
    num number(5),
    reg_date date,

    constraint pk_TBL_NUMBER_id primary key(id)
) ;
--2) sequence 만들기 
create sequence seq_tbl_number 
    start with 1
    increment by 1;

--  sequence 이용해서 값 넣을때 보통 
--  insert into tbl_number values(  seq_tbl_number.nextval, trunc(dbms_random.value(0,99)) +1,sysdate);

-- 3)  반복문으로 값  넣기 
declare 
    num number :=  1;
begin 
    while  num <=100
        loop
                insert into tbl_number values(  seq_tbl_number.nextval, trunc(dbms_random.value(0,99)) +1,sysdate);
                num := num+1;
       end loop;
end;
/
-- ** 조회        
select * From TBL_NUMBER

--** 시퀀스의 번호를 알아보자 (몇번까지 발급됐냐)  
select seq_tbl_number.currval
from dual; 

--  drop table TBL_NUMBER;
--  drop sequence   seq_tbl_number;

-- 4) 입력된 난수의 합계를 출력하는 익명블럭

declare 
    nums number(3) :=1 ;
    pnum number(3);
    psum number(10):= 0;
begin 
    while  nums <=100
        loop
              select num
              into pnum   
              from tbl_number
              where id = nums ;
              
              psum := psum + pnum; 
              nums := nums+1;       
       end loop;

       dbms_output.put_line( ' 합계 : ' || psum ) ;      
end;
/


------------------------------------------------------------------------------------------------
3.주민번호를 입력받아 나이를 리턴하는 저장함수 fn_age를 사용해서 사번, 이름, 성별, 연봉, 나이를 조회
------------------------------------------------------------------------------------------------
-- 1) 함수만들기 
create or replace function fn_age (
    v_emp_no employee.emp_no%type
)

return number
is  age  number(3);
begin
    select  ( select extract ( year from sysdate) -  (decode( substr(emp_no,8,1),'1',1900,'2',1900,2000) + substr(emp_no,1,2) ) 
                    from employee where emp_no = v_emp_no ) emp_age 
    into age
    from employee
    where emp_no = v_emp_no;
    
    return age;
    
end;
/
---- 2) 조회  (사번, 이름, 성별, 연봉, 나이)
select emp_id 사번,
            emp_name 이름,
            decode(substr(emp_no,8,1),'1','남','3','남','여') 성별 ,
            (salary *( 1+ nvl(bonus,0)) )*12 연봉,
            fn_age( emp_no) 나이
from employee;
 
----------------------------------------------------------------------------------------------------------------------------------------------
4. 특별상여금을 계산하는 함수 fn_calc_incentive(salary, hire_date)를 생성하고, 사번, 사원명, 입사일, 근무개월수(n년 m월), 특별상여금 조회
* 입사일 기준 10년이상이면, 급여 150%
* 입사일 기준 10년 미만 3년이상이면, 급여 125%
* 입사일 기준 3년미만, 급여 50%
----------------------------------------------------------------------------------------------------------------------------------------------
--  1) 함수만들기 
create or replace function fn_calc_incentive( 
    v_salary employee.salary%type,
    v_hire_date employee.hire_date%type    
)

return number
is  
    sbonus number(10); 
     diff number(3);

begin
     diff  :=   trunc(months_between(sysdate, v_hire_date)/12);
  
    if ( diff>=10) then  sbonus :=  v_salary*1.5 ;
    elsif ( diff < 10) and ( diff >= 3) then   sbonus :=   v_salary*1.25 ;
    else  sbonus :=  v_salary*0.5 ;
    end if;
    
    return sbonus;
    
end;
/

--2) 조회   사번, 사원명, 입사일, 근무개월수(n년 m월), 특별상여금 조회

select emp_id 사번,
            emp_name 사원명,
            hire_date 입사일,
            trunc(months_between(sysdate, hire_date)/12) || '년 ' || trunc(mod(months_between(sysdate, hire_date),12)) || '월' "근무개월수"
           ,fn_calc_incentive(salary, hire_date )특별상여금
from employee 

-- 지역변수 여러개 선언은 ; ; 이렇게 

select * from employee 
