/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentEVN]    Script Date: 06/20/2016 10:10:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentEVN]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentEVN]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentEVN]    Script Date: 06/20/2016 10:10:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentEVN]   
 @VendorId INT,  
 @EventType INT,  
 @HL7EncodingChars nVarchar(5), 
 @DocumentVersionId INT,  
 @EVNSegmentRaw nVarchar(Max) Output  
AS  
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_SegmentEVN  
-- Create Date : Jun 20 2016
-- Purpose : Generates EVN Segment  
-- Script :  
/*   
 Declare @EVNSegmentRaw nVarchar(max)  
 EXEC SSP_GetHL7_MU_SegmentEVN 1,'8775','|^~\&',@EVNSegmentRaw Output  
 Select @EVNSegmentRaw   
*/  
-- Created By : Chethan N  
-- ================================================================  
-- History --  

-- ================================================================  
BEGIN  
 BEGIN TRY  
  DECLARE @SegmentName VARCHAR(3)  
  DECLARE @EventTypeCode VARCHAR(3)  
  DECLARE @RecordedDateTime VARCHAR(24)  
  DECLARE @PlannedDateTime VARCHAR(24)  
  DECLARE @SendingFacility nVarchar(227)
  DECLARE @OverrideSPName nVarchar(200)  
     
  DECLARE @EVNSegment VARCHAR(MAX)  
    
  -- pull out encoding characters  
  DECLARE @FieldChar char   
  DECLARE @CompChar char  
  DECLARE @RepeatChar char  
  DECLARE @EscChar char  
  DECLARE @SubCompChar char  
  EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output  
    
  SELECT @SendingFacility =SendingFacility       
  FROM HL7CPVendorConfigurations  
  WHERE VendorId=@VendorId  
    
  SET @SegmentName='EVN'  
  SELECT @EventTypeCode = dbo.[GetGlobalCodeName](@EventType)  
  SELECT @RecordedDateTime = dbo.GetDateFormatForHL7(GETDATE(),@HL7EncodingChars)  
  SELECT @PlannedDateTime = dbo.GetDateFormatForHL7(GETDATE(),@HL7EncodingChars)
  
   SELECT @OverrideSPName = StoredProcedureName  
  FROM HL7CPSegmentConfigurations  
  WHERE VendorId = @VendorId  
  AND SegmentType=@SegmentName  
  AND ISNULL(RecordDeleted,'N')='N'    
    
  SET @EVNSegment = @SegmentName+ @FieldChar+ @EventTypeCode +@FieldChar+ @RecordedDateTime +@FieldChar --+ @PlannedDateTime 
  + @FieldChar+@FieldChar+@FieldChar+@FieldChar+@SendingFacility 
    
  SET @EVNSegmentRaw= ISNULL(RTRIM(LTRIM(@EVNSegment)),'N')

 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                        
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_GetHL7_MU_SegmentEVN')                                              
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


