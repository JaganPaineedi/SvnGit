IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportDocumentHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportDocumentHeader]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO              
CREATE PROCEDURE [dbo].[csp_RdlSubReportDocumentHeader]                    
@DocumentVersionId int                    
                            
 AS                             
/*********************************************************************/                                                                                                
 /* Stored Procedure: [csp_RdlSubReportDocumentHeader]               */                                                                                       
 /* Creation Date:  17/Feb/2012                                    */                                                                                                
 /* Purpose: To Initialize */                                                                                               
 /* Input Parameters:   @DocumentVersionId */                                                                                              
 /* Output Parameters:                                */                                                                                                
 /* Return:   */                                                                                                
 /* Called By: RdlSubReportDocumentHeader  */                                                                                      
 /* Calls:                                                            */                                                                                                
 /*                                                                   */                                                                                                
 /* Data Modifications:                                               */                                                                                                
 /*   Updates:                                                          */                                                                                                
 /*       Date              Author                  Purpose    */          
 /*    17/2/2012   Maninder    Created */         
 /*  2031.03.21   JJN      Added DocumentCodeId and RecordDeleted's*/              
 /*********************************************************************/          
BEGIN TRY            
                        
SELECT  DocumentCodes.DocumentName          
        ,Documents.DocumentId                  
        ,(select OrganizationName from SystemConfigurations ) as OrganizationName                  
        ,CONVERT(VARCHAR(10),Documents.EffectiveDate,101) as EffectiveDate           
        ,CONVERT(VARCHAR(10),DATEADD(mm,12,Documents.EffectiveDate),101) as ToDate           
        ,ISNULL(Clients.FirstName, '') + ' ' + ISNULL(Clients.LastName, '') AS ClientName                   
        ,Clients.ClientId               
        ,DocumentCodes.DocumentCodeId     
        ,S.FirstName + ' ' + S.LastName + ',  ' + ISNull(GC.CodeName,'') as ClinicianName          
FROM  Documents                   
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId            
 AND ISNULL(Clients.RecordDeleted,'N')='N'       
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,'N')<>'Y'             
Left Join GlobalCodes GC On GC.GlobalCodeId = S.Degree and isNull(GC.RecordDeleted,'N')<>'Y'       
         
Inner join DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId          
 AND ISNULL(DocumentCodes.RecordDeleted,'N')='N'                    
INNER JOIN DOCUMENTVERSIONS ON DOCUMENTS.DOCUMENTID=DOCUMENTVERSIONS.DOCUMENTID              
 AND ISNULL(DOCUMENTVERSIONS.RecordDeleted,'N')='N'             
 AND DocumentVersions.DocumentVersionId = @DocumentVersionID              
          
END TRY                              
BEGIN CATCH                              
 declare @Error varchar(8000)                              
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RdlSubReportDocumentHeader')                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                
    + '*****' + Convert(varchar,ERROR_STATE())                              
 RAISERROR                               
 (                              
  @Error, -- Message text.                              
  16,  -- Severity.                              
  1  -- State.                              
 );                           
END CATCH 