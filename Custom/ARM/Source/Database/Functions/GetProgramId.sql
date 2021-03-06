/****** Object:  UserDefinedFunction [dbo].[GetProgramId]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProgramId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetProgramId]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProgramId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE FUNCTION [dbo].[GetProgramId](

	@CLIENTID  INT,
	@myDateTime datetime
)

RETURNS VARCHAR(200)
 AS  

BEGIN 
DECLARE @ProgramId VARCHAR (200)
DECLARE @StrProgramId VARCHAR (200)
set @StrProgramId  = ''''

DECLARE @CURDATE DATETIME

--DECLARE @myDateTime DATETIME

 --SELECT @myDateTime = Date FROM CurrentDate


declare  CurProgramId cursor for 
select ClientPrograms.programId from ClientPrograms,Programs 
where clientId = @CLIENTID
and ClientPrograms.ProgramId = Programs.ProgramId   
and (@myDateTime >= EnrolledDate and @myDateTime <= DischargedDate) 
union
select ClientPrograms.programId from ClientPrograms,Programs 
where clientId = @CLIENTID
and ClientPrograms.ProgramId = Programs.ProgramId   
and (@myDateTime >= EnrolledDate and DischargedDate is NULL ) 


open CurProgramId

FETCH NEXT from CurProgramId 
into @ProgramId

WHILE @@FETCH_STATUS = 0 
	begin
	SET @StrProgramId = @StrProgramId +  @ProgramId  + '',''  

	FETCH NEXT from CurProgramId 
	into @ProgramId 
end 

Close CurProgramId
deallocate CurProgramId

if (@StrProgramId <> '''' ) 
begin 
	set @StrProgramId = substring (@StrProgramId,1,len(@StrProgramId)-1)
end


RETURN @StrProgramId


END


















' 
END
GO
