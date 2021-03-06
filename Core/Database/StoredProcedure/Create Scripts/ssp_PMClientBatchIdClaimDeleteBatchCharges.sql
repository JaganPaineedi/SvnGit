
/****** Object:  StoredProcedure [dbo].[ssp_PMClientBatchIdClaimDeleteBatchCharges]    Script Date: 07/27/2016 11:00:40 ******/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PMClientBatchIdClaimDeleteBatchCharges]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_PMClientBatchIdClaimDeleteBatchCharges]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMClientBatchIdClaimDeleteBatchCharges]    Script Date: 07/27/2016 11:00:40 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		
CREATE PROCEDURE [dbo].[ssp_PMClientBatchIdClaimDeleteBatchCharges]
	@SessionId    VARCHAR(30),  
	@InstanceId    INT,	
	@ClientBatchId INT,
	@CurrentUser varchar(30)
AS 
/********************************************************************************                                                      
-- Stored Procedure: [ssp_PMClientBatchIdClaimDeleteBatchCharges]    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Procedure to delete charges from Claims Processing popup page.    
--    
-- Author:  Sachin Borgave    
-- Date:    22.07.2016 

-- *****History**** 

-- 07/27/2016 Sachin Borgave	#2281 Core Bugs Created SP for delete charges from Claims Processing popup page.
	   
*********************************************************************************/   
BEGIN    

     BEGIN try 
  
	CREATE TABLE #LastBilledDate  
	(
			ClaimBatchId int not null,  
			ChargeId int not null,  
			FirstBilledDate datetime null,  
			LastBilledDate datetime null
	)  
  
	DECLARE  @CurrentDate DATETIME  
  
	set @CurrentDate = GETDATE()  
  
	     

			    CREATE TABLE  #RowSelection 
			    (
					BatchId INT
			     )  
			    INSERT INTO #RowSelection (BatchId) 
						  values(@ClientBatchId) 

				INSERT INTO #LastBilledDate  
				SELECT  a.ClaimBatchId, a.ChargeId, min(c.BilledDate), max(c.BilledDate)  
				FROM ClaimBatchCharges a  
				LEFT JOIN BillingHistory c ON (a.ChargeId = c.ChargeId and c.ClaimBatchId <> a.ClaimBatchId)  
				LEFT JOIN #RowSelection rs ON (a.ClaimBatchId in(rs.BatchId))
				WHERE a.ClaimBatchId in(rs.BatchId) 
				group by a.ClaimBatchId,a.ChargeId
  
			 
  
				UPDATE b  
				set FirstBilledDate = a.FirstBilledDate, LastBilledDate = a.LastBilledDate,  
				ModifiedBy = @CurrentUser, ModifiedDate = @CurrentDate  
				from #LastBilledDate a  
				JOIN Charges b ON (a.ChargeId  = b.ChargeId)  
  
			
  
							-- Delete Batch 
			IF EXISTS(SELECT ClaimBatchId FROM #LastBilledDate WHERE ClaimBatchId = @ClientBatchId)
			BEGIN
						 
				UPDATE a  
				set RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate = @CurrentDate  
				from #LastBilledDate z  
				JOIN ClaimBatchCharges a ON (a.ChargeId = z.ChargeId)  
				where a.ClaimBatchId = z.ClaimBatchId  -- Added BatchId
			END
		
			IF EXISTS(SELECT ClaimBatchId FROM #LastBilledDate WHERE ClaimBatchId = @ClientBatchId)
			BEGIN
			
				UPDATE a  
				set RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate = @CurrentDate  
				from #LastBilledDate z  
				JOIN BillingHistory a ON (a.ChargeId = z.ChargeId)  
				where a.ClaimBatchId = z.ClaimBatchId 
			END
			 
			 ----------- Delete Batch-------------------
			IF EXISTS(SELECT ClaimBatchId FROM #LastBilledDate WHERE ClaimBatchId = @ClientBatchId)
			BEGIN
				UPDATE a  
				set RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate = @CurrentDate  
				from ClaimBatches a   
				JOIN #LastBilledDate b on a.ClaimBatchId = b.ClaimBatchId  
				where Not EXISTS (select * from ClaimBatchCharges c   
					 where  a.ClaimBatchId = c.ClaimBatchId  -- Added BatchId
					 and ISNULL(c.RecordDeleted,'N') = 'N')
			END 
			
  
		END try 
		BEGIN CATCH
			DECLARE @Error VARCHAR(8000)

			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + 
				ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientBatchIdClaimDeleteBatchCharges') 
				+ '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + 
				CONVERT(VARCHAR, ERROR_STATE())

			RAISERROR (
							@Error
							,-- Message text.                                                                                              
							16
							,-- Severity.                   
							1 -- State.                                                          
						);
		END CATCH
		
END  
  
  
  
  
  




