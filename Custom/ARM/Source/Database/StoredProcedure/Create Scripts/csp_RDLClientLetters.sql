/****** Object:  StoredProcedure [dbo].[csp_RDLClientLetters]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLClientLetters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLClientLetters]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLClientLetters]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'     
CREATE PROCEDURE [dbo].[csp_RDLClientLetters] 

/************************************************************************/                                                          
/* Stored Procedure: csp_RDLClientLetters        */                                                 
/*        */                                                          
/* Creation Date:  30 Sep 2011           */                                                          
/*                  */                                                          
/* Purpose: Gets Data for csp_RDLClientLetters       */                                                         
/* Input Parameters: DocumentVersionId        */                                                        
/* Output Parameters:             */                                                          
/* Purpose: Use For Rdl Report           */                                                
/* Calls:                */                                                          
/*                  */                                                          
/* Author: Jagdeep             */  
/* Edited by :Rakesh             */       
/* Wasif Butt - Replace the MS Office xml namespace from the RDL TextData*/
/*22.12.2017 - Kavya.N     - Changed clientname  format to (Firstname Lastname)*/                                                     
/*********************************************************************/        
 @DocumentVersionId AS INT 
      
AS      
                                                                                                               
BEGIN TRY                                 
BEGIN   
      
  SELECT TD.DocumentVersionId,
       (Select OrganizationName from SystemConfigurations) as OrganizationName                                  
       ,D.ClientId                                  
       ,Clients.FirstName + '' '' + Clients.LastName as ClientName    
       ,CONVERT(VARCHAR(10),D.EffectiveDate,101) as EffectiveDate                                    
       ,replace(TD.TextData,''<?xml:namespace prefix = o ns = "urn:schemas-microsoft-com:office:office" />'','''') as TextData
 From Documents D                    
 join DocumentVersions DV on D.DocumentId = DV.DocumentId                 
 Left Join TextDocuments TD on TD.DocumentVersionId = DV.DocumentVersionId               
 Join Clients on Clients.ClientId = D.ClientId                                    
 Where TD.DocumentVersionId =@DocumentVersionId             
 and ISNULL(D.RecordDeleted,''N'')=''N''                  
 and ISNULL(DV.RecordDeleted,''N'')=''N''                               
 and ISNULL(TD.RecordDeleted,''N'')=''N''                                 
 and ISNULL(Clients.RecordDeleted,''N'')=''N''                         

END                                                                                    
 END TRY                                                                                             
                  
                                
                                                                                   
 BEGIN CATCH                                               
   DECLARE @Error varchar(8000)                                                                                                                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                  
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLClientLetters'')                 
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                  
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                                        
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                            
 END CATCH 
 
 
 
 

' 
END
GO
