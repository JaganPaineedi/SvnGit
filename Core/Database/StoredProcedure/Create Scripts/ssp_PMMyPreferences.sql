IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_PMMyPreferences]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_PMMyPreferences] 

GO
 
 CREATE PROCEDURE [dbo].[ssp_PMMyPreferences]  
 @LoggedInUserId INT  
   
AS  
  
/********************************************************************************/                                                    
-- Stored Procedure: ssp_PMMyPreferences  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Procedure to return data for the my preferences page.  
--  
-- Author:  Girish Sanaba  
-- Date:    August 08 2011  
--  
-- *****History****  
-- 24 Aug 2011 Girish Removed References to Rowidentifier and/or ExternalReferenceId  
  
 --20 Jan 2012 Shruthi.S Uncommented changes of programviews  
 --21 June 2012 PSelvan  For Ace Harbor Go Live Issues #1608  
 --10/24/2012 Jeff Riley - Fixed issue with duplicate quick actions caused by multiple   
  --                         banners pointing to same ScreenId  
 --03 OCT 2016   Pavani          Added StaffPrefernences table , Mobile Task#2  
 /* Nov-28-2016 Lakshmi Kanth    Added coloumn 'AllowAccessToAllScannedDocuments' to staff table, Ionia - Support #370 */
-- 03/04/2017    jcarlson		Engineering Improvement Initiatives 493- New field: StreamlineStaff
/* 18 May 2017   Manjunath K	Added ClientPharmacy Table For Engineering Improvement Initiatives 528 */
/* 11 OCT 2017   Suneel N		Added StaffNotifications Tables For Harbor Enhancements #1262 */
/*16 Aug 2018 Vishnu Narayanan  What :Added StaffNotificationSubscriptions Table and added few columns to StaffPreferences Table */
/*                              Why: Mobile-Task#6                              */   
/*21 Sep 2018 Vishnu Narayanan  What :Added MobileDeviceRegistrationId and RegisteredForMobileNotificationsTimeStamp to StaffPrefernces*/
/*                                Why : Mobile - #6                             */
/*10 Oct 2018 Vishnu Narayanan  Removed MobileDeviceRegistrationId,SubscribedForPushNotifications,SubscribedForSMSNotifications,SubscribedForEmailNotifications and*/ 
/*                              Added RegisteredForSMSNotifications and RegisteredForEmailNotifications to StaffPreferences for Mobile#6*/
/*04 Dec 2018 Vishnu Naryanan What/Why : Removed StaffNotificationSubscriptions Table for Mobile-#6 */
/*********************************************************************************/ 
  
BEGIN  
  DECLARE @TempClientId INT
 BEGIN TRY  
    
     EXEC [dbo].[ssp_getStaffInformation] @LoggedInUserId  
	  
     CREATE TABLE #StaffNotificationSetupGrid(StaffNotificationId INT,
									DaysList VARCHAR(MAX))
	INSERT INTO #StaffNotificationSetupGrid(StaffNotificationId,DaysList)
	SELECT  StaffNotificationId
			,Case WHEN ISNULL(Monday,'N')='Y' THEN 'M,'  ELSE '' END   +    
			Case WHEN ISNULL(Tuesday,'N')='Y' THEN  'T,' ELSE ''  END  +    
			Case WHEN ISNULL(Wednesday,'N')='Y'  THEN 'W,' ELSE ''  END   +    
			Case WHEN ISNULL(Thursday,'N')='Y'  THEN    'Th,'  ELSE '' END    +    
			Case WHEN ISNULL(Friday,'N')='Y'  THEN    'F,'  ELSE '' END    +    
			Case WHEN ISNULL(Saturday,'N')='Y'  THEN    'Sa,' ELSE ''  END    +    
			Case WHEN ISNULL(Sunday,'N')='Y'    THEN    'Su,'  ELSE '' END   AS DaysList 
	FROM StaffNotifications SN
	INNER JOIN StaffPreferences SP ON SN.staffID=SP.StaffId    
	 WHERE SN.StaffId= @LoggedInUserId    
	 AND  ISNULL(SN.RecordDeleted,'N')= 'N'       
	 AND  ISNULL(SP.RecordDeleted,'N')= 'N'      
                                 
  SELECT     StaffSecurityQuestionId, StaffId, SecurityQuestion, SecurityAnswer  
   ,RowIdentifier  
   , CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate,       
        DeletedBy      
  FROM         StaffSecurityQuestions       
     WHERE     (StaffId = @LoggedInUserId)     
     AND ISNULL(RecordDeleted,'N') = 'N'   
       
           
 ----ProgramView   
 SELECT  [ProgramViewId]  
      ,[UserStaffId]  
      ,[ViewName]  
      ,[AllPrograms]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[RowIdentifier],       
 AllPrograms1 =                                      
   CASE AllPrograms                                      
  WHEN 'Y' THEN 'All'                                      
  WHEN 'N' THEN 'Some'                                      
   END  
 FROM ProgramViews   
 WHERE UserStaffId=@LoggedInUserId  AND ISNULL(RecordDeleted,'N') = 'N'                                      
 ORDER BY ViewName   
   
 ----Multi Program Views  
 SELECT PVP.ProgramViewProgramId  
      ,PVP.ProgramViewId  
      ,PVP.ProgramId  
      ,PVP.RowIdentifier  
      ,PVP.CreatedBy  
      ,PVP.CreatedDate  
      ,PVP.ModifiedBy  
      ,PVP.ModifiedDate  
      ,PVP.RecordDeleted  
      ,PVP.DeletedDate  
      ,PVP.DeletedBy  
      ,PV.ViewName   
 FROM ProgramViewPrograms PVP                             
 INNER JOIN                                       
  ProgramViews PV                                      
 ON                                       
  PV.ProgramViewId = PVP.ProgramViewId AND PV.UserStaffId=@LoggedInUserId                                  
 WHERE                                      
  (PV.RecordDeleted = 'N'OR PV.RecordDeleted IS NULL)                                      
 AND                                      
  (PVP.RecordDeleted = 'N'OR PVP.RecordDeleted IS NULL)                     
         
 --       --Staff Views  
 --SELECT [MultiStaffViewId]  
 --     ,[UserStaffId]  
 --     ,[ViewName]  
 --     ,[AllStaff]  
 --     ,[CreatedBy]  
 --     ,[CreatedDate]  
 --     ,[ModifiedBy]  
 --     ,[ModifiedDate]  
 --     ,[RecordDeleted]  
 --     ,[DeletedDate]  
 --     ,[DeletedBy],   
 --AllStaff1 =                                      
 --  CASE AllStaff                                      
 -- WHEN 'Y' THEN 'All'                                      
 -- WHEN 'N' THEN 'Some'                                      
 --  END   
 --FROM MultiStaffViews   
 --WHERE UserStaffId=@LoggedInUserId                                      
 --AND ISNULL(RecordDeleted,'N') = 'N'  
 --ORDER BY ViewName                                  
                                       
 ----Multi Staff View                                      
 --SELECT  SVS.MultiStaffViewStaffId  
 --     ,SVS.MultiStaffViewId  
 --     ,SVS.StaffId  
 --     --,SVS.RowIdentifier  
 --     ,SVS.CreatedBy  
 --     ,SVS.CreatedDate  
 --     ,SVS.ModifiedBy  
 --     ,SVS.ModifiedDate  
 --     ,SVS.RecordDeleted  
 --     ,SVS.DeletedDate  
 --     ,SVS.DeletedBy  
 --     ,SV.ViewName  
        
 --FROM MultiStaffViewStaff SVS                                      
 --INNER JOIN                                       
 -- MultiStaffViews SV                                      
 --ON                                       
 -- SV.MultiStaffViewId = SVS.MultiStaffViewId                                      
 --WHERE                                      
 -- (SV.RecordDeleted = 'N' OR SV.RecordDeleted IS NULL)                                      
 --AND                                      
 -- (SVS.RecordDeleted = 'N' OR SVS.RecordDeleted IS NULL)                                      
 --AND      SV. UserStaffId=@LoggedInUserId                           
       --Quick Action Order  
 SELECT  distinct                                 
    T.DisplayAs + ' - ' +  S.ScreenName  AS BannerScreen                                    
    ,SQ.StaffQuickActionId  
      ,SQ.StaffId  
      ,SQ.ScreenId  
      ,SQ.SortOrder  
      --,SQ.RowIdentifier  
      ,SQ.CreatedBy  
      ,SQ.CreatedDate  
      ,SQ.ModifiedBy  
      ,SQ.ModifiedDate  
      ,SQ.RecordDeleted  
      ,SQ.DeletedDate  
      ,SQ.DeletedBy                                     
 FROM                                       
  StaffQuickActions SQ                                      
 INNER JOIN Screens S ON S.ScreenId=SQ.ScreenId    
 INNER JOIN Banners B ON S.ScreenId = B.ScreenId   
 INNER JOIN Tabs T ON B.TabId = T.TabId                                        
 WHERE SQ.StaffID = @LoggedInUserId                                      
 AND  ISNULL(SQ.RecordDeleted,'N')= 'N'   
 AND  ISNULL(S.RecordDeleted,'N')= 'N'                                    
 AND  ISNULL(B.RecordDeleted,'N')= 'N'   
 AND  ISNULL(T.RecordDeleted,'N')= 'N'   
 ORDER BY SQ.SortOrder,BannerScreen   
   
  --03 OCT 2016    Pavani       
 --StaffPrefernences    
 select     
 SP.StaffPreferenceId,    
 SP.CreatedBy,    
SP.CreatedDate,    
SP.ModifiedBy,    
SP.ModifiedDate,    
SP.RecordDeleted,    
SP.DeletedBy,    
SP.DeletedDate,    
 SP.StaffId,
 SP.DefaultMobileHomePageId,    
 SP.DefaultMobileProgramId,    
 SP.MobileCalendarEventsDaysLookUpInPast,    
 SP.MobileCalendarEventsDaysLookUpInFuture, 
 s.MobileSmartKey,
 s.AllowMobileAccess,   
 s.AllowAccessToAllScannedDocuments,
 sp.StreamlineStaff,
 sp.NotifyMeOfMyServices,
 SP.RegisteredForMobileNotifications,
 SP.LastTFATimeStamp, 
 SP.RegisteredForMobileNotificationsTimeStamp,
 SP.RegisteredForSMSNotifications,
 SP.RegisteredForEmailNotifications
 from StaffPreferences SP    
 INNER JOIN Staff s ON SP.staffID=s.StaffId    
 WHERE SP.StaffId= @LoggedInUserId    
 AND  ISNULL(SP.RecordDeleted,'N')= 'N'       
 AND  ISNULL(S.RecordDeleted,'N')= 'N'      
  
   ----ClientPharmacies		18 May 2017   Manjunath K
    Select @TempClientId=TempClientId from Staff where StaffId=@LoggedInUserId
	SELECT 
	CP.ClientPharmacyId,
	CP.ClientId,
	CP.SequenceNumber,
	CP.PharmacyId,
	CP.ExternalReferenceId,
	CP.RowIdentifier,
	CP.CreatedBy,
	CP.CreatedDate,
	CP.ModifiedBy,
	CP.ModifiedDate,
	CP.RecordDeleted,
	CP.DeletedDate,
	CP.DeletedBy
	FROM ClientPharmacies CP
	WHERE IsNull(CP.RecordDeleted,'N')<>'Y'
	AND CP.ClientId = @TempClientId
	
select     
 SN.StaffNotificationId,    
 SN.CreatedBy,    
SN.CreatedDate,    
SN.ModifiedBy,    
SN.ModifiedDate,    
SN.RecordDeleted,    
SN.DeletedBy,    
SN.DeletedDate,    
 SN.StaffId,
 SN.Active,    
 SN.Monday,    
 SN.Tuesday,    
 SN.Wednesday, 
 SN.Thursday,
 SN.Friday,
 SN.Saturday,
 SN.Sunday,
 SN.AllProgram,
 SN.ProgramGroupName,
 SN.AllProcedure,
 SN.ProcedureGroupName,
 SN.AllStaff,
 SN.StaffGroupName,
 SN.AllLocation,
 SN.LocationGroupName,
 CASE T.DaysList WHEN null THEN null
		ELSE (
         CASE LEN(T.DaysList) WHEN 0 THEN T.DaysList 
            ELSE LEFT(T.DaysList, LEN(T.DaysList) - 1) 
         END 
		) END AS DaysOfWeek,
 Case WHEN ISNULL(SN.Active,'N')='Y' THEN 'Active'  ELSE 'Inactive' END AS Status
 FROM #StaffNotificationSetupGrid T
 JOIN StaffNotifications SN ON SN.StaffNotificationId = T.StaffNotificationId 
 INNER JOIN StaffPreferences SP ON SN.staffID=SP.StaffId    
 WHERE SN.StaffId= @LoggedInUserId    
 AND  ISNULL(SN.RecordDeleted,'N')= 'N'       
 AND  ISNULL(SP.RecordDeleted,'N')= 'N' 
 
 select     
 SNP.StaffNotificationProgramId,    
 SNP.CreatedBy,    
SNP.CreatedDate,    
SNP.ModifiedBy,    
SNP.ModifiedDate,    
SNP.RecordDeleted,    
SNP.DeletedBy,    
SNP.DeletedDate,    
 SNP.StaffNotificationId,
 SNP.ProgramId
 from StaffNotificationPrograms SNP    
 INNER JOIN StaffNotifications SN ON SNP.StaffNotificationId=SN.StaffNotificationId    
 WHERE SN.StaffNotificationId IN (SELECT StaffNotificationId from StaffNotifications where StaffId=@LoggedInUserId)    
 AND  ISNULL(SNP.RecordDeleted,'N')= 'N'       
 AND  ISNULL(SN.RecordDeleted,'N')= 'N'
 
 select     
 SNPC.StaffNotificationProcedureId,    
 SNPC.CreatedBy,    
SNPC.CreatedDate,    
SNPC.ModifiedBy,    
SNPC.ModifiedDate,    
SNPC.RecordDeleted,    
SNPC.DeletedBy,    
SNPC.DeletedDate,    
 SNPC.StaffNotificationId,
 SNPC.ProcedureCodeId
 from StaffNotificationProcedures SNPC    
 INNER JOIN StaffNotifications SN ON SNPC.StaffNotificationId=SN.StaffNotificationId    
 WHERE SN.StaffNotificationId IN (SELECT StaffNotificationId from StaffNotifications where StaffId=@LoggedInUserId)    
 AND  ISNULL(SNPC.RecordDeleted,'N')= 'N'       
 AND  ISNULL(SN.RecordDeleted,'N')= 'N'
 
 select     
 SNS.StaffNotificationStaffId,    
 SNS.CreatedBy,    
SNS.CreatedDate,    
SNS.ModifiedBy,    
SNS.ModifiedDate,    
SNS.RecordDeleted,    
SNS.DeletedBy,    
SNS.DeletedDate,    
 SNS.StaffNotificationId,
 SNS.StaffId
 from StaffNotificationStaff SNS    
 INNER JOIN StaffNotifications SN ON SNS.StaffNotificationId=SN.StaffNotificationId    
 WHERE SN.StaffNotificationId IN (SELECT StaffNotificationId from StaffNotifications where StaffId=@LoggedInUserId)    
 AND  ISNULL(SNS.RecordDeleted,'N')= 'N'       
 AND  ISNULL(SN.RecordDeleted,'N')= 'N'
 
 select     
 SNL.StaffNotificationLocationId,    
 SNL.CreatedBy,    
SNL.CreatedDate,    
SNL.ModifiedBy,    
SNL.ModifiedDate,    
SNL.RecordDeleted,    
SNL.DeletedBy,    
SNL.DeletedDate,    
 SNL.StaffNotificationId,
 SNL.LocationId
 from StaffNotificationLocations SNL    
 INNER JOIN StaffNotifications SN ON SNL.StaffNotificationId=SN.StaffNotificationId    
 WHERE SN.StaffNotificationId IN (SELECT StaffNotificationId from StaffNotifications where StaffId=@LoggedInUserId)   
 AND  ISNULL(SNL.RecordDeleted,'N')= 'N'       
 AND  ISNULL(SN.RecordDeleted,'N')= 'N'

 END TRY  
                
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMMyPreferences')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH   
 RETURN  
END  