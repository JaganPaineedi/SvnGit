/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataSupervisorSignature]    Script Date: 02/13/2015 13:01:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataSupervisorSignature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataSupervisorSignature]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataSupervisorSignature]    Script Date: 02/13/2015 13:01:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE  [dbo].[csp_RDLGetDataSupervisorSignature]                                  
(                                                      
 @DocumentId int,              
 @AuthorId int              
                              
)                                                      
                                                      
As                                                      
 /****************************************************************************/                                                                
 /* Stored Procedure:csp_RDLGetDataSupervisorSignature           */                                                       
 /* Copyright: 2006 Streamline Healthcare Solutions                                      */                                                               
 /* Creation Date:  April 17,2009                                                         */                                                                
 /* Purpose: Gets Data for Supervisor Signature Used in Rdl                       */                                                               
 /* Input Parameters: @DocumentId int,@AuthorId int                    */                                                              
 /* Output Parameters:None                                                              */                                                                
 /* Return:                */                                                                
 /*                                                                            */                                                                
 /* Data Modifications:                                                                 */                                                                
 /*                                                                                     */                                                                
 /*   Updates:                                                                          */                                                                
 /*   Date                  Author         Purpose                                                */                                                 
 /* April 17,2009           Harish Bansal  Created                                                */          
 /* Vikas Vyas May 01,2009   Perform logic for StaffSupervisor */                            
                                                                                                    
 /*********************************************************************/                                                                 
BEGIN                                    
                                         
 BEGIN TRY                                        
                         
            
                               
select  ISNULL(S.Firstname,'') + '' + ISNULL(S.LastName,'') as SupervisorName,    
        ISNULL(GlobalCodes.CodeName,'') as Degree,      
        SignatureDate ,    
        Ds.PhysicalSignature,      
          case when ds.PhysicalSignature IS NULL then 'Electronically Signed'      
           else 'Physical Signature'      
           End as DisplayAs,  
        Ds.SignerName ,  
        case when Pr.ProgramName IS NULL then 'WMU Behavioral Health Services'
           else 'WMU Behavioral Health Services' + '/' + Pr.ProgramName
           End
           as AgencyProgramName   
                       
   from DocumentSignatures DS              
   inner join StaffSupervisors on StaffSupervisors.SupervisorId=DS.StaffId and Isnull(StaffSupervisors.RecordDeleted,'N')<>'Y'    
   Inner join Staff S              
   on S.StaffId=StaffSupervisors.SupervisorId    
   Left Join GlobalCodes on GlobalCodes.GlobalCodeId=S.Degree and ISNULL(GlobalCodes.RecordDeleted,'N')<>'Y'    
   and GlobalCodes.Active='Y'    
    Left Join Programs Pr on Pr.ProgramId=S.PrimaryProgramId and ISNULL(Pr.RecordDeleted,'N')<>'Y' and Pr.Active='Y'    
   where Ds.DocumentId = @DocumentId and StaffSupervisors.StaffId=@AuthorId and isnull(S.RecordDeleted,'N')<>'Y'          --and S.Degree not in (10126,10056) and isnull(S.RecordDeleted,'N')<>'Y'              
            
                         
   END TRY                                    
   BEGIN CATCH                                
       DECLARE @Error varchar(8000)                                                                       
    set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                      
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_RDLGetDataSupervisorSignature]')                                                                       
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


