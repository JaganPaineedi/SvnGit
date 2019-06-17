INSERT INTO dbo.SystemConfigurationKeys ( [Key], Value, Description,
                                           AcceptedValues, ShowKeyForViewingAndEditing, Modules, Screens, Comments, SourceTableName, AllowEdit )
SELECT 'EnableBundlingMinification','true','Enables or disables bundling and minification of javascript and style sheet files.','true,false','Y',NULL,NULL,NULL,NULL,'Y'
WHERE NOT EXISTS ( SELECT 1
				   FROM dbo.SystemConfigurationKeys AS a
				   WHERE a.[Key] = 'EnableBundlingMinification'
				   AND ISNULL(a.RecordDeleted,'N')='N'
				 )