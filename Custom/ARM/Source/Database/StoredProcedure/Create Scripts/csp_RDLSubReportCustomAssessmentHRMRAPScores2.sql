/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores2]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE   [dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores2]        
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                
AS                
          

/************************************************************************/                                                
/* Stored Procedure: [csp_RDLSubReportCustomAssessmentHRMRAPScores]		*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  July 30, 2008										*/                                                
/*																		*/                                                
/* Purpose: Gets Data from CustomAssessment,SystemConfigurations,		*/
/*			Staff,Documents,Clients,GlobalCodes,Pharmacy				*/                                               
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Tom Remisoski												

exec csp_RDLSubReportCustomAssessmentHRMRAPScores2 @DOcumentVersionID=1199938
*/                                                
/************************************************************************/     


declare @DocumentId int
select @DocumentId = DocumentId from DocumentVersions with(nolock) where DocumentVersionId = @DocumentVersionId

declare @StatusDate varchar(50)
select @StatusDate = CONVERT(varchar(12),d.EffectiveDate,101)
from Documents d with(nolock) 
where d.DocumentId = @DocumentId

Declare @ClientInDDPopulation Char(1), @ClientInMHPopulation Char(1), @ClientInSAPopulation Char(1), @AssessmentType char(1), @AdultOrChild char(10)
        

select 
 @ClientInDDPopulation = ClientInDDPopulation
,@ClientInMHPopulation = ClientInMHPopulation
,@ClientInSAPopulation = ClientInSAPopulation
,@AssessmentType = AssessmentType 
,@AdultOrChild = AdultOrChild
from CustomHRMAssessments with(nolock)                       
where DocumentVersionId = @DocumentVersionId


create table #Verify (
 DocumentId int
,PopulationCategory varchar(10)
,TabName varchar(128)
,TableName varchar(128) 
,ColumnName varchar(128)
,GroupName varchar(128)
,FieldName varchar(128)
,StatusData varchar(128)
)

insert into #Verify 
(DocumentId, PopulationCategory, TabName, TableName, ColumnName, GroupName, FieldName)
 
--Document Initialization Individual Fields
Select Distinct 
@DocumentId
, c.Diagnosis  as PopulationCategory
, c.TabName
, c.TableName as TableName
, c.ColumnName as ColumnName
, case c.ColumnName when ''PsCurrentHealthIssuesComment'' then ''Health and Health Care'' 
	when ''RapCiDomainComment'' then ''Community Inclusion'' 
	when ''RapCbDomainComment'' then ''Challenging Behaviors''
	when ''RapCaDomainComment'' then ''Current Abilities''
	else null end as GroupName
, c.FieldName as FieldName
From Cstm_Conv_Map_DocumentInitializationLog c with(nolock) 
--Left Join DocumentValidations d on c.TabName=d.TabName and c.TableName=d.TableName
Where c.TableName = ''CustomHRMAssessments''
and c.ColumnName in ( ''RapCaDomainComment'', ''RapCbDomainComment'', ''RapCiDomainComment'',''PsCurrentHealthIssuesComment'' ) 
and c.Diagnosis = ''DD''

order by 4, 3, 2, 6, 5

update v
set StatusData = case di.InitializationStatus 
	when 5871 then ''To Verify'' --To Validate
	when 5872 then ''Reviewed and Verified '' + @StatusDate
	when 5873 then ''Reviewed and Updated '' + @StatusDate
	when 5874 then ''Reviewed and Cleared '' + @StatusDate
	else ''*Error ''  end
from #Verify v
join DocumentInitializationLog di with(nolock) on v.DocumentId = di.DocumentId 
	and di.ColumnName = v.ColumnName
join GlobalCodes gc with(nolock) on gc.GlobalCodeId = di.InitializationStatus
where di.DocumentId=v.DocumentId

          

select 
	case rq.RAPDomain 
		when ''Community Inclusion'' then cha.RapCiDomainIntensity
		when ''Challenging Behaviors'' then cha.RapCbDomainIntensity
		when ''Current Abilities'' then cha.RapCaDomainIntensity
		when ''Health and Health Care'' then cha.RapHhcDomainIntensity
	end as DomainIntensity,
	rq.RAPDomain,
	rq.RAPQuestionNumber,
	rq.RAPQuestionText,
	rs.RAPAssessedValue,
    l.RAPLevelDescription,
	rs.AddToNeedsList,
	case rq.RAPDomain 
		when ''Community Inclusion'' then Null
		when ''Challenging Behaviors'' then null
		when ''Current Abilities'' then null 
		when ''Health and Health Care'' then cha.PsMedicationsComment 
		end as MedicationsComment,
	case rq.RAPDomain 
		when ''Community Inclusion'' then cha.RapCiDomainComment
		when ''Challenging Behaviors'' then cha.RapCbDomainComment
		when ''Current Abilities'' then cha.RapCaDomainComment
		when ''Health and Health Care'' then cha.PsCurrentHealthIssuesComment
	end as DomainSummary,
	case when v.StatusData is null then null else '' (''+v.StatusData+'')'' end as DomainStatusComment
from dbo.CustomHRMRAPQuestions as rq with(nolock) 
join dbo.CustomHRMAssessmentRAPScores as rs with(nolock) on rs.HRMRAPQuestionId = rq.HRMRAPQuestionId
join dbo.CustomHRMAssessments as CHA with(nolock) on cha.DocumentVersionId = rs.DocumentVersionId   --Modified by Anuj Dated 03-May-2010
left Join dbo.CustomHRMRAPLevels as l with(nolock) on l.HRMRAPQuestionId = rs.HRMRAPQuestionId and rs.RAPAssessedValue = l.RAPLevelValue
left join #Verify v on v.GroupName = rq.RAPDomain
where rs.DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and isnull(rs.RecordDeleted, ''N'') <> ''Y'' 
order by 
	case rq.RAPDomain 
		when ''Community Inclusion'' then 1
		when ''Challenging Behaviors'' then 2
		when ''Current Abilities'' then 3
		when ''Health and Health Care'' then 4
	end, rq.RAPQuestionNumber,
	case rq.RAPDomain 
		when ''Community Inclusion'' then cha.RapCiDomainComment
		when ''Challenging Behaviors'' then cha.RapCbDomainComment
		when ''Current Abilities'' then cha.RapCaDomainComment
		when ''Health and Health Care'' then cha.PsCurrentHealthIssuesComment end

--select * from CustomHRMRAPLevels
--select * from CustomHRMAssessmentRAPScores
--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   ''[csp_RDLSubReportCustomAssessmentHRMRAPScores2] : An Error Occured''                                                 
		Return                                                
	End
' 
END
GO
