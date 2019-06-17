/****** Object:  StoredProcedure [dbo].[smsp_GetQuantity]    Script Date: 09/27/2017 15:44:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetQuantity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetQuantity]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetQuantity]    Script Date: 09/27/2017 15:44:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetQuantity] @ClientId INT =null
, @Text VARCHAR(100) =null
, @Type VARCHAR(100) =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX) OUTPUT
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Patient details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)     
/*      
 Author			Modified Date			Reason     
*/
-- ============================================= 
AS
BEGIN
	BEGIN TRY	 
		
		IF(@Text = 'StudiesSummaryReferenceRangeLow')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		ELSE IF(@Text = 'StudiesSummaryReferenceRangeHigh')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		END
		ELSE IF(@Text = 'StudiesSummaryReferenceRangeAgeLow')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		ELSE IF(@Text = 'StudiesSummaryReferenceRangeAgeHigh')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		ELSE IF(@Text = 'CurrentMedicationsPackageContentAmount')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		 ELSE IF(@Text = 'VitalSignsValueQuantity')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		ELSE IF(@Text = 'ImmunizationsDoseQuantity')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		 ELSE IF(@Text = 'PlanOfTreatmentActivityDetailDailyAmount')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		 ELSE IF(@Text = 'PlanOfTreatmentActivityDetailQuantity')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		 ELSE IF(@Text = 'GoalsTargetDetailQuantity')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		 ELSE IF(@Text = 'CurrentMedicationsIngredientAmountNumerator')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		 ELSE IF(@Text = 'CurrentMedicationsIngredientAmountDenominator')
		BEGIN
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT c.ClientId
						,'' AS Value	--Numerical value (with implicit precision)
						,'' AS Comparator	--< | <= | >= | > - how to understand the value
						,'' AS Unit		--Unit representation
						,'' AS [System]	--C? System that defines coded unit form
						,'' AS Code		-- Coded form of the unit
				FROM Clients c
				INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = c.MaritalStatus
				WHERE c.ClientId = @ClientId				
				FOR XML path
					,root
				))										
		 END
		 
		 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetQuantity') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END

GO


