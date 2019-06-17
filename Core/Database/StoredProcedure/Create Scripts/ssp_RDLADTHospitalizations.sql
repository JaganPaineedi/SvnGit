IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLADTHospitalizations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLADTHospitalizations] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLADTHospitalizations] 
	(
	@ADTHospitalizationId INT
	)
AS
/******************************************************************************\

*******************************************************************************
**  Change History
*******************************************************************************
**  Date:			Author:			Description: 
**  --------		--------		-------------------------------------------
    28/04/2017		Ravichandra		what:get client ADT: Hospitalization  details  
									why : Task #833.1 SWMBH Support
*******************************************************************************/
BEGIN
	BEGIN TRY
	
	SELECT   A.ADTHospitalizationId
			,(select top 1 OrganizationName from SystemConfigurations ) as OrganizationName
			,A.ClientId 
			,A.AssignedReviewerId
			,S.LastName + ', ' + S.Firstname AS AssignedReviewerName 
			,CONVERT(varchar(10),A.AdmissionDateTime,101) AS AdmissionDateTime
			,Convert(varchar(10),A.DischargeDateTime,101) AS DischargeDateTime
			,dbo.ssf_GetGlobalCodeNameById(D.MessageType) AS TypeOfMessage
			,D.MessageType
    FROM ADTHospitalizations A
	LEFT JOIN Staff S ON S.StaffId=A.AssignedReviewerId AND ISNULL(S.RecordDeleted, 'N') = 'N'
	LEFT JOIN ADTHospitalizationDetails D ON D.ADTHospitalizationId=A.ADTHospitalizationId  AND ISNULL(D.RecordDeleted, 'N') = 'N'	
    WHERE A.ADTHospitalizationId=@ADTHospitalizationId
			AND ISNULL(A.RecordDeleted, 'N') = 'N'
				
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLADTHospitalizations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
