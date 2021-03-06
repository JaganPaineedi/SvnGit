/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomDischarges]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomDischarges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE      PROCEDURE [dbo].[csp_RequiredCustomDischarges]    
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
    
Select ''CustomDischarges'', ''AdmissionDate''  
Union    
Select ''CustomDischarges'', ''LastDateOfService''  
Union    
Select ''CustomDischarges'', ''PresentingProblem''  
Union    
Select ''CustomDischarges'', ''DischargeReason''  
Union    
Select ''CustomDischarges'', ''DischargeDate''  
Union    
Select ''CustomDischarges'', ''DischargeType''  
Union    
Select ''CustomDischarges'', ''ProgressSummary''  
Union    
Select ''CustomDischarges'', ''ServicesSummary''  
  
      
Union    
Select ''CustomDischarges'', ''MedicationInformation''  
Union    
Select ''CustomDischarges'', ''NaturalSupports''  
Union    
Select ''CustomDischarges'', ''ClientFeedback''  
Union    
Select ''CustomDischarges'', ''TreatmentProviders''  
    
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomDischarges.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
