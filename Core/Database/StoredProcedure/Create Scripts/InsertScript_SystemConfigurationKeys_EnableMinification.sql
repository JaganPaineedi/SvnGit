INSERT INTO dbo.SystemConfigurationKeys ( [Key], Value, Description,
                                           AcceptedValues, ShowKeyForViewingAndEditing, Modules, Screens, Comments, SourceTableName, AllowEdit )
SELECT 'EnableMinification','false','Enables or disables minification of javascript and style sheet files, this allows you to still bundle the files but stop the system from minifying them.','true,false','Y',NULL,NULL,NULL,NULL,'Y'
WHERE NOT EXISTS ( SELECT 1
				   FROM dbo.SystemConfigurationKeys AS a
				   WHERE a.[Key] = 'EnableMinification'
				   AND ISNULL(a.RecordDeleted,'N')='N'
				 )