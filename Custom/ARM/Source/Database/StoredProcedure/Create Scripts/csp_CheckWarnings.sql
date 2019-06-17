/****** Object:  StoredProcedure [dbo].[csp_CheckWarnings]    Script Date: 3/24/2016 1:03:40 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CheckWarnings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CheckWarnings]
GO


/****** Object:  StoredProcedure [dbo].[csp_CheckWarnings]    Script Date: 3/24/2016 1:03:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_CheckWarnings]
	/* Param List */
	@ClientId INT
	,@ServiceId INT
	,@ProcedureCodeId INT
	,@ClinicianId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@Attending VARCHAR(10)
	,@DSMCode1 VARCHAR(10)
	,@DSMCode2 VARCHAR(10)
	,@DSMCode3 VARCHAR(10)
	,@ServiceCompletionStatus VARCHAR(10)
	,@ProgramId INT
	,@LocationId INT
	,@Degree INT
	,@UnitValue DECIMAL(9, 2)
	,@Count INT
	,@ServiceAlreadyCompleted CHAR(1)
	,@Billable CHAR(1)
	,@DoesNotRequireStaffForService CHAR(1)
	,@PreviousStatus INT
	,@IsRecursive CHAR(1) = 'N'
	/******************************************************************************  
**  
**  Name: csp_CheckWarnings  
**  Desc:  
**  This procedure is used to check the warnings for the service, while completing the service.  
**  
**  Return values:  
**  
**  Called by:   ServiceDetails.cs  
**  
**  Parameters:  
**  Input       Output  
**              @ClientId int,  
**  @ServiceId int,  
**  @ProcedureCodeId int,  
**  @ClinicianId int,  
**  @StartDate DateTime,  
**  @EndDate DateTime,  
**  @Attending varchar(10),  
**  @DSMCode1 varchar(10),  
**  @DSMCode2 varchar(10),  
**  @DSMCode3 varchar(10)  
**  
**  Auth: Rohit  
**  Date:  
*******************************************************************************  
**  Change History  
*******************************************************************************  
** Date:  Author:  Description:  
** 01/31/2007 SFerenz  Created  
** 09/03/2008 avoss  modified to require a note for non billable procdures that require a note  
** 12/22/2009 avoss  Modified to delete auth service errors for cancel, no show, and error services  
** 12/17/2012 T.Remisoski Added check for locations    
** 12/18/2012 M.Lightner Removed ProcedureCodes.EndDateEqualsStartDate requirement   
       for ErrorType 1000002, 'Duplicate Service Date/Time for Clinician';  
       for ErrorType 1000033, 'Overlapping Date/Time Services for this clinician';  
       and for ErrorType 1000034, 'Overlapping Date/Time Services for this client'.  
       Also, cleaned up date/time overlap logic in all three checks.  
** 12/18/2012 M.Lightner Added ProcedureCodeId exceptions to the duration check (rule 9).  
**  02/26/2013  T.Remisoski Remove errors for services that have zero rates.  
**  04/12/2015 T.Remisoski Implement business rule that checks for proper diagnosis in service area.  
**  07/12/2015  Hemant      commented DiagnosisCode1 logic .Why:#282 A Renewed Mind - Support ;DiagnosisCode1 column is invalid in service table  
**  09/28/2015  Hemant      commented Code as per mail with Subject : SHOW STOPPING ERROR   
**  03/21/2015  MJensen		Added procedure code 289 to DA checks per Ace task 444
**  31/01/2018  Lakshmi  Added validation ''Must have a signed note before completing a service.'' when procedure is non billable and it must have a associated note. As per the task A Renewed Mind - Support #824
**  02/28/2018  Bibhu    Added @ServiceCompletionStatus = 'Completed' and Not Exists Condition  check for validation ''Must have a signed note before completing a service.'' when procedure is non billable and it must have a associated note. As per the task A Renewed Mind - Support #836
*******************************************************************************/
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Status INT

SELECT @Status = STATUS
FROM Services
WHERE ServiceId = @ServiceId

DECLARE @GoLiveDate DATETIME

SET @GoLiveDate = '4/1/2012'

DECLARE @MACSISPlans TABLE (CoveragePlanId INT)

INSERT INTO @MACSISPlans
SELECT CoveragePlanId
FROM CoveragePlans
WHERE (
		DisplayAs LIKE 'MHMCD%'
		OR DisplayAs LIKE 'MHNON%'
		OR DisplayAs LIKE 'DFMCD%'
		OR DisplayAs LIKE 'DFNON%'
		)

DECLARE @ServiceAreaId INT

SELECT @ServiceAreaId = ServiceAreaId
FROM Programs
WHERE @ProgramId = ProgramId

DECLARE @Age INT

SELECT @Age = dbo.GetAge(c.DOB, s.DateOfService)
FROM Services s
JOIN Clients c ON c.ClientId = s.ClientId
	AND c.ClientId = @ClientId
WHERE s.ServiceId = @ServiceId

IF @ServiceCompletionStatus = 'Completed'
	AND @PreviousStatus <> 75
	AND @ProcedureCodeId IN (
		SELECT ProcedureCodeId
		FROM ProcedureCodes
		WHERE (
				ProcedureCodeId IN (
					234 -- INS Diag Assessment  
					,203 -- MH Diag Assessment  
					,223 -- SA Diag Assessment 
					,289
					)
				)
		)
	AND NOT EXISTS (
		SELECT 1
		FROM Documents d
		--    JOIN services s ON s.ServiceId = d.ServiceId AND ISNULL(s.RecordDeleted,'N') <> 'Y'  
		--    JOIN programs p ON s.ProgramId = p.ProgramId  
		--    JOIN ServiceAreas sa ON sa.ServiceAreaId = p.ServiceAreaId  
		--    LEFT JOIN DocumentSignatures ds ON ds.DocumentId = d.DocumentId  
		--    AND ds.StaffId = d.AuthorId AND ISNULL(ds.RecordDeleted,'N') <>'Y'  
		WHERE d.ClientId = @ClientId
			AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
			AND d.STATUS = 22 -- Signed document  
			--    AND sa.ServiceAreaId = 2                 -- EAP Service area  
			AND d.DocumentCodeId IN (1486) -- Code for Diagnostic Assessment & progress note  
			AND d.EffectiveDate <= @StartDate
			AND DATEADD(dd, 31, EffectiveDate) >= @StartDate
		)
	--    And (EffectiveDate =@StartDate OR  EffectiveDate between @Startdate and @EndDate) -- The service not started yet  
	--    AND DIFFERENCE(d.EffectiveDate , d.DueDate) <= 30  
	--And except for when services are provided by an EAP Sub Provider ?  
BEGIN
	IF @IsRecursive = 'Y'
		RETURN 1 -- Indicate there is an error found  
	ELSE
		INSERT INTO ServiceErrors (
			ServiceId
			,ErrorType
			,ErrorMessage
			)
		VALUES (
			@ServiceId
			,1000030
			,' Signed Assessment missing for this date of service'
			)
END

DECLARE @AssociatedNoteId INT    
            SELECT  @AssociatedNoteId = d.DocumentCodeID  
            FROM    Documents d  
                    JOIN DocumentCodes dc ON d.documentcodeid = dc.documentcodeid  
                                             AND ISNULL(dc.recorddeleted, 'N') <> 'Y' 
                    JOIN Services s ON s.serviceid = d.serviceid  
                                       AND ISNULL(s.recorddeleted, 'N') <> 'Y'  
                    JOIN ProcedureCodes p ON s.procedurecodeid = p.procedurecodeid  
                                             AND ISNULL(p.recorddeleted, 'N') <> 'Y'  
            WHERE   d.serviceid = @ServiceId  
                    AND p.RequiresSignedNote = 'Y'  
                    AND ISNULL(d.recorddeleted, 'N') <> 'Y'  
                   
 IF @AssociatedNoteId > 0  
 AND  @ServiceCompletionStatus = 'Completed'   ----02/28/2018  Bibhu
                AND @Billable = 'N'      -- condition for NON Billable    
   AND NOT EXISTS (  
   SELECT 1  
   FROM serviceErrors  
   WHERE ServiceId = @ServiceId  
    AND ErrorMessage = 'Must have a signed note before completing a service.'  
   ) 
                BEGIN    
                    IF NOT EXISTS ( SELECT  *  
                                    FROM    documents  
                                    WHERE   serviceid = @ServiceId  
                                            AND status = 22  
                                            AND CurrentVersionStatus = 22  
                                            AND ISNULL(recorddeleted, 'N') <> 'Y' )   
                        BEGIN    
                            INSERT  INTO serviceErrors  
                                    ( ServiceId ,  
                                      ErrorType ,  
                                      ErrorMessage
                                    )  
                            VALUES  ( @ServiceId ,  
                                      4402 ,  
                                      'Must have a signed note before completing a service.'
                                    )    
                        END    
                END 




--if @PreviousStatus <> 75  
--BEGIN  
-- INSERT INTO dbo.ServiceErrors  
--         (  
--          ServiceId,  
--          ErrorType,  
--          ErrorMessage  
--         )  
-- SELECT sv.ServiceId, gcServiceError.GlobalCodeId, gcServiceError.CodeName  
-- FROM Services AS sv  
-- JOIN Programs AS pg ON pg.ProgramId = sv.ProgramId  
-- CROSS JOIN (  
--  SELECT TOP 1 GlobalCodeId, CodeName  
--  FROM dbo.GlobalCodes  
--  WHERE CodeName = 'Service has invalid primary diagnosis for Service Area'  
--  AND category = 'SERVICEERRORTYPE'  
--  AND Active = 'Y'  
--  AND ISNULL(RecordDeleted, 'N') = 'N'  
-- ) AS gcServiceError  
-- WHERE sv.ServiceId = @ServiceId  
--  AND (  
--   -- Mental health has primary diagnosis of aod  
--   EXISTS (  
--    SELECT *  
--    FROM dbo.ssf_RecodeValuesAsOfDate('XMHSERVICEAREA', sv.DateOfService) AS rcSvArea  
--    WHERE rcSvArea.IntegerCodeId = pg.ServiceAreaId  
--    --AND EXISTS (  
--    -- SELECT *  
--    -- FROM dbo.ssf_RecodeValuesAsOfDate('XAODDSMDIAGNOSES', sv.DateOfService) AS rcDx  
--    -- WHERE rcDx.CharacterCodeId = sv.DiagnosisCode1  
--    --)  
--   )  
--   -- AOD service area has a primary diagnosis that is NOT AOD  
--   OR EXISTS (  
--    SELECT *  
--    FROM dbo.ssf_RecodeValuesAsOfDate('XAODSERVICEAREA', sv.DateOfService) AS rcSvArea  
--    WHERE rcSvArea.IntegerCodeId = pg.ServiceAreaId  
--    --AND NOT EXISTS (  
--    -- SELECT *  
--    -- FROM dbo.ssf_RecodeValuesAsOfDate('XAODDSMDIAGNOSES', sv.DateOfService) AS rcDx  
--    -- WHERE rcDx.CharacterCodeId = sv.DiagnosisCode1  
--    --)  
--   )  
--  )  
--END  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

