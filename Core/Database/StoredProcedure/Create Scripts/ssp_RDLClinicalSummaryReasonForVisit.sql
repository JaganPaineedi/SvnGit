IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryReasonForVisit]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryReasonForVisit]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryReasonForVisit] 
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
AS
/******************************************************************************    
**  File: ssp_RDLClinicalSummaryReasonForVisit.sql    
**  Name: ssp_RDLClinicalSummaryReasonForVisit    
**  Desc: Provides general client information for the Clinical Summary    
**    
**  Return values:    
**    
**  Called by:    
**    
**  Parameters:    
**  Input   Output    
**  ServiceId      -----------    
**    
**  Created By: Veena S Mani    
**  Date:  May 08 2014    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:  Author:    Description:    
**  -------- --------   -------------------------------------------    
    
26/4/14   Veena S Mani  Added ShowClinicalSummaryReasonforVisit Section    
02/05/2014  Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18                
14/07/2014  Veena S Mani        If the progressnote is associated to Appointments,it will show the appointment Type.               
03/09/2014  Revathi					What: Check RecordDeleted    
								 Why: #36 MeaningfulUse     
  03/09/2015  Revathi				what:Get Reason for visit
									why:  task#18 Post Certification            
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @IsProgressNote CHAR(1)
		DECLARE @DocumentCodeId INT
		DECLARE @AppointmentType INT

		IF (@DocumentVersionId IS NULL)
		BEGIN
			SET @IsProgressNote = 'N'
		END
		ELSE
		BEGIN
			SELECT TOP 1 @DocumentCodeId = DocumentCodeId
				,@ClientId = ClientId
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF (@DocumentCodeId = 300)
			BEGIN
				SET @IsProgressNote = 'Y'
			END
			ELSE
			BEGIN
				SET @IsProgressNote = 'N'
			END
		END

		IF (@IsProgressNote = 'N')
		BEGIN
			IF (
					EXISTS (
						SELECT 1
						FROM BedAssignments BA
						INNER JOIN ClientInpatientVisits A ON A.ClientInpatientVisitId = BA.ClientInpatientVisitId
						WHERE A.ClientId = @ClientId
							AND ISNULL(BA.RecordDeleted, 'N') = 'N'
							AND ISNULL(A.RecordDeleted, 'N') = 'N'
						)
					)
			BEGIN
				SELECT TOP 1 ISNULL(BA.Comment, '') AS ReasonforVisit
				FROM BedAssignments BA
				INNER JOIN ClientInpatientVisits A ON A.ClientInpatientVisitId = BA.ClientInpatientVisitId
				WHERE A.ClientId = @ClientId
					AND ISNULL(BA.RecordDeleted, 'N') = 'N'
					AND ISNULL(A.RecordDeleted, 'N') = 'N'
			END
			ELSE
			BEGIN
				IF @ServiceId IS NOT NULL
				BEGIN
					SELECT IsNull(S.Comment, '') AS ReasonforVisit
					FROM Services s
					--INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
					WHERE s.ServiceId = @ServiceId
					AND ISNULL(S.RecordDeleted,'N')='N'
				END
				ELSE
				BEGIN
					SELECT TOP 1 IsNull(S.Comment, '') AS ReasonforVisit
					FROM Services s
					--INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId    
					WHERE s.ClientID = @ClientId
					AND ISNULL(S.RecordDeleted,'N')='N'
					ORDER BY S.DateOfService DESC
				END
			END
		END
		ELSE
		BEGIN
			SELECT TOP 1 @AppointmentType = AppointmentID
			FROM Documents
			WHERE InprogressdocumentVersionid = @DocumentVersionId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF (@AppointmentType IS NOT NULL)
			BEGIN
				SELECT G.CodeName AS ReasonforVisit
				FROM Globalcodes G
				INNER JOIN Appointments A ON A.AppointmentType = G.GlobalcodeId
				WHERE A.AppointmentId = @AppointmentType
				AND ISNULL(G.RecordDeleted, 'N') = 'N'
				AND ISNULL(A.RecordDeleted, 'N') = 'N'


			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
		+ CONVERT(VARCHAR(4000), Error_message()) + '*****' 
		+ Isnull(CONVERT(VARCHAR, Error_procedure()), 
		'ssp_RDLClinicalSummaryReasonForVisit') 
		+ '*****' + CONVERT(VARCHAR, Error_line()) 
		+ '*****' + CONVERT(VARCHAR, Error_severity())
		+ '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (		
				@Error
				,16
				,1
				);
	END CATCH
END
GO

