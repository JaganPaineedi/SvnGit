IF EXISTS (
		SELECT *
		FROM screens
		WHERE screenid = 772
		)
BEGIN
	UPDATE Screens
	SET PostUpdateStoredProcedure = NULL
	WHERE ScreenId = 772;
END

-------DocumentCodes ------------
UPDATE DocumentCodes
SET ClientOrder = 'Y'
WHERE DocumentCodeId = 1506