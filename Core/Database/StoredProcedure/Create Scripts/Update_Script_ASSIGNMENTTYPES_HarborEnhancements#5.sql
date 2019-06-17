Update Globalcodes set CodeName='Documents - All' Where GlobalCodeId = 9435



SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND GlobalCodeId = 9446
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9446
		,'ASSIGNMENTTYPES'
		,'Documents – In Progress'
		,'DOCUMENTSINPROGRESS'
		,'Y'
		,'Y'
		,5
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND GlobalCodeId = 9447
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9447
		,'ASSIGNMENTTYPES'
		,'Documents – To Do'
		,'DOCUMENTSTODO'
		,'Y'
		,'Y'
		,5
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND GlobalCodeId = 9448
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9448
		,'ASSIGNMENTTYPES'
		,'Documents – To Sign'
		,'DOCUMENTSTOSIGN'
		,'Y'
		,'Y'
		,5
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND GlobalCodeId = 9449
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9449
		,'ASSIGNMENTTYPES'
		,'Documents – To Co-Sign'
		,'DOCUMENTSTOCOSIGN'
		,'Y'
		,'Y'
		,5
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND GlobalCodeId = 9496
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9496
		,'ASSIGNMENTTYPES'
		,'Documents - To Acknowledge'
		,'DOCUMENTSTOACKNOWLEDGE'
		,'Y'
		,'Y'
		,5
		)
END
SET IDENTITY_INSERT GlobalCodes OFF



SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND GlobalCodeId = 9497
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9497
		,'ASSIGNMENTTYPES'
		,'Documents - To Be Reviewed'
		,'DOCUMENTSTOBEREVIEWED'
		,'Y'
		,'Y'
		,5
		)
END
SET IDENTITY_INSERT GlobalCodes OFF