IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ObjectiveProgressGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ObjectiveProgressGoals]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[csp_ObjectiveProgressGoals]     
(                                                      
 @ClientID int,                                
 @StaffID int,                              
 @CustomParameters xml                                                      
)                                                                              
As                                                                                       
                                                                                       
Begin                            
Begin try    
DECLARE @CarePlanLatestDocumentVersionID int  
declare @ObjectiveProgress varchar(MAX)  
DECLARE @OverallProgress Varchar(MAX)  
Declare @EpisodeRegistrationDate datetime  
  
SELECT @EpisodeRegistrationDate = ce.RegistrationDate  
FROM ClientEpisodes ce  
WHERE ce.ClientId = @ClientID AND  
      ce.Status <> 102 AND  
      ISNULL(ce.RecordDeleted,'N') = 'N'         
  
SET @CarePlanLatestDocumentVersionID =( SELECT TOP 1 CurrentDocumentVersionId     
from Careplangoals CP,Documents Doc                                                                                    
where CP.DocumentVersionId=Doc.CurrentDocumentVersionId and     
      Doc.ClientId=@ClientID and     
      Doc.Status=22 and     
      Doc.EffectiveDate >= @EpisodeRegistrationDate and    
      IsNull(CP.RecordDeleted,'N')='N' and     
      IsNull(Doc.RecordDeleted,'N')='N'                                                        
ORDER BY Doc.EffectiveDate DESC,Doc.ModifiedDate desc                                                             
)    
  
  
declare @tempGoal table    
(    
tableid int identity(1,1) primary key,    
GoalId int,    
GoalNumber int,    
MemeberGoalVision varchar(MAX),    
GoalDescription varchar(MAX),
Status varchar(10),
GoalStartdate Date    
)    
    
    
    
declare @tempGoalRecordCount int    
declare @tempGoalInit int    
declare @tempObjectiveRecordCount int    
declare @tempObjectiveInit int    
    
set @tempGoalInit = 1    
set @tempObjectiveInit = 1    
set @ObjectiveProgress = ''    
    
insert into @tempGoal (GoalId,GoalNumber,MemeberGoalVision,GoalDescription,Status,GoalStartDate)    
select CarePlanGoalid, GoalNumber,ISNULL(ClientGoal,''),CCPDG.GoalDescription,     
CASe when GoalActive = 'Y' then 'Active' when GoalActive = 'N' then 'Inactive' end as Status,GoalStartdate    
from Careplangoals CDCPG Inner Join CarePlanDomainGoals CCPDG ON CCPDG.CareplanDomainGoalId=CDCPG.CareplanDomainGoalId AND ISNULL(CCPDG.RecordDeleted,'N')<>'Y'    
where DocumentVersionId = @CarePlanLatestDocumentVersionID AND ISNULL(CDCPG.RecordDeleted,'N')<>'Y'    
    
set @tempGoalRecordCount = @@ROWCOUNT    
    
if(@tempGoalRecordCount = 0)    
begin    
set @ObjectiveProgress = ''    
end    
    
else    
begin    
set @tempGoalInit = 1    
    
    
while(@tempGoalInit <= @tempGoalRecordCount)    
 begin    
 set @ObjectiveProgress = @ObjectiveProgress + 'Goal ' + (select CAST(GoalNumber as varchar(10)) from @tempGoal where tableid = @tempGoalInit) + ' - Status: '    
 set @ObjectiveProgress = @ObjectiveProgress + (select Status from @tempGoal where tableid = @tempGoalInit) + Char(13)+ CHAR(10) + 'Client Goal/Vision - '    
 set @ObjectiveProgress = @ObjectiveProgress + (select MemeberGoalVision from @tempGoal where tableid = @tempGoalInit) + Char(13) + CHAR(10) + 'Goal Description - '    
 set @ObjectiveProgress = @ObjectiveProgress + (select GoalDescription from @tempGoal where tableid = @tempGoalInit) + CHAR(13) + CHAR(10)   
 set @ObjectiveProgress = @ObjectiveProgress + 'Start Date: '+ (select CAST(GoalStartdate as varchar(15)) from @tempGoal where tableid = @tempGoalInit) + Char(13) + CHAR(10)      
     
      
  create table #tempObjective     
  (    
  tableid int identity(1,1) primary key,    
  ObjectiveId int,    
  GoalId int,    
  ObjectiveNumber decimal(18,2),    
  Status varchar(10),    
  ObjectiveDescription varchar(max),    
  MemberActions varchar(max),
  Startdate Date 
  )    
      
  insert into #tempObjective(ObjectiveId, GoalId, ObjectiveNumber, Status,ObjectiveDescription, MemberActions,Startdate)    
  select CarePlanObjectiveId,CarePlanGoalId,ObjectiveNumber,    
  CASe when Status = 'A' then 'Active' when Status = 'D' then 'Inactive' end as Status    
  ,do.ObjectiveDescription   
,ISNULL(MemberActions,''),CONVERT (DATE,ObjectiveStartDate)from Careplanobjectives o    
  join CareplanDomainObjectives do on do.CarePlanDomainObjectiveId = o.CarePlanDomainObjectiveId    
  where CarePlanGoalId = (select GoalId from @tempGoal where tableid = @tempGoalInit)    
      
  set @tempObjectiveRecordCount = @@ROWCOUNT    
      
  while(@tempObjectiveInit < = @tempObjectiveRecordCount)    
  BEGIN    
  set @ObjectiveProgress = @ObjectiveProgress + 'Objective ' + (select CAST(ObjectiveNumber as varchar(5)) from #tempObjective where tableid = @tempObjectiveInit) + ' - Status: '  -- 7/17/2013 JR    
  set @ObjectiveProgress = @ObjectiveProgress + (select Status from #tempObjective where tableid = @tempObjectiveInit) + Char(13)+ CHAR(10)       
  set @ObjectiveProgress = @ObjectiveProgress + 'Objective Description: ' + (select ObjectiveDescription from #tempObjective where tableid = @tempObjectiveInit) + Char(13)+ CHAR(10)       
  set @ObjectiveProgress = @ObjectiveProgress + (select MemberActions from #tempObjective where tableid = @tempObjectiveInit) + Char(13) 
  set @ObjectiveProgress = @ObjectiveProgress + 'Last Rating-Start Date: ' + (select CAST(Startdate as varchar(15)) from #tempObjective where tableid = @tempObjectiveInit) + Char(13) + CHAR(10)       
      
      
  set @tempObjectiveInit = @tempObjectiveInit + 1     
  END    
      
 set @ObjectiveProgress = @ObjectiveProgress + Char(13) + CHAR(13)    
 set @tempObjectiveInit = 1    
 drop table #tempObjective    
 set @tempGoalInit = @tempGoalInit + 1     
 end   
 
 SELECT @ObjectiveProgress as Goals
END    
  
  
  
  
  
  
END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_ObjectiveProgressGoals]')                                                                                                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                                    
 RAISERROR                                                                                                       
 (                                                                         
  @Error, -- Message text.                                                                                                      
  16, -- Severity.                                                                                                      
  1 -- State.                                                                                                      
 );                                                                                                    
END CATCH                                                   
END       
  
  