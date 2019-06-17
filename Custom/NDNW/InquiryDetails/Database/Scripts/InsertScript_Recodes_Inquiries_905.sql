DECLARE @RecodeCategoryId INT

IF NOT EXISTS (
		SELECT *
		FROM dbo.RecodeCategories
		WHERE CategoryCode = 'XRequireReferralDetails'
		)
BEGIN
	INSERT INTO dbo.RecodeCategories (
		CategoryCode
		,CategoryName
		)
	VALUES (
		'XRequireReferralDetails'
		,'XRequireReferralDetails'
		)

	SET @RecodeCategoryId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @RecodeCategoryId = RecodeCategoryId
	FROM dbo.RecodeCategories
	WHERE CategoryCode = 'XRequireReferralDetails'
END

IF NOT EXISTS (
		SELECT RecodeId
		FROM Recodes
		WHERE RecodeCategoryId = @RecodeCategoryId
			AND CodeName = 'Require Referral Details'
		)
BEGIN

	INSERT INTO Recodes (
		 CodeName
		,RecodeCategoryId
		)
	VALUES (
		'Require Referral Details'
		,@RecodeCategoryId
		)
END
