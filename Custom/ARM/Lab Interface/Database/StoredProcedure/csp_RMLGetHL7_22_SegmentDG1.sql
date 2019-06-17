/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentDG1]    Script Date: 09/13/2013 12:37:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RMLGetHL7_22_SegmentDG1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentDG1]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentDG1]    Script Date: 09/13/2013 12:37:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentDG1] 
	@VendorId INT,
	--@ClientId INT,
	@ClientOrderId INT,
	@HL7EncodingChars nVarchar(5),
	@DG1SegmentRaw nVarchar(max) Output
AS
--===================================
-- DESC : Gets diagnosescode an description based on the clientId. 
--		  As the diagnoses is a document in SC we fetch all ICD codes  
--		  and its description for the documents which are signed (valid)
/*
Declare @DG1SegmentRaw nVarchar(max)
EXEC csp_RMLGetHL7_22_SegmentDG1 2,6,'|^~\&',@DG1SegmentRaw Output
Select @DG1SegmentRaw
*/
--===================================
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @DiagnosisCodingMethod nVarchar(5)
		DECLARE @DiagnosisCode nVarchar(250)
		DECLARE @DiagnosisDesc nVarchar(250)
		DECLARE @DiagnosisType nVarchar(2)
		DECLARE @SegmentName nVarchar(3)
		DECLARE @OverrideSPName nVarchar(200)
		DECLARE @DG1Segment nVARCHAR(max)
		
		-- pull out encoding characters
		DECLARE @FieldChar char 
		DECLARE @CompChar char
		DECLARE @RepeatChar char
		DECLARE @EscChar char
		DECLARE @SubCompChar char
		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output
		
		
		SET @SegmentName ='DG1'
		SET @DiagnosisType='F' --A=Admitting  W=Working  F=Final
		SET @DiagnosisCodingMethod='ICD-9'
		
		CREATE Table #tempDiagnoses(SetId INT identity(1,1),ICDCode nVARCHAR(13),ICDDescription nVARCHAR(1000))
		
		;WITH Diagnoses_CTE(ICDCode,ICDDescription) AS
			(SELECT ICDCode,Description FROM ClientOrdersDiagnosisIIICodes COD
			 WHERE COD.ClientOrderId=@ClientOrderId
				 AND ISNULL(COD.RecordDeleted,'N')='N')
			 
		INSERT INTO #tempDiagnoses(ICDCode,ICDDescription)
			SELECT Convert(nvarchar(13),CP.ICDCode),Convert(nvarchar(1000),CP.ICDDescription)
			FROM Diagnoses_CTE CP
		
		--Loop through Diagnoses
		
		Declare @Counter Int
		Declare @TotalDiagnoses Int
		Set @Counter=1
		Select @TotalDiagnoses= count(*) from #tempDiagnoses
		
		DECLARE DiagnosesCRSR CURSOR
		LOCAL SCROLL STATIC
		FOR
		SELECT SetId,ICDCode,ICDDescription FROM #tempDiagnoses
		OPEN DiagnosesCRSR
		FETCH NEXT FROM DiagnosesCRSR INTO
			@SetId,@DiagnosisCode,@DiagnosisDesc
		WHILE @@FETCH_STATUS=0
		BEGIN
		DECLARE @PrevString nVarchar(max)
		SELECT @PrevString= ISNULL(@DG1Segment,'')
		
		SET @DG1Segment=@SegmentName+@FieldChar+Convert(nvarchar(4),@SetId)+@FieldChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisCodingMethod,''),@HL7EncodingChars)+@FieldChar
		+dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisCode,''),@HL7EncodingChars)+@FieldChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisDesc,''),@HL7EncodingChars)
		+@FieldChar+@FieldChar+dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisType,''),@HL7EncodingChars)+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar
		+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar
		
		IF @Counter=@TotalDiagnoses
			BEGIN
				SELECT @DG1Segment= @PrevString+@DG1Segment
			END
		Else
			Begin
				SELECT @DG1Segment= @PrevString+@DG1Segment+ CHAR(13)
			End	
		SET @Counter=@Counter+1	
						
		FETCH NEXT FROM DiagnosesCRSR INTO
			@SetId,@DiagnosisCode,@DiagnosisDesc
		END
		
		CLOSE DiagnosesCRSR
		DEALLOCATE DiagnosesCRSR	
		
		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
		AND SegmentType=@SegmentName
		AND ISNULL(RecordDeleted,'N')='N'
		
		SET @DG1SegmentRaw= @DG1Segment
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RMLGetHL7_22_SegmentDG1')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		                                                                
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())    
		                                                                         
		 RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
	END CATCH
END

GO


