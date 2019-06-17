  IF NOT EXISTS (
		SELECT *
		FROM dbo.Screens
		WHERE ScreenId =60002
		)
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO [Screens] (
		  ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[DocumentCodeId]
		)
	VALUES (
		 60002
		,'Substance Use PopUp'
		,5765
		,'Custom/PsychiatricNote/WebPages/SubstanceUsesPopUp.ascx'
		,2
		,null
		)
SET IDENTITY_INSERT Screens OFF		
END
  
    
  UPDATE DocumentCodes  SET  TableList='CustomDocumentPsychiatricNoteGenerals,CustomPsychiatricNoteProblems,ExternalReferralProviders,CustomPsychiatricPCPProviders,CustomDocumentPsychiatricNoteExams,CustomDocumentPsychiatricNoteMDMs,CustomDocumentPsychiatricAIMSs,CustomDocumentPsychiatricNoteChildAdolescents,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions,CustomPsychiatricNoteSubstanceUses' where DocumentCodeId=60000
  
  