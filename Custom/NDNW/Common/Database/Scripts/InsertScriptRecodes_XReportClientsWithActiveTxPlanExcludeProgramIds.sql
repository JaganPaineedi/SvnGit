
/*******************************************************************************

Script:		InsertScriptRecodes_XReportClientsWithActiveTxPlanExcludeProgramIds.sql

Purpose:	TBD

This script utilizes the same sprocs used by the front end
to add recodes to the system.  The createdBy and date fields are
added automatically through default values

Change Log:                                                                                                
Date		Author			Purpose
2018-10-08	jwheeler		Created ; New Directions Enhancements 12

********************************************************************************/

----Test Code
--BEGIN TRAN;

--#############################################################################
-- Recodes for Excluded Programs
--############################################################################# 
		
 
 DECLARE @UndeleteIfAddingSomethingThatHasBeenRecordDeleted CHAR(1) = 'Y'

 DECLARE @RecodeCategoryID			Int			-- Holds RecodeCategories.RecodeCategoryID
 DECLARE @Recode_IntegerCodeId		INT			-- Value to store in Recodes.IntegerCodeID
 DECLARE @Recode_CharacterCodeId	Varchar	(max)	-- Value to store in Recodes.CharacterCodeID
 DECLARE @Recode_CategoryCode		Varchar	(max)	-- Value to store in Recodes.CategoryCode
 DECLARE @Recode_CategoryName		Varchar	(max)	-- Value to store in Recodes.CategoryName
 DECLARE @Recode_Description		Varchar	(max)	-- Value to store in Recodes.Description
 DECLARE @Recode_MappingEntity		Varchar	(max)	-- Value to store in Recodes.MappingEntity /* GlobalCodes */
 

	SET @Recode_CategoryCode			=  'XReportClientsWithActiveTxPlanExcludeProgramIds'	--SELECT LEN('XReportClientsWithActiveTxPlanExcludeProgramIds')
 	SET @Recode_CategoryName			=  'XReportClientsWithActiveTxPlanExcludeProgramIds'
 	SET @Recode_Description			= 'Services in these programs will not count for the Clients Without Tx Plans Report'
 	SET @Recode_MappingEntity			= NULL --eg. Globalcodes, HealthDataAttributes, Programs

       DECLARE @Codes TABLE (CodeName VARCHAR(100), CharacterCodeId VARCHAR(100), IntegerCodeId Integer) --Same names / Types from Recodes
   
   INSERT INTO @Codes
           ( CodeName, CharacterCodeId, IntegerCodeId )
    select ProgramName, NULL, ProgramId from programs WHERE CHARINDEX('dd', ProgramName) = 1
    AND ISNULL(RecordDeleted, 'N') = 'N'
     
 Insert Into RecodeCategories
	(
	 CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,CategoryCode
	,CategoryName
	,Description
	,MappingEntity
	)
 Select
   
 	/*   CreatedBy		*/		'SA'
	/*  ,CreatedDate	*/		,GETDATE()
	/*  ,ModifiedBy		*/		,'SA'
	/*  ,ModifiedDate	*/		,GETDATE()
	/*  ,CategoryCode	*/		,@Recode_CategoryCode
	/*  ,CategoryName	*/		,@Recode_CategoryName
	/*  ,Description	*/		,@Recode_Description
	/*  ,MappingEntity	*/		,@Recode_MappingEntity
   WHERE NOT EXISTS (SELECT 1 FROM RecodeCategories RC WHERE RC.CategoryCode = @Recode_CategoryCode)
   
   Select @RecodeCategoryID = RC.RecodeCategoryId
   FROM RecodeCategories RC WHERE RC.CategoryCode =  @Recode_CategoryCode
  
  Insert Into Recodes
	(
	 CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,IntegerCodeId
	,CharacterCodeId
	,CodeName
	,FromDate
	,ToDate
	,RecodeCategoryId
	)
 Select
   
 	/*   CreatedBy			*/		'SA'
	/*  ,CreatedDate		*/		,GETDATE()
	/*  ,ModifiedBy			*/		,'SA'
	/*  ,ModifiedDate		*/		,GETDATE()
	/*  ,IntegerCodeId		*/		,c.IntegerCodeId
	/*  ,CharacterCodeId	*/		,C.CharacterCodeId
	/*  ,CodeName			*/		,c.CodeName
	/*  ,FromDate			*/		,'8/8/1869'
	/*  ,ToDate				*/		,Null
	/*  ,RecodeCategoryId	*/		,@RecodeCategoryID
   FROM @Codes c
   WHERE NOT EXISTS (SELECT 1 FROM recodes WHERE RecodeCategoryId=@RecodeCategoryID AND CharacterCodeId = c.CharacterCodeId)
   

   IF @UndeleteIfAddingSomethingThatHasBeenRecordDeleted = 'Y'
   Begin
       UPDATE r SET RecordDeleted = 'N', modifiedBy = 'RecodesScript', ModifiedDate = GETDATE()
       FROM recodes r WHERE RecodeCategoryId=@RecodeCategoryID AND ISNULL(RecordDeleted, 'N') = 'Y'
   end



----Test Code   
--SELECT  TOP 10 *
--FROM    RecodeCategories where RecodeCategoryId = @RecodeCategoryId
--SELECT  TOP 10 *
--FROM    Recodes where RecodeCategoryId = @RecodeCategoryId
   

----Test Code
----COMMIT TRAN;
--ROLLBACK TRAN;

/*
--Test Code

DECLARE @MaxId int;

SELECT @MaxId = MAX(RecodeCategoryId) FROM dbo.RecodeCategories
SELECT @MaxId AS [RecodeCategories @MaxId]
DBCC CHECKIDENT(RecodeCategories, RESEED, @MaxId);

SELECT @MaxId = MAX(RecodeId) FROM dbo.Recodes
SELECT @MaxId AS [Recodes @MaxId]
DBCC CHECKIDENT(Recodes, RESEED, @MaxId);

SELECT @MaxId = MAX(ApplicationStoredProcedureRecodeCategoryId) FROM dbo.ApplicationStoredProcedureRecodeCategories
SELECT @MaxId AS [Recodes @MaxId]
DBCC CHECKIDENT(ApplicationStoredProcedureRecodeCategories, RESEED, @MaxId);

--DECLARE @MaxId int;

SELECT @MaxId = MAX(ApplicationStoredProcedureId) FROM dbo.ApplicationStoredProcedures
SELECT @MaxId AS [Recodes @MaxId]
DBCC CHECKIDENT(ApplicationStoredProcedures, RESEED, @MaxId);

*/

GO


