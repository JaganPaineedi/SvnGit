/*
Insert script for Psychiatric Evaluation - Service Note - CustomNoteInformations Info Icon of Current Life Events of Client
Author : Akwinass
Created Date : 08/JAN/2015
Purpose : What/Why : Task #822 - Woods - Customizations
*/
IF NOT EXISTS (
		SELECT 1
		FROM CustomNoteInformations
		WHERE DocumentCodeId = 21400
			AND InformationText = 'Current Life Events'
		)
BEGIN
	INSERT INTO CustomNoteInformations (
		InformationText
		,InformationToolTipStoredProcedure
		,DocumentCodeId
		)
	VALUES (
		'Current Life Events'
		,'csp_CustomDocumentGetCurrentLifeEvents'
		,21400
		)
END
