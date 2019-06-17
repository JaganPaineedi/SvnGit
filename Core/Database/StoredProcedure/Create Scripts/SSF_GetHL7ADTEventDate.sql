IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSF_GetHL7ADTEventDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SSF_GetHL7ADTEventDate]
GO

/****** Object:  UserDefinedFunction [dbo].[SSF_GetHL7ADTEventDate]    Script Date: 02/10/2014 16:46:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SSF_GetHL7ADTEventDate] (@datestring varchar(100))
-- =============================================
	--Modified Date		Modified By   Purpose
	--21 Apr, 2017      Gautam        To display date format ,Created ,SWMBH - Support > Tasks #833.1   
	-- =============================================
RETURNS DATETIME
BEGIN
	DECLARE @FormattedDate DATETIME	
	IF len(@datestring)=8
		set @datestring=@datestring +'000000'
		
	SELECT @FormattedDate=CONVERT(DATETIME,STUFF(STUFF(STUFF(@datestring, 9, 0, ' '), 12, 0, ':'), 15, 0, ':'))
	RETURN @FormattedDate
END
GO