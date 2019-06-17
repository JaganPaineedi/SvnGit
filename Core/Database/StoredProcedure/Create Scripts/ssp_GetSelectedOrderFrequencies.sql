IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSelectedOrderFrequencies]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetSelectedOrderFrequencies]
GO

CREATE PROCEDURE [dbo].[ssp_GetSelectedOrderFrequencies] @OrderId INT
	,@FrequencyName VARCHAR(20)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_GetSelectedOrderFrequencies]              */
/* Creation Date:  17/June/2013                                     */
/* Purpose: To get MedicationNames For orders            */
/* Output Parameters:   */
/*Returns The Table for Order Details  */
/* Called By:                                                       */
/* Data Modifications:                                              */
/*   Updates:                                                       */
/*   Date         Author		Purpose                       */
/*  21/Feb/2014   PPotnuru		Created */
/*  05/Jun/2015   Chethan N		What: For Medication orders filtering out OrderFrequencyTemplates which do not have dispense times
								Why: Phihaven Development task# 310*/
/*	30 Jul 2015	  Chethan N		What: Added new column 'NumberOfDays'
								Why:  Philhaven Development task # 318 */
/*	21 Dec 2015	  Chethan N		What: Removed hardcoded logic to get NumberOfDays
								Why:  Key Point - Environment Issues Tracking task # 151    */	
/********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @Name VARCHAR(50);
		DECLARE @recordsCount INT = 0;
		DECLARE @OrderType INT = 0;
		
		SELECT @OrderType = OrderType FROM Orders WHERE OrderId=@OrderId

		SET @Name = '%' + @FrequencyName + '%'

		CREATE TABLE #TempOrderFrequencies (
			OrderTemplateFrequencyId INT
			,DisplayName VARCHAR(500)
			,NumberofDays CHAR
			);

		INSERT INTO #TempOrderFrequencies
		SELECT OTF.OrderTemplateFrequencyId
			,OTF.DisplayName
			,CASE 
				WHEN CONVERT(FLOAT,GCF.ExternalCode1) < 1 
					THEN CASE 
						WHEN CONVERT(FLOAT,GCF.ExternalCode1)*7 > 1 
							THEN FLOOR(CONVERT(FLOAT,GCF.ExternalCode1)*7) 
						ELSE 1 
						END
				ELSE '0'
				END AS 'NumberofDays'
		FROM OrderFrequencies OFR
		INNER JOIN OrderTemplateFrequencies OTF ON OFR.OrderTemplateFrequencyId = OTF.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GCF ON GCF.GlobalCodeId = OTF.RxFrequencyId
			AND ISNULL(GCF.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(OTF.SelectDays, 'N') = 'Y'
		WHERE OFR.OrderId = @OrderId
			AND (
				ISNULL(OTF.TimesPerDay, - 1) <> - 1
				OR @OrderType <> 8501
				)
			AND ISNULL(OFR.RecordDeleted, 'N') = 'N'

		SELECT @recordsCount = COUNT(*)
		FROM #TempOrderFrequencies

		IF @recordsCount < 1
		BEGIN
			INSERT INTO #TempOrderFrequencies
			SELECT OTF.OrderTemplateFrequencyId
				,OTF.DisplayName
				,CASE 
					WHEN CONVERT(FLOAT,GCF.ExternalCode1) < 1 
						THEN CASE 
							WHEN CONVERT(FLOAT,GCF.ExternalCode1)*7 > 1 
								THEN FLOOR(CONVERT(FLOAT,GCF.ExternalCode1)*7) 
							ELSE 1 
							END
					ELSE '0'
					END AS 'NumberofDays'
			FROM OrderTemplateFrequencies OTF
		LEFT JOIN GlobalCodes GCF ON GCF.GlobalCodeId = OTF.RxFrequencyId  
			AND ISNULL(GCF.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(OTF.SelectDays,'N')='Y'
			WHERE ISNULL(OTF.RecordDeleted, 'N') = 'N'
			AND (ISNULL(OTF.TimesPerDay,-1) <> -1 OR @OrderType <> 8501)
		END

		SELECT OrderTemplateFrequencyId
			,DisplayName
			,NumberofDays
		FROM #TempOrderFrequencies
		WHERE DisplayName LIKE @Name

		DROP TABLE #TempOrderFrequencies
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetSelectedOrderFrequencies') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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
GO

