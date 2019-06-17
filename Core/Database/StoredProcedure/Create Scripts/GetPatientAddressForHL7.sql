/****** Object:  UserDefinedFunction [dbo].[GetPatientAddressForHL7]    Script Date: 02/21/2017 18:23:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPatientAddressForHL7]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPatientAddressForHL7]
GO

/****** Object:  UserDefinedFunction [dbo].[GetPatientAddressForHL7]    Script Date: 02/21/2017 18:23:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetPatientAddressForHL7] (
	@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	)
RETURNS NVARCHAR(250)

/*********************************************************************/
/* Stored Procedure:[[GetPatientAddressForHL7]]                       */
/* Creation Date:8/12/2016                                            */
/*                                                                    */
/* Purpose: To Retrieve client Address			                      */
/*                                                                    */
/* Created By:Hemant Kumar                                            */
/*                                                                    */
/*   Updates:                                                         */
/*     Date              Author                  Purpose            */
/* 8/12/2016			Shankha					 Bradford - Support Go Live# 123*/
/* 2/21/2017			Shankha					 Key Point - Support Go Live #365*/
/* 4/10/2017			Shankha					 Bradford - Support Go Live  #387*/
/*********************************************************************/
BEGIN
	-- pull hl7 esc chars 
	DECLARE @FieldChar CHAR
	DECLARE @CompChar CHAR
	DECLARE @RepeatChar CHAR
	DECLARE @EscChar CHAR
	DECLARE @SubCompChar CHAR
	DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)

	SET @FieldChar = SUBSTRING(@HL7EncodingChars, 1, 1)
	SET @CompChar = SUBSTRING(@HL7EncodingChars, 2, 1)
	SET @RepeatChar = SUBSTRING(@HL7EncodingChars, 3, 1)
	SET @EscChar = SUBSTRING(@HL7EncodingChars, 4, 1)
	SET @SubCompChar = SUBSTRING(@HL7EncodingChars, 5, 1)

	DECLARE @PatientAddress NVARCHAR(250)

	SELECT @PatientAddress = dbo.HL7_OUTBOUND_XFORM(ISNULL(REPLACE(CA.Address, CHAR(10),' '), ''), @HL7EncodingChars) + '^^' + dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.City, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.STATE, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.Zip, ''), @HL7EncodingChars)
	FROM ClientAddresses CA
	WHERE CA.ClientId = @ClientId
		AND CA.AddressType = 90 --Home

	--RETURN ISNULL(@PatientAddress ,'')
	--RETURN ISNULL(REPLACE(@PatientAddress, CHAR(13) + CHAR(10), ' '), '')
	RETURN ISNULL(REPLACE(REPLACE(@PatientAddress,CHAR(13)+CHAR(10), ' '),CHAR(10), ' '), '')
END

GO


