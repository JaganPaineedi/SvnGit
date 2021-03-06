/****** Object:  UserDefinedFunction [dbo].[csf_MMStrengthAllowsAutoCalculation]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_MMStrengthAllowsAutoCalculation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_MMStrengthAllowsAutoCalculation]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_SCClientMedicationC2C5Drugs]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_SCClientMedicationC2C5Drugs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_SCClientMedicationC2C5Drugs]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_GetGlobalCodeNameById]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetGlobalCodeNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_GetGlobalCodeNameById]
GO
/****** Object:  UserDefinedFunction [dbo].[FunctionReturnTotalClientsForGroupService]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FunctionReturnTotalClientsForGroupService]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FunctionReturnTotalClientsForGroupService]
GO
/****** Object:  UserDefinedFunction [dbo].[CheckNewClient]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckNewClient]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CheckNewClient]
GO
/****** Object:  UserDefinedFunction [dbo].[cf_Conv_Resolve_GlobalCode]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_Conv_Resolve_GlobalCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[cf_Conv_Resolve_GlobalCode]
GO
/****** Object:  UserDefinedFunction [dbo].[DecimalToText]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DecimalToText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[DecimalToText]
GO
/****** Object:  UserDefinedFunction [dbo].[fnConvertXMLToTable]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnConvertXMLToTable]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnConvertXMLToTable]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_FASStripSpecialChars]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_FASStripSpecialChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_FASStripSpecialChars]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_GetDelimitedStringElement]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetDelimitedStringElement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_GetDelimitedStringElement]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DateTimeToString]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DateTimeToString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DateTimeToString]
GO
/****** Object:  UserDefinedFunction [dbo].[CustomGetLatestLOFType]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestLOFType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CustomGetLatestLOFType]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_QODateFormat]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_QODateFormat]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_QODateFormat]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_OQStripNameInvalidChars]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_OQStripNameInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_OQStripNameInvalidChars]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_PhoneNumberStripped]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PhoneNumberStripped]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_PhoneNumberStripped]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_PMClaims837StripInvalidChars]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMClaims837StripInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_PMClaims837StripInvalidChars]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetNextStartDateForAppointmentSearch]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNextStartDateForAppointmentSearch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_GetNextStartDateForAppointmentSearch]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_NextStartDateForAppointmentSearch]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_NextStartDateForAppointmentSearch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_NextStartDateForAppointmentSearch]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ReplaceParametersDocumentLetters]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_ReplaceParametersDocumentLetters]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_ReplaceParametersDocumentLetters]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FetchOtherRecepients]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchOtherRecepients]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_FetchOtherRecepients]
GO
/****** Object:  UserDefinedFunction [dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnSplit]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_PMServiceCalculateCharge]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMServiceCalculateCharge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_PMServiceCalculateCharge]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Active_And_Inactive_Staff_Full_Name]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Active_And_Inactive_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Active_And_Inactive_Staff_Full_Name]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_All_Staff_Full_Name]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_All_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_All_Staff_Full_Name]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CombinedStaffName]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_CombinedStaffName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fn_CombinedStaffName]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FetchReceipientsName]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchReceipientsName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_FetchReceipientsName]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Staff_Full_Name]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Staff_Full_Name]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Supervisor_List]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Supervisor_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Supervisor_List]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CombinedStaffID]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_CombinedStaffID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fn_CombinedStaffID]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SCGetDefaultScreenId]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_SCGetDefaultScreenId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_SCGetDefaultScreenId]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Active_Client_Table]    Script Date: 04/22/2013 05:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Active_Client_Table]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Active_Client_Table]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesMatch]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesMatch]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIandIIMatch]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIandIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesIandIIMatch]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIIICodesMatch]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIIICodesMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesIIICodesMatch]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIIIMatch]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesIIIMatch]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIVMatch]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIVMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesIVMatch]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesVMatch]    Script Date: 04/22/2013 05:53:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesVMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesVMatch]
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesVMatch]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesVMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'



CREATE FUNCTION [dbo].[csf_DiagnosesVMatch] 
(@DocumentVersionId_1 int,
 @DocumentVersionId_2 int) 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from table DiagnosesV to see if the      	*/
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
declare @Odx_AxisV int = -1;
declare @Odx_RecordDeleted char(1) = ''''; 

declare @Ndx_AxisV int = -1;
declare @Ndx_RecordDeleted char(1) = '''';     

--
--  Select applicable fields from table to test. 
Select @Odx_AxisV = isnull(AxisV,-1),
       @Odx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesV
 where DocumentVersionId = @DocumentVersionId_1; 
 
Select @Ndx_AxisV = isnull(AxisV,-1),
       @Ndx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesV
 where DocumentVersionId = @DocumentVersionId_2;  

--
-- Test returned variables for mismatch 
If @Odx_AxisV <> @Ndx_AxisV or 
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
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIVMatch]    Script Date: 04/22/2013 05:53:21 ******/
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
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIIIMatch]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[csf_DiagnosesIIIMatch] 
(@DocumentVersionId_1 int,
 @DocumentVersionId_2 int) 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from table DiagnosesIII to see if the    	*/
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
declare @Odx_Specification varchar(max) = '''';
declare @Odx_RecordDeleted char(1) = ''''; 

declare @Ndx_Specification varchar(max) = '''';
declare @Ndx_RecordDeleted char(1) = '''';     

--
--  Select applicable fields from table to test. 
Select @Odx_Specification = isnull(Specification,''''),
       @Odx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesIII
 where DocumentVersionId = @DocumentVersionId_1; 
 
Select @Ndx_Specification = isnull(Specification,''''),
       @Ndx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesIII
 where DocumentVersionId = @DocumentVersionId_2;  

--
-- Test returned variables for mismatch 
If @Odx_Specification <> @Ndx_Specification or 
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
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIIICodesMatch]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIIICodesMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[csf_DiagnosesIIICodesMatch] 
(@DocumentVersionId_1 int,
 @DocumentVersionId_2 int) 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from table DiagnosesIIICodes to see if the 	*/
/* Diagnosis''s are a match.  Returns True(1) if the diagnosis''s are a match and    		*/
/* false(0) if they do not match or the process fails.									*/
/*																						*/
/* Author: Steve Stevens																*/
/* Date: 12/06/2012																		*/
/****************************************************************************************/
	
as
begin

-- Declare variables 
-- default @retval to false
-- @mismatch 999 forces false value in the if statement were the select clause to fail
declare @retval bit = 0;        
declare @mismatch int = 999;    

--  Use common tables to get each set of rows from the diagnosis tables
--  Then join using a full outer join to ensure null values on one side 
--  of the join in the event of a row mismatch.  The row mismatch is 
--  detected by check for isnull(0) value in the documentversionid which
--  should never contain a zero value. 
With OrgDx as (
  select isnull(DocumentVersionId,0) as DocumentVersionId,
         isnull(ICDCode,'''') as ICDCode,
         isnull(Billable,'''') as Billable, 
         isnull(RecordDeleted,'''') as RecordDeleted
         from dbo.DiagnosesIIICodes 
         where DocumentVersionId = @DocumentVersionId_1
         ),
     NewDx as (
  select isnull(DocumentVersionId,0) as DocumentVersionId,
         isnull(ICDCode,'''') as ICDCode,
         isnull(Billable,'''') as Billable, 
         isnull(RecordDeleted,'''') as RecordDeleted
         from dbo.DiagnosesIIICodes 
         where DocumentVersionId = @DocumentVersionId_2
         )
select @mismatch = COUNT(*) from orgdx odx full outer join NewDx ndx 
    on odx.ICDCode = ndx.ICDCode
 Where odx.ICDCode <> ndx.ICDCode
    or odx.Billable <> ndx.Billable 
    or odx.RecordDeleted <> ndx.RecordDeleted 
    or isnull(odx.DocumentVersionId, 0) = 0     -- row mismatch on 1
    or isnull(ndx.DocumentVersionId, 0) = 0;    -- row mismatch on 2
    
If @mismatch = 0
 Set @retval = 1
 else
 Set @retval = 0;

Return @retval;
 
end

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIandIIMatch]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIandIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[csf_DiagnosesIandIIMatch] 
(@DocumentVersionId_1 int,
 @DocumentVersionId_2 int) 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from table DiagnosesIandII to see if the 	*/
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

--  Use common tables to get each set of rows from the diagnosis tables
--  Then join using a full outer join to ensure null values on one side 
--  of the join in the event of a row mismatch.  The row mismatch is 
--  detected by check for isnull(0) value in the documentversionid which
--  should never contain a zero value. 
With OrgDx as (
  select isnull(DocumentVersionId,0) as DocumentVersionId,
         isnull(axis,0) as axis,
         isnull(DSMCode,'''') as DSMCode,
         isnull(DSMNumber,0) as DSMNumber,
         isnull(DiagnosisType,0) as DiagnosisType,
         isnull(RuleOut,'''') as RuleOut,
         isnull(Billable,'''') as Billable, 
         isnull(Severity,0) as Severity,
         isnull(DSMVersion,'''') as DSMVersion,
         isnull(DiagnosisOrder,0) as DiagnosisOrder,
         isnull(Remission,0) as Remission,
         isnull(RecordDeleted,'''') as RecordDeleted
         from dbo.DiagnosesIAndII 
         where DocumentVersionId = @DocumentVersionId_1
         ),
     NewDx as (
  select isnull(DocumentVersionId,0) as DocumentVersionId,     
         isnull(axis,0) as axis,
         isnull(DSMCode,'''') as DSMCode,
         isnull(DSMNumber,0) as DSMNumber,
         isnull(DiagnosisType,0) as DiagnosisType,
         isnull(RuleOut,'''') as RuleOut,
         isnull(Billable,'''') as Billable, 
         isnull(Severity,0) as Severity,
         isnull(DSMVersion,'''') as DSMVersion,
         isnull(DiagnosisOrder,0) as DiagnosisOrder,
         isnull(Remission,0) as Remission,
         isnull(RecordDeleted,'''') as RecordDeleted    
         from dbo.DiagnosesIAndII 
         where DocumentVersionId = @DocumentVersionId_2
         )
select @mismatch = COUNT(*) from orgdx odx full outer join NewDx ndx 
  on odx.diagnosistype = ndx.diagnosistype 
 and odx.diagnosisorder = ndx.diagnosisorder
 where odx.axis <> ndx.axis
    or odx.DSMCode <> ndx.DSMCode
    or odx.DSMNumber <> ndx.DSMNumber
    or odx.DiagnosisType <> ndx.DiagnosisType
    or odx.RuleOut <> ndx.RuleOut
    or odx.Billable <> ndx.Billable
    or odx.Severity <> ndx.Severity 
    or odx.DSMVersion <> ndx.DSMVersion 
    or odx.DiagnosisOrder <> ndx.DiagnosisOrder 
    or odx.Remission <> ndx.Remission  
    or odx.RecordDeleted <> ndx.RecordDeleted 
    or isnull(odx.DocumentVersionId, 0) = 0     -- row mismatch on 1
    or isnull(ndx.DocumentVersionId, 0) = 0;    -- row mismatch on 2
    
If @mismatch = 0
 Set @retval = 1
 else
 Set @retval = 0;

Return @retval;
 
end

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesMatch]    Script Date: 04/22/2013 05:53:21 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_Active_Client_Table]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Active_Client_Table]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'--/*
CREATE FUNCTION [dbo].[fn_Active_Client_Table]()
RETURNS @ClientTable TABLE 
(	
	-- Add the parameters for the function here
	ClientId	Int,
	ClientName	Varchar(50)
)
AS
--*/
-- =============================================
-- Author:		<Michael S Rowley>
-- Create date: <01/15/2013>
-- Description:	<Return a table of all active ClientId and Client Lastname, Firstname>
-- =============================================
/*
DECLARE @ClientTable TABLE
(
	ClientId	Int,
	ClientName	Varchar(50)
)
--*/
BEGIN
	INSERT INTO @ClientTable (ClientId, ClientName)
	VALUES (''0'', ''All Clients'')

	BEGIN
		INSERT INTO @ClientTable(ClientId, ClientName)
		SELECT c.ClientId , c.LastName + '', '' + c.FirstName 
		FROM dbo.clients c
		WHERE c.Active = ''Y''
		AND ISNULL(c.RecordDeleted, ''N'') <> ''Y''
		ORDER BY c.ClientId 
		--SELECT * FROM @ClientTable
	END
	RETURN 

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SCGetDefaultScreenId]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_SCGetDefaultScreenId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create FUNCTION [dbo].[fn_SCGetDefaultScreenId] (      
      
@StaffId int      
      
)  RETURNS   int      
/********************************************************************************        
-- FUNCTION: dbo.fn_SCGetDefaultScreenId      
--        
-- Copyright: Streamline Healthcate Solutions        
--        
-- Purpose: Get screen id for which staff have permission.        
--        
-- Updates:                                                               
-- Date        Author        Purpose        
-- 05.07.2010  Vikas Monga   Created.              
*********************************************************************************/        
      
begin      
declare @ScreenId int      
declare @defaultScreenid int

select @defaultScreenid=defaultScreenid from tabs where tabid=1
if exists(select * from ViewStaffPermissions where staffid=@StaffId and PermissionTemplateType=5703  and PermissionItemId=@defaultScreenid)
Begin
	set @ScreenId= @defaultScreenid
END
else
begin
Select top 1  @ScreenId=B.ScreenId  from ViewStaffPermissions VP         
left join Banners B         
on B.BannerId= VP.PermissionItemId         
where PermissionTemplateType=5703         
and StaffId=@StaffId and B.TabId=1        
    
end
return @ScreenId  
end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CombinedStaffID]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_CombinedStaffID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Mahesh
-- Create date: 7th-Dec-2010
-- Description:	To Get the Concatenated StaffID
-- =============================================

create FUNCTION [dbo].[Fn_CombinedStaffID]
(
	@MessageID int
)
RETURNS varchar(max)
AS
BEGIN
	
	DECLARE @StaffID varchar(max)
	-- Add the T-SQL statements to compute the return value here
	
	--SELECT @StaffID=(Case when a.SystemDatabaseId is Not null then convert(varchar,a.SystemStaffid) else convert(varchar,Msg.FromStaffID) end)+'',''+ Coalesce(@StaffID,'''','''')
 --from MessageRecepients a join Messages Msg on a.MessageId=Msg.MessageId 
 --where a.MessageID=@MessageID
	
	SELECT @StaffID=coalesce(@StaffID,'''','''') from MessageRecepients  where messageid=@MessageID
	declare @Index int
	if(len(@StaffID)>0)
	set @StaffID=substring(@StaffID,0,len(@StaffID))
	-- Return the result of the function
	RETURN @StaffID

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Supervisor_List]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Supervisor_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
--/*
CREATE FUNCTION [dbo].[fn_Supervisor_List] 
(
	-- Add the parameters for the function here
	@looptill	Int,
	@StaffId	varchar(10)
)
RETURNS 
@staff	TABLE
	(
	StaffId		INT,
	StaffName	Varchar(50)
	)
AS
--*/
/* =============================================================*/
/* Author:		<Michael Rowley>								*/
/*																*/
/*	Updates:													*/
/*	Date		Author	Purpose									*/
/*	10/14/2012	MSR		Create to return Table of StaffId		*/
/*						Based on tier in company (Staff/Super/VP*/
/*	11/14/2012	MSR		Added Staff Name to be return with table*/
/* =============================================================*/
/*	
DECLARE
	@looptill	Int,
	@StaffId	varchar(10)

DECLARE @staff	TABLE
	(
	StaffId		Int,
	StaffName	Varchar(50)
	)
	
SELECT	@StaffId = 159,
	@looptill = 1
--*/
BEGIN
	DECLARE 
		@loop		int	

	INSERT	INTO	@staff (StaffId, StaffName)
	SELECT	s.StaffId, s.LastName + '', '' + s.FirstName 
	FROM	Staff s
	WHERE	s.StaffId like @StaffId
	AND (ISNULL(s.RecordDeleted,''N'')<>''Y'')

	BEGIN
		SELECT	@loop =	0
		
		WHILE	@loop < @looptill 
		BEGIN
		
			INSERT	INTO	@staff (StaffId, StaffName)
			SELECT	s.StaffId, ts.LastName + '', '' + ts.FirstName 
			FROM	dbo.StaffSupervisors s
			JOIN Staff ts
			ON s.StaffId = ts.StaffId 
			--WHERE	s.super_id in	(
			WHERE	s.SupervisorId in	(
						SELECT	s2.StaffId
						FROM	@Staff s2
						)
			AND	s.StaffId not in	(
							SELECT	s2.StaffId
							FROM	@Staff s2
							)
			AND (ISNULL(s.RecordDeleted,''N'')<>''Y'')
			SELECT	@loop = @loop + 1
		END
	END
RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Staff_Full_Name]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'--/*
CREATE FUNCTION [dbo].[fn_Staff_Full_Name]()
RETURNS @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
AS
--*/
-- =============================================
-- Author:		<Michael R.>
-- Create date: <10/08/2012>
-- Description:	<Description,,>
-- =============================================
/*
DECLARE @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
--*/
BEGIN
	INSERT INTO @Staff_Full_Name (StaffID, StaffName)
	VALUES (''000'', ''All Staff'')


	BEGIN
		INSERT INTO @Staff_Full_Name(StaffID, StaffName)
		SELECT s.StaffId, s.LastName + '', '' + s.FirstName
		FROM dbo.Staff s
		WHERE s.Active = ''Y''
		AND s.Clinician = ''Y''
		AND ISNULL(s.RecordDeleted, ''N'') <> ''Y''
		ORDER BY s.LastName
	--SELECT * FROM @Staff_Full_Name 
	END
	RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FetchReceipientsName]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchReceipientsName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create FUNCTION [dbo].[fn_FetchReceipientsName]
(
	
	@MessageId int
)
RETURNS varchar(max)
AS
BEGIN
DECLARE @RecepientValue varchar(max)
set @RecepientValue=''''
select
	 @RecepientValue= @RecepientValue + 
	 case when @RecepientValue ='''' then '''' else '' ;'' end
+ Case When MR.StaffId IS Not Null Then       
rtrim(isnull(c.LastName,''''))+ '', '' +  rtrim(isnull(c.FirstName,''''))
Else
rtrim(isnull(d.LastName,''''))+ '', '' +  rtrim(isnull(d.FirstName,''''))
End                       

 from MessageRecepients MR
Left outer join Staff c  on MR.StaffId=c.StaffId    
Left outer join Staff d  on MR.SystemStaffId=d.StaffId   

 join Staff s on MR.StaffId = s.StaffId
where messageid=@MessageId
return @RecepientValue
end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CombinedStaffName]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fn_CombinedStaffName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

  
-- =============================================  
-- Author:  Mahesh  
-- Create date: 7-Dec-2010  
-- Description: To get the Concatenated StaffNames  
--Modified By Vikas (Added  space after comma & semicolon  in Last name & first name Ref to task 48 in KalamazooBugs)
-- =============================================  
CREATE FUNCTION [dbo].[Fn_CombinedStaffName]  
(  
 @MessageID int  
)  
RETURNS varchar(max)  
AS  
BEGIN  
  --Coalesce((Case when a.SystemDatabaseId is Not null then Msg.ToSystemStaffName else (rtrim(staf.LastName) + '' '' + rtrim(staf.FirstName)) end),'','','''') as ToStaffName,  
 DECLARE @StaffName varchar(max)  
 -- Add the T-SQL statements to compute the return value here  
 SELECT @StaffName=(Case when a.SystemDatabaseId is Not null then a.SystemStaffName else (rtrim(staf.LastName) + '', '' + rtrim(staf.FirstName)) end)+''; ''+ Coalesce(@StaffName,'''','''')  
 from MessageRecepients a left join Messages Msg on a.MessageId=Msg.MessageId left join Staff staf on a.StaffId=staf.StaffId  
 where a.MessageId=@MessageID  
 declare @Index int  
 if(len(@StaffName)>0)  
 set @StaffName=substring(@StaffName,0,len(@StaffName))  
 -- Return the result of the function  
 RETURN @StaffName  
  
END  

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_All_Staff_Full_Name]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_All_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'--/*
CREATE FUNCTION [dbo].[fn_All_Staff_Full_Name]()
RETURNS @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
AS
--*/
-- =============================================
-- Author:		<Michael R.>
-- Create date: <10/08/2012>
-- Description:	<Description,,>
-- =============================================
/*
DECLARE @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
--*/
BEGIN
	INSERT INTO @Staff_Full_Name (StaffID, StaffName)
	VALUES (''000'', ''All Staff'')


	BEGIN
		INSERT INTO @Staff_Full_Name(StaffID, StaffName)
		SELECT s.StaffId, s.LastName + '', '' + s.FirstName
		FROM dbo.Staff s
		WHERE s.Active = ''Y''
		AND (ISNULL(s.RecordDeleted, ''N'') <> ''Y'')
		ORDER BY s.LastName
	--SELECT * FROM @Staff_Full_Name 
	END
	RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Active_And_Inactive_Staff_Full_Name]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Active_And_Inactive_Staff_Full_Name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'--/*
CREATE FUNCTION [dbo].[fn_Active_And_Inactive_Staff_Full_Name]()
RETURNS @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
AS
--*/
-- =============================================
-- Author:		<Ryan M.>
-- Create date: <13/06/2013>
-- Description:	<Modified from fn_Staff_Full_Name by Michael R. Gets all staff, even those who are inactive.>
-- =============================================
/*
DECLARE @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)
--*/
BEGIN
	INSERT INTO @Staff_Full_Name (StaffID, StaffName)
	VALUES (''000'', ''All Staff'')


	BEGIN
		INSERT INTO @Staff_Full_Name(StaffID, StaffName)
		SELECT s.StaffId, s.LastName + '', '' + s.FirstName
		FROM dbo.Staff s
		WHERE s.Clinician = ''Y''
		AND ISNULL(s.RecordDeleted, ''N'') <> ''Y''
		ORDER BY s.LastName
	--SELECT * FROM @Staff_Full_Name 
	END
	RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_PMServiceCalculateCharge]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMServiceCalculateCharge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_PMServiceCalculateCharge] (@ServiceId int) RETURNS money AS
begin

declare @retval int

declare @ClientId int, @DateOfService datetime, @ClinicianId int, 
@ProcedureCodeId int, @Units int, @ProgramId int, @LocationId int,
@ProcedureRateId int, @Charge money, @Degree int


-- Get Service Info
select @ClientId = s.ClientId, @DateOfService = s.DateOfService, @ClinicianId = s.ClinicianId,
@ProcedureCodeId = s.ProcedureCodeId, @Units = s.Unit, @ProgramId = s.ProgramId, @LocationId = s.LocationId,
@Degree = st.Degree
from Services as s
left outer join Staff as st on st.StaffId = s.ClinicianId
where s.ServiceId = @ServiceId

if @@rowcount = 0 goto no_service_info

select top 1 @ProcedureRateId = PR.ProcedureRateId, 
@Charge = (Case PR.ChargeType when ''E'' then PR.Amount -- For Exactly
when ''R'' then PR.Amount -- For Range 
when ''P'' then (PR.Amount)*convert(decimal(10,2),(@Units/convert(int,PR.FromUnit))) end) 
from ProcedureRates PR
LEFT JOIN ProcedureRateDegrees PRD ON (PR.ProcedureRateId = PRD.ProcedureRateId
and isnull(PRD.RecordDeleted,''N'') = ''N'')
LEFT JOIN ProcedureRateLocations PRL ON (PR.ProcedureRateId = PRL.ProcedureRateId
and isnull(PRL.RecordDeleted,''N'') = ''N'')
LEFT JOIN ProcedureRatePrograms PRP ON (PR.ProcedureRateId = PRP.ProcedureRateId
and isnull(PRP.RecordDeleted,''N'') = ''N'')
LEFT JOIN ProcedureRateStaff PRS ON (PR.ProcedureRateId = PRS.ProcedureRateId
and isnull(PRS.RecordDeleted,''N'') = ''N'')
where isnull(PR.RecordDeleted,''N'') = ''N''
and PR.CoveragePlanId is  null
and PR.ProcedureCodeId = @ProcedureCodeId
and PR.FromDate <= @DateOfService
and (dateadd(dd, 1, PR.ToDate) > @DateOfService or PR.ToDate is null)
and (PR.ChargeType <> ''P'' or @Units >= PR.FromUnit)
and (PR.ChargeType <> ''E'' or PR.FromUnit = @Units)
and (PR.ChargeType <> ''R'' or (@Units >= PR.FromUnit and @Units <= PR.ToUnit))
and (PRP.ProgramId is null or PRP.ProgramId = @ProgramId)
and (PRD.Degree is null or PRD.Degree = @Degree)
and (PRL.LocationId is null or PRL.LocationId = @LocationId)
and (PRS.StaffId is null or PRS.StaffId = @ClinicianId)
and (PR.ClientId is null or PR.ClientId = @ClientId)
order by PR.Priority ASC, 
(case when PRP.programId= @ProgramId then 1 else 0 end +
case when PRL.LocationId= @LocationId then 1 else 0 end +
case when PRD.Degree= @Degree then 1 else 0 end +
case when PR.ClientId= @ClientId then 1 else 0 end +
case when PRS.StaffId = @ClinicianId then 1 else 0 end) DESC

if @@error <> 0 goto select_error

return @Charge

no_service_info:
	return null

select_error:
	return -$1

end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fnSplit]
(
	@sInputList VARCHAR(8000) -- List of delimited items
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
**		--------		--------				-------------------------------------------*/

(item nVARCHAR(255))

BEGIN

DECLARE @sItem VARCHAR(8000)

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

--select * from [dbo].fnSplit(''1,2,3'','','')
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]  
(@ClientId    int,  
@StartDate    datetime, -- Only look for documents after this date.  Can be passed as null and will default to 1/1/1900.  
@DocumentCodeGroup  varchar(max), -- Comma separated list of documentCodeId''s.  
@DocumentStatusGrouping varchar(max)  -- Comma separated list of document statuses.  
)  
Returns int  
-- Description: This function accepts a clientId, start date, a comma delimited list of document codes, and a comma delimited list of document statuses.  The function then determines and returns  
-- the latest (after the start date provided) DocumentVersionId for any document with a status provied and in the grouping of document codes provided.  
--  
-- Created by: Ryan Noble  
-- Created on: Apr 18 2011  
Begin  
 -- Variable declaration  
 declare @SQL    varchar(max),  
   @DocumentVersionId int,  
   @AdmissionDate  datetime  
   
 declare @DocumentCodes  table  
    (DocumentCodeId int)  
   
 declare @DocumentStatuses table  
    (Status   int)  
  
 -- Use the fnsplit function to create a table of document code filters  
 insert into @DocumentCodes  
 (DocumentCodeId)  
 select * from dbo.fnsplit(@DocumentCodeGroup,'','')  
   
 -- Use the fnsplit function to create a table of document status filters  
 insert into @DocumentStatuses  
 (Status)  
 select * from dbo.fnsplit(@DocumentStatusGrouping,'','')  
  
 -- Using the DocumentCodes and Admission Date, determine the latest document in the group.  
 Select @DocumentVersionId = (select top 1 CurrentDocumentVersionId  
        from Documents a  
        join @DocumentCodes b on a.documentCodeId = b.DocumentCodeId  
        join @DocumentStatuses c on a.status = c.status  
         where a.ClientId = @ClientId  
          and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))  
          and a.EffectiveDate >= isnull(@StartDate, ''1/1/1900'')  
          and isNull(a.RecordDeleted,''N'') <> ''Y''  
          order by a.EffectiveDate desc,a.status,a.ModifiedDate desc) -- To prevent ''random'' sorting, currently status will sort by integer.  This could be given a hierarchy.  
            
 Return @DocumentVersionId  
End  
  ' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FetchOtherRecepients]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchOtherRecepients]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================  
-- Author:  Mahesh Kumar  
-- Create date: 7-Dec-2010  
-- Description: To get the Values of other recepients of Message  
-- =============================================  
  
--select dbo.fn_FetchOtherRecepients(''Rohit,Katoch;Mitu;Rohit'',2)  
CREATE FUNCTION [dbo].[fn_FetchOtherRecepients]  
(  
 @OtherRecepients varchar(max),  
 @CurrentRecord int  
)  
RETURNS varchar(max)  
AS  
BEGIN  
 -- Declare the return variable here  
 DECLARE @OtherRecepientValue varchar(max)  
 Declare @RecordSelected int  
 set @OtherRecepientValue=''''  
 set @RecordSelected = -1  
   
 Declare @Index int  
 set @Index=1  
 while @Index!= 0          
    begin     
  set @RecordSelected=@RecordSelected+1     
        set @Index = charindex('';'',@OtherRecepients)  
        if(@RecordSelected<>@CurrentRecord)  
        Begin          
        if @Index!=0          
            set @OtherRecepientValue =@OtherRecepientValue+ left(@OtherRecepients,@Index - 1)  +'';''       
        else          
            set @OtherRecepientValue = @OtherRecepientValue + @OtherRecepients       
        End  
        set @OtherRecepients= Right(@OtherRecepients,len(@OtherRecepients)-@Index)  
          
    End  
 if (SUBSTRING(@OtherRecepientValue,len(@OtherRecepientValue),1)='';'')  
 set @OtherRecepientValue=SUBSTRING(@OtherRecepientValue,1,LEN(@OtherRecepientValue)-1)  
 return @OtherRecepientValue   
  
END  ' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ReplaceParametersDocumentLetters]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_ReplaceParametersDocumentLetters]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'  
CREATE FUNCTION [dbo].[fn_ReplaceParametersDocumentLetters]  
(  
@TemplateText varchar(max),  
@Parameter varchar(100),  
@ParameterValue varchar(100)  
)  
RETURNS varchar(max)  
AS  
BEGIN  
declare @Index int  
set @Index= CHARINDEX(@Parameter,@TemplateText)  
if(@Index>0)  
set @TemplateText=SUBSTRING(@TemplateText,0,@Index)+@ParameterValue+SUBSTRING(@TemplateText,@Index+LEN(@Parameter),LEN(@TemplateText))  
return @TemplateText  
END  ' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_NextStartDateForAppointmentSearch]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_NextStartDateForAppointmentSearch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create FUNCTION [dbo].[fn_NextStartDateForAppointmentSearch] (
@StartDate    DATETIME, 
@Monday        CHAR(1),  
@Tuesday       CHAR(1),  
@Wednesday       CHAR(1),  
@Thursday       CHAR(1),  
@Friday        CHAR(1),  
@Saturday       CHAR(1),  
@Sunday        CHAR(1)) RETURNS DATETIME
AS
BEGIN

DECLARE @NextStartDate DATETIME
DECLARE @CurDay VARCHAR(10)
DECLARE @setNextDay VARCHAR(10)

SET @CurDay = datename (dw, @StartDate) 
------------------MONDAY------------------------------
IF (@CurDay = ''Monday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''
ELSE IF (@CurDay = ''Monday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Monday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Monday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Monday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Monday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Monday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday''  --NextMonday
------------------TUESDAY------------------------------
IF (@CurDay = ''Tuesday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Tuesday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Tuesday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Tuesday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Tuesday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Tuesday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Tuesday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  --Next Tuesday	
------------------WEDNESDAY------------------------------

IF (@CurDay = ''Wednesday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Wednesday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Wednesday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Wednesday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Wednesday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Wednesday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	
ELSE IF (@CurDay = ''Wednesday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''  --Next Wednesday	
------------------THURSDAY------------------------------		

IF (@CurDay = ''Thursday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Thursday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Thursday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Thursday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Thursday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	 
ELSE IF (@CurDay = ''Thursday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday'' 		
ELSE IF (@CurDay = ''Thursday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''--Next Tuesday	
------------------FRIDAY------------------------------		
IF (@CurDay = ''Friday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Friday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Friday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Friday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	 
ELSE IF (@CurDay = ''Friday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Friday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Friday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday'' --Next Tuesday	
------------------SATURDAY------------------------------		

IF (@CurDay = ''Saturday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Saturday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Saturday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  
ELSE IF (@CurDay = ''Saturday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Saturday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Saturday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Saturday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''--Next Tuesday	
------------------SUNDAY------------------------------		

 IF (@CurDay = ''Sunday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Sunday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  --Next Tuesday	
ELSE	IF (@CurDay = ''Sunday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Sunday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Sunday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Sunday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Sunday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''	
		
		
		
	SELECT 
	@NextStartDate =
	CASE  WHEN @setNextDay = ''Monday''
	THEN 
		 case 
		when datename(dw,dateadd(day,1,@StartDate))=''Monday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Monday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Monday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Monday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Monday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Monday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Monday'' then dateadd(day,7,@StartDate)
	end
	WHEN @setNextDay = ''Tuesday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Tuesday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Tuesday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Tuesday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Tuesday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Tuesday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Tuesday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Tuesday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Wednesday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Wednesday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Wednesday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Wednesday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Wednesday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Wednesday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Wednesday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Wednesday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Thursday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Thursday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Thursday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Thursday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Thursday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Thursday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Thursday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Thursday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Friday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Friday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Friday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Friday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Friday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Friday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Friday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Friday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Saturday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Saturday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Saturday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Saturday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Saturday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Saturday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Saturday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Saturday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Sunday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Sunday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Sunday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Sunday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Sunday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Sunday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Sunday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Sunday'' then dateadd(day,7,@StartDate)
	END
	ELSE
	dateadd(day,1,@StartDate)
END
RETURN @NextStartDate
--SELECT CONVERT(datetime, @NextStartDate, 101) 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetNextStartDateForAppointmentSearch]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNextStartDateForAppointmentSearch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create FUNCTION [dbo].[fn_GetNextStartDateForAppointmentSearch] (
@StartDate    DATETIME, 
@Monday        CHAR(1),  
@Tuesday       CHAR(1),  
@Wednesday       CHAR(1),  
@Thursday       CHAR(1),  
@Friday        CHAR(1),  
@Saturday       CHAR(1),  
@Sunday        CHAR(1)) RETURNS DATETIME
AS
-- =============================================
-- Author:		MSuma
-- Create date: 19th-FEB-2010
-- Description:	To Reset Stat Date in AppointmentSearch
-- =============================================
BEGIN

DECLARE @NextStartDate DATETIME
DECLARE @CurDay VARCHAR(10)
DECLARE @setNextDay VARCHAR(10)

SET @CurDay = datename (dw, @StartDate) 
------------------MONDAY------------------------------
IF (@CurDay = ''Monday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''
ELSE IF (@CurDay = ''Monday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Monday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Monday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Monday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Monday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Monday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday''  --NextMonday
------------------TUESDAY------------------------------
IF (@CurDay = ''Tuesday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Tuesday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Tuesday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Tuesday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Tuesday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Tuesday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Tuesday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  --Next Tuesday	
------------------WEDNESDAY------------------------------

IF (@CurDay = ''Wednesday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Wednesday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Wednesday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Wednesday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Wednesday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Wednesday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	
ELSE IF (@CurDay = ''Wednesday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''  --Next Wednesday	
------------------THURSDAY------------------------------		

IF (@CurDay = ''Thursday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Thursday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Thursday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Thursday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Thursday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	 
ELSE IF (@CurDay = ''Thursday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday'' 		
ELSE IF (@CurDay = ''Thursday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''--Next Tuesday	
------------------FRIDAY------------------------------		
IF (@CurDay = ''Friday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Friday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Friday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Friday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	 
ELSE IF (@CurDay = ''Friday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Friday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Friday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday'' --Next Tuesday	
------------------SATURDAY------------------------------		

IF (@CurDay = ''Saturday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''
ELSE IF (@CurDay = ''Saturday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Saturday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	  
ELSE IF (@CurDay = ''Saturday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Saturday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Saturday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Saturday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''--Next Saturday	
------------------SUNDAY------------------------------		

 IF (@CurDay = ''Sunday'' and @Monday = ''Y'')
		SET @setNextDay = ''Monday'' 
ELSE IF (@CurDay = ''Sunday'' and @Tuesday = ''Y'')
		SET @setNextDay = ''Tuesday''	 	
ELSE	IF (@CurDay = ''Sunday'' and @Wednesday = ''Y'')
		SET @setNextDay = ''Wednesday''
ELSE IF (@CurDay = ''Sunday'' and @Thursday = ''Y'')
		SET @setNextDay = ''Thursday''
ELSE IF (@CurDay = ''Sunday'' and @Friday = ''Y'')
		SET @setNextDay = ''Friday''
ELSE IF (@CurDay = ''Sunday'' and @Saturday = ''Y'')
		SET @setNextDay = ''Saturday''
ELSE IF (@CurDay = ''Sunday'' and @Sunday = ''Y'')
		SET @setNextDay = ''Sunday''	 --Next Sunday
		
		
		
	SELECT 
	@NextStartDate =
	CASE  WHEN @setNextDay = ''Monday''
	THEN 
		 case 
		when datename(dw,dateadd(day,1,@StartDate))=''Monday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Monday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Monday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Monday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Monday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Monday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Monday'' then dateadd(day,7,@StartDate)
	end
	WHEN @setNextDay = ''Tuesday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Tuesday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Tuesday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Tuesday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Tuesday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Tuesday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Tuesday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Tuesday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Wednesday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Wednesday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Wednesday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Wednesday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Wednesday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Wednesday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Wednesday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Wednesday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Thursday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Thursday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Thursday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Thursday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Thursday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Thursday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Thursday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Thursday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Friday''  THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Friday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Friday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Friday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Friday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Friday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Friday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Friday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Saturday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Saturday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Saturday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Saturday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Saturday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Saturday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Saturday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Saturday'' then dateadd(day,7,@StartDate)
	END
	WHEN @setNextDay = ''Sunday'' THEN
		case when datename(dw,dateadd(day,1,@StartDate))=''Sunday'' then dateadd(day,1,@StartDate)
		when datename(dw,dateadd(day,2,@StartDate))=''Sunday'' then dateadd(day,2,@StartDate)
		when datename(dw,dateadd(day,3,@StartDate))=''Sunday'' then dateadd(day,3,@StartDate)
		when datename(dw,dateadd(day,4,@StartDate))=''Sunday'' then dateadd(day,4,@StartDate)
		when datename(dw,dateadd(day,5,@StartDate))=''Sunday'' then dateadd(day,5,@StartDate)
		when datename(dw,dateadd(day,6,@StartDate))=''Sunday'' then dateadd(day,6,@StartDate)
		when datename(dw,dateadd(day,7,@StartDate))=''Sunday'' then dateadd(day,7,@StartDate)
	END
	ELSE
	dateadd(day,1,@StartDate)
END
RETURN @NextStartDate

END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_PMClaims837StripInvalidChars]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMClaims837StripInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[csf_PMClaims837StripInvalidChars] (@incoming varchar(8000)) returns varchar(8000) as
/*********************************************************************/
/* Function: dbo.csf_PMClaims837StripInvalidChars                         */
/* Creation Date:    4/3/2009                                         */
/*                                                                   */
/* Purpose: Common function to cleanup names in the claim lines data	*/
/*                                                                   */
/* Input Parameters:											     */
/*	@incoming varchar(8000) - The string to be cleaned				*/
/*                                                                   */
/* Returns:															*/
/*	varchar(8000) modified string stripped of invalid chars			*/
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  4/3/09		TER			created									*/
/*********************************************************************/
begin

declare @retVal varchar(8000)

set @retVal = @incoming

set @retVal = replace(@retVal, ''('', '' '')
set @retVal = replace(@retVal, '')'', '' '')
set @retVal = replace(@retVal, ''-'', '' '')
set @retVal = replace(@retVal, ''"'', '' '')
set @retVal = replace(@retVal, ''.'', '' '')


return ltrim(rtrim(@retVal))

end


' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_PhoneNumberStripped]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PhoneNumberStripped]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_PhoneNumberStripped](@PrettyPhoneNumber varchar(128)) returns varchar(128) as
/*
	This function was created for the InfoChannel member extract but can be used elsewhere.
	Strips spaces, parens, and dashes from the input text and returns the result.
Creator: Tom Remisoski
Date: 2/15/2007
*/
begin

return replace(replace(replace(replace(@PrettyPhoneNumber, ''('', ''''), '')'', ''''), '' '', ''''), ''-'', '''')

end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_OQStripNameInvalidChars]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_OQStripNameInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_OQStripNameInvalidChars](@n varchar(200)) returns varchar(200) as
begin

	declare @i int
	declare @exprValidCharacters varchar(200)
	set @exprValidCharacters = ''%[^a-zA-Z- ]%''	-- these are the only characters allowed in a client name

	while patindex(@exprValidCharacters, @n) > 0
	begin
		set @i = patindex(@exprValidCharacters, @n)

		if @i = len(@n) and len(@n) = 1
			set @n = ''''
		else if @i = len(@n)
			set @n = substring(@n, 1, @i - 1)
		else
			set @n = substring(@n, 1, @i - 1) + '' '' + substring(@n, @i + 1, 200) 

	end

	return @n

end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_QODateFormat]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_QODateFormat]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_QODateFormat] (@d datetime) returns varchar(10) as
begin

	return case when month(@d) < 10 then ''0'' else '''' end + cast(month(@d) as varchar) + ''/''
		+ case when day(@d) < 10 then ''0'' else '''' end + cast(day(@d) as varchar) + ''/''
		+ cast(year(@d) as varchar)

end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[CustomGetLatestLOFType]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestLOFType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create function [dbo].[CustomGetLatestLOFType]    
(@ClientId       int)  
Returns char(1)  
AS  
-- Description: Procedure to determine and return LOFType to any calling procedure.  As some required elements are commonly needed in  
-- many documents for various reasons, this procedure accepts those elements as parameters, or can calculate them if they have not already  
-- been calculated.  
--  
-- Created by: Ryan Noble  
-- Created on: Apr 18 2011  
Begin  
Declare @AdmissionDate      datetime,  
  @Age        int,  
  @LatestAssessmentDocumentVersionId int,  
  @LOFType       char(1)  
  
-- Get the client''s age.  
  Select @Age = dbo.GetAge(c.DOB, getdate())    
 From Clients c    
 Where c.ClientId = @ClientID    
 and isnull(c.RecordDeleted, ''N'')= ''N''    
    
-- Get the latest signed Assessment DocumentVersionId  
If (@LatestAssessmentDocumentVersionID is null)    
 Begin    
 select @LatestAssessmentDocumentVersionId = dbo.CustomGetLatestDocumentVersionIdByDocumentCodeGroup (@ClientId, null, ''349, 1469'', ''22'')  
  End    
  
-- Only pull @LOFType is the assessment was not a ''DD'' assessment.  If no assessment existed, decided ''Adult'' or ''Child'' based on Age.  Adult = DLA, Child = CAFAS  
select @LOFType =   
  case when isnull(c.ClientInDDPopulation,''N'') = ''N'' then  
   case when isnull(c.AdultOrChild,'''') = '''' then  
    case when @Age >= 18 then ''A'' else ''C''  
    end else c.AdultOrChild  
   end  
  else null  
  end  
 from  
 Clients a  
 left join Documents b on a.ClientId = b.ClientId and b.CurrentDocumentVersionId = @LatestAssessmentDocumentVersionId  
 left join CustomHRMAssessments c on b.CurrentDocumentVersionId = c.DocumentVersionId  
  where   
   a.ClientId = @ClientId  
   and IsNull(a.RecordDeleted,''N'') <> ''Y''  
   and IsNull(b.RecordDeleted,''N'') <> ''Y''  
   and isnull(c.RecordDeleted,''N'') <> ''Y''  
  
return @LOFType  
  
End' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_DateTimeToString]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DateTimeToString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[csf_DateTimeToString](@inDate datetime) returns varchar(24) as
/********************************************************************************
-- Function: dbo.csf_DateTimeToString
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Converts a datetime into a user-friendly string format
--
-- Called by: Harbor note initialization stored procedures.
--
-- Updates:
-- Date              Author      Purpose
-- 04.18.2012		T. Remisoski	Created
*********************************************************************************/

begin

declare @retval varchar(24)

if @inDate is not null
	set @retval = case when DATEPART(MONTH, @inDate) < 10 then ''0'' else '''' end + CAST(DATEPART(MONTH, @inDate) as varchar)
		+ ''/'' + case when DATEPART(DAY, @inDate) < 10 then ''0'' else '''' end + CAST(DATEPART(DAY, @inDate) as varchar)
		+ ''/'' + CAST(DATEPART(year, @inDate) as varchar)
		+ '' '' + case when DATEPART(hour, @inDate) not in (0, 10, 11, 12, 22, 23) then ''0'' else '''' end + case when DATEPART(hour, @inDate) = 0 then ''12'' when DATEPART(hour, @inDate) > 12 then CAST(DATEPART(hour, @inDate) - 12 as varchar) else CAST(DATEPART(hour, @inDate) as varchar) end
		+ '':'' + case when DATEPART(minute, @inDate) < 10 then ''0'' else '''' end + CAST(DATEPART(minute, @inDate) as varchar)
		+ '' '' + case when DATEPART(hour, @inDate) < 12 then ''a.m.'' else ''p.m.'' end
		
return @retval

end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_GetDelimitedStringElement]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetDelimitedStringElement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[csf_GetDelimitedStringElement] (
	@InputString varchar(4000),
	@Delimiter varchar(100),
	@Position int
) returns varchar(4000) as
/*******************************************************************************        
**  Function: csf_GetDelimitedStringElement
**
**  Purpose: find and return the nth element from a delimited string.
**
**  Parameters:
**    @InputString varchar(4000) - String to be parsed.
**
**    @Delimiter varchar(100) - String that delimits fields.  Must be at least one char
**
**    @Position int - position of string element to return.
**
**  Returns: varchar(4000) - string element found or null if not found
**
**  Change History        
*******************************************************************************        
**  Date:  Author:    Description:        
**  --------  --------    ----------------------------------------------------        
**  20121015  TER         Created.  
*******************************************************************************/      

begin

-- IMPORTANT: End of string is considered a delimiter

declare @patt varchar(102), @readpos int, @prevpos int, @DelimitersFound int
declare @retval varchar(4000)

if (@InputString is null) or (@Delimiter is null) or (@Position is null) or (LEN(@InputString) = 0) or (LEN(@Delimiter) = 0) return null

if @Position = 0 return @InputString

set @patt = ''%'' + @Delimiter + ''%''

set @readpos = 1
set @DelimitersFound = 0

while (PATINDEX(@patt, SUBSTRING(@InputString, @readpos, 4000)) > 0) and (@DelimitersFound < @Position)
begin
	set @DelimitersFound = 	@DelimitersFound + 1
	set @prevpos = @readpos
	set @readpos = @readpos + PATINDEX(@patt, SUBSTRING(@InputString, @readpos, 4000)) + LEN(@Delimiter) - 1
	

end

if (@DelimitersFound = @Position)
begin
	if @readpos - LEN(@Delimiter)- @prevpos <= 1
		return ''''
		
	set @retval = SUBSTRING(@InputString, @prevpos, @readpos - LEN(@Delimiter) - @prevpos)
	return @retval
end
-- IMPORTANT: End of string is considered a delimiter
else if (@readpos <= LEN(@InputString)) and (@DelimitersFound = (@Position - 1))
	return SUBSTRING(@InputString, @readpos, 4000)
else if (@DelimitersFound = (@Position - 1))
	return ''''

return null

end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_FASStripSpecialChars]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_FASStripSpecialChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_FASStripSpecialChars](@inputString varchar(max)) returns varchar(max) as
begin
   return replace(@inputString, ''"'', '''')
end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnConvertXMLToTable]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnConvertXMLToTable]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[fnConvertXMLToTable](
@x XML
)
RETURNS TABLE
AS RETURN
/*----------------------------------------------------------------------
This INLINE TVF uses a recursive CTE that processes each element and
attribute of the XML document passed in.
----------------------------------------------------------------------*/
WITH cte AS 
	(
		SELECT
			1 AS lvl
			, x.value(''local-name(.)'',''VARCHAR(MAX)'') AS Name
			, CAST(NULL AS VARCHAR(MAX)) AS ParentName
			, CAST(1 AS INT) AS ParentPosition
			, CAST(''Element'' AS VARCHAR(20)) AS NodeType
			, x.value(''local-name(.)'',''VARCHAR(MAX)'') AS FullPath
			, x.value(''local-name(.)'',''VARCHAR(MAX)'')
				+ ''[''
				+ CAST(ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS VARCHAR)
				+ '']'' AS XPath
			, ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS Position
			, x.value(''local-name(.)'',''VARCHAR(MAX)'') AS Tree
			, x.value(''text()[1]'',''VARCHAR(MAX)'') AS Value
			, x.query(''.'') AS this
			, x.query(''*'') AS t
			, CAST(CAST(1 AS VARBINARY(4)) AS VARBINARY(MAX)) AS Sort
			, CAST(1 AS INT) AS ID
		FROM @x.nodes(''/*'') a(x)
		UNION ALL
	--
	-- Start recursion. Retrieve each child element of the parent node
	--
		SELECT
			p.lvl + 1 AS lvl
			, c.value(''local-name(.)'',''VARCHAR(MAX)'') AS Name
			, CAST(p.Name AS VARCHAR(MAX)) AS ParentName
			, CAST(p.position AS INT) AS ParentPosition
			, CAST(''Element'' AS VARCHAR(20)) AS NodeType
			, CAST(p.FullPath + ''/'' + c.value(''local-name(.)'',''VARCHAR(MAX)'') AS VARCHAR(MAX)) AS FullPath
			, CAST( p.XPath + ''/'' + c.value(''local-name(.)'',''VARCHAR(MAX)'')
				+ ''['' + CAST(ROW_NUMBER() OVER(PARTITION BY c.value(''local-name(.)'',''VARCHAR(MAX)'') ORDER BY (SELECT 1)) AS VARCHAR )
				+ '']'' AS VARCHAR(MAX)
				) AS XPath
			, ROW_NUMBER() OVER(PARTITION BY c.value(''local-name(.)'',''VARCHAR(MAX)'') ORDER BY (SELECT 1)) AS Position
			, CAST( SPACE(2 * p.lvl - 1) + ''|'' + REPLICATE(''-'', 1)
				+ c.value(''local-name(.)'',''VARCHAR(MAX)'') AS VARCHAR(MAX)
				) AS Tree
			, CAST( c.value(''text()[1]'',''VARCHAR(MAX)'') AS VARCHAR(MAX) ) AS Value
			, c.query(''.'') AS this
			, c.query(''*'') AS t
			, CAST(p.Sort + CAST( (lvl + 1) * 1024 + (ROW_NUMBER() OVER(ORDER BY (SELECT 1)) * 2) AS VARBINARY(4)
				) AS VARBINARY(MAX) ) AS Sort
			, CAST( (lvl + 1) * 1024 + (ROW_NUMBER() OVER(ORDER BY (SELECT 1)) * 2) AS INT ) 
		FROM cte p
		CROSS APPLY p.t.nodes(''*'') b(c)
	)

, cte2 AS 
	(
		SELECT 
			lvl AS Depth
			, Name AS NodeName
			, ParentName
			, ParentPosition
			, NodeType
			, FullPath
			, XPath
			, Position
			, Tree AS TreeView
			, Value
			, this AS XMLData
			, Sort
			, ID
		FROM cte 
		UNION ALL
	--
	-- Attributes do not need recursive calls. So add the attributes to the query output at the end.
	--
		SELECT 
			p.lvl
			, x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, p.Name
			, p.Position
			, CAST(''Attribute'' AS VARCHAR(20))
			, p.FullPath + ''/@'' + x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, p.XPath + ''/@'' + x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, 1
			, SPACE(2 * p.lvl - 1) + ''|'' + REPLICATE(''-'', 1) + ''@'' + x.value(''local-name(.)'',''VARCHAR(MAX)'')
			, x.value(''.'',''VARCHAR(MAX)'')
			, NULL
			, p.Sort
			, p.ID + 1
		FROM cte p
		CROSS APPLY this.nodes(''/*/@*'') a(x) 
	)


--
-- Final Select
--
SELECT 
	ROW_NUMBER() OVER(ORDER BY Sort, ID) AS ID
	, ParentName
	, ParentPosition
	, Depth
	, NodeName
	, Position
	, NodeType
	, FullPath
	, XPath
	, TreeView
	, Value
	, XmlData 
FROM cte2' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[DecimalToText]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DecimalToText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[DecimalToText] (@Amount decimal(12,4) )
returns varchar(1000) as 
begin 
  declare @AmountStr varchar(30)
  declare @DecimalPlace int
  declare @Number bigint
  declare @Cents char(6)

  set @AmountStr = convert(varchar(30), @Amount)
  set @DecimalPlace = CharIndex(''.'', @AmountStr)

  if @DecimalPlace > 0
  begin
    set @Number = convert(bigint, left(@AmountStr, @DecimalPlace - 1))
    set @Cents = left(substring(@AmountStr, @DecimalPlace + 1, len(@AmountStr) - @DecimalPlace) + ''00'', 2) + ''/100''
  end
  else
  begin 
    set @Number = convert(bigint, @AmountStr)
    set @Cents = ''00/100''
  end
  
  return dbo.NumberToText(@Number) + case when @Cents <> ''00/100'' then '' and '' + @Cents else '''' end--+ '' Dollar'' + case when @Amount = 1 then '''' else ''s'' end
  
end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[cf_Conv_Resolve_GlobalCode]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_Conv_Resolve_GlobalCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[cf_Conv_Resolve_GlobalCode] (
@category  char(20),
@code   char(10)) 
returns int
as
begin
  declare @return int

  select @return = GlobalCodeId
    from Cstm_Conv_Map_GlobalCodes
   where category = @category
     and code = @code
  
  if @@rowcount = 0
    set @return = -1

  return @return
end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[CheckNewClient]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckNewClient]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*********************************************************************/                
/*Function: dbo.CheckNewClient */                
/* Copyright: 2007 Streamline HealthCare */                
/* Creation Date:  12/14/2006                                    */                
/*                                                                   */                
/* Purpose: it will get Insurer Name            */               
/*                                                                   */              
/* Output Parameters:        bit(Exist/Not Exist)                       */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*  Date          Author      Purpose                                    */                
/* 12/14/2006   Rajesh Kumar    Created                                    */                
CREATE FUNCTION [dbo].[CheckNewClient](@StaffId int, @MachineID varchar(50))  
RETURNS bit AS    
BEGIN   
--Declare @NewClient as bit  

	-- Condition added by Balvinder on 31st-Aug-07 if no client exists for Selected StaffId
  if not exists(Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId)
	return 1
--set @InsurerName=(SELECT InsurerName FROM Insurers WHERE (InsurerId = @InsurerId))   
--My Primary Clients  
 if exists(Select @StaffId from Clients where PrimaryClinicianId=@StaffId and  (RecordDeleted =''N'' or RecordDeleted is Null)  
   and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
 return 1    
  
 --client seen in last 3 months  
 /*if exists(select @StaffID  from Clients where clientid in (select ClientId from Services where DateOfService>=DATEADD(month, -3, getdate()) and ClinicianId=@StaffID  and   
  (RecordDeleted =''N'' or RecordDeleted is Null)) and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
*/  
 --Clients where the user is the sender or receiver of a message (not deleted).  
 if exists(Select @StaffID  from Messages where ( FromStaffID=@StaffID or ToStaffID=@StaffID )  and clientid is not null  
  and (RecordDeleted =''N'' or RecordDeleted is Null) and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
 --Clients  where user is the staff on alert  
 if exists(Select  @StaffID from Alerts where ToStaffID=@StaffID  and clientid is not null  
  and (RecordDeleted =''N'' or RecordDeleted is Null) and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
 --Staff is an Author of ToDo or InProgress  Document.  
 if exists(select @StaffID from documents where status in(20,21) and authorid=@StaffID and (RecordDeleted =''N'' or RecordDeleted is Null)  
   and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
  
 --Staff is a signer but has  not signed yet.  
 if exists(select @StaffID  from documents doc join DocumentSignatures ds  on ds.documentid = doc.Documentid  
  where ds.staffid = @StaffID  and (ds.RecordDeleted =''N'' or ds.RecordDeleted is Null) and ds.SignatureDate is null  
  and doc.ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
  
 
 return 0  
  
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[FunctionReturnTotalClientsForGroupService]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FunctionReturnTotalClientsForGroupService]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[FunctionReturnTotalClientsForGroupService]          
  ( @GroupServiceId int )   
        
/******************************************************************************                                    
**File: GroupScheduled List Page                                    
** Name:                   
**Desc:Used to list all groups that are Sheduled                    
**                                    
** Return values:                                    
**                                     
**  Called by:Groups.cs                           
**                                                  
**  Parameters:                                    
**  Input       Output                                    
**  @GroupId INT                     
**                              
**                                
**                              
**  Auth:  Pradeep                            
**  Date:  17 Dec 2009                                   
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:         Author:       Description:             
**  17 Dec 2009       Pradeep          Created                               
**  --------  --------    ----------------------------------------------------                                    
                               
*******************************************************************************/                                                                                                                                       
          
RETURNS int          
AS          
BEGIN   
         
 RETURN (          
 select count(distinct ClientId) from services          
 inner join globalcodes on  services.[Status]=globalcodes.GlobalCodeId          
 where [services].GroupServiceId = @GroupServiceId          
 and (globalcodes.GlobalCodeId<>72 and globalcodes.GlobalCodeId<>73 and globalcodes.GlobalCodeId<>76)      
 and ISNULL(services.RecordDeleted,''N'')=''N''      
 and ISNULL(globalcodes.RecordDeleted,''N'')=''N''      
 and globalcodes.Active=''Y''      
        
           
 )  
          
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_GetGlobalCodeNameById]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetGlobalCodeNameById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[csf_GetGlobalCodeNameById] (@GlobalCodeId int) returns varchar(250)
/****************************************************************************************/
/* Simple function to get a global code name from a global code id.  Handy for use in	*/
/* reports.  Eliminates the need for several LEFT JOINs to the global codes table.		*/
/*																						*/
/* Warning: may have some performance problems when using with large number of rows		*/
/* because this proc will be called for each row.										*/
/*																						*/
/* Author: Tom Remisoski																*/
/* Date: 7/30/2008																		*/
/****************************************************************************************/
as
begin

declare @retval varchar(250)

select @retval = CodeName
from dbo.GlobalCodes
where GlobalCodeId = @GlobalCodeId

return @retval

end
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_SCClientMedicationC2C5Drugs]    Script Date: 04/22/2013 05:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_SCClientMedicationC2C5Drugs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[csf_SCClientMedicationC2C5Drugs] (
   @MedicationId int
)
returns CHAR(1) as
/*********************************************************************/
/* Stored Procedure: dbo.[[csp_SCClientMedicationC2C5Drugs]          */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    9/Feb/08                                         */
/*                                                                   */
/* Purpose:  To retrieve Category of drug   */
/*                                                                   */
/* Input Parameters: none        @MedicationId */
/*                                                                   */
/* Output Parameters:   None                           */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author       Purpose                                    */
/*  2012.02.05 T.Remisoski Created.                                  */
/*********************************************************************/

begin

	declare @DEACode char(1)
	--set @DEACode = ''0''

	-- if an MDDrugs record exists for the clinical formulation, return the DEACode
	select top 1 @DEACode = d.DEACode
	from MDMedications as m
	join MDDrugs as d on d.ClinicalFormulationId = m.ClinicalFormulationId
	where m.MedicationId = @MedicationId
	and isnull(m.RecordDeleted, ''N'') <>''Y''
	and isnull(d.RecordDeleted, ''N'') <>''Y''
	
	if @DEACode is null
	begin
		-- if no MDDrugs record exists for the formulation, look at all formulations for alternative meds (generics, other brand names)
		declare @MedicationNameId int

		select @MedicationNameId = MedicationNameId
		from MDMedications
		where MedicationId = @MedicationId

		-- logic copied from ssp_MMGetAlternativeMedicationNames
		declare @STATUSCURRENT int, @GENERICTYPE int

		select @STATUSCURRENT = 4881, @GENERICTYPE = 2

		declare @AlternateMeds table (
			MedicationNameId int not null primary key,
			MedicationType int,
			MedicationName varchar(100)
		)


		-- get all medications for clinical formulations under the specific medication name
		insert into @AlternateMeds (MedicationNameId, MedicationType, MedicationName)
		select distinct n.MedicationNameId, n.MedicationType, n.MedicationName
		from MDMedications as m
		join MDMedications as m2 on m2.ClinicalFormulationId = m.ClinicalFormulationId
		join MDMedicationNames as n on n.MedicationNameId = m2.MedicationNameId
		where m.MedicationNameId = @MedicationNameId
		--and n.MedicationNameId <> @MedicationNameId
		and m.Status = @STATUSCURRENT
		and m2.Status = @STATUSCURRENT
		and n.Status = @STATUSCURRENT
		and isnull(m.RecordDeleted, ''N'') <> ''Y''
		and isnull(m2.RecordDeleted, ''N'') <> ''Y''
		and isnull(n.RecordDeleted, ''N'') <> ''Y''

		-- find other meds based on any generics in the result set
		insert into @AlternateMeds (MedicationNameId, MedicationType, MedicationName)
		select distinct n.MedicationNameId, n.MedicationType, n.MedicationName
		from MDMedications as m
		join MDMedications as m2 on m2.ClinicalFormulationId = m.ClinicalFormulationId
		join MDMedicationNames as n on n.MedicationNameId = m2.MedicationNameId
		join @AlternateMeds as r on r.MedicationNameId = m.MedicationNameId
		where r.MedicationType = @GENERICTYPE
		--and n.MedicationNameId <> @MedicationNameId
		and m.Status = @STATUSCURRENT
		and m2.Status = @STATUSCURRENT
		and n.Status = @STATUSCURRENT
		and isnull(m.RecordDeleted, ''N'') <> ''Y''
		and isnull(m2.RecordDeleted, ''N'') <> ''Y''
		and isnull(n.RecordDeleted, ''N'') <> ''Y''
		and not exists (
			select * from @AlternateMeds as r2 where r2.MedicationNameId = n.MedicationNameId
		)

		select top 1 @DEACode = d.DEACode
		from MDDrugs as d
		join MDMedications as m on m.ClinicalFormulationId = d.ClinicalFormulationId
		join @AlternateMeds as am on am.MedicationNameId = m.MedicationNameId
		where isnull(m.RecordDeleted, ''N'') <>''Y''
		and isnull(d.RecordDeleted, ''N'') <>''Y''
		-- make sure deacode 2 rises to the top, followed by other non-zero codes
		order by case when d.DEACode <> ''0'' then 0 else 1 end, d.DEACode desc

	end

	return @DEACode
	
end

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[csf_MMStrengthAllowsAutoCalculation]    Script Date: 04/22/2013 05:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_MMStrengthAllowsAutoCalculation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_MMStrengthAllowsAutoCalculation]    
(
	@MedicationId int
) returns char(1)
as    
begin

	if exists (    
	   select *    
	   from MDMedications as m    
	   join MDClinicalFormulations as cf on cf.ClinicalFormulationId = m.ClinicalFormulationId    
	   join MDDosageFormCodes as dfc on dfc.DosageFormCodeId = cf.DosageFormCodeId    
	   where m.MedicationId = @MedicationId    
	   and dfc.DosageFormCode in (    
		''1A'', ''1E'', ''1F'', ''3Q'', ''4A'', ''4Q'', ''4R'', ''4S'', ''4T'', ''4U'', ''7O'', ''7P'', ''7Q'', ''CA'', ''CB'', ''CC'',    
		''CD'', ''CE'', ''CF'', ''CG'', ''CH'', ''CI'', ''CJ'', ''CK'', ''CL'', ''CM'', ''CN'', ''CO'', ''CP'', ''CQ'',    
		''CR'', ''CS'', ''CT'', ''CX'', ''EA'', ''EX'', ''TA'', ''TB'', ''TC'', ''TE'', ''TF'', ''TH'', ''TI'', ''TJ'',    
		''TL'', ''TM'', ''TN'', ''TO'', ''TP'', ''TQ'', ''TR'', ''TS'', ''TU'', ''TV'', ''TX'', ''TY'', ''TZ'', ''UA'',    
		''UB'', ''UC'', ''UD'', ''UE'', ''UF'', ''UG'', ''UH'', ''UI'', ''UJ'', ''UK'', ''UL'', ''UM'', ''UO'', ''UP'',    
		''UQ'', ''UR'', ''UT'', ''ZJ'', ''ZK'', ''ZN'', ''ZO''    
	   )    
	)
	begin
	   return ''Y''
	end
    
return ''N''


end
' 
END
GO
