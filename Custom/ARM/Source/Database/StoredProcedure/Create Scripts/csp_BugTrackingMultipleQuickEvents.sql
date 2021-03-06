/****** Object:  StoredProcedure [dbo].[csp_BugTrackingMultipleQuickEvents]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingMultipleQuickEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_BugTrackingMultipleQuickEvents]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingMultipleQuickEvents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_BugTrackingMultipleQuickEvents]

as

update A
set a.RecordDeleted = ''Y'',
a.DeletedDate = GETDATE(),
a.DeletedBy = ''MultipleRecordFix''
from TPQuickGoals a with(nolock) 
where  exists (select * from TPQuickGoals b with(nolock) 
			where b.StaffId = a.staffid
			and  convert(varchar(max), b.TPElementText) = convert(varchar(max), a.TPElementText)
			and a.TPQuickId > b.TPQuickId
			and ISNULL(b.recorddeleted, ''N'')= ''N''
			)
and ISNULL(a.RecordDeleted, ''N'')= ''N''

update A
set a.RecordDeleted = ''Y'',
a.DeletedDate = GETDATE(),
a.DeletedBy = ''MultipleRecordFix''
from TPQuickInterventions a with(nolock) 
where  exists (select * from TPQuickInterventions b with(nolock) 
			where b.StaffId = a.staffid
			and  convert(varchar(max), b.TPElementText) = convert(varchar(max), a.TPElementText)
			and a.TPQuickId > b.TPQuickId
			and ISNULL(b.recorddeleted, ''N'')= ''N''
			)
and ISNULL(a.RecordDeleted, ''N'')= ''N''


update A
set a.RecordDeleted = ''Y'',
a.DeletedDate = GETDATE(),
a.DeletedBy = ''MultipleRecordFix''
from TPQuickObjectives a with(nolock) 
where  exists (select * from TPQuickObjectives b with(nolock) 
			where b.StaffId = a.staffid
			and  convert(varchar(max), b.TPElementText) = convert(varchar(max), a.TPElementText)
			and a.TPQuickId > b.TPQuickId
			and ISNULL(b.recorddeleted, ''N'')= ''N''
			)
and ISNULL(a.RecordDeleted, ''N'')= ''N''


--
--Insert into bug tracking log
--
Insert into CustomBugTracking
(Description, CreatedDate)

Select distinct ''Multiple Quick Goals Created'' + '' - '' + ISNULL(ModifiedBy, ''''), DeletedDate
From TPQuickGoals 
Where DeletedBy = ''MultipleRecordFix''
and CONVERT(varchar(20), DeletedDate, 101) = DATEADD(dd, 0, convert(varchar(20), getdate(), 101))



Insert into CustomBugTracking
(Description, CreatedDate)

Select distinct ''Multiple Quick Objectives Created'' + '' - '' + ISNULL(ModifiedBy, ''''), DeletedDate
From TPQuickObjectives
Where DeletedBy = ''MultipleRecordFix''
and CONVERT(varchar(20), DeletedDate, 101) = DATEADD(dd, 0, convert(varchar(20), getdate(), 101))


Insert into CustomBugTracking
(Description, CreatedDate)

Select distinct ''Multiple Quick Interventions Created'' + '' - '' + ISNULL(ModifiedBy, ''''), DeletedDate
From TPQuickInterventions
Where DeletedBy = ''MultipleRecordFix''
and CONVERT(varchar(20), DeletedDate, 101) = DATEADD(dd, 0, convert(varchar(20), getdate(), 101))
' 
END
GO
