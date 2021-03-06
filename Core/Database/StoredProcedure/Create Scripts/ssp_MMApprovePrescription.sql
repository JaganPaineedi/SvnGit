IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMApprovePrescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MMApprovePrescription]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[ssp_MMApprovePrescription]          
(                                      
 @PrescriberId int,          
 @LastReviewDateTime datetime,        
 @RDLDateTime datetime        
         
)                                      
As                                      
                                    
BEGIN TRY                                     
                                           
/*********************************************************************/                                        
/* Stored Procedure: [ssp_MMApprovePrescription]                     */                                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                        
/* Creation Date:  30 Oct 2009                                       */                                        
/*                                                                   */                                        
/* Purpose: Validate Review Prescriptions                            */                                       
/*                                                                   */                                      
/* Input Parameters: @PrescriberId ,@LastPrescriptionReviewTime      */                                      
/*                                                                   */                                        
/* Return:scalar value              */                                        
/*                                                                   */                                        
/* Called By:                                                        */                                        
/*                                                                   */                                        
/* Calls:                                                            */                                        
/*                                                                   */                                        
/* Data Modifications:                                               */                                        
/*                                                                   */                                        
/* Updates:                                                          */                                        
/*  Date        Author     Purpose          */                                        
/* 30/10/2009  Chandan Srivastava       Created						 */
/* 25/04/2016  Anto       Updating the top 200 records to improve performance */
                                     
/*********************************************************************/           
Begin Tran                                      
      
declare @goLiveDate datetime      
set @goLiveDate = '3/24/2009'      
      
      
-- Update ClientMedication table         
update top (200) cms  set PrescriberReviewDateTime = @RDLDateTime  
from ClientMedicationScriptActivities as cmsa  
join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId  
where cms.OrderingPrescriberId = @PrescriberId  
and datediff(day, cmsa.CreatedDate, @goLiveDate) <= 0  
and cmsa.PrescriberReviewDateTime is null  
and isnull(cmsa.RecordDeleted, 'N') <> 'Y'  
and isnull(cms.RecordDeleted, 'N') <> 'Y'  
   
      
update top (200) cmsa set PrescriberReviewDateTime = @RDLDateTime      
from ClientMedicationScriptActivities as cmsa      
join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId      
where cms.OrderingPrescriberId = @PrescriberId      
and datediff(day, cmsa.CreatedDate, @goLiveDate) <= 0        
and cmsa.PrescriberReviewDateTime is null      
and isnull(cmsa.RecordDeleted, 'N') <> 'Y'      
and isnull(cms.RecordDeleted, 'N') <> 'Y'          


      
-- Update Staff table         
Update Staff set LastPrescriptionReviewTime = @RDLDateTime where StaffId = @PrescriberId        
Commit Tran        
Return  (0)              
END TRY                                    
BEGIN CATCH                                    
 declare @Error varchar(8000)                                    
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_MMApprovePrescription')                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                    
                                      
 RAISERROR                                    
 (            
  @Error, -- Message text.                                    
  16, -- Severity.                                    
  1 -- State.                                    
 );                                    
                                    
END CATCH  