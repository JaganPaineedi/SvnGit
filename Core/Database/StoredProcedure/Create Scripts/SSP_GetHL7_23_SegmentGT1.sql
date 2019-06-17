/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_23_SegmentGT1]    Script Date: 08-05-2018 13:03:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_23_SegmentGT1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_23_SegmentGT1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_23_SegmentGT1]    Script Date: 08-05-2018 13:03:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_23_SegmentGT1] @VENDORID INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@GT1SegmentRaw NVARCHAR(max) OUTPUT
AS
--==========================================  
/*  
Declare @GT1SegmentRaw nvarchar(max)  
EXEC [SSP_GetHL7_23_SegmentGT1] 8,48232,'|^~\&',@GT1SegmentRaw Output  
Select @GT1SegmentRaw  
*/
-- ================================================================
/*  Date            Author      Purpose								
	Feb 14 2019	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
-- ================================================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(4)= 'GT1'
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
		DECLARE @SetId INT=1
		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
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
				AND isnull(C.FinanciallyResponsible,'N') = 'Y'
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
		END

		IF @SubScriberContactId IS NULL
		BEGIN
			SELECT TOP 1 @GuarantorName = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.LastName, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.FirstName, ''), @HL7EncodingChars) + CASE 
								WHEN CL.MiddleName IS NOT NULL
									THEN @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.MiddleName, ''), @HL7EncodingChars) else '' end
				,@GuarantorBirthDate = ISNULL(CONVERT(VARCHAR(10), CL.DOB, 112), '')
				,@GuarantorGender = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.Sex, ''), @HL7EncodingChars) 
				,@GuarantorAddress = dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.Address, ''), @HL7EncodingChars) 
				,@GuarantorSocSecNo = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.SSN, ''), @HL7EncodingChars) 
				,@GuarantorCity = dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.City, ''), @HL7EncodingChars) 
				,@GuarantorState = dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.STATE, ''), @HL7EncodingChars) 
				,@GuarantorZip = dbo.HL7_OUTBOUND_XFORM(ISNULL(CA.Zip, ''), @HL7EncodingChars) 
				,@Relationship = dbo.HL7_OUTBOUND_XFORM(ISNULL('SELF', ''), @HL7EncodingChars) 
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
			LEFT JOIN ClientAddresses CA ON CL.ClientId = CA.ClientId
				AND CA.AddressType = 90 --Home
				AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientPhones CP ON CL.ClientId = CP.ClientId
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			WHERE CL.ClientId = @ClientId
				AND ISNULL(CL.RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			SELECT TOP 1 @GuarantorName = dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.LastName, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.FirstName, ''), @HL7EncodingChars) + CASE 
								WHEN CC.MiddleName IS NOT NULL
									THEN @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.MiddleName, ''), @HL7EncodingChars) else '' end
				,@GuarantorBirthDate = ISNULL(CONVERT(VARCHAR(10), CC.DOB, 112), '')
				,@GuarantorGender = dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.Sex, ''), @HL7EncodingChars) 
				,@GuarantorAddress = dbo.HL7_OUTBOUND_XFORM(ISNULL(CCA.Address, ''), @HL7EncodingChars) 
				,@GuarantorSocSecNo = dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.SSN, ''), @HL7EncodingChars) 
				,@GuarantorCity = dbo.HL7_OUTBOUND_XFORM(ISNULL(CCA.City, ''), @HL7EncodingChars) 
				,@GuarantorState = dbo.HL7_OUTBOUND_XFORM(ISNULL(CCA.STATE, ''), @HL7EncodingChars) 
				,@GuarantorZip = dbo.HL7_OUTBOUND_XFORM(ISNULL(CCA.Zip, ''), @HL7EncodingChars) 
				,@Relationship = dbo.HL7_OUTBOUND_XFORM(ISNULL(gc.CodeName, ''), @HL7EncodingChars) 
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
			LEFT JOIN  ClientContactAddresses CCA ON CCA.ClientContactId = CC.ClientContactId
			JOIN GlobalCodes GC ON GC.GlobalCodeId = CC.Relationship
			LEFT JOIN ClientContactPhones CCN ON CCN.ClientContactId = CC.ClientContactId
				AND ISNULL(CCN.RecordDeleted, 'N') = 'N'
			WHERE CC.ClientContactId = @SubScriberContactId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
		END
		
		set @GuarantorAddress= isnull(@GuarantorAddress,'') + @CompChar + isnull(@GuarantorCity,'') + @CompChar + isnull(@GuarantorState,'') + @CompChar + isnull(@GuarantorZip,'')

		IF ISNULL(@GuarantorName, '') = ''
			OR ISNULL(@Relationship, '') = ''
		BEGIN
			SET @GT1SegmentRaw = NULL
		END
		ELSE
		BEGIN
			SET @GuarantorState = CASE 
					WHEN @GuarantorState IS NOT NULL
						AND @GuarantorState <> ''
						THEN substring(@GuarantorState, 1, 2)
					ELSE ''
					END
			SET @GUARSegment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @FieldChar + @GuarantorName + @FieldChar 
							+ @FieldChar + isnull(@GuarantorAddress,'') + @FieldChar + isnull(@HomePhone,'') + @FieldChar + isnull(@WorkPhone,'') + @FieldChar + isnull(@GuarantorBirthDate,'') + @FieldChar  --8
							+ isnull(@GuarantorGender,'') + @FieldChar + @FieldChar + isnull(@Relationship,'') + @FieldChar + isnull(@GuarantorSocSecNo,'') + @FieldChar 						 
							  + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar 
							 
							  
			SET @GT1SegmentRaw = @GUARSegment
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_23_SegmentGT1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
			,'HL7 Procedure Error'
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


