-----Author: Mrunali
-----Task:   Thresholds - Support #1072
-----Added New Table CustomPsychiatricNoteMedicationHistory
--------------------------------------------------------------------------------------------------------------------

Update DocumentCodes  SET TableList ='CustomDocumentPsychiatricNoteGenerals,CustomPsychiatricNoteProblems,ExternalReferralProviders,CustomPsychiatricPCPProviders,CustomDocumentPsychiatricNoteExams,CustomDocumentPsychiatricNoteMDMs,CustomDocumentPsychiatricAIMSs,CustomDocumentPsychiatricNoteChildAdolescents,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions,CustomPsychiatricNoteSubstanceUses,CustomPsychiatricNoteMedicationHistory'
where  DocumentCodeId =60000 








