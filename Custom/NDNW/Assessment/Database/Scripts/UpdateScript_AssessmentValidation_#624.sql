-- New Directions - Support Go Live #624
	
IF EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Severe/Profound Disability narrative is required'
		)
BEGIN
	UPDATE DocumentValidations
	SET ValidationLogic = 'From #CustomHRMAssessments  Where DocumentVersionId = @DocumentVersionId  and isnull(@SevereProfoundDisability,''N'')=''Y''  and isnull(SevereProfoundDisabilityComment,'''')='''' AND ClientInDDPopulation=''Y'''
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Severe/Profound Disability narrative is required'
END
GO	