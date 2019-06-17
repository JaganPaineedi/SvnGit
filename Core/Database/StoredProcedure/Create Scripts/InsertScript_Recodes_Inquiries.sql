/********************************************************************************************
Author			:  AlokKumar Meher 
CreatedDate		:  13 June 2018 
Purpose			:  Insert/Update script for GlobalCodes
*********************************************************************************************/


DECLARE @RecodeCategoryId INT

IF NOT EXISTS ( SELECT * FROM dbo.RecodeCategories WHERE CategoryCode = 'RequireReferralDetails')
BEGIN
	INSERT INTO dbo.RecodeCategories (
		CategoryCode
		,CategoryName
		)
	VALUES (
		'RequireReferralDetails'
		,'RequireReferralDetails'
		)

	SET @RecodeCategoryId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @RecodeCategoryId = RecodeCategoryId
	FROM dbo.RecodeCategories
	WHERE CategoryCode = 'RequireReferralDetails'
END


IF NOT EXISTS ( SELECT RecodeId FROM Recodes WHERE RecodeCategoryId = @RecodeCategoryId AND CodeName = 'Require Referral Details' )
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
