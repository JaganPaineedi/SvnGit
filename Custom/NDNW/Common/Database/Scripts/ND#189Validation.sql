


update DocumentValidations
set ValidationLogic = 
'FROM Documents d INNER JOIN StaffLicenseDegrees s ON s.StaffId = d.AuthorId WHERE d.CurrentDocumentVersionId = @DocumentVersionId  AND LicenseTypeDegree in (25204,39250) AND ISNULL(s.RecordDeleted, ''N'') = ''N''  AND (cast(S.StartDate AS DATE) <= cast(@EffectiveDate AS DATE) AND (S.EndDate IS NULL OR cast(S.EndDate AS DATE) >= cast(@EffectiveDate AS DATE))) HAVING COUNT(LicenseTypeDegree) = 0'
where documentvalidationid = 91



