/****** Object:  UserDefinedFunction [dbo].[ssf_PMServiceCalculateCharge]    Script Date: 08/28/2015 20:22:47 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssf_PMServiceCalculateCharge]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [dbo].[ssf_PMServiceCalculateCharge]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_PMServiceCalculateCharge]    Script Date: 08/28/2015 20:22:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_PMServiceCalculateCharge]
    (
      @ClientId INT ,
      @DateOfService DATETIME ,
      @ClinicianId INT ,
      @ProcedureCodeId INT ,
      @Units DECIMAL(18, 2) ,
      @ProgramId INT ,
      @LocationId INT ,
      @ModifierId1 INT = NULL ,
      @ModifierId2 INT = NULL ,
      @ModifierId3 INT = NULL ,
      @ModifierId4 INT = NULL
	)
	-- =============================================
	--Modified Date		Modified By   Purpose
	--12/9/2015			Revathi			what:Moving SSP CalculateCharge logic to ssf_PMServiceCalculateCharge as per Tom comments
	--									why:task #863 Woods Customisation
	--14/12/2015		Lakshmi Kanth   what:Handled "Divide by zero error encountered" in Service note page on save.
	--									why:task #1860 	Core Bugs			
	--1/11/2016			Dknewtson   What: Changed join to ProcedureRateServiceAreas to join to ProcedureRates (PR) instead of ProcedureRatePrograms (PRP)
	--                         why: PRP may not exist in all cases. Keystone - Environment Issues Tracking #50
	--12/June/2016      Gautam      What: Added code to get the ProcedureRateId if modifiers exists in Procedure Rate . also added 4 new input parameters ModifierId 
	--								Why: The existing code is not actually using modifiers to find a rate,Camino - Environment Issues Tracking, #86 
	-- 08/05/2016		NJain		Updated the Order by to look at Priority after the Case statement 
	-- 11/30/2016	    NJain		Woods SGL #399. Priority should be looked at first, always. 
	-- 4/7/2017         Hemant      Removed the integer conversion for the type "per" to fix charge calculation issue.Harbor - Support # 1146.1  
	-- 10/17/2017       TRemisoski  Restored the integer conversion for the type "per" to fix charge calculation issue.Pines - Support # 907
	-- =============================================
RETURNS @ProcedureRateCharge TABLE
    (
      ProcedureRateId INT ,
      Charge MONEY
    )
AS
    BEGIN
        DECLARE @ProcedureRateId INT
        DECLARE @Charge MONEY
        DECLARE @ServiceId INT
	--12/June/2016      Gautam  
        DECLARE @ProcedureRateChargeModifier TABLE
            (
              ProcedureRateId INT ,
              Charge MONEY ,
              Ranking INT
            )

        SELECT  @ModifierId1 = ISNULL(@ModifierId1, '') ,
                @ModifierId2 = ISNULL(@ModifierId2, '') ,
                @ModifierId3 = ISNULL(@ModifierId3, '') ,
                @ModifierId4 = ISNULL(@ModifierId4, '')

        IF ( SELECT COUNT(*)
             FROM   Services
             WHERE  ClientId = @ClientId
                    AND DateOfService = @DateOfService
                    AND ClinicianId = @ClinicianId
                    AND ProcedureCodeId = @ProcedureCodeId
                    AND Unit = @Units
                    AND ProgramId = @ProgramId
                    AND LocationId = @LocationId
                    AND STATUS IN ( 70, 71, 75 )
                    AND ISNULL(RecordDeleted, 'N') = 'N'
           ) = 1
            BEGIN
                SELECT  @ServiceId = ServiceId
                FROM    Services
                WHERE   ClientId = @ClientId
                        AND DateOfService = @DateOfService
                        AND ClinicianId = @ClinicianId
                        AND ProcedureCodeId = @ProcedureCodeId
                        AND Unit = @Units
                        AND ProgramId = @ProgramId
                        AND LocationId = @LocationId
                        AND STATUS IN ( 70, 71, 75 )
                        AND ISNULL(RecordDeleted, 'N') = 'N'
            END

	-- Determine clinician degree          
        DECLARE @Degree INT
	--2014.06.02 - get service area
        DECLARE @ServiceAreaId INT

        SELECT  @ServiceAreaId = ServiceAreaId
        FROM    dbo.Programs
        WHERE   ProgramId = @ProgramId

        IF @@error <> 0
            RETURN

	--Added By Amit Kumar Srivatava, to use recode table start    
        DECLARE @NewProcedureRateId TABLE ( ProcedureRateId INT )

        INSERT  INTO @NewProcedureRateId
                ( ProcedureRateId
                )
                ( SELECT    PR.ProcedureRateId
                  FROM      ProcedureRates PR
                            LEFT JOIN ProcedureRateServiceAreas PRSA ON PR.ProcedureRateId = PRSA.ProcedureRateId
                                                                        AND ISNULL(PRSA.RecordDeleted, 'N') = 'N'
                  WHERE     PR.ProcedureCodeId = @ProcedureCodeId
                            AND ISNULL(PR.RecordDeleted, 'N') = 'N'
		-- T.Remisoski moved PRSA record deleted check to the left join
                            AND NOT ( EXISTS ( SELECT   1
                                               FROM     [dbo].ssf_RecodeValuesCurrent('XSPENDDOWN')
                                               WHERE    IntegerCodeId = PRSA.ServiceAreaId ) )
                )
	--Added By Amit Kumar Srivatava, to use recode table End    
        SELECT  @Degree = Degree
        FROM    Staff
        WHERE   StaffId = @ClinicianId

        IF @@error <> 0
            RETURN

	-- Added 12/09/2014 Place of Service
        DECLARE @PlaceOfServiceId INT = NULL
        SELECT  @PlaceOfServiceId = PlaceOfServiceId
        FROM    dbo.Services
        WHERE   ServiceId = @ServiceId
        
        IF @PlaceOfServiceId IS NULL
            BEGIN
                SELECT  @PlaceOfServiceId = b.GlobalCodeId
                FROM    Locations a
                        JOIN dbo.GlobalCodes b ON b.GlobalCodeId = a.PlaceOfService
                WHERE   b.Active = 'Y'
                        AND a.LocationId = @LocationId
                        AND ISNULL(a.RecordDeleted, 'N') = 'N'
                        AND ISNULL(b.RecordDeleted, 'N') = 'N'
            END

        IF @@error <> 0
            RETURN

	
        INSERT  INTO @ProcedureRateChargeModifier
                SELECT  PR.ProcedureRateId ,
                        ( CASE WHEN PR.ChargeType = 6762 --'E'    
                                    THEN PR.Amount -- For Exactly            
                               WHEN PR.ChargeType = 6763 --'R'    
                                    THEN PR.Amount -- For Range             
                               WHEN PR.ChargeType = 6761 --'P'    
                                    THEN CASE WHEN PR.FromUnit = 0 -- 14/12/2015  Lakshmi Kanth   
                                                   THEN 0
                                              ELSE ( PR.Amount ) * CONVERT(INT, CONVERT(DECIMAL(10, 2), ( @Units / CONVERT(DECIMAL(18, 2), PR.FromUnit) )))
                                         END
                               WHEN @Units >= ( CONVERT(DECIMAL(18, 2), gc1.ExternalCode1) - CONVERT(DECIMAL(18, 2), gc1.ExternalCode2) ) THEN ( PR.Amount ) * CONVERT(INT, CONVERT(DECIMAL(10, 2), ( CONVERT(DECIMAL(18, 2), @Units + CONVERT(DECIMAL(18, 2), gc1.ExternalCode2)) / CONVERT(DECIMAL(18, 2), CONVERT(DECIMAL(18, 2), gc1.ExternalCode1)) )))
							-- 4/26/2013 JHB Added support for $0 charge in case of custom rate type        
                               ELSE 0
                          END ) ,
                        ROW_NUMBER() OVER ( ORDER BY PR.Priority ASC 
			
					, ( CASE WHEN PRP.programId = @ProgramId THEN 1
                             ELSE 0
                        END + CASE WHEN PRL.LocationId = @LocationId THEN 1
                                   ELSE 0
                              END + CASE WHEN PRD.Degree = @Degree THEN 1
                                         ELSE 0
                                    END + CASE WHEN PR.ClientId = @ClientId THEN 1
                                               ELSE 0
                                          END + CASE WHEN PRS.StaffId = @ClinicianId THEN 1
                                                     ELSE 0
						--2014.06.02 - give preference to matching rate
                                                END + CASE WHEN PRSA.ServiceAreaId = @ServiceAreaId THEN 1
                                                           ELSE 0
                                                      END + CASE WHEN PRPOS.PlaceOfServieId = @PlaceOfServiceId THEN 1
                                                                 ELSE 0
                                                            END ) DESC, CASE WHEN NULLIF(PR.ModifierId1, '') IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 ) THEN 1
                                                                             ELSE 0
                                                                        END + CASE WHEN NULLIF(PR.ModifierId2, '') IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 ) THEN 1
                                                                                   ELSE 0
                                                                              END + CASE WHEN NULLIF(PR.ModifierId3, '') IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 ) THEN 1
                                                                                         ELSE 0
                                                                                    END + CASE WHEN NULLIF(PR.ModifierId4, '') IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 ) THEN 1
                                                                                               ELSE 0
                                                                                          END DESC , CASE NULLIF(@ModifierId1, '')
                                                                                                       WHEN PR.ModifierId1 THEN 1
                                                                                                       WHEN PR.ModifierId2 THEN 2
                                                                                                       WHEN PR.ModifierId3 THEN 3
                                                                                                       WHEN PR.ModifierId4 THEN 4
                                                                                                       ELSE 5
                                                                                                     END ASC
					, CASE NULLIF(@ModifierId2, '')
                        WHEN PR.ModifierId1 THEN 1
                        WHEN PR.ModifierId2 THEN 2
                        WHEN PR.ModifierId3 THEN 3
                        WHEN PR.ModifierId4 THEN 4
                        ELSE 5
                      END ASC
					, CASE NULLIF(@ModifierId3, '')
                        WHEN PR.ModifierId1 THEN 1
                        WHEN PR.ModifierId2 THEN 2
                        WHEN PR.ModifierId3 THEN 3
                        WHEN PR.ModifierId4 THEN 4
                        ELSE 5
                      END ASC
					, CASE NULLIF(@ModifierId4, '')
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
					, PR.amount ASC
					, PR.ProcedureRateId DESC ) AS Ranking
                FROM    ProcedureRates PR
                        LEFT JOIN ProcedureRateDegrees PRD ON ( PR.ProcedureRateId = PRD.ProcedureRateId
                                                                AND ISNULL(PRD.RecordDeleted, 'N') = 'N'
                                                              )
                        LEFT JOIN ProcedureRateLocations PRL ON ( PR.ProcedureRateId = PRL.ProcedureRateId
                                                                  AND ISNULL(PRL.RecordDeleted, 'N') = 'N'
                                                                )
                        LEFT JOIN ProcedureRatePrograms PRP ON ( PR.ProcedureRateId = PRP.ProcedureRateId
                                                                 AND ISNULL(PRP.RecordDeleted, 'N') = 'N'
                                                               )
		--2014.06.02 - add join to ProcedureRateServiceAreas  
                        LEFT JOIN ProcedureRateServiceAreas PRSA ON ( PRSA.ProcedureRateId = PR.ProcedureRateId
                                                                      AND ISNULL(PRSA.RecordDeleted, 'N') = 'N'
                                                                    )
                        LEFT JOIN ProcedureRateStaff PRS ON ( PR.ProcedureRateId = PRS.ProcedureRateId
                                                              AND ISNULL(PRS.RecordDeleted, 'N') = 'N'
                                                            )
                        LEFT OUTER JOIN GlobalCodes gc1 ON ( PR.ChargeType = gc1.GlobalCodeId
                                                             AND PR.ChargeType NOT IN ( 6761, 6762, 6763 )
                                                             AND ISNUMERIC(gc1.ExternalCode1) = 1
                                                             AND ISNUMERIC(gc1.ExternalCode2) = 1
                                                           )
                        LEFT JOIN dbo.ProcedureRatePlacesOfServices PRPOS ON ( PRPOS.ProcedureRateId = PR.ProcedureRateId
                                                                               AND ISNULL(PRPOS.RecordDeleted, 'N') = 'N'
                                                                             )
                WHERE   ISNULL(PR.RecordDeleted, 'N') = 'N'
                        AND PR.CoveragePlanId IS NULL
                        AND PR.ProcedureCodeId = @ProcedureCodeId
			--Added By Amit Kumar Srivatava, to use recode table start         
                        AND EXISTS ( SELECT 1
                                     FROM   @NewProcedureRateId PR1
                                     WHERE  PR1.ProcedureRateId = PR.ProcedureRateId )
			--Added By Amit Kumar Srivatava, to use recode table End     
                        AND PR.FromDate <= @DateOfService
                        AND ( DATEADD(dd, 1, PR.ToDate) > @DateOfService
                              OR PR.ToDate IS NULL
                            )
                        AND ( ( PR.ChargeType = 6761
                                AND @Units >= PR.FromUnit
                              )
                              OR ( PR.ChargeType = 6762
                                   AND @Units = PR.FromUnit
                                 )
                              OR ( PR.ChargeType = 6763
                                   AND @Units >= PR.FromUnit
                                   AND @Units <= PR.ToUnit
                                 )
				--        or (@Units >= (convert(int,gc1.ExternalCode1) - convert(int,gc1.ExternalCode2)))    
				-- 4/26/2013 JHB Added support for $0 charge in case of custom rate type        
                              OR ( PR.ChargeType NOT IN ( 6761, 6762, 6763 ) )
                            )
                        AND ( PRP.ProgramId IS NULL
                              OR PRP.ProgramId = @ProgramId
                            )
                        AND ( PRD.Degree IS NULL
                              OR PRD.Degree = @Degree
                            )
                        AND ( PRL.LocationId IS NULL
                              OR PRL.LocationId = @LocationId
                            )
                        AND ( PRS.StaffId IS NULL
                              OR PRS.StaffId = @ClinicianId
                            )
                        AND ( PR.ClientId IS NULL
                              OR PR.ClientId = @ClientId
                            )
			--2014.06.02 - Match Rate to Service Area if defined  
                        AND ( PRSA.ServiceAreaId IS NULL
                              OR PRSA.ServiceAreaId = @ServiceAreaId
                            )
                        AND ( PRPOS.PlaceOfServieId IS NULL
                              OR PRPOS.PlaceOfServieId = @PlaceOfServiceId
                            )
                        AND ( ( ( NULLIF(PR.ModifierId1, '') IS NULL
                                  OR PR.ModifierId1 IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 )
                                )
                                AND ( NULLIF(PR.ModifierId2, '') IS NULL
                                      OR PR.ModifierId2 IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 )
                                    )
                                AND ( NULLIF(PR.ModifierId3, '') IS NULL
                                      OR PR.ModifierId3 IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 )
                                    )
                                AND ( NULLIF(PR.ModifierId4, '') IS NULL
                                      OR PR.ModifierId4 IN ( @ModifierId1, @ModifierId2, @ModifierId3, @ModifierId4 )
                                    )
                              )
                              OR ( ISNULL(PR.ModifierId1, '') = ''
                                   AND ISNULL(PR.ModifierId2, '') = ''
                                   AND ISNULL(PR.ModifierId3, '') = ''
                                   AND ISNULL(PR.ModifierId4, '') = ''
                                 )
                            )

        SELECT  @ProcedureRateId = ProcedureRateId ,
                @Charge = Charge
        FROM    @ProcedureRateChargeModifier
        WHERE   Ranking = 1

        INSERT  INTO @ProcedureRateCharge
                SELECT  @ProcedureRateId ,
                        @Charge
                        
                      
        RETURN
    END
GO


