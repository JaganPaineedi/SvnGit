
IF EXISTS (SELECT   * FROM  sys.objects WHERE   object_id = OBJECT_ID(N'csp_RDLClientsWithoutActiveTxPlanDataLists') AND type IN ( N'P', N'PC' ))
    DROP PROCEDURE csp_RDLClientsWithoutActiveTxPlanDataLists
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.csp_RDLClientsWithoutActiveTxPlanDataLists
@Type VARCHAR(MAX) = NULL
AS
/************************************************************************************************
Stored Procedure: csp_RDLClientsWithoutActiveTxPlanDataLists                      
                                                                                                 
Created By: Jay                                                                                    

Test Call:
	EXEC csp_RDLClientsWithoutActiveTxPlanDataLists

Change Log:                                                                                                
Date		Author			Purpose
2018-10-08	jwheeler		Created ; New Directions Enhancements 12
                                                                                                 
****************************************************************************************************/
BEGIN
	DECLARE @CRLF CHAR(2) = CHAR(13) + CHAR(10)
	DECLARE @ErrorMessage VARCHAR(MAX) = @CRLF
	DECLARE @Bookmark VARCHAR(MAX) = 'Init' --#EH!INFO!ADD!@Bookmark!
	DECLARE @SaveTranCount INTEGER = @@Trancount
	DECLARE @ThisProc VARCHAR(MAX) = ISNULL(OBJECT_NAME(@@PROCID), 'Testin')
	DECLARE @CreatedBy VARCHAR(30) = CASE
											WHEN LEN(@ThisProc) >= 30 THEN SUBSTRING(@ThisProc, 1, 13) + '...' + SUBSTRING(@ThisProc, LEN(@ThisProc) - 13, 13)
											ELSE @ThisProc
										END


	BEGIN TRY

	;WITH BigList AS (
		SELECT  'Programs' [Type], CAST(P.ProgramId AS VARCHAR(MAX)) [Value], P.ProgramName [Label] FROM Programs P WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
		UNION
		SELECT  'ServiceStatus'
				, GC.GlobalCodeId
				, GC.CodeName
			FROM  GlobalCodes GC
			WHERE ISNULL(GC.RecordDeleted, 'N') = 'N'
				AND ISNULL(GC.Active, 'N') = 'Y'
				AND GC.Category = 'SERVICESTATUS'
		UNION
		SELECT  'Clinicians'
				, s.StaffId
				, s.LastName + ', ' + ISNULL(s.FirstName, 'no first name') + ISNULL(' ' + SUBSTRING(s.MiddleName, 1, 1) + '.', '')
			FROM  Staff s
			WHERE ISNULL(s.Clinician, 'N') = 'Y'
				AND ISNULL(s.RecordDeleted, 'N') = 'N'
		UNION
		SELECT  'Clinicians', -1, 'No Primary Clinician'
		UNION
		SELECT  'Procedures', P.ProcedureCodeId, P.ProcedureCodeName FROM   ProcedureCodes P JOIN Services s ON s.ProcedureCodeId = P.ProcedureCodeId
		)
		SELECT * FROM BigList
		WHERE BigList.[Type] = ISNULL(@Type, [BigList].[Type] )
		ORDER BY 1, 3
	END TRY
	BEGIN CATCH
		IF @@Trancount > 0
			ROLLBACK TRAN
		DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
		DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName))
		SET @ErrorMessage = @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + CHAR(13)

		SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') + CHAR(13) + @ThisProcedureName + ' Variable dump:' + CHAR(13)


		RAISERROR('%s', 16, 1, @ErrorMessage)
	END CATCH
END

GO
