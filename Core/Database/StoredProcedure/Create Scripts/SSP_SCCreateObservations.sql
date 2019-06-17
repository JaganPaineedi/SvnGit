/****** Object:  StoredProcedure [dbo].[SSP_SCCreateObservations]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCCreateObservations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCCreateObservations]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCCreateObservations]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCCreateObservations] @ObservationName VARCHAR(MAX)
	,@Identifier VARCHAR(100)
	,@Range VARCHAR(100)
	,@Unit VARCHAR(MAX)
	,@CurrentObservationNode XML
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
	DECLARE @TranName VARCHAR(25) = 'CreateObservation'
	DECLARE @ValueType VARCHAR(MAX)
	DECLARE @ObservationNameCodingSystem VARCHAR(MAX)
	DECLARE @ObservationNameAltIdentifier VARCHAR(MAX)
	DECLARE @ObservationNameAltText VARCHAR(MAX)
	DECLARE @ObservationNameAltCodingSystem VARCHAR(MAX)
	
	SELECT @ValueType = m.c.value('OBX.2[1]/OBX.2.0[1]/ITEM[1]', 'nvarchar(max)')
			,@ObservationNameCodingSystem = m.c.value('OBX.3[1]/OBX.3.2[1]/ITEM[1]', 'nvarchar(max)')
			,@ObservationNameAltIdentifier = m.c.value('OBX.3[1]/OBX.3.4[1]/ITEM[1]', 'nvarchar(max)')
			,@ObservationNameAltText = m.c.value('OBX.3[1]/OBX.3.4[1]/ITEM[1]', 'nvarchar(max)')
			,@ObservationNameAltCodingSystem = m.c.value('OBX.3[1]/OBX.3.5[1]/ITEM[1]', 'nvarchar(max)')			
	FROM @CurrentObservationNode.nodes('OBX') AS m(c)

	
	BEGIN TRY
		BEGIN TRANSACTION @TranName
		
		IF (
				NOT EXISTS (
					SELECT 1
					FROM Observations O
					WHERE ISNULL(O.RecordDeleted, 'N') = 'N' AND O.ObservationName = @ObservationName AND ObservationMethodIdentifier = @Identifier
					)
				)
		BEGIN
			INSERT INTO Observations (
				ObservationName
				,ObservationMethodIdentifier
				--,LOINCCode
				,[Range]
				,Unit
				,ValueType
				,ObservationNameCodingSystem
				,ObservationNameAltIdentifier
				,ObservationNameAltText
				,ObservationNameAltCodingSystem
				,ObservationMethodCodingSystem
				)
			VALUES (
				@ObservationName
				,@Identifier
				--,@Identifier
				,@Range
				,@Unit
				,@ValueType
				,@ObservationNameCodingSystem
				,@ObservationNameAltIdentifier
				,@ObservationNameAltText
				,@ObservationNameAltCodingSystem
				,@ObservationNameCodingSystem
				)
		END
		ELSE
		BEGIN
			UPDATE O
			SET ObservationName = @ObservationName
				,ObservationMethodIdentifier = @Identifier
				,[Range] = @Range
				,Unit = @Unit
				,ValueType = @ValueType
				,ObservationNameCodingSystem = @ObservationNameCodingSystem
				,ObservationNameAltIdentifier = @ObservationNameAltIdentifier
				,ObservationNameAltText = @ObservationNameAltText
				,ObservationNameAltCodingSystem = @ObservationNameAltCodingSystem
				,ObservationMethodCodingSystem = @ObservationNameCodingSystem
			FROM Observations O
			WHERE ISNULL(O.RecordDeleted, 'N') = 'N'
			AND O.ObservationName = @ObservationName 
			AND ObservationMethodIdentifier = @Identifier
				
		END
		
		COMMIT TRANSACTION @TranName
	END TRY

	BEGIN CATCH
		IF EXISTS (
				SELECT 1
				FROM Sys.dm_tran_active_transactions
				WHERE NAME = @TranName
				)
			ROLLBACK TRANSACTION @TranName

		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'Failed to create HealthDataAttributes from SSP_SCCreateObservations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


