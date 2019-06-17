----- STEP 1 ----------
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------


--PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentLOCUSs')
BEGIN
/* 
 * TABLE: CustomDocumentLOCUSs 
 */
CREATE TABLE CustomDocumentLOCUSs(
    DocumentVersionId                 int                     NOT NULL,
    CreatedBy                         type_CurrentUser        NOT NULL,
    CreatedDate                       type_CurrentDatetime    NOT NULL,
    ModifiedBy                        type_CurrentUser        NOT NULL,
    ModifiedDate                      type_CurrentDatetime    NOT NULL,
    RecordDeleted                     type_YOrN               NULL
                                      CHECK (RecordDeleted in ('Y','N')),
    DeletedDate                       datetime                NULL,
    DeletedBy                         type_UserId             NULL,
    SectionIScore                     int                     NULL,
    SectionIIScore                    int                     NULL,
    SectionIIIScore                   int                     NULL,
    SectionIVaScore                   int                     NULL,
    SectionIVbScore                   int                     NULL,
    SectionVScore                     int                     NULL,
    SectionVIScore                    int                     NULL,
    CompositeScore                    int                     NULL,
    LOCUSRecommendedLevelOfCare       int                     NULL,
    AssessorRecommendedLevelOfCare    int                     NULL,
    ReasonForDeviation                type_Comment2           NULL,
    Comments						 varchar(250)			  NULL,
    CONSTRAINT CustomDocumentLOCUSs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)
      
IF OBJECT_ID('CustomDocumentLOCUSs') IS NOT NULL
PRINT '<<< CREATED TABLE CustomDocumentLOCUSs >>>'
ELSE
 RAISERROR('<<< FAILED CREATING TABLE CustomDocumentLOCUSs >>>', 16, 1)
    
/* 
 * TABLE: CustomDocumentLOCUSs 
 */
		
ALTER TABLE CustomDocumentLOCUSs ADD CONSTRAINT DocumentVersions_CustomDocumentLOCUSs_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

 PRINT 'STEP 4 COMPLETED'
END

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------
If NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_LOCUS')
 BEGIN
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
       ,'CDM_LOCUS'
       ,'1.0'
       )
            
 END
ELSE
 BEGIN
  UPDATE SystemConfigurationKeys SET value ='1.0' WHERE [key] = 'CDM_LOCUS'
 END
PRINT 'STEP 7 COMPLETED'

GO



