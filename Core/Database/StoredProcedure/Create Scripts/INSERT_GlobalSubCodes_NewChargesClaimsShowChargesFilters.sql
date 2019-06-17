


DECLARE	@GlobalCodeId INT = 6255
DECLARE	@UserCode VARCHAR(30)= 'dknewtson'

DECLARE	@GlobalSubCodes TABLE
	(
	  GlobalSubCodeId INT
	, SubCodeName VARCHAR(250)
	, Descr VARCHAR(MAX)
	, SortOrder INT
	)

INSERT	INTO @GlobalSubCodes
		( GlobalSubCodeId, SubCodeName, Descr, SortOrder )
VALUES	( 586-- GlobalSubCodeId - int
		  , 'Show charges to be voided'-- SubCodeName - varchar(250)
		  , 'Charges with to Be Voided Claim Line Items' -- Descr - varchar(max)
		  , 8-- SortOrder - int
		  ),
		( 587 -- GlobalSubCodeId - int
		  , 'Show unbilled and to be voided charges'-- SubCodeName - varchar(250)
		  , 'Unbilled charges and Charges with to be voided claim line items'-- Descr - varchar(max)
		  , 9-- SortOrder - int
		  ),
		( 588 -- GlobalSubCodeId - int
		  , 'Show unbilled, rebill and to be voided'-- SubCodeName - varchar(250)
		  , 'Unbilled charges, rebill charges, and charges with to be voided claim line items'-- Descr - varchar(max)
		  , 10-- SortOrder - int
		  )

UPDATE	gsc
SET		gsc.SortOrder = gsc.SortOrder + ( SELECT COUNT (*) FROM @GlobalSubCodes AS gsc3
										)
FROM	dbo.GlobalSubCodes AS gsc
JOIN	@GlobalSubCodes AS gsc2 ON gsc2.SortOrder = gsc.SortOrder
								   AND gsc2.SubCodeName <> gsc.SubCodeName
WHERE	gsc.GlobalCodeId = @GlobalCodeId
		

DELETE	FROM dbo.GlobalSubCodes
WHERE	GlobalCodeId = @GlobalCodeId
		AND SubCodeName = 'Charges With To Be Voided Claims'


SET IDENTITY_INSERT dbo.GlobalSubCodes ON 

INSERT	INTO dbo.GlobalSubCodes
		( GlobalSubCodeId
		, GlobalCodeId
		, SubCodeName
		, Code
		, Description
		, Active
		, CannotModifyNameOrDelete
		, SortOrder
		, RowIdentifier
		, CreatedBy
		, CreatedDate
		, ModifiedBy
		, ModifiedDate
		)
		SELECT	gsc.GlobalSubCodeId -- GlobalCodeId - int
			  , @GlobalCodeId
			  , gsc.SubCodeName-- SubCodeName - varchar(250)
			  , NULL-- Code - varchar(100)
			  , gsc.Descr-- Description - type_Comment
			  , 'Y'-- Active - type_Active
			  , 'N'-- CannotModifyNameOrDelete - type_YOrN
			  , gsc.SortOrder-- SortOrder - int
			  , NEWID() -- RowIdentifier - type_GUID
			  , @UserCode-- CreatedBy - type_CurrentUser
			  , GETDATE()-- CreatedDate - type_CurrentDatetime
			  , @UserCode-- ModifiedBy - type_CurrentUser
			  , GETDATE()-- ModifiedDate - type_CurrentDatetime
		FROM	@GlobalSubCodes AS gsc
		WHERE	NOT EXISTS ( SELECT	1
							 FROM	dbo.GlobalSubCodes AS gsc2
							 WHERE	gsc2.SubCodeName = gsc.SubCodeName )


SET IDENTITY_INSERT dbo.GlobalSubCodes OFF