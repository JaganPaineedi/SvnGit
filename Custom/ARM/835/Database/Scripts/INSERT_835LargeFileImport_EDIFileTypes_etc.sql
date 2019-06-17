


INSERT  INTO dbo.EDIFileTypes
        ( 
         CreatedBy
        ,CreatedDate
        ,ModifiedBy
        ,ModifiedDate
        ,FileTypeName
        ,FileTypeDesc
        ,FileExtension
        )
        SELECT  'dknewtson'  -- CreatedBy - type_CurrentUser
               ,GETDATE()-- CreatedDate - type_CurrentDatetime
               ,'dknewtson'-- ModifiedBy - type_CurrentUser
               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               ,'835-1'-- FileTypeName - nvarchar(25)
               ,'Health Care Claim Payment/Advice (835)'-- FileTypeDesc - nvarchar(max)
               ,'*.835'-- FileExtension - nvarchar(max)
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.EDIFileTypes eft
                             WHERE  eft.FileExtension = '*.835' )
        UNION ALL
        SELECT  'dknewtson'  -- CreatedBy - type_CurrentUser
               ,GETDATE()-- CreatedDate - type_CurrentDatetime
               ,'dknewtson'-- ModifiedBy - type_CurrentUser
               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               ,'835-2'-- FileTypeName - nvarchar(25)
               ,'Health Care Claim Payment/Advice (835)'-- FileTypeDesc - nvarchar(max)
               ,'*.era'-- FileExtension - nvarchar(max)
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.EDIFileTypes eft
                             WHERE  eft.FileExtension = '*.era' )


INSERT  INTO dbo.EDITransactionSetTypes
        ( 
         CreatedBy
        ,CreatedDate
        ,ModifiedBy
        ,ModifiedDate
        ,TransactionSetIdentifierCode
        ,TransactionSetTypeImplementationConventionReference
        ,TransactionSetTypeDescription
           
        )
        SELECT  'dknewtson'  -- CreatedBy - type_CurrentUser
               ,GETDATE()-- CreatedDate - type_CurrentDatetime
               ,'dknewtson'-- ModifiedBy - type_CurrentUser
               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               ,'835'-- TransactionSetIdentifierCode - nvarchar(25)
               ,'005010X221A1' --TransactionSetTypeImplementationConventionReference - varchar(35)
               ,'Health Care Claim Payment/Advice (835)'-- TransactionSetTypeDescription - type_Comment2
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.EDITransactionSetTypes etst
                             WHERE  etst.TransactionSetTypeImplementationConventionReference = '005010X221A1' )

--INSERT  INTO dbo.CustomEDITradingPartnersERSenders
--        ( 
--         EDITradingPartnerId
--        ,CreatedBy
--        ,CreatedDate
--        ,ModifiedBy
--        ,ModifiedDate
--        ,ERSenderId
--        )
--        SELECT  valtable.EDITradingPartnerId-- EDITradingPartnerId - int
--               ,'dknewtson'-- CreatedBy - type_CurrentUser
--               ,GETDATE()-- CreatedDate - type_CurrentDatetime
--               ,'dknewtson'-- ModifiedBy - type_CurrentUser
--               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
--               ,valtable.ERSenderId -- ERSenderId - int
--        FROM    ( VALUES ( 1, 5), ( 2, 7), ( 3, 7) ) AS valtable ( EDITradingPartnerId, ERSenderid ) 
--        WHERE   NOT EXISTS ( SELECT 1
--                             FROM   dbo.CustomEDITradingPartnersERSenders cetpes
--                             WHERE  cetpes.EDITradingPartnerId = valtable.EDITradingPartnerId )


--INSERT  INTO dbo.EDITransactionTypeProcesses
--        ( 
--         CreatedBy
--        ,CreatedDate
--        ,ModifiedBy
--        ,ModifiedDate
--        ,EDITradingPartnerId
--        ,EDITransactionSetTypeId
--        ,TransactionSetProcessingStoredProcedure
--        )
--        SELECT  'dknewtson' -- CreatedBy - type_CurrentUser
--               ,GETDATE()-- CreatedDate - type_CurrentDatetime
--               ,'dknewtson'-- ModifiedBy - type_CurrentUser
--               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
--               ,etp.EDITradingPartnerId-- EDITradingPartnerId - int
--               ,etst.EDITransactionSetTypeId-- EDITransactionSetTypeId - int
--               ,'csp_ImportLarge835'-- TransactionSetProcessingStoredProcedure - nvarchar(255)
--        FROM    dbo.EDITransactionSetTypes etst
--                CROSS JOIN dbo.EDITradingPartners etp
--        WHERE   TransactionSetTypeImplementationConventionReference = '005010X221A1'


INSERT INTO dbo.SystemConfigurationKeys
        ( CreatedBy
        ,CreateDate
        ,ModifiedBy
        ,ModifiedDate
        ,[Key]
        ,Value
        ,Description
        ,AcceptedValues
        ,ShowKeyForViewingAndEditing
        ,Modules
        ,Screens
        ,Comments
        )
SELECT 'dknewtson'  -- CreatedBy - type_CurrentUser
       ,GETDATE()-- CreateDate - type_CurrentDatetime
       ,'dknewtson'-- ModifiedBy - type_CurrentUser
       ,GETDATE()-- ModifiedDate - type_CurrentDatetime  
       ,'XAUTOMATIC835UPLOADUSERCODE'-- Key - varchar(200)
       ,'admin'-- Value - varchar(max)
       ,'User code used when uploading 835 files from through the EDIUpload process'-- Description - type_Comment2
       ,'Staff.UserCode'-- AcceptedValues - varchar(max)
       ,'Y'-- ShowKeyForViewingAndEditing - type_YOrN
       ,'835'-- Modules - varchar(500)
       ,'None'-- Screens - varchar(500)
       ,NULL-- Comments - type_Comment2
      WHERE NOT EXISTS (SELECT 1 FROM dbo.SystemConfigurationKeys sck WHERE [key] = 'XAUTOMATIC835UPLOADUSERCODE')
        
