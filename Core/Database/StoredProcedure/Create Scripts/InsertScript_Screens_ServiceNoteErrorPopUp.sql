IF NOT EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=2220)
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO dbo.Screens
        (ScreenId, 
		CreatedBy ,
          CreatedDate ,
          ModifiedBy ,
          ModifiedDate ,
          RecordDeleted ,
          DeletedBy ,
          DeletedDate ,
          ScreenName ,
          ScreenType ,
          ScreenURL ,
          ScreenToolbarURL ,
          TabId ,
          InitializationStoredProcedure ,
          ValidationStoredProcedureUpdate ,
          ValidationStoredProcedureComplete ,
          WarningStoredProcedureComplete ,
          PostUpdateStoredProcedure ,
          RefreshPermissionsAfterUpdate ,
          DocumentCodeId ,
          CustomFieldFormId ,
          HelpURL ,
          MessageReferenceType ,
          PrimaryKeyName ,
          WarningStoreProcedureUpdate ,
          KeyPhraseCategory ,
          ScreenParamters
        )
VALUES  ( 2220,
          'SHS' , -- CreatedBy - type_CurrentUser
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'SHS' , -- ModifiedBy - type_CurrentUser
          GETDATE() , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedBy - type_UserId
          GETDATE() , -- DeletedDate - datetime
          'ServiceNoteErrorPopUp' , -- ScreenName - varchar(100)
          5765 , -- ScreenType - type_GlobalCode
          '/ActivityPages/Client/Detail/ServiceNote/ServiceNoteErrorPopUp.ascx' , -- ScreenURL - varchar(200)
          NULL , -- ScreenToolbarURL - varchar(200)
          2 , -- TabId - int
          NULL , -- InitializationStoredProcedure - varchar(100)
          NULL , -- ValidationStoredProcedureUpdate - varchar(100)
          NULL , -- ValidationStoredProcedureComplete - varchar(100)
          NULL , -- WarningStoredProcedureComplete - varchar(100)
          NULL , -- PostUpdateStoredProcedure - varchar(100)
          NULL , -- RefreshPermissionsAfterUpdate - type_YOrN
          null , -- DocumentCodeId - int
          NULL , -- CustomFieldFormId - int
          NULL , -- HelpURL - varchar(1000)
          NULL , -- MessageReferenceType - type_GlobalCode
          NULL , -- PrimaryKeyName - varchar(100)
          NULL , -- WarningStoreProcedureUpdate - varchar(100)
          NULL , -- KeyPhraseCategory - type_GlobalCode
          NULL  -- ScreenParamters - varchar(max)
        )
SET IDENTITY_INSERT Screens OFF
END