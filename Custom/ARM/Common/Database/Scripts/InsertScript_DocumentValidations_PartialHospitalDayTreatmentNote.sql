--Added Validation scripts for 'Partial Hospital/ Day Treatment Note'

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=10017 and ErrorMessage='Note- Significant changes section is required' and TableName = 'CustomDocumentPartialHospitalNotes')
BEGIN
	INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
	VALUES (
	'Y'
	,'10017'
	,'Note'
	,'1'
	,'CustomDocumentPartialHospitalNotes'
	,'SignificantChangesId'
	,'FROM CustomDocumentPartialHospitalNotes WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(SignificantChangesId,'''') = '''''
	,'Check that Significant Changes in the Life of the Client Dropdown should have value'
	,1
	,'Significant changes section is required'
	)
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=10017 and ErrorMessage='Note- Recommended Changes to ISP selection is required' and TableName = 'CustomDocumentPartialHospitalNotes')
BEGIN
	INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
	VALUES (
	'Y'
	,'10017'
	,'Note'
	,'1'
	,'CustomDocumentPartialHospitalNotes'
	,'RecommendedChangesToISP'
	,'FROM CustomDocumentPartialHospitalNotes WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(RecommendedChangesToISP,'''') = '''''
	,'Check that Recommended changes to the ISP should select Radio Button'
	,4
	,'Recommended Changes to ISP selection is required'
	)
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=10017 and ErrorMessage='Note- Rating or progress towards goal section is required' and TableName = 'CustomDocumentPartialHospitalNotes')
BEGIN
	INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
	VALUES (
	'Y'
	,'10017'
	,'Note'
	,'1'
	,'CustomDocumentPartialHospitalNotes'
	,'RatingOfProgressTowardGoal'
	,'FROM CustomDocumentPartialHospitalNotes WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(RatingOfProgressTowardGoal,'''') = '''''
	,'Check that Rating or progress towards goal section should have value'
	,2
	,'Rating or progress towards goal section is required'
	)
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=10017 and ErrorMessage='Note- Description of progress section is required' and TableName = 'CustomDocumentPartialHospitalNotes')
BEGIN
INSERT INTO [dbo].[DocumentValidations] (
[Active]
,[DocumentCodeId]
,[TabName]
,[TabOrder]
,[TableName]
,[ColumnName]
,[ValidationLogic]
,[ValidationDescription]
,[ValidationOrder]
,[ErrorMessage]
)
VALUES (
'Y'
,'10017'
,'Note'
,'1'
,'CustomDocumentPartialHospitalNotes'
,'DescriptionOfProgress'
,'FROM CustomDocumentPartialHospitalNotes WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ((ISNULL(RatingOfProgressTowardGoal,'''')=''S'' OR ISNULL(RatingOfProgressTowardGoal,'''')=''M'' OR ISNULL(RatingOfProgressTowardGoal,'''')=''A'' ) AND ISNULL(DescriptionOfProgress,'''') = '''')'
,'Check that Description of progress section should have value if "Some Improvement", "Moderate Improvement" or "Achieved" selected'
,3
,'Description of progress section is required'
)
END