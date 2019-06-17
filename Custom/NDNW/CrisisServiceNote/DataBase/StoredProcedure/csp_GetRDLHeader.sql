/****** Object:  StoredProcedure [dbo].[csp_GetRDLHeader]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetRDLHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetRDLHeader]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetRDLHeader]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE  [dbo].[csp_GetRDLHeader]                            
(                                
 @DocumentVersionId  int                         
)                                
                                
As                                
 /****************************************************************************/                                          
 /* Stored Procedure:csp_GetRDLHeader            */                                 
 /* Copyright: 2006 Streamlin Healthcare Solutions                                      */                                         
 /* Creation Date:  Feb 02,2009                                                         */                                          
 /* Purpose: Gets Data for ReportHeader Used in Rdl                      */                                         
 /* Input Parameters: @DocumentVersionId                   */                                        
 /* Output Parameters:None                                                              */                                          
 /* Return:                */                                          
 /* Data Modifications:                                                                 */                                          
 /*                                                                                     */                                          
 /*   Updates:                                                                          */                                          
 /*   Date              Author        Purpose                                                */                           
 /* Feb 02,2009         Vikas Vyas    Created                                                */            
                                                                              
 /*********************************************************************/                                           
BEGIN              
                   
 BEGIN TRY                  
        
/*For Rdl Header */   

 DECLARE @DocumentName  VARCHAR(100) 
 
  SELECT @DocumentName = DocumentCodes.DocumentName   
	  FROM Documents  
	  JOIN Staff S ON Documents.AuthorId = S.StaffId  
	  JOIN Clients C ON Documents.ClientId = C.ClientId  
	   AND isnull(C.RecordDeleted, 'N') <> 'Y'  
	  JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId  
	  INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId        
	   AND ISNULL(DocumentCodes.RecordDeleted,'N')='N'   
	  LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId  
	  WHERE dv.DocumentVersionId = @DocumentVersionId  
	   AND isnull(Documents.RecordDeleted, 'N') = 'N'       
    
    
Select       
Documents.ClientId,        
Convert(varchar,Documents.EffectiveDate,101) as EffectiveDate, 
 @DocumentName AS DocumentName  ,       
Clients.LastName+ ', ' + Clients.FirstName  as ClientName,        
Clinician.LastName + ', ' + Clinician.FirstName as ClinicianName,        
(select OrganizationName from SystemConfigurations ) as OrganizationName      
from Documents  
INNER JOIN  Documentversions on   Documents.documentId = Documentversions.documentId       
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId                    
 and isnull(Clients.RecordDeleted,'N')='N'           
Left Join Staff as Clinician On Documents.AuthorId=Clinician.StaffId      
Where Isnull(Documents.RecordDeleted,'N')='N'  and Isnull(Clients.RecordDeleted,'N')='N' and Isnull(Clinician.RecordDeleted,'N')='N'      
and Documentversions.documentversionId=@DocumentVersionId      
/*End */      
               
   END TRY              
   BEGIN CATCH              
       DECLARE @Error varchar(8000)                                                 
    set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_GetRDLHeader]')                                                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                
    + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                
    RAISERROR                                                 
    (                                                 
    @Error, -- Message text.                                                 
    16, -- Severity.                                                 
    1 -- State.                                                 
    )              
   END CATCH                            
End
GO


