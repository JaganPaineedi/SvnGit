
/****** Object:  Trigger [TriggerAfterInsertUpdate_Documents]    Script Date: 04/09/2018 11:44:28 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TriggerAfterInsertUpdate_Documents]'))
DROP TRIGGER [dbo].[TriggerAfterInsertUpdate_Documents]
GO


/****** Object:  Trigger [dbo].[TriggerAfterInsertUpdate_Documents]    Script Date: 04/09/2018 11:44:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE trigger [dbo].[TriggerAfterInsertUpdate_Documents] on [dbo].[Documents] AFTER INSERT ,UPDATE

/*********************************************************************  
-- Trigger: TriggerAfterInsertUpdate_Documents  
--  
-- Copyright: Streamline Healthcare Solutions 
--  Date         Author       Purpose  
--  28.03.2018   Neha         Created to save document effective date with time in documents table.
                              Task #107 MHP Enhancements 
--  25.10.2018   Gautam       What: Added code to not update EffectiveDate time on same day edit, 
							  Task#732.2,MHP-Support Go Live    
--  15.11.2018   Neha         What: Added code to not update EffectiveDate time for the documents which are created with Effective date in past. 
							  Task#732.2,MHP-Support Go Live                                                              
**********************************************************************/ 
AS

IF EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SaveAndDisplayDocumentEffectiveDateWithTime'
			AND Value = 'Yes'
		)
BEGIN
	IF 
		UPDATE (EffectiveDate)

	BEGIN
		-- insert case
		IF EXISTS (
				SELECT 1
				FROM Documents D
				JOIN INSERTED i ON D.DocumentId = i.DocumentId
				WHERE i.EffectiveDate IS NOT NULL
					AND (CAST(i.EffectiveDate AS DATE) = CAST(D.EffectiveDate AS DATE))
					AND CAST(i.EffectiveDate AS TIME(3)) = '00:00:00.000'
				)
		BEGIN
			UPDATE D
			SET D.EffectiveDate = CAST(CAST(i.EffectiveDate AS DATE) AS DATETIME) + cast(CAST(GETDATE() AS TIME(3)) AS DATETIME)
			FROM Documents D
			JOIN INSERTED i ON D.DocumentId = i.DocumentId
			WHERE i.EffectiveDate IS NOT NULL
		END
       
       -- insert case with past date
       IF EXISTS (
				SELECT 1
				FROM Documents D
				JOIN INSERTED i ON D.DocumentId = i.DocumentId
				WHERE i.EffectiveDate IS NOT NULL
					AND (CAST(i.EffectiveDate AS DATE) = CAST(D.EffectiveDate AS DATE))
					AND (CAST(i.EffectiveDate AS DATE) < cast(Getdate() as date))
					AND CAST(i.EffectiveDate AS TIME(3)) = '00:00:00.000'
				)
		BEGIN
			UPDATE D
			SET D.EffectiveDate = CAST(CAST(i.EffectiveDate AS DATE) AS DATETIME) 
			FROM Documents D
			JOIN INSERTED i ON D.DocumentId = i.DocumentId
			WHERE i.EffectiveDate IS NOT NULL
		END
		
		-- update case with same date        
		IF EXISTS (
				SELECT 1
				FROM Documents D
				JOIN INSERTED i ON D.DocumentId = i.DocumentId
				JOIN Deleted O ON O.DocumentId = i.DocumentId
				WHERE i.EffectiveDate IS NOT NULL
					AND (CAST(i.EffectiveDate AS DATE) = CAST(O.EffectiveDate AS DATE))
				)
		BEGIN
			UPDATE D
			SET D.EffectiveDate = CAST(CAST(i.EffectiveDate AS DATE) AS DATETIME) + cast(CAST(O.EffectiveDate AS TIME(3)) AS DATETIME)
			FROM Documents D
			JOIN INSERTED i ON D.DocumentId = i.DocumentId
			JOIN Deleted O ON O.DocumentId = i.DocumentId
			WHERE i.EffectiveDate IS NOT NULL
		END

		-- update case with different date        
		IF EXISTS (
				SELECT 1
				FROM Documents D
				JOIN INSERTED i ON D.DocumentId = i.DocumentId
				JOIN Deleted O ON O.DocumentId = i.DocumentId
				WHERE i.EffectiveDate IS NOT NULL
					AND (CAST(i.EffectiveDate AS DATE) <> CAST(O.EffectiveDate AS DATE))
				)
		BEGIN
			UPDATE D
			SET D.EffectiveDate = CAST(CAST(i.EffectiveDate AS DATE) AS DATETIME) + cast(CAST(GETDATE() AS TIME(3)) AS DATETIME)
			FROM Documents D
			JOIN INSERTED i ON D.DocumentId = i.DocumentId
			JOIN Deleted O ON O.DocumentId = i.DocumentId
			WHERE i.EffectiveDate IS NOT NULL
		END
		
		--update case with past date
		IF EXISTS (
				SELECT 1
				FROM Documents D
				JOIN INSERTED i ON D.DocumentId = i.DocumentId
				JOIN Deleted O ON O.DocumentId = i.DocumentId
				WHERE i.EffectiveDate IS NOT NULL
					AND (CAST(i.EffectiveDate AS DATE) <> CAST(O.EffectiveDate AS DATE))
					AND (CAST(i.EffectiveDate AS DATE) < CAST(GETDATE() AS DATE))
				)
		BEGIN
			UPDATE D
			SET D.EffectiveDate = CAST(CAST(i.EffectiveDate AS DATE) AS DATETIME) 
			FROM Documents D
			JOIN INSERTED i ON D.DocumentId = i.DocumentId
			JOIN Deleted O ON O.DocumentId = i.DocumentId
			WHERE i.EffectiveDate IS NOT NULL
		END
	END
END
go