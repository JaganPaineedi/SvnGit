/****** Object:  StoredProcedure [dbo].[csp_ViewModeClientMedicationHeaderInfo]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeClientMedicationHeaderInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ViewModeClientMedicationHeaderInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeClientMedicationHeaderInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_ViewModeClientMedicationHeaderInfo]
(@ClientId int)


as
/*
Created Date: 3/17/2008
Created By: avoss

Purpose: Header info for client medication history and current medications

exec csp_ViewModeClientMedicationHeaderInfo 36168
select * from clientMedicationScripts
exec csp_RDLClientPrescriptionMain 167, ''p''
exec csp_RDLClientPrescriptionAllergies 167, ''p''
exec csp_RDLClientPrescriptionDrugs 167, ''p''
exec csp_RDLClientPrescriptionSignature 167, ''p''

--Testing
declare @ClientId int
set @ClientId = 36194

sp_helptext csp_ViewModeClientMedicationHeaderInfo 
*/
/*Header Info */
create Table #ClientHeaderInfo (
Row int identity,
ClientId int, 
ClientName varchar(60),
ClientDOB datetime,
ClientSex char(1),
DSMCode varchar(10), 
DSMNumber int, 
DSMDescription varchar(200), 
Axis int, 
AxisName varchar(10), 
DxId varchar(12),
DiagnosisOrder int,
RuleOut varchar(4)
)

declare @ClientName varchar(60), @ClientDOB datetime, @ClientSex char(1),
		@DocumentId int, @Version int, @CurrentDocumentVersionId int  

select	@ClientName = rtrim(c.LastName + '', '' +c.FirstName),
		@ClientDOB = c.DOB,
		@ClientSex = c.Sex
from Clients as c 
where c.ClientId = @ClientId
and isnull(c.RecordDeleted,''N'')<>''Y''

select top 1 @CurrentDocumentVersionId = a.CurrentDocumentVersionId          
from Documents a          
where a.ClientId = @ClientId          
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate() ,101))          
and a.Status = 22          
and a.DocumentCodeId =5          
 and isNull(a.RecordDeleted,''N'')<>''Y''   order by a.EffectiveDate desc,a.ModifiedDate desc    

--Diagnosis I, II, III codes            
Insert into #ClientHeaderInfo
(DSMCode, DSMNumber,  DSMDescription, Axis, AxisName, DxId, DiagnosisOrder, RuleOut)      
select distinct
DSM.DSMCode,
DSM.DSMNumber,
rtrim(DSM.DSMDescription),
DSM.Axis,
case DSM.Axis when 1 then ''Axis I'' else ''Axis II'' end as AxisName, 
rtrim(ltrim(isnull(DSM.DSMCode,''0'')))+ ''_'' + rtrim(ltrim(isnull(cast(DSM.DSMNumber as varchar),''0''))) as DxId,
D.DiagnosisOrder,
case d.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOut
from  DiagnosisDSMDescriptions DSM             
join DiagnosesIandII D on DSM.DSMCODE=D.DSMCODE  and IsNull(D.RecordDeleted,''N'')=''N'' and DSM.DSMNumber=D.DSMNumber      
join documents Doc on D.DocumentVersionId=Doc.CurrentDocumentVersionId  
where (Doc.CurrentDocumentVersionId=@CurrentDocumentVersionId AND IsNull(Doc.RecordDeleted,''N'')=''N''
and ISNULL(d.RecordDeleted, ''N'')= ''N'')      
union 
select iii.ICDCode, 1 as DSMNumber, icd.ICDDescription, 3 as Axis, ''Axis III'' as AxisName,
iii.ICDCode + ''_1'' as DxId,
9 as DiagnosisOrder,
'''' as RuleOut
from DiagnosesIII as dx
join dbo.DiagnosesIIICodes III on III.DocumentVersionId = dx.DocumentVersionId
join DiagnosisICDCodes as icd on icd.ICDCode = iii.ICDCode
join documents Doc on Dx.DocumentVersionId=Doc.CurrentDocumentVersionId  
Where doc.CurrentDocumentVersionId = @CurrentDocumentVersionId
and ISNULL(dx.RecordDeleted, ''N'') =''N''
and ISNULL(doc.RecordDeleted, ''N'')= ''N''






--Update with Client Info
Update #ClientHeaderInfo
Set ClientId = @ClientId, 
	ClientName = @ClientName, 
	ClientDOB = @ClientDOB,
	ClientSex = @ClientSex

select 
	Row,
	ClientId, 
	ClientName,
	ClientDOB,
	ClientSex,
	rtrim(AxisName +'': '' + DSMCode + '' - '' + DSMDescription + '' '' + isnull(RuleOut,'''')) as DiagnosisLine,
	DSMCode, 
	DSMNumber, 
	Axis, 
	DSMDescription, 
	RuleOut
from #ClientHeaderInfo
order by axis, dsmcode
drop Table #ClientHeaderInfo
' 
END
GO
