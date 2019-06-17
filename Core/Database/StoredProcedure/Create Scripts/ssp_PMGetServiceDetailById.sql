/****** Object:  StoredProcedure [dbo].[ssp_PMGetServiceDetailById]    Script Date: 01/24/2014 19:02:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetServiceDetailById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetServiceDetailById] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMGetServiceDetailById]    Script Date: 01/24/2014 19:02:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




  
CREATE PROCEDURE  [dbo].[ssp_PMGetServiceDetailById]                     
(                                              
@ServiceId as int 
,@StaffId INT                                 
)                                              
As                                              
                                                      
Begin                                                      
/*********************************************************************/
BEGIN TRY                                                        
/* Stored Procedure: dbo.ssp_PMGetServiceDetailById             */                                               
                                              
/* Copyright: 2006 Streamline SmartCare*/                                                        
                                              
/* Creation Date:  20/08/2011                                   */                                                        
/*                                                                   */                                                        
/* Purpose:  */                                                       
/*                                                                   */                                                      
/* Input Parameters: @ServiceId */                                                      
/*                                                                   */                                                         
/* Output Parameters:                      */                                                        
/*                                                                   */                                                        
/* Return:    */                                                        
/*                                                                   */                                                        
/* Called By:  */                                              
/*      */                                              
                                              
/*                                                                   */                                                        
/* Calls:                                                            */                                                        
/*                                                                   */                                                        
/* Data Modifications:                                               */                                                        
/*                                                                   */                                                        
/*   Updates:                                                          */                                                        
                                              
/*       Date              Author                  Purpose                                    */                                                        
/*  20/08/2011  Priyanka Gupta                                     */    
/*  05/March/2011  Karan Garg				Changed the CurrentBalance Column to OpenCharges.balance*/                                                      
/* 26Apr2012		Shifali					Added Coluumn SpecificLocation in table Services while merging to 3.5x thread*/
/*	16/May/2012		Mamta Gupta				Task No. 1278 , Kalamazoo Bugs
											Services.RecordDeleted, DeletedBy and DeletedDate column added to remove concurrency.*/                             /*  16Aug2012		Shifali					Added field g.GroupId*/                         
/*28 Aug 2012		Rahul Aneja				Remove Hard Code Custom Field Data Table For The Service Detail as this is implemented on architecture to get the data*/
/* 12September2012		Maninder			Changed Case of StartTimeDateOfService */																
/* 24-01-2014    		Akwinass			Two Columns is Added to AppointmentMaster for Task #1932 Summit Pointe Support*/																
/* 26 May 2014			Vithobha			Added an Logic to Pull data for new Diagnosis Tab Engineering Improvement Initiatives- NBL(I): #1419 8 Diagnosis Codes*/   
/* 30/June/2014    Md Hussain Khusro	    Added the new table 'ServiceAddOnCodes' in result set for task #1420 Engineering Improvement Initiatives- NBL(I)*/													
-- OCT-07-2014          Akwinass            Removed Columns 'DiagnosisCode1,DiagnosisNumber1,DiagnosisVersion1,DiagnosisCode2,DiagnosisNumber2,DiagnosisVersion2,DiagnosisCode3,DiagnosisNumber3,DiagnosisVersion3' from Services table (Task #134 in Engineering Improvement Initiatives- NBL(I))        
-- NOV-06-2014          Akwinass            Top 1 Condition Included in Select Set To avoid SubQuery Error (Task #1419.09 in Engineering Improvement Initiatives- NBL(I))
-- 20/Nov/2014     Md Hussain Khusro		Change the logic for "Current Balance" as per Slavik comment in ace and fixed minor issues as per email communication with Slavik 
--											for Core Bugs #1650
-- DEC-31-2014          Akwinass            Used 'DiagnosisICD10Codes' table instead DiagnosisDSMVCodes as per new ICD10 logic to avoid build error (Task #1419.09 in Engineering Improvement Initiatives- NBL(I))
	-- 16 Jan 2015			Avi Goyal			What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks
	--											Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations
	-- July-03-2015         Akwinass            SystemConfigurationKeys 'BILLINGDIAGNOSISDEFAULTBUTTON' Logic Implemented.(Task #147 in Valley Client Acceptance Testing Issues)
	--07/06/2015          Hemant                Added  OverrideCharge,OverrideChargeAmount,ChargeAmountOverrideBy in services table #605.1; Project : Network-180 Customizations
--	08/10/2015			Wasif Butt			ClientId selection should be from Services table.
-- 18-Aug-2015	Pradeep		Added Null check on @ICDButton variable. Newaygo Support #304
-- Sep-23-2015  Akwinass     ServiceDiagnosis Table Select Modified as Per Tom's Code(Task #27 in  	ICD10 Service Diagnosis Changes) 
-- Oct-19-2015  Akwinass     Added new Columns 'AddOnProcedureCodeStartTime,AddOnProcedureCodeUnit,AddOnProcedureCodeUnitType' to 'ServiceAddOnCodes'(Task #213 in Engineering Improvement Initiatives- NBL(I)) 
-- 19 Oct 2015  Revathi    what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.      
	--							why:task #609, Network180 Customization  
-- 30/Nov/2015  Ponnin       What :Added @IsServiceBilled flag in Services table and returing table "ServiceUpdateHistory" and calling SSP 'ssp_SCShowServiceUpdateHistory'  Why :task #238 , Engineering Improvement Initiatives- NBL(I)          */  
-- 09/Dec/2015  Ponnin       What :Added condition as 'LastBilledDate IS NOT NULL' for charges table to find the billed services   Why :task #238 , Engineering Improvement Initiatives- NBL(I)          */  
-- 14/Dec/2015  Ponnin       What :Reverted the changes of "Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. why:task #609, Network180 Customization "  Why :task #238 , Engineering Improvement Initiatives- NBL(I)          */  
-- 08 Jan 2016  Revathi    what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.      
	--							why:task #609, Network180 Customization  
-- 16/Jan/2017  Lakshmi      What: Added client 'Active' field to select statement Why:Harbor - Support #1089
--06/27/2017    Pranay       Harbor Task#857 Move Document added @ServiceIdMovedFrom,@DocumentIdMovedFrom,@ScreenId
--24-NOV-2017   Akwinass     Added SSP to get ImageRecords (Task #589 in Engineering Improvement Initiatives- NBL(I))
--12-MAR-2018   Akwinass     Added "NoteReplacement" and "AttachmentComments" columns to "Services" table (Task #589.1 in Engineering Improvement Initiatives- NBL(I))
/*********************************************************************/                                                         
   DECLARE @ClientId INT                   
   
   DECLARE @ClientPhones varchar(100)
   Declare @DiagnosisDocumentCodeID int   
   Declare @varClientId int   
   Declare @CurDiagnosisDocumentCodeID int 
   Declare @LatestDiagnosisDocumentVersionId int   
   DECLARE @IsServiceBilled char(1)  = 'N'  
   DECLARE @ServiceIdMovedFrom int =0
   DECLARE @DocumentIdMovedFrom INT=0
   DECLARE @ScreenId  INT --MovedScreenId
  -- EXEC ssp_SCServiceDetailUpdatePermission @StaffId, @OverrideService OUTPUT
  
IF  EXISTS (
		SELECT 1
		FROM Charges
		WHERE ServiceId = @ServiceId 
			AND ISNULL(RecordDeleted, 'N') = 'N' AND LastBilledDate IS NOT NULL
		)
		BEGIN
		SET @IsServiceBilled = 'Y'
		END ELSE 
		BEGIN
		SET @IsServiceBilled = 'N'
		END
                     
   SELECT TOP 1 @ClientId= ClientId FROM Services WHERE ServiceId=@ServiceId                  
     
     SELECT @ClientPhones = COALESCE(@ClientPhones + ', ', '') + 
   CP.PhoneNumber
FROM ClientPhones CP where  Phonetype in (30,31) AND ISNULL(CP.RecordDeleted,'N')='N' AND CP.ClientId = @ClientId
 
 
 /*PranayChange Begin*/    
  SELECT TOP 1 @ServiceIdMovedFrom =dm.ServiceIdFrom,
                @ScreenId=   CASE     
                              WHEN (dc.DocumentType = 17 AND sr.ScreenId IS NULL)    
                                  THEN 102    
                              ELSE sr.ScreenId    
                            END ,
	           @DocumentIdMovedFrom=d.DocumentId
		       FROM DocumentMoves dm LEFT JOIN Documents d ON d.ServiceId = dm.ServiceIdFrom 
		       LEFT JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId
			   LEFT JOIN  DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
		       WHERE dm.ServiceIdTo=@ServiceId AND d.Status=26 AND ISNULL(dm.RecordDeleted,'N')='N' ORDER BY dm.DateOfMove DESC
		 
/*PranayChange End*/
	                          
  SELECT  s.ServiceId,                          
 s.CreatedBy,                          
 s.CreatedDate,                             
 s.ModifiedBy,                         
 s.ModifiedDate,              
 s.ClientId,              
	--Added by Revathi 08 Jan 2016       
		CASE 
			WHEN ISNULL(C.ClientType, 'I') = 'I'
				THEN ISNULL(c.LastName, '') + ', ' + ISNULL(c.FirstName, '')
			ELSE ISNULL(C.OrganizationName, '')
			END AS ClientName
		,           
		
-- Changed by Hussain Khusro on 11/20/2014  
 CASE WHEN s.Status = 75 THEN ISNULL(CHARL.Amount, 0.00) 
     ELSE CHARL.Amount 
 END AS CurrentBalance , 
--Changes End here-----  
 s.GroupServiceId,              
 g.GroupName,               
 s.ProcedureCodeId,              
 pro.DisplayAs,            
 pro.AllowModifiersOnService,            
 pro.EndDateEqualsStartDate,    
 pro.RequiresTimeInTimeOut,            
 s.DateOfService,              
 convert(varchar,  s.DateOfService, 108) as StartTimeDateOfService,               
 s.EndDateOfService,      
 s.RecurringService,              
 s.Unit,              
 s.UnitType,     
 gcsUnit.CodeName as UnitTypeDisplay,             
 s.Status,     
 s.Status as OriginalStatus,    
 gcs.CodeName,              
 s.CancelReason,      
 s.ProviderId,              
 s.ClinicianId,                                                                        
 a.LastName + ', ' + a.FirstName as AuthorName  ,               
 s.AttendingId,              
 s.ProgramId,              
 p.ProgramCode,               
 s.LocationId,              
 s.Billable,            
 s.ClientWasPresent,              
 s.OtherPersonsPresent,      
 s.AuthorizationsApproved,              
 s.AuthorizationsNeeded,       
 s.AuthorizationsRequested,             
 s.Charge,
 s.NumberOfTimeRescheduled,      
 s.NumberOfTimesCancelled,              
 s.ProcedureRateId,              
 s.DoNotComplete,              
 s.Comment,      
 s.Flag1,              
 s.OverrideBy,              
 s.OverrideError,       
 s.ReferringId,      
 s.DateTimeIn,      
 s.DateTimeOut,      
 s.NoteAuthorId,                        
 s.ModifierId1,                          
 m1.ModifierCode as ModifierCode1,                          
 m1.ModifierDescription as ModifierDescription1,                                 
 s.ModifierId2,                          
 m2.ModifierCode as ModifierCode2,                          
 m2.ModifierDescription as ModifierDescription2,                          
 s.ModifierId3,                          
 m3.ModifierCode as ModifierCode3,                          
 m3.ModifierDescription as ModifierDescription3,                          
 s.ModifierId4,                          
 m4.ModifierCode as ModifierCode4,                          
 m4.ModifierDescription as ModifierDescription4,        
 s.PlaceOfServiceId,    
 d.Status as DocumentStatus,                      
 d.DocumentId ,                                        
 d.CurrentDocumentVersionId ,                                        
 d.CurrentDocumentVersionId as DocumentVersionId,                                        
 d.DocumentCodeId,
@ClientPhones as ClientPhones
,s.SpecificLocation
 --16/May/2012 - Mamta Gupta - Task No. 1278 , Kalamazoo Bugs - Services.RecordDeleted, DeletedBy and DeletedDate column added to remove concurrency.
 ,s.RecordDeleted,
 s.DeletedBy,
 s.DeletedDate
 ,g.GroupId 
 ,s.OverrideCharge
 ,s.OverrideChargeAmount
 ,s.ChargeAmountOverrideBy  
 ,isnull(c.Active,'Y') as clientActive /*Added by Lakshmi on 16/01/2017*/
 ,@IsServiceBilled as IsServiceBilled  
 ,@ServiceIdMovedFrom AS ServiceIdMovedFrom
 ,@DocumentIdMovedFrom AS  DocumentIdMovedFrom 
 ,  @ScreenId AS ScreenIdMovedFrom
 --12-MAR-2018   Akwinass
 ,s.NoteReplacement
 ,s.AttachmentComments                                                                 from [Services] s                                                                                   
       join Programs p on p.ProgramId =  s.ProgramId                                                         
       join ProcedureCodes pro on pro.ProcedureCodeId= s.ProcedureCodeId                                          
       left join Documents d on  d.ServiceId=s.ServiceId      and ISNULL(d.RecordDeleted,'N')<>'Y'                                           
       join GlobalCodes gcs on gcs.GlobalCodeId =  s.Status        
       join GlobalCodes gcsUnit on gcsUnit.GlobalCodeId =  s.UnitType                                                     
       left join Staff a on a.StaffId = s.ClinicianId                               
       inner join Clients c on c.ClientId = s.ClientId                          
       left join GroupServices gs on gs.GroupServiceId=s.GroupServiceId                      
       left join Groups g on g.GroupId=gs.GroupId                       
       left join Modifiers m1 on m1.ModifierId=s.ModifierId1                           
       left join Modifiers m2 on m2.ModifierId=s.ModifierId2                            
       left join Modifiers m3 on m3.ModifierId=s.ModifierId3                           
       left join Modifiers m4 on m4.ModifierId=s.ModifierId4 
	--   LEFT join DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId  --Pranay   
	 --  LEFT JOIN screens sc ON sc.DocumentCodeId = d.DocumentCodeId  --Pranay                       
		-- Added by Hussain Khusro on 11/20/2014 as per Slavik comment in ace 
	   LEFT JOIN (SELECT ch.ServiceId,SUM(ARL.Amount) As Amount FROM Charges Ch 
			JOIN OpenCharges OC ON CH.ChargeId = OC.ChargeId
			JOIN ARLedger ARL ON ARL.ChargeId = OC.ChargeId    
			WHERE ch.ServiceId = @ServiceId AND ISNULL(Ch.RecordDeleted, 'N') <> 'Y' AND ISNULL(OC.RecordDeleted, 'N') <> 'Y' AND ISNULL(ARL.RecordDeleted, 'N') <> 'Y'
			GROUP BY ch.ServiceId) CHARL ON s.ServiceId=CHARL.ServiceId
		-- Changes End here ----
 where                               
  s.ServiceId =@ServiceId                               
             
          
                     
   Select ServiceErrorId,ServiceId,ErrorType,ErrorSeverity,                  
   ErrorMessage,NextStep, RowIdentifier,CreatedBy,CreatedDate,ModifiedBy,                  
   ModifiedDate from  [ServiceErrors]                  
   where ServiceId=@ServiceId and ISNULL(RecordDeleted,'N') = 'N'                  
                     
  SELECT CN.clientNoteId
		,CN.ClientId
		,CN.NoteType
		,CN.Note
		,CN.Active
		,
		--GC.CodeName,								-- Commented by Avi Goyal, on 16 Jan 2015 
		FT.FlagType AS CodeName
		,-- Added by Avi Goyal, on 16 Jan 2015  
		CN.AssignedTo
		,CN.CreatedBy
		,CN.CreatedDate
		,CN.ModifiedBy
		,CN.ModifiedDate
		,
		--GC.Bitmap,GC.BitmapImage					-- Commented by Avi Goyal, on 16 Jan 2015 
		FT.Bitmap
		,FT.BitmapImage -- Added by Avi Goyal, on 16 Jan 2015  
	FROM clientNotes CN                        
	--left outer join GlobalCodes GC on CN.NoteType=GC.GlobalCodeId   -- Commented by Avi Goyal, on 16 Jan 2015
	-- Added by Avi Goyal, on 16 Jan 2015
	INNER JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType
		AND ISNULL(FT.RecordDeleted, 'N') = 'N'
		AND ISNULL(FT.DoNotDisplayFlag, 'N') = 'N'
		AND (
			ISNULL(FT.PermissionedFlag, 'N') = 'N'
			OR (
				ISNULL(FT.PermissionedFlag, 'N') = 'Y'
				AND (
					(
						EXISTS (
							SELECT 1
							FROM PermissionTemplateItems PTI
							INNER JOIN PermissionTemplates PT ON PT.PermissionTemplateId = PTI.PermissionTemplateId
								AND ISNULL(PT.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType) = 'Flags'
							INNER JOIN StaffRoles SR ON SR.RoleId = PT.RoleId
								AND ISNULL(SR.RecordDeleted, 'N') = 'N'
							WHERE ISNULL(PTI.RecordDeleted, 'N') = 'N'
								AND PTI.PermissionItemId = FT.FlagTypeId
								AND SR.StaffId = @StaffId
							)
						OR EXISTS (
							SELECT 1
							FROM StaffPermissionExceptions SPE
							WHERE SPE.StaffId = @StaffId
								AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
								AND SPE.PermissionItemId = FT.FlagTypeId
								AND SPE.Allow = 'Y'
								AND (
									SPE.StartDate IS NULL
									OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
									)
								AND (
									SPE.EndDate IS NULL
									OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
									)
							)
						)
					AND NOT EXISTS (
						SELECT 1
						FROM StaffPermissionExceptions SPE
						WHERE SPE.StaffId = @StaffId
							AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
							AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
							AND SPE.PermissionItemId = FT.FlagTypeId
							AND SPE.Allow = 'N'
							AND (
								SPE.StartDate IS NULL
								OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
								)
							AND (
								SPE.EndDate IS NULL
								OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
								)
						)
					)
				)
			)
	WHERE --GC.Category='ClientNoteType' and							-- Commented by Avi Goyal, on 16 Jan 2015
		CN.ClientId = @ClientId
		AND IsNull(CN.RecordDeleted, 'N') = 'N'
		AND CN.Active = 'Y'
		AND (
			(
				GETDATE() >= isnull(CN.StartDate, GETDATE())
				AND GETDATE() <= isnull(DATEADD(Day, 1, CN.EndDate), '01/01/2070')
				)
			)
	ORDER BY 1 DESC            
             
   select * from Appointments where ServiceId=@ServiceId   
   
   DECLARE @ResourceEnabled VARCHAR(5)    
SELECT TOP 1 @ResourceEnabled=UseResourceForService FROM SystemConfigurations    
 IF ISNULL(@ResourceEnabled, 'N') = 'Y'                     
            BEGIN                     
    SELECT    [AppointmentMasterId],          
       [CreatedBy],          
       [CreatedDate],          
       [ModifiedBy],          
       [ModifiedDate],          
       [RecordDeleted],          
       [DeletedBy],          
       [DeletedDate],          
       [Subject],          
       [Description],          
       [StartTime],          
       [EndTime],          
       [AppointmentType],          
       [ShowTimeAs],          
       [ServiceId],
       [ResourceRecurringAppointmentId],
       [RecurringAppointment]                 
      FROM AppointmentMaster RA            
      WHERE ServiceId= @ServiceId          
      AND ISNULL(RA.RecordDeleted,'N')='N'          
                
      SELECT AMR.[AppointmentMasterResourceId],          
       AMR.[CreatedBy],          
       AMR.[CreatedDate],          
       AMR.[ModifiedBy],          
       AMR.[ModifiedDate],          
       AMR.[RecordDeleted],          
       AMR.[DeletedBy],          
       AMR.[DeletedDate],          
       AMR.[AppointmentMasterId],          
       AMR.[ResourceId],          
       RS.[ResourceName] + ' ('+gsc.SubCodeName+')' as ResourceName,          
       RS.[ResourceType] as Type,          
       AMR.[ResourceId] as OrgResourceId          
      FROM AppointmentMasterResources AMR          
      join AppointmentMaster AM on AM.AppointmentMasterId= AMR.AppointmentMasterId          
      join Resources RS on RS.ResourceId=AMR.[ResourceId]          
      join GlobalSubCodes gsc on gsc.GlobalSubCodeId=RS.ResourceSubType          
      WHERE AM.ServiceId=@ServiceId          
      AND ISNULL(AMR.RecordDeleted,'N')='N'          
      AND ISNULL(AM.RecordDeleted,'N')='N'          
      AND ISNULL(RS.RecordDeleted,'N')='N'

   END 
    
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
 
 --Added By Khusro on 30/March/2014
	 SELECT SA.ServiceAddOnCodeId,
	 SA.CreatedBy,
	 SA.CreatedDate,
	 SA.ModifiedBy,
	 SA.ModifiedDate,
	 SA.RecordDeleted,
	 SA.DeletedDate,
	 SA.DeletedBy,
	 SA.ServiceId,
	 SA.AddOnProcedureCodeId,
	 (SELECT TOP 1 ProcedureCodeName FROM ProcedureCodes WHERE ProcedureCodeId= SA.AddOnProcedureCodeId) as AddOnProcedureCodeIdText,
	 SA.AddOnServiceId,
	 -- Oct-19-2015  Akwinass
	 SA.AddOnProcedureCodeStartTime,
	 SA.AddOnProcedureCodeUnit,
	 SA.AddOnProcedureCodeUnitType,
	 CASE WHEN SA.AddOnProcedureCodeStartTime IS NOT NULL THEN REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, SA.AddOnProcedureCodeStartTime), 100), 7)),'AM',' AM'),'PM',' PM') ELSE '' END AS DisplayStartTime,
	 CAST(SA.AddOnProcedureCodeUnit AS VARCHAR(20)) + ' ' +gcsUnit.CodeName as UnitTypeDisplay
	 FROM ServiceAddOnCodes SA 
	 LEFT join GlobalCodes gcsUnit on SA.AddOnProcedureCodeUnitType = gcsUnit.GlobalCodeId
	 WHERE SA.ServiceId=@ServiceId and ISNULL(SA.RecordDeleted,'N')='N'
	       
	SELECT   
	-1 as ServiceUpdateHistoryId,                                            
	s.CreatedBy,
	s.CreatedDate,
	s.ModifiedBy,
	s.ModifiedDate,
	s.RecordDeleted,
	s.DeletedBy,
	s.DeletedDate,          
	s.ServiceId,  
	s.ProcedureCodeId,
	s.ProgramId,
	s.LocationId,
	s.ClinicianId,
	s.AttendingId,
	s.DateOfService as  StartDate,
	s.DateOfService as StartTime,
	s.EndDateOfService as EndDate,
	s.EndDateOfService as EndTime,
	s.PlaceOfServiceId
	 from [Services] s where s.ServiceId = @ServiceId AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
	       
	       
	 EXEC ssp_SCShowServiceUpdateHistory @ServiceId
	 --24-NOV-2017   Akwinass
	 EXEC ssp_SCGetServiceImageRecords @ServiceId
	       
   /*Code Commented By Rahul Aneja Remove Hard Code Custom Field Data Table For TheService Detail as this is implemented on architecture to get the data*/
  /* select * from CustomFieldsData where PrimaryKey1=@ServiceId         */   
   --Checking For Errors                                              
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMGetServiceDetailById') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH
END

GO


