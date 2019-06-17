/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientNoteRecentTreatmentPlan]    Script Date: 10/09/2015 09:42:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetClientNoteRecentTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetClientNoteRecentTreatmentPlan]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientNoteRecentTreatmentPlan]    Script Date: 10/09/2015 09:42:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [dbo].[ssp_SCWebGetClientNoteRecentTreatmentPlan]  
/********************************************************************************                                                    
-- Stored Procedure: ssp_SCWebGetClientNoteRecentTreatmentPlan  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
--    Date                 Author                      Purpose  
--  12/03/2015            Arjun K R               Modified to add custom SCSP to get the goals and objectives. Task #55 WMU- Enhancement.  
--  10/09/2015			  Chethan N				  What : Modified Logic to execute SCSP.
--												  Why : Interact - Support task# 427
*********************************************************************************/  
(        
@ClientId bigint,              
@DateOfService datetime,               
@ProcedureCodeId int,    
@ServiceId int      
)      
as         
  
  
          
Begin                          
 Begin Try       
 /*if OBJECT_ID('tempdb..#TPNeeds') is not null       
  drop table #TPNeeds       
       
 CREATE TABLE #TPNeeds(      
   Id int IDENTITY(1,1) NOT NULL,      
   [NeedId] [int] NOT NULL,      
   [DocumentVersionId] [int] NOT NULL,      
   [NeedNumber] [decimal](18, 0) NOT NULL,      
   [NeedText] [text] NULL,      
   [NeedTextRTF] [text] NULL,      
   [NeedCreatedDate] [datetime] NULL,      
   [NeedModifiedDate] [datetime] NULL,      
   [GoalText] [text] NULL,      
   [GoalTextRTF] [text] NULL,      
   [GoalDesiredResults] varchar(max) NULL,      
   [GoalActive] char(1) NULL,      
   [GoalNaturalSupports] char(1) NULL,      
   [GoalLivingArrangement] char(1) NULL,      
   [GoalEmployment] char(1) NULL,      
   [GoalHealthSafety] char(1) NULL,      
   [GoalStrengths] varchar(max) NULL,      
   [GoalBarriers] varchar(max) NULL,      
   [GoalMonitoredBy] [varchar](128) NULL,      
   [GoalStartDate] [datetime] NULL,      
   [GoalTargetDate] [datetime] NULL,      
   [StageOfTreatment] varchar(50) NULL,      
   [SourceNeedId] [int] NULL,      
   [RowIdentifier] varchar(256) NOT NULL,      
   [CreatedBy] varchar(50) NOT NULL,      
   [CreatedDate] datetime NOT NULL,      
   [ModifiedBy] varchar(50) NOT NULL,      
   [ModifiedDate] datetime NOT NULL,      
   [RecordDeleted] char(1) NULL,      
   [DeletedDate] [datetime] NULL,      
   [DeletedBy] varchar(50) NULL,    
   [AuthorizationCodeId] int)      
      
 if OBJECT_ID('tempdb..#TPObjectives') is not null       
 drop table #TPObjectives       
 CREATE TABLE #TPObjectives(      
   Id [int] IDENTITY(1,1) NOT NULL,      
   [ObjectiveId] [int] NOT NULL,      
   [DocumentVersionId] [int] NOT NULL,      
   [NeedId] [int] NULL,      
   [ObjectiveNumber] [decimal](18, 2) NOT NULL,      
   [ObjectiveText] [text] NULL,      
   [ObjectiveTextRTF] [text] NULL,      
   [ObjectiveStatus] int NULL,      
   [StartDate] [datetime] NULL,      
   [TargetDate] [datetime] NULL,      
   [RowIdentifier] varchar(256) NOT NULL,      
   [CreatedBy] varchar(30) NOT NULL,      
   [CreatedDate] datetime NOT NULL,      
   [ModifiedBy] varchar(30) NOT NULL,      
   [ModifiedDate] datetime NOT NULL,      
   [RecordDeleted] char(1) NULL,      
   [DeletedDate] [datetime] NULL,      
   [DeletedBy] varchar(30) NULL,    
   [AuthorizationCodeId] int)        
      
 Declare @RecentDocumentId as bigint                          
 Declare @RecentVersion as bigint                          
                          
 select top 1 @RecentDocumentId=documentid ,    
     @RecentVersion=CurrentDocumentVersionId     
 from documents     
 where documentcodeid in (350,503,2)                           
   and ClientId=@ClientId            
   and status=22     
   and effectivedate<=convert(datetime,convert(varchar,@DateOfService,101))                           
   and isnull(RecordDeleted,'N')='N'                          
 order by effectivedate desc,modifieddate desc                          
                       
 -- Data from TPNeeds                        
 insert into #TPNeeds(NeedId,       
  DocumentVersionId,       
  NeedNumber,       
  NeedText,       
  NeedTextRTF,       
  NeedCreatedDate,       
  NeedModifiedDate,       
  GoalText,    
  GoalTextRTF,       
  GoalDesiredResults,       
  GoalActive,       
  GoalNaturalSupports,       
  GoalLivingArrangement,       
  GoalEmployment,       
  GoalHealthSafety,       
  GoalStrengths,       
  GoalBarriers,       
  GoalMonitoredBy,       
  GoalStartDate,       
  GoalTargetDate,       
  StageOfTreatment,       
  SourceNeedId,      
  RowIdentifier,                          
  CreatedBy,                          
  CreatedDate,                          
  ModifiedBy,                          
  ModifiedDate,                          
  RecordDeleted,                          
  DeletedDate,                          
  DeletedBy,    
  AuthorizationCodeId )      
 SELECT TPNeeds.NeedId,     
   TPNeeds.DocumentVersionId,     
   TPNeeds.NeedNumber,     
   TPNeeds.NeedText,      TPNeeds.NeedTextRTF,     
            TPNeeds.NeedCreatedDate,     
            TPNeeds.NeedModifiedDate,     
            TPNeeds.GoalText,     
            TPNeeds.GoalTextRTF,     
            TPNeeds.GoalDesiredResults,     
            TPNeeds.GoalActive,     
            TPNeeds.GoalNaturalSupports,     
            TPNeeds.GoalLivingArrangement,     
            TPNeeds.GoalEmployment,     
            TPNeeds.GoalHealthSafety,     
            TPNeeds.GoalStrengths,     
            TPNeeds.GoalBarriers,     
            TPNeeds.GoalMonitoredBy,     
            TPNeeds.GoalStartDate,     
            TPNeeds.GoalTargetDate,     
            TPNeeds.StageOfTreatment,     
            TPNeeds.SourceNeedId,     
            TPNeeds.RowIdentifier,     
            TPNeeds.CreatedBy,     
            TPNeeds.CreatedDate,     
            TPNeeds.ModifiedBy,     
            TPNeeds.ModifiedDate,     
            TPNeeds.RecordDeleted,     
            TPNeeds.DeletedDate,     
            TPNeeds.DeletedBy,     
            TPIP.AuthorizationCodeId    
 FROM    AuthorizationCodeProcedureCodes AS ACPC INNER JOIN    
            TPInterventionProcedures AS TPIP ON ACPC.AuthorizationCodeId = TPIP.AuthorizationCodeId AND ACPC.ProcedureCodeId = @ProcedureCodeId RIGHT OUTER JOIN    
            TPNeeds ON TPIP.NeedId = TPNeeds.NeedId    
 WHERE   (TPNeeds.DocumentVersionId = @RecentVersion)     
   AND (TPNeeds.GoalActive = 'Y')     
   AND (ISNULL(ACPC.RecordDeleted, 'N') = 'N')     
   AND (ISNULL(TPIP.RecordDeleted, 'N') = 'N')    
 ORDER BY TPIP.AuthorizationCodeId DESC    
     
 declare @needresult int =(select COUNT(*) as GoalAddressedNeedResults from #TPNeeds where (isnull(AuthorizationCodeId ,0)<>0));      
       
 -- Data from TPObjectives      
 insert into #TPObjectives(ObjectiveId,       
  DocumentVersionId,       
  NeedId,       
  ObjectiveNumber,       
  ObjectiveText,       
  ObjectiveTextRTF,       
  ObjectiveStatus,       
  TargetDate,       
  RowIdentifier,       
  CreatedBy,       
  CreatedDate,       
  ModifiedBy,       
  ModifiedDate,       
  RecordDeleted,       
  DeletedDate,       
  DeletedBy,    
  AuthorizationCodeId)     
 SELECT  TPObjectives.ObjectiveId,     
   TPObjectives.DocumentVersionId,     
   TPObjectives.NeedId,     
   TPObjectives.ObjectiveNumber,     
            TPObjectives.ObjectiveText,     
            TPObjectives.ObjectiveTextRTF,     
            TPObjectives.ObjectiveStatus,     
            TPObjectives.TargetDate,     
            TPObjectives.RowIdentifier,     
            TPObjectives.CreatedBy,     
            TPObjectives.CreatedDate,     
            TPObjectives.ModifiedBy,     
            TPObjectives.ModifiedDate,     
            TPObjectives.RecordDeleted,     
            TPObjectives.DeletedDate,     
            TPObjectives.DeletedBy,     
            TPIP.AuthorizationCodeId    
 FROM    AuthorizationCodeProcedureCodes AS ACPC INNER JOIN    
            TPInterventionProcedures AS TPIP ON ACPC.AuthorizationCodeId = TPIP.AuthorizationCodeId AND ACPC.ProcedureCodeId = @ProcedureCodeId RIGHT OUTER JOIN    
            TPObjectives INNER JOIN TPNeeds ON TPNeeds.NeedId = TPObjectives.NeedId ON TPIP.NeedId = TPNeeds.NeedId    
 WHERE   (ISNULL(ACPC.RecordDeleted, 'N') = 'N')     
   AND (ISNULL(TPIP.RecordDeleted, 'N') = 'N')     
   AND (ISNULL(TPNeeds.GoalActive, 'N') = 'Y')     
   AND (TPObjectives.DocumentVersionId = @RecentVersion)     
   AND (TPObjectives.ObjectiveStatus IN (191))     
   AND (ISNULL(TPObjectives.RecordDeleted, 'N') = 'N')    
 ORDER BY TPIP.AuthorizationCodeId DESC     
     
 declare @objectiveresult int=(select COUNT(*) as GoalAddressedObjectiveResults from #TPObjectives where isnull(AuthorizationCodeId,0)<>0);       
      
 --TPNeeds Data    
 select NeedId,       
  DocumentVersionId,       
  NeedNumber,       
  NeedText,       
  NeedTextRTF,       
  NeedCreatedDate,       
  NeedModifiedDate,       
  GoalText,       
  GoalTextRTF,       
  GoalDesiredResults,       
  GoalActive,       
  GoalNaturalSupports,       
  GoalLivingArrangement,       
  GoalEmployment,       
  GoalHealthSafety,       
  GoalStrengths,       
  GoalBarriers,       
  GoalMonitoredBy,       
  GoalStartDate,       
  GoalTargetDate,       
  StageOfTreatment,       
  SourceNeedId,      
  RowIdentifier,                          
  CreatedBy,                          
  CreatedDate,                          
  ModifiedBy,                          
  ModifiedDate,                          
  RecordDeleted,                          
  DeletedDate,                          
  DeletedBy     
 from #TPNeeds     
       
 --TPObjectives Data    
 select ObjectiveId,       
  DocumentVersionId,       
  NeedId,       
  ObjectiveNumber,       
  ObjectiveText,       
  ObjectiveTextRTF,       
  ObjectiveStatus,       
  TargetDate,       
  RowIdentifier,       
  CreatedBy,       
  CreatedDate,       
  ModifiedBy,       
  ModifiedDate,       
  RecordDeleted,       
  DeletedDate,       
  DeletedBy from #TPObjectives       
     
 --Count tables    
 select @needresult as GoalAddressedNeed      
 select @objectiveresult as GoalAddressedObjective */     
 IF OBJECT_ID('dbo.scsp_SCWebGetRecentTreatmentPlanOrAddendum', 'P') IS NOT NULL
BEGIN
	EXEC scsp_SCWebGetRecentTreatmentPlanOrAddendum @ClientId = @ClientId
		,@DateOfService = @DateOfService
		,@ProcedureCodeId = @ProcedureCodeId
END
ELSE
BEGIN
	-- Added By : Arjun K R 12/03/2015    
	IF EXISTS (
			SELECT 1
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME = 'CustomTPGoals'
			)
		AND EXISTS (
			SELECT 1
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME = 'CustomTPObjectives'
			)
	BEGIN
		-- This Stored Procedure is Custom Stored Procedure even though name of the stored procedure starts with SSP  
		EXEC ssp_SCWebGetRecentTreatmentPlanOrAddendum @ClientId = @ClientId
			,@DateOfService = @DateOfService
			,@ProcedureCodeId = @ProcedureCodeId
	END
END
   
    
    
 -- Data from ServiceGoals    
 select ServiceGoalId,                                       
   ServiceId,                                                                                  
   NeedId,                                                             
   StageOfTreatment,                                                       
   RowIdentifier,                                                                                  
   CreatedBy,                                                                                  
   CreatedDate,                                                                                  
   ModifiedBy,                                                            
   ModifiedDate,                                                                                  
   RecordDeleted,                                                       
   DeletedDate,                                                                                  
   DeletedBy                                                                                  
 from ServiceGoals     
 where ServiceID=@ServiceId      
   and ISNULL(RecordDeleted,'N')='N'                                                                                   
                                                                                                   
 -- Data from ServiceObjectives                                                                                  
 select                                                                                   
  ServiceObjectiveId,                                         
  ServiceId,                                                                                  
  ObjectiveId,                                                                                  
  RowIdentifier,                                                         
  CreatedBy,                                                
  CreatedDate,                                                                                  
  ModifiedBy,                                                                                  
  ModifiedDate,                                                                                  
  RecordDeleted,                                                                                  
  DeletedDate,                                                  
  DeletedBy                                                                    
 from ServiceObjectives     
 where ServiceID=@ServiceId      
   and ISNULL(RecordDeleted,'N')='N'                                                                                                                                                                      
        
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


