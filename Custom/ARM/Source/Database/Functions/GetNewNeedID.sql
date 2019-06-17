/****** Object:  UserDefinedFunction [dbo].[GetNewNeedID]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewNeedID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetNewNeedID]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewNeedID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




























CREATE FUNCTION [dbo].[GetNewNeedID]  (@OldNeedID int , @NewVersion int)
RETURNS bigint  AS  
BEGIN 

Declare @NeedID as bigint
Declare @NeedNumber as int
Declare @DocumentID as bigint
Declare  @Version as int 


select  @NeedNumber=NeedNumber , @DocumentID = DocumentID, @Version = Version from TPNeeds where NeedID = @OldNeedID


set @NeedID = 0

Select @NeedID=NeedID from TPNeeds where DocumentID = @DocumentID and Version = @NewVersion 
and NeedNumber = @NeedNumber

return @NeedID


END































' 
END
GO
