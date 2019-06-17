UPDATE a 
SET SortOrder = SortOrder + 1
FROM dbo.ListPageColumnConfigurationColumns AS a
WHERE ISNULL(RecordDeleted,'N')='N'
AND SortOrder IS NOT NULL
AND EXISTS (SELECT 1
			FROM dbo.ListPageColumnConfigurationColumns AS b
			WHERE a.ListPageColumnConfigurationId = b.ListPageColumnConfigurationId
			AND b.SortOrder = 0
			AND ISNULL(b.RecordDeleted,'N')='N'
			)
