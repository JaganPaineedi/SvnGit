----- STEP 1 ----------
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('CustomPrePlanningChecklists') IS NOT NULL
BEGIN
IF COL_LENGTH('CustomPrePlanningChecklists','PrePlanIndependentFacilitatorDiscussed')IS NULL
BEGIN
	ALTER TABLE CustomPrePlanningChecklists ADD PrePlanIndependentFacilitatorDiscussed type_YOrN NULL
											CHECK (PrePlanIndependentFacilitatorDiscussed in ('Y','N'))
END
IF COL_LENGTH('CustomPrePlanningChecklists','PrePlanIndependentFacilitatorDesired')IS NULL
BEGIN
	ALTER TABLE CustomPrePlanningChecklists ADD PrePlanIndependentFacilitatorDesired type_YOrN NULL
											CHECK (PrePlanIndependentFacilitatorDesired in ('Y','N'))
END
	PRINT 'STEP 3 COMPLETED'  
END  
------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPrePlanningChecklists')
BEGIN
/* 
 * TABLE: CustomPrePlanningChecklists 
 */
CREATE TABLE CustomPrePlanningChecklists(
    DocumentVersionId						int						NOT NULL,
	CreatedBy								type_CurrentUser		NOT NULL,
	CreatedDate								type_CurrentDatetime	NOT NULL,
	ModifiedBy								type_CurrentUser		NOT NULL,
	ModifiedDate							type_CurrentDatetime	NOT NULL,
	RecordDeleted							type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
	DeletedBy								type_UserId				NULL,
	DeletedDate								datetime				NULL,
	Residential                             type_Comment			NULL,
	OccupationalCommunityParticpation		type_Comment			NULL,
	Safety									type_Comment			NULL,
	Legal									type_Comment			NULL,
	Health									type_Comment			NULL,
	NaturalSupports							type_Comment			NULL,
	Other									type_Comment			NULL,
	Participants							type_Comment			NULL,
	Facilitator								type_Comment			NULL,
	Assessments								type_Comment			NULL,
	TimeLocation							type_Comment			NULL,
	ISsuesToAvoid							type_Comment			NULL,
	CommunicationAccomodations				type_Comment			NULL,
	WishToDiscuss							type_Comment			NULL,
	SourceOfPrePlanningInformation			type_Comment			NULL,
	SelfDetermination						type_YOrN				NULL
											CHECK (SelfDetermination in ('Y','N')),
	FiscalIntermediary						type_YOrN				NULL
											CHECK (FiscalIntermediary in ('Y','N')),
	PCPInformationPamphletGiven				type_YOrN				NULL
											CHECK (PCPInformationPamphletGiven in ('Y','N')),
	PCPInformationDiscussed					type_YOrN				NULL
										    CHECK (PCPInformationDiscussed in ('Y','N')),   
	PrePlanIndependentFacilitatorDiscussed	type_YOrN				NULL
										    CHECK (PrePlanIndependentFacilitatorDiscussed in ('Y','N')), 
	PrePlanIndependentFacilitatorDesired	type_YOrN				NULL
										    CHECK (PrePlanIndependentFacilitatorDesired in ('Y','N')), 										    
    CONSTRAINT CustomPrePlanningChecklists_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)
IF OBJECT_ID('CustomPrePlanningChecklists') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPrePlanningChecklists >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPrePlanningChecklists >>>', 16, 1)
/* 
 * TABLE: CustomPrePlanningChecklists 
 */
 
ALTER TABLE CustomPrePlanningChecklists ADD CONSTRAINT DocumentVersions_CustomPrePlanningChecklists_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	
	PRINT 'STEP 4 COMPLETED'  

END
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_PrePlanChecklist')
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_PrePlanChecklist'
		,'1.0'
		)
	PRINT 'STEP 7 COMPLETED'
END
GO

