/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomTransferBroker]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomTransferBroker]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomTransferBroker]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomTransferBroker]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE      PROCEDURE [dbo].[csp_RequiredCustomTransferBroker]    
  
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
    
SELECT ''CustomTransferBroker'' , ''DocumentType''  
UNION    
SELECT ''CustomTransferBroker'' , ''DateOfRequest''  
UNION    
SELECT ''CustomTransferBroker'' , ''CurrentProgram''  
UNION    
SELECT ''CustomTransferBroker'' , ''ProgramRequested''  
UNION    
  
SELECT ''CustomTransferBroker'' , ''Rationale''  
UNION    
SELECT ''CustomTransferBroker'' , ''Findings''  
  
    
    
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomTransferBroker   failed.  Contact your system administrator.''
' 
END
GO
