/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentIN1]    Script Date: 05/19/2016 14:47:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentIN1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentIN1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentIN1]    Script Date: 05/19/2016 14:47:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentIN1] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@IN1SegmentRaw NVARCHAR(max) OUTPUT
AS
--==========================================
/*
Declare @IN1SegmentRaw nvarchar(max)
EXEC [SSP_SCGetHL7_251_SegmentIN1] 1,24,'|^~\&',@IN1SegmentRaw Output
Select @IN1SegmentRaw
*/
--==========================================
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @InsurancePlanId INT
		DECLARE @InsuranceCompId NVARCHAR(250)
		DECLARE @GroupNumber NVARCHAR(100)
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @IN1Segment NVARCHAR(max)
		DECLARE @StartDate NVARCHAR(24)
		DECLARE @EndDate NVARCHAR(24)
		DECLARE @OverrideSPName NVARCHAR(200)

		SET @SegmentName = 'IN1'

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

		--SELECT * from ClientCoveragePlans
		CREATE TABLE #tempInsurance (
			SetId INT identity(1, 1)
			,InsurancePlanId NVARCHAR(250)
			,InsuranceCompId NVARCHAR(250)
			,GroupNumber NVARCHAR(100)
			,StartDate NVARCHAR(24)
			,EndDate NVARCHAR(24)
			);

		WITH CoveragePlans_CTE (
			InsurancePlanId
			,InsuranceCompId
			,GroupNumber
			,PlanStartDate
			,PlanEndDate
			)
		AS (
			SELECT CCP.CoveragePlanId
				,CCP.InsuredId
				,CCP.GroupNumber
				,CCH.StartDate
				,CCH.EndDate
			FROM ClientCoverageHistory CCH
			JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
			JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
			WHERE CCP.ClientId = @ClientId
				AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
				AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
				AND CCH.COBOrder = 1
			)
		INSERT INTO #tempInsurance (
			InsurancePlanId
			,InsuranceCompId
			,GroupNumber
			,StartDate
			,EndDate
			)
		SELECT Convert(NVARCHAR(250), CP.InsurancePlanId)
			,Convert(NVARCHAR(250), CP.InsuranceCompId)
			,Convert(NVARCHAR(100), CP.GroupNumber)
			,Convert(NVARCHAR(24), CP.PlanStartDate)
			,Convert(NVARCHAR(24), CP.PlanEndDate)
		FROM CoveragePlans_CTE CP

		--select * from  #tempInsurance
		--Cursor Start
		DECLARE @Counter INT
		DECLARE @TotalInsurance INT

		SET @Counter = 1

		SELECT @TotalInsurance = count(*)
		FROM #tempInsurance

		DECLARE InsuranceCRSR CURSOR LOCAL SCROLL STATIC
		FOR
		SELECT SetId
			,InsurancePlanId
			,InsuranceCompId
			,GroupNumber
			,StartDate
			,EndDate
		FROM #tempInsurance

		OPEN InsuranceCRSR

		FETCH NEXT
		FROM InsuranceCRSR
		INTO @SetId
			,@InsurancePlanId
			,@InsuranceCompId
			,@GroupNumber
			,@StartDate
			,@EndDate

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @PrevString NVARCHAR(max)

			SELECT @PrevString = ISNULL(@IN1Segment, '')

			SET @IN1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@InsurancePlanId, ''), @HL7EncodingChars) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@InsuranceCompId, ''), @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@GroupNumber, ''), @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + + dbo.GetDateFormatForHL7(@StartDate, @HL7EncodingChars) + @FieldChar + dbo.GetDateFormatForHL7(@EndDate, @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar

			-- Avoid the Carriage return for the last allergy
			IF @Counter = @TotalInsurance
			BEGIN
				SELECT @IN1Segment = @PrevString + @IN1Segment
			END
			ELSE
			BEGIN
				SELECT @IN1Segment = @PrevString + @IN1Segment + CHAR(13)
			END

			SET @Counter = @Counter + 1

			FETCH NEXT
			FROM InsuranceCRSR
			INTO @SetId
				,@InsurancePlanId
				,@InsuranceCompId
				,@GroupNumber
				,@StartDate
				,@EndDate
		END

		CLOSE InsuranceCRSR

		DEALLOCATE InsuranceCRSR

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF ISNULL(@OverrideSPName, '') != ''
		BEGIN
			--Pass the resulting string and modify in the Override SP.						
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp

			SET @StartingString = @IN1Segment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @IN1Segment = @OutputString
		END

		SET @IN1SegmentRaw = @IN1Segment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentIN1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


