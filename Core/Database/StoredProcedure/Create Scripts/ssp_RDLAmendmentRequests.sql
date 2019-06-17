
/****** Object:  StoredProcedure [dbo].[ssp_RDLAmendmentRequests]    Script Date: 06/09/2015 10:07:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLAmendmentRequests]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLAmendmentRequests]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLAmendmentRequests]    Script Date: 06/09/2015 10:07:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   
CREATE PROCEDURE [dbo].[ssp_RDLAmendmentRequests]        
 (        
  @DocumentVersionId int           
 )        
AS
/******************************************************************************                              
**  File:                               
**  Name: [ssp_RDLAmendmentRequests]                              
**  Desc: This storeProcedure will return information for RDL                            
**                                            
**  Parameters:                              
**  Input  @DocumentVersionId           
                                
**  Output     ----------       -----------                              
**                          
                            
**  Auth:  Vithobha                        
**  Date:  27 Oct 2014                            
*******************************************************************************                              
**  Change History                              
*******************************************************************************                              
**  Date:  Author:    Description:                              
**  --------  --------    -------------------------------------------                              
**                        
*******************************************************************************/         
BEGIN     
 BEGIN TRY       
   SELECT        
     C.[ClientId]        
      , C.[FirstName] + ', ' + C.[LastName] As ClientName          
      ,Convert(varchar(10),C.[DOB],101) as DateOfBirth          
      ,(Select OrganizationName from SystemConfigurations) as OrganizationName         
      ,CONVERT(VARCHAR(10),Documents.EffectiveDate,101) as EffectiveDate         
      ,DocumentName = REPLACE(DocumentCodes.DocumentName,'Converted ','') 
      ,DocumentVersions.DocumentVersionId   
      ,CA.ReasonForRequest         
   FROM        
    Documents        
    INNER JOIN DocumentVersions        
     ON Documents.DocumentId = DocumentVersions.DocumentId        
    Inner join DocumentCodes         
     ON DocumentCodes.DocumentCodeid= Documents.DocumentCodeId                      
    INNER JOIN Clients C        
     ON C.ClientId = Documents.ClientId    
     Join ClientAmendmentRequestDocuments CA on  DocumentVersions.DocumentVersionId= CA.DocumentVersionId  
   WHERE        
    DocumentVersions.DocumentVersionId = @DocumentVersionId        
    AND isnull(Documents.RecordDeleted, 'N') = 'N'        
    AND isnull(DocumentVersions.RecordDeleted, 'N') = 'N'        
    AND isnull(C.RecordDeleted, 'N') = 'N'   
    And isnull(CA.RecordDeleted, 'N') = 'N'   
        
 END TRY    
  BEGIN CATCH            
  DECLARE @Error varchar(8000)                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLAmendmentRequests')                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                      
  RAISERROR                                                                                         
  (                                                           
   @Error, -- Message text.                                                                                        
   16, -- Severity.                                                                                        
   1 -- State.                                                                                        
   );             
 END CATCH    
END 

GO


