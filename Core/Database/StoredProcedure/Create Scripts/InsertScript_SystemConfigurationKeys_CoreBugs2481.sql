INSERT INTO dbo.SystemConfigurationKeys ( [Key], Value, [Description],
                                           AcceptedValues, ShowKeyForViewingAndEditing
										)
SELECT 'EnableSummaryofCareUnsecureEmail',
'N',
'Allow Summary of Care documents to be sent via unsecure email',
'Y,N',
'Y'
WHERE NOT EXISTS( SELECT 1
			   FROM dbo.SystemConfigurationKeys AS a
			   WHERE ISNULL(a.RecordDeleted,'N')='N'
			   AND a.[Key] = 'EnableSummaryofCareUnsecureEmail'
			  ) 
