/****** Object:  StoredProcedure [dbo].[csp_TimelinessServiceValidation]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_TimelinessServiceValidation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_TimelinessServiceValidation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_TimelinessServiceValidation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE                        Procedure [dbo].[csp_TimelinessServiceValidation]
	/* Param List */
	@ServiceId		 int,
	@ClientId	 	 int,
	@StartDate	 datetime,
	@ClinicianId	 int,
	@ProcedureCodeId int
AS


/********************************************************************************/
/*				Timeliness Validations				*/
/* Purpose:	This section is to prevent certain transactions from being	*/
/*		saved if information required for state reporting hasn''t been	*/
/*		entered into the appropriate sections.				*/
/* Author:	Ryan Noble							*/
/* Created:	04/10/2006							*/
/* Task:	See Summit Pointe Support Ace Tasks #593 and #623 for details	*/
/* Mods:									*/
/********************************************************************************/




-- Do Not run for Meds Only Customers or exceptions to the rule
IF @ClientId not in (26776, 35643, 10411, 34967, 35520, 31348, 30089, 35267, 7927, 25660, 35224, 18702, 33482, 35897,28385, 35368, 35366, 29063, 34855, 34016, 12817, 33768, 4719, 12720)
	ANd Not Exists (Select ProgramId From Clients c
	Join ClientPrograms cp on cp.ClientId = c.ClientId and cp.PrimaryAssignment = ''Y''
	Where cp.ProgramId in (20, 21, 22)
	and c.ClientId = @ClientId
	and isnull(c.RecordDeleted, ''N'') = ''N''
	and isnull(cp.RecordDeleted, ''N'') = ''N'')
	
BEGIN
		
	
	-- Find the createddate of the service
	
	
		Declare @CreatedDate datetime,
			@ErrorMessage varchar(200),
			@EpisodeNumber 	int,
			@Status int
			
			
		Select @CreatedDate = s.CreatedDate
		FROM Services s 
		WHERE s.ServiceId = @ServiceId
	
		
		IF @CreatedDate is NULL
		BEGIN
		SET @CreatedDate = convert(datetime, getdate(), 101)
		END
		
	
		IF @@error <> 0 Goto error
	
	
	-- Find Episode
		SELECT @EpisodeNumber = EpisodeNumber 
		FROM ClientEpisodes ce
	        WHERE ce.ClientId = @ClientId	
		AND isnull(ce.RecordDeleted, ''N'') = ''N''
		Group By EpisodeNumber
		Having ce.EpisodeNumber = MAX(ce.EpisodeNumber) 
	
	
		IF @@error <> 0 Goto error
	
	
	
	
	-- Find the most recent ''Initial Assessment''
	declare @IntakeDate	DateTime,
		@NewCustomer	Char(1)
	
	
		SELECT @IntakeDate = isnull(a.DateOfService, ''01/01/1900'') 
		FROM Services a 
		WHERE a.ClientId = @ClientId
		AND a.DateOfService < @StartDate
		AND a.ProcedureCodeId in (274)
		AND a.Status in (70, 71, 75) --(Show, Complete)
		AND a.Billable = ''Y''
		AND isnull(a.RecordDeleted, ''N'') = ''N''
		AND NOT EXISTS (SELECT * FROM Services b
				WHERE b.ProcedureCodeId in (274)
				AND b.Status in (70, 71, 75)
				AND b.Billable = ''Y''
				AND b.ClientId = a.ClientId
				AND b.DateOfService < @StartDate
				AND b.DateOfService > a.DateOfService
				AND isnull(b.RecordDeleted, ''N'') = ''N''
				)
	
	IF @@error <> 0 GOTO error		
	
	--
	-- Determine if Customer is a new customer
	--
	IF isnull(@IntakeDate, ''01/01/1900'') <> ''01/01/1900'' 
				AND isnull(@IntakeDate, ''01/01/1900'') >= ''3/19/2007''
				AND NOT EXISTS
				(SELECT ServiceId FROM Services s
				 JOIN ProcedureCodes p on p.ProcedureCodeId = s.ProcedureCodeId 
						AND isnull(p.Category1, 0) <> 10512 -- Crisis Services
				 WHERE s.ClientId = @ClientId
				 AND DATEDIFF(Day, s.DateOfService, @IntakeDate) < 91
				 AND s.DateOfService < @IntakeDate
				 AND s.Status in (71, 75)
				 AND s.Billable = ''Y''
				 AND s.ProcedureCodeId NOT IN (274, 469) --Screen For Services
				 AND isnull(s.RecordDeleted, ''N'') = ''N''
				 AND isnull(p.RecordDeleted, ''N'') = ''N''
		   
				)
	
		BEGIN
		SET @NewCustomer = ''Y'' 
		END
	
	
	IF @@error <> 0 GOTO error
	
	--
	-- ONGOING SERVICE VALIDATIONS
	--
	
	IF @NewCustomer = ''Y'' AND @ProcedureCodeId Not In (274, 392, 393, 438, 469)
				AND NOT EXISTS 
				(SELECT s.ServiceId FROM Services s
				 JOIN ProcedureCodes p on p.ProcedureCodeId = s.ProcedureCodeId 
						AND p.Category1 <> 10512 -- Crisis Services
				 WHERE s.ClientId = @ClientId
				 AND s.DateOfService between @IntakeDate and @CreatedDate
				 AND s.ServiceId <> @ServiceId
				 AND s.ProgramId NOT IN (19)
				 AND s.Status in (70, 71, 75)
				 AND s.Billable = ''Y''
				 AND s.ProcedureCodeId NOT IN (274, 392, 393, 438, 469) --(Initial Assessment, Obra Del, Obra Write, Youth Prev, Screen For Services)   
				 AND isnull(s.RecordDeleted, ''N'') = ''N''
				 AND isnull(p.RecordDeleted, ''N'') = ''N''
				)
	
			BEGIN
			IF (DATEDIFF(DAY, isnull(@IntakeDate, ''01/01/1900''), @StartDate)) > 14
			AND NOT EXISTS  (SELECT ce.ClientId, EpisodeNumber FROM ClientEpisodes ce
			       WHERE ce.ClientId = @ClientId	
				AND ce.EpisodeNumber = @EpisodeNumber
				AND isnull(TXStartFirstOffered, ''01/01/1900'') > DATEADD(DAY, -1, @IntakeDate)
				AND (DATEDIFF(DAY, @IntakeDate, isnull(TXStartFirstOffered, ''01/01/1900'')) < 15
				    OR
				     TXStartDeclinedReason in (10930) --Med Monitoring Only
				    )				
				AND TXStartDeclinedReason is NOT NULL	
				AND isnull(ce.RecordDeleted, ''N'') = ''N''
				  )
	
				Begin
				insert into serviceErrors(ServiceId,ErrorType,ErrorMessage,ErrorSeverity)  
				Values (@ServiceId, 11018, ''** Please offer a date before '' +  Convert(varchar(200), DATEADD(day, 14, @IntakeDate), 101) + '' and enter in ''''Tx Start Date First Offered'''' and ''''Reason Declined'''' on ''''Client Information'''' screen. '', ''E'')
				
				--SET @ErrorMessage =''Please offer a date before '' +  Convert(varchar(200), DATEADD(day, 14, @IntakeDate), 101) + '' and enter in ''''Tx Start Date First Offered'''' and ''''Reason Declined'''' on ''''Client Information'''' screen. ''
				--Raiserror 50000 @errorMessage
				End
	
	
			IF (DATEDIFF(DAY, isnull(@IntakeDate, ''01/01/1900''), @StartDate)) <= 14
			AND NOT EXISTS  (SELECT ce.ClientId, EpisodeNumber FROM ClientEpisodes ce
			       WHERE ce.ClientId = @ClientId	
				AND ce.EpisodeNumber = @EpisodeNumber
				AND isnull(TXStartFirstOffered, ''01/01/1900'') > DATEADD(DAY, -1, @IntakeDate)
				AND (DATEDIFF(DAY, @IntakeDate, isnull(TXStartFirstOffered, ''01/01/1900'')) < 15
				    OR
				     TXStartDeclinedReason in (10930) --Med Monitoring Only
				    )				
				AND TXStartDeclinedReason is NOT NULL	
				AND isnull(ce.RecordDeleted, ''N'') = ''N''
				  )
	
			BEGIN
			UPDATE ce
			SET TXStartFirstOffered = @StartDate,
			    TXStartDeclinedReason = 10927 --Customer Selected First Date Offered
			FROM ClientEpisodes ce
			WHERE ce.ClientId = @ClientId	
			AND ce.EpisodeNumber = @EpisodeNumber
			AND isnull(ce.RecordDeleted, ''N'') = ''N''
			END
			
			END
	
	
	IF @@error <> 0 GOTO error
	
	
	--
	-- INITIAL ASSESSMENT VALIDATIONS
	--
	
	
	
	-- If there weren''t services during the 90 day period before the intake, then this is a new customer.
	
	
	IF @ProcedureCodeId = 274  --AND isnull(@IntakeDate, ''01/01/1900'') >= ''10/01/2006''
				AND NOT EXISTS 
				(SELECT s.ServiceId FROM Services s
				 WHERE s.ClientId = @ClientId
				 AND DATEDIFF(Day, s.DateOfService, @CreatedDate) < 91
				 AND s.DateOfService < @CreatedDate
				 AND s.Status in (71, 75)
				 AND s.Billable = ''Y'' 
				 AND isnull(s.RecordDeleted, ''N'') = ''N''
				)
	
	BEGIN
		IF NOT EXISTS (SELECT ce.ClientId, EpisodeNumber FROM ClientEpisodes ce
			       WHERE ce.ClientId = @ClientId	
				AND DATEDIFF(DAY, @CreatedDate, isnull(ce.AssessmentFirstOffered, ''01/01/1900'')) < 15
				AND isnull(AssessmentFirstOffered, ''01/01/1900'') >= dateadd(day, -1, @CreatedDate)
				AND ce.AssessmentDeclinedReason is NOT null
				AND isnull(ce.RecordDeleted, ''N'') = ''N''
				Group By ce.ClientId, EpisodeNumber
				Having ce.EpisodeNumber = MAX(ce.EpisodeNumber)
				)
		Begin
		insert into serviceErrors(ServiceId,ErrorType,ErrorMessage,ErrorSeverity)  
		Values (@ServiceId, 11019, ''** Please offer a date before '' +  Convert(varchar(200), DATEADD(day, 14, @CreatedDate), 101) + '' and enter in ''''Assessment First Offered'''' and ''''Reason Declined'''' on ''''Client Information'''' screen. '', ''E'')
				
	
	--	SET @ErrorMessage =''Please offer a date before '' +  Convert(varchar(200), DATEADD(day, 14, @CreatedDate), 101) + '' and enter in ''''Assessment First Offered'''' and ''''Reason Declined'''' on ''''Client Information'''' screen. ''
	--	Raiserror 50000 @errorMessage
		End
		IF @@error <> 0 GOTO error
	
	
	
	END

END
IF @@error <> 0 GOTO error	


Return

error:
Raiserror 50000 ''Error occurred on csp_TimelinessServiceValidation.''

Return
' 
END
GO
