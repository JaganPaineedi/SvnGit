IF EXISTS (
		SELECT *
		FROM sys.Objects
		WHERE Object_Id = Object_Id(N'dbo.SCSP_SCGetLabsoft_SegmentINS')
			AND Type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.SCSP_SCGetLabsoft_SegmentINS
GO

CREATE PROCEDURE [dbo].[SCSP_SCGetLabsoft_SegmentINS] @ClientId INT
	,@EncodingChars NVARCHAR(5)
	,@INSSegmentRaw NVARCHAR(max) OUTPUT
AS
/*  
-- ================================================================    
-- Stored Procedure: SCSP_SCGetLabsoft_SegmentINS    
-- Create Date : Sep 09 2015   
-- Purpose : Get INS Segment for Labsoft(Core Logic)    
-- Created By : Gautam    
 declare @INSSegmentRaw nVarchar(max)  
 exec SCSP_SCGetLabsoft_SegmentINS 127683, '|^~\&' ,@INSSegmentRaw Output  
 select @INSSegmentRaw   
-- ================================================================    
-- History --    
-- Data Modifications:                   
-- Modified Date    Modified By		Purpose
-- 08.23.17			Govind			Deleted from #TempInsurance Table when COBOrder > 1 in order to populate the segment - Andrews Center Implementation Project : #24
-- 09.21.17			Govind			Updated @ClientIsSubscriber Logic - Andrews Center Implementation Project : #24
-- 11.16.17			Shankha			Updated logic to identify Client Bill + Rewrite the logic to return multipl Insurance segments
-- ================================================================    
*/
BEGIN
	BEGIN TRY
		DECLARE @InsurancePlanId INT
		DECLARE @SetId INT = 0
		DECLARE @InsurancePolicyNo NVARCHAR(250)
		DECLARE @GroupNumber NVARCHAR(100)
		DECLARE @GroupName NVARCHAR(100)
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @IN1Segment NVARCHAR(max) = ''
		DECLARE @StartDate DATETIME
		DECLARE @EndDate DATETIME
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @CoveragePlanName VARCHAR(250)
		DECLARE @Address VARCHAR(100)
		DECLARE @City VARCHAR(30)
		DECLARE @State VARCHAR(2)
		DECLARE @ZipCode VARCHAR(12)
		DECLARE @ContactName VARCHAR(30)
		DECLARE @ContactPhone VARCHAR(50)
		DECLARE @PlanType VARCHAR(50)
		DECLARE @Relationship VARCHAR(50)
		DECLARE @SubscriberName VARCHAR(100)
		DECLARE @PatientBirthDate VARCHAR(26)
		DECLARE @PatientAddress VARCHAR(106)
		DECLARE @PatientCity VARCHAR(50)
		DECLARE @PatientState VARCHAR(2)
		DECLARE @PatientZip VARCHAR(15)
		DECLARE @WorkComp VARCHAR(5) = 'False'
		DECLARE @BillTo VARCHAR(1) = 'T'
		DECLARE @ClientIsSubscriber VARCHAR(1)
		DECLARE @SubScriberContactId INT

		SET @SegmentName = 'INS'

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

		CREATE TABLE #tempInsurance (
			SetId INT identity(1, 1)
			,CoveragePlanId INT
			,InsuredId VARCHAR(25)
			,CoveragePlanName VARCHAR(300)
			,Address VARCHAR(300)
			,City VARCHAR(30)
			,STATE VARCHAR(10)
			,ZipCode VARCHAR(20)
			,ContactName VARCHAR(30)
			,ContactPhone VARCHAR(50)
			,GroupNumber VARCHAR(50)
			,GroupName VARCHAR(100)
			,StartDate DATETIME
			,EndDate DATETIME
			,PlanType VARCHAR(30)
			,COBOrder INT
			,ClientIsSubscriber VARCHAR(5)
			,ClientContactId INT
			,Relationship VARCHAR(50)
			)

		INSERT INTO #tempInsurance (
			CoveragePlanId
			,InsuredId
			,CoveragePlanName
			,Address
			,City
			,STATE
			,ZipCode
			,ContactName
			,ContactPhone
			,GroupNumber
			,GroupName
			,StartDate
			,EndDate
			,PlanType
			,COBOrder
			,ClientIsSubscriber
			,ClientContactId
			,Relationship
			)
		SELECT CCP.CoveragePlanId
			,CCP.InsuredId
			,CP.CoveragePlanName
			,CP.Address
			,CP.City
			,CP.STATE
			,CP.ZipCode
			,CP.ContactName
			,CP.ContactPhone
			,CCP.GroupNumber
			,CCP.GroupName
			,CCH.StartDate
			,CCH.EndDate
			,CASE 
				WHEN ISNULL(CP.MedicaidPlan, 'N') = 'Y'
					THEN 'Medicaid'
				WHEN ISNULL(CP.MedicarePlan, 'N') = 'Y'
					THEN 'MedicarePlan'
				ELSE 'Private Insurance'
				END AS PlanType
			,CCH.COBOrder
			,CCP.ClientIsSubscriber
			,CCP.SubscriberContactId
			,Isnull(G.CodeName, 'Self')
		FROM ClientCoverageHistory CCH
		JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
		JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		LEFT JOIN ClientContacts CC ON CC.ClientContactId = CCP.SubscriberContactId 
		LEFT JOIN GLOBALCODES G ON CC.Relationship = G.GLobalCodeId
		WHERE CCP.ClientId = @ClientId
			AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
			AND (
				cch.EndDate IS NULL
				OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
				)
			AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
			AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
		ORDER BY CCH.COBOrder

		--SELECT *
		--FROM #tempInsurance

		IF EXISTS (
				SELECT *
				FROM #tempInsurance
				)
		BEGIN
			DECLARE InsuranceCRSR CURSOR LOCAL SCROLL STATIC
			FOR
			SELECT SetId
				,CoveragePlanId
				,InsuredId
				,CoveragePlanName
				,Address
				,City
				,STATE
				,ZipCode
				,ContactName
				,ContactPhone
				,GroupNumber
				,GroupName
				,StartDate
				,EndDate
				,PlanType
				,ClientIsSubscriber
				,ClientContactId
				,Relationship
			FROM #tempInsurance

			OPEN InsuranceCRSR

			FETCH NEXT
			FROM InsuranceCRSR
			INTO @SetId
				,@InsurancePlanId
				,@InsurancePolicyNo
				,@CoveragePlanName
				,@Address
				,@City
				,@State
				,@ZipCode
				,@ContactName
				,@ContactPhone
				,@GroupNumber
				,@GroupName
				,@StartDate
				,@EndDate
				,@PlanType
				,@ClientIsSubscriber
				,@SubScriberContactId
				,@Relationship

			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @SetId <> 1
				BEGIN
					SET @IN1Segment = @IN1Segment + CHAR(13)
				END

				-- CLIENT IS THE SUBSCRIBER
				IF ISNULL(@ClientIsSubscriber, 'N') = 'Y'
				BEGIN
					SELECT TOP 1 @SubscriberName = dbo.GetPatientNameForLabSoft(@ClientId, @EncodingChars)
						,@PatientBirthDate = CONVERT(VARCHAR(10), CL.DOB, 112)
						,@PatientAddress = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.Address, ''), @EncodingChars)
						,@PatientCity = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.City, ''), @EncodingChars)
						,@PatientState = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.STATE, ''), @EncodingChars)
						,@PatientZip = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CA.Zip, ''), @EncodingChars)
					FROM Clients CL
					LEFT JOIN ClientAddresses CA ON CL.ClientId = CA.ClientId
						AND CA.AddressType = 90 --Home		
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					WHERE CL.ClientId = @ClientId
						AND ISNULL(CL.RecordDeleted, 'N') = 'N'
				END
				ELSE -- CLIENT CONTACT IS THE SUBSCRIBER
				BEGIN
					SELECT TOP 1 @SubscriberName = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CC.LastName, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CC.FirstName, ''), @EncodingChars)
						,@PatientBirthDate = CONVERT(VARCHAR(10), CC.DOB, 112)
						,@PatientAddress = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.Address, ''), @EncodingChars)
						,@PatientCity = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.City, ''), @EncodingChars)
						,@PatientState = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.STATE, ''), @EncodingChars)
						,@PatientZip = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(CCA.Zip, ''), @EncodingChars)
					FROM ClientContacts CC
					JOIN ClientContactAddresses CCA ON CCA.ClientContactId = CC.ClientContactId
					WHERE CC.ClientContactId = @SubScriberContactId
						AND ISNULL(CC.RecordDeleted, 'N') = 'N'
						AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
				END

				SET @PatientState = CASE 
						WHEN @PatientState IS NOT NULL
							AND @PatientState <> ''
							THEN substring(@PatientState, 1, 2)
						ELSE ''
						END

				IF ISNULL(@InsurancePlanId, '') = ''
					OR ISNULL(@CoveragePlanName, '') = ''
					OR ISNULL(@Address, '') = ''
					OR ISNULL(@City, '') = ''
					OR ISNULL(@State, '') = ''
					OR ISNULL(@ZipCode, '') = ''
					OR ISNULL(@GroupNumber, '') = ''
					OR ISNULL(@PlanType, '') = ''
					OR ISNULL(@SubscriberName, '') = ''
					OR ISNULL(@Relationship, '') = ''
					OR ISNULL(@InsurancePolicyNo, '') = ''
					OR ISNULL(@BillTo, '') = ''
				BEGIN
					SET @BillTo = 'P'
					SET @IN1Segment = @SegmentName +  @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar 
						+ @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@BillTo, '')
					SET @INSSegmentRaw = @IN1Segment
					
					CLOSE InsuranceCRSR

					DEALLOCATE InsuranceCRSR
					RETURN
				END
				ELSE
				BEGIN
					SET @IN1Segment = @IN1Segment + @SegmentName+ @FieldChar + CAST(@SetId AS VARCHAR(MAX)) + @FieldChar + + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@InsurancePlanId, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@CoveragePlanName, ''), 
							@EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@Address, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@City, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(
							ISNULL(@State, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@ZipCode, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@ContactName, ''), @EncodingChars) + @FieldChar + dbo.
						GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@ContactName, ''), @EncodingChars) -- need to get actual data  
						+ @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@ContactPhone, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@GroupNumber, ''), @EncodingChars) + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(
								@GroupName, ''), @EncodingChars) + @FieldChar + CASE 
							WHEN @StartDate IS NOT NULL
								THEN CONVERT(VARCHAR(12), @StartDate, 101)
							ELSE ''
							END + @FieldChar + CASE 
							WHEN @EndDate IS NOT NULL
								THEN CONVERT(VARCHAR(12), @EndDate, 101)
							ELSE ''
							END + @FieldChar + ISNULL(@PlanType, '') + @FieldChar + ISNULL(@SubscriberName, '') + @FieldChar + + @FieldChar + ISNULL(@Relationship, '') + @FieldChar + ISNULL(@PatientBirthDate, '') + @FieldChar + ISNULL(@PatientAddress, '') + @FieldChar + ISNULL(
							@PatientCity, '') + @FieldChar + ISNULL(@PatientState, '') + @FieldChar + ISNULL(@PatientZip, '') + @FieldChar + ISNULL(@WorkComp, '') + @FieldChar + ISNULL(@InsurancePolicyNo, '') + @FieldChar

					-- Check whether the coverage plan is set up as Recodes to be identified as Client Bill
					IF EXISTS (
							SELECT 1
							FROM dbo.ssf_RecodeValuesCurrent('COVERAGEPLANSTYPECLIENTBILL')
							WHERE IntegerCodeId = @InsurancePlanId
							)
					BEGIN
						SET @IN1Segment = @IN1Segment + 'C'
					END
					ELSE
					BEGIN
						SET @IN1Segment = @IN1Segment + 'T'
					END
				END

				FETCH NEXT
				FROM InsuranceCRSR
				INTO @SetId
					,@InsurancePlanId
					,@InsurancePolicyNo
					,@CoveragePlanName
					,@Address
					,@City
					,@State
					,@ZipCode
					,@ContactName
					,@ContactPhone
					,@GroupNumber
					,@GroupName
					,@StartDate
					,@EndDate
					,@PlanType
					,@ClientIsSubscriber
					,@SubScriberContactId
					,@Relationship
			END

			SET @INSSegmentRaw = @IN1Segment

			CLOSE InsuranceCRSR

			DEALLOCATE InsuranceCRSR
		END
		ELSE
		BEGIN
			SET @BillTo = 'P'
			SET @IN1Segment = @SegmentName + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 
				@FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@BillTo, '')
			SET @INSSegmentRaw = @IN1Segment
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SCSP_SCGetLabsoft_SegmentINS') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY(
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
