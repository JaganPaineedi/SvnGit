/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentORDR]    Script Date: 09/14/2015 12:40:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentORDR]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentORDR]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentORDR]    Script Date: 09/14/2015 12:40:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentORDR] 
	@ClientOrderId INT,
	@EncodingChars NVARCHAR(6),
	@ORDRSegmentRaw NVARCHAR(MAX) OUTPUT
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentORDR  
-- Create Date : Sep 09 2015 
-- Purpose : Get ORDR Segment for Labsoft  
-- Created By : Gautam  
	declare @ORDRSegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentORDR 4, '|^~\&' ,@ORDRSegmentRaw Output
	select @ORDRSegmentRaw
-- ================================================================  
-- History --  
05/09/2015	Pradeep			Added Comment into ORDR segment
-- ================================================================  
*/
BEGIN  
 BEGIN TRY  
  DECLARE @SegmentName VARCHAR(4)  
  DECLARE @OrderCode VARCHAR(2)  
  DECLARE @PlacerOrderNumber VARCHAR(22)  
  DECLARE @UseTQ1 VARCHAR(200)  
  DECLARE @EnteredBy VARCHAR(120)  
  DECLARE @OrderingPhysian VARCHAR(120)  
  DECLARE @OrderEffectiveFrom VARCHAR(26)  
  DECLARE @CommentText VARCHAR(MAX)
    
    
  DECLARE @ORDRSegment VARCHAR(max)  
    
  -- pull out encoding characters  
  DECLARE @FieldChar char   
  DECLARE @CompChar char  
  DECLARE @RepeatChar char  
  DECLARE @EscChar char  
  DECLARE @SubCompChar char  
  EXEC SSP_SCGetLabSoft_EncChars @EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output  
      
  SET @SegmentName ='ORDR'  
  
  SELECT  Top 1  
      @PlacerOrderNumber=dbo.GetParseLabSoft_OUTBOUND_XFORM(CO.ClientOrderId,@EncodingChars),  
      @UseTQ1=dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(GC.CodeName,''),@EncodingChars),  
      @EnteredBy=[dbo].GetStaffHL7Format(ISNULL(CO.OrderedBy,''), @EncodingChars),  
      @OrderingPhysian=[dbo].GetStaffLabSoftFormat(ISNULL(CO.OrderingPhysician,''), @EncodingChars),
	  @CommentText = ISNULL(CO.CommentsText,'')
  FROM ClientOrders CO  
  JOIN Staff S on S.StaffId=Co.OrderedBy  
  LEFT JOIN OrderTemplateFrequencies OTF On OTF.OrderTemplateFrequencyId =CO.OrderTemplateFrequencyId  
  LEFT JOIN GlobalCodes GC On GC.GlobalCodeId = OTF.RxFrequencyId  
  WHERE CO.ClientOrderId=@ClientOrderId  
  AND ISNULL(CO.RecordDeleted,'N')='N'  
  
    
  SET @ORDRSegment= @SegmentName+@FieldChar+ @OrderingPhysian+@FieldChar+@FieldChar+@FieldChar+@PlacerOrderNumber  
  +@FieldChar+@FieldChar+@FieldChar+@FieldChar+@CommentText
    
    
  SET @ORDRSegmentRaw= @ORDRSegment    
 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                        
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetLabsoft_SegmentORDR')                                              
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                          
   + '*****' + Convert(varchar,ERROR_STATE())                                                                        
                                                                    
   Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)  
   values(@Error,NULL,NULL,'Labsoft Procedure Error','SmartCare',GetDate())      
                                                                             
   RAISERROR                                                                         
   (                                                              
   @Error, -- Message text.                                                                        
   16, -- Severity.                                                                        
   1 -- State.                                                                        
   );    
 END CATCH  
END  
GO


