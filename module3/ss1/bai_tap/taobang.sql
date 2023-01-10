create schema student_management;
use student_management;
create table class(
id int,
name varchar(30),
primary key (id)
);
insert into class (id , name ) values (1, "Nghĩa");
insert into class (id , name ) values (2, "Quân");
select *from class;
create table teacher(
id int,
name varchar(30),
age int,
country varchar(30),
primary key (id)
);
insert into teacher (id , name , age , country ) values ( 1 , "Thảo" , 18 , "Việt Nam" );
select *from teacher;