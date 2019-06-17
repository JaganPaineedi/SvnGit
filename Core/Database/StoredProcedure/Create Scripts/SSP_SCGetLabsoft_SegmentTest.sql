/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentTest]    Script Date: 09/14/2015 12:40:40 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentTest]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentTest]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentTest]    Script Date: 09/14/2015 12:40:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentTest] @DocumentVersionId INT
	,@EncodingChars NVARCHAR(6)
	,@TestSegmentRaw NVARCHAR(MAX) OUTPUT
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentTest  
-- Create Date : Sep 09 2015 
-- Purpose : Get Test Segment for Labsoft  
-- Created By : Gautam  
	declare @TestSegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentTest 193, '|^~\&' ,@TestSegmentRaw Output
	select @TestSegmentRaw
-- ================================================================  
-- History --  
07 Apr 2016		PradeepA	Modified for sending the RBO value when Client has any Medicare Plan
05 July 2016	PradeepA	Modified to support multiple Labs. Added join with OrderLabs.LaboratoryId = ClientOrders.LaboratoryId
12 Sep 2018		Shankha B	Modified to pick the correct Order Priority (BBT - Support Go Live #21)
-- ================================================================  
*/
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(4)
		DECLARE @TestName VARCHAR(200)
		DECLARE @TestId VARCHAR(22)
		DECLARE @CPT VARCHAR(50)
		DECLARE @RefLab VARCHAR(200)
		DECLARE @EnteredBy VARCHAR(120)
		DECLARE @OrderingPhysian VARCHAR(120)
		DECLARE @OrderEffectiveFrom VARCHAR(26)
		DECLARE @RBO VARCHAR(200)
		DECLARE @ClientOrderId INT
		DECLARE @TestSegment VARCHAR(max)
		-- pull out encoding characters  
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @QASegmentRaw NVARCHAR(max)
		DECLARE @Priority VARCHAR(100)
		DECLARE @ClientId INT
		DECLARE @Diagnosis VARCHAR(100)

		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'Test'
		SET @RefLab = 'Quest-Atl'
		SET @RBO = 'Pass!' -- Actual data required

		DECLARE Orders CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT ClientOrderId
		FROM ClientOrders CO
		WHERE CO.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND OrderType = 'Labs'
			AND ISNULL(CO.OrderPended, 'N') = 'N'
			AND NOT EXISTS (
				SELECT 1
				FROM LabsoftMessages LM
				WHERE LM.ClientOrderId = CO.ClientOrderId
					AND ISNULL(LM.RecordDeleted, 'N') = 'N'
				)

		OPEN Orders

		WHILE 1 = 1
		BEGIN
			FETCH Orders
			INTO @ClientOrderId

			IF @@fetch_status <> 0
				BREAK

			SELECT TOP 1 @TestId = dbo.GetParseLabSoft_OUTBOUND_XFORM(OL.ExternalOrderId, @EncodingChars)
				,@TestName = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(O.OrderName, ''), @EncodingChars)
				,@CPT = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(OL.CPT, ''), @EncodingChars)
				,@RefLab = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(L.LaboratoryName, ''), @EncodingChars)
				,@Priority = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(G.CodeName, ''), @EncodingChars)
				,@ClientId = CO.ClientId
			FROM ClientOrders CO
			INNER JOIN Orders O ON CO.OrderId = O.OrderId
			INNER JOIN OrderLabs OL ON OL.OrderId = O.OrderId AND OL.LaboratoryId = CO.LaboratoryId
			LEFT JOIN GlobalCOdes G ON G.GlobalCodeId = CO.OrderPriorityId
			INNER JOIN Laboratories L ON L.LaboratoryId = OL.LaboratoryId 
			WHERE CO.ClientOrderId = @ClientOrderId
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				
			-- Set @RBO for getting ABN in the Requisition report
			IF EXISTS (
					SELECT 1
					FROM ClientCoverageHistory CCH
					INNER JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
					INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
					WHERE CCP.ClientId = @ClientId
						AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
						AND (
							cch.EndDate IS NULL
							OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
							)
						AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
						AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
						AND ISNULL(CP.MedicarePlan, 'N') = 'Y'
					)
			BEGIN
				SELECT @Diagnosis = dbo.sfn_GetClientOrderDiagnosis(@ClientOrderId, @EncodingChars)

				SET @RBO = '##StartABN##' + CONVERT(VARCHAR(100), @ClientId) + '^' + @TestId + '^' + @Diagnosis + '##EndABN##'
			END

			SET @TestSegment = ISNULL(@TestSegment, '') + @SegmentName + @FieldChar + @TestId + @CompChar + @CPT + @FieldChar + @TestName + @FieldChar + @RefLab + @FieldChar + @Priority + @FieldChar + @RBO

			EXEC SSP_SCGetLabsoft_SegmentQA @ClientOrderId
				,@EncodingChars
				,@QASegmentRaw OUTPUT

			IF ISNULL(@QASegmentRaw, '') != ''
			BEGIN
				SET @TestSegment = @TestSegment + CHAR(13) + ISNULL(@QASegmentRaw, '')
			END

			SET @TestSegment = @TestSegment + CHAR(13) + 'SampleType' + @FieldChar + CHAR(13) + 'Container' + @FieldChar + CHAR(13) + 'DrawReq' + @FieldChar
			SET @TestSegment = @TestSegment + CHAR(13) + 'TransportMode' + @FieldChar + CHAR(13) + 'TransportGroup' + @FieldChar + CHAR(13)
		END

		CLOSE Orders

		DEALLOCATE Orders

		SET @TestSegmentRaw = @TestSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetLabsoft_SegmentTest') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


