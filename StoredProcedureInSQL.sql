Create database SPDatabase

CREATE TABLE  tbl_Students
(
    [Studentid] [int] IDENTITY(1,1) NOT NULL,
    [Firstname] [nvarchar](200) NOT  NULL,
    [Lastname] [nvarchar](200)  NULL,
    [Email] [nvarchar](100)  NULL
)

Insert into tbl_Students (Firstname, lastname, Email)
 Values('Saguna', 'Ukade', 'saguu@gmail.com')

Insert into tbl_Students (Firstname, lastname, Email)
 Values('Karishma', 'Kumar', 'Karishma@abc.com')

Insert into tbl_Students (Firstname, lastname, Email)
 Values('Kalyani', 'Singh', 'Kalyani@abc.com')

Insert into tbl_Students (Firstname, lastname, Email)
 Values('Manisha', 'Kumar', 'manisha@abc.comm')

Insert into tbl_Students (Firstname, lastname, Email)
 Values('Abhi', 'Singh', 'abhi@abc.com')

 select * from tbl_Students

 ---CREATE PROCEDURE
/*  Getstudentname is the name of the stored procedure*/

Create  PROCEDURE Getstudentname(
--Input parameter , Studentid of the student 
@studentid INT                   
)
AS
BEGIN
SELECT Firstname+' '+Lastname FROM tbl_Students WHERE studentid=@studentid 
END

Execute Getstudentname 1
Exec Getstudentname 1

/* 
GetstudentnameInOutputVariable is the name of the stored procedure which
uses output variable @Studentname to collect the student name returns by the
stored procedure
*/

Create  PROCEDURE GetstudentnameInOutputVariable
(
--Input parameter , Studentid of the student
-- Out parameter declared with the help of OUT keyword
@studentid INT,                       
@studentname VARCHAR(200)  OUT  
)
AS
BEGIN
SELECT @studentname= Firstname+' '+Lastname FROM tbl_Students WHERE studentid=@studentid
END

/* 
Stored Procedure GetstudentnameInOutputVariable is modified to collect the
email address of the student with the help of the Alert Keyword
*/ 

Alter PROCEDURE GetstudentnameInOutputVariable
(
--Input parameter , Studentid of the student
-- Output parameter to collect the student name
-- Output Parameter to collect the student email
@studentid INT,                   
@studentname VARCHAR (200) OUT,    
@StudentEmail VARCHAR (200)OUT     
)
AS
BEGIN
SELECT @studentname= Firstname+' '+Lastname, 
    @StudentEmail=email FROM tbl_Students WHERE studentid=@studentid
END

/*
This Stored procedure is used to Insert value into the table tbl_students. 
*/

Create Procedure InsertStudentrecord
(
 @StudentFirstName Varchar(200),
 @StudentLastName  Varchar(200),
 @StudentEmail     Varchar(50)
) 
As
 Begin
   Insert into tbl_Students (Firstname, lastname, Email)
   Values(@StudentFirstName, @StudentLastName,@StudentEmail)
 End

-- Declaring the variable to collect the Studentname
 Declare @Studentname as nvarchar(200)
-- Declaring the variable to collect the Studentemail   
Declare @Studentemail as nvarchar(50)     
Execute GetstudentnameInOutputVariable 3 , @Studentname output, @Studentemail output
-- "Select" Statement is used to show the output from Procedure
select @Studentname,@Studentemail     

CREATE TABLE USERS (
    USER_ID INT PRIMARY KEY IDENTITY (1, 1),
    FIRST_NAME VARCHAR (50) NOT NULL,
    LAST_NAME VARCHAR (50) NOT NULL, 
    EMAIL VARCHAR(200) NOT NULL,    
    PHONE VARCHAR(20) NOT NULL,
    CREATED_AT DATETIME DEFAULT GETDATE(),
    CONSTRAINT UK_EMAIL UNIQUE(EMAIL), 
    CONSTRAINT UK_PHONE UNIQUE(PHONE) 
);


CREATE PROCEDURE USER_MANAGEMENT
    -- Add the parameters for the stored procedure here 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT * FROM USERS
END
GO

exec USER_MANAGEMENT

CREATE TABLE [ERROR_LOG]
(
        ERROR_LOG_ID [bigint] IDENTITY(1,1) NOT NULL, 
        ERROR_NUMBER INT NULL,
        ERROR_LINE INT NULL,
        ERROR_MESSAGE VARCHAR (max) NULL,
        OBJECT_NAME VARCHAR(250) NULL, 
        CREATED_AT DATETIME NULL DEFAULT GETDATE()
);


ALTER PROCEDURE USER_MANAGEMENT
--  PARAMETERS FOR STORED PROCEDURE
--ACTION_TYPE parameter will be use to control the execution block for each of the CRUD operation
    @JSON_STRING NVARCHAR(MAX), @ACTION_TYPE VARCHAR(20)
AS
    --  DECLARE GLOBAL VARIABLES 
    DECLARE @USER_ID INT, @FIRST_NAME VARCHAR(50), @LAST_NAME VARCHAR(50),
    @EMAIL VARCHAR(200), @PHONE VARCHAR(20), @CREATED_AT DATETIME;

    --  RESPONSE DECLARATIONS 
    DECLARE @RESPONSE_NUMBER INT = 1, @RESPONSE_MESSAGE VARCHAR(250), 
    @RESPONSE_DATA VARCHAR(MAX), @ERROR_OBJECT_NAME VARCHAR(50), 
    @ERROR_LINE BIGINT

BEGIN 

    IF @ACTION_TYPE = 'CREATE'
    BEGIN
        -- GET VALUES FROM @USER_JSON_STRING        
        SET @FIRST_NAME = JSON_VALUE(@JSON_STRING, '$.FIRST_NAME')    
        SET @LAST_NAME = JSON_VALUE(@JSON_STRING, '$.LAST_NAME')        
        SET @EMAIL = JSON_VALUE(@JSON_STRING, '$.EMAIL')        
        SET @PHONE = JSON_VALUE(@JSON_STRING, '$.PHONE')

        -- VALIDATE PARAMS 
        IF(@FIRST_NAME IS NULL OR @LAST_NAME IS NULL OR @EMAIL IS NULL OR @PHONE IS NULL)
        BEGIN

            SET @RESPONSE_NUMBER = -1
            SET @RESPONSE_MESSAGE = 'Missing field(s)!'
            SET @ERROR_OBJECT_NAME  = ERROR_PROCEDURE()
            SET @RESPONSE_DATA  = ''             
            SET @ERROR_OBJECT_NAME = ERROR_PROCEDURE()
            SET @ERROR_LINE = ERROR_LINE()

            GOTO ERR_HANDLER
        END    

        BEGIN TRY        
            -- CREATE USER
            INSERT INTO USERS(FIRST_NAME, LAST_NAME, EMAIL, PHONE)
            VALUES(@FIRST_NAME, @LAST_NAME, @EMAIL, @PHONE)

            SET @USER_ID = SCOPE_IDENTITY();

            SET @RESPONSE_NUMBER = 1
            SET @RESPONSE_MESSAGE = 'User successfully saved' 
            SET @RESPONSE_DATA  = (SELECT USER_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE  FROM USERS 
                                   WHERE USER_ID = @USER_ID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)             
        END TRY
        BEGIN CATCH
            SET @RESPONSE_NUMBER = ERROR_NUMBER()
            SET @RESPONSE_MESSAGE = ERROR_MESSAGE()
            SET @ERROR_OBJECT_NAME = ERROR_PROCEDURE()
            SET @ERROR_LINE = ERROR_LINE()
            GOTO ERR_HANDLER     
        END CATCH
    END
    IF @@TRANCOUNT > 0
    COMMIT TRANSACTION ; SET XACT_ABORT OFF

    --RESPONSE SECTION
    ERR_HANDLER:
    IF @RESPONSE_NUMBER <> 1
    BEGIN             
        DECLARE @TRAN INT
        SELECT @TRAN = @@TRANCOUNT
        IF @TRAN > 1 COMMIT TRANSACTION
        IF @TRAN = 1 ROLLBACK TRANSACTION    

        INSERT INTO ERROR_LOG(ERROR_NUMBER, ERROR_LINE, ERROR_MESSAGE, OBJECT_NAME)
        VALUES(@RESPONSE_NUMBER, @ERROR_LINE, @RESPONSE_MESSAGE, @ERROR_OBJECT_NAME) 
    END

    SELECT @RESPONSE_NUMBER AS RESPONSE_NUMBER, @RESPONSE_MESSAGE AS RESPONSE_MESSAGE, 
    @RESPONSE_DATA AS RESPONSE_DATA, @ERROR_OBJECT_NAME AS [OBJECT_NAME]

END

EXEC USER_MANAGEMENT @JSON_STRING=N'{"FIRST_NAME":"Saguna","LAST_NAME": "Ukade",
"EMAIL":"saguna@gmail.com","PHONE": "56789098765432"}', @ACTION_TYPE=N'CREATE'

SELECT * FROM USERS
