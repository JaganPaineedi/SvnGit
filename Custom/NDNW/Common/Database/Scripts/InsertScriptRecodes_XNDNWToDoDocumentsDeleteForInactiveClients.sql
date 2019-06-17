
/*******************************************************************************

Script:		InsertScriptRecodes_XNDNWToDoDocumentsDeleteForInactiveClients.sql

Purpose:	Creates recode to identify Documents created by the automated process.

  Date				Author			Purpose
Sep 19, 2018		jstedman		Created ; New Directions Enh 848

********************************************************************************/

DECLARE @categoryCode varchar(100) = 'XNDNWToDoDocumentsDeleteForInactiveClients';
DECLARE @categoryName varchar(100) = 'New Directions NW To Do documents Delete for Inactive Clients';
DECLARE @description varchar(8000) = 'Identity To Do documents to delete whose Clients have become inactive';
DECLARE @fromDate datetime = '01/01/1970'
DECLARE @currDate datetime = GETDATE();
DECLARE @createdBy varchar(30) = 'New Directions Enh 848'

--BEGIN TRAN;

EXEC [dbo].[ssp_RecodesCategoryCreateUpdate]
	@CATEGORYCODE=@categoryCode
	, @CategoryName=@categoryName
	, @Description=@description
	, @MappingEntity='DocumentCodes.DocumentCodeId'
	--, @RecodeType=8402	--8401 "Default" category type for Recodes.  Means that exact match must be made for a given value to be considered.
							--8402 Range type - there are no occurences of this type in the Journey QA DB
;

DECLARE @recodeCategoryId int;

SELECT @recodeCategoryId=RecodeCategoryId FROM dbo.[RecodeCategories] AS rc WHERE ISNULL(rc.RecordDeleted, 'N') = 'N' AND RTRIM(rc.CategoryCode) LIKE @categoryCode

IF @recodeCategoryId IS NOT NULL
BEGIN

	----Test Code
	--SELECT 'FOUND, DO RecodeCategories UPDATE' AS InfoText;
	UPDATE rc SET
		CreatedBy=@createdBy
		, CategoryName=@categoryName
		, [Description]=@description
	FROM
		dbo.[RecodeCategories] AS rc
	WHERE
		rc.RecodeCategoryId = @recodeCategoryId
	;

END;

IF OBJECT_ID('tempdb..#TempRecode') IS NOT NULL
    DROP TABLE #TempRecode
;

CREATE TABLE #TempRecode(CodeName varchar(100), CharacterCode varchar(100));

INSERT INTO #TempRecode
VALUES
	('Assessment', 'Assessment')
	, ('SERVICE PLAN', 'SERVICE PLAN')
	, ('Child and Adolescent Needs and Strengths (CANS)', 'Child and Adolescent Needs and Strengths (CANS)')
;

DECLARE db_cursor CURSOR FOR SELECT CodeName, CharacterCode FROM #TempRecode; 
DECLARE @integerCodeId int;
DECLARE @codeName varchar(100);
DECLARE @characterCode varchar(100);

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @codeName, @characterCode;
WHILE @@FETCH_STATUS = 0  
BEGIN  

	SET @integerCodeId = NULL;

	SELECT
		@integerCodeId=a.DocumentCodeId
	FROM
		dbo.DocumentCodes AS a
	WHERE
		( a.RecordDeleted IS NULL OR a.RecordDeleted = 'N' )
			AND a.DocumentName = @codeName
			AND a.Active = 'Y'
	;

	IF @integerCodeId IS NOT NULL
	BEGIN

		PRINT 'Integer Code found <' + RTRIM(@integerCodeId) + '> for code name <' + @codeName + '>'
		IF NOT EXISTS (
			SELECT 1
			FROM
				dbo.[Recodes] AS r
			WHERE
				ISNULL(r.RecordDeleted, 'N') = 'N'
					AND r.CodeName LIKE @codeName
					AND r.RecodeCategoryId = @recodeCategoryId
		)
		BEGIN

			----Test Code
			--SELECT 'NOT FOUND, DO INSERT' AS InfoText;
			EXEC [ssp_RecodesCreateEntry] @RecodeCategoryCode=@categoryCode
				, @IntegerCodeId=@integerCodeId
				, @CharacterCodeId=@characterCode
				, @CodeName=@codeName
				, @FromDate=@fromDate
			UPDATE r SET
				CreatedBy=@createdBy
			FROM
				dbo.[Recodes] AS r
			WHERE
				r.CodeName LIKE @codeName
					AND r.RecodeCategoryId = @recodeCategoryId
			;

		END
		ELSE
		BEGIN

			----Test Code
			--SELECT 'FOUND IT, DO UPDATE' AS InfoText;
			UPDATE r SET
				IntegerCodeId=@integerCodeId
				, CharacterCodeId=@characterCode
				, FromDate=@fromDate
				, ModifiedBy=@createdBy
				, ModifiedDate=@currDate
			--SELECT *
			FROM
				dbo.[Recodes] AS r
			WHERE
				ISNULL(r.RecordDeleted, 'N') = 'N'
					AND r.CodeName LIKE @codeName
					AND r.RecodeCategoryId = @recodeCategoryId
			;

		END
	END
	ELSE
	BEGIN
		PRINT 'ERROR: Integer Code NOT found for code name <' + @codeName + '>'
	END;

	FETCH NEXT FROM db_cursor INTO @codeName, @characterCode;

END;
CLOSE db_cursor;

DEALLOCATE db_cursor;

IF OBJECT_ID('tempdb..#TempRecode') IS NOT NULL
    DROP TABLE #TempRecode;

IF OBJECT_ID('tempdb..#StoredProcs') IS NOT NULL
	DROP TABLE #StoredProcs;

CREATE TABLE #StoredProcs
(
	StoredProcedureName VARCHAR(500)
	, Custom CHAR(1)
	, SPDescription VARCHAR(MAX)
);

INSERT INTO #StoredProcs
( 
	StoredProcedureName
	, Custom
	, SPDescription
)
SELECT
	valtable.StoredProcedureName
	, valtable.Custom
	, valtable.Descr
FROM
(
	VALUES
		( 'csp_ToDoDocumentsDeleteForInactiveClients', 'Y', @description )
) valtable ( StoredProcedureName, Custom, Descr )
;

INSERT INTO dbo.ApplicationStoredProcedures
( 
	CreatedBy
	, StoredProcedureName
	, CustomStoredProcedure
	, [Description]
)
SELECT
	@createdBy
	, sp.StoredProcedureName	-- varchar(500)
	, sp.Custom					-- type_YOrN
	, sp.SPDescription			-- type_Comment2
FROM
	#StoredProcs sp
WHERE
	NOT EXISTS (
		SELECT 1
        FROM
			dbo.ApplicationStoredProcedures asp
        WHERE
			asp.StoredProcedureName = sp.StoredProcedureName
	)
;

INSERT INTO dbo.ApplicationStoredProcedureRecodeCategories
( 
	CreatedBy
	, ApplicationStoredProcedureId
	, RecodeCategoryId
)
SELECT
	@createdBy
	, asp.ApplicationStoredProcedureId
	, rc.RecodeCategoryId
FROM
	dbo.RecodeCategories rc
        CROSS JOIN #StoredProcs sp
        JOIN dbo.ApplicationStoredProcedures asp ON asp.StoredProcedureName = sp.StoredProcedureName
WHERE
	rc.CategoryCode = @categoryCode
        AND NOT EXISTS (
			SELECT 1
			FROM
				dbo.ApplicationStoredProcedureRecodeCategories asprc
			WHERE
				asprc.RecodeCategoryId = rc.RecodeCategoryId
					AND asprc.ApplicationStoredProcedureId = asp.ApplicationStoredProcedureId
		)
;

IF OBJECT_ID('tempdb..#StoredProcs') IS NOT NULL
	DROP TABLE #StoredProcs
;

/*

--Test Code

SELECT
	*
--UPDATE rc SET rc.CategoryCode = 'XNDNWToDoDocumentsDeleteForInactiveClients', CategoryName = 'Procedures billable for client with Medicare', Description = 'Procedures billable for client with Medicare coverage'
--DELETE
FROM
	dbo.[RecodeCategories] AS rc
WHERE
	--RecodeType <> 8401
	CategoryCode LIKE 'XNDNWToDoDocumentsDeleteForInactiveClients'
;

SELECT
	*
--DELETE
FROM
	dbo.[Recodes]
WHERE
	RecodeCategoryId IN ( SELECT RecodeCategoryId FROM dbo.[RecodeCategories] WHERE CategoryCode LIKE 'XNDNWToDoDocumentsDeleteForInactiveClients' )
;

SELECT
	*
FROM
	 dbo.ssf_RecodeValuesCurrent('XNDNWToDoDocumentsDeleteForInactiveClients') AS s_r
;

SELECT
	*
FROM
	 dbo.ssf_RecodeValuesAsOfDate('XNDNWToDoDocumentsDeleteForInactiveClients', GETDATE()) AS s_r
;

DECLARE @categoryCode2 varchar(100) = 'XNDNWToDoDocumentsDeleteForInactiveClients';
DECLARE @recodeCategoryId2 int;
SELECT @recodeCategoryId2=RecodeCategoryId FROM dbo.[RecodeCategories] AS rc WHERE ISNULL(rc.RecordDeleted, 'N') = 'N' AND RTRIM(rc.CategoryCode) LIKE @categoryCode2;
--DELETE asprc
SELECT
	*
FROM
	dbo.ApplicationStoredProcedureRecodeCategories AS asprc
WHERE
	asprc.ApplicationStoredProcedureId IN (
		SELECT	asp.ApplicationStoredProcedureId
		FROM	dbo.ApplicationStoredProcedures AS asp
		WHERE	asp.StoredProcedureName LIKE 'csp_ToDoDocumentsDeleteForInactiveClients'
	)
		AND asprc.RecodeCategoryId=@recodeCategoryId2
;

SELECT
	*
--DELETE asp
FROM
	dbo.ApplicationStoredProcedures AS asp
WHERE
	asp.StoredProcedureName LIKE 'csp_ToDoDocumentsDeleteForInactiveClients'
;

*/

--ROLLBACK TRAN;

/*

DECLARE @MaxId int;

SELECT @MaxId = MAX(RecodeCategoryId) FROM RecodeCategories
SELECT @MaxId AS 'RecodeCategories @MaxId'
DBCC CHECKIDENT(RecodeCategories, RESEED, @MaxId);

SELECT @MaxId = MAX(RecodeId) FROM Recodes
SELECT @MaxId AS 'Recodes @MaxId'
DBCC CHECKIDENT(Recodes, RESEED, @MaxId);

SELECT @MaxId = MAX(ApplicationStoredProcedureRecodeCategoryId) FROM ApplicationStoredProcedureRecodeCategories
SELECT @MaxId AS 'Recodes @MaxId'
DBCC CHECKIDENT(ApplicationStoredProcedureRecodeCategories, RESEED, @MaxId);

--DECLARE @MaxId int;

SELECT @MaxId = MAX(ApplicationStoredProcedureId) FROM ApplicationStoredProcedures
SELECT @MaxId AS 'Recodes @MaxId'
DBCC CHECKIDENT(ApplicationStoredProcedures, RESEED, @MaxId);

*/

GO


