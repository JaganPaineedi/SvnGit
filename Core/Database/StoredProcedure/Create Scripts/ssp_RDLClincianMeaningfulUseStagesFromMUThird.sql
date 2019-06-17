IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClincianMeaningfulUseStagesFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClincianMeaningfulUseStagesFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO      
      
      
CREATE PROCEDURE [dbo].[ssp_RDLClincianMeaningfulUseStagesFromMUThird]      
      
/********************************************************************************          
-- Stored Procedure: dbo.ssp_RDLClincianMeaningfulUseStages            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date   Author  Purpose          
-- 15-Oct-2017  Gautam  What:ssp  for Multiple Clinician meaningful report Report.                
--        Why:Meaningful Use - Stage 3 > Tasks #64 > Stage 3 Reports     
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
 SELECT CodeName,GlobalCodeId,SortOrder  from  Globalcodes where category='MEANINGFULUSESTAGES' and ISNULL(RecordDeleted,'N')='N'       
 AND GlobalCodeId not in (8766,8767,9373)      
 order by SortOrder    
    
 END TRY      
  BEGIN CATCH      
    DECLARE @error varchar(8000)      
      
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'      
    + CONVERT(varchar(4000), ERROR_MESSAGE())      
    + '*****'      
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),      
    'ssp_RDLClincianMeaningfulUseStagesFromMUThird')      
    + '*****' + CONVERT(varchar, ERROR_LINE())      
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())      
    + '*****' + CONVERT(varchar, ERROR_STATE())      
      
    RAISERROR (@error,-- Message text.      
    16,-- Severity.      
    1 -- State.      
    );      
  END CATCH      
END 