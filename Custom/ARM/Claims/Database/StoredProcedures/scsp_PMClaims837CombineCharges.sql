IF OBJECT_ID('scsp_PMClaims837CombineCharges') IS NOT NULL
    DROP PROCEDURE scsp_PMClaims837CombineCharges
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[scsp_PMClaims837CombineCharges]
    @CurrentUser VARCHAR(30) ,
    @ClaimFormatId INT ,
    @ClaimBatchId INT ,
    @FormatType CHAR(1) ,
    @ExecuteCombineChargesSCSP CHAR(1) OUTPUT
AS
    SET ANSI_WARNINGS OFF

/******************************************************************************************/
--  6/30/2017	MJensen	Combine charges for Ohio medicaid  ARM enhancements task 19
--  2/09/2018	NJain	Updated to ignore ClinicianId when bundling. ARM Enhancements 19.16
--  2/16/2018	NJain	Updated to ignore ProcedureCodeId and ClientCoveragePlanId when bundling
-- 01/10/2019   Dknewtson Correcting JOIN to pick up ClaimLineId from ClaimLines back to charges to prevent errors when generating claims
--						  A Renewed Mind - Support 1042
-- 03/14/2019	dknewtson Correcting the NULL case for inpatient admit date per code reveiw - ARM Support 1042
/******************************************************************************************/
    BEGIN TRY
        SET @ExecuteCombineChargesSCSP = 'N'

        IF EXISTS ( SELECT  cf.FormatName
                    FROM    ClaimBatches cb
                            JOIN ClaimFormats cf ON cb.ClaimFormatId = cf.ClaimFormatId
                            JOIN ( SELECT   IntegerCodeId
                                   FROM     dbo.ssf_RecodeValuesCurrent('XBHREDESIGNCLAIMFORMATS')
                                 ) AS rc ON rc.integerCodeId = cf.ClaimFormatId
                    WHERE   cb.ClaimBatchId = @ClaimBatchId )
            BEGIN
                SET @ExecuteCombineChargesSCSP = 'Y'

                CREATE TABLE #Groups
                    (
                      ChargeId INT ,
                      ClaimFormatId INT ,
                      CoveragePlanId INT ,
                      BillingProviderIdGroup VARCHAR(35) ,
                      RenderingProviderIdGroup VARCHAR(35) ,
                      ClinicianIdGroup INT ,
                      ProcedureCodeIdGroup INT ,
                      ClientIdGroup INT ,
                      AuthorizationIdGroup INT ,
                      DateOfServiceGroup DATETIME ,
                      ClientCoveragePlanIdGroup INT ,
                      PlaceOfServiceGroup INT ,
                      SubmissionReasonCodeGroup CHAR(1) ,
                      BillingCodeGroup VARCHAR(15) ,
                      Modifier1Group VARCHAR(2) ,
                      Modifier2Group VARCHAR(2) ,
                      Modifier3Group VARCHAR(2) ,
                      Modifier4Group VARCHAR(2) ,
                      GroupIdGroup INT ,
                      RevenueCodeGroup VARCHAR(15) ,
                      RevenueCodeDescriptionGroup VARCHAR(15) ,
                      InpatientAdmitDateGroup DATETIME ,
                      SupervisingProvider2310DIdGroup VARCHAR(80) NULL ,
                      RenderingProviderNPIGroup CHAR(10) NULL
                    )

                INSERT  INTO #Groups
                        ( ChargeId ,
                          ClaimFormatId ,
                          CoveragePlanId ,
                          BillingProviderIdGroup ,
                          RenderingProviderIdGroup ,
                          ClinicianIdGroup ,
                          ProcedureCodeIdGroup ,
                          ClientIdGroup ,
                          AuthorizationIdGroup ,
                          DateOfServiceGroup ,
                          ClientCoveragePlanIdGroup ,
                          PlaceOfServiceGroup ,
                          SubmissionReasonCodeGroup ,
                          BillingCodeGroup ,
                          Modifier1Group ,
                          Modifier2Group ,
                          Modifier3Group ,
                          Modifier4Group ,
                          GroupIdGroup ,
                          RevenueCodeGroup ,
                          RevenueCodeDescriptionGroup ,
                          InpatientAdmitDateGroup ,
                          SupervisingProvider2310DIdGroup ,
                          RenderingProviderNPIGroup
			            )
                        SELECT  a.ChargeId ,
                                @ClaimFormatId ,
                                a.CoveragePlanId ,
                                a.BillingProviderId ,
                                a.RenderingProviderId ,
                                a.ClinicianId ,
                                a.ProcedureCodeId ,
                                a.ClientId ,
                                a.AuthorizationId ,
                                a.DateOfService ,
                                a.ClientCoveragePlanId ,
                                a.PlaceofServiceCode ,
                                a.SubmissionReasonCode ,
                                a.BillingCode ,
                                a.Modifier1 ,
                                a.Modifier2 ,
                                a.Modifier3 ,
                                a.Modifier4 ,
                                a.GroupId ,
                                a.RevenueCode ,
                                a.RevenueCodeDescription ,
                                a.InpatientAdmitDate ,
                                a.SupervisingProvider2310DId ,
                                a.RenderingProviderNPI
                        FROM    #Charges a

		--	When supervisor used, do not group by rendering
                UPDATE  #Groups
                SET     DateOfServiceGroup = CAST(DateOfServiceGroup AS DATE) ,
                        RenderingProviderNPIGroup = CASE WHEN SupervisingProvider2310DIdGroup IS NOT NULL THEN NULL
                                                         ELSE RenderingProviderNPIGroup
                                                    END

		-- Combine claims     
                INSERT  INTO #ClaimLines
                        ( BillingProviderId ,
                          RenderingProviderId ,
                          ClientId ,
                          --ClinicianId ,
                          AuthorizationId ,
                          --ProcedureCodeId ,
                          DateOfService ,
                          --ClientCoveragePlanId ,
                          PlaceOfService ,
                          ServiceUnits ,
                          ChargeAmount ,
                          ClientPayment ,
                          ChargeId ,
                          SubmissionReasonCode ,
                          BillingCode ,
                          Modifier1 ,
                          Modifier2 ,
                          Modifier3 ,
                          Modifier4 ,
                          GroupId ,
                          RevenueCode ,
                          RevenueCodeDescription ,
                          ClaimUnits ,
                          InpatientAdmitDate ,
                          SupervisingProvider2310DId ,
                          RenderingProviderNPI
			            )
                        SELECT  b.BillingProviderIdGroup ,
                                b.RenderingProviderIdGroup ,
                                b.ClientIdGroup ,
                                --b.ClinicianIdGroup ,
                                b.AuthorizationIdGroup ,
                                --b.ProcedureCodeIdGroup ,
                                b.DateOfServiceGroup ,
                                --b.ClientCoveragePlanIdGroup ,
                                b.PlaceOfServiceGroup ,
                                SUM(a.ServiceUnits) ,
                                SUM(a.ChargeAmount) ,
                                SUM(a.ClientPayment) ,
                                MAX(a.ChargeId) ,
                                b.SubmissionReasonCodeGroup ,
                                b.BillingCodeGroup ,
                                b.Modifier1Group ,
                                b.Modifier2Group ,
                                b.Modifier3Group ,
                                b.Modifier4Group ,
                                b.GroupIdGroup ,
                                b.RevenueCodeGroup ,
                                b.RevenueCodeDescriptionGroup ,
                                SUM(a.ClaimUnits) ,
                                b.InpatientAdmitDateGroup ,
                                b.SupervisingProvider2310DIdGroup ,
                                b.RenderingProviderNPIGroup
                        FROM    #Charges a
                                JOIN #Groups b ON a.ChargeId = b.ChargeId
                        GROUP BY b.BillingProviderIdGroup ,
                                b.RenderingProviderIdGroup ,
                                b.ClientIdGroup ,
                                --b.ClinicianIdGroup ,
                                b.AuthorizationIdGroup ,
                                --b.ProcedureCodeIdGroup ,
                                b.DateOfServiceGroup ,
                                --b.ClientCoveragePlanIdGroup ,
                                b.PlaceOfServiceGroup ,
                                b.SubmissionReasonCodeGroup ,
                                b.BillingCodeGroup ,
                                b.Modifier1Group ,
                                b.Modifier2Group ,
                                b.Modifier3Group ,
                                b.Modifier4Group ,
                                b.GroupIdGroup ,
                                b.RevenueCodeGroup ,
                                b.RevenueCodeDescriptionGroup ,
                                b.InpatientAdmitDateGroup ,
                                b.SupervisingProvider2310DIdGroup ,
                                b.RenderingProviderNPIGroup

		-- Don't need Rev Code in Professional Claims
                UPDATE  #Charges
                SET     RevenueCode = NULL ,
                        RevenueCodeDescription = NULL

                UPDATE  #ClaimLines
                SET     RevenueCode = NULL ,
                        RevenueCodeDescription = NULL

                UPDATE  #Groups
                SET     RevenueCodeGroup = NULL ,
                        RevenueCodeDescriptionGroup = NULL

                UPDATE  a
                SET     a.ClaimLineId = b.ClaimLineId
                FROM    #Charges a
                        JOIN #Groups g ON ( a.ChargeId = g.ChargeId )
                        JOIN #ClaimLines b ON ISNULL(b.RenderingProviderNPI, '') = ISNULL(g.RenderingProviderNPIGroup, '')
                                              AND ISNULL(b.SupervisingProvider2310DId, '') = ISNULL(g.SupervisingProvider2310DIdGroup, '')
                                              AND ISNULL(b.ClientId, '') = ISNULL(g.ClientIdGroup, '')
                                              --AND ISNULL(b.ClientCoveragePlanId, '') = ISNULL(g.ClientCoveragePlanIdGroup, '')
                                              AND ISNULL(b.PlaceOfService, '') = ISNULL(g.PlaceOfServiceGroup, '')
                                              AND ISNULL(b.SubmissionReasonCode, '') = ISNULL(g.SubmissionReasonCodeGroup, '')
                                              AND ISNULL(b.BillingCode, '') = ISNULL(g.BillingCodeGroup, '')
                                              AND ISNULL(b.Modifier1, '') = ISNULL(g.Modifier1Group, '')
                                              AND ISNULL(b.Modifier2, '') = ISNULL(g.Modifier2Group, '')
                                              AND ISNULL(b.Modifier3, '') = ISNULL(g.Modifier3Group, '')
                                              AND ISNULL(b.Modifier4, '') = ISNULL(g.Modifier4Group, '')
                                              AND ISNULL(b.DateOfService, '19000101') = ISNULL(g.DateOfServiceGroup, '19000101')
											  AND ISNULL(b.BillingProviderId,'') = ISNULL(g.BillingProviderIdGroup,'') 
											  AND ISNULL(b.RenderingProviderId,'') = ISNULL(g.RenderingProviderIdGroup,'') 
											  AND ISNULL(b.AuthorizationId,'') = ISNULL(g.AuthorizationIdGroup,'')
											  AND ISNULL(b.GroupId,'') = ISNULL(g.GroupIdGroup,'')
											  AND ISNULL(b.RevenueCode,'') = ISNULL(g.RevenueCodeGroup,'') 
											  AND ISNULL(b.RevenueCodeDescription,'') = ISNULL(g.RevenueCodeDescriptionGroup,'') 
											  AND ISNULL(b.InpatientAdmitDate,'1900-1-1') = ISNULL(g.InpatientAdmitDateGroup,'1900-1-1') 
                                
                UPDATE  a
                SET     a.ClientId = b.ClientId ,
                        a.ClientLastName = b.ClientLastName ,
                        a.ClientFirstname = b.ClientFirstname ,
                        a.ClientMiddleName = b.ClientMiddleName ,
                        a.ClientSSN = b.ClientSSN ,
                        a.ClientSuffix = b.ClientSuffix ,
                        a.ClientAddress1 = b.ClientAddress1 ,
                        a.ClientAddress2 = b.ClientAddress2 ,
                        a.ClientCity = b.ClientCity ,
                        a.ClientState = b.ClientState ,
                        a.ClientZip = b.ClientZip ,
                        a.ClientHomePhone = b.ClientHomePhone ,
                        a.ClientDOB = b.ClientDOB ,
                        a.ClientSex = b.ClientSex ,
                        a.ClientIsSubscriber = b.ClientIsSubscriber ,
                        a.SubscriberContactId = b.SubscriberContactId ,
                        a.MaritalStatus = b.MaritalStatus ,
                        a.EmploymentStatus = b.EmploymentStatus ,
                        a.RegistrationDate = b.RegistrationDate ,
                        a.DischargeDate = b.DischargeDate ,
                        a.InsuredId = b.InsuredId ,
                        a.GroupNumber = b.GroupNumber ,
                        a.GroupName = b.GroupName ,
                        a.InsuredLastName = b.InsuredLastName ,
                        a.InsuredFirstName = b.InsuredFirstName ,
                        a.InsuredMiddleName = b.InsuredMiddleName ,
                        a.InsuredSuffix = b.InsuredSuffix ,
                        a.InsuredRelation = b.InsuredRelation ,
                        a.InsuredAddress1 = b.InsuredAddress1 ,
                        a.InsuredAddress2 = b.InsuredAddress2 ,
                        a.InsuredCity = b.InsuredCity ,
                        a.InsuredState = b.InsuredState ,
                        a.InsuredZip = b.InsuredZip ,
                        a.InsuredHomePhone = b.InsuredHomePhone ,
                        a.InsuredSex = b.InsuredSex ,
                        a.InsuredSSN = b.InsuredSSN ,
                        a.InsuredDOB = b.InsuredDOB ,
			--a.ServiceId = b.ServiceId ,
                        a.ServiceUnitType = b.ServiceUnitType ,
                        a.ProgramId = b.ProgramId ,
                        a.LocationId = b.LocationId ,
			--ClinicianId = b.ClinicianId ,
                        a.ClinicianLastName = b.ClinicianLastName ,
                        a.ClinicianFirstName = b.ClinicianFirstName ,
                        a.ClinicianMiddleName = b.ClinicianMiddleName ,
                        a.ClinicianSex = b.ClinicianSex ,
                        a.AttendingId = b.AttendingId ,
                        a.Priority = b.Priority ,
                        a.CoveragePlanId = b.CoveragePlanId ,
                        a.MedicaidPayer = b.MedicaidPayer ,
                        a.MedicarePayer = b.MedicarePayer ,
                        a.PayerName = b.PayerName ,
                        a.PayerAddressHeading = b.PayerAddressHeading ,
                        a.PayerAddress1 = b.PayerAddress1 ,
                        a.PayerAddress2 = b.PayerAddress2 ,
                        a.PayerCity = b.PayerCity ,
                        a.PayerState = b.PayerState ,
                        a.PayerZip = b.PayerZip ,
                        a.ProviderCommercialNumber = b.ProviderCommercialNumber ,
                        a.InsuranceCommissionersCode = b.InsuranceCommissionersCode ,
                        a.MedicareInsuranceTypeCode = b.MedicareInsuranceTypeCode ,
                        a.ClaimFilingIndicatorCode = b.ClaimFilingIndicatorCode ,
                        a.ElectronicClaimsPayerId = b.ElectronicClaimsPayerId ,
                        a.ClaimOfficeNumber = b.ClaimOfficeNumber ,
                        a.AuthorizationNumber = b.AuthorizationNumber ,
                        a.PlaceOfServiceCode = b.PlaceOfServiceCode ,
                        a.AgencyName = b.AgencyName ,
                        a.PaymentAddress1 = b.PaymentAddress1 ,
                        a.PaymentAddress2 = b.PaymentAddress2 ,
                        a.PaymentCity = b.PaymentCity ,
                        a.PaymentState = b.PaymentState ,
                        a.PaymentZip = b.PaymentZip ,
                        a.PaymentPhone = b.PaymentPhone ,
                        a.BillingProviderTaxIdType = b.BillingProviderTaxIdType ,
                        a.BillingProviderTaxId = b.BillingProviderTaxId ,
                        a.BillingProviderIdType = b.BillingProviderIdType ,
			--BillingProviderId = b.BillingProviderId ,
                        a.BillingTaxonomyCode = b.BillingTaxonomyCode ,
                        a.BillingProviderLastName = b.BillingProviderLastName ,
                        a.BillingProviderFirstName = b.BillingProviderFirstName ,
                        a.BillingProviderMiddleName = b.BillingProviderMiddleName ,
                        a.BillingProviderNPI = b.BillingProviderNPI ,
                        a.PayToProviderTaxIdType = b.PayToProviderTaxIdType ,
                        a.PayToProviderTaxId = b.PayToProviderTaxId ,
                        a.PayToProviderIdType = b.PayToProviderIdType ,
                        a.PayToProviderId = b.PayToProviderId ,
                        a.PayToProviderLastName = b.PayToProviderLastName ,
                        a.PayToProviderFirstName = b.PayToProviderFirstName ,
                        a.PayToProviderMiddleName = b.PayToProviderMiddleName ,
                        a.PayToProviderNPI = b.PayToProviderNPI ,
                        a.RenderingProviderTaxIdType = b.RenderingProviderTaxIdType ,
                        a.RenderingProviderTaxId = b.RenderingProviderTaxId ,
                        a.RenderingProviderIdType = b.RenderingProviderIdType ,
			--RenderingProviderId = b.RenderingProviderId ,
                        a.RenderingProviderLastName = b.RenderingProviderLastName ,
                        a.RenderingProviderFirstName = b.RenderingProviderFirstName ,
                        a.RenderingProviderMiddleName = b.RenderingProviderMiddleName ,
                        a.RenderingProviderTaxonomyCode = b.RenderingProviderTaxonomyCode ,
                        a.RenderingProviderNPI = b.RenderingProviderNPI ,
                        a.ReferringId = b.ReferringId ,
                        a.ReferringProviderNPI = b.ReferringProviderNPI ,
                        a.FacilityEntityCode = b.FacilityEntityCode ,
                        a.FacilityName = b.FacilityName ,
                        a.FacilityTaxIdType = b.FacilityTaxIdType ,
                        a.FacilityTaxId = b.FacilityTaxId ,
                        a.FacilityProviderIdType = b.FacilityProviderIdType ,
                        a.FacilityProviderId = b.FacilityProviderId ,
                        a.FacilityAddress1 = b.FacilityAddress1 ,
                        a.FacilityAddress2 = b.FacilityAddress2 ,
                        a.FacilityCity = b.FacilityCity ,
                        a.FacilityState = b.FacilityState ,
                        a.FacilityZip = b.FacilityZip ,
                        a.FacilityPhone = b.FacilityPhone ,
                        a.FacilityNPI = b.FacilityNPI ,
                        a.SupervisingProvider2310DLastName = b.SupervisingProvider2310DLastName ,
                        a.SupervisingProvider2310DFirstName = b.SupervisingProvider2310DFirstName ,
                        a.SupervisingProvider2310DMiddleName = b.SupervisingProvider2310DMiddleName ,
                        a.SupervisingProvider2310DIdType = b.SupervisingProvider2310DIdType ,
                        a.SupervisingProvider2310DId = b.SupervisingProvider2310DId ,
                        a.SupervisingProvider2310DSecondaryIdType1 = b.SupervisingProvider2310DSecondaryIdType1 ,
                        a.SupervisingProvider2310DSecondaryId1 = b.SupervisingProvider2310DSecondaryId1 ,
                        a.SupervisingProvider2310DSecondaryIdType2 = b.SupervisingProvider2310DSecondaryIdType2 ,
                        a.SupervisingProvider2310DSecondaryId2 = b.SupervisingProvider2310DSecondaryId2 ,
                        a.SupervisingProvider2310DSecondaryIdType3 = b.SupervisingProvider2310DSecondaryIdType3 ,
                        a.SupervisingProvider2310DSecondaryId3 = b.SupervisingProvider2310DSecondaryId3 ,
                        a.SupervisingProvider2310DSecondaryIdType4 = b.SupervisingProvider2310DSecondaryIdType4 ,
                        a.SupervisingProvider2310DSecondaryId4 = b.SupervisingProvider2310DSecondaryId4 ,
                        a.ServiceLineFacilityEntityCode = b.ServiceLineFacilityEntityCode ,
                        a.ServiceLineFacilityName = b.ServiceLineFacilityName ,
                        a.ServiceLineFacilityTaxIdType = b.ServiceLineFacilityTaxIdType ,
                        a.ServiceLineFacilityTaxId = b.ServiceLineFacilityTaxId ,
                        a.ServiceLineFacilityProviderIdType = b.ServiceLineFacilityProviderIdType ,
                        a.ServiceLineFacilityProviderId = b.ServiceLineFacilityProviderId ,
                        a.ServiceLineFacilityAddress1 = b.ServiceLineFacilityAddress1 ,
                        a.ServiceLineFacilityAddress2 = b.ServiceLineFacilityAddress2 ,
                        a.ServiceLineFacilityCity = b.ServiceLineFacilityCity ,
                        a.ServiceLineFacilityState = b.ServiceLineFacilityState ,
                        a.ServiceLineFacilityZip = b.ServiceLineFacilityZip ,
                        a.ServiceLineFacilityPhone = b.ServiceLineFacilityPhone ,
                        a.ServiceLineFacilityNPI = b.ServiceLineFacilityNPI ,
                        a.VoidedClaimLineItemId = b.VoidedClaimLineItemId ,
                        a.ClaimNoteReferenceCode = b.ClaimNoteReferenceCode ,
                        a.ClaimNote = b.ClaimNote ,
                        a.ServiceNoteReferenceCode = b.ServiceNoteReferenceCode ,
                        a.ServiceNote = b.ServiceNote ,
                        a.PayerClaimControlNumber = b.PayerClaimControlNumber ,
                        a.BillingProviderId = CASE WHEN a.BillingProviderId IS NULL THEN b.BillingProviderId
                                                   ELSE a.BillingProviderId
                                              END ,
                        a.RenderingProviderId = CASE WHEN a.RenderingProviderId IS NULL THEN b.RenderingProviderId
                                                     ELSE a.RenderingProviderId
                                                END ,
                        a.ClinicianId = CASE WHEN a.ClinicianId IS NULL THEN b.ClinicianId
                                             ELSE a.ClinicianId
                                        END ,
                        a.ProcedureCodeId = CASE WHEN a.ProcedureCodeId IS NULL THEN b.ProcedureCodeId
                                                 ELSE a.ProcedureCodeId
                                            END ,
                        a.AuthorizationId = CASE WHEN a.AuthorizationId IS NULL THEN b.AuthorizationId
                                                 ELSE a.AuthorizationId
                                            END ,
                        a.DateOfService = CASE WHEN a.DateOfService IS NULL THEN b.DateOfService
                                               ELSE a.DateOfService
                                          END ,
                        a.ClientCoveragePlanId = CASE WHEN a.ClientCoveragePlanId IS NULL THEN b.ClientCoveragePlanId
                                                      ELSE a.ClientCoveragePlanId
                                                 END ,
                        a.PlaceOfService = CASE WHEN a.PlaceOfService IS NULL THEN b.PlaceOfService
                                                ELSE a.PlaceOfService
                                           END ,
                        a.SubmissionReasonCode = CASE WHEN a.SubmissionReasonCode IS NULL THEN b.SubmissionReasonCode
                                                      ELSE a.SubmissionReasonCode
                                                 END ,
                        a.BillingCode = CASE WHEN a.BillingCode IS NULL THEN b.BillingCode
                                             ELSE a.BillingCode
                                        END ,
                        a.Modifier1 = CASE WHEN a.Modifier1 IS NULL THEN b.Modifier1
                                           ELSE a.Modifier1
                                      END ,
                        a.Modifier2 = CASE WHEN a.Modifier2 IS NULL THEN b.Modifier2
                                           ELSE a.Modifier2
                                      END ,
                        a.Modifier3 = CASE WHEN a.Modifier3 IS NULL THEN b.Modifier3
                                           ELSE a.Modifier3
                                      END ,
                        a.Modifier4 = CASE WHEN a.Modifier4 IS NULL THEN b.Modifier4
                                           ELSE a.Modifier4
                                      END ,
                        a.GroupId = CASE WHEN a.GroupId IS NULL THEN b.GroupId
                                         ELSE a.GroupId
                                    END ,
                        a.RevenueCode = CASE WHEN a.RevenueCode IS NULL THEN b.RevenueCode
                                             ELSE a.RevenueCode
                                        END ,
                        a.RevenueCodeDescription = CASE WHEN a.RevenueCodeDescription IS NULL THEN b.RevenueCodeDescription
                                                        ELSE a.RevenueCodeDescription
                                                   END ,
                        a.InpatientAdmitDate = CASE WHEN a.InpatientAdmitDate IS NULL THEN b.InpatientAdmitDate
                                                    ELSE a.InpatientAdmitDate
                                               END
                FROM    #ClaimLines a
                        JOIN #Charges b ON ( a.ChargeId = b.ChargeId )
            END
    END TRY

    BEGIN CATCH
        DECLARE @Error VARCHAR(8000)

        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'scsp_PMClaims837CombineCharges ') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

        RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
    END CATCH
GO

