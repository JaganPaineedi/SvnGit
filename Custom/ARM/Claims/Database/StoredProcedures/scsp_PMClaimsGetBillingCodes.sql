IF OBJECT_ID('scsp_PMClaimsGetBillingCodes','P') IS NOT NULL
DROP PROC scsp_PMClaimsGetBillingCodes
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_PMClaimsGetBillingCodes]
AS
BEGIN
/**************************************************************************************
   Procedure: scsp_PMClaimsGetBillingCodes
   
   Streamline Healthcare Solutions, LLC Copyright 2017

   Purpose: 

   Parameters: 
      

   Output: 
      

   Called By: 
*****************************************************************************************
   Revision History:
   6/7/2017 - Dknewtson - Created
   1/3/2018	- MJensen	- Use degree based on service area

*****************************************************************************************/

        DECLARE @BHRedesignEffecitiveDate DATETIME 
	
        SELECT  @BHRedesignEffecitiveDate = CAST(CASE WHEN ISDATE(sck.Value) = 1 THEN sck.Value
                                                      ELSE NULL
                                                 END AS DATETIME)
        FROM    dbo.SystemConfigurationKeys AS sck
        WHERE   sck.[Key] = 'XBHRedesignBillingDegreeLogicEffectiveDate'

		DECLARE @ServiceAreaSUDId INT

		SELECT @ServiceAreaSUDId = sa.ServiceAreaId
		FROM	ServiceAreas sa
		WHERE sa.ServiceAreaName = 'SA'
				AND Isnull(sa.RecordDeleted,'N') = 'N'
	

  insert  into #BillingCodes
          (ClaimLineId,
           ChargeId,
           BillingCode,
           Modifier1,
           Modifier2,
           Modifier3,
           Modifier4,
           RevenueCode,
           RevenueCodeDescription,
           ClaimUnits,
           Ranking)
  select  BCT.ClaimLineId,
          BCT.ChargeId,
          case when PR.Advanced = 'Y' then PRBC.BillingCode
               else PR.BillingCode
          end,
          case when PR.Advanced = 'Y' then PRBC.Modifier1
               else PR.Modifier1
          end,
          case when PR.Advanced = 'Y' then PRBC.Modifier2
               else PR.Modifier2
          end,
          case when PR.Advanced = 'Y' then PRBC.Modifier3
               else PR.Modifier3
          end,
          case when PR.Advanced = 'Y' then PRBC.Modifier4
               else PR.Modifier4
          end,
          case when PR.Advanced = 'Y' then PRBC.RevenueCode
               else PR.RevenueCode
          end,
          case when PR.Advanced = 'Y' then PRBC.RevenueCodeDescription
               else PR.RevenueCodeDescription
          end,
          case when PR.BillingCodeUnitType = 6762 then PR.BillingCodeClaimUnits
               when PR.BillingCodeUnitType = 6763 then PR.BillingCodeClaimUnits
               when PR.BillingCodeUnitType not in (6761, 6762, 6763)
                    and BCT.ServiceUnits >= (convert(int, gc2.ExternalCode1) - convert(int, gc2.ExternalCode2)) then convert(int, BCT.ServiceUnits + convert(int, gc2.ExternalCode2)) / convert(int, convert(int, gc2.ExternalCode1))
               else convert(int, BCT.ServiceUnits / PR.BillingCodeUnits) * PR.BillingCodeClaimUnits
          end,
          row_number() over (partition by BCT.ClaimLineId order by PR.Priority asc,
								   (case when PRP.ProgramId = S.ProgramId then 1 else 0 end + 
								    case when PRL.LocationId = S.LocationId then 1 else 0 end + 
									case when PRD.Degree = ST.Degree then 1 else 0 end + 
									case when PR.ClientId = S.ClientId then 1 else 0 end + 
									case when PRS.StaffId = S.ClinicianId then 1 else 0 end + 
									case when PRSA.ServiceAreaId = P.ServiceAreaId then 1 else 0 end + 
									case when (PRPOS.PlaceOfServieId = S.PlaceOfServiceId and S.PlaceOfServiceId is not null)
                                               or (PRPOS.PlaceOfServieId = l.PlaceOfService and S.PlaceOfServiceId is null) then 1 else 0 end) desc, 
											   case when nullif(PR.ModifierId1, '') in (S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4) then 1 else 0 end + 
											   case when nullif(PR.ModifierId2, '') in (S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4) then 1 else 0 end + 
											   case when nullif(PR.ModifierId3, '') in (S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4) then 1 else 0 end + 
											   case when nullif(PR.ModifierId4, '') in (S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4) then 1 else 0 end desc
					, case nullif(S.ModifierId1, '')
                        when PR.ModifierId1 then 1
                        when PR.ModifierId2 then 2
                        when PR.ModifierId3 then 3
                        when PR.ModifierId4 then 4
                        else 5
                      end asc
					, case nullif(S.ModifierId2, '')
                        when PR.ModifierId1 then 1
                        when PR.ModifierId2 then 2
                        when PR.ModifierId3 then 3
                        when PR.ModifierId4 then 4
                        else 5
                      end asc
					, case nullif(S.ModifierId3, '')
                        when PR.ModifierId1 then 1
                        when PR.ModifierId2 then 2
                        when PR.ModifierId3 then 3
                        when PR.ModifierId4 then 4
                        else 5
                      end asc
					, case nullif(S.ModifierId4, '')
                        when PR.ModifierId1 then 1
                        when PR.ModifierId2 then 2
                        when PR.ModifierId3 then 3
                        when PR.ModifierId4 then 4
                        else 5
                      end asc
					, case when isnull(PR.ModifierId1, '') = ''
                                and isnull(PR.ModifierId2, '') = ''
                                and isnull(PR.ModifierId3, '') = ''
                                and isnull(PR.ModifierId4, '') = '' then 1
                           else 2
                      end asc 
					, PR.Amount asc
					, PR.ProcedureRateId desc) as Ranking
  from    #BillingCodeTemplates BCT 
          join Services S on BCT.ServiceId = S.ServiceId
          join dbo.Programs P on P.ProgramId = S.ProgramId
          left join #DegreeValues deg on deg.ServiceId = BCT.ServiceId
          left outer join Staff ST on (S.ClinicianId = ST.StaffId) --Arjun K R
		  LEFT JOIN dbo.CustomStaff AS cs ON cs.StaffId = ST.StaffId
		  LEFT JOIN dbo.StaffLicenseDegrees AS afterbh ON afterbh.StaffLicenseDegreeId = cs.BillingDegreeAfterBHRedesign
			AND ISNULL(afterbh.RecordDeleted,'N') <> 'Y'
		  LEFT JOIN dbo.StaffLicenseDegrees AS priorbh ON priorbh.StaffLicenseDegreeId = cs.BillingDegreePriorToBHRedesign
			AND ISNULL(priorbh.RecordDeleted,'N') <> 'Y'
		  LEFT JOIN dbo.StaffLicenseDegrees AS afterbhSUD ON afterbhSUD.StaffLicenseDegreeId = cs.BillingDegreeAfterBHRedesignSUD
			AND ISNULL(afterbhSUD.RecordDeleted,'N') <> 'Y'
          join ProcedureRates PR on (S.ProcedureCodeId = PR.ProcedureCodeId
                                     and isnull(BCT.TemplateCoveragePlanId, 0) = isnull(PR.CoveragePlanId, 0))
          left outer join ProcedureRatePrograms PRP on PR.ProcedureRateId = PRP.ProcedureRateId
                                                       and isnull(PRP.RecordDeleted, 'N') = 'N'
          left outer join ProcedureRateLocations PRL on PR.ProcedureRateId = PRL.ProcedureRateId
                                                        and isnull(PRL.RecordDeleted, 'N') = 'N'
          left outer join ProcedureRateDegrees PRD on PR.ProcedureRateId = PRD.ProcedureRateId
                                                      and isnull(PRD.RecordDeleted, 'N') = 'N'
          left outer join ProcedureRateStaff PRS on PR.ProcedureRateId = PRS.ProcedureRateId
                                                    and isnull(PRS.RecordDeleted, 'N') = 'N'
          left outer join ProcedureRateBillingCodes PRBC on PR.ProcedureRateId = PRBC.ProcedureRateId
                                                            and isnull(PRBC.RecordDeleted, 'N') = 'N'
          left outer join GlobalCodes gc1 on (PR.ChargeType = gc1.GlobalCodeId
                                              and PR.ChargeType not in (6761, 6762, 6763)
                                              and isnumeric(gc1.ExternalCode1) = 1
                                              and isnumeric(gc1.ExternalCode2) = 1)
          left outer join GlobalCodes gc2 on (PR.BillingCodeUnitType = gc2.GlobalCodeId
                                              and PR.BillingCodeUnitType not in (6761, 6762, 6763)
                                              and isnumeric(gc2.ExternalCode1) = 1
                                              and isnumeric(gc2.ExternalCode2) = 1)
          left join dbo.ProcedureRatePlacesOfServices PRPOS on (PRPOS.ProcedureRateId = PR.ProcedureRateId
                                                                and isnull(PRPOS.RecordDeleted, 'N') = 'N')
          left join dbo.Locations l on l.LocationId = S.LocationId
                                       and isnull(l.RecordDeleted, 'N') = 'N'
          left join dbo.GlobalCodes gc3 on gc3.GlobalCodeId = l.PlaceOfService
                                           and isnull(gc3.RecordDeleted, 'N') = 'N'
                                           and gc3.Active = 'Y'
          left join ProcedureRateServiceAreas PRSA on PR.ProcedureRateId = PRSA.ProcedureRateId
                                                      and isnull(PRSA.RecordDeleted, 'N') = 'N'
  where   isnull(PR.RecordDeleted, 'N') = 'N'
          and PR.FromDate <= S.DateOfService
          and (dateadd(dd, 1, PR.ToDate) > S.DateOfService
               or PR.ToDate is null)
          and 
          (PRP.ProgramId = S.ProgramId
           or isnull(PR.ProgramGroupName, '') = '')
          and (PRL.LocationId = S.LocationId
               or isnull(PR.LocationGroupName, '') = '')
          and (isnull(PR.DegreeGroupName, '') = ''  -- ignore staff degree
				OR PRD.Degree = CASE 
					WHEN @BHRedesignEffecitiveDate IS NULL
						THEN st.Degree
					WHEN DATEDIFF(DAY, @BHRedesignEffecitiveDate, s.DateOfService) >= 0
						THEN CASE 
								WHEN p.ServiceAreaId = @ServiceAreaSUDId
									THEN afterbhSUD.LicenseTypeDegree
								ELSE afterbh.LicenseTypeDegree
								END
					ELSE priorbh.LicenseTypeDegree
					END
				OR PRD.Degree = deg.Degree)
          and (PR.ClientId = S.ClientId
               or isnull(PR.ClientId, '') = '')
          and (PRS.StaffId = S.ClinicianId
               or isnull(PR.StaffGroupName, '') = '')
          and ((PRPOS.PlaceOfServieId = S.PlaceOfServiceId
                and S.PlaceOfServiceId is not null)
               or (PRPOS.PlaceOfServieId = l.PlaceOfService
                   and S.PlaceOfServiceId is null)
               or isnull(PR.PlaceOfServiceGroupName, '') = '')
          and (PRSA.ServiceAreaId = P.ServiceAreaId
               or isnull(PR.ServiceAreaGroupName, '') = '')
          and ((PR.BillingCodeUnitType = 6761
                and BCT.ServiceUnits >= PR.FromUnit)   
               or (PR.BillingCodeUnitType = 6762
                   and (BCT.ServiceUnits = PR.FromUnit
                        or (BCT.ServiceUnits >= PR.FromUnit
                            and (PR.ToUnit is null
                                 or BCT.ServiceUnits <= PR.ToUnit))))
               or (PR.BillingCodeUnitType = 6763
                   and BCT.ServiceUnits >= PR.FromUnit
                   and BCT.ServiceUnits <= PR.ToUnit)
               -- In case there is no Standard Rate record  
               -- Make sure that service units are at least the unit per - low rounding option
               -- e.g. if unit per = 15 and low rounding is 7, it would accomodate services where 
               -- number of units is at least 8.
               or (BCT.ServiceUnits >= (convert(int, gc2.ExternalCode1) - convert(int, gc2.ExternalCode2))))
          and (PR.Advanced <> 'Y'
               or (BCT.ServiceUnits >= PRBC.FromUnit
                   and BCT.ServiceUnits <= PRBC.ToUnit))
                           

END


GO
