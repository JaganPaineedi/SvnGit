/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentData]    Script Date: 12/12/2012 16:40:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentData]    Script Date: 12/12/2012 16:40:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_SCGetDocumentData]         
@DocumentId int,                
@DocumentCodeId int,                
@DocumentVersionId int,                
@ClientId int,                
@AuthorId int,                
@StoredProcedure varchar(100),                
@DocumentType int,                
@ScreenAction varchar(10)      
         
                
/********************************************************************************                      
-- Stored Procedure: dbo.ssp_SCGetDocumentData                        
--                      
-- Copyright: Streamline Healthcate Solutions                      
--                      
-- Purpose: returns Document, DocumentVersion and custom document tables                      
--                      
-- Updates:                                                                             
-- Date        Author       Purpose                      
-- 02.18.2010  Vikas Monga  Created.                            
-- 11.15.2010  SFarber      Added logic for skipping custom tables.                
-- 03.06.2011  Damanpreet Kaur  Modified ref: task#177 Document Acknowledgement and Comment                    
-- 08.07.2011  Shifali  Purpose: Removed Hard Coded DocumentCodeIds as here we had Even Custom DocumentCode Ids too)
-- 19.07.2011  Rohit Katoch  Removed columns Rowidentifier and ExternalReferanceId from DocumentVersions table     
-- 01.09.2011  Devi Dayal Add the Column("ClientLifeEventId") in Select Query      
-- 08.08.2011  Shifali  Purpose: Added columns CurrentVersionStatus,ReviewerId,InProgressDocumentVersionId in Documents table, Revsion Number in DocumentVersions table      
-- 08.26.2011  Shifali  Purpose: Added check for CurrentVersionStatus instaed of status to decide getcustomtabldedata or not
-- 19.09.2011	Shifali		Added column AuthorID in DocumentVersion table selection
-- 29.09.2012   SWAPAN MOHAN  Added a check for blank value of @StoredProcedure passing to the ssp. It is throwing error if null value is passed. 
-- 25.10.2012	Sanjayb Merge from 2.x to 3.5xMerge By Sanjayb - Ref Task No. 259 SC Web Phase II - 
--				Bugs/Features -13-July-2012 - Document Version Views:  Refresh repository PDF
-- 12.12.2012   Rakesh Garg W.rf to change in core datamode 12.28 in documents table by Adding new field 
-- 27.04.2015   Anto modified documentversions table by Adding new field ReasonForNewVersion

AppointmentId for avoiding concurrency issues
 *********************************************************************************/                      
as                                                 
                                         
declare @CurentDocumentVersionID int              
--Added by Damanpreet             
--Declared a variable that will check whether the Acknowledgement is required by the document            
Declare @DocumentAcknowledgementRequired bit                                      
set @DocumentAcknowledgementRequired=0                
begin try                
                                              
--Get Master tables Documents and DocumentVersions                                             
                                            
select d.DocumentId 
	  ,d.CreatedBy                                              
      ,d.CreatedDate                                              
      ,d.ModifiedBy                                              
      ,d.ModifiedDate                                              
      ,d.RecordDeleted                                             
      ,d.DeletedDate                            
      ,d.DeletedBy                                                 
      ,d.ClientId                                              
      ,d.ServiceId                                              
      ,d.GroupServiceId 
      ,EventId                  -- Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp
      ,ProviderId               -- Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp                                    
      ,d.DocumentCodeId                                              
      ,d.EffectiveDate                                              
      ,d.DueDate                                              
      ,d.[Status]                                              
      ,d.AuthorId                                              
      ,d.CurrentDocumentVersionId                                              
      ,d.DocumentShared                                              
      ,d.SignedByAuthor                                              
      ,d.SignedByAll                                              
      ,d.ToSign                                              
      ,d.ProxyId                                              
      ,d.UnderReview                                              
      ,d.UnderReviewBy                                              
      ,d.RequiresAuthorAttention                  
      ,d.InitializedXML 
      ,BedAssignmentId           --Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp   
      ,ReviewerId
      ,InProgressDocumentVersionId
      ,CurrentVersionStatus 
      ,d.[Status] as SavedStatus                                                                              
      ,d.ClientLifeEventId 
      ,d.AppointmentId      --Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp                                           
      FROM Documents d WHERE d.DocumentId = @DocumentId and isnull(d.RecordDeleted, 'N') = 'N'                               
         
-- Get current DocumentVersionId                
if isnull(@DocumentVersionId, 0) <= 0                                          
begin                                          
  select @CurentDocumentVersionId = CurrentDocumentVersionId                
    from Documents                
   where DocumentId = @DocumentId                                            
end                                          
else                                          
begin                                          
  set @CurentDocumentVersionId = @DocumentVersionId                                          
end                                          
-- Added by Damanpreet            
-- Setting the value for acknowledgements depending on the condition -             
-- value 1 signifies- Acknowledgement required                    
if (exists(select 1 from DocumentsAcknowledgements where DocumentId=@DocumentId and AcknowledgedDocumentVersionId=@CurentDocumentVersionId and DateAcknowledged is null and AcknowledgedByStaffId=@AuthorId and isnull(RecordDeleted,'N')<>'Y'))            
set @DocumentAcknowledgementRequired=1            
                                               
select dv.DocumentVersionId                                              
      ,dv.DocumentId                                              
      ,dv.Version                                              
      ,dv.EffectiveDate                                              
      ,dv.DocumentChanges                                              
      ,dv.ReasonForChanges         
      --Commented by Rohit Katoch in reference to core Datamodel upgradation from 2.1. to 2.2                                             
      --,dv.RowIdentifier                                              
      --,dv.ExternalReferenceId                                              
      ,dv.CreatedBy                                              
      ,dv.CreatedDate                                              
 ,dv.ModifiedBy                                              
      ,dv.ModifiedDate                                              
      ,dv.RecordDeleted                                              
      ,dv.DeletedDate                                              
      ,dv.DeletedBy             
      ,@DocumentAcknowledgementRequired as DocumentAcknowledgementRequired
      ,dv.AuthorId   
      ,dv.RevisionNumber       
      ,dv.RefreshView --Task#259  
      ,dv.ReasonForNewVersion  -- Task# 233                                                                       
  from DocumentVersions dv                                                                                  
 where dv.DocumentVersionId = @CurentDocumentVersionId                
   and isnull(dv.RecordDeleted, 'N') = 'N'                
                                                
select di.DocumentInitializationLogId                                  
      ,di.DocumentId                                  
      ,di.TableName                                  
      ,di.ColumnName                                  
      ,di.InitializationStatus                        
      ,di.ParentChildName                                  
      ,di.ChildRecordId                                  
      ,di.RowIdentifier                                  
      ,di.CreatedBy                                  
      ,di.CreatedDate                                  
      ,di.ModifiedBy                                  
      ,di.ModifiedDate                                  
      ,di.RecordDeleted                                  
      ,di.DeletedDate                                  
      ,di.DeletedBy                                  
  from DocumentInitializationLog di                
       join Documents d on di.DocumentId = d.DocumentId                                      
 where di.DocumentId = @DocumentId                
   and d.Status <> 22                
   and isnull(d.RecordDeleted, 'N') = 'N'                               
   and isnull(di.RecordDeleted, 'N') = 'N'                
                                               
-- Get Custom Table(s)                                            
-- Call custom storedProcedure                                      
-- TP/PR/Assement documents require addtional parameter @StaffId                                     
                
if @DocumentType not in (12, 17)          
begin                    
  declare @GetCustomData bit                
  declare @DocumentStatus int                
                  
  /*select @DocumentStatus = d.Status from Documents d where d.DocumentId = @DocumentId                */
  select @DocumentStatus = d.CurrentVersionStatus from Documents d where d.DocumentId = @DocumentId
                  
  --                
  -- Retrieve custom tables if the document:                
  --    1. is opened in Edit mode             
  --    2. is not signed/completed                
  --    3. is in Unsaved Changes                
  --                  
  if @ScreenAction = 'EDIT' or @DocumentStatus <> 22                
  begin                
    set @GetCustomData = 1                        
  end                
  else                 
  begin                
    if exists(select *                
                from UnsavedChanges us                
                     join Screens s on s.ScreenId = us.ScreenId                
               where us.StaffId = @AuthorId                
                 and us.ClientId = @ClientId                
                 and s.DocumentCodeId = @DocumentCodeId                
                 and cast(us.ScreenProperties as XML).query('/ScreenProperties/DocumentId').value('.', 'int') = @DocumentId                
                 and isnull(s.RecordDeleted, 'N') = 'N')                
    begin                
      set @GetCustomData = 1                        
    end                
  end                
                  
  if @GetCustomData = 1                
  begin         
            
 /*Commented by Shifali on 7July,2011 (REASON: We should not Hard Code DocumentCodeIds as here we had Even Custom DocumentCode Ids too)   */           
    /*if @DocumentCodeId in (2, 3, 350, 352, 503, 553, 554,1483,1484,1485,1486)                       
    begin                                      
      exec @StoredProcedure @DocumentVersionId = @CurentDocumentVersionId, @StaffId = @AuthorId                                       
    end                                      
    else                                   
    begin                                      
      exec @StoredProcedure @DocumentVersionId = @CurentDocumentVersionId                                            
    end*/         
            
          
 /*Added a check for blank value of @StoredProcedure passing to the ssp
 It is throwing error if null value is passed.*/
 if(RTRIM(LTRIM(@StoredProcedure))!='')
 begin
 /*Added by Shifali in ref to Check Whether sp @StoredProcedure expects paramater named as @StaffId*/  
 IF EXISTS(select PARAMETER_NAME from information_schema.parameters        
 where specific_name=@StoredProcedure        
 and PARAMETER_NAME='@StaffId')        
    begin                                      
      exec @StoredProcedure @DocumentVersionId = @CurentDocumentVersionId, @StaffId = @AuthorId                                       
    end                                      
    else                                   
    begin                                      
      exec @StoredProcedure @DocumentVersionId = @CurentDocumentVersionId                                            
    end        
                   
  end                                            
end 
end                                           
                                            
end try                                
begin catch                                                                  
  declare @Error varchar(8000)                                                                                                    
  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message())                                             
  + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_SCGetDocumentData')                                                                                                     
  + '*****' + convert(varchar, error_line()) + '*****ERROR_SEVERITY=' + convert(varchar, error_severity())                                                                                                    
  + '*****ERROR_STATE=' + convert(varchar, error_state())                                                                                                    
  raiserror(@Error, 16, 1)                                                
end catch

GO
