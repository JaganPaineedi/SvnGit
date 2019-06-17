
------------------------------------------------------------------------------------
/* Category :  */
/*Insert Into GlobalSubCodes */
/* Values:  
			Last 90 Days
			Last 180 Days
			Last 1 Year
			All Dates

			for GlobalCodeId = 5398 */
 
 
/* For Task #289 Bradford - Customizations  */
-------------------------------------------------------------

DECLARE @GlobalCodeId int
DECLARE @GlobalSubCodeId int

SET @GlobalCodeId = 5398

	--	GlobalSubCodeId: 109 (Last 90 Days)
	SET @GlobalSubCodeId = 109
	
	IF EXISTS (SELECT 1 FROM [GlobalCodes] WHERE GlobalCodeId = @GlobalCodeId)
	BEGIN

		  IF NOT EXISTS (SELECT 1 FROM [GlobalSubCodes] WHERE GlobalCodeId = @GlobalCodeId AND SubCodeName = 'Last 90 Days')
		  BEGIN
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] ON
			INSERT INTO [GlobalSubCodes] (GlobalSubCodeId
			, [GlobalCodeId]
			, [SubCodeName]
			, [Active]
			, [CannotModifyNameOrDelete]
			, SortOrder
			, [ExternalCode1]
			, [Description])
			  VALUES (@GlobalSubCodeId, @GlobalCodeId, 'Last 90 Days', 'Y', 'N', 8, NULL, NULL)
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] OFF
		  END
	END


	--	GlobalSubCodeId: 110 (Last 180 Days)
	SET @GlobalSubCodeId = 110
	
	IF EXISTS (SELECT 1 FROM [GlobalCodes] WHERE GlobalCodeId = @GlobalCodeId)
	BEGIN

		  IF NOT EXISTS (SELECT 1 FROM [GlobalSubCodes] WHERE GlobalCodeId = @GlobalCodeId AND SubCodeName = 'Last 180 Days')
		  BEGIN
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] ON
			INSERT INTO [GlobalSubCodes] (GlobalSubCodeId
			, [GlobalCodeId]
			, [SubCodeName]
			, [Active]
			, [CannotModifyNameOrDelete]
			, SortOrder
			, [ExternalCode1]
			, [Description])
			  VALUES (@GlobalSubCodeId, @GlobalCodeId, 'Last 180 Days', 'Y', 'N', 9, NULL, NULL)
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] OFF
		  END
	END


	--	GlobalSubCodeId: 111 (Last 1 Year)
	SET @GlobalSubCodeId = 111
	
	IF EXISTS (SELECT 1 FROM [GlobalCodes] WHERE GlobalCodeId = @GlobalCodeId)
	BEGIN

		  IF NOT EXISTS (SELECT 1 FROM [GlobalSubCodes] WHERE GlobalCodeId = @GlobalCodeId AND SubCodeName = 'Last 1 Year')
		  BEGIN
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] ON
			INSERT INTO [GlobalSubCodes] (GlobalSubCodeId
			, [GlobalCodeId]
			, [SubCodeName]
			, [Active]
			, [CannotModifyNameOrDelete]
			, SortOrder
			, [ExternalCode1]
			, [Description])
			  VALUES (@GlobalSubCodeId, @GlobalCodeId, 'Last 1 Year', 'Y', 'N', 10, NULL, NULL)
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] OFF
		  END
	END


	--	GlobalSubCodeId: 112 (All Dates)
	SET @GlobalSubCodeId = 112
	
	IF EXISTS (SELECT 1 FROM [GlobalCodes] WHERE GlobalCodeId = @GlobalCodeId)
	BEGIN

		  IF NOT EXISTS (SELECT 1 FROM [GlobalSubCodes] WHERE GlobalCodeId = @GlobalCodeId AND SubCodeName = 'All Dates')
		  BEGIN
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] ON
			INSERT INTO [GlobalSubCodes] (GlobalSubCodeId
			, [GlobalCodeId]
			, [SubCodeName]
			, [Active]
			, [CannotModifyNameOrDelete]
			, SortOrder
			, [ExternalCode1]
			, [Description])
			  VALUES (@GlobalSubCodeId, @GlobalCodeId, 'All Dates', 'Y', 'N', 12, NULL, NULL)
			SET IDENTITY_INSERT [dbo].[GlobalSubCodes] OFF
		  END
	END


	--	GlobalSubCodeId: 108 (Custom Date) Updating Sort Order
	SET @GlobalSubCodeId = 108
	
	IF EXISTS (SELECT 1 FROM [GlobalCodes] WHERE GlobalCodeId = @GlobalCodeId)
	BEGIN

		  IF EXISTS (SELECT 1 FROM [GlobalSubCodes] WHERE GlobalCodeId = @GlobalCodeId AND SubCodeName = 'Custom Date')
		  BEGIN
				Update [GlobalSubCodes] Set SortOrder = 11 WHERE GlobalSubCodeId=@GlobalSubCodeId AND SubCodeName = 'Custom Date'
		  END
	END