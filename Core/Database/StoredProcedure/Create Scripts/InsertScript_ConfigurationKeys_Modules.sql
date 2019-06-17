CREATE TABLE #KeysToFix (
      [Key] VARCHAR(MAX)
    , CorrectName VARCHAR(MAX)
    );
INSERT  INTO #KeysToFix ( [Key], CorrectName )
SELECT  'DirectMessageRetieveListURL', 'DirectMessageRetrieveListUrl'
UNION ALL
SELECT  'DirectMessageRetieveURL', 'DirectMessageRetrieveUrl'
UNION ALL
SELECT  'DirectMessageAttachmentRetieveURL', 'DirectMessageRetrieveAttachmentUrl'
UNION ALL
SELECT  'DirectMessageUploadeAttachmentURL', 'DirectMessageUploadAttachmentUrl'
UNION ALL
SELECT  'DirectMessageSendURL', 'DirectMessageSendUrl';

CREATE TABLE #NewKeys (
      [Key] VARCHAR(MAX)
    , Value VARCHAR(MAX)
    , [Description] VARCHAR(MAX)
    );
INSERT  INTO #NewKeys ( [Key], Value, [Description] )
SELECT  'DirectMessageSmartcarePollingTime', '60', 'Number of seconds between each processing period'
UNION ALL
SELECT  'DirectMessageHISPPollingTime', '60', 'Number of seconds between each processing period'
UNION ALL
SELECT 'DirectMessageDeleteUrl', 'https://direct.sandbox.rosettahealth.net/MailManagement/ws/v3/remove/message',
		'Direct Message HISP API Delete Url'
UNION ALL 
SELECT 'DirectUserAccountCreateUrl','https://direct.sandbox.rosettahealth.net/AccountManagement/ws/v2/mail',''
UNION ALL
SELECT 'DirectUserAccountUpdateUrl','https://direct.sandbox.rosettahealth.net/AccountManagement/ws/v2/mail',''
UNION ALL
SELECT 'DirectUserAccountRemoveUrl','https://direct.sandbox.rosettahealth.net/AccountManagement/ws/v2/mail',''
UNION ALL
SELECT 'DirectUserAccountGetUrl','https://direct.sandbox.rosettahealth.net/AccountManagement/ws/v2/mail',''

--Remove Key that was spelled incorrectly
UPDATE  a
SET     a.[Key] = b.CorrectName, a.Modules = 'DirectMessaging'
FROM    dbo.SystemConfigurationKeys AS a
JOIN    #KeysToFix AS b ON a.[Key] = b.[Key]
WHERE   ISNULL(a.RecordDeleted, 'N') = 'N';

--create new keys
INSERT  INTO dbo.SystemConfigurationKeys ( [Key], Value, Description, AcceptedValues, ShowKeyForViewingAndEditing, Modules, Screens, Comments, SourceTableName,
                                           AllowEdit )
SELECT  [Key], Value, Description, NULL, 'N', 'DirectMessaging', NULL, NULL, NULL, 'N'
FROM    #NewKeys
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.SystemConfigurationKeys AS a
				  WHERE a.[Key] = #NewKeys.[Key]
				  )

DECLARE @ModuleId INT;
---Create Module and Modules Screen entries
INSERT  INTO dbo.Modules ( ModuleName )
SELECT  'Direct Messaging'
WHERE   NOT EXISTS ( SELECT 1
                     FROM   dbo.Modules AS m
                     WHERE  m.ModuleName = 'Direct Messaging'
                            AND ISNULL(m.RecordDeleted, 'N') = 'N' );


 SELECT @ModuleId = m.ModuleId
FROM   dbo.Modules AS m
WHERE  m.ModuleName = 'Direct Messaging'
    AND ISNULL(m.RecordDeleted, 'N') = 'N'


INSERT  INTO dbo.ModuleScreens ( ModuleId, ScreenId )
SELECT  @ModuleId, 890 
	WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 890
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)
UNION ALL
SELECT  @ModuleId, 891 	
WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 891
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)
UNION ALL
SELECT  @ModuleId, 892 
	WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 892
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)
UNION ALL
SELECT  @ModuleId, 893 
	WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 893
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)
UNION ALL
SELECT  @ModuleId, 894 
	WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 894
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)
UNION ALL
SELECT  @ModuleId, 896 
	WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 896
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)
UNION ALL
SELECT  @ModuleId, 897 
	WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 897
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)
UNION ALL
SELECT  @ModuleId, 898 
	WHERE NOT EXISTS ( SELECT 1
						FROM dbo.ModuleScreens AS ms
						WHERE ms.ModuleId = @ModuleId
						AND ms.ScreenId = 898
						AND ISNULL(ms.RecordDeleted,'N')='N'
						)

DROP TABLE #KeysToFix
DROP TABLE #NewKeys
