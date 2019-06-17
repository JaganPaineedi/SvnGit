/*******************************************************************************
* Insert new global codes
*******************************************************************************/

DECLARE @Category VARCHAR(20) = 'WBCompetencyStatus'
INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, UserDefinedCategory )
SELECT @Category,'WhiteBoardCompetencyStatus','Y','Y','Y','Y','N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.GlobalCodeCategories AS a
				  WHERE a.Category = @Category
				  AND ISNULL(a.RecordDeleted,'N')='N'
				  )
DECLARE @Category2 VARCHAR(20) = 'WBLegalStatus'
INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, UserDefinedCategory )
SELECT @Category2,'WhiteBoardLegalStatus','Y','Y','Y','Y','N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.GlobalCodeCategories AS a
				  WHERE a.Category = @Category2
				  AND ISNULL(a.RecordDeleted,'N')='N'
				  )

SELECT @Category AS Category,'Competent' AS CodeName,'C' AS Code,1 AS SortOrder
INTO #NewCodes
UNION ALL
SELECT @Category AS Category,'Incompetent' AS CodeName,'I' AS Code,2 AS SortOrder
UNION ALL 
SELECT @Category AS Category,'New Admission' AS CodeName,'NA' AS Code,3 AS SortOrder
UNION ALL
SELECT @Category2 AS Category,'Voluntary' AS CodeName,'Voluntary' AS Code,1 AS SortOrder
UNION ALL
SELECT @Category2 AS Category,'Involuntary' AS CodeName,'Involuntary' AS Code,2 AS SortOrder

INSERT INTO dbo.GlobalCodes ( Category, CodeName, Code, 
                               Active, CannotModifyNameOrDelete, SortOrder)
SELECT Category, CodeName, Code,'Y','N', SortOrder FROM #NewCodes AS a
WHERE NOT EXISTS ( SELECT 1
				   FROM GlobalCodes AS b
				   WHERE b.Category = a.Category
				   AND b.Code = a.Code
				   AND ISNULL(b.RecordDeleted,'N')='N'
				   )
