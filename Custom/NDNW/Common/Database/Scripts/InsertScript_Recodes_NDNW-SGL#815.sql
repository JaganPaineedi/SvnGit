/***************************************************************************************************
	What: Insert Script for Recodes "ReallocationExcludeAdjustmentTransferCodes"
	Why: New Directions - Support Go Live # 815
***************************************************************************************************/
DECLARE	@RecodeCategoryId INT = NULL;
DECLARE	@CategoryCode VARCHAR(100) = 'ReallocationExcludeAdjustmentTransferCodes';
DECLARE	@UserStamp VARCHAR(50) = 'NDNW-SGL#815';
DECLARE @TimeStamp DATETIME = GETDATE();

SELECT	@RecodeCategoryId = RecodeCategoryId
FROM	dbo.RecodeCategories
WHERE	CategoryCode = @CategoryCode
	AND ISNULL(RecordDeleted, 'N') = 'N'

IF (@RecodeCategoryId IS NOT NULL)
BEGIN
	INSERT INTO dbo.Recodes
	( 
		CreatedBy ,
	    CreatedDate ,
	    ModifiedBy ,
	    ModifiedDate ,
	    IntegerCodeId ,
	    CharacterCodeId ,
	    CodeName ,
	    FromDate ,
	    ToDate ,
	    RecodeCategoryId
	)
	SELECT	@UserStamp,
			@TimeStamp,
			@UserStamp,
			@TimeStamp,
			GlobalCodeId,
			NULL,
			SUBSTRING(CodeName, 0, 100),
			@TimeStamp,
			NULL,
			@RecodeCategoryId
	FROM	dbo.GlobalCodes
	WHERE	Category = 'ADJUSTMENTCODE'
		AND ISNULL(RecordDeleted, 'N') = 'N'
		AND Active = 'Y'
		AND GlobalCodeId <> 40206 -- Billing Reallocation Job
END
ELSE
BEGIN
	RAISERROR('RecodeCategory: ReallocationExcludeAdjustmentTransferCodes does not exist in the database', 16, 1)
END