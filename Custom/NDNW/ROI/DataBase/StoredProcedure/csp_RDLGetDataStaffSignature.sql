IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataStaffSignature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataStaffSignature]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataStaffSignature]    Script Date: 02/13/2015 12:35:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
  
CREATE PROCEDURE [dbo].[csp_RDLGetDataStaffSignature]                                                              
(                                                                  
  @DocumentVersionId int                                                            
                                          
)                                                                  
                                                                  
As                                                                  
 /****************************************************************************/                                                                            
 /* Stored Procedure:csp_RDLGetDataStaffSignature    512617       */                                                                   
 /* Copyright: 2006 Streamline Healthcare Solutions                                      */                                                                           
 /* Creation Date:  April 17,2009                                                         */                                                                            
 /* Purpose: Gets Data for Staff Signature Used in Rdl                       */                                                                           
 /* Input Parameters: @DocumentVersionId                    */                                                                          
 /* Output Parameters:None                                                              */                                                                            
 /* Return:                */                                                                            
 /*                                                                            */                                                                            
 /* Data Modifications:                                                                 */                                                                            
 /*                                                                                     */                                                                            
 /*   Updates:                                                                          */                                                                            
 /*   Date              Author				Purpose                                                */                                                             
 /* April 17,2009       Harish Bansal		Created                                                */                                              
 /* May 01,2009         Vikas Vyas			add Case for PhysicalSignature and get clinician degree */
 /*JUNE 15 , 2013       Aravind halemane	Changed the CSP to  Display Cosigner */
 /*June 21 2013			katta sharath kumar With Ref To Task-525:St. Joe-Support*/
                                                                                                                
 /*********************************************************************/                                                                             
BEGIN                                                      
                                                           
 BEGIN TRY                                                          
                                                
select                                 
  d.DocumentId,                              
  d.AuthorId,                              
  isnull(s.FirstName,'') + ' ' + isnull(s.LastName,'')  as ClinicianName,                                
  ds.SignerName as  ClinicianSignature,  
  Convert(varchar,ds.SignatureDate,101) As ClinicianSignatureDate, -- Added to show the date in MM/dd/yyyy format                                
  --ds.SignatureDate  as ClinicianSignatureDate,                
  ds.PhysicalSignature,                
  case when ds.PhysicalSignature IS NULL then 'Electronically Signed'                
           else 'Physical Signature'         
           End as DisplayAs,             
              
     case when Pr.ProgramName IS NULL then 'WMU Behavioral Health Services'          
           else 'WMU Behavioral Health Services' + '/' + Pr.ProgramName          
           End          
           as AgencyProgramName,                       
                                       
  case when s.Degree in (10126,10056) then ds.PhysicalSignature                                
  else null end as 'Ph'                                
                      
    from Documents as d                                
   Inner join documentVersions as dv on dv.DocumentId = d.DocumentId and isnull(dv.RecordDeleted,'N')<>'Y'        
    join Staff as  s on s.StaffId=d.AuthorId and isnull(S.RecordDeleted,'N')<>'Y'          
     Left Join Programs Pr on Pr.ProgramId=s.PrimaryProgramId and ISNULL(Pr.RecordDeleted,'N')<>'Y' and Pr.Active='Y'                               
   left Join documentSignatures ds on ds.DocumentId=d.DocumentId and ISNULL(ds.RecordDeleted,'N')<>'Y'          
   where dv.DocumentVersionId=@DocumentVersionId and ISNULL(d.RecordDeleted,'N')<>'Y'     
   ---Modified To Avoid Blank Signatures  
    AND ds.SignedDocumentVersionId = @DocumentVersionId    
     AND SignatureDate IS NOT NULL  AND ISNULL(ds.RecordDeleted, 'N') <> 'Y'    
      and  ( ds.StaffId is null or ds.ClientId is null ) and d.Status=22     
    ORDER BY SignatureOrder         
    
   --and d.Status=22         
         
 --  and ds.ClientId is null         
         
          
 --from Documents as d                                  
 --  join documentVersions as dv on dv.DocumentId = d.DocumentId and isnull(dv.RecordDeleted,'N')<>'Y'                                  
 --join Staff as  s on s.StaffId=d.AuthorId and isnull(S.RecordDeleted,'N')<>'Y'                                
 --  Left Join Programs Pr on Pr.ProgramId=s.PrimaryProgramId and ISNULL(Pr.RecordDeleted,'N')<>'Y' and Pr.Active='Y'            
 --  left join documentSignatures as ds on ds.DocumentId = d.DocumentId and ds.Staffid=s.Staffid and isnull(ds.RecordDeleted,'N')<>'Y'                                   
 --where dv.DocumentVersionId =@DocumentVersionId                
 --and isnull(d.RecordDeleted,'N')<>'Y'    and  ( ds.StaffId is null or ds.ClientId is null )        
 --  --and d.Status=22                                      
                      
   END TRY                                                      
   BEGIN CATCH                                                      
       DECLARE @Error varchar(8000)                                                             
    set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_RDLGetDataStaffSignature]')                                                                                         
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


