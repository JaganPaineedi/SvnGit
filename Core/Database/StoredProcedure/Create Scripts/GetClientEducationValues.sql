/****** Object:  UserDefinedFunction [dbo].[GetClientEducationValues]    Script Date: 10/02/2017 13:45:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[GetClientEducationValues]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[GetClientEducationValues]
GO

/****** Object:  UserDefinedFunction [dbo].[GetClientEducationValues]    Script Date: 10/02/2017 13:45:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------  
--Modifiedby :Shruthi.S  
--Date       :1/21/2014  
--Purpose : Added a parameter ParameterType to get the healthdataelement and healthdatasub template based on parametertype.Ref :#5 Meaningful Use.  
/*       Date              Author                  Purpose                   */
/*		 10/2/17		Shankha B				Added @ClientEducationResourcerId to the where clause*/
--------------------------------------------------------------  
CREATE FUNCTION [dbo].[GetClientEducationValues] (
	@InformationType CHAR(1)
	,@ClientEducationResourcerId INT
	,@AllMedication CHAR(1)
	,@AllDiagnosis CHAR(1)
	,@CERParameterType INT
	)
RETURNS VARCHAR(8000)
AS
-- Description:     
--    
-- Created by: Karan Garg    
-- Created on: July 27 2011    
BEGIN
	DECLARE @value VARCHAR(8000)

	IF (@InformationType = 'M')
	BEGIN
		IF (@AllMedication = 'Y')
		BEGIN
			SET @value = 'All'
		END
		ELSE IF (@AllMedication = 'N')
		BEGIN
			SELECT @value = COALESCE(@value + ', ', '') + CAST(MedicationName AS VARCHAR(100))
			FROM MDMedicationNames MD
			INNER JOIN EducationResourceMedications CERM ON CERM.MedicationNameId = MD.MedicationNameId
				AND CERM.EducationResourceId = @ClientEducationResourcerId
				AND ISNULL(CERM.RecordDeleted, 'N') = 'N'
		END
	END
	ELSE IF (@InformationType = 'D')
	BEGIN
		IF (@AllDiagnosis = 'Y')
		BEGIN
			SET @value = 'All'
		END
		ELSE IF (@AllDiagnosis = 'N')
		BEGIN
			SELECT @value = COALESCE(@value + ', ', '') + CAST(ICDDescription AS VARCHAR(100))
			FROM EducationResourceDiagnoses CERD
			WHERE ISNULL(CERD.RecordDeleted, 'N') = 'N'
				AND CERD.EducationResourceId = @ClientEducationResourcerId
		END
	END
	ELSE IF (@InformationType = 'H')
		--AND @CERParameterType = 6309  
	BEGIN
		SELECT @value = COALESCE(@value + ', ', '') + CAST(NAME AS VARCHAR(100))
		FROM HealthDataAttributes HD
		INNER JOIN EducationResourceHealthDataElements CERH ON CERH.HealthParameterValue = HD.HealthDataAttributeId
			AND CERH.EducationResourceId = @ClientEducationResourcerId
			AND ISNULL(CERH.RecordDeleted, 'N') = 'N'
	END
	ELSE IF (@InformationType = 'O')
	BEGIN
		SELECT @value = COALESCE(@value + ', ', '') + CAST(OrderName AS VARCHAR(100))
		FROM Orders O
		INNER JOIN EducationResourceOrders CERO ON CERO.OrderId = O.OrderId
			AND CERO.EducationResourceId = @ClientEducationResourcerId
			AND ISNULL(CERO.RecordDeleted, 'N') = 'N'
	END
	ELSE IF (@InformationType = 'T')
	BEGIN
		SELECT @value = COALESCE(@value + ', ', '') + CAST(TemplateName AS VARCHAR(100))
		FROM HealthMaintenanceTemplates HT
		INNER JOIN EducationResourceHealthMaintenanceTemplates EHMT ON EHMT.HealthMaintenanceTemplateId = HT.HealthMaintenanceTemplateId
			AND EHMT.EducationResourceId = @ClientEducationResourcerId
			AND ISNULL(EHMT.RecordDeleted, 'N') = 'N'
	END
	ELSE IF (
			@InformationType = 'H'
			AND @CERParameterType = 6310
			)
	BEGIN
		SET @value = (
				SELECT DISTINCT (HDST.NAME) AS CategoryName
				FROM HealthDataSubTemplates HDST
				INNER JOIN HealthDataTemplateAttributes HDTA ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
					AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
					AND ISNULL(HDTA.RecordDeleted, 'N') = 'N'
				INNER JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId
					AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
				INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDST.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId
					AND ISNULL(HDSTA.RecordDeleted, 'N') = 'N'
				INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
					AND ISNULL(HDA.RecordDeleted, 'N') = 'N'
				)
	END

	RETURN @value
END
GO


