Use JoinPractice;

---ASCII: returns the ascii code value of a character
--lower case 97-122
--upper case 65-90

select ASCII('A')
select ASCII('a')
select ASCII('Z')
select ASCII('z')

---CHAR convert an ASCII value to character

select CHAR(97)
select CHAR(122)
select CHAR(102)

---CHARINDEX search for substring inside a string starting from a specified location and return the position
--Syntax CHARINDEX (ExpressionToFind , ExpressionToSearch)
select CHARINDEX('ad' , 'SagunaUkade')

--CONCAT join two or more strings into one string
select CONCAT('saguna' , ' ' , 'Ukade')

