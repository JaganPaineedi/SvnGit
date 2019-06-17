IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetTreatmentGoalsObjectives]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebGetTreatmentGoalsObjectives]
GO

CREATE PROCEDURE [dbo].[ssp_SCWebGetTreatmentGoalsObjectives] (
	@ClientId BIGINT
	,@DateOfService DATETIME
	,@ProcedureCodeId INT
	,@serviceId INT
	)
AS
/******************************************************************************                                          
**  Name: ssp_SCWebGetTreatmentGoalsObjectives                                          
**  Desc:                             
**                                                                                   
**                                           
                                    
**                                                        
**  Parameters:                                          
**  Input    Output                                          
**     ----------       -----------                                          
    
**  --------  --------    -------------------------------------------                                          
**                                    
								                               
7/8/2015   Hemant      Calling scsp_SCWebGetTreatmentGoalsObjectives inside ssp_SCWebGetTreatmentGoalsObjectives to get the goals and objectives based on Serviceid                        
*******************************************************************************/
BEGIN
	BEGIN TRY
		IF EXISTS (
				SELECT 1
				FROM sys.procedures sp
				INNER JOIN sys.parameters parm ON sp.object_id = parm.object_id
				WHERE sp.NAME = 'scsp_SCWebGetTreatmentGoalsObjectives'
					AND parm.NAME = '@serviceId'
				)
		BEGIN
			EXEC scsp_SCWebGetTreatmentGoalsObjectives @ClientId
				,@DateOfService
				,@ProcedureCodeId
				,@serviceId
		END
		ELSE
		BEGIN
			EXEC scsp_SCWebGetTreatmentGoalsObjectives @ClientId
				,@DateOfService
				,@ProcedureCodeId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebGetTreatmentGoalsObjectives') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
	END CATCH
END