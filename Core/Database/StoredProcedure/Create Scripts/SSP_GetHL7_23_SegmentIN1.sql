/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_23_SegmentIN1]    Script Date: 08-05-2018 13:03:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_23_SegmentIN1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_23_SegmentIN1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_23_SegmentIN1]    Script Date: 08-05-2018 13:03:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_23_SegmentIN1] @VENDORID INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@IN1SegmentRaw NVARCHAR(max) OUTPUT
AS
--==========================================  
/*  
Declare @IN1SegmentRaw nvarchar(max)  
EXEC [SSP_GetHL7_23_SegmentIN1] 2,48212,'|^~\&',@IN1SegmentRaw Output  
Select @IN1SegmentRaw  
*/
-- ================================================================
/*  Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
-- ================================================================
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
			,InsuranceCompId NVARCHAR(250)
			,InsuranceName NVARCHAR(250)
			,GroupNumber NVARCHAR(100)
			,StartDate NVARCHAR(24)
			,EndDate NVARCHAR(24)
			,NameOfInsured NVARCHAR(48)
			,RelationShipToPatient NVARCHAR(80)
			,DOBofInsured NVARCHAR(26)
			,InsurancePolicyNumber NVARCHAR(15)
			,SexOfInsured NVARCHAR(1)
			,COBOrder INT
			,ClientIsSubscriber CHAR(1)
			,SubscriberContactId INT
			);

		WITH CoveragePlans_CTE (
			InsuranceCompId
			,InsuranceName
			,GroupNumber
			,StartDate
			,EndDate
			,NameOfInsured
			,RelationShipToPatient
			,DOBofInsured
			,InsurancePolicyNumber
			,SexOfInsured
			,COBOrder
			,ClientIsSubscriber
			,SubscriberContactId
			)
		AS (
			SELECT CP.CoveragePlanId
				,CP.CoveragePlanName
				,CCP.GroupNumber
				,CCH.StartDate
				,CCH.EndDate
				,CASE isnull(ccp.ClientIsSubscriber, 'N')
					WHEN 'Y'
						THEN dbo.HL7_OUTBOUND_XFORM(ISNULL(C.LastName, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(C.FirstName, ''), @HL7EncodingChars) + CASE 
								WHEN C.MiddleName IS NOT NULL
									THEN @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(C.MiddleName, ''), @HL7EncodingChars)
								ELSE ''
								END
					WHEN 'N'
						THEN dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.LastName, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.FirstName, ''), @HL7EncodingChars) + dbo.HL7_OUTBOUND_XFORM(ISNULL(@CompChar + CC.MiddleName, ''), @HL7EncodingChars)
					END AS NameOfInsured
				,CASE isnull(ccp.ClientIsSubscriber, 'N')
					WHEN 'Y'
						THEN '01'
					WHEN 'N'
						THEN CASE g.Code
								WHEN 'Wife'
									THEN '02'
								WHEN 'Spouse'
									THEN '02'
								WHEN 'Husband'
									THEN '02'
								WHEN 'Son'
									THEN 'CH'
								WHEN 'Stepson'
									THEN 'CH'
								WHEN 'Stepdaughter'
									THEN 'CH'
								WHEN 'Daughter'
									THEN 'CH'
								ELSE 'O'
								END
					END AS RelationShipToPatient
				,CASE isnull(ccp.ClientIsSubscriber, 'N')
					WHEN 'Y'
						THEN dbo.HL7_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(11), C.DOB, 112), '-', ''), ':', ''), ' ', ''), @HL7EncodingChars)
					WHEN 'N'
						THEN dbo.HL7_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(11), CC.DOB, 112), '-', ''), ':', ''), ' ', ''), @HL7EncodingChars)
					END AS DOBofInsured
				,CCP.InsuredId
				,CASE isnull(ccp.ClientIsSubscriber, 'N')
					WHEN 'Y'
						THEN dbo.HL7_OUTBOUND_XFORM(ISNULL(C.Sex, ''), @HL7EncodingChars)
					WHEN 'N'
						THEN dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.Sex, ''), @HL7EncodingChars)
					END AS SexOfInsured
				,CCH.COBOrder
				,isnull(ccp.ClientIsSubscriber, 'N') AS ClientIsSubscriber
				,CCP.SubscriberContactId
			FROM ClientCoverageHistory CCH
			JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
			JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
			JOIN Clients C ON C.ClientId = CCP.ClientId
			LEFT JOIN ClientContacts CC ON CC.ClientContactId = CCP.SubscriberContactId
				AND cc.ClientId = C.ClientId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes G ON G.GlobalCodeId = CC.Relationship
				AND ISNULL(G.RecordDeleted, 'N') = 'N'
			WHERE CCP.ClientId = @ClientId
				AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
				AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
				AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
				AND (
					cch.EndDate IS NULL
					OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
					)
			)
		INSERT INTO #tempInsurance (
			InsuranceCompId
			,InsuranceName
			,GroupNumber
			,StartDate
			,EndDate
			,NameOfInsured
			,RelationShipToPatient
			,DOBofInsured
			,InsurancePolicyNumber
			,SexOfInsured
			,COBOrder
			,ClientIsSubscriber
			,SubscriberContactId
			)
		SELECT Convert(NVARCHAR(250), CP.InsuranceCompId)
			,Convert(NVARCHAR(250), CP.InsuranceName)
			,Convert(NVARCHAR(100), CP.GroupNumber)
			,Convert(NVARCHAR(24), CP.StartDate)
			,Convert(NVARCHAR(24), CP.EndDate)
			,Convert(NVARCHAR(48), NameOfInsured)
			,Convert(NVARCHAR(80), RelationShipToPatient)
			,Convert(NVARCHAR(26), DOBofInsured)
			,Convert(NVARCHAR(15), InsurancePolicyNumber)
			,Convert(NVARCHAR(1), SexOfInsured)
			,COBOrder
			,ClientIsSubscriber
			,SubscriberContactId
		FROM CoveragePlans_CTE CP ORDER BY  COBOrder

		--SELECT * FROM #tempInsurance
		--Cursor Start  
		DECLARE @Counter INT
		DECLARE @TotalInsurance INT
		DECLARE @InsuranceName NVARCHAR(250)
			,@NameOfInsured NVARCHAR(48)
			,@RelationShipToPatient NVARCHAR(80)
			,@DOBofInsured NVARCHAR(26)
			,@InsurancePolicyNumber NVARCHAR(15)
			,@SexOfInsured NVARCHAR(1)
			,@COBOrder INT
			,@ClientIsSubscriber CHAR(1)
			,@SubscriberContactId INT
			,@SubscriberAddress NVARCHAR(500)

		SET @Counter = 1

		SELECT @TotalInsurance = count(*)
		FROM #tempInsurance

		DECLARE InsuranceCRSR CURSOR LOCAL SCROLL STATIC
		FOR
		SELECT SetId
			,InsuranceCompId
			,InsuranceName
			,GroupNumber
			,StartDate
			,EndDate
			,NameOfInsured
			,RelationShipToPatient
			,DOBofInsured
			,InsurancePolicyNumber
			,SexOfInsured
			,ClientIsSubscriber
			,SubscriberContactId
		FROM #tempInsurance
		ORDER BY COBOrder

		OPEN InsuranceCRSR

		FETCH NEXT
		FROM InsuranceCRSR
		INTO @SetId
			,@InsuranceCompId
			,@InsuranceName
			,@GroupNumber
			,@StartDate
			,@EndDate
			,@NameOfInsured
			,@RelationShipToPatient
			,@DOBofInsured
			,@InsurancePolicyNumber
			,@SexOfInsured
			,@ClientIsSubscriber
			,@SubscriberContactId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @PrevString NVARCHAR(max)

			SELECT @PrevString = ISNULL(@IN1Segment, '')

			SET @SubscriberAddress = ''

			--GET CLIENT CONTACT'S ADDRESS WHO IS THE SUBSCRIBER
			IF (
					@ClientIsSubscriber = 'N'
					AND ISNULL(@SubscriberContactId, 0) <> 0
					)
			BEGIN
				PRINT 'here'

				SELECT @SubscriberAddress = [dbo].[GetClientContactAddressForHL7](@SubscriberContactId, @HL7EncodingChars)
			END

			--GET CLIENT ADDRESS WHEN EITHER THE SUBSCRIBER CONTACT ADDRESS IS NOT PRESENT OR WHEN THE CLIENT IS THE SUBSCRIBER
			IF ISNULL(@SubscriberAddress, '') = ''
			BEGIN
				PRINT 'there'

				SELECT @SubscriberAddress = [dbo].[GetPatientAddressForHL7](@ClientId, @HL7EncodingChars)
			END

			SET @IN1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@InsuranceCompId, ''), @HL7EncodingChars) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@InsuranceName, ''), @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@GroupNumber, ''), @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + dbo.GetDateFormatForHL7(@StartDate, @HL7EncodingChars) + @FieldChar + dbo.GetDateFormatForHL7(@EndDate, @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + isnull(@NameOfInsured, '') + @FieldChar + isnull(@RelationShipToPatient, '') + @FieldChar + isnull(@DOBofInsured, '') + @FieldChar + iSNULL(@SubscriberAddress, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + isnull(@InsurancePolicyNumber, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar 
				+ isnull(@SexOfInsured, '')

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
				,@InsuranceCompId
				,@InsuranceName
				,@GroupNumber
				,@StartDate
				,@EndDate
				,@NameOfInsured
				,@RelationShipToPatient
				,@DOBofInsured
				,@InsurancePolicyNumber
				,@SexOfInsured
				,@ClientIsSubscriber
				,@SubscriberContactId
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

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_23_SegmentIN1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


