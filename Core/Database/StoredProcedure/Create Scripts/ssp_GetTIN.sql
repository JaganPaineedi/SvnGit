IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTIN]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetTIN]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
              
CREATE PROCEDURE [dbo].[ssp_GetTIN]            
(@Stage VARCHAR(10)  ,      
@InPatient  int=0      
)                
AS                
 /******************************************************************************                
**  File: ssp_GetTIN.sql                
**  Name: ssp_GetTIN   9476              
**  Desc: Get all TIN from Locations                
**                
**  Return values: <Return Values>                
**                
**  Called by: <Code file that calls>                
**                
**  Parameters:                
**  Input   Output                
**  ServiceId      -----------                
**                
**  Created By: Gautam              
**  Date:  Oct 16 2017                
*******************************************************************************                
**  Change History                
*******************************************************************************                
-- Updates:                                                                         
-- Date   Author  Purpose                  
-- 15-Oct-2017  Gautam  What:ssp  to get TaxIdentificationNumber from Locations.                        
--        Why:task MeaningFul Use Stage3             
*********************************************************************************/                  
BEGIN                
 BEGIN TRY            
         
        
   If @InPatient=0      
   begin      
 SELECT 'NA' AS  TaxIdentificationNumber WHERE  @Stage=8766 --Stage1        
 UNION        
 SELECT 'NA' AS  TaxIdentificationNumber WHERE  @Stage=8767 --Stage2        
   UNION            
 SELECT 'NA' AS  TaxIdentificationNumber WHERE  @Stage=8768  -- Stage 3         
 UNION         
 SELECT 'NA' AS  TaxIdentificationNumber WHERE  @Stage=9373   --Stage2 – Modified        
  UNION              
  SELECT  ISNULL(L.TaxIdentificationNumber ,'NA')  AS TaxIdentificationNumber           
  FROM Locations AS L                
  WHERE isnull(L.RecordDeleted,'N')='N'             
  AND (                
       @Stage = 9476  --MeaningFulUseStages ACI Transition               
                   
       OR @Stage = 9477    --MeaningFulUseStages Group ACI Transition        
       OR @Stage = 9480    
       OR @Stage = 9481      
       )               
  --ORDER BY L.TaxIdentificationNumber              
  end      
  else      
  begin      
  SELECT 'NA' AS  TaxIdentificationNumber WHERE @Stage in (8766,8767,8768,9373,9476,9477)      
  end      
 END TRY                
                
 BEGIN CATCH                
  DECLARE @Error VARCHAR(8000)                
                
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' +              
   ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetTIN') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) +              
    '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                
                
  RAISERROR (                
    @Error                
    ,-- Message text.                
    16                
    ,-- Severity.                
    1 -- State.                
    );                
 END CATCH                
                
 RETURN                
END 