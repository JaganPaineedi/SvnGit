
IF Not EXISTS(SELECT ScreenId FROM ScreenAlternates WHERE ScreenId=969)
BEGIN
	INSERT INTO ScreenAlternates (ScreenId, AlternateId)VALUES (969,3)
END
ELSE
BEGIN
	UPDATE ScreenAlternates SET AlternateId	= 3 WHERE ScreenId=969
END
