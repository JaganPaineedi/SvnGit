 /****** Object:  StoredProcedure [dbo].[ssp_GetSmartViewGraphDetails]    Script Date: 10/17/2017 15:02:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSmartViewGraphDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSmartViewGraphDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSmartViewGraphDetails] 2000001   Script Date: 10/17/2017 15:02:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[ssp_GetSmartViewGraphDetails]        
(                      
  @ClientId int                                      
)                      
as                  
/******************************************************************************                        
**  File: ssp_GetSmartViewGraphDetails.sql                       
**  Name: ssp_GetSmartViewGraphDetails   940
**  Desc: To Retrive SmartView Panel Data.                  
**  Return values:                        
**  Parameters:                     
**  Auth: Manjunath K                        
**  Date: 28 Sep 2017             
*******************************************************************************                        
**  Change History                        
*******************************************************************************        
**  Date:			Author:			Description:                        
**  ---------		--------		-------------------------------------------                        
**  27/Jul/2018		Chethan N		What : Modified logic to get Vitals.
									Why : Engineering Improvement Initiatives- NBL(I) task #599
*************************************************************************************/                      
BEGIN                     
                
BEGIN TRY

	DECLARE @BMI VARCHAR(20)

	CREATE TABLE #ClientVital (
		VitalDate DATETIME
		,BP VARCHAR(20)
		,BMI VARCHAR(20)
		,Weight VARCHAR(20)
		,Height VARCHAR(20)
		)

	INSERT INTO #ClientVital
	EXEC ssp_GetVitalsClientSmartView @ClientId

	SELECT TOP 1 @BMI = ISNULL(BMI, 0.0)
	FROM #ClientVital

	DECLARE @ClientWeights VARCHAR(1000) = ''

	SELECT @ClientWeights = @ClientWeights + CASE 
			WHEN IsNull(@ClientWeights, '') <> ''
				THEN ','
			ELSE ''
			END + '''' + (
			CASE 
				WHEN IsNull(VitalDate, '') <> ''
					THEN CONVERT(VARCHAR(10), ISNULL(VitalDate, ''), 101) + ':'
				ELSE ''
				END + ISNULL([Weight], '')
			) + ''''
	FROM #ClientVital

	SELECT @ClientId AS ClientId
		,@BMI AS BMI
		,@ClientWeights AS ClientWeights

END TRY                                                                                    
BEGIN CATCH                                        
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                 
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                
'ssp_GetSmartViewGraphDetails')                                                                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                                                
 RAISERROR                                                                                       
 (                                                                                     
  @Error, -- Message text.                                                                                                       
  16, -- Severity.                                                                                                                  
  1 -- State.                                           
 );                                                                                                                
END CATCH                  
end
GO
