IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataPhysicanSignature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataPhysicanSignature]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE  [dbo].[csp_RDLGetDataPhysicanSignature]                                                  
(                                                      
    @DocumentId int,              
    @AuthorId int              
                              
)                                                      
                                                      
As                                                      
 /****************************************************************************/                                                                
 /* Stored Procedure:csp_RDLGetDataPhysicanSignature          */                                                       
 /* Copyright: 2006 Streamline Healthcare Solutions                                      */                                                               
 /* Creation Date:  May 01,2009                                                         */                                                                
 /* Purpose: Gets Data for Physician Signature Used in Rdl                       */                                                               
 /* Input Parameters: @DocumentId int,@AuthorId int                    */                                                              
 /* Output Parameters:None                                                              */                                                                
 /* Return:                */                                                                
 /*                                                                            */                                                                
 /* Data Modifications:                                                                 */                                                                
 /*                                                                                     */                                                                
 /*   Updates:                                                                          */                                                                
 /*   Date              Author         Purpose                                                */                                                 
 /* May 01,2009       Vikas Vyas  Created                                                */                                  
                                                                                                    
 /*********************************************************************/                                                                 
BEGIN                                    
                                         
 BEGIN TRY                                        
                         
                         
                               
select   ISNULL(S.Firstname,'') + '' + ISNULL(S.LastName,'') as PhysicanName,        
         SignerName,SignatureDate,        
          DS.PhysicalSignature,          
          case when ds.PhysicalSignature IS NULL then 'Electronically Signed'          
           else 'Physical Signature'          
           End as DisplayAs,  
           case when Pr.ProgramName IS NULL then 'WMU Behavioral Health Services'  
           else 'WMU Behavioral Health Services' + '/' + Pr.ProgramName  
           End  
           as AgencyProgramName  
           --Pr.ProgramName  
                          
      from DocumentSignatures DS  join Staff S   on S.StaffId=DS.StaffId         
      Left Join Programs Pr on Pr.ProgramId=s.PrimaryProgramId and ISNULL(Pr.RecordDeleted,'N')<>'Y' and Pr.Active='Y'    
     where Ds.DocumentId = @DocumentId and DS.StaffId<>@AuthorId and S.Degree in (10060,10056)  and isnull(S.RecordDeleted,'N')<>'Y'       
     --(10126,10056)  and isnull(S.RecordDeleted,'N')<>'Y'              
     
    
                         
   END TRY                                    
   BEGIN CATCH                                    
       DECLARE @Error varchar(8000)                                                                       
    set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_RDLGetDataPhysicanSignature]')                                                                       
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


