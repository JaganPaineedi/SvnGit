/****** Object:  UserDefinedFunction [dbo].[fnSplit]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnSplit]
GO

/****** Object:  UserDefinedFunction [dbo].[fnSplit]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fnSplit]
(
	@sInputList VARCHAR(MAX) -- List of delimited items
	,@sDelimiter VARCHAR(2)-- delimiter that separates items

) RETURNS @List TABLE 

/******************************************************************************
**		File: [fnSplit]
**		Name: [fnSplit]
**		Desc: Split the string separates with delimiter
**
**		Return values: table
**		
**		Called by : csp_GetDynamicAssessmentForms_Test 	
**		Parameters: 
**		Input							Output
**     ----------							-----------
**		@sInputList
**		@sDelimiter	
**		Auth: Chandan Srivastava
**		Date: March 30, 2009
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:			Author:					Description:
--		22.Apr.2015		Rohith	Uppin			@sInputList Input paramater size modified to Max size. Task#571 CM to SC issues.
--		28.MAR.2019		Akwinass     			What: Modified size of return item & @sItem variable to Max
												Why: When we have large inputs giving error "String or binary data would be truncated"
												Task #10 in StarCare-Environment Issues Trackijjung
**		--------		--------				-------------------------------------------*/

(item nVARCHAR(MAX))

BEGIN

DECLARE @sItem VARCHAR(MAX)

WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0

BEGIN

SELECT

@sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),

@sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))


IF LEN(@sItem) > 0

INSERT INTO @List SELECT @sItem

END

IF LEN(@sInputList) > 0

INSERT INTO @List SELECT @sInputList -- Put the last item in

RETURN

END

--select * from [dbo].fnSplit('1,2,3',',')

GO


