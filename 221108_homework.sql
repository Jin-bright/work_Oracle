-- 221108 실습문제
-- 1. EX_EMPLOYEE테이블에서 사번 마지막번호를 구한 뒤, 
--     +1한 사번에 사용자로 부터 입력받은 이름, 주민번호, 전화번호, 직급코드(J5), 급여등급(S5)를 등록하는 PL/SQL을 작성하세요.

declare 
    v_emp_name  ex_employee.emp_name %TYPE := '&이름';
    v_emp_no ex_employee.emp_no %TYPE:= '&주민번호' ;
    v_phone ex_employee.phone %TYPE :=  '&휴대폰번호' ;
    v_job_code  ex_employee.job_code  %TYPE :=  'J5' ;
    v_sal_level ex_employee.sal_level %TYPE :=  'S5' ;
    
begin
    insert into EX_EMPLOYEE(emp_id,emp_name, emp_no, phone, job_code, sal_level)
    values( (select max(emp_id)+1 from  ex_employee ), v_emp_name, v_emp_no,v_phone, v_job_code ,v_sal_level );
     
     dbms_output.put_line ( '이름 : ' ||    v_emp_name );
     dbms_output.put_line ( '주민번호 : ' ||   v_emp_no );
     dbms_output.put_line ( '전화번호 : ' ||   v_phone );
     dbms_output.put_line ( '직급코드 : ' ||   v_job_code );
     dbms_output.put_line ( '급여등급 : ' ||   v_sal_level );

    -- commit; 저장하고 싶으면 쓰기 
end;
/

rollback;
select * from  EX_EMPLOYEE;


-----------------------------------------------------------------------------------------------------------------------------------------------
--  2. 동전 앞뒤맞추기 게임 익명블럭을 작성하세요.  dbms_random.value api 참고해 난수 생성할 것.


declare
         n number ;
begin
        select  trunc(DBMS_RANDOM.VALUE (0,2))
        into n        
        from dual;

        if n= 1   then dbms_output.put_line('홀');
        else   dbms_output.put_line('짝');
        end if;
        
end;
/


--select trunc(DBMS_RANDOM.VALUE (0,2))  from dual
