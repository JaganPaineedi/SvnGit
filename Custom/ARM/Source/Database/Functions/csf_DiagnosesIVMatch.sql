/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIVMatch]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIVMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesIVMatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIVMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[csf_DiagnosesIVMatch] 
(@DocumentVersionId_1 int,
 @DocumentVersionId_2 int) 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from table DiagnosesIV to see if the      	*/
/* Diagnosis''s are a match.  Returns True(1) if the diagnosis''s are a match and    		*/
/* false(0) if they do not match or the process fails.									*/
/*																						*/
/* Author: Steve Stevens																*/
/* Date: 12/05/2012																		*/
/****************************************************************************************/
	
as
begin

-- Declare variables 
-- default @retval to false
-- @mismatch 999 forces false value in the if statement were the select clause to fail
declare @retval bit = 0;        
declare @mismatch int = 999;

-- Declare work fields
declare @Odx_PrimarySupport char(1) = '''';
declare @Odx_SocialEnvironment char(1) = '''';
declare @Odx_Educational char(1) = '''';
declare @Odx_Occupational char(1) = '''';
declare @Odx_Housing char(1) = '''';
declare @Odx_Economic char(1) = '''';
declare @Odx_HealthcareServices char(1) = '''';
declare @Odx_Legal char(1) = '''';
declare @Odx_Other char(1) = '''';
declare @Odx_Specification varchar(max) = '''';
declare @Odx_RecordDeleted char(1) = ''''; 

declare @Ndx_PrimarySupport char(1) = '''';
declare @Ndx_SocialEnvironment char(1) = '''';
declare @Ndx_Educational char(1) = '''';
declare @Ndx_Occupational char(1) = '''';
declare @Ndx_Housing char(1) = '''';
declare @Ndx_Economic char(1) = '''';
declare @Ndx_HealthcareServices char(1) = '''';
declare @Ndx_Legal char(1) = '''';
declare @Ndx_Other char(1) = '''';
declare @Ndx_Specification varchar(max) = '''';
declare @Ndx_RecordDeleted char(1) = '''';      

--
--  Select applicable fields from table to test.
Select @Odx_PrimarySupport = isnull(PrimarySupport,''''),
       @Odx_SocialEnvironment = isnull(SocialEnvironment,''''),
       @Odx_Educational = isnull(Educational,''''),
       @Odx_Occupational = isnull(Occupational,''''),
       @Odx_Housing = isnull(Housing,''''),
       @Odx_Economic = isnull(Economic,''''),
       @Odx_HealthcareServices = isnull(HealthcareServices,''''),
       @Odx_Legal = isnull(Legal,''''),
       @Odx_Other = isnull(Other,''''), 
       @Odx_Specification = isnull(Specification,''''),
       @Odx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesIV
 where DocumentVersionId = @DocumentVersionId_1; 
 
Select @Ndx_PrimarySupport = isnull(PrimarySupport,''''),
       @Ndx_SocialEnvironment = isnull(SocialEnvironment,''''),
       @Ndx_Educational = isnull(Educational,''''),
       @Ndx_Occupational = isnull(Occupational,''''),
       @Ndx_Housing = isnull(Housing,''''),
       @Ndx_Economic = isnull(Economic,''''),
       @Ndx_HealthcareServices = isnull(HealthcareServices,''''),
       @Ndx_Legal = isnull(Legal,''''),
       @Ndx_Other = isnull(Other,''''), 
       @Ndx_Specification = isnull(Specification,''''),
       @Ndx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesIV
 where DocumentVersionId = @DocumentVersionId_2; 

--
-- Test returned variables for mismatch 
If @Odx_PrimarySupport <> @Ndx_PrimarySupport or
   @Odx_SocialEnvironment <> @Ndx_SocialEnvironment or 
   @Odx_Educational <> @Ndx_Educational or
   @Odx_Occupational <> @Ndx_Occupational or 
   @Odx_Housing <> @Ndx_Housing or
   @Odx_Economic <> @Ndx_Economic or
   @Odx_HealthcareServices <> @Ndx_HealthcareServices or 
   @Odx_Legal <> @Ndx_Legal or
   @Odx_Other <> @Ndx_Other or
   @Odx_Specification <> @Ndx_Specification or 
   @Odx_RecordDeleted <> @Ndx_RecordDeleted 
   Set @mismatch = 1
   else
   Set @mismatch = 0; 

--
-- Set return value    
If @mismatch = 0
 Set @retval = 1
 else
 Set @retval = 0;

Return @retval;

end

' 
END
GO
