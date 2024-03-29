/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomMedicationAdministrations]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomMedicationAdministrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomMedicationAdministrations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomMedicationAdministrations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     PROCEDURE [dbo].[csp_RequiredCustomMedicationAdministrations]    
   
@documentCodeId Int    
as    
    
---execute csp_validateFullMentalStatus @documentId, @documentCodeId    
    
  
   
--This required returns two fields      
--Field1 = TableName      
--Field2 = ColumnName      
    
      
Insert into #RequiredFieldReturnTable      
(    
TableName,      
ColumnName     
)      
    
Select ''CustomMedicationAdministrations'', ''Intervention''  
Union    
Select ''CustomMedicationAdministrations'', ''ResponseToIntervention''  
  
  
  
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomMedicationAdministrations  failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
