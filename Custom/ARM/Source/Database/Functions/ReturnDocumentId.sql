/****** Object:  UserDefinedFunction [dbo].[ReturnDocumentId]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnDocumentId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnDocumentId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnDocumentId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


create FUNCTION [dbo].[ReturnDocumentId]
(
@serviceId bigint
)
RETURNS varchar(100)
AS
BEGIN
	Declare @documentId bigint
	
	select @documentId=documentid from documents where serviceid=@serviceId
	
	return @documentId
END

' 
END
GO
