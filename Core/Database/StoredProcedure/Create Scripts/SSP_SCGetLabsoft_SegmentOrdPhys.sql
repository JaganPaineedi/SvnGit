 ALTER PROCEDURE [DBO].[SSP_SCGETLABSOFT_SEGMENTORDPHYS]   
 @ClientOrderId INT,  
 @EncodingChars NVARCHAR(6),  
 @OrdPhysSegmentRaw NVARCHAR(MAX) OUTPUT  
AS  
/*  
-- ================================================================    
-- Stored Procedure: SSP_SCGetLabsoft_SegmentOrdPhys    
-- Create Date : Sep 09 2015   
-- Purpose : Get OrdPhy Segment for Labsoft    
-- Created By : Gautam    
 declare @OrdPhysSegmentRaw nVarchar(max)  
 exec SSP_SCGetLabsoft_SegmentOrdPhys 4, '|^~\&' ,@OrdPhysSegmentRaw Output  
 select @OrdPhysSegmentRaw  
-- ================================================================    
-- History --    
-- Feb/06/2018		Pradeep	  NPI fetching logic changed from Staff to StaffLicenseDegrees table. 
-- ================================================================    
*/  
BEGIN    
 BEGIN TRY    
  DECLARE @SegmentName VARCHAR(7)    
  DECLARE @OrderingPhysian VARCHAR(120)     
  DECLARE @StaffLicenseNumber VARCHAR(50)    
  DECLARE @StaffNPI VARCHAR(50)    
  DECLARE @StaffSigningSuffix VARCHAR(50)    
  DECLARE @OrderingPhysianId INT    
  DECLARE @OrdPhysSegment VARCHAR(max)    
      
  -- pull out encoding characters    
  DECLARE @FieldChar char     
  DECLARE @CompChar char    
  DECLARE @RepeatChar char    
  DECLARE @EscChar char    
  DECLARE @SubCompChar char    
  EXEC SSP_SCGetLabSoft_EncChars @EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output    
        
  SET @SegmentName ='OrdPhys'    
    
  SELECT       
      @OrderingPhysian=[dbo].GetStaffLabSoftFormat(ISNULL(CO.OrderingPhysician,''), @EncodingChars),  
      @StaffLicenseNumber=dbo.GetParseLabSoft_OUTBOUND_XFORM(S.LicenseNumber,@EncodingChars),     
      --@StaffNPI=dbo.GetParseLabSoft_OUTBOUND_XFORM(S.NationalProviderId,@EncodingChars),  
      @StaffSigningSuffix=dbo.GetParseLabSoft_OUTBOUND_XFORM(S.SigningSuffix,@EncodingChars)  ,
	  @OrderingPhysianId = CO.OrderingPhysician
  FROM ClientOrders CO    
  JOIN Staff S on S.StaffId=Co.OrderingPhysician    
  WHERE CO.ClientOrderId=@ClientOrderId    
  AND ISNULL(CO.RecordDeleted,'N')='N'    

  SELECT TOP 1 @StaffNPI =  SL.LicenseNumber
  FROM StaffLicenseDegrees SL 
  JOIN Staff S On S.StaffId = SL.StaffId
  JOIN GlobalCodes GL On GL.GlobalCodeId = SL.LicenseTypeDegree
  WHERE S.StaffId = @OrderingPhysianId
   AND ISNULL(SL.RecordDeleted,'N')='N' 
   AND ISNULL(S.RecordDeleted,'N')='N' 
   AND ISNULL(GL.RecordDeleted,'N')='N' 
   AND GL.Code = 'NPI'
    
 IF ISNULL(@OrderingPhysian,'')=''  or   ISNULL(@StaffLicenseNumber,'')=''  or ISNULL(@StaffNPI,'')=''  or ISNULL(@StaffSigningSuffix,'')=''    
  Begin  
   SET @OrdPhysSegmentRaw=null  
  End  
 Else  
  Begin    
     SET @OrdPhysSegment= @SegmentName+@FieldChar+ @StaffLicenseNumber + @FieldChar+ @OrderingPhysian+@FieldChar+@StaffSigningSuffix+@FieldChar+ @StaffNPI   
  End   
      
  SET @OrdPhysSegmentRaw= @OrdPhysSegment      
 END TRY    
 BEGIN CATCH    
  DECLARE @Error varchar(8000)                                                                          
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetLabsoft_SegmentOrdPhys')                                                
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