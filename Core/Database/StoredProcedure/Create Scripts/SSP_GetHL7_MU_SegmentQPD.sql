/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentQPD]    Script Date: 07/01/2016 02:27:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentQPD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentQPD]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentQPD]    Script Date: 07/01/2016 02:27:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentQPD]   
 @VendorId INT,  
 @ClientId INT,  
 @HL7EncodingChars nVarchar(5)
 ,@QPDSegmentRaw nVarchar(Max) Output  
AS  
--===========================================  
/*  
Declare @QPDSegmentRaw nVarchar(max)  
EXEC SSP_GetHL7_MU_SegmentQPD 1,127683,'|^~\&','S',3314314,@QPDSegmentRaw Output  
Select @QPDSegmentRaw  
  
-- Jun-22-2017  Varun: Created.  
*/  
--===========================================  
BEGIN  
 BEGIN TRY  
  DECLARE @SegmentName VARCHAR(3)    
  DECLARE @SetId CHAR(1)  
  DECLARE @IntPatientId VARCHAR(20)  
  DECLARE @AlternatePatientId VARCHAR(20)  
  DECLARE @PatientName VARCHAR(48)  
  DECLARE @PatientBirthDate VARCHAR(26)  
  DECLARE @PatientGender CHAR(1)  
  DECLARE @PatientAddress VARCHAR(MAX)  
  DECLARE @PatientEpisodeNumber nVarchar(200)  
  DECLARE @OverrideSPName nVarchar(200)  
  DECLARE @AssigningAuthority VARCHAR(250)
  DECLARE @Race VARCHAR(MAX)
  DECLARE @Ethnicity VARCHAR(MAX)
  DECLARE @DeathInfo nVarchar(15)
  DECLARE @MotherName VARCHAR(250)
  DECLARE @PatientPhoneNumber VARCHAR(250)
  DECLARE @PatientEmailAdress VARCHAR(250)
  DECLARE @PhoneNumberandEmail VARCHAR(MAX)
  DECLARE @MultipleBirthIndicator CHAR = 'N' 
  DECLARE @BirthOrder CHAR = '1'
  DECLARE @InformationNotConfirmed CHAR
  DECLARE @MessageQueryName VARCHAR(200)
  DECLARE @QueryTag VARCHAR(200)
      
  -- pull out encoding characters  
  DECLARE @FieldChar char   
  DECLARE @CompChar char  
  DECLARE @RepeatChar char  
  DECLARE @EscChar char  
  DECLARE @SubCompChar char  
  EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output  
  
  DECLARE @QPDSegment VARCHAR(max)  
    
  SET @SegmentName ='QPD'  
  SET @AlternatePatientId =''  
  SET @SetId='1'  
  SET @MessageQueryName='Z44^Request Evaluated History and Forecast^CDCPHINVS'
  SET @QueryTag='IZ-1.1-2015'

    
  SELECT @OverrideSPName = StoredProcedureName  
  FROM HL7CPSegmentConfigurations  
  WHERE VendorId = @VendorId  
  AND SegmentType=@SegmentName  
  AND ISNULL(RecordDeleted,'N')='N'  
  
    
  SELECT @IntPatientId = dbo.HL7_OUTBOUND_XFORM(@ClientId, @HL7EncodingChars),  
      @PatientName = dbo.GetPatientNameForHL7(@ClientId, @HL7EncodingChars), 
      @PatientBirthDate = CONVERT(varchar, CL.DOB, 112),  
      @PatientGender = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.Sex,''), @HL7EncodingChars),  
      @PatientAddress = dbo.SSF_GetHL7_MU_PatientAddress(@ClientId, @HL7EncodingChars) ,  
      @PatientEpisodeNumber =  dbo.HL7_OUTBOUND_XFORM(ISNULL(EpisodeNumber,''), @HL7EncodingChars),
      @Race = dbo.SSF_GETHL7_MU_Race(@ClientId, @HL7EncodingChars),
      @Ethnicity = dbo.SSF_GETHL7_MU_Ethnicity(@ClientId, @HL7EncodingChars),
      --@DeathInfo = dbo.SSF_GetHL7_MU_DeathInformation(@ClientId,@DocumentVersionId, @HL7EncodingChars),
      @MotherName = CASE ISNULL(CC.LastName,'') WHEN '' THEN '' ELSE dbo.HL7_OUTBOUND_XFORM(ISNULL(CC.LastName,''), @HL7EncodingChars)+@CompChar+@CompChar+@CompChar+@CompChar+@CompChar+@CompChar+'M' END,
      @PatientEmailAdress = CASE WHEN CL.Email IS NOT NULL THEN '^NET^^' + dbo.HL7_OUTBOUND_XFORM(CL.Email, @HL7EncodingChars) ELSE '' END      
  FROM Clients CL  
  LEFT JOIN ClientEpisodes CE ON CL.ClientId = CE.ClientId AND CE.Status = 101 AND ISNULL(CE.RecordDeleted,'N')='N' 
  LEFT JOIN ClientContacts CC ON CC.ClientId = CL. ClientId AND ISNULL(CC.RecordDeleted,'N')='N'
  LEFT JOIN GlobalCodes GC ON GC.Category = 'RELATIONSHIP' AND GC.CodeName = 'Mother' AND CC.Relationship = GC.GlobalCodeId  AND ISNULL(GC.RecordDeleted,'N')='N' 
  WHERE  CL.ClientId = @ClientId  
  
  IF object_id('dbo.SCSP_GetHL7_MU_SegmentPID') IS NOT NULL
	BEGIN
		EXEC SCSP_GetHL7_MU_SegmentPID @ClientId , @InformationNotConfirmed OUTPUT, @MultipleBirthIndicator OUTPUT, @BirthOrder OUTPUT
	END

  SET @AssigningAuthority = '^^^NIST-MPI-1^MR'
  
  SET @PatientPhoneNumber = dbo.SSF_GetHL7_MU_PatientPhoneNumber(@ClientId, @HL7EncodingChars)
  
 
  SET @QPDSegment = @SegmentName+@FieldChar+@MessageQueryName+@FieldChar+@QueryTag+@FieldChar+@IntPatientId+@AssigningAuthority+@FieldChar+@PatientName+@FieldChar+
  @MotherName+@FieldChar+@PatientBirthDate + @FieldChar + @PatientGender + @FieldChar + @PatientAddress+ @FieldChar +@PatientPhoneNumber + @FieldChar +@MultipleBirthIndicator+ @FieldChar+ @BirthOrder
 
  SELECT @QPDSegmentRaw= ISNULL(RTRIM(LTRIM(@QPDSegment)),'')
 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                        
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_GetHL7_MU_SegmentQPD')                                              
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


