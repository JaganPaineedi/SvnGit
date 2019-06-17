IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMeaningfulGlobalCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMeaningfulGlobalCodes]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetMeaningfulGlobalCodes]
	/********************************************************************************    
-- Stored Procedure: dbo.ssp_GetMeaningfulGlobalCodes      
--   
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 23-may-2014	 Revathi		What:GetMeaningfulGlobalCodes.          
--								Why:task #26 MeaningFul Use
*********************************************************************************/
AS
BEGIN

		
DECLARE @MeaningfulUseStageLevel VARCHAR(10)
	
SELECT TOP 1 @MeaningfulUseStageLevel = Value
	FROM SystemConfigurationKeys
	WHERE [key] = 'MeaningfulUseStageLevel'
	AND ISNULL(RecordDeleted, 'N') = 'N'
	
	
	SELECT Distinct MU.DisplayWidgetNameAs as CodeName,
	MU.MeasureType as GlobalCodeId
	FROM MeaningfulUseMeasureTargets MU
	where MU.Stage=@MeaningfulUseStageLevel and isnull(mu.Target,0)>0
	order by MU.MeasureType
END

	
GO


