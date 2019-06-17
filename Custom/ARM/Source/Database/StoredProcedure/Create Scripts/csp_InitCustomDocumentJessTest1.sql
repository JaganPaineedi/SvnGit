/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentJessTest1]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentJessTest1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentJessTest1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentJessTest1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomDocumentJessTest1]            
(                                
 @ClientID int,          
 @StaffID int,        
 @CustomParameters xml                                
)                                                        
As                                                          
                                                                                                                                                     
                              
Select TOP 1 ''CustomDocumentJessTest1'' AS TableName, -1 as ''DocumentVersionId'',                        
''Some Initialization Text'' as Narrative,                     
'''' as CreatedBy,                      
getdate() as CreatedDate,                      
'''' as ModifiedBy,                      
getdate() as ModifiedDate     
                                       
' 
END
GO
