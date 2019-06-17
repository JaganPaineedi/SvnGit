----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClientInformationReleases_CustomDocumentRevokeReleaseOfInformations_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentRevokeReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentRevokeReleaseOfInformations] DROP CONSTRAINT [ClientInformationReleases_CustomDocumentRevokeReleaseOfInformations_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentVersions_CustomDocumentRevokeReleaseOfInformations_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentRevokeReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentRevokeReleaseOfInformations] DROP CONSTRAINT [DocumentVersions_CustomDocumentRevokeReleaseOfInformations_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_CustomDocumentRevokeReleaseOfInformations_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentRevokeReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentRevokeReleaseOfInformations] DROP CONSTRAINT [Staff_CustomDocumentRevokeReleaseOfInformations_FK]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Recor__38E54BF0]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentRevokeReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentRevokeReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Recor__38E54BF0]
GO

/****** Object:  Table [dbo].[CustomDocumentRevokeReleaseOfInformations]    Script Date: 01/17/2013 14:14:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentRevokeReleaseOfInformations]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentRevokeReleaseOfInformations]
GO



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClientInformationReleases_CustomRevokeReleaseOfInformations_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomRevokeReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomRevokeReleaseOfInformations] DROP CONSTRAINT [ClientInformationReleases_CustomRevokeReleaseOfInformations_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_CustomRevokeReleaseOfInformations_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomRevokeReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomRevokeReleaseOfInformations] DROP CONSTRAINT [Staff_CustomRevokeReleaseOfInformations_FK]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomRev__Recor__332C729A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomRevokeReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomRevokeReleaseOfInformations] DROP CONSTRAINT [CK__CustomRev__Recor__332C729A]
GO


/****** Object:  Table [dbo].[CustomRevokeReleaseOfInformations]    Script Date: 01/17/2013 11:55:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomRevokeReleaseOfInformations]') AND type in (N'U'))
DROP TABLE [dbo].[CustomRevokeReleaseOfInformations]
GO



PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------

/* 
 * TABLE: CustomDocumentRevokeReleaseOfInformations 
 */

CREATE TABLE CustomDocumentRevokeReleaseOfInformations(
    DocumentVersionId             int                     NOT NULL,
    CreatedBy                     type_CurrentUser        NOT NULL,
    CreatedDate                   type_CurrentDatetime    NOT NULL,
    ModifiedBy                    type_CurrentUser        NOT NULL,
    ModifiedDate                  type_CurrentDatetime    NOT NULL,
    RecordDeleted                 type_YOrN               NULL
                                  CHECK (RecordDeleted in ('Y','N')),
    DeletedDate                   datetime                NULL,
    DeletedBy                     type_UserId             NULL,
    ClientInformationReleaseId    int                     NULL,
    StaffId                       int                     NULL,
    RevokeEndDate                 datetime                NULL,
    CONSTRAINT CustomRevokeReleaseOfInformations_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)
go



IF OBJECT_ID('CustomDocumentRevokeReleaseOfInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentRevokeReleaseOfInformations >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentRevokeReleaseOfInformations >>>'
go

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'CustomDocumentRevokeReleaseOfInformations', 'column', 'RevokeEndDate'))
BEGIN
    exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'CustomDocumentRevokeReleaseOfInformations', 'column', 'RevokeEndDate'
END
exec sys.sp_addextendedproperty 'MS_Description', 'Stores withdraw date of Authorization to Obtain/Disclose protected
Health information', 'schema', 'dbo', 'table', 'CustomDocumentRevokeReleaseOfInformations', 'column', 'RevokeEndDate'
go
/* 
 * TABLE: CustomDocumentRevokeReleaseOfInformations 
 */

ALTER TABLE CustomDocumentRevokeReleaseOfInformations ADD CONSTRAINT ClientInformationReleases_CustomDocumentRevokeReleaseOfInformations_FK 
    FOREIGN KEY (ClientInformationReleaseId)
    REFERENCES ClientInformationReleases(ClientInformationReleaseId)
go

ALTER TABLE CustomDocumentRevokeReleaseOfInformations ADD CONSTRAINT DocumentVersions_CustomDocumentRevokeReleaseOfInformations_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go

ALTER TABLE CustomDocumentRevokeReleaseOfInformations ADD CONSTRAINT Staff_CustomDocumentRevokeReleaseOfInformations_FK 
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
go






--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

PRINT 'STEP 7 COMPLETED'
Update SystemConfigurations set CustomDataBaseVersion=1.01

Go


