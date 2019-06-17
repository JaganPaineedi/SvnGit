IF EXISTS (
		SELECT 1 FROM DocumentValidations 
		WHERE DocumentCodeId=10502
		AND TabName='FBA/BIP'
		AND TableName='Documents'
		AND ColumnName IS NULL
		AND ValidationDescription='Document must be signed.'
		AND ErrorMessage='Document must be signed by a physician'
		AND Active='Y'
		AND ISNULL(RecordDeleted,'N')<>'Y'
)
BEGIN
	UPDATE DocumentValidations
	SET 
		ValidationLogic='FROM Documents d INNER JOIN StaffLicenseDegrees s ON s.StaffId = d.AuthorId WHERE d.CurrentDocumentVersionId = @DocumentVersionId  AND LicenseTypeDegree = 25204  AND ISNULL(s.RecordDeleted, ''N'') = ''N''  AND (cast(S.StartDate AS DATE) <= cast(@EffectiveDate AS DATE) AND (S.EndDate IS NULL OR cast(S.EndDate AS DATE) >= cast(@EffectiveDate AS DATE))) HAVING COUNT(LicenseTypeDegree) = 0'
	WHERE DocumentCodeId=10502
		AND TabName='FBA/BIP'
		AND TableName='Documents'
		AND ColumnName IS NULL
		AND ValidationDescription='Document must be signed.'
		AND ErrorMessage='Document must be signed by a physician'
		AND Active='Y'
		AND ISNULL(RecordDeleted,'N')<>'Y'
END
ELSE
BEGIN
	INSERT INTO DocumentValidations (Active,DocumentCodeId,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage)
	VALUES ('Y',10502,'FBA/BIP',1,'Documents',NULL,'FROM Documents d INNER JOIN StaffLicenseDegrees s ON s.StaffId = d.AuthorId WHERE d.CurrentDocumentVersionId = @DocumentVersionId  AND LicenseTypeDegree = 25204  AND ISNULL(s.RecordDeleted, ''N'') = ''N''  AND (cast(S.StartDate AS DATE) <= cast(@EffectiveDate AS DATE) AND (S.EndDate IS NULL OR cast(S.EndDate AS DATE) >= cast(@EffectiveDate AS DATE))) HAVING COUNT(LicenseTypeDegree) = 0','Document must be signed.',1,'Document must be signed by a physician')
END