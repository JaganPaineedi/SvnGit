/****** Object:  StoredProcedure [dbo].[ssp_PMClaimsGetProviderIds]    Script Date: 11/18/2011 16:25:44 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PMClaimsGetProviderIds]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_PMClaimsGetProviderIds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ssp_PMClaimsGetProviderIds]
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_PMClaimsGetProviderIds                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */
/* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  9/25/06   JHB	  Created										 */
/*  9/4/2013  dknewtson	Changed default Rendering Provider ID type from 24 to XX for 5010 Compliance		 */
/*  3/12/2014 NJain      Use NPI from Staff table only when Staff Id in CoveragePlanProviderIds is not null  */
/*	8/17/2015 NJain		 Use Staff Last Name only when Staff Id in CoveragePlanProviderIds is not null*/
/*  9/8/2015  NJain		 Added the condition for Rendering Provider Tax Id Type: WHEN h.NationalProviderId IS NOT NULL THEN 'XX' 
						 This field gets set to XX even when Rendering NPI is null, and in the 837 we send XX with Agency Tax Id	*/
/*	9/21/2015 NJain		 Updated to use Agency Taxonomy when Staff is not the billing provider*/						 
/*********************************************************************/
    CREATE TABLE #ProviderIds
        (
          ChargeId INT NOT NULL ,
          BillingProviderTaxIdType VARCHAR(2) NULL ,
          BillingProviderTaxId VARCHAR(9) NULL ,
          BillingProviderIdType VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(35) NULL ,
          BillingTaxonomyCode VARCHAR(30) NULL ,
          BillingProviderLastName VARCHAR(35) NULL ,
          BillingProviderFirstName VARCHAR(25) NULL ,
          BillingProviderMiddleName VARCHAR(25) NULL ,
          BillingProviderNPI CHAR(10) NULL ,
          PayToProviderTaxIdType VARCHAR(2) NULL ,
          PayToProviderTaxId VARCHAR(9) NULL ,
          PayToProviderIdType VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(35) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(25) NULL ,
          PayToProviderMiddleName VARCHAR(25) NULL ,
          PayToProviderNPI CHAR(10) NULL ,
          RenderingProviderTaxIdType VARCHAR(2) NULL ,
          RenderingProviderTaxId VARCHAR(9) NULL ,
          RenderingProviderIdType VARCHAR(2) NULL ,
          RenderingProviderId VARCHAR(35) NULL ,
          RenderingProviderLastName VARCHAR(35) NULL ,
          RenderingProviderFirstName VARCHAR(25) NULL ,
          RenderingProviderMiddleName VARCHAR(25) NULL ,
          RenderingProviderTaxonomyCode VARCHAR(20) NULL ,
          RenderingProviderNPI CHAR(10) NULL,
        )

    IF @@error <> 0
        RETURN

    INSERT  INTO #ProviderIds
            ( ChargeId ,
              BillingProviderTaxIdType ,
              BillingProviderTaxId ,
              BillingProviderIdType ,
              BillingProviderId ,
              BillingProviderLastName ,
              BillingProviderNPI ,
              BillingTaxonomyCode ,
              PayToProviderTaxIdType ,
              PayToProviderTaxId ,
              PayToProviderIdType ,
              PayToProviderId ,
              PayToProviderLastName ,
              PayToProviderNPI
            )
            SELECT  a.ChargeId ,
                    '24' ,
                    REPLACE(REPLACE(g.TaxId, '-', RTRIM('')), ' ', RTRIM('')) ,
                    f.ExternalCode1 ,
                    REPLACE(REPLACE(e.ProviderId, '-', RTRIM('')), ' ', RTRIM('')) ,
                    g.AgencyName ,
                    g.NationalProviderId ,
                    g.BillingTaxonomy ,
                    '24' ,
                    REPLACE(REPLACE(g.TaxId, '-', RTRIM('')), ' ', RTRIM('')) ,
                    f.ExternalCode1 ,
                    REPLACE(REPLACE(e.ProviderId, '-', RTRIM('')), ' ', RTRIM('')) ,
                    g.AgencyName ,
                    g.NationalProviderId
            FROM    #Charges a --JOIN Charges b ON (a.ChargeId = b.ChargeId)
--JOIN Services c ON (b.ServiceId = c.ServiceId)
--JOIN ClientCoveragePlans d ON (b.ClientCoveragePlanId = d.ClientCoveragePlanId)
                    JOIN CoveragePlans e ON ( a.CoveragePlanId = e.CoveragePlanId )
                    LEFT JOIN GlobalCodes f ON ( e.ProviderIdType = f.GlobalCodeId )
                    CROSS JOIN Agency g

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     BillingProviderTaxIdType = CASE WHEN h.StaffId IS NOT NULL THEN '34'
                                            ELSE a.BillingProviderTaxIdType
                                       END ,
            BillingProviderTaxId = CASE WHEN h.StaffId IS NOT NULL THEN REPLACE(REPLACE(h.SSN, '-', RTRIM('')), ' ', RTRIM(''))
                                        ELSE a.BillingProviderTaxId
                                   END ,
            BillingProviderIdType = SUBSTRING(g.ExternalCode1, 1, 2) ,
            BillingProviderId = REPLACE(REPLACE(f.ProviderId, '-', RTRIM('')), ' ', RTRIM('')) ,
            BillingTaxonomyCode = CASE WHEN f.StaffId IS NOT NULL THEN i.ExternalCode1
                                       ELSE a.BillingTaxonomyCode
                                  END ,
            BillingProviderLastName = CASE WHEN f.StaffId IS NOT NULL THEN h.LastName
                                           ELSE a.BillingProviderLastName
                                      END ,
            BillingProviderFirstName = h.FirstName ,
            BillingProviderMiddleName = h.MiddleName ,
            BillingProviderNPI = CASE WHEN f.StaffId IS NOT NULL THEN h.NationalProviderId
                                      ELSE a.BillingProviderNPI
                                 END
    FROM    #ProviderIds a
            JOIN #Charges b ON ( a.ChargeId = b.ChargeId )
--JOIN Charges b ON (a.ChargeId = b.ChargeId)
--JOIN Services c ON (b.ServiceId = c.ServiceId)
--JOIN ClientCoveragePlans d ON (b.ClientCoveragePlanId = d.ClientCoveragePlanId)
            JOIN CoveragePlans e ON ( b.CoveragePlanId = e.CoveragePlanId )
            LEFT JOIN CoveragePlanProviderIds f ON ( e.CoveragePlanId = f.CoveragePlanId
                                                     AND f.Active = 'Y'
                                                     AND ISNULL(f.RecordDeleted, 'N') = 'N'
                                                     AND ( f.ProgramId IS NULL
                                                           OR b.ProgramId = f.ProgramId
                                                         )
                                                     AND ( f.StaffId IS NULL
                                                           OR b.ClinicianId = f.StaffId
                                                         )
                                                   )
            LEFT JOIN GlobalCodes g ON ( f.ProviderIdType = g.GlobalCodeId )
            LEFT JOIN Staff h ON ( f.StaffId = h.StaffId
                                   AND h.StaffId = b.ClinicianId
                                 )
            LEFT JOIN GlobalCodes i ON ( h.TaxonomyCode = i.GlobalCodeId )
    WHERE   ISNULL(f.BillingProvider, 'N') = 'Y'

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     RenderingProviderTaxIdType = CASE WHEN f.ProviderId IS NOT NULL THEN '34'
                                              WHEN h.NationalProviderId IS NOT NULL THEN 'XX'
                                              ELSE NULL
                                         END ,
            RenderingProviderTaxId = CASE WHEN f.ProviderId IS NOT NULL THEN REPLACE(REPLACE(h.SSN, '-', RTRIM('')), ' ', RTRIM(''))
                                          ELSE REPLACE(REPLACE(j.TaxId, '-', RTRIM('')), ' ', RTRIM(''))
                                     END ,
            RenderingProviderIdType = CASE WHEN f.ProviderId IS NOT NULL THEN SUBSTRING(g.ExternalCode1, 1, 2)
                                           ELSE NULL
                                      END ,
            RenderingProviderId = CASE WHEN f.ProviderId IS NOT NULL THEN REPLACE(REPLACE(f.ProviderId, '-', RTRIM('')), ' ', RTRIM(''))
                                       ELSE NULL
                                  END ,
            RenderingProviderLastName = h.LastName ,
            RenderingProviderFirstName = h.FirstName ,
            RenderingProviderMiddleName = h.MiddleName ,
            RenderingProviderTaxonomyCode = i.ExternalCode1 ,
            RenderingProviderNPI = h.NationalProviderId
    FROM    #ProviderIds a
            JOIN #Charges b ON ( a.ChargeId = b.ChargeId )
--JOIN Charges b ON (a.ChargeId = b.ChargeId)
--JOIN Services c ON (b.ServiceId = c.ServiceId)
--JOIN ClientCoveragePlans d ON (b.ClientCoveragePlanId = d.ClientCoveragePlanId)
            JOIN CoveragePlans e ON ( b.CoveragePlanId = e.CoveragePlanId )
            LEFT JOIN CoveragePlanProviderIds f ON ( e.CoveragePlanId = f.CoveragePlanId
                                                     AND f.Active = 'Y'
                                                     AND ISNULL(f.RecordDeleted, 'N') = 'N'
                                                     AND ( f.ProgramId IS NULL
                                                           OR b.ProgramId = f.ProgramId
                                                         )
                                                     AND ( f.StaffId IS NULL
                                                           OR b.ClinicianId = f.StaffId
                                                         )
                                                   )
            LEFT JOIN GlobalCodes g ON ( f.ProviderIdType = g.GlobalCodeId )
            JOIN Staff h ON ( b.ClinicianId = h.StaffId )
            LEFT JOIN GlobalCodes i ON ( h.TaxonomyCode = i.GlobalCodeId )
            CROSS JOIN Agency j
    WHERE   ISNULL(f.BillingProvider, 'N') = 'N'

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     BillingProviderTaxIdType = b.BillingProviderTaxIdType ,
            BillingProviderTaxId = b.BillingProviderTaxId ,
            BillingProviderIdType = b.BillingProviderIdType ,
            BillingProviderId = b.BillingProviderId ,
            BillingTaxonomyCode = b.BillingTaxonomyCode ,
            BillingProviderLastName = b.BillingProviderLastName ,
            BillingProviderFirstName = b.BillingProviderFirstName ,
            BillingProviderMiddleName = b.BillingProviderMiddleName ,
            BillingProviderNPI = b.BillingProviderNPI ,
            PayToProviderTaxIdType = b.PayToProviderTaxIdType ,
            PayToProviderTaxId = b.PayToProviderTaxId ,
            PayToProviderIdType = b.PayToProviderIdType ,
            PayToProviderId = b.PayToProviderId ,
            PayToProviderLastName = b.PayToProviderLastName ,
            PayToProviderFirstName = b.PayToProviderFirstName ,
            PayToProviderMiddleName = b.PayToProviderMiddleName ,
            PayToProviderNPI = b.PayToProviderNPI ,
            RenderingProviderTaxIdType = b.RenderingProviderTaxIdType ,
            RenderingProviderTaxId = b.RenderingProviderTaxId ,
            RenderingProviderIdType = b.RenderingProviderIdType ,
            RenderingProviderId = b.RenderingProviderId ,
            RenderingProviderLastName = b.RenderingProviderLastName ,
            RenderingProviderFirstName = b.RenderingProviderFirstName ,
            RenderingProviderMiddleName = b.RenderingProviderMiddleName ,
            RenderingProviderTaxonomyCode = b.RenderingProviderTaxonomyCode ,
            RenderingProviderNPI = b.RenderingProviderNPI
    FROM    #Charges a
            JOIN #ProviderIds b ON ( a.ChargeId = b.ChargeId )

    IF @@error <> 0
        RETURN

GO
