/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentAL1]    Script Date: 05/19/2016 14:44:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentAL1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentAL1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentAL1]    Script Date: 05/19/2016 14:44:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentAL1] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@AL1SegmentRaw NVARCHAR(max) OUTPUT
AS
--======================================        
-- DESC : Gets the allergies information of the client from CustomMemberAllergies        
/*        
Declare @AL1SegmentRaw nVarchar(max)        
Exec [SSP_SCGetHL7_251_SegmentAL1] 1,24,'|^~\&',@AL1SegmentRaw Output        
Select @AL1SegmentRaw        
*/
/*                
 Author   Modified Date   Reason            
 Shankha  08/05/2015    Why : General Philhaven Implementation task# 70       
*/
--======================================        
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @AllergenTypeCode NVARCHAR(2)
		DECLARE @AllergenCode NVARCHAR(13)
		DECLARE @AllergenCodeDesc NVARCHAR(100)
		DECLARE @AllergenComments NVARCHAR(MAX)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @AL1Segment VARCHAR(MAX)
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

		SET @SegmentName = 'AL1'
		SET @AllergenTypeCode = 'DA' -- Always DA as per katie's Doc.        

		CREATE TABLE #tempAllergies (
			SetId INT identity(1, 1)
			,AllTypeCode NVARCHAR(2)
			,AllergyCode NVARCHAR(100)
			,AllergyComments NVARCHAR(MAX)
			);

		WITH Allergies (
			ExternalConceptId
			,ConceptDescription
			,AllergyType
			,Comment
			)
		AS (
			SELECT MAC.ExternalConceptId
				,MAC.ConceptDescription
				,CA.AllergyType
				,CA.Comment
			FROM ClientAllergies CA
			INNER JOIN MDAllergenConcepts MAC ON MAC.AllergenConceptId = CA.AllergenConceptId
			WHERE CA.ClientId = @ClientId
				AND ISNULL(CA.RecordDeleted, 'N') = 'N'
				AND ISNULL(MAC.RecordDeleted, 'N') = 'N'
				AND CA.Active = 'Y'
			
			UNION
			
			SELECT ''
				,'No Known Allergies'
				,''
				,''
			FROM Clients C
			WHERE C.ClientId = @ClientId
				AND ISNULL(C.NoKnownAllergies, 'N') = 'Y'
			)
		INSERT INTO #tempAllergies (
			AllTypeCode
			,AllergyCode
			,AllergyComments
			)
		SELECT @AllergenTypeCode
			,dbo.HL7_OUTBOUND_XFORM(Convert(NVARCHAR(100), A.ExternalConceptId), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(Convert(NVARCHAR(100), UPPER(A.ConceptDescription)), @HL7EncodingChars)
			,dbo.HL7_OUTBOUND_XFORM(Convert(NVARCHAR(100), A.Comment), @HL7EncodingChars)
		FROM Allergies A

		--Loop through Allergies        
		DECLARE @Counter INT
		DECLARE @TotalAllergies INT

		SET @Counter = 1

		SELECT @TotalAllergies = count(*)
		FROM #tempAllergies

		DECLARE AllergiesCRSR CURSOR LOCAL SCROLL STATIC
		FOR
		SELECT SetId
			,AllTypeCode
			,AllergyCode
			,AllergyComments
		FROM #tempAllergies

		OPEN AllergiesCRSR

		FETCH NEXT
		FROM AllergiesCRSR
		INTO @SetId
			,@AllergenTypeCode
			,@AllergenCodeDesc
			,@AllergenComments

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @PrevString NVARCHAR(max)

			SELECT @PrevString = ISNULL(@AL1Segment, '')

			SET @AL1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @AllergenTypeCode + @FieldChar + @AllergenCodeDesc + @FieldChar + ISNULL(@AllergenComments, '') + @FieldChar + @FieldChar

			-- Avoid the Carriage return for the last allergy        
			IF @Counter = @TotalAllergies
			BEGIN
				SELECT @AL1Segment = @PrevString + @AL1Segment
			END
			ELSE
			BEGIN
				SELECT @AL1Segment = @PrevString + @AL1Segment + CHAR(13)
			END

			SET @Counter = @Counter + 1

			FETCH NEXT
			FROM AllergiesCRSR
			INTO @SetId
				,@AllergenTypeCode
				,@AllergenCodeDesc
				,@AllergenComments
		END

		CLOSE AllergiesCRSR

		DEALLOCATE AllergiesCRSR

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

			SET @StartingString = @AL1Segment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientId, @HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @AL1Segment = @OutputString
		END

		SET @AL1SegmentRaw = @AL1Segment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentAL1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


