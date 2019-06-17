INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, [Description], UserDefinedCategory,
                                        HasSubcodes, UsedInPracticeManagement, UsedInCareManagement)
SELECT 'DirectMessageActions','DirectMessageActions','Y','N','Y','Y','Actions that can be performed on the Direct Messages list page.','N','N','N','N'
WHERE NOT EXISTS( SELECT 1
				 FROM dbo.GlobalCodeCategories 
				 WHERE ISNULL(RecordDeleted,'N')='N'
				 AND Category = 'DirectMessageActions'
				 )

CREATE TABLE #Actions (
CodeName VARCHAR(MAX),
Code VARCHAR(MAX),
SortOrder INT,
[Description] VARCHAR(MAX)
)
INSERT INTO #Actions ( CodeName, Code, SortOrder, [Description] )
SELECT 'Delete message(s)','Delete',3,'Record Delete the selected direct messages'
UNION ALL
SELECT 'Mark as read','MarkAsRead',2,'Mark selected direct messages are read'
UNION ALL
SELECT 'Mark as unread','MarkAsUnread',1,'Mark the selected direct messages as unread'

INSERT INTO dbo.GlobalCodes ( Category, CodeName, Code, [Description], Active, CannotModifyNameOrDelete, SortOrder )
SELECT 'DirectMessageActions',CodeName, Code, [Description],'Y','N',SortOrder
FROM #Actions AS b
WHERE NOT EXISTS( SELECT 1
				 FROM dbo.GlobalCodes AS a
				 WHERE a.Category = 'DirectMessageActions'
				 AND a.Code = b.Code
				 AND ISNULL(a.RecordDeleted,'N')='N'
				 )
				 
DROP TABLE #Actions