 221103 실습문제 
--## @실습문제 : CREATE
-- 테이블을 적절히 생성하고, 테이블, 컬럼주석을 추가하세요.
--1. 첫번째 테이블 명 : EX_MEMBER
--* MEMBER_CODE(NUMBER) - 기본키                        -- 회원전용코드 
--* MEMBER_ID (varchar2(20) ) - 중복금지                    -- 회원 아이디
--* MEMBER_PWD (char(20)) - NULL 값 허용금지                    -- 회원 비밀번호
--* MEMBER_NAME(varchar2(30))                             -- 회원 이름
--* MEMBER_ADDR (varchar2(100)) - NULL값 허용금지                    -- 회원 거주지
--* GENDER (char(3)) - '남' 혹은 '여'로만 입력 가능                -- 성별
--* PHONE(char(11)) - NULL 값 허용금지                     -- 회원 연락처


--1. 테이블 생성 
create table EX_MEMBER (
             MEMBER_CODE NUMBER,                                     -- 회원전용코드 
             MEMBER_ID varchar2(20),                                      -- 회원 아이디
             MEMBER_PWD char(20)  not NULL,                      -- 회원 비밀번호
             MEMBER_NAME  varchar2(30),                              -- 회원 이름
             MEMBER_ADDR varchar2(100)  not  NULL,         -- 회원 거주지
             GENDER char(3),                                                          -- 성별
             PHONE char(11)  not NULL,                                      -- 회원 연락처

            constraint pk_MEMBER_CODE primary key(MEMBER_CODE),
            constraint  uq_MEMBER_ID unique(  MEMBER_ID ),
            constraint  ck_GENDER check( GENDER in ('남', '여') )
);

--2. 테이블 주석 추가  / 컬럼주석 추가 
comment on table EX_MEMBER is '회원 정보 관리 테이블';  --테이블주석 
comment on column EX_MEMBER.MEMBER_CODE  is '회원전용코드' ;
comment on column EX_MEMBER.MEMBER_ID  is '회원 아이디' ;
comment on column EX_MEMBER.MEMBER_PWD  is '회원 비밀번호' ;
comment on column EX_MEMBER.MEMBER_NAME  is '회원 이름' ;
comment on column EX_MEMBER.MEMBER_ADDR  is '회원 거주지' ;
comment on column EX_MEMBER.GENDER  is '성별' ;
comment on column EX_MEMBER.PHONE  is '회원 연락처' ;


select * from EX_MEMBER;



--2. EX_MEMBER_NICKNAME 테이블을 생성하자. (제약조건 이름 지정할것)
--(참조키를 다시 기본키로 사용할 것.)
--* MEMBER_CODE(NUMBER) - 외래키(EX_MEMBER의 기본키를 참조), 중복금지        -- 회원전용코드
--* MEMBER_NICKNAME(varchar2(100)) - 필수    

-- 1. 테이블 생성 
create table EX_MEMBER_NICKNAME (
            MEMBER_CODE NUMBER,        -- 회원전용코드
            MEMBER_NICKNAME varchar2(100) not null,    
    
            constraint   FK_EX_MEMBER_NICKNAME_MEMBER_CODE foreign key (MEMBER_CODE) references  EX_MEMBER (MEMBER_CODE), -- fk 
            constraint  PK_EX_MEMBER_NICKNAME_MEMBER_CODE primary key ( MEMBER_CODE )
);

select * from EX_MEMBER





----------------------------------------------------------------------
 < 테이블주석 / 컬럼주석 / 제약조건  조회해보기 > 

--** 주석조회해볼까 
select *  from user_tab_comments  where table_name = 'EX_MEMBER';
select * from user_col_comments where table_name = 'EX_MEMBER';

-- ** 제약조건 조회해볼까 
select  constraint_name,
            uc.table_name,
            ucc.column_name,
            uc.constraint_type,
            uc.search_condition,
            uc.r_constraint_name
            
from user_constraints uc   join user_cons_columns ucc
            using(constraint_name)
where uc.table_name = 'EX_MEMBER';
-- Q. 제약조건을 안건 name은 왜 이렇게 조회하면 안뜨니 ? 
    


-- <  test  >  
-- 멤버테이블에 먼저 값넣고 
insert into EX_MEMBER values( 1, 'jinnn2','1234',null,'서울시','여','01012341234');
insert into EX_MEMBER values( 2, 'john2','1234','john','US','남','010345345');

-- 닉넴테이블에서 닉넴넣기 
insert into EX_MEMBER_NICKNAME  values(1,'지니지니'); --ok 
insert into EX_MEMBER_NICKNAME  values(2,'존존'); --ok 


insert into EX_MEMBER_NICKNAME  values(1,'지니지니찡'); 
--무결성 제약 조건(SH.PK_EX_MEMBER_NICKNAME_MEMBER_CODE)에 위배됩니다

-- Q. 닉네임을 바꾸고 싶다면  ?
update EX_MEMBER_NICKNAME
set MEMBER_NICKNAME = '지니지니찡찡'
where  MEMBER_CODE = 1;

insert into EX_MEMBER_NICKNAME  values(3,'지니지니');
-- 무결성 제약조건(SH.FK_EX_MEMBER_NICKNAME_MEMBER_CODE)이 위배되었습니다- 부모 키가 없습니다

select * from  EX_MEMBER;
select * from  EX_MEMBER_NICKNAME;


-- <  모르는거 /오류  >  
Q. 내가 FK_MEMBER_CODE  이렇게만 썼을 때 하기와 같은 오류 발생 
근데 테이블이 다른데, 컬럼의 기존 제약 조건의 이름이 중복되면 안되는건가 ???
--오류 보고 -
--ORA-02264: 기존의 제약에 사용된 이름입니다  -
--02264. 00000 -  "name already used by an existing constraint"
--*Cause:    The specified constraint name has to be unique.
--*Action:   Specify a unique constraint name for the constraint.

 Q. 제약조건을 안적은 컬럼은 제약조건조회할때 아예 컬럼에서 조회되지 않는게 맞는건가 
