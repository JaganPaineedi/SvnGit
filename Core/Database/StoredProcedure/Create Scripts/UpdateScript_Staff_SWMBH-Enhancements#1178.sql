/*********************************************************************/
--  Created By	:	K.Soujanya
--  Dated		:	26/July/2017
--  Purpose		:	To update PasswordExpire,PasswordExpiresNextLogin,PasswordExpirationDate 
--  What/Why	:	SWMBH-Enhancements,Task#1178

/*********************************************************************/

IF EXISTS (
		SELECT Value
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'SETGLOBALCODEVALUEFORPASSWORDEXPIRY' AND ISNULL(RecordDeleted,'N')='N'
		)
	BEGIN
	 DECLARE @Months INT	-- Set months to increment
	 DECLARE @Value INT
	 SELECT @Value=(SELECT Value FROM SystemConfigurationKeys WHERE [KEY] = 'SETGLOBALCODEVALUEFORPASSWORDEXPIRY' AND ISNULL(RecordDeleted,'N')='N')
	 SET @Months = CASE @Value
		WHEN '2602' THEN 1
		WHEN '2603' THEN 3
		WHEN '2604' THEN 6
		WHEN '2605' THEN 12
		ELSE NULL
	END
	
		IF EXISTS (SELECT 1 FROM STAFF WHERE  ISNULL(RecordDeleted,'N')='N')
		 BEGIN
		  UPDATE Staff SET PasswordExpiresNextLogin='N',PasswordExpirationDate = DATEADD(MONTH,@Months,GetDate()), PasswordExpires=@Value WHERE ISNULL(RecordDeleted,'N')='N'		  
	     END
    END
GO


