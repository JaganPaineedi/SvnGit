INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, [Description], UserDefinedCategory,
                                        HasSubcodes, UsedInPracticeManagement, UsedInCareManagement )
SELECT 'DirectMessageStatus','DirectMessageStatus','Y','N','N','N','Status of direct messages','N','N','N','N'
WHERE NOT EXISTS( SELECT 1
				 FROM dbo.GlobalCodeCategories 
				 WHERE ISNULL(RecordDeleted,'N')='N'
				 AND Category = 'DirectMessageStatus'
				 )

CREATE TABLE #Codes (
CodeName VARCHAR(MAX),
Code VARCHAR(MAX),
SortOrder INT,
[Description] VARCHAR(MAX)
)
INSERT INTO #Codes ( CodeName, Code, SortOrder, [Description] )
SELECT 'New Message','NM',1,''
UNION ALL
SELECT 'Sent','S',2,''
UNION ALL
SELECT 'Received','R',3,''
UNION ALL
SELECT 'Error','E',4,''
UNION ALL 
SELECT 'Sent via Service','SVS',5,''
UNION ALL 
SELECT 'Ready to Send via Service','RSVS',6,''
UNION ALL 
SELECT 'Received via Service','RVS',7,''
UNION ALL 
SELECT 'Deleted via Service','DVS',8,''
UNION ALL 
SELECT 'Deleted','D',9,''
UNION ALL 
SELECT 'Delete via Service','DMVS',9,''

INSERT INTO dbo.GlobalCodes ( Category, CodeName, Code, [Description], Active, CannotModifyNameOrDelete, SortOrder )
SELECT 'DirectMessageStatus',CodeName, Code, [Description],'Y','N',SortOrder
FROM #Codes AS b
WHERE NOT EXISTS( SELECT 1
				 FROM dbo.GlobalCodes AS a
				 WHERE a.Category = 'DirectMessageStatus'
				 AND a.Code = b.Code
				 AND ISNULL(a.RecordDeleted,'N')='N'
				 )
				 
DROP TABLE #Codes				 