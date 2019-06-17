IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'csf_GetLocationnamesById') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION csf_GetLocationnamesById
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[csf_GetLocationnamesById] (@Locations varchar(max)) RETURNS  Varchar(max)
/****************************************************************************************/
/* Function to get a Location names 														*/
/* Author:Anto																			*/
/* Date: 3/11/2015																		*/
/****************************************************************************************/
as
begin


DECLARE @delimiter CHAR(1) = ','
DECLARE @Locationscount INT = 1
DECLARE @Result Varchar(max) = ''
DECLARE @output TABLE(splitdata NVARCHAR(MAX),ProgramId INT)

 DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @Locations) 
    WHILE @start < LEN(@Locations) + 1 
    BEGIN 
        IF @end = 0  
            SET @end = LEN(@Locations) + 1
       
        INSERT INTO @output (splitdata,ProgramId)  
        VALUES(SUBSTRING(@Locations,@start, @end - @start),@Locationscount) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @Locations, @start)
        SET @Locationscount = @Locationscount + 1 
        
    END 
    
    DECLARE @RowCount INT
	SET @RowCount = (SELECT COUNT(*) FROM @output)
	DECLARE @I INT	
	SET @I = 1 
	WHILE (@I <= @RowCount)
	BEGIN	
	DECLARE @Locationstext varchar(250)
	DECLARE @LocationId Varchar(50)
	select @LocationId = splitdata from @output where ProgramId = @I
	SELECT @Locationstext = LocationCode from Locations WHERE LocationId = @LocationId
	SET @Result = @Result + ',' + @Locationstext
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

