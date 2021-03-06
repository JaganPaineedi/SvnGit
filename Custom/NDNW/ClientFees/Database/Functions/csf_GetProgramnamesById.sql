IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'csf_GetProgramnamesById') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION csf_GetProgramnamesById
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[csf_GetProgramnamesById] (@Programs varchar(max)) RETURNS  Varchar(max)
/****************************************************************************************/
/* Function to get a Program names 														*/
/* Author:Anto																			*/
/* Date: 3/11/2015																		*/
/****************************************************************************************/
as
begin


DECLARE @delimiter CHAR(1) = ','
DECLARE @Programcount INT = 1
DECLARE @Result Varchar(max) = ''
DECLARE @output TABLE(splitdata NVARCHAR(MAX),ProgramId INT)

 DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @Programs) 
    WHILE @start < LEN(@Programs) + 1 
    BEGIN 
        IF @end = 0  
            SET @end = LEN(@Programs) + 1
       
        INSERT INTO @output (splitdata,ProgramId)  
        VALUES(SUBSTRING(@Programs,@start, @end - @start),@Programcount) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @Programs, @start)
        SET @Programcount = @Programcount + 1 
        
    END 
    
    DECLARE @RowCount INT
	SET @RowCount = (SELECT COUNT(*) FROM @output)
	DECLARE @I INT	
	SET @I = 1 
	WHILE (@I <= @RowCount)
	BEGIN	
	DECLARE @Programstext varchar(250)
	DECLARE @ProgramId Varchar(50)
	select @ProgramId = splitdata from @output where ProgramId = @I
	SELECT @Programstext = ProgramCode from Programs WHERE ProgramId = @ProgramId
	SET @Result = @Result + ',' + @Programstext
	SET @I = @I + 1

	END	
	IF LEN(@Result) >= 1
	BEGIN	
    SET @Result = RIGHT(@Result, LEN(@Result) - 1)
    END
    ELSE
    BEGIN
    SET @Result = ''
    
    END
    RETURN @Result    
end

