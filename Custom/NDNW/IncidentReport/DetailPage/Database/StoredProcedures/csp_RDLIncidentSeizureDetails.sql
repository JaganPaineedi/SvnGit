IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentSeizureDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLIncidentSeizureDetails] 
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentSeizureDetails]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLIncidentSeizureDetails] (@IncidentSeizureDetailId INT)
AS
/*********************************************************************/
/* Stored Procedure: dbo.[csp_RDLIncidentSeizureDetails]                */
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:   06-May-2015                                     */
/*                                                                   */
/* Purpose:  Get Data for CustomIncidentSeizureDetails Pages */
/*                                                                   */
/* Input Parameters:  @IncidentSeizureDetailId           */
/*                                                                   */
/* Output Parameters:   None                   */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                        */
/* */
/* Data Modifications:   */
/*      */
/* Updates:                                          
 Date			Author			Purpose       
 ----------		---------		--------------------------------------                                                                               
 07-May-2015	Ravichandra		what:Use For Rdl Report  
								why:task #818 Woods – Customizations                                    
*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT (S.LastName + ', ' + S.FirstName) AS SignedBy
			,CIS.IncidentSeizureDetailsDescriptionOfIncident AS DescriptionOfincident
			,CIS.IncidentSeizureDetailsActionsTakenByStaff AS ActionsTakenByStaff
			,CIS.IncidentSeizureDetailsWitnesses AS Witnesses
			,(SS.LastName + ', ' + SS.FirstName) AS StaffNotifiedForInjury			
			,(SSS.LastName + ', ' + SSS.FirstName) AS IncidentSeizureDetailsSupervisorFlaggedId			
			,CONVERT(VARCHAR(10), CIS.IncidentSeizureDetailsDateStaffNotified, 101) AS DateStaffNotified
			,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIS.IncidentSeizureDetailsTimestaffNotified, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CIS.IncidentSeizureDetailsTimestaffNotified, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CIS.IncidentSeizureDetailsTimestaffNotified, 100), 18, 2)) AS TimestaffNotified
			,CIS.IncidentSeizureDetailsNoMedicalStaffNotified AS NoMedicalStaffNotified
			,CONVERT(VARCHAR(10), CIS.SignedDate, 101) AS SignedDate
			,CIS.PhysicalSignature AS PhysicalSignature
			,CIS.CurrentStatus AS CurrentStatus
			,CIS.InProgressStatus AS InProgressStatus
		FROM CustomIncidentSeizureDetails CIS
		LEFT JOIN Staff S ON CIS.SignedBy = S.StaffId
		LEFT JOIN Staff SS ON CIS.IncidentSeizureDetailsStaffNotifiedForInjury = SS.StaffId
		LEFT JOIN Staff SSS ON CIS.IncidentSeizureDetailsSupervisorFlaggedId= SSS.StaffId
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
		WHERE IncidentSeizureDetailId = @IncidentSeizureDetailId
			AND isnull(CIS.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentSeizureDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
