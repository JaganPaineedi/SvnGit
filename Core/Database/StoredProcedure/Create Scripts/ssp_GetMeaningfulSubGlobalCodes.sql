IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMeaningfulSubGlobalCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMeaningfulSubGlobalCodes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetMeaningfulSubGlobalCodes] @GlobalCodeId INT
	/********************************************************************************    
-- Stored Procedure: dbo.ssp_GetMeaningfulSubGlobalCodes      
--   
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 30-Jul-2014	 Revathi		What:GetMeaningfulSubGlobalCodes.          
--								Why:task #25.3 MeaningFul Use
*********************************************************************************/
AS
BEGIN

DECLARE @MeaningfulUseStageLevel VARCHAR(10)

 SELECT TOP 1 @MeaningfulUseStageLevel = Value
	FROM SystemConfigurationKeys
	WHERE [key] = 'MeaningfulUseStageLevel'
	AND ISNULL(RecordDeleted, 'N') = 'N'
	
	SELECT GS.GlobalSubCodeId
		,GS.SubCodeName
	FROM GlobalSubCodes GS
	LEFT  JOIN MeaningfulUseMeasureTargets MU ON MU.MeasureSubType=GS.GlobalSubCodeId
	WHERE GS.GlobalCodeId = @GlobalCodeId AND  MU.Stage=@MeaningfulUseStageLevel
		AND ISNULL(GS.RecordDeleted, 'N') = 'N' 
	
	UNION
	
	SELECT 0 AS GlobalSubCodeId
		,'No Measure Sub Type' AS SubCodeName
END
GO


