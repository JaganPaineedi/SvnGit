/****** Object:  StoredProcedure [dbo].[csp_ReferralServiceDropDown]    Script Date: 07/19/2013 04:40:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReferralServiceDropDown]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReferralServiceDropDown]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]    Script Date: 07/19/2013 04:40:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetServiceNoteDocumentData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetServiceNoteDocumentData]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]    Script Date: 07/19/2013 04:40:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetServiceNoteDocumentData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
 CREATE Procedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]                                                                                               
(                                                                                                                                                                                      
 @DocumentID int,                                                                                                                                                                                      
 @Version  int,                                                                                                                                                                                      
 @ServiceId int,                                                                                                                                                                             
 @DocumentCodeId int,                                                                                                                                                                                      
 @Mode varchar(10),    
 @AuthorId int,                                                  
 @CustomStoredProcedure varchar(100),                                                  
 @DocumentVersionId int,                                                  
 @FillCustomTablesData AS CHAR(1)=''Y''                                                  
)                                                                                                                                                                                      
As                                                                                                                                                                                      
/*********************************************************************                                                                                                      
-- Stored Procedure: dbo.ssp_SCGetServiceNoteDocumentData                                                                                                      
--                                                                                                      
-- Copyright: 2005 Provider Claim Management System                                                                                                      
--                                                                                                      
-- Creation Date:  01/02/2010                                                                                                      
--                                                                                                      
-- Purpose: Gets Service Note  Values                                                                                                      
--                                                                                                                                                                                                     
-- Data Modifications:                                                                                                      
--                                                                                                      
-- Updates:                                                                                                      
-- Date            Author              Purpose                                                                                                      
   1st  Feb-2010   Vikas Vyas          Get Service Note Data                                   */                                                     
/*13Oct2011     Shifali      Added Column ClientLifeEventId,AuthorId,RevisionNumber                      */    
/*3 Jan, 2012    Davinder Kumar    Added AuthorId                      */    
/*29/March/2012    Rohit Katoch        Added Column  Prescriber           */    
/*10/Apr/2012      Rohit Katoch        Remove Column  Prescriber  */    
/*17/Apr/2012      Shifali      Added Column  SpecificLocation   */    
/*2/May/2012       Maninder      Changed  Documents.CurrentDocumentVersionId to Documents.InProgressDocumentVersionId=DocumentVersions.DocumentVersionId in join condition to pick @Version   */    
/*8/June/2012    Shifali         Added Column Appointments.RecurringOccurrenceIndex as per DM Change from 11.49 to 11.50 (Core Version)*/    
/*10aug2012     Shifali             Added Column SavedStatus table Services (Merge of task# 1533 from 3.5x (Thresholds Bugs/Feature)*/    
/*28Sep2012     Rahul Aneja     Added new column into table Appointments.SpecificLocation */    
/*01Oct2012     Sudhir Singh  Remove the CustomFieldsData Table from the Sp*/    
/*25.10.2012    Sanjayb          Merge from 2.x to 3.5xMerge By Sanjayb - Ref Task No. 259 SC Web Phase II - Bugs/Features -13-July-2012 - Document Version Views:  Refresh repository PDF*/        
/*26/Oct/2012    Mamta Gupta  Added new column into table Appointments.NumberofTimeRescheduledTo Count no of appointment rescheduling. Task No. 35 Primary Care - Summit Pointe */             
/*12.12.2012       Rakesh Garg      W.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId for avoiding concurrency issues*/             
/*17Apr2013     Pradeepa   Added AppointmentMaster,AppointmentMasterResources table.    
/**********************************************************************/ */                                                                                                                             
BEGIN TRY                                                                                             
                
--Changes by sonia Ref Task #701                                   
Declare @DocumentType int                                          
                 
Select @DocumentType=DocumentType                         
from DocumentCodes                                                      
where DocumentCodeId=@DocumentCodeId                                                      
--Changes end over here                                                               
                                                
if(@ServiceId=-1)                                                                
begin                                       
 Select @ServiceId = ServiceID from Documents where DocumentID = @DocumentID                                                                           
end                                                
                                                                                                  
if(@Version=-1)                                                                                                         
begin                                                                                                
 --Select @Version = CurrentVersion from Documents where DocumentID = @DocumentID                                                                                                                                                            
 if Exists (select DocumentVersions.Version from documents inner join DocumentVersions on Documents.CurrentDocumentVersionId=DocumentVersions.DocumentVersionId  where Documents.DocumentId=@DocumentID                  
and ISNULL(Documents.RecordDeleted,''N'')<>''Y'')                
 Begin                
  --Code Commented by Maninder: for task#748 in Threshold Bugs/Feature        
-- Select @Version = DocumentVersions.Version from documents inner join DocumentVersions on Documents.CurrentDocumentVersionId=DocumentVersions.DocumentVersionId  where Documents.DocumentId=@DocumentID                    
--and ISNULL(Documents.RecordDeleted,''N'')<>''Y''              
Select @Version = DocumentVersions.Version from documents inner join DocumentVersions on Documents.InProgressDocumentVersionId=DocumentVersions.DocumentVersionId  where Documents.DocumentId=@DocumentID                    
and ISNULL(Documents.RecordDeleted,''N'')<>''Y''                
 End                
 else                
set @Version=-1                
                 
 Select @DocumentVersionId=DocumentVersionId from DocumentVersions where DocumentID = @DocumentID                  
 and Version=@Version                                            
                                     
end                                                                                                                                                     
                                                                                                                                                        
 SELECT [ServiceId]                                                    
      ,[ClientId]                                                    
      ,[GroupServiceId]                                                    
      ,[ProcedureCodeId]                                                    
      ,[DateOfService]                                                    
      ,[EndDateOfService]                                                    
      ,[RecurringService]                                                    
      ,[Unit]                                                    
      ,[UnitType]                                                    
      ,[Status]                                                    
      ,[CancelReason]                                                    
      ,[ProviderId]                                                    
      ,[ClinicianId]                                                    
      ,[AttendingId]                                                    
      ,[ProgramId]                                                    
      ,[LocationId]                                                    
      ,[Billable]                                                    
      ,[DiagnosisCode1]                                                    
      ,[DiagnosisNumber1]                                                    
      ,[DiagnosisVersion1]                                                    
      ,[DiagnosisCode2]                                                    
      ,[DiagnosisNumber2]                                                    
      ,[DiagnosisVersion2]                                                    
      ,[DiagnosisCode3]                                                    
      ,[DiagnosisNumber3]                                                 
      ,[DiagnosisVersion3]                                                    
      ,[ClientWasPresent]                            
 ,[OtherPersonsPresent]                                           
      ,[AuthorizationsApproved]                
      ,[AuthorizationsNeeded]                                                    
      ,[AuthorizationsRequested]                                                    
      ,[Charge]                                                    
      ,[NumberOfTimeRescheduled]                                                    
      ,[NumberOfTimesCancelled]                                                    
 ,[ProcedureRateId]                                                    
      ,[DoNotComplete]                                                    
      ,Services.[Comment]                                                    
      ,[Flag1]                                                    
      ,[OverrideError]                                                    
      ,[OverrideBy]                                                    
      ,[ReferringId]                                                    
      --,DateOfService as DateTimeIn                  
      --,EndDateOfService as DateTimeOut                               
       ,DateTimeIn                                                   
       ,DateTimeOut                               
      ,[NoteAuthorId]                                        
      --,Services.[RowIdentifier]                                        
      --,Services.[ExternalReferenceId]                                                    
      ,Services.[CreatedBy]                           
      ,Services.[CreatedDate]                                                    
      ,Services.[ModifiedBy]                            
      ,Services.[ModifiedDate]                                                    
      ,Services.[RecordDeleted]                                                    
      ,Services.[DeletedDate]                                                    
      ,Services.[DeletedBy]                         
      --,right(CONVERT(varchar, DateOfService, 100),7)  as ''StartTimeDateOfService''                            
   , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateofService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')            
   as ''StartTimeDateOfService''             
               
     -- ,right(CONVERT(varchar, EndDateOfService, 100),7)  as  ''EndTimeEndDateOfService''                          
    , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,EndDateOfService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')            
   as ''EndTimeEndDateOfService''             
      --,right(CONVERT(varchar, DateOfService, 100),7)  as ''DateInDateTimeIn''                           
   --   , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateOfService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')            
   --as ''DateInDateTimeIn''             
           
    , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateTimeIn,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')            
   as ''DateInDateTimeIn''            
            
   --        , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,EndDateOfService,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')            
   --as ''DateOutDateTimeOut''         
, REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateTimeOut,100),7)),7),''AM'', '' AM''),''PM'', '' PM'')            
as ''DateOutDateTimeOut''         
                  
      ,Staff.LastName +  '', '' + Staff.FirstName as ''ClinicianName''                          
                                
      ,SpecificLocation                           
      ,[Status] as SavedStatus    
  FROM Services  left join Staff on Staff.StaffId=Services.ClinicianId                                                    
  where ServiceId=@ServiceId and ISNULL(Services.RecordDeleted,''N'')=''N''                                                      
                                                      
                                   
  Declare @serviceStatus as int                            
  Declare @disableNoShowNotes as char(1)                            
  Declare @disableCancelNotes as char(1)                            
                              
  select @serviceStatus=status from Services where ServiceId=@ServiceId and ISNULL(RecordDeleted,''N'')=''N''                 select @disableNoShowNotes=ISNULL(SystemConfigurations.DisableNoShowNotes,''N'') from SystemConfigurations                            


                    
  select @disableCancelNotes=ISNULL(SystemConfigurations.DisableCancelNotes,''N'') from SystemConfigurations                            
                          
                               
                               
                         
                                                                          
  SELECT [DocumentId]                                                    
      ,[ClientId]                                                    
      ,[ServiceId]                              
      ,[DocumentCodeId]                                     
      ,[EffectiveDate]                    
      ,[DueDate]                                                    
      ,[Status]                                                    
      ,[AuthorId]                                                    
      --,[CurrentVersion]                                                    
      ,CurrentDocumentVersionId                                    
      ,[DocumentShared]                                                    
      ,[SignedByAuthor]                                                    
      ,[SignedByAll]                                            
      ,[ToSign]                                                    
   ,[ProxyId]                                                    
      ,[UnderReview]                                                    
      ,[UnderReviewBy]                                                    
      ,[RequiresAuthorAttention]                                                                                                 
      ,[CreatedBy]                                                    
      ,[CreatedDate]                                                    
      ,[ModifiedBy]                                             
      ,[ModifiedDate]                                                    
      ,[RecordDeleted]                                                    
      ,[DeletedDate]                                                    
      ,[DeletedBy]                                                    
      ,[GroupServiceId]       
      ,EventId    
   ,ProviderId    
   ,InitializedXML    
   ,BedAssignmentId    
   ,ReviewerId    
   ,InProgressDocumentVersionId    
   ,CurrentVersionStatus    
   ,ClientLifeEventId    
   ,AppointmentId      --Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp                                                
      FROM Documents WHERE DocumentID = @DocumentID and ISNULL(RecordDeleted,''N'')=''N''                             
                                                                                                                                               
                                                     
  SELECT [DocumentVersionId]                                                    
      ,[DocumentId]                                                    
      ,[Version]                                                    
      ,[EffectiveDate]                                                    
      ,[DocumentChanges]                                                    
      ,[ReasonForChanges]                                                    
      --,[RowIdentifier]                                                    
      --,[ExternalReferenceId]                                                    
      ,[CreatedBy]                                                    
      ,[CreatedDate]                                                    
      ,[ModifiedBy]                                           
      ,[ModifiedDate]                                                    
      ,[RecordDeleted]                                                    
      ,[DeletedDate]                                                    
      ,[DeletedBy]     
   ,AuthorId    
   ,RevisionNumber      
   ,[RefreshView] --Task#259                                                                                         
  FROM [DocumentVersions]                                                    
  where DocumentID=@DocumentID and Version=@Version  and ISNULL(RecordDeleted,''N'')=''N''                              
                              
  /*******Modification after adding documentlog table in dataSet as per chaning in documents ********/                             
      SELECT [DocumentInitializationLogId]                        
      ,[DocumentId]                          
      ,[TableName]                              
      ,[ColumnName]                              
      ,[InitializationStatus]                              
      ,[ChildRecordId]                              
      ,[RowIdentifier]                              
      ,[CreatedBy]                              
      ,[CreatedDate]                              
      ,[ModifiedBy]                         
      ,[ModifiedDate]                              
      ,[RecordDeleted]                              
      ,[DeletedDate]                       
      ,[DeletedBy]                              
  FROM [DocumentInitializationLog]                                  
   WHERE ISNull(RecordDeleted,''N'')=''N'' and DocumentId=@DocumentID                                
                              
  /****** End of modification adding documentlog table **********************************************/                                                        
                         
                                                     
                                                      
                                                                                                                                      
                                                      
  SELECT [AppointmentId]                                                    
      ,[StaffId]                                                    
      ,[Subject]                                                    
      ,[StartTime]                                                    
      ,[EndTime]                                                    
      ,[AppointmentType]                                                    
      ,[Description]                                                    
      ,[ShowTimeAs]                                                    
      ,[LocationId]                                                    
      ,[ServiceId]                                                    
    ,[GroupServiceId]                                                    
      ,[AppointmentProcedureGroupId]                                                    
      ,[RecurringAppointment]                                                    
      ,[RecurringDescription]                                                    
      ,[RecurringAppointmentId]                                              
      ,[RecurringServiceId]                                                    
      ,[RecurringGroupServiceId]                                                    
      ,RecurringOccurrenceIndex    
      ,[RowIdentifier]                                                    
     ,[CreatedBy]                                          
      ,[CreatedDate]                                                    
      ,[ModifiedBy]                                                    
      ,[ModifiedDate]                                                    
      ,[RecordDeleted]                                                    
      ,[DeletedDate]                                                    
      ,[DeletedBy]     
      ,[SpecificLocation] --Added By Rahul Aneja    
      ,[NumberofTimeRescheduled]      --Added By Mmata Gupta                                                          
  FROM [Appointments]                                    
  where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                                                                                    
                                                
  SELECT [ServiceErrorId]                                                    
      ,[ServiceId]                                                    
      ,[CoveragePlanId]                                                    
   ,[ErrorType]         
      ,[ErrorSeverity]                                                    
,[ErrorMessage]                                          
      ,[NextStep]                                                    
      ,[RowIdentifier]                                                    
      ,[CreatedBy]                                                    
      ,[CreatedDate]                                            
      ,[ModifiedBy]                                                    
      ,[ModifiedDate]   
      ,[RecordDeleted]                                                   
      ,[DeletedDate]                                                    
      ,[DeletedBy]                                                    
  FROM [ServiceErrors]                                                    
  where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                                                                                     
                                                                                                     
--ServiceGoals                                                                                       
  select                                                                                                   
 ServiceGoalId,                                                       
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
                                                                                                 
  from ServiceGoals where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                                                                                   
                                                                                                                                                                                                                                       
--ServiceObjectives                         
                                                                                               
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
                                                                  
  from ServiceObjectives where ServiceID=@ServiceId  and ISNULL(RecordDeleted,''N'')=''N''                                                  
               
--  SELECT [CustomFieldsDataId]              
--      ,[DocumentType]              
--      ,[DocumentCodeId]              
--      ,[PrimaryKey1]              
--      ,[PrimaryKey2]              
--    ,[ColumnVarchar1]              
--      ,[ColumnVarchar2]              
--      ,[ColumnVarchar3]              
--      ,[ColumnVarchar4]              
--      ,[ColumnVarchar5]              
--      ,[ColumnVarchar6]              
--      ,[ColumnVarchar7]              
--      ,[ColumnVarchar8]              
--      ,[ColumnVarchar9]              
--      ,[ColumnVarchar10]              
--      ,[ColumnVarchar11]              
--,[ColumnVarchar12]              
--      ,[ColumnVarchar13]              
--      ,[ColumnVarchar14]              
--      ,[ColumnVarchar15]              
--      ,[ColumnVarchar16]              
--      ,[ColumnVarchar17]              
--      ,[ColumnVarchar18]              
--      ,[ColumnVarchar19]              
--      ,[ColumnVarchar20]              
--      ,[ColumnText1]              
--      ,[ColumnText2]              
--      ,[ColumnText3]              
--      ,[ColumnText4]              
--      ,[ColumnText5]              
--      ,[ColumnText6]              
--      ,[ColumnText7]              
--      ,[ColumnText8]              
--      ,[ColumnText9]              
--      ,[ColumnText10]              
--      ,[ColumnInt1]              
--      ,[ColumnInt2]              
--      ,[ColumnInt3]              
--      ,[ColumnInt4]              
--      ,[ColumnInt5]              
--      ,[ColumnInt6]              
--      ,[ColumnInt7]              
--      ,[ColumnInt8]            ,[ColumnInt9]              
--      ,[ColumnInt10]              
--      ,[ColumnDatetime1]              
--      ,[ColumnDatetime2]              
--      ,[ColumnDatetime3]              
--      ,[ColumnDatetime4]              
--      ,[ColumnDatetime5]              
--      ,[ColumnDatetime6]              
--      ,[ColumnDatetime7]              
--      ,[ColumnDatetime8]              
--      ,[ColumnDatetime9]              
--      ,[ColumnDatetime10]              
--      ,[ColumnDatetime11]              
--      ,[ColumnDatetime12]              
--      ,[ColumnDatetime13]              
--      ,[ColumnDatetime14]              
--      ,[ColumnDatetime15]              
--      ,[ColumnDatetime16]              
--      ,[ColumnDatetime17]              
--      ,[ColumnDatetime18]              
--      ,[ColumnDatetime19]              
--      ,[ColumnDatetime20]              
--      ,[ColumnGlobalCode1]              
--      ,[ColumnGlobalCode2]              
--      ,[ColumnGlobalCode3]              
--      ,[ColumnGlobalCode4]              
--      ,[ColumnGlobalCode5]              
--      ,[ColumnGlobalCode6]              
--      ,[ColumnGlobalCode7]              
--      ,[ColumnGlobalCode8]              
--      ,[ColumnGlobalCode9]              
--      ,[ColumnGlobalCode10]              
--      ,[ColumnGlobalCode11]              
--      ,[ColumnGlobalCode12]              
--      ,[ColumnGlobalCode13]              
--      ,[ColumnGlobalCode14]              
--      ,[ColumnGlobalCode15]              
--      ,[ColumnGlobalCode16]              
--      ,[ColumnGlobalCode17]              
--      ,[ColumnGlobalCode18]              
--      ,[ColumnGlobalCode19]              
--      ,[ColumnGlobalCode20]              
--      ,[ColumnMoney1]              
--      ,[ColumnMoney2]              
--      ,[ColumnMoney3]              
--      ,[ColumnMoney4]              
--      ,[ColumnMoney5]              
--      ,[ColumnMoney6]              
--      ,[ColumnMoney7]              
--      ,[ColumnMoney8]              
--      ,[ColumnMoney9]              
--      ,[ColumnMoney10]              
--      ,[RowIdentifier]              
--      ,[CreatedBy]              
--      ,[CreatedDate]              
--      ,[ModifiedBy]              
--      ,[ModifiedDate]              
--      ,[RecordDeleted]              
--      ,[DeletedDate]              
--      ,[DeletedBy]              
--  FROM [CustomFieldsData] where PrimaryKey1=@ServiceId and ISNULL(CustomFieldsData.RecordDeleted,''N'')=''N''                      
--SELECT    [AppointmentMasterId],    
--   [CreatedBy],    
--   [CreatedDate],    
--   [ModifiedBy],    
--   [ModifiedDate],    
--   [RecordDeleted],    
--   [DeletedBy],    
--   [DeletedDate],    
--   [Subject],    
--   [Description],    
--   [StartTime],    
--   [EndTime],    
--   [AppointmentType],    
--   [ShowTimeAs],    
--   [ServiceId]    
--  FROM AppointmentMaster RA      
--  WHERE ServiceId= @ServiceId    
--  AND ISNULL(RA.RecordDeleted,''N'')=''N''    
      
--  SELECT AMR.[AppointmentMasterResourceId],    
--   AMR.[CreatedBy],    
--   AMR.[CreatedDate],    
--   AMR.[ModifiedBy],    
--   AMR.[ModifiedDate],    
--   AMR.[RecordDeleted],    
--   AMR.[DeletedBy],    
--   AMR.[DeletedDate],    
--   AMR.[AppointmentMasterId],    
--   AMR.[ResourceId],    
--   RS.[ResourceName] + '' (''+gsc.SubCodeName+'')'' as ResourceName,    
--   RS.[ResourceType] as Type,    
--   AMR.[ResourceId] as OrgResourceId    
--  FROM AppointmentMasterResources AMR    
--  join AppointmentMaster AM on AM.AppointmentMasterId= AMR.AppointmentMasterId    
--  join Resources RS on RS.ResourceId=AMR.[ResourceId]    
--  join GlobalSubCodes gsc on gsc.GlobalSubCodeId=RS.ResourceSubType    
--  WHERE AM.ServiceId=@ServiceId    
--  AND ISNULL(AMR.RecordDeleted,''N'')=''N''    
--  AND ISNULL(AM.RecordDeleted,''N'')=''N''    
--  AND ISNULL(RS.RecordDeleted,''N'')=''N''     
      
-- Select AMS.AppointmentMasterStaffId,    
--  AMS.CreatedBy,    
--  AMS.CreatedDate,    
--  AMS.ModifiedBy,    
--  AMS.ModifiedDate,    
--  AMS.RecordDeleted,    
--  AMS.DeletedBy,    
--  AMS.DeletedDate,    
--  AMS.AppointmentMasterId,    
--  AMS.StaffId    
-- from AppointmentMasterStaff AMS     
-- join AppointmentMaster AM on AM.AppointmentMasterId= AMS.AppointmentMasterId      
-- join Staff S on S.StaffId=AMS.[StaffId]     
             
--Modified by Davinder Kumar                                                           
IF EXISTS(select PARAMETER_NAME from information_schema.parameters            
 where specific_name=@CustomStoredProcedure            
 and PARAMETER_NAME=''@StaffId'')            
begin                                                                    
 --Following added by sonia                                                      
 if(@DocumentType=18 and @FillCustomTablesData=''Y'')    -- Changes by Sonia Ref Task #701                                                  
 begin                                                      
   exec @CustomStoredProcedure  @DocumentVersionId, @FillCustomTablesData                                                      
   --return                                                   
 end                                              
 --Changes end over here                                               
 else                                                
 begin                                              
    if(@DocumentCodeId > 0)                                         
    begin                                                 
    exec @CustomStoredProcedure @DocumentVersionId, @StaffId = @AuthorId --@Version                                             
    end                        
 end         
end      
Else    
begin               
 --Following added by sonia                                                      
 if(@DocumentType=18 and @FillCustomTablesData=''Y'')    -- Changes by Sonia Ref Task #701                                                  
 begin                                                      
   exec @CustomStoredProcedure  @DocumentVersionId,@FillCustomTablesData                                                      
   --return                                                   
 end                                              
 --Changes end over here                                               
 else                                                
 begin                                              
    if(@DocumentCodeId > 0)                                         
    begin                                                 
    exec @CustomStoredProcedure @DocumentVersionId --@Version                                             
    end                                               
 end         
end                                                                              
                                                          
                    
                                                        
  END TRY                  
                                                    
BEGIN CATCH                                                      
 declare @Error varchar(8000)                                                      
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetServiceNoteCustomTables120'')                                                       
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                        
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                      
                                                
 RAISERROR                                                       
 (                                                      
  @Error, -- Message text.                                                      
  16,  -- Severity.                                                      
  1  -- State.                                                      
 );                                                      
                                                      
END CATCH 


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_ReferralServiceDropDown]    Script Date: 07/19/2013 04:40:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReferralServiceDropDown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReferralServiceDropDown]  
 @DocumentCodeId int,  
 @ClientId int,  
 @isInitialTxTab char(1)  
AS  
BEGIN  
BEGIN TRY  
/****************************************************************/  
-- PROCEDURE: scsp_ReferralServiceDropDown  
-- PURPOSE: Fills the authorization codes list drop-down for  
-- any Harbor document that uses services (Treatment plans,  
-- Diagnostic Assessments, referrals, transfers).  
-- CALLED BY: Harbor custom documents.  
-- REVISION HISTORY:  
--  2012.06.15  
--2012.06.20 Rohitk add try catch   
--2012.07.02 Amit Kumar Srivastava Added @isInitialTxTab char(1), #1672, Harbor Go Live Issues, DA: Call csp_ReferralServiceDropDown with extra parameter  
/****************************************************************/  
  
  
declare @referralTransferServices table (  
 AuthorizationCodeId int  
)  
insert into @referralTransferServices values  
(1),  
(2),  
(3),  
(4),  
(5),  
(6),  
(7),  
(8),  
(9),  
(10),  
(11),  
(12),  
(13),  
(14),  
(15),  
(16),  
(17),  
(18),  
(333) -- Health Home  
  
declare @txPlanReferralTransferServices table (  
 AuthorizationCodeId int  
)  
insert into @txPlanReferralTransferServices   
        (AuthorizationCodeId)  
values  
(1),  
(2),  
(3),  
(4),  
(5),  
(6),  
(7),  
(8),  
(9),  
(10),  
(11),  
(12),  
(13),  
(14),  
(15),  
(16),  
(17),  
(18),  
(333) -- Health Home  

if ((@DocumentCodeId in (1483, 1484, 1485)) or (@isInitialTxTab = ''Y''))  
 select a.AuthorizationCodeId, a.DisplayAs  
 from dbo.AuthorizationCodes as a  
 join @txPlanReferralTransferServices as b on b.AuthorizationCodeId = a.AuthorizationCodeId  
 where a.Active = ''Y''  
 and ISNULL(RecordDeleted, ''N'') <> ''Y''  
 order by DisplayAs, AuthorizationCodeId  
else  
 select a.AuthorizationCodeId, a.DisplayAs  
 from dbo.AuthorizationCodes as a  
 join @referralTransferServices as b on b.AuthorizationCodeId = a.AuthorizationCodeId  
 where a.Active = ''Y''  
 and ISNULL(RecordDeleted, ''N'') <> ''Y''  
 order by DisplayAs, AuthorizationCodeId  
  
END TRY  
BEGIN CATCH  
 DECLARE @Error varchar(8000)  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())  
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_ReferralServiceDropDown'')  
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())  
    + ''*****'' + Convert(varchar,ERROR_STATE())  
 RAISERROR  
 (  
   @Error, -- Message text.  
   16, -- Severity.  
   1 -- State.  
  );  
END CATCH  
END  
      ' 
END
GO
