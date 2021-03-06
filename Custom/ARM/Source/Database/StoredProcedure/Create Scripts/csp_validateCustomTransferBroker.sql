/****** Object:  StoredProcedure [dbo].[csp_validateCustomTransferBroker]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomTransferBroker]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomTransferBroker]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomTransferBroker]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE      PROCEDURE [dbo].[csp_validateCustomTransferBroker]
@DocumentVersionId	Int
as


--Load the document data into a temporary table to prevent multiple seeks on the document table
CREATE TABLE #CustomTransferBroker
(
DocumentVersionId int,
DocumentType char(1),
DateOfRequest datetime,
CurrentProgram int,
ProgramRequested int,
ServiceRequested int,
RequestedClinician int,
VerballyAcceptedDate datetime,
Rationale varchar(max), 
Findings varchar(max),
NoticeDeliveredDate datetime
)
insert into #CustomTransferBroker
(
DocumentVersionId,
DocumentType,
DateOfRequest,
CurrentProgram,
ProgramRequested,
ServiceRequested,
RequestedClinician,
VerballyAcceptedDate,
Rationale, 
Findings,
NoticeDeliveredDate
)
select
a.DocumentVersionId,
a.DocumentType,
a.DateOfRequest,
a.CurrentProgram,
a.ProgramRequested,
a.ServiceRequested,
a.RequestedClinician,
a.VerballyAcceptedDate,
a.Rationale, 
a.Findings,
a.NoticeDeliveredDate
from CustomTransferBroker a
where a.DocumentVersionId = @DocumentVersionId


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

SELECT ''CustomTransferBroker'' , ''DocumentType'', ''Document Type must be specified.''
From #CustomTransferBroker
Where isnull(DocumentType,'''')=''''
UNION
SELECT ''CustomTransferBroker'' , ''DateOfRequest'', ''Date Of Request must be specified.''
From #CustomTransferBroker
Where DateOfRequest is null
UNION
SELECT ''CustomTransferBroker'' , ''CurrentProgram'', ''Current Program must be specified.''
From #CustomTransferBroker
Where CurrentProgram is null
UNION
SELECT ''CustomTransferBroker'' , ''ProgramRequested'', ''Program Requested must be specified.''
From #CustomTransferBroker
Where ProgramRequested is null
UNION
--SELECT ''CustomTransferBroker'' , ''ServiceRequested'', ''ServiceRequested must be specified.''
--UNION
--SELECT ''CustomTransferBroker'' , ''RequestedClinician'', ''Requested Clinician must be specified.''
--From #CustomTransferBroker
--Where RequestedClinician is null
--UNION
--SELECT ''CustomTransferBroker'' , ''VerballyAcceptedDate'', ''Verbally Accepted Date must be specified.''
--From #CustomTransferBroker
--Where isnull(VerballyAcceptedDate,'''')=''''
--UNION
SELECT ''CustomTransferBroker'' , ''Rationale'', ''Rationale must be specified.''
From #CustomTransferBroker
Where isnull(Rationale,'''')=''''
--UNION
--SELECT ''CustomTransferBroker'' , ''Findings'', ''Findings must be specified.''
--FROM #CustomTransferBroker
--WHERE DocumentType = ''T''
--and isnull(Findings,'''')=''''
--UNION
--SELECT ''CustomTransferBroker'' , ''NoticeDeliveredDate'', ''NoticeDeliveredDate must be specified.''



if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomTransferBroker failed.  Contact your system administrator.''
' 
END
GO
