/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomAdequateNotice]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomAdequateNotice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomAdequateNotice]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomAdequateNotice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     PROCEDURE [dbo].[csp_RequiredCustomAdequateNotice]    
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
  
Select ''CustomAdequateNotice'', ''DateOfNotice''  
Union    
Select ''CustomAdequateNotice'', ''PrimaryStaffId''  
Union    
Select ''CustomAdequateNotice'', ''StaffPosition''  
Union    
Select ''CustomAdequateNotice'', ''Director''  
Union    
Select ''CustomAdequateNotice'', ''ReasonForNotice''  
Union    
Select ''CustomAdequateNotice'', ''DischargeFromAgency''  
   
Union    
Select ''CustomAdequateNotice'', ''PersonCenteredPlan''  
  Union    
Select ''CustomAdequateNotice'', ''ServiceDenied''  
 Union    
Select ''CustomAdequateNotice'', ''ServiceDeniedReason''  
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomAdequateNotice  failed.  Contact your system administrator.''
' 
END
GO
