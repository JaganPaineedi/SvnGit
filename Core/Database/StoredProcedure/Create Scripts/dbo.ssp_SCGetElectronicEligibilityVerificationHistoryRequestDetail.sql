IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetElectronicEligibilityVerificationHistoryRequestDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationHistoryRequestDetail]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationHistoryRequestDetail]
    @EligibilityVerificationRequestId AS INTEGER
AS 
-- =============================================
-- Author:		Suhail Ali
-- Create date: 1/13/2012
-- Description:	
-- For a given historical verfication reqest return all the request and response data
-- 11/27/2018	Vijay	What: Retriving ElectronicEligibilityVerificationPayerId column value to bind the Payers dropdown. 
--						Why: Bradford SGL #742
-- =============================================
    BEGIN
		BEGIN TRY
        SELECT  
                ElectronicPayerId ,
                payer.ElectronicEligibilityVerificationPayerId,
                SubscriberInsuredId ,
                SubscriberFirstName ,
                SubscriberLastName ,
                SubscriberSSN ,
                SubscriberDOB ,
                SubscriberSex ,
                DependentRelationshipCode ,
                DependentFirstName ,
                DependentLastName ,
                DependentDOB ,
                DependentSex ,
                DateOfServiceStart ,
                DateOfServiceEnd ,
                VerifiedResponseText ,
                ( SELECT    MAX(HasCoverageBeenAutoUpdated)
                  FROM      dbo.ElectronicEligibilityVerificationCoveragePlans icvg
                  WHERE     icvg.EligibilityVerificationRequestId = hist.EligibilityVerificationRequestId
                ) AS HasCoverageBeenAutoUpdated
        FROM    dbo.ElectronicEligibilityVerificationRequests AS hist INNER JOIN [dbo].[ElectronicEligibilityVerificationPayers] payer ON payer.ElectronicEligibilityVerificationPayerId = hist.ElectronicEligibilityVerificationPayerId
        WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId
   
		END TRY
		BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetElectronicEligibilityVerificationHistoryRequestDetail') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
