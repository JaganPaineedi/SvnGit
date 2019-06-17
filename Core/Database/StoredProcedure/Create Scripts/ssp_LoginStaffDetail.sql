IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_LoginStaffDetail]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_LoginStaffDetail] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[ssp_LoginStaffDetail] (@StaffId INT) 
AS 
  BEGIN TRY 
  /*********************************************************************/ 
  /* Stored Procedure: dbo.ssp_LoginStaffDetail                        */ 
  /* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
  /* Creation Date:  10 March 2009                                        */ 
  /*                                                                   */ 
  /* Purpose: Gets Staff Information                              */ 
  /*                                                                   */ 
  /* Input Parameters: @StaffId                    */ 
  /*                                                                   */ 
  /* Return: staff row from staff Table  */ 
  /*                                                                   */ 
  /* Called By: StaffDetail() in User.cs                                                        */
  /*                                                                   */ 
  /* Calls:                                                            */ 
  /*                                                                   */ 
  /* Data Modifications:                                               */ 
  /*                                                                   */ 
  /* Updates:                                                          */ 
  /*  Date   Author         Purpose                          */ 
  /* 10/03/2009  Loveena       Created               */ 
  /* 18th March 2009 Chandan       Modify      */ 
  /* 22-May-2009    Loveena       Modify  */ 
  /* 22-May-2009    Loveena       Modify in Ref to Task#2595 to get column EnablePrecriberSecurityQuestion */
  /* 26 Nov 2009    Pradeep       Added DefaultPrescribingQuantity field in select statement from staff table as per task#2640*/
  /* 11 Dec 2009    Loveena  Added by Loveena in ref to Task#34*/ 
  /* 15 April2010   Loveena  Added column AllowAllergyMedications in ref to Task#2983*/ 
  /* 06 May2010     Loveena  Added column EnableOtherPrescriberSelection in ref to Task#3040*/
  /* 11 Nov 2011    Kneale Alpers Added the RefillStartUseEndPlusOne to return Y  */ 
  /* 7 Dec 2012     Chuck Blaine  Changed Admin flag to look at dbo.Staff.SystemAdministrator instead of dbo.Staff.Administrator*/
  /* 9 Jan 2013     Chuck Blaine  Updated dbo.Staff.SystemAdministrator select to catch NULL values and pass 'N'*/
  /* 22 Mar 2016	Malathi Shiva	Included Staff.CanSignUsingSignaturePad column for signature pad functionality Engineering Improvement Initiatives- NBL(I): Task# 291 */ 
  /* 18 Oct 2016	Anto			Included Staff.IsEPCSEnabled,TwoFactorAuthenticationDeviceRegistrations.DeviceName and Password column for EPCS Task# 3 */ 
  /* 18 Apr 2017	Malathi Shiva	RefillStartUseEndPlusOne is returned from the SystemConfigurations.RefillStartUseEndPlusOne field rather than hard coding to 'Y' always */
      /*********************************************************************/ 
      BEGIN 
          --Added by Loveena in ref to Task#2595                    
          DECLARE @countquestions    INT, 
                  @counter           INT, 
                  @admin             CHAR(1), 
                  @Prescribe         CHAR(1), 
                  @QuestionsAnswered INT 

          SELECT @countquestions = Count(SecurityQuestion) 
          FROM   StaffSecurityQuestions 
                 JOIN Staff 
                   ON Staff.StaffId = StaffSecurityQuestions.StaffId 
          WHERE  Staff.StaffId = @StaffId 
                 AND ISNULL(StaffSecurityQuestions.RecordDeleted, 'N') <> 'Y' 
                 AND Active = 'Y' 

          SELECT @counter = NumberOfPrescriberSecurityQuestions 
          FROM   SystemConfigurations 

          SELECT @admin = Administrator 
          FROM   Staff 
          WHERE  Staff.StaffId = @StaffId 

          SELECT @Prescribe = Prescriber 
          FROM   Staff 
          WHERE  Staff.StaffId = @StaffId 

          --if (@admin != 'Y' and @Prescribe = 'Y' and @countquestions < @counter  )             
          --if (@Prescribe = 'Y' and @countquestions < @counter  )         
          --Changes by Loveena Ref Task #2700             
          DECLARE @StaffPermissionNewOrder INT 
          DECLARE @StaffPermissionRefillChangeOrder INT 

          SELECT @StaffPermissionNewOrder = ISNULL(Count(*), 0) 
          FROM   StaffPermissions 
                 JOIN Staff 
                   ON Staff.StaffId = StaffPermissions.StaffId 
                      AND Staff.StaffId = @StaffId 
          WHERE  ActionId = 10024 

          SELECT @StaffPermissionRefillChangeOrder = ISNULL(Count(*), 0) 
          FROM   StaffPermissions 
                 JOIN Staff 
                   ON Staff.StaffId = StaffPermissions.StaffId 
                      AND Staff.StaffId = @StaffId 
          WHERE  ActionId = 10028 
                  OR ActionId = 10040 

          --Ref Task #2700 by Sonia             
          IF ( ( @Prescribe = 'Y' 
                  OR ( @StaffPermissionNewOrder > 0 
                       AND @StaffPermissionRefillChangeOrder > 0 ) ) 
               AND @countquestions < @counter ) 
            BEGIN 
                SET @QuestionsAnswered = 1 
            END 
          ELSE 
            BEGIN 
                SET @QuestionsAnswered = 0 
            END 

          SELECT [Staff].[StaffId], 
                 [UserCode], 
                 [LastName], 
                 [FirstName], 
                 [MiddleName], 
                 [Degree], 
                 [EHRUser], 
                 ISNULL([Staff].[MedicationDaysDefault], 0) AS 
                 MedicationDaysDefault, 
                 DefaultPrescribingLocation                 AS 
                 StaffPrescribingLocationId, 
                 staff.RowIdentifier, 
                 ISNULL(SystemAdministrator, 'N')           AS Administrator, 
                 UserPassword, 
                 [Prescriber], 
                 EnablePrescriberSecurityQuestion, 
                 PharmacyCoverLetters, 
                 EnablePrescriptionReview, 
                 LastPrescriptionReviewTime, 
                 NumberOfPrescriberSecurityQuestions, 
                 DefaultPrescribingQuantity, 
                 VerbalOrdersRequireApproval, 
                 AllowRePrintFax, 
                 GC.CodeName                                AS DegreeName, 
                 AllowAllergyMedications, 
                 EnableOtherPrescriberSelection, 
                 @QuestionsAnswered                         AS QuestionsAnswered 
                 , 
                 ChangeOrderStartDateUseToday, 
                 RefillStartUseEndPlusOne                                       AS 
                 RefillStartUseEndPlusOne 
                 ,ISNULL(CanSignUsingSignaturePad,'N') AS CanSignUsingSignaturePad
                 ,IsEPCSEnabled
                 ,TF.DevicePassword as DevicePassword   
                 ,TF.DeviceEmail as DeviceEmail   
          FROM   Staff 
                 CROSS JOIN SystemConfigurations SC 
                 LEFT JOIN GlobalCodes GC 
                        ON GC.GlobalCodeId = Staff.Degree 
				 LEFT JOIN TwoFactorAuthenticationDeviceRegistrations TF     
                        ON TF.StaffId = Staff.StaffId                              
          WHERE  Staff.StaffId = @StaffId 
                 AND ISNULL(Staff.RecordDeleted, 'N') <> 'Y' 
      END 
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                   + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                   + '*****' 
                   + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                   'ssp_LoginStaffDetail') 
                   + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                   + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                   + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR ( @Error, 
                  -- Message text.                                                             
                  16, 
                  -- Severity.                                                             
                  1 
      -- State.                                                             
      ); 
  END CATCH 

GO 