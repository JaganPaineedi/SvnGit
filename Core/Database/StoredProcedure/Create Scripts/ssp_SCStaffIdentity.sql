IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_SCStaffIdentity]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCStaffIdentity] 
GO

CREATE PROCEDURE [dbo].[ssp_SCStaffIdentity] (
	@UserCode VARCHAR(50)
	,@UserPassword VARCHAR(50)
	)
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_SCStaffIdentity                */
	/* Copyright: 2005 Provider Claim Management System             */
	/* Creation Date:  27/10/2006                                    */
	/*                                                                   */
	/* Purpose: Gets StaffID,FirstName,RowIdentifier from Staff Table  */
	/*                                                                   */
	/* Input Parameters: @UserCode, @UserPassword */
	/*                                                                   */
	/* Output Parameters:                                */
	/*                                                                   */
	/* Return:   */
	/*                                                                   */
	/* Called By: chkServerLogin(string varUsername,string varPassword)   Method in MSDE Class Of DataService  in "Always Online Application"  */
	/*      */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/*   Updates:                                                          */
	/*       Date               Author					Purpose                                    */
	/*  27/10/2006				Piyush Gajrani          Created                                                 
/*  06/05/2007				Sony John				Added Recorddeleted and Active checks   */              */
	/*  Aug 26,2009				Pradeep					Added Usercode field in select statement */
	/*  02July2010				Devinder				selected total questions answered by loggedin user*/
	/*  19 August 2010			Priya					Added AllowRemoteAccess       */
	/*  29 April 2011			Rohit katoch			Added Emergency Access fields    */
	/*  01 Nov 2011				MSuma					Commented ModifiedDate by MSuma to fix ACE#226  */
	/*  10Oct2012				Shifali					Modified - Replaced Field Stafff.Administrator with Staff.SystemAdministrator*/
	/*  May 22 2014				Pradeep.A				Added LastName,NonStaffuser,ClientId */
	/*  16 Jun 2014				Pradeep A				What : Changed ClientId to TempClientId for releasing PPA. */
	/*  19th Jun 2014			Smitha Sebastian		Added LastVisit condition to check for second time login */
	/*  19th Jan 2015			Smitha Sebastian        Modified to check for first time login  */
	/*  19th Oct 2016			Chethan N				What : Added RecordDeleted check to Staff table
													Why : New Directions - Support Go Live task#473	*/
	/*  26 July 2017            K.Soujanya              Added PasswordExpirationDate SWMBH-Enhancements ,Task#1178*/
	/*  15 Dec. 2017            Ray Stratton            Added Email field to the return set - Task #67 */
	/* Aug 21 2018				Pradeep A				Added RegisteredForMobileNotifications,SubscribedForPushNotifications,LastTFATimeStamp for Mobile #6 */
	/*  Oct 10 2018             Vishnu Narayanan        Removed SubscribedForPushNotifications and changed JOIN to LEFT JOIN for fixing the issue for Non Staff User Login for Mobile #6 */
	/* Oct 11 2018				Pradeep A 				Added SubscribedForPushNotifications based on the entry in the MobileDevices entry for Mobile #6 */
	/* Dec 03 2018				Pradeep A 				Added PhoneNumber,RegisteredForSMSNotifications, and RegisteredForEmailNotifications for Mobile #6 */
	/*********************************************************************/
	DECLARE @varOutput INT;

	SET @varOutput = 0;

	DECLARE @StaffId INT;

	SET @StaffId = 0;

	DECLARE @countquestions INT;

	IF (
			SELECT PasswordExpiresNextLogin
			FROM Staff
			WHERE UserCode = @UserCode
				AND UserPassword = @UserPassword
				AND isNull(RecordDeleted, 'N') <> 'Y'
				AND Active = 'Y'
			) = 'Y'
	BEGIN
		--set @varOutPut=1 means password expires next login                                                                
		SET @varOutput = 1;
	END;

	--check for expiration date                                                                  
	IF (
			SELECT IsNull(DATEDIFF(dd, GETDATE(), PasswordExpirationDate), 0)
			FROM Staff
			WHERE UserCode = @UserCode
				AND UserPassword = @UserPassword
				AND PasswordExpiresNextLogin <> 'Y'
				AND isNull(RecordDeleted, 'N') <> 'Y'
				AND Active = 'Y'
			) < 0
	BEGIN
		-- " 2 means password is expired"                                              
		SET @varOutput = 2;
	END;

	IF EXISTS (
			SELECT StaffId
			FROM Staff
			WHERE UserCode = @UserCode
				AND UserPassword = @UserPassword
				AND isNull(RecordDeleted, 'N') <> 'Y'
				AND Active = 'Y'
			)
	BEGIN
		IF EXISTS (
				SELECT StaffId
				FROM Staff
				WHERE UserCode = @UserCode
					AND UserPassword = @UserPassword
					AND isNull(RecordDeleted, 'N') <> 'Y'
					AND Active = 'Y'
					AND isnull(AccessSmartCare, 'N') = 'Y'
				)
		BEGIN
			SELECT @countquestions = COUNT(SecurityQuestion)
			FROM StaffSecurityQuestions
			INNER JOIN Staff ON Staff.StaffId = StaffSecurityQuestions.StaffId
			WHERE UserCode = @UserCode
				AND UserPassword = @UserPassword
				AND isNull(StaffSecurityQuestions.RecordDeleted, 'N') <> 'Y'
				AND Active = 'Y'
				AND isnull(Staff.AccessSmartCare, 'N') = 'Y'
				AND ISNULL(Staff.RecordDeleted, 'N') = 'N';

			SELECT S.StaffID
				,S.FirstName
				,S.LastName
				,S.RowIdentifier
				,IsNull(S.SystemAdministrator, 'N') AS Administrator
				,@varOutput AS PasswordStatus
				,IsNull(S.Supervisor, 'N') AS Supervisor
				,S.DefaultImageServerId                                 
				,S.UserCode
				,S.LastVisit
				,@countquestions AS QuestionsAnswered
				,S.Email
				,S.AllowRemoteAccess
				,S.AllowEmergencyAccess
				,S.EmergencyAccessRoleId
				,S.NonStaffUser
				,S.TempClientId
				,S.PrimaryProviderId
				,S.PrimaryInsurerId
				,S.PasswordExpirationDate   
				,SP.RegisteredForMobileNotifications
				,SP.LastTFATimeStamp      
				,ISNULL((SELECT TOP 1 'Y' FROM MobileDevices WHERE StaffId = S.StaffId AND SubscribedForPushNotifications = 'Y' AND ISNULL(RecordDeleted,'N') = 'N'),'N') AS SubscribedForPushNotifications
				,S.PhoneNumber
				,SP.RegisteredForSMSNotifications
				,SP.RegisteredForEmailNotifications
			FROM Staff S
			LEFT JOIN StaffPreferences SP ON SP.StaffId = S.StaffId
			WHERE UserCode = @UserCode
				AND UserPassword = @UserPassword
				AND isNull(S.RecordDeleted, 'N') <> 'Y'
				AND isNull(SP.RecordDeleted, 'N') <> 'Y'
				AND S.Active = 'Y'
				AND isnull(S.AccessSmartCare, 'N') = 'Y';

			UPDATE Staff
			SET LastVisit = GETDATE()
				,ModifiedBy = @UserCode
			WHERE UserCode = @UserCode;
		END;
		ELSE
		BEGIN
			SELECT 'Not an authorized user';
		END;
	END;
	ELSE
		SELECT staffid
		FROM Staff
		WHERE 1 = 2;

	--Checking For Errors                                                                  
	IF (@@error != 0)
	BEGIN
		RAISERROR (
				'ssp_SCStaffIdentity: An Error Occured' --/* Message text*/
				,16 --/*Severity*/
				,1 --/*State*/
				);

		RETURN;
	END;
END;

