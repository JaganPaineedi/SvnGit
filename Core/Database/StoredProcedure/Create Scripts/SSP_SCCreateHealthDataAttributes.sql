/****** Object:  StoredProcedure [dbo].[SSP_SCCreateHealthDataAttributes]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCCreateHealthDataAttributes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCCreateHealthDataAttributes]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCCreateHealthDataAttributes]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCCreateHealthDataAttributes] @HealthDataAttributeName VARCHAR(MAX)
	,@HealthDataSubTemplateId INT
	,@Identifier VARCHAR(100)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Dec 03, 2015   
-- Description: Create HealthDataAttribute and link with HealthDataSubtemplate.
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	DECLARE @TranName VARCHAR(25) = 'CreateHealthDataAttribute'

	BEGIN TRY
		IF (
				NOT EXISTS (
					SELECT 1
					FROM HealthDataAttributes HDA
					INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
					WHERE ISNULL(HDA.RecordDeleted, 'N') = 'N'
						AND ISNULL(HDSTA.RecordDeleted, 'N') = 'N'
						AND HDSTA.HealthDataSubTemplateId = @HealthDataSubTemplateId
						AND (
							HDA.LoincCode IN (@Identifier)
							OR HDA.AlternativeName1 = @Identifier
							OR HDA.AlternativeName2 = @Identifier
							OR HDA.AlternativeName3 = @Identifier
							OR HDA.AlternativeName4 = @Identifier
							OR HDA.AlternativeName5 = @Identifier
							OR HDA.AlternativeName5 = @Identifier
							)
					)
				)
		BEGIN
			DECLARE @HealthDataAttributeId INT

			BEGIN TRANSACTION @TranName

			INSERT INTO HealthDataAttributes (
				Category
				,DataType
				,NAME
				,Description
				,LOINCCode
				)
			VALUES (
				8229 -- Education
				,8084 -- Character
				,@HealthDataAttributeName
				,@HealthDataAttributeName
				,@Identifier
				)

			SET @HealthDataAttributeId = SCOPE_IDENTITY()

			INSERT INTO HealthDataSubTemplateAttributes (
				HealthDataSubTemplateId
				,HealthDataAttributeId
				,DisplayInFlowSheet
				,OrderInFlowSheet
				,IsSingleLineDisplay
				)
			VALUES (
				@HealthDataSubTemplateId
				,@HealthDataAttributeId
				,'Y'
				,1
				,'N'
				)

			COMMIT TRANSACTION @TranName
		END
		ELSE
		BEGIN		
			UPDATE HDA
			SET Name = @HealthDataAttributeName, [Description]= @HealthDataAttributeName ,LOINCCode = @Identifier
			FROM HealthDataAttributes HDA
			INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
					WHERE ISNULL(HDA.RecordDeleted, 'N') = 'N'
						AND ISNULL(HDSTA.RecordDeleted, 'N') = 'N'
						AND HDSTA.HealthDataSubTemplateId = @HealthDataSubTemplateId
						AND (
							HDA.LoincCode IN (@Identifier)
							OR HDA.AlternativeName1 = @Identifier
							OR HDA.AlternativeName2 = @Identifier
							OR HDA.AlternativeName3 = @Identifier
							OR HDA.AlternativeName4 = @Identifier
							OR HDA.AlternativeName5 = @Identifier
							OR HDA.AlternativeName5 = @Identifier
							)
		END
	END TRY

	BEGIN CATCH
		IF EXISTS (
				SELECT 1
				FROM Sys.dm_tran_active_transactions
				WHERE NAME = @TranName
				)
			ROLLBACK TRANSACTION @TranName

		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'Failed to create HealthDataAttributes from SSP_SCCreateHealthDataAttributes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


