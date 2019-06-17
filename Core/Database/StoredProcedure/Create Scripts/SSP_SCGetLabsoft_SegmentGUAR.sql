/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentGUAR]    Script Date: 04/04/2017 03:13:13 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentGUAR]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentGUAR]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentGUAR]    Script Date: 04/04/2017 03:13:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentGUAR] @ClientId INT
	,@EncodingChars NVARCHAR(5)
	,@GUARSegmentRaw NVARCHAR(Max) OUTPUT
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentGUAR  
-- Create Date : Sep 09 2015 
-- Purpose : Get GUAR Segment for Labsoft  
-- Created By : Gautam  
	declare @GUARSegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentGUAR 45, '|^~\&' ,@GUARSegmentRaw Output
	select @GUARSegmentRaw
-- ================================================================  
-- History --  
-- 1/19/2017	Pradeep		Modified to Handle GUAR segment based on the ClientIsSubscriber field from ClientCoverageplans
-- ================================================================  
*/
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(4) = 'GUAR'
		DECLARE @GuarantorName VARCHAR(48)
		DECLARE @GuarantorBirthDate VARCHAR(26)
		DECLARE @GuarantorGender CHAR(1)
		DECLARE @GuarantorAddress VARCHAR(106)
		DECLARE @GuarantorSocSecNo NVARCHAR(75)
		DECLARE @GuarantorCity VARCHAR(50)
		DECLARE @GUARSegment VARCHAR(500)
		DECLARE @GuarantorState VARCHAR(2)
		DECLARE @GuarantorZip VARCHAR(15)
		DECLARE @HomePhone VARCHAR(30)
		DECLARE @WorkPhone VARCHAR(30)
		DECLARE @Relationship VARCHAR(30)
		DECLARE @ClientIsSubscriber CHAR(1)
		DECLARE @SubScriberContactId INT
		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		--GET COVERAGE PLAN DETAILS FOR GUARANTOR DETAILS
		SELECT TOP 1 @SubScriberContactId = CCP.SubscriberContactId
			,@ClientIsSubscriber = ISNULL(CCP.ClientIsSubscriber, 'N')
		FROM ClientCoverageHistory CCH
		JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
		JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		WHERE CCP.ClientId = @ClientId
			AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
			AND (
				cch.EndDate IS NULL
				OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
				)
			AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
			AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
		ORDER BY CCH.COBOrder

		IF @@ROWCOUNT = 0 -- SINCE THERE ARE NO COVERAGE PLANS, CHECK IF THERE IS A CLIENT / CONTACT WHO IS FINANCIALLY RESPONSIBLE
		BEGIN
			SELECT TOP 1 @SubScriberContactId = C.ClientContactId
			FROM ClientContacts C
			WHERE C.ClientId = @ClientId
				AND C.FinanciallyResponsible = 'Y'
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
		END

		IF @SubScriberContactId IS NULL
		BEGIN
			SELECT TOP 1 @GuarantorName = dbo.GetPatientNameForLabSoft(@ClientId, @EncodingChars)
				,@GuarantorBirthDate = ISNULL(CONVERT(VARCHAR(10), CL.DOB, 112), '')
				,@GuarantorGender = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CL.Sex, ''), @EncodingChars)
				,@GuarantorAddress = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.Address, ''), @EncodingChars)
				,@GuarantorSocSecNo = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CL.SSN, ''), @EncodingChars)
				,@GuarantorCity = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.City, ''), @EncodingChars)
				,@GuarantorState = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.STATE, ''), @EncodingChars)
				,@GuarantorZip = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.Zip, ''), @EncodingChars)
				,@Relationship = dbo.GetParseLabSoft_OUTBOUND_XFORM('SELF', @EncodingChars)
				,@HomePhone = CASE 
					WHEN CP.PhoneType = 30
						THEN CP.PhoneNumber
					ELSE ''
					END
				,@WorkPhone = CASE 
					WHEN CP.PhoneType = 31
						THEN CP.PhoneNumber
					ELSE ''
					END
			FROM Clients CL
			JOIN ClientAddresses CA ON CL.ClientId = CA.ClientId
				AND CA.AddressType = 90 --Home
				AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientPhones CP ON CL.ClientId = CP.ClientId
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			WHERE CL.ClientId = @ClientId
				AND ISNULL(CL.RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			SELECT TOP 1 @GuarantorName = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CC.LastName, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CC.FirstName, ''), @EncodingChars)
				,@GuarantorBirthDate = ISNULL(CONVERT(VARCHAR(10), CC.DOB, 112), '')
				,@GuarantorGender = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CC.Sex, ''), @EncodingChars)
				,@GuarantorAddress = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.Address, ''), @EncodingChars)
				,@GuarantorSocSecNo = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CC.SSN, ''), @EncodingChars)
				,@GuarantorCity = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.City, ''), @EncodingChars)
				,@GuarantorState = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.STATE, ''), @EncodingChars)
				,@GuarantorZip = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.Zip, ''), @EncodingChars)
				,@Relationship = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(gc.CodeName, ''), @EncodingChars)
				,@HomePhone = CASE 
					WHEN CCN.PhoneType = 30
						THEN CCN.PhoneNumber
					ELSE ''
					END
				,@WorkPhone = CASE 
					WHEN CCN.PhoneType = 31
						THEN CCN.PhoneNumber
					ELSE ''
					END
			FROM ClientContacts CC
			JOIN ClientContactAddresses CCA ON CCA.ClientContactId = CC.ClientContactId
			JOIN GlobalCodes GC ON GC.GlobalCodeId = CC.Relationship
			LEFT JOIN ClientContactPhones CCN ON CCN.ClientContactId = CC.ClientContactId
				AND ISNULL(CCN.RecordDeleted, 'N') = 'N'
			WHERE CC.ClientContactId = @SubScriberContactId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
		END

		IF ISNULL(@GuarantorName, '') = ''
			OR ISNULL(@GuarantorGender, '') = ''
			OR ISNULL(@GuarantorBirthDate, '') = ''
			OR ISNULL(@GuarantorAddress, '') = ''
			OR ISNULL(@GuarantorCity, '') = ''
			OR ISNULL(@GuarantorState, '') = ''
			OR ISNULL(@GuarantorZip, '') = ''
			OR ISNULL(@Relationship, '') = ''
		BEGIN
			SET @GUARSegmentRaw = NULL
		END
		ELSE
		BEGIN
			SET @GuarantorState = CASE 
					WHEN @GuarantorState IS NOT NULL
						AND @GuarantorState <> ''
						THEN substring(@GuarantorState, 1, 2)
					ELSE ''
					END
			SET @GUARSegment = @SegmentName + @FieldChar + @GuarantorName + @FieldChar + @FieldChar + @GuarantorGender + @FieldChar + @GuarantorBirthDate + @FieldChar + @GuarantorSocSecNo + @FieldChar + @GuarantorAddress + @FieldChar + @GuarantorCity + @FieldChar + @GuarantorState + 
				@FieldChar + @GuarantorZip + @FieldChar + @HomePhone + @FieldChar + @WorkPhone + @FieldChar + @Relationship
			SET @GUARSegmentRaw = @GUARSegment
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetLabsoft_SegmentGUAR') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY(
				)) + '*****' + Convert(VARCHAR, ERROR_STATE())

		INSERT INTO ErrorLog (
			ErrorMessage
			,VerboseInfo
			,DataSetInfo
			,ErrorType
			,CreatedBy
			,CreatedDate
			)
		VALUES (
			@Error
			,NULL
			,NULL
			,'Labsoft Procedure Error'
			,'SmartCare'
			,GetDate()
			)

		RAISERROR (
				@Error
				,-- Message text.                                                                      
				16
				,-- Severity.                                                                      
				1 -- State.                                                                      
				);
	END CATCH
END
GO


