 /****** Object:  StoredProcedure [dbo].[ssp_GetVitalsClientSmartView]    Script Date: 10/17/2017 15:02:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetVitalsClientSmartView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetVitalsClientSmartView]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetVitalsClientSmartView] 2000001   Script Date: 10/17/2017 15:02:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

               
CREATE proc [dbo].[ssp_GetVitalsClientSmartView]        
(                      
  @ClientId int
)                      
as                  
/******************************************************************************                        
**  File: ssp_GetVitalsClientSmartView.sql                       
**  Name: ssp_GetVitalsClientSmartView   940
**  Desc: To Retrive SmartView Panel Data.                  
**  Return Values:                        
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
 
 	CREATE TABLE #ClientVitals (
	VitalDate DATETIME
	,Diastolic VARCHAR(20)
	,Systolic VARCHAR(20)
	,BMI VARCHAR(20)
	,Weight VARCHAR(20)
	,Height VARCHAR(20)
	)

	--DROP TABLE #tempvitals
	CREATE TABLE #tempvitals (
		RowId INT PRIMARY KEY IDENTITY(1, 1)
		,HealthDataTemplateId INT
		,HealthDataSubTemplateId INT
		,HealthDataAttributeId INT
		,SubTemplateName VARCHAR(100)
		,AttributeName VARCHAR(100)
		,Value VARCHAR(50)
		,HealthRecordDate DATETIME
		,ClientHealthDataAttributeId INT
		,DataType INT
		)

	INSERT INTO #tempvitals
	SELECT HDTA.HealthDataTemplateId
		,HDTA.HealthDataSubTemplateId
		,HDSTA.HealthDataAttributeId
		,HDST.NAME
		,HDA.NAME
		,CHDA.Value
		,CHDA.HealthRecordDate
		,CHDA.ClientHealthDataAttributeId
		,HDA.DataType
	FROM HealthDataTemplateAttributes HDTA
	INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDTA.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId
	INNER JOIN HealthDataSubTemplates HDST ON HDTA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId
	INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
	INNER JOIN ClientHealthDataAttributes CHDA ON CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
	WHERE HDTA.HealthDataTemplateId = 110
		AND Isnull(HDTA.RecordDeleted, 'N') = 'N'
		AND CHDA.Clientid = @ClientId
		AND CHDA.HealthRecordDate IN (
			SELECT DISTINCT TOP 3 HealthRecordDate
			FROM ClientHealthDataAttributes TCHDA
			INNER JOIN HealthDataAttributes THDA ON THDA.HealthDataAttributeId = TCHDA.HealthDataAttributeId
				AND THDA.Name IN (
					'Weight'
					,'Height'
					,'BMI'
					,'CalculatedBMI'
					,'Diastolic'
					,'Systolic'
					)
			WHERE TCHDA.Clientid = @ClientId
				AND ISNULL(TCHDA.RecordDeleted, 'N') = 'N'
			ORDER BY HealthRecordDate DESC
			)
		AND Isnull(HDSTA.RecordDeleted, 'N') = 'N'
		AND Isnull(HDST.RecordDeleted, 'N') = 'N'
		AND Isnull(HDA.RecordDeleted, 'N') = 'N'
		AND Isnull(CHDA.RecordDeleted, 'N') = 'N'
		AND HDA.Name IN (
			'Weight'
			,'Height'
			,'BMI'
			,'CalculatedBMI'
			,'Diastolic'
			,'Systolic'
			)

	INSERT INTO #ClientVitals (VitalDate)
	SELECT DISTINCT HealthRecordDate
	FROM #tempvitals

	UPDATE C
	SET Diastolic = t.Value
	FROM #tempvitals t
	INNER JOIN #ClientVitals C ON C.VitalDate = t.HealthRecordDate
	WHERE t.AttributeName = 'Diastolic'

	UPDATE C
	SET Systolic = t.Value
	FROM #tempvitals t
	INNER JOIN #ClientVitals C ON C.VitalDate = t.HealthRecordDate
	WHERE t.AttributeName = 'Systolic'

	UPDATE C
	SET BMI = t.Value
	FROM #tempvitals t
	INNER JOIN #ClientVitals C ON C.VitalDate = t.HealthRecordDate
	WHERE (t.AttributeName = 'BMI' OR t.AttributeName = 'CalculatedBMI')

	UPDATE C
	SET [Weight] = t.Value
	FROM #tempvitals t
	INNER JOIN #ClientVitals C ON C.VitalDate = t.HealthRecordDate
	WHERE t.AttributeName = 'Weight'

	UPDATE C
	SET Height = t.Value
	FROM #tempvitals t
	INNER JOIN #ClientVitals C ON C.VitalDate = t.HealthRecordDate
	WHERE t.AttributeName = 'Height'

	SELECT TOP 3 CONVERT(VARCHAR(10), VitalDate, 101) AS HealthRecordDate
		,Systolic + '/' + Diastolic AS 'SBP/DBP'
		,BMI
		,[Weight]
		,Height
	FROM #CLIENTVITALS
	WHERE VitalDate IS NOT NULL
	ORDER BY HealthRecordDate DESC

	DROP TABLE #ClientVitals

	DROP TABLE #tempvitals
	
END TRY                                                                                    
BEGIN CATCH                                        
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                 
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                
'ssp_GetVitalsClientSmartView')                                                                                                                   
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
