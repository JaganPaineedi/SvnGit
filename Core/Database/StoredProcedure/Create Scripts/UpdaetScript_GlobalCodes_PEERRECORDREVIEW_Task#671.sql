IF EXISTS (
		SELECT *
		FROM GlobalCodeCategories
		WHERE Category = 'PEERRECORDREVIEW'
		)
BEGIN
	UPDATE GlobalCodeCategories
	SET AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
	WHERE Category = 'PEERRECORDREVIEW'
END
GO

