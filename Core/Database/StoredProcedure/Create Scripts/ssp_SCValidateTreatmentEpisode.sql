IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateTreatmentEpisode]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCValidateTreatmentEpisode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCValidateTreatmentEpisode] @CurrentUserId INT
 ,@ScreenKeyId INT
 AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCValidateTreatmentEpisode] 550,1   */
/* Date              Author                  Purpose                 */
/* 4/17/2015        Sunil.D             SC: Treatment Episode New Screen and Banner not Client Episode
											Thresholds - Support  #828                       */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */
/*	08/25/2017	MJensen		Correct typo in error message Thresholds-Enhancements #828.1	*/

BEGIN 
BEGIN TRY     
DECLARE @DocumentType VARCHAR(10) 
DECLARE @ClientId INT 
set @ClientId=(SELECT ClientId FROM  TreatmentEpisodes where   TreatmentEpisodeId=@ScreenKeyId )
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
	SELECT 'TreatmentEpisodes', 'TreatmentEpisodeType', 'General - Treatment Episode - Type is required ' ,1,1
		FROM TreatmentEpisodes  
	WHERE isnull(TreatmentEpisodeType,'') = ''   and TreatmentEpisodeId=@ScreenKeyId 
UNION  
	SELECT 'TreatmentEpisodes', 'ServiceAreaId', 'General - Treatment Episode - Service Area is required ',1 ,2 
		FROM TreatmentEpisodes  
	WHERE isnull(ServiceAreaId,'') = ''   and TreatmentEpisodeId=@ScreenKeyId 
UNION   
	 SELECT 'TreatmentEpisodes', 'TreatmentEpisodeStatus', 'General - Treatment Episode - Status is required ',1 ,3 
		FROM TreatmentEpisodes  
	WHERE isnull(TreatmentEpisodeStatus,'') = ''   and TreatmentEpisodeId=@ScreenKeyId 
	
	declare @RegistrationDate datetime=(SELECT RegistrationDate FROM  TreatmentEpisodes where   TreatmentEpisodeId=@ScreenKeyId )
 	
	 if (@RegistrationDate >0)
	 begin
 			IF EXISTS (SELECT SystemConfigurationKeyId FROM systemconfigurationkeys WHERE (RecordDeleted IS NULL OR RecordDeleted = 'N') and Value='Y' and [Key] ='REQUIRECLIENTEPISODEFORTXEPISODE' )   
			BEGIN  
					 
							IF Not  EXISTS (SELECT ClientEpisodeId FROM ClientEpisodes where (RecordDeleted IS NULL OR RecordDeleted = 'N') and ClientId=@ClientId and  @RegistrationDate between RegistrationDate and ISNULL(DischargeDate,GETDATE()))
							begin
										Insert	INTO  
										@validationReturnTable  
										(  
												TableName,  ColumnName, ErrorMessage,TabOrder,ValidationOrder 
										)  
												SELECT 'TreatmentEpisodes', 'RegistrationDate', 'Require that treatment episode should fall within an open episode period' ,1,1
												 
								end 
						 
						 
						 
				end
	end
	
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
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCValidateTreatmentEpisode')                       
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

