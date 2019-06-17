INSERT   INTO dbo.SystemConfigurationKeys
         (
           CreatedBy
         , CreateDate
         , ModifiedBy
         , ModifiedDate
         , [Key]
         , Value
         , Description
         , AcceptedValues
         , ShowKeyForViewingAndEditing
         , Modules
         , Screens
         , Comments
         , SourceTableName
         , AllowEdit
         )
         SELECT   'dknewtson' -- CreatedBy - type_CurrentUser
                , GETDATE()-- CreateDate - type_CurrentDatetime
                , 'dknewtson'-- ModifiedBy - type_CurrentUser
                , GETDATE()-- ModifiedDate - type_CurrentDatetime
                , 'SetERAutomaticTransferForSecondaryAdjustWhenClientIsNextPayer'-- Key - varchar(200)
                , 'Y'-- Value - varchar(max)
                , 'When handling remaining balance on secondary/tertiary charges in 835 posting, adjust when the client is the next payer'-- Description - type_Comment2
                , 'Y,N'-- AcceptedValues - varchar(max)
                , 'Y'-- ShowKeyForViewingAndEditing - type_YOrN
                , '835'-- Modules - varchar(500)
                , NULL-- Screens - varchar(500)
                , NULL	-- Comments - type_Comment2
                , NULL-- SourceTableName - varchar(250)
                , 'Y'-- AllowEdit - type_YOrN
         WHERE    NOT EXISTS ( SELECT  1
                               FROM    dbo.SystemConfigurationKeys AS sck
                               WHERE   sck.[Key] = 'SetERAutomaticTransferForSecondaryAdjustWhenClientIsNextPayer' )