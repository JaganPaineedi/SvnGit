IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDLA20Youth]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDLA20Youth] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure   [dbo].[csp_RDLCustomDocumentDLA20Youth]
(     
@DocumentVersionId  int
)                
AS                
          

/************************************************************************/                                                
/* Stored Procedure: [csp_RDLCustomDocumentDLA20Youth]		*/                                                                                                                        
/* Creation Date:  Jan 20, 2017								*/                                                
/*																		*/                                                
/* Purpose: MHA sub report for DLA scores DLA Youth					*/                                    
/* What:Moved from F&CS to NDNW; Why:New Directions - Support Go Live ,Task#286*/
/* Input Parameters: @DocumentVersionId									*/                                         
/* Output Parameters:													*/                                         
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: K.Soujanya											*/                                               
/************************************************************************/                  


create table #scoreComments
  (
    Score int,
    ScoreDescription varchar(max)
  )
  
  insert into #scoreComments select 1,'None of the time; Pervasive, continuous intervention required- Dysfunctional; Extremely severe disabling impairment.'
  insert into #scoreComments select 2,'Almost never; Not functional; Dependent; Severe Impairments'
  insert into #scoreComments select 3,'Occasionally; Functioning depends on continuous support; Serious substantial Impairment.'
  insert into #scoreComments select 4,'Some of the time; marginal independence Low Level of continuous support; Moderate Impairment.'
  insert into #scoreComments select 5,'A good bit of the time (WNL); Independent with moderate, routine support; Mild problems; social, job.'
  insert into #scoreComments select 6,'Most of the time (WNL); Independent with intermittent support or follow-up; Intermittent problem.'
  insert into #scoreComments select 7,'All of the time (WNL); Optimal & independent asset; no problem.'
  
------

-----Previous DLA Average Score --------------		
declare @latestDLADocumentVersionId int;
declare @latestnQuestionsAnswered float  
declare @latestavgDLAScore float  
declare @latestsumDLAScore float  
declare @ClientId int;
SET @ClientId = (
			SELECT ClientId
			FROM documents doc
			INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
			WHERE DocumentVersionId = @DocumentVersionId
				AND ISNULL(docv.RecordDeleted, 'N') <> 'Y')
select  TOP 1 @latestDLADocumentVersionId = CurrentDocumentVersionId from CustomYouthDLAScores C  
 Inner Join Documents Doc ON C.DocumentVersionId=Doc.CurrentDocumentVersionId  where Doc.ClientId=@ClientID  
  and isnull(C.RecordDeleted, 'N') <> 'Y'  and isnull(C.ActivityScore, 0) <> 0 
  and Doc.Status=22 and IsNull(C.RecordDeleted,'N')='N' and IsNull(Doc.RecordDeleted,'N')='N'    
 AND Doc.EffectiveDate <= GetDate()                                                     
 ORDER BY Doc.EffectiveDate asc,Doc.ModifiedDate asc   

select @latestnQuestionsAnswered = count(*), @latestsumDLAScore= sum(dla.ActivityScore) from CustomYouthDLAScores as dla  
where dla.DocumentVersionId = @latestDLADocumentVersionId  
and isnull(dla.RecordDeleted, 'N') <> 'Y'  
and isnull(dla.ActivityScore, 0) <> 0 ;

set @latestavgDLAScore= (@latestsumDLAScore/@latestnQuestionsAnswered)

----Previous DLA Average Score Ends----------- 	
--GAF calculation

declare @nQuestionsAnswered float  
declare @avgDLAScore float  
declare @sumDLAScore float  
declare @GAFScore float 
declare @ChangeScore float 
  
select @nQuestionsAnswered = count(*), @avgDLAScore= (sum(dla.ActivityScore)/20), @sumDLAScore= sum(dla.ActivityScore)  
from CustomYouthDLAScores as dla  
where dla.DocumentVersionId = @DocumentVersionId  
and isnull(dla.RecordDeleted, 'N') <> 'Y'  
and isnull(dla.ActivityScore, 0) <> 0  
  
-- at least 15 questions must be answered  
if (@nQuestionsAnswered >0)
 begin
 set @avgDLAScore= (@sumDLAScore/@nQuestionsAnswered)
 set @avgDLAScore = cast(round(@avgDLAScore, 2) as float)  
 set @GAFScore = cast(round(@avgDLAScore * 10.0, 2) as float)  
 end

set @ChangeScore = @latestavgDLAScore -  @avgDLAScore
set @ChangeScore = cast(round(@ChangeScore, 2) as float)  
------
select 
    act.SortOrder  as RowId,
	SUBSTRING(act.HRMActivityDescription, 1, CHARINDEX(':', act.HRMActivityDescription, 1)) AS HRMActivityHeadDescription,
 replace((replace((SUBSTRING(act.HRMActivityDescription,  CHARINDEX(':', act.HRMActivityDescription, 1)+1,LEN(act.HRMActivityDescription))),'<b>','')),'</b>','') AS HRMActivityDescription,
	act.SortOrder,
	sc.ActivityScore,
	sc.ActivityComment,
	(select ScoreDescription from #scoreComments where Score =sc.ActivityScore) as ScoreDescription,
	@sumDLAScore as Sum20Ratings,
	@avgDLAScore as AverageDLA,
	@GAFScore as EstimateGAF,
	@ChangeScore as ChangeScore
from dbo.CustomDailyLivingActivities as act
join dbo.CustomYouthDLAScores as sc on sc.DailyLivingActivityId = act.DailyLivingActivityId
where sc.DocumentVersionId = @DocumentVersionId 
and isnull(sc.RecordDeleted, 'N') <> 'Y'
order by  act.SortOrder


--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   '[csp_RDLCustomDocumentDLA20Youth] : An Error Occured.'                                                 
		Return                                                
	End   


GO


