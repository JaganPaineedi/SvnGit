/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentDraw]    Script Date: 09/14/2015 12:40:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentDraw]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentDraw]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentDraw]    Script Date: 09/14/2015 12:40:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentDraw] 
	@ClientOrderId INT,
	@EncodingChars NVARCHAR(6),
	@DrawSegmentRaw NVARCHAR(MAX) OUTPUT
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentDraw  
-- Create Date : Sep 09 2015 
-- Purpose : Get Draw Segment for Labsoft  
-- Created By : Gautam  
	declare @DrawSegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentDraw 141, '|^~\&' ,@DrawSegmentRaw Output
	select @DrawSegmentRaw
-- ================================================================  
-- History --  

-- ================================================================  
*/
BEGIN  
 BEGIN TRY  
  DECLARE @SegmentName VARCHAR(4)  
  DECLARE @DrawSegment VARCHAR(max)
  DECLARE @ScheduleDateTime varchar(50)
  DECLARE @DrawFromServiceCenter VARCHAR(5) = 'false'  
    
  -- pull out encoding characters  
  DECLARE @FieldChar char   
  DECLARE @CompChar char  
  DECLARE @RepeatChar char  
  DECLARE @EscChar char  
  DECLARE @SubCompChar char  
  EXEC SSP_SCGetLabSoft_EncChars @EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output  
      
  SET @SegmentName ='Draw'  
  
  
  -- get the document effective date  
  select  Top 1 @ScheduleDateTime =  convert(VARCHAR(10), CO.OrderStartDateTime,101) + ' @ ' + 
       substring(convert(VARCHAR(10), CO.OrderStartDateTime,8),1,5)
               from ClientOrders CO  
              where ClientOrderId=@ClientOrderID AND  
               ISNULL(CO.RecordDeleted,'N')='N' 
  
  IF EXISTS (SELECT 1 FROM ClientOrders CO WHERE Co.DocumentVersionId = (Select DocumentVersionId FROM ClientOrders WHERE ClientOrderId = @ClientOrderId) AND CO.DrawFromServiceCenter = 'Y' AND ISNULL(Co.RecordDeleted,'N')= 'N')
  BEGIN
	SET @DrawFromServiceCenter = 'true'
  END
     
  SET @DrawSegment= @SegmentName+@FieldChar+ @ScheduleDateTime +@FieldChar + @DrawFromServiceCenter
    
  SET @DrawSegmentRaw= @DrawSegment    
 END TRY  
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                                                                        
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetLabsoft_SegmentDraw')                                              
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


