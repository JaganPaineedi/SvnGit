IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   [name] = 'ssp_CMQueryElectronicEligibilityClientInsured' ) 
    DROP PROCEDURE ssp_CMQueryElectronicEligibilityClientInsured
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMQueryElectronicEligibilityClientInsured]
    @ClientId AS INT ,
    @ElectronicPayerId AS VARCHAR(25)
AS 
-- =============================================
-- Author:		Suhail Ali
-- Create date: 4/4/2012
-- Description:	
-- Return client info. for insurance verificaiton to pre-populate for request
-- 11/27/2018	Vijay	What: Retriving ElectronicEligibilityVerificationPayerId column value to bind the Payers dropdown. 
--						Why: Bradford SGL #742
-- =============================================
    BEGIN		
		BEGIN TRY
        DECLARE @ElectronicEligibilityVerificationPayerId AS INT ;


        SELECT  @ElectronicEligibilityVerificationPayerId = ElectronicEligibilityVerificationPayerId
        FROM    dbo.ElectronicEligibilityVerificationPayers
        WHERE   ElectronicPayerId = @ElectronicPayerId ;
			

            SELECT  CAST(NULL AS VARCHAR(25)) AS SubscriberInsuredId ,
                    CAST(payer.ElectronicPayerId AS CHAR(5)) AS ElectronicPayerId ,
                    payer.ElectronicEligibilityVerificationPayerId,
                    age.NationalProviderId ,
					b.LastName  AS SubscriberLastName ,
                    b.FirstName AS SubscriberFirstName ,
                    ISNULL(CONVERT(VARCHAR, b.DOB, 101), '01/01/1900') AS SubscriberDOB ,
                    ISNULL(b.Sex, '') AS SubscriberSex ,
                    ISNULL(b.SSN, '') AS SubscriberSSN ,
                    CAST('18' AS CHAR(2)) AS DependentRelationshipCode ,-- Self
                    ISNULL(b.LastName, '') AS DependentLastName ,
                    ISNULL(b.FirstName, '') AS DependentFirstName ,
                    ISNULL(CONVERT(VARCHAR, b.DOB, 101), '01/01/1900') AS DependentDOB ,
                    ISNULL(b.Sex, '') AS [DependentSex]
            FROM    Clients b  
					CROSS JOIN dbo.Agency age
					CROSS JOIN [dbo].[ElectronicEligibilityVerificationPayers] payer 
			WHERE	ISNULL(b.RecordDeleted, 'N') = 'N'          
					AND b.Active = 'Y'
					AND b.clientid = @ClientId

		END TRY
		BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMQueryElectronicEligibilityClientInsured') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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