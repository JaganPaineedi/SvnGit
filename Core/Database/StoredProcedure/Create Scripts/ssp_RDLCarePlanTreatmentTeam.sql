/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanTreatmentTeam]    Script Date: 01/13/2015 15:06:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLCarePlanTreatmentTeam]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLCarePlanTreatmentTeam]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanTreatmentTeam]    Script Date: 01/13/2015 15:06:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLCarePlanTreatmentTeam] --805088
	(@DocumentVersionId AS INT)
AS
/************************************************************************/
/* Stored Procedure: ssp_RDLCarePlanTreatmentTeam 40032           */
/* Creation Date: Feb 16 2015                                             */
/* Purpose: Get Data for the RDL                                         */
/* Input Parameters: DocumentVersionId                                   */
/* Purpose: Use For Rdl Report                                           */
/* 13 Jan 2014    Aravind         Modified As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans
				                  Valley - Customizations                       */
/* Feb 16 2015	  PradeepA		  PrimaryClinician column is added as part of the development #915.2 (Valley Customizations) */
-- 2016.09.15    Venkatesh MR    if the staff is deleted also AssignForContribution validation was showing - Added RecordDeleted check for the staff at Where condition - Camino Environment Issue Tracking #233 */
/************************************************************************/
BEGIN
	BEGIN TRY
		SELECT CarePlanProgramId
			,P.ProgramId
			,P.ProgramName
			,CPP.StaffId
			,COALESCE(S.LastName, '') + ', ' + COALESCE(S.FirstName, '') AS [StaffName]
			,CPP.DocumentVersionId
			,AssignForContribution
			,Completed
			,DocumentAssignedTaskId
			,GC.CodeName AS SupportsInvolvement
			,(IsNull(ST.LastName, '') + coalesce(', ' + ST.FirstName, '')) AS [PrimaryClinician]
		FROM CarePlanPrograms CPP
		LEFT JOIN Programs P ON CPP.ProgramId = P.ProgramId
			AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff S ON S.StaffId = CPP.StaffId
		LEFT JOIN DocumentCarePlans DCP ON CPP.DocumentVersionId = DCP.DocumentVersionId
			AND ISNULL(DCP.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = DCP.SupportsInvolvement
			AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
		INNER JOIN DocumentVersions Dv ON DV.DocumentVersionId = CPP.DocumentVersionId
		INNER JOIN Documents D ON D.CurrentDocumentVersionId = Dv.DocumentVersionId
		INNER JOIN Clients C ON D.ClientId = C.CLientId
		LEFT JOIN Staff ST ON C.PrimaryClinicianId = ST.StaffId 
		WHERE ISNULL(CPP.RecordDeleted, 'N') <> 'Y'
			AND CPP.DocumentVersionId = @DocumentVersionId
			AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		ORDER BY [StaffName]
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RdlCarePlanSupportTreatmentTeam') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

--CarePlanPrograms