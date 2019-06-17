/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataOtherSignature]    Script Date: 02/13/2015 12:58:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataOtherSignature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataOtherSignature]
GO



/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataOtherSignature]    Script Date: 02/13/2015 12:58:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE  [dbo].[csp_RDLGetDataOtherSignature]                 
(                                                            
 @DocumentVersionId int                  
                                    
)                                                            
                                                            
As                                                            
 /****************************************************************************/                                                                      
 /* Stored Procedure:csp_RDLGetDataOtherSignature           */                                                             
 /* Copyright: 2006 Streamline Healthcare Solutions                                      */                                                                     
 /* Creation Date:  May 07,2009                                                         */                                                                      
 /* Purpose: Gets Data for Other Signature Section Used in Rdl                       */                                                                     
 /* Input Parameters: @DocumentId int,@AuthorId int                    */                                                                    
 /* Output Parameters:None                                                              */                                                                      
 /* Return:                */                                                                      
 /*                                                                            */                                                                      
 /* Data Modifications:                                                                 */                                                                      
 /*                                                                                     */                                                                      
 /*   Updates:                                                                          */                                                                      
 /*   Date                  Author           Purpose                                                */                                                       
  /* May 17,2009            Vikas Vyas       RDL(To Show only Record Not SuperVisor,Not clinician, Not Physician                  */        
  /* June 21 2013			katta sharath kumar With Ref To Task-525:St. Joe-Support*/
                                                                                                          
 /*********************************************************************/                                                                       
BEGIN                                          
                                               
 BEGIN TRY                                               
select  Ds.SignerName as ParticipantName,  
Convert(varchar,SignatureDate,101) As SignatureDate ,   
        --SignatureDate ,          
        ds.PhysicalSignature,            
          case when ds.PhysicalSignature IS NULL then 'Electronically Signed'            
           else 'Physical Signature'            
           End as DisplayAs                     
   from Documents as d                              
   Inner join documentVersions as dv on dv.DocumentId = d.DocumentId and isnull(dv.RecordDeleted,'N')<>'Y'                              
   left Join documentSignatures ds on ds.DocumentId=d.DocumentId and ISNULL(ds.RecordDeleted,'N')<>'Y'        
 --  where dv.DocumentVersionId=@DocumentVersionId and ISNULL(d.RecordDeleted,'N')<>'Y'       
 --  --and d.Status=22       
 --  and  ( ds.StaffId is null or ds.ClientId is null )      
 ----  and ds.ClientId is null       
    WHERE   DV.DocumentVersionId = @DocumentVersionId    
            AND ds.SignedDocumentVersionId = @DocumentVersionId -- Added additional filter to retreive only the signatures for the requested DocumentVersionId    
            AND ISNULL(d.RecordDeleted, 'N') <> 'Y'    
            AND SignatureDate IS NOT NULL    
--and ds.signatureorder = 1                 
            AND ISNULL(ds.RecordDeleted, 'N') <> 'Y'    
    ORDER BY SignatureOrder                             
                               
   END TRY                                          
   BEGIN CATCH                                      
       DECLARE @Error varchar(8000)                                                                             
    set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_RDLGetDataOtherSignature]')                                                                             
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


