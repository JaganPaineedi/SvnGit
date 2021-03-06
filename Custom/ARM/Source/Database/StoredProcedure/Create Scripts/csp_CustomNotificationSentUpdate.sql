/****** Object:  StoredProcedure [dbo].[csp_CustomNotificationSentUpdate]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomNotificationSentUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomNotificationSentUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomNotificationSentUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_CustomNotificationSentUpdate]
AS

INSERT into CustomNotificationsSent 
(DocumentId, ServiceId, DocumentCodeId, ProcedureCodeId)
SELECT d.documentid, s.serviceid, d.documentCodeId, s.procedurecodeid 
FROM services s
join documents d on d.serviceid = s.serviceid
join notes n on n.DocumentVersionId = d.CurrentDocumentVersionId
where d.documentcodeid = 6
and isnull(convert(varchar(8000), n.notificationmessage), '''') <> ''''
and s.serviceid not in (select cns.serviceid from CustomNotificationsSent cns
						where isnull(cns.RecordDeleted, ''N'' ) = ''N'')


/*
insert into 
CustomNotificationsSent 
(DocumentId, ServiceId, DocumentCodeId, ProcedureCodeId)
select d.documentid, s.serviceid, d.documentCodeId, s.procedurecodeid from services s
join documents d on d.serviceid = s.serviceid
join customhospitalizationprescreens n on n.documentid = d.documentid and d.currentversion = n.version
where d.documentcodeid = 119
and isnull(convert(varchar(8000), n.notificationmessage), '''') <> ''''
and s.serviceid not in (select cns.serviceid from CustomNotificationsSent cns
						where isnull(cns.RecordDeleted, ''N'' ) = ''N'')
*/

Return
' 
END
GO
