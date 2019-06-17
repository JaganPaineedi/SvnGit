IF NOT EXISTS(SELECT * FROM EventTypes WHERE AssociatedDocumentCodeId=1055 AND EventType=5771 )
	BEGIN
		INSERT INTO [EventTypes]
				   ([EventName]
				   ,[EventType]
				   ,[DisplayNextEventGroup]
				   ,[AssociatedDocumentCodeId]
				   ,[SummaryReportRDL]
				   ,[SummaryStoredProcedure]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[ModifiedBy]
				   ,[ModifiedDate]
				   ,[RecordDeleted]
				   ,[DeletedDate]
				   ,[DeletedBy])
			 VALUES
				   ('Event',
					 5771,
					 NULL,
					 1055,
					 NULL,
					 NULL,
					 'admin',
					 getdate(),
					 'admin',
					 getdate(),
					 NULL,
					 NULL,
					 NULL
					)
	END


