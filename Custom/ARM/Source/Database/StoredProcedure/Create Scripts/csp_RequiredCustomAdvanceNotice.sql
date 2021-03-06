/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomAdvanceNotice]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomAdvanceNotice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomAdvanceNotice]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomAdvanceNotice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[csp_RequiredCustomAdvanceNotice]    
  
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
    
Select ''CustomAdvanceNotice'', ''DateOfNotice''  
Union    
Select ''CustomAdvanceNotice'', ''PrimaryStaffId''  
Union    
Select ''CustomAdvanceNotice'', ''StaffPosition''  
Union    
Select ''CustomAdvanceNotice'', ''Director''  
Union    
Select ''CustomAdvanceNotice'', ''ReasonForNotice''  
Union    
Select ''CustomAdvanceNotice'', ''DischargeFromAgency''  
    
Union    
Select ''CustomAdvanceNotice'', ''ServicesDenied''  
Union    
Select ''CustomAdvanceNotice'', ''ServicesDeniedReason''  
Union    
Select ''CustomAdvanceNotice'', ''NoticeEffectiveDate''  
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomAdvanceNotice  failed.  Contact your system administrator.''
' 
END
GO
