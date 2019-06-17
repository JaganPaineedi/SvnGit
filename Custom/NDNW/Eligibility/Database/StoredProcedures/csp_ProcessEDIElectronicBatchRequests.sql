/****** Object:  StoredProcedure [dbo].[csp_ProcessEDIElectronicBatchRequests]    Script Date: 01/27/2016 14:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_ProcessEDIElectronicBatchRequests]
    @PayerId AS NVARCHAR(100)
AS -- =============================================  
-- Author:  Pradeep A  
-- Create date: June 13, 2012  
-- Description: To Process the Subbatch response.  
-- 8/22/2013 Kneale - Added check for null value on processed status
-- =============================================  
    BEGIN  
        DECLARE @ElectronicEligibilityVerificationSubBatchId AS INT  
        DECLARE @ElectronicEligibilityVerificationBatchId AS INT  
        DECLARE @BatchSubmissionResponseId AS INT  
        DECLARE @MessageId AS INT  
        DECLARE @CreatedBy AS VARCHAR(100)  
        BEGIN TRY 
            DECLARE C1 CURSOR READ_ONLY
            FOR
                SELECT  ElectronicEligibilityVerificationSubBatchId ,
                        ElectronicEligibilityVerificationBatchId ,
                        BatchSubmissionResponseId ,
                        MessageId ,
                        CreatedBy
                FROM    dbo.ElectronicEligibilityVerificationSubBatches
                WHERE   SendStatus = 'ClosingData'
                        AND ISNULL(ProcessStatus, '') = 0  
	  
            OPEN c1  
            FETCH NEXT FROM C1 INTO @ElectronicEligibilityVerificationSubBatchId, @ElectronicEligibilityVerificationBatchId, @BatchSubmissionResponseId, @MessageId, @CreatedBy  
            WHILE @@Fetch_Status = 0
                BEGIN   
                    EXEC csp_SCUpdateSubBatchResponse @MessageId, @BatchSubmissionResponseId, @ElectronicEligibilityVerificationBatchId, @PayerId, @ElectronicEligibilityVerificationSubBatchId, @CreatedBy  
                    IF NOT EXISTS ( SELECT  1
                                    FROM    ElectronicEligibilityVerificationSubBatches
                                    WHERE   ElectronicEligibilityVerificationBatchId = @ElectronicEligibilityVerificationBatchId
                                            AND ISNULL(ProcessStatus, 0) = 0 )
                        BEGIN  
                            UPDATE  ElectronicEligibilityVerificationBatches
                            SET     [Status] = 1
                            WHERE   ElectronicEligibilityVerificationBatchId = @ElectronicEligibilityVerificationBatchId  
                        END  
                    FETCH NEXT FROM C1 INTO @ElectronicEligibilityVerificationSubBatchId, @ElectronicEligibilityVerificationBatchId, @BatchSubmissionResponseId, @MessageId, @CreatedBy  
                END  
            CLOSE C1  
            DEALLOCATE C1  
        END TRY
        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[csp_ProcessEDIElectronicBatchRequests]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                           
	(                                                             
		@Error, -- Message text.                                                                                          
		16, -- Severity.                                                                                          
		1 -- State.                                                                                          
	);
        END CATCH
    END  



GO
