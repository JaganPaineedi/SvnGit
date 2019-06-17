----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.59)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.59 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 ------- 

------ STEP 3 ------------

IF OBJECT_ID('Groups')  IS NOT NULL
BEGIN
	IF COL_LENGTH('Groups','GroupNoteType') IS NULL
	BEGIN
	ALTER TABLE Groups ADD  GroupNoteType type_GlobalCode  NULL		
	END
END


IF OBJECT_ID('GroupNoteDocumentCodes')  IS NOT NULL
BEGIN
	IF COL_LENGTH('GroupNoteDocumentCodes','GroupNoteCodeId') IS NOT NULL
	BEGIN
	ALTER TABLE GroupNoteDocumentCodes Alter Column  GroupNoteCodeId INT NULL		
	END
END

go
-----END Of STEP 3--------------------

------ STEP 4 ------------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='GroupTemplates')
BEGIN
/* 
 * TABLE: GroupTemplates
 */
CREATE TABLE GroupTemplates(
			GroupTemplateId				int	identity(1,1)		NOT NULL,
			CreatedBy					type_CurrentUser        NOT NULL,
			CreatedDate					type_CurrentDatetime    NOT NULL,
			ModifiedBy					type_CurrentUser        NOT NULL,
			ModifiedDate				type_CurrentDatetime    NOT NULL,
			RecordDeleted				type_YOrN               NULL
										CHECK (RecordDeleted in ('Y','N')),
			DeletedBy					type_UserId             NULL,
			DeletedDate					datetime				NULL,
			GroupId						int						NULL,
			StaffId						int						NULL,
			DocumentId					int						NULL,				
			StartDate					datetime				NULL,
			EndDate						datetime				NULL,
			CONSTRAINT GroupTemplates_PK PRIMARY KEY CLUSTERED (GroupTemplateId) 
 )
 
IF OBJECT_ID('GroupTemplates') IS NOT NULL
    PRINT '<<< CREATED TABLE GroupTemplates >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE GroupTemplates >>>', 16, 1)
    
   	
/* 
 * TABLE: GroupTemplates 
 */ 
 
	ALTER TABLE GroupTemplates ADD CONSTRAINT Groups_GroupTemplates_FK 
		FOREIGN KEY (GroupId)
		REFERENCES Groups(GroupId)
		
	ALTER TABLE GroupTemplates ADD CONSTRAINT Staff_GroupTemplates_FK 
		FOREIGN KEY (StaffId)
		REFERENCES Staff(StaffId)
		
	ALTER TABLE Documents ADD CONSTRAINT Documents_GroupTemplates_FK 
		FOREIGN KEY (DocumentId)
		REFERENCES Documents(DocumentId)	
 
	PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='GroupStandAloneDocuments')
BEGIN
/* 
 * TABLE: GroupStandAloneDocuments
 */
CREATE TABLE GroupStandAloneDocuments(
			GroupStandAloneDocumentId		int	identity(1,1)		NOT NULL,
			CreatedBy						type_CurrentUser        NOT NULL,
			CreatedDate						type_CurrentDatetime    NOT NULL,
			ModifiedBy						type_CurrentUser        NOT NULL,
			ModifiedDate					type_CurrentDatetime    NOT NULL,
			RecordDeleted					type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
			DeletedBy						type_UserId             NULL,
			DeletedDate						datetime				NULL,
			GroupId							int						NULL,
			ClientId						int						NULL,
			StaffId							int						NULL,
			ServiceId						int						NULL,
			DocumentId						int						NULL,
			CONSTRAINT GroupStandAloneDocuments_PK PRIMARY KEY CLUSTERED (GroupStandAloneDocumentId) 
 )
 
IF OBJECT_ID('GroupStandAloneDocuments') IS NOT NULL
    PRINT '<<< CREATED TABLE GroupStandAloneDocuments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE GroupStandAloneDocuments >>>', 16, 1)
    
   	
/* 
 * TABLE: GroupStandAloneDocuments 
 */ 
 
	ALTER TABLE GroupStandAloneDocuments ADD CONSTRAINT Groups_GroupStandAloneDocuments_FK 
		FOREIGN KEY (GroupId)
		REFERENCES Groups(GroupId)
		
	ALTER TABLE GroupStandAloneDocuments ADD CONSTRAINT Clients_GroupStandAloneDocuments_FK 
		FOREIGN KEY (ClientId)
		REFERENCES Clients(ClientId)
		
	ALTER TABLE GroupStandAloneDocuments ADD CONSTRAINT Staff_GroupStandAloneDocuments_FK 
		FOREIGN KEY (StaffId)
		REFERENCES Staff(StaffId)
		
	ALTER TABLE GroupStandAloneDocuments ADD CONSTRAINT Services_GroupStandAloneDocuments_FK 
		FOREIGN KEY (ServiceId)
		REFERENCES [Services](ServiceId)
		
	ALTER TABLE GroupStandAloneDocuments ADD CONSTRAINT Documents_GroupStandAloneDocuments_FK 
		FOREIGN KEY (DocumentId)
		REFERENCES Documents(DocumentId)	
 
	PRINT 'STEP 4(B) COMPLETED'
END

-- Global codes entry for CategoryName = 'GROUPNOTETYPE' & related Code Name
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'GROUPNOTETYPE' AND Category = 'GROUPNOTETYPE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('GROUPNOTETYPE','GROUPNOTETYPE','Y','Y','Y','Y','N','N','Y')
END

IF NOT EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'GROUPNOTETYPE')
BEGIN
	IF NOT EXISTS(SELECT 1 from GlobalCodes where GlobalCodeId = 9383)
	BEGIN
		SET IDENTITY_INSERT GlobalCodes ON
		INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
		VALUES (9383,'GROUPNOTETYPE','Group Note',NULL,'Y','N',NULL,'GROUPNOTE')
		SET IDENTITY_INSERT GlobalCodes OFF
	END
	
	IF NOT EXISTS(SELECT 1 from GlobalCodes where GlobalCodeId = 9384)
	BEGIN
		SET IDENTITY_INSERT GlobalCodes ON
		INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
		VALUES (9384,'GROUPNOTETYPE','Daily Stand-alone',NULL,'Y','N',NULL,'DAILYSTANDALONE')
		SET IDENTITY_INSERT GlobalCodes OFF
	END
	
	IF NOT EXISTS(SELECT 1 from GlobalCodes where GlobalCodeId = 9385)
	BEGIN
		SET IDENTITY_INSERT GlobalCodes ON
		INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
		VALUES (9385,'GROUPNOTETYPE','Weekly Stand-alone',NULL,'Y','N',NULL,'WEEKLYSTANDALONE')
		SET IDENTITY_INSERT GlobalCodes OFF
	END
	
	IF NOT EXISTS(SELECT 1 from GlobalCodes where GlobalCodeId = 9386)
	BEGIN
		SET IDENTITY_INSERT GlobalCodes ON
		INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
		VALUES (9386,'GROUPNOTETYPE','Screen',NULL,'Y','N',NULL,'SCREEN')
		SET IDENTITY_INSERT GlobalCodes OFF
	END
END

-- Data Migration script before dropping column AttendanceStandAloneDocumentCodeId & AttendanceWeekly from table Groups
IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'AttendanceWeekly' AND Object_ID = Object_ID(N'Groups'))
BEGIN

exec ('	
IF OBJECT_ID(''tempdb..#Groups'') IS NOT NULL
	DROP TABLE #Groups
	
CREATE TABLE #Groups(GroupId INT,GroupNoteDocumentCodeId INT,GroupNoteType INT,AttendanceStandAloneDocumentCodeId INT,AttendanceScreenId INT,AttendanceWeekly CHAR(1),UsesAttendanceFunctions CHAR(1))

INSERT INTO #Groups(GroupNoteType,GroupId,GroupNoteDocumentCodeId,AttendanceStandAloneDocumentCodeId,AttendanceScreenId,AttendanceWeekly,UsesAttendanceFunctions)
SELECT GroupNoteType,GroupId,GroupNoteDocumentCodeId,AttendanceStandAloneDocumentCodeId,AttendanceScreenId,AttendanceWeekly,UsesAttendanceFunctions
FROM Groups
WHERE ISNULL(RecordDeleted, ''N'') = ''N''

UPDATE #Groups
SET GroupNoteType = 9383 --Group Note
WHERE GroupNoteDocumentCodeId IS NOT NULL
AND GroupNoteType IS NULL

UPDATE #Groups
SET GroupNoteType = 9386 --Screen
WHERE GroupNoteDocumentCodeId IS NULL
	AND AttendanceStandAloneDocumentCodeId IS NULL
	AND AttendanceScreenId IS NOT NULL
	AND ISNULL(UsesAttendanceFunctions,''N'') = ''Y''
	AND GroupNoteType IS NULL
	
IF OBJECT_ID(''tempdb..#GroupNoteDocumentCodes'') IS NOT NULL
	DROP TABLE #GroupNoteDocumentCodes
CREATE TABLE #GroupNoteDocumentCodes(GroupNoteName VARCHAR(100),Active CHAR(1),ServiceNoteCodeId INT)

INSERT INTO #GroupNoteDocumentCodes(GroupNoteName,Active,ServiceNoteCodeId)
SELECT DISTINCT DC.DocumentName,DC.Active,DC.DocumentCodeId
FROM Groups G
JOIN DocumentCodes DC ON G.AttendanceStandAloneDocumentCodeId = DC.DocumentCodeId
WHERE ISNULL(G.RecordDeleted, ''N'') = ''N''
	AND ISNULL(DC.RecordDeleted, ''N'') = ''N''
ORDER BY DC.DocumentName ASC

INSERT INTO GroupNoteDocumentCodes (GroupNoteName,Active,GroupNoteCodeId,ServiceNoteCodeId)
SELECT GroupNoteName,Active,NULL,ServiceNoteCodeId
FROM #GroupNoteDocumentCodes TGNDC
WHERE NOT EXISTS (
		SELECT 1
		FROM GroupNoteDocumentCodes GNDC
		WHERE GNDC.GroupNoteName = TGNDC.GroupNoteName
			AND GNDC.Active = TGNDC.Active
			AND GNDC.ServiceNoteCodeId = TGNDC.ServiceNoteCodeId
		)


UPDATE G
SET G.GroupNoteType = 9384 --Daily Stand-alone
	,G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
FROM #Groups G
JOIN GroupNoteDocumentCodes GNDC ON G.AttendanceStandAloneDocumentCodeId = GNDC.ServiceNoteCodeId
WHERE G.AttendanceStandAloneDocumentCodeId IS NOT NULL
	AND ISNULL(AttendanceWeekly, ''N'') = ''N''
	AND ISNULL(UsesAttendanceFunctions,''N'') = ''Y''
	AND GroupNoteType IS NULL
	
UPDATE G
SET G.GroupNoteType = 9385  --Weekly Stand-alone
	,G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
FROM #Groups G
JOIN GroupNoteDocumentCodes GNDC ON G.AttendanceStandAloneDocumentCodeId = GNDC.ServiceNoteCodeId
WHERE G.AttendanceStandAloneDocumentCodeId IS NOT NULL
	AND ISNULL(AttendanceWeekly, ''N'') = ''Y''
	AND ISNULL(UsesAttendanceFunctions,''N'') = ''Y''
	AND GroupNoteType IS NULL

UPDATE G
SET G.GroupNoteType = TG.GroupNoteType
	,G.GroupNoteDocumentCodeId = TG.GroupNoteDocumentCodeId
FROM Groups G
JOIN #Groups TG ON G.GroupId = TG.GroupId
')
END


IF COL_LENGTH('Groups','AttendanceStandAloneDocumentCodeId') IS NOT NULL
BEGIN		
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_Groups_FK]') AND parent_object_id = OBJECT_ID(N'Groups'))
	BEGIN
		ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DocumentCodes_Groups_FK]		
	END
END

--- drop column AttendanceStandAloneDocumentCodeId in Groups	
	
IF COL_LENGTH('Groups','AttendanceStandAloneDocumentCodeId') IS NOT NULL
BEGIN		
		
	ALTER TABLE Groups DROP COLUMN AttendanceStandAloneDocumentCodeId 
END	

--- drop column AttendanceWeekly in Groups


/* Drop Constraint */
declare @Cstname nvarchar(max), 
    @sql nvarchar(1000)

-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='Groups'
        AND TC.name='AttendanceWeekly'
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [Groups] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

IF COL_LENGTH('Groups','AttendanceWeekly') IS NOT NULL
BEGIN		
		
	ALTER TABLE Groups DROP COLUMN AttendanceWeekly 
END	


----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.59)
BEGIN
Update SystemConfigurations set DataModelVersion=15.60
PRINT 'STEP 7 COMPLETED'
END
Go