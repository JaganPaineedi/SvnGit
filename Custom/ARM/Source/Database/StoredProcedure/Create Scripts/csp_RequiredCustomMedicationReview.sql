/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomMedicationReview]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomMedicationReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomMedicationReview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomMedicationReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       PROCEDURE [dbo].[csp_RequiredCustomMedicationReview]    
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
    
    
    
SELECT ''CustomMedicationReviews'' , ''Subjective''  
UNION    
SELECT ''CustomMedicationReviews'' , ''Objective''  
UNION    
SELECT ''CustomMedicationReviews'' , ''Assessment''  
UNION    
SELECT ''CustomMedicationReviews'' , ''PlanDetail''  
UNION    
SELECT ''CustomMedicationReviews'' , ''Aims''  
UNION    
SELECT ''CustomMedicationReviews'' , ''SideEffects''  
UNION    
SELECT ''CustomMedicationReviews'' , ''Changes''  
UNION    
SELECT ''CustomMedicationReviews'' , ''Efficacy''  
UNION    
SELECT ''CustomMedicationReviews'' , ''MedicationConsentGiven''  
UNION    
SELECT ''CustomMedicationReviews'' , ''UnderstoodEducation''  
UNION    
SELECT ''CustomMedicationReviews'' , ''GivenToCareProvide''  
UNION    
SELECT ''CustomMedicationReviews'' , ''NextSession''  
  
  
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomMedicationReview  failed.  Contact your system administrator.''
' 
END
GO
