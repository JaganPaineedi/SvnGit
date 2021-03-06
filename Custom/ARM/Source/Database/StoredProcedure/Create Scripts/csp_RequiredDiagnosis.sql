/****** Object:  StoredProcedure [dbo].[csp_RequiredDiagnosis]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredDiagnosis]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        PROCEDURE [dbo].[csp_RequiredDiagnosis]    
@documentCodeId int    
as    
    
  
--This required returns two fields      
--Field1 = TableName      
--Field2 = ColumnName      
    
      
Insert into #RequiredFieldReturnTable      
(    
TableName,      
ColumnName     
)      
   
Select ''DiagnosesIandII'', ''DSMCode''  
   UNION    
 Select ''DiagnosesIandII'', ''DSMCode''  
 Union    
  Select ''DiagnosesIandII'', ''DSMCode''  
 UNION    
 Select ''DiagnosesIandII'', ''DSMCode''  
 UNION    
 Select ''DiagnosesV'', ''AxisV''  
     
  
if @@error <> 0 goto error  
return    
    
error:    
raiserror 50000 ''csp_RequiredDiagnosis  failed.  Contact your system administrator.''
' 
END
GO
