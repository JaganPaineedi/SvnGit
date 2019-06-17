/********************************************************************************************
/*	Date    : 04 April 2017																					 */
/*	Author  : Alok Kumar 																					 */
/*	Purpose : Created for the Task #602- Aspenpointe Customizations.
				Updating GlobalCodeId from 9410 to 9426.															*/
*********************************************************************************************/


--Insert script for GlobalCodeCategories [TRIAGESTATUS]		GlobalCodeId - 9426

IF EXISTS (SELECT 1 FROM dbo.GlobalCodeCategories WHERE Category = 'TRIAGESTATUS')
BEGIN

	--Insert script for GlobalCodes [TRIAGESTATUS]
	IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE GlobalCodeId = 9426)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO GlobalCodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9426, 'TRIAGESTATUS', 'Heads up', NULL, 'Y', 'Y', 1)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END

END


-- Updating ContactStatus column of CustomCrisisContacts table(From 9410 to 9426)

DECLARE @StrSqlQuery Varchar(Max)
IF OBJECT_ID(N'dbo.CustomCrisisContacts', N'U') IS NOT NULL
BEGIN
	IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'ContactStatus' AND Object_ID = Object_ID(N'CustomCrisisContacts'))
		BEGIN
			SET @StrSqlQuery = 'IF OBJECT_ID(N''dbo.CustomCrisisContacts'', N''U'') IS NOT NULL
									BEGIN
										IF COL_LENGTH(''CustomCrisisContacts'',''ContactStatus'') IS NOT NULL
										BEGIN
											IF EXISTS (SELECT 1 FROM dbo.CustomCrisisContacts WHERE ContactStatus = 9410 )
											BEGIN
												
												Update dbo.CustomCrisisContacts set ContactStatus = 9426 where ContactStatus = 9410

											END
										END
									END'
									
			EXEC (@StrSqlQuery)
		END
END



-- Deleting GlobalCodes, when GlobalCodeId = 9410 AND CodeName = 'Heads up' AND Category = 'TRIAGESTATUS'.
IF EXISTS (SELECT 1 FROM dbo.GlobalCodeCategories WHERE Category = 'TRIAGESTATUS')
BEGIN

	IF EXISTS (SELECT 1 FROM GlobalCodes WHERE GlobalCodeId = 9410 AND CodeName = 'Heads up' AND Category = 'TRIAGESTATUS' )
	BEGIN
			
		Delete FROM GlobalCodes WHERE GlobalCodeId = 9410 AND CodeName = 'Heads up' AND Category = 'TRIAGESTATUS'
	  
	END

END




