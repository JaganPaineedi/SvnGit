/****** Object:  Trigger [TriggerInsertUpdate_Documents]    Script Date: 12/21/2015 9:55:26 AM ******/
DROP TRIGGER [dbo].[TriggerInsertUpdate_Documents]
GO

/****** Object:  Trigger [dbo].[TriggerInsertUpdate_Documents]    Script Date: 12/21/2015 9:55:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[TriggerInsertUpdate_Documents] on [dbo].[Documents] for insert, update
as

--
-- Created Date: 07.10.2013
-- This trigger is a temporary solution to preserve data integity until the issue is identified and fixed
-- Sachin 29-Nove-2017   What : Added Where isnull(i.[Status], -1) NOT IN( 22,26), when the Service being set to error has a Complete status is tied to a Signed Service Note document also Pranay has missed in Harbor Task#857,
--                       Why : Core Bugs #2448
if update(CurrentDocumentVersionId) 
begin
  if exists(select *
              from inserted i
                   join dbo.DocumentVersions dv on dv.DocumentVersionId = i.CurrentDocumentVersionId
             where i.DocumentId <> dv.DocumentId
               and i.DocumentCodeId <> 5                   
               and isnull(i.RecordDeleted, 'N') = 'N'
               and isnull(dv.RecordDeleted, 'N') = 'N')
  begin
  RAISERROR ('System Error: CurrentDocumentVersionId belongs to a different document.  Please contact your system administrator.',16,1); 
  --  raiserror 50010 'System Error: CurrentDocumentVersionId belongs to a different document.  Please contact your system administrator.'
    rollback tran
  end
end
  
if update(InProgressDocumentVersionId)  
begin
  if exists(select *
              from inserted i
                   join dbo.DocumentVersions dv on dv.DocumentVersionId = i.InProgressDocumentVersionId
             where i.DocumentId <> dv.DocumentId
               and i.DocumentCodeId <> 5                   
               and isnull(i.RecordDeleted, 'N') = 'N'
               and isnull(dv.RecordDeleted, 'N') = 'N')
  begin
  RAISERROR ('System Error: InProgressDocumentVersionId belongs to a different document.  Please contact your system administrator.',16,1);  
   -- raiserror 50020 'System Error: InProgressDocumentVersionId belongs to a different document.  Please contact your system administrator.'
    rollback tran
  end
end      

if update(AuthorId)  
begin
  if exists(select *
              from inserted i
                   join Services s on s.ServiceId = i.ServiceId
             where i.AuthorId <> s.ClinicianId
               and isnull(i.RecordDeleted, 'N') = 'N'
               and isnull(s.RecordDeleted, 'N') = 'N')
  begin
   RAISERROR ('System Error: Author does not match service clinician.  Please contact your system administrator.',16,1);  
   -- raiserror 50030 'System Error: Author does not match service clinician.  Please contact your system administrator.'
    rollback tran
  end
end

if update([Status])
begin
  if exists(select *
              from inserted i
                   join deleted d on d.DocumentId = i.DocumentId
            -- where isnull(i.[Status], -1) <> 22
               where isnull(i.[Status], -1) NOT IN( 22,26)  -- Added By Sachin which has Pranay has been missed in Harbor Task#857
               and d.[Status] = 22
               and isnull(i.RecordDeleted, 'N') = 'N'
			   and isnull(i.DocumentCodeId,-1) not in (select IntegerCodeId from dbo.ssf_RecodeValuesCurrent('SIGNEDDOCUMENTSTATUSCHANGEEXCEPTIONS') srvc)
			   and isnull(i.DocumentId,-1) not in (select IntegerCodeId from dbo.ssf_RecodeValuesCurrent('MoveSignedDocumentIdException') a)) --jcarlson 12/21/2015 added to support Change ClientId on Signed Document functionality

  begin
   RAISERROR ('System Error: Document status cannot be changed from Signed to In Progress.  Please contact your system administrator.',16,1);  
    --raiserror 50040 'System Error: Document status cannot be changed from Signed to In Progress.  Please contact your system administrator.'
    rollback tran
  end
end

-- 10/22/2013 - Jeff Riley - Prevent mismatched ClientId between documents and services
IF EXISTS ( SELECT 1
            FROM inserted i
            LEFT JOIN Services s ON s.ServiceId = i.ServiceId
            WHERE i.ServiceId IS NOT NULL AND
                  i.ClientId <> s.ClientId )
BEGIN
RAISERROR ('System Error: ClientId on Document and Service do not match.  Please try saving/signing the document again.  If you still have a problem please contact your system administrator.',16,1);  
	--RAISERROR 50010 'System Error: ClientId on Document and Service do not match.  Please try saving/signing the document again.  If you still have a problem please contact your system administrator.'
	ROLLBACK TRAN
END                    

GO


