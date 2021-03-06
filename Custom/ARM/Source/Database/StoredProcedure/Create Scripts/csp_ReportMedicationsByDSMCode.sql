/****** Object:  StoredProcedure [dbo].[csp_ReportMedicationsByDSMCode]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicationsByDSMCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMedicationsByDSMCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicationsByDSMCode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create
 procedure [dbo].[csp_ReportMedicationsByDSMCode]
( 

	@DiagnosisCode varchar(8)
)

as 
/*
exec dbo.csp_ReportMedicationsByDSMCode 311

declare 
	 @VarMedicationName varchar(200) 
	,@DiagnosisCode varchar(8)
	,@VarDrugPurpose varchar(1000)
	,@SearchType int --0 = exact, 1 = any part, 2 = partial start, 3 = partial end
	,@ReportType varchar(20) --(''Med Name'', ''DSM Code'', ''Drug Purpose'') 
*/
declare @SearchDSMCode varchar(8),
	 @VarMedicationName varchar(200) 
	,@VarDrugPurpose varchar(1000)
	,@SearchType int --0 = exact, 1 = any part, 2 = partial start, 3 = partial end
	,	@ReportType varchar(20) --(''Med Name'', ''DSM Code'', ''Drug Purpose'')

--set report as Dx Report 
	set @ReportType = ''DSM Code''
	set @SearchType = 0
-- clear .00 
--if @SearchType in (1,2) begin set @DiagnosisCode = ltrim(replace(replace(@DiagnosisCode,''.00'',''''),''.0'','''')) end
-- @DiagnosisCode = ltrim(replace(@DiagnosisCode,''.00'',''''))

begin
	set @SearchDSMCode = case when @SearchType = 0 then @DiagnosisCode 
		when @SearchType = 1 then ''%'' + @DiagnosisCode + ''%'' 
		when @SearchType = 2 then @DiagnosisCode + ''%''
		when @SearchType = 3 then ''%'' + @DiagnosisCode end
end


--select * from globalCodes where category = ''degree''
declare @Degree Table (degree varchar(12))
insert into @Degree 
select CodeName from GlobalCodes where CodeName in (''M.D.'',''D.O.'',''RN., C.S./NP'',''P.A.'')


declare @Report table ( 
	 Id int Identity
	,ReportGroup1 varchar(30)
	,ReportGroup1Sort int
	,ReportGroup2 varchar(30)
	,ReportGroup2Sort int
	,Degree varchar(12)
	,DSMCode varchar(8)
	,PrescriberId int
	,PrescriberName varchar(80)
	,MedicationName1 varchar(200)
	,MedicationCount1 Int
	,MedicationName2 varchar(200)
	,MedicationCount2 Int
	,MedicationName3 varchar(200)
	,MedicationCount3 Int
)

declare @Results table ( 
	 Id int Identity
	,ReportGroup1 varchar(30)
	,ReportGroup1Sort int
	,ReportGroup2 varchar(30)
	,ReportGroup2Sort int
	,Degree varchar(12)
	,DSMCode varchar(8)
	,PrescriberId int
	,PrescriberName varchar(80)
	,MedicationName varchar(200)
	,MedicationCount Int
	,MedNumber int
)


declare @TempResults table (
	Degree varchar(12)
	,DSMCode varchar(8)
	,PrescriberId int
	,PrescriberName varchar(80)
	,MedicationName varchar(200)
	,MedicationCount Int
)

declare @MedicationTotalCounts table (
	 MedicationName varchar(200)
	,MedicationCount Int
)

declare @MedDegreeCounts table (
	 Sort int
	,Degree varchar(12)
	,MedicationName varchar(200)
	,MedicationCount Int
)

--For Main Outline
declare @MedDegreeSummary table (
	 Sort int
	,Degree varchar(12)
	,MedicationName varchar(200)
	,MedicationCount Int
)

--Testing
--set @DiagnosisCode = 311
--

insert into @TempResults
(Degree, PrescriberId, PrescriberName, DSMCode, MedicationName,MedicationCount)
select 
	distinct 
	gc.CodeName,
	st.StaffId,
	st.Lastname +'', ''+st.FirstName,
	ltrim(cm.DSMCode),
	--ltrim(replace(replace(cm.DSMCode,''.00'',''''),''.0'','''')), 	
	mn.MedicationName,
	count(distinct(cms.ClientMedicationScriptId))
from clientmedicationScripts cms
join clientMedicationScriptDrugs cmsd on cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId and isnull(cmsd.RecordDeleted,''N'')<>''Y''
join clientMedicationInstructions cmi on cmi.clientMedicationInstructionId = cmsd.ClientMedicationInstructionId and isnull(cmi.RecordDeleted,''N'')<>''Y''
join clientMedications cm on cm.ClientMedicationId = cmi.ClientMedicationId and isnull(cm.RecordDeleted,''N'')<>''Y''
join MDMedicationNames mn on mn.MedicationNameId = cm.MedicationNameId and isnull(mn.RecordDeleted,''N'')<>''Y''
join Staff st on st.StaffId = cms.OrderingPrescriberId
join GlobalCodes gc on gc.GlobalCodeId = st.Degree
where isnull(cms.RecordDeleted, ''N'')<>''Y''
and isnull(cm.DrugPurpose,'''')<>''''
and cm.DSMCode not like ''-%'' 
and cm.DSMCode not like ''000%''
and ltrim(replace(cm.DSMCode,''.00'','''')) like @SearchDSMCode
and gc.COdeName in (select degree from @Degree)
group by gc.CodeName, st.StaffId, st.Lastname +'', ''+st.FirstName, ltrim(cm.DSMCode),  mn.MedicationName
order by gc.CodeName, st.StaffId, st.Lastname +'', ''+st.FirstName, count(distinct(cms.ClientMedicationScriptId)) desc, mn.MedicationName, ltrim(cm.DSMCode)

insert into @MedicationTotalCounts
select 
	 MedicationName, 
	 Sum(MedicationCount)
from @TempResults
group by MedicationName

insert into @MedDegreeCounts
select case Degree when ''M.D.'' then 2 when ''D.O.'' then 3 when ''P.A.'' then 4 else 5 end ,
	 Degree, 
	 MedicationName, 
	 Sum(MedicationCount)
from @TempResults
group by 
case Degree when ''M.D.'' then 2 when ''D.O'' then 3 when ''P.A.'' then 4 else 5 end ,
Degree, MedicationName

--select * from @MedDegreeCounts

insert into @MedDegreeSummary
select top 3 1, ''Total'', MedicationName, MedicationCount
from @MedicationTotalCounts
group by MedicationName, MedicationCount 
order by MedicationCount desc

insert into @MedDegreeSummary
select top 3 Sort, Degree, MedicationName, MedicationCount
from @MedDegreeCounts
where Degree = ''M.D.''
group by Sort, Degree, MedicationName, MedicationCount
union all
select top 3 sort, Degree, MedicationName, MedicationCount
from @MedDegreeCounts
where Degree = ''D.O.''
group by Sort, Degree, MedicationName, MedicationCount
union all
select top 3 sort, Degree, MedicationName, MedicationCount
from @MedDegreeCounts
where Degree = ''P.A.''
group by Sort, Degree, MedicationName, MedicationCount
union all
select top 3 sort, Degree, MedicationName, MedicationCount
from @MedDegreeCounts
where Degree = ''RN., C.S./NP''
group by Sort, Degree, MedicationName, MedicationCount
order by MedicationCount desc

insert into @Results
(ReportGroup1, ReportGroup1Sort, ReportGroup2, ReportGroup2Sort, Degree, DSMCode, PrescriberId, PrescriberName, MedicationName, MedicationCount)
select ''Totals'', case when Degree = ''Total'' then 1 else 2 end, ''Degree'', Sort, Degree, @DiagnosisCode, 0, ''Total'', MedicationName, MedicationCount
from @MedDegreeSummary 
order by Sort asc, MedicationCount desc, MedicationName
--select * from @TempResults

declare @PrescriberId int

declare cur1 cursor for 
	select
		PrescriberId
	from @TempResults
	group by PrescriberId

	open cur1

	Fetch next from cur1 into @PrescriberId
	while (@@fetch_status = 0)
	begin
		
		insert into @Results
		(ReportGroup1, ReportGroup1Sort, ReportGroup2, ReportGroup2Sort, Degree, DSMCode, PrescriberId, PrescriberName, MedicationName, MedicationCount)
		select top 3
			''Details'', 3, ''Prescriber Details'', --6,
			case Degree when ''M.D.'' then 2 when ''D.O.'' then 3 when ''P.A.'' then 4 else 5 end,
			Degree, DSMCode, PrescriberId, PrescriberName, MedicationName, MedicationCount
		from @TempResults 
		where prescriberId = @PrescriberId
		group by Degree, DSMCode, PrescriberId, PrescriberName, MedicationName,MedicationCount 
		order by MedicationCount Desc


	Fetch next from cur1 into @PrescriberId

	end
	
close cur1
deallocate cur1

/*
select * from @Results
order by DSMCode, ReportGroup1Sort,	ReportGroup1, ReportGroup2Sort, ReportGroup2,	
Degree, PrescriberName, MedicationCount, MedicationName	
*/

/**/
update r
set MedNumber = (r.Id - r2.minId) + 1
from @Results r  
join ( select a.ReportGroup1 ,a.ReportGroup2 ,a.Degree ,a.PrescriberName ,min(a.Id) as minId from @Results a
	group by a.ReportGroup1 ,a.ReportGroup2 ,a.Degree ,a.PrescriberName )  r2 
	on r.ReportGroup1 = r2.ReportGroup1 and r.ReportGroup2 = r2.ReportGroup2
	and r.Degree = r2.Degree and r.PrescriberName = r2.PrescriberName



insert into @Report (r.ReportGroup1
	,ReportGroup1Sort
	,ReportGroup2
	,ReportGroup2Sort
	,Degree
	,DSMCode
	,PrescriberId
	,PrescriberName
)

select distinct
	 r.ReportGroup1
	,r.ReportGroup1Sort
	,r.ReportGroup2
	,r.ReportGroup2Sort
	,r.Degree
	,r.DSMCode
	,r.PrescriberId
	,r.PrescriberName
from @Results r
order by 	
	 r.ReportGroup1Sort
	,r.ReportGroup2Sort
	,r.Degree
	,r.PrescriberName
	,r.PrescriberId


update rep
set  MedicationName1 = a.MedicationName
	,MedicationCount1 = a.MedicationCount
	,MedicationName2 = b.MedicationName
	,MedicationCount2 = b.MedicationCount
	,MedicationName3 = c.MedicationName
	,MedicationCount3 = c.MedicationCount
from @Report rep
left join @Results a on a.ReportGroup1 = rep.ReportGroup1 and a.ReportGroup2 = rep.ReportGroup2
	and a.Degree = rep.Degree and a.PrescriberName = rep.PrescriberName and a.MedNumber = 1
left join @Results b on b.ReportGroup1 = rep.ReportGroup1 and b.ReportGroup2 = rep.ReportGroup2
	and b.Degree = rep.Degree and b.PrescriberName = rep.PrescriberName and b.MedNumber = 2
left join @Results c on c.ReportGroup1 = rep.ReportGroup1 and c.ReportGroup2 = rep.ReportGroup2
	and c.Degree = rep.Degree and c.PrescriberName = rep.PrescriberName and c.MedNumber = 3


select 
	 ReportGroup1
	,ReportGroup1Sort
	,ReportGroup2
	,ReportGroup2Sort
	,Degree
	,DSMCode
	,PrescriberId
	,PrescriberName
	,MedicationName1
	,MedicationCount1
	,MedicationName2
	,MedicationCount2
	,MedicationName3
	,MedicationCount3
from @Report
order by ReportGroup1Sort, ReportGroup2Sort



/*
exec csp_ReportTop3MedicationsByDSMCode null, 295, null, 2, ''DSM Code''

*/
' 
END
GO
