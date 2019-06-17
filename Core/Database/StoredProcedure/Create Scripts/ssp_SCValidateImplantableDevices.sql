IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateImplantableDevices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCValidateImplantableDevices]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCValidateImplantableDevices] @CurrentUserId INT
 ,@ScreenKeyId INT
 AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCValidateImplantableDevices] 550,9   */
/* Date              Author                  Purpose                 */
/* 29/06/2017        Sunil.D            SC: ImplantableDevices  ssp_SCValidateImplantableDevices #24 Meaningfull Use                       */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */
BEGIN 
BEGIN TRY     
 
 DECLARE @validationReturnTable TABLE          
 (      
	 TableName  VARCHAR(200),      
	 ColumnName  VARCHAR(200),      
	 ErrorMessage VARCHAR(1000),
	 TabOrder int,
	 ValidationOrder Int      
 )      
---- Inser row in Validation Table ------      
INSERT  
INTO  
 @validationReturnTable  
 (  
  TableName,  
  ColumnName,  
  ErrorMessage,
  TabOrder, 
  ValidationOrder 
 )  
 SELECT 'ImplantableDevices', 'ImplantDate', 'Device Information - Global UDI is required' ,1,1
		FROM ImplantableDevices  
	WHERE isnull(GlobalUDI,'') = ''   and ImplantableDeviceId=@ScreenKeyId 
UNION  
	SELECT 'ImplantableDevices', 'ImplantDate', 'Device Information - Implant Date is required' ,1,1
		FROM ImplantableDevices  
	WHERE isnull(ImplantDate,'') = ''   and ImplantableDeviceId=@ScreenKeyId 
UNION  
SELECT 'ImplantableDevices', 'ImplantDate', 'Device Information – Status is required' ,1,1
		FROM ImplantableDevices  
	WHERE isnull(Active,'') = ''   and ImplantableDeviceId=@ScreenKeyId 
UNION  
	SELECT 'ImplantableDevices', 'InactiveReason', 'Device Information - Inactive Reason is required',1 ,2 
		FROM ImplantableDevices I 
		join GlobalCodes G on G.GlobalCodeId=I.Active 
	WHERE  isnull(I.Active,'') != '' and isnull(I.InactiveReason,'') = '' and G.Code='I'  and I.ImplantableDeviceId=@ScreenKeyId 
	
	 
 
	 
 SELECT distinct TableName  
  , ColumnName  
  , ErrorMessage
  ,TabOrder
  ,ValidationOrder  
FROM  
 @validationReturnTable    order by  ValidationOrder   
 IF EXISTS (SELECT *   FROM    @validationReturnTable)          
  BEGIN  
SELECT 1 AS ValidationStatus          
  END      
 ELSE      
  BEGIN  
SELECT 0 AS ValidationStatus          
  END 

END TRY   
BEGIN CATCH                      
 DECLARE @ERROR VARCHAR(8000)                      
 SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                       
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCValidateImplantableDevices')                       
    + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                        
    + '*****' + CONVERT(VARCHAR,ERROR_STATE())                      
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16,  -- Severity.                      
  1  -- State.                      
 );                   
END CATCH  

END
GO

