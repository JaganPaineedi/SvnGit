
/****** Object:  StoredProcedure [dbo].[csp_ReportClientGeneralDemographics]    Script Date: 09/20/2017 16:11:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientGeneralDemographics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientGeneralDemographics]
GO


/****** Object:  StoredProcedure [dbo].[csp_ReportClientGeneralDemographics]    Script Date: 09/20/2017 16:11:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_ReportClientGeneralDemographics] @FROMDATE DATETIME
,   @ToDate DATETIME
,   @Location VARCHAR(MAX) = NULL
,   @ProgramsStr VARCHAR(MAX) = NULL
,   @Active VARCHAR(MAX) = 'B'
,   @Ages VARCHAR(MAX) = NULL
,   @InsuranceTypes VARCHAR(MAX) = NULL
,   @IncludeClientsWithNoServicesInTimeFrame BIT = 0
--,   @Ethnicity VARCHAR(MAX)
--,   @Race VARCHAR(MAX)
--,   @MilitaryStatus VARCHAR(MAX) = NULL


/************************************************************************************************
 Stored Procedure: dbo.csp_ReportClientGeneralDemographics                                     
                                                                                                 
 Created By: Jay                                                                                    
 Purpose:                        
                                                                                                 
 Test Call:  
      Exec csp_ReportClientGeneralDemographics @FromDate='1/1/16', @ToDate= '12/31/16'


 Change Log:                                                                                     
                                                                                                 
ModifiedDate	ModifiedBy		Purpose
20-Sep-2017		Irfan			What: Changed the length of this column SubDemographic from 100 to 8000. 
									  Since it was giving error 'String or binary data would be truncated'                                                                                                    
****************************************************************************************************/

AS
    BEGIN
        BEGIN TRY

            DECLARE @ErrorMessage VARCHAR(MAX) = ''
            DECLARE @IncludeServiceData CHAR(1) = 'Y'
            DECLARE @IncludeNonBillable CHAR(1) = 'N'
            DECLARE @LocationDefault VARCHAR(MAX)
            DECLARE @ProgramDefault VARCHAR(MAX)
            DECLARE @InsuranceTypesDefault VARCHAR(MAX)
            DECLARE @LimittedServices CHAR(1) = 'N'
            DECLARE @ReportMedicare CHAR(1) = 'N'
            DECLARE @ReportMedicaid CHAR(1) = 'N'
            DECLARE @ReportOther CHAR(1) = 'N'
      
            DECLARE @ServiceStatusesToCount TABLE ( item INTEGER )
            INSERT INTO @ServiceStatusesToCount
                VALUES  
                --( 70 )  -- Sheduled
                        ( 71 )  -- Show
                --,(72)  -- No Show
                --,(73)  -- Cancel
                ,       ( 75 )  -- Complete
                --,(76)  -- Error
        
            IF @IncludeClientsWithNoServicesInTimeFrame = 1
                SET @LimittedServices = 'N'
            ELSE
                SET @LimittedServices = 'Y'
  
--        DECLARE @ages VARCHAR(MAX)
            DECLARE @AgeInfo TABLE ( Value INTEGER
                                   , Label VARCHAR(26) )
            INSERT INTO @AgeInfo
                    ( Value
                    ,Label )
                    EXEC csp_ReportClientGeneralDemographicsParamaters 'Ages'


            DECLARE @AgesXref TABLE ( Id INTEGER
                                    , nMin INTEGER
                                    , nMax INTEGER )
            INSERT INTO @AgesXref
                    ( Id
                    ,nMin
                    ,nMax )
                    SELECT A.Value
                        ,   RTRIM(SUBSTRING(A.Label, 1, CHARINDEX('-', A.Label) - 1))
                        ,   RTRIM(LTRIM(SUBSTRING(A.Label, CHARINDEX('-', A.Label) + 1, 99)))
                        FROM @AgeInfo A

            DECLARE @AgeFilter TABLE ( Age INTEGER )
 
            DELETE A
                FROM @AgesXref A
                    LEFT JOIN dbo.fnSplit(@Ages, ',') FS ON FS.item = A.Id
                WHERE FS.item IS NULL
                    AND @Ages IS NOT NULL
            
            
       --#############################################################################
       -- tally
       --############################################################################# 
            ;
            WITH    lv0
                      AS ( SELECT 0 g
                           UNION ALL
                           SELECT 0 ),
                    lv1
                      AS ( SELECT 0 g
                            FROM lv0 a
                                CROSS JOIN lv0 b)-- 4
            ,       lv2
                      AS ( SELECT 0 g
                            FROM lv1 a
                                CROSS JOIN lv1 b)-- 16
            ,       lv3
                      AS ( SELECT 0 g
                            FROM lv2 a
                                CROSS JOIN lv2 b)-- 256
            ,       lv4
                      AS ( SELECT 0 g
                            FROM lv3 a
                                CROSS JOIN lv3 b)-- 65,536
            ,       Tally ( n )
                      AS ( SELECT ROW_NUMBER() OVER ( ORDER BY ( SELECT NULL ) )
                            FROM lv4),
                    top999
                      AS ( SELECT TOP ( 999 ) n
                            FROM Tally t
                            ORDER BY n)
                INSERT INTO @AgeFilter
                        ( Age )
                        SELECT n - 1
                            FROM top999 t
                                JOIN @AgesXref AX ON t.n - 1 BETWEEN AX.nMin AND AX.nMax
        
         
            SELECT @ToDate = DATEADD(dd, 1, @ToDate) 

            DECLARE @AvailableValues TABLE ( Value VARCHAR(50)
                                           , Label VARCHAR(50) )

            INSERT INTO @AvailableValues
                    ( Value
                    ,Label )
                    EXEC csp_ReportClientGeneralDemographicsParamaters 'InsuranceTypes'



                            --DECLARE @location VARCHAR(MAX)
            SELECT @InsuranceTypesDefault = STUFF(( SELECT ',' + CAST(Value AS VARCHAR)
                                                        FROM @AvailableValues
                                                  FOR
                                                    XML PATH('') ), 1, 1, '')

            --DECLARE @location VARCHAR(MAX)
            SELECT @LocationDefault = STUFF(( SELECT ',' + CAST(LocationId AS VARCHAR)
                                                FROM Locations L
                                                WHERE ISNULL(L.RecordDeleted, 'N') = 'N'
                                            FOR
                                              XML PATH('') ), 1, 1, '')
        
            --DECLARE @ProgramsStr VARCHAR(MAX)
            SELECT @ProgramDefault = STUFF(( SELECT ',' + CAST(ProgramId AS VARCHAR)
                                                FROM Programs
                                                WHERE ISNULL(RecordDeleted, 'N') = 'N'
                                                    AND ProgramType = 25163
                                           FOR
                                             XML PATH('') ), 1, 1, '')


            SELECT @InsuranceTypes = ISNULL(@InsuranceTypes, @InsuranceTypesDefault)
                ,   @Location = ISNULL(@Location, @LocationDefault)
                ,   @ProgramsStr = ISNULL(@ProgramsStr, @ProgramDefault)


        
            SELECT @ReportMedicaid = 'Y'
                WHERE CHARINDEX('Medicaid', @InsuranceTypes) > 0
            SELECT @ReportMedicare = 'Y'
                WHERE CHARINDEX('Medicare', @InsuranceTypes) > 0
            SELECT @ReportOther = 'Y'
                WHERE CHARINDEX('Other', @InsuranceTypes) > 0



            --IF @Location <> @LocationDefault
            --    OR @ProgramsStr <> @ProgramDefault
            --    OR @InsuranceTypes <> @InsuranceTypesDefault
            --    SET @LimittedServices = 'Y'

            CREATE TABLE #Output ( id INT IDENTITY(1, 1)
                                          PRIMARY KEY
                                 , Demographic VARCHAR(100)           --eg. Sex
								 , SubDemographic VARCHAR(8000)        --eg. Male --Modified on 20-09-2017 by Irfan
                                 , Total INTEGER
                                 , Services1To4 INTEGER
                                 , Services5Plus INTEGER
                                 , ClientName VARCHAR(MAX)
                                 , ClientId INTEGER
                                 , ServiceId INTEGER
                                 , DateofService DATETIME
                                 , ProcedureName VARCHAR(MAX)
                                 , ServiceCounts INTEGER )
        
       CREATE INDEX IDX_output_Clientid ON #Output(clientid, Demographic, SubDemographic)
     --  CREATE INDEX IDX_output_demographic ON #Output(Demographic)

            CREATE TABLE #Clients ( ClientId INT
                                  , HasMedicaid CHAR(1)
                                  , HasMedicare CHAR(1)
                                  , HasOther CHAR(1) )

            CREATE TABLE #Services ( ServiceId INT
                                   , Clientid INTEGER
                                   , ProcedureName VARCHAR(MAX)
                                   , DateOfService DATETIME );
            WITH    MyClients
                      AS ( SELECT ClientId
                            ,   dbo.GetAge(DOB, GETDATE()) AS Age
                            ,   Active
                            FROM Clients
                            WHERE ISNULL(RecordDeleted, 'N') = 'N')
                INSERT INTO #Clients
                        ( ClientId )
                        SELECT DISTINCT C.ClientId
                            FROM MyClients C
                                JOIN ClientPrograms CP ON CP.ClientId = C.ClientId
                                                          AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                JOIN ( SELECT item
                                        FROM dbo.fnSplit(@ProgramsStr, ',') ) ServicerProgs ON ServicerProgs.item = CP.ProgramId --JOIN dbo.fnSplit(@MilitaryStatus, ',') m ON m.item = ISNULL(C.MilitaryStatus, ( SELECT GlobalCodeId
                            --                                                                                    FROM GlobalCodes
                            --                                                                                    WHERE Category = 'MILITARYSTATUS'
                            --                                                                                        AND CodeName = 'Unknown' ))
                          -- SLOOOOOWWWW  JOIN @AgeFilter AF ON dbo.GetAge(C.DOB, GETDATE()) = AF.Age
                          -- Removed, we'll see if they want me to add it back...
                                --JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
                                --                          AND ISNULL(CE.RecordDeleted, 'N') = 'N'
                                --                          AND CE.RegistrationDate <= @ToDate
                                --                          AND ISNULL(CE.DischargeDate, @FromDate) >= @FromDate
                            WHERE ( @Active = 'B'
                                    OR ISNULL(C.Active, 'N') = @Active )
                                AND EXISTS ( SELECT 1
                                                FROM @AgeFilter AF
                                                WHERE AF.Age = C.Age )
                                AND EXISTS ( SELECT 1
                                                FROM ClientProgramHistory CPH
                                                WHERE CPH.ClientProgramId = CP.ClientProgramId
                                                    AND ISNULL(CPH.RecordDeleted, 'N') = 'N'
                                                    AND CPH.Status = 4
                                                    AND ISNULL(CPH.EnrolledDate, '7/4/1776') < @ToDate
                          AND ISNULL(CPH.DischargedDate, GETDATE()) > @FromDate )
                           

            UPDATE C
                SET HasMedicaid = 'Y'
                FROM #Clients C
                WHERE EXISTS ( SELECT 1
                                FROM ClientCoveragePlans CCP
                                    JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
                                    JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                WHERE ISNULL(CCP.RecordDeleted, 'N') = 'N'
                                    AND CCP.ClientId = C.ClientId
                                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                    AND CP.MedicaidPlan = 'Y'
                                    AND CCH.StartDate <= @ToDate
                                    AND ISNULL(CCH.EndDate, GETDATE()) >= @FromDate )
            UPDATE C
                SET HasMedicare = 'Y'
                FROM #Clients C
                WHERE EXISTS ( SELECT 1
                                FROM ClientCoveragePlans CCP
                                    JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
                                    JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                WHERE ISNULL(CCP.RecordDeleted, 'N') = 'N'
                                    AND CCP.ClientId = C.ClientId
                                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                    AND CP.MedicarePlan = 'Y'
                                    AND CCH.StartDate <= @ToDate
                                    AND ISNULL(CCH.EndDate, GETDATE()) >= @FromDate )
            UPDATE c
                SET HasOther = 'Y'
                FROM #Clients c
                WHERE EXISTS ( SELECT 1
                                FROM ClientCoveragePlans CCP
                                    JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
                                    JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                WHERE ISNULL(CCP.RecordDeleted, 'N') = 'N'
                                    AND CCP.ClientId = c.ClientId
                                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(CP.MedicarePlan, 'N') = 'N'
                                    AND ISNULL(CP.MedicaidPlan, 'N') = 'N'
                                    AND CCH.StartDate <= @ToDate
                                    AND ISNULL(CCH.EndDate, GETDATE()) >= @FromDate )





 --     Exec csp_ReportClientGeneralDemographics @FromDate='7/1/15', @ToDate= '12/31/15'

            INSERT INTO #Services
                    ( ServiceId
                    ,Clientid
                    ,DateOfService
                    ,ProcedureName )
                    SELECT S.ServiceId
                        ,   S.ClientId
                        ,   S.DateOfService
                        ,   PC.ProcedureCodeName
                        FROM Services S
                            JOIN #Clients C ON S.ClientId = C.ClientId
                            JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
                            JOIN @ServiceStatusesToCount st ON st.item = S.Status --JOIN ( SELECT item
                            --        FROM dbo.fnSplit(@ProgramsStr, ',') ) ServicerProgs ON ServicerProgs.item = S.ProgramId
                            JOIN ( SELECT item
                                    FROM dbo.fnSplit(@Location, ',') FS ) ServiceLocations ON ServiceLocations.item = S.LocationId
                            JOIN ( SELECT item
                                    FROM dbo.fnSplit(@ProgramsStr, ',') ) ServicerProgs ON ServicerProgs.item = S.ProgramId
                                                                                           AND ( ISNULL(S.Billable, 'N') = 'Y'
                                                                                                 OR @IncludeNonBillable = 'y' )
                                                                                           AND @IncludeServiceData = 'Y'
                                                                                           AND S.DateOfService BETWEEN @FromDate AND @ToDate

   --   Exec csp_ReportClientGeneralDemographics @FromDate='7/1/15', @ToDate= '12/31/15'
                             
--#############################################################################
-- if the user has selected specific locations or programs, delete any clients 
-- that do not have services with those locations or programs
--############################################################################# 
            IF @LimittedServices = 'Y'
                BEGIN
                    DELETE C
                        FROM #Clients C
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                        WHERE S.ServiceId IS NULL


                END

--#############################################################################
-- now for the insurance types bit
--############################################################################# 


    --  Exec csp_ReportClientGeneralDemographicsParamaters 'InsuranceTypes'


--#############################################################################
-- end insurance types bit.
--############################################################################# 
            INSERT INTO #Output
                    ( Demographic
                    ,SubDemographic
                    ,ClientId
                    ,ServiceId
                    ,DateofService
                    ,ProcedureName )
--#############################################################################
-- Sex
--############################################################################# 
                    SELECT 'Sex'
                        ,   CASE WHEN C.Sex = 'M' THEN 'Male'
                                 WHEN C.Sex = 'F' THEN 'Female'
                                 ELSE 'Other'
                            END
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN #Services S ON C.ClientId = S.Clientid
                   
--#############################################################################
-- Race
--#############################################################################                                 
                    UNION ALL
                    SELECT 'Race'
                        ,   ISNULL(dbo.GetGlobalCodeName(CR.RaceId), 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN ClientRaces CR ON CR.ClientId = C.ClientId
                                                        AND ISNULL(CR.RecordDeleted, 'N') = 'N'
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                                                  
--#############################################################################
-- Ethnicity
--#############################################################################     
                    UNION ALL
                    SELECT 'Ethnicity'
                        ,   ISNULL(Ethnicity.Ethnicity, 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM dbo.Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN dbo.ClientEthnicities CE ON C.ClientId = CE.ClientId
                                                                  AND ISNULL(CE.RecordDeleted, 'N') <> 'Y'
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                            OUTER APPLY ( SELECT STUFF(( SELECT ',' + dbo.GetGlobalCodeName(CE.EthnicityId)
                                                            FROM dbo.ClientEthnicities CE
                                                            WHERE ISNULL(CE.RecordDeleted, 'N') = 'N'
                                                                AND CE.ClientId = C.ClientId
                                                       FOR
                                                         XML PATH('') ), 1, 1, '') Ethnicity ) Ethnicity
		
--#############################################################################
-- Military Status
--#############################################################################
                    UNION ALL
                    SELECT 'Military Status'
                        ,   ISNULL(dbo.GetGlobalCodeName(C.MilitaryStatus), 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM dbo.Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN #Services S ON C.ClientId = S.Clientid
                    
--#############################################################################
-- Living
--############################################################################# 
                    UNION ALL
                    SELECT 'Living'
                        ,   ISNULL(dbo.GetGlobalCodeName(C.LivingArrangement), 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                                                    
--#############################################################################
-- County of Residence
--############################################################################# 
                    UNION ALL
                    SELECT 'County of Residence'
                        ,   ISNULL(C2.CountyName, 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN Counties C2 ON CAST(C.CountyOfResidence AS INTEGER) = CAST(C2.CountyFIPS AS INTEGER)
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                                                    
                    
--#############################################################################
-- County of Financial Responsibility
--############################################################################# 
  UNION ALL
                    SELECT 'County of Financial Responsibility'
                        ,   ISNULL(C2.CountyName, 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN Counties C2 ON CAST(C.CountyOfTreatment AS INTEGER) = CAST(C2.CountyFIPS AS INTEGER)
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                           


--#############################################################################
-- Education Status
--############################################################################# 
                    UNION ALL
                    SELECT 'Educational Status'
                        ,   ISNULL(dbo.GetGlobalCodeName(C.EducationalStatus), 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                           
--#############################################################################
-- Employment Status
--############################################################################# 
                    UNION ALL
                    SELECT 'Employment Status'
                        ,   ISNULL(dbo.GetGlobalCodeName(C.EmploymentStatus), 'Unknown')
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                           
--#############################################################################
-- Age
--############################################################################# 
                    UNION ALL
                    SELECT 'Age'
                        ,   CASE WHEN dbo.GetAge(C.DOB, GETDATE()) BETWEEN 0 AND 3 THEN '0-3'
                                 WHEN dbo.GetAge(C.DOB, GETDATE()) BETWEEN 4 AND 7 THEN '4-7'
                                 WHEN dbo.GetAge(C.DOB, GETDATE()) BETWEEN 8 AND 11 THEN '8-11'
                                 WHEN dbo.GetAge(C.DOB, GETDATE()) BETWEEN 12 AND 17 THEN '12-17'
                                 WHEN dbo.GetAge(C.DOB, GETDATE()) BETWEEN 18 AND 25 THEN '18-25'
                                 WHEN dbo.GetAge(C.DOB, GETDATE()) BETWEEN 26 AND 64 THEN '26-64'
                                 WHEN dbo.GetAge(C.DOB, GETDATE()) > 64 THEN '65+'
                            END
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId

                         
--#############################################################################
-- Insurance Type
--############################################################################# 
                    UNION ALL
                    SELECT 'Insurance Type'
                        ,   'Medicaire'
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                    JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                                                AND Cl.HasMedicare = 'Y'
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                            LEFT JOIN Charges CH ON CH.ServiceId = S.ServiceId
                                                    AND ISNULL(CH.RecordDeleted, 'N') = 'N'
                            LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CH.ClientCoveragePlanId
                                                                 AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                            LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                                          AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                                          AND CP.MedicarePlan = 'Y'
                    UNION ALL
                    SELECT 'Insurance Type'
                        ,   'Medicaid'
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                                                AND Cl.HasMedicaid = 'Y'
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                            LEFT JOIN Charges CH ON CH.ServiceId = S.ServiceId
                                                    AND ISNULL(CH.RecordDeleted, 'N') = 'N'
                            LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CH.ClientCoveragePlanId
                                                                 AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                            LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                                          AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                                          AND CP.MedicaidPlan = 'Y'
                    UNION ALL
                    SELECT 'Insurance Type'
                        ,   'Other'
                        ,   C.ClientId
                        ,   S.ServiceId
                        ,   S.DateOfService
                        ,   S.ProcedureName
                        FROM Clients C
                            JOIN #Clients Cl ON Cl.ClientId = C.ClientId
                                                AND Cl.HasOther = 'Y'
                            LEFT JOIN #Services S ON S.Clientid = C.ClientId
                            LEFT JOIN Charges CH ON CH.ServiceId = S.ServiceId
                                                    AND ISNULL(CH.RecordDeleted, 'N') = 'N'
                            LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CH.ClientCoveragePlanId
                                                                 AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                            LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                                          AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                                          AND ( ISNULL(CP.MedicaidPlan, 'N') = 'N'
                                                                AND ISNULL(CP.MedicarePlan, 'N') = 'N' )

--#############################################################################
-- Totals
--############################################################################# 
      --;
      --      WITH    Totals
      --                AS ( SELECT   O.Demographic
      --                     ,        O.SubDemographic
      --                     ,        COUNT(DISTINCT ClientId) AS Tot
      --                     FROM     #Output O
      --                     GROUP BY O.Demographic
      --     ,        O.SubDemographic
      --                   )
      --          UPDATE  O
      --          SET     O.Total = T.Tot
      --          FROM    #Output O
      --                  JOIN Totals T ON O.Demographic = T.Demographic
      --                                   AND T.SubDemographic = O.SubDemographic
       
--      Exec csp_ReportClientGeneralDemographics @FromDate='7/1/15', @ToDate= '12/31/15' --18

            UPDATE #Output
                SET Total = 1
                ,   Services1To4 = 0
                ,   Services5Plus = 0
                ,   ServiceCounts = 0


          --21      return
            UPDATE O
                SET O.Total = 0
                FROM #Output O
                WHERE O.Total = 1
                    AND EXISTS ( SELECT 1
                                    FROM #Output O2
                                    WHERE O.Demographic = O2.Demographic
                                        AND O.SubDemographic = O2.SubDemographic
                                        AND O.ClientId = O2.ClientId
                                        AND O2.id > O.id )
 --#############################################################################
 -- Service counts
 --#############################################################################               
   ;
            WITH    UniqueServices
                      AS ( SELECT  DISTINCT Clientid
                            ,   ServiceId
                            FROM #Services S),
                    ClientTots
                      AS ( SELECT Clientid
                            ,   SUM(1) AS tot
                            FROM UniqueServices
                            GROUP BY Clientid)
                UPDATE O
                    SET O.ServiceCounts = ISNULL(T.tot, 0)
                    ,   O.Services1To4 = CASE WHEN T.tot BETWEEN 1 AND 4 THEN 1
                                              ELSE 0
                                         END
                    ,   O.Services5Plus = CASE WHEN T.tot >= 5 THEN 1
                                               ELSE 0
                                          END
                    FROM #Output O
                        JOIN ClientTots T ON O.ClientId = T.Clientid

--      Exec csp_ReportClientGeneralDemographics @FromDate='7/1/15', @ToDate= '12/31/15' --18 -- 45



            UPDATE O
                SET O.Services1To4 = 0
                FROM #Output O
                WHERE O.Services1To4 > 0
                    AND EXISTS ( SELECT 1
                                    FROM #Output O2
                                    WHERE O.Demographic = O2.Demographic
                                        AND O.SubDemographic = O2.SubDemographic
                                        AND O.ClientId = O2.ClientId
                                        AND O2.id > O.id )

            UPDATE O
                SET O.Services5Plus = 0
                FROM #Output O
                WHERE O.Services5Plus > 0
                    AND EXISTS ( SELECT 1
                                    FROM #Output O2
                                    WHERE O.Demographic = O2.Demographic
                                        AND O.SubDemographic = O2.SubDemographic
                                        AND O.ClientId = O2.ClientId
                                        AND O2.id > O.id )


            UPDATE O
                SET O.ClientName = C.LastName + ', ' + C.FirstName + ' (' + CAST(C.ClientId AS VARCHAR) + ')'
                FROM #Output O
                    JOIN Clients C ON C.ClientId = O.ClientId





--#############################################################################
-- Output
--############################################################################# 
        
        
            SELECT O.Demographic
                ,   O.SubDemographic
                ,   O.ClientId
  ,   O.ClientName
                ,   O.ServiceId
                ,   S.DateOfService
                ,   PC.ProcedureCodeName
                ,   O.Total
                ,   O.Services1To4
                ,   O.Services5Plus
                ,   O.ServiceCounts
                ,   dbo.GetGlobalCodeName(S.Status) AS [Status]
                FROM #Output O
                    JOIN Clients c ON c.ClientId = O.ClientId
                    LEFT JOIN Services S ON O.ServiceId = S.ServiceId
                    LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
                ORDER BY O.Demographic
                ,   O.SubDemographic
                ,   O.ClientName
                ,   O.DateofService
                ,   O.ProcedureName

        END TRY
     
        BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                          
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ReportClientGeneralDemographics')                                                
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                            
		+ '*****' + Convert(varchar,ERROR_STATE())                                                                          
	                                                        
		RAISERROR                                                                           
		(                                         
		  @Error, -- Message text.                                                                          
		  16, -- Severity.                                                                          
		  1 -- State.                                                                          
		); 
        END CATCH
    END



GO


