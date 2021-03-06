/****** Object:  StoredProcedure [dbo].[csp_ReportMedicationDiscontinuedReasonByMedicationNameId]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicationDiscontinuedReasonByMedicationNameId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMedicationDiscontinuedReasonByMedicationNameId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicationDiscontinuedReasonByMedicationNameId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportMedicationDiscontinuedReasonByMedicationNameId]
( 
	 @MedicationNameId int 

)

as 
/*
exec dbo.csp_ReportMedicationDiscontinuedReasonByMedicationNameId 5068

--test
--set @MedicationNameId = 1769
set @MedicationNameId = 12827

--Fields should be added to below table for CanPrescribe and PrescribingPriority and used instead of harcoding degrees in the report
select * from customDegreePriorities

*/
declare 
	@DiagnosisCode varchar(8)
	,@SearchType int --0 = exact, 1 = any part, 2 = partial start, 3 = partial end
	,@ReportType varchar(20) --(''Med Name'', ''DSM Code'', ''Drug Purpose'') 


--set report as Med Name Report 
	select @ReportType = ''Med Name''
		,@SearchType = 0


--select * from globalCodes where category = ''degree''
declare @Degree Table (degree varchar(12))
insert into @Degree 
select CodeName from GlobalCodes where CodeName in (''M.D.'',''D.O.'',''RN., C.S./NP'',''P.A.'')


declare @Results table ( 
	 Id int Identity
	,ReportGroup1 varchar(30)
	,ReportGroup1Sort int
	,ReportGroup1Label varchar(100)
	,ReportGroup2 varchar(30)
	,ReportGroup2Sort int
	,ReportGroup2Label varchar(100)
	,DSMCode varchar(8)
	,DSMDescription varchar(200)
	,MedicationName varchar(200)	
	,MedicationCount Int
	,DiscontinuedReasonCode int
	,DiscontinuedReasonCodeDesc varchar(1000)
)


declare @TempResults table (
	 DSMCode varchar(8)
	,DSMDescription varchar(200)
	,MedicationName varchar(200)
	,MedicationCount Int
	,DiscontinuedReasonCode int
	,DiscontinuedReasonCodeDesc varchar(1000)
)


insert into @TempResults
(DSMCode, DSMDescription, MedicationName, MedicationCount, DiscontinuedReasonCode, DiscontinuedReasonCodeDesc)
select distinct 
	ltrim(cm.DSMCode),
	isnull(d.DSMDescription, ''No Valid DSM-IV TR Description'') as DSMDescription,	
	mn.MedicationName,
	count(distinct(cms.ClientMedicationScriptId)),
	isnull(cm.DiscontinuedReasonCode,0), 
	case when isnull(gc2.CodeName,'''') = '''' and isnull(Discontinued, ''N'')= ''N'' then ''Active Rx''
		 when isnull(gc2.CodeName,'''') = '''' and isnull(Discontinued, ''N'')= ''Y'' then ''Other Discontinue Reason''
		else gc2.CodeName End
from clientmedicationScripts cms
join clientMedicationScriptDrugs cmsd on cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId and isnull(cmsd.RecordDeleted,''N'')<>''Y''
join clientMedicationInstructions cmi on cmi.clientMedicationInstructionId = cmsd.ClientMedicationInstructionId and isnull(cmi.RecordDeleted,''N'')<>''Y''
join clientMedications cm on cm.ClientMedicationId = cmi.ClientMedicationId and isnull(cm.RecordDeleted,''N'')<>''Y''
join MDMedicationNames mn on mn.MedicationNameId = cm.MedicationNameId and isnull(mn.RecordDeleted,''N'')<>''Y''
left join GlobalCodes gc2 on gc2.GlobalCodeId = cm.DiscontinuedReasonCode
left join ( select distinct replace(a.dsmCode,''311.00'',''311'') as dsmCode, a.DSMDescription 
	from diagnosisDSMDescriptions a 
	where a.DSMNumber=1 ) d on d.DSMCode = replace(cm.dsmCode,''.00'','''')
where isnull(cms.RecordDeleted, ''N'')<>''Y''
and isnull(cm.DrugPurpose,'''')<>''''
--and cm.DSMCode not like ''-%'' 
--and cm.DSMCode not like ''000%''
and cm.MedicationNameId = @MedicationNameId
--and gc.COdeName in (select degree from @Degree)
group by mn.MedicationName, isnull(cm.DiscontinuedReasonCode,0), case when isnull(gc2.CodeName,'''') = '''' and isnull(Discontinued, ''N'')= ''N'' then ''Active Rx''
		 when isnull(gc2.CodeName,'''') = '''' and isnull(Discontinued, ''N'')= ''Y'' then ''Other Discontinue Reason''
		else gc2.CodeName End, ltrim(cm.DSMCode), isnull(d.DSMDescription, ''No Valid DSM-IV TR Description'') 
order by mn.MedicationName, isnull(cm.DiscontinuedReasonCode,0), case when isnull(gc2.CodeName,'''') = '''' and isnull(Discontinued, ''N'')= ''N'' then ''Active Rx''
		 when isnull(gc2.CodeName,'''') = '''' and isnull(Discontinued, ''N'')= ''Y'' then ''Other Discontinue Reason''
		else gc2.CodeName End, count(distinct(cms.ClientMedicationScriptId)) desc, ltrim(cm.DSMCode), isnull(d.DSMDescription, ''No Valid DSM-IV TR Description'') 


insert into @Results (
ReportGroup1 ,ReportGroup1Sort ,ReportGroup1Label ,ReportGroup2 ,ReportGroup2Sort ,ReportGroup2Label ,DSMCode
,DSMDescription ,MedicationName ,MedicationCount ,DiscontinuedReasonCode ,DiscontinuedReasonCodeDesc
)
select
''DiscontinueReason'' ,1 ,''Discontinue Status'' ,''Status'' ,sum(MedicationCount) ,'''' ,sum(MedicationCount)
,'''' ,MedicationName , sum(MedicationCount), DiscontinuedReasonCode, DiscontinuedReasonCodeDesc
from @TempResults 
group by MedicationName, DiscontinuedReasonCode, DiscontinuedReasonCodeDesc
order by sum(MedicationCount) Desc


insert into @Results (
ReportGroup1 ,ReportGroup1Sort ,ReportGroup1Label ,ReportGroup2 ,ReportGroup2Sort ,ReportGroup2Label ,DSMCode
,DSMDescription ,MedicationName ,MedicationCount ,DiscontinuedReasonCode ,DiscontinuedReasonCodeDesc
)
select
''DSMCode'' ,2 , ''DSM Code'', ''DSMCode'' ,sum(MedicationCount) ,'''' ,DSMCode
,DSMDescription  ,MedicationName ,sum(MedicationCount), DiscontinuedReasonCode, DiscontinuedReasonCodeDesc
from @TempResults 
group by MedicationName, DiscontinuedReasonCode, DiscontinuedReasonCodeDesc, DSMCode, DSMDescription
order by sum(MedicationCount) Desc




--FINAL SELECT
select
	 r.ReportGroup1
	,r.ReportGroup1Sort
	,r.ReportGroup1Label
	,r.ReportGroup2
	,r.ReportGroup2Sort
	,r.ReportGroup2Label
	,r.DSMCode
	,case when r.ReportGroup1Sort = 1 then '''' else r.DSMDescription end as DSMDescription
--	,case when r.ReportGroup1Sort = 1 then '''' else isnull(d.DSMDescription, ''No Valid DSM-IV TR Description'') end as DSMDescription
	,r.MedicationName
	,r.DiscontinuedReasonCode
	,r.DiscontinuedReasonCodeDesc
	,r.MedicationCount
from @Results r
--left join ( select distinct replace(a.dsmCode,''311.00'',''311'') as dsmCode, a.DSMDescription 
--	from diagnosisDSMDescriptions a 
--	where DSMNumber=1 ) d on d.DSMCode = replace(r.dsmCode,''.00'','''')
order by r.ReportGroup1Sort asc,  r.ReportGroup2Sort desc ,case when DiscontinuedReasonCodeDesc = ''Active Rx'' then 99999 else r.ReportGroup2Sort end
' 
END
GO
