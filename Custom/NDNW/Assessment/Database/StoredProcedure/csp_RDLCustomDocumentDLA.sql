/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentDLA]    Script Date: 08/09/2014 15:04:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDLA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDLA] 
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentDLA]    Script Date: 08/09/2014 15:04:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure   [dbo].[csp_RDLCustomDocumentDLA]
(     
@DocumentVersionId  int
)                
AS                
          

/************************************************************************/                                                
/* Stored Procedure: [csp_RDLCustomDocumentDLA]		*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  Aug 09, 2014										*/                                                
/*																		*/                                                
/* Purpose: MHA sub report for DLA scores					*/                                    
/*																		*/                                              
/* Input Parameters: @DocumentVersionId									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Akwinass												*/                                                
/************************************************************************/                  

declare @DocumentId int
select @DocumentId = DocumentId from DocumentVersions where DocumentVersionId = @DocumentVersionId

declare @StatusDate varchar(50)
select @StatusDate = CONVERT(varchar(12),d.EffectiveDate,101)
from Documents d 
where d.DocumentId = @DocumentId

Declare @ClientInDDPopulation Char(1), @ClientInMHPopulation Char(1), @ClientInSAPopulation Char(1), @AssessmentType char(1), @AdultOrChild char(10)
        
select 
 @ClientInDDPopulation = ClientInDDPopulation
,@ClientInMHPopulation = ClientInMHPopulation
,@ClientInSAPopulation = ClientInSAPopulation
,@AssessmentType = AssessmentType 
,@AdultOrChild = AdultOrChild
from CustomHRMAssessments                      
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
 
 /*
--Document Initialization Individual Fields
select distinct 
 @DocumentId
, c.Diagnosis  as PopulationCategory
, c.TabName
, c.TableName as TableName
, cast(row_number()  over (order by c.MapDocumentInitializationLogId ) as varchar) as ColumnName
, c.GroupName as GroupName 
, isnull(c.FieldName,'') as FieldName
From Cstm_Conv_Map_DocumentInitializationLog c
--Left Join DocumentValidations d on c.TabName=d.TabName and c.TableName=d.TableName
Where c.TableName='CustomDailyLivingActivityScores'
*/
select distinct 
 @DocumentId
,null
,'CustomHRMActivities'
,'CustomHRMActivities' as TableName
,c.HRMActivityId as ColumnName
,Null as GroupName
,c.HRMActivityId as FieldName
from CustomHRMActivities c


update v
set StatusData = case di.InitializationStatus 
	when 5871 then 'To Verify' --To Validate
	when 5872 then 'Reviewed and Verified ' + @StatusDate
	when 5873 then 'Reviewed and Updated ' + @StatusDate
	when 5874 then 'Reviewed and Cleared ' + @StatusDate
	else '*Error '  end
from #Verify v
join DocumentInitializationLog di on v.DocumentId = di.DocumentId and ISNULL(di.RecordDeleted,'N')<>'Y' 
join GlobalCodes gc on gc.GlobalCodeId = di.InitializationStatus
join CustomDailyLivingActivityScores dla on dla.DailyLivingActivityScoreId = di.ChildRecordId  and ISNULL(dla.RecordDeleted,'N')<>'Y'
where di.DocumentId=v.DocumentId
and dla.HRMActivityId = v.ColumnName
---
create table #scoreComments
  (
    Score int,
    ScoreDescription varchar(max)
  )
  
  insert into #scoreComments select 1,'None of the time; extremely severe impairment or problems in functioning; pervasive level of continuous paid supports needed.'
  insert into #scoreComments select 2,'A little of the time; severe impairment or problems in functioning; extensive level of continuous paid supports needed.'
  insert into #scoreComments select 3,'Occasionally; moderately severe impairment or problems in functioning; moderate level of continuous paid supports needed.'
  insert into #scoreComments select 4,'Some of the time; moderate impairment or problems in functioning; moderate level of continuous paid supports needed.'
  insert into #scoreComments select 5,'A good bit of the time; mild impairment or problems in functioning; moderate level of intermittent paid supports needed.'
  insert into #scoreComments select 6,'Most of the time; very mild impairment or problems in functioning; low level of intermittent paid supports needed.'
  insert into #scoreComments select 7,'All of the time; no significant impairment or problems in functioning requiring paid supports.'
  
------
--GAF calculation

declare @nQuestionsAnswered float  
declare @avgDLAScore float  
declare @sumDLAScore float  
declare @GAFScore float 
  
select @nQuestionsAnswered = count(*), @avgDLAScore= (sum(dla.ActivityScore)/20), @sumDLAScore= sum(dla.ActivityScore)  
from CustomDailyLivingActivityScores as dla  
where dla.DocumentVersionId = @DocumentVersionId  
and isnull(dla.RecordDeleted, 'N') <> 'Y'  
and isnull(dla.ActivityScore, 0) <> 0  
  
  set @avgDLAScore= (@sumDLAScore/20)
-- at least 15 questions must be answered  
if 15 > @nQuestionsAnswered begin set @GAFScore = 0   end
else 
if 20 = @nQuestionsAnswered  
begin  
 set @GAFScore = cast(round(@sumDLAScore / 2.0, 2) as float)  
end  
else  
begin  
 set @GAFScore = cast(round(@avgDLAScore * 10.0, 2) as float)  
end


------
select 
    ROW_NUMBER() OVER(ORDER BY act.SortOrder asc)  as RowId,
	SUBSTRING(act.HRMActivityDescription, 1, CHARINDEX(':', act.HRMActivityDescription, 1)) AS HRMActivityHeadDescription,
	SUBSTRING(act.HRMActivityDescription,  CHARINDEX(':', act.HRMActivityDescription, 1)+1,LEN(act.HRMActivityDescription)) AS HRMActivityDescription,
	act.SortOrder,
	sc.ActivityScore,
	sc.ActivityComment,
	(select ScoreDescription from #scoreComments where Score =sc.ActivityScore) as ScoreDescription,
	case when v.StatusData is null then null else v.StatusData + ': ' end as CommentLabel,
	@sumDLAScore as Sum20Ratings,
	@avgDLAScore as AverageDLA,
	@GAFScore as EstimateGAF
from dbo.CustomHRMActivities as act
join dbo.CustomDailyLivingActivityScores as sc on sc.HRMActivityId = act.HRMActivityId
left join #Verify v on v.ColumnName = sc.HRMActivityId 
where sc.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010     
and isnull(sc.RecordDeleted, 'N') <> 'Y'
order by  act.SortOrder


--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   '[csp_RDLCustomDocumentDLA] : An Error Occured'                                                 
		Return                                                
	End   


GO


