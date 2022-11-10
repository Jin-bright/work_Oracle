--1. EMPLOYEE테이블의 퇴사자관리를 별도의 테이블 TBL_EMP_QUIT에서 하려고 한다.
--    다음과 같이 TBL_EMP_JOIN, TBL_EMP_QUIT테이블을 생성하고, 
    TBL_EMP_JOIN에서 DELETE시 자동으로 퇴사자 데이터가  TBL_EMP_QUIT에 INSERT되도록 트리거를 생성하라.
--    **TBL_EMP_JOIN 테이블 생성 : QUIT_DATE, QUIT_YN 제외

set serveroutput on;


-- 1) 테이블 생성 
    CREATE TABLE TBL_EMP_JOIN
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE
    FROM EMPLOYEE
    WHERE QUIT_YN = 'N';

    SELECT * FROM TBL_EMP_JOIN;

---TBL_EMP_QUIT : EMPLOYEE테이블에서 QUIT_YN 컬럼제외하고 복사

    CREATE TABLE TBL_EMP_QUIT
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE
    FROM EMPLOYEE
    WHERE QUIT_YN = 'Y';

  
-- 테이블 만든거 조회 
 SELECT * FROM TBL_EMP_JOIN;
 SELECT * FROM TBL_EMP_QUIT;    


--2 ) 트리거 만들기 
 create or replace trigger trg_emp_join_and_quit
 after 
 delete on TBL_EMP_JOIN
 for each row 
 
 begin
       insert into TBL_EMP_QUIT
       values(:old.EMP_ID, :old.EMP_NAME, :old.EMP_NO, :old.EMAIL,:old.PHONE, :old.DEPT_CODE, :old.JOB_CODE, :old.SAL_LEVEL, :old.SALARY, :old.BONUS, 
                  :old.MANAGER_ID, :old.HIRE_DATE,  sysdate );  <-- 날짜 어떻게 넣어야됨 ?
end;
/

-- 테스트 
--delete from TBL_EMP_JOIN where emp_id = '223';
-- rollback;




-- 2. 사원변경내역을 기록하는 emp_log테이블을 생성하고, 
    ex_employee 사원테이블의 insert, update가 있을 때마다 신규데이터를 기록하는 트리거를 생성하라.
-- * 로그테이블명 emp_log : 컬럼 log_no(시퀀스객체로부터 채번함. pk), log_date(기본값 sysdate, not null), ex_employee테이블의 모든 컬럼
* 트리거명 trg_emp_log

-- 1) 테이블 만들기 
create table emp_log as 
 select *  from ex_employee where 1=0;
    
alter table emp_log    
add (log_no number(3), log_date date default sysdate not null) ;

alter table emp_log    
add constraint pk_emp_log_no primary key(log_no); 

-- 시퀀스 만들기 
create sequence seq_emp_log_log_no;
-- 만든 테이블 조회 
select * from emp_log
-- drop table emp_log

--2 ) 트리거 만들기 
create or replace trigger trg_emp_log
    before 
    insert or update on ex_employee
    for each row 

begin 
    if inserting then insert into emp_log
                                values(:new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, 
                                                    :new.sal_level, :new.salary, :new.bonus, :new.manager_id,default, default, :new.quit_yn, 
                                                    seq_emp_log_log_no.nextval,default);
     elsif updating then  insert into emp_log
                                values(:new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, 
                                                    :new.sal_level, :new.salary, :new.bonus, :new.manager_id,default, default, :new.quit_yn, 
                                                    seq_emp_log_log_no.nextval, default);                                    
    end if;

end;
/

-- 3) 테스트 
select * from ex_employee
select * from emp_log
insert into ex_employee
  values('400', '진','999999-0000000','ggg@naver.com', '0102341241','D7','J7','S2' ,2000000,default,default,sysdate,default,'N');

rollback;


★★★★★ 질문 ★★★★★

Q. 트리거 만들때, begin 절에서 insert into ~~ 로 값을 넣을때  꼭 :old 나 :new 이런걸 써야 되는건가 ? 
 날짜 형식은 어떻게 넣어야 되는걸까 .. 
--  values( EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, 
--                        HIRE_DATE, to_char(20221110, 'yyyy/mm/dd' );
ㄴ 이거 안되는건가? 안될거같애,, 특정값이 아니니까 

Q. 테이블 만들 때 다른 테이블 가져오기 ++ 추가로 새로운 컬럼 만들기 동시에 못함 ???  


