IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetElectronicEligibilityVerificationElectronicPayerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationElectronicPayerList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationElectronicPayerList] @ClientCoveragePlanId AS
    INT
AS 
-- =============================================
-- Author:		Suhail Ali
-- Create date: 1/13/2012
-- Description:	
-- List of electronic payers in the system. Filtered down to electronic payers associated with 
-- client coverage plan if specified
-- 27/03/2017   Lakshmi What: Added ElectronicEligibilityVerificationConfigurationId to select statement
--						Why:  Woods - Support Go Live #170
-- 10/26/2017	NJain	Added record deleted check on eligibility payers table. AHN EIT #65
-- 11/27/2018	Vijay	What: Retriving ElectronicEligibilityVerificationPayerId column value to bind the Payers dropdown. 
--						Why: Bradford SGL #742
-- =============================================
    BEGIN
		BEGIN TRY
        IF ( @ClientCoveragePlanId IS NULL ) 
            SELECT DISTINCT
					payer.ElectronicEligibilityVerificationPayerId,
                    payer.ElectronicPayerId ,
                    payer.ElectronicPayername,
                    Payer.ElectronicEligibilityVerificationConfigurationId
            FROM    dbo.ElectronicEligibilityVerificationPayers AS payer 
			WHERE ISNULL(RecordDeleted, 'N') = 'N'
            ORDER BY payer.ElectronicPayername ASC
        ELSE 
            SELECT DISTINCT
					payer.ElectronicEligibilityVerificationPayerId,
                    payer.ElectronicPayerId ,
                    payer.ElectronicPayername,
                    Payer.ElectronicEligibilityVerificationConfigurationId
            FROM    dbo.CoveragePlans AS cvg                        
                    INNER JOIN dbo.ElectronicEligibilityVerificationPayers AS payer ON cvg.ElectronicEligibilityVerificationPayerId = payer.ElectronicEligibilityVerificationPayerId
                    INNER JOIN dbo.ClientCoveragePlans AS clientcvg ON clientcvg.CoveragePlanId = cvg.CoveragePlanId
            WHERE   clientcvg.ClientCoveragePlanId = @ClientCoveragePlanId AND ISNULL(payer.RecordDeleted, 'N') = 'N'
			ORDER BY payer.ElectronicPayername ASC                    
   
		END TRY
		BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetElectronicEligibilityVerificationElectronicPayerList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


