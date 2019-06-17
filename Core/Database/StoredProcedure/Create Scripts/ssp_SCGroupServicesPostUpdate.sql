 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGroupServicesPostUpdate')
	BEGIN
		DROP  Procedure  ssp_SCGroupServicesPostUpdate
	END

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
           
CREATE proc [dbo].[ssp_SCGroupServicesPostUpdate]    
(                  
  @ScreenKeyId int,                                                  
  @StaffId int,                                                  
  @CurrentUser varchar(30),                  
  @CustomParameters xml                                   
)                  
as              
/******************************************************************************                    
**  File:                     
**  Name: ssp_SCGroupServicesPostUpdate                    
**  Desc:                     
**                    
**  This template can be customized:                    
**                                  
**  Return values:                    
**                     
**  Called by:                       
**                                  
**  Parameters:                    
**  Input       Output                    
**     ----------       -----------                    
**                    
**  Auth:                     
**  Date:                     
*******************************************************************************                    
**  Change Histor6y                    
*******************************************************************************                    
**  Date:      Author:     Description:                    
**  ---------  --------    -------------------------------------------                    
**  1/31/2007  Umesh		Created Procedure to AFter update functionality of GroupServices page
**  25/05/ 2012 Rakesh-II	changes  for task #1073 in THreshold BUg/ Features  
**  14 /08/2012 Rakesh-II   new condition added in update statement D.Status <> 22 i.e Signed status were changing to in progress after some scenario          
**  11Sept2012  Shifali     Thresholds Bugs/Features, task# 1855 (Copy Location to all services as same that of GroupServices.SpecificLocation
**  27Sept2012	Shifali		Threshold 3.5x Merged Issues Task# 401 (Group Service:- Author id doesn't update in document versions and signature)
**	9/26/2012	Wasif		Record delete document when service status set to no-show	
**  11/Feb 2013 SunilKh		Added condition to check disablenoshow so that in case of no show status the document record deleted should not be 'Y'          
**  8/March 2013 Maninder	Changed UPDATE Documents SET AuthorId=S.NoteAuthorId to UPDATE Documents SET AuthorId=S.ClinicianId
**	5/28/2013	Wasif Butt	Update Documents.EffectiveDate same as that GroupServices.DateOfService
**  4/2/2014    Deej			Changed the logic to remove the time from effective date
**  12/11/2014  Hemant      Added @PlaceOfServiceId for display the value in place of service dropdown for task MFS Setup #16
**	7/6/2015	Wasif Butt	Fixed conditions to update DocumentSignature Staff and DocumentVersions AuthorId to person selected on Document as AuthorId.
**	8/18/2015	Chethan N	What : Commented GroupStaff insert logic.
							Why: Philhaven - Customization Issues Tracking task# 1326
**  22-Feb-2016	Akwinass	What:Included ssp_SCManageAttendanceToDoDocuments, To create To Do document for the Associated Attendance Group Service.          
**							Why:task #167 Valley - Support Go Live
**  02/10/2017  MD Hussain  Added logic to update Documents.CurrentVersionStatus w.r.t Thresholds - Support #730
** 21/07/2017   Sanjay      Added scsp_SCGroupServicesPostUpdate to customize GroupServicesPostUpdate logic and commented Print statement
                            why: AspenPointe - Support Go Live: #362
*************************************************************************************************************************************************/                  
begin                 
            
begin try             
    --Following option is reqd for xml operations                                
    SET ARITHABORT ON                                   
                                
    declare @action varchar(40)            
    DECLARE @GroupServiceId INT      
    DECLARE @SpecificLocation VARCHAR(MAX)
    Declare @DisableNoShowNotes VARCHAR(10)
    DECLARE @PlaceOfServiceId INT        
                                  
    set @action = @CustomParameters.value('(/Root/Parameters/@GroupServiceAction)[1]', 'varchar(40)');            
    set @GroupServiceId =@CustomParameters.value('(/Root/Parameters/@PostUpdateGroupServiceId)[1]', 'varchar(10)');                  
                
     --print @GroupServiceId           
    IF @GroupServiceId  <= 0            
    BEGIN            
                
       SELECT  TOP 1 @GroupServiceId = GroupServiceId from GroupServices order by 1 desc           
        --print @GroupServiceId          
    END            
                   
                  
   --Copy the GroupNote into ClientNote Where User is Author              
   IF @action = 'UpdateClientNotes'             
   BEGIN            
    --EXEC ssp_SCExecuteClientNoteCopyProcedure @ScreenKeyId, @CurrentUser         
    --Added by vishant to implement message code functionality 
    DECLARE @ErrorMessage nvarchar(max)
    select @ErrorMessage=dbo.Ssf_GetMesageByMessageCode(29,'INUPDATECLIENTNOTES_SSP','in updateclientnotes')
    --print   @ErrorMessage               
      
    --print 'in updateclientnotes'              
     EXEC ssp_SCExecuteClientNoteCopyProcedure @GroupServiceId, @StaffId                  
   END            
                
  --Update the Note Author in Documents Table as in the Services table              
  --UPDATE Documents SET AuthorId=  S.NoteAuthorId                              
  UPDATE Documents SET AuthorId=  S.ClinicianId                              
  FROM  Services S INNER join Documents D ON S.ServiceId = D.ServiceId                             
  WHERE S.GroupServiceId = @GroupServiceId             
  and D.Status <> 22 AND ISNULL(S.RecordDeleted,'n')='n'                    
  AND ISNULL(D.RecordDeleted,'N')='N'           
  
  UPDATE DocumentVersions SET AuthorId = S.ClinicianId                             
  FROM  DocumentVersions DV INNER join Documents D ON D.InProgressDocumentVersionId = DV.DocumentVersionId
	inner join services as s on d.ServiceId = s.ServiceId
  WHERE s.GroupServiceId = @GroupServiceId               
  and D.Status <> 22 AND ISNULL(DV.RecordDeleted,'n')='n'                      
  AND ISNULL(D.RecordDeleted,'N')='N'  
  
  UPDATE DocumentSignatures SET StaffId = S.ClinicianId                               
  FROM  DocumentSignatures DS INNER join Documents D ON D.DocumentId = DS.DocumentId
	inner join services as s on d.ServiceId = s.ServiceId
  WHERE s.GroupServiceId = @GroupServiceId               
  and D.Status <> 22 AND ISNULL(DS.RecordDeleted,'n')='n'                      
  AND DS.SignatureDate IS NULL AND DS.SignatureOrder = 1   
      
  --added by Shifali 
  select  @DisableNoShowNotes=DisableNoShowNotes from systemconfigurations --Added by sunilkh for threshold bugs/Features 2711   
  Update Documents SET Status  =     
  CASE S.Status     
   WHEN 70 THEN 20     
   WHEN 71 THEN 21     
   WHEN 72 THEN 21     
   WHEN 73 THEN 21     
   WHEN 76 THEN 21   
   WHEN 75 THEN 22    
  END
  ,CurrentVersionStatus  =     --Added by MD on 2/10/2017  
  CASE S.Status       
   WHEN 70 THEN 20       
   WHEN 71 THEN 21       
   WHEN 72 THEN 21       
   WHEN 73 THEN 21       
   WHEN 76 THEN 21     
   WHEN 75 THEN 22   
  END       
  --added to delete the document when client service status is set to no-show
	--Harbor go live issues document item #317
  ,RecordDeleted =   
  CASE   
   WHEN S.Status=72 and @DisableNoShowNotes='Y' THEN  'Y'    
   END        
  FROM  Services S INNER join Documents D ON S.ServiceId = D.ServiceId                             
  WHERE S.GroupServiceId = @GroupServiceId 
  and D.Status <> 22 -- this condition is added BY Rakesh-II, as signed status were changing to in progress after some scenario (Added afer discuss with Devender Pal)             
  and ISNULL(S.RecordDeleted,'N')='N'                    
  AND ISNULL(D.RecordDeleted,'N')='N'        
          
        
  --added by Shifali      
  IF @action = 'DeleteGroupService'             
   BEGIN                
    Update DocumentVersions set RecordDeleted='Y',      
    DeletedBy=(select UserCode from Staff where StaffId=@StaffId),      
    DeletedDate=GETDATE()      
    where DocumentVersionId in (select CurrentDocumentVersionId from Documents d inner join services s on d.ServiceId = s.ServiceId    
    where s.GroupServiceId=@GroupServiceId)      
          
    Update Documents set RecordDeleted='Y',      
    DeletedBy=(select UserCode from Staff where StaffId=@StaffId),      
    DeletedDate=GETDATE()       
    Where Documents.DocumentId in (select documentId from documents d join services s on d.ServiceId = s.ServiceId where s.GroupServiceId = @GroupServiceId)                         
   END             
  ELSE --\\ELSE condition added by Shifali as per task# 298  
  --Desc: When user deletes client and saves the group service, the corresponding documents should delete as well  
  --which we achieve using below statements  
 BEGIN  
  Update Documents  
  Set Documents.RecordDeleted='Y',  
  DeletedBy=(select UserCode from Staff where StaffId=@StaffId),      
  DeletedDate=GETDATE()   
  Where exists (Select ServiceId from Services S Where S.GroupServiceId=@GroupServiceId and ISNULL(RecordDeleted,'N')<>'N' and S.ServiceId = Documents.ServiceId)  
   
  Update DocumentVersions set RecordDeleted='Y',      
  DeletedBy=(select UserCode from Staff where StaffId=@StaffId),      
  DeletedDate=GETDATE()      
  where exists (select CurrentDocumentVersionId from Documents      
  where exists (Select ServiceId from Services S Where GroupServiceId=@GroupServiceId and ISNULL(RecordDeleted,'N')<>'N' and S.ServiceId=Documents.ServiceId)  
  and DocumentVersions.DocumentVersionId=Documents.CurrentDocumentVersionId)     
 
 --Added by Shifali to Update Documents.EffectiveDate same as that GroupServices.DateOfService
		--Except Signed documents
		Update Documents
		Set EffectiveDate=(Select CAST(CONVERT(VARCHAR(10),DateOfService,101) AS DATE) from GroupServices where GroupServiceId=@GroupServiceId)
		where Documents.Status <> 22 and Documents.ServiceId in (select ServiceId from services where GroupServiceId = @GroupServiceId)
 
 END    
   
   
   -- code Added By Rakesh-II For task 1073 In Threshold Bugs/ Features  
		  Declare @GroupStatus int                                              
		  set @GroupStatus = (SELECT [dbo].[SCGetGroupServiceStatus](@GroupServiceId))
		  if(@GroupStatus!='' and @GroupStatus is not null)
		  begin   
			update Groupservices set Status=@GroupStatus where GroupServiceId=@GroupServiceId  
		  end
 
   -- end of my Code 
   
   /*Added By Shifali on 11Sept2012*/
   --  12/11/2014  Hemant 
   SELECT @SpecificLocation = SpecificLocation,@PlaceOfServiceId=PlaceOfServiceId FROM GroupServices WHERE GroupServiceId = @GroupServiceId
   
   UPDATE Services SET SpecificLocation = @SpecificLocation, PlaceOfServiceId=@PlaceOfServiceId   
   WHERE GroupServiceId = @GroupServiceId AND ISNULL(RecordDeleted,'N') <> 'Y'
    --  12/11/2014  Hemant
   /*Changes By Shifali Ends here*/
   
   -- 22-Feb-2016	Akwinass
   IF ISNULL(@action,'') <> 'DeleteGroupService'
   BEGIN		
		EXEC ssp_SCManageAttendanceToDoDocuments NULL,@ScreenKeyId,@CurrentUser,NULL		
   END
   
   ----Added by Sanjay-----
    IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'scsp_SCGroupServicesPostUpdate')
	BEGIN
		EXEC scsp_SCGroupServicesPostUpdate @ScreenKeyId

	END
   
   
  end try                                                                                
                                                                                                                         
BEGIN CATCH                                    
DECLARE @Error varchar(8000)                                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                             
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                            
'ssp_SCGroupServicesPostUpdate')                                                                                                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                
    + '*****' + Convert(varchar,ERROR_STATE())                                                            
 RAISERROR                                                                                   
 (                                                                                 
  @Error, -- Message text.                                                                                                   
  16, -- Severity.                                                                                                              
  1 -- State.                                       
 );                                                                                                            
END CATCH              
              
end