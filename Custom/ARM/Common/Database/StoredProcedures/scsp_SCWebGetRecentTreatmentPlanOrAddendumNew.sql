
/****** Object:  StoredProcedure [dbo].[scsp_SCWebGetRecentTreatmentPlanOrAddendumNew]    Script Date: 06/25/2015 15:28:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCWebGetRecentTreatmentPlanOrAddendumNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCWebGetRecentTreatmentPlanOrAddendumNew]
GO



/****** Object:  StoredProcedure [dbo].[scsp_SCWebGetRecentTreatmentPlanOrAddendumNew]    Script Date: 06/25/2015 15:28:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[scsp_SCWebGetRecentTreatmentPlanOrAddendumNew]   
(@ClientId bigint,    
@DateOfService datetime,    
@ProcedureCodeId int 
)
As

  
/******************************************************************************      
**  File:      
**  Name: ssp_SCGetRecentTreatmentPlanOrAddendum      
**  Desc:      
**      
**  This Stored procedure gets the latest signed Treatment Plan or Addendum for the client.      
**      
**  Return values:A Result set containing information about recent signed treatment plan or addendum.      
**      
      
**      
**  Parameters:      
**  Input    Output      
**     ----------       -----------      
  28/12/2008   Vikas Vyas      
**  --------  --------    -------------------------------------------      
**25/06/2015  Pradeep Kumar Yadav  Took Entire logic of core ssp_SCWebGetRecentTreatmentPlanOrAddendum inside this scsp_SCWebGetRecentTreatmentPlanOrAddendumNew    
                                   In this scsp we have custom logic for the Harbor and rest of the client we have core logic    
** 27/09/2018 Lakshmi   Added isnull check condition (ISNULL(tpg.Active, 'Y') = 'Y') for CustomTPGoals  
*******************************************************************************/  
Begin  
Begin Try      
      
 Declare @RecentDocumentVersionId as int      
      
 select top 1 @RecentDocumentVersionId = CurrentDocumentVersionId      
 from documents      
 where documentcodeid in (1483,1484,1485)      
   and ClientId=@ClientId      
   and status=22      
   and effectivedate<=convert(datetime,convert(varchar,@DateOfService,101))      
   and isnull(RecordDeleted,'N')='N'      
 order by effectivedate desc,modifieddate desc      
      
      
--select top 100 * from dbo.Documents where DocumentCodeId in (1483,1484,1485) and ISNULL(RecordDeleted,'n') <> 'y' and Status = 22 order by 1 desc      
--select * from dbo.CustomTPGoals      
      
 select tpg.TPGoalId as NeedId,      
    tpg.DocumentVersionId,      
    tpg.GoalNumber as NeedNumber,      
    tpg.GoalText as NeedText,      
    CAST(null as varchar(MAX)) as NeedTextRTF,      
    tpg.CreatedDate as NeedCreatedDate,      
    tpg.ModifiedDate as NeedModifiedDate,      
    tpg.GoalText,      
    CAST(null as varchar(MAX)) as GoalTextRTF,      
    CAST(null as varchar(MAX)) as GoalDesiredResults,      
    tpg.Active as GoalActive,      
    CAST(null as char(1)) as GoalNaturalSupports,      
    CAST(null as char(1)) as GoalLivingArrangement,      
    CAST(null as char(1)) as GoalEmployment,      
    CAST(null as char(1)) as GoalHealthSafety,      
    CAST(null as varchar(MAX)) as GoalStrengths,      
    CAST(null as varchar(MAX)) as GoalBarriers,      
    --GoalMonitoredBy,      
    CAST(null as datetime) as GoalStartDate,      
    tpg.TargeDate as GoalTargetDate,      
    CAST(null as int) as StageOfTreatment,      
    CAST(null as int) as SourceNeedId,      
    --RowIdentifier,      
    tpg.CreatedBy,      
    tpg.CreatedDate,      
    tpg.ModifiedBy,      
    tpg.ModifiedDate,      
    tpg.RecordDeleted,      
    tpg.DeletedDate,      
    tpg.DeletedBy      
  FROM dbo.CustomTPGoals as tpg      
  where DocumentVersionId=@RecentDocumentVersionId      
  and Isnull(RecordDeleted,'N')='N'      
  and ISNULL(tpg.Active, 'Y') = 'Y'
  and convert(datetime,convert(varchar(8),isnull(tpg.TargeDate,getdate()),112))  >= convert(datetime,convert(varchar(8),getdate(),112))         
      
      
 -- Data from TPObjectives      
      
--select * from dbo.CustomTPObjectives      
--exec sp_help 'tpobjectives'      
      
 select      
 o.TPObjectiveId as ObjectiveId,      
    n.DocumentVersionId,      
    o.TPGoalId as NeedId,      
    o.ObjectiveNumber,      
    o.ObjectiveText,      
    CAST(null as varchar(MAX)) as ObjectiveTextRTF,      
    o.Status as ObjectiveStatus,      
    o.TargetDate,      
    CAST(null as uniqueidentifier) as RowIdentifier,      
    o.CreatedBy,      
    o.CreatedDate,      
    o.ModifiedBy,      
    o.ModifiedDate,      
    o.RecordDeleted,      
    o.DeletedDate,      
 o.DeletedBy,      
    'Goals / Objectives indicating this procedure based upon intervention(s)' as ObjectiveGrouping      
      
 FROM CustomTPObjectives o      
 Join CustomTPGoals n on n.TPGoalId = o.TPGoalId      
 WHERE      
   ISNULL(n.Active, 'Y') = 'Y'      
   AND n.DocumentVersionId = @RecentDocumentVersionId      
   --AND n.Status IN (191)      
   AND convert(datetime,convert(varchar(8),isnull(o.TargetDate,getdate()),112))  >= convert(datetime,convert(varchar(8),getdate(),112))      
   AND ISNULL(o.RecordDeleted, 'N') = 'N'      
   and ISNULL(n.RecordDeleted, 'N') = 'N'      
      
 End Try      
 Begin Catch      
  declare @Error varchar(8000)      
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())      
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetRecentTreatmentPlanOrAddendum')      
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())      
  + '*****' + Convert(varchar,ERROR_STATE())      
 End Catch    
End  
GO


