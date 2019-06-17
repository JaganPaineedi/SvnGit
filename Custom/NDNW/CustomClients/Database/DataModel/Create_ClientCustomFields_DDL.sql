/****************************************************************************************
* Table Definition for New Directions North West Custom Client Information Fields
* Tryan - 12/23/14 - Created
****************************************************************************************/

CREATE TABLE CustomClients (
	 ClientId INT NOT NULL PRIMARY KEY
	,CreatedBy type_CurrentUser NOT NULL
	,CreatedDate type_CurrentDatetime NOT NULL
	,ModifiedBy	type_CurrentUser NOT NULL
	,ModifiedDate type_CurrentDatetime NOT NULL
	,RecordDeleted type_YOrN NULL
	,DeletedBy type_UserId NULL
	,DeletedDate DATETIME NULL
	,AccompaniedByChild type_YOrN NULL
	,ChildName1 VARCHAR(250) NULL
	,ChildDOB1 DATETIME NULL
	,MoveInDate1 DATETIME NULL
	,MoveOutDate1 DATETIME NULL
	,ReasonForLeaving1 VARCHAR(250) NULL
	,ChildName2 VARCHAR(250) NULL
	,ChildDOB2 DATETIME NULL
	,MoveInDate2 DATETIME NULL
	,MoveOutDate2 DATETIME NULL
	,ReasonForLeaving2 VARCHAR(250) NULL
	,ChildName3 VARCHAR(250) NULL
	,ChildDOB3 VARCHAR(250) NULL
	,MoveInDate3 DATETIME NULL
	,MoveOutDate3 DATETIME NULL
	,ReasonForLeaving3 VARCHAR(250) NULL
	,CurrentlyEnrolledInEducation type_YOrN NULL
	,NameOfSchool VARCHAR(250) NULL
	--Type? Match Admission doc? -There is a globalcode->clients.educationstatus, needed?
	--,LastGradeCompleted VARCHAR(250) NULL
	,TCUEntryDate DATETIME NULL
	,TCUScore VARCHAR(250) NULL
	,NinetyDayScoreDate DATETIME NULL
	,NinetyDayScore VARCHAR(250) NULL
	,DischargeScoreDate DATETIME NULL
	,DischargeScore VARCHAR(250) NULL
	,AIPDateOfIncarceration DATETIME NULL
	,AIPPotentialReleaseDate DATETIME NULL
	,AIPActualReleaseDate DATETIME NULL
	,AIPTransLeaveDate DATETIME NULL
	,AIPPostPrisonSupervisionEndDate DATETIME NULL
	)