IF OBJECT_ID('ssp_ChangePassword','P') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_ChangePassword]
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE  Procedure [dbo].[ssp_ChangePassword]
	 @UserCode VARCHAR(30)
	,@UserPassword VARCHAR(100)
	,@PasswordExpiresNextLogin VARCHAR(1)
AS

/******************************************************************************
**		File: dbo.ssp_ChangePassword.prc
**		Name: dbo.ssp_ChangePassword.prc
**		Desc: This SP update the newely assigned password from the Change password window
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------						-----------
**
**		Auth: Yogesh
**		Date: 05-Jul-06
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:			User:				Description:
**		--------		--------			-------------------------------------------
**		02/17/2011		dharvey				Added StaffSecurityQuestion reset
**		FEB-13-2015		dharvey				Set default Reset @Months value to NULL
**		Dec-21-2016		Shivanand		    Set PasswordExpirationDate when @PasswordExpiresNextLogin = 'Y'
                                            for AspenPointe - Support Go Live #70
**      Dec-27-2016     Lakshmi kanth       What: Do not reset security questions upon password expiray
											Why:  Woods - Support Go Live #404                                  
*******************************************************************************/
SELECT @PasswordExpiresNextLogin =  PasswordExpiresNextLogin 
FROM 
	STAFF 
WHERE 
	UserCode=@UserCode 


DECLARE @PasswordExpires INT
DECLARE @Code VARCHAR(30)
DECLARE @PasswordExpirationDate DATETIME
DECLARE @DonotExpiraySecurityQuestions CHAR(1)

SELECT 
      @PasswordExpires=PasswordExpires    
     ,@PasswordExpirationDate=PasswordExpirationDate
FROM 
	STAFF 
WHERE 
	UserCode=@UserCode AND PasswordExpires IS NOT NULL

--Get Code Name for expiration date
IF @PasswordExpires IS NOT NULL 
BEGIN
	SELECT @Code=CodeName FROM GlobalCodes WHERE GlobalCodeId=@PasswordExpires
END

DECLARE @Months INT	-- Set months to increment
	SET @Months = CASE @Code
		WHEN 'Every Month' THEN 1
		WHEN 'Every 3 Months' THEN 3
		WHEN 'Every 6 Months' THEN 6
		WHEN 'Every Year' THEN 12
		--ELSE 0
		ELSE NULL
	END

IF @PasswordExpiresNextLogin = 'Y'	--Update user password and set PasswordExpiresNextLogin to 'N' and also update Expiration date if required
BEGIN
	UPDATE Staff
		SET 
		 UserPassword=@UserPassword
		,PasswordExpiresNextLogin = 'N'
		,ModifiedDate = GetDate()
		,ModifiedBy = @UserCode
		,PasswordExpirationDate = DATEADD(MONTH,@Months,GetDate())--Shivanand
	WHERE
		UserCode=@UserCode	
	
	IF @PasswordExpirationDate < GetDate()
	--BEGIN
		UPDATE Staff
		SET 
		 PasswordExpirationDate = DATEADD(MONTH,@Months,GetDate())			
		WHERE
		UserCode=@UserCode
	--END		
END	
ELSE	-- Just update expiration date
BEGIN	
	UPDATE Staff
		SET 
		 UserPassword=@UserPassword
		,PasswordExpirationDate = DATEADD(MONTH,@Months,GetDate())	
		,ModifiedDate = GetDate()
		,ModifiedBy = UserCode
	WHERE
		UserCode=@UserCode
END

--
-- Reset Staff Security Questions each time the password is reset
--
DECLARE @StaffId int
SELECT @StaffId = StaffId
	FROM Staff 
	WHERE UserCode = @UserCode

--Added by Lakshmi 27/12/2016 Do not reset security questions up on password expiray
SELECT @DonotExpiraySecurityQuestions=Value From SystemConfigurationKeys where [key]='DONOTRESETSECURITYQUESTIONSUPONPASSWORDEXPIRY' AND ISNULL(RecordDeleted,'N')='N'

IF(ISNULL(@DonotExpiraySecurityQuestions,'N')='N')
BEGIN
DELETE From StaffSecurityQuestions  
WHERE StaffId = @StaffId  
END
  
/*

IF @PasswordExpiresNextLogin <> 'Y' --Update Expiration date if PasswordExpiresNextLogin is 'N'
	BEGIN
	--Set Months to be Added for new Expiration date
	DECLARE @Months INT
	SET @Months = CASE @Code
	WHEN 'Every Month' THEN 1
	WHEN 'Every 3 Months' THEN 3
	WHEN 'Every 6 Months' THEN 6
	WHEN 'Every Year' THEN 12
	ELSE 0
	END

	--UPDATE new password and expiration date
	UPDATE Staff
		SET 
		 UserPassword=@UserPassword
		,PasswordExpirationDate = DATEADD(MONTH,@Months,GetDate())	
		,ModifiedDate = GetDate()
		,ModifiedBy = UserCode
	WHERE
		UserCode=@UserCode	
	END
ELSE
	BEGIN
	UPDATE Staff
		SET 
		 UserPassword=@UserPassword
		,PasswordExpiresNextLogin = 'N'
		,ModifiedDate = GetDate()
		,ModifiedBy = @UserCode
	WHERE
		UserCode=@UserCode	
	
END	*/
GO


