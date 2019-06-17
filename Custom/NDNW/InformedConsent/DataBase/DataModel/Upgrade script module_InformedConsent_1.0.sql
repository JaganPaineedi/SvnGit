/****** Object:  Table [dbo].[CustomRevokeReleaseOfInformations]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentInformedConsents]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentInformedConsents]
GO

CREATE TABLE CustomDocumentInformedConsents(
    DocumentVersionId         int                     NOT NULL,
    CreatedBy                 type_CurrentUser        NOT NULL,
    CreatedDate               type_CurrentDatetime    NOT NULL,
    ModifiedBy                type_CurrentUser        NOT NULL,
    ModifiedDate              type_CurrentDatetime    NOT NULL,
    RecordDeleted             type_YOrN               NULL
                              CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                 type_UserId             NULL,
    DeletedDate               datetime                NULL,
    MemberRefusedSignature    type_YOrN               NULL
                              CHECK (MemberRefusedSignature in ('Y','N')),
    CONSTRAINT CustomDocumentInformedConsents_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)
go



IF OBJECT_ID('CustomDocumentInformedConsents') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentInformedConsents >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentInformedConsents >>>'
go

/* 
 * TABLE: CustomDocumentInformedConsents 
 */

ALTER TABLE CustomDocumentInformedConsents ADD CONSTRAINT DocumentVersions_CustomDocumentInformedConsents_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go


