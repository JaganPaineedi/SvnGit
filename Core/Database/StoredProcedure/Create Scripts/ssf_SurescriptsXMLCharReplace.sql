IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SurescriptsXMLCharReplace]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION ssf_SurescriptsXMLCharReplace

/****** Object:  UserDefinedFunction [dbo].[csf_SurescriptsXMLCharReplace]    Script Date: 12/17/2013 8:50:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[ssf_SurescriptsXMLCharReplace]
    (
      @incomingString VARCHAR(1000), @maxlength INT
    )
/*****************************************************************************************************/
/*
Scalar Function: dbo.csf_SurescriptsXMLCharReplace

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Finds XML characters embedded in data and replaces them with their "quoted" values

Input Parameters:
   @incomingString varchar(1000)	-- any text data that needs to be "quoted"


Output Parameters:

Return:
	quoted text as varchar(1000)

Calls:

Called by:
	SmartCareRx Surescripts Messaging Stored Procedures

Log:
	2011.03.04 - Created.
	2013.12.17  Kneale created the core function to accept a max length and then convert the special characters
*/
/*****************************************************************************************************/
RETURNS VARCHAR(1000)
AS 
    BEGIN
		DECLARE @TotalLen INT = LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@incomingString, '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&apos;'), CHAR(13)+CHAR(10), ' '), CHAR(10), ' '), CHAR(13), ' '))
		IF (@TotalLen > @maxlength)
			RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(@incomingString,1, ((@maxlength - @TotalLen) + LEN(@incomingString))) , '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&apos;'), CHAR(13)+CHAR(10), ' '), CHAR(10), ' '), CHAR(13), ' ')	
		
		RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@incomingString, '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&apos;'), CHAR(13)+CHAR(10), ' '), CHAR(10), ' '), CHAR(13), ' ')
    END

GO


