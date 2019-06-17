/****** Object:  StoredProcedure [dbo].[smsp_GetTiming]    Script Date: 09/27/2017 15:53:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetTiming]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetTiming]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetTiming]    Script Date: 09/27/2017 15:53:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetTiming]  @ClientId INT = null
, @Text VARCHAR(100) = null
, @Type VARCHAR(10) = null
, @FromDate DATETIME = null
, @ToDate DATETIME = null
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Sept 27, 2017      
-- Description: Retrieves Patient details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)      
/*      
 Author			Modified Date			Reason     
*/
-- =============================================      
BEGIN
	BEGIN TRY
	
	SET NOCOUNT ON
	
		IF @ClientId IS NOT NULL
		BEGIN
			IF @Type = 'Inpatient'
				BEGIN	
					IF @Text = 'PlanOfTreatmentActivityDetailScheduledTiming'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS [Event]
									,'' AS RepeatBoundsDuration	-- { Duration },-- bounds[x]: Length/Range of lengths, or (Start and/or end) limits. One of these 3:
									,'' AS RepeatBoundsRange	-- { Range },
									,'' AS RepeatBoundsPeriod	--{ Period },
									,0 AS RepeatCount			-- <integer>, -- Number of times to repeat
									,0 AS RepeatCountMax 		-- Maximum number of times to repeat
									,'' AS RepeatDuration 		-- How long when it happens
									,'' AS RepeatDurationMax    -- How long when it happens (Max)
									,'' AS RepeatDurationUnit   -- s | min | h | d | wk | mo | a - unit of time (UCUM)
									,0 AS RepeatFrequency 	 -- Event occurs frequency times per period
									,0 AS RepeatFrequencyMax   -- Event occurs up to frequencyMax times per period
									,'' AS RepeatPeriod  	 	 -- Event occurs frequency times per period
									,'' AS RepeatPeriodMax  	 -- Upper limit of period (3-4 hours)
									,'' AS RepeatPeriodUnit 	 -- s | min | h | d | wk | mo | a - unit of time (UCUM)
									,'' AS RepeatDayOfWeek  	 -- mon | tue | wed | thu | fri | sat | sun
									,'' AS RepeatTimeOfDay 	 -- Time of day for action
									,'' AS RepeatWhen  		 -- Regular life events the event is tied to
									,0 AS RepeatOffset  	     -- Minutes from event (before or after)
									--,'' AS code 	CodeableConcept-- BID | TID | QID | AM | PM | QD | QOD | Q4H | Q6H +	  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
					END
			ELSE IF @Type = 'Outpatient'
				BEGIN
					IF @Text = 'PlanOfTreatmentActivityDetailScheduledTiming'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS [Event]
									,'' AS RepeatBoundsDuration	-- { Duration },-- bounds[x]: Length/Range of lengths, or (Start and/or end) limits. One of these 3:
									,'' AS RepeatBoundsRange	-- { Range },
									,'' AS RepeatBoundsPeriod	--{ Period },
									,0 AS RepeatCount			-- <integer>, -- Number of times to repeat
									,0 AS RepeatCountMax 		-- Maximum number of times to repeat
									,'' AS RepeatDuration 		-- How long when it happens
									,'' AS RepeatDurationMax    -- How long when it happens (Max)
									,'' AS RepeatDurationUnit   -- s | min | h | d | wk | mo | a - unit of time (UCUM)
									,0 AS RepeatFrequency 	 -- Event occurs frequency times per period
									,0 AS RepeatFrequencyMax   -- Event occurs up to frequencyMax times per period
									,'' AS RepeatPeriod  	 	 -- Event occurs frequency times per period
									,'' AS RepeatPeriodMax  	 -- Upper limit of period (3-4 hours)
									,'' AS RepeatPeriodUnit 	 -- s | min | h | d | wk | mo | a - unit of time (UCUM)
									,'' AS RepeatDayOfWeek  	 -- mon | tue | wed | thu | fri | sat | sun
									,'' AS RepeatTimeOfDay 	 -- Time of day for action
									,'' AS RepeatWhen  		 -- Regular life events the event is tied to
									,0 AS RepeatOffset  	     -- Minutes from event (before or after)
									--,'' AS code 	CodeableConcept-- BID | TID | QID | AM | PM | QD | QOD | Q4H | Q6H +	  
							FROM Clients c
							LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
							--LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							--LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
							WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
							AND c.Active = 'Y' 
							AND ISNULL(c.RecordDeleted,'N')='N'	
							FOR XML path
							,ROOT
							))
						END
					END
			END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetTiming') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


