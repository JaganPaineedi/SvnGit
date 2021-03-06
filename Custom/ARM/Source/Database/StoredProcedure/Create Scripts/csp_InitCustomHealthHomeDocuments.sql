/****** Object:  StoredProcedure [dbo].[csp_InitCustomHealthHomeDocuments]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomHealthHomeDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomHealthHomeDocuments]        
(                            
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                            
)                                                    
As                                                      
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_InitCustomHealthHomeDocuments]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       29/Jan/2013      Bernardin               To Retrieve Data           */      
 /*********************************************************************/        
 
                                                                            
Begin     

Declare @NameOfGuardian varchar(500)
Declare @PrimaryPhysician varchar(500)                                       
    
Begin try

-- Select client''s guardian 
SET @NameOfGuardian = (SELECT LastName +'', ''+FirstName AS GuardianName FROM ClientContacts WHERE ClientId = @ClientID AND Guardian = ''Y'')

-- Select Primary Physician Name 1009494

SET @PrimaryPhysician = (SELECT LastName +'', ''+FirstName AS PrimaryCarePhysician FROM ClientContacts WHERE ClientId = @ClientID AND Relationship = 1009494)

-- CustomDocumentHealthHomeCommPlans                      
Select TOP 1 ''CustomDocumentHealthHomeCommPlans'' AS TableName, -1 as ''DocumentVersionId'', 
'''' as CreatedBy,                  
getdate() as CreatedDate,                  
'''' as ModifiedBy,                  
getdate() as ModifiedDate,
@PrimaryPhysician as PrimaryCarePhysicianName, 
@NameOfGuardian as LegalGuardian
from systemconfigurations s left outer join CustomDocumentHealthHomeCommPlans CDHHCP                                                                       
on s.Databaseversion = -1
                                 
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomHealthHomeDocuments'')                                                                             
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
