/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomPsychiatricEvaluations]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomPsychiatricEvaluations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomPsychiatricEvaluations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomPsychiatricEvaluations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       PROCEDURE [dbo].[csp_RequiredCustomPsychiatricEvaluations]    
@documentCodeId Int    
as    
    
  --This required returns two fields      
--Field1 = TableName      
--Field2 = ColumnName      
    
      
Insert into #RequiredFieldReturnTable      
(    
TableName,      
ColumnName     
)      
  
    
    
    
SELECT ''CustomPsychiatricEvaluations'' , ''IdentifyingData''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''ChiefComplaint''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''HistoryofPresentIllness''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''PastPsychiatricHistory''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''MedicalHistory''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''SocialHistory''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''MentalStatusExam''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''Prognosis''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''OtherTherapyInterventionsPlanned1''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''MedicationCompliance''  
  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''OtherIndividuals''  
UNION    
SELECT ''CustomPsychiatricEvaluations'' , ''PlanReviewFrequency''  
  
  
--Diagnosis Validation    
--exec csp_validateDiagnosis @documentId, @documentCodeId    
--if @@error <> 0 goto error    
    
    
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomPsychiatricEvaluations  failed.  Contact your system administrator.''
' 
END
GO
