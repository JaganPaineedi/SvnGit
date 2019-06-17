/*********************************************************************                                                                                          
	File Procedure:		UpdateScript_Screens_WarningStoredProcedureComplete.sql
	Creation Date:		07/20/2017
	Created By:			mlightner
	Purpose:			Add Warning validation to Service Notes for Appointment Requested and Appointment First Offered dates
	Customer:			New Directions

	Input Parameters:	
	Output Parameters:	
	Return:				
	
	Called By:			
	Calls:				
 
	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	07/20/2017	mlightner		Created - New Directions-Enhancements #552.1
*********************************************************************/

update	s
set		s.WarningStoredProcedureComplete = 'csp_Warning' + replace(s.ScreenName, ' ', '') + 'Complete'
from	dbo.DocumentCodes dc
join	dbo.Screens s
		on dc.DocumentCodeId = s.DocumentCodeId
		   and isnull(s.RecordDeleted, 'N') = 'N'
where	isnull(dc.RecordDeleted, 'N') = 'N'
		and dc.DocumentType = 10
		and isnull(dc.ServiceNote, 'N') = 'Y'
		and s.WarningStoredProcedureComplete is null;

/* 
ScreenID	DocumentCodeId	ScreenName					ProcedureName
29			1				Service Note				csp_WarningServiceNoteComplete
10027		115				Miscellaneous				csp_WarningMiscellaneousComplete
11145		11145			Individual Service Note		csp_WarningIndividualServiceNoteComplete
21300		21300			Psychiatric Service Note	csp_WarningPsychiatricServiceNoteComplete
21400		21400			Psychiatric Evaluation		csp_WarningPsychiatricEvaluationComplete
60006		60005			Service Note				csp_WarningServiceNoteComplete
10038		60006			Crisis Service Note			csp_WarningCrisisServiceNoteComplete

select	s.WarningStoredProcedureComplete, dc.*
from	dbo.DocumentCodes dc
join	dbo.Screens s
		on dc.DocumentCodeId = s.DocumentCodeId
		   and isnull(s.RecordDeleted, 'N') = 'N'
where	isnull(dc.RecordDeleted, 'N') = 'N'
		and dc.DocumentType = 10
		and isnull(dc.ServiceNote, 'N') = 'Y';
*/
