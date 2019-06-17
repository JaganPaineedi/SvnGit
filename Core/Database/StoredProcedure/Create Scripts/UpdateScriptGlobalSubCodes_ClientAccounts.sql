IF EXISTS (Select * from GlobalSubCodes WHERE   GlobalCodeId = 7002 AND SubCodeName = 'Total Balance > 0')
BEGIN
	UPDATE  dbo.GlobalSubCodes
	SET     SubCodeName = 'Client Balance > 0'
	WHERE   GlobalCodeId = 7002
			AND SubCodeName = 'Total Balance > 0'
END			