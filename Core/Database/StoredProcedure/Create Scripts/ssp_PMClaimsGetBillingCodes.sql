IF OBJECT_ID('ssp_PMClaimsGetBillingCodes', 'P') IS NOT NULL
    DROP PROCEDURE ssp_PMClaimsGetBillingCodes
go


CREATE PROCEDURE dbo.ssp_PMClaimsGetBillingCodes
  
/*********************************************************************  
-- Stored Procedure: dbo.ssp_PMClaimsGetBillingCodes  
-- Creation Date:    9/25/06  
--  
-- Purpose: Calculates billing codes and units  
--  
-- Updates:  
--   Date         Author      Purpose  
--   09.25.2006   JHB				Created.  
--   07.05.2007   SFarber			Moved checks for RecordDeleted from WHERE clause to LEFT JOIN  
--   12.14.2007   SFerenz			Added precision and scale to service units and claim units  
--   10.12.2011   Girish			 Changed ChargeType Values from P,E,R to 6761,6762,6763  
--   10.17.2011   Girish			Changed BillingCodeUnitTYpe from 'A' to 6762  
--   06.09.2012	  MSuma				Custom Charge Changes from Javed
	02.07.2013		dharvey		Added scsp_PMClaimsGetBillingCodes
--   10.14.2013   wherman		Changed RevenueCodeDescription to VARCHAR(100)
--	 12/09/2014   NJain			Added Place of Service Procedure Rates
--	 08/23/2015	  NJain			Replace ChargeType with BillingCodeUnitType in the WHERE clause
--	 08/25/2015	  NJain			Added 6763 in the case statement in the select
--	 09/05/2015	  NJain			Updated Billing Code calculation to look at From Unit only and From and To Units when Billing Code Unit Type = For Exactly/Always
--   09/21/2015   TRemisoski	Handle the null case for 6762 (always)
--	 10/30/2015	  NJain			Added Billing Code Description
--	 12/6/2015	  NJain			Added logic to look up POS for the Location when POS on the service is NULL
--   03/14/2016	  NJain			Added Service Area logic
--   05/20/2016   Dknewtson     Added Charge Billing Code Override logic - included as Dynamic SQL so as not to break anything else.
--	 08/01/2016   Gautam        Added code to get the ProcedureRateId if modifiers exists in Procedure Rate . 
--								Why: The existing code is not actually using modifiers to find a rate,Camino - Environment Issues Tracking, #86
--	 08/05/2016	  NJain		    Updated the Order by to look at Priority after the Case statement ,Woods - Support Go Live > Tasks #203 > Rate Calculation Issue
--	 11/30/2016	  NJain		    Woods SGL #399. Priority should be looked at first, always. 
--   01/12/2017   Arjun KR      Checking if row exits in #BillingCodes table before inserting records into it. Task #151 CEI Support Go Live.
--   05.23.2017   SFarber       Modified to skip core logic for a ClaimLineId if it already has a record in #BillingCodes populated by custom billing code logic 
--   08.14.2017	  Dknewtson     Allowing FromUnit to be null for 6762 Always BillingCodeUnitType because there is no way to enter this on the front end. -- TXAce - Environment Issues Tracking 196
--   09.08.2017	  NJain			Updated to look for non-blank group names in ProcedureRates table in the left joins. AHN EIT#39
--   09.15.2017   Dknewtson		Adding Modifiers from Service based on Checkbox on Service Standard Rate (Still need to add checkbox to front end for Plans -> Billing Codes) CEI 683
--   03.08.2018   VSinha		Converted FromUnit and ToUnit to 0 when its valuse is NULL, because if the value will be null it's getting fail while comparing with decimal value. 	Woods - Support Go Live #852
*********************************************************************/
AS
    BEGIN

        CREATE TABLE #BillingCodeTemplates
            (
              ClaimLineId INT NOT NULL ,
              ChargeId INT NULL ,
              TemplateCoveragePlanId INT NULL ,
              ServiceId INT NULL ,
              ServiceUnits DECIMAL(9, 2) NULL
            )  
  
        CREATE TABLE #BillingCodes
            (
              ClaimLineId INT NOT NULL ,
              ChargeId INT NULL ,
              BillingCode VARCHAR(25) NULL ,
              Modifier1 VARCHAR(10) NULL ,
              Modifier2 VARCHAR(10) NULL ,
              Modifier3 VARCHAR(10) NULL ,
              Modifier4 VARCHAR(10) NULL ,
              BillingCodeDescription VARCHAR(50) NULL ,
              RevenueCode VARCHAR(10) NULL ,
              RevenueCodeDescription VARCHAR(100) NULL ,
              ClaimUnits DECIMAL(9, 2) NULL ,
              Ranking INT
            )  
  
        IF @@error <> 0
            RETURN  

        DECLARE @Sql VARCHAR(MAX)

        IF EXISTS ( SELECT  1
                    FROM    tempdb.sys.columns c
                    WHERE   c.object_id = OBJECT_ID('tempdb..#ClaimLines')
                            AND c.name = 'ChargeId' )
            BEGIN
	  -- Find the coverage plan used as template for billing codes  
                SET @Sql = ' INSERT   INTO #BillingCodeTemplates
							( 
							 ClaimLineId
							,ChargeId
							,TemplateCoveragePlanId
							,ServiceId
							,ServiceUnits
							)
							SELECT  a.ClaimLineId
								   ,a.ChargeId
								   ,CASE e.BillingCodeTemplate
									  WHEN ''T'' THEN e.CoveragePlanId
									  WHEN ''O'' THEN e.UseBillingCodesFrom
									  ELSE NULL
									END
								   ,a.ServiceId
								   ,a.ServiceUnits
							FROM    #ClaimLines a 
									LEFT JOIN CoveragePlans e
										ON ( a.CoveragePlanId = e.CoveragePlanId )  
						'
                EXEC (@Sql)
            END
        ELSE
            BEGIN
      -- Find the coverage plan used as template for billing codes  
                INSERT  INTO #BillingCodeTemplates
                        ( ClaimLineId ,
                          ChargeId ,
                          TemplateCoveragePlanId ,
                          ServiceId ,
                          ServiceUnits
                        )
                        SELECT  a.ClaimLineId ,
                                c.ChargeId ,
                                CASE e.BillingCodeTemplate
                                  WHEN 'T' THEN e.CoveragePlanId
                                  WHEN 'O' THEN e.UseBillingCodesFrom
                                  ELSE NULL
                                END ,
                                a.ServiceId ,
                                a.ServiceUnits
                        FROM    #ClaimLines a
                                LEFT JOIN CoveragePlans e ON ( a.CoveragePlanId = e.CoveragePlanId )
                                JOIN dbo.Services s ON s.ServiceId = a.ServiceId
                                LEFT JOIN dbo.ClientCoveragePlans ccp ON ccp.CoveragePlanId = a.CoveragePlanId
                                                                         AND ccp.ClientId = s.ClientId
                                                                         AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
                                LEFT JOIN dbo.Charges c ON s.ServiceId = c.ServiceId
                                                           AND c.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                           AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
            END   
  
        IF @@error <> 0
            RETURN  
  


  --Custom Logic call
        CREATE TABLE #DegreeValues
            (
              ClaimLineId INT ,
              ServiceId INT ,
              DegreeGlobalCodeId INT ,
              Degree INT
            )
		
  /* Custom Billing Code Logic */
        IF OBJECT_ID('scsp_PMClaimsGetBillingCodes', 'P') IS NOT NULL
            BEGIN
                EXEC scsp_PMClaimsGetBillingCodes
            END

        INSERT  INTO #BillingCodes
                ( ClaimLineId ,
                  ChargeId ,
                  BillingCode ,
                  Modifier1 ,
                  Modifier2 ,
                  Modifier3 ,
                  Modifier4 ,
                  RevenueCode ,
                  RevenueCodeDescription ,
                  ClaimUnits ,
                  Ranking
                )
                SELECT  BCT.ClaimLineId ,
                        BCT.ChargeId ,
                        CASE WHEN PR.Advanced = 'Y' THEN PRBC.BillingCode
                             ELSE PR.BillingCode
                        END ,
                        CASE WHEN PR.Advanced = 'Y' THEN PRBC.Modifier1
                             ELSE PR.Modifier1
                        END ,
                        CASE WHEN PR.Advanced = 'Y' THEN PRBC.Modifier2
                             ELSE PR.Modifier2
                        END ,
                        CASE WHEN PR.Advanced = 'Y' THEN PRBC.Modifier3
                             ELSE PR.Modifier3
                        END ,
                        CASE WHEN PR.Advanced = 'Y' THEN PRBC.Modifier4
                             ELSE PR.Modifier4
                        END ,
                        CASE WHEN PR.Advanced = 'Y' THEN PRBC.RevenueCode
                             ELSE PR.RevenueCode
                        END ,
                        CASE WHEN PR.Advanced = 'Y' THEN PRBC.RevenueCodeDescription
                             ELSE PR.RevenueCodeDescription
                        END ,
                        CASE WHEN PR.BillingCodeUnitType = 6762 THEN PR.BillingCodeClaimUnits
                             WHEN PR.BillingCodeUnitType = 6763 THEN PR.BillingCodeClaimUnits
                             WHEN PR.BillingCodeUnitType NOT IN ( 6761, 6762, 6763 )
                                  AND BCT.ServiceUnits >= ( CONVERT(INT, gc2.ExternalCode1) - CONVERT(INT, gc2.ExternalCode2) ) THEN CONVERT(INT, BCT.ServiceUnits + CONVERT(INT, gc2.ExternalCode2)) / CONVERT(INT, CONVERT(INT, gc2.ExternalCode1))
                             ELSE CONVERT(INT, BCT.ServiceUnits / PR.BillingCodeUnits) * PR.BillingCodeClaimUnits
                        END ,
                        ROW_NUMBER() OVER ( PARTITION BY BCT.ClaimLineId ORDER BY PR.Priority ASC, ( CASE WHEN PRP.ProgramId = S.ProgramId THEN 1
                                                                                                          ELSE 0
                                                                                                     END + CASE WHEN PRL.LocationId = S.LocationId THEN 1
                                                                                                                ELSE 0
                                                                                                           END + CASE WHEN PRD.Degree = ST.Degree THEN 1
                                                                                                                      ELSE 0
                                                                                                                 END + CASE WHEN PR.ClientId = S.ClientId THEN 1
                                                                                                                            ELSE 0
                                                                                                                       END + CASE WHEN PRS.StaffId = S.ClinicianId THEN 1
                                                                                                                                  ELSE 0
                                                                                                                             END + CASE WHEN PRSA.ServiceAreaId = P.ServiceAreaId THEN 1
                                                                                                                                        ELSE 0
                                                                                                                                   END + CASE WHEN ( PRPOS.PlaceOfServieId = S.PlaceOfServiceId
                                                                                                                                                     AND S.PlaceOfServiceId IS NOT NULL
                                                                                                                                                   )
                                                                                                                                                   OR ( PRPOS.PlaceOfServieId = l.PlaceOfService
                                                                                                                                                        AND S.PlaceOfServiceId IS NULL
                                                                                                                                                      ) THEN 1
                                                                                                                                              ELSE 0
                                                                                                                                         END ) DESC, CASE WHEN NULLIF(PR.ModifierId1, '') IN ( S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4 ) THEN 1
                                                                                                                                                          ELSE 0
                                                                                                                                                     END + CASE WHEN NULLIF(PR.ModifierId2, '') IN ( S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4 ) THEN 1
                                                                                                                                                                ELSE 0
                                                                                                                                                           END + CASE WHEN NULLIF(PR.ModifierId3, '') IN ( S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4 ) THEN 1
                                                                                                                                                                      ELSE 0
                                                                                                                                                                 END + CASE WHEN NULLIF(PR.ModifierId4, '') IN ( S.ModifierId1, S.ModifierId2, S.ModifierId3, S.ModifierId4 ) THEN 1
                                                                                                                                                                            ELSE 0
                                                                                                                                                                       END DESC
					, CASE NULLIF(S.ModifierId1, '')
                        WHEN PR.ModifierId1 THEN 1
                        WHEN PR.ModifierId2 THEN 2
                        WHEN PR.ModifierId3 THEN 3
                        WHEN PR.ModifierId4 THEN 4
                        ELSE 5
                      END ASC
					, CASE NULLIF(S.ModifierId2, '')
                        WHEN PR.ModifierId1 THEN 1
                        WHEN PR.ModifierId2 THEN 2
                        WHEN PR.ModifierId3 THEN 3
                        WHEN PR.ModifierId4 THEN 4
                        ELSE 5
                      END ASC
					, CASE NULLIF(S.ModifierId3, '')
                        WHEN PR.ModifierId1 THEN 1
                        WHEN PR.ModifierId2 THEN 2
                        WHEN PR.ModifierId3 THEN 3
                        WHEN PR.ModifierId4 THEN 4
                        ELSE 5
                      END ASC
					, CASE NULLIF(S.ModifierId4, '')
                        WHEN PR.ModifierId1 THEN 1
                        WHEN PR.ModifierId2 THEN 2
                        WHEN PR.ModifierId3 THEN 3
                        WHEN PR.ModifierId4 THEN 4
                        ELSE 5
                      END ASC
					, CASE WHEN ISNULL(PR.ModifierId1, '') = ''
                                AND ISNULL(PR.ModifierId2, '') = ''
                                AND ISNULL(PR.ModifierId3, '') = ''
                                AND ISNULL(PR.ModifierId4, '') = '' THEN 1
                           ELSE 2
                      END ASC 
					, PR.Amount ASC
					, PR.ProcedureRateId DESC ) AS Ranking
                FROM    #BillingCodeTemplates BCT
                        JOIN Services S ON BCT.ServiceId = S.ServiceId
                        JOIN dbo.Programs P ON P.ProgramId = S.ProgramId
                        LEFT JOIN #DegreeValues deg ON deg.ServiceId = BCT.ServiceId
                        LEFT OUTER JOIN Staff ST ON ( S.ClinicianId = ST.StaffId ) --Arjun K R
                        JOIN ProcedureRates PR ON ( S.ProcedureCodeId = PR.ProcedureCodeId
                                                    AND ISNULL(BCT.TemplateCoveragePlanId, 0) = ISNULL(PR.CoveragePlanId, 0)
                                                  )
                        LEFT OUTER JOIN ProcedureRatePrograms PRP ON PR.ProcedureRateId = PRP.ProcedureRateId
                                                                     AND ISNULL(PRP.RecordDeleted, 'N') = 'N'
                                                                     AND ISNULL(PR.ProgramGroupName, '') <> ''
                        LEFT OUTER JOIN ProcedureRateLocations PRL ON PR.ProcedureRateId = PRL.ProcedureRateId
                                                                      AND ISNULL(PRL.RecordDeleted, 'N') = 'N'
                                                                      AND ISNULL(PR.LocationGroupName, '') <> ''
                        LEFT OUTER JOIN ProcedureRateDegrees PRD ON PR.ProcedureRateId = PRD.ProcedureRateId
                                                                    AND ISNULL(PRD.RecordDeleted, 'N') = 'N'
																	AND ISNULL(PR.DegreeGroupName, '') <> ''
                        LEFT OUTER JOIN ProcedureRateStaff PRS ON PR.ProcedureRateId = PRS.ProcedureRateId
                                                                  AND ISNULL(PRS.RecordDeleted, 'N') = 'N'
																  AND ISNULL(PR.StaffGroupName, '') <> ''
                        LEFT OUTER JOIN ProcedureRateBillingCodes PRBC ON PR.ProcedureRateId = PRBC.ProcedureRateId
                                                                          AND ISNULL(PRBC.RecordDeleted, 'N') = 'N'
                        LEFT OUTER JOIN GlobalCodes gc1 ON ( PR.ChargeType = gc1.GlobalCodeId
                                                             AND PR.ChargeType NOT IN ( 6761, 6762, 6763 )
                                                             AND ISNUMERIC(gc1.ExternalCode1) = 1
                                                             AND ISNUMERIC(gc1.ExternalCode2) = 1
                                                           )
                        LEFT OUTER JOIN GlobalCodes gc2 ON ( PR.BillingCodeUnitType = gc2.GlobalCodeId
                                                             AND PR.BillingCodeUnitType NOT IN ( 6761, 6762, 6763 )
                                                             AND ISNUMERIC(gc2.ExternalCode1) = 1
                                                             AND ISNUMERIC(gc2.ExternalCode2) = 1
                                                           )
                        LEFT JOIN dbo.ProcedureRatePlacesOfServices PRPOS ON ( PRPOS.ProcedureRateId = PR.ProcedureRateId
                                                                               AND ISNULL(PRPOS.RecordDeleted, 'N') = 'N'
																			   AND ISNULL(PR.PlaceOfServiceGroupName, '') <> ''
                                                                             )
                        LEFT JOIN dbo.Locations l ON l.LocationId = S.LocationId
                                                     AND ISNULL(l.RecordDeleted, 'N') = 'N'
                        LEFT JOIN dbo.GlobalCodes gc3 ON gc3.GlobalCodeId = l.PlaceOfService
                                                         AND ISNULL(gc3.RecordDeleted, 'N') = 'N'
                                                         AND gc3.Active = 'Y'
                        LEFT JOIN ProcedureRateServiceAreas PRSA ON PR.ProcedureRateId = PRSA.ProcedureRateId
                                                                    AND ISNULL(PRSA.RecordDeleted, 'N') = 'N'
																	AND ISNULL(PR.ServiceAreaGroupName, '') <> ''
                WHERE   -- Skip if populated by custom billing code logic
                        NOT EXISTS ( SELECT *
                                     FROM   #BillingCodes bc
                                     WHERE  bc.ClaimLineId = BCT.ClaimLineId )
                        AND ISNULL(PR.RecordDeleted, 'N') = 'N'
                        AND PR.FromDate <= S.DateOfService
                        AND ( DATEADD(dd, 1, PR.ToDate) > S.DateOfService
                              OR PR.ToDate IS NULL
                            )
                        AND ( PRP.ProgramId = S.ProgramId
                              OR ISNULL(PR.ProgramGroupName, '') = ''
                            )
                        AND ( PRL.LocationId = S.LocationId
                              OR ISNULL(PR.LocationGroupName, '') = ''
                            )
                        AND ( ISNULL(PR.DegreeGroupName, '') = ''
                              OR PRD.Degree = ST.Degree
                              OR PRD.Degree = deg.Degree
                            )
                        AND ( PR.ClientId = S.ClientId
                              OR ISNULL(PR.ClientId, '') = ''
                            )
                        AND ( PRS.StaffId = S.ClinicianId
                              OR ISNULL(PR.StaffGroupName, '') = ''
                            )
                        AND ( ( PRPOS.PlaceOfServieId = S.PlaceOfServiceId
                                AND S.PlaceOfServiceId IS NOT NULL
                              )
                              OR ( PRPOS.PlaceOfServieId = l.PlaceOfService
                                   AND S.PlaceOfServiceId IS NULL
                                 )
                              OR ISNULL(PR.PlaceOfServiceGroupName, '') = ''
                            )
                        AND ( PRSA.ServiceAreaId = P.ServiceAreaId
                              OR ISNULL(PR.ServiceAreaGroupName, '') = ''
                            )
                        AND ( ( PR.BillingCodeUnitType = 6761
                                AND BCT.ServiceUnits >= ISNULL(PR.FromUnit,0)
                              )
                              OR ( PR.BillingCodeUnitType = 6762
                                   AND (  (PR.FromUnit IS NULL OR BCT.ServiceUnits >= ISNULL(PR.FromUnit,0))
                                              AND ( PR.ToUnit IS NULL
                                                    OR BCT.ServiceUnits <= ISNULL(PR.ToUnit,0)
                                                  )
                                            )
                                       
                                 )
                              OR ( PR.BillingCodeUnitType = 6763
                                   AND BCT.ServiceUnits >= ISNULL(PR.FromUnit,0)
                                   AND BCT.ServiceUnits <= ISNULL(PR.ToUnit,0)
                                 )
               -- In case there is no Standard Rate record  
               -- Make sure that service units are at least the unit per - low rounding option
               -- e.g. if unit per = 15 and low rounding is 7, it would accomodate services where 
               -- number of units is at least 8.
                              OR ( BCT.ServiceUnits >= ( CONVERT(INT, gc2.ExternalCode1) - CONVERT(INT, gc2.ExternalCode2) ) )
                            )
                        AND ( PR.Advanced <> 'Y'
                              OR ( BCT.ServiceUnits >= ISNULL(PRBC.FromUnit,0)
                                   AND BCT.ServiceUnits <= ISNULL(PRBC.ToUnit,0)
                                 )
                            )


        UPDATE  bc
        SET     bc.Modifier1 = CASE WHEN bc.Modifier1 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier1
                               END
              , bc.Modifier2 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier2
                               END
              , bc.Modifier3 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier3
                               END
              , bc.Modifier4 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NOT NULL
                                         AND bc.Modifier4 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier4
                               END
        FROM    #BillingCodes AS bc
                JOIN dbo.Charges AS c ON c.ChargeId = bc.ChargeId
                JOIN dbo.Services AS s ON s.ServiceId = c.ServiceId
                JOIN dbo.Modifiers AS m ON m.ModifierId = s.ModifierId1
					-- using the standard rate because the "Add Modifiers" checkbox is not available on Plan -> Billing Codes
                JOIN dbo.ProcedureRates AS pr ON pr.ProcedureRateId = s.ProcedureRateId
        WHERE   ISNULL(pr.AddModifiersFromService, 'N') = 'Y'
                AND m.ModifierCode NOT IN ( ISNULL(bc.Modifier1,''), ISNULL(bc.Modifier2,''), ISNULL(bc.Modifier3,''), ISNULL(bc.Modifier4,'') )
                           
        UPDATE  bc
        SET     bc.Modifier1 = CASE WHEN bc.Modifier1 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier1
                               END
              , bc.Modifier2 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier2
                               END
              , bc.Modifier3 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier3
                               END
              , bc.Modifier4 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NOT NULL
                                         AND bc.Modifier4 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier4
                               END
        FROM    #BillingCodes AS bc
                JOIN dbo.Charges AS c ON c.ChargeId = bc.ChargeId
                JOIN dbo.Services AS s ON s.ServiceId = c.ServiceId
                JOIN dbo.Modifiers AS m ON m.ModifierId = s.ModifierId2
					-- using the standard rate because the "Add Modifiers" checkbox is not available on Plan -> Billing Codes
                JOIN dbo.ProcedureRates AS pr ON pr.ProcedureRateId = s.ProcedureRateId
        WHERE   ISNULL(pr.AddModifiersFromService, 'N') = 'Y'
                AND m.ModifierCode NOT IN ( ISNULL(bc.Modifier1,''), ISNULL(bc.Modifier2,''), ISNULL(bc.Modifier3,''), ISNULL(bc.Modifier4,'') )

        UPDATE  bc
        SET     bc.Modifier1 = CASE WHEN bc.Modifier1 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier1
                               END
              , bc.Modifier2 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier2
                               END
              , bc.Modifier3 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier3
                               END
              , bc.Modifier4 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NOT NULL
                                         AND bc.Modifier4 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier4
                               END
        FROM    #BillingCodes AS bc
                JOIN dbo.Charges AS c ON c.ChargeId = bc.ChargeId
                JOIN dbo.Services AS s ON s.ServiceId = c.ServiceId
                JOIN dbo.Modifiers AS m ON m.ModifierId = s.ModifierId3
					-- using the standard rate because the "Add Modifiers" checkbox is not available on Plan -> Billing Codes
                JOIN dbo.ProcedureRates AS pr ON pr.ProcedureRateId = s.ProcedureRateId
        WHERE   ISNULL(pr.AddModifiersFromService, 'N') = 'Y'
                AND m.ModifierCode NOT IN ( ISNULL(bc.Modifier1,''), ISNULL(bc.Modifier2,''), ISNULL(bc.Modifier3,''), ISNULL(bc.Modifier4,'') )
                           
        UPDATE  bc
        SET     bc.Modifier1 = CASE WHEN bc.Modifier1 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier1
                               END
              , bc.Modifier2 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier2
                               END
              , bc.Modifier3 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier3
                               END
              , bc.Modifier4 = CASE WHEN bc.Modifier1 IS NOT NULL
                                         AND bc.Modifier2 IS NOT NULL
                                         AND bc.Modifier3 IS NOT NULL
                                         AND bc.Modifier4 IS NULL THEN m.ModifierCode
                                    ELSE bc.Modifier4
                               END
        FROM    #BillingCodes AS bc
                JOIN dbo.Charges AS c ON c.ChargeId = bc.ChargeId
                JOIN dbo.Services AS s ON s.ServiceId = c.ServiceId
                JOIN dbo.Modifiers AS m ON m.ModifierId = s.ModifierId4
					-- using the standard rate because the "Add Modifiers" checkbox is not available on Plan -> Billing Codes
                JOIN dbo.ProcedureRates AS pr ON pr.ProcedureRateId = s.ProcedureRateId
        WHERE   ISNULL(pr.AddModifiersFromService, 'N') = 'Y'
                AND m.ModifierCode NOT IN ( ISNULL(bc.Modifier1,''), ISNULL(bc.Modifier2,''), ISNULL(bc.Modifier3,''), ISNULL(bc.Modifier4,'') )
                           
                                                       
  -- override billing code logic.
        UPDATE  bc
        SET     BillingCode = c.BillingCode ,
                Modifier1 = c.Modifier1 ,
                Modifier2 = c.Modifier2 ,
                Modifier3 = c.Modifier3 ,
                Modifier4 = c.Modifier4
        FROM    #BillingCodes bc
                JOIN dbo.Charges c ON bc.ChargeId = c.ChargeId
        WHERE   ISNULL(c.OverrideBillingCodes, 'N') = 'Y'
  
  
        IF @@error <> 0
            RETURN  
  
        UPDATE  a
        SET     BillingCode = b.BillingCode ,
                Modifier1 = b.Modifier1 ,
                Modifier2 = b.Modifier2 ,
                Modifier3 = b.Modifier3 ,
                Modifier4 = b.Modifier4 ,
                RevenueCode = b.RevenueCode ,
                RevenueCodeDescription = b.RevenueCodeDescription ,
                ClaimUnits = b.ClaimUnits
        FROM    #ClaimLines a
                JOIN #BillingCodes b ON ( a.ClaimLineId = b.ClaimLineId )
        WHERE   b.Ranking = 1  

    END  
  

go
