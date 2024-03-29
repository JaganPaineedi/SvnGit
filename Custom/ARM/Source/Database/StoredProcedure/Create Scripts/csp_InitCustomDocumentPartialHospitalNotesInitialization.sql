/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentPartialHospitalNotesInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentPartialHospitalNotesInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentPartialHospitalNotesInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentPartialHospitalNotesInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_InitCustomDocumentPartialHospitalNotesInitialization]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
As

BEGIN

BEGIN TRY

-- get the next scheduled service based on today''s date
declare @nextScheduledServiceDate varchar(100)

select top 1 @nextScheduledServiceDate = dbo.csf_DateTimeToString(s.DateOfService)
from dbo.Services as s
where s.ClientId = @ClientID
and s.Status = 70	-- scheduled
and DATEDIFF(DAY, GETDATE(), s.DateOfService) > 0
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
order by s.DateOfService, s.ServiceId

Select TOP 1 ''CustomDocumentPartialHospitalNotes'' AS TableName, -1 as ''DocumentVersionId'',
@nextScheduledServiceDate as DateOfNextVisit,
'''' as CreatedBy,
getdate() as CreatedDate,
'''' as ModifiedBy,
getdate() as ModifiedDate
from systemconfigurations s left outer join CustomDocumentPartialHospitalNotes C
on s.Databaseversion = -1

END TRY

BEGIN CATCH

DECLARE @Error varchar(8000)
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDocumentPartialHospitalNotesInitialization'')
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
    + ''*****'' + Convert(varchar,ERROR_STATE())
 RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );

END CATCH

END
' 
END
GO
