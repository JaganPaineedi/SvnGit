/****** Object:  StoredProcedure [dbo].[ssp_CompleteFlags]    Script Date: 07/10/2018 18:45:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CompleteFlags]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CompleteFlags]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CompleteFlags]    Script Date: 07/10/2018 18:45:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_CompleteFlags]
    @ClientNoteId INT,
    @UserCode VARCHAR(100),
    @ClientId INT,
    @DocumentId INT,
    @DocumentCodeId INT,
    @TrackingProtocolId INT,
    @Initials VARCHAR(100)
AS 
/********************************************************************************                                                    
-- Stored Procedure: ssp_CompleteFlags
-- Copyright: Streamline Healthcate Solutions
-- Purpose: Procedure to update ClientNotes.EndDate column to complete the flags
-- Author:  Vijay
-- Date:    29 Jun 2018
-- *****History****  
-- Date				Author			Purpose
---------------------------------------------------------------------------------
-- 06 Jun 2018		Vijay			What:Created ssp to complete the flags
									Why:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/  

BEGIN  
	BEGIN TRY  
	DECLARE @TrackingProtocolFlagId INT
	DECLARE @StartDate DateTime
	DECLARE @DueDate DateTime
	DECLARE @CanBeCompletedNoSoonerThan INT
	DECLARE @Output INT
	DECLARE @StaffId INT
	SET @CanBeCompletedNoSoonerThan = 0
	SET @Output = 0
	
	SELECT @StaffId = StaffId FROM STAFF WHERE USERCODE = @UserCode AND ISNULL(RecordDeleted, 'N') = 'N'
	
	CREATE TABLE #Results( ClientNoteId INT ,TrackingProtocolFlagId INT, CanBeCompletedNoSoonerThan INT,DueDate DATETIME)  
	
--1 Scenario: Client Tracking - Multi Action PopUp
--2 Scenario: Client Tracking - While signing the document based on DocumentCodeId we need to complete multiple flags.
	IF ((@TrackingProtocolId > 0) OR (@ClientNoteId = -1 AND @DocumentId > 0 AND @DocumentCodeId > 0))
	BEGIN
		IF(@TrackingProtocolId > 0)
		BEGIN
		
			 INSERT INTO  #Results(ClientNoteId, TrackingProtocolFlagId,CanBeCompletedNoSoonerThan,DueDate) 
			   SELECT CN.ClientNoteId,CN.TrackingProtocolFlagId ,TPF.CanBeCompletedNoSoonerThan,CN.DueDate
			   From ClientNotes CN 
			   JOIN TrackingProtocolFlags TPF ON TPF.TrackingProtocolFlagId=CN.TrackingProtocolFlagId
			   WHERE CN.TrackingProtocolId=@TrackingProtocolId
			   AND CN.EndDate is null
			   AND CN.Active = 'Y' 
			   AND ISNULL(CN.RecordDeleted, 'N') = 'N'  
			   --AND ISNULL(TPF.RecordDeleted, 'N') = 'N'
	   END
	   ELSE IF(@ClientNoteId = -1 AND @DocumentId > 0 AND @DocumentCodeId > 0) --2 scenario
	   BEGIN
	   
			INSERT INTO  #Results(ClientNoteId, TrackingProtocolFlagId,CanBeCompletedNoSoonerThan,DueDate)  
			   SELECT CN.ClientNoteId,CN.TrackingProtocolFlagId ,TPF.CanBeCompletedNoSoonerThan,CN.DueDate
			   From ClientNotes CN 
			   JOIN TrackingProtocolFlags TPF ON TPF.TrackingProtocolFlagId=CN.TrackingProtocolFlagId 
			   JOIN Documents D ON CN.DocumentCodeId = D.DocumentCodeId 
			   WHERE CN.DocumentCodeId=@DocumentCodeId
			   AND CAST(D.EffectiveDate AS DATE)  >= CN.StartDate
			   AND CN.EndDate is null
			   AND CN.Active = 'Y' 
			   AND ISNULL(CN.RecordDeleted, 'N') = 'N'
			   AND ISNULL(D.RecordDeleted, 'N') = 'N'
			   --AND ISNULL(TPF.RecordDeleted, 'N') = 'N'	
			   --If multiple flags are present for a document then based on doucment effective date we need to complete the flags		   
	   END	
	
	DECLARE CompleteTrackingProtocolFlags_cursor CURSOR    
    FOR   
    SELECT ClientNoteId, TrackingProtocolFlagId,CanBeCompletedNoSoonerThan,DueDate  
    FROM #Results    
	   OPEN CompleteTrackingProtocolFlags_cursor
	   FETCH NEXT FROM CompleteTrackingProtocolFlags_cursor INTO @ClientNoteId,@TrackingProtocolFlagId,@CanBeCompletedNoSoonerThan,@DueDate
	   WHILE @@FETCH_STATUS = 0
	   BEGIN  
			--***************************** Completing the flag start ******************
			IF (@CanBeCompletedNoSoonerThan > 0)  
			BEGIN					 
				IF DATEADD(d, -@CanBeCompletedNoSoonerThan, @DueDate) <= GETDATE() 
				BEGIN
					UPDATE ClientNotes SET EndDate=GETDATE(), ModifiedBy=@UserCode, CompletedBy=@StaffId, ModifiedDate=GETDATE() 
					WHERE ClientNoteId = @ClientNoteId AND ISNULL(RecordDeleted, 'N') = 'N' 					
					Exec ssp_ProcessRecurringClientNotes @ClientNoteId --Calling recrring flag ssp
				END
				ELSE
				BEGIN
					SET @Output = @CanBeCompletedNoSoonerThan
				END
			END
			ELSE
			BEGIN
				UPDATE ClientNotes SET EndDate=GETDATE(), ModifiedBy=@UserCode, CompletedBy=@StaffId, ModifiedDate=GETDATE() 
				WHERE ClientNoteId = @ClientNoteId AND ISNULL(RecordDeleted, 'N') = 'N'				
				Exec ssp_ProcessRecurringClientNotes @ClientNoteId --Calling recrring flag ssp
			END			
			--***************************** Completing the flag end ******************
			
			FETCH NEXT FROM CompleteTrackingProtocolFlags_cursor INTO @ClientNoteId,@TrackingProtocolFlagId,@CanBeCompletedNoSoonerThan,@DueDate
	    END
	   
	   CLOSE CompleteTrackingProtocolFlags_cursor
	   DEALLOCATE CompleteTrackingProtocolFlags_cursor 
	END
	ELSE
	BEGIN
		--2 Scenario: Client Tracking - While signing the document
		--IF (@ClientNoteId = -1 AND @DocumentId > 0 AND @DocumentCodeId > 0) 
		--BEGIN
		--SELECT @ClientNoteId = ClientNoteId FROM ClientNotes WHERE ClientId = @ClientId 
		--	AND DocumentId = @DocumentId 
		--	AND DocumentCodeId = @DocumentCodeId
		--END
			
		
		--3 Scenario: Client Tracking - "Complete Flag" PopUp(Checkbox selection)
		SELECT @TrackingProtocolFlagId = CN.TrackingProtocolFlagId,
			   @StartDate = CN.StartDate,
			   @DueDate = CN.DueDate,
			   @CanBeCompletedNoSoonerThan = TPF.CanBeCompletedNoSoonerThan,
			   @TrackingProtocolId = CN.TrackingProtocolId
		   From ClientNotes CN 
		   JOIN TrackingProtocolFlags TPF ON TPF.TrackingProtocolFlagId=CN.TrackingProtocolFlagId
		   WHERE CN.ClientNoteId=@ClientNoteId 
			AND ISNULL(CN.RecordDeleted, 'N') = 'N'
			--AND ISNULL(TPF.RecordDeleted, 'N') = 'N'
				
		--***************************** Completing the flag start ****************** 
		IF (@CanBeCompletedNoSoonerThan > 0)  
		BEGIN					 
			IF DATEADD(d, -@CanBeCompletedNoSoonerThan, @DueDate) <= GETDATE() 
			BEGIN
				UPDATE ClientNotes SET EndDate=GETDATE(), ModifiedBy=@UserCode, CompletedBy=@StaffId, ModifiedDate=GETDATE() 
				WHERE ClientNoteId = @ClientNoteId AND ISNULL(RecordDeleted, 'N') = 'N'
				Exec ssp_ProcessRecurringClientNotes @ClientNoteId --Calling recrring flag ssp 
			END
			ELSE
			BEGIN
				SET @Output = @CanBeCompletedNoSoonerThan
			END
		END
		ELSE
		BEGIN
			UPDATE ClientNotes SET EndDate=GETDATE(), ModifiedBy=@UserCode, CompletedBy=@StaffId, ModifiedDate=GETDATE() 
			WHERE ClientNoteId = @ClientNoteId AND ISNULL(RecordDeleted, 'N') = 'N'
			Exec ssp_ProcessRecurringClientNotes @ClientNoteId --Calling recrring flag ssp
		END
		--***************************** Completing the flag end ******************
	END 		
		
		--Add entry in History table
		IF @TrackingProtocolId = '' OR @TrackingProtocolId = -1
		BEGIN
			SET @TrackingProtocolId = NULL
		END
		
		IF @TrackingProtocolFlagId = '' OR @TrackingProtocolFlagId = -1
		BEGIN
			SET @TrackingProtocolFlagId = NULL
		END	
		
		IF (@ClientNoteId > 0)
		BEGIN  	
		INSERT INTO ClientNoteTrackingProtocolHistory(CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			ClientNoteId,
			TrackingProtocolId,
			TrackingProtocolFlagId,
			StartDate,
			EndDate)
		VALUES(@UserCode,
			GETDATE(),
			@UserCode,
			GETDATE(),
			@ClientNoteId,
			@TrackingProtocolId,
			@TrackingProtocolFlagId,
			@StartDate,
			GETDATE()
			)
		END
			
			SELECT @Output
		
	END TRY 
    BEGIN CATCH                                
		DECLARE @Error VARCHAR(8000)                                                                          
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                       
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_CompleteFlags')                                                                                                           
					+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                            
					+ '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                        
		RAISERROR                                                                                                           
		(                                                                             
			@Error, -- Message text.         
			16, -- Severity.         
			1 -- State.                                                           
		);                                                                                                        
	END CATCH
END
GO


