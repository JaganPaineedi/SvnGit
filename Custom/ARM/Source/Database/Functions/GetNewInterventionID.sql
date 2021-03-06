/****** Object:  UserDefinedFunction [dbo].[GetNewInterventionID]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewInterventionID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetNewInterventionID]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewInterventionID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























CREATE FUNCTION [dbo].[GetNewInterventionID]  (@OldInterventionID int , @NewVersion int)
RETURNS bigint  AS  
BEGIN 

Declare @InterventionID as bigint
Declare @InterventionNumber as int
Declare @DocumentID as bigint
Declare  @Version as int 


select  @InterventionNumber= InterventionNumber , @DocumentID = DocumentID, @Version = Version from TPInterventions where InterventionID = @OldInterventionID


set @InterventionID = 0

Select @InterventionID=InterventionID from TPInterventions where DocumentID = @DocumentID and Version = @NewVersion 
and InterventionNumber = @InterventionNumber

return @InterventionID


END






























' 
END
GO
