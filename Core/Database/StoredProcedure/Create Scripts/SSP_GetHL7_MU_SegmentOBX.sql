/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentOBX]    Script Date: 06/09/2016 23:33:50 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentOBX]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentOBX]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentOBX]    Script Date: 06/09/2016 23:33:50 
Declare @OBXSegmentRaw nVarchar(max)
EXEC SSP_GetHL7_MU_SegmentOBX 1,127683,'|^~\&',3314315, @OBXSegmentRaw Output
Select @OBXSegmentRaw
-- Author: Varun
******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentOBX] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@DocumentVersionId INT
	,@OBXSegmentRaw NVARCHAR(max) OUTPUT
AS
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @OBXSegment NVARCHAR(max)
		DECLARE @Years INT
		DECLARE @Months INT
		DECLARE @Age INT
		DECLARE @AgeUnit NVARCHAR(200)
		DECLARE @ChiefComplaint NVARCHAR(max)
		DECLARE @Height NVARCHAR(100)
		DECLARE @HeightUnit NVARCHAR(200)
		DECLARE @Weight NVARCHAR(100)
		DECLARE @WeightUnit NVARCHAR(200)
		DECLARE @SmokingStatus NVARCHAR(300)
		DECLARE @VisitFacility NVARCHAR(300)
		DECLARE @InformationNotConfirmed CHAR
		DECLARE @ClientInpatientVisitId INT
		DECLARE @Location NVARCHAR(300)
		DECLARE @ArrivalDate NVARCHAR(100)
		DECLARE @PatientClass VARCHAR(1)
		DECLARE @EventType VARCHAR(3)

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'OBX'
		SET @OBXSegment = ''

		DECLARE @Counter INT

		SET @Counter = 1

		SELECT @Years = cast((DATEDIFF(m, DOB, GETDATE()) / 12) AS INT)
		FROM Clients
		WHERE ClientId = @ClientId

		SELECT @Months = cast((DATEDIFF(m, DOB, GETDATE()) % 12) AS INT)-1
		FROM Clients
		WHERE ClientId = @ClientId

		
		IF object_id('dbo.SCSP_GetHL7_MU_SegmentPID') IS NOT NULL
		BEGIN
			EXEC SCSP_GetHL7_MU_SegmentPID @ClientId
				,@InformationNotConfirmed OUTPUT
		END

		IF (@Years > 0)
		BEGIN
			SET @AgeUnit = 'a^year^UCUM'
			SET @Age = @Years
		END
		ELSE IF (@Months > 0)
		BEGIN
			SET @AgeUnit = 'mo^age^UCUM'
			SET @Age = @Months
		END
		ELSE
		BEGIN
			SET @AgeUnit = 'UNK^Unknown^NULLFL'
			SET @Age = ''
		END

		SELECT @VisitFacility = G.CODE
		FROM GlobalCodes G
		INNER JOIN DocumentSyndromicSurveillances DSS ON DSS.FacilityVisitType = G.GlobalCodeId
		WHERE DSS.DocumentVersionId = @DocumentVersionId

		SET @VisitFacility = CASE @VisitFacility
				WHEN 'URGENTCARE'
					THEN 'OBX|' + Convert(NVARCHAR(4), @Counter) + '|CWE|SS003^Facility/Visit Type^PHINQUESTION||261QU0200X^Urgent Care^HCPTNUCC^AABBCC^UC^L^^^Urgent Care Center||||||F'
				WHEN 'EMERGENCYCARE'
					THEN 'OBX|' + Convert(NVARCHAR(4), @Counter) + '|CWE|SS003^Facility/Visit Type^PHINQUESTION||261QE0002X^Emergency Care^HCPTNUCC||||||F'
				WHEN 'INPATIENTCARE'
					THEN 'OBX|' + Convert(NVARCHAR(4), @Counter) + '|CWE|SS003^Facility/Visit Type^PHINQUESTION||1021-5^Inpatient practice setting^HSLOC||||||F'
				END

		SELECT @ChiefComplaint = ChiefComplaint
		FROM DocumentSyndromicSurveillances
		WHERE DocumentVersionId = @DocumentVersionId

		SELECT @Height = CONVERT(FLOAT, CHDA.Value)
		FROM HealthDataAttributes HDA
		INNER JOIN ClientHealthDataAttributes CHDA ON CHDA.HealthDataAttributeId = HDA.HealthDataAttributeId
			AND HDA.NAME = 'Height'
		INNER JOIN CLients C ON C.ClientId = CHDA.ClientId
		WHERE C.ClientId = @ClientId
			AND CHDA.HealthDataTemplateId = 110

		IF (ISNULL(@Height, '') <> '')
			SET @HeightUnit = '[in_us]^inch^UCUM'

		SELECT @Weight = CONVERT(FLOAT, CHDA.Value)
		FROM HealthDataAttributes HDA
		INNER JOIN ClientHealthDataAttributes CHDA ON CHDA.HealthDataAttributeId = HDA.HealthDataAttributeId
			AND HDA.NAME = 'Weight'
		INNER JOIN CLients C ON C.ClientId = CHDA.ClientId
		WHERE C.ClientId = @ClientId
			AND CHDA.HealthDataTemplateId = 110

		IF (ISNULL(@Weight, '') <> '')
			SET @WeightUnit = '[lb_av]^pound^UCUM'

		SELECT @SmokingStatus = G.ExternalCode1 + @CompChar + G.COdeName + @CompChar + 'SCT'
		FROM GlobalCodes G
		INNER JOIN ClientHealthDataAttributes CHDA ON CHDA.Value = G.GlobalCodeId
		INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = CHDA.HealthDataAttributeId
			AND HDA.NAME = 'Smoking Status'
		INNER JOIN CLients C ON C.ClientId = CHDA.ClientId
		WHERE C.ClientId = @ClientId
			AND CHDA.HealthDataTemplateId = 110

		SELECT TOP 1 @PatientClass = GC1.ExternalCode1
			,@EventType = GC2.ExternalCode1
		FROM DocumentSyndromicSurveillances DSS
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = DSS.DischargeReason
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = DSS.FacilityVisitType
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = DSS.GeneralType
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE DSS.DocumentVersionId = @DocumentVersionId
			AND ISNULL(DSS.RecordDeleted, 'N') = 'N'

		IF (
				(
					SELECT COUNT(*)
					FROM ClientInpatientVisits CIV
					WHERE CIV.ClientId = @ClientId
						AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
					) > 0
				AND (
					(
						@EventType = 'A01'
						OR @EventType = 'A03'
						)
					AND @PatientClass = 'I'
					)
				)
		BEGIN
			SELECT @ClientInpatientVisitId = CIV.ClientInpatientVisitId
				,@Location = L.LocationName
				,@ArrivalDate = CONVERT(VARCHAR(8), BA.ArrivalDate, 112) + REPLACE(LEFT(CAST(BA.ArrivalDate AS TIME), 5), ':', '')
			FROM ClientInpatientVisits CIV
			INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
			INNER JOIN Locations L ON L.LocationId = BA.LocationId
			WHERE CIV.ClientId = @ClientId
				AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
		END

		IF (ISNULL(@VisitFacility, '') <> '')
		BEGIN
			SET @OBXSegment = @VisitFacility + CHAR(13)
			SET @Counter = @Counter + 1
		END

		IF (ISNULL(@ClientInpatientVisitId, 0) > 0)
		BEGIN
			SET @OBXSegment = @OBXSegment + @SegmentName + @FieldChar + Convert(NVARCHAR(4), @Counter) + @FieldChar + 'CWE' + @FieldChar + '56816-2^PATIENT LOCATION^LN' + @FieldChar + @FieldChar + '1028-0' + @CompChar + ISNULL(@Location, '') + @CompChar + 'HSLOC' + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + @FieldChar + @FieldChar + @FieldChar + ISNULL(@ArrivalDate, '') + CHAR(13)
			SET @Counter = @Counter + 1
		END

		IF (
				ISNULL(@Age, '') <> ''
				AND ISNULL(@Age, '') <> 0
				AND ISNULL(@InformationNotConfirmed, 'N') = 'N'
				)
		BEGIN
			SET @OBXSegment = @OBXSegment + @SegmentName + @FieldChar + Convert(NVARCHAR(4), @Counter) + @FieldChar + 'NM' + @FieldChar + '21612-7^Age at Time Patient Reported^LN' + @FieldChar + @FieldChar + CONVERT(VARCHAR(100), @Age) + @FieldChar + ISNULL(@AgeUnit, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + CHAR(13)
			SET @Counter = @Counter + 1
		END
		ELSE
		BEGIN
			SET @OBXSegment = @OBXSegment + 'OBX|' + Convert(NVARCHAR(4), @Counter) + '|NM|21612-7^Age at Time Patient Reported^LN|||UNK^Unknown^NULLFL|||||F' + CHAR(13)
			SET @Counter = @Counter + 1
		END

		IF (ISNULL(@ChiefComplaint, '') <> '')
		BEGIN
			SET @OBXSegment = @OBXSegment + @SegmentName + @FieldChar + Convert(NVARCHAR(4), @Counter) + @FieldChar + 'TX' + @FieldChar + '8661-1^Chief complaint:Find:Pt:Patient:Nom:Reported^LN' + @FieldChar + @FieldChar + ISNULL(@ChiefComplaint, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + CHAR(13)
			SET @Counter = @Counter + 1
		END

		IF (ISNULL(@Height, '') <> '')
		BEGIN
			SET @OBXSegment = @OBXSegment + @SegmentName + @FieldChar + Convert(NVARCHAR(4), @Counter) + @FieldChar + 'NM' + @FieldChar + '8302-2^Height^LN' + @FieldChar + @FieldChar + @Height + @FieldChar + @HeightUnit + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + CHAR(13)
			SET @Counter = @Counter + 1
		END

		IF (ISNULL(@Weight, '') <> '')
		BEGIN
			SET @OBXSegment = @OBXSegment + @SegmentName + @FieldChar + Convert(NVARCHAR(4), @Counter) + @FieldChar + 'NM' + @FieldChar + '3141-9^Weight^LN' + @FieldChar + @FieldChar + @Weight + @FieldChar + @WeightUnit + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + CHAR(13)
			SET @Counter = @Counter + 1
		END

		IF (ISNULL(@SmokingStatus, '') <> '')
		BEGIN
			SET @OBXSegment = @OBXSegment + @SegmentName + @FieldChar + Convert(NVARCHAR(4), @Counter) + @FieldChar + 'CWE' + @FieldChar + '72166-2^Tobacco Smoking Status^LN' + @FieldChar + @FieldChar + ISNULL(@SmokingStatus, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + CHAR(13)
			SET @Counter = @Counter + 1
		END

		SET @OBXSegmentRaw = ISNULL(LTRIM(RTRIM(STUFF(@OBXSegment, LEN(@OBXSegment), 1, ''))), '')
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_SegmentOBX') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
	END CATCH
END
GO

