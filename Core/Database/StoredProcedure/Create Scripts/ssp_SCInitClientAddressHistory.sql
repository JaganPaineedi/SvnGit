IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCInitClientAddressHistory]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].ssp_SCInitClientAddressHistory;
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitClientAddressHistoryr]    Script Date:   ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].ssp_SCInitClientAddressHistory
    @StaffId INT
  , @ClientID INT
  , @CustomParameters XML
AS /******************************************************************************
**		File: ssp_SCInitClientAddressHistory.sql
**		Name: ssp_SCInitClientAddressHistory
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
**		Auth: jcarlson
**		Date: 2/8/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:	    	Author:	     			Description:
**		--------		--------				-------------------------------------------
**	    2/8/2017          jcarlson	            created
*******************************************************************************/     
    BEGIN
        BEGIN TRY
	
            DECLARE @PrimaryKey INT = @ClientID;
 --do this for each table you need, remove top 1 if need more than 1 row
            SELECT TOP 1
                    'Clients' AS TableName, cah.ClientId AS ClientId
            FROM    SystemConfigurations s
            LEFT OUTER JOIN Clients AS cah ON cah.ClientId = @PrimaryKey;


            SELECT  'ClientAddressHistory' AS TableName, a.ClientAddressId, a.ClientId, a.AddressType, a.Address, a.City, a.State, a.Zip, a.Display, a.Billing,
                    a.RowIdentifier, a.ExternalReferenceId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedDate,
                    a.DeletedBy, a.StartDate, a.EndDate
            FROM    dbo.SystemConfigurations AS s
            LEFT JOIN dbo.ClientAddressHistory AS a ON a.ClientId = @PrimaryKey
                                                       AND ISNULL(a.RecordDeleted, 'N') = 'N';


				
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInitClientAddressHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
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

