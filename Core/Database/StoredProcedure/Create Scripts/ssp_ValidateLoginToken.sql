IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_ValidateLoginToken]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_ValidateLoginToken] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER OFF 

GO 

CREATE PROCEDURE [dbo].[ssp_ValidateLoginToken] (@UserGuid CHAR(36)) 
AS 
  BEGIN TRY 
  /*********************************************************************/ 
  /* Stored Procedure: dbo.ssp_ValidateLoginToken                      */ 
  /* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
  /* Creation Date:  10 nov 2007                                       */ 
  /*                                                                   */ 
  /* Purpose: Validate a token request                                 */ 
  /*                                                                   */ 
  /* Input Parameters: @UserGuid           */ 
  /*                                                                   */ 
  /* Return: Staff row from Staff Table         */ 
  /*                                                                   */ 
  /* Called By:                                                        */ 
  /*                                                                   */ 
  /* Calls:                                                            */ 
  /*                                                                   */ 
  /* Data Modifications:                                               */ 
  /*                                                                   */ 
  /* Updates:                                                          */ 
  /*  Date        Author         Purpose         */ 
  /* 11/10/2007    Jatinder Singh       Created       */ 
  /* 05/12/2008    Rohit Verma. [DefaultPrescribingLocation as StaffPrescribingLocationId] field added */
  /* 26 Nov 2009   Pradeep       Added DefaultPrescribingQuantity field in select from Staff table as per task#2640*/
  /* 15Aprl2010    Loveena    Added in ref to Task#2983    */ 
  /* 06 May2010    Loveena    Added column EnableOtherPrescriberSelection in ref to Task#3040*/
  /* 22 Mar 2016	Malathi Shiva	Included Staff.CanSignUsingSignaturePad column for signature pad functionality Engineering Improvement Initiatives- NBL(I): Task# 291 */ 
   /*03/10/2017       Pranay         Included  ,IsEPCSEnabled,DevicePassword,DeviceEmail,DeviceName   in ref to   Task#1095.1 Heartland     */
 /*********************************************************************/ 
     DECLARE @staffid AS INT 

      SELECT @staffid = staffid 
      FROM   ValidateLogins 
      WHERE  UserGUID = @UserGuid 

      IF @staffId > 0 
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

      BEGIN 
          SELECT Staff.StaffId
                 ,[UserCode] 
                 ,[LastName] 
                 ,[FirstName] 
                 ,[MiddleName] 
                 ,[Degree] 
                 ,[EHRUser] 
                 ,ISNULL([Staff].[MedicationDaysDefault], 0) AS 
                  MedicationDaysDefault 
                 ,DefaultPrescribingLocation                 AS 
                  StaffPrescribingLocationId 
                 ,Staff.RowIdentifier 
                 ,ISNULL(SystemAdministrator, 'N')           AS Administrator 
                 ,UserPassword 
                 ,[Prescriber] 
                 ,EnablePrescriberSecurityQuestion 
                 ,PharmacyCoverLetters 
                 ,EnablePrescriptionReview 
                 ,LastPrescriptionReviewTime 
                 ,NumberOfPrescriberSecurityQuestions 
                 ,DefaultPrescribingQuantity 
                 ,VerbalOrdersRequireApproval 
                 ,AllowRePrintFax 
                 ,GC.CodeName                                AS DegreeName 
                 ,AllowAllergyMedications 
                 ,EnableOtherPrescriberSelection 
                 ,@QuestionsAnswered                         AS 
                  QuestionsAnswered 
                 ,ChangeOrderStartDateUseToday 
                 ,SC.RefillStartUseEndPlusOne                AS 
                  RefillStartUseEndPlusOne 
                  ,ISNULL(CanSignUsingSignaturePad,'N')               AS 
                  CanSignUsingSignaturePad 
				    ,IsEPCSEnabled
                 ,TF.DevicePassword as DevicePassword   
                 ,TF.DeviceEmail as DeviceEmail   
                 ,TF.DeviceName as DeviceName   
          FROM   Staff 
                 CROSS JOIN SystemConfigurations SC 
                 LEFT JOIN GlobalCodes GC 
                 ON GC.GlobalCodeId = Staff.Degree 
				LEFT JOIN TwoFactorAuthenticationDeviceRegistrations TF     --Task#1095.1 Harbor
                ON TF.StaffId = Staff.StaffId   
                WHERE Staff.StaffId = @StaffId 
                 AND ISNULL(Staff.RecordDeleted, 'N') <> 'Y' 
      --Delete from ValidateLogins where UserGUID=@UserGuid                            
      --select CopyrightInfo from  SystemConfigurations    Comment as per task 2378- 1.7.1 - Copyright info                        
      END 
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                   + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                   + '*****' 
                   + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                   'ssp_ValidateLoginToken') 
                   + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                   + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                   + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR ( @Error, 
                  -- Message text.                                             
                  16,-- Severity.                                             
                  1 -- State.                                             
      ); 
  END CATCH 

GO 