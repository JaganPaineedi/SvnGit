 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClinicianMeaningfulGlobalCodes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClinicianMeaningfulGlobalCodes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_GetClinicianMeaningfulGlobalCodes] @InPatient BIT              
 ,@Stage VARCHAR(10) = NULL              
 /********************************************************************************                      
-- Stored Procedure: dbo.ssp_GetMeaningfulGlobalCodes                        
--                     
-- Copyright: Streamline Healthcate Solutions                   
--                      
-- Updates:                                                                             
-- Date   Author   Purpose                      
-- 23-may-2014  Revathi  What:GetMeaningfulGlobalCodes.                            
--      Why:task #26 MeaningFul Use                  
-- 11-Jan-2016  Ravi     What : Change the code for Stage 9373 'Stage2 - Modified' requirement              
       why : Meaningful Use, Task #66 - Stage 2 - Modified                 
*********************************************************************************/              
AS              
BEGIN              
 DECLARE @MeaningfulUseStageLevel VARCHAR(10)              
              
 IF @Stage IS NULL              
 BEGIN              
  SELECT TOP 1 @MeaningfulUseStageLevel = Value              
  FROM SystemConfigurationKeys              
  WHERE [key] = 'MeaningfulUseStageLevel'              
   AND ISNULL(RecordDeleted, 'N') = 'N'              
 END              
 ELSE              
 BEGIN              
  SET @MeaningfulUseStageLevel = @Stage              
 END              
              
 IF @InPatient = 1              
 BEGIN              
             
  IF (@MeaningfulUseStageLevel = 8768  or @MeaningfulUseStageLevel = 9476  or @MeaningfulUseStageLevel = 9477  )            
  BEGIN              
   SELECT DISTINCT MU.DisplayWidgetNameAs AS CodeName              
    ,MU.MeasureType AS GlobalCodeId              
   FROM MeaningfulUseMeasureTargets MU              
   WHERE MU.Stage = @MeaningfulUseStageLevel              
    AND isnull(mu.Target, 0) > 0              
    AND MU.MeasureType IN (              
     8698  ,8683,8710,9478,8700,9479,8699,8680 ,8697,8703        
     )              
   ORDER BY MU.MeasureType              
  END              
  IF @MeaningfulUseStageLevel = 8766              
  BEGIN              
   SELECT DISTINCT MU.DisplayWidgetNameAs AS CodeName              
    ,MU.MeasureType AS GlobalCodeId              
   FROM MeaningfulUseMeasureTargets MU              
   WHERE MU.Stage = @MeaningfulUseStageLevel              
    AND isnull(mu.Target, 0) > 0              
    AND MU.MeasureType IN (              
     8707              
     ,8709              
     ,8680              
     ,8686              
     ,8688              
     ,8694              
     ,8697              
     ,8698              
     ,8699              
     ,8700              
     ,8687              
     ,8682              
     ,8704              
     ,8705              
     ,8706              
     ,8708              
     ,8684              
     ,8685              
     )              
   ORDER BY MU.MeasureType              
  END              
              
  IF @MeaningfulUseStageLevel = 8767              
  BEGIN              
   SELECT DISTINCT MU.DisplayWidgetNameAs AS CodeName              
    ,MU.MeasureType AS GlobalCodeId              
   FROM MeaningfulUseMeasureTargets MU              
   WHERE MU.Stage = @MeaningfulUseStageLevel              
    AND isnull(mu.Target, 0) > 0              
    AND MU.MeasureType IN (              
     8707              
     ,8709              
     ,8680              
     ,8686              
     ,8688              
     ,8694              
     ,8697              
     ,8698              
     ,8699              
     ,8700              
     ,8687              
     ,8682              
     ,8683              
     ,8704              
     ,8705              
     ,8706              
     ,8708              
     ,8684              
     ,8685              
     )              
   ORDER BY MU.MeasureType              
  END              
-- 11-Jan-2016 Ravi               
  IF (@MeaningfulUseStageLevel = 9373 OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481)             
  BEGIN              
   SELECT DISTINCT MU.DisplayWidgetNameAs AS CodeName              
    ,MU.MeasureType AS GlobalCodeId              
   FROM MeaningfulUseMeasureTargets MU              
   WHERE MU.Stage = @MeaningfulUseStageLevel              
    AND isnull(mu.Target, 0) > 0              
    AND MU.MeasureType IN (              
     8680              
     ,8682 ,8710             
     ,8683           
     ,8687              
     ,8686              
     ,8688              
     ,8694              
     ,8697              
     ,8697              
     ,8698              
     ,8699              
     ,8700              
     ,8707              
     ,8708              
     ,8709              
     ,8708             )              
   ORDER BY MU.MeasureType              
  END              
 END              
 ELSE              
 BEGIN              
  SELECT DISTINCT MU.DisplayWidgetNameAs AS CodeName              
   ,MU.MeasureType AS GlobalCodeId              
  FROM MeaningfulUseMeasureTargets MU              
  WHERE MU.Stage = @MeaningfulUseStageLevel              
   AND isnull(mu.Target, 0) > 0              
   AND MU.MeasureType NOT IN (              
    8707              
    ,8709              
    ,8708              
    )              
  ORDER BY MU.MeasureType              
 END              
END 