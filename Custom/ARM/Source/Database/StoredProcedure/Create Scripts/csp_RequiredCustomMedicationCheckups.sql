/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomMedicationCheckups]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomMedicationCheckups]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomMedicationCheckups]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomMedicationCheckups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        PROCEDURE [dbo].[csp_RequiredCustomMedicationCheckups]    
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
    
  
SELECT ''CustomMedicationCheckups'', ''ChiefComplaint''  
UNION    
SELECT ''CustomMedicationCheckups'', ''PastHistory''  
UNION    
SELECT ''CustomMedicationCheckups'', ''Summary''  
UNION    
SELECT ''CustomMedicationCheckups'', ''PlanOtherText''  
UNION    
  
SELECT ''CustomMedicationCheckups'', ''MedicationReviewGiven''  
    
    
UNION    
SELECT ''CustomMedicationCheckups'', ''MedicationReviewDetail''  
    
UNION    
SELECT ''CustomMedicationCheckups'', ''MuscleOtherText''  
    
UNION    
SELECT ''CustomMedicationCheckups'', ''GaitOtherText''  
    
    
UNION    
SELECT ''CustomMedicationCheckups'', ''SpeechOtherText''  
    
UNION    
SELECT ''CustomMedicationCheckups'', ''PainOtherText''  
UNION    
SELECT ''CustomMedicationCheckups'', ''ThoughtProcessOtherText''  
    
    
UNION    
SELECT ''CustomMedicationCheckups'', ''AssociationsOtherText''  
    
UNION    
SELECT ''CustomMedicationCheckups'', ''JudgementOtherText''  
    
UNION    
SELECT ''CustomMedicationCheckups'', ''AbnormalThoughtsOtherText''  
UNION    
SELECT ''CustomMedicationCheckups'', ''FundOfKnowledgeText''  
UNION    
SELECT ''CustomMedicationCheckups'', ''RRMemoryOtherText''  
UNION    
SELECT ''CustomMedicationCheckups'', ''AttentionOtherText''  
UNION    
SELECT ''CustomMedicationCheckups'', ''LanguageOtherText''  
UNION    
SELECT ''CustomMedicationCheckups'', ''MoodAffectOtherText''  
UNION    
SELECT ''CustomMedicationCheckups'', ''SleepOtherText''  
  
UNION    
SELECT ''CustomMedicationCheckups'', ''AppetiteOtherText''  
    
    
UNION     
SELECT ''CustomMedicationCheckups'', ''MuscleNormal''  
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomMedicationCheckups  failed.  Contact your system administrator.''
' 
END
GO
