/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesMatch]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesMatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


CREATE FUNCTION [dbo].[csf_DiagnosesMatch] 
(@DocumentVersionId int,
 @DocumentVersionId_5 int)
 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from the Diagnoses tables to see if the  	*/
/* Diagnosis''s are a match.																*/
/* Returns True(1) if the diagnosis''s are a match and false(0) if they do not match 	*/
/* or the process fails.																*/
/* The first DocumentVersionID is from a med note and this procedure gets the second	*/
/* DocumentVersionID from the base diagnosis document record (5) that should already	*/
/* exist for the Client.																*/
/*																						*/
/* Author: Steve Stevens																*/
/* Date: 12/06/2012																		*/
/****************************************************************************************/
	
as
begin

--
-- Declare variables 
declare @IandII bit;
declare @III bit;
declare @IIIcodes bit;
declare @IV bit;
declare @V bit;
declare @ClientID int;        

-- default @retval to false
declare @retval bit = 0;
 
--
-- Check the diagnosis records using custom functions
set @IandII   = dbo.csf_DiagnosesIandIIMatch(@DocumentVersionId, @DocumentVersionId_5);
set @III      = dbo.csf_DiagnosesIIIMatch(@DocumentVersionId, @DocumentVersionId_5);
set @IIICodes = dbo.csf_DiagnosesIIICodesMatch(@DocumentVersionId, @DocumentVersionId_5);
set @IV       = dbo.csf_DiagnosesIVMatch(@DocumentVersionId, @DocumentVersionId_5);
set @V        = dbo.csf_DiagnosesVMatch(@DocumentVersionId, @DocumentVersionId_5);

--
-- Test results and set return value
If @IandII = 1 and @III = 1 and @IIICodes = 1 and @IV = 1 and @V = 1
 Set @retval = 1;

--
-- Return Value
Return @retval;
 
end


' 
END
GO
