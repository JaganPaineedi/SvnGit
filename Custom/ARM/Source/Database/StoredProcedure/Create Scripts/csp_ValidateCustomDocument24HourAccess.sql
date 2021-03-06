/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocument24HourAccess]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocument24HourAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocument24HourAccess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocument24HourAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_ValidateCustomDocument24HourAccess]
	@DocumentVersionId int
/****************************************************************/
-- PROCEDURE: [csp_ValidateCustomDocument24HourAccess]
-- PURPOSE: Validate custom Harbor document.
-- CALLED BY: SmartCare on signature or validate.
-- REVISION HISTORY:
--		2012.02.14 - A. Voss - Created.
/****************************************************************/

as

create Table #CustomDocument24HourAccess ( 
--***TABLE CREATE***--
 DocumentVersionId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,TimeOfCall datetime
,TimeSpentMinutes int
,PersonResponding int
,PersonCalling varchar(MAX)
,PhoneNumber varchar(100)
,IssueConcern varchar(max)
,ActionTaken varchar(max)
,ResolvedNoFurtherAction char(1)
,ResolvedNeedsFollowup char(1)
,ReferredRescue char(1)
,ResultedInpatientAdmission char(1)
,Crisis911 char(1)
,OtherAction char(1)
,OtherActionDescription varchar(MAX)
,DangerSelfOthers char(1)
,DangerDescription varchar(max)
,[Plan] varchar(max)
)
--***INSERT LIST***--
insert into #CustomDocument24HourAccess
(
 DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,TimeOfCall
,TimeSpentMinutes
,PersonResponding
,PersonCalling
,PhoneNumber
,IssueConcern
,ActionTaken
,ResolvedNoFurtherAction
,ResolvedNeedsFollowup
,ReferredRescue
,ResultedInpatientAdmission
,Crisis911
,OtherAction
,OtherActionDescription
,DangerSelfOthers
,DangerDescription
,[Plan]
)

select 
 DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,TimeOfCall
,TimeSpentMinutes
,PersonResponding
,PersonCalling
,PhoneNumber
,IssueConcern
,ActionTaken
,ResolvedNoFurtherAction
,ResolvedNeedsFollowup
,ReferredRescue
,ResultedInpatientAdmission
,Crisis911
,OtherAction
,OtherActionDescription
,DangerSelfOthers
,DangerDescription
,[Plan]
from CustomDocument24HourAccess
where DocumentVersionId = @DocumentVersionId


declare @Sex char(1), @Age int, @EffectiveDate datetime, @ClientId int, @DocumentCodeId int

select @Sex = isnull(c.Sex,''U''), @Age = dbo.GetAge(c.DOB,d.EffectiveDate), @EffectiveDate = d.EffectiveDate, @ClientId = d.ClientId, 
	@DocumentCodeId = d.DocumentCodeId
from DocumentVersions dv
join Documents d on d.DocumentId = dv.DocumentId 
join Clients c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId

insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
--***VALIDATIION SELECT/UNION***--
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Time Of Call section is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL(TimeOfCall, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Time Spent in Minutes section is required'',1 ,1
--FROM CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(TimeSpentMinutes, '''')))) = 0

UNION
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Person Responding section is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL(PersonResponding, '''')))) = 0

UNION
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Person Calling section is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL(PersonCalling, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - PhoneNumber section is required'',1 ,1
--FROM CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(PhoneNumber, '''')))) = 0

UNION
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Issue / Concern section is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL(IssueConcern, '''')))) = 0

UNION
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Action Taken section is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL(ActionTaken, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - ResolvedNoFurtherAction selection is required'',1 ,1
--FROM #CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(ResolvedNoFurtherAction, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - ResolvedNeedsFollowup selection is required'',1 ,1
--FROM #CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(ResolvedNeedsFollowup, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - ReferredRescue selection is required'',1 ,1
--FROM #CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(ReferredRescue, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - ResultedInpatientAdmission selection is required'',1 ,1
--FROM #CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(ResultedInpatientAdmission, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Crisis911 selection is required'',1 ,1
--FROM #CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(Crisis911, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - OtherAction selection is required'',1 ,1
--FROM #CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(OtherAction, '''')))) = 0

--UNION
--SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - OtherActionDescription section is required'',1 ,1
--FROM #CustomDocument24HourAccess
--WHERE LEN(LTRIM(RTRIM(ISNULL(OtherActionDescription, '''')))) = 0

UNION
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Danger to Self/Others selection is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL(DangerSelfOthers, '''')))) = 0

UNION
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Danger Description section is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL(DangerDescription, '''')))) = 0 and DangerSelfOthers = ''Y''

UNION
SELECT ''CustomDocument24HourAccess'', ''DeletedBy'', ''General  - Plan section is required'',1 ,1
FROM #CustomDocument24HourAccess
WHERE LEN(LTRIM(RTRIM(ISNULL([Plan], '''')))) = 0



' 
END
GO
