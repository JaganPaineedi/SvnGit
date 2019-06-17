/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentDG1]    Script Date: 20-02-2018 21:28:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHL7_23_SegmentDG1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHL7_23_SegmentDG1]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentDG1]    Script Date: 20-02-2018 21:28:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetHL7_23_SegmentDG1] @VendorId INT
	,@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@DG1SegmentRaw NVARCHAR(max) OUTPUT
AS
--===================================
-- DESC : Gets diagnosescode an description based on the clientId. 
--		  As the diagnoses is a document in SC we fetch all ICD codes  
--		  and its description for the documents which are signed (valid)
/*

Declare @DG1SegmentRaw nVarchar(max)
EXEC ssp_GetHL7_23_SegmentDG1 2,1265,'|^~\&',@DG1SegmentRaw Output
Select @DG1SegmentRaw
/*  Date            Author      Purpose								*/
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
--===================================
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @DiagnosisCodingMethod NVARCHAR(6)
		DECLARE @DiagnosisCode NVARCHAR(250)
		DECLARE @Diagnosis10Code NVARCHAR(250)
		DECLARE @DiagnosisDesc NVARCHAR(250)
		DECLARE @Diagnosis10Desc NVARCHAR(250)
		DECLARE @DiagnosisType NVARCHAR(2)
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @DG1Segment NVARCHAR(max)
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

		SET @SegmentName = 'DG1'
		SET @DiagnosisType = 'F' --A=Admitting  W=Working  F=Final
		SET @DiagnosisCodingMethod = 'I10'
		
		SELECT @OverrideSPName = StoredProcedureName  
		FROM HL7CPSegmentConfigurations  
		WHERE VendorId = @VendorId  
		AND SegmentType = @SegmentName  
		AND ISNULL(RecordDeleted, 'N') = 'N'  
		
		IF ISNULL(@OverrideSPName, '') = '' 
			BEGIN			
				CREATE TABLE #tempCustomDiagnoses (
					SetId INT identity(1, 1)
					,ICDCode NVARCHAR(13)
					,ICDDescription NVARCHAR(1000)
					,ICD10Code NVARCHAR(1000)
					,ICD10Description NVARCHAR(1000)
					);

				WITH Diagnoses_CTE (
					ICDCode
					,ICDDescription
					,ICD10Code
					,ICD10Description
					)
				AS (
					SELECT Top 10 COD.ICDCode -- To show only max 10 diagnosis as per quest requirement
						,DC.ICDDescription
						,REPLACE(DC.ICD10Code, '*', '') AS ICD10Code
						,DC.ICDDescription
					FROM ClientOrdersDiagnosisIIICodes COD
					LEFT JOIN DiagnosisICD10Codes DC ON COD.ICD10CodeId = DC.ICD10CodeId
					WHERE COD.ClientOrderId = @ClientOrderId
						AND ISNULL(COD.RecordDeleted, 'N') = 'N'
					)
				INSERT INTO #tempCustomDiagnoses (
					ICDCode
					,ICDDescription
					,ICD10Code
					,ICD10Description
					)
				SELECT Convert(NVARCHAR(13), CP.ICDCode)
					,Convert(NVARCHAR(1000), CP.ICDDescription)
					,Convert(NVARCHAR(1000), CP.ICD10Code)
					,Convert(NVARCHAR(1000), CP.ICD10Description)
				FROM Diagnoses_CTE CP

				--Loop through Diagnoses
				DECLARE @Counter INT
				DECLARE @TotalDiagnoses INT

				SET @Counter = 1

				SELECT @TotalDiagnoses = count(*)
				FROM #tempCustomDiagnoses

				DECLARE DiagnosesCRSR CURSOR LOCAL SCROLL STATIC
				FOR
				SELECT SetId
					,ICDCode
					,ICDDescription
					,ICD10Code
					,ICD10Description
				FROM #tempCustomDiagnoses

				OPEN DiagnosesCRSR

				FETCH NEXT
				FROM DiagnosesCRSR
				INTO @SetId
					,@DiagnosisCode
					,@DiagnosisDesc
					,@Diagnosis10Code
					,@Diagnosis10Desc

				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @PrevString NVARCHAR(max)

					SELECT @PrevString = ISNULL(@DG1Segment, '')

					SET @DG1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisCodingMethod, ''), @HL7EncodingChars) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@Diagnosis10Code, ''), @HL7EncodingChars) + @CompChar 
						+ dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisDesc, ''), @HL7EncodingChars) + @CompChar + @DiagnosisCodingMethod + @FieldChar

					-- + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisType, ''), @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar
					IF @Counter = @TotalDiagnoses
					BEGIN
						SELECT @DG1Segment = @PrevString + @DG1Segment
					END
					ELSE
					BEGIN
						SELECT @DG1Segment = @PrevString + @DG1Segment + CHAR(13)
					END

					SET @Counter = @Counter + 1

					FETCH NEXT
					FROM DiagnosesCRSR
					INTO @SetId
						,@DiagnosisCode
						,@DiagnosisDesc
						,@Diagnosis10Code
						,@Diagnosis10Desc
				END

				CLOSE DiagnosesCRSR

				DEALLOCATE DiagnosesCRSR
			END
		ELSE
			BEGIN 
				   --Pass the resulting string and modify in the Override SP.        
				   DECLARE @OutputString NVARCHAR(max)  
				   DECLARE @SPName NVARCHAR(max)  
				   DECLARE @ParamDef NVARCHAR(max)  
				   DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp  
				  
				   SET @StartingString = @DG1Segment  
				   SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientOrderId,@HL7EncodingChars,@OutputString OUTPUT'  
				   SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientOrderId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'  
				 
				  
				   EXECUTE sp_executesql @SPName  
					,@ParamDef  
					,@StartingString  
					,@VendorId  
					,@ClientOrderId  
					,@HL7EncodingChars  
					,@OutputString OUTPUT  
				  
				   SET @DG1Segment = @OutputString  
			END 
		SET @DG1SegmentRaw = @DG1Segment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHL7_23_SegmentDG1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + 
			'*****' + Convert(VARCHAR, ERROR_STATE())

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


