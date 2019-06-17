-- New Directions - Support Go Live Task # 889
IF EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'cannibis'
			AND Category = 'xSUdrugname'
		)
BEGIN
	UPDATE Globalcodes
	SET CodeName = 'Cannabis'
	WHERE CodeName = 'cannibis'
		AND Category = 'xSUdrugname'
END
GO

