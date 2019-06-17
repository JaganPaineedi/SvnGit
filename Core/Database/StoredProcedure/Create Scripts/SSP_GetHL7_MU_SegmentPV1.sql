/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentPV1]    Script Date: 06/28/2016 15:52:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentPV1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentPV1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentPV1]    Script Date: 06/28/2016 15:52:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentPV1]   
 @VendorId INT,  
 @ClientId INT,  
 @HL7EncodingChars nVarchar(5),
 @DocumentVersionId INT,   
 @PV1SegmentRaw nVarchar(Max) Output  
AS  
--===========================================  
/*  
Declare @PV1SegmentRaw nVarchar(max)  
EXEC SSP_GetHL7_MU_SegmentPV1 1,127686,'|^~\&','3314321',@PV1SegmentRaw Output  
Select @PV1SegmentRaw  
*/  

-- Jun-23-2016  Chethan N: Created.   
  
--===========================================  
BEGIN  
 BEGIN TRY  
  DECLARE @SegmentName VARCHAR(3)  
  DECLARE @SetId nVarchar(4)  
  DECLARE @PatientClass VARCHAR(1)  
  DECLARE @AssignedPatientLocation VARCHAR(40)  
    
  DECLARE @AssigningAuthority VARCHAR(250)
  DECLARE @EventType VARCHAR(3)
    
  -- pull out encoding characters  
  DECLARE @FieldChar char   
  DECLARE @CompChar char  
  DECLARE @RepeatChar char  
  DECLARE @EscChar char  
  DECLARE @SubCompChar char  
  EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output  
    
      
  DECLARE @OverrideSPName nVarchar(200)  
  DECLARE @PV1Segment nVARCHAR(max)  
  SET @SegmentName = 'PV1'  
  SET @SetId='1'  
  --SET @PatientClass ='I'  
  
  SET @AssigningAuthority = dbo.SSF_GETHL7_MU_AssigningAuthority ('|^~\&' )
  
  DECLARE @VisitNumber nVarchar(10)
  DECLARE @DischargeDisposition nVarchar(2) 
  DECLARE @AdmitDateTime VARCHAR(15)  
  DECLARE @DischargeDateTime VARCHAR(15)  
  DECLARE @AdmissionType VARCHAR(1)
  
 	SELECT TOP 1 @DischargeDisposition = CAST(ISNULL(GC.ExternalCode1,'N') AS VARCHAR)
		,@AdmitDateTime = CONVERT(VARCHAR(8), AdmissionDateTime, 112) + REPLACE(LEFT(CAST(AdmissionDateTime AS TIME), 5), ':', '')
		,@DischargeDateTime = CONVERT(VARCHAR(8), DischargeDateTime, 112) + REPLACE(LEFT(CAST(DischargeDateTime AS TIME), 5), ':', '')
		,@PatientClass = GC1.ExternalCode1
		--,@AdmissionType = GC1.ExternalCode2
		,@EventType = GC2.ExternalCode1
	FROM DocumentSyndromicSurveillances DSS
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = DSS.DischargeReason AND ISNULL(GC.RecordDeleted, 'N') = 'N'
	LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = DSS.FacilityVisitType AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
	LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = DSS.GeneralType AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
	WHERE DSS.DocumentVersionId = @DocumentVersionId
		AND ISNULL(DSS.RecordDeleted, 'N') = 'N'

	IF ((SELECT COUNT(*) FROM ClientInpatientVisits CIV WHERE CIV.ClientId = @ClientId AND ISNULL(CIV.RecordDeleted,'N') = 'N') > 0 AND (@EventType = 'A01' OR @PatientClass = 'I'))
	  BEGIN
		--SET @PatientClass ='I' 
		SELECT TOP 1 @VisitNumber =  CIV.ClientInpatientVisitId 
		FROM ClientInpatientVisits CIV 
		INNER JOIN Documents D on D.ClientId=CIV.ClientId and D.DocumentCodeId=1639 and ISNULL(D.RecordDeleted,'N') = 'N'
		WHERE CIV.ClientId = @ClientId AND ISNULL(CIV.RecordDeleted,'N') = 'N'
		AND (  
         cast(D.EffectiveDate AS DATE) >= CAST(CIV.AdmitDate AS DATE)  
         AND cast(D.EffectiveDate AS DATE) <= CAST(ISNULL(CIV.DischargedDate,'12/31/2199') AS DATE)  
         )
		AND CIV.Status not in (4983,4984) -- (On Leave, Discharged)
		ORDER BY CIV.ClientInpatientVisitId DESC

		IF @VisitNumber > 1
		SET @AdmissionType='U'
		--SELECT TOP 1 @VisitNumber = ClientInpatientVisitId --,@AdmitDateTime = AdmitDate, @DischargeDateTime = DischargedDate  
		--FROM ClientInpatientVisits CIV 
		--WHERE CIV.ClientId = @ClientId AND ISNULL(CIV.RecordDeleted,'N') = 'N'
		--ORDER BY ClientInpatientVisitId DESC
	  END
  ELSE
  BEGIN
	--SET @PatientClass ='O' 
	
	SELECT TOP 1 @VisitNumber = ClientEpisodeId --,@AdmitDateTime = RegistrationDate, @DischargeDateTime = DischargeDate  
	FROM ClientEpisodes  
	WHERE ClientId = @ClientId AND ISNULL(RecordDeleted,'N') = 'N'
	ORDER BY ClientEpisodeId DESC
	
  END
          
  SET @PV1Segment=@SegmentName+@FieldChar+Convert(nVarchar(4),@SetId)+@FieldChar+ISNULL(@PatientClass, 'O')+@FieldChar+ISNULL(@AdmissionType,'')
  
  -- add 17 more separators  
  DECLARE @cntr int =1  
  WHILE @cntr < 17 BEGIN  
   SET @cntr = @cntr + 1  
   Set @PV1Segment=@PV1Segment + @FieldChar     
  END  
  
  SET @PV1Segment = @PV1Segment + ISNULL(@VisitNumber, '') + @CompChar + @CompChar + @CompChar + ISNULL(@AssigningAuthority, '') + @CompChar + 'VN'
  
  WHILE @cntr < 34 BEGIN  
   SET @cntr = @cntr + 1  
   Set @PV1Segment=@PV1Segment + @FieldChar     
  END
    
  SET @PV1Segment = CASE @DischargeDisposition WHEN 'N' THEN @PV1Segment  ELSE @PV1Segment + @DischargeDisposition END
    
  WHILE @cntr < 42 BEGIN  
   SET @cntr = @cntr + 1  
   Set @PV1Segment=@PV1Segment + @FieldChar     
  END  
      
  SET @PV1Segment=@PV1Segment + CASE WHEN @AdmitDateTime IS NULL THEN '' ELSE @AdmitDateTime END 
		+  CASE WHEN @DischargeDateTime IS NULL OR @DischargeDateTime = '' THEN '' ELSE @FieldChar + @DischargeDateTime END
    
    
  SET @PV1SegmentRaw= ISNULL(RTRIM(LTRIM(@PV1Segment)), '')
  
 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                        
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_GetHL7_MU_SegmentPV1')                                              
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


