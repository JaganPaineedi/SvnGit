/****** Object:  StoredProcedure [dbo].[ssp_GetCarePlanClientPrograms]    Script Date: 01/06/2015 11:01:38 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCarePlanClientPrograms]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetCarePlanClientPrograms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetCarePlanClientPrograms]    Script Date: 01/06/2015 11:01:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetCarePlanClientPrograms] (
	@ClientID INT
	,@StaffId INT = NULL
	)
AS
-- =============================================
-- Author:		Pradeep.A
-- Create date: 01/19/2015
-- Description:	Get Programs names based on the ClientId and StaffId
/*      
 Author			Modified Date			Reason      
 Pradeep.A		Apr/16/2015				ProgramType configurations has been moved to Recodes
 Irfan			Dec/06/2016				What: Change LEFT JOIN to INNER JOIN to the Programs table and added RecordDeleted Condition should pull 
										only the programs which has RecordDeleted=NULL
										Why: Pathway - Support Go Live - #312 */
-- =============================================
BEGIN
	BEGIN TRY
		IF (@StaffId = - 1)
		BEGIN
			SELECT DISTINCT P.ProgramId,P.ProgramType
				,P.ProgramName
			FROM ClientPrograms AS CP
			INNER JOIN Programs AS P ON CP.ProgramId = P.ProgramId
			WHERE (CP.ClientId = @ClientID)
				AND CP.STATUS IN (
					'1'
					,'4'
					)
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N' --Added on Dec/06/2016 by Irfan
				AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('CAREPLANPROGRAMTYPE') AS CD
						WHERE CD.IntegerCodeId = P.ProgramType
						)	
			ORDER BY P.ProgramName
		END
		ELSE
		BEGIN
			SELECT DISTINCT P.ProgramId
				,P.ProgramName
			FROM StaffPrograms SP
			INNER JOIN ClientPrograms CP ON (SP.ProgramId = CP.ProgramId)
			INNER JOIN Programs AS P ON SP.ProgramId = P.ProgramId
			WHERE SP.StaffId = @StaffId
				AND CP.ClientId = @ClientId
				AND ISNULL(SP.RecordDeleted, 'N') = 'N'
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'  --Added on Dec/06/2016 by Irfan
				AND CP.STATUS IN (
					'1'
					,'4'
					)
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetCarePlanClientPrograms') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

