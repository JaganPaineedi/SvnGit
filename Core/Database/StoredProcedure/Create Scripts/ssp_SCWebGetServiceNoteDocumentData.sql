/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]    Script Date: 01/24/2014 19:02:44 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetServiceNoteDocumentData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebGetServiceNoteDocumentData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteDocumentData]    Script Date: 01/24/2014 19:02:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebGetServiceNoteDocumentData] (
	@DocumentID INT
	,@Version INT
	,@ServiceId INT
	,@DocumentCodeId INT
	,@Mode VARCHAR(10)
	,@AuthorId INT
	,@CustomStoredProcedure VARCHAR(100)
	,@DocumentVersionId INT
	,@FillCustomTablesData AS CHAR(1) = 'Y'
	)
AS
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
/* 24-01-2014    Akwinass			Two Columns is Added to AppointmentMaster for Task #1932 Summit Pointe Support*/	
/* 26 May 2014	Vithobha		Added an Logic to Pull data for new Diagnosis Tab Engineering Improvement Initiatives- NBL(I): #1419 8 Diagnosis Codes*/     															
/*23/June/2014 Md Khusro	Added the new table 'ServiceAddOnCodes' in result set for task #1420 Engineering Improvement Initiatives- NBL(I)*/													
-- OCT-07-2014 Akwinass       Removed Columns 'DiagnosisCode1,DiagnosisNumber1,DiagnosisVersion1,DiagnosisCode2,DiagnosisNumber2,DiagnosisVersion2,DiagnosisCode3,DiagnosisNumber3,DiagnosisVersion3' from Services table (Task #134 in Engineering Improvement Initiatives- NBL(I))
/* 03 Nov 2014	Vithobha		Added Services.PlaceOfServiceId  MFS - Setup: #16 Service Entry Changes to Support Billing*/     															
-- NOV-06-2014  Akwinass       Top 1 Condition Included in Select Set To avoid SubQuery Error (Task #1419.09 in Engineering Improvement Initiatives- NBL(I))
-- DEC-31-2014  Akwinass       Used 'DiagnosisICD10Codes' table instead DiagnosisDSMVCodes as per new ICD10 logic to avoid build error (Task #1419.09 in Engineering Improvement Initiatives- NBL(I))
-- APRIL-30-2015  Akwinass     Included New Column 'ReasonForNewVersion' (Task #233 in Philhaven Development)
-- July-03-2015   Akwinass     SystemConfigurationKeys 'BILLINGDIAGNOSISDEFAULTBUTTON' Logic Implemented.(Task #147 in Valley Client Acceptance Testing Issues)
-- 18-Aug-2015	Pradeep		Added Null check on @ICDButton variable. Newaygo Support #304
-- 10-Sep-2015	Shankha		What : Retriving Group.StartTime
  --						Why : Philhaven - Customization Issues Tracking task # 1372
-- Sep-23-2015  Akwinass     ServiceDiagnosis Table Select Modified as Per Tom's Code(Task #27 in  	ICD10 Service Diagnosis Changes) 
-- Oct-19-2015  Akwinass     Added new Columns 'AddOnProcedureCodeStartTime,AddOnProcedureCodeUnit,AddOnProcedureCodeUnitType' to 'ServiceAddOnCodes'(Task #213 in Engineering Improvement Initiatives- NBL(I)) 
-- Oct-26-2015  Akwinass     Included 'ServiceNoteCodeId' to 'Services' table to identify group service associate note(Task #829.06 in Core Bugs) 
-- Nov-03-2015  Pavani		 Added columns  Services.ModifierId1,Services.ModifierId2 ,Services.ModifierId3  ,Services.ModifierId4(Task# 251 in Engineering Improvement Initiatives- NBL(I) )
-- 13-APRIL-2016 Akwinass	 What:Included GroupNoteType Column.          
							 Why:task #167.1 Valley - Support Go Live
-- 01-SEP-2016 Akwinass		 What: Included RecordDeleted check on DocumentVersions.          
							 Why:task #399 Key Point - Support Go Live
-- 07/10/2017  Pranay       What : Included @ServiceIdMovedFrom,@DocumentIdMovedFrom,@ScreenId 
                            why: Harbor Task#857
--24-NOV-2017   Akwinass     Added SSP to get ImageRecords (Task #589 in Engineering Improvement Initiatives- NBL(I))
--12-MAR-2018   Akwinass     Added "NoteReplacement" and "AttachmentComments" columns to "Services" table (Task #589.1 in Engineering Improvement Initiatives- NBL(I))
/**********************************************************************/ */
BEGIN TRY
	--Changes by sonia Ref Task #701                                     
	DECLARE @DocumentType INT
	DECLARE @DiagnosisDocumentCodeID INT
	DECLARE @varClientId INT
	DECLARE @CurDiagnosisDocumentCodeID INT
	DECLARE @LatestDiagnosisDocumentVersionId INT
    DECLARE @ServiceIdMovedFrom int =0
    DECLARE @DocumentIdMovedFrom INT=0
    DECLARE @ScreenId  INT --MovedScreenId
    SELECT TOP 1 @DocumentType = DocumentType
	FROM DocumentCodes
	WHERE DocumentCodeId = @DocumentCodeId

	--Changes end over here                                                                 
	IF (@ServiceId = - 1)
	BEGIN
		SELECT TOP 1 @ServiceId = ServiceID
		FROM Documents
		WHERE DocumentID = @DocumentID
	END

	IF (@Version = - 1)
	BEGIN
		--Select @Version = CurrentVersion from Documents where DocumentID = @DocumentID                                                                                                                                                              
		IF EXISTS (
				SELECT DocumentVersions.Version
				FROM documents
				INNER JOIN DocumentVersions ON Documents.CurrentDocumentVersionId = DocumentVersions.DocumentVersionId
				WHERE Documents.DocumentId = @DocumentID
					AND ISNULL(Documents.RecordDeleted, 'N') <> 'Y'
					-- 01-SEP-2016 Akwinass	
					AND ISNULL(DocumentVersions.RecordDeleted, 'N') <> 'Y'
				)
		BEGIN
			--Code Commented by Maninder: for task#748 in Threshold Bugs/Feature          
			-- Select @Version = DocumentVersions.Version from documents inner join DocumentVersions on Documents.CurrentDocumentVersionId=DocumentVersions.DocumentVersionId  where Documents.DocumentId=@DocumentID                      
			--and ISNULL(Documents.RecordDeleted,'N')<>'Y'                
			SELECT TOP 1 @Version = DocumentVersions.Version
			FROM documents
			INNER JOIN DocumentVersions ON Documents.InProgressDocumentVersionId = DocumentVersions.DocumentVersionId
			WHERE Documents.DocumentId = @DocumentID
				AND ISNULL(Documents.RecordDeleted, 'N') <> 'Y'
				-- 01-SEP-2016 Akwinass	
				AND ISNULL(DocumentVersions.RecordDeleted, 'N') <> 'Y'
		END
		ELSE
			SET @Version = - 1

		SELECT TOP 1 @DocumentVersionId = DocumentVersionId
		FROM DocumentVersions
		WHERE DocumentID = @DocumentID
			AND Version = @Version
			-- 01-SEP-2016 Akwinass	
			AND ISNULL(DocumentVersions.RecordDeleted, 'N') <> 'Y'
	END

 
 /*PranayChange Begin*/   
   SELECT TOP 1 @ServiceIdMovedFrom =dm.ServiceIdFrom,
                @ScreenId=   CASE     
                              WHEN (@DocumentType = 17 AND sr.ScreenId IS NULL)    
                                  THEN 102    
                              ELSE sr.ScreenId    
                            END ,
	           @DocumentIdMovedFrom=d.DocumentId
		       FROM DocumentMoves dm LEFT JOIN Documents d ON d.ServiceId = dm.ServiceIdFrom 
		       LEFT JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId
		       WHERE dm.ServiceIdTo=@ServiceId AND d.Status=26  AND ISNULL(dm.RecordDeleted,'N')='N' ORDER BY dm.DateOfMove DESC
 /*PranayChange End*/   

	SELECT s.[ServiceId]
		,s.ClientId
		,s.[GroupServiceId]
		,s.[ProcedureCodeId]
		,s.[DateOfService]
		,s.[EndDateOfService]
		,s.[RecurringService]
		,s.[Unit]
		,s.[UnitType]
		,s.[Status]
		,s.[CancelReason]
		,s.[ProviderId]
		,s.[ClinicianId]
		,s.[AttendingId]
		,s.[ProgramId]
		,s.[LocationId]
		,s.[Billable]
		,s.[ClientWasPresent]
		,s.[OtherPersonsPresent]
		,s.[AuthorizationsApproved]
		,s.[AuthorizationsNeeded]
		,s.[AuthorizationsRequested]
		,s.[Charge]
		,s.[NumberOfTimeRescheduled]
		,s.[NumberOfTimesCancelled]
		,s.[ProcedureRateId]
		,s.[DoNotComplete]
		,s.[Comment]
		,s.[Flag1]
		,s.[OverrideError]
		,s.[OverrideBy]
		,s.[ReferringId]
		--,DateOfService as DateTimeIn                    
		--,EndDateOfService as DateTimeOut                                 
		,s.DateTimeIn
		,s.DateTimeOut
		,s.[NoteAuthorId]
		--,Services.[RowIdentifier]                                          
		--,Services.[ExternalReferenceId]                                                      
		,s.[CreatedBy]
		,s.[CreatedDate]
		,s.[ModifiedBy]
		,s.[ModifiedDate]
		,s.[RecordDeleted]
		,s.[DeletedDate]
		,s.[DeletedBy]
		,s.PlaceOfServiceId
		--,right(CONVERT(varchar, DateOfService, 100),7)  as 'StartTimeDateOfService'                              
		,REPLACE(Replace(Right(LTRIM(Right(Convert(VARCHAR, s.DateofService, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS 'StartTimeDateOfService'
		-- ,right(CONVERT(varchar, EndDateOfService, 100),7)  as  'EndTimeEndDateOfService'                            
		,REPLACE(Replace(Right(LTRIM(Right(Convert(VARCHAR, s.EndDateOfService, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS 'EndTimeEndDateOfService'
		--,right(CONVERT(varchar, DateOfService, 100),7)  as 'DateInDateTimeIn'                             
		--   , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,DateOfService,100),7)),7),'AM', ' AM'),'PM', ' PM')              
		--as 'DateInDateTimeIn'               
		,REPLACE(Replace(Right(LTRIM(Right(Convert(VARCHAR, s.DateTimeIn, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS 'DateInDateTimeIn'
		--        , REPLACE(Replace(Right(LTRIM(Right(Convert(varchar,EndDateOfService,100),7)),7),'AM', ' AM'),'PM', ' PM')              
		--as 'DateOutDateTimeOut'           
		,REPLACE(Replace(Right(LTRIM(Right(Convert(VARCHAR, s.DateTimeOut, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS 'DateOutDateTimeOut'
		,Staff.LastName + ', ' + Staff.FirstName AS 'ClinicianName'
		,s.SpecificLocation
		,s.[Status] AS SavedStatus
		-- Oct-26-2015  Akwinass
		,GNDC.ServiceNoteCodeId,
		---Nov-03-2015 Pavani

      s.ModifierId1 
      ,s.ModifierId2 
      ,s.ModifierId3 
      ,s.ModifierId4  
      , s.OverrideCharge
      ,s.OverrideChargeAmount
      ,s.ChargeAmountOverrideBy
      , m1.ModifierCode as ModifierCode1
      ,m2.ModifierCode as ModifierCode2
      ,m3.ModifierCode as ModifierCode3
      ,m4.ModifierCode as ModifierCode4
 ,m1.ModifierDescription as ModifierDescription1,    
 m2.ModifierDescription as ModifierDescription2, 
  m3.ModifierDescription as ModifierDescription3,
  m4.ModifierDescription as ModifierDescription4, 
   @ServiceIdMovedFrom AS ServiceIdMovedFrom,
   @DocumentIdMovedFrom AS DocumentIdMovedFrom,
   @ScreenId  AS ScreenIdMovedFrom,
   --12-MAR-2018   Akwinass
   s.NoteReplacement,
   s.AttachmentComments
	FROM Services as s
	---Nov-03-2015 Pavani
	  left join Modifiers m1 on m1.ModifierId=s.ModifierId1                           
       left join Modifiers m2 on m2.ModifierId=s.ModifierId2                            
       left join Modifiers m3 on m3.ModifierId=s.ModifierId3                           
       left join Modifiers m4 on m4.ModifierId=s.ModifierId4        
	
	----Nov-03-2015 Pavani Changes end here
	
	LEFT JOIN Staff ON Staff.StaffId = s.ClinicianId
	LEFT JOIN GroupServices GS ON s.GroupServiceId = GS.GroupServiceId AND ISNULL(GS.RecordDeleted, 'N') = 'N'
	LEFT JOIN Groups G ON GS.GroupId = G.GroupId AND ISNULL(G.RecordDeleted, 'N') = 'N'
	LEFT JOIN GroupNoteDocumentCodes GNDC ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId AND ISNULL(G.GroupNoteType,0) = 9383 AND ISNULL(GNDC.RecordDeleted, 'N') = 'N' -- 13-APRIL-2016 Akwinass
	WHERE ServiceId = @ServiceId
		AND ISNULL(s.RecordDeleted, 'N') = 'N'
		
		
		

	DECLARE @serviceStatus AS INT
	DECLARE @disableNoShowNotes AS CHAR(1)
	DECLARE @disableCancelNotes AS CHAR(1)

	SELECT TOP 1 @serviceStatus = STATUS
	FROM Services
	WHERE ServiceId = @ServiceId
		AND ISNULL(RecordDeleted, 'N') = 'N'

	SELECT TOP 1 @disableNoShowNotes = ISNULL(SystemConfigurations.DisableNoShowNotes, 'N')
	FROM SystemConfigurations

	SELECT TOP 1 @disableCancelNotes = ISNULL(SystemConfigurations.DisableCancelNotes, 'N')
	FROM SystemConfigurations

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
		,AppointmentId --Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp                                                  
	FROM Documents
	WHERE DocumentID = @DocumentID
		AND ISNULL(RecordDeleted, 'N') = 'N'

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
		,ReasonForNewVersion
	FROM [DocumentVersions]
	WHERE DocumentID = @DocumentID
		AND Version = @Version
		AND ISNULL(RecordDeleted, 'N') = 'N'

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
	WHERE ISNull(RecordDeleted, 'N') = 'N'
		AND DocumentId = @DocumentID

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
		,[ClientId]
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
		,[NumberofTimeRescheduled] --Added By Mmata Gupta                                                            
	FROM [Appointments]
	WHERE ServiceID = @ServiceId
		AND ISNULL(RecordDeleted, 'N') = 'N'

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
	WHERE ServiceID = @ServiceId
		AND ISNULL(RecordDeleted, 'N') = 'N'

	--ServiceGoals                                                                                         
	SELECT ServiceGoalId
		,ServiceId
		,NeedId
		,StageOfTreatment
		,RowIdentifier
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
	FROM ServiceGoals
	WHERE ServiceID = @ServiceId
		AND ISNULL(RecordDeleted, 'N') = 'N'

	--ServiceObjectives                           
	SELECT ServiceObjectiveId
		,ServiceId
		,ObjectiveId
		,RowIdentifier
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
	FROM ServiceObjectives
	WHERE ServiceID = @ServiceId
		AND ISNULL(RecordDeleted, 'N') = 'N'

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
	--      ,[ColumnMoney2]                --      ,[ColumnMoney3]                
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
	--  FROM [CustomFieldsData] where PrimaryKey1=@ServiceId and ISNULL(CustomFieldsData.RecordDeleted,'N')='N'     
	
	SELECT SD.ServiceDiagnosisId
		,SD.CreatedBy
		,SD.CreatedDate
		,SD.ModifiedBy
		,SD.ModifiedDate
		,SD.RecordDeleted
		,SD.DeletedDate
		,SD.DeletedBy
		,SD.ServiceId
		,SD.DSMCode
		,SD.DSMNumber
		,SD.DSMVCodeId
		,SD.ICD10Code
		,SD.ICD9Code
		,SD.[Order]
		,DD.ICDDescription AS 'Description'
	FROM ServiceDiagnosis SD
	JOIN Services AS s ON SD.ServiceId = s.ServiceId
	JOIN DiagnosisICD10Codes DD ON SD.DSMVCodeId = DD.ICD10CodeId
		AND SD.ICD10Code = DD.ICD10Code
	WHERE SD.DSMNumber IS NULL
		AND ISNULL(SD.RecordDeleted, 'N') = 'N'
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND SD.ServiceId = @ServiceId

	UNION

	SELECT SD.ServiceDiagnosisId
		,SD.CreatedBy
		,SD.CreatedDate
		,SD.ModifiedBy
		,SD.ModifiedDate
		,SD.RecordDeleted
		,SD.DeletedDate
		,SD.DeletedBy
		,SD.ServiceId
		,SD.DSMCode
		,SD.DSMNumber
		,SD.DSMVCodeId
		,SD.ICD10Code
		,SD.ICD9Code
		,SD.[Order]
		,DD.DSMDescription AS 'Description'
	FROM ServiceDiagnosis SD
	JOIN Services AS s ON SD.ServiceId = s.ServiceId
	JOIN DiagnosisDSMDescriptions DD ON SD.DSMCode = DD.DSMCode
		AND SD.DSMNumber = DD.DSMNumber
	WHERE SD.DSMVCodeId IS NULL
		AND ISNULL(SD.RecordDeleted, 'N') = 'N'
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND SD.ServiceId = @ServiceId

	UNION

	SELECT SD.ServiceDiagnosisId
		,SD.CreatedBy
		,SD.CreatedDate
		,SD.ModifiedBy
		,SD.ModifiedDate
		,SD.RecordDeleted
		,SD.DeletedDate
		,SD.DeletedBy
		,SD.ServiceId
		,SD.DSMCode
		,SD.DSMNumber
		,SD.DSMVCodeId
		,SD.ICD10Code
		,SD.ICD9Code
		,SD.[Order]
		,DD.ICDDescription AS 'Description'
	FROM ServiceDiagnosis SD
	JOIN Services AS s ON SD.ServiceId = s.ServiceId
	JOIN DiagnosisICDCodes DD ON SD.DSMCode = DD.ICDCode
	WHERE SD.DSMNumber IS NULL
		AND SD.DSMVCodeId IS NULL
		AND ISNULL(SD.RecordDeleted, 'N') = 'N'
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND SD.ServiceId = @ServiceId

	DECLARE @ResourceEnabled VARCHAR(5)

	SELECT @ResourceEnabled = UseResourceForService
	FROM SystemConfigurations

	IF ISNULL(@ResourceEnabled, 'N') = 'Y'
	BEGIN
		SELECT [AppointmentMasterId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,[Subject]
			,[Description]
			,[StartTime]
			,[EndTime]
			,[AppointmentType]
			,[ShowTimeAs]
			,[ServiceId]
			,[ResourceRecurringAppointmentId]
			,[RecurringAppointment]
		FROM AppointmentMaster RA
		WHERE ServiceId = @ServiceId
			AND ISNULL(RA.RecordDeleted, 'N') = 'N'

		SELECT AMR.[AppointmentMasterResourceId]
			,AMR.[CreatedBy]
			,AMR.[CreatedDate]
			,AMR.[ModifiedBy]
			,AMR.[ModifiedDate]
			,AMR.[RecordDeleted]
			,AMR.[DeletedBy]
			,AMR.[DeletedDate]
			,AMR.[AppointmentMasterId]
			,AMR.[ResourceId]
			,RS.[ResourceName] + ' (' + gsc.SubCodeName + ')' AS ResourceName
			,RS.[ResourceType] AS Type
			,AMR.[ResourceId] AS OrgResourceId
		FROM AppointmentMasterResources AMR
		INNER JOIN AppointmentMaster AM ON AM.AppointmentMasterId = AMR.AppointmentMasterId
		INNER JOIN Resources RS ON RS.ResourceId = AMR.[ResourceId]
		INNER JOIN GlobalSubCodes gsc ON gsc.GlobalSubCodeId = RS.ResourceSubType
		WHERE AM.ServiceId = @ServiceId
			AND ISNULL(AMR.RecordDeleted, 'N') = 'N'
			AND ISNULL(AM.RecordDeleted, 'N') = 'N'
			AND ISNULL(RS.RecordDeleted, 'N') = 'N'

		SELECT AMS.AppointmentMasterStaffId
			,AMS.CreatedBy
			,AMS.CreatedDate
			,AMS.ModifiedBy
			,AMS.ModifiedDate
			,AMS.RecordDeleted
			,AMS.DeletedBy
			,AMS.DeletedDate
			,AMS.AppointmentMasterId
			,AMS.StaffId
		FROM AppointmentMasterStaff AMS
		INNER JOIN AppointmentMasterResources AMR ON AMS.AppointmentMasterId = AMR.AppointmentMasterId
		INNER JOIN AppointmentMaster AM ON AM.AppointmentMasterId = AMR.AppointmentMasterId
		INNER JOIN Resources RS ON RS.ResourceId = AMR.[ResourceId]
		INNER JOIN GlobalSubCodes gsc ON gsc.GlobalSubCodeId = RS.ResourceSubType
		WHERE AM.ServiceId = @ServiceId
			AND ISNULL(AMS.RecordDeleted, 'N') = 'N'
			AND ISNULL(AMR.RecordDeleted, 'N') = 'N'
			AND ISNULL(AM.RecordDeleted, 'N') = 'N'
			AND ISNULL(RS.RecordDeleted, 'N') = 'N'
	END

	--Added By Khusro on 30/March/2014
	SELECT SA.ServiceAddOnCodeId
		,SA.CreatedBy
		,SA.CreatedDate
		,SA.ModifiedBy
		,SA.ModifiedDate
		,SA.RecordDeleted
		,SA.DeletedDate
		,SA.DeletedBy
		,SA.ServiceId
		,SA.AddOnProcedureCodeId
		,(
			SELECT TOP 1 ProcedureCodeName
			FROM ProcedureCodes
			WHERE ProcedureCodeId = SA.AddOnProcedureCodeId
			) AS AddOnProcedureCodeIdText
		,SA.AddOnServiceId
		-- Oct-19-2015  Akwinass
		,SA.AddOnProcedureCodeStartTime
		,SA.AddOnProcedureCodeUnit
		,SA.AddOnProcedureCodeUnitType
		,CASE WHEN SA.AddOnProcedureCodeStartTime IS NOT NULL THEN REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, SA.AddOnProcedureCodeStartTime), 100), 7)),'AM',' AM'),'PM',' PM') ELSE '' END AS DisplayStartTime
		,CAST(SA.AddOnProcedureCodeUnit AS VARCHAR(20)) + ' ' +gcsUnit.CodeName as UnitTypeDisplay
	 FROM ServiceAddOnCodes SA 
	 LEFT join GlobalCodes gcsUnit on SA.AddOnProcedureCodeUnitType = gcsUnit.GlobalCodeId
	WHERE SA.ServiceId = @ServiceId
		AND ISNULL(SA.RecordDeleted, 'N') = 'N'
	
	 --24-NOV-2017   Akwinass	
	EXEC ssp_SCGetServiceImageRecords @ServiceId

	--Modified by Davinder Kumar                                                             
	IF EXISTS (
			SELECT PARAMETER_NAME
			FROM information_schema.parameters
			WHERE specific_name = @CustomStoredProcedure
				AND PARAMETER_NAME = '@StaffId'
			)
	BEGIN
		--Following added by sonia                                                        
		IF (
				@DocumentType = 18
				AND @FillCustomTablesData = 'Y'
				) -- Changes by Sonia Ref Task #701                                                    
		BEGIN
			EXEC @CustomStoredProcedure @DocumentVersionId
				,@FillCustomTablesData
				--return                                                     
		END
				--Changes end over here                                                 
		ELSE
		BEGIN
			IF (@DocumentCodeId > 0)
			BEGIN
				EXEC @CustomStoredProcedure @DocumentVersionId
					,@StaffId = @AuthorId --@Version                                               
			END
		END
	END
	ELSE
	BEGIN
		--Following added by sonia                                                        
		IF (
				@DocumentType = 18
				AND @FillCustomTablesData = 'Y'
				) -- Changes by Sonia Ref Task #701                                                    
		BEGIN
			EXEC @CustomStoredProcedure @DocumentVersionId
				,@FillCustomTablesData
				--return                                                     
		END
				--Changes end over here                                                 
		ELSE
		BEGIN
			IF (@DocumentCodeId > 0)
			BEGIN
				EXEC @CustomStoredProcedure @DocumentVersionId --@Version                                               
			END
		END
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebGetServiceNoteDocumentData') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                                        
			16
			,-- Severity.                                                        
			1 -- State.                                                        
			);
END CATCH
GO

