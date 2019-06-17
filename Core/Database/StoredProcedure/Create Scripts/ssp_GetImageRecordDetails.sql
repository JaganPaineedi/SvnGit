/****** Object:  StoredProcedure [dbo].[ssp_GetImageRecordDetails]    Script Date: 12/12/2012 17:57:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetImageRecordDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetImageRecordDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetImageRecordDetails]    Script Date: 12/12/2012 17:57:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_GetImageRecordDetails]                      
@ImageRecordId int,                      
@LoggedInStaffId int                      
/********************************************************************************                                                                                                                      
-- Stored Procedure: dbo.ssp_GetImageRecordDetails                                                                                                                        
--                                                                                                                      
-- Copyright: Streamline Healthcate Solutions                                                                                                                      
--                                                                                                                      
-- Purpose: gets image record details                      
--                                                                                                                      
-- Updates:                                                                                                                                                                             
-- Date          Author       Purpose                                                                                                                  
-- 08.26.2010    SFarber      Created.                
-- 05.09.2011    Karan Garg	  Updated  -- added condition for 5820          
-- 05.10.2011    Karan Garg	  Updated  -- added coverageplanid in table imagerecordlist        
-- 05.19.2011    Karan Garg	  Updated  -- commented rowIdentifier from ImageRecords        
-- 07.18.2011    Devi Dayal   Updated  -- Commented RowIdentifier and ExternalrefrenceId From Document Version
-- 12.12.2012    Rakesh Garg  W.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId for avoiding concurrency issues   
-- 3-Dec-2014   SuryaBalan Added ProviderAuthorizationDocumentId   in ImageRecords Table for Task 177 CM to SC Issues 
-- 07.08.2015    Vaibhav Khare   W.rf to change in Harbor 3.5 Implementation Changes done for Client Order 
-- 15.10.2015	 Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
									why:task #609, Network180 Customization 
-- 10.03.2016	 Akwinass		  What:Included PaymentId Column in ImageRecords Table
								  Why:task #840 Renaissance - Dev Items
-- 07.DEC.2017	 Akwinass		  What:Included ServiceId Column in ImageRecords Table
								  Why:task #589 Engineering Improvement Initiatives- NBL(I)
-- 29-Jan-2018   Arjun K R        What: InsurerId column is added in select statement of ImageRecord table.
--                                Why : Task #14 SWMBH Enhacement.							 
*********************************************************************************/                                                                                           
as                      
BEGIN
	BEGIN TRY                                       
		declare @ImageServerId int                      
		declare @AssociatedWith int                      
		declare @AssociatedWithId int                      
		declare @AssociatedWithName varchar(250)                      
		declare @ClientId int                      
		declare @ProviderId int                      
		declare @StaffId int                      
		declare @DocumentVersionId int                      
		declare @DocumentId int                      
		declare @EventId int                      
		                      
		if @ImageRecordId > 0                       
		  select @ImageServerId = imr.ImageServerId,                      
				 @AssociatedWith = imr.AssociatedWith,                      
				 @ClientId = imr.ClientId,                      
				 @ProviderId = imr.StaffId,                      
				 @StaffId = imr.ProviderId,                      
				 @DocumentVersionId = imr.DocumentVersionId,                      
				 @DocumentId = dv.DocumentId,                      
				 @EventId = imr.EventId                      
			from ImageRecords imr                      
				 left join DocumentVersions dv on dv.DocumentVersionId = imr.DocumentVersionId                      
		   where imr.ImageRecordId = @ImageRecordId                      
		else                      
		  select @ImageServerId = DefaultImageServerId                      
			from Staff s                      
		   where s.StaffId = @LoggedInStaffId                      
			 and isnull(s.RecordDeleted, 'N') = 'N'                      
		                      
		if @AssociatedWith in (5811, 5812, 5813,5828,5821)                      
		  select @AssociatedWithId = c.ClientId,                      
				 --Added by Revathi  10/15/2015                  
				@AssociatedWithName = CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(c.LastName, '') + ', ' + ISNULL(c.FirstName, '')
					ELSE ISNULL(C.OrganizationName, '')
					END                    
			from Clients c                      
		   where c.ClientId = @ClientId             
		   -- Added for 5820               
		 else if @AssociatedWith = 5820                  
		  select @AssociatedWithId = c.ClientId,                      
		  --Added by Revathi  10/15/2015                  
				@AssociatedWithName = CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(c.LastName, '') + ', ' + ISNULL(c.FirstName, '')
					ELSE ISNULL(C.OrganizationName, '')
					END                   
			from Clients c                      
		   where c.ClientId = @ClientId                    
		else if @AssociatedWith = 5814                      
		  select @AssociatedWithId = s.StaffId,                      
				 @AssociatedWithName = s.LastName + ', ' + s.FirstName                      
			from Staff s                      
		   where s.StaffId = @StaffId                      
		else if @AssociatedWith = 5815                      
		  select @AssociatedWithId = p.ProviderId,                      
				 @AssociatedWithName = p.ProviderName + case when len(p.FirstName) > 0 then ', ' + p.FirstName else '' end                      
			from Providers p                      
		   where p.ProviderId = @ProviderId                      
		                      
		-- Table 1 - Image Server URL                      
		select s.ImageServerURL                            
		  from ImageServers s                      
		 where s.ImageServerId = @ImageServerId                      
		                      
		-- Table 2 - Associated With                      
		select @AssociatedWithId as AssociatedWithId, @AssociatedWithName as AssociatedWithName                      
		                      
		-- Table 3 - Image Records                      
		SELECT [ImageRecordId]              
			  ,[ScannedOrUploaded]              
			  ,[DocumentVersionId]              
			  ,[ImageServerId]              
			  ,[ClientId]              
			  ,[AssociatedId]              
			  ,[AssociatedWith]              
			  ,[RecordDescription]              
			  ,[EffectiveDate]              
			  ,[NumberOfItems]              
			  ,[AssociatedWithDocumentId]              
			  ,[AppealId]              
			  ,[StaffId]              
			  ,[EventId]              
			  ,[ProviderId]              
			  ,[TaskId]              
			  ,[AuthorizationDocumentId]              
			  ,[ScannedBy]              
			  --,[RowIdentifier]              
			  ,[CreatedBy]              
			  ,[CreatedDate]              
			  ,[ModifiedBy]              
			  ,[ModifiedDate]              
			  ,[RecordDeleted]              
			  ,[DeletedDate]              
			  ,[DeletedBy]         
			  ,[CoveragePlanID]
			  ,[ProviderAuthorizationDocumentId] 
			  -- 10.03.2016	 Akwinass
			  ,[PaymentId]
			  -- 07.DEC.2017  Akwinass
			  ,[ServiceId]  
			  -- 29-Jan-2018  Arjun K R 
			  ,[InsurerId]      
			  ,(SELECT ProviderName FROM Providers WHERE [ProviderId]= [ImageRecords].[ProviderId]) as ProviderName   
		  FROM [ImageRecords]                    
		 where ImageRecordId = @ImageRecordId                      
		                      
		-- Table 4 - Documents                      
		SELECT [DocumentId]              
			  ,[CreatedBy]              
			  ,[CreatedDate]              
			  ,[ModifiedBy]              
			  ,[ModifiedDate]              
			  ,[RecordDeleted]              
			  ,[DeletedDate]              
			  ,[DeletedBy]              
			  ,[ClientId]              
			  ,[ServiceId]              
			  ,[GroupServiceId]              
			  ,[EventId]              
			  ,[ProviderId]              
			  ,[DocumentCodeId]              
			  ,[EffectiveDate]              
			  ,[DueDate]              
			  ,[Status]              
			  ,[AuthorId]              
			  ,[CurrentDocumentVersionId]              
			  ,[DocumentShared]              
			  ,[SignedByAuthor]              
			  ,[SignedByAll]              
			  ,[ToSign]              
			  ,[ProxyId]              
			  ,[UnderReview]              
			  ,[UnderReviewBy]              
			  ,[RequiresAuthorAttention]              
			  ,[InitializedXML]              
			  ,[BedAssignmentId]
			  ,Documents.ReviewerId
			  ,Documents.ClientLifeEventId
			  ,Documents.InProgressDocumentVersionId
			  ,Documents.CurrentVersionStatus
			  ,Documents.AppointmentId ----Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp 
		  FROM [dbo].[Documents]                     
		  WHERE DocumentId = @DocumentId                      
		                      
		-- Table 5 - Document Versions                      
		select dv.DocumentVersionId                      
			  ,dv.DocumentId                      
			  ,dv.[Version]                      
			  ,dv.EffectiveDate                      
			  ,dv.DocumentChanges                      
			  ,dv.ReasonForChanges                      
			  --,dv.RowIdentifier --,dv.ExternalReferenceId                      
			  ,dv.CreatedBy                      
			  ,dv.CreatedDate                      
			  ,dv.ModifiedBy                      
			  ,dv.ModifiedDate                      
			  ,dv.RecordDeleted                      
			  ,dv.DeletedDate                      
			  ,dv.DeletedBy
			  ,dv.RevisionNumber  
			  ,dv.AuthorId                    
			  ,dv.RefreshView
		  from DocumentVersions dv                      
		 where dv.DocumentVersionId = @DocumentVersionId                      
		                      
		-- Table 6 - Events                      
		SELECT [EventId]              
			  ,[StaffId]              
			  ,[ClientId]              
			  ,[EventTypeId]              
			  ,[EventDateTime]              
			  ,[Status]              
			  ,[FollowUpEventId]              
			  ,[ProviderId]              
			  ,[InsurerId]              
			  ,[RowIdentifier]              
			  ,[CreatedBy]              
			  ,[CreatedDate]              
			  ,[ModifiedBy]              
			  ,[ModifiedDate]              
			  ,[RecordDeleted]              
			  ,[DeletedDate]              
			  ,[DeletedBy]              
		  FROM [dbo].[Events]                     
		 where EventId = @EventId

	  END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_GetImageRecordDetails')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
GO


