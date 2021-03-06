/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomAssessments]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomAssessments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RequiredCustomAssessments]          
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
          
Select ''CustomAssessments'', ''AssessmentType''         
Union          
Select ''CustomAssessments'', ''Population''        
Union          
Select ''CustomAssessments'', ''TeamGeneral''        
Union          
Select ''CustomAssessments'', ''PresentingProblem''        
Union        
Select ''CustomAssessments'', ''PrimaryCarePhysician''        
Union          
Select ''CustomAssessments'', ''CurrentHealth''        
Union          
Select ''CustomAssessments'', ''MedicalIssues''        
Union          
Select ''CustomAssessments'', ''FamilyMedicalHistory''        
Union          
Select ''CustomAssessments'', ''CurrentMedications''        
          
Union          
Select ''CustomAssessments'', ''ExistingAdvanceDirective''        
Union          
Select ''CustomAssessments'', ''CopyAdvanceDirective''        
Union          
Select ''CustomAssessments'', ''MoreInformationAdvanceDirective''        
Union          
Select ''CustomAssessments'', ''ChangeEatinghabits''        
Union          
Select ''CustomAssessments'', ''Eatinghabits''         
Union          
Select ''CustomAssessments'', ''ChangeSleepingHabits''        
Union          
Select ''CustomAssessments'', ''SleepingHabits''          
Union          
Select ''CustomAssessments'', ''ClientStrengths''        
Union          
Select ''CustomAssessments'', ''SocialHistory''        
Union          
Select ''CustomAssessments'', ''Relationships''        
Union          
Select ''CustomAssessments'', ''MentalHealthFamilyHistory''        
Union          
Select ''CustomAssessments'', ''LeisureIssues''        
Union          
Select ''CustomAssessments'', ''FinancialIssues''        
Union          
Select ''CustomAssessments'', ''Education''        
Union          
Select ''CustomAssessments'', ''Employment''        
Union          
Select ''CustomAssessments'', ''Ethnicity''        
Union          
Select ''CustomAssessments'', ''LivingArrangement''        
Union          
Select ''CustomAssessments'', ''Abuse''          
Union          
Select ''CustomAssessments'', ''TxHistoryDetail''        
Union          
Select ''CustomAssessments'', ''TxHistoryHopitalization''        
Union          
Select ''CustomAssessments'', ''DeletedBy''        
Union          
Select ''CustomAssessments'', ''IncreasedSupport''        
Union          
Select ''CustomAssessments'', ''NaturalSupportSufficiency''        
Union          
Select ''CustomAssessments'', ''ClinicalSummary''        
Union          
Select ''CustomAssessments'', ''SummaryAppropriate''        
Union          
Select ''CustomAssessments'', ''SummaryAppropriateText''        
Union          
Select ''CustomAssessments'', ''SummaryReferrals''        
Union          
Select ''CustomAssessments'', ''SummaryReferralsText''        
Union        
Select ''CustomAssessments'', ''CrisisPlanClientDesire''        
Union          
Select ''CustomAssessments'', ''CrisisPlan''        
         
if @@error <> 0 goto error      
          
return          
          
error:          
raiserror 50000 ''csp_RequiredCustomAssessments failed.  Contact your system administrator.''
' 
END
GO
