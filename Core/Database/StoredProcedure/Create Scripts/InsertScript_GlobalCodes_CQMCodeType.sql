INSERT INTO dbo.GlobalCodeCategories
        ( Category ,
          CategoryName ,
          Active ,
          AllowAddDelete ,
          AllowCodeNameEdit ,
          AllowSortOrderEdit ,
          UserDefinedCategory ,
          HasSubcodes 
		          )
SELECT 'CQMCodeType',
'CQMCodeType',
'Y',
'N',
'N',
'N',
'N',
'N'
WHERE NOT EXISTS ( SELECT 1
					FROM dbo.GlobalCodeCategories
					WHERE Category = 'CQMCodeType'
					AND ISNULL(RecordDeleted,'N')='N')


INSERT INTO dbo.GlobalCodes
        ( 
          Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder ,
          ExternalCode1         )
SELECT 'CQMCodeType',
'CPT',
'CPT',
'Y',
'Y',
1,
'2.16.840.1.113883.6.13'
WHERE NOT EXISTS ( SELECT 1
					FROM dbo.GlobalCodes 
					WHERE Category = 'CQMCodeType'
					AND Code = 'CPT'
					AND ISNULL(RecordDeleted,'N')='N'
					)

INSERT INTO dbo.GlobalCodes
        ( 
          Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder ,
          ExternalCode1         )
SELECT 'CQMCodeType',
'SNOMEDCT',
'SNOMEDCT',
'Y',
'Y',
1,
'2.16.840.1.113883.6.96'
WHERE NOT EXISTS ( SELECT 1
					FROM dbo.GlobalCodes 
					WHERE Category = 'CQMCodeType'
					AND Code = 'SNOMEDCT'
					AND ISNULL(RecordDeleted,'N')='N'
					)
INSERT INTO dbo.GlobalCodes
        ( 
          Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder ,
          ExternalCode1         )
SELECT 'CQMCodeType',
'HCPCS',
'HCPCS',
'Y',
'Y',
1,
'2.16.840.1.113883.6.285'
WHERE NOT EXISTS ( SELECT 1
					FROM dbo.GlobalCodes 
					WHERE Category = 'CQMCodeType'
					AND Code = 'HCPCS'
					AND ISNULL(RecordDeleted,'N')='N'
					)

