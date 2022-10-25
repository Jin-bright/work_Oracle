 --한글은 3바이트 *4자리면 12 ? 이름 김강아지  

 
 create table today (
     t_id CHAR(15  CHAR) 
    , t_password VARCHAR2(15 CHAR)
    ,t_name CHAR(12) 
    ,t_phone_num VARCHAR2(11) -- phone : - 없이 11자리  
    ,t_ssn CHAR(13)--똑같
    ,t_mileage NUMBER 
    ,t_reg_date DATE
 );

select * from today;

insert into today VALUES('brightjin','12341234','김혜진','01012341234','9999992999999',20, to_char(sysdate,'yyyy/mm/dd') ); --test
insert into today VALUES('jin','12341234','김진','01012341234','9899991999999',200, to_char(sysdate-11,'yyyy/mm/dd') ); 
--test2 /id6자리아니어도 저장되는데 뒤에는 공백으로채워지는건가 ? 


create table board (
    boardNo number
    ,b_userid CHAR(15 CHAR) --이렇게하면 영어/한글 다 15자까지 가능?
    ,b_passw VARCHAR2(6 CHAR)
    ,b_content CLOB
);

select * from board;  --테스트

insert into board VALUES(1,'지잉지잉징징이','abcd','테이블 생성 후 변경하는법은 뭘까');
insert into board VALUES(2,'지잉지잉징징이징징징징징징징징','abcd','값 넣고  변경하는법은 뭘까');
insert into board VALUES(3,'iceamericanojoa','abcd','테이블 생성 후 변경하는법은 뭘까');

insert into board VALUES(4,'지잉지잉징징이징징징징징징징징징','abcd','테이블 생성 후 변경하는법은 뭘까'); --오류
insert into board VALUES(5,'iceamericanojoajoa','abcd','테이블 생성 후 변경하는법은 뭘까'); --오류

COMMIT;

/*
--test2 /id6자리아니어도 저장되는데 뒤에는 공백으로채워지는건가 ? 
--테이블 생성 후 안에 컬럼 내용 변경할 수는 없나 ? 
*/

--drop table today;
--drop table board;

 /*
 1. today회사의 회원테이블을 만든다. 다음조건을 만족하는 컬럼데이터타입을 작성하자.
 
* id : 6자리에서 15자리(변동가능성 없음)
* password : 8자리이상 15자리
* name : 한글입력 
* phone : - 없이 11자리
* ssn 주민등록번호 : -없이 13자리
* mileage 회원마일리지 : 
* reg_date 가입일 : 


2. 게시판테이블을 만들어보자.
* boardNo : 글고유번호
* userid : 6자리에서 15자리(변동가능성 없음)
* password : 4자리에서 6자리(변동가능성 없음)
* content : 게시글
*/