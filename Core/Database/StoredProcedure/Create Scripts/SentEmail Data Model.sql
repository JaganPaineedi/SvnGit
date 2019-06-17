
CREATE TABLE SentEmails (
    SentEmailId INT IDENTITY(1, 1) PRIMARY KEY,
    CreatedBy type_CurrentUser,
    CreatedDate type_CurrentDatetime,
    ModifiedBy type_CurrentUser,
    ModifiedDate type_CurrentDatetime,
    RecordDeleted type_YOrN NULL,
    DeletedBy type_UserId NULL,
    DeletedDate DATETIME NULL,
    StaffId INT,
    ClientId INT NULL,
    MessageTo VARCHAR(MAX),
    MessageFrom VARCHAR(MAX),
    MessageCC VARCHAR(MAX),
    MessageBCC VARCHAR(MAX),
    MessageSubject VARCHAR(MAX),
    MessageBody VARCHAR(MAX));

CREATE TABLE SentEmailAttachments (
    SentEmailAttachmentId INT IDENTITY(1, 1) PRIMARY KEY,
    CreatedBy type_CurrentUser,
    CreatedDate type_CurrentDatetime,
    ModifiedBy type_CurrentUser,
    ModifiedDate type_CurrentDatetime,
    RecordDeleted type_YOrN NULL,
    DeletedBy type_UserId NULL,
    DeletedDate DATETIME NULL,
	SentEmailId INT NULL,
    AttachmentName VARCHAR(MAX),
    AttachmentData VARBINARY(MAX),
    AttachmentMimeType VARCHAR(MAX),
    DocumentVersionId INT NULL);


	ALTER TABLE dbo.SentEmails ADD CONSTRAINT FK_SentEmails_StaffId FOREIGN KEY (StaffId) REFERENCES Staff (StaffId)
	ALTER TABLE dbo.SentEmails ADD CONSTRAINT FK_SentEmails_ClientId FOREIGN KEY (ClientId) REFERENCES Clients (ClientId)
	ALTER TABLE dbo.SentEmailAttachments ADD CONSTRAINT FK_SentEmailAttachments_SentEmailId FOREIGN KEY (SentEmailId) REFERENCES dbo.SentEmails (SentEmailId)
	ALTER TABLE dbo.SentEmailAttachments ADD CONSTRAINT FK_SentEmailAttachments_DocumentVersionId FOREIGN KEY (DocumentVersionId) REFERENCES dbo.DocumentVersions (DocumentVersionId)


	CREATE TABLE TemporaryEmailAttachments 
	(
		TemporaryEmailAttachmentId INT PRIMARY KEY IDENTITY(1,1),
		CreatedBy type_CurrentUser,
		CreatedDate type_CurrentDatetime,
		ModifiedBy type_CurrentUser,
		ModifiedDate type_CurrentDatetime,
		RecordDeleted type_YOrN NULL,
		DeletedBy type_UserId NULL,
		DeletedDate DATETIME NULL,
		AttachmentName VARCHAR(MAX),
		AttachmentData VARBINARY(MAX),
		AttachmentMimeType VARCHAR(MAX),
		SessionId VARCHAR(MAX),
		StaffId INT
	)
	ALTER TABLE dbo.TemporaryEmailAttachments ADD CONSTRAINT FK_TemporaryEmailAttachments_StaffId FOREIGN KEY (StaffId) REFERENCES dbo.Staff (StaffId)

