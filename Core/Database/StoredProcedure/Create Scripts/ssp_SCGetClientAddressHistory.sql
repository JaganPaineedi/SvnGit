IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetClientAddressHistory')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCGetClientAddressHistory; 
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE ssp_SCGetClientAddressHistory @ClientId INT
AS /******************************************************************************
**		File: ssp_SCGetClientAddressHistory.sql
**		Name: ssp_SCGetClientAddressHistory
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------
**	    11/25/2016      jcarlson			    created
**		05/03/2017		jcarlson				if billing is null, set to "N" - Object not set to reference of object error
*******************************************************************************/ 
    BEGIN
	
        BEGIN TRY
            SELECT  a.ClientId
            FROM    dbo.Clients AS a
            WHERE   a.ClientId = @ClientId;

            SELECT  a.ClientAddressId, a.ClientId, a.AddressType, a.Address, a.City, a.State, a.Zip, a.Display, ISNULL(a.Billing,'N') AS Billing, a.RowIdentifier,
                    a.ExternalReferenceId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedDate, a.DeletedBy, a.StartDate,
                    a.EndDate
            FROM    dbo.ClientAddressHistory AS a
            WHERE   a.ClientId = @ClientId
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
		  ORDER BY a.AddressType,ISNULL(a.StartDate,'01/01/1900') DESC,ISNULL(a.EndDate,'01/01/2900') DESC, ClientAddressId desc



        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientAddressHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

            RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
        END CATCH;
    END;

GO

