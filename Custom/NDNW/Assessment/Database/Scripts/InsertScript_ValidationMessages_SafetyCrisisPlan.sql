--Validation scripts for Task #955 in Valley - Customizations (Assessment Document)
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                                */
/*       02/DEC/2014	Akwinass			Created(Safety Crisis Plan Validations)*/
************************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10018 and TableName = 'CustomDocumentSafetyCrisisPlans'

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
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
	N'N'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'InitialSafetyPlan'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(InitialSafetyPlan,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Safety Plan – General – Initial Safety Plan or Review  is required.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Safety Plan – General – Initial Safety Plan or Review  is required'
	),
	 (
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'WarningSignsCrisis'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(WarningSignsCrisis,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Safety Plan – Warning Signs of a Crisis – What are my thoughts, feelings, behaviors, or moods that indicate that a crisis may be developing? is required.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Safety Plan – Warning Signs of a Crisis – What are my thoughts, feelings, behaviors, or moods that indicate that a crisis may be developing? is required.'
	)
	,
	-- (
	--N'Y'
	--,10018
	--,NULL
	--,'Safety/Crisis Plan'
	--,1
	--,N'CustomDocumentSafetyCrisisPlans'
	--,N'CopingStrategies'
	--,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(ReviewSafetyPlanXDays,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	--,N'Safety Plan – Next Review – Review Every X Days is required.'
	--,CAST(3 AS DECIMAL(18, 0))
	--,N'Safety Plan – Coping Strategies – Review Every X Days is required.'
	--),
	
	 (
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'CopingStrategies'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(CopingStrategies,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Safety Plan – Coping Strategies – What can I do to make sure that I am personally safe? is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Safety Plan – Coping Strategies – What can I do to make sure that I am personally safe? is required.'
	),
	-- (
	--N'Y'
	--,10018
	--,NULL
	--,'Safety/Crisis Plan'
	--,1
	--,N'CustomSupportContacts'
	--,N'SupportContactId'
	--,N'FROM CustomSupportContacts S WHERE S.DocumentVersionId=@DocumentVersionId AND  ISNULL(S.RecordDeleted,''N'') = ''N'' and exists(select 1 from CustomDocumentSafetyCrisisPlans C where C.DocumentVersionId=S.DocumentVersionId)'
	--,N'Safety Plan – Support Systems – Whom do I contact when I need help? is required.'
	--,CAST(4 AS DECIMAL(18, 0))
	--,N'Safety Plan – Support Systems – Whom do I contact when I need help? is required.'
	--),
	 (
	N'N'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'InitialCrisisPlan'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(InitialCrisisPlan,'''') = '''' AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y'' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan – General – Initial Crisis Plan or Review is required.'
	,CAST(4 AS DECIMAL(18, 0))
	,N'Crisis Plan – General – Initial Crisis Plan or Review is required'
	),(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'DateOfCrisis'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(DateOfCrisis,'''') = '''' AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan - Crisis Plan Demographics - Date of Crisis is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Crisis Plan - Crisis Plan Demographics - Date of Crisis is required.'
	)
	,(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'ProgramId'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(ProgramId,0) <= 0 AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan - Crisis Plan Demographics - Program is required.'
	,CAST(6 AS DECIMAL(18, 0))
	,N'Crisis Plan - Crisis Plan Demographics - Program is required.'
	)
	,(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'StaffId'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(StaffId,0) <= 0 AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan - Crisis Plan Demographics - Staff Contact Person is required.'
	,CAST(7 AS DECIMAL(18, 0))
	,N'Crisis Plan - Crisis Plan Demographics - Staff Contact Person is required.'
	)
	,(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'CurrentCrisisDescription'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(CurrentCrisisDescription,'''') = '''' AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan - Crisis Related Issues and Information - Description of the Current Crisis is required.'
	,CAST(8 AS DECIMAL(18, 0))
	,N'Crisis Plan - Crisis Related Issues and Information - Description of the Current Crisis is required.'
	)
	,(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'CurrentCrisisSpecificactions'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(CurrentCrisisSpecificactions,'''') = '''' AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan - Specific plan and circumstances when plan should be enacted - List specific actions is required.'
	,CAST(9 AS DECIMAL(18, 0))
	,N'Crisis Plan - Specific plan and circumstances when plan should be enacted - List specific actions is required.'
	)
	,(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'SafetyPlanNotReviewed'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SafetyPlanNotReviewed,'''') = ''N'' AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Safety Plan must be reviewed or check the “Safety Plan was not reviewed” checkbox on the Crisis Plan tab'
	,CAST(10 AS DECIMAL(19, 0))
	,N'Safety Plan must be reviewed or check the “Safety Plan was not reviewed” checkbox on the Crisis Plan tab'
	)
	,(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'CurrentCrisisSpecificactions'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(ReviewCrisisPlanXDays,'''') = '''' AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan - Review - Review Every X Days is required.'
	,CAST(11 AS DECIMAL(19, 0))
	,N'Crisis Plan - Review - Review Every X Days is required.'
	)
	,(
	N'Y'
	,10018
	,NULL
	,'Safety/Crisis Plan'
	,19
	,N'CustomDocumentSafetyCrisisPlans'
	,N'CurrentCrisisSpecificactions'
	,N'FROM CustomDocumentSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  AND (ReviewCrisisPlanXDays>14 OR ReviewCrisisPlanXDays<1)  AND ISNULL(ClientHasCurrentCrisis,'''') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Crisis Plan - Review - Review Every X Days must be between 1 and 14.'
	,CAST(12 AS DECIMAL(20, 0))
	,N'Crisis Plan - Review - Review Every X Days must be between 1 and 14.'
	)
	