/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationClientContacts]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationClientContacts]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLDocumentRegistrationClientContacts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationClientContacts]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationClientContacts (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationClientContacts.sql                
**  Name: ssp_RDLDocumentRegistrationClientContacts           
**  Desc:   Get data for Client Contacts tab Sub report                             
**  Return values: <Return Values>                                                                
**  Called by: <Code file that calls>                                                                               
**  Parameters:    @DocumentVersionId                              
**  Input   Output                                  
**  ----    -----------                                                               
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	-----			-------		-----------
	Aug 06 2018		Ravi		Get data for Client Contacts tab Sub report.
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document	                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT

		SELECT TOP 1 @ClientId = C.ClientId
		FROM Documents D
		JOIN DocumentVersions DV ON D.DocumentId = DV.DocumentId
		JOIN Clients C ON C.ClientId = D.ClientId
		WHERE Dv.DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'

		SELECT CC.ClientContactId
			,CC.ListAs
			,GC.CodeName AS RelationshipText
			,(
				SELECT TOP (1) PhoneNumber
				FROM ClientContactPhones
				WHERE (ClientContactId = CC.ClientContactId)
					AND (PhoneNumber IS NOT NULL)
					AND (ISNULL(RecordDeleted, 'N') = 'N')
				ORDER BY PhoneType
				) AS Phone
			,CC.Organization
			,CASE 
				WHEN ISNULL(CC.Guardian, 'N') = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS GuardianText
			,CASE 
				WHEN ISNULL(CC.EmergencyContact, 'N') = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS EmergencyText
			,CASE 
				WHEN ISNULL(CC.FinanciallyResponsible, 'N') = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS FinResponsibleText
			,CASE 
				WHEN ISNULL(CC.HouseholdMember, 'N') = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS HouseholdnumberText
			,CASE 
				WHEN ISNULL(CC.CareTeamMember, 'N') = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS CareTeamMemberText
			,CASE 
				WHEN ISNULL(CC.Active, 'N') = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS Active
		FROM ClientContacts CC
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CC.Relationship
			AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
			AND GC.Category = 'RELATIONSHIP'
		WHERE (ISNULL(CC.RecordDeleted, 'N') = 'N')
			AND (CC.ClientId = @ClientId)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationClientContacts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
