      
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClincianMeaningfulUseStages]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClincianMeaningfulUseStages]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO     
      
CREATE PROCEDURE [dbo].[ssp_RDLClincianMeaningfulUseStages]      
      
/********************************************************************************          
-- Stored Procedure: dbo.ssp_RDLClincianMeaningfulUseStages            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date    Author   Purpose          
-- 16-Jul-2014  Revathi  What:ssp  for Multiple Clinician meaningful report Report.                
--        Why:task #25.3 MeaningFul Use      
*********************************************************************************/       
AS      
BEGIN      
 BEGIN TRY      
 DECLARE @MeaningfulUseStageLevel VARCHAR(10)        
 SELECT TOP 1 @MeaningfulUseStageLevel = Value      
   FROM SystemConfigurationKeys      
   WHERE [key] = 'MeaningfulUseStageLevel'      
    AND ISNULL(RecordDeleted, 'N') = 'N'      
          
       
 --SELECT CodeName,GlobalCodeId from  Globalcodes where category='MEANINGFULUSESTAGES' and ISNULL(RecordDeleted,'N')='N' AND GlobalCodeId=@MeaningfulUseStageLevel      
 --union all      
 SELECT CodeName,GlobalCodeId from  Globalcodes where category='MEANINGFULUSESTAGES' AND GlobalCodeId not in (8768,9476,9477,9480,9481)   -- Stage3      
  and ISNULL(RecordDeleted,'N')='N' Order by CodeName       
 END TRY      
  BEGIN CATCH      
    DECLARE @error varchar(8000)      
      
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'      
    + CONVERT(varchar(4000), ERROR_MESSAGE())      
    + '*****'      
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),      
    'ssp_RDLClincianMeaningfulUseStages')      
    + '*****' + CONVERT(varchar, ERROR_LINE())      
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())      
    + '*****' + CONVERT(varchar, ERROR_STATE())      
      
    RAISERROR (@error,-- Message text.      
    16,-- Severity.      
    1 -- State.      
    );      
  END CATCH      
END		