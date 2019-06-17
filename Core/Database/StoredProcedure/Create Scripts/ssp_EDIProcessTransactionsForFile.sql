IF OBJECT_ID('ssp_EDIProcessTransactionsForFile') IS NOT NULL 
   DROP PROCEDURE ssp_EDIProcessTransactionsForFile
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

go

CREATE PROCEDURE ssp_EDIProcessTransactionsForFile
       @EDIFileId INT
      ,@CreatedByUserCode VARCHAR(30) = 'EDIProcessing'
AS 
/******************************************************************************
 * Procedure Name: csp_834ProcessMain
 * Author: David Knewtson
 * Created Date: 8/20/2015
 *
 * Purpose: Determine processing stored procedure for EDI File and execute
 ******************************************************************************
 * Change History
 ******************************************************************************
 * Author		Date		Purpose
 *-----------------------------------------------------------------------------
 ******************************************************************************/
BEGIN
       BEGIN TRY
             DECLARE @ErrorMessage NVARCHAR(MAX)
	
             DECLARE @TransactionSets TABLE
                     (
                      TransactionSetId INT
                     ,TradingPartnerId INT
                     )          
			
             UPDATE ei
             SET    EDITradingPartnerId = etp.EDITradingPartnerId
             FROM   dbo.EDIInterchanges ei
                    JOIN dbo.EDITradingPartners etp
                        ON ISNULL(etp.AuthorizationIdQualifier, '00') = ei.AuthorizationInformationQualifier
                           AND ISNULL(etp.AuthorizationId, '') = RTRIM(LTRIM(ei.AuthorizationInformation))
                           AND ISNULL(etp.SecurityInfoQualifier, '00') = ei.SecurityInformationQualifier
                           AND ISNULL(etp.SecurityId, '') = RTRIM(LTRIM(ei.SecurityInformation))
                           AND ISNULL(etp.InterchangeSenderIdQualifier,'ZZ') = ei.InterchangeSenderIdQualifier
                           AND etp.InterchangeSenderId = RTRIM(LTRIM(ei.InterchangeSenderId))
                           AND ISNULL(etp.InterchangeReceiverIdQualifier,'ZZ') = ei.InterchangeReceiverIdQualifier
                           AND etp.InterchangeReceiverId = RTRIM(LTRIM(ei.InterchangeReceiverId))
                           AND ISNULL(etp.RecordDeleted, 'N') <> 'Y'
                           AND etp.RecordType = 1 -- outgoing (whatever that's going to be)
                    JOIN dbo.EDIFiles ef
                        ON ef.EDIFileId = ei.EDIFileId
             WHERE  ef.EDIFileId = @EDIFileId


			 -- Saving time by doing these joins once and storing the result

             INSERT INTO @TransactionSets
                    (
                     TransactionSetId
                    ,TradingPartnerId
			        )
                    SELECT  ets.EDITransactionSetId
                           ,ei.EDITradingPartnerId
                    FROM    dbo.EDITransactionSets ets
                            JOIN dbo.EDIFunctionalGroups efg
                                ON ets.EDIFunctionalGroupId = efg.EDIFunctionalGroupId
                                   AND ISNULL(efg.RecordDeleted, 'N') <> 'Y'
                            JOIN dbo.EDIInterchanges ei
                                ON efg.EDIInterchangeId = ei.EDIInterchangeId
                                   AND ISNULL(ei.RecordDeleted, 'N') <> 'Y'
                            JOIN dbo.EDIFiles ef
                                ON ei.EDIFileId = ef.EDIFileId
                                   AND ISNULL(ef.RecordDeleted, 'N') <> 'Y'
                    WHERE   ef.EDIFileId = @EDIFileId
                            AND ISNULL(ets.RecordDeleted, 'N') <> 'Y'
                            AND ISNULL(ets.Processed,'N') <> 'Y'

             UPDATE ets
             SET    EDITradingPartnerId = ts.TradingPartnerId
                    ,EDITransactionSetTypeId = etst.EDITransactionSetTypeId
             FROM   dbo.EDITransactionSets ets
                    JOIN EDITransactionSetTypes ETST
                        ON ETST.TransactionSetIdentifierCode = ets.IdentifierCode
                           AND ETST.TransactionSetTypeImplementationConventionReference = ets.ImplementationConvention
                           AND ISNULL(etst.RecordDeleted, 'N') <> 'Y'
                    JOIN @TransactionSets ts
                        ON ts.TransactionSetId = ets.EDITransactionSetId

             -- try the functional group
             UPDATE ets
             SET    EDITradingPartnerId = ts.TradingPartnerId
                    ,EDITransactionSetTypeId = etst.EDITransactionSetTypeId
             FROM   dbo.EDITransactionSets ets
                    JOIN dbo.EDIFunctionalGroups efg ON ets.EDIFunctionalGroupId = efg.EDIFunctionalGroupId
                        AND ISNULL(efg.RecordDeleted,'N') <> 'Y'
                    JOIN EDITransactionSetTypes ETST
                        ON ETST.TransactionSetIdentifierCode = ets.IdentifierCode
                           AND ETST.TransactionSetTypeImplementationConventionReference = efg.VersionReleaseIICCode
                           AND ISNULL(etst.RecordDeleted, 'N') <> 'Y'
                    JOIN @TransactionSets ts
                        ON ts.TransactionSetId = ets.EDITransactionSetId
             WHERE ets.EDITransactionSetTypeId IS NULL

             IF EXISTS ( SELECT 1
                         FROM   dbo.EDITransactionSets ets
                                JOIN @TransactionSets ts
                                    ON ts.TransactionSetId = ets.EDITransactionSetId
                         WHERE  ets.EDITransactionSetTypeId IS NULL ) 
                BEGIN
                      DECLARE @TSWithoutType VARCHAR(MAX)

                      SELECT    @TSWithoutType = ISNULL(@TSWithoutType + ', ' + ets.TransactionSetControlNumber,
                                                        ets.TransactionSetControlNumber)
                      FROM      dbo.EDITransactionSets ets
                                JOIN @TransactionSets ts
                                    ON ts.TransactionSetId = ets.EDITransactionSetId
                      WHERE     ets.EDITransactionSetTypeId IS NULL 

                      SET @ErrorMessage = 'Unable to determine transaction type for Transaction Control Numbers '
                          + ISNULL(@TSWithoutType,'') + '. Please Check Transaction Control Number and Implementation Convention.'
                    INSERT INTO dbo.EDIFileErrors
                            (
                             CreatedBy
                            ,CreatedDate
                            ,ModifiedBy
                            ,ModifiedDate
                            ,EDIFileId
                            ,ErrorCode
                            ,ErrorMessage
                            )
                    VALUES  (
                              @CreatedByUserCode-- CreatedBy - type_CurrentUser
                            ,GETDATE()-- CreatedDate - type_CurrentDatetime
                            ,@CreatedByUserCode-- ModifiedBy - type_CurrentUser
                            ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                            ,@EDIFileId -- EDIFileId - int
                            ,NULL-- ErrorCode - varchar(10)
                            ,@ErrorMessage-- ErrorMessage - type_Comment2
                            )
                      --RAISERROR(@ErrorMessage,16,1)
                END           
				
				  
             IF EXISTS ( SELECT 1
                         FROM   dbo.EDITransactionSets ets
                                JOIN @TransactionSets ts
                                    ON ts.TransactionSetId = ets.EDITransactionSetId
                         WHERE  ets.EDITradingPartnerId IS NULL ) 
                BEGIN
                      DECLARE @MissingTradingPartner VARCHAR(MAX)

                      SELECT    @MissingTradingPartner = ISNULL(@MissingTradingPartner + ', '
                                                                + ets.TransactionSetControlNumber,
                                                                ets.TransactionSetControlNumber)
                      FROM      dbo.EDITransactionSets ets
                                JOIN @TransactionSets ts
                                    ON ts.TransactionSetId = ets.EDITransactionSetId
                      WHERE     ets.EDITradingPartnerId IS NULL   

                      SET @ErrorMessage = 'Unable to determine Trading Partner for Transaction Control Numbers '
                          + ISNULL(@MissingTradingPartner,'') + '. Please Check Interchange sender and receiver.'
                    INSERT INTO dbo.EDIFileErrors
                            (
                             CreatedBy
                            ,CreatedDate
                            ,ModifiedBy
                            ,ModifiedDate
                            ,EDIFileId
                            ,ErrorCode
                            ,ErrorMessage
                            )
                    VALUES  (
                              @CreatedByUserCode-- CreatedBy - type_CurrentUser
                            ,GETDATE()-- CreatedDate - type_CurrentDatetime
                            ,@CreatedByUserCode-- ModifiedBy - type_CurrentUser
                            ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                            ,@EDIFileId -- EDIFileId - int
                            ,NULL-- ErrorCode - varchar(10)
                            ,@ErrorMessage-- ErrorMessage - type_Comment2
                            )
                      --RAISERROR(@ErrorMessage,16,1)
                END     

             IF EXISTS ( SELECT 1
                         FROM   dbo.EDITransactionSets ets
                                JOIN dbo.EDITransactionSetTypes etst
                                    ON ets.EDITransactionSetTypeId = etst.EDITransactionSetTypeId
                                       AND ISNULL(etst.RecordDeleted, 'N') <> 'Y'
                                JOIN dbo.EDITradingPartners etp
                                    ON etp.EDITradingPartnerId = ets.EDITradingPartnerId
                                       AND ISNULL(etp.RecordDeleted, 'N') <> 'Y'
                                JOIN @TransactionSets ts
                                    ON ts.TransactionSetId = ets.EDITransactionSetId
                         WHERE  NOT EXISTS ( SELECT 1
                                             FROM   dbo.EDITransactionTypeProcesses ettp
                                             WHERE  etp.EDITradingPartnerId = ettp.EDITradingPartnerId
                                                    AND etst.EDITransactionSetTypeId = ettp.EDITransactionSetTypeId
                                                    AND ISNULL(ettp.RecordDeleted, 'N') <> 'Y'
                                                    AND ettp.TransactionSetProcessingStoredProcedure IS NOT NULL ) ) 
                BEGIN 
                      DECLARE @MissingProcess VARCHAR(MAX)

                      SELECT    @MissingProcess = ISNULL(@MissingProcess + ' or ' + etst.TransactionSetIdentifierCode
                                                         + '('
                                                         + etst.TransactionSetTypeImplementationConventionReference
                                                         + ') for Trading Partner ' + etp.OrganizationName,
                                                         etst.TransactionSetIdentifierCode + '('
                                                         + etst.TransactionSetTypeImplementationConventionReference
                                                         + ') for Trading Partner ' + etp.OrganizationName)
                      FROM      dbo.EDITransactionSets ets
                                JOIN dbo.EDITransactionSetTypes etst
                                    ON ets.EDITransactionSetTypeId = etst.EDITransactionSetTypeId
                                       AND ISNULL(etst.RecordDeleted, 'N') <> 'Y'
                                JOIN dbo.EDITradingPartners etp
                                    ON etp.EDITradingPartnerId = ets.EDITradingPartnerId
                                       AND ISNULL(etp.RecordDeleted, 'N') <> 'Y'
                                JOIN @TransactionSets ts
                                    ON ts.TransactionSetId = ets.EDITransactionSetId
                      WHERE     NOT EXISTS ( SELECT 1
                                             FROM   dbo.EDITransactionTypeProcesses ettp
                                             WHERE  etp.EDITradingPartnerId = ettp.EDITradingPartnerId
                                                    AND etst.EDITransactionSetTypeId = ettp.EDITransactionSetTypeId
                                                    AND ISNULL(ettp.RecordDeleted, 'N') <> 'Y'
                                                    AND ettp.TransactionSetProcessingStoredProcedure IS NOT NULL )
                      GROUP BY  etst.TransactionSetTypeImplementationConventionReference
                               ,etst.TransactionSetIdentifierCode
                               ,etp.OrganizationName

                      SET @ErrorMessage = 'Could not find processing stored procedure for transaction type '
                          + ISNULL(@MissingProcess,'')
                    INSERT INTO dbo.EDIFileErrors
                            (
                             CreatedBy
                            ,CreatedDate
                            ,ModifiedBy
                            ,ModifiedDate
                            ,EDIFileId
                            ,ErrorCode
                            ,ErrorMessage
                            )
                    VALUES  (
                              @CreatedByUserCode-- CreatedBy - type_CurrentUser
                            ,GETDATE()-- CreatedDate - type_CurrentDatetime
                            ,@CreatedByUserCode-- ModifiedBy - type_CurrentUser
                            ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                            ,@EDIFileId -- EDIFileId - int
                            ,NULL-- ErrorCode - varchar(10)
                            ,@ErrorMessage-- ErrorMessage - type_Comment2
                            )
                      --RAISERROR(@ErrorMessage,16,1)
                END
					 
             DECLARE @TransactionSetId INT
                    ,@TransactionStoredProcedure VARCHAR(MAX)
					  
             DECLARE cur_TransactionSets CURSOR
             FOR
                     SELECT ets.EDITransactionSetId
                           ,ettp.TransactionSetProcessingStoredProcedure
                     FROM   dbo.EDITransactionSets ets
                            JOIN dbo.EDITransactionSetTypes etst
                                ON ets.EDITransactionSetTypeId = etst.EDITransactionSetTypeId
                                   AND ISNULL(etst.RecordDeleted, 'N') <> 'Y'
                            JOIN dbo.EDITradingPartners etp
                                ON etp.EDITradingPartnerId = ets.EDITradingPartnerId
                                   AND ISNULL(etp.RecordDeleted, 'N') <> 'Y'
                            JOIN dbo.EDITransactionTypeProcesses ettp
                                ON etp.EDITradingPartnerId = ettp.EDITradingPartnerId
                                   AND etst.EDITransactionSetTypeId = ettp.EDITransactionSetTypeId
                                   AND ISNULL(ettp.RecordDeleted, 'N') <> 'Y'
                            JOIN @TransactionSets ts ON ts.TransactionSetId = ets.EDITransactionSetId
                     WHERE  ettp.TransactionSetProcessingStoredProcedure IS NOT NULL
  
             OPEN cur_TransactionSets
             FETCH NEXT FROM cur_TransactionSets INTO @TransactionSetId, @TransactionStoredProcedure
	
             WHILE @@Fetch_Status = 0 
                   BEGIN
                         EXEC @TransactionStoredProcedure @TransactionSetId = @TransactionSetId
                         
                         UPDATE dbo.EDITransactionSets SET Processed = 'Y' WHERE EDITransactionSetId = @TransactionSetId
                         FETCH NEXT FROM cur_TransactionSets INTO @TransactionSetId, @TransactionStoredProcedure
                   END      
		
             CLOSE cur_TransactionSets
             DEALLOCATE cur_TransactionSets
       END TRY

       BEGIN CATCH
             IF @@TRANCOUNT > 0 
                ROLLBACK TRAN
			
			DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
            DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName)) 
            DECLARE @ErrorLine VARCHAR(25) = ISNULL(ERROR_LINE(), 0)                
            SET @ErrorMessage = 'Line: ' + @ErrorLine + ' ' + @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + CHAR(13)
            SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') 
                
            RAISERROR (@ErrorMessage,16,1)     
 

       END CATCH
 END

GO 