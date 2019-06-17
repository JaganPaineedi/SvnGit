


INSERT  INTO dbo.GlobalCodes
        ( 
         CreatedBy
        ,CreatedDate
        ,ModifiedBy
        ,ModifiedDate
        ,Category
        ,CodeName
        ,Code
        ,Description
        ,Active
        ,CannotModifyNameOrDelete
        ,SortOrder
        )
        SELECT  'dknewtson'-- CreatedBy - type_CurrentUser
               ,GETDATE()-- CreatedDate - type_CurrentDatetime
               ,'dknewtson'-- ModifiedBy - type_CurrentUser
               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               ,'ADJUSTMENTCODE'-- Category - char(20)
               ,'Correction Charge'-- CodeName - varchar(250)
               ,'Correction Charge'-- Code - varchar(100)
               ,'Balancing adjustments for secondary EOBs.'-- Description - type_Comment
               ,'Y'-- Active - type_Active
               ,'N'-- CannotModifyNameOrDelete - type_YOrN
               ,NULL-- SortOrder - int
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.GlobalCodes gc
                             WHERE  Category = 'ADJUSTMENTCODE'
                                    AND CodeName = 'Correction Charge' )

DELETE  FROM dbo.SystemConfigurationKeys
WHERE   [key] IN ( 'FALSECHARGEADJUSTMENTCODE', 'ELECTRONICREMITTANCEVERBOSEMODE' )

INSERT  INTO dbo.SystemConfigurationKeys
        ( 
         CreatedBy
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
        SELECT  'dknewtson'  -- CreatedBy - type_CurrentUser
               ,GETDATE()-- CreateDate - type_CurrentDatetime
               ,'dknewtson'-- ModifiedBy - type_CurrentUser
               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               ,'ELECTRONICREMITTANCEVERBOSEMODE'-- Key - varchar(200)
               ,'N'-- Value - varchar(max)
               ,'Turn on or off posting all adjustments as a part of electronic remittance.'-- Description - type_Comment2
               ,'Y,N'-- AcceptedValues - varchar(max)
               ,'Y'-- ShowKeyForViewingAndEditing - type_YOrN
               ,'835'-- Modules - varchar(500)
               ,'Payments/Adjustments'-- Screens - varchar(500)
               ,NULL-- Comments - type_Comment2
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.SystemConfigurationKeys sck
                             WHERE  [Key] = 'ELECTRONICREMITTANCEVERBOSEMODE' )

INSERT  INTO dbo.SystemConfigurationKeys
        ( 
         CreatedBy
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
        SELECT  'dknewtson'  -- CreatedBy - type_CurrentUser
               ,GETDATE()-- CreateDate - type_CurrentDatetime
               ,'dknewtson'-- ModifiedBy - type_CurrentUser
               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               ,'FALSECHARGEADJUSTMENTCODE'-- Key - varchar(200)
               ,gc.GlobalCodeId-- Value - varchar(max)
               ,'GlobalCode for Verbose Mode false charges'-- Description - type_Comment2
               ,'GlobalCodes of Category ADJUSTMENTCODE'-- AcceptedValues - varchar(max)
               ,'N'-- ShowKeyForViewingAndEditing - type_YOrN
               ,'835'-- Modules - varchar(500)
               ,'Payments/Adjustments'-- Screens - varchar(500)
               ,NULL-- Comments - type_Comment2
        FROM    dbo.GlobalCodes gc
        WHERE   gc.Category = 'ADJUSTMENTCODE'
                AND CodeName = 'Correction Charge'
                AND NOT EXISTS ( SELECT 1
                                 FROM   dbo.SystemConfigurationKeys sck
                                 WHERE  [Key] = 'FALSECHARGEADJUSTMENTCODE' )
