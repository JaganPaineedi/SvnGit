----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.23)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.23 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ---------- 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='BedAssignmentOverlappingProgramMappings')
BEGIN
/*  
 * TABLE: BedAssignmentOverlappingProgramMappings 
 */
 CREATE TABLE BedAssignmentOverlappingProgramMappings( 
		BedAssignmentOverlappingProgramMappingId	int	identity(1,1)	 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime             NULL,
		ProgramId									int					 NULL,
		OverlappingProgramId						int					 NULL,			
		CONSTRAINT BedAssignmentOverlappingProgramMappings_PK PRIMARY KEY CLUSTERED (BedAssignmentOverlappingProgramMappingId)
)
IF OBJECT_ID('BedAssignmentOverlappingProgramMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE BedAssignmentOverlappingProgramMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE BedAssignmentOverlappingProgramMappings >>>', 16, 1)
    
/* 
 * TABLE: BedAssignmentOverlappingProgramMappings 
 */ 
 
 ALTER TABLE BedAssignmentOverlappingProgramMappings ADD CONSTRAINT Programs_BedAssignmentOverlappingProgramMappings_FK
    FOREIGN KEY (ProgramId)
    REFERENCES Programs(ProgramId)  
    
   ALTER TABLE BedAssignmentOverlappingProgramMappings ADD CONSTRAINT Programs_BedAssignmentOverlappingProgramMappings_FK2
    FOREIGN KEY (OverlappingProgramId)
    REFERENCES Programs(ProgramId)          

 PRINT 'STEP 4(A) COMPLETED' 
END

--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.23)
BEGIN
Update SystemConfigurations set DataModelVersion=15.24
PRINT 'STEP 7 COMPLETED'
END
Go
