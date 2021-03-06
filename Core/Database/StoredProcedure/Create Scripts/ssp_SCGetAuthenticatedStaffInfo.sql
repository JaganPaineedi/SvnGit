/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthenticatedStaffInfo]    Script Date: 11/18/2011 16:25:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuthenticatedStaffInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAuthenticatedStaffInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuthenticatedStaffInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Wasif Butt
-- Create date: Sep 22, 2011
-- Description:	Get authenticated user information
-- History
-- May 22 2014		Pradeep		Added LastName,NonStaffUser and ClientId column for handling the Patient portal Staff user.
-- 16 Jun 2014		Pradeep A		What : Changed ClientId to TempClientId for releasing PPA.
-- 17 Feb 2015		Malathi Shiva   What : Changed the order of the display since the column number is used in the code.
-- 27 June 2017		Deej			What: Changed Administrator to SystemAdministrator in the select query. 
--									Why: SystemAdministrator is the column to determine whether the Staff is Admin or Not. -- 15 Dec 2017		Ray Stratton    What : Added Email field to the return set - Task #67 
-- Valley - Support Go Live #1252
-- 26 July 2017            K.Soujanya              Added PasswordExpirationDate SWMBH-Enhancements ,Task#1178 (Added By Pradeep which was missed while comparing with ssp_SCStaffIdentity)
-- Aug 21 2018			   Pradeep A			   Added RegisteredForMobileNotifications,SubscribedForPushNotifications,LastTFATimeStamp for Mobile #6
-- Dec 03 2018			   Pradeep A 			   Added PhoneNumber,RegisteredForSMSNotifications, and RegisteredForEmailNotifications for Mobile #6 */
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SCGetAuthenticatedStaffInfo]
    @StaffId INT ,
    @UserCode VARCHAR(50)
AS 
    BEGIN
        DECLARE @countquestions INT
        DECLARE @varOutput INT                                                
        SET @varOutput = 0      
        IF EXISTS ( SELECT  StaffId
                    FROM    Staff
                    WHERE   UserCode = @UserCode
                            AND StaffId = @StaffId
                            AND ISNULL(RecordDeleted, ''N'') <> ''Y''
                            AND Active = ''Y''
                            AND ISNULL(AccessSmartCare, ''N'') = ''Y'' ) 
            BEGIN                        
                SELECT  @countquestions = COUNT(SecurityQuestion)
                FROM    StaffSecurityQuestions
                        JOIN Staff ON Staff.StaffId = StaffSecurityQuestions.StaffId
                WHERE   UserCode = @UserCode
                        AND Staff.StaffId = @StaffId
                        AND ISNULL(StaffSecurityQuestions.RecordDeleted, ''N'') <> ''Y''
                        AND Active = ''Y''
                        AND ISNULL(Staff.AccessSmartCare, ''N'') = ''Y''                                      
                                                                     
                SELECT  S.StaffID ,
                        S.FirstName ,
                        S.RowIdentifier ,
                        ISNULL(S.SystemAdministrator, ''N'') AS Administrator ,
                        ISNULL(S.Supervisor, ''N'') AS Supervisor ,
					    @varOutput AS PasswordStatus ,
                        S.DefaultImageServerId ,
                        S.UserCode ,
						S.Email ,
                        S.LastVisit ,
                        @countquestions AS QuestionsAnswered ,
                        S.AllowRemoteAccess ,
                        S.AllowEmergencyAccess ,
                        S.EmergencyAccessRoleId,
                        S.NonStaffUser,
                        S.TempClientId  ,
                        S.PrimaryProviderId,
                        S.PrimaryInsurerId,
						S.PasswordExpirationDate,
						SP.RegisteredForMobileNotifications,
						SP.LastTFATimeStamp,
						ISNULL((SELECT TOP 1 ''Y'' FROM MobileDevices WHERE StaffId = S.StaffId AND SubscribedForPushNotifications = ''Y'' AND ISNULL(RecordDeleted,''N'') = ''N''),''N'') AS SubscribedForPushNotifications,
						S.PhoneNumber,
						SP.RegisteredForSMSNotifications,
				        SP.RegisteredForEmailNotifications
                FROM    Staff S
				LEFT JOIN StaffPreferences SP ON SP.StaffId = S.StaffId
                WHERE   S.UserCode = @UserCode
                        AND S.StaffId = @StaffId
                        AND ISNULL(S.RecordDeleted, ''N'') <> ''Y''
                        AND S.Active = ''Y''
                        AND ISNULL(S.AccessSmartCare, ''N'') = ''Y''                                          
               
                UPDATE  Staff
                SET     LastVisit = GETDATE() ,
                        ModifiedBy = @UserCode ,
                        ModifiedDate = GETDATE()
                WHERE   UserCode = @UserCode              
               
            END                         
        ELSE 
            BEGIN                  
                --Added by vishant to implement message code functionality 
                DECLARE @ErrorMessage nvarchar(max)
                select @ErrorMessage=dbo.Ssf_GetMesageByMessageCode(29,''NOTAUTHORIZEDUSER_SSP'',''Not an authorized user'')                
                SELECT  @ErrorMessage
                -- SELECT  ''Not an authorized user''                       
            END   
            
              --Checking For Errors                                                                  
        IF ( @@error != 0 ) 
            BEGIN                                                             
                RAISERROR  (   ''ssp_SCGetAuthenticatedStaffInfo: An Error Occured'',16,1)                                                                       
                RETURN                                                                  
            END                                                                           
              
    END

' 
END
GO
