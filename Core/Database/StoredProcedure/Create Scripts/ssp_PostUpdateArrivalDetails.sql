
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateArrivalDetails]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_PostUpdateArrivalDetails]
GO

CREATE PROCEDURE [dbo].[ssp_PostUpdateArrivalDetails]
    @ScreenKeyId INT ,
    @StaffId INT ,
    @CurrentUser VARCHAR(30) ,
    @CustomParameters XML  
  
/************************************************************************************************                          
**  File:                                             
**  Name: ssp_PostUpdateArrivalDetails                                            
**  Desc: This storeProcedure will executed on post update of Arrival Details   
**  
**  Parameters:   
**  Input   @ScreenKeyId INT,  
 @StaffId INT,  
 @CurrentUser VARCHAR(30),  
 @CustomParameters XML   
**  Output     ----------       -----------   
**    
**  Auth:  Varun  
**  Date:  April 18, 2017  

****************************************************************************************************************************************************************/
AS
    BEGIN  
	DECLARE @ClientId INT
	DECLARE @ClientAddressLine1 VARCHAR(500)
	DECLARE @ClientAddressLine2 VARCHAR(250)
	DECLARE @ClientCity VARCHAR(100)
	DECLARE @ClientState VARCHAR(100)
	DECLARE @ClientZip VARCHAR(50)
	DECLARE @ClientPhone VARCHAR(50)

	Select @ClientId = ClientId from TriageArrivalDetails where TriageArrivalDetailId=@ScreenKeyId

	IF @ClientId IS NOT NULL
	BEGIN
		SELECT @ClientAddressLine1= AddressLine1,
			   @ClientAddressLine2= AddressLine2,
			   @ClientCity=City,
			   @ClientState=State,
			   @ClientZip=Zip,
			   @ClientPhone=Phone
		from TriageArrivalDetails where TriageArrivalDetailId=@ScreenKeyId

		SET @ClientAddressLine1=CASE ISNULL(@ClientAddressLine2,'') WHEN '' THEN @ClientAddressLine1 ELSE @ClientAddressLine1 + CHAR(13) + CHAR(10) END
		SELECT @ClientPhone=Phone from TriageArrivalDetails where TriageArrivalDetailId=@ScreenKeyId 
		IF EXISTS (
		SELECT ClientAddressId
		FROM ClientAddresses
		WHERE ClientId = @ClientId
			AND AddressType = 90
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
		BEGIN
			UPDATE ClientAddresses
			SET Address = @ClientAddressLine1 + ISNULL(@ClientAddressLine2, '')
				,City = @ClientCity
				,STATE = @ClientState
				,Zip = @ClientZip
				,Display = @ClientAddressLine1 + ISNULL(@ClientAddressLine2, '') + ISNULL(@ClientCity, '') + ' ' + ISNULL(@ClientState, '') + ' ' + ISNULL(@ClientZip, '')
			WHERE ClientId = @ClientId
				AND AddressType = 90
		END
		ELSE
			INSERT INTO ClientAddresses (
				ClientId
				,AddressType
				,Address
				,City
				,STATE
				,Zip
				,Display
				)
			VALUES (
				@ClientId
				,90
				,@ClientAddressLine1 + ISNULL(@ClientAddressLine2, '')
				,@ClientCity
				,@ClientState
				,@ClientZip
				,@ClientAddressLine1 + ISNULL(@ClientAddressLine2, '') + CHAR(13) + CHAR(10) + ISNULL(@ClientCity, '') + ' ' + ISNULL(@ClientState, '') + ' ' + ISNULL(@ClientZip, '')
				)
		IF EXISTS (
		SELECT ClientPhoneId
		FROM ClientPhones
		WHERE ClientId = @ClientId
			AND PhoneType = 30
			AND ISNULL(RecordDeleted, 'N') = 'N'
		) AND @ClientPhone IS NOT NULL
		BEGIN
			UPDATE ClientPhones
			SET PhoneNumber = @ClientPhone,
			PhoneNumberText = Replace(Replace(Replace(Replace(@ClientPhone,'-',''),'(',''),')',''),' ','')
			WHERE ClientId = @ClientId
				AND PhoneType = 30
		END
		ELSE IF @ClientPhone IS NOT NULL
		BEGIN
		INSERT INTO ClientPhones
		(
			ClientId,
			PhoneType,
			PhoneNumber,
			PhoneNumberText
		)
		VALUES
		(
			@ClientId,
			30,
			@ClientPhone,
			Replace(Replace(Replace(Replace(@ClientPhone,'-',''),'(',''),')',''),' ','')
		)
		END
	END
   END
GO



