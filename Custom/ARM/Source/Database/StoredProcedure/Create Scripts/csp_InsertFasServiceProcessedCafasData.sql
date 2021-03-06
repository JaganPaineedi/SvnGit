/****** Object:  StoredProcedure [dbo].[csp_InsertFasServiceProcessedCafasData]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InsertFasServiceProcessedCafasData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InsertFasServiceProcessedCafasData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InsertFasServiceProcessedCafasData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_InsertFasServiceProcessedCafasData]   
@FASRequestId int  ,
@DocumentVersionID int
-- =============================================
-- Author:		Mahesh	
-- Create date: 11 October 2010
-- Description:	To process the Response received from FasSevices and Save in the desired Format.
-- Form Called: SHS.DataServices.HRMAssessment.cs
-- =============================================
as  
  
set nocount on  
set ansi_warnings off  
  
declare @idoc int  
declare @doc xml  
declare @errorno int  
declare @errormsg varchar(max)  
declare @ResponseError char(1) 
declare @ClientID varchar(50) 
  
declare @Assessments table (  
ResponseRecordId                         int identity not null,  
CAFASAssessmentId                        int,  
AssessmentId                             uniqueidentifier,  
AssessmentDate                           datetime,  
IsDeleted                                varchar(3),  
ClientId                                 varchar(20),  
ClientName                               varchar(100),  
ClientAge                                int,  
AdministrationDescription                varchar(100),  
IsLocked                                 varchar(5),  
AssessmentStatus                         varchar(20),  
EmployeeId                               varchar(20),  
ServiceAreaCode                          varchar(20),  
ServiceAreaName                          varchar(50),  
ProgramCode                              varchar(20),  
ProgramName                              varchar(50),  
Rater                                    varchar(100),  
EpisodeNumber                            int,  
TotalScore                               int,  
CAFASTier                                varchar(50),  
RiskBehaviors                            varchar(max),  
ChildMgmtConsider                        varchar(20),  
SevereImpairmentsTotal                   int,  
PervasiveBehImpResult                    varchar(20),  
ChangeTotalScore                         int,  
ChangeSevereImpairments                  varchar(20),  
ChangePervasiveBehImp                    varchar(20),  
ChangeMeaningfulReliableDiff             varchar(20),  
ChangeImprovement1orMore                 varchar(20),  
YouthSchoolScore                         int,  
YouthSchoolCouldNotScore                 varchar(5),  
YouthSchoolExplanation                   varchar(max),  
YouthSchoolPlanText                      varchar(max),  
YouthHomeScore                           int,  
YouthHomeCouldNotScore                   varchar(5),  
YouthHomeExplanation                     varchar(max),  
YouthHomePlanText                        varchar(max),  
YouthCommunityScore                      int,  
YouthCommunityCouldNotScore              varchar(5),  
YouthCommunityExplanation                varchar(max),  
YouthCommunityPlanText                   varchar(max),  
YouthBehaviorScore                       int,  
YouthBehaviorCouldNotScore               varchar(5),  
YouthBehaviorExplanation                 varchar(max),  
YouthBehaviorPlanText                    varchar(max),  
YouthMoodsScore                          int,  
YouthMoodsCouldNotScore                  varchar(5),  
YouthMoodsExplanation                    varchar(max),  
YouthMoodsPlanText                       varchar(max),  
YouthSelfHarmScore                       int,  
YouthSelfHarmCouldNotScore               varchar(5),  
YouthSelfHarmExplanation                 varchar(max),  
YouthSelfHarmPlanText                    varchar(max),  
YouthSubUseScore                         int,  
YouthSubUseCouldNotScore                 varchar(5),  
YouthSubUseExplanation                   varchar(max),  
YouthSubUsePlanText                      varchar(max),  
YouthThinkingScore                       int,  
YouthThinkingCouldNotScore               varchar(5),  
YouthThinkingExplanation                 varchar(max),  
YouthThinkingPlanText            varchar(max),  
CaregiverPrimaryMaterialScore            int,  
CaregiverPrimarySocialScore              int,  
CaregiverPrimaryCouldNotScore            varchar(5),  
CaregiverPrimaryCaregiverName            varchar(100),  
CaregiverPrimaryCaregiverRelation        varchar(50),  
CaregiverPrimaryMaterialExplanation      varchar(max),  
CaregiverPrimarySocialExplanation        varchar(max),  
CaregiverPrimaryPlanText                 varchar(max),  
CaregiverNonCustodialMaterialScore       int,  
CaregiverNonCustodialSocialScore         int,  
CaregiverNonCustodialCouldNotScore       varchar(5),  
CaregiverNonCustodialCaregiverName       varchar(100),  
CaregiverNonCustodialCaregiverRelation   varchar(50),  
CaregiverNonCustodialMaterialExplanation varchar(max),  
CaregiverNonCustodialSocialExplanation   varchar(max),  
CaregiverNonCustodialPlanText            varchar(max),  
CaregiverSurrogateMaterialScore          int,  
CaregiverSurrogateSocialScore            int,  
CaregiverSurrogateCouldNotScore          varchar(5),  
CaregiverSurrogateCaregiverName          varchar(100),  
CaregiverSurrogateCaregiverRelation      varchar(50),  
CaregiverSurrogateMaterialExplanation    varchar(max),  
CaregiverSurrogateSocialExplanation      varchar(max),  
CaregiverSurrogatePlanText               varchar(max))  
  
declare @RiskBehaviors table (  
BehaviorId    int identity not null,  
AssessmentId  uniqueidentifier,  
Behavior      varchar(max))  
  
select @doc = ResponseXML  
  from CustomFASRequestLog  
 where FASRequestId = @FASRequestId  
  
--set @doc = replace(@doc, ''’'', '''''''')  
  
exec sp_xml_preparedocument @idoc output, @doc  
  
if @@error <> 0  
begin  
  select @errorno = 50010, @errormsg = ''Failed to execute sp_xml_preparedocument''  
  goto error  
end  
  
-- Check for response errors  
select @ResponseError = Error  
 from openxml(@idoc, ''/response'', 2)  
        with (Error  char(1)  ''@error'')  
  
if isnull(@ResponseError, '''') <> ''0''  
begin  
  update CustomFASRequestLog  
     set ResponseProcessed = ''Y'',  
         ResponseError = ''Y''  
   where FASRequestId = @FASRequestId  
  
  if @@error <> 0  
  begin  
    select @errorno = 50015, @errormsg = ''Failed to update CustomFASRequestLog''  
     
    goto error  
  end  
  
  return  
end  

-- Check if Response is received but ClientID doesnot Exist and Even no Error is thrown

--select @ClientID= ClientID 
--        from openxml(@idoc, ''/response/clientAssessments/client'',1)--/assessment/youthSubscaleScores/Subscale'',2)  
--                       with (ClientID  int ''@primaryId'')
--	if @ClientID is null 
--	Begin
--		  update CustomFASRequestLog  
--     set ResponseProcessed = ''N'',  
--         ResponseError = ''Y''  
--   where FASRequestId = @FASRequestId  
   
--   if @@error <> 0  
--  begin  
--    select @errorno = 50016, @errormsg = ''Failed to update CustomFASRequestLog''  
     
--    goto error  
--  end  
  
--  return 
--	End 
--	else
--	Begin
--		update CustomFASRequestLog  
--     set ResponseProcessed = ''Y'',  
--         ResponseError = ''N''  
--   where FASRequestId = @FASRequestId  
   
--   if @@error <> 0  
--  begin  
--    select @errorno = 50017, @errormsg = ''Failed to update CustomFASRequestLog''  
     
--    goto error  
--  end  
  
--  return 
--	End
	
  
--  
-- Process assessmens  
--  
  
insert into @Assessments (  
       AssessmentId,  
       AssessmentDate,  
       IsDeleted,  
       ClientId,  
       ClientName,  
       ClientAge,  
       AdministrationDescription,  
       IsLocked,  
       AssessmentStatus,  
       EmployeeId,  
       ServiceAreaCode,  
       ServiceAreaName,  
       ProgramCode,  
       ProgramName,  
       Rater,  
       EpisodeNumber,  
       TotalScore,  
       CAFASTier,  
       ChildMgmtConsider,  
       SevereImpairmentsTotal,  
       PervasiveBehImpResult,  
       ChangeTotalScore,  
       ChangeSevereImpairments,  
       ChangePervasiveBehImp,  
       ChangeMeaningfulReliableDiff,  
       ChangeImprovement1orMore)  
select AssessmentId,  
       AssessmentDate,  
       IsDeleted,  
       ClientId,  
       ClientName,  
       ClientAge,  
       AdministrationDescription,  
       IsLocked,  
       AssessmentStatus,  
       EmployeeId,  
       ServiceAreaCode,  
       ServiceAreaName,  
       ProgramCode,  
       ProgramName,  
       Rater,  
       EpisodeNumber,  
       case when TotalScore = '''' then null else TotalScore end,  
       CAFASTier,  
       ChildMgmtConsider,  
       SevereImpairmentsTotal,  
       PervasiveBehImpResult,  
       case when ChangeTotalScore = '''' then null else ChangeTotalScore end,  
       ChangeSevereImpairments,  
       ChangePervasiveBehImp,  
       ChangeMeaningfulReliableDiff,  
       ChangeImprovement1orMore  
  from openxml(@idoc, ''/response/clientAssessments/client/assessment'',2)  
          with(AssessmentId uniqueidentifier ''@assessmentID'',  
               AssessmentDate datetime ''@assessmentDate'',  
               ClientId varchar(20) ''../@primaryId'',  
               ClientName varchar(100) ''../@name'',  
               ClientAge int ''../@age'',  
               IsDeleted varchar(3) ''@isDeleted'',  
               AdministrationDescription varchar(100) ''@administrationDescription'',  
               IsLocked varchar(5) ''@isLocked'',  
               AssessmentStatus varchar(20) ''@assessmentStatus'',  
               EmployeeID varchar(20) ''@employeeID'',  
               ServiceAreaCode varchar(20) ''@serviceAreaCode'',  
               ServiceAreaName varchar(50) ''@serviceAreaName'',  
               ProgramCode varchar(20)'' @programCode'',  
               ProgramName varchar(50) ''@programName'',  
               Rater varchar(100) ''@rater'',  
               EpisodeNumber int ''@episodeNumber'',  
               TotalScore varchar(20) ''@totalScore'',  
               CAFASTier varchar(50) ''CAFASTier'',  
               ChildMgmtConsider varchar(20) ''childMgmt/@consider'',  
               SevereImpairmentsTotal int ''severeImpairments/@total'',  
               PervasiveBehImpResult varchar(20) ''pervasiveBehImp/@result'',  
               ChangeTotalScore varchar(20) ''change/totalScore/@change'',  
               ChangeSevereImpairments varchar(20) ''change/severeImpairments/@change'',  
               ChangePervasiveBehImp varchar(20) ''change/pervasiveBehImp/@change'',  
               ChangeMeaningfulReliableDiff varchar(20) ''change/meaningfulReliableDiff/@change'',  
               ChangeImprovement1orMore varchar(20) ''change/improvement1orMore/@change'')  
  
if @@error <> 0  
begin  
  select @errorno = 50020, @errormsg = ''Failed to openxml - assessment''  
  goto error  
end  
  
update a  
   set YouthSchoolScore = case when s.YouthSchoolScore = '''' then null else s.YouthSchoolScore end,  
       YouthSchoolCouldNotScore = s.YouthSchoolCouldNotScore,  
       YouthSchoolExplanation = s.YouthSchoolExplanation,  
       YouthSchoolPlanText = s.YouthSchoolPlanText,  
       YouthHomeScore = case when s.YouthHomeScore = '''' then null else s.YouthHomeScore end,  
       YouthHomeCouldNotScore = s.YouthHomeCouldNotScore,  
       YouthHomeExplanation = s.YouthHomeExplanation,  
       YouthHomePlanText = s.YouthHomePlanText,  
       YouthCommunityScore = case when s.YouthCommunityScore = '''' then null else s.YouthCommunityScore end,   
       YouthCommunityCouldNotScore = s.YouthCommunityCouldNotScore,  
       YouthCommunityExplanation = s.YouthCommunityExplanation,    
       YouthCommunityPlanText = s.YouthCommunityPlanText,       
       YouthBehaviorScore = case when s.YouthBehaviorScore = '''' then null else s.YouthBehaviorScore end,           
       YouthBehaviorCouldNotScore = s.YouthBehaviorCouldNotScore,   
       YouthBehaviorExplanation = s.YouthBehaviorExplanation,     
       YouthBehaviorPlanText = s.YouthBehaviorPlanText,        
       YouthMoodsScore = case when s.YouthMoodsScore = '''' then null else s.YouthMoodsScore end,     
       YouthMoodsCouldNotScore = s.YouthMoodsCouldNotScore,      
       YouthMoodsExplanation = s.YouthMoodsExplanation,        
       YouthMoodsPlanText = s.YouthMoodsPlanText,           
       YouthSelfHarmScore = case when s.YouthSelfHarmScore = '''' then null else s.YouthSelfHarmScore end,           
       YouthSelfHarmCouldNotScore = s.YouthSelfHarmCouldNotScore,   
       YouthSelfHarmExplanation = s.YouthSelfHarmExplanation,     
       YouthSelfHarmPlanText = s.YouthSelfHarmPlanText,        
       YouthSubUseScore = case when s.YouthSubUseScore = '''' then null else s.YouthSubUseScore end,             
       YouthSubUseCouldNotScore = s.YouthSubUseCouldNotScore,     
       YouthSubUseExplanation = s.YouthSubUseExplanation,       
       YouthSubUsePlanText = s.YouthSubUsePlanText,          
       YouthThinkingScore = case when s.YouthThinkingScore = '''' then null else s.YouthThinkingScore end,           
       YouthThinkingCouldNotScore = s.YouthThinkingCouldNotScore,   
       YouthThinkingExplanation = s.YouthThinkingExplanation,     
       YouthThinkingPlanText = s.YouthThinkingPlanText  
  from @Assessments a  
       join (select AssessmentId,  
                    max(case when SubscaleName = ''School / Work'' then Score else null end) as YouthSchoolScore,  
                    max(case when SubscaleName = ''School / Work'' then CouldNotScore else null end) as YouthSchoolCouldNotScore,  
                    max(case when SubscaleName = ''School / Work'' then Explanation else null end) as YouthSchoolExplanation,  
                    max(case when SubscaleName = ''School / Work'' then PlanText else null end) as YouthSchoolPlanText,  
  
                    max(case when SubscaleName = ''Home'' then Score else null end) as YouthHomeScore,  
                    max(case when SubscaleName = ''Home'' then CouldNotScore else null end) as YouthHomeCouldNotScore,  
                    max(case when SubscaleName = ''Home'' then Explanation else null end) as YouthHomeExplanation,  
                    max(case when SubscaleName = ''Home'' then PlanText else null end) as YouthHomePlanText,  
  
                    max(case when SubscaleName = ''Community'' then Score else null end) as YouthCommunityScore,  
                    max(case when SubscaleName = ''Community'' then CouldNotScore else null end) as YouthCommunityCouldNotScore,  
                    max(case when SubscaleName = ''Community'' then Explanation else null end) as YouthCommunityExplanation,  
                    max(case when SubscaleName = ''Community'' then PlanText else null end) as YouthCommunityPlanText,  
  
                    max(case when SubscaleName = ''Behavior Toward Others'' then Score else null end) as YouthBehaviorScore,  
                    max(case when SubscaleName = ''Behavior Toward Others'' then CouldNotScore else null end) as YouthBehaviorCouldNotScore,  
                    max(case when SubscaleName = ''Behavior Toward Others'' then Explanation else null end) as YouthBehaviorExplanation,  
                    max(case when SubscaleName = ''Behavior Toward Others'' then PlanText else null end) as YouthBehaviorPlanText,  
  
                    max(case when SubscaleName = ''Moods / Emotions'' then Score else null end) as YouthMoodsScore,  
                    max(case when SubscaleName = ''Moods / Emotions'' then CouldNotScore else null end) as YouthMoodsCouldNotScore,  
                    max(case when SubscaleName = ''Moods / Emotions'' then Explanation else null end) as YouthMoodsExplanation,  
                    max(case when SubscaleName = ''Moods / Emotions'' then PlanText else null end) as YouthMoodsPlanText,  
  
                    max(case when SubscaleName = ''Self-Harmful Behavior'' then Score else null end) as YouthSelfHarmScore,  
                    max(case when SubscaleName = ''Self-Harmful Behavior'' then CouldNotScore else null end) as YouthSelfHarmCouldNotScore,  
                    max(case when SubscaleName = ''Self-Harmful Behavior'' then Explanation else null end) as YouthSelfHarmExplanation,  
                    max(case when SubscaleName = ''Self-Harmful Behavior'' then PlanText else null end) as YouthSelfHarmPlanText,  
  
                    max(case when SubscaleName = ''Substance Use'' then Score else null end) as YouthSubUseScore,  
                    max(case when SubscaleName = ''Substance Use'' then CouldNotScore else null end) as YouthSubUseCouldNotScore,  
                    max(case when SubscaleName = ''Substance Use'' then Explanation else null end) as YouthSubUseExplanation,  
                    max(case when SubscaleName = ''Substance Use'' then PlanText else null end) as YouthSubUsePlanText,  
  
                    max(case when SubscaleName = ''Thinking'' then Score else null end) as YouthThinkingScore,  
                    max(case when SubscaleName = ''Thinking'' then CouldNotScore else null end) as YouthThinkingCouldNotScore,  
                    max(case when SubscaleName = ''Thinking'' then Explanation else null end) as YouthThinkingExplanation,  
                    max(case when SubscaleName = ''Thinking'' then PlanText else null end) as YouthThinkingPlanText  
               from openxml(@idoc, ''/response/clientAssessments/client/assessment/youthSubscaleScores/Subscale'',2)  
                       with (AssessmentId  uniqueidentifier ''../../@assessmentID'',  
                             SubscaleName  varchar(50)  ''@name'',  
                             Score         varchar(20)  ''@score'',  
                             CouldNotScore varchar(5)   ''@isCouldNotScore'',  
                             Explanation   varchar(max) ''explanation'',  
                             PlanText      varchar(max) ''planText'')  
             group by AssessmentId) as s on s.AssessmentId = a.AssessmentId  
  
if @@error <> 0  
begin  
  select @errorno = 50030, @errormsg = ''Failed to openxml - youthSubscaleScores''  
  goto error  
end  
  
update a  
   set CaregiverPrimaryMaterialScore = case when s.CaregiverPrimaryMaterialScore = '''' then null else s.CaregiverPrimaryMaterialScore end,  
       CaregiverPrimarySocialScore = case when s.CaregiverPrimarySocialScore = '''' then null else s.CaregiverPrimarySocialScore end,  
       CaregiverPrimaryCouldNotScore = s.CaregiverPrimaryCouldNotScore,  
       CaregiverPrimaryCaregiverName = s.CaregiverPrimaryCaregiverName,  
       CaregiverPrimaryCaregiverRelation = s.CaregiverPrimaryCaregiverRelation,  
       CaregiverPrimaryMaterialExplanation = s.CaregiverPrimaryMaterialExplanation,  
       CaregiverPrimarySocialExplanation = s.CaregiverPrimarySocialExplanation,  
       CaregiverPrimaryPlanText = s.CaregiverPrimaryPlanText,  
       CaregiverNonCustodialMaterialScore = case when s.CaregiverNonCustodialMaterialScore = '''' then null else s.CaregiverNonCustodialMaterialScore end,  
       CaregiverNonCustodialSocialScore = case when s.CaregiverNonCustodialSocialScore = '''' then null else s.CaregiverNonCustodialSocialScore end,  
       CaregiverNonCustodialCouldNotScore = s.CaregiverNonCustodialCouldNotScore,  
       CaregiverNonCustodialCaregiverName = s.CaregiverNonCustodialCaregiverName,  
       CaregiverNonCustodialCaregiverRelation = s.CaregiverNonCustodialCaregiverRelation,  
       CaregiverNonCustodialMaterialExplanation = s.CaregiverNonCustodialMaterialExplanation,  
       CaregiverNonCustodialSocialExplanation = s.CaregiverNonCustodialSocialExplanation,  
       CaregiverNonCustodialPlanText = s.CaregiverNonCustodialPlanText,  
       CaregiverSurrogateMaterialScore = case when s.CaregiverSurrogateMaterialScore = '''' then null else s.CaregiverSurrogateMaterialScore end,  
       CaregiverSurrogateSocialScore = case when s.CaregiverSurrogateSocialScore = '''' then null else s.CaregiverSurrogateSocialScore end,  
       CaregiverSurrogateCouldNotScore = s.CaregiverSurrogateCouldNotScore,  
       CaregiverSurrogateCaregiverName = s.CaregiverSurrogateCaregiverName,  
       CaregiverSurrogateCaregiverRelation = s.CaregiverSurrogateCaregiverRelation,  
       CaregiverSurrogateMaterialExplanation = s.CaregiverSurrogateMaterialExplanation,  
       CaregiverSurrogateSocialExplanation = s.CaregiverSurrogateSocialExplanation,  
       CaregiverSurrogatePlanText = s.CaregiverSurrogatePlanText  
  from @Assessments a  
       join (select AssessmentId,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then MaterialNeedsScore else null end) as CaregiverPrimaryMaterialScore,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then SocialSupportScore else null end) as CaregiverPrimarySocialScore,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then CouldNotScore else null end) as CaregiverPrimaryCouldNotScore,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then CaregiverName else null end) as CaregiverPrimaryCaregiverName,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then CaregiverRelation else null end) as CaregiverPrimaryCaregiverRelation,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then ExplanationMaterial else null end) as CaregiverPrimaryMaterialExplanation,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then ExplanationSupport else null end) as CaregiverPrimarySocialExplanation,  
                    max(case when SubscaleName = ''Caregiver Resources -Primary Material Needs'' then PlanText else null end) as CaregiverPrimaryPlanText,  
  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then MaterialNeedsScore else null end) as CaregiverNonCustodialMaterialScore,  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then SocialSupportScore else null end) as CaregiverNonCustodialSocialScore,  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then CouldNotScore else null end) as CaregiverNonCustodialCouldNotScore,  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then CaregiverName else null end) as CaregiverNonCustodialCaregiverName,  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then CaregiverRelation else null end) as CaregiverNonCustodialCaregiverRelation,  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then ExplanationMaterial else null end) as CaregiverNonCustodialMaterialExplanation,  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then ExplanationSupport else null end) as CaregiverNonCustodialSocialExplanation,  
                    max(case when SubscaleName = ''Caregiver Resources - Non Custodial Material Needs'' then PlanText else null end) as CaregiverNonCustodialPlanText,  
  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then MaterialNeedsScore else null end) as CaregiverSurrogateMaterialScore,  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then SocialSupportScore else null end) as CaregiverSurrogateSocialScore,  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then CouldNotScore else null end) as CaregiverSurrogateCouldNotScore,  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then CaregiverName else null end) as CaregiverSurrogateCaregiverName,  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then CaregiverRelation else null end) as CaregiverSurrogateCaregiverRelation,  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then ExplanationMaterial else null end) as CaregiverSurrogateMaterialExplanation,  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then ExplanationSupport else null end) as CaregiverSurrogateSocialExplanation,  
                    max(case when SubscaleName = ''Caregiver Resources - Surrogate Material Needs'' then PlanText else null end) as CaregiverSurrogatePlanText  
               from openxml(@idoc, ''/response/clientAssessments/client/assessment/caregiverSubscaleScores/Subscale'',2)  
                       with(AssessmentId        uniqueidentifier ''../../@assessmentID'',  
                            SubscaleName        varchar(100) ''@name'',  
                            MaterialNeedsScore  varchar(20)  ''@materialNeedsScore'',  
                            SocialSupportScore  varchar(20)  ''@socialSupportScore'',  
                            CouldNotScore       varchar(5)   ''@isCouldNotScore'',  
                            CaregiverName       varchar(100) ''@caregiverName'',  
                            CaregiverRelation   varchar(50)  ''@caregiverRelation'',  
                            ExplanationMaterial varchar(max) ''explanation'',  
                            ExplanationSupport  varchar(max) ''explanation2'',  
                            PlanText            varchar(max) ''planText'')  
                 group by AssessmentId) as s on s.AssessmentId = a.AssessmentId  
  
if @@error <> 0  
begin  
  select @errorno = 50040, @errormsg = ''Failed to openxml - caregiverSubscaleScores''  
  goto error  
end  
  
insert into @RiskBehaviors (AssessmentId, Behavior)  
select AssessmentId, Behavior  
  from openxml(@idoc, ''/response/clientAssessments/client/assessment/riskBehaviors/behavior'',2)  
          with (AssessmentId uniqueidentifier ''../../@assessmentID'',  
                Behavior varchar(max) ''.'')  
 order by AssessmentId  
  
if @@error <> 0  
begin  
  select @errorno = 50050, @errormsg = ''Failed to openxml - riskBehaviors''  
  goto error  
end  
  
exec sp_xml_removedocument @idoc  
  
if @@error <> 0  
begin  
  select @errorno = 50060, @errormsg = ''Failed to execute sp_xml_removedocument''  
  goto error  
end  
  
while exists(select * from @RiskBehaviors)  
begin  
  update a  
     set RiskBehaviors = case when len(a.RiskBehaviors) > 0 then a.RiskBehaviors + char(13) + char(10) else '''' end + rb.Behavior  
    from @Assessments a  
         join @RiskBehaviors rb on rb.AssessmentId = a.AssessmentId  
   where not exists(select *  
                      from @RiskBehaviors rb2  
                     where rb2.AssessmentId = a.AssessmentId  
                       and rb2.BehaviorId < rb.BehaviorId)  
  
  if @@error <> 0    
  begin  
    select @errorno = 50070, @errormsg = ''Failed to update @Assessments''  
    goto error  
  end  
  
  delete rb  
    from @RiskBehaviors rb  
   where not exists(select *  
                      from @RiskBehaviors rb2  
                    where rb2.AssessmentId = rb.AssessmentId  
                      and rb2.BehaviorId < rb.BehaviorId)  
  
  if @@error <> 0    
  begin  
    select @errorno = 50080, @errormsg = ''Failed to delete from @RiskBehaviors''  
    goto error  
  end  
end  
  
-- Delete assessment that should excluded  
delete a  
  from @Assessments a  
       join CustomFASExcludeServiceAreaPrograms sap on sap.ServiceAreaCode = a.ServiceAreaCode and sap.ProgramCode = a.ProgramCode  
  
if @@error <> 0    
begin  
  select @errorno = 50085, @errormsg = ''Failed to delete from @Assessments''  
  goto error  
end  
  
begin tran  
  
declare @InsertedAssessments table (CAFASAssessmentId int, ResponseRecordId int)  
  
insert into CustomFASCAFASAssessments (  
       FASRequestId, 
       DocumentVersionId, 
       ResponseRecordId,  
       AssessmentId,  
       AssessmentDate,  
       IsDeleted,  
       ClientId,  
       ClientName,  
       ClientAge,  
       AdministrationDescription,  
       IsLocked,  
       AssessmentStatus,  
       EmployeeId,  
       ServiceAreaCode,  
       ServiceAreaName,  
       ProgramCode,  
       ProgramName,  
       Rater,  
       EpisodeNumber,  
       TotalScore,  
       CAFASTier,  
       RiskBehaviors,  
       ChildMgmtConsider,  
       SevereImpairmentsTotal,  
       PervasiveBehImpResult,  
       ChangeTotalScore,  
       ChangeSevereImpairments,  
       ChangePervasiveBehImp,  
       ChangeMeaningfulReliableDiff,  
       ChangeImprovement1orMore,  
       YouthSchoolScore,  
       YouthSchoolCouldNotScore,  
       YouthSchoolExplanation,  
       YouthSchoolPlanText,  
       YouthHomeScore,  
       YouthHomeCouldNotScore,  
       YouthHomeExplanation,  
       YouthHomePlanText,  
       YouthCommunityScore,  
       YouthCommunityCouldNotScore,  
       YouthCommunityExplanation,  
       YouthCommunityPlanText,  
       YouthBehaviorScore,  
       YouthBehaviorCouldNotScore,  
       YouthBehaviorExplanation,  
       YouthBehaviorPlanText,  
       YouthMoodsScore,  
       YouthMoodsCouldNotScore,  
       YouthMoodsExplanation,  
       YouthMoodsPlanText,  
       YouthSelfHarmScore,  
       YouthSelfHarmCouldNotScore,  
       YouthSelfHarmExplanation,  
       YouthSelfHarmPlanText,  
       YouthSubUseScore,  
       YouthSubUseCouldNotScore,  
       YouthSubUseExplanation,  
       YouthSubUsePlanText,  
       YouthThinkingScore,  
       YouthThinkingCouldNotScore,  
       YouthThinkingExplanation,  
       YouthThinkingPlanText,  
       CaregiverPrimaryMaterialScore,  
       CaregiverPrimarySocialScore,  
       CaregiverPrimaryCouldNotScore,  
       CaregiverPrimaryCaregiverName,  
       CaregiverPrimaryCaregiverRelation,  
       CaregiverPrimaryMaterialExplanation,  
       CaregiverPrimarySocialExplanation,  
       CaregiverPrimaryPlanText,  
       CaregiverNonCustodialMaterialScore,  
       CaregiverNonCustodialSocialScore,  
       CaregiverNonCustodialCouldNotScore,  
       CaregiverNonCustodialCaregiverName,  
       CaregiverNonCustodialCaregiverRelation,  
       CaregiverNonCustodialMaterialExplanation,  
       CaregiverNonCustodialSocialExplanation,  
       CaregiverNonCustodialPlanText,  
       CaregiverSurrogateMaterialScore,  
       CaregiverSurrogateSocialScore,  
       CaregiverSurrogateCouldNotScore,  
       CaregiverSurrogateCaregiverName,  
       CaregiverSurrogateCaregiverRelation,  
       CaregiverSurrogateMaterialExplanation,  
       CaregiverSurrogateSocialExplanation,  
       CaregiverSurrogatePlanText)  
output inserted.CAFASAssessmentId, inserted.ResponseRecordId into @InsertedAssessments  
select @FASRequestId, 
	   @DocumentVersionID, 
       a.ResponseRecordId,   
       a.AssessmentId,  
       a.AssessmentDate,  
       a.IsDeleted,  
       a.ClientId,  
       a.ClientName,  
       a.ClientAge,  
       a.AdministrationDescription,  
       a.IsLocked,  
       a.AssessmentStatus,  
       a.EmployeeId,  
       a.ServiceAreaCode,  
       a.ServiceAreaName,  
       a.ProgramCode,  
       a.ProgramName,  
       a.Rater,  
       a.EpisodeNumber,  
       a.TotalScore,  
       a.CAFASTier,  
       a.RiskBehaviors,  
       a.ChildMgmtConsider,  
       a.SevereImpairmentsTotal,  
       a.PervasiveBehImpResult,  
       a.ChangeTotalScore,  
       a.ChangeSevereImpairments,  
       a.ChangePervasiveBehImp,  
       a.ChangeMeaningfulReliableDiff,  
       a.ChangeImprovement1orMore,  
       a.YouthSchoolScore,  
       a.YouthSchoolCouldNotScore,  
       a.YouthSchoolExplanation,  
       a.YouthSchoolPlanText,  
       a.YouthHomeScore,  
       a.YouthHomeCouldNotScore,  
       a.YouthHomeExplanation,  
       a.YouthHomePlanText,  
       a.YouthCommunityScore,  
       a.YouthCommunityCouldNotScore,  
       a.YouthCommunityExplanation,  
       a.YouthCommunityPlanText,  
       a.YouthBehaviorScore,  
       a.YouthBehaviorCouldNotScore,  
       a.YouthBehaviorExplanation,  
       a.YouthBehaviorPlanText,  
       a.YouthMoodsScore,  
       a.YouthMoodsCouldNotScore,  
       a.YouthMoodsExplanation,  
       a.YouthMoodsPlanText,  
       a.YouthSelfHarmScore,  
       a.YouthSelfHarmCouldNotScore,  
       a.YouthSelfHarmExplanation,  
       a.YouthSelfHarmPlanText,  
       a.YouthSubUseScore,  
       a.YouthSubUseCouldNotScore,  
       a.YouthSubUseExplanation,  
       a.YouthSubUsePlanText,  
       a.YouthThinkingScore,  
       a.YouthThinkingCouldNotScore,  
       a.YouthThinkingExplanation,  
       a.YouthThinkingPlanText,  
       a.CaregiverPrimaryMaterialScore,  
       a.CaregiverPrimarySocialScore,  
       a.CaregiverPrimaryCouldNotScore,  
       a.CaregiverPrimaryCaregiverName,  
       a.CaregiverPrimaryCaregiverRelation,  
       a.CaregiverPrimaryMaterialExplanation,  
       a.CaregiverPrimarySocialExplanation,  
       a.CaregiverPrimaryPlanText,  
       a.CaregiverNonCustodialMaterialScore,  
       a.CaregiverNonCustodialSocialScore,  
       a.CaregiverNonCustodialCouldNotScore,  
       a.CaregiverNonCustodialCaregiverName,  
       a.CaregiverNonCustodialCaregiverRelation,  
       a.CaregiverNonCustodialMaterialExplanation,  
       a.CaregiverNonCustodialSocialExplanation,  
       a.CaregiverNonCustodialPlanText,  
       a.CaregiverSurrogateMaterialScore,  
       a.CaregiverSurrogateSocialScore,  
       a.CaregiverSurrogateCouldNotScore,  
       a.CaregiverSurrogateCaregiverName,  
       a.CaregiverSurrogateCaregiverRelation,  
       a.CaregiverSurrogateMaterialExplanation,  
       a.CaregiverSurrogateSocialExplanation,  
       a.CaregiverSurrogatePlanText  
  from @Assessments a  where CONVERT(smalldatetime, a.AssessmentDate)=(select MAX(AssessmentDate) from @Assessments)
  
  
  
if @@error <> 0  
begin  
  select @errorno = 50090, @errormsg = ''Failed to insert into CustomFASCAFASAssessments''  
  goto error  
end  


-- Changed on 20th- Oct-2010
if (exists(Select * from @Assessments a where  CONVERT(smalldatetime, a.AssessmentDate)=(select MAX(AssessmentDate) from @Assessments)))
Begin
	Update CustomFASRequestLog set ResponseError=''N'',ResponseProcessed=''Y'' where FASRequestId=@FASRequestId
End
Else
	Update CustomFASRequestLog set ResponseError=''Y'',ResponseProcessed=''N'' where FASRequestId=@FASRequestId

if @@error <> 0  
begin  
  select @errorno = 50100, @errormsg = ''Failed to update into CustomFASRequestLog''  
  goto error  
end 


commit tran  
  
return  
  
error:  
  if @@trancount > 0  
    rollback tran  
  
  raiserror @errorno @errormsg  
  ' 
END
GO
