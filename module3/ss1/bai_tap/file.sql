create schema student_management;
use student_management;
create table class(
id int,
name varchar(30),
primary key (id)
);
create table teacher(
id int,
name varchar(30),
age int,
country varchar(30),
primary key (id)
);