--1)  221107 숙제 -- DDL 
--1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.

create table TB_CATEGORY (    
    NAME VARCHAR2(10),
    USE_YN CHAR(1) default 'Y'
) ;

--2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.

create table TB_CLASS_TYPE ( 
    NO  VARCHAR2(5),
    NAME VARCHAR2(10) ,
    
    constraint pk_tb_class_type_no PRIMARY KEY(no)
);

--3. TB_CATEGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
--(KEY 이름을 생성하지 않아도 무방함. 맊일 KEY 이를 지정하고자 핚다면 이름은 본인이 알아서 적당핚 이름을 사용핚다.)

alter table  TB_CATEGORY
add constraint pk_tb_category_name primary key(name);

--4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.

alter table TB_CLASS_TYPE
modify NAME VARCHAR2(10) not null;

--5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 
--    컬럼명이    NAME 인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오. 

alter table TB_CLASS_TYPE 
modify   NO  VARCHAR2(10);

alter table TB_CLASS_TYPE 
modify    NAME VARCHAR2(20) ;
    
alter table TB_CATEGORY     
modify  NAME VARCHAR2(20);

--6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다.
--(ex. CATEGORY_NAME)

alter table TB_CLASS_TYPE 
rename   column category_NAME  to CLASS_TYPE_NAME;

alter table TB_CLASS_TYPE 
rename   column no  to CLASS_TYPE_no;
--
alter table TB_CATEGORY     
rename  column NAME to CATEGORY_NAME;

--7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
-- Primary Key 의 이름은 PK_ + 컬럼이름‛으로 지정하시오. (ex. PK_CATEGORY_NAME )

alter table TB_CATEGORY     
rename  constraint  pk_tb_category_name to pk_category_name;

alter table TB_CLASS_TYPE 
rename   constraint pk_tb_class_type_no  to pk_class_type_no;


--8. 다음과 같은 INSERT 문을 수행핚다.

INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');

COMMIT;

--9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모값으로 참조하도록 FOREIGN KEY 를 지정하시오. 
--이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY )

alter table TB_DEPARTMENT
add constraint  FK_DEPARTMENT_CATEGORY foreign key(CATEGORY) references  TB_CATEGORY(CATEGORY_NAME);


--10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW 를 만들고자 한다. 아래 내용을 참고하여 적절한 SQL 문을 작성하시오.

--1) 관리자 계정으로 view 생성권한주기
grant create view to chun;

--2) 뷰생성 
create view VW_학생일반정보 
as (
    select     e.student_no 학번,
                    e.student_name 학생이름,
                    e.student_address 주소

        from tb_student e
);

--11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다.
--이를 위해 사용할 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 만드시오.
--이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 
--(단, 이 VIEW 는 단순 SELECT 만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)

create view VW_이름_학과_담당교수
as(
            select e.* 
            
            from (            
            select          s.student_name 학생이름,
                                d.department_name 학과이름,
                               nvl(p.professor_name,'없음') 담당교수이름
                 
            from    tb_student s left join tb_department d
                                      on(s.department_no = d.department_no)                            
                        left join tb_professor p
                                    on (s.coach_professor_no  = p.professor_no )
            
            order by 2
            )e
        
 );       

select * from VW_이름_학과_담당교수;

--12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW 를 작성해 보자.

create view VW_학과별학생수
as(
            select     d.department_name  DEPARTMENT_NAME,
                            count(s.student_no)  STUDENT_COUNT
            
            from    tb_student s left join tb_department d
                                using (department_no)
            
            group by  department_name                   
);

--13. 위에서 생성한 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인 이름으로 변경하는 SQL 문을 작성하시오.

update  VW_학생일반정보
set  학생이름  = '김혜진' 
where 학번 = 'A213046';

--select * from VW_학생일반정보

--14. 13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를 어떻게 생성해야 하는지 작성하시오.

create or replace  view VW_학생일반정보
as (
    select     e.student_no 학번,
                    e.student_name 학생이름,
                    e.student_address 주소

        from tb_student e
)
with read only;

--15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이 몰려 문제가 되고 있다. 
--최근 3 년을 기준으로 수강인원이 가장 많았던 3 과목을 찾는 구문을 작성해보시오.
-- 수강생수 ★
select 
            e.cl_no 과목번호,
            e.cl_name  과목이름,
            e.cl_conut "누적수강생수(명)"

from(
     select    
             c.class_name cl_name,
             count (  c.class_no ) cl_conut,
             c.class_no cl_no

       from  tb_grade g join tb_class c 
                            on(g.class_no = c.class_no)
            where extract ( year from  (to_date(term_no,'yyyymm') )) >= 2007
            group by c.class_name, c.class_no
            order by  cl_conut desc  
)e         

where rownum<=3 ;                    
           
----  저 pdf 는 2005~ 2009인거같은데             
select    
 c.class_name cl_name,
 count (  c.class_no ) cl_conut,
 c.class_no cl_no

from  tb_grade g join tb_class c 
                on(g.class_no = c.class_no)
where extract ( year from  (to_date(term_no,'yyyymm') )) >= 2005
group by c.class_name, c.class_no
order by  cl_conut desc  ;
            
    
                       
/* 제약조건조회 
--select  constraint_name, 
        uc.table_name, 
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition,
        uc.r_constraint_name  --참조하는 제약조건이름(외래키에만 해당됨 )
from user_constraints uc join user_cons_columns ucc
                using(constraint_name) 
where uc.table_name = 'TB_DEPARTMENT' ;

desc TB_CLASS_TYPE;
*/

-- 2)  221107 숙제 -- DML 
-- 1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.

insert into  TB_CLASS_TYPE  values('01', '전공필수')
insert into  TB_CLASS_TYPE  values('02', '전공선택')
insert into  TB_CLASS_TYPE  values('03', '교양필수')
insert into  TB_CLASS_TYPE  values('04', '교양선택')
insert into  TB_CLASS_TYPE  values('05', '논문지도')
;

--2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다. 
--        아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (서브쿼리를 이용하시오)

create table TB_학생일반정보 
as ( select  student_no  학번,  student_name 학생이름, student_address 주소  from tb_student  );

--3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다. 
-- 아래 내용을 참고하여 적절한  SQL 문을 작성하시오. (힌트 : 방법은 다양함, 소신껏 작성하시오)

create table TB_국어국문학과 
as (
         select  s. student_no  학번,  
                      s.student_name 학생이름,
                     decode(  substr(student_ssn,8,1),'1',1900,'2',1900,2000)   +  substr(student_ssn,1,2)  출생년도,
                      nvl(p.professor_name,'없음') 교수이름       
         from tb_student s left join  tb_professor  p
                        on (s.coach_professor_no = p.professor_no)
                    left join tb_department d 
                         on (s.department_no =  d.department_no)                       
        where d.department_name = '국어국문학과'
);

--4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용핛 SQL 문을 작성하시오. (단, 반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)
update tb_department 
set capacity =  round(capacity*1.1,0);


--5. 학번 A413042 인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고 한다. 주소지를 정정하기 위해 사용할 SQL 문을 작성하시오
update  tb_student 
set student_address ='서울시 종로구 숭인동 181-21'
where student_no = 'A413042';

--6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다. 
--    이 내용을 반영한 적적할 SQL 문장을 작성하시오. (예. 830530-2124663 ==> 830530 )

update  tb_student 
set student_ssn =  substr(student_ssn,1,6);

--7. 의학과 김명훈 학생은 2005 년 1 학기에 자신이 수강한 '피부생리학' 점수가 잘못되었다는 것을 발견하고는 정정을 요청하였다. 
--   담당 교수의 확인 받은 결과 해당 과목의 학점을 3.5 로 변경키로 결정되었다. 적절한 SQL 문을 작성하시오.

update tb_grade  
set point = 3.5
where  class_no = (  select  g.class_no  from tb_student s  join tb_department d   using (department_no)
                                     join tb_grade g   using(student_no)  where s.student_name  ='김명훈' and d.category = '의학' and g.term_no = '200501' ) 
                and (term_no = '200501')  
                and  student_no = ( select  s.student_no  from tb_student s join tb_department d  using (department_no)
                            where s.student_name  ='김명훈' and d.category = '의학'    );

--8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오
-- 행 전체 삭제가 맞나  ? 일단 조금만삭제.. 

delete 
from  tb_grade 
where student_no in  ( select student_no   from tb_student    where absence_yn  = 'Y'  and  student_no like '99%');
-- 실제 where 절 => where student_no in ( select student_no  from tb_student   where absence_yn  = 'Y'  )
-- rollback;
