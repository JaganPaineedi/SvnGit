IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPCClientGraphData]') AND type in (N'P', N'PC'))
	BEGIN
		DROP  Procedure  [dbo].[ssp_GetPCClientGraphData]
	END

GO

CREATE Procedure [dbo].[ssp_GetPCClientGraphData]
(
	@ClientId INT,
	@HealthDataAttributeId INT,
	@StartDate DATETIME,
	@EndDate DATETIME
)
/********************************************************************************                                                          
-- Stored Procedure: dbo.ssp_GetPCClientGraphData                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: used to get client HealthData for Graph details
--                                                          
-- Updates:                                                                                                                 
-- Date			Author			Purpose                                                          
-- Sep 5,2012	Varinder Verma	Created. 
-- Sep 14,2012	Varinder Verma	Filtered by GraphCriteriaId
-- Sep 18,2012	Varinder Verma	Get graph value by date
-- Oct 10,2012	Varinder Verma	Changed year to Month to show graph 
-- Oct 11,2012	Varinder Verma	Added "AllAges" check to fill colors of graph background
-- Feb-25,2013  Rakesh Garg   Both criteria will be fetched in every case  as Both Criteria is not working in graph
-- OCT 24 2016 Nandita    What : Added "DropdownType,SharedTableName,StoredProcedureName,TextField,ValueField" columns 
--						  Why : Keystone - Customizations > Tasks #51> Flow Sheet: Ability to filter behavior drop down based on client
*********************************************************************************/
AS
BEGIN    
BEGIN TRY 
	DECLARE @Gender CHAR(1), @AGE INT, @FilterGraphCriteriaId INT
	SELECT @Gender = Sex, @AGE = DATEDIFF(day,DOB,GETDATE())/30 FROM Clients WHERE ClientId=@clientId
	
	;WITH HDGCriteira AS(SELECT  HDGC.HealthDataGraphCriteriaId,HDGC.HealthDataAttributeId,HDGC.MinimumValue,HDGC.MaximumValue,
		HDGC.AllAge,HDGC.AgeFrom,HDGC.AgeTo,HDGC.Priority 
		FROM healthdatagraphcriteria HDGC
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDGC.Sex
		WHERE HDGC.HealthDataAttributeId = @HealthDataAttributeId AND ISNULL(HDGC.RecordDeleted,'N')='N'
		AND (HDGC.Sex = CASE WHEN @Gender = 'M' THEN 8142	
							WHEN @Gender = 'F' THEN 8143
						ELSE 8144 END -- Both
				OR HDGC.Sex = 8144) -- Both criteria will be fetched in every case Added by Rakesh as per discussion with Varinder as Both Criteria is not working in graph
		AND (@AGE BETWEEN HDGC.AgeFrom AND HDGC.AgeTo OR HDGC.AllAge ='Y')
		AND HDGC.MinimumValue >= 0 AND HDGC.MaximumValue > 0
		),
		MinPriority AS (
		SELECT MIN(Priority)Priority FROM HDGCriteira
		),
		HDGraphCriteria AS(
		SELECT * FROM HDGCriteira WHERE Priority =(SELECT Priority FROM MinPriority)
		)
	SELECT @FilterGraphCriteriaId = HealthDataGraphCriteriaId FROM HDGraphCriteria
	
	SELECT HealthDataAttributeId, Name,NumbersAfterDecimal,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,SharedTableName,StoredProcedureName,DropdownType,TextField,ValueField
	FROM HealthDataAttributes
	WHERE ISNULL(RecordDeleted,'N')='N'
	
	SELECT HealthDataGraphCriteriaId,HealthDataAttributeId,MinimumValue,MaximumValue,AllAge,AgeFrom,AgeTo,Priority
	FROM HealthDataGraphCriteria 
	WHERE HealthDataGraphCriteriaId = @FilterGraphCriteriaId AND ISNULL(RecordDeleted,'N')='N'

	SELECT HDGCR.HealthDataGraphCriteriaRangeId,HDGCR.HealthDataGraphCriteriaId,HDGCR.Level,HDGCR.MinimumValue,HDGCR.MaximumValue,GC.Color
	FROM HealthDataGraphCriteriaRanges HDGCR	
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDGCR.Level
	WHERE HDGCR.HealthDataGraphCriteriaId = @FilterGraphCriteriaId AND ISNULL(HDGCR.RecordDeleted,'N')='N'
	AND ISNULL(HDGCR.RecordDeleted,'N')='N'
	
	SELECT HealthRecordDate,Value
	FROM ClientHealthDataAttributes
	WHERE HealthDataAttributeId = @HealthDataAttributeId AND ClientId = @ClientId
	AND CAST(HealthRecordDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
	AND ISNULL(RecordDeleted,'N')='N'

END TRY
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetPCClientGraphData')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED     
    
END
GO
