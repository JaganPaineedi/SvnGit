/****** Object:  UserDefinedFunction [dbo].[GetNewProcedureID]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewProcedureID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetNewProcedureID]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewProcedureID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























CREATE FUNCTION [dbo].[GetNewProcedureID]  (@OldProcedureID int , @NewVersion int)
RETURNS bigint  AS  
BEGIN 

Declare @ProcedureID as bigint
Declare @InterventionID  as bigint
Declare @DocumentID as bigint
Declare  @Version as int 


select  @InterventionID = InterventionID , @DocumentID = DocumentID, @Version = Version from TPProcedures where TPProcedureID = @OldProcedureID


set @ProcedureID = 0

Select @ProcedureID=TPProcedureID from TPProcedures where DocumentID = @DocumentID and Version = @NewVersion 
and InterventionID = @InterventionID

return @ProcedureID


END































' 
END
GO
