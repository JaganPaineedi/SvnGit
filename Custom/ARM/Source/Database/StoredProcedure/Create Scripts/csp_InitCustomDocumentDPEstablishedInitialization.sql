/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentDPEstablishedInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentDPEstablishedInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentDPEstablishedInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentDPEstablishedInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[csp_InitCustomDocumentDPEstablishedInitialization]            
(                                
 @ClientID int,          
 @StaffID int,        
 @CustomParameters xml                                
)                                                        
As                                                          
                                                                                                                                                     
BEGIN                                                
        
BEGIN TRY   
                              
Select TOP 1 ''CustomDocumentDPEstablished'' AS TableName, -1 as ''DocumentVersionId'',                        
                     
    
                                 
'''' as CreatedBy,                      
getdate() as CreatedDate,                      
'''' as ModifiedBy,                      
getdate() as ModifiedDate     
from systemconfigurations s left outer join CustomDocumentDPEstablished C                                                                           
on s.Databaseversion = -1    
                                       
END TRY                                                 
                                                                                           
BEGIN CATCH  
    
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDocumentDPEstablishedInitialization'')                                                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                              
 RAISERROR                                                                                 
 (                                                   
  @Error, -- Message text.                                                                                
  16, -- Severity.                                                                                
  1 -- State.                                                                                
 );                                                                              
END CATCH   
                          
END    

' 
END
GO
