IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetElectronicEligibilityVerificationHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationHistory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationHistory]
    @ClientId AS INT ,
    @InquiryId AS INT
AS -- =============================================  
-- Author:  Suhail Ali  
-- Create date: 1/13/2012  
-- Description:   
--Retrieve electronic eligibility history by either Inquiry Id or Client Id. Support  
--the following use cases:  
--  - View Electronic Eligibility History in Pop-up from Client Plan &  Time Spans  
--  - View Electronic Eligibility History in Client Plan Details  
--  - View Electronic Eligibility History in Inquiry Screen  
    
--Output:  
--Plan  – The name of the plan that had eligibility checked.  
--Verified On – The date the eligibility verification took place  
--Response – The outcome of the eligibility request.  This drop down will have configurable options.  Examples include:   
--    Eligible: The member has active coverage for the period specified  
--    Spend Down: The member has active Medicaid coverage with spend down for the period specified  
--    Not Eligible: The member does not have an active coverage for the date specified  
--Insured ID – The insured id that was indicated at the time of the eligibility check  
--Start Date – The date that was indicated that coverage began  
--End Date – The date that was indicated the coverage was terminated.   
-- History
-- =============================================
-- Apr 20 2016		Pradeep A		Added RecordDeleted Check for ElectronicEligibilityVerificationRequests table 
-- Sep 08 2017		NJain			Removed hard-coded text: 'Under review by billing'. Leave it blank if there is nothing to display. AP SGL #345
-- =============================================  
    BEGIN  
        DECLARE @ErrorResponseMessage AS VARCHAR(25) = '' -- 'Under review by billing' ;  
    
        IF ( @ClientId IS NOT NULL ) 
            BEGIN  
				/* This is a temporary fix to tie inquiry id to client id if the inquiry at 
					a certain point was linked to a member */
                UPDATE  dbo.ElectronicEligibilityVerificationRequests
                SET     ClientId = @ClientId
                WHERE   EligibilityVerificationRequestId IN (
                        SELECT  EligibilityVerificationRequestId
                        FROM    dbo.CustomInquiries inq
                                INNER JOIN dbo.CustomInquiryElectronicEligibilityVerificationRequests inqverf ON inq.InquiryId = inqverf.InquiryId
                        WHERE   inq.ClientId = @ClientId ) 

                SELECT  verify.EligibilityVerificationRequestId ,
                        cvg.CoveragePlanId ,
                        plans.CoveragePlanName ,
                        verify.SubscriberInsuredId ,
                        CONVERT(VARCHAR(10), verify.VerifiedOnDate, 101) AS VerifiedOnDate ,
                        CASE WHEN RequestReturnCode <> 0
                             THEN RequestErrorMessage
                             WHEN cvg.VerifiedResponseType IS NULL
                                  OR verify.AbleToParseXMLResponseBenefits = 'N'
                             THEN @ErrorResponseMessage
                             ELSE cvg.VerifiedResponseType
                                  + CASE WHEN IsNewCoverage = 'Y'
                                         THEN ' New Coverage'
                                         ELSE ''
                                    END
                                  + CASE WHEN HasCoverageBeenAutoUpdated = 'Y'
                                         THEN ' - Auto Updated'
                                         ELSE ' - Manually Update'
                                    END
                        END AS VerifiedResponseType ,
                        ISNULL(cvg.VerifiedResponseType, @ErrorResponseMessage) AS VerifiedResponseType ,
                        CONVERT(VARCHAR(10), cvg.CoverageStartDate, 101) AS CoverageStartDate ,
                        CONVERT(VARCHAR(10), cvg.CoverageEndDate, 101) AS CoverageEndDate
                FROM    dbo.ElectronicEligibilityVerificationRequests AS verify
                        LEFT OUTER JOIN dbo.ElectronicEligibilityVerificationCoveragePlans
                        AS cvg ON verify.EligibilityVerificationRequestId = cvg.EligibilityVerificationRequestId
                        LEFT OUTER JOIN dbo.CoveragePlans AS plans ON cvg.CoveragePlanId = plans.CoveragePlanId
                WHERE   ClientId = @ClientId AND ISNULL(verify.RecordDeleted,'N')='N'
--                        AND RequestReturnCode = 0 /* Only query records with a successful response */
                ORDER BY verify.VerifiedOnDate DESC                         
    
            END  
        ELSE 
            IF ( @InquiryId IS NOT NULL ) 
                BEGIN  
                    SELECT  verify.EligibilityVerificationRequestId ,
                            cvg.CoveragePlanId ,
                            plans.CoveragePlanName ,
                            verify.SubscriberInsuredId ,
                            CONVERT(VARCHAR(10), verify.VerifiedOnDate, 101) AS VerifiedOnDate ,
                            CASE WHEN RequestReturnCode <> 0
                                 THEN RequestErrorMessage
                                 WHEN cvg.VerifiedResponseType IS NULL
                                      OR verify.AbleToParseXMLResponseBenefits = 'N'
                                 THEN @ErrorResponseMessage
                                 ELSE cvg.VerifiedResponseType
                                      + CASE WHEN IsNewCoverage = 'Y'
                                             THEN ' New Coverage'
                                             ELSE ''
                                        END
                                      + CASE WHEN HasCoverageBeenAutoUpdated = 'Y'
                                             THEN ' - Auto Updated'
                                             ELSE ' - Manually Update'
                                        END
                            END AS VerifiedResponseType ,
                            CONVERT(VARCHAR(10), cvg.CoverageStartDate, 101) AS CoverageStartDate ,
                            CONVERT(VARCHAR(10), cvg.CoverageEndDate, 101) AS CoverageEndDate
                    FROM    dbo.ElectronicEligibilityVerificationRequests AS verify
                            INNER JOIN dbo.CustomInquiryElectronicEligibilityVerificationRequests
                            AS inquiry ON verify.EligibilityVerificationRequestId = inquiry.EligibilityVerificationRequestId
                            LEFT OUTER JOIN dbo.ElectronicEligibilityVerificationCoveragePlans
                            AS cvg ON verify.EligibilityVerificationRequestId = cvg.EligibilityVerificationRequestId
                            LEFT OUTER JOIN dbo.CoveragePlans AS plans ON cvg.CoveragePlanId = plans.CoveragePlanId
                    WHERE   inquiry.InquiryId = @InquiryId
--                            AND RequestReturnCode = 0 /* Only query records with a successful response */
                    ORDER BY verify.VerifiedOnDate DESC                                        
                END  
            ELSE 
                RAISERROR (N'Both InquiryId and ClientId not specified. InquiryId and/or ClientId must be specified', 16, 1)  
  
    END  


GO


