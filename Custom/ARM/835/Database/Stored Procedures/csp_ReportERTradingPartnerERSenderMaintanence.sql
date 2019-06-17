
IF OBJECT_ID('csp_ReportERTradingPartnerERSenderMaintanence') IS NOT NULL 
   DROP PROCEDURE csp_ReportERTradingPartnerERSenderMaintanence
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

CREATE PROCEDURE csp_ReportERTradingPartnerERSenderMaintanence
       @InterchangeSenderIdQualifier VARCHAR(2) = NULL
      ,@InterchangeSenderId VARCHAR(15) = NULL
      ,@InterchangeReceiverIdQualifier VARCHAR(2) = NULL
      ,@InterchangeReceiverId VARCHAR(15) = NULL
      ,@AuthorizationIdQualifier VARCHAR(2) = NULL
      ,@AuthorizationId VARCHAR(10) = NULL
      ,@SecurityInfoQualifier VARCHAR(2) = NULL
      ,@SecurityId VARCHAR(10) = NULL
      ,@OrganizationName VARCHAR(100) = NULL
      ,@TradingPartnerDescription VARCHAR(MAX) = NULL
      ,@ERSenderId INT = NULL
      ,@Action CHAR(1) = 'V' -- 'V' for view, 'A' for Add/Update
      ,@ExecutedByStaffId INT
AS 
       BEGIN
/**************************************************************************************
   Procedure: csp_ReportERTradingPartnerERSenderMaintanence
   
   Streamline Healthcare Solutions, LLC Copyright 2016

   Purpose: Maintain list of EDITradingPartners sending 834s and how they match to ERSenders

   Parameters: 
      

   Output: 
      

   Called By: 
*****************************************************************************************
   Revision History:
   1-FEB-2016 - Dknewtson - Created

*****************************************************************************************/

             BEGIN TRY

                   DECLARE @UserCode VARCHAR(30) 

                   SELECT   @UserCode = UserCode
                   FROM     Staff
                   WHERE    StaffId = @ExecutedByStaffId          

                   DECLARE @Message VARCHAR(MAX) = NULL
  
                   IF @UserCode IS NULL 
                      BEGIN
                            SET @Message = 'Unable to locate executing staff record.'
                            GOTO done                   
                      END                        

                   IF @Action IN ( 'A' )
                      AND ( @InterchangeSenderId IS NULL
                            OR @InterchangeReceiverId IS NULL
                            OR @ERSenderId IS NULL
                          ) 
                      BEGIN
                            SET @Message = 'ER Sender, Interchange Sender and Receiver Id are Requierd.'   
                                
                      END    

                   IF @Message IS NOT NULL 
                      GOTO done                 

                   IF @Action = 'A' 
                      BEGIN
                            DECLARE @RecordToUpdate INT = NULL
                        
                            SELECT  @RecordToUpdate = etp.EDITradingPartnerId
                            FROM    dbo.EDITradingPartners etp
                                    LEFT JOIN dbo.CustomEDITradingPartnersERSenders cetpes
                                        ON etp.EDITradingPartnerId = cetpes.EDITradingPartnerId
                                    LEFT JOIN dbo.ERSenders es
                                        ON cetpes.ERSenderId = es.ERSenderId
                            WHERE   ISNULL(@InterchangeSenderIdQualifier, 'ZZ') = ISNULL(etp.InterchangeSenderIdQualifier,
                                                                                         'ZZ')
                                    AND RTRIM(LTRIM(@InterchangeSenderId)) = etp.InterchangeSenderId
                                    AND ISNULL(@InterchangeReceiverIdQualifier, 'ZZ') = ISNULL(etp.InterchangeReceiverIdQualifier,
                                                                                               'ZZ')
                                    AND RTRIM(LTRIM(@InterchangeReceiverId)) = etp.InterchangeReceiverId
                                    AND ISNULL(@AuthorizationIdQualifier, '00') = ISNULL(etp.AuthorizationIdQualifier,
                                                                                         '00')
                                    AND ISNULL(RTRIM(LTRIM(@AuthorizationId)), '') = ISNULL(etp.AuthorizationId, '')
                                    AND ISNULL(@SecurityInfoQualifier, '') = ISNULL(SecurityInfoQualifier, '00')
                                    AND ISNULL(RTRIM(LTRIM(@SecurityId)), '') = ISNULL(SecurityId, '')   
                                    
                            IF @RecordToUpdate IS NULL 
                               BEGIN
                                     IF @OrganizationName IS NULL
                                        OR @TradingPartnerDescription IS NULL 
                                        BEGIN
                                              SET @Message = 'Organization Name and Trading Partner Description are required when adding a new record'
                                              GOTO done
                                        END

                                     INSERT INTO dbo.EDITradingPartners
                                            ( 
                                             CreatedBy
                                            ,CreatedDate
                                            ,ModifiedBy
                                            ,ModifiedDate
                                            ,OrganizationName
                                            ,Description
                                            ,RecordType
                                            ,AuthorizationIdQualifier
                                            ,AuthorizationId
                                            ,SecurityInfoQualifier
                                            ,SecurityId
                                            ,InterchangeSenderIdQualifier
                                            ,InterchangeSenderId
                                            ,InterchangeReceiverIdQualifier
                                            ,InterchangeReceiverId
                                            )
                                     VALUES ( 
                                             @UserCode  -- CreatedBy - type_CurrentUser
                                            ,GETDATE()-- CreatedDate - type_CurrentDatetime
                                            ,@UserCode-- ModifiedBy - type_CurrentUser
                                            ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                                            ,@OrganizationName -- OrganizationName - varchar(100)
                                            ,@TradingPartnerDescription-- Description - type_Comment2
                                            ,1 -- outbound -- RecordType - type_GlobalCode
                                            ,RTRIM(LTRIM(@AuthorizationIdQualifier))-- AuthorizationIdQualifier - char(2)
                                            ,RTRIM(LTRIM(@AuthorizationId))-- AuthorizationId - char(10)
                                            ,RTRIM(LTRIM(@SecurityInfoQualifier))-- SecurityInfoQualifier - char(2)
                                            ,RTRIM(LTRIM(@SecurityId))-- SecurityId - char(10)
                                            ,RTRIM(LTRIM(@InterchangeSenderIdQualifier))-- InterchangeSenderIdQualifier - char(2)
                                            ,RTRIM(LTRIM(@InterchangeSenderId))-- InterchangeSenderId - char(15)
                                            ,RTRIM(LTRIM(@InterchangeReceiverIdQualifier))-- InterchangeReceiverIdQualifier - char(2)
                                            ,RTRIM(LTRIM(@InterchangeReceiverId))-- InterchangeReceiverId - char(15)
                                             
                                            )         
                                            
                                     DECLARE @EDITradingPartnerId INT = SCOPE_IDENTITY()

                                     INSERT INTO dbo.CustomEDITradingPartnersERSenders
                                            ( 
                                             EDITradingPartnerId
                                            ,CreatedBy
                                            ,CreatedDate
                                            ,ModifiedBy
                                            ,ModifiedDate
                                            ,ERSenderId
                                               
                                            )
                                     VALUES ( 
                                             @EDITradingPartnerId  -- EDITradingPartnerId - int
                                            ,@UserCode-- CreatedBy - type_CurrentUser
                                            ,GETDATE()-- CreatedDate - type_CurrentDatetime
                                            ,@UserCode-- ModifiedBy - type_CurrentUser
                                            ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                                            ,@ERSenderId-- ERSenderId - int
                                               
                                            )
                                                   
                                     INSERT INTO dbo.EDITransactionTypeProcesses
                                             ( CreatedBy
                                             ,CreatedDate
                                             ,ModifiedBy
                                             ,ModifiedDate
                                             ,EDITradingPartnerId
                                             ,EDITransactionSetTypeId
                                             ,TransactionSetProcessingStoredProcedure
                                             )
                                     SELECT @UserCode  -- CreatedBy - type_CurrentUser
                                          ,GETDATE()-- CreatedDate - type_CurrentDatetime
                                          ,@UserCode-- ModifiedBy - type_CurrentUser
                                          ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                                          ,@EDITradingPartnerId-- EDITradingPartnerId - int
                                          ,etst.EDITransactionSetTypeId-- EDITransactionSetTypeId - int
                                          ,'csp_ImportLarge835'-- TransactionSetProcessingStoredProcedure - nvarchar(255)
                                         FROM dbo.EDITransactionSetTypes etst WHERE TransactionSetTypeImplementationConventionReference = '005010X221A1'  
                                                                   
                                     SET @Message = 'Record Succesfully Added.'
                                                 
                                                    
                               END
                            ELSE 
                               BEGIN
                                 
                                     UPDATE etp
                                     SET    OrganizationName = ISNULL(@OrganizationName, OrganizationName)
                                           ,[Description] = ISNULL(@TradingPartnerDescription, [Description])
                                     FROM   dbo.EDITradingPartners etp
                                     WHERE  etp.EDITradingPartnerId = @RecordToUpdate

                                     IF EXISTS ( SELECT 1
                                                 FROM   dbo.CustomEDITradingPartnersERSenders cetpes
                                                 WHERE  cetpes.EDITradingPartnerId = @RecordToUpdate ) 
                                        BEGIN
                                              UPDATE    cetpes
                                              SET       ERSenderId = @ERSenderId
                                              FROM      dbo.CustomEDITradingPartnersERSenders cetpes
                                              WHERE     EDITradingPartnerId = @RecordToUpdate
                                        END
                                     ELSE 
                                        BEGIN
                                              INSERT    INTO dbo.CustomEDITradingPartnersERSenders
                                                        ( 
                                                         EDITradingPartnerId
                                                        ,CreatedBy
                                                        ,CreatedDate
                                                        ,ModifiedBy
                                                        ,ModifiedDate
                                                        ,ERSenderId
                                                        )
                                              VALUES    ( 
                                                         @RecordToUpdate  -- EDITradingPartnerId - int
                                                        ,@UserCode-- CreatedBy - type_CurrentUser
                                                        ,GETDATE()-- CreatedDate - type_CurrentDatetime
                                                        ,@UserCode-- ModifiedBy - type_CurrentUser
                                                        ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                                                        ,@ERSenderId-- ERSenderId - int
                                                        )                                     
                                        END                                 

                               END                             
                                            
                      END    

-- Current Settings

                   done:

                   SELECT   etp.OrganizationName
                           ,etp.Description
                           ,ISNULL(es.SenderName, 'NONE SELECTED') AS ERSenderName
                           ,ISNULL(etp.InterchangeSenderIdQualifier, 'ZZ') AS InterchangeSenderIdQualifier
                           ,etp.InterchangeSenderId
                           ,ISNULL(etp.InterchangeReceiverIdQualifier, 'ZZ') AS InterchangeReceiverIdQualifier
                           ,etp.InterchangeReceiverId
                           ,ISNULL(etp.AuthorizationIdQualifier, '00') AS AuthorizationIdQualifier
                           ,ISNULL(etp.AuthorizationId, '') AS AuthorizationId
                           ,ISNULL(etp.SecurityInfoQualifier, '00') AS SecurityInfoQualifier
                           ,ISNULL(etp.SecurityId, '') AS SecurityId
                           ,ISNULL(@Message, 'Current Settings Listed') AS [Message]
                   INTO     #Report
                   FROM     dbo.EDITradingPartners etp
                            LEFT JOIN dbo.CustomEDITradingPartnersERSenders cetpes
                                ON etp.EDITradingPartnerId = cetpes.EDITradingPartnerId
                                   AND ISNULL(cetpes.RecordDeleted, 'N') <> 'Y'
                            LEFT JOIN dbo.ERSenders es
                                ON cetpes.ERSenderId = es.ERSenderId
                                   AND ISNULL(es.RecordDeleted, 'N') <> 'Y'
                   WHERE    ( @InterchangeSenderIdQualifier IS NULL
                              OR @InterchangeSenderIdQualifier = ISNULL(etp.InterchangeSenderIdQualifier, 'ZZ')
                            )
                            AND ( @InterchangeSenderId IS NULL
                                  OR RTRIM(LTRIM(@InterchangeSenderId)) = RTRIM(LTRIM(etp.InterchangeSenderId))
                                )
                            AND ( @InterchangeReceiverIdQualifier IS NULL
                                  OR @InterchangeReceiverIdQualifier = ISNULL(etp.InterchangeReceiverIdQualifier, 'ZZ')
                                )
                            AND ( @InterchangeReceiverId IS NULL
                                  OR RTRIM(LTRIM(@InterchangeReceiverId)) = RTRIM(LTRIM(etp.InterchangeReceiverId))
                                )
                            AND ( @AuthorizationIdQualifier IS NULL
                                  OR @AuthorizationIdQualifier = ISNULL(etp.AuthorizationIdQualifier, '00')
                                )
                            AND ( @AuthorizationId IS NULL
                                  OR RTRIM(LTRIM(@AuthorizationId)) = ISNULL(etp.AuthorizationId, '')
                                )
                            AND ( @SecurityInfoQualifier IS NULL
                                  OR @SecurityInfoQualifier = ISNULL(etp.SecurityInfoQualifier, '00')
                                )
                            AND ( @SecurityId IS NULL
                                  OR RTRIM(LTRIM(@SecurityId)) = ISNULL(etp.SecurityId, '')
                                )
                            AND ( @ERSenderId IS NULL
                                  OR cetpes.ERSenderId = @ERSenderId
                                )
                            AND ISNULL(etp.RecordDeleted, 'N') <> 'Y'
                    
                   IF NOT EXISTS ( SELECT   1
                                   FROM     #Report ) 
                      BEGIN
                            SELECT  '' AS OrganizationName
                                   ,'' AS Description
                                   ,'' AS ERSenderName
                                   ,'' AS InterchangeSenderIdQualifier
                                   ,'' AS InterchangeSenderId
                                   ,'' AS InterchangeReceiverIdQualifier
                                   ,'' AS InterchangeReceiverId
                                   ,'' AS AuthorizationIdQualifier
                                   ,'' AS AuthorizationId
                                   ,'' AS SecurityInfoQualifier
                                   ,'' AS SecurityId
                                   ,ISNULL(@Message, 'No Records found') AS [Message]                
                      END
                   ELSE 
                      BEGIN
                            SELECT  *
                            FROM    #Report r                
                      END
                      
             END TRY
             BEGIN CATCH

                   IF @@TRANCOUNT <> 0 
                      ROLLBACK TRAN
   
                   EXEC dbo.ssp_SQLErrorHandler

             END CATCH

                           

       END
GO


