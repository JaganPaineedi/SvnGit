IF OBJECT_ID('[csp_SCUpdateElectronicEligibilityData]') IS NOT NULL
	DROP TABLE [csp_SCUpdateElectronicEligibilityData]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

  
CREATE PROCEDURE [dbo].[csp_SCUpdateElectronicEligibilityData] 
    @EligibilityVerificationRequestId AS INTEGER ,  
    @ClientId AS INTEGER ,  
    @InquiryId AS INTEGER  
AS -- =============================================  
-- Author:  Joe Neylon  
-- Create date: 2013.02.22  
-- Description:   
-- Use the data from the eligibility coverage plan data in the table   
-- ElectronicEligibilityVerificationCoveragePlans to update clientClientCoverage plan table  
-- 
--
-- =============================================  
/*****************************************************************************************
   Revision History:
   11/20/2018 - Dknewtson - Updated logic to remove DMAP to use the dates table to determine dates that DMAP Should be eligible.

*****************************************************************************************/
    BEGIN  
  
        BEGIN TRY  
      
            SET NOCOUNT ON  
  
            --DECLARE @CountyNumber TINYINT  
  
            CREATE TABLE #ResponseCoveragePlans  
                (  
                  EligibilityVerificationRequestId INT ,  
                  CoveragePlanId INT ,  
                  InsuredId VARCHAR(25) ,  
                  VerifiedResponseType VARCHAR(25) ,  
                  CoverageStartDate DATE ,  
                  CoverageEndDate DATE ,  
                  ServiceStartDate DATE ,  
                  ServiceEndDate DATE ,  
                  HasSpendBeenMet CHAR(1) ,  
                  ClientId INT ,  
                  ServiceAreaId INT  
                );  
  
            CREATE TABLE #AffectedCoveragePlans  
                (  
                  CoveragePlanId INT ,  
                  ServiceAreaId INT ,  
                  CanCoverageBeInactiveIfNotInResponse CHAR(1) NULL  
                )  
      
            IF ( ( @ClientId IS NULL  
                   OR @ClientId < 0  
                 )  
                 AND ( @InquiryId IS NULL  
                       OR @InquiryId < 0  
                     )  
               )   
                RAISERROR (N'Either a valid Client id and/or Inquiry Id must be specified.', 16, 1)   
  
  -- Delete any existing coverage plan before re-populating the records  
            DELETE  FROM dbo.ElectronicEligibilityVerificationCoveragePlans  
            WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId  
  
  --1. Links Eligibility Verification to Client Id and/or Inquiry   
  --   Id CustomInquiryElectronicEligibilityVerificationRequests  
            EXEC ssp_SCUpdateElectronicEligibilityData_LinkToClient @ClientId = @ClientId,  
                @EligibilityVerificationRequestId = @EligibilityVerificationRequestId,  
                @InquiryId = @InquiryId  
  
  --2. If the response contains an error message then mark the request as error and   
  --   populate error text  
            EXEC ssp_SCUpdateElectronicEligibilityData_MarkErrors @EligibilityVerificationRequestId = @EligibilityVerificationRequestId   
  
  --3 If subscriber insured id was not passed in for the 270 request then let's set it from the 271 response  
            EXEC ssp_SCUpdateElectronicEligibilityData_UpdateInsuredId @EligibilityVerificationRequestId = @EligibilityVerificationRequestId   
  
  --4. Create rows in ElectronicEligibilityVerificationCoveragePlans table   
  --   for each coverage plan returned in XML response.    
  ;  
            WITH    ParseResponseXML  
                      AS ( SELECT   response.EligibilityVerificationRequestId ,  
                                    U.item.value('data((subscriberaddinfo/grouppolicynum)[1])',  
                                                 'varchar(100)') AS GroupPolicyNumber ,  
                                    CHARINDEX(',',  
                                              U.item.value('data((subscriberaddinfo/grouppolicynum)[1])',  
                                                           'varchar(100)'), 1)  
                                    + 1 AS BeginCounty ,  
                                    response.DateOfServiceStart AS ServiceStartDate ,  
            response.DateOfServiceEnd AS ServiceEndDate ,  
                                    response.ClientId AS ClientId  
                           FROM dbo.[ElectronicEligibilityVerificationRequests]  
                                    AS response  
                                    CROSS APPLY VerifiedXMLResponse.nodes('//subscriber')  
                                    AS U ( Item )  
                           WHERE    response.EligibilityVerificationRequestId = @EligibilityVerificationRequestId  
                         )
                --    ParseCountyNumber  
                --      AS ( SELECT   CASE WHEN CHARINDEX(',',  
                --                                        REVERSE(GroupPolicyNumber)) = 3  
                --                         THEN CAST(CAST(RIGHT(GroupPolicyNumber,  
                --                                              2) AS INT) AS CHAR(2))  
                --                         ELSE REPLACE(CAST(CAST(SUBSTRING(GroupPolicyNumber,  
                --                                              BeginCounty, 2) AS INT) AS CHAR(2)),  
                --                                      84, 39)  
                --                    END AS CountyNumber ,  
                --                    *  
                --           FROM     ParseResponseXML  
                --         )  
                --SELECT  @CountyNumber = MIN(CountyNumber)  
                --FROM    ParseCountyNumber  
    
            INSERT  INTO #ResponseCoveragePlans  
                    ( EligibilityVerificationRequestId ,  
                      CoveragePlanId ,  
                      InsuredId ,  
                      VerifiedResponseType ,  
                      CoverageStartDate ,  
                      CoverageEndDate ,  
                      ServiceStartDate ,  
                      ServiceEndDate ,  
                      HasSpendBeenMet ,  
                      ClientId ,  
                      ServiceAreaId  
        )  
                    SELECT  DISTINCT EligibilityVerificationRequestId ,  
                            CoveragePlanId ,  
                            InsuredId ,  
                            VerifiedResponseType ,  
                            CoverageStartDate ,  
                            CoverageEndDate ,  
                            ServiceStartDate ,  
                            ServiceEndDate ,  
                            HasSpendBeenMet ,  
                            ClientId ,  
                            ServiceAreaId  
                    FROM    cfn_SCUpdateElectronicEligibilityData_ResponseCoveragePlans_Oregon(@EligibilityVerificationRequestId)    
  
  
		-- remove dmap when there is an CCO provider available.
      


	      UPDATE   #ResponseCoveragePlans
         SET      CoverageStartDate = ServiceStartDate
         WHERE    CoverageStartDate IS NULL 

		 UPDATE #ResponseCoveragePlans SET CoverageEndDate = '9999-12-30'
		 WHERE DATEDIFF(DAY, CoverageEndDate, GETDATE()) = 0 OR CoverageEndDate IS NULL 

		 -- if the client has an overlapping MCO plan with DMAP Coverage.
			IF EXISTS ( SELECT	1
						FROM	#ResponseCoveragePlans rcp
								JOIN dbo.CustomCoveragePlans ccp ON ccp.CoveragePlanId = rcp.CoveragePlanId
																	AND ccp.DMAPPlan = 'Y'
																	AND EXISTS ( SELECT	1
																					FROM
																						#ResponseCoveragePlans rcp2
																						JOIN dbo.CustomCoveragePlans ccp2 ON ccp2.CoveragePlanId = rcp2.CoveragePlanId
																																AND ccp2.MedicaidMCOPlan = 'Y'
																																AND rcp2.ServiceAreaId = rcp.ServiceAreaId
																																AND rcp2.InsuredId = rcp.InsuredId
																																AND rcp.VerifiedResponseType = 'Billable'
																																AND rcp2.CoverageStartDate <= rcp.CoverageEndDate
																																AND rcp.CoverageStartDate <= rcp2.CoverageEndDate ) 
						WHERE rcp.VerifiedResponseType = 'Billable'
																																)
				BEGIN 
		 
					DECLARE	@MaxEndDate DATE;
					-- need to limit this or things get silly.
					SELECT	@MaxEndDate = DATEADD(DAY, 1, MAX(CoverageEndDate))
					FROM	#ResponseCoveragePlans
					WHERE	CoverageEndDate <> '9999-12-30';


					IF OBJECT_ID('tempdb..#DMAPDates') IS NOT NULL DROP TABLE #DMAPDates
					CREATE TABLE #DMAPDates
						(
							DMAPDateId INT IDENTITY ,
							[Date] DATE ,
							CoveragePlanId INT ,
							ServiceAreaId INT ,
							InsuredId VARCHAR(25) ,
							DateGroup DATE
						);
					-- all dates by coverage plan for DMAP that don't have an eligible MCO plan
					INSERT	INTO #DMAPDates
							(	Date ,
								CoveragePlanId ,
								ServiceAreaId ,
								InsuredId
							)
					SELECT DISTINCT
							d.Date ,
							rcp.CoveragePlanId ,
							rcp.ServiceAreaId ,
							rcp.InsuredId
					FROM	#ResponseCoveragePlans AS rcp
							JOIN dbo.CustomCoveragePlans AS ccp ON ccp.CoveragePlanId = rcp.CoveragePlanId
																	AND ccp.DMAPPlan = 'Y'
							JOIN dbo.Dates d ON rcp.CoverageStartDate <= d.Date
												AND d.Date <= ISNULL(NULLIF(rcp.CoverageEndDate, '9999-12-30'), @MaxEndDate)
												AND NOT EXISTS ( SELECT	1
																	FROM
																		#ResponseCoveragePlans rcp2
																		JOIN dbo.CustomCoveragePlans ccp2 ON ccp2.CoveragePlanId = rcp2.CoveragePlanId
																												AND ccp2.MedicaidMCOPlan = 'Y'
																												AND rcp2.ServiceAreaId = rcp.ServiceAreaId
																												AND rcp2.InsuredId = rcp.InsuredId
																												AND rcp2.VerifiedResponseType = 'Billable'
																												AND rcp2.CoverageStartDate <= d.Date
																												AND d.Date <= rcp2.CoverageEndDate )
					WHERE rcp.VerifiedResponseType = 'Billable'
					-- dategrouping. This will make it so DateGroup is the same for all contiguous dates of coverage.

					IF OBJECT_ID('tempdb..#DateGroup') IS NOT NULL
						DROP TABLE #DateGroup
					SELECT	DATEADD(DAY, -ROW_NUMBER() OVER ( PARTITION BY CoveragePlanId, ServiceAreaId, InsuredId ORDER BY [Date] ASC ), [Date]) AS dategroup
							,DMAPDateId
					INTO #DateGroup
					FROM	#DMAPDates;

					UPDATE dd
					SET dd.DateGroup = dg.dategroup
					FROM #DMAPDates dd
					JOIN #DateGroup dg ON dg.DMAPDateId = dd.DMAPDateId


					DELETE	rcp
					FROM	#ResponseCoveragePlans AS rcp
							JOIN dbo.CustomCoveragePlans AS ccp ON ccp.CoveragePlanId = rcp.CoveragePlanId
																	AND ccp.DMAPPlan = 'Y'
					WHERE	rcp.VerifiedResponseType = 'Billable';

					INSERT	INTO #ResponseCoveragePlans
							(	EligibilityVerificationRequestId ,
								CoveragePlanId ,
								InsuredId ,
								VerifiedResponseType ,
								CoverageStartDate ,
								CoverageEndDate ,
								ServiceStartDate ,
								ServiceEndDate ,
								HasSpendBeenMet ,
								ClientId ,
								ServiceAreaId
							)
					SELECT	@EligibilityVerificationRequestId , -- EligibilityVerificationRequestId - int
							d.CoveragePlanId , -- CoveragePlanId - int
							d.InsuredId , -- InsuredId - varchar(25)
							'Billable' , -- VerifiedResponseType - varchar(25)
							MIN(d.Date) , -- CoverageStartDate - date
							MAX(d.Date) , -- CoverageEndDate - date
							eevr.DateOfServiceStart , -- ServiceStartDate - date
							eevr.DateOfServiceEnd , -- ServiceEndDate - date
							'Y' , -- HasSpendBeenMet - char(1)
							eevr.ClientId , -- ClientId - int
							d.ServiceAreaId  -- ServiceAreaId - int
					FROM	#DMAPDates d
							JOIN dbo.ElectronicEligibilityVerificationRequests eevr ON eevr.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
					GROUP BY d.DateGroup ,
							d.CoveragePlanId ,
							d.ServiceAreaId ,
							d.InsuredId ,
							eevr.ClientId ,
							eevr.DateOfServiceStart ,
							eevr.DateOfServiceEnd;

					UPDATE #ResponseCoveragePlans SET CoverageEndDate = '9999-12-30' WHERE CoverageEndDate = @MaxEndDate
					

				END; 

		   UPDATE #ResponseCoveragePlans SET CoverageEndDate = NULL WHERE CoverageEndDate = '9999-12-30'

		--   SELECT * FROM #ResponseCoveragePlans

  /* If the beneift records returned from 271 do not   
   all match all the expected benefits then flag  
  */                                                          
            UPDATE  [dbo].[ElectronicEligibilityVerificationRequests]  
            SET     AbleToParseXMLResponseBenefits = 'Y'  
            WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId  
  
            INSERT  INTO #AffectedCoveragePlans  
                    ( CoveragePlanId ,  
                      ServiceAreaId ,  
                      CanCoverageBeInactiveIfNotInResponse  
              )  
                    SELECT  a.CoveragePlanId ,  
                            b.ServiceAreaId ,  
                            c.CanCoverageBeInactiveIfNotInResponse  
                    FROM    CoveragePlans a  
                            JOIN CoveragePlanServiceAreas b  
                                ON b.CoveragePlanId = a.CoveragePlanId  
                            JOIN CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping c  
                                ON c.CoveragePlanId = a.CoveragePlanId  
  
 --Do not inactivate coverages if no 271 reponse comes back  
            IF NOT EXISTS ( SELECT  *  
                            FROM    #ResponseCoveragePlans )   
                UPDATE  #AffectedCoveragePlans  
                SET     CanCoverageBeInactiveIfNotInResponse = 'N'  
  
 -- Stage Coverages for Update  
            EXEC csp_SCUpdateElectronicEligibilityData_StageCoveragesForUpdate @EligibilityVerificationRequestId = @EligibilityVerificationRequestId  
  
 -- Update XML with Summary data and County Names  
          --  EXEC csp_SCUpdateElectronicEligibilityData_UpdateXML_Oregon @EligibilityVerificationRequestId = @EligibilityVerificationRequestId   
         
 -- Convert response xml to html  
            EXEC ssp_SCUpdateElectronicEligibilityData_ConvertResponseXMLToHTML @EligibilityVerificationRequestId = @EligibilityVerificationRequestId  
  
        END TRY  
        BEGIN CATCH   
            IF XACT_STATE() <> 0   
                ROLLBACK TRANSACTION;  
  
            IF ERROR_NUMBER() <> 0   
                EXECUTE dbo.ssp_RethrowError   -- this throws error number 50000 to the client with info in the message  
                             
        END CATCH;  
  
        RETURN  
    END  
  







GO

