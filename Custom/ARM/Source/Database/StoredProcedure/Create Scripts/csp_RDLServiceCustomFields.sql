/****** Object:  StoredProcedure [dbo].[csp_RDLServiceCustomFields]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLServiceCustomFields]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLServiceCustomFields]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLServiceCustomFields]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDLServiceCustomFields]

( @DocumentVersionId int )

as 
/*
THIS MUST BE MODIFIED FOR EACH AFFILIATE
*/

declare @GoLiveDate datetime
set @GoLiveDate = ''1/10/2011''


select 
 dv.DocumentVersionId
,s.ServiceId
,''Healthcare coordination was a part of the service.''
--+'' If checked, address in note narrative section.''
	as ColumnVarchar1Label
,isnull(ColumnVarchar1,''N'') as ColumnVarchar1
,''A disclosure occurred as a part of this intervention.''
--+'' If checked, address in note narrative section.''
	as ColumnVarchar2Label
,isnull(ColumnVarchar2,''N'') as ColumnVarchar2
,''Goal Not Addressed'' as ColumnGlobalCode5Label
,gc3.CodeName as ColumnGlobalCode5
,''Billing Physician Onsite'' as ColumnGlobalCode1Label
,gc4.CodeName as ColumnGlobalCode1
,''Outpatient Mini Team'' as ColumnGlobalCode2Label
,gc5.CodeName as ColumnGlobalCode2
,''DBT Group Assistant'' as ColumnGlobalCode3Label
,gc6.CodeName as ColumnGlobalCode3
,''Transcribed By'' as ColumnGlobalCode6Label
,gc7.CodeName as ColumnGlobalCode6
,''Transcribed Date'' as ColumnDatetime1Label
,ColumnDatetime1
,''Number of Group Participants (Including Customer)'' as ColumnInt1Label
,ColumnInt1 
FROM documentVersions dv with(nolock) 
join Documents d with(nolock) on d.DocumentId = dv.DocumentId and isnull(d.RecordDeleted,''N'')<>''Y''
join Services s with(nolock) on d.ServiceId = s.ServiceId and isnull(s.RecordDeleted,''N'')<>''Y''
left join CustomFieldsData cfd with(nolock) on cfd.PrimaryKey1 = s.ServiceId and isnull(cfd.RecordDeleted,''N'') <> ''Y'' 
	and cfd.DocumentType = 4943 --Service
--There are no custom fields for coord or disclosures
left join GlobalCodes gc3 with(nolock) on gc3.GlobalCodeId = cfd.ColumnGlobalCode5	--Goal Not Addressed
left join GlobalCodes gc4 with(nolock) on gc4.GlobalCodeId = cfd.ColumnGlobalCode1	--Billing Physician Onsite	
left join GlobalCodes gc5 with(nolock) on gc5.GlobalCodeId = cfd.ColumnGlobalCode2	--Outpatient Mini Team	
left join GlobalCodes gc6 with(nolock) on gc6.GlobalCodeId = cfd.ColumnGlobalCode3	--DBT Group Assistant
left join GlobalCodes gc7 with(nolock) on gc7.GlobalCodeId = cfd.ColumnGlobalCode6	--Transcribed By
where isnull(dv.RecordDeleted,''N'') <> ''Y''
and dv.DocumentVersionId = @DocumentVersionId 
and s.DateOfService >= @GoLiveDate
' 
END
GO
