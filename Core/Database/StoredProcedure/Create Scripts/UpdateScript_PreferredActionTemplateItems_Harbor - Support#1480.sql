/**********************************************************************************************************************/
/* Date : 05-January-2018                                                                                             */
/* Author : Vishnu Narayanan                                                                                          */
/* Purpose : Updating DefaultFilters values for Harbor - Support-Task#1480                                            */
/**********************************************************************************************************************/
IF EXISTS(SELECT 1 FROM PreferredActionTemplateItems WHERE ISNULL(RecordDeleted,'N') = 'N' AND 
ItemName IN 
			(
				'Review Queued Orders'
				,'Review Verbal Orders'
				,'View Medication History'
			)
		)
BEGIN
	UPDATE PreferredActionTemplateItems SET AssociatedScreenId=1197,DefaultFilters='DocumentNavigationName=Medications^OpenScreen=VerbalOrQueuedPage^OrderType=V' WHERE ItemName='Review Verbal Orders'
	UPDATE PreferredActionTemplateItems SET AssociatedScreenId=1197,DefaultFilters='DocumentNavigationName=Medications^OpenScreen=VerbalOrQueuedPage^OrderType=A' WHERE ItemName='Review Queued Orders'
	UPDATE PreferredActionTemplateItems SET DefaultFilters='DocumentNavigationName=Medications^OpenScreen=MedicationReport' WHERE ItemName='View Medication History'
	
END