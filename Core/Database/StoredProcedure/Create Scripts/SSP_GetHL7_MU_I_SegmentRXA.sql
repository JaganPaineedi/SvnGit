/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentRXA]    Script Date: 20-09-2017 14:45:41 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_I_SegmentRXA]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentRXA]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentRXA]    Script Date: 20-09-2017 14:45:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentRXA] 
	 @VendorId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ClientID INT
	,@ClientImmunizationId INT
    ,@RXASegmentRaw nvarchar(max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_I_SegmentRXA  
-- Create Date :  September-14-2017
-- Purpose : Generates RXR Segment  
-- Script :  
/*   
  Declare @RXASegmentRaw nVarchar(max)  
  EXEC SSP_GetHL7_MU_I_SegmentRXA 4,'|^~\&',127687,2,@RXASegmentRaw Output  
  Select @RXASegmentRaw   
*/
-- Created By : Varun 
-- ================================================================  
BEGIN
  BEGIN TRY
    DECLARE @SegmentName varchar(3)
    DECLARE @EventTypeCode varchar(3)
    DECLARE @RecordedDateTime varchar(24)
    DECLARE @PlannedDateTime varchar(24)
    DECLARE @SendingFacility nvarchar(227)

    DECLARE @RXASegment varchar(max)

    -- pull out encoding characters  
    DECLARE @FieldChar char
    DECLARE @CompChar char
    DECLARE @RepeatChar char
    DECLARE @EscChar char
    DECLARE @SubCompChar char
    ---Variable declare for Message
    DECLARE @SubIdCounter int
    DECLARE @AdministrationSubId int
    DECLARE @DateandTime varchar(20)
    DECLARE @VaccineNameId int
    DECLARE @VaccineName varchar(200)
    DECLARE @Amount varchar(500)
    DECLARE @ProviderInfo varchar(1000)
    DECLARE @LocationInfo varchar(500)
    DECLARE @LotNumber varchar(50)
    DECLARE @ExpirationDate varchar(20)
    DECLARE @MnnufactureInfo Varchar(500)
    DECLARE @AdministrationNotes VARCHAR(150)
    DECLARE @AdministrationChar VARCHAR(5)
    DECLARE @VaccineStatus varchar(250)
    DECLARE @STATUS VARCHAR(1)
    DECLARE @AmountHistory VARCHAR(250)
    DECLARE @StaffIDISO VARCHAR(100)
    -- END Variable declare for Message

    EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars,
                               @FieldChar OUTPUT,
                               @CompChar OUTPUT,
                               @RepeatChar OUTPUT,
                               @EscChar OUTPUT,
                               @SubCompChar OUTPUT

	SET @SegmentName = 'RXA'

	SELECT
      @SendingFacility = SendingFacility
    FROM HL7CPVendorConfigurations
    WHERE VendorId = @VendorId


    ---Setting Variable declare for Message
    SET @SubIdCounter = 0
    SET @AdministrationSubId = 1
    SET @LocationInfo = 'NIST-Clinic-1' + @SubCompChar + '1' + @SubCompChar+'ISO'
    SELECT 
      @DateandTime =RTRIM( ISNULL(CONVERT(VARCHAR(8), AdministeredDateTime, 112), '')) ,
      @VaccineNameId = VaccineNameId,
      @Amount = CASE WHEN dbo.GetGlobalCodeName(VaccineStatus) = 'No Vaccine - Client/Guardian Refused'
					THEN 
						'999' + @FieldChar + ISNULL((SELECT
						codename + @CompChar + codename+ @CompChar+ 'UCUM'
						 FROM Globalcodes
						WHERE GlobalCodeId = AdministedAmountType),'')
					ELSE
						ISNULL(CAST(AdministeredAmount AS varchar(20)),'') + @FieldChar + ISNULL((SELECT
						codename + @CompChar + codename+ @CompChar+ 'UCUM'
						 FROM Globalcodes
						WHERE GlobalCodeId = AdministedAmountType),'')
					END
			    ,
	  @AmountHistory=ISNULL(CAST(CAST(AdministeredAmount AS INT) AS varchar(20)),'') + @FieldChar +@FieldChar,
      @LotNumber=ISNULL(CAST(LotNumber AS VARCHAR(50)),''),
      @ExpirationDate=ISNULL(CONVERT(varchar(8), ExpirationDate, 112),''),
      @MnnufactureInfo=(select ISNULL(ExternalCode1,'')+@CompChar+ISNULL(CodeName,'')+@CompChar+ISNULL(ExternalCode2,'') FROM globalcodes where globalcodeid=ManufacturerId),
      @VaccineStatus=dbo.GetGlobalCodeName(VaccineStatus)
    FROM ClientImmunizations
    where ClientImmunizationId=@ClientImmunizationId 
   
    SELECT @STATUS =
    Case WHEN CI.RecordDeleted='Y' THEN 'D'
    WHEN  EXISTS (SELECT IA.ClientImmunizationId from ImmunizationAdministrationLog IA JOIN ImmunizationTransmissionLog IT ON IT.ImmunizationTransmissionLogId=IA.ImmunizationTransmissionLogId WHERE IA.ClientImmunizationId=CI.ClientImmunizationId) THEN 'U'
    ELSE 'A' END
    FROM ClientImmunizations CI WHERE  CI.ClientImmunizationId=@ClientImmunizationId  
    
    SELECT
      @VaccineName =  ISNULL(ExternalCode1, '')+ @CompChar+ Code + @CompChar + ISNULL(ExternalCode2, '')
    FROM GlobalCodes
    WHERE GlobalCodeid = @VaccineNameId
    SELECT
      @ProviderInfo = ISNULL(CAST(StaffId AS VARCHAR(20)),'') + @CompChar + ISNULL(LastName,'') + @CompChar + ISNULL(FirstName,'') + @CompChar +  'NA' + @CompChar + @CompChar + @CompChar + @CompChar + @CompChar + 'NIST-PI-1'+ @SubCompChar + '1' + @SubCompChar+'ISO'+ @CompChar + 'L' + @CompChar + @CompChar + @CompChar + 'PRN'
    FROM Staff
    WHERE staffId = (SELECT
      AdministeringProvider
    FROM ImmunizationDetails
    WHERE ClientImmunizationId = @ClientImmunizationId)
    
    
    
    
 --   SELECT @AdministrationChar =CASE WHEN EXISTS(SELECT 1 FROM ClientImmunizationHistory WHERE  ClientImmunizationId=@ClientImmunizationId) 
	--								THEN  'U'--'01' + @CompChar + 'Historical Administration' + @CompChar + 'NIP001'
	--								ELSE 
	--									 'A'
	--							END	
								
	--IF (@VaccineStatus='Historical')
	--	BEGIN
	--			SET @AdministrationNotes='01' + @CompChar + 'Historical Administration' + @CompChar + 'NIP001'
	--	END
	--ELSE
	--	BEGIN
	--		SET @AdministrationNotes='00' + @CompChar + 'New Record' + @CompChar + 'NIP001'
	--	END
	
    ---END Setting Variable declare for Message  
	IF (@VaccineStatus='Historical')
    BEGIN
		SET @AdministrationNotes='01' + @CompChar + 'Historical Administration' + @CompChar + 'NIP001'
		SET @RXASegment = ISNULL(@SegmentName,'') + @FieldChar+ CAST(@SubIdCounter AS VARCHAR(20)) + @FieldChar + ISNULL( CAST( @AdministrationSubId AS VARCHAR(20)),'') + @FieldChar + ISNULL(@DateandTime,'') + @FieldChar + @FieldChar + @VaccineName+ @FieldChar + ISNULL(@AmountHistory,'') + @FieldChar +@AdministrationNotes+ @FieldChar +@FieldChar + @FieldChar+ @FieldChar +@FieldChar + @FieldChar + @FieldChar +@FieldChar + @FieldChar + @FieldChar +@FieldChar + 'CP'+@FieldChar+@STATUS+char(13)
    
   
		--SET @RXASegment = ISNULL(@RXASegment,'') + @FieldChar + @FieldChar + @FieldChar + @FieldChar+ISNULL(@LotNumber,'')+ @FieldChar+ISNULL(CONVERT(varchar(8), @ExpirationDate, 112),'') + @FieldChar+ISNULL(CONVERT(varchar(8),@MnnufactureInfo, 112),'')+@FieldChar+@FieldChar+@FieldChar+'CP'+@FieldChar+@STATUS
	END
	ELSE
	BEGIN
		SET @AdministrationNotes='00' + @CompChar + 'New Record' + @CompChar + 'NIP001'
		DECLARE @ParentRefuse VARCHAR(250)
		DECLARE @CompleteStatus VARCHAR(20)
		IF(@VaccineStatus ='No Vaccine - Client/Guardian Refused')
		BEGIN
			SET @ParentRefuse='00^Parental decision^NIP002'
			SET @CompleteStatus='RE'
			SET @AdministrationNotes=''
		END
		ELSE
		BEGIN
			SET @ParentRefuse=''
			SET @CompleteStatus='CP'
		END
		
		SET @RXASegment = ISNULL(@SegmentName,'') + @FieldChar+ CAST(@SubIdCounter AS VARCHAR(20)) + @FieldChar + ISNULL( CAST( @AdministrationSubId AS VARCHAR(20)),'') + @FieldChar + ISNULL(@DateandTime,'') + @FieldChar + @FieldChar + @VaccineName+ @FieldChar + ISNULL(@Amount,'') + @FieldChar + @FieldChar +@AdministrationNotes+ @FieldChar + ISNULL(@ProviderInfo,'') + @FieldChar  +@CompChar + @CompChar + @CompChar + ISNULL(@LocationInfo,'')
    
   
		SET @RXASegment = ISNULL(@RXASegment,'') + @FieldChar + @FieldChar + @FieldChar + @FieldChar+ISNULL(@LotNumber,'')+ @FieldChar+ISNULL(CONVERT(varchar(8), @ExpirationDate, 112),'') + @FieldChar+ISNULL(@MnnufactureInfo,'')+@FieldChar+@ParentRefuse+@FieldChar+@FieldChar+@CompleteStatus+@FieldChar+@STATUS+char(13)
	END    
    
	
    
    SET @RXASegmentRaw = @RXASegment
  END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_I_SegmentRXA')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    INSERT INTO ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
      VALUES (@Error, NULL, NULL, 'HL7 Procedure Error', 'SmartCare', GETDATE())

    RAISERROR
    (
    @Error, -- Message text.                                                                        
    16, -- Severity.                                                                        
    1 -- State.                                                                        
    );
  END CATCH
END
GO


