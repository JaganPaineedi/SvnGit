
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientCCDData]    Script Date: 06/09/2015 02:33:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientCCDData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientCCDData]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientCCDData]    Script Date: 06/09/2015 02:33:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientCCDData]      
	 @XMLData XML,
	 @listAllergy VARCHAR(MAX)  OUTPUT,
	 @listMedication VARCHAR(MAX)  OUTPUT,
	 @listProblems VARCHAR(MAX)  OUTPUT
AS     
/*********************************************************************/     
/* Stored Procedure: dbo.ssp_SCGetClientCCDData            */     
/* Creation Date:    24/Nov/2014                  */     
/* Purpose:  Used to update ClientCCD Allergy, Medication and Problem from XML data                */     
/*    Exec ssp_SCGetClientCCDData                                              */    
/* Input Parameters:                           */     
/*  Date		Author			Purpose              */     
/* 24/Nov/2014  Gautam			Created           Task #57,Certification 2014   */    
/* 26/Nov/2014	Pradeep			Modified		  Get Allergies,Medications and Problems as an output parameters*/                    
  /*********************************************************************/     
  BEGIN     
    BEGIN TRY  	  
	DEClare @XMLTempdata varchar(max)           
	  
	Select @XMLTempdata = REPLACE(cast(@XMLData as varchar(max)),'xmlns:voc="urn:hl7-org:v3/voc" xmlns:sdtc="urn:hl7-org:sdtc" xmlns="urn:hl7-org:v3"','')    
	  
	Select @XMLData =cast (@XMLTempdata as xml)    
    
      
	Create table #AllergyData    
	(AllergyDesc varchar(max))    
	          
	Create table #MedicationData    
	(MedicationDesc varchar(max))    
	   
	Create table #ProblemData    
	(ProblemDesc varchar(max))    
       
	Insert Into #AllergyData(AllergyDesc)    
	SELECT  LTRIM(RTRIM(m.c.value('./td[1]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[2]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[3]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[4]','varchar(MAX)')))     
	FROM @XMLData.nodes('ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr') AS m(c)    
	WHERE  m.c.exist('../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.6.1"]') = 1    
      
	Insert Into #MedicationData(MedicationDesc)    
	SELECT  LTRIM(RTRIM(m.c.value('./td[1]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[2]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[3]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[4]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[5]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[6]','varchar(MAX)')))    
	FROM @XMLData.nodes('ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr') AS m(c)    
	WHERE  m.c.exist('../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.1.1"]') = 1    
      
      
	Insert Into #ProblemData(ProblemDesc)    
	SELECT  LTRIM(RTRIM(m.c.value('./td[1]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[2]','varchar(MAX)'))) +'-' +    
	LTRIM(RTRIM(m.c.value('./td[3]','varchar(MAX)')))     
	FROM @XMLData.nodes('ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr') AS m(c)    
	WHERE  m.c.exist('../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.5.1"]') = 1    
	  
	  
	SELECT @listAllergy = COALESCE(@listAllergy + '<br>' ,'') + AllergyDesc    
	FROM #AllergyData    
	  
	SELECT @listMedication = COALESCE(@listMedication+'<br>' ,'') + MedicationDesc    
	FROM #MedicationData    
	  
	SELECT @listProblems = COALESCE(@listProblems+'<br>' ,'') + ProblemDesc    
	FROM #ProblemData    
    
    END TRY     
    
    BEGIN catch     
          DECLARE @Error VARCHAR(max)     
    
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'     
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE())     
                      + '*****'     
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),     
                      'ssp_SCGetClientCCDData'     
                      )     
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE())     
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())     
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE())     
    
          RAISERROR ( @Error,     
                      -- Message text.                                                                                     
                      16,     
                      -- Severity.                                                                                     
                      1     
          -- State.                                                                                     
          );     
      END catch     
  END     
GO

