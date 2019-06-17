/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentRXR]    Script Date: 06/10/2016 01:33:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_I_SegmentRXR]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentRXR]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentRXR]    Script Date: 06/10/2016 01:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentRXR] 
	 @VendorId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ClientID INT
	,@ClientImmunizationId INT
    ,@RXRSegmentRaw nvarchar(max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_I_SegmentRXR  
-- Create Date :  September-14-2017
-- Purpose : Generates RXR Segment  
-- Script :  
/*   
  Declare @RXRSegmentRaw nVarchar(max)  
  EXEC SSP_GetHL7_MU_I_SegmentRXR 4,'|^~\&',127687,2,@RXRSegmentRaw Output  
  Select @RXRSegmentRaw   
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

    DECLARE @RXRSegment varchar(max)
	DECLARE @OBXSegment varchar(max)

    -- pull out encoding characters  
    DECLARE @FieldChar char
    DECLARE @CompChar char
    DECLARE @RepeatChar char
    DECLARE @EscChar char
    DECLARE @SubCompChar char
    ---Variable declare for Message
    DECLARE @RouteInfo NVARCHAR(500)=''
    DECLARE @SiteInfo NVARCHAR(500)=''
	DECLARE @Route INT
	DECLARE @Site INT
	
    -- END Variable declare for Message

    EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars,
                               @FieldChar OUTPUT,
                               @CompChar OUTPUT,
                               @RepeatChar OUTPUT,
                               @EscChar OUTPUT,
                               @SubCompChar OUTPUT


    SET @SegmentName = 'RXR'

	SELECT
      @SendingFacility = SendingFacility
    FROM HL7CPVendorConfigurations
    WHERE VendorId = @VendorId

	SELECT @Route=[Route],@Site=AdministrationSite From ClientImmunizations WHERE ClientImmunizationId=@ClientImmunizationId
   
    IF(@Route iS NOT NULL)
		SELECT @RouteInfo = ISNULL(ExternalCode1,'')+@CompChar+CodeName+@CompChar+'NCIT' From Globalcodes where Globalcodeid = @Route
	IF(@Site iS NOT NULL)
	  SELECT @SiteInfo= ISNULL(ExternalCode1,'')+@CompChar+CodeName+@CompChar+'HL70163' From Globalcodes where Globalcodeid = @Site

    SET @RXRSegment = @SegmentName + @FieldChar + @RouteInfo + @FieldChar + @SiteInfo + CHAR(13)
	SET @OBXSegment=''
	
    EXEC SSP_GetHL7_MU_I_SegmentOBX @VendorId 
			,@HL7EncodingChars
			,@ClientID 
			,@ClientImmunizationId 
			,@OBXSegment OUTPUT

    SET @RXRSegmentRaw = @RXRSegment + @OBXSegment
  END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_I_SegmentRXR')
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