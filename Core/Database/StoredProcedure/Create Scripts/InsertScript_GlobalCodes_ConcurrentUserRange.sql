INSERT INTO dbo.GlobalCodeCategories (Category,
                                      CategoryName,
                                      Active,
                                      AllowAddDelete,
                                      AllowCodeNameEdit,
                                      AllowSortOrderEdit,
                                      Description,
                                      UserDefinedCategory,
                                      HasSubcodes,
                                      UsedInPracticeManagement,
                                      UsedInCareManagement)
SELECT 'ConcurrentUserRange',
       'ConcurrentUserRange',
       'Y',
       'Y',
       'Y',
       'Y',
       '',
       'N',
       'N',
       'N',
       'N'
 WHERE NOT EXISTS (SELECT 1
                     FROM dbo.GlobalCodeCategories
                    WHERE Category                   = 'ConcurrentUserRange'
                      AND ISNULL(RecordDeleted, 'N') = 'N');


CREATE TABLE #Codes (
    CodeName VARCHAR(MAX),
    Code VARCHAR(MAX),
    Description VARCHAR(MAX),
    SortOrder VARCHAR(MAX),
    ExternalCode1 VARCHAR(MAX),
    ExternalCode2 VARCHAR(MAX));
INSERT INTO #Codes (CodeName,
                    Code,
                    Description,
                    SortOrder,
                    ExternalCode1,
                    ExternalCode2)
SELECT 'Today',
       'D',
       '',
       1,
       '0',
       '0'
UNION ALL
SELECT 'Yesterday',
       'D',
       '',
       2,
       '1',
       '1'
UNION ALL
SELECT 'Past Week',
       'D',
       '',
       3,
       '0',
       '7'
UNION ALL
SELECT 'Last 2 Weeks',
       'D',
       '',
       4,
       '0',
       '14'
UNION ALL
SELECT 'This Month',
       'M',
       '',
       5,
       '0',
       '0'
UNION ALL
SELECT 'Last Month',
       'M',
       '',
       6,
       '1',
       '0'
UNION ALL
SELECT 'Current Year',
       'Y',
       '',
       7,
       '0',
       NULL
UNION ALL
SELECT 'Last Year',
       'Y',
       '',
       8,
       '1',
       NULL;

INSERT INTO dbo.GlobalCodes (Category,
                             CodeName,
                             Code,
                             Description,
                             Active,
                             CannotModifyNameOrDelete,
                             SortOrder,
                             ExternalCode1,
                             ExternalCode2)
SELECT 'ConcurrentUserRange',
       a.CodeName,
       a.Code,
       a.Description,
       'Y',
       'N',
       a.SortOrder,
       a.ExternalCode1,
       a.ExternalCode2
  FROM #Codes AS a
 WHERE NOT EXISTS (SELECT 1
                     FROM GlobalCodes AS b
                    WHERE a.CodeName                   = b.CodeName
                      AND b.Category                   = 'ConcurrentUserRange'
                      AND ISNULL(b.RecordDeleted, 'N') = 'N');

DROP TABLE #Codes;
GO