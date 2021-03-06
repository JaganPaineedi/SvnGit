/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeOtherFamilyMembers]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFeeOtherFamilyMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFeeOtherFamilyMembers]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeOtherFamilyMembers]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientFeeOtherFamilyMembers] @ClientId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetClientFeeOtherFamilyMembers           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    06/JAN/2016                                         */
/*                                                                   */
/* Purpose:  Used in ClientFees Detail Page  */
/*                                                                   */
/* Input Parameters: @ClientId   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT C.ClientId
			,C.LastName + ', ' + C.FirstName + ' (' + CAST(C.ClientId AS VARCHAR(25)) + ')' ClientName
		FROM ClientContacts CC
		JOIN Clients C ON CC.AssociatedClientId = C.ClientId
		WHERE CC.ClientId = @ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND ISNULL(CC.Active, 'N') = 'Y'
			AND ISNULL(C.Active, 'N') = 'Y'
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			AND CC.AssociatedClientId IS NOT NULL
		ORDER BY ClientName ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetClientFeeOtherFamilyMembers]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


