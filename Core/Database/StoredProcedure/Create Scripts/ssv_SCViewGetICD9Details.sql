
/****** Object:  View [dbo].[ssv_SCViewGetICD9Details]    Script Date: 07/08/2015 20:08:56 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ssv_SCViewGetICD9Details]'))
DROP VIEW [dbo].[ssv_SCViewGetICD9Details]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE view [dbo].[ssv_SCViewGetICD9Details] as  
/********************************************************************************  
-- View: dbo.ssv_SCViewGetICD9Details    
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: returns ICD9 tables data from DiagnosisDSMDescriptions and DiagnosisICDCodes tables 
--           require for ssp_SCSearchICD10CodesByDescription 
-- Updates:                                                         
-- Date				Author      Purpose  
-- 08/July/2015		Gautam      Created.        
*********************************************************************************/  
  Select DSMCode as 'ICDCode', DSMDescription as 'ICDDescription'
  From DiagnosisDSMDescriptions  
  UNION ALL
  Select ICDCode, ICDDescription
  From DiagnosisICDCodes             

     
GO


