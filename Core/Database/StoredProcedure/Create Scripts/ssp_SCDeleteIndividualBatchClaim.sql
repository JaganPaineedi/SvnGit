
/****** Object:  StoredProcedure [dbo].[ssp_SCDeleteIndividualBatchClaim]    Script Date: 08/22/2016 14:01:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDeleteIndividualBatchClaim]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDeleteIndividualBatchClaim]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCDeleteIndividualBatchClaim]    Script Date: 08/22/2016 14:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ssp_SCDeleteIndividualBatchClaim]          
(   
 @ClaimBatchDirectEntryId Int ,
 @StaffId int
)        
 AS  
      
/*********************************************************************/                                              
-- Stored Procedure: dbo.ssp_SCDeleteIndividualBatchClaim                                                              
-- Copyright: Streamline Healthcate Solutions                                                            
-- Creation Date:  08/22/2016                                                                               
--                                                                                                                 
-- Purpose: It will delete Individual Batch Claim data                                                      
--                                                                                                               
-- Input Parameters:                                                     
--                                                                                                               
-- Output Parameters:                                                                             
--                                                                                                                
-- Return:  */                                              
--                                                                                                                 
-- Called By:                                                                                                     
--                                                                                                                 
-- Calls:                                                                                                          
--                                                                                                                 
-- Data Modifications:                                                                                            
--                                                                                                                 
-- Updates:                                                                                                        
-- Date				Author    Purpose                                                                               
-- 25/Aug/2016		Gautam    Created ,Ref #73  Network180-Customizations.                     
  
/*********************************************************************/    
--Variable to store GlobalCodeId from database   
   BEGIN   
     BEGIN TRY 
     Declare @UserCode varchar(50)
     DECLARE @Submitted int
     
	select @UserCode= UserCode from Staff where StaffId=@StaffId
	select @Submitted = GlobalCodeId from GlobalCodes where Code='SUBMITTED' and Category='BatchClaimBtchStatus' and  isnull(RecordDeleted,'N') = 'N'  

	Update CB
	Set CB.RecordDeleted='Y', CB.DeletedBy=@UserCode ,CB.DeletedDate=getdate()
	From ClaimBatchDirectEntries CB where CB.ClaimBatchDirectEntryId =@ClaimBatchDirectEntryId
	and ISNULL(CB.RecordDeleted,'N')='N'
	and CB.BatchStatus <> @Submitted
		
	--MIDemoSmartCare
    
    END TRY           
  BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCDeleteIndividualBatchClaim')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 

      
GO
   
 