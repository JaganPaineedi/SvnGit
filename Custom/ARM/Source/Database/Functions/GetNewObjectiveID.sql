/****** Object:  UserDefinedFunction [dbo].[GetNewObjectiveID]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewObjectiveID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetNewObjectiveID]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewObjectiveID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























CREATE FUNCTION [dbo].[GetNewObjectiveID]  (@OldObjectiveID int , @NewVersion int)
RETURNS bigint  AS  
BEGIN 

Declare @ObjectiveID as bigint
Declare @ObjectiveNumber as int
Declare @DocumentID as bigint
Declare  @Version as int 


select  @ObjectiveNumber= ObjectiveNumber , @DocumentID = DocumentID, @Version = Version from TPObjectives where ObjectiveID = @OldObjectiveID


set @ObjectiveID = 0

Select @ObjectiveID=ObjectiveID from TPObjectives where DocumentID = @DocumentID and Version = @NewVersion 
and ObjectiveNumber = @ObjectiveNumber

return @ObjectiveID


END





























' 
END
GO
