/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionClientDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInternalCollectionClientDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetInternalCollectionClientDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionClientDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetInternalCollectionClientDetails] @ClientId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetInternalCollectionClientDetails   137           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    11/AUG/2015                                         */
/*                                                                   */
/* Purpose:  Used to Get Client Informations  */
/*                                                                   */
/* Input Parameters: @ClientId   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY		
		DECLARE @ClientName VARCHAR(100)
		DECLARE @ClientPhone VARCHAR(100)
		DECLARE @ClientAddress VARCHAR(250)
		DECLARE @PrimaryProgram VARCHAR(100)
		DECLARE @PrimaryClinician VARCHAR(100)
		DECLARE @ClientContactId INT
		DECLARE @Relation VARCHAR(250)
		DECLARE @RelationName VARCHAR(100)
		DECLARE @RelationPhone VARCHAR(100)
		DECLARE @RelationAddress VARCHAR(250)
			
		SELECT TOP 1 @ClientName = C.LastName + ', ' + C.FirstName
			,@PrimaryClinician = CASE WHEN S.StaffId IS NOT NULL THEN S.LastName + ',' + S.FirstName ELSE '' END
		FROM Clients C
		LEFT JOIN Staff S ON C.PrimaryClinicianId = S.StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N'
		WHERE C.ClientId = @ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			
		SELECT TOP 1 @ClientPhone = CP.PhoneNumber
		FROM Clients C
		JOIN ClientPhones CP ON C.ClientId = CP.ClientId 
		WHERE C.ClientId = @ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CP.PhoneNumber,'') <> ''
		ORDER BY CP.PhoneType ASC
		
		SELECT TOP 1 @ClientAddress = CA.Display
		FROM Clients C
		JOIN ClientAddresses CA ON C.ClientId = CA.ClientId 
		WHERE C.ClientId = @ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(CA.Display, '') <> ''
		ORDER BY CA.AddressType ASC
		
		SELECT TOP 1 @PrimaryProgram = P.ProgramCode
		FROM ClientPrograms CP
		JOIN Programs P ON CP.ProgramId = P.ProgramId
		WHERE CP.ClientId = @ClientId
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND ISNULL(CP.PrimaryAssignment, 'N') = 'Y'
		ORDER BY P.ProgramCode ASC
		
		SELECT TOP 1 @ClientContactId = CC.ClientContactId
			,@RelationName = CC.LastName + ', ' + CC.FirstName
			,@Relation = GC.CodeName
		FROM ClientContacts CC
		JOIN Clients C ON CC.ClientId = C.ClientId
		LEFT JOIN GlobalCodes GC ON CC.Relationship = GC.GlobalCodeId
		WHERE CC.ClientId = @ClientId
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND ISNULL(CC.FinanciallyResponsible, 'N') = 'Y'
			AND ISNULL(CC.Active, 'N') = 'Y'
		ORDER BY CC.CreatedDate DESC
			,CC.ModifiedDate DESC
			
		SELECT TOP 1 @RelationPhone = CCP.PhoneNumber
		FROM ClientContacts CC
		JOIN ClientContactPhones CCP ON CC.ClientContactId= CCP.ClientContactId
		WHERE CC.ClientContactId = @ClientContactId
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CCP.PhoneNumber,'') <> ''
		ORDER BY CCP.PhoneType ASC
		
		SELECT TOP 1 @RelationAddress = CCA.Display
		FROM ClientContacts CC
		JOIN ClientContactAddresses CCA ON CC.ClientContactId = CCA.ClientContactId 
		WHERE CC.ClientContactId = @ClientContactId
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
			AND ISNULL(CCA.Display, '') <> ''
		ORDER BY CCA.AddressType ASC
		
		IF ISNULL(@Relation, '') = ''
		BEGIN
			SET @Relation = 'Client'
		END
		
		IF ISNULL(@RelationName, '') = ''
		BEGIN
			SET @RelationName = @ClientName
		END
		
		IF ISNULL(@RelationPhone, '') = ''
		BEGIN
			SET @RelationPhone = @ClientPhone
		END
		
		IF ISNULL(@RelationAddress, '') = ''
		BEGIN
			SET @RelationAddress = @ClientAddress
		END
		
		SELECT ISNULL(@ClientName,'') AS ClientName
			,ISNULL(@ClientPhone,'') AS ClientPhone
			,ISNULL(@ClientAddress,'') AS ClientAddress
			,ISNULL(@PrimaryProgram,'') AS PrimaryProgram
			,ISNULL(@PrimaryClinician,'') AS PrimaryClinician
			,ISNULL(@Relation,'') AS Relation
			,ISNULL(@RelationName,'') AS RelationName
			,ISNULL(@RelationPhone,'') AS RelationPhone
			,ISNULL(@RelationAddress,'') AS RelationAddress			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetInternalCollectionClientDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


