---Create database
create database JoinPractice

---Create table Employee
create table Employee(
Emp_Id int identity(1,1) primary key,
Name varchar(100) not null,
Designation varchar(100) not null,
City varchar(100) not null,
DOB DateTime,
Salary int)

select * from Employee

---insert values into emp table
insert Employee values('Saguna','Software Developer','Chennai','02/02/1998',40000);
insert Employee values('Krisma','Java Developer','USA','01/12/1996',20000);
insert Employee values('Rani','Dotnet Developer','Pune','05/08/1997',50000);
insert Employee values('Riya','SQL Developer','Mumbai','01/09/1991',30000);
insert Employee values('Prachi','HR','Pune','03/08/1992',45000);
insert Employee values('Amruta','Manager','Banglore','11/06/1996',43000);
insert Employee values('Kavya','Marketing','Chennai','09/02/1993',50000);

---create dept table
create table Department(
Dept_Id int Primary key,
Emp_Id int,
Dept_Name varchar(100),
Pincode int)

select * from Department
 
--insert values into dept table
insert Department values(1,2,'HR',234051)
insert Department values(2,8,'Developer',530951)
insert Department values(3,3,'HR',237865)
insert Department values(4,5,'Sales',474051)
insert Department values(5,7,'Analyst',444051)
insert Department values(6,4,'HR',434051)

---Create table EmployeeDetails
Create table EmployeeDetails(
Emp_Id int Primary key,
Age int,
Address varchar(100)) 

select * from EmployeeDetails

---insert values into EmployeeDetails
insert EmployeeDetails values(1,26,'Pune')
insert EmployeeDetails values(2,21,'Chennai')
insert EmployeeDetails values(3,12,'Bhopal')
insert EmployeeDetails values(4,56,'USA')
insert EmployeeDetails values(5,19,'Kolhapur')

--INNER JOIN
select Employee.Emp_Id, Department.Dept_Name, Employee.Designation
from Employee
INNER JOIN
Department on Employee.Emp_Id=Department.Emp_Id

select Employee.Emp_Id,Department.Pincode, Employee.DOB, Department.Dept_Name,Employee.City
from Employee
INNER JOIN
Department ON Employee.Emp_Id=Department.Emp_Id

--Join Three Tables
select Employee.Emp_Id,Department.Dept_Name,EmployeeDetails.Address,Department.Pincode
from Employee
INNER JOIN 
Department on Employee.Emp_Id=Department.Emp_Id
INNER JOIN 
EmployeeDetails on EmployeeDetails.Emp_Id=Employee.Emp_Id

--LEFT JOIN
select Employee.Emp_Id,Department.Dept_Name
from Employee
LEFT JOIN
Department on Employee.Emp_Id=Department.Emp_Id
ORDER BY Employee.Name

--RIGHT JOIN
select Employee.Emp_Id,Employee.Designation,Employee.Name,Department.Dept_Name,Department.Pincode
from Employee
RIGHT JOIN
Department on Department.Emp_Id=Employee.Emp_Id
ORDER BY Employee.Name DESC

--FULL OUTER JOIN
select Employee.City,Employee.DOB,Employee.Salary,Department.Dept_Name,Department.Pincode
from Employee
FULL OUTER JOIN
Department on Department.Emp_Id=Employee.Emp_Id

--SELF JOIN
SELECT Employee.Designation AS Emp_Id, Department.Dept_Name AS Emp_Id
FROM Employee, Department 
WHERE Employee.Emp_Id= Department.Emp_Id
AND Employee.Emp_Id= Department.Emp_Id
ORDER BY Employee.Emp_Id;

--CROSS JOIN
select Employee.City, Employee.Designation, Department.Dept_Name,Department.Pincode
from Employee
CROSS JOIN
Department;