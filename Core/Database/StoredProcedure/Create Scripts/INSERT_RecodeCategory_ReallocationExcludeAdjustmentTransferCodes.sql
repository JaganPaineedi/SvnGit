



DECLARE	@CreatedBy VARCHAR(30) = 'dknewtson'

DECLARE	@CategoryCode VARCHAR(100) = 'ReallocationExcludeAdjustmentTransferCodes'
DECLARE	@CategoryName VARCHAR(100) = 'Reallocation Excluded Adjustment Transfer Codes'
DECLARE	@Description VARCHAR(MAX) = 'Adjustment Codes that cause charges to be excluded from Reallocation.'
DECLARE	@MappingEntity VARCHAR(100) = 'GlobalCodes.GlobalCodeId'

IF OBJECT_ID('tempdb..#StoredProcs') IS NOT NULL
	DROP TABLE #StoredProcs

CREATE TABLE #StoredProcs
	(
	  StoredProcedureName VARCHAR(500)
	, Custom CHAR(1)
	, SPDescription VARCHAR(MAX)
	)

INSERT	INTO #StoredProcs
		( StoredProcedureName
		, Custom
		, SPDescription
		)
		SELECT	valtable.StoredProcedureName
			  , valtable.Custom
			  , valtable.Descr
		FROM	( VALUES ( 'ssp_PMRetroactiveChargeReallocation', 'Y', 'Reallocate Charges based on changes in client coverage.') ) valtable ( StoredProcedureName, Custom, Descr ) 
INSERT	INTO dbo.RecodeCategories
		( CreatedBy
		, CreatedDate
		, ModifiedBy
		, ModifiedDate
		, CategoryCode
		, CategoryName
		, Description
		, MappingEntity
		, RecodeType
		, RangeType
		)
		SELECT	@CreatedBy  -- CreatedBy - type_CurrentUser
			  , GETDATE()-- CreatedDate - type_CurrentDatetime
			  , @CreatedBy-- ModifiedBy - type_CurrentUser
			  , GETDATE()-- ModifiedDate - type_CurrentDatetime
			  , @CategoryCode-- CategoryCode - varchar(100)
			  , @CategoryName-- CategoryName - varchar(100)
			  , @Description-- Description - type_Comment2
			  , @MappingEntity-- MappingEntity - varchar(100) 
			  , 8401-- RecodeType - type_GlobalCode
			  , NULL-- RangeType - type_GlobalCode
		WHERE	NOT EXISTS ( SELECT	1
							 FROM	dbo.RecodeCategories rc
							 WHERE	rc.CategoryCode = @CategoryCode )

INSERT	INTO dbo.ApplicationStoredProcedures
		( CreatedBy
		, CreatedDate
		, ModifiedBy
		, ModifiedDate
		, StoredProcedureName
		, CustomStoredProcedure
		, Description
		)
		SELECT	@CreatedBy -- CreatedBy - type_CurrentUser
			  , GETDATE()-- CreatedDate - type_CurrentDatetime
			  , @CreatedBy-- ModifiedBy - type_CurrentUser
			  , GETDATE()-- ModifiedDate - type_CurrentDatetime
			  , sp.StoredProcedureName-- StoredProcedureName - varchar(500)
			  , sp.Custom-- CustomStoredProcedure - type_YOrN
			  , sp.SPDescription-- Description - type_Comment2
		FROM	#StoredProcs sp
		WHERE	NOT EXISTS ( SELECT	1
							 FROM	dbo.ApplicationStoredProcedures asp
							 WHERE	asp.StoredProcedureName = sp.StoredProcedureName )

INSERT	INTO dbo.ApplicationStoredProcedureRecodeCategories
		( CreatedBy
		, CreatedDate
		, ModifiedBy
		, ModifiedDate
		, ApplicationStoredProcedureId
		, RecodeCategoryId
		)
		SELECT	@CreatedBy-- CreatedBy - type_CurrentUser
			  , GETDATE()-- CreatedDate - type_CurrentDatetime
			  , @CreatedBy-- ModifiedBy - type_CurrentUser
			  , GETDATE()-- ModifiedDate - type_CurrentDatetime
			  , asp.ApplicationStoredProcedureId -- ApplicationStoredProcedureId - int
			  , rc.RecodeCategoryId-- RecodeCategoryId - int
		FROM	dbo.RecodeCategories rc
		CROSS JOIN #StoredProcs sp
		JOIN	dbo.ApplicationStoredProcedures asp ON asp.StoredProcedureName = sp.StoredProcedureName
		WHERE	rc.CategoryCode = @CategoryCode
				AND NOT EXISTS ( SELECT	1
								 FROM	dbo.ApplicationStoredProcedureRecodeCategories asprc
								 WHERE	asprc.RecodeCategoryId = rc.RecodeCategoryId
										AND asprc.ApplicationStoredProcedureId = asp.ApplicationStoredProcedureId )