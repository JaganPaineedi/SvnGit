IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCQueryElectronicEligibilityClientInsured]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCQueryElectronicEligibilityClientInsured]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 CREATE PROCEDURE [dbo].[ssp_SCQueryElectronicEligibilityClientInsured]
    @ClientId AS INT ,    
    @ElectronicEligibilityVerificationPayerId AS INT = NULL, 
    @ClientCoveragePlanId AS INT    
AS -- =============================================     
-- Author:    Suhail Ali     
-- Create date: 2/9/2012     
-- Description:       
-- Return client info. for insurance verificaiton to pre-populate for request    
-- Pradeep : Added Group Number for the Task Philhaven Development #138 (Core Change)  
-- Kavya 21/Aug/2017  ElectronicPayerId input size and retriving variable size should be equall. MFS-Support Go Live #153   
-- Neelima 03/Jan/2018  ElectronicPayerId input size to varchar(25) instead of 5. KCMHSAS - Support #917
-- 11/27/2018	Vijay	What: Retriving ElectronicEligibilityVerificationPayerId column value to bind the Payers dropdown. 
--						Why: Bradford SGL #742
-- =============================================     
    BEGIN     
		BEGIN TRY
        DECLARE @ElectronicPayerId AS VARCHAR(25);     
    
        SELECT  @ElectronicPayerId = ElectronicPayerId    
        FROM    dbo.ElectronicEligibilityVerificationPayers    
        WHERE   ElectronicEligibilityVerificationPayerId = @ElectronicEligibilityVerificationPayerId;     
    
        IF EXISTS ( SELECT  *    
                    FROM    dbo.ClientCoveragePlans coverage    
                            INNER JOIN dbo.CoveragePlans plans    
                                ON ( coverage.CoveragePlanId = plans.CoveragePlanId )    
                            INNER JOIN [dbo].[ElectronicEligibilityVerificationPayers] payer    
                                ON payer.ElectronicEligibilityVerificationPayerId = plans.ElectronicEligibilityVerificationPayerId    
                    WHERE   ISNULL(coverage.RecordDeleted, 'N') = 'N'    
                            AND ISNULL(plans.RecordDeleted, 'N') = 'N'    
                            AND plans.Active = 'Y'    
                            AND ( ( ( plans.MedicaidPlan = 'Y'    
                                      OR EXISTS ( SELECT    *    
                                                  FROM      dbo.CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping imap    
                                                  WHERE     BenefitPlanCoverageDescription IN (    
                                                            'ABW', 'ABW-MC','DHS SOCIAL SERVICES')    
                                                            AND imap.CoveragePlanId = coverage.CoveragePlanId )    
                                    )    
                                    AND payer.ElectronicPayerName LIKE '%Medicaid%'    
                                  )    
                                  OR ( payer.ElectronicPayerName NOT LIKE '%Medicaid%' )    
                                )    
                            AND coverage.ClientId = @ClientId    
                            AND plans.ElectronicEligibilityVerificationPayerId = @ElectronicEligibilityVerificationPayerId    
                            AND ( coverage.ClientCoveragePlanId = @ClientCoveragePlanId    
                                  OR @ClientCoveragePlanId IS NULL    
                                ) )     
            WITH    coverage ( clientid, clientissubscriber, SubscriberContactId, insuredid, Rnk, ElectronicPayerId, ElectronicEligibilityVerificationPayerId, GroupNumber )    
                      AS ( SELECT   coverage.clientid ,    
                                    CASE WHEN coverage.ClientIsSubscriber = 'Y'    
                                         THEN 0    
                                         ELSE 1    
                                    END ,    
                                    coverage.SubscriberContactId ,    
                                    ISNULL(coverage.InsuredId, '') ,    
                                    ROW_NUMBER() OVER ( ORDER BY CASE    
                                                              WHEN coverage.InsuredId IS NOT NULL    
                                                              THEN 1    
                                                              ELSE 2    
                                                              END, cch.StartDate DESC) AS Rnk ,    
                                    ISNULL(payer.ElectronicPayerId, ''),    
                                    ISNULL(payer.ElectronicEligibilityVerificationPayerId, ''),    
                                    coverage.GroupNumber    
                           FROM     dbo.ClientCoveragePlans coverage    
                                    INNER JOIN dbo.CoveragePlans plans    
     ON ( coverage.CoveragePlanId = plans.CoveragePlanId )    
                                    INNER JOIN [dbo].[ElectronicEligibilityVerificationPayers] payer    
                                        ON payer.ElectronicEligibilityVerificationPayerId = plans.ElectronicEligibilityVerificationPayerId    
         LEFT OUTER JOIN dbo.ClientCoverageHistory cch    
          ON cch.ClientCoveragePlanId = coverage.ClientCoveragePlanId    
                           WHERE    ISNULL(coverage.RecordDeleted, 'N') = 'N'    
                                    AND ISNULL(plans.RecordDeleted, 'N') = 'N'    
                                    AND plans.Active = 'Y'    
                                    AND ( ( ( plans.MedicaidPlan = 'Y'    
                                              OR EXISTS ( SELECT    
                                                              *    
                                                          FROM    
                                                              dbo.CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping imap    
                                                          WHERE    
                                                              BenefitPlanCoverageDescription IN (    
                                                              'ABW', 'ABW-MC','DHS SOCIAL SERVICES' )    
                                                              AND imap.CoveragePlanId = coverage.CoveragePlanId )    
                                            )    
                                            AND payer.ElectronicPayerName LIKE '%Medicaid%'    
                                          )    
                                          OR ( payer.ElectronicPayerName NOT LIKE '%Medicaid%' )    
                                        )    
                                    AND coverage.ClientId = @ClientId    
                                    AND plans.ElectronicEligibilityVerificationPayerId = @ElectronicEligibilityVerificationPayerId    
                                    AND ( coverage.ClientCoveragePlanId = @ClientCoveragePlanId    
                                          OR @ClientCoveragePlanId IS NULL    
                                        )    
                         ),    
                    coverages ( clientid, clientissubscriber, insuredid, SubscriberContactId, ElectronicPayerId, ElectronicEligibilityVerificationPayerId, GroupNumber )    
                      AS ( SELECT DISTINCT    
                                    clientid ,    
                                    clientissubscriber ,    
                                    insuredid ,    
                                    SubscriberContactId ,    
                                    ElectronicPayerId,    
                                    ElectronicEligibilityVerificationPayerId,    
                                    GroupNumber    
                           FROM     coverage    
                           WHERE    Rnk = 1    
                         ),    
                    coveragewithagency ( clientid, clientissubscriber, insuredid, SubscriberContactId, ElectronicPayerId, ElectronicEligibilityVerificationPayerId, NationalProviderId ,GroupNumber)    
                      AS ( SELECT   clientid ,    
                                    clientissubscriber ,    
                                    insuredid ,    
                                    SubscriberContactId ,    
                                    ElectronicPayerId ,    
                                    ElectronicEligibilityVerificationPayerId,    
                                    ISNULL(b.NationalProviderId, ''),    
                                    GroupNumber    
                           FROM     coverages a    
                                    CROSS JOIN dbo.Agency b    
                         )    
                SELECT DISTINCT    
                        CAST(insuredid AS VARCHAR(25)) AS SubscriberInsuredId ,    
                        CAST(GroupNumber AS VARCHAR(25)) AS GroupNumber,    
                        RTRIM(CAST(@ElectronicPayerId AS VARCHAR(25))) AS ElectronicPayerId ,    
                        @ElectronicEligibilityVerificationPayerId AS ElectronicEligibilityVerificationPayerId , 
                        NationalProviderId ,    
                        ISNULL(CASE WHEN a.clientissubscriber = 0    
                                    THEN b.LastName    
                                    ELSE c.LastName                                 END, '') AS SubscriberLastName ,    
                        ISNULL(CASE WHEN a.clientissubscriber = 0    
                                    THEN b.FirstName    
                                    ELSE c.FirstName    
                               END, '') AS SubscriberFirstName ,    
                        ISNULL(CONVERT(VARCHAR, CASE WHEN a.clientissubscriber = 0    
                                                     THEN b.DOB    
                                                     ELSE c.dob    
                                                END, 101), '01/01/1900') AS SubscriberDOB ,    
                        ISNULL(CASE WHEN a.clientissubscriber = 0 THEN b.Sex    
                                    ELSE c.sex    
                               END, '') AS SubscriberSex ,    
                        ISNULL(CASE WHEN a.clientissubscriber = 0 THEN b.SSN    
                                    ELSE c.SSN    
                               END, '') AS SubscriberSSN ,    
                        CAST(CASE WHEN a.clientissubscriber = 0 THEN '18'    
                                  ELSE ISNULL(gc.ExternalCode1, '')    
                             END AS CHAR(2)) AS DependentRelationshipCode ,-- Self     
                        ISNULL(b.LastName, '') AS DependentLastName ,    
                        ISNULL(b.FirstName, '') AS DependentFirstName ,    
                        ISNULL(CONVERT(VARCHAR, b.DOB, 101), '01/01/1900') AS DependentDOB ,    
                        ISNULL(b.Sex, '') AS [DependentSex]    
                FROM    coveragewithagency a    
                        INNER JOIN clients b    
                            ON ( a.clientid = b.ClientId    
                                 AND ISNULL(b.RecordDeleted, 'N') = 'N'    
                                 AND a.clientissubscriber = 0    
                               )    
                        LEFT JOIN dbo.ClientContacts c    
                            ON ( a.clientissubscriber = 1    
                                 AND a.SubscriberContactId = c.ClientId    
                               )    
                        LEFT JOIN [dbo].GlobalCodes gc    
                            ON c.Relationship = gc.GlobalCodeId     
    
  -- no coverage plans exist for client for electronic payer so let's just return basic client info    
        ELSE     
            SELECT  CAST(NULL AS VARCHAR(25)) AS SubscriberInsuredId ,    
     CAST(NULL AS VARCHAR(25)) AS GroupNumber ,    
                    RTRIM(CAST(@ElectronicPayerId AS VARCHAR(25))) AS ElectronicPayerId , --   ElectronicPayerId size is taking same as input size.//kavya-MFS SupportgoLive 153
                    @ElectronicEligibilityVerificationPayerId AS ElectronicEligibilityVerificationPayerId , 
                    ISNULL(c.NationalProviderId, '') AS NationalProviderId ,    
                    ISNULL(b.LastName, '') AS SubscriberLastName ,    
                    ISNULL(b.FirstName, '') AS SubscriberFirstName ,    
                    ISNULL(CONVERT(VARCHAR, b.DOB, 101), '01/01/1900') AS SubscriberDOB ,    
                    b.Sex AS SubscriberSex ,    
                    b.SSN AS SubscriberSSN ,    
                    CAST('18' AS CHAR(2)) AS DependentRelationshipCode ,-- Self     
                    ISNULL(b.LastName, '') AS DependentLastName ,    
                    ISNULL(b.FirstName, '') AS DependentFirstName ,    
                    ISNULL(CONVERT(VARCHAR, b.DOB, 101), '01/01/1900') AS DependentDOB ,    
                    ISNULL(b.Sex, '') AS [DependentSex]    
            FROM    clients b    
                    CROSS JOIN dbo.Agency c    
            WHERE   ISNULL(b.RecordDeleted, 'N') = 'N'    
                    AND b.ClientId = @ClientId     
    
		END TRY
		BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCQueryElectronicEligibilityClientInsured') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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