/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomTreatmentPlan]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomTreatmentPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomTreatmentPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE          PROCEDURE [dbo].[csp_RequiredCustomTreatmentPlan]    
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
    
SELECT ''TPGeneral'', ''PlanOrAddendum''  
UNION    
SELECT ''TPGeneral'', ''Participants''  
UNION    
SELECT ''TPGeneral'', ''HopesAndDreams''  
UNION    
SELECT ''TPGeneral'', ''Barriers''  
UNION    
SELECT ''TPGeneral'', ''PurposeOfAddendum''  
   
UNION    
SELECT ''TPGeneral'', ''StrengthsAndPreferences''  
UNION    
SELECT ''TPGeneral'', ''AreasOfNeed''  
UNION    
SELECT ''TPGeneral'', ''DeferredTreatmentIssues''  
UNION    
  
SELECT ''TPGeneral'', ''DischargeCriteria''  
UNION    
SELECT ''TPGeneral'', ''PeriodicReviewDueDate''  
UNION    
SELECT ''TPGeneral'', ''PlanDeliveryMethod''  
UNION    
SELECT ''TPGeneral'', ''ClientAcceptedPlan''  
UNION    
SELECT ''TPGeneral'', ''CrisisPlan''  
UNION    
SELECT ''TPGeneral'', ''PlanDeliveredDate''  
UNION    
SELECT ''TPGeneral'', ''NotificationMessage''  
  
    
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomTreatmentPlan  failed.  Contact your system administrator.''
' 
END
GO
