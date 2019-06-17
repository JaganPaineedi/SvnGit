IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentDasts]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].ssp_RDLDocumentDasts
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLDocumentDasts] @DocumentVersionId AS INT
AS
/************************************************************************/
/* Stored Procedure: ssp_RDLDocumentDasts      */
/* Creation Date:  04-05-2018                  */
/* Purpose: Gets Data for ssp_RDLDocumentDasts */
/* Input Parameters: DocumentVersionId         */
/* Output Parameters:                          */
/* Purpose: Use For Rdl Report                 */
/* Calls:                                      */
/* Author: Chethan N               */
-- *****History****  
/*  Date			Author				Description                   */
/*  17/APR/2018		Chethan N			Westbridge-Customizations task #4650                   */
/*********************************************************************/
BEGIN TRY
	BEGIN

		SELECT DD.DocumentVersionId
			,(
				SELECT TOP 1 OrganizationName
				FROM SystemConfigurations
				) AS OrganizationName
			,DC.DocumentName
			,D.ClientId
			,C.LastName + ', ' + C.FirstName AS ClientName
			,CONVERT(VARCHAR(10), D.EffectiveDate, 101) AS EffectiveDate
			,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB
			,CASE DD.MedicalReason WHEN 'Y' THEN 'Yes' ELSE 'No' END AS MedicalReason
			,CASE DD.PrescriptionDrugs WHEN 'Y' THEN 'Yes' ELSE 'No' END AS PrescriptionDrugs
			,CASE DD.OneDrugAtaTime WHEN 'Y' THEN 'Yes' ELSE 'No' END AS OneDrugAtaTime
			,CASE DD.WeekWithoutDrugs WHEN 'Y' THEN 'Yes' ELSE 'No' END AS WeekWithoutDrugs
			,CASE DD.StopDrug WHEN 'Y' THEN 'Yes' ELSE 'No' END AS StopDrug
			,CASE DD.ContinuousDrugs WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ContinuousDrugs
			,CASE DD.LimitDrugsSituations WHEN 'Y' THEN 'Yes' ELSE 'No' END AS LimitDrugsSituations
			,CASE DD.FlashBack WHEN 'Y' THEN 'Yes' ELSE 'No' END AS FlashBack
			,CASE DD.DrugAbuse WHEN 'Y' THEN 'Yes' ELSE 'No' END AS DrugAbuse
			,CASE DD.InvolvementWithDrug WHEN 'Y' THEN 'Yes' ELSE 'No' END AS InvolvementWithDrug
			,CASE DD.SuspectDrugs WHEN 'Y' THEN 'Yes' ELSE 'No' END AS SuspectDrugs
			,CASE DD.ProblemCreatedSpouse WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ProblemCreatedSpouse
			,CASE DD.ShoughtHelp WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ShoughtHelp
			,CASE DD.LostFriends WHEN 'Y' THEN 'Yes' ELSE 'No' END AS LostFriends
			,CASE DD.NeglectedDrug WHEN 'Y' THEN 'Yes' ELSE 'No' END AS NeglectedDrug
			,CASE DD.TroubleWork WHEN 'Y' THEN 'Yes' ELSE 'No' END AS TroubleWork
			,CASE DD.LostJob WHEN 'Y' THEN 'Yes' ELSE 'No' END AS LostJob
			,CASE DD.GottenIntoFights WHEN 'Y' THEN 'Yes' ELSE 'No' END AS GottenIntoFights
			,CASE DD.ArrestedDrugs WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ArrestedDrugs
			,CASE DD.ArrestedDrivingDrugs WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ArrestedDrivingDrugs
			,CASE DD.ObtainDrug WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ObtainDrug
			,CASE DD.PossessionIligalDrugs WHEN 'Y' THEN 'Yes' ELSE 'No' END AS PossessionIligalDrugs
			,CASE DD.HeavyDrugIntake WHEN 'Y' THEN 'Yes' ELSE 'No' END AS HeavyDrugIntake
			,CASE DD.MedicalProblem WHEN 'Y' THEN 'Yes' ELSE 'No' END AS MedicalProblem
			,CASE DD.GoneAnyoneHelp WHEN 'Y' THEN 'Yes' ELSE 'No' END AS GoneAnyoneHelp
			,CASE DD.HospitalisedDrug WHEN 'Y' THEN 'Yes' ELSE 'No' END AS HospitalisedDrug
			,CASE DD.TreatmentProgram WHEN 'Y' THEN 'Yes' ELSE 'No' END AS TreatmentProgram
			,CASE DD.TreatedAsOutpatient WHEN 'Y' THEN 'Yes' ELSE 'No' END AS TreatedAsOutpatient
			,DD.Score
		FROM Documents D
		JOIN DocumentVersions DV ON D.DocumentId = DV.DocumentId
		JOIN DocumentDASTs AS DD ON DD.DocumentVersionId = DV.DocumentVersionId
		JOIN Clients C ON C.ClientId = D.ClientId
		JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
		WHERE ISNull(DD.RecordDeleted, 'N') = 'N'
			AND DD.DocumentVersionId = @DocumentVersionId
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentDasts') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error /* Message text*/
			,16 /*Severity*/
			,1 /*State*/
			)
END CATCH
GO

