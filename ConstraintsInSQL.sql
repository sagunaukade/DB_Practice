--SQL CONSTRAINTS
--constraints are the rules enforced on the data columns of table
 
use JoinPractice

---use of NOT NULL
--ensure that a column can not have NULL value

create table tab
(RollNo int NOT NULL,
Name varchar(100),
Class varchar(100)
)

select * from Tab

--column does not allow null values 
insert into tab(name,class)values('Saguna','BE')

insert into tab(RollNo,name,class)values(1,'Saguna','BE')

---create table tab2
create table tab2
(RollNo int,
Name varchar(100),
Class varchar(100)
)

select * from Tab2
alter table tab2 alter column RollNo int NOT NULL

--use of UNIQUE
--all the values in the column must be unique
create table TabUnique
(RollNo int UNIQUE,
Name varchar(100),
Class varchar(100)
)

select * from TabUnique

insert into TabUnique(RollNo,name,class)values(1,'Saguna','BE')

alter table TabUnique add constraint UniqueRollNo UNIQUE(RollNo)

--use of PRIMARY KEY
--primary key is field which can uniquely identify each row in a table
--only one primary key is allowed in a table
--you may have multiple unique key in a table
--primary key does not allow any null values but UNIQUE KEY can allow NULL value

create table DemoPK
(RollNo int PRIMARY KEY,
Name varchar(100),
Class varchar(100)
)

create table DemoPK_2
(RollNo int UNIQUE,
MobileNo int UNIQUE,
Name varchar(100),
Class varchar(100))

select * from DemoPK_2
INSERT into DemoPK_2(RollNo,MobileNo,Name,Class) values(1,'879876','Saguna','BE')

create table DemoPK_3
(RollNo int PRIMARY KEY,
MobileNo int UNIQUE,
Name varchar(100),
Class varchar(100))

INSERT into DemoPK_3(RollNo,MobileNo,Name,Class) values(1,'879876','Saguna','BE')

---use of CHECK CONSTRAINTS
create table DemoCheck
(RollNo int PRIMARY KEY,
Age int NOT NULL CHECK(Age<=40),
Name varchar(100),
Class varchar(100))

select * from DemoCheck
INSERT into DemoCheck(RollNo,Age,Name,Class) values(1,34,'Saguna','BE')
INSERT into DemoCheck(RollNo,Age,Name,Class) values(1,44,'Saguna','BE')

--use of DEFAULT CONSTRAINTS
--this constraints is used to providea default value for the fields
create table DemoDefault
(RollNo int PRIMARY KEY,
Age int NOT NULL DEFAULT 22,
Name varchar(100),
Class varchar(100))

SELECT * from DemoDefault

INSERT into DemoDefault(RollNo,Age,Name,Class) values(1,'32','Saguna','BE')

--use of FOREIGN KEY 
/*
foreign key is field in table which uniquely identifies each row of another table
tht is this field points to primary key of another table
this usually create a kind of link between two tables
data type of both key must be same
*/

create table studPK
(
RollNo int Primary key
)

select * from studPK

create table studMarksFK
(RollNo int,
Math int,
Science int,
FOREIGN KEY(RollNo) REFERENCES StudPK(RollNo)
)

select * from studMarksFK

insert into studPK(RollNo) values(1)
insert into studPK(RollNo) values(2)

insert into studMarksFK(RollNo,Math,Science) values(1,45,67)
insert into studMarksFK(RollNo,Math,Science) values(2,45,67)

delete from studPK where RollNo=1
delete from studMarksFK where RollNo=1

--use of TABLE LEVEL CONSTRAINTS
--Constraints can be specified for groups of columns as part of table
create table DemoTableLevel
(RollNo int,
MobileNo int,
Name varchar(100),
Class varchar(100),
CONSTRAINT Roll_Mobile_Unique UNIQUE(RollNo,MobileNo))

INSERT into DemoTableLevel(RollNo,MobileNo,Name,Class) values(1,'879876','Saguna','BE')
INSERT into DemoTableLevel(RollNo,MobileNo,Name,Class) values(2,'879876','Saguna','BE')
INSERT into DemoTableLevel(RollNo,MobileNo,Name,Class) values(1,'999999','Saguna','BE')

select * from DemoTableLevel