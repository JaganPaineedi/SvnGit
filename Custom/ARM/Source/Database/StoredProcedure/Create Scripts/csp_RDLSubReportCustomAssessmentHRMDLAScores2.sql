/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores2]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure   [dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores2]
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010               
)                
AS                
          

/************************************************************************/                                                
/* Stored Procedure: [csp_RDLSubReportCustomAssessmentHRMDLAScores]		*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  July 30, 2008										*/                                                
/*																		*/                                                
/* Purpose: HRM assessment sub report for DLA scores					*/                                    
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Tom Remisoski												*/                                                
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
, isnull(c.FieldName,'''') as FieldName
From Cstm_Conv_Map_DocumentInitializationLog c
--Left Join DocumentValidations d on c.TabName=d.TabName and c.TableName=d.TableName
Where c.TableName=''CustomDailyLivingActivityScores''
*/
select distinct 
 @DocumentId
,null
,''CustomHRMActivities''
,''CustomHRMActivities'' as TableName
,c.HRMActivityId as ColumnName
,Null as GroupName
,c.HRMActivityId as FieldName
from CustomHRMActivities c


update v
set StatusData = case di.InitializationStatus 
	when 5871 then ''To Verify'' --To Validate
	when 5872 then ''Reviewed and Verified '' + @StatusDate
	when 5873 then ''Reviewed and Updated '' + @StatusDate
	when 5874 then ''Reviewed and Cleared '' + @StatusDate
	else ''*Error ''  end
from #Verify v
join DocumentInitializationLog di on v.DocumentId = di.DocumentId and ISNULL(di.RecordDeleted,''N'')<>''Y'' 
join GlobalCodes gc on gc.GlobalCodeId = di.InitializationStatus
join CustomDailyLivingActivityScores dla on dla.DailyLivingActivityScoreId = di.ChildRecordId  and ISNULL(dla.RecordDeleted,''N'')<>''Y''
where di.DocumentId=v.DocumentId
and dla.HRMActivityId = v.ColumnName


select 
	act.HRMActivityDescription,
	act.SortOrder,
	sc.ActivityScore,
	sc.ActivityComment,
	case when v.StatusData is null then null else v.StatusData + '': '' end as CommentLabel
from dbo.CustomHRMActivities as act
join dbo.CustomDailyLivingActivityScores as sc on sc.HRMActivityId = act.HRMActivityId
left join #Verify v on v.ColumnName = sc.HRMActivityId 
where sc.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010     
and isnull(sc.RecordDeleted, ''N'') <> ''Y''
order by  act.SortOrder







--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   ''[csp_RDLSubReportCustomAssessmentHRMDLAScores2] : An Error Occured''                                                 
		Return                                                
	End
' 
END
GO
