----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentVersions_CustomDocumentUrinalysis_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentUrinalysis]'))
	ALTER TABLE [dbo].[CustomDocumentUrinalysis] DROP CONSTRAINT [DocumentVersions_CustomDocumentUrinalysis_FK]
GO
-------------------------------------------------------------------------
/****** Object:  Table [dbo].[CustomDocumentUrinalysis]    Script Date: 07/10/2013 09:52:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentUrinalysis]') AND type in (N'U'))
DROP TABLE [dbo].CustomDocumentUrinalysis
GO


PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------
IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentUrinalysis')
 BEGIN
/* 
 * TABLE: CustomDocumentUrinalysis 
 */

	CREATE TABLE CustomDocumentUrinalysis(
	   DocumentVersionId					Int						NOT NULL,
	   CreatedBy                            type_CurrentUser		NOT NULL,
	   CreatedDate                          type_CurrentDatetime    NOT NULL,
	   ModifiedBy                           type_CurrentUser        NOT NULL,
	   ModifiedDate                         type_CurrentDatetime    NOT NULL,
	   RecordDeleted                        type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
	   DeletedBy                            type_UserId             NULL,
	   DeletedDate                          datetime                NULL,
	   IssuesPresentedToday					type_YOrN				NULL
											CHECK (IssuesPresentedToday in ('Y','N')),
	   MoodAffectComment					type_Comment2			NULL,
	   RiskNone								type_YOrN				NULL
											CHECK (RiskNone in ('Y','N')),
	   RiskIdeation							type_YOrN				NULL
											CHECK (RiskIdeation in ('Y','N')),
	   RiskSelf								type_YOrN				NULL
											CHECK (RiskSelf in ('Y','N')),
	   RiskPlan								type_YOrN				NULL
											CHECK (RiskPlan in ('Y','N')),
	   RiskOthers							type_YOrN				NULL
											CHECK (RiskOthers in ('Y','N')),
	   RiskIntent							type_YOrN				NULL
											CHECK (RiskIntent in ('Y','N')),
	   RiskProperty							type_YOrN				NULL
											CHECK (RiskProperty in ('Y','N')),
	   RiskAttempt							type_YOrN				NULL
											CHECK (RiskAttempt in ('Y','N')),
	   RiskOther							type_YOrN				NULL
											CHECK (RiskOther in ('Y','N')),
	   RiskOtherComment						type_Comment2			NULL,
	   InterventionADUL						type_YOrN				NULL
											CHECK (InterventionADUL in ('Y','N')),
	   InterventionMDMA						type_YOrN				NULL
											CHECK (InterventionMDMA in ('Y','N')),
	   InterventionAMP						type_YOrN				NULL
											CHECK (InterventionAMP in ('Y','N')),
	   InterventionMTD						type_YOrN				NULL
											CHECK (InterventionMTD in ('Y','N')),
	   InterventionBZO						type_YOrN				NULL
											CHECK (InterventionBZO in ('Y','N')),
	   InterventionOPI						type_YOrN				NULL
											CHECK (InterventionOPI in ('Y','N')),
	   InterventionCOC						type_YOrN				NULL
											CHECK (InterventionCOC in ('Y','N')),
	   InterventionBUP						type_YOrN				NULL
											CHECK (InterventionBUP in ('Y','N')),
	   InterventionMET						type_YOrN				NULL
											CHECK (InterventionMET in ('Y','N')),
	   InterventionPCP						type_YOrN				NULL
											CHECK (InterventionPCP in ('Y','N')),
	   InterventionMOP						type_YOrN				NULL
											CHECK (InterventionMOP in ('Y','N')),
	   InterventionPPX						type_YOrN				NULL
											CHECK (InterventionPPX in ('Y','N')),
	   InterventionTHC						type_YOrN				NULL
											CHECK (InterventionTHC in ('Y','N')),
	   InterventionK2						type_YOrN				NULL
											CHECK (InterventionK2 in ('Y','N')),
	   InterventionOXY						type_YOrN				NULL
											CHECK (InterventionOXY in ('Y','N')),
	   InterventionOther					type_YOrN				NULL
											CHECK (InterventionOther in ('Y','N')),
	   InterventionOtherComment             type_Comment2			NULL,
	   SampleSendToLab                      type_YOrNOrNA			NULL
											CHECK (SampleSendToLab in ('Y','N','NA')),
	   UrinalysisTemperature                type_YOrN				NULL
											CHECK (UrinalysisTemperature in ('Y','N')),
	   UrinalysisShareWithClient            type_YOrN				NULL
											CHECK (UrinalysisShareWithClient in ('Y','N')),
	   UrinalysisConsistentWithClientReport type_YOrN				NULL
											CHECK (UrinalysisConsistentWithClientReport in ('Y','N')),
	   UrineNoteStaffRating                 type_GlobalCode			NULL,
	   UrinalysisComment                    type_Comment2			NULL,
	   CONSTRAINT CustomDocumentUrinalysis_PK PRIMARY KEY CLUSTERED (DocumentVersionId)  
   )

IF OBJECT_ID('CustomDocumentUrinalysis') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentUrinalysis >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentUrinalysis >>>'


/* 
 * TABLE: CustomUrinalysis 
 */
END


ALTER TABLE CustomDocumentUrinalysis ADD CONSTRAINT DocumentVersions_CustomDocumentUrinalysis_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go


---------------------------------------------------------------
PRINT 'STEP 4 COMPLETED'
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_Urinalysis')
	begin
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_Urinalysis'
				   ,'1.0'
				   )
            
	End

Else
	Begin
		Update SystemConfigurationKeys set value ='1.0' Where [key] = 'CDM_Urinalysis'
	End

Go
PRINT 'STEP 7 COMPLETED'


