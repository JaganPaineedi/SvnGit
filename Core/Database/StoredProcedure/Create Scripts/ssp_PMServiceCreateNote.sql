/****** Object:  StoredProcedure [dbo].[ssp_PMServiceCreateNote]    Script Date: 11/18/2011 16:25:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMServiceCreateNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMServiceCreateNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                      
CREATE PROCEDURE [dbo].[ssp_PMServiceCreateNote]                                      
 @ServiceId int                                      
AS                                      
-- Get what I need to create a document and Note              
-- March 19,2010 Sahil Add a update query on Documents Table to update CurrentDocumentVersionId   
/* 17 July 2012  AmitSr  Commented SignedDocumentVersionId, It should not be inserted, only be updated,#1733,Harbor Go Live Issues, Note Signatures not Saving [Fwd: Re: FW: Procedure says I need to sign note to complete], Wed, 08 Aug 2012 18:59:10 +0530, Ankit(QA) Email */                             
/* 10 Aug 2012  AmitSr  #1918,Harbor Go Live Issues, Procedure says I need to sign note to complete */     
/* 04 Apr 2014	dknewtson	Adding InProgressDocumentVersionId and CurrentVersionStatus to match New Datamodel. Was causing Service notes to be created with NULL InProgressDocumentVersionIds */                                                         
/* 14-Oct-2016 Deej included the logic of groupService Note as well*/
declare                                      
 @ClientId int,                                      
 @DocumentCodeId int,                                      
 @EffectiveDate datetime,                                      
 @Status int,                                      
 @AuthorId int,                                      
 @CurrentVersion int,                                      
 @DocumentId int,
 @GroupServiceId INT                                      
 print @ServiceId                                     
select                                       
 @ClientId = s.ClientId,                                      
 @DocumentCodeId = pc.AssociatedNoteId,                                      
 @EffectiveDate = convert(datetime,convert(varchar,s.DateOfService,101)),                                      
 @Status = case when s.Status = 70 then 20 else 21 end, -- To Do                                      
 @AuthorId = ClinicianId,                                      
 @CurrentVersion = 1  ,
 @GroupServiceId=s.GroupServiceId                                    
from Services as s                                      
join ProcedureCodes as pc on (pc.procedurecodeid = s.procedurecodeid)                                      
join Staff as st on (st.StaffId = s.ClinicianId)                                      
where                                       
 s.ServiceId = @ServiceId  -- For Services                                      
-- and st.Active = 'Y'   -- Clinician is Active                                      
-- and st.AccessClinicianDesktop = 'Y' -- Clinician uses the Always Online Application                                      
-- and isNull(st.RecordDeleted, 'N') <> 'Y'                                      
-- and s.status in (70, 71) -- scheduled, show                                      
 and not exists (   -- a document does not already exist for this service                                      
  select * from Documents where ServiceId = @ServiceId and isNull(RecordDeleted, 'N') <> 'Y'                                      
 )       
  --changes by Deej 14-Oct-2016                             
  IF ( ISNULL(@GroupServiceId, 0) <> 0 ) 
    BEGIN  
        SELECT  @DocumentCodeId = ServiceNoteCodeId
        FROM    GroupNoteDocumentCodes GNDC
                INNER JOIN Groups G ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId AND ISNULL(G.GroupNoteType,0) = 9383 --13-APRIL-2016    Akwinass
                INNER JOIN GroupServices GS ON G.GroupId = GS.GroupId
        WHERE   GS.GroupServiceId = @GroupServiceId
                AND ISNULL(GS.RecordDeleted, 'N') <> 'Y'
                AND ISNULL(G.RecordDeleted, 'N') <> 'Y'
                AND ISNULL(GNDC.RecordDeleted, 'N') <> 'Y'   
    END  
                                
Declare @UserCode as varchar(50)                    
Declare @DocumentVersionId int -- Sonia Ref DocumentVersionId changes                               
select @UserCode = ModifiedBy from Services where ServiceID = @ServiceId                                  
--print @UserCode                                  
                                  
if (@ClientId is not null) and (@DocumentCodeId is not null)                                      
begin                                      
print  @ClientId                                    
print @DocumentCodeId                                    
 -- Create the Documents Record                                      
 insert into Documents(DocumentCodeId, ClientId, ServiceId, EffectiveDate, Status, AuthorId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,CurrentVersionStatus)                                      
 values (@DocumentCodeId, @ClientId, @ServiceId, @EffectiveDate, @Status, @AuthorId,  @UserCode, getdate(), @UserCode, getdate(),@Status)                                      
                                      
 if @@error <> 0 goto error                                      
                                      
 SET @DocumentId = @@IDENTITY                                      
                                      
 -- Create the DocumentVersions record                                      
 --insert into DocumentVersions (DocumentId, Version, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)                                      
 --values (@DocumentId, @CurrentVersion, @UserCode, getdate(), @UserCode, getdate())                                      
  insert into DocumentVersions (DocumentId, Version, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,RevisionNumber)                                        
 values (@DocumentId, @CurrentVersion, @UserCode, getdate(), @UserCode, getdate(),1)                                        
                
SET @DocumentVersionId = @@IDENTITY     -- Set the DocumentVersionId                                   
 if @@error <> 0 goto error                              
------ -- Create the Note                                      
-- if  @DocumentCodeId = 6                             
-- begin                                      
--  insert into Notes (DocumentId, Version, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)                                      
--  values (@DocumentId, @CurrentVersion, @UserCode, getdate(), @UserCode, getdate())                                      
--                                        
--  if @@error <> 0 goto error                                      
--                                      
--  insert into MentalStatus (DocumentId, Version, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)                                      
--  values (@DocumentId, @CurrentVersion, @UserCode, getdate(), @UserCode, getdate())                                       
--                                      
--  if @@error <> 0 goto error                                        
-- end                                      
 --DocumentVersionId Changes parameter added by sonia                        
             
Update Documents set CurrentDocumentVersionId = @DocumentVersionId, InProgressDocumentVersionId = @DocumentVersionId where DocumentId=@DocumentId -- Added by Sahil on Mar.19,2010            

--Following commented by Sonia ref ticket #3019                     
--exec ssp_PMServiceInsertNote @ServiceId,@DocumentCodeId,@UserCode,@DocumentVersionId                          
                             
                         
                                
 -- For In Progress add records to the DocumentSignatures table too                             
 if @Status = 21                                      
 begin                                      
  /*insert into DocumentSignatures                                      
  (DocumentId,SignedDocumentVersionId, StaffId, SignatureOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)                                      
  values (@DocumentId,@DocumentVersionId, @AuthorId, 1, @UserCode, getdate(), @UserCode, getdate())  */
  insert into DocumentSignatures                                        
  (DocumentId, StaffId, SignatureOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)                                        
  values (@DocumentId, @AuthorId, 1, @UserCode, getdate(), @UserCode, getdate())                                                                            
                                      
  if @@error <> 0 goto error                                      
 end                                      
                                       
                                      
end                                      
                                       
return 0                                      
                                      
                                      
error:                                      
------------------------------------------------------------
--RAISERROR('Error Creating Note from ssp_PMCreateServiceNote', 16, 1)
	--Modified by: SWAPAN MOHAN 
	--Modified on: 4 July 2012
	--Purpose: For implementing the Customizable Message Codes. 
	--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
DECLARE @ERROR NVARCHAR(MAX)
Set @ERROR=dbo.Ssf_GetMesageByMessageCode(29,'ERRCREATINGNOTE_SSP','Error Creating Note from ssp_PMCreateServiceNote')
RAISERROR(@ERROR, 16, 1)
------------------------------------------------------------                                       
return -1