IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'csp_RDLCategoricalReport')
                    AND type IN ( N'P', N'PC' ) ) 
            BEGIN 
            DROP PROCEDURE csp_RDLCategoricalReport
            END
            go
            
            
CREATE PROCEDURE csp_RDLCategoricalReport
@StartDate DATETIME,
@EndDate DATETIME
AS
--DECLARE @StartDate DATETIME
--  , @EndDate DATETIME
BEGIN TRY
 SET NOCOUNT ON  
DECLARE @errorMessage VARCHAR(MAX)
DECLARE @Results TABLE
    (
      ServiceId INT
    , ClientId INT
    , ClientName VARCHAR(MAX)
    , ClientAge INT
    , DOS DATETIME
    , ProcedureCodeId INT
    , ProcedureCode VARCHAR(MAX)
    , StaffId INT
    , StaffName VARCHAR(MAX)
    , StatusId INT
    , [Status] VARCHAR(MAX)
    , ProgramId INT
    , ProgramName VARCHAR(MAX)
    , Category VARCHAR(MAX)
    , SubCategory VARCHAR(MAX)
    , FundingSource VARCHAR(MAX)
    , Charge MONEY
    , ExcludedPlan VARCHAR(MAX)
    , [Population] VARCHAR(MAX)
    , ErrorMessage VARCHAR(MAX)
    , DUIICharge MONEY
    , ChargeExcludingExcluded money
    )
IF @StartDate > @EndDate
BEGIN
SELECT @errorMessage = 'The Start Date cannot be after the End Date'
END

IF @errorMessage IS NOT NULL
BEGIN
RAISERROR(@errorMessage,16,1)

END


SET @StartDate = CONVERT(DATE , @StartDate)
SET @EndDate = CONVERT(DATE , @EndDate)



DECLARE @Services TABLE
    (
      ServiceId INT
    , ClientId INT
    , ProcedureCodeId INT
    , DateOfService DATETIME
    , EndDateOfService DATETIME
    , Unit DECIMAL
    , UnitType INT
    , [Status] INT
    , ClinicianId INT
    , ProgramId INT
    , LocationId INT
    , Charge MONEY
    , ProcedureRateId INT
    )

INSERT  INTO @Services
        ( ServiceId
        , ClientId
        , ProcedureCodeId
        , DateOfService
        , EndDateOfService
        , Unit
        , UnitType
        , [Status]
        , ClinicianId
        , ProgramId
        , LocationId
        , Charge
        , ProcedureRateId 
        )
        SELECT  s.ServiceId
              , s.ClientId
              , s.ProcedureCodeId
              , s.DateOfService
              , s.EndDateOfService
              , s.Unit
              , s.UnitType
              , s.[Status]
              , s.ClinicianId
              , s.ProgramId
              , s.LocationId
              , s.Charge
              , s.ProcedureRateId
        FROM    dbo.[Services] s
        WHERE   CONVERT(DATE , s.DateOfService) >= @StartDate
                AND CONVERT(DATE , s.DateOfService) <= @EndDate
                AND ISNULL(s.RecordDeleted , 'N') = 'N'
                AND s.[Status] IN ( 71 , 75 ) --show, complete
                AND NOT EXISTS ( SELECT 1
                                 FROM   dbo.ssf_RecodeValuesCurrent('ExcludeStateCategoricalProgram') AS rel
                                 WHERE  s.ProgramId = rel.IntegerCodeId )





-- if there are no services in the date range, exit
IF ( SELECT COUNT(*)
     FROM   @Services ) = 0 
    BEGIN
    SELECT @errorMessage = 'No services found in date range.'
      RAISERROR(@errorMessage,16,1)
    END 


--try to determine a rate for each service that does not have a rateid or charge amount already
--update the rate and charge if we can

DECLARE @ServiceId INT
  , @ClientId INT
  , @ProcedureCodeId INT
  , @DateOfService DATETIME
  , @EndDateOfService DATETIME
  , @Unit DECIMAL
  , @UnitType INT
  , @Status INT
  , @ClinicianId INT
  , @ProgramId INT
  , @LocationId INT
  , @Charge MONEY
  , @ProcedureRateId INT  

DECLARE charge_Cursor CURSOR FAST_FORWARD
FOR
    SELECT  s.ServiceId
          , s.ClientId
          , s.ProcedureCodeId
          , s.DateOfService
          , s.EndDateOfService
          , s.Unit
          , s.UnitType
          , s.[Status]
          , s.ClinicianId
          , s.ProgramId
          , s.LocationId
          , s.Charge
          , s.ProcedureRateId
    FROM    @Services s
    WHERE   s.ProcedureRateId IS NULL
            OR s.Charge IS NULL 

OPEN charge_Cursor
FETCH NEXT FROM charge_Cursor INTO @ServiceId , @ClientId , @ProcedureCodeId , @DateOfService , @EndDateOfService , @Unit , @UnitType , @Status , @ClinicianId , @ProgramId , @LocationId , @Charge , @ProcedureRateId
					 
WHILE @@Fetch_STatus = 0 
    BEGIN

        EXEC ssp_PMServiceCalculateCharge @ClientId = @ClientId , @DateOfService = @StartDate , @ClinicianId = @ClinicianId , @ProcedureCodeId = @ProcedureCodeId , @Units = @Unit , @ProgramId = @ProgramId , @LocationId = @LocationId , @ProcedureRateId = @ProcedureRateId OUTPUT , @Charge = @Charge OUTPUT
	
	
        UPDATE  @Services
        SET     ProcedureRateId = @ProcedureRateId
              , Charge = @Charge
        WHERE   ServiceId = @ServiceId



        FETCH NEXT FROM charge_Cursor INTO @ServiceId , @ClientId , @ProcedureCodeId , @DateOfService , @EndDateOfService , @Unit , @UnitType , @Status , @ClinicianId , @ProgramId , @LocationId , @Charge , @ProcedureRateId
    END

CLOSE charge_Cursor
DEALLOCATE charge_Cursor

--Declare and Init variables for category and sub category use
DECLARE @Outpatient INT
  , @Crisis INT
  , @ProblemGambling INT

SELECT  @Outpatient = GlobalCodeId
FROM    dbo.GlobalCodes
WHERE   Category = 'PROGRAMTYPE'
        AND CodeName = 'Outpatient'
        AND ISNULL(RecordDeleted , 'N') = 'N' 
SELECT  @Crisis = GlobalCodeId
FROM    dbo.GlobalCodes
WHERE   Category = 'PROGRAMTYPE'
        AND CodeName = 'Crisis'
        AND ISNULL(RecordDeleted , 'N') = 'N' 
SELECT  @ProblemGambling = GlobalCodeId
FROM    dbo.GlobalCodes
WHERE   Category = 'PROGRAMTYPE'
        AND CodeName = 'Problem Gambling'
        AND ISNULL(RecordDeleted , 'N') = 'N' 


-- validate the variables were init
IF @Outpatient IS NULL 
    BEGIN
        SELECT  @errorMessage = 'Cannot find Program Type: Outpatient globalcode. '

    END 
IF @Crisis IS NULL 
    BEGIN
        SELECT  @errorMessage = ISNULL(@errorMessage , '') + 'Cannot find Program Type: Crisis globalcode. '

    END 
IF @ProblemGambling IS NULL 
    BEGIN
        SELECT  @errorMessage = ISNULL(@errorMessage , '') + 'Cannot find Program Type: Problem Gambling globalcode. '
    END 

IF @errorMessage IS NOT NULL 
    BEGIN
        RAISERROR(@errorMessage, 16,1)
    END 



--insert all of our services into the Results table variable now that they are ready to go
--figure out the popluation, service area and sub category, category in initial select
INSERT  INTO @Results
        ( ServiceId
        , ClientId
        , ClientName
        , ClientAge
        , [Population]
        , DOS
        , ProcedureCodeId
        , ProcedureCode
        , StaffId
        , StaffName
        , StatusId
        , [Status]
        , ProgramId
        , ProgramName
        , Category
        , SubCategory
        , FundingSource
        , Charge
        , ExcludedPlan
        , DUIICharge
        , ChargeExcludingExcluded
        )
        SELECT  s.ServiceId
              , c.ClientId
              , c.FirstName + ' ' + c.LastName AS ClientName
              , dbo.GetAge(c.DOB , CONVERT(DATE , s.DateOfService)) AS ClientAge
              , CASE WHEN dbo.GetAge(c.DOB , CONVERT(DATE , s.DateOfService)) < 18 THEN 'Child'
                     ELSE 'Adult'
                END AS [Population]
              , s.DateOfService
              , s.ProcedureCodeId
              , pc.DisplayAs AS ProcedureCode
              , s.ClinicianId
              , st.DisplayAs AS StaffName
              , s.[Status] AS StatusId
              , dbo.ssf_GetGlobalCodeNameById(s.[Status]) AS [Status]
              , s.ProgramId
              , p.ProgramName
              ,
   ---Category
                CASE p.ProgramType
                  WHEN @Outpatient THEN 'Outpatient'
                  WHEN @Crisis THEN 'Crisis'
                  WHEN @ProblemGambling THEN 'Gambling'
                  ELSE 'Program Type Not Found'
                END AS Category
              ,
   --Sub Category
                CASE sa.ServiceAreaName -- having a program type of Problem Gambling override the sub category from service area
                  WHEN 'Mental Health' THEN CASE p.ProgramType
									    WHEN @ProblemGambling 
											 THEN 'Prevention'
									   ELSE 'Mental Health'
									   END 
                  WHEN 'SA' THEN CASE p.ProgramType
									    WHEN @ProblemGambling 
											 THEN 'Prevention'
									   ELSE 'Alcohol and Other Drug'
									   end
                  ELSE CASE p.ProgramType
				     WHEN @ProblemGambling 
						 THEN 'Prevention'
				   ELSE 'Not Found'
				   END 
                END AS SubCategory
              ,
    ---Funding Source
                CASE p.ProgramType
                  WHEN @Outpatient THEN 'State General Fund'
                  WHEN @Crisis THEN 'MH BG'
                  WHEN @ProblemGambling THEN 'MH BG'
                  ELSE 'Program Type Not Found'
                END AS FundingSource
              , s.Charge
              , NULL --excluded plan
              , CASE 
				WHEN p.ProgramId IN (109,110)--'BHW - DUII Rehabiliation', 'BHW - DUII Education'
					   THEN s.Charge
					ELSE 0
					END 
			, NULL --ChargeExcludingExcluded
			
        FROM    @Services s
        JOIN    dbo.Clients c ON s.ClientId = c.ClientId
                                 AND ISNULL(c.RecordDeleted , 'N') = 'N'
        JOIN    dbo.Programs p ON s.ProgramId = p.ProgramId
                                  AND ISNULL(p.RecordDeleted , 'N') = 'N'
        JOIN    dbo.ServiceAreas sa ON p.ServiceAreaId = sa.ServiceAreaId
                                       AND ISNULL(sa.RecordDeleted , 'N') = 'N'
        JOIN    dbo.ProcedureCodes pc ON s.ProcedureCodeId = pc.ProcedureCodeId
                                         AND ISNULL(pc.RecordDeleted , 'N') = 'N'
        JOIN    dbo.Staff st ON s.ClinicianId = st.StaffId
                                AND ISNULL(st.RecordDeleted , 'N') = 'N'

--handle the category and sub category stuff


---Did the client have an 'ExcludedStateCategoricalPlan' during that date of service

UPDATE s
SET s.ExcludedPlan = ( SELECT TOP 1 cp.DisplayAs from ClientCoveragePlans ccp
				    JOIN ClientCoverageHistory cch  ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
				    AND ISNULL(cch.RecordDeleted,'N')='N'
				    AND CONVERT(DATE,cch.StartDate) <= CONVERT(DATE,s.DOS)
				    AND ( ( cch.EndDate IS NULL ) OR ( CONVERT(DATE,cch.EndDate) >= CONVERT(DATE,s.DOS) ) )
				    JOIN CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId
				    AND ISNULL(cp.RecordDeleted,'N')='N'
				    JOIN ssf_RecodeValuesCurrent('ExcludeStateCategoricalCoveragePlan') AS rel on rel.IntegerCodeId = ccp.CoveragePlanId 
				    WHERE ISNULL(ccp.RecordDeleted,'N')='N'
				    AND ccp.ClientId = s.ClientId
				    ORDER BY cch.COBOrder asc
				 )
FROM @Results s

UPDATE s 
SET s.ChargeExcludingExcluded = s.Charge
FROM @Results s
WHERE LEN(LTRIM(RTRIM(ISNULL(s.ExcludedPlan,'')))) = 0 OR s.ExcludedPlan IS NULL 



SELECT ClientId,ClientName,[Population],DOS,ProcedureCode,StaffName,[Status],ProgramName,Category,SubCategory,FundingSource,Charge,ExcludedPlan,ErrorMessage, DUIICharge
        , ChargeExcludingExcluded FROM @Results
ORDER BY ClientId,Category

SET NOCOUNT OFF

END TRY

begin CATCH

DELETE FROM r FROM @Results r

--handle unexpected error
SELECT @errorMessage = ISNULL(@errorMessage,'') + CHAR(13)+CHAR(10) + ' ' + ERROR_MESSAGE()

INSERT INTO @Results (ErrorMessage)
SELECT @errorMessage

SELECT ClientId,ClientName,[Population],DOS,ProcedureCode,StaffName,[Status],ProgramName,Category,SubCategory,FundingSource,Charge,ExcludedPlan,ErrorMessage, DUIICharge
        , ChargeExcludingExcluded FROM @Results
ORDER BY ClientId,Category

END CATCH

go