IF EXISTS ( SELECT  *
            FROM    sys.procedures
            WHERE   name = 'ssp_PMClaimsGetPlaceOfService' )
    DROP PROCEDURE ssp_PMClaimsGetPlaceOfService
GO

CREATE PROCEDURE ssp_PMClaimsGetPlaceOfService
AS
    BEGIN

		/****************
		-- 10/2/2015		NJain			Created
		****************/

        CREATE TABLE #PlaceOfService
            (
              ChargeId INT ,
              ServiceId INT ,
              PlaceOfService INT ,
              CoveragePlanId INT
            )
		
        CREATE TABLE #PlaceOfServiceCalculation
            (
              ChargeId INT ,
              PlaceOfService INT
            )
		
        INSERT  INTO #PlaceOfService
                ( ChargeId ,
                  ServiceId ,
                  PlaceOfService ,
                  CoveragePlanId
                )
                SELECT  ChargeId ,
                        ServiceId ,
                        PlaceOfService ,
                        CoveragePlanId
                FROM    #Charges
		
		
        INSERT  INTO #PlaceOfServiceCalculation
                ( ChargeId ,
                  PlaceOfService
                )
                SELECT 
                        a.ChargeId ,
                        d.PlaceofServiceId
                FROM    #PlaceOfService a
                        JOIN dbo.Services b ON b.ServiceId = a.ServiceId
                        JOIN dbo.Programs c ON c.ProgramId = b.ProgramId
                        JOIN dbo.Staff c2 ON c2.StaffId = b.ClinicianId
                        LEFT JOIN dbo.PlaceofServiceMappings d ON d.PlaceofServiceId IS NOT NULL
                        LEFT JOIN dbo.PlaceofServiceMappingPlans d2 ON d2.PlaceOfServiceMappingId = d.PlaceOfServiceMappingId
                                                                       AND ISNULL(d2.RecordDeleted, 'N') = 'N'
                        LEFT JOIN PlaceofServiceMappingPrograms d3 ON d3.PlaceOfServiceMappingId = d.PlaceOfServiceMappingId
                                                                      AND ISNULL(d3.RecordDeleted, 'N') = 'N'
                        LEFT JOIN PlaceofServiceMappingLocations d4 ON d4.PlaceOfServiceMappingId = d.PlaceOfServiceMappingId
                                                                       AND ISNULL(d4.RecordDeleted, 'N') = 'N'
                        LEFT JOIN PlaceofServiceMappingDegrees d5 ON d5.PlaceOfServiceMappingId = d.PlaceOfServiceMappingId
                                                                     AND ISNULL(d5.RecordDeleted, 'N') = 'N'
                        LEFT JOIN PlaceOfServiceMappingProcedureCodes d6 ON d6.PlaceOfServiceMappingId = d.PlaceOfServiceMappingId
                                                                            AND ISNULL(d6.RecordDeleted, 'N') = 'N'
                        LEFT JOIN PlaceOfServiceMappingStaff d7 ON d7.PlaceOfServiceMappingId = d.PlaceOfServiceMappingId
                                                                   AND ISNULL(d7.RecordDeleted, 'N') = 'N'
                        LEFT JOIN PlaceofServiceMappingServiceAreas d8 ON d8.PlaceOfServiceMappingId = d.PlaceOfServiceMappingId
                                                                          AND ISNULL(d8.RecordDeleted, 'N') = 'N'
                WHERE   CAST(b.DateOfService AS DATE) BETWEEN CAST(ISNULL(d.FromDate, '1/1/1911') AS DATE)
                                                      AND     CAST(ISNULL(d.ToDate, '12/31/2199') AS DATE)
                        AND ( a.CoveragePlanId = d2.CoveragePlanId
                              OR ISNULL(d.PlanGroupName, '') = ''
                            )
                        AND ( b.ProgramId = d3.ProgramId
                              OR ISNULL(d.ProgramGroupName, '') = ''
                            )
                        AND ( b.LocationId = d4.LocationId
                              OR ISNULL(d.LocationGroupName, '') = ''
                            )
                        AND ( c2.Degree = d5.Degree
                              OR ISNULL(d.DegreeGroupName, '') = ''
                            )
                        AND ( b.ProcedureCodeId = d6.ProcedureCodeId
                              OR ISNULL(d6.ProcedureCodeId, '') = ''
                            )
                        AND ( b.ClinicianId = d7.StaffId
                              OR ISNULL(d.StaffGroupName, '') = ''
                            )
                        AND ( c.ServiceAreaId = d8.ServiceAreaId
                              OR ISNULL(d.ServiceAreaGroupName, '') = ''
                            )
                ORDER BY a.ChargeId ASC ,
                        ISNULL(d.Priority, 100) ASC ,
                        ( CASE WHEN a.CoveragePlanId = d2.CoveragePlanId THEN 1
                               ELSE 0
                          END + CASE WHEN b.ProgramId = d3.ProgramId THEN 1
                                     ELSE 0
                                END + CASE WHEN b.LocationId = d4.LocationId THEN 1
                                           ELSE 0
                                      END + CASE WHEN c2.Degree = d5.Degree THEN 1
                                                 ELSE 0
                                            END + CASE WHEN b.ProcedureCodeId = d6.ProcedureCodeId THEN 1
                                                       ELSE 0
                                                  END + CASE WHEN b.ClinicianId = d7.StaffId THEN 1
                                                             ELSE 0
                                                        END + CASE WHEN c.ServiceAreaId = d8.ServiceAreaId THEN 1
                                                                   ELSE 0
                                                              END )                                                 
				
        UPDATE  a
        SET     PlaceOfService = CASE WHEN ISNULL(b.PlaceOfService, 0) <> 0 THEN b.PlaceOfService
                                      ELSE a.PlaceOfService
                                 END
        FROM    #PlaceOfService a
                JOIN #PlaceOfServiceCalculation b ON b.ChargeId = a.ChargeId
                    

                                        
        UPDATE  a
        SET     PlaceOfService = b.PlaceOfService ,
                PlaceOfServiceCode = c.ExternalCode1
        FROM    #Charges a
                JOIN #PlaceOfService b ON b.ChargeId = a.ChargeId
                LEFT JOIN GlobalCodes c ON ( b.PlaceOfService = c.GlobalCodeId )                                                              


    END